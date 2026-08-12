import Foundation

/// One day cell in the streak week strip.
enum LumiDayStatus: String, Codable {
    case done
    case freeze
    case empty
}

/// Everything the three widgets read. The running app writes one of these
/// to shared storage whenever streak/lesson/profile state changes; each
/// widget's TimelineProvider reads it back on every reload.
struct LumiWidgetSnapshot: Codable {
    var streakCount: Int
    var weekStatuses: [LumiDayStatus]
    var daysSinceLastActive: Int

    var courseTitle: String
    var lessonTitle: String
    var lessonProgress: Double
    var lessonCompletedToday: Bool

    var level: Int
    var levelProgress: Double
    var lumens: Int

    /// Shown before the app has ever synced real data, and in Xcode previews.
    static let sample = LumiWidgetSnapshot(
        streakCount: 7,
        weekStatuses: [.done, .done, .done, .freeze, .done, .done, .empty],
        daysSinceLastActive: 0,
        courseTitle: "Курс 1 · Работа с внутренним критиком",
        lessonTitle: "Урок 3. Замечаем критику",
        lessonProgress: 0.4,
        lessonCompletedToday: false,
        level: 3,
        levelProgress: 0.6,
        lumens: 1230
    )

    static let freshStart = LumiWidgetSnapshot(
        streakCount: 0,
        weekStatuses: Array(repeating: .empty, count: 7),
        daysSinceLastActive: 0,
        courseTitle: "",
        lessonTitle: "",
        lessonProgress: 0,
        lessonCompletedToday: false,
        level: 1,
        levelProgress: 0,
        lumens: 0
    )
}

enum LumiWidgetStore {
    // Must match the App Group capability added to both the main app
    // target and the widget extension target — see Widgets/README.md.
    static let appGroupID = "group.com.lumi.app"
    private static let key = "lumiWidgetSnapshot"

    static func load() -> LumiWidgetSnapshot {
        guard
            let defaults = UserDefaults(suiteName: appGroupID),
            let data = defaults.data(forKey: key),
            let snapshot = try? JSONDecoder().decode(LumiWidgetSnapshot.self, from: data)
        else {
            return .sample
        }
        return snapshot
    }

    static func save(_ snapshot: LumiWidgetSnapshot) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return }
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: key)
    }
}

extension LumiWidgetSnapshot {
    /// Call from the main app after any change to streak/lesson/profile state,
    /// then `WidgetCenter.shared.reloadAllTimelines()`.
    func save() {
        LumiWidgetStore.save(self)
    }
}
