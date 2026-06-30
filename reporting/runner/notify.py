"""Slim ops-alert channel for the reporting runner (report FAILED, etc.).

Best-effort; never raises. Channel chosen by RPT_NOTIFY (falls back to ATD_NOTIFY
so a shared worker VM reuses the same setup):
  telegram -> ATD_TG_TOKEN, ATD_TG_CHAT
  webhook  -> RPT_WEBHOOK_URL | ATD_WEBHOOK_URL   (Teams/Slack {"text": ...})
  off/unset-> no-op
"""
import os


def send(text, attempts=3):
    import time
    ch = (os.environ.get("RPT_NOTIFY") or os.environ.get("ATD_NOTIFY") or "").lower()
    fn = {"telegram": _telegram, "webhook": _webhook}.get(ch)
    if fn is None:
        return False
    last = None
    for i in range(max(1, attempts)):
        try:
            fn(text)
            return True
        except Exception as e:  # noqa: BLE001 - never break a run on a notify error
            last = e
            if i + 1 < attempts:
                time.sleep(2 * (i + 1))
    print(f"[notify] {ch} failed after {attempts}: {last}")
    return False


def _telegram(text):
    import httpx
    token = os.environ["ATD_TG_TOKEN"]
    chat = os.environ.get("RPT_TG_CHAT") or os.environ["ATD_TG_CHAT"]
    httpx.post(f"https://api.telegram.org/bot{token}/sendMessage",
               json={"chat_id": chat, "text": text}, timeout=30).raise_for_status()


def _webhook(text):
    import httpx
    url = os.environ.get("RPT_WEBHOOK_URL") or os.environ["ATD_WEBHOOK_URL"]
    httpx.post(url, json={"text": text}, timeout=20).raise_for_status()
