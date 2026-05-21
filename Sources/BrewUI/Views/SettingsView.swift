import SwiftUI

struct SettingsView: View {
    @ObservedObject var store: BrewStore

    var body: some View {
        Form {
            Section("Homebrew") {
                LabeledContent("Executable", value: store.brewPath)
                Toggle("Disable auto-update during app commands", isOn: .constant(true))
                    .disabled(true)
                Toggle("Hide Homebrew environment hints", isOn: .constant(true))
                    .disabled(true)
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .frame(width: 520)
    }
}
