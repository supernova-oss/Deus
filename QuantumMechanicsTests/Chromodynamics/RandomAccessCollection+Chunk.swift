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
  /// Divides this `Collection` into chunks of `size`.
  ///
  /// ## Difference from that of swift-algorithms
  ///
  /// The swift-algorithms package, as of 1.2.1, provides an extension function for dividing a
  /// `Collection` into chunks: `chunks(ofCount:)`. Our implementation, however, provides control
  /// over whether partiality is allowed or prohibited; in contrast, `chunks(ofCount:)` presupposes
  /// that partiality is always permitted, never ignoring the last chunk when its size is greater
  /// than that which has been specified.
  ///
  /// Apart from this distinction, and although some optimazations are not present here (such as
  /// lazy chunk evaluation), the contents of the return value of both functions are the same.
  ///
  /// - Parameters:
  ///   - size: Quantity in which the elements will be grouped.
  ///   - allowsPartiality: Whether the last chunk can contain less than `size` elements due to the
  ///     `count` of this `Collection` being insufficient for a division into such size. When
  ///     `false`, remaining elements will be ignored.
  ///
  ///     E.g., given `self` = `[2, 4, 8, 12, 16]` and `size` = 2:
  ///
  ///     `allowsPartiality` | Result                    |
  ///     ------------------ | ------------------------- |
  ///     `false`            | `[[2, 4], [8, 12]]`       |
  ///     `true`             | `[[2, 4], [8, 12], [16]]` |
  /// - Returns:
  ///   Sizing               | Result                |
  ///   -------------------- | --------------------- |
  ///   `size` ≤ 0           | `[]`                  |
  ///   `size` ≥ `count`     | `[self[...]]`         |
  ///   0 < `size` < `count` | ≤-`size`-sized chunks |
  func chunked(into size: Int, allowsPartiality: Bool = true) -> [SubSequence] {
    guard !isEmpty && size > 0 else { return [] }
    guard size < count else { return [self[...]] }
    let countOfPartialChunks = allowsPartiality && count % size > 0 ? 1 : 0
    let countOfCompleteChunks = count / size
    let totalCountOfChunks = countOfCompleteChunks + countOfPartialChunks
    return [SubSequence](
      unsafeUninitializedCapacity: totalCountOfChunks,
      initializingWith: { buffer, initializedCount in
        guard var addressOfCurrentChunk = buffer.baseAddress else { return }
        var currentChunk = self[startIndex...index(startIndex, offsetBy: size - 1)]
        var indexOfCurrentChunk = startIndex
        while indexOfCurrentChunk < index(startIndex, offsetBy: totalCountOfChunks) {
          addressOfCurrentChunk.initialize(to: currentChunk)
          addressOfCurrentChunk = addressOfCurrentChunk.successor()
          currentChunk =
            self[
              currentChunk
                .endIndex..<Swift.min(endIndex, index(currentChunk.endIndex, offsetBy: size))
            ]
          indexOfCurrentChunk = index(indexOfCurrentChunk, offsetBy: 1)
        }
        initializedCount = totalCountOfChunks
      }
    )
  }
}
