import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var babies: [BabyModel]
    @AppStorage("babyday.onboardingComplete") private var completed = false
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if babies.isEmpty && !completed {
                OnboardingView()
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView().tag(0).tabItem { Label("Ana Sayfa", systemImage: "house.fill") }
                    HistoryView().tag(1).tabItem { Label("Geçmiş", systemImage: "chart.bar.fill") }
                    AddEventView().tag(2).tabItem { Label("Kayıt", systemImage: "plus.circle.fill") }
                    GrowthView().tag(3).tabItem { Label("Gelişim", systemImage: "leaf.fill") }
                    ProfileView().tag(4).tabItem { Label("Profil", systemImage: "person.crop.circle") }
                }
                .tint(.babyPurple)
            }
        }
    }
}
