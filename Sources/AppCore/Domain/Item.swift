import CoreTransferable
import Foundation

public nonisolated struct Item: Identifiable, Hashable, Sendable, Codable, Transferable {
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case summary
    case isFavourite
    case legacyIsFavorite = "isFavorite"
    case updatedAt
  }

  public let id: String
  public var title: String
  public var summary: String
  public var isFavourite: Bool
  public var updatedAt: Date

  public static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(contentType: .starterItem)
  }

  public init(
    id: String = UUID().uuidString,
    title: String,
    summary: String,
    isFavourite: Bool = false,
    updatedAt: Date = .now,
  ) {
    self.id = id
    self.title = title
    self.summary = summary
    self.isFavourite = isFavourite
    self.updatedAt = updatedAt
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    summary = try container.decode(String.self, forKey: .summary)
    isFavourite = try container.decodeIfPresent(Bool.self, forKey: .isFavourite)
      ?? container.decode(Bool.self, forKey: .legacyIsFavorite)
    updatedAt = try container.decode(Date.self, forKey: .updatedAt)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(summary, forKey: .summary)
    try container.encode(isFavourite, forKey: .isFavourite)
    try container.encode(updatedAt, forKey: .updatedAt)
  }
}
