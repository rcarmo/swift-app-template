public nonisolated protocol UserPresentableError: Error, Sendable {
  var userMessage: String { get }
}
