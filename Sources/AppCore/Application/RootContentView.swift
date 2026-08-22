import SwiftUI
import UniformTypeIdentifiers

public struct RootContentView: View {
  private enum FocusTarget: Hashable {
    case search
  }

  @Environment(AppModel.self) private var model
  @Environment(\.openWindow) private var openWindow
  @FocusState private var focusTarget: FocusTarget?
  @State private var searchText = ""
  @State private var isImporting = false
  @State private var isExporting = false
  @State private var presentedError: PresentedError?

  public init() {}

  public var body: some View {
    @Bindable var model = model
    let filteredItems = ItemSearch.filter(model.items, query: searchText)

    NavigationSplitView {
      ItemsSidebar(
        items: filteredItems,
        selection: $model.selection,
        importItems: model.importItems,
      )
      .searchable(text: $searchText, prompt: "Search items")
      .searchFocused($focusTarget, equals: .search)
    } detail: {
      ItemsDetailContent(
        filteredItems: filteredItems,
        isSearching: !searchText.isEmpty,
      )
    }
    .toolbar {
      ToolbarItemGroup {
        Button("New Item", systemImage: "plus", action: model.addItem)
        Button("Show Inspector", systemImage: "info.circle") {
          openWindow(id: "item-inspector")
        }
        .disabled(model.selection == nil)
      }
    }
    .focusedSceneValue(
      \.appActions,
      AppActions(
        addItem: model.addItem,
        focusSearch: { focusTarget = .search },
        importItems: { isImporting = true },
        exportSelection: { isExporting = selectedItem != nil },
        showItemsTable: { openWindow(id: "items-table") },
      ),
    )
    .focusedSceneValue(\.selectedItem, selectedItem)
    .fileImporter(
      isPresented: $isImporting,
      allowedContentTypes: [.starterItem],
      allowsMultipleSelection: true,
      onCompletion: importItems,
    )
    .fileExporter(
      isPresented: $isExporting,
      item: selectedItem,
      contentType: .starterItem,
      defaultFilename: selectedItem?.title,
      onCompletion: exportCompleted,
    )
    .alert(item: $presentedError) { error in
      Alert(
        title: Text(error.title),
        message: Text(error.message),
        dismissButton: .default(Text("OK")),
      )
    }
    .task {
      await model.loadIfNeeded()
    }
  }

  private var selectedItem: Item? {
    model.items.first { $0.id == model.selection }
  }

  private func importItems(_ result: Result<[URL], any Error>) {
    Task {
      do {
        let urls = try result.get()
        try await model.importItems(ItemFileCodec.decode(urls))
      } catch {
        presentedError = PresentedError(title: "Couldn’t Import Items", message: error.localizedDescription)
      }
    }
  }

  private func exportCompleted(_ result: Result<URL, any Error>) {
    if case let .failure(error) = result {
      presentedError = PresentedError(title: "Couldn’t Export Item", message: error.localizedDescription)
    }
  }
}

private struct PresentedError: Identifiable {
  let id = UUID()
  let title: String
  let message: String
}
