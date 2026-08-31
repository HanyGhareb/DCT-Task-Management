"""Unit tests for the per-user OTBI credential plumbing (db/62).

Run from runner/:  python -m pytest tests/test_user_cred.py -q
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import auth      # noqa: E402
import config    # noqa: E402
import notify    # noqa: E402
import runner    # noqa: E402


# ---- auth: credential resolution -------------------------------------------

def test_creds_default_service_account(monkeypatch):
    monkeypatch.setenv("OTBI_USER", "svc@x.ae")
    monkeypatch.setenv("OTBI_PWD", "svc-pwd")
    u, p = auth._creds({"credential_ref": "NOPE"})
    assert (u, p) == ("svc@x.ae", "svc-pwd")


def test_creds_personal_override_wins(monkeypatch):
    monkeypatch.setenv("OTBI_USER", "svc@x.ae")
    monkeypatch.setenv("OTBI_PWD", "svc-pwd")
    u, p = auth._creds({"credential_ref": "NOPE",
                        "cred_user": "me@dctabudhabi.ae", "cred_pwd": "my-pwd"})
    assert (u, p) == ("me@dctabudhabi.ae", "my-pwd")


def test_creds_personal_without_password_raises():
    try:
        auth._creds({"cred_user": "me@dctabudhabi.ae"})
        raise AssertionError("expected RuntimeError")
    except RuntimeError as e:
        assert "no password" in str(e)


# ---- auth: state/profile path suffixing ------------------------------------

def test_default_paths_unchanged():
    # deploy must not move the service-account session (would cost an MFA)
    assert auth._state_path("FUSION_PROD").name == "auth_state_FUSION_PROD.json"
    assert auth._profile_path("FUSION_PROD").name.endswith("_FUSION_PROD")
    assert "__" not in auth._profile_path("FUSION_PROD").name


def test_personal_paths_suffixed():
    env = {"cred_user": "Me.User@dctabudhabi.ae"}
    ident = auth._ident(env)
    assert ident == "me.user_dctabudhabi.ae"
    assert auth._state_path("FUSION_PROD", ident).name == \
        f"auth_state_FUSION_PROD__{ident}.json"
    assert auth._profile_path("FUSION_PROD", ident).name.endswith(f"__{ident}")


def test_ident_empty_for_service_account():
    assert auth._ident({}) == ""
    assert auth._ident({"cred_user": "  "}) == ""


# ---- auth: MFA lock naming ---------------------------------------------------

def test_mfa_lock_name():
    assert auth._mfa_lock_name({}) == "FUSION_MFA"
    assert auth._mfa_lock_name({"cred_user": "Me@X.ae"}) == "FUSION_MFA:me@x.ae"


# ---- runner: session-map keys ------------------------------------------------

def test_ctx_key():
    assert runner._ctx_key("FUSION_PROD") == "FUSION_PROD"
    cred = {"fusion_login": "Me@X.ae", "fusion_pwd": "p"}
    assert runner._ctx_key("FUSION_PROD", cred) == "FUSION_PROD|me@x.ae"


def test_env_of_carries_cred():
    job = {"analytics_base_url": "https://x/analytics", "fusion_apps_url": None,
           "xmlpserver_base_url": None, "credential_ref": "FUSION_ADGOV"}
    cred = {"fusion_login": "me@x.ae", "fusion_pwd": "p", "tg_chat": "123"}
    env = runner._env_of(job, "FUSION_PROD", cred)
    assert env["cred_user"] == "me@x.ae"
    assert env["cred_pwd"] == "p"
    assert env["cred_tg_chat"] == "123"
    dflt = runner._env_of(job, "FUSION_PROD")
    assert "cred_user" not in dflt


def test_session_files_exclude_personal(tmp_path, monkeypatch):
    (tmp_path / "auth_state_FUSION_PROD.json").write_text("{}")
    (tmp_path / "auth_state_FUSION_PROD__me.json").write_text("{}")
    monkeypatch.setenv("ATD_STATE_DIR", str(tmp_path))
    files = runner._session_files()
    assert len(files) == 1
    assert files[0].endswith("auth_state_FUSION_PROD.json")


# ---- notify: per-user chat routing ------------------------------------------

def test_telegram_chat_override(monkeypatch):
    sent = {}

    def fake_telegram(text, chat_id=None):
        sent["chat"] = chat_id
        sent["text"] = text
        return {"result": {"message_id": 1}}

    monkeypatch.setenv("ATD_NOTIFY", "telegram")
    monkeypatch.setattr(notify, "_telegram", fake_telegram)
    assert notify.send("hello", chat_id="999") is True
    assert sent["chat"] == "999"
    assert notify.send("hello") is True
    assert sent["chat"] is None          # default -> _telegram falls back to ATD_TG_CHAT


# ---- config: credential cache fallback matrix -------------------------------

class _FakeVar:
    def __init__(self, val):
        self._val = val

    def getvalue(self):
        return self._val


class _FakeCursor:
    def __init__(self, result):
        self._result = result       # (login, pwd, chat) or Exception
        self._n = 0

    def var(self, _type):
        vals = self._result if not isinstance(self._result, Exception) else (None,) * 3
        v = _FakeVar(vals[self._n])
        self._n += 1
        return v

    def callproc(self, name, args):
        if isinstance(self._result, Exception):
            raise self._result
        assert name in ("prod.atd_cred_pkg.resolve_runner_cred",
                        "prod.atd_cred_pkg.resolve_job_cred")


class _FakeConn:
    def __init__(self, result):
        self._result = result

    def cursor(self):
        return _FakeCursor(self._result)


def test_resolve_user_cred_none_for_blank():
    assert config.resolve_user_cred(_FakeConn((None, None, None)), None) is None
    assert config.resolve_user_cred(_FakeConn((None, None, None)), "  ") is None


def test_resolve_user_cred_hit_and_cache():
    config._CRED_CACHE.clear()
    conn = _FakeConn(("me@x.ae", "pwd", "123"))
    cred = config.resolve_user_cred(conn, "hany")
    assert cred == {"fusion_login": "me@x.ae", "fusion_pwd": "pwd", "tg_chat": "123"}
    # cached: a broken conn must not be touched now
    cred2 = config.resolve_user_cred(_FakeConn(RuntimeError("db down")), "hany")
    assert cred2 == cred


def test_resolve_user_cred_miss_cached():
    config._CRED_CACHE.clear()
    assert config.resolve_user_cred(_FakeConn((None, None, None)), "ghost") is None
    # the miss is cached too
    assert config.resolve_user_cred(_FakeConn(RuntimeError("db down")), "ghost") is None


def test_resolve_job_cred_owner_and_cache():
    config._CRED_CACHE.clear()
    conn = _FakeConn(("owner@x.ae", "pwd", "77"))
    cred = config.resolve_job_cred(conn, "/users/owner@x.ae/Data/A", None)
    assert cred["fusion_login"] == "owner@x.ae"
    # cached per (path-prefix, requester): broken conn must not be touched
    again = config.resolve_job_cred(_FakeConn(RuntimeError("db down")),
                                    "/users/owner@x.ae/Data/A", None)
    assert again == cred
    # a different requester is a DIFFERENT cache slot
    assert config.resolve_job_cred(_FakeConn((None, None, None)),
                                   "/users/owner@x.ae/Data/A", "someone") is None


def test_resolve_job_cred_none():
    config._CRED_CACHE.clear()
    assert config.resolve_job_cred(_FakeConn((None, None, None)),
                                   "/shared/Data/A", None) is None


def test_resolve_user_cred_db_error_not_cached():
    config._CRED_CACHE.clear()
    assert config.resolve_user_cred(_FakeConn(RuntimeError("db down")), "hany") is None
    # a later good lookup succeeds (error was NOT cached as a miss)
    assert config.resolve_user_cred(
        _FakeConn(("me@x.ae", "pwd", None)), "hany")["fusion_login"] == "me@x.ae"
