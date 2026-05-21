# Runtime Entrypoints

## App Entrypoint

`BrewUIApp` is the app entrypoint. It creates one `BrewStore` and passes it into `ContentView`.

On launch, `AppDelegate.applicationDidFinishLaunching` calls:

- `NSApp.setActivationPolicy(.regular)`
- `NSApp.activate(ignoringOtherApps: true)`

This is necessary because the app is staged from a SwiftPM executable into a local `.app` bundle.

## Command Menu

`BrewCommands` adds a `Homebrew` menu with:

- Refresh
- Update Metadata
- Upgrade All Outdated
- Doctor

Menu actions route through `BrewStore`, matching toolbar and utility actions.

## Run Script

`script/build_and_run.sh` is the canonical local entrypoint.

Default behavior:

1. Stop any running `BrewUI` process.
2. Run `swift build`.
3. Stage `dist/BrewUI.app`.
4. Copy the SwiftPM executable into `Contents/MacOS`.
5. Copy `Assets/BrewUI.icns` into `Contents/Resources`.
6. Generate `Info.plist`.
7. Launch the app bundle with `/usr/bin/open -n`.

Supported modes:

- `run`
- `--debug`
- `--logs`
- `--telemetry`
- `--verify`

## Codex Run Action

`.codex/environments/environment.toml` defines one `Run` action:

```toml
[[actions]]
name = "Run"
icon = "run"
command = "./script/build_and_run.sh"
```

The Run action should stay pointed at the script rather than duplicating build logic in Codex configuration.
