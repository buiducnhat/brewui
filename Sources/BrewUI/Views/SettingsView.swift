import Sparkle
import SwiftUI

struct SettingsView: View {
    @ObservedObject var store: BrewStore
    let updater: SPUUpdater?

    var body: some View {
        Form {
            Section("Application") {
                LabeledContent("Version", value: AppConfiguration.displayVersion)
                LabeledContent("Build", value: AppConfiguration.buildVersion)
            }

            Section("Homebrew") {
                LabeledContent("Executable", value: store.brewPath)
                Toggle("Disable auto-update during app commands", isOn: .constant(true))
                    .disabled(true)
                Toggle("Hide Homebrew environment hints", isOn: .constant(true))
                    .disabled(true)
            }

            if let updater {
                UpdaterSettingsSection(updater: updater)
            } else {
                Section("Updates") {
                    Text("Update checks are enabled only in builds that include a Sparkle feed URL and public signing key.")
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 520)
    }
}
