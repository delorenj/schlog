# kautolog

Auto-log **everything you see** in every terminal tab on Kali/Linux using `script(1)` — prompt, commands, output, ANSI colors, and ncurses apps — with optional timing/replay, tmux per-pane logs, logrotate, and rclone cloud sync.

**v1.1.0**: Installs into **both** `~/.bashrc` and `~/.zshrc` by default (so it works on Kali's Zsh and Bash).

## Install
```
pipx install kautolog
kautolog install
# or add extras
kautolog install --with-tmux --with-sync remote:terminal-logs --interval 10
```
Uninstall:
```
kautolog uninstall
```

## Notes
- Works for tabs/windows/SSH. Passwords you type are not logged (not echoed).
- Zsh logging uses a `precmd()` hook to timestamp commands similar to Bash's `PROMPT_COMMAND`.
