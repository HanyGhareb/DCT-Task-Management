"""otbi-atd : Telegram query bot (PoC).

Polls Telegram getUpdates, parses commands, runs whitelisted read-only DB
queries, and replies via sendMessage.

Commands:
  /help              — list available commands
  /vendor <number>   — look up supplier by number (name + status + currency)
  /vendor <name>     — fuzzy name search, top 5 results
  (more commands to be added per session — see brief)

Security:
  - Chat-id allow-list: ATD_TGBOT_ALLOW (comma list; falls back to ATD_TG_CHAT).
    Unrecognised chats are silently ignored.
  - Column whitelist: only safe supplier fields are returned — IBAN,
    BANK_ACCOUNT_NUMBER, BANK_NAME, BANK_BRANCH_NAME, ACCOUNT_NAME are NEVER
    included in any reply.
  - No free-form SQL; every query is fixed and parameterised.

Config (env.sh additions needed on vm180 only):
  ATD_TGBOT_ALLOW=<comma-separated chat IDs>   # required; seed with ATD_TG_CHAT
  ATD_TGBOT_ENABLED=1                          # optional gate (default: on)

State: last processed update_id is persisted to
  $ATD_STATE_DIR/tgbot_offset.txt  (default /root/otbi-atd/tgbot_offset.txt)
so a restart does not replay old messages.

Deploy to ONE VM only — getUpdates is single-consumer.
  journalctl -u atd-tgbot -f    # follow logs
"""
import html
import os
import sys
import time
import pathlib

import httpx
import config


# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

_TOKEN_KEY = "ATD_TG_TOKEN"
_ALLOW_KEY = "ATD_TGBOT_ALLOW"
_POLL_TIMEOUT = 30          # seconds for Telegram long-poll
_MAX_FUZZY = 5              # max rows returned by name search
_RETRY_SLEEP = 5            # seconds before retrying after poll error

_STATE_FILE = (
    pathlib.Path(os.environ.get("ATD_STATE_DIR", "/root/otbi-atd"))
    / "tgbot_offset.txt"
)


# ---------------------------------------------------------------------------
# Telegram helpers
# ---------------------------------------------------------------------------

def _tg(method, **kwargs):
    """Call a Telegram Bot API method and return the parsed result list."""
    token = os.environ[_TOKEN_KEY]
    r = httpx.post(
        f"https://api.telegram.org/bot{token}/{method}",
        json=kwargs,
        timeout=_POLL_TIMEOUT + 5,
    )
    r.raise_for_status()
    return r.json()


def _send(chat_id, text):
    """Send an HTML-formatted message to a specific chat ID."""
    try:
        _tg("sendMessage", chat_id=chat_id, text=text, parse_mode="HTML")
    except Exception as exc:
        print(f"[bot] sendMessage → {chat_id} failed: {exc}")


# ---------------------------------------------------------------------------
# Allow-list
# ---------------------------------------------------------------------------

def _allowed_ids():
    """Return the frozenset of authorised Telegram chat IDs.

    Reads ATD_TGBOT_ALLOW (comma or space separated integers).
    Falls back to ATD_TG_CHAT so the operator is always allowed even if
    ATD_TGBOT_ALLOW was not added to env.sh yet.
    """
    raw = (os.environ.get(_ALLOW_KEY) or os.environ.get("ATD_TG_CHAT") or "").replace(",", " ")
    ids = set()
    for part in raw.split():
        try:
            ids.add(int(part))
        except ValueError:
            pass
    return frozenset(ids)


# ---------------------------------------------------------------------------
# DB lookups — safe columns only
# ---------------------------------------------------------------------------
# NEVER add: iban, bank_account_number, bank_name, bank_branch_name, account_name

_SELECT = (
    "SELECT supplier_number, supplier_name, supplier_site_status, currency "
    "FROM prod.atd_suppliers"
)

_STATUS_ICON = {"ACTIVE": "🟢", "INACTIVE": "🔴"}


