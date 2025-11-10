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

extension String {
  /// Obtains the index of the character in the line in which such character is. Differs from
  /// ``index(of:)`` in that the index returned by this function is relative to the line rather than
  /// the entire string itself, with the ``startIndex`` of the string being considered that of the
  /// line.
  ///
  /// - Complexity: O(*n*), where *n* is the distance between the last newline character before the
  ///   character at the given `index` and the character at such `index`.
  /// - Parameter characterIndex: Index of the character in the string whose line-based index will
  ///   be obtained.
  func inlinedIndex(ofCharacterAt characterIndex: Index) -> Index {
    let prefixIndices = self[...characterIndex].indices
    let lastNewlineIndex = prefixIndices.partitioned(by: { index in self[index].isNewline })
      .trueElements.last
    return index(
      startIndex,
      offsetBy: distance(from: lastNewlineIndex ?? startIndex, to: characterIndex)
    )
  }

  /// Obtains the index of the line at which the character at the specified `characterIndex` is in
  /// the string. Like ``inlinedIndex(ofCharacterAt:)``, differs from ``index(of:)`` in that the
  /// returned index is relative instead of absolute — relative to the amount of occurrences of
  /// newline characters up until the `characterIndex`.
  ///
  /// - Complexity: O(*n*), where *n* is the amount of characters in `self[...characterIndex]`.
  /// - Parameter characterIndex: Index of the character in the string whose line is that whose
  ///   index will be obtained.
  func lineIndex(ofCharacterAt characterIndex: Index) -> Index {
    index(startIndex, offsetBy: self[...characterIndex].count(where: \.isNewline))
  }
}
