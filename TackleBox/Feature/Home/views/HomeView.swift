import SwiftData
import SwiftUI

struct HomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: [SortDescriptor(\Item.timestamp, order: .reverse)]) private var items: [Item]
  @StateObject private var viewModel = HomeViewModel()
  @State private var showingAddItem = false
  @State private var selectedCategoryIndex: Int = 0
  private let categories: [String] = {
    var cats = ["全部"]
    cats.append(contentsOf: Category.all.map { $0.name })
    return cats
  }()

  init() {}

  private var filteredItems: [Item] {
    if selectedCategoryIndex == 0 { return items }
    let selected = categories[selectedCategoryIndex]
    return items.filter { $0.category == selected }
  }

  var body: some View {
    NavigationStack {
      List {
        Section(header: CategoryHeaderView(categories: categories, selectedIndex: $selectedCategoryIndex)) {
          ForEach(filteredItems, id: \.id) { item in
            ItemRow(item: item, viewModel: viewModel, modelContext: modelContext)
              .listRowSeparator(.hidden)
          }
          .onDelete { offsets in viewModel.delete(at: offsets, items: filteredItems, context: modelContext) }
        }
      }
      .listStyle(.plain)
      .navigationTitle("装备")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { showingAddItem = true }) {
            Image(systemName: "plus")
          }
        }
      }
      .sheet(isPresented: $showingAddItem) {
        NavigationStack {
          AddItemView()
        }
      }
    }
  }

  
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
// `CategoryHeaderView` has been moved to Feature component file