def _rowdicts(cur):
    cols = [d[0].lower() for d in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


def _fmt_single(row):
    """Rich HTML card for a single supplier (exact lookup)."""
    num    = row.get("supplier_number", "")
    name   = html.escape(row.get("supplier_name") or "(no name)")
    status = (row.get("supplier_site_status") or "").upper()
    cur    = row.get("currency") or ""
    icon   = _STATUS_ICON.get(status, "⚪")
    status_lbl = html.escape(status.capitalize()) if status else "—"
    cur_lbl    = html.escape(cur) if cur else "—"
    return (
        f"🏢 <b>{name}</b>\n"
        f"<code>#{num}</code>\n"
        f"\n"
        f"{icon} {status_lbl}   💱 {cur_lbl}"
    )


def _fmt_row(i, row):
    """One list-item line for a search result (HTML)."""
    num    = row.get("supplier_number", "")
    name   = html.escape(row.get("supplier_name") or "(no name)")
    status = (row.get("supplier_site_status") or "").upper()
    cur    = row.get("currency") or ""
    icon   = _STATUS_ICON.get(status, "⚪")
    meta   = "  ".join(filter(None, [status.capitalize(), cur]))
    return f"{i}. <b>{name}</b>  <code>#{num}</code>\n   {icon} {html.escape(meta)}"


def lookup_number(conn, number):
    """Exact lookup by supplier_number. Returns an HTML-formatted card."""
    cur = conn.cursor()
    cur.execute(_SELECT + " WHERE supplier_number = :n AND rownum = 1", n=int(number))
    rows = _rowdicts(cur)
    if not rows:
        return f"❌ No supplier found for number <code>{number}</code>."
    return _fmt_single(rows[0])


def search_name(conn, query):
    """Case-insensitive substring search. Returns up to _MAX_FUZZY HTML rows."""
    cur = conn.cursor()
    # Subquery so ORDER BY applies before the ROWNUM cap (Oracle quirk)
    cur.execute(
        f"SELECT * FROM ({_SELECT} WHERE UPPER(supplier_name) LIKE :q ORDER BY supplier_number)"
        f" WHERE rownum <= :m",
        q=f"%{query.upper()}%",
        m=_MAX_FUZZY,
    )
    rows = _rowdicts(cur)
    if not rows:
        return f"❌ No suppliers matching <i>{html.escape(query)}</i>."
    n = len(rows)
    header = f"🔍 <b>{n} result{'s' if n > 1 else ''}</b> for <i>{html.escape(query)}</i>"
    items  = "\n\n".join(_fmt_row(i + 1, r) for i, r in enumerate(rows))
    return f"{header}\n\n{items}"


# ---------------------------------------------------------------------------
# Worker refresh (operator re-login trigger) — sets ATD_WORKER_HEARTBEAT.refresh_req;
# the target VM's --forever worker clears it and forces a fresh Fusion login (MFA).
# ---------------------------------------------------------------------------

def _norm_worker(arg):
    """Normalise loose VM input to a worker_id: 'vm180'/'180'/'atd-vm180' -> 'atd-vm180';
    'all' -> 'all'. Returns None for empty input."""
    a = (arg or "").strip().lower()
    if not a:
        return None
    if a == "all":
        return "all"
    if a.startswith("atd-"):
        return a
    if a.startswith("vm"):
        return "atd-" + a
    if a.isdigit():
        return "atd-vm" + a
    return "atd-" + a


def do_refresh(conn, arg):
    """Request a re-login for a worker (or all). Returns an HTML reply."""
    w = _norm_worker(arg)
    if not w:
        return ("Usage: <code>refresh vm180</code> (or vm181 / vm182, or "
                "<code>refresh all</code>)")
    cur = conn.cursor()
    if w == "all":
        cur.execute("update prod.atd_worker_heartbeat set refresh_req = systimestamp")
    else:
        cur.execute("update prod.atd_worker_heartbeat set refresh_req = systimestamp "
                    "where worker_id = :w", w=w)
    n = cur.rowcount
    conn.commit()
    if n == 0:
        return (f"❌ No worker matching <code>{html.escape(w)}</code>. "
                f"Try <code>vm180</code> / <code>vm181</code> / <code>vm182</code> / "
                f"<code>all</code>.")
    tgt = "all workers" if w == "all" else f"<code>{html.escape(w)}</code>"
    return (f"🔄 Re-login requested for {tgt} ({n}). The worker will start a fresh login "
            f"shortly — <b>approve the Microsoft Authenticator number</b> when it arrives.")


# ---------------------------------------------------------------------------
# Command dispatch
# ---------------------------------------------------------------------------

_HELP = (
    "🏦 <b>i-Finance Bot</b>\n"
    "\n"
    "<b>📦 Vendors</b>\n"
    "/vendor <code>12345</code>  — look up by number\n"
    "/vendor <code>acme</code>   — fuzzy name search (top 5)\n"
    "\n"
    "<b>🖥️ Analytics Loader (ops)</b>\n"
    "<code>refresh vm180</code>  — re-login a worker (vm180/181/182, or "
    "<code>all</code>); then approve the Authenticator number\n"
    "\n"
    "<b>🔜 Coming soon</b>\n"
    "/payments  ·  /pettycash  ·  /freelancer\n"
    "\n"
    "/help — show this message\n"
    "\n"
    "<i>Finance Department\n"
    "Department of Culture and Tourism</i>"
)

_COMING_SOON = {
    "/payments":   "🔜 <b>Payments</b> lookup — coming soon.",
    "/pettycash":  "🔜 <b>Petty Cash</b> lookup — coming soon.",
    "/freelancer": "🔜 <b>Freelancers</b> lookup — coming soon.",
}


def _handle(update, conn, allow):
    """Dispatch one Telegram update dict."""
    msg = update.get("message") or update.get("edited_message")
    if not msg:
        return
    chat_id = msg.get("chat", {}).get("id")
    text = (msg.get("text") or "").strip()
    if not chat_id or not text:
        return

    if chat_id not in allow:
        print(f"[bot] ignored update from chat_id={chat_id} (not in allow-list)")
        return  # silent ignore — do not reveal the bot exists to strangers

    # Strip the @botname suffix Telegram appends in groups; accept with or without /
    cmd_part, _, arg = text.partition(" ")
    cmd = cmd_part.lower().split("@")[0]
    if not cmd.startswith("/"):
        cmd = "/" + cmd
    arg = arg.strip()

    if cmd in ("/start", "/help"):
        _send(chat_id, _HELP)
        return

    if cmd in _COMING_SOON:
        _send(chat_id, _COMING_SOON[cmd])
        return

    if cmd == "/vendor":
        if not arg:
            _send(chat_id,
                  "Usage:\n"
                  "  /vendor <code>12345</code>  — exact lookup by number\n"
                  "  /vendor <code>acme</code>   — fuzzy name search")
            return
        try:
            _send(chat_id, lookup_number(conn, int(arg)))
        except ValueError:
            _send(chat_id, search_name(conn, arg))
        return

    if cmd == "/refresh":
        _send(chat_id, do_refresh(conn, arg))
        return

    _send(chat_id, _HELP)


# ---------------------------------------------------------------------------
# Offset persistence (survives Restart=always without replaying old messages)
# ---------------------------------------------------------------------------

def _load_offset():
    try:
        return int(_STATE_FILE.read_text().strip())
    except Exception:
        return 0


def _save_offset(offset):
    try:
        _STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
        _STATE_FILE.write_text(str(offset))
    except Exception as exc:
        print(f"[bot] warning: could not save offset: {exc}")


# ---------------------------------------------------------------------------
# Poll loop
# ---------------------------------------------------------------------------

def run():
    enabled = os.environ.get("ATD_TGBOT_ENABLED", "1").strip()
    if enabled.lower() in ("0", "false", "no", "off"):
        print("[bot] ATD_TGBOT_ENABLED is falsy — exiting.")
        return

    print("[bot] starting — connecting to DB …")
    conn = config.connect()
    config.apply_runner_config(conn)

    allow = _allowed_ids()
    if not allow:
        print("[bot] WARNING: ATD_TGBOT_ALLOW is empty and ATD_TG_CHAT is unset — "
              "no one will be served. Set ATD_TGBOT_ALLOW in env.sh.")
    else:
        print(f"[bot] allow-list: {sorted(allow)}")

    offset = _load_offset()
    print(f"[bot] polling from offset={offset} (long-poll timeout={_POLL_TIMEOUT}s)")

    while True:
        try:
            data = _tg("getUpdates", offset=offset, timeout=_POLL_TIMEOUT)
            for u in data.get("result", []):
                uid = u.get("update_id", 0)
                try:
                    _handle(u, conn, allow)
                except Exception as exc:
                    print(f"[bot] error handling update {uid}: {exc}")
                if uid + 1 > offset:
                    offset = uid + 1
                    _save_offset(offset)
        except httpx.TimeoutException:
            pass  # normal for long-poll with no messages
        except Exception as exc:
            print(f"[bot] poll error: {exc} — retrying in {_RETRY_SLEEP}s")
            time.sleep(_RETRY_SLEEP)
            try:
                conn = config.connect()
            except Exception as cexc:
                print(f"[bot] DB reconnect failed: {cexc}")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "chatid":
        # Helper: print all chat IDs that have messaged the bot
        from notify import _chatid  # noqa: PLC0415
        _chatid()
    else:
        run()
