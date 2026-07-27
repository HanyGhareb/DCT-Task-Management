"""otbi-atd action : rebill an AR invoice with a corrected tax classification.

Oracle Fusion Receivables, driven through the UI on the shared, already
authenticated SSO session -- the same one the OTBI extract jobs use. There is
no REST alternative: fscmRestApi returns 401 even with a full UI cookie session
under the federated ADGOV SSO (docs/fusion-actions/README.md), so the UI robot
is the only channel.

The manual flow this replaces (Navigator -> Receivables -> Billing):

  search the invoice by Transaction Number
    -> Actions > Credit Transaction: fill number/dates/reason/comments,
       Credit Entire Balance, then Save or Complete and Close
    -> OK the confirmation, open the new credit memo, capture its Document Number
    -> back to the original: Actions > Duplicate
    -> Transaction Source = DCT Manual, dates, and on the nominated memo lines
       set Tax Classification (VAT OUTPUT - STD)
    -> per line: Details > Project + Task, Save and Close
    -> Complete and Review, capture the new invoice's Document Number

WHY THIS ONE IS DIFFERENT
AP_INVOICE and PPM_TASK_ADDL_INFO are single, naturally idempotent writes. This
is a NINE-stage saga that CREATES two objects and COMPLETES them, and a
completed credit memo cannot be un-completed in Fusion -- only reversed. A
retry that restarts from the top would raise a SECOND credit memo against a
live customer invoice. So every stage is checkpointed in ATD_ACTION_STEP
(db/52) and every stage probes Fusion before it acts:

  CM_CREATE  the Manage Transactions grid carries an "Original Transaction
             Number" column -- "does a credit memo for this invoice already
             exist?" is a free, exact probe with nothing to stamp.
  DUPLICATE  a duplicated invoice carries no link back to its source, so the
             duplicate is stamped "Rebill of <invoice>" (STAMP_FIELD) and the
             probe searches for that.
  DUP_LINE_DFF  reads each line's current Project/Task and skips lines already
             carrying the target values.

A resumed run reads back what earlier stages captured via
atd_action_saga_pkg.stage_ref, so a crash between "completed the credit memo"
and "recorded its document number" does not lose the number.

SAFETY (this is developed and run against PROD -- there is no test pod)
  ATD_ACTION_LIVE=1        required before ANY committing click. Without it a
                           stage navigates, probes and fills, then raises
                           DryRun immediately before its commit.
  ATD_AR_REBILL_ALLOW      csv of invoice numbers. While set, any invoice not
                           on the list is refused outright. This is what stops
                           a selector bug touching a real customer invoice.
                           Keep it set for the whole tuning period.
  ATD_ACTION_STOP_AFTER    stage code to halt cleanly after, for stepping
                           through the saga during the tune.
  ATD_ACTION_SHOT_DIR      per-stage full-page screenshots.

SELECTOR PROVENANCE (ADGOV pod, harvested with diag_ar.py 2026-07-25)
  CONFIRMED LIVE   navigation to Billing, the "Search: Transactions" rail
                   magnifier, the results-grid id scheme (cl1/cl3), opening the
                   invoice (exact-text link -- a substring match also hits
                   <invoice>CM), and both Actions menu entries.
  HARVESTED        Credit Transaction form (it1/id1/id2/selectOneChoice2/
                   HdrComments/creditEntireBal) and the Create Transaction form
                   (batchSourceId/tdt/inputDate9/showMore and the line grid
                   table1:<row>:memoLineNameId / :taxClassificationCodeId /
                   :commandImageLink110). Wired but not yet exercised live.
  UNVERIFIED       the Project/Task fields inside the per-line Details drawer
                   are filled BY LABEL and will raise loudly on the first dry
                   run if those labels differ.
The framework around the selectors (stage checkpointing, probes, per-stage
dry-run gating, the invoice allowlist, result callback) is release-independent.
"""
import os
import re
import time

from . import DryRun
from .ap_invoice import _apps_base  # same Fusion apps-base resolution rules
from .ppm_task_addl import (  # the ADF toolkit, proven over a 19-round tune
    _clear_label_field,
    _dismiss_overlays,
    _fill_label_real,
    _jsclick,
    _label_input_id,
)

# ---------------------------------------------------------------------------
# Selectors / literals. CONFIRM EACH WITH diag_ar.py BEFORE THE FIRST LIVE RUN.
# ---------------------------------------------------------------------------
SEL = {
    "nav_group":      ['a[id="groupNode_receivables"]',
                       'a[id*="groupNode"][id*="receivable" i]'],
    "nav_billing":    ['a[id*="itemNode_receivables"][id*="billing" i]',
                       'a:has-text("Billing")'],
    # The Billing work area's right rail carries three drawers; the magnifier is
    # "Search: Transactions". NEVER match on the bare title "Search" -- the
    # global topbar search carries that title and wins in document order
    # (ADF law 1). Confirmed by diag_ar.py on the ADGOV pod 2026-07-25.
    "search_toggle":  ['[title="Search: Transactions"]',
                       '[id$="TransactionsQuickSearch::icon"]',
                       '[id*="TransactionsQuickSearch"]'],
    "search_run":     ['button:text-is("Search")', 'a:text-is("Search")'],
    # EXACT text, never :has-text() -- that is a SUBSTRING match and the topbar
    # "Settings and Actions" comes first in document order, so :has-text
    # ("Actions") opens the wrong menu entirely (measured 2026-07-25).
    "actions_menu":   ['a:text-is("Actions")', 'button:text-is("Actions")'],
    # The Actions menu renders its entries as <td> with EMPTY ids -- matching on
    # a: never finds them (measured 2026-07-25).
    "act_credit":     ['td:text-is("Credit Transaction")',
                       'a:text-is("Credit Transaction")'],
    "act_duplicate":  ['td:text-is("Duplicate")', 'a:text-is("Duplicate")'],
    # Credit Entire Balance is a real <button> with a stable id leaf -- prefer it.
    "credit_all":     ['[id$=":creditEntireBal"]',
                       'button:text-is("Credit Entire Balance")',
                       'a:text-is("Credit Entire Balance")'],
    # Save / Complete and Close / Complete and Review are ADF SPLIT buttons: the
    # element whose id ends "::popEl" is the DROPDOWN ARROW, not the action.
    # Clicking it just opens a menu, so exclude it explicitly.
    # ID FIRST (ADF law 5). The text-only form matched NOTHING on the live
    # ADGOV form 2026-07-25 even though the button was plainly visible: the
    # anchor carrying the text has an EMPTY id and sits inside the split-button
    # container `…:ap1:CompleteandClose`, and the only id-bearing anchor with
    # that text is the `::popEl` dropdown arrow we must exclude. Targeting the
    # container id is deterministic; the text forms stay as fallbacks.
    "cm_complete":    ['[id$=":CompleteandClose"]:not([id$="::popEl"])',
                       'a:text-is("Complete and Close"):not([id$="::popEl"])',
                       'button:text-is("Complete and Close"):not([id$="::popEl"])'],
    # "Save" must be exact too, or it matches "Save and Close"
    "cm_save":        ['[id$=":saveMenu2"]:not([id$="::popEl"])',
                       'a:text-is("Save"):not([id$="::popEl"])',
                       'button:text-is("Save"):not([id$="::popEl"])'],
    "dup_complete":   ['[id$=":dupTrx1"]:not([id$="::popEl"])',
                       'a:text-is("Complete and Review"):not([id$="::popEl"])',
                       'button:text-is("Complete and Review"):not([id$="::popEl"])'],
    # A RESUMED invoice is on the Edit Transaction page, whose completing split
    # button is `newTrx` = "Complete and Create Another" -- there is no
    # "Complete and Review" there at all (measured on 45100250002, 2026-07-25).
    # It completes THIS transaction and then offers a fresh blank form, which we
    # simply never fill, so no second invoice results.
    "dup_complete_alt": ['[id$=":newTrx"]:not([id$="::popEl"])',
                         'a:text-is("Complete and Create Another"):not([id$="::popEl"])'],
    # The Edit Transaction page's completing action lives in the SPLIT MENU,
    # not on the button face. Clicking the `::popEl` arrow opens
    # "Complete and Review" / "Complete and Close" (user-supplied screenshot,
    # 2026-07-25). Complete and Close is the one we want: it completes the
    # invoice and returns, whereas the button face "Complete and Create
    # Another" completes and then opens a blank new-transaction form.
    "dup_menu_arrow":  ['[id$=":newTrx::popEl"]', '[id$=":dupTrx1::popEl"]'],
    "dup_menu_close":  ['td:text-is("Complete and Close")',
                        'a:text-is("Complete and Close")'],
    # Preferred over Complete and Close: it leaves you ON the completed record,
    # so the new Document Number can be READ rather than searched for. Fusion
    # RENUMBERS the transaction on completion (45100250002 -> 45110096150), so
    # a stage that searches for the pre-completion number finds nothing at all.
    "dup_menu_review": ['td:text-is("Complete and Review")',
                        'a:text-is("Complete and Review")'],
    "dialog_ok":      ['button:text-is("OK")', 'a:text-is("OK")'],
    "line_details":   ['[title="Details"]', 'a[id*="dffIL"]',
                       'img[title*="Detail" i]'],
    # Same shape as cm_complete (law 5): the visible "Save and Close" in the
    # Edit Invoice Line drawer is NOT a plain <button>/<a> carrying that text --
    # both text selectors matched nothing on 2026-07-25 while the button sat
    # plainly on screen. Try the ADF id leaves first, then widen the tag set
    # beyond button/a, and let _resolve_click_target dump the real candidates
    # if none hit.
    "line_save_close": ['[id$=":SaveandClose"]:not([id$="::popEl"])',
                        '[id$=":saveAndClose"]:not([id$="::popEl"])',
                        '[id$=":sacButton"]:not([id$="::popEl"])',
                        'button:text-is("Save and Close")',
                        'a:text-is("Save and Close")',
                        '[role="button"]:text-is("Save and Close")',
                        'span:text-is("Save and Close")',
                        'div:text-is("Save and Close")'],
    # Only used to BACK OUT of a line drawer that opened the wrong row, so it
    # must never match the page-level Cancel that would discard the whole
    # transaction: exact text, and the drawer is the only thing on screen when
    # this runs.
    "line_cancel":     ['[id$=":Cancel"]:not([id$="::popEl"])',
                        'button:text-is("Cancel")',
                        'a:text-is("Cancel")',
                        '[role="button"]:text-is("Cancel")'],
}


def _txn_link(number):
    """Selector for a transaction-number link in the results grid.

    EXACT match is mandatory: the credit memo is named <invoice>CM, so a
    substring match on the invoice number hits BOTH rows and the robot opens
    the credit memo believing it opened the invoice.
    """
    return ['a:text-is("%s")' % number]


# Labels as they render on the Fusion forms (required-marker tolerant helpers)
LBL_TXN_NUMBER   = "Transaction Number"
LBL_TXN_DATE     = "Transaction Date"
LBL_ACCT_DATE    = "Accounting Date"
LBL_CREDIT_REASON = "Credit Reason"
LBL_COMMENTS     = "Comments"
LBL_TXN_SOURCE   = "Transaction Source"
LBL_DOC_NUMBER   = "Document Number"
LBL_PROJECT      = "Project"
LBL_TASK         = "Task"
LBL_MEMO_LINE    = "Memo Line"   # the drawer's identity check -- see stage 7

