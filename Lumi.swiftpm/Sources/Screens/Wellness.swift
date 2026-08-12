import SwiftUI

// MARK: - Breathing (4-7-8 technique)

private struct BreathPhase {
    let text: String
    let number: Int
    let scale: Double
    let round: Int
    let timeLabel: String
}

struct BreathingView: View {
    @EnvironmentObject var app: AppState
    @State private var repeatOn = false
    @State private var speed: Double = 1

    private var phase: BreathPhase {
        let cyclePos = app.breathElapsed % 19
        let name: String
        let duration: Int
        let elapsed: Int
        if cyclePos < 4 {
            name = "Вдох"; duration = 4; elapsed = cyclePos
        } else if cyclePos < 11 {
            name = "Задержка"; duration = 7; elapsed = cyclePos - 4
        } else {
            name = "Выдох"; duration = 8; elapsed = cyclePos - 11
        }
        let progress = Double(elapsed) / Double(duration)
        let scale: Double
        switch name {
        case "Вдох": scale = 0.62 + 0.38 * progress
        case "Задержка": scale = 1
        default: scale = 1 - 0.38 * progress
        }
        let round = min(6, app.breathElapsed / 19 + 1)
        let clamped = min(app.breathElapsed, 114)
        let timeLabel = String(format: "%02d:%02d / 01:54", clamped / 60, clamped % 60)
        return BreathPhase(text: name, number: duration - elapsed, scale: scale, round: round, timeLabel: timeLabel)
    }

    var body: some View {
        DetailScreen {
            VStack(spacing: 18) {
                Text(phase.timeLabel)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()

                ZStack {
                    Circle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [4, 5]))
                        .foregroundColor(Color(hex: 0xc9c2e6).opacity(0.25))
                        .frame(width: 210, height: 210)
                        .scaleEffect(CGFloat(0.82 + phase.scale * 0.18))
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color(hex: 0xc9bbff), LumiColor.purple1.opacity(0.9), LumiColor.purple2],
                                center: .center, startRadius: 0, endRadius: 105
                            )
                        )
                        .frame(width: 210, height: 210)
                        .scaleEffect(CGFloat(phase.scale))
                        .animation(.linear(duration: 1), value: app.breathElapsed)
                    VStack(spacing: 4) {
                        Text(phase.text)
                            .font(.lumi(14, weight: .bold))
                            .foregroundColor(.white.opacity(0.9))
                        Text("\(phase.number)")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 220)

                HStack(spacing: 8) {
                    ControlPillButton(icon: "arrow.triangle.2.circlepath", label: repeatOn ? "Повтор" : "Один раз", isActive: repeatOn) {
                        repeatOn.toggle()
                    }
                    ControlPillButton(icon: "info.circle", label: "Инфо", isActive: app.breathInfoOpen) {
                        app.breathInfoOpen.toggle()
                    }
                    ControlPillButton(icon: "icon-clock", label: "\(String(format: "%g", speed))×", isActive: speed != 1) {
                        speed = speed >= 1.5 ? 0.75 : speed + 0.25
                    }
                }

                if app.breathInfoOpen {
                    Text("Вдох на 4 счёта, задержка на 7, выдох на 8. Помогает снизить тревожность и успокоить нервную систему.")
                        .font(.lumi(11.5, weight: .semibold))
                        .foregroundColor(Color(hex: 0xe5e0f7))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(hex: 0x2a2050)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(LumiColor.purple1.opacity(0.4), lineWidth: 1))
                }

                HStack {
                    TransportButton(systemImage: "chevron.left") {}
                        .opacity(0.4)
                        .disabled(true)
                    Spacer()
                    TransportButton(systemImage: app.breathPlaying ? "pause.fill" : "play.fill", size: 64, prominent: true) {
                        app.toggleBreathing()
                    }
                    Spacer()
                    TransportButton(systemImage: "chevron.right") {}
                        .opacity(0.4)
                        .disabled(true)
                }

                Button { app.go(.breathComplete) } label: {
                    Text("Завершить")
                        .font(.lumi(12.5, weight: .bold))
                        .foregroundColor(LumiColor.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear { app.startBreathingTimerIfNeeded() }
        .onDisappear { app.stopBreathingTimer() }
    }
}

