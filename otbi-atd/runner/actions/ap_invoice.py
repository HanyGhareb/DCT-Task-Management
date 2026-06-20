"""otbi-atd action : create an Accounts Payable invoice in Oracle Fusion.

Driven through the Fusion UI (the user's chosen mechanism) using the shared,
already-authenticated browser context — the same SSO/MFA session the OTBI extract
jobs use. No service account is introduced.

Idempotency (mandatory for writes): before creating anything we probe Fusion for
an invoice already carrying this invoice number (the action's idem_key) via the
read-only Payables REST resource, reusing the session cookies (ctx.request — the
same authenticated channel extract.py uses for Go-URL downloads). If found, we
return that InvoiceId and create nothing. This makes a reaped/retried action safe.

Safety: nothing is saved unless ATD_ACTION_LIVE=1. Otherwise we run the probe +
navigate/validate the Create-Invoice form, then raise actions.DryRun.

NOTE — pod-specific selectors: the Create-Invoice ADF page ids differ per Fusion
release. The fill steps below are a first cut and MUST be confirmed in a HEADED
run against a Fusion TEST pod (see otbi-atd/docs/deployment-notes.md) before the
first live save. The framework around them (queue, idempotency, dry-run, result
callback) is release-independent.
"""
import os
import time
from urllib.parse import urlparse, quote

from . import DryRun

REST_PATH = "/fscmRestApi/resources/11.13.18.05/invoices"


def _live():
    return os.environ.get("ATD_ACTION_LIVE", "0") == "1"


def _apps_base(env):
    """The Fusion Applications base URL (ERP UI + fscmRestApi). Resolution order:
      1. ATD_OTBI_ENV.fusion_apps_url  (explicit column, threaded via env dict)
      2. ATD_FUSION_APPS_URL env var   (override)
      3. derived from analytics_base_url host (OTBI + apps share the SSO domain)."""
    explicit = (env.get("fusion_apps_url") or "").strip()
    if explicit:
        return explicit.rstrip("/")
    override = os.environ.get("ATD_FUSION_APPS_URL")
    if override:
        return override.rstrip("/")
    u = urlparse(env["analytics_base_url"])
    return f"{u.scheme}://{u.netloc}"


def find_existing_invoice(ctx, env, invoice_number):
    """Return the InvoiceId of an existing invoice with this number, else None.
    Read-only REST probe over the session cookies — the idempotency guard."""
    base = _apps_base(env)
    q = quote(f"InvoiceNumber={invoice_number}", safe="=")
    url = f"{base}{REST_PATH}?q={q}&fields=InvoiceId,InvoiceNumber&onlyData=true&limit=1"
    try:
        resp = ctx.request.get(url, timeout=120000)
    except Exception as e:  # noqa: BLE001
        # a failed probe must not be mistaken for "does not exist" — surface it
        raise RuntimeError(f"idempotency probe failed for {invoice_number!r}: {e}")
    if resp.status == 404:
        return None
    if resp.status != 200:
        raise RuntimeError(f"idempotency probe HTTP {resp.status} for {invoice_number!r}")
    try:
        body = resp.json()
    except Exception:  # noqa: BLE001
        # HTML (e.g. a login redirect) means the session is not valid for the apps host
        raise RuntimeError("idempotency probe returned non-JSON (session not valid for apps host?)")
    items = body.get("items") or []
    if items:
        inv = items[0]
        return str(inv.get("InvoiceId") or inv.get("InvoiceNumber") or invoice_number)
    return None


