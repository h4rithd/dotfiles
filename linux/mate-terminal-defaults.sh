#!/usr/bin/env bash
# mate-terminal profile defaults.
#
# NOTE: this is a hand-written set of sane defaults (dark theme, same Nerd Font
# used on macOS, unlimited scrollback), NOT a byte-for-byte export of a real
# mate-terminal profile — the installer has no way to read a live profile off
# a machine it isn't running on. If you want this to match your actual
# mate-terminal setup exactly, run the following on the Linux box you want to
# capture, then replace the values below with what it prints:
#
#   dconf dump /org/mate/terminal/profiles/Default/
#
# Applied via gsettings against the relocatable "Default" profile, which is
# what a stock MATE desktop ships as the default terminal profile.
set -euo pipefail

PROFILE="org.mate.terminal.profile:/org/mate/terminal/profiles/Default/"

if ! command -v gsettings >/dev/null 2>&1; then
    echo "[!] gsettings not found - skipping mate-terminal profile setup." >&2
    exit 0
fi

if ! gsettings list-schemas 2>/dev/null | grep -q '^org.mate.terminal.profile$'; then
    echo "[!] org.mate.terminal.profile schema not found (mate-terminal not installed?) - skipping." >&2
    exit 0
fi

gsettings set "$PROFILE" visible-name 'h4rithd'
gsettings set "$PROFILE" use-system-font false
gsettings set "$PROFILE" font 'JetBrainsMono Nerd Font Mono 12'
gsettings set "$PROFILE" scrollback-unlimited true
gsettings set "$PROFILE" use-theme-colors false
gsettings set "$PROFILE" background-color '#1A1B26'
gsettings set "$PROFILE" foreground-color '#C0CAF5'
gsettings set "$PROFILE" bold-color-same-as-fg true
gsettings set "$PROFILE" allow-bold true
gsettings set "$PROFILE" audible-bell false
gsettings set "$PROFILE" default-size-columns 120
gsettings set "$PROFILE" default-size-rows 30

echo "[+] mate-terminal 'Default' profile updated with generated defaults."
echo "    Run 'dconf dump /org/mate/terminal/profiles/Default/' later and send it"
echo "    back if you want this replaced with your exact real profile."
