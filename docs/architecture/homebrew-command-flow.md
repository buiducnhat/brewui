# Homebrew Command Flow

BrewUI talks to Homebrew by executing the local `brew` executable through `Foundation.Process`.

## Command Path

1. A user action starts in a SwiftUI view, command menu, context menu, or toolbar.
2. The view calls an async method on `BrewStore`.
3. `BrewStore` delegates command execution to `BrewClient`.
4. `BrewClient.run(_:)` launches `brew` with the requested arguments.
5. Standard output and standard error are captured into a `BrewCommandResult`.
6. Store state is updated on the main actor.
7. The UI reacts through published state.

## Brew Discovery

`BrewClient.locateBrew()` checks common Homebrew paths first:

- `/opt/homebrew/bin/brew`
- `/usr/local/bin/brew`
- `/home/linuxbrew/.linuxbrew/bin/brew`

If none are executable, it searches the process `PATH`.

## Environment

Every `brew` command inherits the process environment and adds:

- `HOMEBREW_NO_ENV_HINTS=1`
- `HOMEBREW_NO_AUTO_UPDATE=1`

This keeps app-triggered commands quieter and prevents implicit auto-update side effects during routine UI refreshes.

## Read Operations

Refresh loads formulae, casks, outdated packages, and taps concurrently:

- `brew list --formula --versions`
- `brew list --cask --versions`
- `brew outdated --verbose`
- `brew tap`

Search uses:

- `brew search <term>`

Package info uses:

- `brew info --formula <name>`
- `brew info --cask <name>`

The raw info result is parsed into `BrewPackageInfo` sections for the sheet UI.

## Mutating Operations

Package and utility operations call `brew`, save the command result, then refresh the package state:

- Install: `brew install <name>` or `brew install --cask <name>`
- Uninstall: `brew uninstall <name>` or `brew uninstall --cask <name>`
- Upgrade: `brew upgrade <name>` or `brew upgrade --cask <name>`
- Update metadata: `brew update`
- Doctor: `brew doctor`
- Cleanup: `brew cleanup` and `brew cleanup --dry-run`
- Autoremove: `brew autoremove` and `brew autoremove --dry-run`
- Brewfile: `brew bundle dump --describe --force` and `brew bundle check --verbose`

## Error Handling

Thrown command or launch errors are exposed as `BrewStore.errorMessage` and shown through the root error banner.
