import SwiftUI
import SwiftData

struct ItemRow: View {
  let item: Item
  let viewModel: HomeViewModel
  let modelContext: ModelContext

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(item.name)
          .font(.headline)

        if let cat = item.category {
          Text(cat)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }

      Spacer()

      Button(action: { viewModel.toggleEquip(item: item, context: modelContext) }) {
        Image(systemName: item.isEquipped ? "checkmark.seal.fill" : "circle")
          .foregroundColor(item.isEquipped ? .green : .secondary)
      }
    }
    .padding(.vertical, 8)
  }
}

// Preview omitted due to ModelContext construction complexity in this environment.
