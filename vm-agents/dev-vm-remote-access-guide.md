# Dev VM — Remote Access Reference Guide

> Personal dev VM on the home ESXi host. Use it as a remote development box
> (VS Code, Claude Code, SQLcl) reachable from anywhere via Tailscale.

---

## 1. Key Facts

| Item | Value |
|---|---|
| Dev VM hostname | `dev-vm` |
| Dev VM LAN IP (at home) | `192.168.1.191` |
| Dev VM Tailscale IP (anywhere) | `100.119.47.78` |
| User / password | `root` / `Nono@2017` |
| OS | Oracle Linux 9 |
| ESXi host | `192.168.1.190` (root / `Nono@2017`), VMID 55 |
| code-server (VS Code in browser) | `http://192.168.1.191:8080` — password `DevVM@2026` |
| Tailscale account | hany.network27@gmail.com |
| Subnet route advertised | `192.168.1.0/24` (reaches all home VMs .180/.181/.182) |

**Installed on the VM:** Node.js 22, Claude Code CLI, code-server 4.125, SQLcl 26.1
(`prod_mcp` wrapper → Oracle ADB), Python 3.9, Git, Java 17.

---

## 2. Three Ways to Use the VM

| Method | What you install | Best for |
|---|---|---|
| **VS Code Desktop + Remote-SSH** | VS Code (User Installer) on your machine | Day-to-day coding (recommended) |
| **code-server (browser)** | Nothing — just a browser | Quick access from any device |
| **Full Linux desktop** | XFCE + xrdp on VM; Windows Remote Desktop client | GUI apps (not yet installed) |

---

## 3. VS Code Desktop + Remote-SSH Setup

### 3.1 Install VS Code (no admin rights needed)
1. https://code.visualstudio.com/download
2. Download **Windows → "User Installer" (x64)** — installs to your user folder,
   **no admin required**. (Avoid the System Installer — that one needs admin.)
3. Run it, accept defaults.

### 3.2 Add the Remote-SSH extension
1. Open VS Code → Extensions (`Ctrl+Shift+X`)
2. Search **`Remote - SSH`** (Microsoft) → **Install**

### 3.3 Connect
1. `F1` → **`Remote-SSH: Connect to Host…`**
2. **`+ Add New SSH Host…`** → type: `ssh root@192.168.1.191` → Enter
3. Save to config file: pick `C:\Users\<you>\.ssh\config`
4. VS Code opens the config file to confirm it saved — that's normal, close it.
5. `F1` → **`Remote-SSH: Connect to Host…`** → now pick **`192.168.1.191`**
6. Platform → **Linux**; fingerprint prompt → **Continue**
7. Password (top box) → `Nono@2017` → Enter
8. Wait ~20–30s (one-time VS Code server install).
   **Bottom-left green corner shows `SSH: 192.168.1.191` = connected.**
9. **File → Open Folder** → choose the project folder on the VM.
10. Terminal (`` Ctrl+` ``) runs **on the VM** — `claude`, `prod_mcp`, `node`, etc.

> The editor UI runs on your machine; files + terminals + tools run on the VM.

---

## 4. Passwordless Login (SSH Keys)

Stops VS Code from asking for the password every connection.

### The model
- **The VM is the lock.** It keeps one file — `~/.ssh/authorized_keys` —
  listing the public keys of every machine allowed in without a password.
- **Each machine you connect FROM is a key.** Each generates its **own** key pair once.
- **To authorize a machine:** add that machine's **public** key to the VM's
  `authorized_keys`. One line per machine.
- **Best practice:** one separate key per machine (don't copy one key everywhere)
  — lets you revoke a single lost machine while the rest keep working.

### Recipe — repeat for EVERY machine you connect from

**① Generate the machine's own key** (built into Windows PowerShell, Mac, Linux):
```bash
ssh-keygen -t ed25519 -C "describe-this-machine"
```
Press Enter through all prompts (empty passphrase = no prompt on the key itself).

**② Show its public key:**
```powershell
# Windows PowerShell:
type $env:USERPROFILE\.ssh\id_ed25519.pub
```
```bash
# Mac / Linux:
cat ~/.ssh/id_ed25519.pub
```
Copy the whole printed line (starts with `ssh-ed25519 …`).

**③ Authorize it on the VM** — paste into a VM terminal (swap in that machine's key):
```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo 'PASTE_THE_PUBLIC_KEY_LINE_HERE' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```
A VM terminal = open it inside a connected VS Code window (`` Ctrl+` ``), or SSH in.

That machine now logs in passwordless. Reconnect to confirm — no password prompt.

> **Shortcut once your main laptop is passwordless:** you no longer need the VM
> terminal for new machines — from the trusted laptop you can append any new
> machine's public key to the VM's `authorized_keys` directly over SSH.

### Revoke a machine (lost / sold)
Edit `~/.ssh/authorized_keys` on the VM and delete that machine's line.
The `-C "..."` comment at the end of each line is how you tell them apart —
**name each one clearly** (`work-laptop`, `home-pc`, `phone`).

