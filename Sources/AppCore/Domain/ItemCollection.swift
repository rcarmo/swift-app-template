public nonisolated enum ItemCollection {
  public static func normalising(_ items: [Item]) -> [Item] {
    var normalisedItems: [Item] = []
    var indexByID: [Item.ID: Int] = [:]

    for item in items {
      if let index = indexByID[item.id] {
        normalisedItems[index] = item
      } else {
        indexByID[item.id] = normalisedItems.endIndex
        normalisedItems.append(item)
      }
    }

    return normalisedItems
  }

  public static func merging(_ existingItems: [Item], with incomingItems: [Item]) -> [Item] {
    var itemsByID: [Item.ID: Item] = [:]

    for item in existingItems {
      itemsByID[item.id] = item
    }
    for item in incomingItems {
      itemsByID[item.id] = item
    }

    return itemsByID.values.sorted { leftItem, rightItem in
      if leftItem.updatedAt == rightItem.updatedAt {
        return leftItem.id < rightItem.id
      }
      return leftItem.updatedAt > rightItem.updatedAt
    }
  }
}
