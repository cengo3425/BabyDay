import Foundation
import SwiftData

enum BabySex: String, Codable, CaseIterable, Identifiable {
    case girl = "Kız"
    case boy = "Erkek"

    var id: String { rawValue }
}

@Model
final class BabyModel {
    var id: UUID
    var name: String
    var birthDate: Date
    var birthWeightKg: Double
    var birthHeightCm: Double
    var sexRawValue: String

    var sex: BabySex {
        get { BabySex(rawValue: sexRawValue) ?? .girl }
        set { sexRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        name: String,
        birthDate: Date,
        birthWeightKg: Double,
        birthHeightCm: Double,
        sex: BabySex
    ) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.birthWeightKg = birthWeightKg
        self.birthHeightCm = birthHeightCm
        self.sexRawValue = sex.rawValue
    }
}
