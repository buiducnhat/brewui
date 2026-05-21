# Source Layout

## Repository Root

| Path | Purpose |
| ---- | ------- |
| `Package.swift` | SwiftPM package definition for the `BrewUI` executable product. |
| `Sources/BrewUI/` | App source code. |
| `Assets/` | Project-owned app icon source PNG and generated `.icns`. |
| `script/build_and_run.sh` | Project-local build, bundle, launch, debug, log, telemetry, and verify entrypoint. |
| `.codex/environments/environment.toml` | Codex app Run action configuration. |
| `docs/` | Project documentation. |
| `dist/` | Generated app bundle output, ignored by git. |
| `.build/` | SwiftPM build output, ignored by git. |

## Swift Source Groups

| Folder | Responsibility |
| ------ | -------------- |
| `App/` | App entrypoint, AppKit activation delegate, scene declarations, and command menu. |
| `Models/` | Value models and enums shared across client, store, and views. |
| `Services/` | Homebrew process execution, parsing, and discovery logic. |
| `Stores/` | Main actor app state and async action orchestration. |
| `Support/` | Small view/style/formatting helpers. |
| `Views/` | SwiftUI screens, layout components, sheets, cards, tables, and controls. |

## Key Files

- `App/BrewUIApp.swift`: launches the app, owns `BrewStore`, defines settings and commands.
- `Services/BrewClient.swift`: wraps `brew` commands and parses command output.
- `Stores/BrewStore.swift`: coordinates UI actions and app state.
- `Views/ContentView.swift`: root split-view shell.
- `Views/PackagesView.swift`: installed/outdated package tables, filters, actions, and info sheet.
- `Views/UtilitiesView.swift`: maintenance utilities and command output.
- `Support/BrewGlass.swift`: Liquid Glass-compatible surface helper.
