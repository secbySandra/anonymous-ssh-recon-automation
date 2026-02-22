# Anonymous SSH Recon Automation

## Overview

This project demonstrates automated remote reconnaissance over SSH while maintaining Tor-based anonymity using Nipe.

The script validates whether the local system is routed through Tor, enables anonymity if required, and then connects to a remote Linux host via SSH to execute predefined reconnaissance commands.

All collected data is stored locally in a structured output directory.

This project was developed and tested in a controlled lab environment for educational purposes only.

---

## Features

- Tor-based anonymity validation (Nipe integration)
- Automatic external IP verification
- SSH-based remote command execution
- Automated collection of:
  - Whois information
  - Nmap scan results
  - Remote system uptime
  - Public IP & GeoIP details
- Structured local output directory
- Matrix-style completion mode

---

## Tools Used

- Bash
- SSH / sshpass
- Nipe (Tor routing)
- Whois
- Nmap
- GeoIPLookup
- Cmatrix

---

## Workflow

1. Check if connection is anonymous
2. Start Nipe (Tor) if required
3. Connect to remote SSH target
4. Execute reconnaissance commands
5. Save results in `recon_output/`
6. Display completion screen

---

## How to Run

```bash
chmod +x anonymous_ssh_recon.sh
sudo ./anonymous_ssh_recon.sh