# Where the duplicate is stamped so a retry can recognise it.
# Fusion links a credit memo back to its source automatically (Original
# Transaction Number) but records NOTHING linking a duplicate to the invoice it
# was copied from -- so we write our own marker and search for it on a retry.
# Comments confirmed by the user 2026-07-25 (the same box finance already uses
# for the credit memo's explanatory note).
STAMP_FIELD = "Comments"
STAMP_TEMPLATE = "Rebill of {invoice}"

# DISABLED by user decision 2026-07-25: do not write anything into a
# customer-visible field on the new invoice. The Create Transaction header has
# no Comments field at all (only Cross Reference; Comments lives on the
# Miscellaneous tab), and finance does not want either one carrying a robot
# marker.
#
# WHAT THIS COSTS: Fusion records NO link from a duplicate back to its source,
# so without the stamp `_existing_duplicate` cannot prove whether a previous
# attempt already completed one. The compensating control is in
# _stage_dup_complete: on any attempt after the first it REFUSES to click
# Complete and Review without a confirmed duplicate, and asks for a human to
# check. That trades an automatic retry for a safe stop -- the right way round,
# since the failure it prevents is a second live invoice for a customer.
# Set ATD_AR_REBILL_STAMP=1 to re-enable.
STAMP_ENABLED = os.environ.get("ATD_AR_REBILL_STAMP") == "1"

# Tax classification for lines the request does NOT nominate.
#
# DEFAULT IS "LEAVE THEM ALONE" (user decision 2026-07-25, second call): the
# payload is the whole instruction, and the robot must not write to a line the
# request never mentioned -- invoices differ in line count, so anything not
# listed is simply not ours to touch.
#
# The earlier rule was the opposite (force VAT OUTPUT - EXEMPT), and it was not
# arbitrary: a BLANK Tax Classification is not "no tax", Fusion falls back to a
# default that CHARGES VAT, which is how 45100250002 came out at Tax 60.00
# instead of 25.00. That risk is now ACCEPTED and explicit -- an unnominated
# line keeps whatever the duplicate inherited, and if that is blank Fusion may
# tax it. Set ATD_AR_REBILL_OTHER_TAX="VAT OUTPUT - EXEMPT" to restore the old
# behaviour. Stage 6 reports which lines it left alone either way, so the
# choice is visible in the run log rather than implied.
OTHER_TAX_CLASSIFICATION = (os.environ.get("ATD_AR_REBILL_OTHER_TAX") or "").strip()

FINISH_SAVE = "SAVE"
FINISH_COMPLETE = "COMPLETE_AND_CLOSE"


# ---------------------------------------------------------------------------
# Environment gates
# ---------------------------------------------------------------------------
def _live():
    return os.environ.get("ATD_ACTION_LIVE", "0") == "1"


def _stop_after():
    return (os.environ.get("ATD_ACTION_STOP_AFTER") or "").strip().upper() or None


def _allowlist():
    raw = (os.environ.get("ATD_AR_REBILL_ALLOW") or "").strip()
    if not raw:
        return None  # unset = no restriction (go-live state)
    return {x.strip().upper() for x in raw.split(",") if x.strip()}


def _fusion_date(value):
    """ISO 'YYYY-MM-DD' -> Fusion's 'dd/mm/yyyy' display format.

    The API and the Excel template speak ISO because it is unambiguous;
    Fusion's date fields render dd/mm/yyyy (the form's own hint reads
    "Example: 25/07/2026"). Typing an ISO string into that field would be
    silently misread -- 2026-02-28 has no valid dd/mm reading, but 2026-03-04
    does, and it is the WRONG date. Anything already in dd/mm/yyyy is passed
    through unchanged.
    """
    v = (value or "").strip()
    m = re.match(r"^(\d{4})-(\d{2})-(\d{2})$", v)
    if m:
        return "%s/%s/%s" % (m.group(3), m.group(2), m.group(1))
    return v


_JS_VISIBLE_ID = """([suffix,tags])=>{
  const vis=e=>e&&e.offsetParent!==null&&e.getBoundingClientRect().width>0;
  for(const el of document.querySelectorAll(tags)){
    if(el.id&&el.id.endsWith(suffix)&&vis(el))return el.id;
  }
  return null;}"""


def _visible_id_by_suffix(page, suffix, tags="input,textarea"):
    """Id of the first VISIBLE element of `tags` whose id ENDS WITH suffix.

    ADF ids carry a variable region/tab prefix (…:MTF1:<n>:pt1:r1:0:ap1:…) but a
    stable component leaf, so the suffix is the deterministic part.
    """
    try:
        return page.evaluate(_JS_VISIBLE_ID, [suffix, tags])
    except Exception:  # noqa: BLE001
        return None


def _read_by_id_suffix(page, suffix, tags="input,textarea,select"):
    """Current .value of the visible control with this id suffix, or None.

    Reading the CONTROL is the only honest verification. Reading the label's
    neighbour (what _fill_verified used to do) tells you nothing when the fill
    landed on a different field entirely -- which is exactly how "Tax rate
    error" ended up in Transaction Source on 2026-07-25.
    """
    iid = _visible_id_by_suffix(page, suffix, tags)
    if not iid:
        return None
    try:
        return page.evaluate("(id)=>{const e=document.getElementById(id);"
                             "return e?(e.value||''):null;}", iid)
    except Exception:  # noqa: BLE001
        return None


def _fill_by_id_suffix(page, suffix, value, attempts=3):
    """Type into the first VISIBLE input whose id ENDS WITH suffix.

    PROVE THE FIELD IS EMPTY BEFORE TYPING. Two separate ADF behaviours make a
    naive clear-then-type merge the old value with the new one, and both were
    measured on the ADGOV pod 2026-07-25 against the Accounting Date field
    (default 25/07/2026, wanted 28/02/2026):

      locator.fill("")            -> "28/02/20262"       (fill's focus/blur
                                                          cycle re-asserts the
                                                          old value)
      Control+a, Delete, type     -> "28/02/20262/2026"  (ADF re-renders the
                                                          input between the
                                                          clear and the typing,
                                                          so the keystrokes go
                                                          to a fresh element
                                                          still holding its
                                                          default)

    Neither is detectable from a screenshot, and both produce a date Fusion
    will happily accept into the wrong period. So: re-locate the element every
    attempt, clear it, READ IT BACK to confirm it is actually empty (falling
    back to per-character Backspace when select-all did not take), only then
    type, and verify. Retry the whole cycle -- an ADF re-render is transient,
    and the second attempt almost always lands on a settled DOM.
    """
    for attempt in range(attempts):
        iid = _visible_id_by_suffix(page, suffix)
        if not iid:
            return False
        loc = page.locator('[id="%s"]' % iid)
        try:
            loc.click(timeout=5000)
            page.keyboard.press("Control+a")
            page.keyboard.press("Delete")
            time.sleep(0.4)                      # let ADF settle/re-render
            current = _read_by_id_suffix(page, suffix) or ""
            if current:
                # select-all did not take (or the element was swapped) --
                # delete what is actually there, one character at a time
                loc.click(timeout=5000)
                page.keyboard.press("End")
                for _ in range(len(current) + 4):
                    page.keyboard.press("Backspace")
                time.sleep(0.3)
                current = _read_by_id_suffix(page, suffix) or ""
            if current:
                continue                          # still dirty -- try again
            try:
                loc.press_sequentially(value, delay=30)
            except AttributeError:                # older Playwright
                loc.type(value, delay=30)
            page.keyboard.press("Tab")
            time.sleep(0.5)
            got = (_read_by_id_suffix(page, suffix) or "").strip()
            if got == value.strip() or not got:
                return True
            # ADF may reformat (LOVs redisplay a description); accept only an
            # exact-length-ish match, never a value that grew
            if value.strip() in got and len(got) <= len(value.strip()):
                return True
        except Exception:  # noqa: BLE001
            pass
        time.sleep(1)
    return False


JS_CLICK_BY_TEXT = """(args)=>{
  const [want, prefer] = args;
  const vis=e=>e&&e.offsetParent!==null&&e.getBoundingClientRect().width>0
              &&e.getBoundingClientRect().height>0;
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const hits=[];
  document.querySelectorAll('a,button,div,span,td').forEach(e=>{
    if(!vis(e))return;
    if(norm(e.innerText)!==want)return;
    hits.push(e);
  });
  if(!hits.length)return null;
  // prefer a real command element over the span that merely carries the label
  let el=hits.find(e=>prefer.includes(e.tagName.toLowerCase()))||hits[0];
  el.click();
  return el.tagName.toLowerCase()+'#'+(el.id||'(none)');}"""


def _click_by_text(page, text, what, prefer=("a", "button")):
    """Click the visible element whose text EXACTLY equals `text`, via in-DOM
    el.click(), bypassing the selector engine entirely.

    Why this exists: on the Edit Invoice Line drawer 2026-07-25 the diagnostic
    dump proved a VISIBLE `<a>` with text exactly "Save and Close" was present,
    yet `a:text-is("Save and Close")` -- and the span form, and every id
    variant -- matched nothing. ADF wraps the label in a nested span, and the
    combination of that nesting with the drawer's markup defeats the CSS/text
    engine. The DOM scan that FOUND the element is therefore also the thing
    that should click it: no second guess about how to address it.

    Returns "tag#id" of what it clicked, or None.
    """
    try:
        return page.evaluate(JS_CLICK_BY_TEXT, [text, list(prefer)])
    except Exception:  # noqa: BLE001
        return None


def _valid_doc_number(value):
    """A document number is digits, 6-20 of them.

    Guard against capturing a LABEL. On 2026-07-25 stage 9 read the column
    header "Transaction Number", called it the document number and reported
    DONE -- that string would have been written into the AR register as the
    invoice's identifier. A capture that is not a number is a failure, exactly
    as a malformed date is.
    """
    v = (value or "").strip()
    return v.isdigit() and 6 <= len(v) <= 20


def _resolve_click_target(page, selectors, what, keyword):
    """Return the first selector that actually matches something VISIBLE.

    Raises with a dump of the real candidates when none do. A committing click
    is the worst place to discover a stale selector -- on 2026-07-25 the
    text-only 'Complete and Close' selector matched nothing while the button
    sat plainly visible on screen, and the failure said only "no matching
    element", which cost a full re-open of the form to diagnose. Listing what
    IS on the page turns the next such failure into an immediate answer.
    """
    for sel in selectors:
        try:
            loc = page.locator(sel)
            for i in range(min(loc.count(), 12)):
                if loc.nth(i).is_visible():
                    return sel
        except Exception:  # noqa: BLE001
            continue
    try:
        found = page.evaluate(
            """(kw)=>{
              const vis=e=>e&&e.offsetParent!==null&&
                          e.getBoundingClientRect().width>0;
              const out=[];
              document.querySelectorAll('a,button,div[role=button],span').forEach(e=>{
                if(!vis(e))return;
                const t=(e.innerText||'').replace(/\\s+/g,' ').trim();
                if(t&&t.length<70&&t.toLowerCase().includes(kw.toLowerCase()))
                  out.push(e.tagName.toLowerCase()+' id='+(e.id||'(none)')+
                           ' text='+JSON.stringify(t));
              });
              return out.slice(0,12);}""", keyword)
    except Exception:  # noqa: BLE001
        found = []
    raise RuntimeError(
        "%s: none of %s matched a visible element. Visible controls containing "
        "%r right now: %s" % (what, selectors, keyword,
                              "; ".join(found) if found else "(none)"))


