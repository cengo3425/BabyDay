import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: EventType
    @State private var detail = ""
    @State private var temperature = 36.7
    @State private var duration = 15

    init(initialType: EventType = .feeding) {
        _selectedType = State(initialValue: initialType)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        typePicker

                        BabyCard {
                            formForSelectedType
                        }

                        Button {
                            save()
                        } label: {
                            Text("Kaydet")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.babyPurple, in: RoundedRectangle(cornerRadius: 18))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Kayıt Ekle")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var typePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(EventType.allCases) { type in
                    Button {
                        selectedType = type
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: type.icon)
                            Text(type.rawValue)
                                .font(.caption.bold())
                        }
                        .frame(width: 76, height: 66)
                        .background(
                            selectedType == type
                            ? type.tint.opacity(0.16)
                            : Color.white,
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedType == type ? type.tint : .clear, lineWidth: 1.5)
                        )
                        .foregroundStyle(type.tint)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var formForSelectedType: some View {
        switch selectedType {
        case .feeding:
            VStack(alignment: .leading, spacing: 16) {
                Text("Beslenme").font(.title3.bold())
                Picker("Beslenme türü", selection: $detail) {
                    Text("Anne sütü").tag("Anne sütü")
                    Text("Mama").tag("Mama")
                    Text("Ek gıda").tag("Ek gıda")
                }
                .pickerStyle(.segmented)

                Stepper("Süre: \(duration) dakika", value: $duration, in: 1...120)

            }
        case .sleep:
            VStack(alignment: .leading, spacing: 12) {
                Text("Uyku").font(.title3.bold())
                TextField("Örn. Gündüz uykusu", text: $detail)
                    .textFieldStyle(.roundedBorder)
            }
        case .diaper:
            VStack(alignment: .leading, spacing: 12) {
                Text("Bez").font(.title3.bold())
                Picker("Tür", selection: $detail) {
                    Text("Çiş").tag("Çiş")
                    Text("Kaka").tag("Kaka")
                    Text("İkisi").tag("Çiş + Kaka")
                }
                .pickerStyle(.segmented)
            }
        case .stool:
            VStack(alignment: .leading, spacing: 12) {
                Text("Kaka").font(.title3.bold())
                Picker("Kıvam", selection: $detail) {
                    Text("Sulu").tag("Sulu")
                    Text("Yumuşak").tag("Yumuşak")
                    Text("Katı").tag("Katı")
                }
                .pickerStyle(.segmented)
            }
        case .temperature:
            VStack(alignment: .leading, spacing: 12) {
                Text("Ateş").font(.title3.bold())
                Stepper("\(temperature, specifier: "%.1f") °C", value: $temperature, in: 34...42, step: 0.1)
            }
        }
    }

    private func save() {
        let finalDetail: String

        switch selectedType {
        case .feeding:
            let typeText = detail.isEmpty ? "Anne sütü" : detail
            finalDetail = "\(typeText) • \(duration) dakika"
        case .temperature:
            finalDetail = "\(temperature, specifier: "%.1f") °C"
        default:
            finalDetail = detail.isEmpty ? "Kayıt eklendi" : detail
        }

        context.insert(BabyEventModel(
            type: selectedType,
            detail: finalDetail,
            value: selectedType == .temperature ? temperature : nil
        ))

        try? context.save()
        dismiss()
    }
}
