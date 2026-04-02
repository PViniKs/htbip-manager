# 🚀 HTBIP Manager

![Bash](https://img.shields.io/badge/Language-Bash-green.svg)
![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)
![Target](https://img.shields.io/badge/Target-HackTheBox-red.svg)

**HTBIP** is a command-line automation utility for managing the `/etc/hosts` file, specifically designed to streamline the workflow for Pentesters in the Hack The Box (HTB) environment.

## ✨ Why use HTBIP?

During modules like **Web Penetration Tester**, the constant rotation of instances and the need to manually configure vhosts (subdomains) can slow down your enumeration process. HTBIP solves this by providing:

- **Dynamic Domains:** No more hardcoding. Manage your default domains in `~/.config/htbip/domains.conf`.
- **Bulletproof Backup:** The script automatically creates a timestamped backup of your hosts file before any modification.
- **Clean Management:** All entries are isolated between `BEGIN/END` markers, making it easy to clear everything once a lab is finished.
- **Global & Local Scope:** Use global defaults or specify unique domains for a single IP.

## 🛠 Installation

### Debian-based (Parrot, Kali, Ubuntu)
Download the latest `.deb` package from the [Releases](https://github.com/pviniks/htbip-manager/releases) page and run:
```
sudo dpkg -i htbip.deb
```

### Manual Installation
1. Give execution permission to the script:
```
chmod +x htbip
```
2. Move it to your local PATH:
```
sudo mv htbip /usr/local/bin/
```

## 📖 Usage Guide

### 1. Standard Mapping
Map a target IP to all default domains in your config:
`htbip 10.129.202.42`

### 2. Interactive Selection (`-e`, `--choose`)
If you only discovered specific subdomains during fuzzing and don't want to map everything:
`htbip 10.129.202.42 -e`

### 3. Custom URL Mapping (`-u`, `--url`)
Add specific domains for a single IP that are not in your default list:
`htbip 10.129.202.42 -u "custom.target.htb dev.target.htb"`

### 4. Management Commands
- **List Active Hosts (`-l`, `--list`):** View all current mappings within the HTB section.
- **Remove Specific IP (`-r`, `--remove`):** Delete only the entries related to a specific IP address.
- **Clear All (`-c`, `--clear`):** Wipe the entire HTB section from your hosts file.
- **Open Hosts File (`-o`, `--open`):** Quickly open `/etc/hosts` in `nano` with sudo privileges.

### 5. Utilities & Config
- **Connectivity Test (`-p`, `--ping`):** Ping all IPs currently saved in the HTB section to check if they are online.
- **Manual Backup (`-b`, `--backup`):** Create an instant safety copy of your hosts file.
- **Edit Defaults (`--edit-conf`):** Modify your permanent list of default domains.

## 🛡 Security & Best Practices
HTBIP uses `sudo` granularly. It will only prompt for your password when it actually needs to write to `/etc/hosts`. The automatic backup function ensures that you can always restore your original system state if any `sed` operation fails.

## 📄 License
This project is licensed under the **GPL-3.0 License**. Feel free to use, modify, and distribute, as long as the source remains open.

<sub>Copyright © 2026 pviniks<br>This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.</sub>
