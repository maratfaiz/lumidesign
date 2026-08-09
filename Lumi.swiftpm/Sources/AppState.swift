import SwiftUI
import Foundation

enum Screen: Hashable {
    case splash, welcome, disclaimer
    case ob1, ob2, ob3, ob4
    case planLoading, planReady, streakStart
    case home, catalog, profile
}

enum MainTab {
    case catalog, home, profile
}

@MainActor
final class AppState: ObservableObject {
    @Published var screen: Screen = .splash

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

    // "Coming soon" sheet for screens not built yet
    @Published var comingSoonTitle: String?

    private var planTimer: Timer?

    func go(_ screen: Screen) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.screen = screen
        }
    }

    func soon(_ title: String) {
        comingSoonTitle = title
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
}
