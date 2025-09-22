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
  /// Pairs each element of this `Collection` to a respective value.
  ///
  /// - Parameter pair: Produces the pair of the given element.
  /// - Returns: An `Array` with the produced pairs joined to each existing element of this
  ///   `Collection`.
  func paired(to pair: (Element) throws -> Element) rethrows -> [Element] {
    guard !isEmpty else { return self as? [Element] ?? [] }
    let pairedCount = count * 2
    return try [Element](
      unsafeUninitializedCapacity: pairedCount,
      initializingWith: { buffer, initializedCount in
        guard var currentAddress = buffer.baseAddress else { return }
        for (index, element) in zip(indices, self) {
          currentAddress.initialize(to: element)
          currentAddress = currentAddress.successor()
          currentAddress.initialize(to: try pair(element))
          guard index < endIndex else { break }
          currentAddress = currentAddress.successor()
        }
        initializedCount = pairedCount
      }
    )
  }
}
