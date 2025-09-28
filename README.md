# Schlog

Terminal session auto-logging with script(1), tmux integration, logrotate, and cloud sync capabilities.

## Overview

Schlog is a comprehensive terminal session logging tool that automatically captures all your terminal activity with precise timing information. It integrates seamlessly with both Bash and Zsh shells, supports tmux multiplexing, includes automatic log rotation, and can sync your logs to cloud storage using rclone.

## Features

- **Automatic Terminal Logging**: Captures all terminal input/output with timing using `script(1)`
- **Multi-Shell Support**: Works with both Bash and Zsh shells
- **Tmux Integration**: Optional per-pane logging for tmux sessions
- **Log Rotation**: Automatic cleanup and compression with logrotate
- **Cloud Sync**: Optional sync to cloud storage using rclone
- **Session Replay**: Replay terminal sessions with original timing
- **Organized Storage**: Hierarchical log organization by date (YYYY/MM/DD)

## Installation

### From PyPI

```bash
pip install schlog
```

### From Source

```bash
git clone https://github.com/delorenj/schlog.git
cd schlog
pip install .
```

## Quick Start

### Basic Installation

Install schlog for your user account (both Bash and Zsh):

```bash
schlog install
```

This will:
- Add logging hooks to your `.bashrc` and `.zshrc`
- Install the `schlog-replay` helper script
- Set up logrotate rules for automatic cleanup
- Create the default log directory at `~/terminal-logs`

### Installation with Options

```bash
# Custom log directory
schlog install --logdir ~/my-logs

# Enable tmux integration
schlog install --with-tmux

# Disable logrotate
schlog install --no-logrotate

# Enable cloud sync with rclone
schlog install --with-sync remote:terminal-logs --interval 15

# All options together
schlog install --logdir ~/my-logs --with-tmux --with-sync remote:logs --interval 10
```

### Verify Installation

```bash
schlog status
```

This shows:
- Installation status for Bash, Zsh, and tmux
- Sync timer status
- Recent log files

## Usage

### Automatic Logging

Once installed, logging happens automatically in new terminal sessions. No manual intervention required.

### Log Structure

Logs are organized hierarchically:

```
~/terminal-logs/
├── 2025/
│   ├── 01/
│   │   ├── 15/
│   │   │   ├── hostname-12345-094530.log      # Terminal output
│   │   │   ├── hostname-12345-094530.timing   # Timing data
│   │   │   └── tmux-session-w0-p0-1234567890.log  # Tmux logs
│   │   └── 16/
│   └── 02/
```

### Replaying Sessions

Use the `schlog replay` command to replay recorded sessions:

```bash
# Replay with original timing
schlog replay ~/terminal-logs/2025/01/15/hostname-12345-094530

# Instant dump without timing
schlog replay -i ~/terminal-logs/2025/01/15/hostname-12345-094530

# Replay at 2x speed
schlog replay -d 2 ~/terminal-logs/2025/01/15/hostname-12345-094530

# Limit max delay between lines
schlog replay --maxdelay 0.5 ~/terminal-logs/2025/01/15/hostname-12345-094530

# Target duration (adjust speed automatically)
schlog replay --target 60 ~/terminal-logs/2025/01/15/hostname-12345-094530
```

## Configuration Options

### Log Directory

By default, logs are stored in `~/terminal-logs`. You can specify a custom directory:

```bash
schlog install --logdir /path/to/logs
```

### Tmux Integration

Enable automatic per-pane logging for tmux sessions:

```bash
schlog install --with-tmux
```

This adds configuration to `~/.tmux.conf` that logs each pane's output separately.

### Log Rotation

Schlog includes automatic log rotation via logrotate:

- Daily rotation
- 14 days retention
- Automatic compression
- Handles both `.log` and `.timing` files

Disable with `--no-logrotate` if you prefer manual log management.

### Cloud Sync

Sync your logs to cloud storage using rclone:

```bash
# Configure rclone first
rclone config

# Install with sync enabled
schlog install --with-sync remote:terminal-logs --interval 10
```

This creates a systemd user timer that syncs logs every specified interval (minutes).

## Advanced Features

### Environment Variables

- `UNDER_SCRIPT`: Set automatically to prevent recursive logging
- `logbase`: Available in shell sessions, contains the current log file base path

### Integration with Other Tools

Schlog works well with:
- **rclone**: For cloud storage sync
- **logrotate**: For automatic cleanup
- **tmux**: For multiplexed sessions
- **systemd**: For automated sync timers

### Custom Log Processing

Since logs are standard text files with timing data, you can process them with any tools:

```bash
# Search logs
grep -r "error" ~/terminal-logs/

# Analyze command frequency
cat ~/terminal-logs/2025/01/15/*.log | grep "^$ " | sort | uniq -c | sort -nr

# Extract commands only
cat ~/terminal-logs/2025/01/15/*.log | grep "^$ " | cut -c3-
```

## Uninstallation

Remove schlog configuration:

```bash
schlog uninstall
```

This removes:
- Shell configuration from `.bashrc` and `.zshrc`
- Tmux configuration from `.tmux.conf`
- Logrotate rules
- Systemd sync timer
- Helper scripts

Note: Log files are preserved. Remove `~/terminal-logs` manually if desired.

## Troubleshooting

### Common Issues

1. **Logs not appearing**: Ensure you're in a new terminal session after installation
2. **Permission errors**: Check that the log directory is writable
3. **Sync not working**: Verify rclone configuration and remote accessibility
4. **Script not found**: Ensure `/usr/bin/script` is available (util-linux package)

### Debugging

Check status and recent logs:

```bash
schlog status
```

Verify shell configuration:

```bash
# Check for schlog markers in shell configs
grep -A5 -B5 "SCHLOG" ~/.bashrc ~/.zshrc
```

Test manual logging:

```bash
# Manual script execution
script -fqe -t/tmp/test.timing /tmp/test.log
# ... do some commands ...
# exit
scriptreplay -t /tmp/test.timing /tmp/test.log
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE.txt for details.

## Author

**Jarad DeLorenzo**
- Email: jaradd@gmail.com
- Website: https://delorenj.github.io
- GitHub: https://github.com/delorenj/schlog

## Acknowledgments

- Built on the robust `script(1)` utility from util-linux
- Inspired by the need for comprehensive terminal session recording
- Thanks to the open-source community for the underlying tools