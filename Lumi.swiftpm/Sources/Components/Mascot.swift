import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Renders real Lumi artwork when it's been added to the asset catalog;
/// otherwise falls back to a soft glow + gradient disc with an SF Symbol,
/// sized like the `<image-slot>` mascot images in the original prototype.
struct MascotPlaceholder: View {
    var size: CGFloat = 150
    var systemImage: String = "sparkles"
    /// Asset catalog name for real Lumi artwork (e.g. "mascot-splash"). When the
    /// named image isn't in the catalog yet, falls back to the gradient placeholder.
    var assetName: String? = nil

    private var resolvedImage: Image? {
        guard let assetName else { return nil }
        #if canImport(UIKit)
        guard UIImage(named: assetName) != nil else { return nil }
        return Image(assetName)
        #else
        return nil
        #endif
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [LumiColor.purple1.opacity(0.35), LumiColor.purple1.opacity(0)],
                        center: .center, startRadius: 0, endRadius: size / 2
                    )
                )
            if let resolvedImage {
                resolvedImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else {
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
        }
        .frame(width: size, height: size)
    }
}
