import Foundation

public nonisolated enum ItemFileCodec {
  @concurrent
  public static func decode(_ urls: [URL]) async throws -> [Item] {
    try urls.map { url in
      let hasAccess = url.startAccessingSecurityScopedResource()
      defer {
        if hasAccess {
          url.stopAccessingSecurityScopedResource()
        }
      }
      return try JSONDecoder().decode(Item.self, from: Data(contentsOf: url))
    }
  }
}
