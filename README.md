# kdbx-crack

Bash script to brute-force KeePass `.kdbx` databases using `keepassxc-cli`. Designed for newer KDBX 4.x databases that can't be cracked with hashcat (unsupported hash format).

This tool is slow by design — it shells out to `keepassxc-cli` for each attempt. Best used with small, targeted wordlists. Expect a few minutes per 1,000 passwords.

## Install KeePassXC CLI (Kali / Flatpak)

KeePassXC isn't in the default Kali repos, but Flatpak works:

```bash
# Install Flatpak if not already installed
sudo apt install flatpak -y

# Add Flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install KeePassXC
flatpak install flathub org.keepassxc.KeePassXC -y
```

Verify the CLI is accessible:

```bash
flatpak run --command=keepassxc-cli org.keepassxc.KeePassXC --version
```

## Usage

```bash
chmod +x kbdx-crack.sh
./kbdx-crack.sh <database.kdbx> <wordlist.txt>
```

### Example

```bash
./kbdx-crack.sh targets/vault.kdbx /usr/share/wordlists/custom.txt
```

### Output

```
[*] Target: targets/vault.kdbx
[*] Wordlist: /usr/share/wordlists/custom.txt (500 entries)
[*] Starting brute-force...

[+] PASSWORD FOUND after 137 attempts!
[+] Password: Summer2025!

[*] Database contents:
Recycle Bin/
Root/
```

## Notes

- **Speed:** ~1,000 passwords in a few minutes depending on hardware and database key derivation settings.
- **Use case:** Targeted wordlists (mangled names, keyboard walks, org-specific patterns). Not for rockyou-sized lists.
- **Why not hashcat?** KDBX 4.x with Argon2id is not supported by hashcat/john in many cases. This script bypasses that by using the official KeePassXC CLI directly.
