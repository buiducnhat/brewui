import AppKit
import Sparkle
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct BrewUIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var store: BrewStore
    private let updaterController: SPUStandardUpdaterController?

    init() {
        _store = StateObject(wrappedValue: BrewStore(client: BrewClient()))
        if AppConfiguration.updatesAreConfigured {
            updaterController = SPUStandardUpdaterController(
                startingUpdater: true,
                updaterDelegate: nil,
                userDriverDelegate: nil
            )
        } else {
            updaterController = nil
        }
    }

    var body: some Scene {
        WindowGroup("BrewUI", id: "main") {
            ContentView(store: store)
                .frame(minWidth: 1060, minHeight: 680)
                .task {
                    await store.loadInitialData()
                }
        }
        .windowResizability(.contentMinSize)
        .commands {
            if let updaterController {
                CommandGroup(after: .appInfo) {
                    CheckForUpdatesView(updater: updaterController.updater)
                }
            }
            BrewCommands(store: store)
        }

        Settings {
            SettingsView(store: store, updater: updaterController?.updater)
        }
    }
}

struct BrewCommands: Commands {
    @ObservedObject var store: BrewStore

    var body: some Commands {
        CommandMenu("Homebrew") {
            Button("Refresh") {
                Task { await store.refreshAll() }
            }
            .keyboardShortcut("r", modifiers: [.command])

            Divider()

            Button("Update Metadata") {
                Task { await store.runUtility(.update) }
            }
            .keyboardShortcut("u", modifiers: [.command, .shift])

            Button("Upgrade All Outdated") {
                Task { await store.runUtility(.upgradeAll) }
            }
            .disabled(store.outdatedPackages.isEmpty)

            Button("Doctor") {
                Task { await store.runUtility(.doctor) }
            }
        }
    }
}
