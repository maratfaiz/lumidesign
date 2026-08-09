import SwiftUI

struct Ob1View: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        ZStack {
            LumiBackground()
            VStack(spacing: 0) {
                OnboardingHeader(step: 1, total: 4)

                VStack(spacing: 8) {
                    Text("Как ты сейчас оцениваешь свою уверенность?")
                        .font(.lumi(24, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text("Выбери на шкале от 1 до 5")
                        .font(.lumi(12, weight: .semibold))
                        .foregroundColor(LumiColor.textSecondary)
                }
                .padding(.top, 14)

                Spacer()
                MascotPlaceholder(size: 150, systemImage: "questionmark.circle")
                Spacer()

                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { n in
                        RatingCircle(number: n, isSelected: app.confidenceRating == n) {
                            withAnimation(.spring(response: 0.3)) { app.confidenceRating = n }
                        }
                    }
                }

                HStack {
                    Text("Совсем не уверен(а)")
                    Spacer()
                    Text("Очень уверен(а)")
                }
                .font(.lumi(11, weight: .semibold))
                .foregroundColor(LumiColor.textTertiary)
                .padding(.top, 10)

                Spacer()
                PrimaryButton(title: "Далее →") { app.go(.ob2) }
            }
            .padding(20)
        }
    }
}

struct Ob2View: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        ZStack {
            LumiBackground()
            VStack(spacing: 0) {
                OnboardingHeader(step: 2, total: 4)

                Text("Что тебя беспокоит сильнее всего?")
                    .font(.lumi(23, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 14)
                Text("Выбери то, что ближе")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .padding(.top, 6)
                    .padding(.bottom, 10)

                MascotPlaceholder(size: 110, systemImage: "person.fill.questionmark")
                    .padding(.bottom, 14)

                VStack(spacing: 8) {
                    ForEach(Concern.allCases) { concern in
                        SelectableOptionRow(icon: concern.icon, title: concern.title, isSelected: app.concern == concern) {
                            withAnimation { app.concern = concern }
                        }
                    }
                }

                Spacer()
                PrimaryButton(title: "Далее") { app.go(.ob3) }
            }
            .padding(20)
        }
    }
}

struct Ob3View: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        ZStack {
            LumiBackground()
            VStack(spacing: 0) {
                OnboardingHeader(step: 3, total: 4)

                Text("Какой формат тебе ближе?")
                    .font(.lumi(23, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 26)
                Text("Выбери предпочитаемый")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .padding(.top, 6)
                    .padding(.bottom, 10)

                MascotPlaceholder(size: 110, systemImage: "headphones", assetName: "mascot-home")
                    .padding(.bottom, 20)

                VStack(spacing: 8) {
                    ForEach(LearningFormat.allCases) { format in
                        SelectableOptionRow(icon: format.icon, title: format.title, isSelected: app.format == format) {
                            withAnimation { app.format = format }
                        }
                    }
                }

                Spacer()
                PrimaryButton(title: "Далее") { app.go(.ob4) }
            }
            .padding(20)
        }
    }
}

struct Ob4View: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        ZStack {
            LumiBackground()
            VStack(spacing: 0) {
                OnboardingHeader(step: 4, total: 4)

                Text("Какая у тебя цель на этот путь?")
                    .font(.lumi(23, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 26)
                Text("Выбери то, что важно")
                    .font(.lumi(12, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .padding(.top, 6)
                    .padding(.bottom, 10)

                MascotPlaceholder(size: 110, systemImage: "heart.circle")
                    .padding(.bottom, 20)

                VStack(spacing: 8) {
                    ForEach(Goal.allCases) { goal in
                        SelectableOptionRow(icon: goal.icon, title: goal.title, isSelected: app.goal == goal) {
                            withAnimation { app.goal = goal }
                        }
                    }
                }

                Spacer()
                PrimaryButton(title: "Готово") { app.go(.planLoading) }
            }
            .padding(20)
        }
    }
}
