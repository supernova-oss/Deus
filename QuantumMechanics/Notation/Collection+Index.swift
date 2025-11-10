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

extension Collection {
  /// Obtains the position of an element at the given `index`; position by which relativization due
  /// to subsequencing or specificities of collection-based index arithmetic (such as
  /// ``index(before:)`` or ``index(after:)``) is disregarded, and only the zero-based iteration
  /// index is considered.
  ///
  /// E.g., the indices of the substring
  ///
  /// ```swift
  /// let sentence = "Hello, world!"
  /// let word = sentence[sentence.index(sentence.startIndex, offsetBy: 7)...sentence.index(sentence.index(before: sentence.endIndex), offsetBy: -1))]
  /// ```
  ///
  /// are maintained. The `startIndex` of `word` is `7` and its `endIndex` is `12`. This function,
  /// however, allows for obtaining the index of such indices of the substring as if such substring
  /// was a string (that is: unrelated to the original string). Calling
  ///
  /// ```swift
  /// word.abs(word.startIndex)
  /// ```
  ///
  /// would return an integer `0`, while
  ///
  /// ```swift
  /// word.abs(word.endIndex)
  /// ```
  ///
  /// would return `5`.
  ///
  /// - Complexity: O(*n*), where *n* is the distance between the start index of this collection and
  ///   the given one.
  /// - Returns: The absolute position of the `index`.
  public func abs(_ index: Index) -> Int { distance(from: startIndex, to: index) }
}
