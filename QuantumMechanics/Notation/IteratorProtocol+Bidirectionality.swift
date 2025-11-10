// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Deus
//
// This file is part of the Deus open-source project.
//
// This program is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
// even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with this program. If
// not, see https://www.gnu.org/licenses.
// ===-------------------------------------------------------------------------------------------===

extension RandomAccessCollection {
  /// Returns an iterator which can iterate forward and backward over the elements of this
  /// collection.
  public func makeBidirectionalIterator() -> BidirectionalIterator<Self> { .init(self) }
}

/// Iterator which traverses the given collection from the element at its start index to the element
/// at its end index and vice-versa.
///
/// Being bidirectional means that iteration can be done toward both ends of the collection, as
/// opposed to the single current-to-next mechanism of the default iterator of Swift. This type of
/// iterator supports both that and current-to-previous iteration, allowing for iterating over the
/// collection backward, reaching an element which has already been reached before.
///
/// For example:
///
/// ```swift
/// let numbers = [2, 4, 6, 8, 12]
/// var numberIterator = numbers.makeBidirectionalIterator()
/// var iteratedBackward = false
/// while let number = numberIterator.next() {
///   guard number == 12 || iteratedBackward else { continue }
///   doSomething()
///   let _ = numberIterator.previous()
///   iteratedBackward = true
/// }
/// ```
///
/// In this case, the arbitrary `doSomething()` function gets called three times:
///
/// 1. When `12` is reached on the fifth iteration;
/// 2. on the second iteration to `8`, before which ``previous()`` was called; and
/// 3. on the second iteration to `12`, after the backward iteration to `8`.
public struct BidirectionalIterator<CollectionType>: IteratorProtocol
where CollectionType: RandomAccessCollection {
  /// Index of the element over which iteration was last performed. Defaults to the index before the
  /// start index of the collection.
  public private(set) var currentIndex: CollectionType.Index

  /// Collection over which iteration is to be performed.
  private let collection: CollectionType

  fileprivate init(_ collection: CollectionType) {
    self.collection = collection
    currentIndex = collection.index(before: collection.startIndex)
  }

  /// Iterates backward over the collection.
  ///
  /// - Returns: The element before that over which iteration occurred before; or `nil` if such
  ///   regression exceeds the bounds of the collection.
  public mutating func previous() -> CollectionType.Element? {
    guard let (index, previous) = indexedElement(ofIterationBy: -1) else { return nil }
    currentIndex = index
    return previous
  }

  public mutating func next() -> CollectionType.Element? {
    guard let (index, next) = indexedElement(ofIterationBy: 1) else { return nil }
    currentIndex = index
    return next
  }

  /// Resets this iterator to its initial state. After this function gets called, iteration over
  /// subsequent elements starts from the beginning of the collection. Calling it while iteration
  /// has not yet taken place is a no-op.
  public mutating func reset() { currentIndex = collection.index(before: collection.startIndex) }

  /// Obtains the element which will result from an iteration with the given amount of steps
  /// alongside its index, used by both public functions of this iterator for updating the
  /// ``currentIndex``.
  ///
  /// - Parameter stepCount: Distance from the lastly "consumed" element to the next. Passing in a
  ///   negative integer denotes a backward iteration, while a positive one means iterating forward;
  ///   a positive `1` yields the same result as an iterator provided by default by Swift would.
  /// - Returns: The element at the current index + an offset equating to the given `stepCount`; or
  ///   `nil` if the resulting index is outside of the bounds of the collection.
  @inline(__always)
  private func indexedElement(
    ofIterationBy stepCount: Int
  ) -> (CollectionType.Index, CollectionType.Element)? {
    let index = collection.index(currentIndex, offsetBy: stepCount)
    guard collection.indices.contains(index) else { return nil }
    let next = collection[index]
    return (index, next)
  }
}
