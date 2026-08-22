import Foundation
import Testing
@testable import AppCore

struct ItemFileCodecTests {
  @Test
  func `decode reads a valid item file`() async throws {
    let fixture = try ItemFileFixture()
    defer { fixture.remove() }
    let item = Item(
      id: "fixture",
      title: "Fixture",
      summary: "Decoded from disk",
      updatedAt: Date(timeIntervalSince1970: 1_000),
    )
    try fixture.write(item)

    let decodedItems = try await ItemFileCodec.decode([fixture.url])

    #expect(decodedItems == [item])
  }

  @Test
  func `decode rejects a file larger than its configured limit`() async throws {
    let fixture = try ItemFileFixture()
    defer { fixture.remove() }
    try fixture.write(Item(title: "Large", summary: "Reject before decoding"))

    await #expect(throws: ItemFileCodecError.self) {
      try await ItemFileCodec.decode([fixture.url], maximumFileSize: 1)
    }
  }
}

private struct ItemFileFixture {
  let directoryURL: URL
  let url: URL

  init() throws {
    directoryURL = FileManager.default.temporaryDirectory
      .appending(path: UUID().uuidString, directoryHint: .isDirectory)
    url = directoryURL.appending(path: "item.starteritem")
    try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
  }

  func write(_ item: Item) throws {
    try JSONEncoder().encode(item).write(to: url, options: .atomic)
  }

  func remove() {
    try? FileManager.default.removeItem(at: directoryURL)
  }
}
