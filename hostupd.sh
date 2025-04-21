#!/bin/sh
set -euo pipefail

log() {
  level="$1"
  shift
  case "$level" in
  INFO) printf "\033[1;32m[INFO]\033[0m %s\n" "$*" ;;
  WARN) printf "\033[1;33m[WARN]\033[0m %s\n" "$*" ;;
  ERROR) printf "\033[1;31m[ERROR]\033[0m %s\n" "$*" >&2 ;;
  *) printf "[%s] %s\n" "$level" "$*" ;;
  esac
}

# Defaults (can be overridden by env)
hosts_url="${HOSTS_URL:-http://raw.githubusercontent.com/StevenBlack/hosts/master/hosts}"
custom_hosts="${CUSTOM_HOSTS:-${XDG_CONFIG_HOME:-$HOME/.config}/hosts}"
system_hosts="${SYSTEM_HOSTS:-/etc/hosts}"
dry_run=false

print_help() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -u, --url URL         URL to fetch base hosts file (default: StevenBlack)
  -c, --custom PATH     Path to custom hosts file (default: \$XDG_CONFIG_HOME/hosts)
  -o, --output PATH     Output system hosts file path (default: /etc/hosts)
  -d, --dry-run         Show planned actions without making changes
  -h, --help            Show this help message
EOF
}

# Parse args
while [ $# -gt 0 ]; do
  case "$1" in
  -u | --url) hosts_url="$2" && shift 2 ;;
  -c | --custom) custom_hosts="$2" && shift 2 ;;
  -o | --output) system_hosts="$2" && shift 2 ;;
  -d | --dry-run) dry_run=true && shift ;;
  -h | --help) print_help && exit 0 ;;
  *) log ERROR "Unknown option: $1" && print_help && exit 1 ;;
  esac
done

# Fetch logic
fetch() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    log ERROR "Neither curl nor wget is available."
    exit 1
  fi
}

log INFO "Base hosts URL: $hosts_url"
log INFO "Custom hosts file: $custom_hosts"
log INFO "Output will go to: $system_hosts"
$dry_run && log INFO "Dry run mode enabled. No changes will be made."

tmpfile="$(mktemp)"
fetch "$hosts_url" "$tmpfile"
[ -f "$custom_hosts" ] && cat "$custom_hosts" >>"$tmpfile"

if [ "$dry_run" = false ]; then
  sudo cp "$tmpfile" "$system_hosts"
  sudo chmod 644 "$system_hosts"
  log INFO "Hosts file updated successfully."
else
  log INFO "Dry run complete. Would copy merged file to $system_hosts"
fi

rm "$tmpfile"
