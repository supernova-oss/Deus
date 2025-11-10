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
  /// Produces an ``Array`` containing the elements at the given ``indices`` of this one.
  ///
  /// - Parameter indices: Indices of this ``Array`` at which the elements to be copied into the
  ///   produced one are.
  /// - Returns: Another ``Array`` with `indices.count` elements of this one, or this one itself in
  ///   case the specified ``indices`` equal to those of this ``Array``.
  func sliced(_ bounds: Range<Index>) -> [Element] {
    guard bounds != self.indices else { return self }
    guard !bounds.isEmpty else { return [] }
    guard bounds.count > 1 else { return [self[bounds.lowerBound]] }
    var bounds = bounds.map { bound in bound }
    while bounds.endIndex > endIndex { let _ = bounds.popLast() }
    return .init(count: bounds.count) { index in self[bounds[index]] }
  }
}
