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
// ===-------------------------------------------------------------------------------------------===I

/// Lightest ``Quark``, with a Lagrangian mass of 2.3 ± 0.7 ± 0.5 MeV/*c*². As per the Standard
/// Model, cannot decay.
public struct UpQuark<ColorLike: SingleColor>: Quark {
  public let symbol = "u"
  public let charge = ElectricCharge.elementary(2 / 3)
  public let colorLike: ColorLike

  public init(colorLike: ColorLike) { self.colorLike = colorLike }

  public func getMass(approximatedBy approximator: Approximator<Mass>) -> Mass {
    approximator.approximate(
      .megaelectronvoltsPerLightSpeedSquared(2.3),
      .megaelectronvoltsPerLightSpeedSquared(0.7),
      .megaelectronvoltsPerLightSpeedSquared(0.5)
    )
  }
}
