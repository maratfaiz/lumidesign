import SwiftUI

struct StreakStartView: View {
    @EnvironmentObject var app: AppState
    private let days = ["П", "В", "С", "Ч", "П", "С", "В"]

    var body: some View {
        ZStack {
            LumiBackground()
            StarField(stars: StarPresets.streakStart)

            VStack(spacing: 0) {
                Text("НОВАЯ СЕРИЯ")
                    .font(.lumi(12, weight: .heavy))
                    .foregroundColor(LumiColor.orange1)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(LumiColor.orange1.opacity(0.14)))
                    .overlay(Capsule().stroke(LumiColor.orange1.opacity(0.35), lineWidth: 1))
                    .padding(.top, 62)
                    .padding(.bottom, 22)

                (Text("Серия ").foregroundColor(.white) + Text("начата!").foregroundColor(LumiColor.orange1))
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .padding(.bottom, 26)

                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [LumiColor.orange1.opacity(0.32), .clear],
                                center: .center, startRadius: 0, endRadius: 79
                            )
                        )
                        .frame(width: 158, height: 158)
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 9)
                        .frame(width: 140, height: 140)
                    Circle()
                        .trim(from: 0, to: 0.86)
                        .stroke(LumiGradient.streak, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 28))
                            .foregroundColor(LumiColor.orange1)
                        Text("1")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 26)

                HStack(spacing: 7) {
                    ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                        Text(day)
                            .font(.lumi(11, weight: .heavy))
                            .foregroundColor(index == 0 ? .white : Color(hex: 0x5f5580))
                            .frame(width: 26, height: 26)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(index == 0 ? AnyShapeStyle(LumiGradient.streak) : AnyShapeStyle(Color.white.opacity(0.06)))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(index == 0 ? 0 : 0.1), lineWidth: 1)
                            )
                    }
                }
                .padding(.bottom, 24)

                Text("Каждый день практики продолжает её.\nПропуск не страшен — заморозка защитит серию.")
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(LumiColor.textBody)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Spacer()
                PrimaryButton(title: "Понятно, погнали!") { app.go(.home) }
            }
            .padding(20)
        }
    }
}
