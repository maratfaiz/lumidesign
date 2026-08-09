import SwiftUI

/// The "critic → fact" mini-exercise chain (ex1…ex5). Reachable from the
/// prototype's own screen list, not from a natural in-app link — same as in
/// the original, where these live alongside (not inside) the main lesson flow.
private let ex1Phrases = [
    "«Ты опять всё испортил»",
    "«Ничего у тебя не получится»",
    "«Ты недостаточно хорош(а)»",
]

struct Ex1View: View {
    @EnvironmentObject var app: AppState
    @State private var selected: Int?

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 0) {
                exerciseHeader(subtitle: "Курс 1 · Замечаем критику", progress: 0.2)

                HStack(alignment: .top, spacing: 10) {
                    ZStack {
                        Circle().fill(LumiColor.purple1.opacity(0.2)).frame(width: 34, height: 34)
                        Image(systemName: "face.smiling").font(.system(size: 15)).foregroundColor(LumiColor.purpleLight)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Что сегодня сказал внутренний критик?")
                            .font(.lumi(13, weight: .heavy))
                            .foregroundColor(.white)
                        Text("Вспомни фразу и выбери, или напиши свою")
                            .font(.lumi(11, weight: .semibold))
                            .foregroundColor(LumiColor.textSecondary)
                    }
                }
                .padding(.bottom, 14)

                VStack(spacing: 8) {
                    ForEach(Array(ex1Phrases.enumerated()), id: \.offset) { index, phrase in
                        Button { selected = index } label: {
                            Text(phrase)
                                .font(.lumi(13, weight: .semibold))
                                .foregroundColor(Color(hex: 0xe5e0f7))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(selected == index ? LumiColor.purple1.opacity(0.18) : Color.white.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(selected == index ? LumiColor.purple1 : Color.white.opacity(0.1), lineWidth: selected == index ? 2 : 1)
                        )
                    }
                    Button { selected = 3 } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Написать свою мысль")
                        }
                        .font(.lumi(13, weight: .bold))
                        .foregroundColor(LumiColor.purpleLight)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .background(RoundedRectangle(cornerRadius: 14).fill(LumiColor.purple1.opacity(0.12)))
                    .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5])).foregroundColor(LumiColor.purple1.opacity(0.4)))
                }

                Spacer(minLength: 12)
                tipRow(text: "Просто запиши её. Сейчас мы ничего не оцениваем.", icon: "pencil.and.scribble")
                PrimaryButton(title: "Продолжить →") { app.go(.ex2) }
            }
        }
    }
}

struct Ex2View: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс 1 · Замечаем критику", progress: 0.2)

                Text("Вот твоя мысль критика")
                    .font(.lumi(20, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 18)

                ZStack {
                    Circle()
                        .fill(RadialGradient(colors: [LumiColor.purple1.opacity(0.22), LumiColor.purple1.opacity(0.04)], center: .center, startRadius: 0, endRadius: 110))
                        .overlay(Circle().stroke(LumiColor.purple1.opacity(0.3), lineWidth: 1))
                        .frame(width: 220, height: 220)
                    Text("«Я опять всё испортил»")
                        .font(.lumi(16, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 10)

                Spacer(minLength: 8)
                tipRow(text: "Это мысль. Она не обязана быть фактом.", icon: "face.dashed")
                PrimaryButton(title: "Дальше →") { app.go(.ex3) }
            }
        }
    }
}

struct Ex3View: View {
    @EnvironmentObject var app: AppState

    private var borderColor: Color {
        if app.ex3DragOffset > 40 { return Color(hex: 0xffb347) }
        if app.ex3DragOffset < -40 { return Color(hex: 0x7fe0a8) }
        return LumiColor.purple1.opacity(0.4)
    }

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс 1 · Замечаем критику", progress: 0.4)

                Text("Факт или оценка?")
                    .font(.lumi(19, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.bottom, 4)

                if !app.ex3Checked {
                    Text("Перетащи карточку влево, если это факт, вправо — если оценка")
                        .font(.lumi(12, weight: .semibold))
                        .foregroundColor(LumiColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    HStack {
                        Label("ФАКТ", systemImage: "arrow.left")
                            .font(.lumi(12, weight: .heavy))
                            .foregroundColor(Color(hex: 0x7fe0a8))
                        Spacer()
                        Label {
                            Text("ОЦЕНКА").font(.lumi(12, weight: .heavy)).foregroundColor(Color(hex: 0xffb347))
                        } icon: {
                            Image(systemName: "arrow.right").foregroundColor(Color(hex: 0xffb347))
                        }
                    }
                    .padding(.bottom, 16)

                    Text("«Ты опять всё испортил»")
                        .font(.lumi(20, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 280, minHeight: 220)
                        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.07)))
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 2))
                        .frame(maxWidth: .infinity)
                        .offset(x: app.ex3DragOffset)
                        .rotationEffect(.degrees(Double(max(-12, min(12, app.ex3DragOffset / 14)))))
                        .gesture(
                            DragGesture()
                                .onChanged { value in app.ex3DragOffset = value.translation.width }
                                .onEnded { _ in app.resolveEx3Drag() }
                        )
                        .padding(.bottom, 16)
                } else {
                    Text("«Ты опять всё испортил»")
                        .font(.lumi(14, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.07)))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: 0xffb347), lineWidth: 2))
                        .padding(.bottom, 20)

                    tipRow(text: "Верно! Это оценка, а не факт.", icon: "hand.point.right.fill")
                        .padding(.bottom, 14)

                    Text("А как бы звучал факт?")
                        .font(.lumi(13, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)

                    placeholderField("Напиши здесь…")
                }

                Spacer(minLength: 12)
                PrimaryButton(title: app.ex3Checked ? "Далее →" : "Проверить") {
                    if !app.ex3Checked {
                        app.ex3Checked = true
                    } else {
                        app.go(.ex4)
                    }
                }
            }
        }
        .onDisappear {
            app.ex3Checked = false
            app.ex3DragOffset = 0
        }
    }
}

