#!/usr/bin/env bash

# ── Constants ─────────────────────────────────────────────────────────────────
BOT_DIR="/root/srtunnel"
REPO="https://raw.githubusercontent.com/kunshakolime/srtunnel/main/"


# ── Helpers ───────────────────────────────────────────────────────────────────
die()        { echo "Error: $*" >&2; exit 1; }
fetch()      { local src="$1" dst="$2"; [[ "$src" == http* ]] || src="${REPO}$src"; curl -fsSL "$src" -o "$dst" || echo "WARNING: failed to fetch $src"; }
fetchx()     { fetch "$1" "$2" && chmod +x "$2"; }
sshd_ensure(){ grep -qF "$1" /etc/ssh/sshd_config || echo "$1" >> /etc/ssh/sshd_config; }

# ── Distro Check ──────────────────────────────────────────────────────────────
[ -f /etc/os-release ] || die "Cannot detect Linux distro."
source /etc/os-release
case "$ID" in debian|ubuntu) ;; *) die "Distro $ID not supported." ;; esac

mkdir -p "$BOT_DIR" && cd "$BOT_DIR"


# ── APT Dependencies ──────────────────────────────────────────────────────────
echo "Installing base dependencies..."
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash
apt update -qq && apt install -y -qq python3 python3-venv tmux gettext-base python3-psutil curl

# ── Binaries ──────────────────────────────────────────────────────────────────

fetchx "websocket" websocket


# ── Python Venv ───────────────────────────────────────────────────────────────
echo "Setting up Python venv..."
[ -d venv ] || python3 -m venv venv
source venv/bin/activate
pip install -q --upgrade pip && pip install -q python-telegram-bot ruamel.yaml psutil PyYAML certbot
# ── Done ──────────────────────────────────────────────────────────────────────
