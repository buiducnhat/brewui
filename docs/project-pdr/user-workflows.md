# User Workflows

## Review Homebrew State

1. Launch BrewUI.
2. The app loads installed formulae, casks, outdated packages, and taps.
3. The Dashboard summarizes totals and exposes common next actions.

## Filter Installed Packages

1. Open Installed Packages.
2. Use the segmented control to switch between All, Formulae, and Casks.
3. Select a package to reveal package actions.

## Inspect Package Info

1. Select a package in Installed, Outdated, or Search results.
2. Click Info or double-click the package row.
3. Review the native info sheet.
4. Close the sheet with the close button or Escape.

## Search And Install

1. Use the toolbar search field or open Search.
2. Enter a formula or cask name.
3. Run search.
4. Click Install on a result.
5. BrewUI runs the appropriate `brew install` command and refreshes package state.

## Upgrade Or Remove Packages

1. Select a package.
2. Click Upgrade or Uninstall.
3. Review command output if needed.
4. BrewUI refreshes installed and outdated package state after the command completes.

## Run Maintenance Utilities

1. Open Dashboard next actions or Utilities.
2. Choose Update Metadata, Doctor, Cleanup Preview, Cleanup, Autoremove Preview, Autoremove, Upgrade All, Dump Brewfile, or Check Brewfile.
3. Review command status, output, duration, and recent history.

## Manage Taps

1. Open Taps.
2. Review installed taps.
3. Use the context menu to untap a selected tap.
