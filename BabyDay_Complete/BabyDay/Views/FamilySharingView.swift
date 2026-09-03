import SwiftUI
import CloudKit

struct FamilySharingView: View {
    @StateObject private var manager = FamilySharingManager.shared
    @State private var showingInfo = false

    var body: some View {
        Form {
            Section("Aile paylaşımı") {
                Label("Ortak bebek günlüğü", systemImage: "person.2.fill")
                    .font(.headline)

                Text("Eşin veya başka bir bakıcıyla BabyDay kayıtlarını paylaşmak için iCloud üzerinden özel bir paylaşım oluşturabilirsin.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Durum") {
                HStack {
                    Text("iCloud")
                    Spacer()
                    Text(manager.isICloudAvailable ? "Hazır" : "Kontrol ediliyor")
                        .foregroundStyle(manager.isICloudAvailable ? .green : .secondary)
                }

                Button("iCloud durumunu kontrol et") {
                    Task { await manager.refreshAccountStatus() }
                }
            }

            Section {
                Button {
                    showingInfo = true
                } label: {
                    Label("Ebeveyn daveti nasıl çalışır?", systemImage: "questionmark.circle")
                }
            }
        }
        .navigationTitle("Aile Paylaşımı")
        .task {
            await manager.refreshAccountStatus()
        }
        .alert("BabyDay aile paylaşımı", isPresented: $showingInfo) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text("Paylaşım, iCloud hesabı üzerinden özel CloudKit paylaşımı olarak tasarlanır. Davet edilen kişi kabul ettiğinde paylaşılan kayıtlar kendi cihazındaki paylaşılan veritabanında görünür.")
        }
    }
}
