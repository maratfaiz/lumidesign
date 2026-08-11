import Foundation
import SwiftUI

enum Concern: CaseIterable, Identifiable, Hashable {
    case selfCritic, boundaries, notGoodEnough, anxiety, other

    var id: Self { self }

    var title: String {
        switch self {
        case .selfCritic: return "Сильно критикую себя"
        case .boundaries: return "Трудно отстаивать свои границы"
        case .notGoodEnough: return "Чувствую себя недостаточно хорошим(ей)"
        case .anxiety: return "Тревожность и стресс"
        case .other: return "Другое"
        }
    }

    var icon: String {
        switch self {
        case .selfCritic: return "icon-critic-voice"
        case .boundaries: return "icon-clock"
        case .notGoodEnough: return "icon-heart-outline"
        case .anxiety: return "icon-anxiety"
        case .other: return "icon-question"
        }
    }
}

enum LearningFormat: CaseIterable, Identifiable, Hashable {
    case reading, audio, interactive

    var id: Self { self }

    var title: String {
        switch self {
        case .reading: return "Чтение (тексты)"
        case .audio: return "Аудио (голос, медитация)"
        case .interactive: return "Интерактивные задания"
        }
    }

    var icon: String {
        switch self {
        case .reading: return "icon-book"
        case .audio: return "icon-headphones"
        case .interactive: return "icon-tap"
        }
    }
}

enum Goal: CaseIterable, Identifiable, Hashable {
    case confidence, lessCritical, anxietyEase, selfWorth, other

    var id: Self { self }

    var title: String {
        switch self {
        case .confidence: return "Стать увереннее в себе"
        case .lessCritical: return "Меньше критиковать себя"
        case .anxietyEase: return "Легче справляться с тревогой"
        case .selfWorth: return "Начать ценить себя"
        case .other: return "Другое"
        }
    }

    var icon: String {
        switch self {
        case .confidence: return "icon-target"
        case .lessCritical: return "icon-smile"
        case .anxietyEase: return "icon-bolt"
        case .selfWorth: return "icon-heart-fill"
        case .other: return "icon-question"
        }
    }
}

enum SkinRarity: String {
    case base, rare, special

    var label: String {
        switch self {
        case .base: return "Обычный"
        case .rare: return "Редкий"
        case .special: return "Эпический"
        }
    }

    var color: Color {
        switch self {
        case .base: return LumiColor.textSecondary
        case .rare: return Color(hex: 0x5b9fff)
        case .special: return Color(hex: 0xff6ec7)
        }
    }
}

struct Skin: Identifiable {
    let key: String
    let name: String
    let category: SkinRarity
    var price: Int? = nil
    var locked: Bool = false
    var lessonsCur: Int = 0
    var lessonsReq: Int = 0

    var id: String { key }
}
