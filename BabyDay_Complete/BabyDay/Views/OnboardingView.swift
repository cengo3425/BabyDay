import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("babyday.onboardingComplete") private var completed = false
    @State private var name = "Duru Arya"
    @State private var birthDate = Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15)) ?? .now
    @State private var birthWeight = "3.530"
    @State private var birthHeight = "51"
    @State private var sex: BabySex = .girl

    var body: some View {
        NavigationStack {
            Form {
                Section("Bebeğin") {
                    TextField("Adı", text: $name)
                    DatePicker("Doğum tarihi", selection: $birthDate, displayedComponents: .date)
                    Picker("Cinsiyet", selection: $sex) {
                        ForEach(BabySex.allCases) { Text($0.rawValue).tag($0) }
                    }
                    TextField("Doğum kilosu (kg)", text: $birthWeight).keyboardType(.decimalPad)
                    TextField("Doğum boyu (cm)", text: $birthHeight).keyboardType(.decimalPad)
                }
                Section {
                    Button("BabyDay'e Başla") { createBaby() }
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("BabyDay")
        }
    }

    private func createBaby() {
        let weight = Double(birthWeight.replacingOccurrences(of: ",", with: ".")) ?? 3.53
        let height = Double(birthHeight.replacingOccurrences(of: ",", with: ".")) ?? 51
        modelContext.insert(BabyModel(name: name.isEmpty ? "Bebeğim" : name, birthDate: birthDate, birthWeightKg: weight, birthHeightCm: height, sex: sex))
        try? modelContext.save()
        completed = true
    }
}