struct Ex4View: View {
    @EnvironmentObject var app: AppState
    @State private var fact: String = ""

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс 1 · Замечаем критику", progress: 0.4)

                Text("Перепиши мысль критика как факт")
                    .font(.lumi(16, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 18)

                VStack(alignment: .leading, spacing: 4) {
                    Text("МЫСЛЬ КРИТИКА")
                        .font(.lumi(10, weight: .bold))
                        .foregroundColor(LumiColor.textTertiary)
                    Text("«Ты опять всё испортил»")
                        .font(.lumi(13, weight: .heavy))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(13)
                .lumiCard(radius: 14)
                .padding(.bottom, 10)

                Image(systemName: "arrow.down")
                    .foregroundColor(LumiColor.textTertiary)
                    .padding(.bottom, 10)

                Text("Напиши факт")
                    .font(.lumi(12, weight: .bold))
                    .foregroundColor(LumiColor.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 6)

                placeholderField("Напиши здесь…", text: $fact)
                    .padding(.bottom, 16)

                Spacer(minLength: 8)
                tipRow(text: "Представь, что ты журналист. Только факты.", icon: "newspaper")
                PrimaryButton(title: "Проверить") { app.go(.ex5) }
            }
        }
    }
}

struct Ex5View: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                exerciseHeader(subtitle: "Курс 1 · Замечаем критику", progress: 0.6)

                Text("Смотри, как это работает")
                    .font(.lumi(16, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 18)

                HStack(spacing: 10) {
                    MascotPlaceholder(size: 44, systemImage: "text.bubble")
                    Text("«Я опять всё испортил»")
                        .font(.lumi(13, weight: .heavy))
                        .foregroundColor(Color(hex: 0xe5e0f7))
                    Spacer(minLength: 0)
                }
                .padding(12)
                .lumiCard(radius: 14)
                .padding(.bottom, 8)

                Image(systemName: "arrow.down")
                    .foregroundColor(LumiColor.textTertiary)
                    .padding(.bottom, 8)

                Text("Я замечаю мысль, что «Я опять всё испортил»")
                    .font(.lumi(13, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 14).fill(LumiColor.purple1.opacity(0.2)))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(LumiColor.purple1, lineWidth: 1.5))
                    .padding(.bottom, 14)

                Spacer(minLength: 8)
                tipRow(text: "Мысль есть, но её не нужно принимать за правду.", icon: "sparkles", size: 34)
                PrimaryButton(title: "Попробовать самому →") { app.go(.lessonComplete) }
            }
        }
    }
}

// MARK: - Shared bits for the exercise screens

@ViewBuilder
func exerciseHeader(subtitle: String, progress: Double) -> some View {
    VStack(alignment: .leading, spacing: 8) {
        Text(subtitle)
            .font(.lumi(12, weight: .bold))
            .foregroundColor(LumiColor.textSecondary)
        RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.1)).frame(height: 5)
            .overlay(
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 3).fill(LumiGradient.primary).frame(width: geo.size.width * CGFloat(progress))
                }, alignment: .leading
            )
    }
    .padding(.bottom, 18)
}

@ViewBuilder
func tipRow(text: String, icon: String, size: CGFloat = 56) -> some View {
    HStack(alignment: .top, spacing: 10) {
        MascotPlaceholder(size: size, systemImage: icon)
        Text(text)
            .font(.lumi(12.5, weight: .semibold))
            .foregroundColor(LumiColor.textBody)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(11)
    .lumiCard(radius: 14)
    .padding(.bottom, 14)
}

@ViewBuilder
func placeholderField(_ placeholder: String, text: Binding<String>? = nil) -> some View {
    ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.04))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
        if let text {
            TextField("", text: text, prompt: Text(placeholder).foregroundColor(LumiColor.textDim))
                .font(.lumi(12, weight: .semibold))
                .foregroundColor(.white)
                .padding(13)
        } else {
            Text(placeholder)
                .font(.lumi(12, weight: .semibold))
                .foregroundColor(LumiColor.textDim)
                .padding(13)
        }
    }
    .frame(height: 52)
}
