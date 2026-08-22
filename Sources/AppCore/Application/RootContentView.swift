import SwiftUI

public struct RootContentView: View {
  @Environment(AppModel.self) private var model
  @State private var searchText = ""

  public init() {}

  public var body: some View {
    @Bindable var model = model
    let filteredItems = ItemSearch.filter(model.items, query: searchText)

    NavigationSplitView {
      ItemsSidebar(items: filteredItems, selection: $model.selection)
        .searchable(text: $searchText, prompt: "Search items")
    } detail: {
      ItemsDetailContent(
        filteredItems: filteredItems,
        isSearching: !searchText.isEmpty
      )
    }
    .task {
      await model.loadIfNeeded()
    }
  }
}
