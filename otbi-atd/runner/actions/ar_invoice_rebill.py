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
    "cm_complete":    ['a:text-is("Complete and Close"):not([id$="::popEl"])',
                       'button:text-is("Complete and Close"):not([id$="::popEl"])'],
    # "Save" must be exact too, or it matches "Save and Close"
    "cm_save":        ['a:text-is("Save"):not([id$="::popEl"])',
                       'button:text-is("Save"):not([id$="::popEl"])'],
    "dup_complete":   ['a:text-is("Complete and Review"):not([id$="::popEl"])',
                       'button:text-is("Complete and Review"):not([id$="::popEl"])'],
    "dialog_ok":      ['button:text-is("OK")', 'a:text-is("OK")'],
    "line_details":   ['[title="Details"]', 'a[id*="dffIL"]',
                       'img[title*="Detail" i]'],
    "line_save_close": ['button:text-is("Save and Close")',
                        'a:text-is("Save and Close")'],
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

# Where the duplicate is stamped so a retry can recognise it.
# Fusion links a credit memo back to its source automatically (Original
# Transaction Number) but records NOTHING linking a duplicate to the invoice it
# was copied from -- so we write our own marker and search for it on a retry.
# Comments confirmed by the user 2026-07-25 (the same box finance already uses
# for the credit memo's explanatory note).
STAMP_FIELD = "Comments"
STAMP_TEMPLATE = "Rebill of {invoice}"

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


def _fill_by_id_suffix(page, suffix, value):
    """Type into the first VISIBLE input whose id ENDS WITH suffix.

    ADF ids carry a variable region/tab prefix (…:MTF1:<n>:pt1:r1:0:ap1:…) but a
    stable component leaf, so the suffix is the deterministic part. Needed for
    controls that cannot be found by label -- see _fill_verified.
    """
    js = """(suffix)=>{
      const vis=e=>e&&e.offsetParent!==null&&e.getBoundingClientRect().width>0;
      for(const el of document.querySelectorAll('input,textarea')){
        if(el.id&&el.id.endsWith(suffix)&&vis(el))return el.id;
      }
      return null;}"""
    try:
        iid = page.evaluate(js, suffix)
    except Exception:  # noqa: BLE001
        iid = None
    if not iid:
        return False
    loc = page.locator('[id="%s"]' % iid)
    try:
        loc.click(timeout=5000)
        loc.fill("")
        try:
            loc.press_sequentially(value, delay=30)
        except AttributeError:  # older Playwright
            loc.type(value, delay=30)
        page.keyboard.press("Tab")
        return True
    except Exception:  # noqa: BLE001
        return False


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
    if label:
        ok = _fill_label_real(page, label, value)
    if not ok:
        for suffix in id_suffixes:
            if _fill_by_id_suffix(page, suffix, value):
                ok = True
                break
    if not ok:
        raise RuntimeError(
            "could not fill %s -- tried label %r and id suffixes %s. Re-run "
            "diag_ar.py: the form's ids or labels have changed."
            % (what, label, list(id_suffixes)))
    if verify:
        got = _read_label_value(page, label) if label else None
        if got is not None and got != "" and got.strip() != value.strip():
            # ADF reformats some values (LOVs show the description, dates may
            # be re-rendered) -- only flag when nothing resembling it landed
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
    """Accept ISO YYYY-MM-DD (what the API and Excel template use) or Fusion's
    own dd/mm/yyyy, and reject anything else.

    A malformed date must fail HERE. Typed into an ADF date field it would
    either be silently rejected -- leaving the previous value in place and
    committing the wrong accounting period -- or reinterpreted.
    """
    v = str(value or "").strip()
    if not re.match(r"^\d{4}-\d{2}-\d{2}$", v) and \
            not re.match(r"^\d{2}/\d{2}/\d{4}$", v):
        raise RuntimeError("%s must be YYYY-MM-DD or dd/mm/yyyy (got %r)"
                           % (label, v))
    return v


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
    for i, ln in enumerate(raw_lines):
        try:
            no = int(str(ln.get("lineNumber")).strip())
        except (TypeError, ValueError):
            raise RuntimeError("lines[%d].lineNumber must be a whole number" % i)
        if no < 1:
            raise RuntimeError("lines[%d].lineNumber must be >= 1" % i)
        if no in seen:
            raise RuntimeError("lines[%d]: line %d is listed twice" % (i, no))
        seen.add(no)
        memo = str(ln.get("memoLine") or "").strip()
        if not memo:
            # the memo line is the cross-check that stops the robot coding the
            # wrong row -- two lines can share a memo line name, so the line
            # number selects and the memo line verifies
            raise RuntimeError("lines[%d].memoLine is required (it verifies the "
                               "line number)" % i)
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


