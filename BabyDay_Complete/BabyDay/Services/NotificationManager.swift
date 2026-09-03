import Foundation
import UserNotifications

@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published private(set) var authorized = false

    private let center = UNUserNotificationCenter.current()

    func refreshStatus() async {
        let settings = await center.notificationSettings()
        authorized = settings.authorizationStatus == .authorized ||
                     settings.authorizationStatus == .provisional
    }

    func requestPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            await refreshStatus()
            return granted
        } catch {
            await refreshStatus()
            return false
        }
    }

    func scheduleDailyReminder(hour: Int, minute: Int, title: String, body: String) async {
        guard await ensurePermission() else { return }

        center.removePendingNotificationRequests(
            withIdentifiers: ["babyday.daily.reminder"]
        )

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "babyday.daily.reminder",
            content: content,
            trigger: trigger
        )

        try? await center.add(request)
    }

    func cancelDailyReminder() {
        center.removePendingNotificationRequests(
            withIdentifiers: ["babyday.daily.reminder"]
        )
    }

    private func ensurePermission() async -> Bool {
        let settings = await center.notificationSettings()

        if settings.authorizationStatus == .authorized ||
           settings.authorizationStatus == .provisional {
            authorized = true
            return true
        }

        if settings.authorizationStatus == .notDetermined {
            return await requestPermission()
        }

        return false
    }
}
