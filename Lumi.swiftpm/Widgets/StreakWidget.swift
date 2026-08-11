import WidgetKit
import SwiftUI

private enum StreakState: Equatable {
    case fresh          // состояние А — серии ещё нет
    case active         // состояние Б — серия активна
    case awaitingReturn // состояние В — давно не заходил (2+ дня)

    init(_ snapshot: LumiWidgetSnapshot) {
        if snapshot.daysSinceLastActive >= 2 {
            self = .awaitingReturn
        } else if snapshot.streakCount > 0 {
            self = .active
        } else {
            self = .fresh
        }
    }
}

struct StreakEntry: TimelineEntry {
    let date: Date
    let snapshot: LumiWidgetSnapshot
}

struct StreakProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(date: .now, snapshot: .sample)
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> Void) {
        completion(StreakEntry(date: .now, snapshot: LumiWidgetStore.load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakEntry>) -> Void) {
        let entry = StreakEntry(date: .now, snapshot: LumiWidgetStore.load())
        // Streak state only changes at day boundaries; refresh once after midnight.
        let midnight = Calendar.current.nextDate(after: .now, matching: DateComponents(hour: 0, minute: 5), matchingPolicy: .nextTime) ?? .now.addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

private struct WeekStripView: View {
    let statuses: [LumiDayStatus]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(Array(statuses.enumerated()), id: \.offset) { _, status in
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(status == .empty ? Color.white.opacity(0.16) : Color.white.opacity(0.92))
                    .frame(width: 22, height: 22)
                    .overlay {
                        switch status {
                        case .done:
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .black))
                                .foregroundStyle(LumiWidgetColor.purple2)
                        case .freeze:
                            WidgetIcon(name: "icon-freeze", systemFallback: "snowflake", size: 12, color: Color(widgetHex: 0x4a9fe0))
                        case .empty:
                            EmptyView()
                        }
                    }
            }
        }
    }
}

struct StreakWidgetView: View {
    let snapshot: LumiWidgetSnapshot

    private var state: StreakState { StreakState(snapshot) }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            content
                .frame(maxWidth: 190, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .leading)

            mascot
                .frame(width: mascotSize.width, height: mascotSize.height)
                .padding(.trailing, mascotInset.width)
                .padding(.bottom, mascotInset.height)
        }
        .containerBackground(for: .widget) {
            LumiWidgetGradient.streakWarm
        }
    }

    @ViewBuilder private var content: some View {
        switch state {
        case .fresh:
            VStack(alignment: .leading, spacing: 8) {
                Text("Начни серию\nсегодня")
                    .font(.lumiWidget(17, weight: .heavy))
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                WeekStripView(statuses: Array(repeating: .empty, count: 7))
            }
        case .active:
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    WidgetIcon(name: "icon-streak", systemFallback: "flame.fill", size: 26, color: .white)
                    Text("\(snapshot.streakCount)")
                        .font(.lumiWidget(34, weight: .heavy))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                }
                Text("дней подряд")
                    .font(.lumiWidget(12.5, weight: .bold))
                    .foregroundStyle(.white.opacity(0.82))
                WeekStripView(statuses: snapshot.weekStatuses)
                    .padding(.top, 4)
            }
        case .awaitingReturn:
            Text("Луми ждёт тебя,\nкогда будешь готов(а)\nпродолжить")
                .font(.lumiWidget(15.5, weight: .bold))
                .foregroundStyle(.white)
                .lineSpacing(2)
        }
    }

    @ViewBuilder private var mascot: some View {
        switch state {
        case .fresh:
            Image("mascot-welcome").resizable().scaledToFit()
        case .active:
            Image("mascot-joy").resizable().scaledToFit()
        case .awaitingReturn:
            Image("mascot-ob1").resizable().scaledToFit()
        }
    }

    private var mascotSize: CGSize {
        state == .awaitingReturn ? CGSize(width: 118, height: 118) : CGSize(width: 132, height: 132)
    }

    private var mascotInset: CGSize {
        state == .awaitingReturn ? CGSize(width: -2, height: 2) : CGSize(width: -6, height: -8)
    }
}

struct StreakWidget: Widget {
    let kind = "LumiStreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            StreakWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("Серия дней")
        .description("Текущая серия и повод вернуться сегодня.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    StreakWidget()
} timeline: {
    StreakEntry(date: .now, snapshot: .freshStart)
    StreakEntry(date: .now, snapshot: .sample)
    StreakEntry(date: .now, snapshot: LumiWidgetSnapshot(
        streakCount: 4, weekStatuses: [.done, .done, .done, .done, .empty, .empty, .empty],
        daysSinceLastActive: 3, courseTitle: "", lessonTitle: "", lessonProgress: 0,
        lessonCompletedToday: false, level: 1, levelProgress: 0, lumens: 0
    ))
}
