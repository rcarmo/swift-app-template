import SwiftUI

public struct ItemInspectorView: View {
  @Environment(AppModel.self) private var model

  public init() {}

  public var body: some View {
    if let item = model.items.first(where: { $0.id == model.selection }) {
      Form {
        LabeledContent("Title", value: item.title)
        LabeledContent("Summary", value: item.summary)
        LabeledContent("Favourite", value: item.isFavorite ? "Yes" : "No")
        LabeledContent("Updated") {
          Text(item.updatedAt, format: .dateTime)
        }
      }
      .formStyle(.grouped)
      .padding()
      .navigationTitle("Item Inspector")
    } else {
      ContentUnavailableView(
        "No Selection",
        systemImage: "sidebar.left",
        description: Text("Select an item in the main window."),
      )
    }
  }
}
