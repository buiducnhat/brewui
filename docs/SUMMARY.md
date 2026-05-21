# Documentation Summary

BrewUI is a SwiftPM-based macOS SwiftUI app for managing Homebrew packages and maintenance workflows. It uses a native `NavigationSplitView` interface, a `BrewStore` state layer, and a `BrewClient` process wrapper around the local `brew` executable.

## Agent Context Guide

Before planning or implementing, read this `docs/SUMMARY.md` file first. Load only the detail docs relevant to the current task, and prioritize `Code Standard` docs for implementation conventions. If docs conflict with code or user intent, use the available question tool before making broad changes.

## Architecture

System design, component interactions, data flows, deployment, and external integrations.

| File | Description |
| ---- | ----------- |
| [system-design.md](architecture/system-design.md) | SwiftUI scene structure, state ownership, app surfaces, and bundle/runtime shape. |
| [homebrew-command-flow.md](architecture/homebrew-command-flow.md) | How UI actions flow through `BrewStore`, `BrewClient`, `brew`, parsers, and result views. |

## Codebase

Directory structure, entry points, API patterns, and key modules.

| File | Description |
| ---- | ----------- |
| [source-layout.md](codebase/source-layout.md) | Repository folders, Swift source groups, assets, docs, and generated bundle outputs. |
| [runtime-entrypoints.md](codebase/runtime-entrypoints.md) | App entrypoint, command menu, build/run script, Codex Run action, and icon bundling. |

## Code Standard

Conventions, naming rules, tech stack versions, and development workflows.

| File | Description |
| ---- | ----------- |
| [swiftui-conventions.md](code-standard/swiftui-conventions.md) | SwiftUI, state, naming, styling, and Liquid Glass conventions used by BrewUI. |
| [build-run-workflow.md](code-standard/build-run-workflow.md) | Required local build, app bundle, verification, and shell command workflow. |

## Project PDR

Product goals, use cases, business rules, and constraints.

| File | Description |
| ---- | ----------- |
| [product-requirements.md](project-pdr/product-requirements.md) | Product goals, current feature scope, constraints, and non-goals. |
| [user-workflows.md](project-pdr/user-workflows.md) | Supported user workflows for package management, package info, search, taps, and utilities. |
