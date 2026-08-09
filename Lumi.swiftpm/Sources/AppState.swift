import SwiftUI
import Foundation

enum Screen: Hashable {
    case splash, welcome, disclaimer
    case ob1, ob2, ob3, ob4
    case planLoading, planReady, streakStart
    case home, catalog, profile

    case catalogDetail, lesson, exercise
    case ex1, ex2, ex3, ex4, ex5, ex6, ex7, ex8, ex9, ex10
    case lessonComplete
    case customize

    case breathing, breathComplete
    case affirmations, affirmComplete
    case beforeSleep, meditationComplete

    case shop, inventory, achievements
    case statistics, settings, streakDetail, notifications, crisis
    case empty, loading, error

    /// Not part of the original prototype's user-facing flow — a jump-to-any-screen
    /// menu, standing in for the prototype's own left-rail "Все экраны" list, so
    /// every screen stays reachable even ones with no natural in-app link into them.
    case allScreens

    /// Whether the bottom tab bar shows on this screen, matching the prototype's
    /// `showTabBar = ['home','catalog','profile'].includes(s)`.
    var showsTabBar: Bool {
        switch self {
        case .home, .catalog, .profile: return true
        default: return false
        }
    }

    /// Whether a "←" back button shows, matching the prototype's `excludedBack` list.
    var showsBackButton: Bool {
        switch self {
        case .splash, .welcome, .disclaimer, .ob1, .ob2, .ob3, .ob4,
             .planLoading, .planReady, .streakStart, .home, .catalog, .profile:
            return false
        default:
            return true
        }
    }
}

enum MainTab {
    case catalog, home, profile
}

@MainActor
final class AppState: ObservableObject {
    @Published var screen: Screen = .splash
    private var history: [Screen] = []

    // Onboarding answers
    @Published var confidenceRating: Int = 3
    @Published var concern: Concern = .notGoodEnough
    @Published var format: LearningFormat = .interactive
    @Published var goal: Goal = .confidence

    // Plan loading
    @Published var planLoadingPct: Double = 0

    // Home stats
    @Published var streakDays: Int = 7
    @Published var gems: Int = 1230
    @Published var freezesAvailable: Int = 1

    // Lesson flow: whether "lessoncomplete" continues into the streak-start
    // celebration (very first lesson) or back to the course page.
    @Published var firstLessonFlow: Bool = false

    // MARK: Ex3 — "факт или оценка" drag classification
    @Published var ex3Checked: Bool = false
    @Published var ex3DragOffset: CGFloat = 0

    // MARK: Ex7 — matching game
    @Published var ex7SelectedTop: Int?
    @Published var ex7Matched: [Bool] = [false, false, false]

    // MARK: Ex9 — small action picker
    @Published var ex9Selected: String?
    @Published var ex9When: String?

    // MARK: Breathing (4-7-8 technique)
    @Published var breathElapsed: Int = 43
    @Published var breathPlaying: Bool = true
    @Published var breathInfoOpen: Bool = false
    private var breathTimer: Timer?

    // MARK: Affirmations
    let affirmations = [
        "Я справлюсь с этим шаг за шагом.",
        "Мои ошибки не определяют меня.",
        "Я имею право отдыхать.",
        "Я достоин(а) любви и уважения.",
    ]
    @Published var affirmIndex: Int = 3
    @Published var affirmSound: Bool = true
    @Published var affirmRepeat: Bool = false
    @Published var affirmSpeed: Double = 1
    @Published var affirmPlaying: Bool = true

    // MARK: Meditation ("перед сном")
    @Published var meditationDuration: Int = 10
    @Published var meditationElapsed: Int = 0
    @Published var meditationPlaying: Bool = false
    @Published var meditationAmbience: String = "silence"
    private var meditationTimer: Timer?

    // MARK: Streak freezes (separate collectible tracked on the Streak screen,
    // independent from the static "1/2" chip shown on Home — the prototype
    // itself keeps these as two unrelated pieces of state).
    @Published var freezeCount: Int = 2
    @Published var freezeUsed: Bool = false

    // MARK: Shop / customize
    @Published var shopFilter: String = "all"
    @Published var customizeFilter: String = "all"
    @Published var equippedSkin: String = "classic"
    @Published var previewSkin: String = "classic"

