import Foundation

/// Production boundary for WHO Child Growth Standards calculations.
/// The bundled app must be populated with the official WHO tables before
/// displaying medical z-scores/percentiles. No approximate values are generated.
struct WHOGrowthResult {
    let indicator: String
    let percentile: Double?
    let zScore: Double?
    let statusText: String
}

enum WHOGrowthCalculator {
    static func result(
        baby: BabyModel,
        measurement: GrowthMeasurementModel
    ) -> WHOGrowthResult {
        WHOGrowthResult(
            indicator: "WHO 0–5 yaş büyüme standardı",
            percentile: nil,
            zScore: nil,
            statusText: "WHO tablosu ile değerlendirmeye hazır"
        )
    }
}
