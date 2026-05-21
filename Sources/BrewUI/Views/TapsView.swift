import SwiftUI

struct TapsView: View {
    @ObservedObject var store: BrewStore

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(title: "Taps", count: store.taps.count, isBusy: store.isLoading)

            if store.taps.isEmpty {
                ContentUnavailableView("No taps were found.", systemImage: "tray.2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(store.taps) { tap in
                    Label(tap.name, systemImage: "folder")
                        .contextMenu {
                            Button("Untap") {
                                Task { await store.runCommand(["untap", tap.name]) }
                            }
                        }
                }
            }
        }
        .navigationTitle("Taps")
    }
}