def _select_option(page, suffix, what, wanted):
    """Choose an option in an ADF <select> by its VISIBLE TEXT.

    Credit Reason looks like a combo box but is a plain <select> (confirmed by
    diag_ar.py on the ADGOV pod 2026-07-25). Typing into one is not merely
    ineffective -- the keystrokes go somewhere. On the first dry run they
    landed in Transaction Source, opened its "Search and Select" LOV dialog,
    and that dialog then stole focus from the Comments textarea, truncating it
    to "Credit I". One mis-typed field corrupted three.

    Raises with the ACTUAL option list when nothing matches, so a wrong value
    in the request is self-diagnosing instead of silently left blank.
    """
    iid = _visible_id_by_suffix(page, suffix, "select")
    if not iid:
        raise RuntimeError("could not find the %s dropdown (id suffix %s) -- "
                           "re-run diag_ar.py creditform" % (what, suffix))
    opts = page.evaluate(
        "(id)=>Array.from(document.getElementById(id).options)"
        ".map(o=>o.text)", iid) or []
    target = (wanted or "").strip().lower()
    for text in opts:
        if (text or "").strip().lower() == target:
            page.locator('[id="%s"]' % iid).select_option(label=text)
            page.keyboard.press("Tab")
            time.sleep(1)
            return text
    raise RuntimeError(
        "%s %r is not one of the values Fusion offers: %s"
        % (what, wanted, ", ".join(repr(o) for o in opts if o)))


def _fill_verified(page, what, value, label=None, id_suffixes=(), verify=True):
    """Fill a field by label, falling back to id suffixes, then READ IT BACK.

    Two lessons are baked in here.

    (1) Not every field is reachable by label. The Credit Transaction date
        inputs sit next to the hint text "Press down arrow to access Calendar",
        NOT next to "Transaction Date" -- so a label-based fill silently
        no-ops (measured on the ADGOV pod 2026-07-25).
    (2) A silent no-op on a date is the worst outcome available: the form keeps
        its default date and the credit memo posts to the wrong accounting
        period, with nothing in the log to say so.

    So this raises rather than returning False, and verifies the value landed.
    """
    ok = False
    used_suffix = None
    if label:
        ok = _fill_label_real(page, label, value)
    if not ok:
        for suffix in id_suffixes:
            if _fill_by_id_suffix(page, suffix, value):
                ok = True
                used_suffix = suffix
                break
    if not ok:
        raise RuntimeError(
            "could not fill %s -- tried label %r and id suffixes %s. Re-run "
            "diag_ar.py: the form's ids or labels have changed."
            % (what, label, list(id_suffixes)))
    if not verify:
        return True

    # Verify against the CONTROL ITSELF wherever we know its id. The previous
    # version only ever read the LABEL's neighbour, so a field filled purely by
    # id suffix -- every date on this form, because their only label is "Press
    # down arrow to access Calendar" -- was never checked at all. That is how
    # the malformed "28/02/20262" passed as filled (ADGOV pod, 2026-07-25).
    got = None
    for suffix in ([used_suffix] if used_suffix else list(id_suffixes)):
        if suffix:
            got = _read_by_id_suffix(page, suffix)
            if got is not None:
                break
    if got is None and label:
        got = _read_label_value(page, label)
    if got is None or got == "":
        return True
    if got.strip() == value.strip():
        return True
    # ADF reformats some values (LOVs redisplay the description); accept a
    # containment match, but never a value that merely STARTS with what we
    # typed -- that is the signature of a failed clear.
    if value.strip() in got.strip() and len(got.strip()) > len(value.strip()):
        raise RuntimeError(
            "%s did not clear before typing: field shows %r, wanted %r"
            % (what, got, value))
    if value.strip() not in got and got not in value.strip():
        raise RuntimeError("%s did not take: field shows %r, wanted %r"
                           % (what, got, value))
    return True


def _real_click(page, selectors, label, required=True):
    """REAL pointer click on the first VISIBLE match.

    Not every ADF control opens on a synthetic in-DOM el.click(). The af:query
    disclosure needs a real pointer event (ADF law 2) and so does the Review
    Transaction "Actions" menu -- a JS click leaves the popup closed, so the
    menu entries never enter the DOM and the next selector "mysteriously" finds
    nothing. Measured on the ADGOV pod 2026-07-25.
    """
    if isinstance(selectors, str):
        selectors = [selectors]
    for sel in selectors:
        loc = page.locator(sel)
        for i in range(min(loc.count(), 12)):
            el = loc.nth(i)
            try:
                if el.is_visible():
                    el.click(timeout=6000)
                    return True
            except Exception:  # noqa: BLE001
                pass
    if required:
        raise RuntimeError("%s: no visible element (selectors %s)"
                           % (label, selectors))
    return False


def _open_actions_menu(page):
    """Open the Review Transaction Actions menu and wait for its entries."""
    _real_click(page, SEL["actions_menu"], "Actions menu")
    time.sleep(3)


def _shot(page, name):
    """Debug screenshot (headless selector tuning): set ATD_ACTION_SHOT_DIR."""
    d = os.environ.get("ATD_ACTION_SHOT_DIR")
    if not d:
        return
    try:
        page.screenshot(path=os.path.join(d, name), full_page=True)
    except Exception:  # noqa: BLE001
        pass


# ---------------------------------------------------------------------------
# Payload
# ---------------------------------------------------------------------------
def _check_date(label, value):
    """Normalise to ISO YYYY-MM-DD. Accepts ISO or day-first d/m/yyyy (any of
    / - . separators, single digits fine); a day-slot that cannot be a day of
    a real month with month>12 flips the reading (2/13/2026 -> Feb 13).

    Two-digit years are REFUSED: '2/11/26' could be 2 Nov or 11 Feb and a
    wrong-but-valid date silently commits the wrong accounting period. The AR
    page reads real Excel date cells as Date objects, so a legitimate upload
    never produces one -- only hand-built payloads can, and those must be
    explicit.
    """
    v = str(value or "").strip()
    m = re.match(r"^(\d{4})-(\d{1,2})-(\d{1,2})$", v)
    if m:
        y, mo, d = int(m.group(1)), int(m.group(2)), int(m.group(3))
    else:
        m = re.match(r"^(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{4})$", v)
        if not m:
            raise RuntimeError(
                "%s must be YYYY-MM-DD or dd/mm/yyyy with a 4-digit year "
                "(got %r); two-digit years are ambiguous and refused"
                % (label, v))
        d, mo, y = int(m.group(1)), int(m.group(2)), int(m.group(3))
        if mo > 12 and d <= 12:
            d, mo = mo, d
    if not (1 <= mo <= 12 and 1 <= d <= 31):
        raise RuntimeError("%s is not a valid calendar date (got %r)"
                           % (label, v))
    return "%04d-%02d-%02d" % (y, mo, d)


def validate_payload(data):
    """Normalise and validate. Raises RuntimeError on anything malformed --
    a bad payload must fail at the queue, never halfway through Fusion."""
    inv = str(data.get("invoiceNumber") or "").strip()
    if not inv:
        raise RuntimeError("AR_INVOICE_REBILL payload needs invoiceNumber")

    cm = dict(data.get("cm") or {})
    finish = str(cm.get("finish") or FINISH_COMPLETE).strip().upper()
    if finish not in (FINISH_SAVE, FINISH_COMPLETE):
        raise RuntimeError("cm.finish must be %s or %s (got %r)"
                           % (FINISH_SAVE, FINISH_COMPLETE, finish))
    cm["finish"] = finish
    cm["transactionNumber"] = str(cm.get("transactionNumber")
                                  or (inv + "CM")).strip()
    for k in ("transactionDate", "accountingDate"):
        if not str(cm.get(k) or "").strip():
            raise RuntimeError("cm.%s is required" % k)
        cm[k] = _check_date("cm.%s" % k, cm[k])
    cm["creditReason"] = str(cm.get("creditReason") or "").strip()
    cm["comments"] = str(cm.get("comments") or "").strip()

    dup = dict(data.get("duplicate") or {})
    dup["transactionSource"] = str(dup.get("transactionSource")
                                   or "DCT Manual").strip()
    for k in ("transactionDate", "accountingDate"):
        if not str(dup.get(k) or "").strip():
            raise RuntimeError("duplicate.%s is required" % k)
        dup[k] = _check_date("duplicate.%s" % k, dup[k])

    raw_lines = data.get("lines") or []
    if not raw_lines:
        raise RuntimeError("AR_INVOICE_REBILL payload needs at least one line")
    lines = []
    seen = set()
    seen_memos = set()
    for i, ln in enumerate(raw_lines):
        # The MEMO LINE is the matching key (user rule 2026-07-26): the grid
        # row is resolved by memo line, never by position, because the payload
        # order need not match Fusion's line order. lineNumber is optional and
        # serves only as a hint/label -- absent, it defaults to the position.
        raw_no = ln.get("lineNumber")
        if raw_no in (None, ""):
            no = i + 1
        else:
            try:
                no = int(str(raw_no).strip())
            except (TypeError, ValueError):
                raise RuntimeError("lines[%d].lineNumber must be a whole number" % i)
        if no < 1:
            raise RuntimeError("lines[%d].lineNumber must be >= 1" % i)
        if no in seen:
            raise RuntimeError("lines[%d]: line %d is listed twice" % (i, no))
        seen.add(no)
        memo = str(ln.get("memoLine") or "").strip()
        if not memo:
            raise RuntimeError("lines[%d].memoLine is required (it is the "
                               "matching key that selects the grid row)" % i)
        if memo.lower() in seen_memos:
            # memo-based matching cannot tell two identical memo lines apart;
            # such an invoice must be handled manually rather than guessed at
            raise RuntimeError("lines[%d]: memo line %r appears twice in the "
                               "payload -- memo-based matching would be "
                               "ambiguous" % (i, memo))
        seen_memos.add(memo.lower())
        proj = str(ln.get("projectNumber") or "").strip()
        task = str(ln.get("taskNumber") or "").strip()
        if not proj or not task:
            raise RuntimeError("lines[%d] needs projectNumber and taskNumber" % i)
        lines.append({
            "lineNumber": no,
            "memoLine": memo,
            "taxClassification": str(ln.get("taxClassification") or "").strip(),
            "projectNumber": proj,
            "taskNumber": task,
        })
    lines.sort(key=lambda x: x["lineNumber"])

    return {"invoiceNumber": inv, "cm": cm, "duplicate": dup, "lines": lines}


def _check_allowlist(invoice):
    allow = _allowlist()
    if allow is not None and invoice.upper() not in allow:
        raise RuntimeError(
            "invoice %s is not in ATD_AR_REBILL_ALLOW -- refusing. This guard is "
            "deliberate: the action runs against PROD and creates real "
            "transactions. Add the invoice to the allowlist, or unset the "
            "variable at go-live." % invoice)


