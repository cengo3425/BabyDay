import Foundation
import SwiftData
import SwiftUI

enum EventType: String, Codable, CaseIterable, Identifiable {
    case feeding = "Beslenme"
    case sleep = "Uyku"
    case diaper = "Bez"
    case stool = "Kaka"
    case temperature = "Ateş"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .feeding: return "waterbottle.fill"
        case .sleep: return "moon.zzz.fill"
        case .diaper: return "drop.fill"
        case .stool: return "circle.fill"
        case .temperature: return "thermometer.medium"
        }
    }

    var tint: Color {
        switch self {
        case .feeding: return .purple
        case .sleep: return .blue
        case .diaper: return .mint
        case .stool: return .orange
        case .temperature: return .pink
        }
    }
}

@Model
final class BabyEventModel {
    var id: UUID
    var typeRawValue: String
    var date: Date
    var detail: String
    var value: Double?

    var type: EventType {
        get { EventType(rawValue: typeRawValue) ?? .feeding }
        set { typeRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        type: EventType,
        date: Date = .now,
        detail: String,
        value: Double? = nil
    ) {
        self.id = id
        self.typeRawValue = type.rawValue
        self.date = date
        self.detail = detail
        self.value = value
    }
}
