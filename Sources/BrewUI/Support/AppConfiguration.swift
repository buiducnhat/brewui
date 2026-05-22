import Combine
import Foundation
import Sparkle
import SwiftUI

enum AppConfiguration {
    static var displayVersion: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)
            ?? "0.0.0"
    }

    static var buildVersion: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)
            ?? displayVersion
    }

    static var updaterFeedURL: URL? {
        guard let rawValue = Bundle.main.object(forInfoDictionaryKey: "SUFeedURL") as? String else {
            return nil
        }

        let trimmedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return nil
        }

        return URL(string: trimmedValue)
    }

    static var updaterPublicKey: String? {
        guard let rawValue = Bundle.main.object(forInfoDictionaryKey: "SUPublicEDKey") as? String else {
            return nil
        }

        let trimmedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return nil
        }

        return trimmedValue
    }

    static var updatesAreConfigured: Bool {
        updaterFeedURL != nil && updaterPublicKey != nil
    }
}

@MainActor
final class CheckForUpdatesViewModel: ObservableObject {
    @Published private(set) var canCheckForUpdates = false

    init(updater: SPUUpdater) {
        canCheckForUpdates = updater.canCheckForUpdates
        updater.publisher(for: \.canCheckForUpdates)
            .receive(on: RunLoop.main)
            .assign(to: &$canCheckForUpdates)
    }
}

struct CheckForUpdatesView: View {
    @ObservedObject private var viewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater

    init(updater: SPUUpdater) {
        self.updater = updater
        _viewModel = ObservedObject(wrappedValue: CheckForUpdatesViewModel(updater: updater))
    }

    var body: some View {
        Button("Check for Updates…", action: updater.checkForUpdates)
            .disabled(!viewModel.canCheckForUpdates)
    }
}

struct UpdaterSettingsSection: View {
    private let updater: SPUUpdater
    @State private var automaticallyChecksForUpdates: Bool
    @State private var automaticallyDownloadsUpdates: Bool

    init(updater: SPUUpdater) {
        self.updater = updater
        _automaticallyChecksForUpdates = State(initialValue: updater.automaticallyChecksForUpdates)
        _automaticallyDownloadsUpdates = State(initialValue: updater.automaticallyDownloadsUpdates)
    }

    var body: some View {
        Section("Updates") {
            Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
                .onChange(of: automaticallyChecksForUpdates) { _, newValue in
                    updater.automaticallyChecksForUpdates = newValue
                }

            Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
                .disabled(!automaticallyChecksForUpdates)
                .onChange(of: automaticallyDownloadsUpdates) { _, newValue in
                    updater.automaticallyDownloadsUpdates = newValue
                }

            if let updaterFeedURL = AppConfiguration.updaterFeedURL {
                LabeledContent("Feed") {
                    Text(updaterFeedURL.absoluteString)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }
            }
        }
    }
}
