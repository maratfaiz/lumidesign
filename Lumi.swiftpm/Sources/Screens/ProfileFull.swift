import SwiftUI

// MARK: - Profile tab content

struct ProfileContentView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Профиль")
                    .font(.system(size: 19, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 14) {
                    Button { app.go(.crisis) } label: {
                        Image(systemName: "heart.text.square").foregroundColor(Color(hex: 0xff9f9f))
                    }
                    Button { app.go(.notifications) } label: {
                        LumiIcon(name: "icon-bell", size: 20).foregroundColor(LumiColor.textSecondary)
                    }
                }
                .buttonStyle(.plain)
            }

            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(RadialGradient(colors: [Color(hex: 0x2a1d52), Color(hex: 0x150f30)], center: .init(x: 0.5, y: 0.3), startRadius: 0, endRadius: 180))
                VStack {
                    MascotPlaceholder(size: 130, systemImage: "sparkles", assetName: "mascot-profile")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)

                Button { app.go(.customize) } label: {
                    LumiIcon(name: "icon-edit", size: 16)
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
                .buttonStyle(.plain)
                .padding(14)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Марат").font(.lumi(15, weight: .heavy)).foregroundColor(.white)
                Text("Уровень 3").font(.lumi(11.5, weight: .semibold)).foregroundColor(LumiColor.textSecondary)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1))
                        RoundedRectangle(cornerRadius: 3).fill(LumiGradient.primary).frame(width: geo.size.width * 0.6)
                    }
                }
                .frame(height: 6)
                .padding(.vertical, 4)
                Text("120 / 200 XP").font(.lumi(10, weight: .semibold)).foregroundColor(LumiColor.textTertiary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lumiCard(fill: Color.white.opacity(0.05), border: Color.white.opacity(0.08))

            HStack(spacing: 8) {
                statTile(icon: "icon-lumen", value: "1230", label: "Люменов", color: LumiColor.yellow) { app.go(.shop) }
                statTile(icon: "icon-streak", value: "7", label: "Серия дней", color: LumiColor.orange1) { app.go(.streakDetail) }
                statTile(icon: "icon-freeze", value: "1/2", label: "Заморозки", color: LumiColor.blueChip) { app.go(.shop) }
            }

            HStack {
                Text("Достижения").font(.lumi(14, weight: .heavy)).foregroundColor(.white)
                Spacer()
                Button { app.go(.achievements) } label: {
                    Text("2 из 8 · Все →").font(.lumi(12, weight: .bold)).foregroundColor(LumiColor.purpleLighter)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 8) {
                achievementBadge(icon: "icon-trophy", title: "Первый урок", unlocked: true, color: Color(hex: 0xffb020))
                achievementBadge(icon: "icon-streak", title: "7 дней подряд", unlocked: true, color: Color(hex: 0xff7a30))
                achievementBadge(icon: "icon-lock", title: "Ранняя пташка", unlocked: false, color: .clear)
                achievementBadge(icon: "icon-lock", title: "Дневник × 5", unlocked: false, color: .clear)
            }

            VStack(spacing: 8) {
                navRow(icon: "icon-shop", title: "Магазин") { app.go(.shop) }
                navRow(icon: "icon-stats", title: "Статистика") { app.go(.statistics) }
                navRow(icon: "icon-settings", title: "Настройки") { app.go(.settings) }
            }
        }
    }

    private func statTile(icon: String, value: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                LumiIcon(name: icon, size: 17).foregroundColor(color)
                Text(value).font(.lumi(14, weight: .heavy)).foregroundColor(color)
                Text(label).font(.lumi(10, weight: .semibold)).foregroundColor(color.opacity(0.75))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.12)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
    }

    private func achievementBadge(icon: String, title: String, unlocked: Bool, color: Color) -> some View {
        VStack(spacing: 6) {
            Circle()
                .fill(unlocked ? color : Color.white.opacity(0.04))
                .overlay(Circle().stroke(Color.white.opacity(unlocked ? 0 : 0.12), style: StrokeStyle(lineWidth: 1.5, dash: unlocked ? [] : [3])))
                .frame(width: 52, height: 52)
                .overlay(
                    LumiIcon(name: icon, size: unlocked ? 20 : 17)
                        .foregroundColor(unlocked ? Color(hex: 0x2a1a00) : LumiColor.textDim)
                )
            Text(title)
                .font(.lumi(9, weight: .bold))
                .foregroundColor(unlocked ? color : LumiColor.textFaint)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }

    private func navRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Label {
                    Text(title).font(.lumi(13, weight: .bold))
                } icon: {
                    LumiIcon(name: icon, size: 16)
                }
                .foregroundColor(Color(hex: 0xe5e0f7))
                Spacer()
                Text("→").foregroundColor(Color(hex: 0xe5e0f7))
            }
            .padding(12)
        }
        .buttonStyle(.plain)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

