import SwiftUI

struct ItemsEmptyView: View {
  let isSearching: Bool
  let clearSearch: () -> Void
  let addItem: () -> Void

  var body: some View {
    if isSearching {
      ContentUnavailableView {
        Label("No Results", systemImage: "magnifyingglass")
      } description: {
        Text("No items match your search.")
      } actions: {
        Button("Clear Search", action: clearSearch)
          .buttonStyle(.borderedProminent)
      }
    } else {
      ContentUnavailableView {
        Label("No Items", systemImage: "tray")
      } description: {
        Text("Connect a service or add your first item to get started.")
      } actions: {
        Button("New Item", systemImage: "plus", action: addItem)
          .buttonStyle(.borderedProminent)
      }
    }
  }
}
