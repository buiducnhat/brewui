# SwiftUI Conventions

## App Structure

- Keep the app split into `App`, `Models`, `Services`, `Stores`, `Support`, and `Views`.
- Keep `ContentView` as root composition only.
- Put feature-specific UI in dedicated views such as `PackagesView`, `SearchView`, `TapsView`, and `UtilitiesView`.
- Keep process execution outside views. Views call `BrewStore`; `BrewStore` calls `BrewClient`.

## State

- `BrewStore` is `@MainActor` and owns app state.
- Root ownership uses `@StateObject`.
- Child views receive the store as `@ObservedObject`.
- Local view controls, such as package filters, use `@State`.
- Models crossing async boundaries should remain value types and `Sendable`.

## UI Patterns

- Use `NavigationSplitView` for top-level structure.
- Use native `Table` for installed and outdated package lists.
- Use `Picker(...).pickerStyle(.segmented)` for package kind filtering.
- Use sheets for package details that should not look like raw terminal output.
- Keep destructive operations visibly marked with `.destructive` role.
- Keep utility cards fully clickable with `contentShape` and an expanded frame.

## Styling

- Use semantic colors and foreground styles.
- Use `brewGlass(cornerRadius:interactive:)` for custom glass surfaces.
- Let sidebars, toolbars, tables, and sheets keep system-native behavior.
- Do not hardcode light-only backgrounds.
- Avoid adding custom chrome where a native SwiftUI control already communicates the action.

## Homebrew Commands

- Add new Homebrew operations through `BrewUtility` when they are reusable utilities.
- Keep command arguments as structured arrays, not shell-joined strings.
- Avoid invoking a shell for Homebrew commands; use `Process.executableURL` and `Process.arguments`.
- Preserve `HOMEBREW_NO_ENV_HINTS=1` and `HOMEBREW_NO_AUTO_UPDATE=1` unless a feature explicitly requires different behavior.
