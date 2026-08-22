import Foundation

public enum ItemSearch {
  public static func filter(_ items: [Item], query: String) -> [Item] {
    let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedQuery.isEmpty else { return items }

    return items.filter { item in
      item.title.localizedStandardContains(trimmedQuery)
        || item.summary.localizedStandardContains(trimmedQuery)
    }
  }
}
