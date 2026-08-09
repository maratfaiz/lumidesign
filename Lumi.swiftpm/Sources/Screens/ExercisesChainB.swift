import SwiftUI

/// The self-compassion mini-exercise chain (ex6…ex10) — like ex1…ex5, this is
/// reachable via the app's screen list rather than a natural forward link.

struct Ex6View: View {
    @EnvironmentObject var app: AppState
    @State private var support: String = ""

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс · Что сказал бы друг?", progress: 0.2)

                HStack(alignment: .top, spacing: 10) {
                    ZStack {
                        Circle().fill(Color(hex: 0x5aaaff).opacity(0.18)).frame(width: 34, height: 34)
                        Image(systemName: "person.2.fill").font(.system(size: 15)).foregroundColor(LumiColor.blueChip)
                    }
                    Text("Я совершил ошибку на работе… Мне так стыдно.")
                        .font(.lumi(12.5, weight: .semibold))
                        .foregroundColor(Color(hex: 0xe5e0f7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(11)
                .lumiCard(radius: 14)
                .padding(.bottom, 16)

                Text("Что бы ты ему сказал?")
                    .font(.lumi(13, weight: .heavy))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)

                placeholderField("Напиши поддержку для друга…", text: $support)
                    .onChange(of: support) { _, newValue in
                        if newValue.count > 200 { support = String(newValue.prefix(200)) }
                    }
                Text("\(support.count) / 200")
                    .font(.lumi(10, weight: .semibold))
                    .foregroundColor(LumiColor.textDim)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, 16)

                Spacer(minLength: 8)
                tipRow(text: "А теперь попробуй сказать эти же слова себе. Ты этого заслуживаешь.", icon: "heart.text.square")
                PrimaryButton(
                    title: "Готово",
                    isEnabled: !support.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ) {
                    app.go(.ex7)
                }
            }
        }
        .onAppear { support = "" }
    }
}

private struct Ex7Quality {
    let icon: String
    let title: String
}

// Qualities in their displayed (top-row) order.
private let ex7Qualities: [Ex7Quality] = [
    .init(icon: "heart.fill", title: "Доброта"),
    .init(icon: "globe", title: "Общая человечность"),
    .init(icon: "person.fill", title: "Осознанность"),
]

// Phrases in their displayed (bottom-row) order — intentionally not aligned
// index-for-index with the qualities above; see `ex7CorrectBottomForTop`.
private let ex7Phrases: [String] = [
    "«Я замечаю свои чувства и принимаю их без осуждения»",
    "«Я отношусь к себе с теплом и заботой, а не с критикой»",
    "«Я не один(а) со своими трудностями. Все иногда ошибаются»",
]

