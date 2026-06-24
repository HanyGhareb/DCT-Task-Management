"""otbi-atd : push the MFA number (NN) to the operator wherever they are.

Best-effort, pluggable. Channel chosen by ATD_NOTIFY:
  telegram  -> ATD_TG_TOKEN, ATD_TG_CHAT          (default / recommended)
  email     -> ATD_SMTP_HOST[, ATD_SMTP_PORT=587], ATD_SMTP_USER, ATD_SMTP_PWD,
               ATD_MAIL_FROM, ATD_MAIL_TO
  webhook   -> ATD_WEBHOOK_URL   (Teams/Slack incoming webhook; posts {"text": ...})
  sms       -> ATD_TWILIO_SID, ATD_TWILIO_TOKEN, ATD_TWILIO_FROM, ATD_TWILIO_TO

send() never raises - a notify failure must not break the login.

Helpers:
  python notify.py test          # send a test message on the configured channel
  python notify.py chatid        # (telegram) print chat ids that have messaged the bot
"""
import os
import sys


class _SafeDict(dict):
    """Leave unknown {placeholders} literal instead of raising KeyError, so an
    edited template that references a wrong field still sends (visibly wrong)."""
    def __missing__(self, key):
        return "{" + key + "}"


def render(env_key, default, **values):
    """Render a notification message from a UI-editable template.

    The template text lives in ATD_RUNNER_CONFIG (overlaid onto os.environ[env_key]
    at startup by config.apply_runner_config). If the key is unset/blank or the
    template is malformed, fall back to `default`. Never raises — a bad template
    must not break a run or hide the underlying event."""
    tpl = (os.environ.get(env_key) or "").strip() or default
    for candidate in (tpl, default):
        try:
            return candidate.format_map(_SafeDict(values))
        except Exception:  # noqa: BLE001 - malformed template -> try the default next
            continue
    return default


def send(text, attempts=3):
    """Send a notification, retrying transient failures (e.g. the flaky Telegram SSL
    handshake timeout / connection reset) up to `attempts` times with a short backoff.
    Never raises — a notify failure must not break the login."""
    import time
    ch = (os.environ.get("ATD_NOTIFY") or "").lower()
    if not ch:
        return False
    fn = {"telegram": _telegram, "email": _email,
          "webhook": _webhook, "sms": _twilio}.get(ch)
    if fn is None:
        print(f"[notify] unknown ATD_NOTIFY={ch!r}")
        return False
    last = None
    for i in range(max(1, attempts)):
        try:
            fn(text)
            return True
        except Exception as e:  # noqa: BLE001 - never break the run on a notify error
            last = e
            if i + 1 < attempts:
                time.sleep(2 * (i + 1))      # 2s, then 4s, before retrying
    print(f"[notify] {ch} send failed after {attempts} attempts: {last}")
    return False


def _telegram(text):
    import httpx
    token = os.environ["ATD_TG_TOKEN"]
    chat = os.environ["ATD_TG_CHAT"]
    r = httpx.post(f"https://api.telegram.org/bot{token}/sendMessage",
                   json={"chat_id": chat, "text": text}, timeout=30)
    r.raise_for_status()


def _webhook(text):
    import httpx
    httpx.post(os.environ["ATD_WEBHOOK_URL"], json={"text": text}, timeout=20).raise_for_status()


def _email(text):
    import smtplib
    from email.message import EmailMessage
    m = EmailMessage()
    m["From"] = os.environ["ATD_MAIL_FROM"]
    m["To"] = os.environ["ATD_MAIL_TO"]
    m["Subject"] = "OTBI sign-in approval needed"
    m.set_content(text)
    host = os.environ["ATD_SMTP_HOST"]
    port = int(os.environ.get("ATD_SMTP_PORT", "587"))
    with smtplib.SMTP(host, port, timeout=30) as s:
        s.starttls()
        s.login(os.environ["ATD_SMTP_USER"], os.environ["ATD_SMTP_PWD"])
        s.send_message(m)


def _twilio(text):
    import httpx
    sid = os.environ["ATD_TWILIO_SID"]
    r = httpx.post(f"https://api.twilio.com/2010-04-01/Accounts/{sid}/Messages.json",
                   data={"From": os.environ["ATD_TWILIO_FROM"],
                         "To": os.environ["ATD_TWILIO_TO"], "Body": text},
                   auth=(sid, os.environ["ATD_TWILIO_TOKEN"]), timeout=20)
    r.raise_for_status()


def _chatid():
    import httpx
    token = os.environ["ATD_TG_TOKEN"]
    r = httpx.get(f"https://api.telegram.org/bot{token}/getUpdates", timeout=20).json()
    seen = set()
    for u in r.get("result", []):
        chat = (u.get("message") or u.get("my_chat_member") or {}).get("chat", {})
        if chat.get("id") and chat["id"] not in seen:
            seen.add(chat["id"])
            print(f"chat_id={chat['id']}  ({chat.get('first_name') or chat.get('title')})")
    if not seen:
        print("no chats yet — send any message to your bot first, then re-run.")


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "test"
    if cmd == "chatid":
        _chatid()
    else:
        ok = send("otbi-atd test message — if you see this, notifications work.")
        print("sent" if ok else "not sent (check ATD_NOTIFY + channel env vars)")
