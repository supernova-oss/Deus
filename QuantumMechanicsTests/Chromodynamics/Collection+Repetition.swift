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

extension Collection {
  /// Makes an `Array` in which each element of this one is repeated consecutively by the specified
  /// amount of times.
  ///
  /// - Parameter count: Determines the amount of times the given element will be repeated in the
  ///   returned `Array`.
  func spread(by: (Element) throws -> Int) rethrows -> [Element] {
    guard !isEmpty else { return self as? [Element] ?? map(\.self) }
    let counts = try map(by)
    let spreadCount = counts.reduce(0, +)
    guard spreadCount != self.count else { return self as? [Element] ?? map(\.self) }
    guard spreadCount > 0 else { return [] }
    return [Element](
      unsafeUninitializedCapacity: spreadCount,
      initializingWith: { buffer, initializedCount in
        var offset = 0
        for (index, element) in enumerated() {
          guard let baseAddress = buffer.baseAddress else { break }
          for _ in 1...counts[index] {
            baseAddress.advanced(by: offset).initialize(to: element)
            offset += 1
          }
        }
        initializedCount = spreadCount
      }
    )
  }
}
