import SwiftUI

// MARK: - BabyDay Colors

extension Color {

    static let babyPurple = Color(
        red: 0.46,
        green: 0.29,
        blue: 0.88
    )

    static let babyLavender = Color(
        red: 0.95,
        green: 0.92,
        blue: 1.00
    )

    static let babyInk = Color(
        red: 0.10,
        green: 0.15,
        blue: 0.25
    )

    static let babyMint = Color(
        red: 0.25,
        green: 0.72,
        blue: 0.62
    )

    static let babyPeach = Color(
        red: 1.00,
        green: 0.65,
        blue: 0.30
    )

    static let babyPink = Color(
        red: 0.96,
        green: 0.42,
        blue: 0.62
    )
}

// MARK: - BabyDay Card

struct BabyCard<Content: View>: View {

    let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(
                Color.white.opacity(0.96),
                in: RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
            )
            .shadow(
                color: Color.black.opacity(0.04),
                radius: 12,
                x: 0,
                y: 4
            )
    }
}

// MARK: - BabyDay Section Title

struct BabySectionTitle: View {

    let title: String
    let subtitle: String?

    init(
        title: String,
        subtitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(Color.babyInk)

            if let subtitle = subtitle,
               !subtitle.isEmpty {

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
        }
    }
}
