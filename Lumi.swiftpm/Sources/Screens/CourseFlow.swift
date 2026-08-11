import SwiftUI

// MARK: - Catalog tab (list of courses)

struct CatalogListView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Курсы")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("Твой путь к уверенности")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
            }

            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 6)
                        .frame(width: 52, height: 52)
                    Circle()
                        .trim(from: 0, to: 0.25)
                        .stroke(LumiColor.purple1, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 52, height: 52)
                        .rotationEffect(.degrees(-90))
                    Text("25%")
                        .font(.lumi(11, weight: .heavy))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("ТВОЙ ПРОГРЕСС")
                        .font(.lumi(11, weight: .bold))
                        .foregroundColor(LumiColor.purpleLight)
                    Text("1 из 4 курсов пройден")
                        .font(.lumi(13, weight: .heavy))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(LumiColor.purple1.opacity(0.15)))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(LumiColor.purple1.opacity(0.3), lineWidth: 1))

            Text("МОИ КУРСЫ")
                .font(.lumi(11, weight: .bold))
                .foregroundColor(LumiColor.textTertiary)

            VStack(spacing: 10) {
                courseRow(
                    icon: "star.fill", iconColor: LumiColor.purpleLight,
                    title: "Курс 0 · Основы самооценки", subtitle: "5 уроков · пройден",
                    trailing: AnyView(Text("✓").foregroundColor(LumiColor.purple1)),
                    highlighted: false, action: nil
                )
                courseRow(
                    icon: "icon-headphones", iconColor: .white,
                    title: "Курс 1 · Работа с внутренним критиком", subtitle: nil,
                    progress: 0.8,
                    trailing: AnyView(
                        Text("80%").font(.lumi(11, weight: .bold)).foregroundColor(LumiColor.purpleLight)
                    ),
                    highlighted: true
                ) { app.go(.catalogDetail) }
                courseRow(
                    icon: "icon-heart-fill", iconColor: LumiColor.textBody,
                    title: "Курс 2 · Самосострадание", subtitle: "5 уроков · заблокирован",
                    trailing: AnyView(LumiIcon(name: "icon-lock", size: 12).foregroundColor(LumiColor.textFaint2)),
                    dimmed: true, highlighted: false, action: nil
                )
                courseRow(
                    icon: "flag.fill", iconColor: LumiColor.textBody,
                    title: "Курс 5 · Самопринятие", subtitle: "5 уроков · заблокирован",
                    trailing: AnyView(LumiIcon(name: "icon-lock", size: 12).foregroundColor(LumiColor.textFaint2)),
                    dimmed: true, highlighted: false, action: nil
                )
            }
        }
    }

    @ViewBuilder
    private func courseRow(
        icon: String, iconColor: Color,
        title: String, subtitle: String?,
        progress: Double? = nil,
        trailing: AnyView,
        dimmed: Bool = false,
        highlighted: Bool,
        action: (() -> Void)?
    ) -> some View {
        let row = HStack(spacing: 13) {
            ZStack {
                Circle().fill(Color.white.opacity(0.08)).frame(width: 44, height: 44)
                if icon.hasPrefix("icon-") {
                    LumiIcon(name: icon, size: 17).foregroundColor(iconColor)
                } else {
                    Image(systemName: icon).font(.system(size: 17)).foregroundColor(iconColor)
                }
            }
            .opacity(dimmed ? 0.6 : 1)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.lumi(13, weight: highlighted ? .heavy : .bold))
                    .foregroundColor(highlighted ? .white : LumiColor.textBody)
                if let subtitle {
                    Text(subtitle)
                        .font(.lumi(10, weight: .semibold))
                        .foregroundColor(LumiColor.textFaint2)
                }
                if let progress {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.12))
                            RoundedRectangle(cornerRadius: 3).fill(LumiGradient.primary)
                                .frame(width: geo.size.width * CGFloat(progress))
                        }
                    }
                    .frame(height: 5)
                }
            }
            trailing
        }
        .padding(13)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(highlighted ? LumiColor.purple1.opacity(0.18) : Color.white.opacity(dimmed ? 0.02 : 0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(
                    highlighted ? LumiColor.purple1 : Color.white.opacity(dimmed ? 0.14 : 0.1),
                    style: StrokeStyle(lineWidth: highlighted ? 2 : (dimmed ? 1.5 : 1), dash: dimmed ? [4] : [])
                )
        )

        if let action {
            Button(action: action) { row }.buttonStyle(.plain)
        } else {
            row
        }
    }
}

// MARK: - Course detail ("coursepage")

private struct CourseLesson: Identifiable {
    let id: Int
    let title: String
    var state: State
    enum State { case done, active, locked }
}

