# Build And Run Workflow

## Required Shell Convention

This repository uses RTK command filtering. Prefix shell commands with `rtk`.

Examples:

```bash
rtk swift build
rtk ./script/build_and_run.sh --verify
rtk git status
```

Use `rtk proxy <cmd>` only when `rtk` does not support a command shape directly.

## Build

Use SwiftPM:

```bash
rtk swift build
```

The package builds an executable product named `BrewUI`.

## Run

Use the project-local script:

```bash
rtk ./script/build_and_run.sh
```

Do not launch the SwiftPM executable directly for normal GUI testing. The script creates a real `.app` bundle with `Info.plist`, resources, and foreground app activation support.

## Verify

Use:

```bash
rtk ./script/build_and_run.sh --verify
```

This builds, stages, opens the app bundle, waits briefly, and checks for a running `BrewUI` process.

## Generated Files

Generated local files are ignored by git:

- `.build/`
- `.swiftpm/`
- `dist/`
- build caches and logs

The app icon source and `.icns` in `Assets/` are project assets and should be committed.

## Commit Style

Commit messages use Conventional Commits:

```text
<type>(<scope>): <summary>
```

Use lowercase imperative summaries under 72 characters.
