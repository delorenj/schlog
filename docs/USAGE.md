# Schlog Usage Guide

## Basic Commands

### Installation Commands

```bash
# Basic installation
schlog install

# Install with custom options
schlog install --logdir ~/my-logs --with-tmux --with-sync remote:backup

# Check installation status
schlog status

# Uninstall
schlog uninstall
```

### Replay Commands

```bash
# Basic replay with timing
schlog replay ~/terminal-logs/2025/01/15/hostname-12345-094530

# Instant dump (no timing)
schlog replay -i ~/terminal-logs/2025/01/15/hostname-12345-094530

# Speed control
schlog replay -d 2 ~/terminal-logs/2025/01/15/hostname-12345-094530

# Maximum delay between lines
schlog replay --maxdelay 0.5 ~/terminal-logs/2025/01/15/hostname-12345-094530

# Target duration (auto-adjust speed)
schlog replay --target 120 ~/terminal-logs/2025/01/15/hostname-12345-094530
```

## Log Organization

### Directory Structure

```
~/terminal-logs/
├── 2025/           # Year
│   ├── 01/         # Month
│   │   ├── 15/     # Day
│   │   │   ├── hostname-12345-094530.log      # Terminal output
│   │   │   ├── hostname-12345-094530.timing   # Timing information
│   │   │   └── tmux-session-w0-p0-*.log       # Tmux pane logs
│   │   └── 16/
│   └── 02/
```

### File Naming Convention

- **Terminal logs**: `hostname-pid-timestamp.log`
- **Timing files**: `hostname-pid-timestamp.timing`
- **Tmux logs**: `tmux-session-w{window}-p{pane}-{timestamp}.log`

## Advanced Usage

### Search Logs

```bash
# Search for specific text
grep -r "error" ~/terminal-logs/

# Search recent logs only
grep -r "error" ~/terminal-logs/$(date +%Y/%m/%d)/

# Case-insensitive search
grep -ri "warning" ~/terminal-logs/
```

### Log Analysis

```bash
# Count commands by frequency
cat ~/terminal-logs/2025/01/15/*.log | grep "^$ " | sort | uniq -c | sort -nr

# Extract just the commands
cat ~/terminal-logs/2025/01/15/*.log | grep "^$ " | sed 's/^$ //'

# Find long-running commands (analyze timing)
awk '{if($1>10) print $0}' ~/terminal-logs/2025/01/15/*.timing
```

### Tmux Integration

When tmux integration is enabled:

```bash
# Each tmux pane gets its own log file
# Format: tmux-{session}-w{window}-p{pane}-{timestamp}.log

# Find tmux logs for specific session
find ~/terminal-logs -name "tmux-mysession-*"

# Replay tmux pane activity
# (Note: tmux logs don't have timing files)
cat ~/terminal-logs/2025/01/15/tmux-mysession-w0-p0-*.log
```

### Cloud Sync

When rclone sync is enabled:

```bash
# Check sync timer status
systemctl --user status autologger-rclone-sync.timer

# Manual sync
systemctl --user start autologger-rclone-sync.service

# View sync logs
journalctl --user -u autologger-rclone-sync.service
```

## Integration Examples

### With Git Hooks

```bash
# Pre-commit hook to log git commands
#!/bin/bash
echo "Git commit at $(date)" >> ~/terminal-logs/git-activity.log
```

### With Cron Jobs

```bash
# Daily log summary
0 23 * * * find ~/terminal-logs/$(date +\%Y/\%m/\%d) -name "*.log" | wc -l >> ~/daily-activity.log
```

### With Shell Aliases

```bash
# Add to .bashrc or .zshrc
alias replay-last='schlog replay $(find ~/terminal-logs -name "*.log" -type f -printf "%T@ %p\n" | sort -n | tail -1 | cut -d" " -f2- | sed "s/.log$//")'
alias logs-today='ls -la ~/terminal-logs/$(date +%Y/%m/%d)/'
alias logs-grep='grep -r --include="*.log"'
```

## Environment Variables

### Available Variables

- `UNDER_SCRIPT`: Prevents recursive logging
- `logbase`: Current log file base path (available in logged sessions)

### Usage Examples

```bash
# Add custom markers to logs
echo "# Starting important task" >> "$logbase.log"

# Conditional behavior based on logging
if [[ -n "$UNDER_SCRIPT" ]]; then
    echo "This session is being logged"
fi
```

## Best Practices

### Log Management

1. **Regular cleanup**: Use logrotate or manual cleanup
2. **Selective logging**: Exclude sensitive sessions when needed
3. **Backup important logs**: Sync to cloud or external storage
4. **Monitor disk usage**: Logs can grow large over time

### Security Considerations

1. **Sensitive data**: Be aware that passwords and secrets may be logged
2. **Access control**: Secure your log directory appropriately
3. **Cloud sync**: Ensure encrypted transport for sensitive logs
4. **Log retention**: Define appropriate retention policies

### Performance Tips

1. **Log rotation**: Enable to prevent large file accumulation
2. **Selective tmux logging**: Only enable for sessions that need it
3. **Sync frequency**: Balance between freshness and performance
4. **Storage location**: Use fast storage for active logs