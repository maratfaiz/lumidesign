import SwiftUI

struct PlanReadyView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        ZStack {
            LumiBackground()
            StarField(stars: StarPresets.planReady)

            VStack(spacing: 0) {
                MascotPlaceholder(size: 210, systemImage: "flag.fill", assetName: "mascot-obtrack")
                    .padding(.top, 20)
                    .padding(.bottom, 22)

                Text("Твой персональный план готов!")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)

                Text("Мы нашли курс, который поможет тебе чувствовать себя увереннее и поддержит на этом пути")
                    .font(.lumi(14, weight: .semibold))
                    .foregroundColor(LumiColor.textBody)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)

                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(LumiColor.purple1.opacity(0.25)).frame(width: 40, height: 40)
                        Image(systemName: "star.fill").foregroundColor(LumiColor.purpleLight)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("СТАРТОВЫЙ КУРС")
                            .font(.lumi(10, weight: .bold))
                            .foregroundColor(LumiColor.textTertiary)
                        Text("Внутренний критик · 5 уроков")
                            .font(.lumi(15, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(14)
                .lumiCard()
                .padding(.bottom, 12)

                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)).frame(width: 40, height: 40)
                        Image(systemName: "checkmark").foregroundColor(LumiColor.textBody)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("ТВОЙ ПЕРВЫЙ УРОК")
                            .font(.lumi(10, weight: .bold))
                            .foregroundColor(LumiColor.textTertiary)
                        Text("Знакомство с критиком")
                            .font(.lumi(15, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(14)
                .lumiCard()
                .padding(.bottom, 16)

                HStack(spacing: 6) {
                    LumiIcon(name: "icon-freeze", size: 14)
                    Text("+1 заморозка дня")
                }
                .font(.lumi(13, weight: .bold))
                .foregroundColor(LumiColor.blueChip)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(Capsule().fill(LumiColor.blueStrong.opacity(0.15)))
                .overlay(Capsule().stroke(LumiColor.blueStrong.opacity(0.3), lineWidth: 1))
                .frame(maxWidth: .infinity)

                Spacer()
                PrimaryButton(title: "Начать первый урок →") {
                    app.firstLessonFlow = true
                    app.go(.lesson)
                }
            }
            .padding(20)
        }
    }
}
