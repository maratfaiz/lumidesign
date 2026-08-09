import SwiftUI

struct EmptyStateView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen {
            VStack(spacing: 14) {
                Spacer()
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                    .foregroundColor(Color.white.opacity(0.15))
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.04)))
                    .frame(width: 80, height: 80)
                Text("Пока пусто").font(.lumi(15, weight: .heavy)).foregroundColor(.white)
                Text("Здесь появятся ваши достижения, как только вы пройдёте первый урок")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .multilineTextAlignment(.center)
                Button { app.go(.lesson) } label: {
                    Text("Перейти к уроку")
                        .font(.lumi(13, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 13)
                }
                .buttonStyle(.plain)
                .background(RoundedRectangle(cornerRadius: 14).fill(LumiGradient.primary))
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct LoadingDemoView: View {
    var body: some View {
        DetailScreen {
            VStack(spacing: 16) {
                Spacer()
                ProgressView()
                    .tint(LumiColor.purple1)
                    .scaleEffect(1.4)
                Text("Загрузка…").font(.lumi(13, weight: .semibold)).foregroundColor(LumiColor.textSecondary)
                VStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)).frame(height: 60)
                    RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.05)).frame(height: 16).frame(maxWidth: 240)
                    RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.05)).frame(height: 16).frame(maxWidth: 170)
                }
                .padding(.top, 10)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ErrorDemoView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen {
            VStack(spacing: 14) {
                Spacer()
                ZStack {
                    Circle().fill(Color(hex: 0xff8a65).opacity(0.15)).frame(width: 60, height: 60)
                    Text("!").font(.system(size: 24, weight: .bold)).foregroundColor(Color(hex: 0xff8a65))
                }
                Text("Что-то пошло не так").font(.lumi(15, weight: .heavy)).foregroundColor(.white)
                Text("Проверьте соединение и повторите попытку")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .multilineTextAlignment(.center)
                Button { app.go(.home) } label: {
                    Text("Повторить")
                        .font(.lumi(13, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 13)
                }
                .buttonStyle(.plain)
                .background(RoundedRectangle(cornerRadius: 14).fill(LumiGradient.primary))
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

/// Direct-jump menu listing every screen in the app, mirroring the prototype's
/// own always-visible "Все экраны" sidebar so nothing is left unreachable.
struct AllScreensView: View {
    @EnvironmentObject var app: AppState

    private let groups: [(String, [(String, Screen)])] = [
        ("Онбординг", [
            ("Заставка", .splash), ("Знакомство", .welcome), ("Дисклеймер", .disclaimer),
            ("Онбординг 1/4", .ob1), ("Онбординг 2/4", .ob2), ("Онбординг 3/4", .ob3), ("Онбординг 4/4", .ob4),
            ("Сборка плана", .planLoading), ("План готов", .planReady), ("Начало серии", .streakStart),
        ]),
        ("Главная", [
            ("Луми (главная)", .home), ("Курсы", .catalog), ("Профиль", .profile),
        ]),
        ("Курс и урок", [
            ("Страница курса", .catalogDetail), ("Урок", .lesson), ("Упражнение", .exercise), ("Урок завершён", .lessonComplete),
        ]),
        ("Упражнения · Замечаем критику", [
            ("Упр. — Карточки+выбор", .ex1), ("Упр. — Bubble UI", .ex2), ("Упр. — Перетаскивание", .ex3),
            ("Упр. — Перепиши мысль", .ex4), ("Упр. — ACT", .ex5),
        ]),
        ("Упражнения · Сострадание", [
            ("Упр. — Что сказал бы друг?", .ex6), ("Упр. — Соедини", .ex7), ("Упр. — Письмо другу", .ex8),
            ("Упр. — Маленькие действия", .ex9), ("Упр. — Ценности", .ex10),
        ]),
        ("Практики", [
            ("Дыхание", .breathing), ("Дыхание завершено", .breathComplete),
            ("Аффирмации", .affirmations), ("Аффирмации — завершено", .affirmComplete),
            ("Перед сном", .beforeSleep), ("Медитация завершена", .meditationComplete),
        ]),
        ("Магазин и образы", [
            ("Внешний вид Луми", .customize), ("Магазин", .shop), ("Инвентарь", .inventory),
        ]),
        ("Профиль", [
            ("Достижения", .achievements), ("Статистика", .statistics), ("Настройки", .settings),
            ("Серия дней", .streakDetail), ("Уведомления", .notifications), ("Кризисный экран", .crisis),
        ]),
        ("Служебные", [
            ("Пусто (Empty)", .empty), ("Загрузка (Loading)", .loading), ("Ошибка (Error)", .error),
        ]),
    ]

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 18) {
                Text("Все экраны")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                ForEach(groups, id: \.0) { group in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(group.0.uppercased())
                            .font(.lumi(11, weight: .bold))
                            .foregroundColor(LumiColor.textTertiary)
                        VStack(spacing: 6) {
                            ForEach(group.1, id: \.0) { label, target in
                                Button { app.go(target) } label: {
                                    HStack {
                                        Text(label)
                                            .font(.lumi(12.5, weight: .semibold))
                                            .foregroundColor(Color(hex: 0xc9c2e6))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 10))
                                            .foregroundColor(LumiColor.textDim)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                }
                                .buttonStyle(.plain)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
                            }
                        }
                    }
                }
            }
        }
    }
}
