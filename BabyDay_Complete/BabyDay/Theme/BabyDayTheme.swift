import SwiftUI

extension Color {
    static let babyPurple = Color(red: 0.46, green: 0.29, blue: 0.88)
    static let babyLavender = Color(red: 0.95, green: 0.92, blue: 1.0)
    static let babyInk = Color(red: 0.10, green: 0.15, blue: 0.25)
    static let babyMint = Color(red: 0.25, green: 0.72, blue: 0.62)
    static let babyPeach = Color(red: 1.0, green: 0.65, blue: 0.30)
    static let babyPink = Color(red: 0.96, green: 0.42, blue: 0.62)
}

struct BabyCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(.white.opacity(0.96), in: RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.04), radius: 12, y: 4)
    }
}

struct BabySectionTitle: View {
    let title: String
    let subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.babyInk)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
