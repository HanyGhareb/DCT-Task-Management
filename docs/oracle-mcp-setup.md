# Oracle ATP — Claude Code MCP Setup Guide

Connect Claude Code to Oracle Autonomous Transaction Processing (ATP) via SQLcl MCP Server,
so Claude can query your database directly within a session.

---

## What Was Configured

| Component | Location |
|---|---|
| SQLcl | `C:\claude\tools\sqlcl\sqlcl\bin\sql.exe` |
| ATP Wallet | `C:\claude\wallet\Wallet_prod.zip` |
| Saved DB connection | SQLcl internal store (name: `prod_mcp`) |
| MCP wrapper script | `C:\claude\tools\oracle-mcp.bat` |
| MCP registration | `C:\Users\<you>\.claude.json` (via `claude mcp add`) |

---

## How It Works

```
Claude Code  →  oracle-db MCP  →  oracle-mcp.bat  →  sql.exe -name prod_mcp -mcp  →  ATP
```

SQLcl starts in MCP mode (`-mcp`) using a saved connection (`-name prod_mcp`) that
already has the wallet and password stored — so no prompt is needed at runtime.

---

## Setup Steps (This PC)

### Prerequisites
- Java 17+ installed (`java -version`)
- Oracle ATP wallet zip downloaded from OCI Console

### Step 1 — Install SQLcl
1. Download SQLcl from oracle.com/sqldeveloper/technologies/sqlcl
2. Extract to `C:\claude\tools\sqlcl\`
3. Add `C:\claude\tools\sqlcl\sqlcl\bin` to user PATH:
   ```powershell
   [System.Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\claude\tools\sqlcl\sqlcl\bin", [System.EnvironmentVariableTarget]::User)
   ```
4. Reopen PowerShell and verify: `sql -version`

### Step 2 — Save the DB Connection
Open PowerShell and connect using the wallet:
```powershell
sql -cloudconfig C:\claude\wallet\Wallet_prod.zip ADMIN@prod_high
```
At the `SQL>` prompt, save the connection with password:
```sql
conn -save prod_mcp -savepwd ADMIN@prod_high
exit
```
Test saved connection (no password prompt):
```powershell
sql -name prod_mcp
```

### Step 3 — Create MCP Wrapper Script
Create `C:\claude\tools\oracle-mcp.bat`:
```bat
@echo off
"C:\claude\tools\sqlcl\sqlcl\bin\sql.exe" -name prod_mcp -mcp
```

### Step 4 — Register with Claude Code
```powershell
claude mcp add -s user oracle-db "C:\claude\tools\oracle-mcp.bat"
```
Verify: `claude mcp list` → should show `oracle-db ✓ Connected`

### Step 5 — Use It
Start a new Claude Code session. The `oracle-db` MCP tool is now available.
Ask Claude: *"List all tables in the ADMIN schema"* to test.

---

## Setup Steps (New / Another PC)

### Prerequisites
- Java 17+ installed
- Oracle ATP wallet zip (copy `Wallet_prod.zip` from this PC or re-download from OCI)
- Claude Code CLI installed (`npm install -g @anthropic-ai/claude-code` or via installer)

### Step 1 — Install SQLcl
Same as above. Choose any install path (e.g. `C:\tools\sqlcl\`).
Update the PATH to point to your chosen `bin` folder.

### Step 2 — Copy the Wallet
Copy `Wallet_prod.zip` to the new PC (e.g. `C:\claude\wallet\Wallet_prod.zip`).
The wallet is the same file — no need to re-download if you have it.

### Step 3 — Save the DB Connection
```powershell
sql -cloudconfig C:\claude\wallet\Wallet_prod.zip ADMIN@prod_high
```
```sql
conn -save prod_mcp -savepwd ADMIN@prod_high
exit
```
> The saved connection is stored locally per machine — you must repeat this on each PC.

### Step 4 — Create MCP Wrapper Script
Create `C:\claude\tools\oracle-mcp.bat` (adjust path if SQLcl is installed elsewhere):
```bat
@echo off
"C:\tools\sqlcl\bin\sql.exe" -name prod_mcp -mcp
```
> Update the path inside the `.bat` to match where SQLcl is installed on the new PC.

### Step 5 — Register with Claude Code
```powershell
claude mcp add -s user oracle-db "C:\claude\tools\oracle-mcp.bat"
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `sql` not found | Add SQLcl `bin` folder to PATH, reopen terminal |
| Password prompted at startup | Re-run `conn -save prod_mcp -savepwd ...` |
| `claude mcp list` shows not connected | Check the `.bat` path is correct; run the `.bat` manually to test |
| `unknown option '-name'` error | Use the `.bat` wrapper — do not pass `-name` directly to `claude mcp add` |
| MCP not available in session | Start a **new** Claude Code session after registering |

---

## Key Files Summary

| File | Purpose |
|---|---|
| `C:\claude\wallet\Wallet_prod.zip` | mTLS wallet for ATP connection |
| `C:\claude\tools\sqlcl\sqlcl\bin\sql.exe` | SQLcl executable |
| `C:\claude\tools\oracle-mcp.bat` | Wrapper that launches SQLcl in MCP mode |
| `C:\Users\<you>\.claude.json` | Claude Code config (MCP registration stored here) |
