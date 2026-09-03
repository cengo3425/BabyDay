import SwiftUI

struct ReminderSettingsView: View {
    @AppStorage("reminder.feeding") private var feeding = false
    @AppStorage("reminder.sleep") private var sleep = false
    @AppStorage("reminder.diaper") private var diaper = false
    var body: some View {
        Form {
            Section("Hatırlatmalar") {
                Toggle("Beslenme", isOn: $feeding)
                Toggle("Uyku", isOn: $sleep)
                Toggle("Bez değişimi", isOn: $diaper)
            }
            Section {
                Text("Hatırlatmaların çalışması için Bildirimler iznini açık tutun.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Hatırlatmalar")
    }
}

struct PrivacySettingsView: View {
    @State private var showDeleteAlert = false
    var body: some View {
        Form {
            Section("Veri") {
                Label("Kayıtlar cihazında SwiftData ile tutulur.", systemImage: "internaldrive")
                Label("Aile paylaşımı yalnızca açıkça oluşturduğun paylaşım üzerinden çalışır.", systemImage: "person.2")
                Label("BabyDay tıbbi tanı veya tedavi önerisi vermez.", systemImage: "cross.case")
            }
            Section("Hesap") {
                Button(role: .destructive) { showDeleteAlert = true } label: {
                    Label("Tüm yerel verileri sil", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Veri ve Gizlilik")
        .alert("Yerel veriler silinsin mi?", isPresented: $showDeleteAlert) {
            Button("İptal", role: .cancel) {}
            Button("Sil", role: .destructive) {
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "com.babyday.app")
            }
        } message: {
            Text("Bu işlem ayarları sıfırlar. SwiftData kayıtlarının silinmesi için uygulama verilerini cihazdan kaldırıp yeniden yüklemek gerekir.")
        }
    }
}

struct BackupSettingsView: View {
    var body: some View {
        Form {
            Section("iCloud") {
                Label("iCloud / CloudKit altyapısı hazır.", systemImage: "checkmark.icloud")
                Text("Gerçek cihaz senkronizasyonu için Xcode'da iCloud capability ve iCloud.com.babyday.app container'ı etkinleştirilmelidir.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Yedekleme")
    }
}

struct AboutView: View {
    var body: some View {
        Form {
            Section("BabyDay") {
                LabeledContent("Sürüm", value: "1.0.0")
                Text("Bebeğinin her anı, hep yanında.")
                    .font(.headline)
            }
            Section("Güvenlik") {
                Text("BabyDay takip amaçlıdır ve sağlık profesyonelinin değerlendirmesinin yerine geçmez.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Hakkında")
    }
}
