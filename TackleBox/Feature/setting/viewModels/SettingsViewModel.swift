import Foundation
import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var receiveNotifications: Bool = false
    @Published var shareDiagnostics: Bool = false
    @Published var useICloudSync: Bool
    @Published var showICloudUnavailableAlert: Bool = false

    // UI text and status for cloud sync
//    @Published var cloudRowTitle: String
//    @Published var cloudRowSubtitle: String
//    @Published var cloudRowStatusText: String

    let modelManager: ModelManager

    init() {
        let initialUse = UserDefaults.standard.bool(forKey: "useICloudSync")
        self.useICloudSync = initialUse
        self.modelManager = ModelManager()
        // self.cloudRowTitle = "iCloud 同步"
        // self.cloudRowSubtitle = "iCloud 数据同步状态"
        // self.cloudRowStatusText = initialUse ? "已启用" : "未启用"
    }

    // Sections built from current state
    var sections: [SettingsSection] {
        [
            SettingsSection(title: "账户与同步", items: [
                SettingsItem(title: "iCloud 同步",
                             subtitle: nil,
                             trailingText: nil,
                             trailingImageName: nil,
                             style: .navigation,
                             toggleGet: nil,
                             toggleSet: nil),
                SettingsItem(title: "隐私政策",
                             subtitle: "了解您的数据如何被使用",
                             trailingText: nil,
                             trailingImageName: nil,
                             style: .navigation,
                             toggleGet: nil,
                             toggleSet: nil),
            ]),
            SettingsSection(title: "导入与导出", items: [
                SettingsItem(title: "从其他应用导入",
                             subtitle: "(MVP阶段禁用)",
                             trailingText: nil,
                             trailingImageName: "icloud",
                             style: .plain,
                             toggleGet: nil,
                             toggleSet: nil),
                SettingsItem(title: "导出为 CSV 文件",
                             subtitle: "(MVP阶段禁用)",
                             trailingText: nil,
                             trailingImageName: "chart.bar",
                             style: .plain,
                             toggleGet: nil,
                             toggleSet: nil)
            ]),
            SettingsSection(title: "应用偏好", items: [
                SettingsItem(title: "接收通知",
                             subtitle: "接收关于物品库存的提醒",
                             trailingText: nil,
                             trailingImageName: nil,
                             style: .toggle,
                             toggleGet: { [weak self] in self?.receiveNotifications ?? false },
                             toggleSet: { [weak self] in self?.receiveNotifications = $0 }),
                SettingsItem(title: "分享诊断数据",
                             subtitle: "帮助我们改进应用",
                             trailingText: nil,
                             trailingImageName: nil,
                             style: .toggle,
                             toggleGet: { [weak self] in self?.shareDiagnostics ?? false },
                             toggleSet: { [weak self] in self?.shareDiagnostics = $0 })
            ])
        ]
    }

    func setICloudSync(_ newValue: Bool) {
        if newValue {
            if FileManager.default.ubiquityIdentityToken == nil {
                showICloudUnavailableAlert = true
                useICloudSync = false
                return
            }
        }

        useICloudSync = newValue
        UserDefaults.standard.set(newValue, forKey: "useICloudSync")
        // refreshCloudStatus()
    }

//     func refreshCloudStatus() {
//         if useICloudSync {
//             cloudRowStatusText = "已启用"
//         } else {
//             cloudRowStatusText = "未启用"
//         }
//     }
}
