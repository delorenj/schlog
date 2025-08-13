#!/usr/bin/env bash

set -euo pipefail

replay() {
  local base="$1"; shift || true
  local speed_args=() target= maxdelay=
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -d) speed_args+=("-d" "$2"); shift 2 ;;
      --maxdelay|-m) maxdelay="$2"; shift 2 ;;
      --target) target="$2"; shift 2 ;;
      *) speed_args+=("$1"); shift ;;
    esac
  done
  [[ -z "${base:-}" ]] && { echo "usage: replay <basename> [-d N] [--maxdelay SEC] [--target SEC]"; return 2; }

  local timing="${base%.timing}.timing"
  local log="${base%.log}.log"
  [[ -f "$timing" && -f "$log" ]] || { echo "missing files: $timing or $log"; return 1; }

  # total seconds (for --target)
  local total; total="$(awk '{s+=$1} END{print int(s+0.5)}' "$timing")"; (( total<=0 )) && total=1
  if [[ -n "${target:-}" && "$target" -gt 0 ]]; then
    local d=$(( total / target )); (( d<1 )) && d=1
    speed_args=( "-d" "$d" )
    [[ -z "${maxdelay:-}" ]] && maxdelay="0.12"
  fi

  local cmd=( /usr/bin/scriptreplay )
  if [[ ${#speed_args[@]} -gt 0 ]]; then cmd+=( "${speed_args[@]}" ); fi
  if [[ -n "${maxdelay:-}" ]]; then cmd+=( --maxdelay "$maxdelay" ); fi
  cmd+=( -t "$timing" "$log" )

  # save/restore without clearing screen
  local saved; saved=$(stty -g 2>/dev/null || true)
  _restore() {
    stty "$saved" 2>/dev/null || true
    # re-enable line wrap and make cursor visible (no full reset)
    printf '\e[?7h\e[?25h'
    trap - INT EXIT
  }
  trap _restore INT EXIT

  echo "Replaying: $log"
  echo "Tips: Ctrl+C to stop early; you’ll stay on this screen."

  "${cmd[@]}"

  _restore
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    echo -n "Done. Press any key to return..."
    # zsh: read -k
    read -k 1 -s
    echo
  else
    # bash: read -n1 -s -r
    read -n1 -s -r -p "Done. Press any key to return..."; echo
  fi
  echo "✅ Back to your shell (no screen reset)."
}

replay_instant() {
  if [[ -z "${1:-}" ]]; then
    echo "Usage: replay -i <basename-without-ext>"
    echo "Example: replay -i ~/terminal-logs/2025/08/10/kali-33608-203123"
    return 2
  fi
  local base="$1"
  local log="${base%.log}.log"
  if [[ ! -f "$log" ]]; then
    echo "Missing: $log"
    return 1
  fi

  # If you try to dump the *current* session's log, copy it first to avoid infinite growth
  local tmp="" cleanup=0
  if [[ -n "${logbase:-}" && "$log" == "${logbase}.log" ]]; then
    tmp="$(mktemp /tmp/kautolog-XXXXXX.log)" || { echo "mktemp failed"; return 1; }
    cp -- "$log" "$tmp" || { echo "copy failed"; rm -f -- "$tmp"; return 1; }
    log="$tmp"; cleanup=1
    echo "(info) Using a frozen copy of the live log to avoid recursion."
  fi

  # Gentle TTY save/restore (no full screen reset)
  local saved; saved=$(stty -g 2>/dev/null || true)
  _ri_restore() { stty "$saved" 2>/dev/null || true; printf '\e[?7h\e[?25h'; trap - INT EXIT; }
  trap _ri_restore INT EXIT

  echo "Instant dump of: $log"
  cat -- "$log"

  _ri_restore
  if [[ $cleanup -eq 1 ]]; then rm -f -- "$log"; fi
  echo
  echo "✅ Back to your shell."
}

# --- dispatcher: `replay [-i] <basename>` ---
if [[ "${1:-}" == "-i" || "${1:-}" == "--instant" ]]; then
  shift
  replay_instant "$@"
else
  replay "$@"
fi
