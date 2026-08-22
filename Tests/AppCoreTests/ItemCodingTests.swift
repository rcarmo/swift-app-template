import Foundation
import Testing
@testable import AppCore

struct ItemCodingTests {
  @Test
  func `encoding uses the British favourite field`() throws {
    let item = Item(id: "item", title: "Item", summary: "Encoded", isFavourite: true)

    let object = try #require(JSONSerialization.jsonObject(with: JSONEncoder().encode(item)) as? [String: Any])

    #expect(object["isFavourite"] as? Bool == true)
    #expect(object["isFavorite"] == nil)
  }

  @Test
  func `decoding accepts the legacy favorite field`() throws {
    let legacyObject: [String: Any] = [
      "id": "legacy",
      "title": "Legacy",
      "summary": "Imported from an earlier template",
      "isFavorite": true,
      "updatedAt": 0.0,
    ]
    let data = try JSONSerialization.data(withJSONObject: legacyObject)

    let item = try JSONDecoder().decode(Item.self, from: data)

    #expect(item.isFavourite)
  }
}
