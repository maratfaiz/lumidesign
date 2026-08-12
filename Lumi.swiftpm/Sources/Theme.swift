import SwiftUI

extension Color {
    /// Creates a color from a 0xRRGGBB hex literal, matching the HTML prototype's CSS hex colors.
    init(hex: UInt32, opacity: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

enum LumiColor {
    static let bgDeep = Color(hex: 0x0b0a1a)
    static let bgGlow = Color(hex: 0x241a45)
    static let bgCard = Color(hex: 0x0d0b22)

    static let textPrimary = Color.white
    static let textSecondary = Color(hex: 0x9c93c9)
    static let textTertiary = Color(hex: 0x8a80b0)
    static let textBody = Color(hex: 0xc9c2e6)
    static let textFaint = Color(hex: 0x6b6285)
    static let textFaint2 = Color(hex: 0x7a7099)
    static let textDim = Color(hex: 0x6a6088)

    static let purple1 = Color(hex: 0x8b6cf6)
    static let purple2 = Color(hex: 0x6c4fe0)
    static let purpleLight = Color(hex: 0xc3b3ff)
    static let purpleLighter = Color(hex: 0xb39dff)

    static let danger = Color(hex: 0xff5a5a)
    static let orange1 = Color(hex: 0xffb37a)
    static let orange2 = Color(hex: 0xff7a4d)
    static let yellow = Color(hex: 0xffd166)
    static let blueChip = Color(hex: 0x8fc3ff)
    static let blueStrong = Color(hex: 0x5aaaff)

    static let cardFill = Color.white.opacity(0.06)
    static let cardFillLight = Color.white.opacity(0.05)
    static let cardBorder = Color.white.opacity(0.1)
    static let cardBorderStrong = Color.white.opacity(0.12)
}

enum LumiGradient {
    static let primary = LinearGradient(
        colors: [LumiColor.purple1, LumiColor.purple2],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let streak = LinearGradient(
        colors: [LumiColor.orange1, LumiColor.orange2],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let background = RadialGradient(
        colors: [LumiColor.bgGlow, LumiColor.bgDeep],
        center: UnitPoint(x: 0.2, y: 0.0),
        startRadius: 0,
        endRadius: 520
    )
}

extension Font {
    /// Rounded system font standing in for the prototype's Nunito typeface.
    static func lumi(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

struct LumiBackground: View {
    var body: some View {
        LumiGradient.background
            .ignoresSafeArea()
    }
}
