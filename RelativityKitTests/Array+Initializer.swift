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

extension Array {
  /// Initializes an ``Array`` with ``count`` elements which result from the given closure.
  ///
  /// - Parameters:
  ///   - count: Amount of elements in the ``Array`` (and of times the ``initializer`` is called).
  ///   - initializer: Produces the element to be inserted at the given index.
  init(count: Int, _ initializer: (_ index: Int) -> Element) {
    self =
      count <= 0
      ? .init()
      : .init(
        unsafeUninitializedCapacity: count,
        initializingWith: { buffer, initializedCount in
          for index in 0..<count {
            buffer.baseAddress?.advanced(by: index).initialize(to: initializer(index))
          }
          initializedCount = count
        }
      )
  }
}
