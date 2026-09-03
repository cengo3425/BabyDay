import SwiftUI
import SwiftData

@main
struct BabyDayApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { await NotificationManager.shared.refreshStatus() }
        }
        .modelContainer(for: [
            BabyModel.self,
            BabyEventModel.self,
            GrowthMeasurementModel.self
        ])
    }
}