// MARK: - Achievements

private struct AchievementRow {
    let icon: String
    let title: String
    let subtitle: String
    let progress: Double?
    let color: Color
    let unlocked: Bool
}

struct AchievementsView: View {
    private let unlocked: [AchievementRow] = [
        .init(icon: "icon-trophy", title: "Первый урок", subtitle: "Пройден первый урок в приложении", progress: nil, color: Color(hex: 0xffb020), unlocked: true),
        .init(icon: "icon-streak", title: "7 дней подряд", subtitle: "Держал серию 7 дней без пропуска", progress: nil, color: Color(hex: 0xff7a30), unlocked: true),
    ]
    private let upcoming: [AchievementRow] = [
        .init(icon: "icon-sunrise", title: "Ранняя пташка", subtitle: "Позанимайся до 9 утра — 1 / 3 раза", progress: 0.33, color: .clear, unlocked: false),
        .init(icon: "icon-journal", title: "Дневник × 5", subtitle: "Заполни дневник эмоций — 2 / 5 раз", progress: 0.4, color: .clear, unlocked: false),
        .init(icon: "icon-seal", title: "Курс пройден", subtitle: "Заверши курс целиком — 0 / 1", progress: 0, color: .clear, unlocked: false),
        .init(icon: "icon-calendar", title: "30 дней подряд", subtitle: "Держи серию месяц — 7 / 30", progress: 0.23, color: .clear, unlocked: false),
    ]

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .lastTextBaseline) {
                    Text("Достижения").font(.system(size: 22, weight: .black, design: .rounded)).foregroundColor(.white)
                    Spacer()
                    Text("2 из 8").font(.lumi(12, weight: .bold)).foregroundColor(LumiColor.textSecondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("ОТКРЫТО").font(.lumi(12, weight: .heavy)).foregroundColor(LumiColor.textTertiary)
                    ForEach(unlocked, id: \.title) { row in
                        HStack(spacing: 12) {
                            Circle().fill(row.color).frame(width: 52, height: 52)
                                .overlay(LumiIcon(name: row.icon, size: 20).foregroundColor(Color(hex: 0x2a1a00)))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(row.title).font(.lumi(13.5, weight: .heavy)).foregroundColor(.white)
                                Text(row.subtitle).font(.lumi(10.5, weight: .semibold)).foregroundColor(row.color.opacity(0.8))
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 14).fill(row.color.opacity(0.1)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(row.color.opacity(0.3), lineWidth: 1))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("ВПЕРЕДИ").font(.lumi(12, weight: .heavy)).foregroundColor(LumiColor.textTertiary)
                    ForEach(upcoming, id: \.title) { row in
                        HStack(spacing: 12) {
                            Circle().fill(Color.white.opacity(0.05)).frame(width: 52, height: 52)
                                .overlay(Circle().strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [3])).foregroundColor(Color.white.opacity(0.18)))
                                .overlay(LumiIcon(name: "icon-lock", size: 16).foregroundColor(LumiColor.textDim))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(row.title).font(.lumi(13.5, weight: .heavy)).foregroundColor(Color(hex: 0xe5e0f7))
                                Text(row.subtitle).font(.lumi(10.5, weight: .semibold)).foregroundColor(LumiColor.textFaint2)
                                if let progress = row.progress {
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.08))
                                            RoundedRectangle(cornerRadius: 2).fill(LumiColor.textDim).frame(width: geo.size.width * CGFloat(progress))
                                        }
                                    }
                                    .frame(height: 4)
                                }
                            }
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.04)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    }
                }
            }
        }
    }
}

// MARK: - Statistics

