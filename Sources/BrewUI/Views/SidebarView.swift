import SwiftUI

struct SidebarView: View {
    @Binding var selection: BrewSection

    var body: some View {
        List(BrewSection.allCases, selection: $selection) { section in
            Label(section.rawValue, systemImage: section.systemImage)
                .tag(section)
        }
        .listStyle(.sidebar)
        .navigationTitle("BrewUI")
    }
}
