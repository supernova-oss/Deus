// ===-------------------------------------------------------------------------------------------===
// Copyright © 2026 Supernova. All rights reserved.
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

import CoreGraphics

extension CGVector {
  var length: CGFloat { sqrt(dx * dx + dy * dy) }

  mutating func normalize() {
    guard length > 0 else { return }
    dx /= length
    dy /= length
  }
}

extension CGVector: @retroactive AdditiveArithmetic {
  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    .init(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
  }
}