def _search_transaction(page, number):
    """Run the Billing transaction search. ADF law 3: REAL keystrokes -- a JS
    value-set leaves the ADF component state empty and the query runs unfiltered.
    ADF law 4: clear any saved-search defaults that would over-constrain it."""
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
    _search_transaction(page, run.invoice)
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
    if cm["creditReason"]:
        _fill_verified(page, "credit reason", cm["creditReason"],
                       label=LBL_CREDIT_REASON,
                       id_suffixes=[":ap1:selectOneChoice2::content"],
                       verify=False)   # LOV redisplays the description
    if cm["comments"]:
        _fill_verified(page, "comments", cm["comments"],
                       label=LBL_COMMENTS,
                       id_suffixes=[":ap1:HdrComments::content"])

    _jsclick(page, SEL["credit_all"], "Credit Entire Balance")
    time.sleep(4)
    _shot(page, "ar_2_credit_filled.png")

    finishing = ("Complete and Close" if cm["finish"] == FINISH_COMPLETE
                 else "Save")
    run.gate(finishing)

    _jsclick(page, SEL["cm_complete"] if cm["finish"] == FINISH_COMPLETE
             else SEL["cm_save"], finishing)
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

    _search_transaction(page, number)
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

    _search_transaction(page, run.invoice)
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

JS_DUP_LINE_ROWS = """(args)=>{
  const [grid, comp] = args;
  const norm=s=>(s||'').replace(/\\s+/g,' ').trim();
  const out={};
  document.querySelectorAll('[id]').forEach(el=>{
    const i=el.id.indexOf(grid);
    if(i<0)return;
    const m=el.id.slice(i).match(new RegExp('^'+grid.replace(/[.*+?^${}()|[\\]\\\\]/g,'\\\\$&')+'(\\\\d+):'+comp));
    if(!m)return;
    const v=(el.tagName==='INPUT'||el.tagName==='TEXTAREA')?el.value:norm(el.innerText);
    if(v && !out[m[1]]) out[m[1]]=v;
  });
  return out;}"""


def _dup_line_rows(page):
    """{gridRowIndex: memoLineText} for the duplicate's line grid."""
    try:
        return page.evaluate(JS_DUP_LINE_ROWS, [DUP_GRID, DUP_COMP_MEMO]) or {}
    except Exception:  # noqa: BLE001
        return {}


