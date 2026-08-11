import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// A custom UI icon from the Phosphor set (Assets.xcassets, imageset name
/// e.g. "icon-streak"), rendered as a template so `.foregroundColor(...)`
/// tints it exactly like the `Image(systemName:)` calls it replaces. Falls
/// back to an SF Symbol if the named asset isn't in the catalog yet, same
/// safety net as `MascotPlaceholder`.
struct LumiIcon: View {
    var name: String
    var size: CGFloat = 20
    var fallbackSystemImage: String = "questionmark"

    private var isAvailable: Bool {
        #if canImport(UIKit)
        return UIImage(named: name) != nil
        #else
        return false
        #endif
    }

    var body: some View {
        if isAvailable {
            Image(name)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            Image(systemName: fallbackSystemImage)
                .font(.system(size: size * 0.82, weight: .semibold))
                .frame(width: size, height: size)
        }
    }
}
