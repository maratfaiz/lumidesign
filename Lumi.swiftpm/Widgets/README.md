# Lumi home screen widgets

This folder holds the WidgetKit source for the three widgets from the design
brief: **Серия дней** (streak, `systemMedium`), **Сегодняшний урок** (lesson,
`systemMedium`), **Профиль коротко** (profile, `systemSmall`). Visual spec
for every state/size/appearance mode: see `widget-mockups.html` at the repo
root (also published as a Claude artifact).

## Why this code isn't wired into the app yet

`Lumi.swiftpm` is a **Swift Playgrounds App package** — `Package.swift`
declares a single `.iOSApplication` product with one `.executableTarget`
(`AppModule`). That format only supports one build target. A **Widget
Extension** is a second, separate build target (its own bundle ID, its own
`WidgetKit` entry point), which `.swiftpm` packages cannot host — Swift
Playgrounds simply has no mechanism to add one.

So this code is deliberately kept **outside** `Sources/`, in this sibling
`Widgets/` folder. `AppModule`'s target `path: "Sources"` in `Package.swift`
means SwiftPM never compiles anything in here — it can't accidentally break
the existing build or CI. It's parked here fully written and ready to move.

## The one manual step (needs a Mac + Xcode)

1. Open the project in Xcode and use **File → Save As Xcode Project…** (or:
   create a new Xcode iOS App project and copy `Sources/` into it) to get a
   real `.xcodeproj`. `.swiftpm` apps convert to `.xcodeproj` losslessly —
   this is a supported Xcode flow, not a rewrite.
2. **File → New → Target… → Widget Extension**, name it e.g. `LumiWidgets`.
   Xcode scaffolds a template `TimelineProvider`/`Widget` — delete its
   generated Swift files and drop in the files from this folder instead.
3. Add `Assets.xcassets` (or at least the `mascot-*` imagesets referenced
   below) to the new widget extension's **target membership** too, so
   `Image("mascot-joy")` etc. resolve inside the widget process.
4. Add an **App Group** capability (e.g. `group.com.lumi.app`) to *both* the
   main app target and the widget extension target. This lets the running
   app write live stats into shared storage that the widget's timeline
   provider reads — see `LumiWidgetData.swift`.
5. Build & run the `LumiWidgets` scheme once, then long-press the home
   screen → **+** → search "Lumi" to add a widget.

## Files

| File | Contents |
|---|---|
| `LumiWidgetBundle.swift` | `@main` `WidgetBundle` entry point, groups all three widgets |
| `LumiWidgetTheme.swift` | Color tokens copied from `Sources/Theme.swift` (kept as its own copy — the widget extension is a separate target and can't import `AppModule`'s internal types) |
| `LumiWidgetData.swift` | `LumiWidgetSnapshot` model + reader for the shared `UserDefaults(suiteName:)` App Group store, with a sample fallback so previews/first-run never show empty state by accident |
| `StreakWidget.swift` | Variant 1 — states: no streak yet / active streak / inactive 2+ days |
| `LessonWidget.swift` | Variant 2 — states: today's lesson pending / already completed |
| `ProfileWidget.swift` | Variant 3 — single always-current state |

## Wiring real data from the app

Once the App Group exists, call this from the app whenever streak/lesson/
profile state changes (e.g. after finishing a lesson, after the daily streak
updates):

```swift
LumiWidgetSnapshot(
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
).save()

WidgetCenter.shared.reloadAllTimelines()
```

`WidgetCenter` lives in `import WidgetKit`, available from the main app
target too (no App-Group-only restriction on the reload call itself).
