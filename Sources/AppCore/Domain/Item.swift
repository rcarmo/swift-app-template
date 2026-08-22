import Foundation

public struct Item: Identifiable, Hashable, Sendable {
  public let id: String
  public var title: String
  public var summary: String
  public var isFavorite: Bool
  public var updatedAt: Date

  public init(
    id: String = UUID().uuidString,
    title: String,
    summary: String,
    isFavorite: Bool = false,
    updatedAt: Date = .now
  ) {
    self.id = id
    self.title = title
    self.summary = summary
    self.isFavorite = isFavorite
    self.updatedAt = updatedAt
  }
}
