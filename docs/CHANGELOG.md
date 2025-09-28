# Changelog

All notable changes to Schlog will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-01-28

### Added
- Initial release of Schlog (transformed from kautolog)
- Terminal session auto-logging with script(1)
- Support for both Bash and Zsh shells
- Tmux integration for per-pane logging
- Automatic log rotation with logrotate
- Cloud sync capabilities using rclone
- Session replay functionality with timing control
- Hierarchical log organization by date (YYYY/MM/DD)
- Comprehensive CLI with install/uninstall/status/replay commands
- Environment variable support for custom behavior
- Systemd user timer integration for automated sync
- Complete documentation and usage guides

### Changed
- Project name changed from "kautolog" to "Schlog"
- CLI command changed from "kautolog" to "schlog"
- All internal references updated to use "schlog" branding
- Author changed to Jarad DeLorenzo
- Repository moved to delorenj/schlog
- Version reset to 0.1.0 for new project identity

### Technical Details
- Updated pyproject.toml with new project metadata
- Modified all Python modules to use schlog naming
- Updated all template files with new markers and references
- Renamed kautolog-replay to schlog-replay
- Updated all shell script markers from KAUTOLOG to SCHLOG
- Modified installer to use new variable names and paths
- Updated systemd service and timer configurations
- Added schlog-specific .gitignore patterns

### Documentation
- Complete README.md with installation and usage instructions
- Detailed installation guide in docs/INSTALLATION.md
- Comprehensive usage guide in docs/USAGE.md
- Project changelog in docs/CHANGELOG.md

### Migration from kautolog
Users migrating from kautolog should:
1. Uninstall kautolog: `kautolog uninstall`
2. Install schlog: `pip install schlog && schlog install`
3. Existing logs remain compatible and can be replayed with schlog
4. Update any custom scripts to use "schlog" command instead of "kautolog"