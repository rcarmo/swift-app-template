import SwiftUI

struct ItemDetailView: View {
  let item: Item
  let toggleFavourite: () -> Void

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: AppTheme.Spacing.section) {
        Text(item.title)
          .font(.largeTitle)
          .bold()

        Text(item.summary)
          .font(.body)
          .foregroundStyle(.secondary)

        LabeledContent("Last updated") {
          UpdatedAtText(date: item.updatedAt)
        }

        Button(
          item.isFavourite ? "Remove from Favourites" : "Add to Favourites",
          systemImage: item.isFavourite ? "star.slash" : "star",
          action: toggleFavourite,
        )
        .buttonStyle(.borderedProminent)
      }
      .frame(maxWidth: AppTheme.Metrics.readableWidth, alignment: .leading)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(AppTheme.Spacing.section)
    }
    .navigationTitle(item.title)
  }
}
