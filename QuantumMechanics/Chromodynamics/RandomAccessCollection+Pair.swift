// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Supernova. All rights reserved.
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
  /// Returns whether all pairs of elements of this `Array` match the `predicate` in some order.
  ///
  /// - Parameter predicate: Condition to be satisfied, given a pair of elements (*a*, *b*). If it
  ///   is unsatisfied when *a* and *b* of the pair are passed in respectively, this closure is
  ///   called again with the pair switched (*b*, *a*).
  /// - Returns: `true` in case this `Array` does not contain enough elements to form a pair
  ///   (`count` < 2) or the `predicate` was satisfied by all pairs of elements in either order;
  ///   otherwise, `false`.
  func either(_ predicate: (_ first: Element, _ second: Element) throws -> Bool) rethrows -> Bool {
    guard !isEmpty else { return true }
    var firstIndex = startIndex
    var secondIndex = index(firstIndex, offsetBy: 1)
    while secondIndex < endIndex {
      let first = self[firstIndex]
      let second = self[secondIndex]
      guard try !predicate(first, second) && !predicate(second, first) else { return true }
      firstIndex = index(firstIndex, offsetBy: 2)
      secondIndex = index(secondIndex, offsetBy: 2)
    }
    return false
  }
}
