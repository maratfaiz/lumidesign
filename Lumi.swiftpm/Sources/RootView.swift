import SwiftUI

struct RootView: View {
    @StateObject private var app = AppState()

    var body: some View {
        Group {
            switch app.screen {
            case .splash: SplashView()
            case .welcome: WelcomeView()
            case .disclaimer: DisclaimerView()
            case .ob1: Ob1View()
            case .ob2: Ob2View()
            case .ob3: Ob3View()
            case .ob4: Ob4View()
            case .planLoading: PlanLoadingView()
            case .planReady: PlanReadyView()
            case .streakStart: StreakStartView()
            case .home, .catalog, .profile: MainTabView()

            case .catalogDetail: CourseDetailView()
            case .lesson: LessonView()
            case .exercise: ExerciseIntroView()
            case .ex1: Ex1View()
            case .ex2: Ex2View()
            case .ex3: Ex3View()
            case .ex4: Ex4View()
            case .ex5: Ex5View()
            case .ex6: Ex6View()
            case .ex7: Ex7View()
            case .ex8: Ex8View()
            case .ex9: Ex9View()
            case .ex10: Ex10View()
            case .lessonComplete: LessonCompleteView()
            case .customize: CustomizeView()

            case .breathing: BreathingView()
            case .breathComplete: BreathCompleteView()
            case .affirmations: AffirmationsView()
            case .affirmComplete: AffirmCompleteView()
            case .beforeSleep: MeditationView()
            case .meditationComplete: MeditationCompleteView()

            case .shop: ShopView()
            case .inventory: InventoryView()
            case .achievements: AchievementsView()
            case .statistics: StatisticsView()
            case .settings: SettingsView()
            case .streakDetail: StreakDetailView()
            case .notifications: NotificationsView()
            case .crisis: CrisisView()

            case .empty: EmptyStateView()
            case .loading: LoadingDemoView()
            case .error: ErrorDemoView()
            case .allScreens: AllScreensView()
            }
        }
        .environmentObject(app)
        .preferredColorScheme(.dark)
    }
}
