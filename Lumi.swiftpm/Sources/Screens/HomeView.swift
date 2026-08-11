import SwiftUI

struct HomeContentView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Привет, Марат!")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                HStack(spacing: 8) {
                    statChip(icon: "icon-streak", text: "\(app.streakDays)", color: LumiColor.orange1)
                    Button { app.go(.shop) } label: {
                        statChip(icon: "icon-lumen", text: "\(app.gems)", color: LumiColor.yellow)
                    }
                    .buttonStyle(.plain)
                    statChip(icon: "icon-freeze", text: "\(app.freezesAvailable)/2", color: LumiColor.blueChip)
                }
            }

            Button { app.go(.customize) } label: {
                MascotPlaceholder(size: 150, systemImage: "headphones", assetName: "mascot-home")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 12) {
                Text("ТЕКУЩИЙ УРОК")
                    .font(.lumi(11, weight: .bold))
                    .foregroundColor(LumiColor.textTertiary)
                Text("Курс 1. Работа с внутренним критиком")
                    .font(.lumi(14, weight: .heavy))
                    .foregroundColor(.white)
                Text("Урок 3. Замечаем критику · 2/5")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                PrimaryButton(title: "Продолжить урок →") { app.go(.lesson) }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lumiCard()

            Text("СЕГОДНЯ ДЛЯ ТЕБЯ")
                .font(.lumi(11, weight: .bold))
                .foregroundColor(LumiColor.textTertiary)

            HStack(spacing: 8) {
                dailyTile(icon: "moon", title: "Дыхание") { app.go(.breathing) }
                dailyTile(icon: "heart.fill", assetIcon: "icon-heart-fill", title: "Аффирмации") { app.go(.affirmations) }
                dailyTile(icon: "sun.max", title: "Медитация") { app.go(.beforeSleep) }
            }

            Button { app.go(.shop) } label: {
                HStack(spacing: 12) {
                    MascotPlaceholder(size: 40, systemImage: "tshirt.fill", assetName: "mascot-home-wardrobe")
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Создай стиль для Луми и подними ему настроение")
                            .font(.lumi(12, weight: .heavy))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Text("Гардероб →")
                            .font(.lumi(11, weight: .semibold))
                            .foregroundColor(LumiColor.textSecondary)
                    }
                    Spacer()
                }
                .padding(14)
            }
            .buttonStyle(.plain)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.white.opacity(0.05)))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(Color.white.opacity(0.15))
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("МЫСЛЬ ДНЯ")
                    .font(.lumi(10, weight: .bold))
                    .foregroundColor(LumiColor.purpleLight)
                Text("Не обязательно быть идеальным, чтобы быть достойным любви.")
                    .font(.lumi(13, weight: .medium))
                    .foregroundColor(Color(hex: 0xf0ecff))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(LinearGradient(
                        colors: [LumiColor.purple1.opacity(0.16), LumiColor.purple2.opacity(0.08)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(LumiColor.purple1.opacity(0.25), lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private func statChip(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 4) {
            LumiIcon(name: icon, size: 12)
            Text(text).font(.lumi(12, weight: .heavy))
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(color.opacity(0.15)))
    }

    @ViewBuilder
    private func dailyTile(icon: String, assetIcon: String? = nil, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                if let assetIcon {
                    LumiIcon(name: assetIcon, size: 17)
                        .foregroundColor(LumiColor.purpleLight)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(LumiColor.purpleLight)
                }
                Text(title)
                    .font(.lumi(10, weight: .bold))
                    .foregroundColor(LumiColor.textBody)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
