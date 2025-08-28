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
import Geometry
internal import Numerics

// MARK: - U(1)
extension Complex<Double> {
  /// Performs a global transformation on the phase of this quantum state on the unidimensional
  /// Abelian unit group U(1) (a unit circle) by rotating its phase while maintaining its magnitude.
  ///
  /// ## Formula
  ///
  /// U(1) = exp(*i* × θ)
  ///
  /// - Parameter theta: Angle of the rotation.
  func u1(by theta: Measurement<UnitAngle>) -> Self {
    self * .exp(.i * theta._converted(to: .radians).value)
  }
}
