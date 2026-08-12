import WidgetKit
import SwiftUI

struct ProfileEntry: TimelineEntry {
    let date: Date
    let snapshot: LumiWidgetSnapshot
}

struct ProfileProvider: TimelineProvider {
    func placeholder(in context: Context) -> ProfileEntry {
        ProfileEntry(date: .now, snapshot: .sample)
    }

    func getSnapshot(in context: Context, completion: @escaping (ProfileEntry) -> Void) {
        completion(ProfileEntry(date: .now, snapshot: LumiWidgetStore.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ProfileEntry>) -> Void) {
        let entry = ProfileEntry(date: .now, snapshot: LumiWidgetStore.load())
        // Profile stats can change any time the app is used; refresh periodically.
        completion(Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 30))))
    }
}

private struct ProfileRow: View {
    let iconName: String
    let systemFallback: String
    let tint: Color
    let label: String

    var body: some View {
        HStack(spacing: 7) {
            WidgetIcon(name: iconName, systemFallback: systemFallback, size: 15, color: tint)
            Text(label)
                .font(.lumiWidget(13, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

struct ProfileWidgetView: View {
    let snapshot: LumiWidgetSnapshot

    var body: some View {
        ZStack(alignment: .topTrailing) {
            WidgetStarField(stars: WidgetStarPresets.smallDeep)

            VStack(alignment: .leading, spacing: 9) {
                ProfileRow(iconName: "icon-stats", systemFallback: "star.fill", tint: LumiWidgetColor.inkDim, label: "Уровень \(snapshot.level)")

                GeometryReader { geo in
                    Capsule()
                        .fill(.white.opacity(0.16))
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(LumiWidgetColor.yellow)
                                .frame(width: geo.size.width * snapshot.levelProgress)
                        }
                }
                .frame(height: 5)

                ProfileRow(iconName: "icon-lumen", systemFallback: "diamond.fill", tint: LumiWidgetColor.yellow, label: "\(snapshot.lumens)")
                ProfileRow(iconName: "icon-streak", systemFallback: "flame.fill", tint: LumiWidgetColor.orange1, label: "\(snapshot.streakCount) дней")
            }
            .frame(maxWidth: 118, alignment: .leading)
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            Image("mascot-profile")
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 74)
                .padding(.top, -6)
                .padding(.trailing, -10)
        }
        .containerBackground(for: .widget) {
            LumiWidgetGradient.deep
        }
    }
}

struct ProfileWidget: Widget {
    let kind = "LumiProfileWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProfileProvider()) { entry in
            ProfileWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("Профиль коротко")
        .description("Уровень, люмены и серия дней в одном взгляде.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    ProfileWidget()
} timeline: {
    ProfileEntry(date: .now, snapshot: .sample)
}
