import SwiftUI

// MARK: - Shop

private struct ShopItem {
    let icon: String
    let name: String
    let price: Int
    let badge: String?
    let color: Color
}

private let shopAccessories = [
    ShopItem(icon: "eyeglasses", name: "Очки мечтателя", price: 80, badge: "Редкий", color: Color(hex: 0x5b9fff)),
    ShopItem(icon: "headphones", name: "Галакт. наушники", price: 120, badge: "Редкий", color: Color(hex: 0x5b9fff)),
    ShopItem(icon: "crown.fill", name: "Звёздная корона", price: 100, badge: "Эпический", color: Color(hex: 0xff6ec7)),
]
private let shopTechniques = [
    ShopItem(icon: "hands.sparkles.fill", name: "«Самообъятие»", price: 40, badge: nil, color: .white.opacity(0.1)),
    ShopItem(icon: "book.closed.fill", name: "Дневник эмоций", price: 40, badge: nil, color: .white.opacity(0.1)),
    ShopItem(icon: "target", name: "Фокус на ценностях", price: 40, badge: nil, color: .white.opacity(0.1)),
]
private let shopBoosters = [
    ShopItem(icon: "snowflake", name: "Заморозка серии", price: 30, badge: nil, color: LumiColor.blueChip.opacity(0.3)),
    ShopItem(icon: "plus.circle.fill", name: "Доп. задание дня", price: 30, badge: nil, color: .white.opacity(0.1)),
    ShopItem(icon: "lightbulb.fill", name: "Подсказка в уроке", price: 20, badge: nil, color: LumiColor.purple1.opacity(0.4)),
]

struct ShopView: View {
    @EnvironmentObject var app: AppState

    private let filters: [(key: String, label: String, icon: String, color: Color)] = [
        ("popular", "Популярное", "star.fill", LumiColor.yellow),
        ("accessories", "Аксессуары", "eyeglasses", LumiColor.textBody),
        ("techniques", "Техники", "book.closed.fill", LumiColor.textBody),
        ("boosters", "Бустеры", "bolt.fill", LumiColor.textBody),
    ]

    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("Магазин")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 5) {
                        Image(systemName: "star.fill")
                        Text("1230")
                    }
                    .font(.lumi(12, weight: .heavy))
                    .foregroundColor(LumiColor.yellow)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(LumiColor.yellow.opacity(0.12)))
                    .overlay(Capsule().stroke(LumiColor.yellow.opacity(0.3), lineWidth: 1))
                }

                HStack(spacing: 10) {
                    ForEach(filters, id: \.key) { filter in
                        let active = app.shopFilter == filter.key
                        Button { app.shopFilter = filter.key } label: {
                            VStack(spacing: 6) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(active ? filter.color.opacity(0.16) : Color.white.opacity(0.05))
                                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(active ? filter.color : Color.white.opacity(0.1), lineWidth: active ? 1.5 : 1))
                                        .frame(width: 52, height: 52)
                                    Image(systemName: filter.icon).font(.system(size: 20)).foregroundColor(active ? filter.color : LumiColor.textBody)
                                }
                                Text(filter.label)
                                    .font(.lumi(10.5, weight: active ? .heavy : .bold))
                                    .foregroundColor(active ? filter.color : LumiColor.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                    }
                }

                if app.shopFilter != "all" {
                    Button { app.shopFilter = "all" } label: {
                        Text("← Все категории")
                            .font(.lumi(12.5, weight: .bold))
                            .foregroundColor(LumiColor.blueChip)
                    }
                    .buttonStyle(.plain)
                }

                if showSection("accessories") {
                    shopSection(title: "Аксессуары для Луми", items: shopAccessories) { app.shopFilter = "accessories" }
                }
                if showSection("techniques") {
                    shopSection(title: "Секретные техники", items: shopTechniques) { app.shopFilter = "techniques" }
                }
                if showSection("boosters") {
                    shopSection(title: "Бустеры", items: shopBoosters) { app.shopFilter = "boosters" }
                }
            }
        }
    }

    private func showSection(_ key: String) -> Bool {
        app.shopFilter == "all" || app.shopFilter == "popular" || app.shopFilter == key
    }

    private func shopSection(title: String, items: [ShopItem], seeAll: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .lastTextBaseline) {
                Text(title).font(.lumi(15, weight: .heavy)).foregroundColor(.white)
                Spacer()
                Button(action: seeAll) {
                    Text("Смотреть все").font(.lumi(11.5, weight: .bold)).foregroundColor(LumiColor.blueChip)
                }
                .buttonStyle(.plain)
            }
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(items, id: \.name) { item in
                    VStack(spacing: 6) {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(item.color.opacity(0.12))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(item.color.opacity(0.5), lineWidth: 1.5))
                                .aspectRatio(1, contentMode: .fit)
                            Image(systemName: item.icon)
                                .font(.system(size: 20))
                                .foregroundColor(item.badge == nil ? LumiColor.textBody : item.color)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            if let badge = item.badge {
                                Text(badge.uppercased())
                                    .font(.system(size: 7, weight: .heavy))
                                    .foregroundColor(Color(hex: 0x0a1a33))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 1.5)
                                    .background(item.color)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .offset(x: -4, y: -4)
                            }
                        }
                        Text(item.name)
                            .font(.lumi(10.5, weight: .bold))
                            .foregroundColor(Color(hex: 0xe5e0f7))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill").font(.system(size: 9))
                            Text("\(item.price)")
                        }
                        .font(.lumi(11, weight: .heavy))
                        .foregroundColor(LumiColor.yellow)
                    }
                }
            }
        }
    }
}