struct StatisticsView: View {
    private let weekHeights: [CGFloat] = [0.35, 0.65, 1.0, 0.45, 0.25, 0.55, 0.12]
    private let weekDays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    private let courseProgress: [(String, Double, Bool)] = [
        ("Курс 0 · Основы самооценки", 1.0, true),
        ("Курс 1 · Внутренний критик", 0.8, true),
        ("Курс 2 · Самосострадание", 0, false),
        ("Курс 5 · Самопринятие", 0, false),
    ]

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 14) {
                Text("Статистика").font(.system(size: 22, weight: .black, design: .rounded)).foregroundColor(.white)

                HStack(spacing: 8) {
                    statCard(icon: "icon-journal", value: "12", label: "уроков всего", color: LumiColor.purpleLight)
                    statCard(icon: "icon-streak", value: "7", label: "серия сейчас", color: LumiColor.orange1)
                    statCard(icon: "star.fill", value: "14", label: "лучшая серия", color: LumiColor.yellow)
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Уроки за неделю").font(.lumi(12, weight: .bold)).foregroundColor(Color(hex: 0xe5e0f7))
                        Spacer()
                        Text("5 из 7 дней").font(.lumi(11, weight: .semibold)).foregroundColor(LumiColor.textSecondary)
                    }
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(Array(weekHeights.enumerated()), id: \.offset) { index, height in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(index == 2 ? AnyShapeStyle(LumiGradient.primary) : AnyShapeStyle(LumiColor.purple1.opacity(0.3)))
                                .frame(height: 64 * height)
                        }
                    }
                    .frame(height: 64, alignment: .bottom)
                    HStack(spacing: 8) {
                        ForEach(Array(weekDays.enumerated()), id: \.offset) { index, day in
                            Text(day)
                                .font(.lumi(9, weight: index == 2 ? .heavy : .regular))
                                .foregroundColor(index == 2 ? LumiColor.purpleLight : LumiColor.textFaint2)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(14)
                .lumiCard(fill: Color.white.opacity(0.05), border: Color.white.opacity(0.1))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Прогресс по курсам").font(.lumi(12, weight: .bold)).foregroundColor(Color(hex: 0xe5e0f7))
                    ForEach(courseProgress, id: \.0) { title, progress, active in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(title).font(.lumi(11, weight: .semibold)).foregroundColor(active ? Color(hex: 0xc9c2e6) : LumiColor.textDim)
                                Spacer()
                                Text("\(Int(progress * 100))%").font(.lumi(11, weight: .bold)).foregroundColor(active ? LumiColor.purple1 : LumiColor.textDim)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1))
                                    RoundedRectangle(cornerRadius: 3).fill(LumiGradient.primary).frame(width: geo.size.width * CGFloat(progress))
                                }
                            }
                            .frame(height: 6)
                        }
                    }
                }
                .padding(14)
                .lumiCard(fill: Color.white.opacity(0.05), border: Color.white.opacity(0.1))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Июль · календарь серии").font(.lumi(12, weight: .bold)).foregroundColor(Color(hex: 0xe5e0f7))
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
                        ForEach(weekDays, id: \.self) { day in
                            Text(day).font(.system(size: 8)).foregroundColor(LumiColor.textDim).frame(maxWidth: .infinity)
                        }
                        ForEach(calendarDays) { day in
                            Text(day.label)
                                .font(.lumi(10, weight: day.emphasis ? .heavy : .regular))
                                .foregroundColor(day.textColor)
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                                .background(RoundedRectangle(cornerRadius: 6).fill(day.fill))
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(day.borderColor, lineWidth: day.borderWidth))
                        }
                    }
                    HStack(spacing: 12) {
                        calendarLegend(color: LumiColor.purple1, label: "пройден урок")
                        calendarLegend(color: LumiColor.blueChip.opacity(0.4), label: "заморозка")
                    }
                }
                .padding(14)
                .lumiCard(fill: Color.white.opacity(0.05), border: Color.white.opacity(0.1))
            }
        }
    }

    private struct CalendarDay: Identifiable {
        let id: Int
        let label: String
        let fill: AnyShapeStyle
        let textColor: Color
        let borderColor: Color
        let borderWidth: CGFloat
        let emphasis: Bool
    }

    private var calendarDays: [CalendarDay] {
        [
            CalendarDay(id: 0, label: "25", fill: AnyShapeStyle(Color.white.opacity(0.05)), textColor: LumiColor.textDim, borderColor: .clear, borderWidth: 0, emphasis: false),
            CalendarDay(id: 1, label: "26", fill: AnyShapeStyle(LumiGradient.primary), textColor: .white, borderColor: .clear, borderWidth: 0, emphasis: true),
            CalendarDay(id: 2, label: "27", fill: AnyShapeStyle(LumiGradient.primary), textColor: .white, borderColor: .clear, borderWidth: 0, emphasis: true),
            CalendarDay(id: 3, label: "28", fill: AnyShapeStyle(LumiGradient.primary), textColor: .white, borderColor: .clear, borderWidth: 0, emphasis: true),
            CalendarDay(id: 4, label: "29", fill: AnyShapeStyle(LumiGradient.primary), textColor: .white, borderColor: .clear, borderWidth: 0, emphasis: true),
            CalendarDay(id: 5, label: "30", fill: AnyShapeStyle(LumiColor.blueChip.opacity(0.2)), textColor: LumiColor.blueChip, borderColor: LumiColor.blueChip.opacity(0.5), borderWidth: 1, emphasis: false),
            CalendarDay(id: 6, label: "1", fill: AnyShapeStyle(LumiColor.purple1.opacity(0.25)), textColor: .white, borderColor: LumiColor.purple1, borderWidth: 2, emphasis: true),
        ]
    }

    private func calendarLegend(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 8, height: 8)
            Text(label).font(.system(size: 9)).foregroundColor(LumiColor.textTertiary)
        }
    }

    private func statCard(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            if icon.hasPrefix("icon-") {
                LumiIcon(name: icon, size: 16).foregroundColor(color)
            } else {
                Image(systemName: icon).font(.system(size: 16)).foregroundColor(color)
            }
            Text(value).font(.lumi(20, weight: .heavy)).foregroundColor(color)
            Text(label).font(.lumi(10, weight: .bold)).foregroundColor(color.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .lumiCard(fill: Color.white.opacity(0.05), border: Color.white.opacity(0.1))
    }
}