struct Ex7View: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс · Соедини качества", progress: 0.4)

                Text("Соедини каждую часть сострадания с её смыслом")
                    .font(.lumi(15, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)

                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        topCard(index)
                    }
                }
                .padding(.bottom, 10)

                Text(app.ex7AllMatched ? "Отлично! Ты собрал воедино три части сострадания." : "Нажми на качество, затем на подходящую фразу.")
                    .font(.lumi(11.5, weight: .semibold))
                    .foregroundColor(LumiColor.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)

                VStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        bottomCard(index)
                    }
                }
                .padding(.bottom, 16)

                Spacer(minLength: 8)
                tipRow(text: "Отлично! Ты собрал воедино три части сострадания.", icon: "hands.clap.fill")
                PrimaryButton(title: "Далее", isEnabled: app.ex7AllMatched) {
                    guard app.ex7AllMatched else { return }
                    app.go(.ex8)
                }
            }
        }
        .onDisappear {
            app.ex7Matched = [false, false, false]
            app.ex7SelectedTop = nil
        }
    }

    private func topCard(_ index: Int) -> some View {
        let quality = ex7Qualities[index]
        let matched = app.ex7Matched[index]
        let selected = app.ex7SelectedTop == index
        return Button { app.ex7SelectTop(index) } label: {
            VStack(spacing: 6) {
                Image(systemName: quality.icon)
                    .font(.system(size: 18))
                    .foregroundColor(matched || selected ? LumiColor.purpleLight : LumiColor.textBody)
                Text(quality.title)
                    .font(.lumi(10.5, weight: .bold))
                    .foregroundColor(LumiColor.textBody)
                    .multilineTextAlignment(.center)
                if matched {
                    Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundColor(Color(hex: 0x7fe0a8))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .disabled(matched)
        .background(RoundedRectangle(cornerRadius: 12).fill(selected ? LumiColor.purple1.opacity(0.2) : Color.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(selected ? LumiColor.purple1 : Color.white.opacity(0.1), lineWidth: selected ? 2 : 1))
    }

    private func bottomCard(_ index: Int) -> some View {
        let matched = app.ex7BottomMatched(index)
        return Button { app.ex7SelectBottom(index) } label: {
            Text(ex7Phrases[index])
                .font(.lumi(11.5, weight: .semibold))
                .foregroundColor(Color(hex: 0xe5e0f7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
        }
        .buttonStyle(.plain)
        .disabled(matched)
        .background(RoundedRectangle(cornerRadius: 12).fill(matched ? Color(hex: 0x7fe0a8).opacity(0.12) : Color.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(matched ? Color(hex: 0x7fe0a8) : Color.white.opacity(0.1), lineWidth: matched ? 1.5 : 1))
    }
}

struct Ex8View: View {
    @EnvironmentObject var app: AppState
    @State private var letter: String = ""

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс · Письмо другу", progress: 0.6)

                Text("Напиши письмо поддержки другу (или себе в трудный день)")
                    .font(.lumi(15, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 20))
                        .foregroundColor(LumiColor.purple1)
                    Text("Дорогой друг,")
                        .font(.lumi(13, weight: .heavy))
                        .foregroundColor(Color(hex: 0x3a2f5c))
                    ZStack(alignment: .topLeading) {
                        if letter.isEmpty {
                            Text("Напиши здесь несколько тёплых строк…")
                                .font(.lumi(12.5, weight: .medium))
                                .foregroundColor(Color(hex: 0x3a2f5c).opacity(0.45))
                                .padding(.top, 8)
                                .allowsHitTesting(false)
                        }
                        TextEditor(text: $letter)
                            .font(.lumi(12.5, weight: .medium))
                            .foregroundColor(Color(hex: 0x3a2f5c))
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .frame(minHeight: 110)
                }
                .padding(16)
                .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: 0xf4ecd8)))
                .shadow(color: .black.opacity(0.3), radius: 12, y: 8)

                tipRow(text: "Сохрани это письмо. К нему можно вернуться позже.", icon: "envelope.open.fill")
                    .padding(.top, 14)
                PrimaryButton(
                    title: "Отправить письмо",
                    isEnabled: !letter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ) {
                    app.go(.ex9)
                }
            }
        }
        .onAppear { letter = "" }
    }
}

struct Ex9View: View {
    @EnvironmentObject var app: AppState

    private let options: [(key: String, icon: String, title: String)] = [
        ("message", "message.fill", "Написать сообщение"),
        ("call", "phone.fill", "Сделать звонок"),
        ("task", "checkmark.circle.fill", "Доделать задачу"),
        ("custom", "wand.and.stars", "Свой вариант"),
    ]
    private let whens: [(key: String, label: String)] = [
        ("morning", "Утром"), ("day", "Днём"), ("evening", "Вечером"),
    ]

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс · Маленькие действия", progress: 0.8)

                Text("Выбери одно маленькое действие на сегодня")
                    .font(.lumi(16, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 18)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(options, id: \.key) { option in
                        Button {
                            app.ex9Selected = option.key
                            app.ex9When = nil
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: option.icon).font(.system(size: 18)).foregroundColor(Color(hex: 0xe5e0f7))
                                Text(option.title)
                                    .font(.lumi(11.5, weight: .bold))
                                    .foregroundColor(Color(hex: 0xe5e0f7))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)
                        .background(RoundedRectangle(cornerRadius: 14).fill(app.ex9Selected == option.key ? LumiColor.purple1.opacity(0.18) : Color.white.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(app.ex9Selected == option.key ? LumiColor.purple1 : Color.white.opacity(0.1), lineWidth: app.ex9Selected == option.key ? 2 : 1))
                    }
                }
                .padding(.bottom, 16)

