import SwiftUI

/// Big gradient CTA button, matches the prototype's
/// `linear-gradient(135deg,#8b6cf6,#6c4fe0)` pill buttons.
struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(.lumi(15, weight: .heavy))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .foregroundColor(isEnabled ? .white : LumiColor.textDim)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isEnabled ? AnyShapeStyle(LumiGradient.primary) : AnyShapeStyle(Color.white.opacity(0.08)))
        )
        .shadow(color: isEnabled ? LumiColor.purple2.opacity(0.45) : .clear, radius: 14, y: 8)
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

/// White pill button used for "Войти с Apple".
struct AppleSignInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "apple.logo")
                Text("Войти с Apple")
            }
            .font(.lumi(16, weight: .heavy))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white))
        .buttonStyle(.plain)
    }
}

/// Plain text link button, e.g. "Понятно, продолжить".
struct TextLinkButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.lumi(13, weight: .bold))
                .foregroundColor(LumiColor.textSecondary)
                .padding(12)
        }
        .buttonStyle(.plain)
    }
}
