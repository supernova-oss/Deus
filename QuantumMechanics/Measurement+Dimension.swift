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

extension Measurement where UnitType: Dimension {
  /// Converts this `Measurement` into the specified `unit`.
  ///
  /// This function differs from that provided by ``Foundation`` in that another `Measurement` is
  /// not instantiated in case the unit of this one and that to which it should be converted are
  /// equal.
  ///
  /// - Parameter otherUnit: A unit of the same `Dimension`.
  /// - Returns: The converted `Measurement`.
  public func _converted(to otherUnit: UnitType) -> Self {
    guard unit != otherUnit else { return self }
    return converted(to: otherUnit)
  }
}
