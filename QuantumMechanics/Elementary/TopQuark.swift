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

/// Heaviest ``Quark``, with a Lagrangian mass of 173.21 ± 0.51 ± 0.7 GeV/*c*². Decays to a
/// ``BottomQuark``.
struct TopQuark<ColorLike: SingleColor>: Quark {
  public let symbol = "t"
  public let charge = ElectricCharge.elementary(2 / 3)
  public let colorLike: ColorLike

  public init(colorLike: ColorLike) { self.colorLike = colorLike }

  func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass {
    approximator.approximate(
      .gigaelectronvoltsPerLightSpeedSquared(173.21),
      .gigaelectronvoltsPerLightSpeedSquared(0.51),
      .gigaelectronvoltsPerLightSpeedSquared(0.7)
    )
  }
}
