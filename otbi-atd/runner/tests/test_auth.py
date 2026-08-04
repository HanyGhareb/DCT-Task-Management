"""Unit tests for Entra MFA number detection (no browser/network required)."""

import sys
import types

import auth


class _Element:
    def __init__(self, text):
        self._text = text

    def inner_text(self):
        return self._text


class _Locator:
    def __init__(self, texts):
        self._elements = [_Element(text) for text in texts]

    def count(self):
        return len(self._elements)

    def nth(self, index):
        return self._elements[index]


class _Page:
    def __init__(self, values=None):
        self._values = values or {}

    def locator(self, selector):
        return _Locator(self._values.get(selector, []))

    def inner_text(self, selector):
        raise AssertionError("MFA detection must not scan the whole page")


def test_grab_number_accepts_exact_two_digits_from_mfa_element():
    page = _Page({'.display-sign': [' 4\n2 ']})

    assert auth._grab_number(page, timeout_ms=0) == '42'


def test_grab_number_ignores_unrelated_two_digit_page_text():
    page = _Page()

    assert auth._grab_number(page, timeout_ms=0) == ''


def test_grab_number_rejects_non_exact_mfa_element_text():
    page = _Page({'#idRichContext_DisplaySign': ['Approve number 42', '2026']})

    assert auth._grab_number(page, timeout_ms=0) == ''


class _LockCursor:
    rowcount = 0

    def execute(self, sql, **binds):
        self.rowcount = 1 if sql.startswith("update prod.atd_mfa_lock") else 0

    def fetchone(self):
        return None


class _LockConnection:
    def __init__(self):
        self.cur = _LockCursor()
        self.committed = False
        self.closed = False

    def cursor(self):
        return self.cur

    def commit(self):
        self.committed = True

    def close(self):
        self.closed = True


def test_mfa_slot_acquire_and_release(monkeypatch):
    connections = []

    def connect():
        conn = _LockConnection(); connections.append(conn); return conn

    monkeypatch.setitem(sys.modules, "config", types.SimpleNamespace(connect=connect))
    states = []
    monkeypatch.setattr(auth, "_record_mfa", lambda status, env: states.append((status, env)))

    auth._acquire_mfa_slot("FUSION_ADGOV", 420)
    auth._release_mfa_slot()

    assert states == [("REQUESTED", "FUSION_ADGOV")]
    assert len(connections) == 2
    assert all(c.committed and c.closed for c in connections)
