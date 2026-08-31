"""Focused tests for Telegram bot Oracle disconnect recovery."""

import sys
import types

# The recovery unit does not make HTTP calls. Keep this test runnable with the
# repository's minimal system Python; production uses the worker venv's real httpx.
sys.modules.setdefault("httpx", types.SimpleNamespace(TimeoutException=TimeoutError))

import tg_bot


class _Connection:
    def __init__(self):
        self.closed = False

    def close(self):
        self.closed = True


def test_sd_notify_is_optional(monkeypatch):
    monkeypatch.delenv("NOTIFY_SOCKET", raising=False)
    assert tg_bot._sd_notify("WATCHDOG=1") is False


def test_disconnect_reconnects_and_retries_same_update(monkeypatch):
    old = _Connection()
    new = _Connection()
    calls = []

    def handle(update, conn, allow):
        calls.append(conn)
        if conn is old:
            raise RuntimeError("DPY-4011: the database or network closed the connection")

    monkeypatch.setattr(tg_bot, "_handle", handle)
    monkeypatch.setattr(tg_bot.config, "connect", lambda: new)
    monkeypatch.setattr(tg_bot.config, "apply_runner_config", lambda conn: 0)

    conn, handled = tg_bot._handle_with_db_retry({"update_id": 42}, old, frozenset())

    assert handled is True
    assert conn is new
    assert old.closed is True
    assert calls == [old, new]


def test_failed_reconnect_keeps_update_pending(monkeypatch):
    old = _Connection()

    def handle(update, conn, allow):
        raise RuntimeError("DPY-4011: connection closed")

    monkeypatch.setattr(tg_bot, "_handle", handle)
    monkeypatch.setattr(
        tg_bot.config,
        "connect",
        lambda: (_ for _ in ()).throw(RuntimeError("DPY-4011: database unavailable")),
    )

    conn, handled = tg_bot._handle_with_db_retry({"update_id": 43}, old, frozenset())

    assert handled is False
    assert conn is old
    assert old.closed is True


def test_non_database_error_is_not_retried(monkeypatch):
    old = _Connection()

    monkeypatch.setattr(
        tg_bot,
        "_handle",
        lambda update, conn, allow: (_ for _ in ()).throw(ValueError("bad command")),
    )

    try:
        tg_bot._handle_with_db_retry({"update_id": 44}, old, frozenset())
    except ValueError as exc:
        assert str(exc) == "bad command"
    else:
        raise AssertionError("non-database error should propagate")