// MARK: - Settings

struct SettingsView: View {
    @EnvironmentObject var app: AppState
    @State private var remindersOn = true

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 0) {
                Text("Настройки")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                HStack {
                    Text("Напоминания").font(.lumi(13, weight: .semibold)).foregroundColor(Color(hex: 0xe5e0f7))
                    Spacer()
                    Toggle("", isOn: $remindersOn).labelsHidden().tint(LumiColor.purple1)
                }
                settingsDivider()

                settingsRow("Дисклеймер") { app.go(.disclaimer) }
                settingsDivider()
                settingsRow("Политика конфиденциальности", enabled: false, action: nil)
                settingsDivider()
                settingsRow("Кризисные ресурсы") { app.go(.crisis) }
                settingsDivider()
                settingsRow("Все экраны (демо)") { app.go(.allScreens) }
                settingsDivider()

                Text("Версия 1.0")
                    .font(.lumi(11, weight: .semibold))
                    .foregroundColor(LumiColor.textDim)
                    .padding(.top, 14)
                Text("Иконки — Phosphor Icons (phosphoricons.com), лицензия MIT, © 2023 Phosphor Icons")
                    .font(.lumi(9.5, weight: .medium))
                    .foregroundColor(LumiColor.textDim)
                    .padding(.top, 4)
                    .padding(.bottom, 14)
            }
        }
    }

    private func settingsDivider() -> some View {
        Rectangle().fill(Color.white.opacity(0.08)).frame(height: 1)
    }

    @ViewBuilder
    private func settingsRow(_ title: String, enabled: Bool = true, action: (() -> Void)?) -> some View {
        let text = Text(title)
            .font(.lumi(13, weight: .semibold))
            .foregroundColor(enabled ? Color(hex: 0xe5e0f7) : LumiColor.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 14)

        if let action, enabled {
            Button(action: action) { text }.buttonStyle(.plain)
        } else {
            text
        }
    }
}

// MARK: - Streak detail

struct StreakDetailView: View {
    @EnvironmentObject var app: AppState

    private enum DayState { case done, frozen, today, empty }
    private let days: [(label: String, state: DayState)] = [
        ("Пн", .done), ("Вт", .done), ("Ср", .done), ("Чт", .frozen), ("Пт", .today), ("Сб", .empty), ("Вс", .empty),
    ]

