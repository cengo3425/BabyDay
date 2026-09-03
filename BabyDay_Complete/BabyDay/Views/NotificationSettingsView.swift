import SwiftUI

struct NotificationSettingsView: View {
    @StateObject private var manager = NotificationManager.shared
    @AppStorage("babyday.reminders.enabled") private var remindersEnabled = false
    @AppStorage("babyday.reminders.hour") private var reminderHour = 20
    @AppStorage("babyday.reminders.minute") private var reminderMinute = 0

    var body: some View {
        Form {
            Section("Günlük hatırlatma") {
                Toggle("Günlük kayıt hatırlatması", isOn: $remindersEnabled)
                    .onChange(of: remindersEnabled) { _, enabled in
                        Task {
                            if enabled {
                                await manager.scheduleDailyReminder(
                                    hour: reminderHour,
                                    minute: reminderMinute,
                                    title: "BabyDay 💜",
                                    body: "Bugünün kayıtlarını eklemeyi unutma."
                                )
                            } else {
                                manager.cancelDailyReminder()
                            }
                        }
                    }

                DatePicker(
                    "Hatırlatma saati",
                    selection: reminderDate,
                    displayedComponents: .hourAndMinute
                )
                .disabled(!remindersEnabled)
                .onChange(of: reminderHour) { _, _ in rescheduleIfNeeded() }
                .onChange(of: reminderMinute) { _, _ in rescheduleIfNeeded() }
            }

            Section {
                HStack {
                    Text("Bildirim izni")
                    Spacer()
                    Text(manager.authorized ? "Açık" : "Kapalı")
                        .foregroundStyle(manager.authorized ? .green : .secondary)
                }

                if !manager.authorized {
                    Button("Bildirimlere izin ver") {
                        Task { _ = await manager.requestPermission() }
                    }
                }
            }

            Section {
                Text("Hatırlatmalar cihaz üzerinde yerel olarak planlanır. Bildirimlerin gösterilmesi iOS bildirim ayarlarına bağlıdır.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Bildirimler")
        .task {
            await manager.refreshStatus()
        }
    }

    private var reminderDate: Binding<Date> {
        Binding(
            get: {
                Calendar.current.date(
                    bySettingHour: reminderHour,
                    minute: reminderMinute,
                    second: 0,
                    of: .now
                ) ?? .now
            },
            set: { value in
                let c = Calendar.current.dateComponents([.hour, .minute], from: value)
                reminderHour = c.hour ?? 20
                reminderMinute = c.minute ?? 0
                rescheduleIfNeeded()
            }
        )
    }

    private func rescheduleIfNeeded() {
        guard remindersEnabled else { return }
        Task {
            await manager.scheduleDailyReminder(
                hour: reminderHour,
                minute: reminderMinute,
                title: "BabyDay 💜",
                body: "Bugünün kayıtlarını eklemeyi unutma."
            )
        }
    }
}
