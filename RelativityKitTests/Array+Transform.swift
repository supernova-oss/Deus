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

@testable import RelativityKit

extension Array where Element: Sendable {
  /// Produces an ``Array`` containing the result of having applied the given transformation to each
  /// element of this ``Array``. Differs from the one in the standard library in that it is
  /// asynchronous and, thus, allows for asynchronous transformations.
  ///
  /// - Parameter transform: Transformation to be performed to an element contained in this
  ///   ``Array``.
  /// - Returns: The transformations made to each element.
  func map<R>(_ transform: @Sendable (Element) async throws -> R) async rethrows -> [R] {
    var results = [R?](count: count) { _ in nil }
    for index in indices { results[index] = try await transform(self[index]) }
    return results as! [R]
  }
}
