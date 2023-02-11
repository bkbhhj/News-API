import Foundation

final class Observable <T> {
    // MARK: Properties
  typealias Listener = (T) -> Void
  
  private var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
    // MARK: Binding function
  func bind(_ listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