# ---------------------------------------------------------------------------
# Saga checkpoint access (db/52)
# ---------------------------------------------------------------------------
class _Saga:
    def __init__(self, conn, action_id, host, attempt):
        self.conn = conn
        self.action_id = action_id
        self.host = host
        self.attempt = attempt

    def _call(self, proc, args):
        cur = self.conn.cursor()
        cur.callproc(proc, args)
        cur.close()

    def _func(self, fn, rtype, args):
        cur = self.conn.cursor()
        v = cur.callfunc(fn, rtype, args)
        cur.close()
        return v

    def resume_from(self):
        return int(self._func("prod.atd_action_saga_pkg.resume_from", int,
                              [self.action_id]) or 1)

    def begin(self, no, code):
        self._call("prod.atd_action_saga_pkg.begin_stage",
                   [self.action_id, no, code, self.host, self.attempt])

    def end(self, code, status="DONE", ref=None, note=None):
        self._call("prod.atd_action_saga_pkg.end_stage",
                   [self.action_id, code, status, ref, note])

    def fail(self, code, err):
        self._call("prod.atd_action_saga_pkg.fail_stage",
                   [self.action_id, code, str(err)[:4000]])

    def done(self, code):
        return (self._func("prod.atd_action_saga_pkg.stage_done", str,
                           [self.action_id, code]) or "N") == "Y"

    def ref(self, code):
        return self._func("prod.atd_action_saga_pkg.stage_ref", str,
                          [self.action_id, code])


class _Run:
    """Everything a stage needs, in one object."""

    def __init__(self, page, base, payload, saga):
        self.page = page
        self.base = base
        self.p = payload
        self.saga = saga
        self.invoice = payload["invoiceNumber"]
        self.cm_txn_number = None
        self.cm_doc_number = None
        self.new_txn_number = None
        self.new_doc_number = None

    def gate(self, what):
        """Raise DryRun immediately before a committing click."""
        if not _live():
            raise DryRun("AR_INVOICE_REBILL %s: reached '%s' -- ATD_ACTION_LIVE "
                         "is not 1, nothing committed" % (self.invoice, what))


# ---------------------------------------------------------------------------
# Navigation
# ---------------------------------------------------------------------------
def _goto_billing(page, base):
    """FuseWelcome -> Navigator -> Receivables -> Billing."""
    page.goto(base + "/fscmUI/faces/FuseWelcome", wait_until="domcontentloaded")
    time.sleep(9)
    try:
        page.locator('a[title="Navigator"]').first.click()
    except Exception:  # noqa: BLE001
        pass
    time.sleep(4)
    # ADF: Navigator sub-items are lazy -- expand the group before the item
    _jsclick(page, SEL["nav_group"], "expand Receivables group", required=False)
    time.sleep(2)
    _jsclick(page, SEL["nav_billing"], "Receivables>Billing")
    time.sleep(15)
    _dismiss_overlays(page)


def _open_search_panel(page):
    """ADF law 2: the af:query disclosure only responds to a REAL pointer click
    on the VISIBLE anchor -- header-text clicks and JS clicks never expand it."""
    for _ in range(3):
        if _label_input_id(page, LBL_TXN_NUMBER):
            return True
        for sel in SEL["search_toggle"]:
            loc = page.locator(sel)
            for i in range(min(loc.count(), 10)):
                el = loc.nth(i)
                try:
                    if el.is_visible():
                        el.click(timeout=4000)
                        time.sleep(3)
                        if _label_input_id(page, LBL_TXN_NUMBER):
                            return True
                except Exception:  # noqa: BLE001
                    pass
        time.sleep(2)
    return bool(_label_input_id(page, LBL_TXN_NUMBER))


def _search_transaction(page, number, base=None):
    """Run the Billing transaction search. ADF law 3: REAL keystrokes -- a JS
    value-set leaves the ADF component state empty and the query runs unfiltered.
    ADF law 4: clear any saved-search defaults that would over-constrain it.

    `base` makes the search SELF-HEALING, and it is not optional in practice.
    Only stage 1 navigates to Billing; every later stage inherited that page
    from the stage before it. That holds for a clean single-process run and
    breaks the moment the saga RESUMES -- a fleet retry after a worker restart,
    or the supervised runner picking up at stage 2 -- because the browser then
    opens cold on FuseWelcome with no search panel anywhere. Measured on the
    ADGOV pod 2026-07-25: resuming at CM_CREATE died with "could not open the
    Billing search panel". Navigating on demand costs one page load and makes
    every searching stage independently resumable.
    """
    if not _open_search_panel(page) and base:
        _goto_billing(page, base)
    if not _open_search_panel(page):
        raise RuntimeError("could not open the Billing search panel "
                           "(no %s input)" % LBL_TXN_NUMBER)
    for lbl in ("Bill-to Customer Account Number", LBL_TXN_DATE):
        _clear_label_field(page, lbl)
    if not _fill_label_real(page, LBL_TXN_NUMBER, number):
        raise RuntimeError("could not type into %s" % LBL_TXN_NUMBER)
    time.sleep(1)
    _jsclick(page, SEL["search_run"], "Search", required=False)
    time.sleep(8)


# ---------------------------------------------------------------------------
# The Manage Transactions results grid.
#
# ADF law 5: never map headers onto <td>s by position. The page is a nest of
# tables (toolbars, saved-search menus, column choosers) and the grid itself is
# split -- headers live in `<table>...table2::ch::t` while the data lives
# elsewhere -- so a positional scraper returns confident GARBAGE. Measured on
# the ADGOV pod 2026-07-25: it produced 13 "rows" of saved-search menu text and
# zero real transactions, which would have made the credit-memo probe report
# "no credit memo exists" and raise a SECOND one.
#
# Use the deterministic id scheme instead. Data cells are
#     <...>:table2:<rowIndex>:<componentId>
# with the component ids below harvested by diag_ar.py on the ADGOV pod.
# ---------------------------------------------------------------------------
GRID_TXN_NUMBER = "cl1"   # Transaction Number (the link that opens the record)
GRID_ORIG_TXN = "cl3"     # Original Transaction Number -- populated ONLY on a
                          # credit memo, which is what makes the probe exact

JS_GRID_ROWS = """()=>{
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const rows={};
  document.querySelectorAll('[id*=":table2:"]').forEach(el=>{
    const m=el.id.match(/:table2:(\\d+):([A-Za-z0-9_]+)(?:::|$)/);
    if(!m)return;
    const t=norm(el.innerText);
    if(!t||t.length>60)return;
    const r=m[1], c=m[2];
    if(!rows[r])rows[r]={};
    if(!rows[r][c])rows[r][c]=t;   // first non-empty wins (outermost element)
  });
  return rows;}"""


def _grid_rows(page):
    """{rowIndex: {componentId: text}} for the results grid, or {} when the
    grid is not on screen."""
    try:
        return page.evaluate(JS_GRID_ROWS) or {}
    except Exception:  # noqa: BLE001
        return {}


def _grid_assert_readable(page, expect_number, what):
    """Prove the scraper still understands the grid BEFORE trusting a negative
    answer from it.

    This is the safety invariant of the whole action. "No credit memo found" is
    indistinguishable from "the DOM contract changed and I can read nothing" --
    and the two have wildly different consequences: the first means create one,
    the second means a duplicate against a live customer invoice. So every
    probe first confirms it can see a row it KNOWS is there. If it cannot, the
    stage fails loudly instead of creating anything.
    """
    rows = _grid_rows(page)
    for cells in rows.values():
        if (cells.get(GRID_TXN_NUMBER) or "").strip().upper() \
                == expect_number.strip().upper():
            return rows
    raise RuntimeError(
        "%s: the results grid does not show %s, so its contents cannot be "
        "trusted (read %d row(s)). Refusing to act on a negative probe -- "
        "re-run diag_ar.py, the ADF id scheme has probably changed."
        % (what, expect_number, len(rows)))


def _read_label_value(page, label):
    """Read the displayed value next to a visible label (works for both the
    input form and the read-only Review Transaction header)."""
    js = """(label)=>{
      const norm=s=>(s||'').replace(/\\s+/g,' ').replace(/^\\*+\\s*/,'').trim();
      const vis=e=>e&&e.offsetParent!==null&&e.getBoundingClientRect().width>0;
      for(const l of document.querySelectorAll('label,span,div')){
        if(norm(l.innerText)===label && vis(l)){
          let p=l.closest('tr,td,div'); let d=0;
          while(p&&d<5){
            const inp=p.querySelector('input:not([type=hidden]),textarea');
            if(inp&&vis(inp)) return inp.value||'';
            // read-only header: the value is the next non-empty sibling text
            const sibs=[...p.querySelectorAll('span,div')].map(s=>norm(s.innerText))
                        .filter(t=>t&&t!==label);
            if(sibs.length) return sibs[0];
            p=p.parentElement; d++;
          }
        }
      }
      return '';}"""
    try:
        return (page.evaluate(js, label) or "").strip()
    except Exception:  # noqa: BLE001
        return ""


# ---------------------------------------------------------------------------
# Stages
# ---------------------------------------------------------------------------
def effective_start(saga, start):
    """Pull a resume back to DUPLICATE when the new invoice is not yet committed.

    Stages 5-8 share ONE in-memory Create Transaction form: `Actions >
    Duplicate` builds it in the browser and nothing exists in Fusion until
    DUP_COMPLETE clicks Complete and Review. So a checkpoint of "DUPLICATE
    DONE" does NOT mean the form still exists -- it only means it was opened
    once, in a browser that has since exited.

    resume_from() returns the first gap, which after a stage-6 failure is 6.
    Starting there would edit a form that is not on screen and fail on every
    field. Measured 2026-07-25: stage 6 died on the retry stamp, the process
    exited, and the form went with it.

    Once DUP_COMPLETE is done the invoice is REAL, so we must NOT rebuild the
    form -- that is how a second invoice gets created. Hence the condition is
    "not committed yet", never merely "start > 5".
    """
    if 5 < start <= 8 and not saga.done("DUP_COMPLETE"):
        return 5
    return start


def _stage_locate(run):
    """Find the original invoice and open it. Not found is a clean business
    failure, not a crash."""
    page = run.page
    _goto_billing(page, run.base)
    _search_transaction(page, run.invoice)
    _shot(page, "ar_1_locate_results.png")

    rows = _grid_rows(page)
    hit = any((c.get(GRID_TXN_NUMBER) or "").strip().upper()
              == run.invoice.upper() for c in rows.values())
    if not hit:
        # A genuine business outcome, not a crash -- the request is failed with
        # this exact wording so the AR register can show it verbatim.
        raise RuntimeError("Invoice %s not found" % run.invoice)

    if not _jsclick(page, _txn_link(run.invoice), "open invoice",
                    required=False):
        raise RuntimeError("Invoice %s found in the grid but its link would not "
                           "open" % run.invoice)
    time.sleep(10)
    _shot(page, "ar_1_locate_invoice.png")
    return "DONE", None, "opened %s" % run.invoice


