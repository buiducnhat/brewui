import SwiftUI

struct DashboardView: View {
    @ObservedObject var store: BrewStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HeaderView(
                    title: "Homebrew Overview",
                    subtitle: store.brewPath,
                    isBusy: store.isLoading || store.isRunningCommand
                )

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 190), spacing: 12)], spacing: 12) {
                    MetricCard(title: "Formulae", value: "\(store.formulaCount)", systemImage: "terminal")
                    MetricCard(title: "Casks", value: "\(store.caskCount)", systemImage: "macwindow")
                    MetricCard(title: "Outdated", value: "\(store.outdatedPackages.count)", systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                    MetricCard(title: "Taps", value: "\(store.taps.count)", systemImage: "tray.2")
                }

                SectionBox(title: "Next Actions") {
                    HStack(spacing: 10) {
                        UtilityButton(utility: .doctor, store: store)
                        UtilityButton(utility: .cleanupDryRun, store: store)
                        UtilityButton(utility: .upgradeAll, store: store)
                    }
                }

                CommandOutputView(result: store.activeResult, history: store.commandHistory)
            }
            .padding(24)
        }
    }
}

struct HeaderView: View {
    let title: String
    let subtitle: String
    let isBusy: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.largeTitle.weight(.semibold))
                Text(subtitle)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
            Spacer()
            if isBusy {
                ProgressView()
                    .controlSize(.small)
            }
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            Text(value)
                .font(.system(size: 34, weight: .semibold, design: .rounded))
            Text(title)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .brewGlass(cornerRadius: 14)
    }
}

struct SectionBox<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .brewGlass(cornerRadius: 14)
    }
}
