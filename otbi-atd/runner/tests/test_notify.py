"""Tests for fast, observable Telegram delivery."""

import notify


def test_telegram_send_logs_delivery_metadata(monkeypatch, capsys):
    monkeypatch.setenv("ATD_NOTIFY", "telegram")
    monkeypatch.setattr(
        notify,
        "_telegram",
        lambda text, chat_id=None: {"ok": True, "result": {"message_id": 18452}},
    )

    assert notify.send("MFA 36") is True
    output = capsys.readouterr().out
    assert "telegram delivered attempt=1" in output
    assert "message_id=18452" in output


def test_telegram_retries_quickly_then_succeeds(monkeypatch, capsys):
    monkeypatch.setenv("ATD_NOTIFY", "telegram")
    calls = []
    sleeps = []

    def flaky(text, chat_id=None):
        calls.append(text)
        if len(calls) < 3:
            raise TimeoutError("temporary timeout")
        return {"ok": True, "result": {"message_id": 99}}

    monkeypatch.setattr(notify, "_telegram", flaky)
    monkeypatch.setattr(notify.time, "sleep", sleeps.append)

    assert notify.send("MFA 42") is True
    assert calls == ["MFA 42", "MFA 42", "MFA 42"]
    assert sleeps == [0.5, 1.5]
    assert "telegram delivered attempt=3" in capsys.readouterr().out


def test_telegram_failure_remains_best_effort(monkeypatch):
    monkeypatch.setenv("ATD_NOTIFY", "telegram")
    monkeypatch.setattr(
        notify, "_telegram",
        lambda text, chat_id=None: (_ for _ in ()).throw(TimeoutError("offline"))
    )
    monkeypatch.setattr(notify.time, "sleep", lambda seconds: None)

    assert notify.send("MFA 55") is False
