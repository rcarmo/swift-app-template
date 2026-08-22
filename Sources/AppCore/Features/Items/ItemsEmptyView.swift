import SwiftUI

struct ItemsEmptyView: View {
  let isSearching: Bool

  var body: some View {
    if isSearching {
      ContentUnavailableView.search
    } else {
      ContentUnavailableView(
        "No Items",
        systemImage: "tray",
        description: Text("Connect a service or add your first item to get started.")
      )
    }
  }
}
