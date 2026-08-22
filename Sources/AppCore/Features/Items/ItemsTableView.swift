import SwiftUI

public struct ItemsTableView: View {
  @Environment(AppModel.self) private var model

  public init() {}

  public var body: some View {
    @Bindable var model = model

    Table(model.items, selection: $model.selection) {
      TableColumn("Title", value: \.title)

      TableColumn("Summary") { item in
        Text(item.summary)
          .lineLimit(1)
          .help(item.summary)
      }

      TableColumn("Updated") { item in
        Text(item.updatedAt, format: .dateTime)
          .monospacedDigit()
      }

      TableColumn("Favourite") { item in
        Image(systemName: item.isFavorite ? "star.fill" : "star")
          .foregroundStyle(item.isFavorite ? .yellow : .secondary)
          .accessibilityLabel(item.isFavorite ? "Favourite" : "Not favourite")
      }
      .width(70)
    }
    .navigationTitle("Items Table")
  }
}
