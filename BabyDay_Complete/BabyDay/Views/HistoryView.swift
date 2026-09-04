import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context

    @Query(
        sort: \BabyEventModel.date,
        order: .reverse
    )
    private var events: [BabyEventModel]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                List {
                    Section {
                        HStack {
                            Text("Bugünün kayıtları")
                                .font(.headline)

                            Spacer()

                            Text("\(today.count)")
                                .font(.headline)
                                .foregroundStyle(Color.purple)
                        }
                    }

                    Section("Zaman Akışı") {
                        ForEach(events) { event in
                            EventRow(event: event)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: delete)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Geçmiş")
        }
    }

    private var today: [BabyEventModel] {
        events.filter {
            Calendar.current.isDateInToday($0.date)
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(events[index])
        }

        try? context.save()
    }
}
