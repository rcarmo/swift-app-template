import Foundation

public nonisolated enum ItemFileCodec {
  public static let defaultMaximumFileSize = 10 * 1_024 * 1_024

  @concurrent
  public static func decode(
    _ urls: [URL],
    maximumFileSize: Int = defaultMaximumFileSize,
  ) async throws -> [Item] {
    try Task.checkCancellation()

    return try urls.map { url in
      try Task.checkCancellation()
      let hasAccess = url.startAccessingSecurityScopedResource()
      defer {
        if hasAccess {
          url.stopAccessingSecurityScopedResource()
        }
      }

      let declaredSize = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize
      if let declaredSize, declaredSize > maximumFileSize {
        throw ItemFileCodecError.fileTooLarge(maximumBytes: maximumFileSize)
      }

      let data = try Data(contentsOf: url, options: .mappedIfSafe)
      guard data.count <= maximumFileSize else {
        throw ItemFileCodecError.fileTooLarge(maximumBytes: maximumFileSize)
      }
      return try JSONDecoder().decode(Item.self, from: data)
    }
  }
}

public nonisolated enum ItemFileCodecError: Error, Equatable, Sendable {
  case fileTooLarge(maximumBytes: Int)
}
