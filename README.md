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
- Sparkle-based in-app update checks and installs for signed release builds.
- Liquid Glass-inspired surfaces on supported macOS versions with material fallback.
- Project-local macOS app bundle launcher with app icon support.
- Tag-driven GitHub Actions release pipeline for signed builds and appcast publishing.

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

## Releases

Pushing a tag like `v0.1.0` triggers `.github/workflows/release.yml`. The workflow:

- builds and signs a release app bundle
- optionally notarizes and staples it when notary secrets are configured
- publishes the Sparkle appcast and update archives on `gh-pages`
- creates a GitHub release with the same zip artifact

Required repository secrets:

- `APPLE_CERTIFICATE_P12_BASE64`
- `APPLE_CERTIFICATE_PASSWORD`
- `APPLE_SIGNING_IDENTITY`
- `SPARKLE_PUBLIC_ED_KEY`
- `SPARKLE_PRIVATE_ED_KEY`

Optional notarization secrets:

- `APPLE_NOTARY_KEY_ID`
- `APPLE_NOTARY_ISSUER_ID`
- `APPLE_NOTARY_API_KEY_P8_BASE64`

GitHub Pages should be configured once to serve from the `gh-pages` branch root so `https://<owner>.github.io/<repo>/appcast.xml` stays live.

## Documentation

Start with [docs/SUMMARY.md](docs/SUMMARY.md) for architecture, codebase, conventions, and product requirements.

## Repository

GitHub: [buiducnhat/brewui](https://github.com/buiducnhat/brewui)

## Author

Nhat Bui ([@buiducnhat](https://github.com/buiducnhat))

## License

BrewUI is released under the [MIT License](LICENSE).