def _dup_row_for_line(page, line):
    """Grid row index for a requested line.

    The request gives a Line NUMBER; the grid is addressed by row INDEX. They
    usually differ by one, but never assume it -- match on the memo line, which
    is exactly what the memoLine field is there to verify. Raises rather than
    guessing, because the consequence of guessing is taxing the wrong line.
    """
    rows = _dup_line_rows(page)
    if not rows:
        raise RuntimeError("could not read the duplicate's line grid -- re-run "
                           "diag_ar.py, the id scheme has changed")
    want = line["memoLine"].strip().lower()
    guess = str(line["lineNumber"] - 1)
    if (rows.get(guess) or "").strip().lower() == want:
        return guess
    matches = [r for r, v in rows.items() if (v or "").strip().lower() == want]
    if len(matches) == 1:
        return matches[0]
    if not matches:
        raise RuntimeError(
            "line %d: no row on the duplicate carries memo line %r (grid shows "
            "%s) -- refusing to change a line that was not requested"
            % (line["lineNumber"], line["memoLine"],
               ", ".join(sorted(set(rows.values())))))
    raise RuntimeError(
        "line %d: memo line %r matches %d rows and row %s is not one of them, "
        "so the correct row is ambiguous -- refusing to guess"
        % (line["lineNumber"], line["memoLine"], len(matches), guess))


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

    # Field ids harvested by diag_ar.py 2026-07-25 (this form's components live
    # under :TCF:0:ap1: and differ from the Credit Transaction form's).
    _fill_verified(page, "duplicate transaction source", dup["transactionSource"],
                   label=LBL_TXN_SOURCE,
                   id_suffixes=[":ap1:batchSourceId::content"], verify=False)
    time.sleep(2)
    _fill_verified(page, "duplicate transaction date",
                   _fusion_date(dup["transactionDate"]),
                   label=None, id_suffixes=[":ap1:tdt::content"])
    _fill_verified(page, "duplicate accounting date",
                   _fusion_date(dup["accountingDate"]),
                   label=None, id_suffixes=[":ap1:inputDate9::content"])

    # The retry stamp lives in Comments, which is COLLAPSED behind "Show More"
    # on this form -- without expanding it the field is not in the DOM and the
    # stamp silently never lands, leaving a retry unable to recognise its own
    # duplicate. Measured 2026-07-25.
    _real_click(page, ['[id$=":ap1:showMore"]', 'a:text-is("Show More")'],
                "Show More", required=False)
    time.sleep(3)
    _fill_verified(page, "retry stamp (%s)" % STAMP_FIELD,
                   STAMP_TEMPLATE.format(invoice=run.invoice),
                   label=STAMP_FIELD,
                   id_suffixes=[":ap1:HdrComments::content",
                                ":ap1:inputText1::content"])

    changed = []
    for line in run.p["lines"]:
        if not line["taxClassification"]:
            continue
        # match the grid row by memo line -- never assume row == lineNumber-1
        row = _dup_row_for_line(page, line)
        if not _fill_by_id_suffix(page, "%s%s:%s::content"
                                  % (DUP_GRID, row, DUP_COMP_TAX),
                                  line["taxClassification"]):
            raise RuntimeError("could not set Tax Classification on line %d "
                               "(grid row %s)" % (line["lineNumber"], row))
        time.sleep(2)
        changed.append(line["lineNumber"])

    _shot(page, "ar_6_duplicate_edited.png")
    return "DONE", None, "tax classification set on lines %s" % (
        ",".join(str(x) for x in changed) or "(none requested)")


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

    run.gate("Complete and Review")
    _jsclick(run.page, SEL["dup_complete"], "Complete and Review")
    time.sleep(15)
    _shot(run.page, "ar_7_duplicate_completed.png")
    return "DONE", None, "duplicate completed"


def _stage_dup_capture(run):
    """OK the confirmation, then read the new invoice's Document Number."""
    page = run.page
    _jsclick(page, SEL["dialog_ok"], "confirmation OK", required=False)
    time.sleep(6)
    doc = _read_label_value(page, LBL_DOC_NUMBER)
    _shot(page, "ar_8_new_invoice.png")
    if not doc:
        raise RuntimeError("the completed duplicate carries no %s"
                           % LBL_DOC_NUMBER)
    run.new_doc_number = doc
    return "DONE", doc, "new invoice document number %s" % doc


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
        row = _dup_row_for_line(page, line)   # memo-line verified, never guessed
        if not _jsclick(page, ['[id$="%s%s:commandImageLink110"]' % (DUP_GRID, row),
                               '[id*="%s%s:commandImageLink"]' % (DUP_GRID, row)],
                        "Details icon line %d" % line["lineNumber"],
                        required=False):
            _jsclick(page, SEL["line_details"],
                     "Details icon line %d" % line["lineNumber"])
        time.sleep(8)

        cur_proj = _read_label_value(page, LBL_PROJECT)
        cur_task = _read_label_value(page, LBL_TASK)
        # ADF law 8: after an LOV commit Fusion shows the DESCRIPTION, not the
        # code -- so accept either when deciding "already set"
        if (line["projectNumber"] in (cur_proj or "")
                and line["taskNumber"] in (cur_task or "")):
            skipped.append(line["lineNumber"])
            _jsclick(page, SEL["line_save_close"], "Save and Close",
                     required=False)
            time.sleep(5)
            continue

        # raises if the labels are not on the drawer -- better a loud failure on
        # the first dry run than lines silently left uncoded
        _fill_verified(page, "line %d project" % line["lineNumber"],
                       line["projectNumber"], label=LBL_PROJECT, verify=False)
        time.sleep(2)
        _fill_verified(page, "line %d task" % line["lineNumber"],
                       line["taskNumber"], label=LBL_TASK, verify=False)
        time.sleep(2)
        _shot(page, "ar_7_line_%d_dff.png" % line["lineNumber"])

        # Save and Close commits the LINE into the in-progress transaction; the
        # transaction itself is still uncommitted until Complete and Review.
        run.gate("Save and Close (line %d)" % line["lineNumber"])
        _jsclick(page, SEL["line_save_close"], "Save and Close")
        time.sleep(8)
        done.append(line["lineNumber"])

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
        start = saga.resume_from()

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
