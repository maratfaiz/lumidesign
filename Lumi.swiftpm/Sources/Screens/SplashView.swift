import SwiftUI

struct SplashView: View {
    @EnvironmentObject var app: AppState
    private let progress: Double = 0.72

    var body: some View {
        ZStack {
            LumiBackground()
            StarField(stars: StarPresets.splash)

            VStack(spacing: 6) {
                Spacer(minLength: 40)

                Text("Луми")
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("Твой путь к уверенности")
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .padding(.bottom, 18)

                MascotPlaceholder(size: 140)
                    .padding(.bottom, 22)

                Text("Загружаем Луми...")
                    .font(.lumi(15, weight: .bold))
                    .foregroundColor(LumiColor.textBody)
                    .padding(.bottom, 16)

                ProgressBarView(progress: progress)
                    .frame(width: 220, height: 8)

                Text("\(Int(progress * 100))%")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textTertiary)
                    .padding(.top, 8)

                Spacer(minLength: 40)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { app.go(.welcome) }
        .task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            if app.screen == .splash {
                app.go(.welcome)
            }
        }
    }
}
