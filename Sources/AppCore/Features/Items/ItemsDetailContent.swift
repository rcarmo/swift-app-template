import SwiftUI

struct ItemsDetailContent: View {
  @Environment(AppModel.self) private var model
  let filteredItems: [Item]
  let isSearching: Bool
  let clearSearch: () -> Void
  @State private var retryGeneration = 0

  var body: some View {
    Group {
      switch model.phase {
      case .idle, .loading:
        ProgressView("Loading…")
      case let .failed(message):
        LoadFailureView(message: message, retry: retry)
      case .loaded:
        loadedContent
      }
    }
    .task(id: retryGeneration) {
      guard retryGeneration > 0 else { return }
      await model.reload()
    }
  }

  @ViewBuilder
  private var loadedContent: some View {
    if filteredItems.isEmpty {
      ItemsEmptyView(
        isSearching: isSearching,
        clearSearch: clearSearch,
        addItem: model.addItem,
      )
    } else if let selectedItem {
      ItemDetailView(item: selectedItem) {
        model.toggleFavourite(for: selectedItem.id)
      }
    } else {
      ContentUnavailableView(
        "Select an Item",
        systemImage: "sidebar.left",
        description: Text("Choose an item from the sidebar to see its details."),
      )
    }
  }

  private var selectedItem: Item? {
    filteredItems.first(where: { $0.id == model.selection })
  }

  private func retry() {
    retryGeneration += 1
  }
}