---

## 5. Remote Access From Outside Home (Tailscale)

The VM runs Tailscale as a **subnet router**, so from anywhere you reach not only
the dev VM but every home VM (`192.168.1.0/24`).

### On each remote device you connect from:
1. Install Tailscale:
   - Windows: https://tailscale.com/download/windows (2-click, no admin)
   - Phone: Tailscale app (Play Store / App Store)
2. Log in as **hany.network27@gmail.com**.
3. Make sure subnet routes are accepted (on by default).

### Then connect using the Tailscale IP instead of the LAN IP:
- SSH / VS Code host: **`100.119.47.78`** (instead of `192.168.1.191`)
- Reach home VMs: `192.168.1.180`, `.181`, `.182` work over the tunnel.

> Tip: add a second VS Code host `dev-vm-tailscale` → `100.119.47.78` so you have
> one entry for home (`.191`) and one for away (`100.119.47.78`).

---

## 6. Full Linux Desktop (optional — not yet installed)

If you ever need GUI apps on the VM:
- **On the VM:** install XFCE + xrdp (lightweight; dormant when nobody's connected,
  so negligible performance cost).
- **On Windows:** connect with the built-in **Remote Desktop** (`mstsc.exe`) to
  `192.168.1.191` — no install, no admin.

Until then, code-server (browser) + Remote-SSH cover all coding needs.

---

## 7. Troubleshooting

| Symptom | Fix |
|---|---|
| Host not listed after Connect to Host | `F1` → `Remote-SSH: Open SSH Configuration File` → confirm it's `C:\Users\<you>\.ssh\config`; the `Host` block must be there |
| Asked for password twice | Normal before keys are set — Remote-SSH opens a 2nd connection. Set up SSH keys (§4) to stop it |
| Connection drops right after connecting | `Ctrl+Shift+U` → pick **Remote - SSH** in the dropdown → read the last lines for the error |
| Still prompts for password after adding key | Key line may be malformed or perms wrong — on VM run `chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys` |
| Can't reach VM from outside | Confirm Tailscale is running on both ends (`tailscale status`) and you used `100.119.47.78` |

---

---

## 8. dev-vm2 — Second Dev VM (for another developer)

A clone of dev-vm with all the same tools, for a second developer. Built by
cloning dev-vm's disk on ESXi, then re-stamping a fresh identity.

| Item | Value |
|---|---|
| Hostname | `dev-vm2` |
| LAN IP (at home) | `192.168.1.192` |
| Tailscale IP (anywhere) | `100.105.123.46` |
| User / password | `root` / `Dct@2026` |
| ESXi VMID | 56 (datastore1, `dev-vm2/`) |
| code-server | `http://192.168.1.192:8080` — password `DevVM@2026` |
| Tools | Same as dev-vm (Node 22, Claude Code, code-server, SQLcl + `prod_mcp`, Python, Git, Java 17, Oracle wallet) |

### What was re-stamped on the clone (so it's NOT a duplicate)
- hostname → `dev-vm2`; static IP → `192.168.1.192`
- new MAC + BIOS UUID (ESXi `uuid.action="create"`)
- regenerated SSH **host** keys and `machine-id`
- **fresh Tailscale node** — old state wiped, re-registered as its own node
  (`100.105.123.46`); it is NOT a subnet router (plain node).

### How the other developer reaches dev-vm2 (private — shared node model)
dev-vm2 is **shared** from your Tailscale account to the developer's own account,
so they get dev-vm2 only and never see dev-vm or your home VMs.

- **Share it (you, once):** [login.tailscale.com/admin/machines](https://login.tailscale.com/admin/machines)
  → `dev-vm2` row → `⋯` → **Share…** → copy link → send to developer.
- **Developer connects:** installs Tailscale, accepts the share link into their
  account, then VS Code Remote-SSH to `100.105.123.46` (anywhere) or
  `192.168.1.192` (on the home LAN). User `root` / `Nono@2017`.
- The developer should set up their own SSH key on dev-vm2 (§4 recipe) and may
  change the `root` password / code-server password for their own use.

### Cloning another dev VM later (repeat recipe)
1. ESXi: power off the source VM; `vmkfstools -i source.vmdk newvm/newvm.vmdk -d thin`
2. Write a new `.vmx` (new `displayName`, `scsi0:0.fileName`, `uuid.action="create"`);
   `vim-cmd solo/registervm <path>.vmx`
3. Boot the clone **alone** (source off to avoid IP clash); re-stamp:
   hostname, IP, `ssh-keygen -A` (after `rm /etc/ssh/ssh_host_*`),
   `systemd-machine-id-setup` (after `rm /etc/machine-id`); reboot.
4. Wipe Tailscale: stop `tailscaled`, `rm /var/lib/tailscale/tailscaled.state` +
   `profile-data/`; `tailscale up` → approve → share.

---

*Last updated: 2026-06-23 — added dev-vm2*
