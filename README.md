# BrewUI

BrewUI is a native macOS app for managing Homebrew formulae, casks, taps, updates, cleanup tasks, and diagnostics from a SwiftUI interface.

![BrewUI app icon](Assets/BrewUI-AppIcon.png)

## Features

- Dashboard with installed formula, cask, outdated package, and tap counts.
- Installed and outdated package tables with filters for all packages, formulae, and casks.
- Package info sheet that presents `brew info` output as app-native sections.
- Search for formulae and casks, then install selected results.
- Taps list with untap action.
- Utilities for update, doctor, cleanup, autoremove, upgrade, and Brewfile checks.
- Liquid Glass-inspired surfaces on supported macOS versions with material fallback.
- Project-local macOS app bundle launcher with app icon support.

## Requirements

- macOS 14 or later.
- Swift 6 toolchain.
- Homebrew installed at `/opt/homebrew/bin/brew`, `/usr/local/bin/brew`, or available on `PATH`.

## Quick Start

```bash
./script/build_and_run.sh
```

Useful script modes:

```bash
./script/build_and_run.sh --verify
./script/build_and_run.sh --logs
./script/build_and_run.sh --telemetry
./script/build_and_run.sh --debug
```

## Documentation

Start with [docs/SUMMARY.md](docs/SUMMARY.md) for architecture, codebase, conventions, and product requirements.

## Repository

GitHub: [buiducnhat/brewui](https://github.com/buiducnhat/brewui)

## Author

Nhat Bui ([@buiducnhat](https://github.com/buiducnhat))

## License

BrewUI is released under the [MIT License](LICENSE).
