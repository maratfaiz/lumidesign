import SwiftUI
import UIKit

/// Widget-target counterpart to Sources/Components/LumiIcon.swift: renders
/// one of the app's own asset-catalog icons (streak/freeze/lumen/stats),
/// template-tinted to `color`, falling back to the matching SF Symbol if
/// the asset isn't present (e.g. its target membership wasn't added yet —
/// see Widgets/README.md step 3).
struct WidgetIcon: View {
    var name: String
    var systemFallback: String
    var size: CGFloat
    var color: Color

    private var isAvailable: Bool { UIImage(named: name) != nil }

    var body: some View {
        if isAvailable {
            Image(name)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(color)
        } else {
            Image(systemName: systemFallback)
                .font(.system(size: size * 0.82, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: size, height: size)
        }
    }
}
