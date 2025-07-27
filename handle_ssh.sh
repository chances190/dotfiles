#!/usr/bin/env bash
set -euo pipefail

encrypt_ssh() {
    local src="./dotfiles/ssh/.ssh"
    local dest="./dotfiles/ssh/.ssh-encrypted"
    read -s -p "Enter SSH encryption passphrase: " ENC_PASS
    echo
    mkdir -p "$dest"
    for file in "$src"/*; do
        if [[ -f "$file" ]]; then
            out="$dest/$(basename "$file").enc"
            openssl aes-256-cbc -salt -pbkdf2 \
                -in "$file" -out "$out" -pass "pass:$ENC_PASS"
            echo "Encrypted $file -> $out"
        fi
    done
}

decrypt_ssh() {
    local src="./dotfiles/ssh/.ssh-encrypted"
    local dest="./dotfiles/ssh/.ssh"
    read -s -p "Enter SSH decryption passphrase: " DEC_PASS
    echo
    mkdir -p "$dest"
    echo "Decrypting SSH files..."
    for f in "$src"/*.enc; do
        if [[ -f "$f" ]]; then
            out="$dest/$(basename "$f" .enc)"
            openssl aes-256-cbc -d -pbkdf2 \
                -in "$f" -out "$out" -pass "pass:$DEC_PASS"
            chmod 600 "$out"
            echo "Decrypted $f -> $out"
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        encrypt) encrypt_ssh ;;
        decrypt) decrypt_ssh ;;
        *) echo "Usage: $0 {encrypt|decrypt}" ;;
    esac
fi