    let skins: [Skin] = [
        Skin(key: "classic", name: "Без образа", category: .base, price: nil, locked: false),
        Skin(key: "night", name: "Кепка", category: .base, price: 400, locked: false),
        Skin(key: "sport", name: "Очки мечтателя", category: .rare, price: 80, locked: false),
        Skin(key: "scientist", name: "Галакт. наушники", category: .rare, price: 120, locked: false),
        Skin(key: "musician", name: "Звёздная корона", category: .special, price: 100, locked: false),
        Skin(key: "traveler", name: "Плащ путешественника", category: .rare, price: 200, locked: false),
        Skin(key: "cosmonaut", name: "Костюм космонавта", category: .special, locked: true, lessonsCur: 0, lessonsReq: 20),
        Skin(key: "wizard", name: "Мантия волшебника", category: .special, locked: true, lessonsCur: 0, lessonsReq: 30),
        Skin(key: "lucky", name: "Талисман удачи", category: .special, locked: true, lessonsCur: 0, lessonsReq: 40),
    ]

    private var planTimer: Timer?

    func go(_ screen: Screen) {
        history.append(self.screen)
        withAnimation(.easeInOut(duration: 0.25)) {
            self.screen = screen
        }
    }

    func goBack() {
        let previous = history.popLast() ?? .home
        withAnimation(.easeInOut(duration: 0.25)) {
            self.screen = previous
        }
    }

    func startPlanLoading() {
        planTimer?.invalidate()
        planLoadingPct = 0
        planTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] timer in
            Task { @MainActor in
                guard let self else { timer.invalidate(); return }
                if self.planLoadingPct >= 100 {
                    timer.invalidate()
                    self.planTimer = nil
                    return
                }
                self.planLoadingPct = min(100, self.planLoadingPct + 1)
            }
        }
    }

    // MARK: Lesson completion routing

    func lessonCompleteContinue() {
        if firstLessonFlow {
            firstLessonFlow = false
            go(.streakStart)
        } else {
            go(.catalogDetail)
        }
    }

    // MARK: Ex7 matching game

    /// The three phrase cards are shown in a fixed order that intentionally doesn't
    /// line up positionally with the quality cards above them — top quality `i`'s
    /// correct phrase sits at bottom index `ex7CorrectBottomForTop[i]`, matching
    /// the prototype's fixed (not randomized) phrase order.
    let ex7CorrectBottomForTop = [1, 2, 0]

    func ex7SelectTop(_ index: Int) {
        guard !ex7Matched[index] else { return }
        ex7SelectedTop = index
    }

    func ex7SelectBottom(_ bottomIndex: Int) {
        guard let top = ex7SelectedTop else { return }
        if ex7CorrectBottomForTop[top] == bottomIndex {
            ex7Matched[top] = true
        }
        ex7SelectedTop = nil
    }

    func ex7BottomMatched(_ bottomIndex: Int) -> Bool {
        ex7Matched.indices.contains { ex7Matched[$0] && ex7CorrectBottomForTop[$0] == bottomIndex }
    }

    var ex7AllMatched: Bool { ex7Matched.allSatisfy { $0 } }

    // MARK: Ex3 drag classification

    func resolveEx3Drag() {
        if abs(ex3DragOffset) > 90 {
            ex3DragOffset = ex3DragOffset > 0 ? 90 : -90
            ex3Checked = true
        } else {
            ex3DragOffset = 0
        }
    }

    // MARK: Breathing timer

    func toggleBreathing() {
        breathPlaying.toggle()
    }

    func startBreathingTimerIfNeeded() {
        guard breathTimer == nil else { return }
        breathTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, self.screen == .breathing else { return }
                guard self.breathPlaying else { return }
                if self.breathElapsed >= 113 {
                    self.go(.breathComplete)
                } else {
                    self.breathElapsed += 1
                }
            }
        }
    }

    func stopBreathingTimer() {
        breathTimer?.invalidate()
        breathTimer = nil
    }

    // MARK: Meditation timer

    func toggleMeditation() {
        if meditationPlaying {
            meditationTimer?.invalidate()
            meditationTimer = nil
            meditationPlaying = false
            return
        }
        meditationPlaying = true
        meditationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                let total = self.meditationDuration * 60
                if self.meditationElapsed + 1 >= total {
                    self.meditationTimer?.invalidate()
                    self.meditationTimer = nil
                    self.meditationElapsed = total
                    self.meditationPlaying = false
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    self.go(.meditationComplete)
                } else {
                    self.meditationElapsed += 1
                }
            }
        }
    }

    func selectMeditationDuration(_ minutes: Int) {
        guard !meditationPlaying else { return }
        meditationDuration = minutes
        meditationElapsed = 0
    }

    func stopMeditationTimer() {
        meditationTimer?.invalidate()
        meditationTimer = nil
    }

    // MARK: Freeze

    func useFreeze() {
        guard freezeCount > 0, !freezeUsed else { return }
        freezeCount -= 1
        freezeUsed = true
    }
}
