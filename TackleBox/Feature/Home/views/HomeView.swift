import SwiftData
import SwiftUI

struct HomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: [SortDescriptor(\Item.timestamp, order: .reverse)]) private var items: [Item]
  @StateObject private var viewModel = HomeViewModel()
  @State private var showingAddItem = false

  init() {}

  var body: some View {
    NavigationStack {
      List {
        ForEach(items, id: \.id) { item in
          ItemRow(item: item, viewModel: viewModel, modelContext: modelContext)
        }
        .onDelete { offsets in viewModel.delete(at: offsets, items: items, context: modelContext) }
      }
      .listStyle(.insetGrouped)
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
