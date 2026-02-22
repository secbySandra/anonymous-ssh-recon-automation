#!/bin/bash
# ==================================================
# Anonymous SSH Recon Automation
# --------------------------------------------------
# Automated remote reconnaissance via SSH
# with Tor (Nipe) anonymity validation.
# Developed for controlled lab environments only.
# ==================================================

set -e

LOG() {
    echo "[+] $1"
}

# --- Function 1: Check Anonymity and Start Nipe if Needed ---
ANON_CHECK() {
    External_IP=$(curl -s ident.me)
    COUNTRY=$(geoiplookup "$External_IP" | awk '{print $5}')

    if [ "$COUNTRY" == "Israel" ]; then
        LOG "Connection not anonymous. Activating Nipe..."

        NIPE_DIR=$(sudo find / -name nipe -type d 2>/dev/null | head -n 1)
        if [ -z "$NIPE_DIR" ]; then
            echo "[!] Nipe directory not found."
            exit 1
        fi

        cd "$NIPE_DIR"
        sudo perl nipe.pl start
        sudo perl nipe.pl restart
        sleep 5

        LOG "Anonymity enabled:"
        sudo perl nipe.pl status
    else
        LOG "Already running through Tor."
    fi
}

# --- Function 2: Remote Recon via SSH ---
REMOTE_RECON() {
    echo "Enter SSH target IP:"
    read TARGET_IP

    echo "Enter SSH username:"
    read TARGET_USER

    echo "Enter SSH password:"
    read -s TARGET_PASS
    echo

    LOG "Starting remote reconnaissance..."

    mkdir -p recon_output
    cd recon_output

    sshpass -p "$TARGET_PASS" ssh -o StrictHostKeyChecking=no \
        "$TARGET_USER@$TARGET_IP" "whois espn.com" > whois_data.txt

    sshpass -p "$TARGET_PASS" ssh -o StrictHostKeyChecking=no \
        "$TARGET_USER@$TARGET_IP" "nmap 8.8.8.8" > nmap_data.txt

    sshpass -p "$TARGET_PASS" ssh -o StrictHostKeyChecking=no \
        "$TARGET_USER@$TARGET_IP" "uptime ; curl -s ident.me ; geoiplookup \$(curl -s ident.me)" \
        > target_details.txt

    LOG "Recon data saved in recon_output directory."
}

# --- Function 3: Matrix Mode ---
MATRIX_MODE() {
    LOG "Mission complete."
    sleep 2

    if command -v cmatrix &>/dev/null; then
        cmatrix
    else
        sudo apt-get install cmatrix -y
        cmatrix
    fi
}

# --- MAIN ---
clear
echo "==== Anonymous SSH Recon Automation ===="
ANON_CHECK
REMOTE_RECON
MATRIX_MODE