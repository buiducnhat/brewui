import SwiftUI

struct ContentView: View {
    @ObservedObject var store: BrewStore

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $store.selectedSection)
        } detail: {
            DetailView(store: store)
        }
        .searchable(text: $store.searchTerm, placement: .toolbar, prompt: "Search formulae and casks")
        .onSubmit(of: .search) {
            store.selectedSection = .search
            Task { await store.performSearch() }
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    Task { await store.refreshAll() }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .disabled(store.isLoading || store.isRunningCommand)

                Button {
                    Task { await store.runUtility(.update) }
                } label: {
                    Label("Update", systemImage: "arrow.triangle.2.circlepath")
                }
                .disabled(store.isRunningCommand)
            }
        }
        .overlay(alignment: .bottom) {
            if let errorMessage = store.errorMessage {
                ErrorBanner(message: errorMessage) {
                    store.errorMessage = nil
                }
                .padding()
            }
        }
        .buttonBorderShape(.roundedRectangle(radius: 8))
    }
}

struct DetailView: View {
    @ObservedObject var store: BrewStore

    var body: some View {
        switch store.selectedSection {
        case .dashboard:
            DashboardView(store: store)
        case .installed:
            PackagesView(
                title: "Installed Packages",
                packages: store.installedPackages,
                packageFilter: $store.installedPackageFilter,
                store: store,
                emptyMessage: "No installed formulae or casks were found."
            )
        case .outdated:
            PackagesView(
                title: "Outdated Packages",
                packages: store.outdatedPackages,
                packageFilter: $store.outdatedPackageFilter,
                store: store,
                emptyMessage: "Everything is current."
            )
        case .search:
            SearchView(store: store)
        case .taps:
            TapsView(store: store)
        case .utilities:
            UtilitiesView(store: store)
        }
    }
}

struct ErrorBanner: View {
    let message: String
    let dismiss: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text(message)
                .lineLimit(2)
            Spacer()
            Button(action: dismiss) {
                Image(systemName: "xmark")
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .brewGlass(cornerRadius: 12)
        .shadow(radius: 12, y: 4)
        .padding(.horizontal)
    }
}
