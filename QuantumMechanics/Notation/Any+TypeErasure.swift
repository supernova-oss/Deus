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

internal import Algorithms

// MARK: - RangeReplaceableCollection

/// Wrapper for erasing the type of a collection which is range-replaceable.
struct AnyRangeReplaceableCollection<Element> {
  /// Array into which each of the elements of the original collection are copied; or the original
  /// collection itself, in case it is an array.
  private var base: [Element]

  init<Base>(_ base: consuming Base)
  where Base: RangeReplaceableCollection, Base.Element == Element {
    self.base = Base.self == [Element].self ? base as! [Element] : .init(base)
  }
}

extension AnyRangeReplaceableCollection: Collection {
  var startIndex: AnyIndex { .init(base.startIndex) }
  var endIndex: AnyIndex { .init(base.endIndex) }

  func index(after i: AnyIndex) -> AnyIndex { .init(base.index(after: index(typeErasedAs: i))) }

  /// Converts an index of this collection which is type-erased into the equivalent one of the array
  /// by which this collection is backed.
  ///
  /// - Complexity: O(log *n*), where *n* is the amount of elements in this collection.
  /// - Parameter typeErasedIndex: Index of this collection whose typed counterpart will be
  ///   returned.
  fileprivate func index(typeErasedAs typeErasedIndex: AnyIndex) -> Array.Index {
    base.indices.firstIndex(of: indices.abs(typeErasedIndex)) ?? base.indices.endIndex
  }
}

extension AnyRangeReplaceableCollection: BidirectionalCollection {
  func index(before i: AnyIndex) -> AnyIndex { .init(base.index(before: index(typeErasedAs: i))) }
}

extension AnyRangeReplaceableCollection: RandomAccessCollection {
  subscript(position: AnyIndex) -> Element { base[index(typeErasedAs: position)] }
}

extension AnyRangeReplaceableCollection: RangeReplaceableCollection {
  init() { self = .init([]) }

  mutating func replaceSubrange<C>(_ subrange: Range<AnyIndex>, with newElements: C)
  where C: Collection, Element == C.Element {
    let typedUpperBound = index(typeErasedAs: subrange.upperBound)
    base.replaceSubrange(
      index(
        typeErasedAs: subrange.lowerBound
      )..<(subrange.contains(subrange.upperBound)
        ? typedUpperBound : base.index(before: typedUpperBound)),
      with: newElements
    )
  }
}
