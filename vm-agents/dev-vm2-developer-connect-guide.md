# dev-vm2 — How to Connect (for Developer)

You've been given remote access to a development VM called **dev-vm2**. It has
everything pre-installed (Node.js, Python, Git, VS Code server, SQLcl, etc.).
You can reach it from anywhere in the world over a secure private tunnel
(Tailscale) — no VPN config, no port forwarding.

---

## What you'll receive
- A **Tailscale share link** (sent to you separately)
- Login: user **`root`**, password **`Dct@2026`**
- The VM's address: **`100.105.123.46`**

---

## Step 1 — Get on the secure network (Tailscale)

1. Create a free Tailscale account (or use an existing one): https://tailscale.com
   *(Use your own account — you only get access to dev-vm2, nothing else.)*
2. **Open the share link** you were sent → click **Accept**.
   `dev-vm2` now appears in your Tailscale.
3. **Install the Tailscale app** on your laptop: https://tailscale.com/download
   (Windows installer needs no admin rights.)
4. Sign in with **your** Tailscale account and make sure Tailscale is **ON**
   (toggle/connected).

> ⏰ Accept the share link soon after you receive it — unused invite links can expire.
> If it does, just ask for a fresh one.

---

## Step 2 — Install VS Code + Remote-SSH

1. Install VS Code — download the **Windows "User Installer" (x64)**
   (no admin rights needed): https://code.visualstudio.com/download
2. Open VS Code → Extensions (`Ctrl+Shift+X`) → search **`Remote - SSH`**
   (by Microsoft) → **Install**.

---

## Step 3 — Connect to dev-vm2

1. Press `F1` (or `Ctrl+Shift+P`) → **`Remote-SSH: Connect to Host…`**
2. Click **`+ Add New SSH Host…`** → type exactly:
   ```
   ssh root@100.105.123.46
   ```
   → Enter.
3. Save to the suggested SSH config file (first option).
4. `F1` → **`Remote-SSH: Connect to Host…`** again → pick **`100.105.123.46`**.
5. Platform → **Linux**; fingerprint prompt → **Continue**.
6. Password (top box) → `Dct@2026` → Enter.
7. Wait ~20–30s (one-time server install). When the **bottom-left green corner**
   shows `SSH: 100.105.123.46`, you're connected.
8. **File → Open Folder** → choose your working folder on the VM.
   The terminal (`` Ctrl+` ``) runs **on the VM** — `node`, `python3`, `git`, etc.

---

## Optional — stop typing the password every time (SSH key)

1. On your laptop (PowerShell), generate a key once:
   ```powershell
   ssh-keygen -t ed25519 -C "my-laptop"
   ```
   Press Enter through the prompts.
2. Show your public key:
   ```powershell
   type $env:USERPROFILE\.ssh\id_ed25519.pub
   ```
   Copy the whole `ssh-ed25519 …` line.
3. In a VM terminal (inside your connected VS Code), run (paste your key in place):
   ```bash
   mkdir -p ~/.ssh && chmod 700 ~/.ssh
   echo 'PASTE_YOUR_PUBLIC_KEY_LINE_HERE' >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```
4. Reconnect — no more password prompts.

---

## Browser alternative (no install)

You can also use VS Code in a browser — no VS Code install needed:
- Go to **`http://100.105.123.46:8080`**
- Password: `DevVM@2026`

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Can't reach `100.105.123.46` | Make sure the Tailscale app is **ON** and you accepted the share link |
| Host not listed in VS Code | `F1` → `Remote-SSH: Open SSH Configuration File` → confirm the `Host` block is there |
| Asked for password twice | Normal before you set up an SSH key — set one up (above) to stop it |

---

*Access is provided via Tailscale node sharing and can be revoked by the owner at any time.*
