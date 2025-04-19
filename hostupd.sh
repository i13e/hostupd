#!/bin/sh
set -euo pipefail

# Defaults
hosts_url="http://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
custom_hosts="${XDG_CONFIG_HOME:-$HOME/.config}/hosts"
system_hosts="/etc/hosts"
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
    -u|--url)
      hosts_url="$2"; shift 2;;
    -c|--custom)
      custom_hosts="$2"; shift 2;;
    -o|--output)
      system_hosts="$2"; shift 2;;
    -d|--dry-run)
      dry_run=true; shift;;
    -h|--help)
      print_help; exit 0;;
    *)
      echo "Unknown option: $1" >&2
      print_help; exit 1;;
  esac
done

# Fetch logic
fetch() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    echo "Error: neither curl nor wget is available." >&2
    exit 1
  fi
}

tmpfile="$(mktemp)"

echo "[INFO] Downloading base hosts from: $hosts_url"
echo "[INFO] Custom hosts file: $custom_hosts"
echo "[INFO] Target hosts file: $system_hosts"
$dry_run && echo "[INFO] Dry run mode enabled. No changes will be written."

fetch "$hosts_url" "$tmpfile"
[ -f "$custom_hosts" ] && cat "$custom_hosts" >>"$tmpfile"

if [ "$dry_run" = false ]; then
  sudo cp "$tmpfile" "$system_hosts"
  sudo chmod 644 "$system_hosts"
  echo "[INFO] Hosts file updated successfully."
else
  echo "[DRY RUN] Would copy merged hosts file to $system_hosts"
fi

rm "$tmpfile"
