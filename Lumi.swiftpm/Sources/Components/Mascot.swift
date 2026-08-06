import SwiftUI

/// Stand-in for Lumi the mascot until real artwork is provided.
/// A soft glow + gradient disc with an SF Symbol, sized like the
/// `<image-slot>` mascot images in the original prototype.
struct MascotPlaceholder: View {
    var size: CGFloat = 150
    var systemImage: String = "sparkles"

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [LumiColor.purple1.opacity(0.35), LumiColor.purple1.opacity(0)],
                        center: .center, startRadius: 0, endRadius: size / 2
                    )
                )
            Circle()
                .fill(LumiGradient.primary.opacity(0.18))
                .frame(width: size * 0.72, height: size * 0.72)
            Circle()
                .strokeBorder(LumiColor.purple1.opacity(0.35), lineWidth: 1.5)
                .frame(width: size * 0.72, height: size * 0.72)
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.34, height: size * 0.34)
                .foregroundStyle(LumiGradient.primary)
        }
        .frame(width: size, height: size)
    }
}
