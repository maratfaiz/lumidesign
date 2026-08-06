import SwiftUI

struct CardBackground: ViewModifier {
    var fill: Color = LumiColor.cardFill
    var border: Color = LumiColor.cardBorder
    var borderWidth: CGFloat = 1
    var radius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(fill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(border, lineWidth: borderWidth)
            )
    }
}

extension View {
    /// Translucent card look shared by most panels in the design
    /// (`background:rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.1)`).
    func lumiCard(
        fill: Color = LumiColor.cardFill,
        border: Color = LumiColor.cardBorder,
        borderWidth: CGFloat = 1,
        radius: CGFloat = 16
    ) -> some View {
        modifier(CardBackground(fill: fill, border: border, borderWidth: borderWidth, radius: radius))
    }
}

/// A tappable row used across the onboarding questionnaire screens —
/// icon + label, with a filled/bordered "selected" state and a checkmark badge.
struct SelectableOptionRow: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? LumiColor.purpleLight : LumiColor.textBody)
                    .frame(width: 20)
                Text(title)
                    .font(.lumi(13, weight: isSelected ? .bold : .semibold))
                    .foregroundColor(isSelected ? .white : LumiColor.textBody)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                if isSelected {
                    ZStack {
                        Circle().fill(LumiColor.purple1).frame(width: 20, height: 20)
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isSelected ? LumiColor.purple1.opacity(0.18) : Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(isSelected ? LumiColor.purple1 : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
        )
        .buttonStyle(.plain)
    }
}
