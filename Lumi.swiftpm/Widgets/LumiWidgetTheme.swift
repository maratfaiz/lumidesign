import SwiftUI

// Duplicated from Sources/Theme.swift on purpose: the widget extension is a
// separate build target from AppModule and can't import its internal types.

extension Color {
    init(widgetHex hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

enum LumiWidgetColor {
    static let purple1 = Color(widgetHex: 0x8b6cf6)
    static let purple2 = Color(widgetHex: 0x6c4fe0)
    static let purpleLight = Color(widgetHex: 0xa58bff)
    static let purpleDeep = Color(widgetHex: 0x150f2c)
    static let purpleDeep2 = Color(widgetHex: 0x2a2154)

    static let orange1 = Color(widgetHex: 0xffb37a)
    static let orange2 = Color(widgetHex: 0xff7a4d)

    static let yellow = Color(widgetHex: 0xffd166)
    static let ink = Color.white
    static let inkDim = Color(widgetHex: 0x9c93c9)
}

enum LumiWidgetGradient {
    static let streakWarm = LinearGradient(
        colors: [LumiWidgetColor.orange1, LumiWidgetColor.orange2],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let streakPurple = LinearGradient(
        colors: [LumiWidgetColor.purpleLight, LumiWidgetColor.purple2],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let deep = RadialGradient(
        colors: [LumiWidgetColor.purpleDeep2, LumiWidgetColor.purpleDeep],
        center: UnitPoint(x: 1.0, y: 0.0),
        startRadius: 0,
        endRadius: 260
    )
}

extension Font {
    static func lumiWidget(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
