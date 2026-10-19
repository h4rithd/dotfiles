#!/bin/sh
# tmux status-bar helpers (macOS). Usage: status.sh cpu|mem|disk|bat
case "$1" in
  cpu)  # total CPU use across all cores
    ps -A -o %cpu | awk -v n="$(sysctl -n hw.ncpu)" 'NR>1{s+=$1} END{printf "%-9s", sprintf("%d%%", s/n)}' ;;
  mem)  # used (app + wired + compressed) / total, like Activity Monitor
    vm_stat | awk -v t="$(sysctl -n hw.memsize)" '
      /page size of/{ps=$8} /^Anonymous pages/{a=$3} /^Pages wired down/{w=$4} /occupied by compressor/{c=$5}
      END{printf "%-9s", sprintf("%.1f/%dG", (a+w+c)*ps/1073741824, t/1073741824)}' ;;
  disk) # free space on the data volume
    df -h /System/Volumes/Data 2>/dev/null | awk 'NR==2{sub(/i$/,"",$4); print $4}' ;;
  bat)  # battery %, with a bolt while on charger; prints nothing on desktops
    b=$(pmset -g batt 2>/dev/null)
    p=$(printf '%s' "$b" | grep -Eo '[0-9]+%' | head -1)
    [ -z "$p" ] && exit 0
    if printf '%s' "$b" | grep -qi 'discharging'; then printf '%s' "$p"; else printf '⚡%s' "$p"; fi ;;
  ip)   # LAN address (en0)
    i=$(ipconfig getifaddr en0 2>/dev/null); [ -n "$i" ] && printf '📡 %s' "$i" ;;
  vpn)  # first tunnel (utun) address
    ifconfig 2>/dev/null | awk '/^utun[0-9]/{d=$1} /inet /&&d{printf "🔐 %s", $2; d=""; exit}' ;;
esac
