# Product Requirements

## Product Goal

BrewUI gives macOS users a native interface for common Homebrew package management tasks without requiring every operation to be typed manually in Terminal.

## Target Users

- Developers using Homebrew on macOS.
- Users who want a quick view of installed packages, outdated packages, casks, and taps.
- Users who prefer a guided UI for maintenance tasks like cleanup, autoremove, doctor, and Brewfile checks.

## Current Scope

BrewUI currently supports:

- Homebrew discovery from common install paths and `PATH`.
- Installed formula and cask inventory.
- Package kind filtering.
- Outdated package view.
- Package info in a readable sheet.
- Package search and install.
- Package upgrade and uninstall.
- Tap listing and untap action.
- Maintenance utilities from Homebrew's CLI surface.
- Command output and recent command history for utility and mutating operations.
- App icon and local `.app` bundle staging.

## Constraints

- Requires Homebrew to be installed locally.
- Runs Homebrew commands on the user's machine with the same permissions as the app process.
- Does not bundle Homebrew or package metadata.
- Uses Homebrew command output parsing, so parser behavior should be revisited when Homebrew output changes.
- The app currently disables Homebrew auto-update for commands it runs to keep UI refreshes predictable.

## Non-Goals

- Replacing Homebrew's full CLI surface.
- Managing remote machines.
- Providing a package marketplace backend.
- Signing, notarization, or packaged distribution artifacts.
- Editing Homebrew taps or formula source files.
