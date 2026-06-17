# otbi-atd on an OCI Always-Free VM (headless)

Because the MFA number is delivered to **Telegram** and you approve on your phone, the VM needs
**no display/VNC** — it runs fully headless. This guide stands up the runner on an Always-Free
OCI instance and schedules it.

## 1. Provision the VM (Always Free)
OCI Console → Compute → Instances → **Create instance**:
- **Image:** Ubuntu 22.04 (**ARM/aarch64**).
- **Shape:** Ampere **VM.Standard.A1.Flex**, **2 OCPU / 12 GB** (Always-Free-eligible; needed
  because Chromium wants ~1 GB+ — the tiny AMD micro 1 GB is too small).
- **Networking:** VCN with internet access (VCN wizard); assign a public IPv4.
- **SSH keys:** download the private key.
- Create. *(If "out of host capacity" for A1, retry / change Availability Domain.)*

Outbound only is needed: 443 to the Fusion pod, 443 to api.telegram.org, and ADB SQL*Net
(1521/1522, TLS via wallet). Default egress allows all. Inbound: just SSH 22 from your IP.

## 2. Base software
```bash
sudo apt update && sudo apt -y upgrade
sudo apt -y install python3 python3-pip python3-venv unzip
# Python deps — python-oracledb thin mode IS the fast default load path (no Instant Client/Java)
python3 -m pip install --user playwright httpx python-oracledb
python3 -m playwright install --with-deps chromium     # ARM Chromium + system libs
```
> SQLcl + Java (`openjdk-17-jre-headless`) are only needed for the **fallback** SQLcl load mode
> (Section 3b). The default `oracledb` mode needs neither — just the wallet + `python-oracledb`.

## 3. The ADB wallet (default `oracledb` mode)
```bash
# From OCI Console -> Autonomous DB -> DB Connection -> Download Wallet (set a wallet password).
mkdir -p ~/wallet && cp /path/to/Wallet_*.zip ~/wallet/ && cd ~/wallet && unzip Wallet_*.zip
# Thin mode needs ewallet.pem + tnsnames.ora (cwallet.sso is NOT used; sqlnet.ora optional).
ls ~/wallet/ewallet.pem ~/wallet/tnsnames.ora      # confirm both exist
```
- The runner connects via `python-oracledb` thin mode using `ATD_DB_*` + `ATD_WALLET_PASSWORD`
  (Section 5). **`ATD_WALLET_PASSWORD` decrypts `ewallet.pem`** — it's the password you set when
  downloading the wallet (here it equals the DB password).
- Egress needed: TCP **1522 (TCPS)** to the ADB host (default OCI egress allows it).

## 3b. (Optional) SQLcl + the `prod_mcp` connection — only for the fallback mode
```bash
sudo apt -y install openjdk-17-jre-headless
cd /opt && sudo curl -L -o sqlcl.zip https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip
sudo unzip sqlcl.zip && sudo ln -s /opt/sqlcl/bin/sql /usr/local/bin/sql
sql /nolog
SQL> set cloudconfig /home/ubuntu/wallet/Wallet_xxxx.zip
SQL> connect -save prod_mcp -savepwd <DBUSER>/<DBPASS>@<tns_alias_high>
SQL> exit
```
- `-savepwd` stores the password in SQLcl's secure store so the runner connects unattended.
  Test: `sql -name prod_mcp` then `select 1 from dual;`. Use this only if you set `ATD_DB_MODE=sqlcl`.

## 4. Deploy the runner
```bash
mkdir -p ~/otbi-atd && cd ~/otbi-atd
# copy the repo's otbi-atd/runner/ here (scp/git). Then:
mkdir -p ~/otbi-atd-state          # saved Fusion session + mfa file
```

## 5. Environment (put in ~/otbi-atd/env.sh, chmod 600)
```bash
export OTBI_USER='hg2248@dctabudhabi.ae'
export OTBI_PWD='********'
export ATD_STATE_DIR="$HOME/otbi-atd-state"
export ATD_MFA_WAIT="600"              # give yourself time to approve from the phone
# Telegram MFA delivery
export ATD_NOTIFY="telegram"
export ATD_TG_TOKEN="<bot token from BotFather>"
export ATD_TG_CHAT="<your chat id>"
# DEFAULT fast load (oracledb thin mode, ~155x on the DB load) — uses the wallet from Section 3
export ATD_DB_MODE="oracledb"
export ATD_DB_USER="ADMIN" ; export ATD_DB_PASSWORD="********"
export ATD_WALLET_PASSWORD="********"   # decrypts ewallet.pem (= DB password here)
export ATD_DB_DSN="prod_low" ; export TNS_ADMIN="$HOME/wallet"
export ATD_DB_CHUNK="5000"
# Fallback SQLcl mode instead? unset the ATD_DB_* above and set:
# export ATD_DB_MODE="sqlcl" ; export ATD_SQLCL="/usr/local/bin/sql" ; export ATD_SQLCL_CONN="prod_mcp"
```
> Keep secrets out of git. `chmod 600 env.sh`. Put the passwords (DB + wallet) in **OCI Vault**
> for a real fleet rather than plain files. `oracledb` is the default; SQLcl is the no-creds fallback.

## 6. First run (one-time MFA to seed the session)
```bash
cd ~/otbi-atd/runner && source ~/otbi-atd/env.sh
python3 runner.py
# -> you get the number on Telegram; approve in Authenticator; tables load.
```
This writes `~/otbi-atd-state/auth_state_FUSION_ADGOV.json`. Later runs reuse it silently until
Entra expires it (then you just get another Telegram number to approve).

## 7. Schedule (cron)
```bash
crontab -e
# every day at 06:00 VM time:
0 6 * * *  bash -lc 'source ~/otbi-atd/env.sh && cd ~/otbi-atd/runner && python3 runner.py >> ~/otbi-atd/run.log 2>&1'
```
On a run that needs MFA, the job sends the number to Telegram and waits `ATD_MFA_WAIT` seconds
for your approval; if not approved in time it logs FAILED and the next run retries.

## Linux notes
- The Windows-only SQLcl "Incorrect function" stdin workaround is harmless on Linux.
- Set timezone (`sudo timedatectl set-timezone Asia/Dubai`) so cron + dates align.
- To add analyses on the VM: `python3 add_analysis.py "<path>" --apply` (same as anywhere).