def _fill_invoice_form(page, data):
    """Open Create Invoice and fill header + distribution lines from the payload.
    POD-SPECIFIC: confirm these locators in a headed run against a Fusion test pod."""
    page.set_default_timeout(45000)

    def fill(selectors, value):
        if value is None or value == "":
            return
        for s in selectors:
            loc = page.locator(s)
            if loc.count() > 0:
                loc.first.fill(str(value))
                return
        raise RuntimeError(f"field not found for value {value!r} (selectors {selectors})")

    # Invoice Type (Standard / Prepayment / ...) — configurable per source document
    itype = data.get("invoiceType")
    if itype:
        for s in ['select[id*="InvoiceType"]', 'select[aria-label*="Type"]']:
            loc = page.locator(s)
            if loc.count() > 0:
                try:
                    loc.first.select_option(label=itype)
                except Exception:  # noqa: BLE001
                    loc.first.select_option(itype)
                break

    fill(['input[id*="InvoiceNumber"]', 'input[aria-label*="Number"]'], data.get("invoiceNumber"))
    fill(['input[id*="InvoiceAmount"]', 'input[aria-label*="Amount"]'], data.get("invoiceAmount"))
    fill(['input[id*="InvoiceDate"]', 'input[aria-label*="Date"]'], data.get("invoiceDate"))
    fill(['input[id*="Description"]', 'textarea[id*="Description"]'], data.get("description"))
    payee = data.get("payee") or {}
    fill(['input[id*="Supplier"]', 'input[aria-label*="Supplier"]'],
         payee.get("name") or payee.get("employeeNumber"))
    fill(['input[id*="BusinessUnit"]', 'input[aria-label*="Business Unit"]'], data.get("businessUnit"))

    for ln in (data.get("lines") or []):
        add = page.locator('button[title*="Add"], a[title*="Add Row"], button:has-text("Add")')
        if add.count() > 0:
            add.first.click()
            time.sleep(1)
        fill(['input[id*="LineAmount"]:not([disabled])', 'input[aria-label*="Amount"]:not([disabled])'],
             ln.get("amount"))
        fill(['input[id*="Distribution"]:not([disabled])', 'input[aria-label*="Distribution Combination"]'],
             ln.get("glAccount"))


def _read_back_invoice_id(page, invoice_number):
    """After Save, read the created InvoiceId from the page; fall back to a fresh
    REST lookup so we always confirm a real, saved object."""
    try:
        el = page.locator('span[id*="InvoiceId"], [aria-label*="Invoice Id"]')
        if el.count() > 0:
            txt = el.first.inner_text().strip()
            if txt:
                return txt
    except Exception:  # noqa: BLE001
        pass
    return None


def create(ctx, env, data, action):
    """Create one AP invoice. Returns (invoice_id, ref). Idempotent + dry-run safe."""
    num = data.get("invoiceNumber") or action.get("idem_key")
    if not num:
        raise RuntimeError("AP_INVOICE payload missing invoiceNumber / idem_key")

    # 1) idempotency: never create a duplicate
    existing = find_existing_invoice(ctx, env, num)
    if existing:
        return existing, "existing (idempotent skip)"

    # 2) drive the UI: navigate + fill the form (this validates the selectors).
    #    The final Save is gated by ATD_ACTION_LIVE so a dry-run still exercises
    #    everything up to — but not including — the write.
    base = _apps_base(env)
    page = ctx.new_page()
    try:
        page.goto(base + "/fscmUI/faces/FuseWelcome", wait_until="domcontentloaded")
        time.sleep(4)
        # navigate Payables > Invoices > Create Invoice (deep link varies by pod)
        page.goto(base + "/fscmUI/faces/deeplink?objType=AP_CREATE_INVOICE",
                  wait_until="domcontentloaded")
        time.sleep(5)
        _fill_invoice_form(page, data)

        # safety gate: do not save unless explicitly enabled
        if not _live():
            raise DryRun(f"AP_INVOICE {num}: form filled but ATD_ACTION_LIVE!=1 -> NOT saved "
                         "(set ATD_ACTION_LIVE=1 to create for real)")

        save = page.locator('button:has-text("Save and Close"), button:has-text("Save")')
        if save.count() == 0:
            raise RuntimeError("Save button not found on Create-Invoice form")
        save.first.click()
        time.sleep(6)

        invoice_id = _read_back_invoice_id(page, num)
    finally:
        page.close()

    # 4) confirm via REST that the invoice now exists (authoritative read-back)
    confirmed = find_existing_invoice(ctx, env, num)
    if not confirmed:
        raise RuntimeError(f"AP_INVOICE {num}: Save did not produce a findable invoice "
                           "(not marking DONE so it can be retried safely)")
    return invoice_id or confirmed, "created"