def _existing_credit_memo(page, invoice):
    """The credit-memo idempotency probe -- the single most important check in
    this action, because a false negative creates a second credit memo against
    a live customer invoice.

    'Original Transaction Number' is populated ONLY on a credit memo, so a row
    carrying this invoice there IS the credit memo, and its Transaction Number
    is the answer. The grid is asserted readable first, so a negative result
    means "no credit memo", never "I could not read the page".
    """
    rows = _grid_assert_readable(page, invoice, "credit-memo probe")
    for cells in rows.values():
        if (cells.get(GRID_ORIG_TXN) or "").strip().upper() == invoice.upper():
            return cells.get(GRID_TXN_NUMBER)
    return None


def _stage_cm_create(run):
    """Actions > Credit Transaction, fill the memo, Credit Entire Balance, then
    finish as the request asked."""
    page = run.page
    cm = run.p["cm"]

    # probe: did an earlier attempt already raise the credit memo?
    _search_transaction(page, run.invoice, run.base)
    existing = _existing_credit_memo(page, run.invoice)
    if existing:
        run.cm_txn_number = existing
        return "SKIPPED", existing, "credit memo %s already exists" % existing

    # reopen the invoice (the probe search navigated away from it)
    if not _jsclick(page, _txn_link(run.invoice), "reopen invoice",
                    required=False):
        raise RuntimeError("could not reopen invoice %s" % run.invoice)
    time.sleep(10)

    _open_actions_menu(page)
    _jsclick(page, SEL["act_credit"], "Actions > Credit Transaction")
    time.sleep(12)
    _shot(page, "ar_2_credit_form.png")

    # Field ids harvested by diag_ar.py on the ADGOV pod 2026-07-25. The dates
    # MUST go by id: their nearest label is the calendar hint text, so a
    # label-based fill silently does nothing and the memo posts to the default
    # period.
    _fill_verified(page, "credit memo number", cm["transactionNumber"],
                   label=LBL_TXN_NUMBER, id_suffixes=[":ap1:it1::content"])
    _fill_verified(page, "CM transaction date", _fusion_date(cm["transactionDate"]),
                   label=None, id_suffixes=[":ap1:id1::content"])
    _fill_verified(page, "CM accounting date", _fusion_date(cm["accountingDate"]),
                   label=None, id_suffixes=[":ap1:id2::content"])
    # Credit Reason is a <select>, NOT a text field or an LOV. Never type here:
    # on the 2026-07-25 dry run a typed value went into Transaction Source,
    # opened its Search-and-Select dialog, and the dialog stole focus from the
    # Comments textarea mid-typing. Transaction Source itself is left strictly
    # alone -- it arrives correct (DCT_SYSTEM) and is not ours to set.
    if cm["creditReason"]:
        chosen = _select_option(page, ":ap1:selectOneChoice2::content",
                                "credit reason", cm["creditReason"])
        if chosen.strip().lower() != cm["creditReason"].strip().lower():
            raise RuntimeError("credit reason resolved to %r, wanted %r"
                               % (chosen, cm["creditReason"]))

    # Comments last: it is the longest field, so it is the one that loses text
    # if any earlier control opens a popup. Verified in full below.
    if cm["comments"]:
        _fill_verified(page, "comments", cm["comments"],
                       label=LBL_COMMENTS,
                       id_suffixes=[":ap1:HdrComments::content"])
        got = _read_by_id_suffix(page, ":ap1:HdrComments::content")
        if got is not None and got.strip() != cm["comments"].strip():
            raise RuntimeError(
                "comments were truncated: field holds %r (%d chars), wanted "
                "%r (%d chars)" % (got, len(got or ""), cm["comments"],
                                   len(cm["comments"])))

    # The source must still be what Fusion prefilled -- proof that nothing
    # leaked into it while the memo fields were being filled.
    src = _read_by_id_suffix(page, ":ap1:batchsourceseq::content")
    if src is not None and cm["creditReason"] \
            and src.strip().lower() == cm["creditReason"].strip().lower():
        raise RuntimeError(
            "Transaction Source was overwritten with the credit reason (%r) -- "
            "refusing to complete this credit memo" % src)

    _jsclick(page, SEL["credit_all"], "Credit Entire Balance")
    time.sleep(4)
    _shot(page, "ar_2_credit_filled.png")

    finishing = ("Complete and Close" if cm["finish"] == FINISH_COMPLETE
                 else "Save")
    sels = (SEL["cm_complete"] if cm["finish"] == FINISH_COMPLETE
            else SEL["cm_save"])
    # Resolve the target BEFORE the gate, so a dry run proves the committing
    # button is findable instead of discovering it is not on the live attempt.
    sel = _resolve_click_target(page, sels, finishing,
                                "Complete" if cm["finish"] == FINISH_COMPLETE
                                else "Save")
    run.gate(finishing)

    _jsclick(page, [sel], finishing)
    time.sleep(10)

    run.cm_txn_number = cm["transactionNumber"]
    return "DONE", cm["transactionNumber"], "credit memo %s (%s)" % (
        cm["transactionNumber"], finishing)


def _stage_cm_confirm(run):
    """OK the 'Transaction n has been completed' dialog."""
    if run.p["cm"]["finish"] != FINISH_COMPLETE:
        return "SKIPPED", None, "cm.finish=SAVE, no completion dialog"
    _jsclick(run.page, SEL["dialog_ok"], "confirmation OK", required=False)
    time.sleep(5)
    _shot(run.page, "ar_3_cm_confirmed.png")
    return "DONE", None, "confirmation acknowledged"


def _stage_cm_capture(run):
    """Open the new credit memo and read its Document Number.

    An Incomplete credit memo (cm.finish=SAVE) has no document number yet, so
    this stage is skipped and the register shows the transaction number only.
    """
    if run.p["cm"]["finish"] != FINISH_COMPLETE:
        return "SKIPPED", None, "credit memo left Incomplete, no document number"

    page = run.page
    number = run.cm_txn_number or run.saga.ref("CM_CREATE")
    if not number:
        raise RuntimeError("no credit-memo transaction number to open")

    _search_transaction(page, number, run.base)
    if not _jsclick(page, _txn_link(number), "open credit memo",
                    required=False):
        raise RuntimeError("could not open credit memo %s" % number)
    time.sleep(10)

    doc = _read_label_value(page, LBL_DOC_NUMBER)
    _shot(page, "ar_4_cm_document.png")
    if not doc:
        raise RuntimeError("credit memo %s carries no %s"
                           % (number, LBL_DOC_NUMBER))
    run.cm_doc_number = doc
    return "DONE", doc, "credit memo document number %s" % doc


def _existing_duplicate(page, invoice):
    """Probe for a duplicate this action already completed.

    Unlike the credit memo there is NO Fusion-side link from a duplicate back
    to its source, so stage 6 stamps STAMP_FIELD and this looks for that stamp
    in the grid.

    Returns the transaction number, or None when no row carries the stamp.
    The caller must treat None as "not proven absent" on a retry -- the stamp
    column is only searchable if it is among the grid's visible columns, which
    is why _stage_dup_complete refuses to re-complete on a later attempt rather
    than trusting a bare None.
    """
    if not STAMP_ENABLED:
        # No stamp is written, so this probe is INERT -- it cannot distinguish
        # "no duplicate" from "duplicate exists, unmarked". Returning None is
        # honest; the real guard is _stage_dup_complete refusing to complete on
        # any attempt after the first without a confirmed duplicate.
        return None
    stamp = STAMP_TEMPLATE.format(invoice=invoice).lower()
    for cells in _grid_rows(page).values():
        for text in cells.values():
            if stamp in (text or "").lower():
                return cells.get(GRID_TXN_NUMBER)
    return None


def _stage_duplicate(run):
    """Actions > Duplicate on the original invoice.

    NOT a committing stage: Duplicate only opens a Create Transaction form
    prefilled from the original. Nothing exists in Fusion until stage 7 clicks
    Complete and Review, so this stage is not gated -- gating it would stop
    every dry run before the form whose selectors most need exercising.
    """
    page = run.page

    # RESUME ONTO AN EXISTING DUPLICATE instead of building a second one.
    # Saving a line (Save and Close) also SAVES THE TRANSACTION -- it becomes a
    # real, Incomplete invoice with its own number even though Complete and
    # Review has never run. Discovered the hard way on 2026-07-25: transaction
    # 45100250002 existed while the saga still believed nothing was committed.
    # Re-running stage 5 blindly would duplicate the original AGAIN and leave
    # two invoices for one rebill, so an explicitly known number always wins.
    # This is the idempotency the Comments stamp used to provide, done by exact
    # identity instead of a marker in a customer-visible field.
    resume_txn = (os.environ.get("ATD_AR_REBILL_RESUME_TXN") or "").strip() \
        or (run.saga.ref("DUPLICATE") if run.saga else None)
    if resume_txn:
        _search_transaction(page, resume_txn, run.base)
        if not _jsclick(page, _txn_link(resume_txn), "open existing duplicate",
                        required=False):
            raise RuntimeError(
                "cannot reopen the existing duplicate %s -- refusing to build "
                "another one. Check the transaction in Fusion." % resume_txn)
        time.sleep(10)
        run.new_txn_number = resume_txn
        _shot(page, "ar_5_resumed_duplicate.png")
        return "SKIPPED", resume_txn, ("resumed existing invoice %s (no second "
                                       "duplicate created)" % resume_txn)

    _search_transaction(page, run.invoice, run.base)
    # if a previous attempt already completed a duplicate, do not build another
    already = _existing_duplicate(page, run.invoice)
    if already:
        run.new_txn_number = already
        return "SKIPPED", already, "duplicate %s already exists" % already

    if not _jsclick(page, _txn_link(run.invoice), "reopen invoice",
                    required=False):
        raise RuntimeError("could not reopen invoice %s" % run.invoice)
    time.sleep(10)

    _open_actions_menu(page)
    _jsclick(page, SEL["act_duplicate"], "Actions > Duplicate")
    time.sleep(12)
    _shot(page, "ar_5_duplicate_opened.png")
    return "DONE", None, "duplicate form opened (nothing committed yet)"


# The Create Transaction (duplicate) line grid, harvested by diag_ar.py on the
# ADGOV pod 2026-07-25. Rows are addressed by GRID INDEX (0-based), which is not
# necessarily the invoice Line number -- so we read the memo line at each index
# and match, rather than assuming row N-1 is line N.
DUP_GRID = ":AT1:_ATp:table1:"
DUP_COMP_MEMO = "memoLineNameId"
DUP_COMP_TAX = "taxClassificationCodeId"

# The id prefix `…table1:<row>:memoLineNameId` is shared by the row's INPUT and
# by ADF's decorations for the same component -- the accessibility hint, the
# label, the LOV icon. First-one-wins therefore picked up whichever came first
# in document order, and on 2026-07-25 that was the hint: every row read back as
# "Memo Line Autocompletes on TAB", no row matched the requested memo line, and
# the stage refused to tax anything. The refusal was correct; the read was not.
# A real field ALWAYS wins here, and decoration ids are skipped outright.
JS_DUP_LINE_ROWS = """(args)=>{
  const [grid, comp] = args;
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const out={};
  document.querySelectorAll('[id]').forEach(el=>{
    const i=el.id.indexOf(grid);
    if(i<0)return;
    const tail=el.id.slice(i);
    const m=tail.match(new RegExp('^'+grid.replace(/[.*+?^${}()|[\\]\\\\]/g,'\\\\$&')+'(\\\\d+):'+comp));
    if(!m)return;
    if(/::(hint|lbl|label|desc|lovIconId|popup|glyph)/.test(tail))return;
    const isField=(el.tagName==='INPUT'||el.tagName==='TEXTAREA');
    const v=isField?el.value:norm(el.innerText);
    if(!v)return;
    if(isField) out[m[1]]=v;                    // the control itself wins
    else if(!(m[1] in out)) out[m[1]]=v;        // text only as a placeholder
  });
  return out;}"""


