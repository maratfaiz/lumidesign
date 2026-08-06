import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        ZStack {
            LumiBackground()
            StarField(stars: StarPresets.welcome)

            VStack(spacing: 0) {
                Spacer(minLength: 24)

                VStack(spacing: 6) {
                    Text("Луми")
                        .font(.system(size: 46, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Каждый день чуть ближе к себе")
                        .font(.lumi(15, weight: .semibold))
                        .foregroundColor(LumiColor.textSecondary)
                }

                Spacer()

                MascotPlaceholder(size: 190)

                Spacer()

                Text("Привет! Я Луми — твоя звёздочка поддержки. Будем расти вместе!")
                    .font(.lumi(14, weight: .semibold))
                    .foregroundColor(LumiColor.textBody)
                    .multilineTextAlignment(.center)
                    .padding(14)
                    .lumiCard(radius: 20)
                    .padding(.top, 10)

                Spacer(minLength: 24)

                VStack(spacing: 16) {
                    AppleSignInButton { app.go(.disclaimer) }

                    Text("Продолжая, вы соглашаетесь с условиями использования")
                        .font(.lumi(11, weight: .semibold))
                        .foregroundColor(LumiColor.textFaint)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }
}
