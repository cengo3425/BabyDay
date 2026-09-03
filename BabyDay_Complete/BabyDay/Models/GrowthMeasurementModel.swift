import Foundation
import SwiftData

@Model
final class GrowthMeasurementModel {
    var id: UUID
    var date: Date
    var weightKg: Double?
    var heightCm: Double?
    var headCircumferenceCm: Double?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        weightKg: Double? = nil,
        heightCm: Double? = nil,
        headCircumferenceCm: Double? = nil
    ) {
        self.id = id
        self.date = date
        self.weightKg = weightKg
        self.heightCm = heightCm
        self.headCircumferenceCm = headCircumferenceCm
    }
}
