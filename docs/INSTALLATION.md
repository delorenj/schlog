# Schlog Installation Guide

## Prerequisites

- Python 3.8 or higher
- `util-linux` package (for `script` command)
- Optional: `rclone` (for cloud sync)
- Optional: `tmux` (for multiplexed sessions)

## Installation Methods

### Method 1: PyPI (Recommended)

```bash
pip install schlog
```

### Method 2: From Source

```bash
git clone https://github.com/delorenj/schlog.git
cd schlog
pip install .
```

### Method 3: Development Install

```bash
git clone https://github.com/delorenj/schlog.git
cd schlog
pip install -e .
```

## Post-Installation Setup

### Basic Setup

```bash
# Install with default settings
schlog install

# Verify installation
schlog status
```

### Advanced Setup

```bash
# Custom log directory
schlog install --logdir /custom/path/logs

# Enable all features
schlog install \
  --logdir ~/my-logs \
  --with-tmux \
  --with-sync remote:backup \
  --interval 15
```

## Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `--logdir` | Log directory path | `~/terminal-logs` |
| `--with-tmux` | Enable tmux integration | `false` |
| `--with-logrotate` | Enable log rotation | `true` |
| `--with-sync` | rclone remote for sync | None |
| `--interval` | Sync interval (minutes) | `10` |

## Verification

After installation, verify that schlog is working:

1. **Check status**: `schlog status`
2. **Open new terminal**: Start a new shell session
3. **Check logs**: Look for files in your log directory
4. **Test replay**: Use `schlog replay` on a log file

## Troubleshooting

### Common Issues

- **Permission denied**: Ensure log directory is writable
- **Command not found**: Check that `~/.local/bin` is in PATH
- **No logs created**: Verify you're in a new terminal session

### Getting Help

- Run `schlog --help` for command reference
- Check `schlog status` for configuration details
- Review installation output for error messages