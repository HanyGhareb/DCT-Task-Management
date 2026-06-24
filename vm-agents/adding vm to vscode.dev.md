# Adding a VM to vscode.dev (VS Code Remote Tunnels)

Reusable runbook for giving any Linux VM **no-admin, browser-only** VS Code access
via `code tunnel`. Nothing is installed on the client laptop — you connect from
**vscode.dev** in any browser with a GitHub (or Microsoft) login. The tunnel agent
runs on the VM; the connection is private (account-gated) and relayed through
Microsoft, so it passes most corporate firewalls.

---

## When to use this
- The client machine is locked down / no admin (can't install VS Code, Tailscale, etc.).
- You have **root on the Linux VM** and the VM has outbound internet.
- You want full VS Code (editor + terminal + extensions) running on the VM.

## Currently live (this environment)
| VM | LAN IP | Tunnel name | Browser link | Tunnel account |
|---|---|---|---|---|
| dev-vm  | 192.168.1.191 | `dev-vm`  | https://vscode.dev/tunnel/dev-vm  | owner GitHub |
| dev-vm2 | 192.168.1.192 | `dev-vm2` | https://vscode.dev/tunnel/dev-vm2 | owner GitHub (hand to developer — see last section) |

---

## A. Set up a tunnel on a VM (run as root on the VM)

1. **Install the VS Code CLI** (single static binary — NOT full VS Code):
   ```bash
   cd /opt
   curl -Lsk 'https://update.code.visualstudio.com/latest/cli-linux-x64/stable' -o vscode_cli.tar.gz
   tar -xf vscode_cli.tar.gz
   install -m755 code /usr/local/bin/code
   code --version
   ```
   > Gotcha: use the `update.code.visualstudio.com/latest/cli-linux-x64/stable`
   > URL. The `code.visualstudio.com/sha/download?...os=cli-linux-x64` form 404s.

2. **Authenticate (one-time GitHub device-code flow):**
   ```bash
   code tunnel user login --provider github
   ```
   It prints `https://github.com/login/device` + a code. Open that link in ANY
   browser (any device), sign in to GitHub, enter the code, authorize.

3. **Install as a persistent background service + survive reboot/disconnect:**
   ```bash
   code tunnel service install --accept-server-license-terms --name <vm-name>
   loginctl enable-linger root
   ```

4. **Verify (give it ~10s to connect):**
   ```bash
   code --cli-data-dir /root/.vscode/cli tunnel status      # expect "tunnel":"Connected"
   XDG_RUNTIME_DIR=/run/user/0 systemctl --user is-active code-tunnel   # expect: active
   ```

## B. Connect from the client (no install, no admin)
1. Open any browser → **https://vscode.dev/tunnel/<vm-name>**
2. Sign in with the **same account** that authorized the tunnel.
3. Full VS Code, connected to the VM. Terminal (`` Ctrl+` ``) runs on the VM.

## C. Maintenance (on the VM, as root)
| Action | Command |
|---|---|
| Tunnel status | `code --cli-data-dir /root/.vscode/cli tunnel status` |
| Service state | `XDG_RUNTIME_DIR=/run/user/0 systemctl --user status code-tunnel` |
| Live logs | `code tunnel service log` |
| Stop / remove | `code tunnel service uninstall` then `code tunnel unregister` |

---

## D. Hand a VM's tunnel to ANOTHER person (different GitHub account)

A tunnel is openable only by the **one account** that owns it — you can't forward
the link. To give a VM to someone else, re-authorize its tunnel to **their** GitHub
account. They only need a free GitHub account (no repo).

> Do it through a STABLE shell, not through the VM's own tunnel — switching the
> account restarts that tunnel and would drop your session. Go in via another VM's
> tunnel and SSH across the LAN, or run it from a direct SSH session.

Example — hand `dev-vm2` to a developer, driven from `dev-vm`'s tunnel:
1. Open `https://vscode.dev/tunnel/dev-vm` (your account) → **Terminal → New Terminal**.
2. Hop to the target over the LAN (stable session):
   ```bash
   ssh -o StrictHostKeyChecking=accept-new root@192.168.1.192   # password: Dct@2026
   ```
3. Remove the tunnel from your account:
   ```bash
   code tunnel service uninstall
   code tunnel unregister
   ```
4. Log in as the new owner:
   ```bash
   code tunnel user login --provider github
   ```
   → the new person opens the printed `github.com/login/device` link, signs into
   THEIR GitHub, enters the code, authorizes.
5. Recreate the persistent tunnel under their account:
   ```bash
   code tunnel service install --accept-server-license-terms --name dev-vm2
   loginctl enable-linger root
   code --cli-data-dir /root/.vscode/cli tunnel status
   ```
6. The new person opens `https://vscode.dev/tunnel/dev-vm2`, signs in with THEIR
   GitHub → done. Only their account can open it now.

Notes:
- After handover you still reach the VM via SSH / Tailscale / code-server.
- Optional: delete the old offline tunnel entry from your VS Code account's Tunnels list.

---

## Fallback if vscode.dev / the tunnel relay is blocked
Rare on corporate networks (it's Microsoft traffic), but if blocked, use
**Cloudflare Tunnel + code-server** (also browser-only / no-admin), optionally with
Cloudflare Access email-OTP gating.

---
*Reusable runbook — applies to any Linux VM with root + outbound internet.*
