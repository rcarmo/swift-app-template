import SwiftUI

public struct ItemsTableView: View {
  @Environment(AppModel.self) private var model
  @State private var sortOrder = [KeyPathComparator(\Item.title)]

  public init() {}

  public var body: some View {
    @Bindable var model = model
    let sortedItems = model.items.sorted(using: sortOrder)

    Table(sortedItems, selection: $model.selection, sortOrder: $sortOrder) {
      TableColumn("Title", value: \.title)

      TableColumn("Summary") { item in
        Text(item.summary)
          .lineLimit(1)
          .help(item.summary)
      }

      TableColumn("Updated") { item in
        UpdatedAtText(date: item.updatedAt)
          .monospacedDigit()
      }

      TableColumn("Favourite") { item in
        Image(systemName: item.isFavourite ? "star.fill" : "star")
          .foregroundStyle(item.isFavourite ? .yellow : .secondary)
          .accessibilityLabel(item.isFavourite ? "Favourite" : "Not favourite")
      }
      .width(70)
    }
    .navigationTitle("Items Table")
  }
}
