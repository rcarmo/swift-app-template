import SwiftUI

struct ItemsDetailContent: View {
  @Environment(AppModel.self) private var model
  let filteredItems: [Item]
  let isSearching: Bool

  var body: some View {
    switch model.phase {
    case .idle, .loading:
      ProgressView("Loading…")
    case let .failed(message):
      LoadFailureView(message: message, retry: retry)
    case .loaded:
      loadedContent
    }
  }

  @ViewBuilder
  private var loadedContent: some View {
    if filteredItems.isEmpty {
      ItemsEmptyView(isSearching: isSearching)
    } else if let selectedItem {
      ItemDetailView(item: selectedItem) {
        model.toggleFavorite(for: selectedItem.id)
      }
    } else {
      ContentUnavailableView(
        "Select an Item",
        systemImage: "sidebar.left",
        description: Text("Choose an item from the sidebar to see its details.")
      )
    }
  }

  private var selectedItem: Item? {
    filteredItems.first(where: { $0.id == model.selection }) ?? filteredItems.first
  }

  private func retry() {
    Task { await model.reload() }
  }
}
