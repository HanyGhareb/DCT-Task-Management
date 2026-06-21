# PoC kickoff brief — i-Finance Telegram query bot

> **▶ Paste this into a fresh session to start:**
> Build the Telegram query-bot PoC per `otbi-atd/docs/tg-bot-poc-brief.md` —
> start with `/vendor` (number→name and name→fuzzy top-5) and `/help`, polling
> approach (loop `getUpdates` → lookup → `sendMessage`), reuse `notify.py` +
> `config.connect()`, chat-id allow-list (`ATD_TGBOT_ALLOW`, seed `ATD_TG_CHAT`)
> + column whitelist (never IBAN/bank), data from `PROD.ATD_SUPPLIERS`. New
> `tg_bot.py` + cloned `atd-tgbot.service`, deploy to **vm180 only** (getUpdates
> is single-consumer). Then test from an allowed and a non-allowed chat.

**Status:** PLANNED (to be built in a fresh session). Goal = a Telegram bot that
*receives* a message (e.g. a vendor number) and *replies* with i-Finance data
(e.g. the vendor name). This brief is the handoff so a new session starts cold
with full context.

## Goal (PoC scope — keep it minimal)
- `/vendor <number>` → reply with that supplier's name (+ a couple of safe fields).
- `/vendor <text>`   → fuzzy name search, top 5 matches (number — name).
- `/help`            → list commands.
- Everything else / anyone not whitelisted → ignored (or "not authorized").

Defer for later (note, don't build in PoC): PC voucher status, ATD job/run
status, approvals. Decide the next lookup with the user before adding.

## Approach — polling bot (recommended over webhook for the PoC)
A tiny long-running Python service that loops Telegram `getUpdates`, parses the
command, runs ONE whitelisted read-only DB query, replies via `sendMessage`.
No public URL, no new firewall rules — runs on the existing VMs.

(Webhook alternative = `POST /dct/tg/webhook` ORDS handler + `api.telegram.org`
network ACL. More moving parts + a public endpoint to secure. Not for the PoC.)

## Building blocks already present (reuse, don't reinvent)
- **Telegram I/O:** `otbi-atd/runner/notify.py` already does `sendMessage` (send)
  and `getUpdates` (receive) via httpx. Bot token + chat id are in each VM's
  `~/otbi-atd/env.sh` (`ATD_TG_TOKEN`, `ATD_TG_CHAT`).
- **DB:** `otbi-atd/runner/config.py` `connect()` gives a thin `oracledb` conn
  (ADMIN, wallet) — same one the worker uses.
- **Service pattern:** systemd unit model = `otbi-atd/runner/systemd/atd-worker.service`
  (Restart=always, EnvironmentFile sources env.sh). Clone it for `atd-tgbot`.
- **Deploy:** `scp` to `root@192.168.1.18x:/root/otbi-atd/runner/` with key
  `/c/tmp/atd-provision/keys/atd_id_ed25519`; `systemctl` to (re)start.

## Data source
`PROD.ATD_SUPPLIERS` (1417 rows): `SUPPLIER_NUMBER` (NUMBER), `SUPPLIER_NAME`
(VARCHAR2), `SUPPLIER_SITE_STATUS`, `SITE_PAY_GROUP`, `CURRENCY`, and **sensitive
bank fields** (`IBAN`, `BANK_ACCOUNT_NUMBER`, `BANK_NAME`, `ACCOUNT_NAME`).
`DCT_EMP_SUPPLIER_MAP` maps employees↔suppliers.

## Security — two layers, both mandatory
1. **Who can ask:** allow-list of Telegram chat/user IDs (`ATD_TGBOT_ALLOW` =
   comma list; seed with `ATD_TG_CHAT`). Ignore everyone else. Optionally map a
   chat id → an i-Finance user/role later.
2. **What it returns:** whitelist the COLUMNS exposed per command. The PoC
   returns name (+ status/currency at most) — **never** `IBAN` /
   `BANK_ACCOUNT_NUMBER` unless a specific authorized command is added.
   No free-form SQL — only fixed, parameterised lookups.
3. Run only ONE bot instance (Telegram `getUpdates` long-poll is single-consumer
   — running it on all 3 VMs would make them steal each other's updates). Pick
   ONE VM for the bot, or use an offset/lock. (Simplest: bot on vm180 only.)

## File / unit plan (proposed)
- `otbi-atd/runner/tg_bot.py` — poll loop + command dispatch + lookups (import
  `notify`, `config`).
- `otbi-atd/runner/systemd/atd-tgbot.service` — cloned unit, ExecStart runs
  `tg_bot.py`.
- env additions (env.sh): `ATD_TGBOT_ALLOW` (chat-id allow-list); optional
  `ATD_TGBOT_ENABLED=1`.
- Deploy to **one** VM for the PoC.

## Test plan
- From an allowed chat: `/vendor <known number>` → correct name; `/vendor acme`
  → top-5; `/help` → command list.
- From a NON-allowed chat id → no reply (or "not authorized").
- Confirm bank/IBAN never appear in any reply.
- Kill+restart the service → resumes (Restart=always), no duplicate replies
  (track `update_id` offset).

## Open decisions to confirm at kickoff
- Which lookups beyond `/vendor` (if any) for the PoC.
- Allow-list membership (which Telegram users).
- One shared bot for everyone vs. per-user identity mapping (PoC = shared + allow-list).
