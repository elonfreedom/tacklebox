import Foundation

// Models for building settings UI from ViewModel
struct SettingsSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let trailingText: String?
    let trailingImageName: String?
    let style: ItemStyle
    let toggleGet: (() -> Bool)?
    let toggleSet: ((Bool) -> Void)?
}

enum ItemStyle {
    case navigation
    case toggle
    case plain
}