// MARK: - Inventory

struct InventoryView: View {
    var body: some View {
        DetailScreen {
            VStack(alignment: .leading, spacing: 10) {
                Text("Инвентарь")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    inventoryTile(title: "Скин «Ночь»", subtitle: "экипировано", highlighted: true)
                    inventoryTile(title: "Заморозка дня", subtitle: "2 шт.", highlighted: false)
                    inventoryTile(title: "пусто", subtitle: nil, highlighted: false, empty: true)
                    inventoryTile(title: "пусто", subtitle: nil, highlighted: false, empty: true)
                }
            }
        }
    }

    private func inventoryTile(title: String, subtitle: String?, highlighted: Bool, empty: Bool = false) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.lumi(12, weight: .bold))
                .foregroundColor(empty ? LumiColor.textDim : .white)
            if let subtitle {
                Text(subtitle)
                    .font(.lumi(11, weight: .semibold))
                    .foregroundColor(highlighted ? LumiColor.purpleLight : LumiColor.textSecondary)
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(highlighted ? LumiColor.purple1.opacity(0.18) : (empty ? Color.white.opacity(0.03) : Color.white.opacity(0.05))))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(highlighted ? LumiColor.purple1 : Color.white.opacity(empty ? 0.12 : 0.1), style: StrokeStyle(lineWidth: highlighted ? 2 : 1, dash: empty ? [4] : []))
        )
    }
}

// MARK: - Customize ("Внешний вид Луми")

struct CustomizeView: View {
    @EnvironmentObject var app: AppState

    private let filters: [(key: String, label: String)] = [
        ("all", "Все"), ("base", "Обычные"), ("rare", "Редкие"), ("special", "Эпические"),
    ]

    private var visibleSkins: [Skin] {
        app.skins.filter { app.customizeFilter == "all" || $0.category.rawValue == app.customizeFilter }
    }

    private var previewSkin: Skin? {
        app.skins.first { $0.key == app.previewSkin }
    }

