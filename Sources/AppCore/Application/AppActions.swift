public struct AppActions {
  public let addItem: () -> Void
  public let focusSearch: () -> Void
  public let importItems: () -> Void
  public let exportSelection: () -> Void
  public let showItemsTable: () -> Void

  public init(
    addItem: @escaping () -> Void,
    focusSearch: @escaping () -> Void,
    importItems: @escaping () -> Void,
    exportSelection: @escaping () -> Void,
    showItemsTable: @escaping () -> Void,
  ) {
    self.addItem = addItem
    self.focusSearch = focusSearch
    self.importItems = importItems
    self.exportSelection = exportSelection
    self.showItemsTable = showItemsTable
  }
}