                if app.ex9Selected != nil {
                    Text("Когда сделаешь это сегодня?")
                        .font(.lumi(12, weight: .heavy))
                        .foregroundColor(Color(hex: 0xc9c2e6))
                        .padding(.bottom, 8)
                    HStack(spacing: 8) {
                        ForEach(whens, id: \.key) { when in
                            Button { app.ex9When = when.key } label: {
                                Text(when.label)
                                    .font(.lumi(12, weight: .bold))
                                    .foregroundColor(app.ex9When == when.key ? .white : Color(hex: 0xc9c2e6))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.plain)
                            .background(RoundedRectangle(cornerRadius: 12).fill(app.ex9When == when.key ? LumiColor.purple1.opacity(0.22) : Color.white.opacity(0.05)))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(app.ex9When == when.key ? LumiColor.purple1 : Color.white.opacity(0.1), lineWidth: app.ex9When == when.key ? 1.5 : 1))
                        }
                    }
                    .padding(.bottom, 16)
                }

                Spacer(minLength: 8)
                tipRow(text: hint, icon: "paperplane.fill")
                PrimaryButton(title: "Далее", isEnabled: app.ex9Selected != nil && app.ex9When != nil) {
                    guard app.ex9Selected != nil, app.ex9When != nil else { return }
                    app.go(.ex10)
                }
            }
        }
        .onDisappear {
            app.ex9Selected = nil
            app.ex9When = nil
        }
    }

    private var hint: String {
        guard app.ex9Selected != nil else { return "Любое маленькое действие — это шаг к уверенности!" }
        if app.ex9When != nil {
            return "Отлично! Ты запланировал конкретное время — так действие почти наверняка случится."
        }
        return "Учёные называют это «намерением-планом»: выбери, когда именно сделаешь это сегодня."
    }
}

private struct Ex10Value {
    let icon: String
    let title: String
    let color: Color
}

private let ex10Values: [Ex10Value] = [
    .init(icon: "heart.fill", title: "Забота", color: Color(hex: 0xff8fa8)),
    .init(icon: "book.closed.fill", title: "Развитие", color: Color(hex: 0xc9c2e6)),
    .init(icon: "checkmark.seal.fill", title: "Честность", color: Color(hex: 0xc9c2e6)),
    .init(icon: "bolt.fill", title: "Смелость", color: Color(hex: 0x7fe0a8)),
]

struct Ex10View: View {
    @EnvironmentObject var app: AppState
    @State private var selected: Int = 0
    @State private var reflection: String = ""

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс · Ценности", progress: 0.2)

                Text("Выбери ценность, которая важна для тебя прямо сейчас")
                    .font(.lumi(15, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(Array(ex10Values.enumerated()), id: \.offset) { index, value in
                        Button { selected = index } label: {
                            VStack(spacing: 8) {
                                Image(systemName: value.icon).font(.system(size: 17)).foregroundColor(value.color)
                                Text(value.title).font(.lumi(12, weight: .heavy)).foregroundColor(selected == index ? .white : Color(hex: 0xe5e0f7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(.plain)
                        .background(RoundedRectangle(cornerRadius: 14).fill(selected == index ? LumiColor.purple1.opacity(0.18) : Color.white.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(selected == index ? LumiColor.purple1 : Color.white.opacity(0.1), lineWidth: selected == index ? 2 : 1))
                    }
                }
                .padding(.bottom, 16)

                Text("Когда за последнюю неделю ты поступил(а) в соответствии с этой ценностью?")
                    .font(.lumi(13, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)

                placeholderField("Опиши ситуацию…", text: $reflection)
                    .padding(.bottom, 14)

                Spacer(minLength: 8)
                tipRow(text: "Спасибо! Ты живёшь в согласии со своими ценностями.", icon: "heart.circle.fill")
                PrimaryButton(
                    title: "Готово",
                    isEnabled: !reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ) {
                    app.go(.lessonComplete)
                }
            }
        }
        .onAppear { reflection = "" }
    }
}