    var body: some View {
        DetailScreen(showStars: true) {
            VStack(spacing: 16) {
                Text("Серия дней")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)

                ZStack {
                    Circle().fill(RadialGradient(colors: [LumiColor.orange1.opacity(0.28), .clear], center: .center, startRadius: 0, endRadius: 75))
                        .frame(width: 150, height: 150)
                    Circle().stroke(Color.white.opacity(0.08), lineWidth: 8).frame(width: 132, height: 132)
                    Circle().trim(from: 0, to: 0.75).stroke(LumiGradient.streak, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 132, height: 132)
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 2) {
                        LumiIcon(name: "icon-streak", size: 24).foregroundColor(LumiColor.orange1)
                        Text("7").font(.system(size: 32, weight: .black, design: .rounded)).foregroundColor(.white)
                    }
                }
                .frame(height: 150)

                Text("Лучшая серия за всё время!\nЕщё немного — и будет рекорд.")
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(Color(hex: 0xc9c2e6))
                    .multilineTextAlignment(.center)

                HStack(spacing: 6) {
                    ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                        VStack(spacing: 5) {
                            Text(day.label).font(.lumi(9, weight: day.state == .empty ? .bold : .heavy)).foregroundColor(dayLabelColor(day.state))
                            RoundedRectangle(cornerRadius: 9)
                                .fill(dayFill(day.state))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9)
                                        .strokeBorder(dayBorderColor(day.state), style: StrokeStyle(lineWidth: day.state == .empty ? 1.5 : 2, dash: day.state == .empty ? [3] : []))
                                )
                                .overlay {
                                    switch day.state {
                                    case .done:
                                        Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                                    case .frozen:
                                        LumiIcon(name: "icon-freeze", size: 12).foregroundColor(LumiColor.blueChip)
                                    case .today:
                                        LumiIcon(name: "icon-streak", size: 12).foregroundColor(LumiColor.orange1)
                                    case .empty:
                                        EmptyView()
                                    }
                                }
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }

                HStack(spacing: 11) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(LumiColor.blueChip.opacity(0.18)).frame(width: 36, height: 36)
                        LumiIcon(name: "icon-freeze", size: 18).foregroundColor(LumiColor.blueChip)
                    }
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Заморозки: \(app.freezeCount)").font(.lumi(13, weight: .heavy)).foregroundColor(.white)
                        Text("Сохранят серию, если пропустишь день").font(.lumi(10.5, weight: .semibold)).foregroundColor(Color(hex: 0x8fa0c9))
                    }
                    Spacer(minLength: 0)
                    Button { app.useFreeze() } label: {
                        Text(app.freezeUsed ? "Использовано" : "Использовать")
                            .font(.lumi(11, weight: .bold))
                            .foregroundColor(app.freezeUsed || app.freezeCount == 0 ? Color(hex: 0x6a7a94) : Color(hex: 0x0a1a33))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    .disabled(app.freezeUsed || app.freezeCount == 0)
                    .background(RoundedRectangle(cornerRadius: 10).fill(app.freezeUsed || app.freezeCount == 0 ? Color.white.opacity(0.05) : LumiColor.blueChip))
                }
                .padding(13)
                .background(RoundedRectangle(cornerRadius: 14).fill(LumiColor.blueChip.opacity(0.1)))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(LumiColor.blueChip.opacity(0.25), lineWidth: 1))
            }
        }
    }

    private func dayLabelColor(_ state: DayState) -> Color {
        switch state {
        case .done, .empty: return LumiColor.textDim
        case .frozen: return LumiColor.blueChip
        case .today: return LumiColor.orange1
        }
    }

    private func dayFill(_ state: DayState) -> AnyShapeStyle {
        switch state {
        case .done: return AnyShapeStyle(LumiGradient.primary)
        case .frozen: return AnyShapeStyle(LumiColor.blueChip.opacity(0.18))
        case .today: return AnyShapeStyle(LumiColor.orange1.opacity(0.15))
        case .empty: return AnyShapeStyle(Color.white.opacity(0.05))
        }
    }

    private func dayBorderColor(_ state: DayState) -> Color {
        switch state {
        case .done: return .clear
        case .frozen: return LumiColor.blueChip
        case .today: return LumiColor.orange1
        case .empty: return Color.white.opacity(0.18)
        }
    }
}