def _dup_line_rows(page):
    """{gridRowIndex: memoLineText} for the duplicate's line grid."""
    try:
        return page.evaluate(JS_DUP_LINE_ROWS, [DUP_GRID, DUP_COMP_MEMO]) or {}
    except Exception:  # noqa: BLE001
        return {}


def _wait_for_line_grid(page, timeout=60):
    """Poll until the duplicate's line grid is READABLE, or give up loudly.

    The grid renders asynchronously after the Invoice Lines tab is selected,
    and how long that takes varies with the page: the Create Transaction form
    usually has it already, the Edit Transaction page (which is where every
    line after the first runs) does not. A fixed `time.sleep(3)` was enough on
    one attempt and not on the next, so the run failed with "could not read the
    line grid -- the id scheme has changed" when nothing had changed at all
    (45100251002, 2026-07-25). Waiting for the CONDITION instead of a duration
    removes the race and is faster in the common case.
    """
    deadline = time.time() + timeout
    while True:
        rows = _dup_line_rows(page)
        if rows:
            return rows
        if time.time() >= deadline:
            return {}
        time.sleep(1)


def _ensure_line_grid(page, timeout=75):
    """Wait for the line grid, SURFACING it if the page morphed underneath us.

    Saving the FIRST line's drawer COMMITS the transaction: the Create
    Transaction form reloads as the Edit Transaction page, which opens on the
    Distribution tab, sometimes behind an Information dialog -- so the grid is
    genuinely not on screen, not merely slow (INV00583821, 2026-07-26).
    Waiting alone can never succeed there. _stage_dup_edit already knew this
    for the RESUME path; this applies the same dismiss-dialog + Invoice-Lines
    -tab dance to every grid wait, because the morph happens mid-stage-7 on
    every fresh invoice.
    """
    deadline = time.time() + timeout
    while True:
        rows = _wait_for_line_grid(page, timeout=15)
        if rows:
            return rows
        if time.time() >= deadline:
            return {}
        _jsclick(page, SEL["dialog_ok"], "dismiss info dialog", required=False)
        time.sleep(1)
        _jsclick(page, ['a[id$=":sdi3::disAcr"]', 'a:text-is("Invoice Lines")',
                        'div[role="tab"]:text-is("Invoice Lines")'],
                 "Invoice Lines tab", required=False)
        time.sleep(2)


def _close_line_drawer(page, what, timeout=45):
    """Close an open line drawer and PROVE the grid is back.

    Every route out of the drawer has to end with the line grid on screen,
    because the next iteration's first act is to read it. A close that quietly
    fails leaves the drawer open and the failure surfaces one line later as
    "the line grid was unreadable" -- which points at the grid instead of at
    the door we left open. So: try Save and Close (selector engine, then the
    exact-text DOM scan that actually works on this drawer), then Cancel, and
    confirm the grid reads before returning.
    """
    for attempt in ("line_save_close", "line_cancel"):
        if _jsclick(page, SEL[attempt], what, required=False) or \
                _real_click(page, SEL[attempt], what, required=False) or \
                _click_by_text(page, "Save and Close" if attempt == "line_save_close"
                               else "Cancel", what):
            rows = _ensure_line_grid(page, timeout=timeout)
            if rows:
                return rows
    raise RuntimeError(
        "%s: the line drawer would not close -- the line grid never came back. "
        "Continuing would read the drawer instead of the grid and mis-resolve "
        "every remaining line." % what)


def _dup_rows_for_line(page, line):
    """ALL grid row indices whose memo line matches the requested line.

    The memo line is the matching key (user rule 2026-07-26) and it applies to
    EVERY row that carries it: an invoice can hold more lines than the request
    names, including several lines sharing one memo. On 45110096161 the
    duplicate had TWO 'Entertainer Permit' lines while the request named one --
    the robot taxed one and left the other with no tax classification and no
    Project/Task, and the user had to correct it by hand. Same memo, same
    treatment, every row (user rule 2026-07-26). Raises when NO row matches,
    because that means the request names a line the duplicate does not have.
    """
    rows = _ensure_line_grid(page)
    if not rows:
        raise RuntimeError(
            "the duplicate's line grid was still unreadable after 60s. That is "
            "usually the Invoice Lines tab not being selected (the Edit "
            "Transaction page opens on Distribution) rather than an id change "
            "-- check the stage screenshot, then re-run probe_details.py")
    want = line["memoLine"].strip().lower()
    matches = [r for r, v in sorted(rows.items(), key=lambda kv: int(kv[0]))
               if (v or "").strip().lower() == want]
    if not matches:
        raise RuntimeError(
            "line %d: no row on the duplicate carries memo line %r (grid shows "
            "%s) -- refusing to change a line that was not requested"
            % (line["lineNumber"], line["memoLine"],
               ", ".join(sorted(set(rows.values())))))
    return matches


JS_LINE_CELL = """(args)=>{
  const [lineNo, header] = args;
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const vis=e=>e&&e.offsetParent!==null&&e.getBoundingClientRect().width>0;
  for(const tb of document.querySelectorAll('table')){
    if(!vis(tb))continue;
    const heads=[...tb.querySelectorAll('th')].map(h=>norm(h.innerText));
    const iLine=heads.findIndex(h=>h==='Line');
    const iWant=heads.findIndex(h=>h===header);
    if(iLine<0||iWant<0)continue;
    for(const tr of tb.querySelectorAll('tr')){
      const tds=[...tr.querySelectorAll('td')];
      if(tds.length<=Math.max(iLine,iWant))continue;
      const cell=tds[iLine];
      const inp=cell.querySelector('input');
      const val=norm(inp?inp.value:cell.innerText);
      if(val===String(lineNo)){
        const t=tds[iWant];
        const el=t.querySelector('input,select,textarea,[id]');
        return {text:norm(t.innerText), id:el?(el.id||''):''};
      }
    }
  }
  return null;}"""


def _line_cell(page, line_no, header):
    try:
        return page.evaluate(JS_LINE_CELL, [line_no, header])
    except Exception:  # noqa: BLE001
        return None


def _verify_memo_line(page, line):
    """Two lines can share a memo line name, so the LINE NUMBER selects the row
    and the memo line VERIFIES it. A mismatch fails the request rather than
    coding the wrong row."""
    cell = _line_cell(page, line["lineNumber"], "Memo Line")
    got = (cell or {}).get("text", "") if cell else ""
    if not cell:
        raise RuntimeError("line %d not found on the duplicate"
                           % line["lineNumber"])
    if got.strip().lower() != line["memoLine"].strip().lower():
        raise RuntimeError(
            "line %d memo line mismatch: Fusion shows %r, the request says %r "
            "-- refusing to change the wrong line"
            % (line["lineNumber"], got, line["memoLine"]))
    return True


def _stage_dup_edit(run):
    """Transaction Source / dates on the header, tax classification on the
    nominated lines, and the retry stamp."""
    page = run.page
    dup = run.p["duplicate"]

    # On a RESUMED invoice the header is already correct and must be left
    # alone. Two reasons, both learned on 45100250002 (2026-07-25): the Edit
    # Transaction page uses DIFFERENT header ids from the Create Transaction
    # form (`:ap1:tdt` does not exist there), and re-writing the dates would
    # re-trigger the invoicing-rule recalculation that reset the accounting
    # date in the first place. Only the line tax classifications still need
    # applying.
    if run.new_txn_number:
        print("  [resume] header already set on %s -- editing lines only"
              % run.new_txn_number, flush=True)
    else:
        # Field ids harvested by diag_ar.py 2026-07-25 (the Create Transaction
        # form's components live under :TCF:0:ap1:).
        _fill_verified(page, "duplicate transaction source",
                       dup["transactionSource"], label=LBL_TXN_SOURCE,
                       id_suffixes=[":ap1:batchSourceId::content"],
                       verify=False)
        time.sleep(2)
        _fill_verified(page, "duplicate transaction date",
                       _fusion_date(dup["transactionDate"]),
                       label=None, id_suffixes=[":ap1:tdt::content"])
        _fill_verified(page, "duplicate accounting date",
                       _fusion_date(dup["accountingDate"]),
                       label=None, id_suffixes=[":ap1:inputDate9::content"])

    # Retry stamp -- OFF by default (see STAMP_ENABLED): nothing is written to a
    # customer-visible field. The Create Transaction HEADER has no Comments at
    # all (Cross Reference only; Comments sits on the Miscellaneous tab), which
    # is what this stage discovered on 2026-07-25.
    if STAMP_ENABLED:
        _real_click(page, ['[id$=":ap1:showMore"]', 'a:text-is("Show More")'],
                    "Show More", required=False)
        time.sleep(3)
        _real_click(page, ['a:text-is("Miscellaneous")',
                           'div[role="tab"]:text-is("Miscellaneous")'],
                    "Miscellaneous tab", required=False)
        time.sleep(3)
        _fill_verified(page, "retry stamp (%s)" % STAMP_FIELD,
                       STAMP_TEMPLATE.format(invoice=run.invoice),
                       label=STAMP_FIELD,
                       id_suffixes=[":ap1:HdrComments::content",
                                    ":ap1:inputText1::content"])

    # Make the line grid visible before touching it. A RESUMED invoice opens on
    # the Edit Transaction page, which lands on the DISTRIBUTION tab (and may
    # carry an Information dialog), so the grid is simply not on screen and
    # every row lookup reads nothing. The freshly-duplicated Create form shows
    # its lines already, where these clicks are harmless no-ops.
    _jsclick(page, SEL["dialog_ok"], "dismiss info dialog", required=False)
    time.sleep(2)
    _jsclick(page, ['a[id$=":sdi3::disAcr"]', 'a:text-is("Invoice Lines")',
                    'div[role="tab"]:text-is("Invoice Lines")'],
             "Invoice Lines tab", required=False)
    time.sleep(4)

    changed = []
    taxed_rows = set()
    for line in run.p["lines"]:
        if not line["taxClassification"]:
            continue
        # memo line is the matching key, and it selects EVERY row carrying that
        # memo -- a duplicate memo on the invoice means every one of those
        # lines gets the same treatment (user rule 2026-07-26)
        for row in _dup_rows_for_line(page, line):
            if not _fill_by_id_suffix(page, "%s%s:%s::content"
                                      % (DUP_GRID, row, DUP_COMP_TAX),
                                      line["taxClassification"]):
                raise RuntimeError("could not set Tax Classification on line %d "
                                   "(grid row %s)" % (line["lineNumber"], row))
            time.sleep(2)
            taxed_rows.add(str(row))
            changed.append("%d:r%s" % (line["lineNumber"], row))

    # Lines the payload does not nominate. The invoice's line count varies from
    # invoice to invoice, so anything not listed is not ours to touch (user
    # decision 2026-07-25) -- see OTHER_TAX_CLASSIFICATION for the accepted
    # risk and the env var that restores the old force-EXEMPT behaviour.
    all_rows = _ensure_line_grid(page)
    other_rows = [r for r in sorted(all_rows.keys(), key=lambda r: int(r))
                  if str(r) not in taxed_rows]
    exempted = []
    if OTHER_TAX_CLASSIFICATION:
        for row in other_rows:
            if not _fill_by_id_suffix(page, "%s%s:%s::content"
                                      % (DUP_GRID, row, DUP_COMP_TAX),
                                      OTHER_TAX_CLASSIFICATION):
                raise RuntimeError(
                    "could not set %r on grid row %s -- refusing to continue "
                    "with a blank Tax Classification, which would over-tax the "
                    "invoice" % (OTHER_TAX_CLASSIFICATION, row))
            time.sleep(2)
            exempted.append(row)

    # Name the untouched lines rather than counting them: they are the ones
    # whose tax nobody has asserted, so the run log has to be specific enough
    # to check them afterwards.
    if OTHER_TAX_CLASSIFICATION:
        other_note = "%d other line(s) set %s" % (len(exempted),
                                                  OTHER_TAX_CLASSIFICATION)
    elif other_rows:
        other_note = "left untouched: %s (not in the payload)" % ", ".join(
            repr(all_rows[r]) for r in other_rows)
    else:
        other_note = "every line on the duplicate was named in the payload"

    _shot(page, "ar_6_duplicate_edited.png")
    return "DONE", None, "tax set on lines %s; %s" % (
        ",".join(str(x) for x in changed) or "(none requested)", other_note)


