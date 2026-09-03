import Foundation

/// WHO Child Growth Standards metadata used by BabyDay.
/// Percentile/z-score values must come from the official WHO tables;
/// this type intentionally does not approximate medical reference values.
enum WHOGrowthStandard {
    static let sourceName = "WHO Child Growth Standards 0–5 years"

    static let indicators = [
        "Kilo / yaş",
        "Boy veya uzunluk / yaş",
        "Kilo / boy veya uzunluk",
        "Baş çevresi / yaş"
    ]

    static let note = "Takip amaçlıdır; tıbbi değerlendirme yerine geçmez."
}
