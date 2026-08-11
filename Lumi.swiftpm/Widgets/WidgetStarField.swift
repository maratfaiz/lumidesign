import SwiftUI

/// Static counterpart to Sources/Components/Stars.swift's StarField — widgets
/// render frozen snapshots, so this skips the repeatForever twinkle animation
/// and just places the same "sparkle" dots at fixed opacities.
struct WidgetStarSpec {
    let size: CGFloat
    let color: Color
    let x: CGFloat // fraction of width
    let y: CGFloat // fraction of height
    let opacity: Double
}

struct WidgetStarField: View {
    let stars: [WidgetStarSpec]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(Array(stars.enumerated()), id: \.offset) { _, star in
                    Image(systemName: "sparkle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: star.size, height: star.size)
                        .foregroundStyle(star.color)
                        .opacity(star.opacity)
                        .position(x: geo.size.width * star.x, y: geo.size.height * star.y)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

enum WidgetStarPresets {
    // Kept clear of the bottom/top-trailing mascot corner in each layout.
    static let mediumDeep: [WidgetStarSpec] = [
        .init(size: 11, color: LumiWidgetColor.purple1, x: 0.08, y: 0.16, opacity: 0.5),
        .init(size: 7, color: .white, x: 0.32, y: 0.82, opacity: 0.3),
        .init(size: 8, color: LumiWidgetColor.purpleLight, x: 0.05, y: 0.58, opacity: 0.4),
        .init(size: 6, color: .white, x: 0.20, y: 0.10, opacity: 0.32),
    ]

    static let smallDeep: [WidgetStarSpec] = [
        .init(size: 9, color: LumiWidgetColor.purple1, x: 0.16, y: 0.10, opacity: 0.5),
        .init(size: 6, color: .white, x: 0.08, y: 0.46, opacity: 0.32),
        .init(size: 7, color: LumiWidgetColor.purpleLight, x: 0.22, y: 0.86, opacity: 0.36),
    ]
}
