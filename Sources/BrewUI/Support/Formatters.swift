import Foundation

@MainActor
enum BrewFormatters {
    static let duration: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter
    }()

    static let timestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()

    static func formatDuration(_ interval: TimeInterval) -> String {
        duration.string(from: Measurement(value: interval, unit: UnitDuration.seconds))
    }
}
