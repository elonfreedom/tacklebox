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
          .font(.title3)
          .fontWeight(.semibold)

        HStack {
          Text("×\(item.quantity)")
            .font(.subheadline)
            // .foregroundColor(.clear)

          Text(item.status)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(statusColor(for: item.status))
            .clipShape(Capsule())
        }
      }

      Spacer()

      Image(systemName: "chevron.right")
        .foregroundColor(.secondary)
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(8)
  }

  private func statusColor(for status: String) -> Color {
    switch status {
    case "在用":
      return Color(red: 0.09, green: 0.56, blue: 0.46)
    case "闲置":
      return Color(red: 0.20, green: 0.34, blue: 0.34)
    case "损坏":
      return Color(red: 0.53, green: 0.16, blue: 0.18)
    default:
      return Color.gray
    }
  }
}

//struct ItemRow_Previews: PreviewProvider {
//  static var previews: some View {
//      ItemRow(item: <#Item#>, viewModel: <#HomeViewModel#>, modelContext: <#ModelContext#>)
//  }
//}
// Preview omitted due to ModelContext construction complexity in this environment.