    var body: some View {
        DetailScreen {
            VStack(spacing: 0) {
                Text("Образы Луми")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 6)
                Text("Выбери образ, который отражает тебя")
                    .font(.lumi(12.5, weight: .semibold))
                    .foregroundColor(LumiColor.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 18)

                VStack(spacing: 8) {
                    MascotPlaceholder(size: 120, systemImage: "sparkles")
                }
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(RadialGradient(colors: [Color(hex: 0x2a1d52), Color(hex: 0x150f30)], center: .init(x: 0.5, y: 0.35), startRadius: 0, endRadius: 160))
                )
                .padding(.bottom, 18)

                HStack(spacing: 6) {
                    ForEach(filters, id: \.key) { filter in
                        let active = app.customizeFilter == filter.key
                        Button { app.customizeFilter = filter.key } label: {
                            Text(filter.label)
                                .font(.lumi(11.5, weight: active ? .heavy : .bold))
                                .foregroundColor(active ? .white : LumiColor.textSecondary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                        .background(Capsule().fill(active ? LumiColor.purple1.opacity(0.3) : Color.white.opacity(0.05)))
                        .overlay(Capsule().stroke(active ? LumiColor.purple1.opacity(0.6) : Color.white.opacity(0.1), lineWidth: 1))
                    }
                    Spacer(minLength: 0)
                }
                .padding(.bottom, 14)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(visibleSkins) { skin in
                        skinCard(skin)
                    }
                }

                if app.previewSkin != app.equippedSkin {
                    PrimaryButton(
                        title: (previewSkin?.locked ?? false) ? "Заблокировано" : "Надеть образ",
                        isEnabled: !(previewSkin?.locked ?? false)
                    ) {
                        app.equippedSkin = app.previewSkin
                    }
                    .padding(.top, 14)
                }
            }
        }
    }

    private func skinCard(_ skin: Skin) -> some View {
        let equipped = app.equippedSkin == skin.key
        let previewed = app.previewSkin == skin.key
        let borderColor = equipped ? LumiColor.yellow : (previewed ? LumiColor.purple1 : skin.category.color.opacity(0.6))
        let fillColor = equipped ? LumiColor.yellow.opacity(0.1) : (previewed ? LumiColor.purple1.opacity(0.14) : skin.category.color.opacity(0.08))

        return Button { app.previewSkin = skin.key } label: {
            VStack(spacing: 5) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.05))
                        .aspectRatio(1, contentMode: .fit)
                    Image(systemName: "sparkles")
                        .foregroundColor(LumiColor.textBody)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Text(skin.category.label.uppercased())
                        .font(.system(size: 7, weight: .heavy))
                        .foregroundColor(Color(hex: 0x1a1530))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1.5)
                        .background(skin.category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .offset(x: -4, y: -4)
                    if equipped {
                        ZStack {
                            Circle().fill(LumiColor.yellow)
                            Image(systemName: "checkmark").font(.system(size: 9, weight: .black)).foregroundColor(Color(hex: 0x3a2400))
                        }
                        .frame(width: 18, height: 18)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(x: 4, y: -4)
                    }
                    if skin.locked {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: 0x0a0819).opacity(0.55))
                            .overlay(Image(systemName: "lock.fill").foregroundColor(LumiColor.textTertiary))
                    }
                }
                Text(skin.name)
                    .font(.lumi(10, weight: .bold))
                    .foregroundColor(Color(hex: 0xe5e0f7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text(equipped ? "Надет" : (skin.locked ? "\(skin.lessonsCur)/\(skin.lessonsReq) уроков" : "В магазине →"))
                    .font(.lumi(9, weight: .bold))
                    .foregroundColor(equipped ? LumiColor.yellow : (skin.locked ? LumiColor.textDim : LumiColor.blueChip))
            }
            .padding(7)
        }
        .buttonStyle(.plain)
        .disabled(skin.locked)
        .background(RoundedRectangle(cornerRadius: 12).fill(fillColor))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: equipped || previewed ? 2 : 1.5))
    }
}
