import SwiftUI
import SwiftData
import StoreKit

struct ProfileView: View {
    @Query private var babies: [BabyModel]
    @StateObject private var premium = PremiumStore()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        BabyCard {
                            HStack(spacing: 14) {
                                Circle()
                                    .fill(.babyLavender)
                                    .frame(width: 70, height: 70)
                                    .overlay(Image(systemName: "face.smiling.fill").font(.title).foregroundStyle(.babyPurple))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(babies.first?.name ?? "Bebeğim")
                                        .font(.title2.bold())
                                    Text("\(babies.first?.sex.rawValue ?? "Kız") • Bebek profili")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                        }

                        BabyCard {
                            VStack(alignment: .leading, spacing: 4) {
                                Label("Ebeveyn Paylaşımı", systemImage: "person.2.fill")
                                    .font(.headline)
                                Text("İlerleyen sürümde eş veya bakıcı davet edilebilecek.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        BabyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "crown.fill").foregroundStyle(.orange)
                                    Text("BabyDay Premium").font(.headline)
                                    Spacer()
                                }
                                Text("Detaylı analizler, gelişim raporları ve sınırsız kayıt.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Text("49 TL / ay")
                                    .font(.title2.bold())
                                    .foregroundStyle(.babyPurple)

                                Button {
                                    Task { await premium.purchase() }
                                } label: {
                                    Text(premium.isPremium ? "Premium Aktif" : (premium.product?.displayPrice ?? "49 TL / ay"))
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.babyPurple)
                                .disabled(premium.isPremium)
                            }
                        }

                        BabyCard {
                            VStack(alignment: .leading, spacing: 18) {
                                NavigationLink { NotificationSettingsView() } label: { SettingRow(icon: "bell.fill", title: "Bildirimler") }
                                NavigationLink { FamilySharingView() } label: { SettingRow(icon: "person.2.fill", title: "Aile Paylaşımı") }
                                NavigationLink { ReminderSettingsView() } label: { SettingRow(icon: "clock.fill", title: "Hatırlatmalar") }
                                NavigationLink { PrivacySettingsView() } label: { SettingRow(icon: "lock.fill", title: "Veri ve Gizlilik") }
                                NavigationLink { BackupSettingsView() } label: { SettingRow(icon: "icloud.fill", title: "Yedekleme ve Senkronizasyon") }
                                NavigationLink { AboutView() } label: { SettingRow(icon: "info.circle.fill", title: "Hakkında") }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Profil")
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 28)
                .foregroundStyle(.babyPurple)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
