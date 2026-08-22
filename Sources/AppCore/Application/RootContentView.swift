import SwiftUI
import UniformTypeIdentifiers

public struct RootContentView: View {
  private enum FocusTarget: Hashable {
    case search
  }

  @Environment(AppModel.self) private var model
  @Environment(\.openWindow) private var openWindow
  @Environment(\.undoManager) private var undoManager
  @FocusState private var focusTarget: FocusTarget?
  @State private var searchText = ""
  @State private var isImporting = false
  @State private var isExporting = false
  @State private var importURLs: [URL]?
  @State private var presentedError: PresentedError?
  @State private var deletionUndoController = ItemDeletionUndoController()

  public init() {}

  public var body: some View {
    @Bindable var model = model
    let filteredItems = ItemSearch.filter(model.items, query: searchText)

    NavigationSplitView {
      ItemsSidebar(
        items: filteredItems,
        selection: $model.selection,
        importItems: model.importItems,
        deleteItem: deleteItem,
        deleteSelection: deleteSelection,
      )
      .searchable(text: $searchText, prompt: "Search items")
      .searchFocused($focusTarget, equals: .search)
    } detail: {
      ItemsDetailContent(
        filteredItems: filteredItems,
        isSearching: !searchText.isEmpty,
        clearSearch: { searchText = "" },
      )
    }
    .toolbar {
      ToolbarItemGroup {
        Button("New Item", systemImage: "plus", action: model.addItem)
        Button("Show Inspector", systemImage: "info.circle") {
          openWindow(id: "item-inspector")
        }
        .disabled(model.selection == nil)

        Button("Delete Item", systemImage: "trash", action: deleteSelection)
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
      contentTypes: [.starterItem],
      defaultFilename: selectedItem?.title,
      onCompletion: exportCompleted,
    )
    .alert(item: $presentedError) { error in
      Alert(
        title: Text(error.title),
        message: Text(error.message),
      )
    }
    .onChange(of: filteredItems.map(\.id), initial: true) {
      model.reconcileSelection(with: filteredItems)
    }
    .task {
      await model.loadIfNeeded()
    }
    .task(id: importURLs) {
      guard let importURLs else { return }

      do {
        let importedItems = try await ItemFileCodec.decode(importURLs)
        try Task.checkCancellation()
        model.importItems(importedItems)
      } catch is CancellationError {
        return
      } catch {
        presentedError = PresentedError(
          title: "Couldn’t Import Items",
          message: "Check that the selected files are valid item files and try again.",
        )
      }
      self.importURLs = nil
    }
  }

  private var selectedItem: Item? {
    model.items.first { $0.id == model.selection }
  }

  private func importItems(_ result: Result<[URL], any Error>) {
    do {
      importURLs = try result.get()
    } catch {
      guard !isUserCancellation(error) else { return }
      presentedError = PresentedError(
        title: "Couldn’t Import Items",
        message: "Check that the selected files are valid item files and try again.",
      )
    }
  }

  private func exportCompleted(_ result: Result<URL, any Error>) {
    if case let .failure(error) = result, !isUserCancellation(error) {
      presentedError = PresentedError(
        title: "Couldn’t Export Item",
        message: "Choose another location and try again.",
      )
    }
  }

  private func deleteItem(_ itemID: Item.ID) {
    model.selection = itemID
    deleteSelection()
  }

  private func deleteSelection() {
    guard let deletion = model.deleteSelection() else { return }
    if let undoManager {
      deletionUndoController.registerDeletion(deletion, in: model, with: undoManager)
    }
  }

  private func isUserCancellation(_ error: any Error) -> Bool {
    let cocoaError = error as NSError
    return cocoaError.domain == NSCocoaErrorDomain && cocoaError.code == NSUserCancelledError
  }
}

private struct PresentedError: Identifiable {
  let id = UUID()
  let title: String
  let message: String
}