struct CourseDetailView: View {
    @EnvironmentObject var app: AppState

    private let lessons: [CourseLesson] = [
        .init(id: 1, title: "Знакомство с критиком", state: .done),
        .init(id: 2, title: "Почему он появляется?", state: .done),
        .init(id: 3, title: "Замечаем критику", state: .active),
        .init(id: 4, title: "Как ему отвечать?", state: .locked),
        .init(id: 5, title: "Поддержка вместо критики", state: .locked),
    ]

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Курс 1")
                        .font(.lumi(12, weight: .bold))
                        .foregroundColor(LumiColor.textSecondary)
                    Spacer()
                    HStack(spacing: 4) {
                        LumiIcon(name: "icon-lumen", size: 13)
                        Text("1230")
                    }
                    .font(.lumi(12, weight: .heavy))
                    .foregroundColor(LumiColor.yellow)
                }

                Text("Работа с внутренним критиком")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("5 уроков")
                    .font(.lumi(11, weight: .semibold))
                    .foregroundColor(LumiColor.textTertiary)

                MascotPlaceholder(size: 150, systemImage: "headphones", assetName: "mascot-coursepage")
                    .frame(maxWidth: .infinity)

                HStack {
                    Text("Прогресс курса")
                    Spacer()
                    Text("80%")
                }
                .font(.lumi(11, weight: .semibold))
                .foregroundColor(LumiColor.textSecondary)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1))
                        RoundedRectangle(cornerRadius: 3).fill(LumiGradient.primary).frame(width: geo.size.width * 0.8)
                    }
                }
                .frame(height: 6)

                VStack(spacing: 8) {
                    ForEach(lessons) { lesson in
                        lessonRow(lesson)
                    }
                }
                .padding(.top, 8)

                PrimaryButton(title: "Начать урок →") {
                    app.go(.lesson)
                }
                .padding(.top, 8)
            }
        }
    }

    @ViewBuilder
    private func lessonRow(_ lesson: CourseLesson) -> some View {
        let row = HStack {
            Text("\(lesson.id). \(lesson.title)")
                .font(.lumi(12, weight: lesson.state == .active ? .bold : .semibold))
                .foregroundColor(lesson.state == .locked ? LumiColor.textDim : (lesson.state == .active ? .white : LumiColor.textBody))
            Spacer()
            switch lesson.state {
            case .done:
                Text("✓").foregroundColor(LumiColor.purple1)
            case .active:
                Text("→").foregroundColor(.white)
            case .locked:
                LumiIcon(name: "icon-lock", size: 12).foregroundColor(LumiColor.textDim)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(lesson.state == .active ? LumiColor.purple1.opacity(0.18) : Color.white.opacity(lesson.state == .locked ? 0.03 : 0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(lesson.state == .active ? LumiColor.purple1 : Color.white.opacity(lesson.state == .locked ? 0.06 : 0.1), lineWidth: lesson.state == .active ? 2 : 1)
        )

        if lesson.state == .active {
            Button { app.go(.lesson) } label: { row }.buttonStyle(.plain)
        } else {
            row
        }
    }
}

// MARK: - Lesson intro

struct LessonView: View {
    @EnvironmentObject var app: AppState

    private let bullets = [
        ("ellipsis.bubble", "Разберём, как звучит внутренний критик"),
        ("star.fill", "Потренируемся замечать момент критики"),
        ("icon-heart-fill", "Запишем ответ на критику своими словами"),
    ]

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1)).frame(height: 6)
                    .overlay(
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 3).fill(LumiGradient.primary)
                                .frame(width: geo.size.width * 0.3)
                        }, alignment: .leading
                    )
                    .padding(.bottom, 18)

                MascotPlaceholder(size: 110, systemImage: "headphones", assetName: "mascot-lesson")
                    .padding(.bottom, 12)

                Text("Урок 3: Замечаем критику")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)

                Text("Иногда внутренний голос говорит с нами жёстче, чем с другом. Сегодня научимся замечать этот момент.")
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(LumiColor.textBody)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .lumiCard(radius: 14)

                Text("В ЭТОМ УРОКЕ")
                    .font(.lumi(11, weight: .bold))
                    .foregroundColor(LumiColor.textFaint2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 22)
                    .padding(.bottom, 10)

                VStack(spacing: 8) {
                    ForEach(bullets, id: \.1) { icon, text in
                        HStack(spacing: 10) {
                            if icon.hasPrefix("icon-") {
                                LumiIcon(name: icon, size: 15).foregroundColor(LumiColor.purpleLight)
                            } else {
                                Image(systemName: icon)
                                    .font(.system(size: 15))
                                    .foregroundColor(LumiColor.purpleLight)
                            }
                            Text(text)
                                .font(.lumi(12.5, weight: .semibold))
                                .foregroundColor(LumiColor.textBody)
                            Spacer(minLength: 0)
                        }
                        .padding(11)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.04)))
                    }
                }

                Spacer(minLength: 16)
                PrimaryButton(title: "Продолжить") { app.go(.exercise) }
            }
        }
    }
}

