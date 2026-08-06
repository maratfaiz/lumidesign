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
            }
        }
        .environmentObject(app)
        .preferredColorScheme(.dark)
    }
}
