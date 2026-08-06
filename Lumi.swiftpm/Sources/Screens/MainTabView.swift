import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var app: AppState

    private var selectedTab: MainTab {
        switch app.screen {
        case .catalog: return .catalog
        case .profile: return .profile
        default: return .home
        }
    }

    var body: some View {
        ZStack {
            LumiBackground()
            ScrollView {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeContentView()
                    case .catalog:
                        PlaceholderTabView(
                            title: "Курсы",
                            subtitle: "Список курсов скоро появится здесь",
                            icon: "text.book.closed"
                        )
                    case .profile:
                        PlaceholderTabView(
                            title: "Профиль",
                            subtitle: "Профиль и статистика скоро появятся здесь",
                            icon: "person.crop.circle"
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 12)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            TabBarView(selected: selectedTab)
        }
        .sheet(isPresented: Binding(
            get: { app.comingSoonTitle != nil },
            set: { isPresented in if !isPresented { app.comingSoonTitle = nil } }
        )) {
            ComingSoonSheet(title: app.comingSoonTitle ?? "")
        }
    }
}

struct TabBarView: View {
    @EnvironmentObject var app: AppState
    let selected: MainTab

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            tabButton(icon: "book.closed", label: "Курсы", isActive: selected == .catalog) {
                app.go(.catalog)
            }
            .frame(maxWidth: .infinity)

            Button {
                app.go(.home)
            } label: {
                VStack(spacing: 2) {
                    ZStack {
                        Circle()
                            .fill(selected == .home ? AnyShapeStyle(LumiGradient.primary) : AnyShapeStyle(Color.white.opacity(0.08)))
                            .frame(width: 52, height: 52)
                            .overlay(Circle().stroke(LumiColor.bgCard, lineWidth: 3))
                            .shadow(color: selected == .home ? LumiColor.purple2.opacity(0.55) : .clear, radius: 10, y: 6)
                        Image(systemName: "sparkle")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(selected == .home ? .white : LumiColor.textSecondary)
                    }
                    Text("Луми")
                        .font(.lumi(11, weight: .black))
                        .foregroundColor(selected == .home ? .white : LumiColor.textSecondary)
                }
            }
            .buttonStyle(.plain)
            .offset(y: -14)
            .frame(maxWidth: .infinity)

            tabButton(icon: "person.crop.circle", label: "Профиль", isActive: selected == .profile) {
                app.go(.profile)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 6)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(LumiColor.bgCard.opacity(0.96))
        .overlay(Rectangle().fill(Color.white.opacity(0.08)).frame(height: 1), alignment: .top)
    }

    @ViewBuilder
    private func tabButton(icon: String, label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                Text(label)
                    .font(.lumi(10, weight: .bold))
            }
            .foregroundColor(isActive ? LumiColor.purpleLight : LumiColor.textDim)
            .padding(.top, 8)
        }
        .buttonStyle(.plain)
    }
}

struct PlaceholderTabView: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(spacing: 14) {
            Spacer(minLength: 60)
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(LumiGradient.primary)
            Text(title)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(.white)
            Text(subtitle)
                .font(.lumi(13, weight: .semibold))
                .foregroundColor(LumiColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity)
    }
}
