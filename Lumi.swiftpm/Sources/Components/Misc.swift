import SwiftUI

/// Thin fill bar used by splash's loading indicator.
struct ProgressBarView: View {
    /// 0...1
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.1))
                RoundedRectangle(cornerRadius: 4)
                    .fill(LumiGradient.primary)
                    .frame(width: max(0, geo.size.width * CGFloat(progress)))
            }
        }
    }
}

/// Segmented step indicator at the top of each onboarding screen.
struct StepProgressBar: View {
    let total: Int
    let current: Int // 1-based

    var body: some View {
        HStack(spacing: 5) {
            ForEach(1...total, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(i <= current ? AnyShapeStyle(LumiGradient.primary) : AnyShapeStyle(Color.white.opacity(0.12)))
                    .frame(height: 4)
            }
        }
    }
}

struct OnboardingHeader: View {
    let step: Int
    let total: Int

    var body: some View {
        HStack(spacing: 12) {
            Text("\(step) / \(total)")
                .font(.lumi(11, weight: .bold))
                .foregroundColor(LumiColor.textSecondary)
            StepProgressBar(total: total, current: step)
        }
    }
}

/// 1...5 rating selector used on the first onboarding question.
struct RatingCircle: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.lumi(15, weight: .heavy))
                .foregroundColor(isSelected ? .white : LumiColor.textBody)
                .frame(width: 44, height: 44)
        }
        .background(
            Circle().fill(isSelected ? AnyShapeStyle(LumiGradient.primary) : AnyShapeStyle(Color.white.opacity(0.06)))
        )
        .overlay(Circle().stroke(Color.white.opacity(isSelected ? 0 : 0.12), lineWidth: 1))
        .shadow(color: isSelected ? LumiColor.purple2.opacity(0.5) : .clear, radius: 10, y: 4)
        .buttonStyle(.plain)
    }
}

/// Shared chrome for every screen reached by drilling in from Home/Catalog/Profile —
/// background, an optional "←" back button (matching the prototype's `showBack`
/// rule), and 20pt content padding.
struct DetailScreen<Content: View>: View {
    @EnvironmentObject var app: AppState
    var showBack: Bool
    var showStars: Bool
    var content: Content

    init(showBack: Bool = true, showStars: Bool = false, @ViewBuilder content: () -> Content) {
        self.showBack = showBack
        self.showStars = showStars
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            LumiBackground()
            if showStars {
                StarField(stars: StarPresets.planLoading)
            }
            VStack(alignment: .leading, spacing: 0) {
                if showBack {
                    Button { app.goBack() } label: {
                        Text("←")
                            .font(.lumi(15, weight: .bold))
                            .foregroundColor(LumiColor.textBody)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 2)
                }
                // A GeometryReader-sized min-height keeps Spacer()-based centering
                // working for short screens while still scrolling ones that overflow,
                // matching the prototype's `overflow-y:auto` content area.
                GeometryReader { geo in
                    ScrollView {
                        content
                            .padding(.horizontal, 20)
                            .padding(.top, 14)
                            .padding(.bottom, 20)
                            .frame(minHeight: geo.size.height)
                    }
                }
            }
        }
    }
}

/// Small pill-style toggle button used on breathing/affirmation/meditation
/// control rows (repeat, sound, speed, info…).
struct ControlPillButton: View {
    let icon: String
    let label: String
    var isActive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                if icon.hasPrefix("icon-") {
                    LumiIcon(name: icon, size: 14)
                } else {
                    Image(systemName: icon).font(.system(size: 14, weight: .semibold))
                }
                Text(label).font(.lumi(10, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
        }
        .foregroundColor(isActive ? LumiColor.purpleLight : LumiColor.textTertiary)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isActive ? LumiColor.purple1.opacity(0.16) : Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isActive ? LumiColor.purple1.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
        )
        .buttonStyle(.plain)
    }
}

/// Circular transport-control button (play/pause, prev/next) used by the
/// breathing/affirmations/meditation screens.
struct TransportButton: View {
    let systemImage: String
    var size: CGFloat = 52
    var prominent: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundColor(prominent ? .white : LumiColor.textBody)
                .frame(width: size, height: size)
        }
        .background(
            Circle().fill(prominent ? AnyShapeStyle(LumiGradient.primary) : AnyShapeStyle(Color.white.opacity(0.06)))
        )
        .overlay(Circle().stroke(Color.white.opacity(prominent ? 0 : 0.12), lineWidth: 1))
        .shadow(color: prominent ? LumiColor.purple1.opacity(0.4) : .clear, radius: 10, y: 4)
        .buttonStyle(.plain)
    }
}
