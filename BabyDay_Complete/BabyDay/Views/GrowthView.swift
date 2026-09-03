import SwiftUI
import SwiftData

struct GrowthView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \GrowthMeasurementModel.date, order: .reverse) private var measurements: [GrowthMeasurementModel]
    @Query private var babies: [BabyModel]

    @State private var showingAdd = false

    private var baby: BabyModel? { babies.first }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        BabySectionTitle(
                            title: "Gelişim",
                            subtitle: "\(baby?.name ?? "Bebeğim")'in ölçümlerini takip et 💜"
                        )

                        HStack(spacing: 10) {
                            Metric(title: "Son kilo", value: latestWeight)
                            Metric(title: "Son boy", value: latestHeight)
                        }

                        BabyCard {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    Text("Kilo Gelişimi").font(.title3.bold())
                                    Spacer()
                                    Text("\(measurements.count) ölçüm")
                                        .font(.caption.bold())
                                        .foregroundStyle(.babyPurple)
                                }

                                GrowthChart(measurements: measurements)
                                    .frame(height: 230)
                            }
                        }

                        BabyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Son Ölçümler").font(.title3.bold())
                                    Spacer()
                                    Button("Ekle") { showingAdd = true }
                                        .font(.caption.bold())
                                        .foregroundStyle(.babyPurple)
                                }

                                if measurements.isEmpty {
                                    Text("Henüz ölçüm yok. İlk kilo ve boy ölçümünü ekleyelim.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } else {
                                    ForEach(measurements.prefix(5)) { measurement in
                                        MeasurementRow(measurement: measurement)
                                    }
                                }
                            }
                        }

                        BabyCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Label(WHOGrowthStandard.sourceName, systemImage: "checkmark.seal.fill")
                                    .font(.headline)
                                    .foregroundStyle(.babyPurple)
                                Text("BabyDay, yaş ve cinsiyete göre resmi WHO büyüme standartlarıyla karşılaştırma yapacak şekilde tasarlanıyor.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Text("Not: Gelişim ekranındaki veriler takip amaçlıdır; tıbbi değerlendirme yerine geçmez.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.babyPurple)
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddGrowthMeasurementView()
            }
        }
    }

    private var latestWeight: String {
        guard let value = measurements.first?.weightKg else { return "—" }
        return String(format: "%.2f kg", value)
    }

    private var latestHeight: String {
        guard let value = measurements.first?.heightCm else { return "—" }
        return String(format: "%.1f cm", value)
    }
}

struct GrowthChart: View {
    let measurements: [GrowthMeasurementModel]

    var body: some View {
        GeometryReader { geo in
            let points = measurements
                .filter { $0.weightKg != nil }
                .reversed()
                .compactMap { $0.weightKg }

            if points.count >= 2,
               let min = points.min(),
               let max = points.max() {
                let range = max == min ? 1 : max - min

                Path { path in
                    for (index, value) in points.enumerated() {
                        let x = CGFloat(index) / CGFloat(max(points.count - 1, 1)) * geo.size.width
                        let y = geo.size.height - CGFloat((value - min) / range) * (geo.size.height - 20) - 10

                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(.babyPurple, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))

                Text(String(format: "%.2f kg", max))
                    .font(.caption2.bold())
                    .foregroundStyle(.babyPurple)
                    .position(x: 45, y: 10)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 46))
                        .foregroundStyle(.babyPurple)
                    Text("En az iki kilo ölçümü ekleyince grafik burada oluşacak.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.babyLavender, in: RoundedRectangle(cornerRadius: 18))
            }
        }
    }
}

struct MeasurementRow: View {
    let measurement: GrowthMeasurementModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(measurement.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline.bold())
                Text(details)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }

    private var details: String {
        var values: [String] = []
        if let weightKg = measurement.weightKg {
            values.append(String(format: "Kilo %.2f kg", weightKg))
        }
        if let heightCm = measurement.heightCm {
            values.append(String(format: "Boy %.1f cm", heightCm))
        }
        if let head = measurement.headCircumferenceCm {
            values.append(String(format: "Baş %.1f cm", head))
        }
        return values.joined(separator: " • ")
    }
}

struct AddGrowthMeasurementView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var date = Date()
    @State private var weightText = ""
    @State private var heightText = ""
    @State private var headText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Ölçüm tarihi") {
                    DatePicker("Tarih", selection: $date, displayedComponents: .date)
                }

                Section("Ölçümler") {
                    TextField("Kilo (kg)", text: $weightText)
                        .keyboardType(.decimalPad)
                    TextField("Boy (cm)", text: $heightText)
                        .keyboardType(.decimalPad)
                    TextField("Baş çevresi (cm)", text: $headText)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button("Ölçümü Kaydet") {
                        save()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Ölçüm Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }

    private func number(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }

    private func save() {
        let measurement = GrowthMeasurementModel(
            date: date,
            weightKg: number(weightText),
            heightCm: number(heightText),
            headCircumferenceCm: number(headText)
        )

        context.insert(measurement)
        try? context.save()
        dismiss()
    }
}

struct Metric: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.headline).foregroundStyle(.babyInk)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
    }
}
