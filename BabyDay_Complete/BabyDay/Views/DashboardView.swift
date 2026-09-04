import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var context

    @Query(
        sort: \BabyEventModel.date,
        order: .reverse
    )
    private var events: [BabyEventModel]

    @Query
    private var babies: [BabyModel]

    private var baby: BabyModel? {
        babies.first
    }

    private var todayEvents: [BabyEventModel] {
        events.filter {
            Calendar.current.isDateInToday($0.date)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: 18
                    ) {
                        header
                        summary
                        quickAdd
                        recent
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .task {
                seedIfNeeded()
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(Color.babyLavender)
                .frame(
                    width: 58,
                    height: 58
                )
                .overlay {
                    Image(
                        systemName: "face.smiling.fill"
                    )
                    .font(.title2)
                    .foregroundStyle(Color.babyPurple)
                }

            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                Text("Günaydın ☀️")
                    .font(.headline)
                    .foregroundStyle(Color.secondary)

                Text(baby?.name ?? "Bebeğim")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.babyInk)
            }

            Spacer()
        }
    }

    // MARK: - Summary

    private var summary: some View {
        BabyCard {
            VStack(
                alignment: .leading,
                spacing: 14
            ) {
                HStack {
                    BabySectionTitle(
                        title: "Bugünün Özeti",
                        subtitle: nil
                    )

                    Spacer()

                    Text(
                        Date.now,
                        format: .dateTime
                            .day()
                            .month(.wide)
                    )
                    .font(.caption.bold())
                    .foregroundStyle(Color.babyPurple)
                }

                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 10
                ) {
                    SummaryCard(
                        title: "Beslenme",
                        value: "\(count(.feeding)) kez",
                        icon: EventType.feeding.icon,
                        color: Color.babyPurple
                    )

                    SummaryCard(
                        title: "Uyku",
                        value: "\(count(.sleep)) kayıt",
                        icon: EventType.sleep.icon,
                        color: Color.blue
                    )

                    SummaryCard(
                        title: "Bez",
                        value: "\(count(.diaper)) kez",
                        icon: EventType.diaper.icon,
                        color: Color.babyMint
                    )

                    SummaryCard(
                        title: "Kaka",
                        value: "\(count(.stool)) kez",
                        icon: EventType.stool.icon,
                        color: Color.babyPeach
                    )
                }
            }
        }
    }

    // MARK: - Quick Add

    private var quickAdd: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            BabySectionTitle(
                title: "Kayıt Ekle",
                subtitle: "Bebeğinin yaptığı şeyi tek dokunuşla kaydet."
            )

            HStack(spacing: 10) {
                ForEach(EventType.allCases) { type in
                    NavigationLink {
                        AddEventView(
                            initialType: type
                        )
                    } label: {
                        VStack(spacing: 8) {
                            Image(
                                systemName: type.icon
                            )
                            .font(.title3)

                            Text(type.rawValue)
                                .font(.caption2.bold())
                        }
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(.vertical, 12)
                        .background(
                            type.tint.opacity(0.12),
                            in: RoundedRectangle(
                                cornerRadius: 16,
                                style: .continuous
                            )
                        )
                        .foregroundStyle(type.tint)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Recent Events

    private var recent: some View {
        BabyCard {
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                HStack {
                    BabySectionTitle(
                        title: "Son Kayıtlar",
                        subtitle: nil
                    )

                    Spacer()

                    NavigationLink("Tümünü Gör") {
                        HistoryView()
                    }
                    .font(.caption.bold())
                    .foregroundStyle(Color.babyPurple)
                }

                if events.isEmpty {
                    Text("Henüz kayıt bulunmuyor.")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                        .padding(.vertical, 10)
                } else {
                    ForEach(
                        Array(events.prefix(5))
                    ) { event in
                        EventRow(event: event)
                    }
                }
            }
        }
    }

    // MARK: - Count

    private func count(
        _ type: EventType
    ) -> Int {
        todayEvents.filter {
            $0.type == type
        }.count
    }

    // MARK: - Seed

    private func seedIfNeeded() {
        guard babies.isEmpty else {
            return
        }

        let baby = BabyModel(
            name: "Duru Arya",
            birthDate:
                Calendar.current.date(
                    byAdding: .month,
                    value: -3,
                    to: .now
                ) ?? .now,
            birthWeightKg: 3.53,
            birthHeightCm: 51,
            sex: .girl
        )

        context.insert(baby)

        if events.isEmpty {
            context.insert(
                BabyEventModel(
                    type: .feeding,
                    detail: "Anne sütü (Sağ) • 15 dakika"
                )
            )

            context.insert(
                BabyEventModel(
                    type: .diaper,
                    detail: "Çiş"
                )
            )
        }

        do {
            try context.save()
        } catch {
            print(
                "BabyDay başlangıç verisi kaydetme hatası: \(error)"
            )
        }
    }
}

// MARK: - Summary Card

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Image(systemName: icon)
                .font(.title3)

            Text(title)
                .font(.caption)
                .foregroundStyle(Color.secondary)

            Text(value)
                .font(.headline)
                .foregroundStyle(Color.babyInk)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(12)
        .background(
            color.opacity(0.09),
            in: RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
        .foregroundStyle(color)
    }
}

// MARK: - Event Row

struct EventRow: View {
    let event: BabyEventModel

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(
                    event.type.tint.opacity(0.12)
                )
                .frame(
                    width: 42,
                    height: 42
                )
                .overlay {
                    Image(
                        systemName: event.type.icon
                    )
                    .foregroundStyle(
                        event.type.tint
                    )
                }

            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                Text(event.type.rawValue)
                    .font(.subheadline.bold())

                Text(event.detail)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }

            Spacer()

            Text(
                event.date,
                style: .time
            )
            .font(.caption)
            .foregroundStyle(Color.secondary)
        }
        .padding(.vertical, 7)
    }
}
