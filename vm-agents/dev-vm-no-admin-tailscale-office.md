# Reach the Dev VMs from a Work Laptop — NO ADMIN (Tailscale userspace mode)

The normal Tailscale Windows client needs admin (it installs a service + network
driver). This method instead runs Tailscale's **standalone binaries** in
**userspace mode** — just `.exe` files in your own user folder. No install, no
service, no driver, **no admin**. It gives you a local **SOCKS5 proxy** at
`127.0.0.1:1055`; you point your browser (and optionally VS Code) at it to reach
the VMs.

**Your VM addresses (Tailscale IPs):**
- dev-vm  → `100.119.47.78`   (code-server: `:8080`, password `DevVM@2026`)
- dev-vm2 → `100.105.123.46`  (code-server: `:8080`, password `DevVM@2026`)

> Heads-up: some corporate networks block Tailscale or block running `.exe` from
> your user folder (AppLocker). If a step is blocked, note the exact error and
> send it over — there are workarounds.

---

## Step 1 — Get the binaries WITHOUT installing (no admin)

Tailscale has NO Windows static `.zip` (that list on the site is Linux-only).
Windows ships only as an MSI — but you can **extract** the two `.exe` files from
the MSI without installing it. Extraction needs no admin; only *installing* does.

1. Download the Windows MSI (direct link):
   **https://pkgs.tailscale.com/stable/tailscale-setup-1.98.4-amd64.msi**
   (or get the current version from https://pkgs.tailscale.com/stable/ → Windows)
2. Open a Command Prompt and run an **administrative extract** (unpacks, does
   NOT install — no service, no driver, no admin):
   ```
   msiexec /a "%USERPROFILE%\Downloads\tailscale-setup-1.98.4-amd64.msi" /qb TARGETDIR="%USERPROFILE%\tailscale"
   ```
3. In `C:\Users\<you>\tailscale\` (check subfolders too), find **`tailscale.exe`**
   and **`tailscaled.exe`**. Move both to `%USERPROFILE%\tailscale\` if they
   landed in a subfolder.
   - If `msiexec /a` is blocked by policy: open the MSI with 7-Zip and extract the
     two exes, or tell me and I'll give another no-admin extraction route.

---

## Step 2 — Create two small helper scripts

Open **Notepad** and save these into `%USERPROFILE%\tailscale\`.

### 2a. `start-tailscaled.bat`  (starts the background daemon)
```bat
@echo off
set TSDIR=%USERPROFILE%\tailscale
if not exist "%TSDIR%\state" mkdir "%TSDIR%\state"
echo Starting Tailscale (userspace, no admin)...
echo Leave this window OPEN while you work. Close it to disconnect.
"%TSDIR%\tailscaled.exe" -tun=userspace-networking -socks5-server=127.0.0.1:1055 -state="%TSDIR%\state\tailscaled.state" -socket=\\.\pipe\tailscaled-userspace -verbose=1
```

### 2b. `ts.bat`  (talks to the daemon without retyping the socket)
```bat
@echo off
"%USERPROFILE%\tailscale\tailscale.exe" -socket=\\.\pipe\tailscaled-userspace %*
```

---

## Step 3 — Start it and log in (first time only)

1. **Double-click `start-tailscaled.bat`.** A console window opens and stays open
   (that's the running daemon — minimize it, don't close it).
2. Open a **new** Command Prompt (`Win`+`R` → `cmd`). Run:
   ```
   cd %USERPROFILE%\tailscale
   ts up
   ```
3. It prints an **auth URL** like `https://login.tailscale.com/a/xxxxxxxx`.
   - First make sure you're **logged into https://login.tailscale.com** in your
     browser (as `hany.network27@gmail.com`).
   - Then open the auth URL → **approve** this laptop.
4. Back in the cmd window, verify it's connected:
   ```
   ts status
   ```
   You should see `dev-vm` and `dev-vm2` listed. SOCKS5 is now live on
   `127.0.0.1:1055`.

---

## Step 4 (RECOMMENDED) — Use VS Code in the browser via the proxy

This needs nothing but the Edge/Chrome you already have — no admin.

1. Open a Command Prompt and launch a **separate browser window pointed at the
   proxy** (pick the one you have):

   **Edge:**
   ```
   "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" --user-data-dir="%USERPROFILE%\ts-browser" --proxy-server="socks5://127.0.0.1:1055"
   ```
   **Chrome:**
   ```
   "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --user-data-dir="%USERPROFILE%\ts-browser" --proxy-server="socks5://127.0.0.1:1055"
   ```
   (The `--user-data-dir` makes a separate profile so ONLY this window uses the
   proxy — your normal browsing is unaffected.)

2. In that window, go to:
   ```
   http://100.119.47.78:8080      (dev-vm)
   ```
   Password: `DevVM@2026`. Full VS Code in the browser — editor, terminal,
   Claude Code, SQLcl — all running on the VM.

That's it for daily browser-based dev.

---

## Step 5 (OPTIONAL) — Full VS Code DESKTOP via Remote-SSH through the proxy

Only if you want the desktop app instead of the browser. SSH needs a small SOCKS
"connector" helper. Ask me and I'll hand you a no-admin connector (`ncat` or
`connect.exe`) plus the exact `~/.ssh/config` `ProxyCommand` line. Sketch:
```
Host dev-vm-ts
  HostName 100.119.47.78
  User root
  ProxyCommand C:\Users\<you>\tailscale\ncat.exe --proxy 127.0.0.1:1055 --proxy-type socks5 %h %p
```
Then VS Code → Remote-SSH → `dev-vm-ts`.

---

## Daily use (after first-time setup)

1. Double-click **`start-tailscaled.bat`** (leave the window open).
2. Launch the **proxied browser** (Step 4 command) → open the code-server URL.
3. When done, **close the `start-tailscaled.bat` window** to disconnect.

(No need to run `ts up` again — it stays logged in. Just start the daemon.)

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `ts status` says "failed to connect" to daemon | Make sure the `start-tailscaled.bat` window is still open; both scripts must use the same `-socket` pipe name |
| Auth URL shows "logged out" | Log into https://login.tailscale.com FIRST, then open the auth URL |
| Browser can't load `:8080` | Confirm `ts status` lists the VM; confirm you launched the browser with the `--proxy-server` flag |
| Port 1055 in use | Change `1055` to e.g. `1080` in BOTH the proxy flag and `start-tailscaled.bat` |
| `.exe` won't run / blocked | Corporate AppLocker may block exes in your profile — tell me the error |
| Tailscale won't connect at all on office WiFi | Corporate firewall may block it; try a phone hotspot to confirm, then ask IT to allow `*.tailscale.com` / UDP 41641 |

---

*Userspace mode = no admin, but the daemon only runs while `start-tailscaled.bat`
is open. It stays private inside your Tailscale network — nothing is exposed
publicly.*