struct BreathCompleteView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        CompletionScreen(
            title: "Дыхание завершено",
            subtitle: "Ты сделал(а) \(min(6, app.breathElapsed / 19 + 1)) раундов 4-7-8. Тело и разум немного спокойнее",
            mascotIcon: "wind",
            reward: "+15 Люменов",
            assetName: "mascot-breathcomplete"
        ) {
            app.breathElapsed = 0
            app.breathPlaying = true
            app.go(.home)
        }
    }
}

// MARK: - Affirmations

struct AffirmationsView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen {
            VStack(spacing: 18) {
                Spacer(minLength: 8)
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(colors: [LumiColor.purple1.opacity(0.22), LumiColor.purple2.opacity(0.08)], startPoint: .top, endPoint: .bottom)
                        )
                        .overlay(RoundedRectangle(cornerRadius: 22).stroke(LumiColor.purple1.opacity(0.3), lineWidth: 1))
                    LumiIcon(name: "icon-quote", size: 28)
                        .foregroundColor(LumiColor.purple1.opacity(0.35))
                        .padding(16)
                    VStack(spacing: 12) {
                        Text("«\(app.affirmations[app.affirmIndex])»")
                            .font(.lumi(20, weight: .heavy))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        Text("\(app.affirmIndex + 1) из \(app.affirmations.count)")
                            .font(.lumi(11.5, weight: .semibold))
                            .foregroundColor(LumiColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
                .frame(minHeight: 220)

                HStack(spacing: 8) {
                    ControlPillButton(icon: "speaker.wave.2.fill", label: app.affirmSound ? "Со звуком" : "Без звука", isActive: app.affirmSound) {
                        app.affirmSound.toggle()
                    }
                    ControlPillButton(icon: "arrow.triangle.2.circlepath", label: app.affirmRepeat ? "Повтор" : "Один раз", isActive: app.affirmRepeat) {
                        app.affirmRepeat.toggle()
                    }
                    ControlPillButton(icon: "icon-clock", label: "\(String(format: "%g", app.affirmSpeed))×", isActive: app.affirmSpeed != 1) {
                        app.affirmSpeed = app.affirmSpeed >= 1.5 ? 0.75 : app.affirmSpeed + 0.25
                    }
                }

                HStack {
                    TransportButton(systemImage: "chevron.left") {
                        app.affirmIndex = (app.affirmIndex - 1 + app.affirmations.count) % app.affirmations.count
                    }
                    Spacer()
                    TransportButton(systemImage: app.affirmPlaying ? "pause.fill" : "play.fill", size: 64, prominent: true) {
                        app.affirmPlaying.toggle()
                    }
                    Spacer()
                    TransportButton(systemImage: "chevron.right") {
                        app.affirmIndex = (app.affirmIndex + 1) % app.affirmations.count
                    }
                }

                Button { app.go(.affirmComplete) } label: {
                    Text("Завершить")
                        .font(.lumi(12.5, weight: .bold))
                        .foregroundColor(LumiColor.textSecondary)
                }
                .buttonStyle(.plain)
                Spacer(minLength: 8)
            }
        }
    }
}

struct AffirmCompleteView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        CompletionScreen(
            title: "Сеанс завершён",
            subtitle: "Ты повторил(а) \(app.affirmations.count) аффирмации. Пусть эти слова останутся с тобой сегодня",
            mascotIcon: "heart.fill",
            reward: "+15 Люменов",
            assetName: "mascot-affirmcomplete"
        ) {
            app.go(.home)
        }
    }
}

// MARK: - Meditation ("перед сном")

struct MeditationView: View {
    @EnvironmentObject var app: AppState

    private let ambiences: [(key: String, label: String, icon: String)] = [
        ("silence", "Тишина", "icon-ambience-silence"),
        ("rain", "Дождь", "icon-ambience-rain"),
        ("ocean", "Океан", "icon-ambience-ocean"),
    ]

    private var timeLabel: String {
        let remaining = max(0, app.meditationDuration * 60 - app.meditationElapsed)
        return String(format: "%02d:%02d", remaining / 60, remaining % 60)
    }

    private var stateLabel: String {
        guard app.meditationPlaying else { return "Готов(а), когда ты будешь готов(а)" }
        let phrases = ["Дыши спокойно…", "Расслабь плечи…", "Почувствуй тело…", "Отпусти мысли…", "Просто будь здесь…"]
        return phrases[(app.meditationElapsed / 12) % phrases.count]
    }