def _reassert_header_dates(run):
    """Re-apply the header dates IMMEDIATELY before the commit, and verify.

    WHY THIS EXISTS. Stage 6 sets Transaction Date and Accounting Date and
    verifies both landed -- and they do. Then stage 7 opens each line's detail
    drawer and saves it, and saving a line makes Fusion re-run the invoicing
    rule ("In Advance" on these transactions), which RESETS the header
    Accounting Date to the rule-derived value. Measured on 45110096152
    (2026-07-25): 28/02/2026 at the end of stage 6, 18/02/2026 by the end of
    stage 7, and that is the date the invoice completed with.

    A verified fill is therefore not enough on its own -- the field can be
    overwritten AFTER the verification by something we did not type. The only
    safe point to assert a header value is after every edit that could
    recalculate it, i.e. here.

    The accounting date picks the GL period, so a wrong one is a real posting
    error. This raises rather than completing an invoice with a date nobody
    asked for; the form is uncommitted at this point, so a resume simply
    rebuilds it at stage 5.
    """
    dup = run.p["duplicate"]
    for what, wanted, suffix in (
            ("transaction date", _fusion_date(dup["transactionDate"]),
             ":ap1:tdt::content"),
            ("accounting date", _fusion_date(dup["accountingDate"]),
             ":ap1:inputDate9::content")):
        got = _read_by_id_suffix(run.page, suffix)
        if got is None:
            # The Edit Transaction page (resume path) uses different header ids,
            # so an unreadable field is expected there and must not block a
            # resume -- but say so, loudly, rather than assuming it is fine.
            print("  [dates] could not read %s (id %s) -- skipping the "
                  "pre-commit check on this page" % (what, suffix), flush=True)
            continue
        if (got or "").strip() == wanted:
            continue
        print("  [dates] %s drifted to %r after the line edits (invoicing-rule "
              "recalculation); re-setting to %r" % (what, got, wanted),
              flush=True)
        _fill_verified(run.page, "duplicate %s (re-assert)" % what, wanted,
                       label=None, id_suffixes=[suffix])
        time.sleep(2)
        final = _read_by_id_suffix(run.page, suffix)
        if (final or "").strip() != wanted:
            raise RuntimeError(
                "the duplicate's %s reads %r immediately before Complete, and "
                "re-setting it to %r did not hold. Refusing to complete an "
                "invoice with an accounting date nobody requested -- nothing "
                "is committed yet, so re-running resumes from stage 5."
                % (what, final, wanted))


def _stage_dup_complete(run):
    """Complete and Review -- THE commit that brings the new invoice into
    existence.

    On a RETRY this is the one place that could duplicate an invoice: if a
    previous attempt clicked Complete and died before its checkpoint was
    written, the saga resumes at stage 5, rebuilds the form and would complete a
    second one. Stage 5's stamp probe normally catches that. But a bare "no
    stamp found" is not proof of absence -- the stamp column may simply not be
    among the grid's visible columns -- so on any attempt after the first we
    refuse rather than risk it, and ask for a human to confirm.
    """
    attempt = run.saga.attempt if run.saga else 1
    if attempt and int(attempt) > 1 and not run.new_txn_number:
        raise RuntimeError(
            "attempt %s reached Complete and Review with no confirmed duplicate. "
            "A previous attempt may already have completed one. Refusing to "
            "complete a second invoice -- check Fusion for a transaction "
            "stamped %r, then either mark the action DONE or clear its saga "
            "with atd_action_saga_pkg.reset_stages."
            % (attempt, STAMP_TEMPLATE.format(invoice=run.invoice)))

    # LAST possible moment to catch a header value that Fusion recalculated
    # behind us. Must run BEFORE run.gate(), so a dry run exercises it too.
    _reassert_header_dates(run)

    run.gate("Complete and Review")
    # Same two-step as the line drawer's Save and Close: selector engine first,
    # then the exact-text DOM scan. This is THE irreversible click, so it must
    # not fail merely because ADF nests the label in a span (2026-07-25).
    clicked = None

    # PREFERRED PATH on a resumed (Edit Transaction) invoice: open the split
    # menu and choose "Complete and Close". Tried FIRST because the button face
    # next to it is "Complete and Create Another", which also completes but
    # then leaves a blank Create Transaction form open.
    _real_click(run.page, SEL["dup_menu_arrow"], "complete split-menu arrow",
                required=False)
    time.sleep(3)
    for label, key in (("Complete and Review", "dup_menu_review"),
                       ("Complete and Close", "dup_menu_close")):
        for sel in SEL[key]:
            if _jsclick(run.page, [sel], label, required=False):
                clicked = "%s via %s" % (label, sel)
                break
        if not clicked and _click_by_text(run.page, label, label,
                                          prefer=("td", "a", "button")):
            clicked = "%s via text scan" % label
        if clicked:
            break

    for label, key in (() if clicked else
                       (("Complete and Review", "dup_complete"),
                        ("Complete and Create Another", "dup_complete_alt"))):
        for sel in SEL[key]:
            if _jsclick(run.page, [sel], label, required=False):
                clicked = "%s via %s" % (label, sel)
                break
        if not clicked:
            if _click_by_text(run.page, label, label):
                clicked = "%s via text scan" % label
        if clicked:
            print("  [commit] %s" % clicked, flush=True)
            break
    if not clicked:
        raise RuntimeError(
            "neither 'Complete and Review' nor 'Complete and Create Another' "
            "was clickable -- the invoice is NOT completed.")
    time.sleep(15)
    _shot(run.page, "ar_7_duplicate_completed.png")

    # Read the new number NOW, while we are still on the record. Fusion
    # renumbers on completion, so the number this run has been carrying is
    # already dead -- searching for it afterwards returns nothing (measured
    # 2026-07-25: 45100250002 -> 45110096150). Stage 9 falls back to a search
    # only if this read misses.
    doc = _read_label_value(run.page, LBL_DOC_NUMBER)
    txn = _read_label_value(run.page, LBL_TXN_NUMBER)
    if _valid_doc_number(doc):
        run.new_doc_number = doc
    if _valid_doc_number(txn):
        run.new_txn_number = txn
    return "DONE", run.new_txn_number, ("duplicate completed%s"
        % (" as %s" % run.new_txn_number if run.new_txn_number else ""))


def _stage_dup_capture(run):
    """OK the confirmation, then read the new invoice's Document Number."""
    page = run.page
    _jsclick(page, SEL["dialog_ok"], "confirmation OK", required=False)
    time.sleep(6)

    # 1) whatever stage 8 read off the completed record (the reliable source)
    doc = run.new_doc_number
    # 2) else read the page we are on
    if not _valid_doc_number(doc):
        doc = _read_label_value(page, LBL_DOC_NUMBER)
    # 3) else re-find the record by its POST-completion number
    if not _valid_doc_number(doc) and run.new_txn_number:
        _search_transaction(page, run.new_txn_number, run.base)
        if _jsclick(page, _txn_link(run.new_txn_number), "open new invoice",
                    required=False):
            time.sleep(10)
            doc = _read_label_value(page, LBL_DOC_NUMBER)
    _shot(page, "ar_8_new_invoice.png")

    if not _valid_doc_number(doc):
        raise RuntimeError(
            "could not capture a valid document number for the new invoice "
            "(read %r). REFUSING to record it: the invoice IS completed in "
            "Fusion, so find it under transaction %s and record the number by "
            "hand rather than trusting this value."
            % (doc, run.new_txn_number or "(unknown)"))
    run.new_doc_number = doc
    return "DONE", doc, "new invoice document number %s" % doc


