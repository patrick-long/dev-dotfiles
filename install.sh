#!/bin/sh
# Links this repo's config folders to where Wezterm and Neovim look for them (macOS/Linux)
# Safe to re-run: existing links are skipped and real folders are backed up to *.bak

repo="$(cd "$(dirname "$0")" && pwd)"

backup() {
  if [ -e "$1.bak" ]; then
    echo "Stopped: $1.bak already exists" >&2
    exit 1
  fi

  mv "$1" "$1.bak"
  echo "Backed up $1 to $1.bak"
}

link() {
  if [ -L "$1" ]; then
    echo "Already linked: $1"
    return
  fi

  if [ -e "$1" ]; then
    backup "$1"
  fi

  mkdir -p "$(dirname "$1")"
  ln -s "$2" "$1"
  echo "Linked $1 -> $2"
}

link "$HOME/.config/nvim" "$repo/nvim"
link "$HOME/.config/wezterm" "$repo/wezterm"

if [ -e "$HOME/.wezterm.lua" ]; then
  backup "$HOME/.wezterm.lua"
fi

