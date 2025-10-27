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

import Foundation

extension RangeReplaceableCollection {
  /// Leaves this collection only with elements of its own which are common to the `other`
  /// collection. In case there are no elements in common or the `other` collection is empty, all
  /// elements of this collection are removed.
  ///
  /// Commonality is determined by the return value of the disambiguation specified for a given
  /// element of either collection. Performing an equality comparison between such value of one
  /// element of this collection and another of an element from the `other` collection and such
  /// operation returning `true` signifies that both elements are deemed equal.
  ///
  /// - Parameters:
  ///   - other: Collection to intersect with this one.
  ///   - disambiguate: Provides the value based on an element with which an element of this
  ///     collection should be compared with one of the `other` in order to determine whether these
  ///     elements are considered equal.
  ///
  ///     Requiring disambiagution stems from this function not being constrained to a collection
  ///     whose elements are equatable. In case they are, in fact, equatable, this function may be
  ///     called as `self.formIntersection(other, by: \.self)`.
  /// - Complexity: O(*n*), where *n* is the length of this collection.
  mutating func formIntersection<Other, Disambiguation>(
    _ other: Other,
    by disambiguate: (Element) -> Disambiguation
  ) where Other: Collection, Other.Element == Element, Disambiguation: Equatable {
    guard !isEmpty else { return }
    guard !other.isEmpty else {
      removeAll()
      return
    }
    guard let other = other as? Set<AnyHashable>, Element.self is (any Hashable.Type) else {
      var validIndices = Array(indices)
      validIndices.removeLast()
      for index in validIndices {
        guard
          !other.contains(where: { otherElement in
            disambiguate(self[index]) == disambiguate(otherElement)
          })
        else { continue }
        remove(at: index)
      }
      return
    }
    let intersection = other.intersection(self as! [AnyHashable])
    removeAll(where: { element in
      !intersection.contains(where: { intersected in
        disambiguate(element) == disambiguate(intersected.base as! Element)
      })
    })
  }
}