// MARK: - Notifications

struct NotificationsView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 8) {
                Text("Уведомления")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 4)

                notificationRow(text: "Не забудьте про сегодняшний урок", time: "2 часа назад") { app.go(.lesson) }
                notificationRow(text: "Открыто новое достижение 🏅", time: "вчера") { app.go(.achievements) }
                notificationRow(text: "Серия дней под угрозой — вернитесь сегодня", time: "2 дня назад", dim: true, action: nil)
            }
        }
    }

    private func notificationRow(text: String, time: String, dim: Bool = false, action: (() -> Void)?) -> some View {
        let card = VStack(alignment: .leading, spacing: 4) {
            Text(text).font(.lumi(13, weight: .semibold)).foregroundColor(dim ? LumiColor.textTertiary : Color(hex: 0xe5e0f7))
            Text(time).font(.lumi(10, weight: .semibold)).foregroundColor(dim ? Color(hex: 0x5c5480) : LumiColor.textDim)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(dim ? 0.03 : 0.05)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(dim ? 0.06 : 0.1), lineWidth: 1))

        return Group {
            if let action {
                Button(action: action) { card }.buttonStyle(.plain)
            } else {
                card
            }
        }
    }
}

// MARK: - Crisis

struct CrisisView: View {
    @EnvironmentObject var app: AppState

    private let resources: [(icon: String, title: String, detail: String, color: Color)] = [
        ("icon-call", "Детский телефон доверия", "8 800 2000 122 · круглосуточно, бесплатно", LumiColor.blueChip),
        ("bubble.left.and.bubble.right.fill", "Кризисная линия для взрослых", "8 (800) 333-44-34 · круглосуточно", LumiColor.purpleLight),
        ("cross.case.fill", "Экстренная помощь", "112", LumiColor.orange1),
    ]

    var body: some View {
        DetailScreen {
            VStack(spacing: 14) {
                VStack(spacing: 10) {
                    MascotPlaceholder(size: 96, systemImage: "exclamationmark.triangle.fill", assetName: "mascot-crisis")
                    Text("Тебе сейчас тяжело?")
                        .font(.system(size: 19, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("То, что ты сейчас чувствуешь — серьёзно, и с этим не нужно справляться в одиночку. Я не могу заменить живого специалиста, но рядом есть люди, которые умеют помочь прямо сейчас.")
                        .font(.lumi(13, weight: .semibold))
                        .foregroundColor(Color(hex: 0xc9c2e6))
                        .multilineTextAlignment(.center)
                        .padding(15)
                        .lumiCard(radius: 14)
                }

                ForEach(resources, id: \.title) { resource in
                    HStack(spacing: 10) {
                        ZStack {
                            Circle().fill(resource.color.opacity(0.2)).frame(width: 34, height: 34)
                            if resource.icon.hasPrefix("icon-") {
                                LumiIcon(name: resource.icon, size: 14).foregroundColor(resource.color)
                            } else {
                                Image(systemName: resource.icon).font(.system(size: 14)).foregroundColor(resource.color)
                            }
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            Text(resource.title).font(.lumi(13, weight: .heavy)).foregroundColor(.white)
                            Text(resource.detail).font(.lumi(11, weight: .semibold)).foregroundColor(resource.color)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(13)
                    .background(RoundedRectangle(cornerRadius: 14).fill(resource.color.opacity(0.12)))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(resource.color.opacity(0.3), lineWidth: 1))
                }

                HStack(spacing: 10) {
                    MascotPlaceholder(size: 32, systemImage: "sparkles")
                    Text("Ты важен(на). Тебя слышат. Ты не один(на).")
                        .font(.lumi(12, weight: .semibold))
                        .foregroundColor(Color(hex: 0xc9c2e6))
                }
                .padding(13)
                .lumiCard(fill: Color.white.opacity(0.04), border: Color.white.opacity(0.08))

                Spacer(minLength: 8)
                PrimaryButton(title: "Вернуться") { app.goBack() }
                Text("Это не срочно")
                    .font(.lumi(11, weight: .semibold))
                    .foregroundColor(LumiColor.textDim)
            }
        }
    }
}
