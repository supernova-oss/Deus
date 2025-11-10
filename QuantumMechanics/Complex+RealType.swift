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

internal import Numerics

extension Complex {
  /// Multiplies the real and imaginary parts of a complex number by a scalar.
  ///
  /// - Parameters:
  ///   - lhs: Complex number to be multiplied by `rhs`.
  ///   - rhs: Scalar by which each part of `lhs` is multiplied.
  static func * (lhs: Self, rhs: RealType) -> Self {
    guard rhs != 1 else { return lhs }
    return .init(lhs.real * rhs, lhs.imaginary * rhs)
  }
}
