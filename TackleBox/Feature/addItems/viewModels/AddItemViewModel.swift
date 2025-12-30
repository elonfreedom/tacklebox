import Foundation
import Combine
import SwiftData

final class AddItemViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var category: String = "鱼竿"
    @Published var quantity: Int = 1
    @Published var status: String = "在用"
    @Published var notes: String = ""

    let categories = ["鱼竿", "线组", "配件", "工具"]
    let statuses = ["在用", "闲置", "损坏"]

    func save(context: ModelContext) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        let item = Item(name: trimmed, category: category)
        item.quantity = max(1, quantity)
        item.status = status
        item.notes = notes.isEmpty ? nil : notes

        context.insert(item)
        do {
            try context.save()
            return true
        } catch {
            print("AddItem save error: \(error)")
            return false
        }
    }
}
