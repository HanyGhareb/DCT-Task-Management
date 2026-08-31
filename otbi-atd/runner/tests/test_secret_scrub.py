import io
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
import checks


def test_scrub_sensitive_headers_and_cookie_pairs():
    raw = ("cookie: JSESSIONID=abc123; ORA_OCIS_CG_SESSION=secret\n"
           "Authorization: Bearer eyJ.secret.token\n"
           "request failed _WL_AUTHCOOKIE_XYZ=value")
    safe = checks.scrub(raw)
    assert "abc123" not in safe
    assert "secret.token" not in safe
    assert "=value" not in safe
    assert safe.count("[redacted]") >= 3


def test_stream_scrubs_before_write():
    target = io.StringIO()
    stream = checks._RedactingStream(target)
    stream.write("Cookie: JSESSIONID=live-token\n")
    assert "live-token" not in target.getvalue()
    assert "[redacted]" in target.getvalue()
