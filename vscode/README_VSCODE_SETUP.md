# VS Code Setup

This folder contains my personal VS Code configuration, extensions list and installation scripts.

## Contents

- `my_vscode_settings.json` — VS Code settings
- `extensions.txt` — list of installed extensions
- `install-vscode-extensions.ps1` — Windows extension installer
- `install-vscode-extensions.sh` — Mac/Linux extension installer

---

# Setup on a new machine

## 1. Install VS Code

Download:

- https://code.visualstudio.com/

---

# Windows Setup

## 1. Copy settings

Replace:

```text
%APPDATA%\Code\User\settings.json
```

with:

```text
my_vscode_settings.json
```

---

## 2. Install extensions

Open PowerShell in repo root:

```powershell
.\vscode\install-vscode-extensions.ps1
```

---

# Mac / Linux Setup

## 1. Copy settings

Replace:

```text
~/Library/Application Support/Code/User/settings.json
```

(Mac)

or:

```text
~/.config/Code/User/settings.json
```

(Linux)

with:

```text
my_vscode_settings.json
```

---

## 2. Install extensions

Make script executable:

```bash
chmod +x ./vscode/install-vscode-extensions.sh
```

Run:

```bash
./vscode/install-vscode-extensions.sh
```

---

# Update extensions list

After installing new extensions manually:

```powershell
code --list-extensions > vscode/extensions.txt
```

---

# Recommended

Install:

- Git
- Node.js
- .NET SDK
- PowerShell 7
