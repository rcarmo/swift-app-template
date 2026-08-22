#if os(watchOS)
  import SwiftUI

  struct WatchItemsView: View {
    let items: [Item]
    @Binding var searchText: String

    var body: some View {
      NavigationStack {
        Group {
          if items.isEmpty {
            ItemsEmptyView(isSearching: !searchText.isEmpty)
          } else {
            List(items) { item in
              NavigationLink(value: item) {
                ItemRow(item: item)
              }
            }
            .navigationDestination(for: Item.self) { item in
              WatchItemDetailView(item: item)
            }
          }
        }
        .navigationTitle("Items")
        .searchable(text: $searchText, prompt: "Search")
      }
    }
  }
#endif
