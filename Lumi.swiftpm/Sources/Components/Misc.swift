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
                    .frame(width: max(0, geo.size.width * progress))
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

/// Bottom sheet shown when tapping into a part of the app that isn't
/// built yet (lesson content, breathing, meditation, wardrobe, ...).
struct ComingSoonSheet: View {
    let title: String

    var body: some View {
        VStack(spacing: 14) {
            Capsule().fill(Color.white.opacity(0.15)).frame(width: 40, height: 5)
                .padding(.top, 10)
            Image(systemName: "hourglass")
                .font(.system(size: 36))
                .foregroundStyle(LumiGradient.primary)
                .padding(.top, 8)
            Text(title)
                .font(.lumi(18, weight: .heavy))
                .foregroundColor(.white)
            Text("Этот экран скоро появится в приложении.")
                .font(.lumi(13, weight: .semibold))
                .foregroundColor(LumiColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(LumiColor.bgDeep.ignoresSafeArea())
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.hidden)
    }
}
