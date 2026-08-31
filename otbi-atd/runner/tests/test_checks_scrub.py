import checks


def test_scrub_redacts_telegram_bot_token_from_url():
    text = "502 for https://api.telegram.org/bot123456:ABC-secret/getUpdates"
    cleaned = checks.scrub(text)
    assert "123456:ABC-secret" not in cleaned
    assert "api.telegram.org/bot[redacted]/getUpdates" in cleaned