    var body: some View {
        DetailScreen {
            VStack(spacing: 14) {
                Text(timeLabel)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                Text(stateLabel)
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)

                ZStack {
                    Circle()
                        .fill(RadialGradient(colors: [LumiColor.purple1.opacity(0.25), .clear], center: .center, startRadius: 0, endRadius: 125))
                        .frame(width: 250, height: 250)
                    Circle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [4, 5]))
                        .foregroundColor(Color(hex: 0xc9c2e6).opacity(0.25))
                        .frame(width: 205, height: 205)
                    MascotPlaceholder(size: 170, systemImage: "moon.stars.fill", assetName: "mascot-meditation")
                }
                .frame(height: 250)

                HStack(spacing: 8) {
                    ForEach(ambiences, id: \.key) { ambience in
                        Button { app.meditationAmbience = ambience.key } label: {
                            Label {
                                Text(ambience.label)
                            } icon: {
                                LumiIcon(name: ambience.icon, size: 14)
                            }
                            .font(.lumi(12, weight: app.meditationAmbience == ambience.key ? .heavy : .bold))
                            .foregroundColor(app.meditationAmbience == ambience.key ? .white : LumiColor.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                        }
                        .buttonStyle(.plain)
                        .background(RoundedRectangle(cornerRadius: 12).fill(app.meditationAmbience == ambience.key ? LumiColor.purple1.opacity(0.25) : Color.white.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(app.meditationAmbience == ambience.key ? LumiColor.purple1.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1))
                    }
                }

                HStack(spacing: 8) {
                    ForEach([5, 10, 15], id: \.self) { minutes in
                        Button { app.selectMeditationDuration(minutes) } label: {
                            Text("\(minutes) мин")
                                .font(.lumi(12, weight: app.meditationDuration == minutes ? .heavy : .bold))
                                .foregroundColor(app.meditationDuration == minutes ? .white : LumiColor.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 9)
                        }
                        .buttonStyle(.plain)
                        .disabled(app.meditationPlaying)
                        .opacity(app.meditationPlaying ? 0.5 : 1)
                        .background(RoundedRectangle(cornerRadius: 12).fill(app.meditationDuration == minutes ? LumiColor.purple1.opacity(0.25) : Color.white.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(app.meditationDuration == minutes ? LumiColor.purple1.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1))
                    }
                }

                PrimaryButton(
                    title: app.meditationPlaying ? "Пауза" : "Начать медитацию",
                    systemImage: app.meditationPlaying ? "pause.fill" : "play.fill"
                ) {
                    app.toggleMeditation()
                }
            }
        }
        .onDisappear { app.stopMeditationTimer() }
    }
}

struct MeditationCompleteView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        CompletionScreen(
            title: "Медитация завершена",
            subtitle: "Ты провёл(а) \(app.meditationDuration) минут в тишине. Дай себе немного этого спокойствия на весь день",
            mascotIcon: "moon.zzz.fill",
            reward: "+15 Люменов",
            assetName: "mascot-meditationcomplete"
        ) {
            app.meditationElapsed = 0
            app.go(.home)
        }
    }
}

// MARK: - Shared completion screen (breathing / affirmations / meditation)

struct CompletionScreen: View {
    let title: String
    let subtitle: String
    let mascotIcon: String
    let reward: String
    var assetName: String? = nil
    let action: () -> Void

    var body: some View {
        DetailScreen(showStars: true) {
            VStack(spacing: 14) {
                Spacer(minLength: 4)
                Text(title)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                MascotPlaceholder(size: 170, systemImage: mascotIcon, assetName: assetName)
                    .padding(.vertical, 8)

                HStack(spacing: 6) {
                    LumiIcon(name: "icon-lumen", size: 14)
                    Text(reward)
                }
                .font(.lumi(13, weight: .heavy))
                .foregroundColor(LumiColor.yellow)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(Capsule().fill(LumiColor.yellow.opacity(0.14)))
                .overlay(Capsule().stroke(LumiColor.yellow.opacity(0.3), lineWidth: 1))

                Spacer(minLength: 4)
                PrimaryButton(title: "Готово", action: action)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
