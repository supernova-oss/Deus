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

/// Second lightest ``Quark``, with a Lagrangian mass of 4.8 ± 0.5 ± 0.3 MeV/*c*². Decays to an
/// ``UpQuark``.
public struct DownQuark<ColorLike: SingleColor>: Quark {
  public let symbol = "d"
  public let charge = ElectricCharge.elementary(-1 / 3)
  public let colorLike: ColorLike

  public init(colorLike: ColorLike) { self.colorLike = colorLike }

  public func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass {
    approximator.approximate(
      .megaelectronvoltsPerLightSpeedSquared(4.8),
      .megaelectronvoltsPerLightSpeedSquared(0.5),
      .megaelectronvoltsPerLightSpeedSquared(0.3)
    )
  }
}
