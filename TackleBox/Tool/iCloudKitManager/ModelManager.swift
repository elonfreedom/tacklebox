import Foundation
import SwiftUI
import Combine
import SwiftData

final class ModelManager: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    @Published private(set) var container: ModelContainer
    private(set) var isUsingICloud: Bool

    init() {
        let useICloud = UserDefaults.standard.bool(forKey: "useICloudSync")
        self.isUsingICloud = useICloud
        let schema = Schema([ Item.self ])
        do {
            self.container = try Self.makeContainer(schema: schema, useICloud: useICloud)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDefaultsChanged(_:)),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func userDefaultsChanged(_ note: Notification) {
        let useICloud = UserDefaults.standard.bool(forKey: "useICloudSync")
        if useICloud != isUsingICloud {
            Task { @MainActor in
                await updateContainer(useICloud: useICloud)
            }
        }
    }

    static func makeContainer(schema: Schema, useICloud: Bool) throws -> ModelContainer {
        // NOTE: To actually enable CloudKit syncing the app must have iCloud
        // capabilities and the proper container id in Signing & Capabilities.
        // SwiftData will automatically sync when the entitlements are present.
        // Here we construct a plain ModelContainer — you can customize with
        // ModelConfiguration if you need an explicit CloudKit configuration.
        return try ModelContainer(for: schema)
    }

    @MainActor
    func updateContainer(useICloud: Bool) async {
        // Attempt to migrate data between the current container and the
        // newly-created container for the target store type.
        let schema = Schema([ Item.self ])
        let oldContainer = self.container

        do {
            let newContainer = try Self.makeContainer(schema: schema, useICloud: useICloud)

            // Fetch items from old container
            let oldContext = oldContainer.mainContext
            let fetchAll = FetchDescriptor<Item>()
            let oldItems = try oldContext.fetch(fetchAll)

            // Fetch existing items in new container to avoid duplicates
            let newContext = newContainer.mainContext
            let existingNewItems = try newContext.fetch(fetchAll)
            let existingIDs = Set(existingNewItems.map { $0.id })

            // Copy items that don't exist in the new store
            for old in oldItems {
                if existingIDs.contains(old.id) { continue }
                let copied = Item(id: old.id, name: old.name, category: old.category, timestamp: old.timestamp, isEquipped: old.isEquipped)
                newContext.insert(copied)
            }

            // Save new context
            try newContext.save()

            // Swap to the new container only after successful migration
            self.container = newContainer
            self.isUsingICloud = useICloud
        } catch {
            // Failed to migrate or create new container — keep old one and restore flag
            print("Failed to update ModelContainer or migrate data: \(error)")
            UserDefaults.standard.set(self.isUsingICloud, forKey: "useICloudSync")
        }
    }
}