// MARK: - Interactive exercise ("exercise")

struct ExerciseIntroView: View {
    @EnvironmentObject var app: AppState
    @State private var thought: String = ""

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Урок 1 из 5")
                        .font(.lumi(11, weight: .bold))
                        .foregroundColor(LumiColor.textTertiary)
                    Spacer()
                    LumiIcon(name: "icon-heart-fill", size: 15)
                        .foregroundColor(Color(hex: 0xff7a94))
                }
                .padding(.bottom, 6)

                RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1)).frame(height: 6)
                    .overlay(
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 3).fill(LumiGradient.primary).frame(width: geo.size.width * 0.2)
                        }, alignment: .leading
                    )
                    .padding(.bottom, 16)

                Text("Что говорит внутренний критик?")
                    .font(.lumi(16, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.bottom, 4)
                Text("Замечай негативные мысли и не принимай их за факт")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .padding(.bottom, 14)

                MascotPlaceholder(size: 64, systemImage: "exclamationmark.bubble", assetName: "mascot-exercise-1")
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)

                VStack(spacing: 8) {
                    chip("Ты опять всё испортил")
                    chip("У тебя ничего не получится")
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)

                Text("Какая мысль звучит у тебя чаще всего?")
                    .font(.lumi(13, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.04))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    TextField("", text: $thought, prompt: Text("Напиши свою мысль…").foregroundColor(LumiColor.textDim))
                        .font(.lumi(12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(13)
                }
                .frame(height: 46)

                Spacer(minLength: 16)

                Button { app.go(.crisis) } label: {
                    Text("Мне сейчас правда тяжело →")
                        .font(.lumi(11, weight: .semibold))
                        .foregroundColor(LumiColor.textSecondary)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 12)

                PrimaryButton(
                    title: "Далее",
                    isEnabled: !thought.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ) {
                    app.go(.lessonComplete)
                }
            }
        }
        .onAppear { thought = "" }
    }

    private func chip(_ text: String) -> some View {
        Button { thought = text } label: {
            Text(text)
                .font(.lumi(11, weight: .semibold))
                .foregroundColor(Color(hex: 0xe5e0f7))
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(thought == text ? LumiColor.purple1.opacity(0.18) : LumiColor.cardFillLight)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(thought == text ? LumiColor.purple1 : LumiColor.cardBorder, lineWidth: thought == text ? 2 : 1)
        )
    }
}

// MARK: - Lesson complete

struct LessonCompleteView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen(showStars: true) {
            VStack(spacing: 0) {
                Spacer(minLength: 8)
                Text("Отличная работа!")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 6)
                Text("Ты сделал важный шаг к уверенности в себе.")
                    .font(.lumi(13, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 22)

                MascotPlaceholder(size: 190, systemImage: "moon.zzz.fill", assetName: "mascot-lessoncomplete")
                    .padding(.bottom, 26)

                HStack(spacing: 10) {
                    rewardCard(value: "+10 XP", label: "Опыт", color: Color(hex: 0x4ade80))
                    rewardCard(value: "+10", label: "Люменов", color: LumiColor.yellow, valueColor: .white, icon: "icon-lumen")
                }
                .padding(.bottom, 22)

                PrimaryButton(title: "Далее") { app.lessonCompleteContinue() }

                Button { app.go(.home) } label: {
                    Text("Вернуться на главную")
                        .font(.lumi(12, weight: .semibold))
                        .foregroundColor(LumiColor.textTertiary)
                        .padding(12)
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func rewardCard(value: String, label: String, color: Color, valueColor: Color? = nil, icon: String = "star.fill") -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle().fill(color.opacity(0.25)).frame(width: 34, height: 34)
                if icon.hasPrefix("icon-") {
                    LumiIcon(name: icon, size: 15).foregroundColor(color)
                } else {
                    Image(systemName: icon).font(.system(size: 15)).foregroundColor(color)
                }
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(value).font(.lumi(14, weight: .heavy)).foregroundColor(valueColor ?? color)
                Text(label).font(.lumi(10, weight: .semibold)).foregroundColor(LumiColor.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 16).fill(color.opacity(0.14)))
        .frame(maxWidth: .infinity)
    }
}
