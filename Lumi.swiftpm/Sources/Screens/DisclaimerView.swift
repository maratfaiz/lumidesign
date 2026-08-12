import SwiftUI

struct DisclaimerView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        ZStack {
            LumiBackground()

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(LumiColor.danger.opacity(0.15))
                        .frame(width: 88, height: 88)
                        .overlay(Circle().stroke(LumiColor.danger.opacity(0.4), lineWidth: 2))
                    Image(systemName: "exclamationmark")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(LumiColor.danger)
                }
                .padding(.top, 10)

                Text("Важно знать!")
                    .font(.lumi(19, weight: .black))
                    .foregroundColor(.white)

                Text("Луми не заменяет профессиональную психологическую помощь и не ставит диагнозы.\n\nЕсли тебе очень тяжело, пожалуйста, обратись за поддержкой к близким или на горячую линию.")
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(LumiColor.textBody)
                    .lineSpacing(4)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lumiCard()

                Spacer()

                PrimaryButton(title: "Я понимаю и согласен(на)", systemImage: "checkmark") {
                    app.go(.ob1)
                }
                TextLinkButton(title: "Понятно, продолжить") {
                    app.go(.ob1)
                }
            }
            .padding(20)
        }
    }
}
