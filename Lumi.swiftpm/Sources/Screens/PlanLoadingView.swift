import SwiftUI

struct PlanLoadingView: View {
    @EnvironmentObject var app: AppState

    private var dotCount: Int {
        Int(app.planLoadingPct / 8) % 3 + 1
    }

    var body: some View {
        ZStack {
            LumiBackground()
            StarField(stars: StarPresets.planLoading)

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [LumiColor.purple1.opacity(0.35), .clear],
                                center: .center, startRadius: 0, endRadius: 115
                            )
                        )
                        .frame(width: 230, height: 230)
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 12)
                        .frame(width: 196, height: 196)
                    Circle()
                        .trim(from: 0, to: CGFloat(app.planLoadingPct / 100))
                        .stroke(LumiColor.purple1, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 196, height: 196)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.15), value: app.planLoadingPct)
                    Text("\(Int(app.planLoadingPct))%")
                        .font(.system(size: 46, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: LumiColor.purple1.opacity(0.7), radius: 12)
                }

                Text("Собирается план" + String(repeating: ".", count: dotCount))
                    .font(.lumi(12, weight: .bold))
                    .foregroundColor(LumiColor.textTertiary)
            }
        }
        .onAppear {
            app.startPlanLoading()
        }
        .onChange(of: app.planLoadingPct) { _, newValue in
            if newValue >= 100 {
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    if app.screen == .planLoading {
                        app.go(.planReady)
                    }
                }
            }
        }
    }
}