def _dff_one_row(run, line, row):
    """Open ONE grid row's Details drawer and set Project/Task on it.

    Returns "skipped" (row already coded) or "done". Everything here is scoped
    to the resolved row (law 22): no generic fallback, the drawer must prove
    its Memo Line before anything is written, and both values are read back
    before the save.
    """
    page = run.page
    # NO BLIND FALLBACK. This used to fall back to SEL["line_details"], a
    # bare [title="Details"] that matches EVERY row's icon and therefore
    # opens the FIRST one. On 45110096152 (2026-07-25) that is exactly what
    # happened for line 3: the row-specific id missed, the fallback opened
    # line 1, and line 3's Project/Task were written over line 1's -- so
    # line 1 ended up with the wrong task and line 3 with none, while the
    # stage reported "project/task set on lines 1,2,3". Resolving the row
    # correctly and then clicking something else is worse than not clicking.
    # THE STAGE SPANS TWO DIFFERENT PAGES. The duplicate opens as a Create
    # Transaction form, but saving the FIRST line's drawer commits the whole
    # transaction (measured on 45100251002, 2026-07-25) -- so every later
    # line runs on the Edit Transaction page, which uses a DIFFERENT
    # component id for the same icon: `cil2` instead of `commandImageLink110`
    # under the same `…:AT1:_ATp:table1:<row>:` prefix.
    row_prefix = "%s%s:" % (DUP_GRID, row)
    details_sels = ['[id$="%scommandImageLink110"]' % row_prefix,
                    '[id$="%scil2"]' % row_prefix,
                    '[id*="%s"][title="Details"]' % row_prefix]

    # THE DETAILS LINK OPENS THE GRID'S *ACTIVE* ROW, NOT THE ROW YOU CLICK.
    # A synthetic in-DOM el.click() does not raise ADF's row-activation
    # event, so the drawer shows whichever row was last touched. Measured on
    # 45100251002 (2026-07-25): stage 6 set tax last on row 2, then stage 7
    # clicked row 1's icon and got row 2's drawer. A REAL pointer click
    # carries the activation with it, so try that first and keep the JS
    # click only as a last resort -- the drawer identity check below is what
    # makes either safe.
    open_memo = None
    for attempt in (1, 2):
        if attempt == 2:
            # Recovery: leave the wrong drawer, then activate the row
            # EXPLICITLY by clicking its own memo-line cell before asking
            # for Details again. Closing first matters -- reopening from
            # inside a drawer just re-shows the same row.
            _real_click(page, SEL["line_cancel"], "Cancel drawer",
                        required=False)
            time.sleep(5)
            _real_click(page, ['[id$="%s%s::content"]'
                               % (row_prefix, DUP_COMP_MEMO)],
                        "activate grid row %s" % row, required=False)
            time.sleep(2)

        opened = _real_click(page, details_sels,
                             "Details icon line %d" % line["lineNumber"],
                             required=False)
        if not opened:
            opened = _jsclick(page, details_sels,
                              "Details icon line %d" % line["lineNumber"],
                              required=False)
        if not opened:
            raise RuntimeError(
                "line %d (%r) resolved to grid row %s but no Details icon "
                "was found under %s. Refusing to click a selector that is "
                "not scoped to that row, because it would open whichever "
                "row is first -- re-run probe_details.py, the grid's id "
                "scheme has changed again."
                % (line["lineNumber"], line["memoLine"], row, row_prefix))
        time.sleep(8)

        # The drawer must PROVE it is the line we asked for before anything
        # is written into it.
        open_memo = _read_label_value(page, LBL_MEMO_LINE)
        if open_memo is None:
            raise RuntimeError(
                "line %d: could not read the Memo Line on the open drawer, "
                "so there is no way to tell which line is about to be "
                "written. Refusing to write blind." % line["lineNumber"])
        if open_memo.strip().lower() == line["memoLine"].strip().lower():
            break
        if attempt == 2:
            raise RuntimeError(
                "line %d: the Details drawer carries memo line %r, not the "
                "requested %r, even after activating grid row %s first -- "
                "ADF keeps opening a different line. Refusing to write "
                "Project/Task onto the wrong line."
                % (line["lineNumber"], open_memo, line["memoLine"], row))
        print("  [line %d] drawer opened %r instead of %r -- closing and "
              "retrying with the row activated first"
              % (line["lineNumber"], open_memo, line["memoLine"]), flush=True)

    cur_proj = _read_label_value(page, LBL_PROJECT)
    cur_task = _read_label_value(page, LBL_TASK)
    # ADF law 8: after an LOV commit Fusion shows the DESCRIPTION, not the
    # code -- so accept either when deciding "already set"
    if (line["projectNumber"] in (cur_proj or "")
            and line["taskNumber"] in (cur_task or "")):
        # ALREADY CODED -- close the drawer (proving the grid comes back;
        # a best-effort close left the drawer open on 45100251002) and skip.
        _close_line_drawer(page, "line %d row %s (already coded)"
                           % (line["lineNumber"], row))
        return "skipped"

    # raises if the labels are not on the drawer -- better a loud failure on
    # the first dry run than lines silently left uncoded
    _fill_verified(page, "line %d project" % line["lineNumber"],
                   line["projectNumber"], label=LBL_PROJECT, verify=False)
    time.sleep(2)
    _fill_verified(page, "line %d task" % line["lineNumber"],
                   line["taskNumber"], label=LBL_TASK, verify=False)
    time.sleep(2)
    _shot(page, "ar_7_line_%d_r%s_dff.png" % (line["lineNumber"], row))

    # Read both values back BEFORE saving. These fills run with verify=False
    # because ADF law 8 means an LOV commit displays the DESCRIPTION rather
    # than the code -- but "cannot match exactly" is not a reason to skip
    # checking altogether. Substring either way covers code-or-description.
    got_proj = _read_label_value(page, LBL_PROJECT) or ""
    got_task = _read_label_value(page, LBL_TASK) or ""
    for what, wanted, got in (("project", line["projectNumber"], got_proj),
                              ("task", line["taskNumber"], got_task)):
        if not got.strip():
            raise RuntimeError(
                "line %d: %s is still EMPTY after filling it with %r -- "
                "refusing to save a line whose DFF did not take."
                % (line["lineNumber"], what, wanted))
        if wanted.lower() not in got.lower() and got.lower() not in wanted.lower():
            raise RuntimeError(
                "line %d: %s reads %r after filling it with %r -- the value "
                "landed somewhere else or the LOV picked a different row."
                % (line["lineNumber"], what, got, wanted))

    # Save and Close commits the LINE into the in-progress transaction; the
    # transaction itself is still uncommitted until Complete and Review.
    run.gate("Save and Close (line %d row %s)" % (line["lineNumber"], row))
    clicked = None
    for sel in SEL["line_save_close"]:
        if _jsclick(page, [sel], "Save and Close", required=False):
            clicked = sel
            break
    if not clicked:
        clicked = _click_by_text(page, "Save and Close", "Save and Close")
    if not clicked:
        raise RuntimeError(
            "Save and Close: line %d could not be saved -- neither the "
            "selectors nor an exact-text DOM scan found a clickable "
            "control. The line drawer is still open and the transaction "
            "is NOT committed." % line["lineNumber"])
    # Clicking Save and Close is not proof it closed. Wait for the line grid
    # to come back, so a failed close is reported HERE, against the line
    # that caused it, instead of one line later as an unreadable grid.
    if not _ensure_line_grid(page, timeout=90):
        raise RuntimeError(
            "line %d: Save and Close was clicked but the line grid never "
            "came back, so the drawer is still open. Whatever this line "
            "saved, the remaining lines cannot be resolved."
            % line["lineNumber"])
    return "done"


def _stage_dup_line_dff(run):
    """Per line: Details > Project + Task > Save and Close.

    Runs on the Create Transaction form, BEFORE Complete and Review (user
    decision 2026-07-25). Two reasons this ordering is better: the whole saga
    then has a single commit (Complete and Review) instead of edits applied to
    an already-completed transaction, and the per-line Details icon on this
    form has a confirmed id (`…:table1:<row>:commandImageLink110`, harvested
    2026-07-25) whereas the completed-invoice grid did not yield one.

    Idempotent: a line already carrying the target Project/Task is left alone,
    so a retry part-way through the lines does not redo the coded ones.
    """
    page = run.page
    done, skipped = [], []

    for line in run.p["lines"]:
        # Saving a line RETURNS to Edit Transaction, and Fusion may raise an
        # Information dialog ("...the accounting date has been reset...") and
        # leave the Distribution tab selected. Both hide the line grid, so the
        # next line's row lookup reads nothing and the stage stops. Measured
        # 2026-07-25 after line 1 saved successfully. Re-assert the context
        # before every line rather than assuming the page came back as we left
        # it -- ADF rarely does.
        _jsclick(page, SEL["dialog_ok"], "dismiss info dialog", required=False)
        time.sleep(2)
        _jsclick(page, ['a[id$=":sdi3::disAcr"]', 'a:text-is("Invoice Lines")',
                        'div[role="tab"]:text-is("Invoice Lines")'],
                 "Invoice Lines tab", required=False)
        time.sleep(3)
        # The memo line selects EVERY matching grid row (user rule 2026-07-26,
        # learned on 45110096161 -- see _dup_rows_for_line). The page context
        # is re-asserted between rows because saving one row's drawer can
        # reload the page (the FIRST save commits the transaction, law 23).
        for row in _dup_rows_for_line(page, line):
            outcome = _dff_one_row(run, line, row)
            label = "%d:r%s" % (line["lineNumber"], row)
            (skipped if outcome == "skipped" else done).append(label)
            _jsclick(page, SEL["dialog_ok"], "dismiss info dialog",
                     required=False)
            time.sleep(1)

    note = "project/task set on lines %s" % (
        ",".join(str(x) for x in done) or "(none)")
    if skipped:
        note += "; already set on %s" % ",".join(str(x) for x in skipped)
    return "DONE", None, note


# Order matters twice over: resume_from() walks these numbers expecting 1..N
# contiguous, and the DFF stage sits BEFORE the commit so the saga has exactly
# one irreversible step (DUP_COMPLETE) rather than edits to a completed invoice.
STAGES = [
    (1, "LOCATE",       _stage_locate),
    (2, "CM_CREATE",    _stage_cm_create),
    (3, "CM_CONFIRM",   _stage_cm_confirm),
    (4, "CM_CAPTURE",   _stage_cm_capture),
    (5, "DUPLICATE",    _stage_duplicate),
    (6, "DUP_EDIT",     _stage_dup_edit),
    (7, "DUP_LINE_DFF", _stage_dup_line_dff),
    (8, "DUP_COMPLETE", _stage_dup_complete),
    (9, "DUP_CAPTURE",  _stage_dup_capture),
]


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------
def rebill(ctx, env, data, action):
    """Run (or resume) the rebill saga. Returns (fusion_id, ref) like every
    other action handler: the new invoice document number, plus a short note."""
    import config  # local import: keeps this module importable without DB creds

    payload = validate_payload(data)
    _check_allowlist(payload["invoiceNumber"])

    action_id = action.get("action_id") or action.get("actionId")
    if not action_id:
        raise RuntimeError("AR_INVOICE_REBILL needs action_id for checkpointing")

    conn = config.connect()
    try:
        saga = _Saga(conn, action_id,
                     action.get("claimed_by") or action.get("worker_host"),
                     action.get("attempts"))
        start = effective_start(saga, saga.resume_from())

        base = _apps_base(env)
        page = ctx.new_page()
        page.set_default_timeout(45000)
        page.set_viewport_size({"width": 1700, "height": 1000})

        run = _Run(page, base, payload, saga)
        stop_after = _stop_after()

        # a resumed run must know what earlier attempts captured
        if start > 1:
            run.cm_txn_number = saga.ref("CM_CREATE")
            run.cm_doc_number = saga.ref("CM_CAPTURE")
            run.new_txn_number = saga.ref("DUPLICATE")
            run.new_doc_number = saga.ref("DUP_CAPTURE")

        try:
            for no, code, fn in STAGES:
                if no < start:
                    continue
                saga.begin(no, code)
                try:
                    status, ref, note = fn(run)
                except DryRun:
                    # not a failure: the stage did its navigation and fills and
                    # stopped at its commit. Leave the checkpoint open so the
                    # live run redoes this stage from the top.
                    saga.end(code, "RUNNING", None, "dry run stopped here")
                    raise
                except Exception as e:  # noqa: BLE001
                    saga.fail(code, e)
                    raise
                saga.end(code, status, ref, note)

                if stop_after and code == stop_after:
                    raise DryRun("AR_INVOICE_REBILL %s: stopped after %s as "
                                 "requested by ATD_ACTION_STOP_AFTER"
                                 % (run.invoice, code))
        finally:
            try:
                page.close()
            except Exception:  # noqa: BLE001
                pass

        doc = run.new_doc_number or saga.ref("DUP_CAPTURE")
        cm = run.cm_doc_number or saga.ref("CM_CAPTURE") or run.cm_txn_number
        return doc, "rebilled %s (credit memo %s)" % (run.invoice, cm or "n/a")
    finally:
        try:
            conn.close()
        except Exception:  # noqa: BLE001
            pass
