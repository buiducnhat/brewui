# System Design

BrewUI is a single-window macOS app built with SwiftUI and packaged through SwiftPM. The app runs as a foreground `.app` bundle staged by `script/build_and_run.sh`, not as a raw command-line executable.

## Scene Structure

- `BrewUIApp` is the `@main` app type.
- `AppDelegate` sets `NSApp` to `.regular` and activates the app so SwiftPM-launched bundles behave like normal foreground macOS apps.
- The main window is a `WindowGroup("BrewUI", id: "main")` with a minimum size of `1060x680`.
- Settings are exposed through a separate `Settings` scene.
- Homebrew actions are also available from a `CommandMenu("Homebrew")`.

## UI Structure

The root UI uses `NavigationSplitView`:

- Sidebar: section selection for Dashboard, Installed, Outdated, Search, Taps, and Utilities.
- Detail pane: switches on `BrewSection` and renders the selected feature surface.
- Toolbar: refresh and metadata update actions.
- Global search: attached to the split view and routed to the Search section on submit.

Package lists use `Table` for dense desktop scanning. Package info opens in a sheet so command output is translated into readable app-native sections instead of a raw terminal dump.

## State Ownership

`BrewStore` is the main app state object and is owned by `BrewUIApp` with `@StateObject`. Views receive it as `@ObservedObject`.

`BrewStore` owns:

- Installed packages.
- Outdated packages.
- Taps.
- Search results.
- Selected sidebar section and selected package.
- Current package info sheet model.
- Last command result and command history.
- Loading, command-running, and error states.

## Styling

The app uses native SwiftUI controls first. Custom glass surfaces go through `brewGlass(cornerRadius:interactive:)`, which applies native `glassEffect` on macOS 26+ and `.regularMaterial` fallback on earlier macOS versions.

## Runtime Bundle

SwiftPM builds the `BrewUI` executable. The run script stages:

- `dist/BrewUI.app/Contents/MacOS/BrewUI`
- `dist/BrewUI.app/Contents/Resources/BrewUI.icns`
- `dist/BrewUI.app/Contents/Info.plist`

The staged bundle includes `CFBundleIconFile=BrewUI` and `CFBundlePackageType=APPL`.
