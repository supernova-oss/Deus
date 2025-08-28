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

/// Base value for calculating an approximation of the mass of a ``StrangeQuark``.
private let baseMass = Measurement(value: 95, unit: UnitMass.megaelectronvolt)

/// Statistical uncertainty for calculating an approximation of the mass of a ``StrangeQuark``.
private let massStatisticalUncertainty = Measurement(value: 5, unit: UnitMass.gigaelectronvolt)

/// Third lightest ``Quark``, with a Lagrangian mass of 95 ± 5 MeV/*c*². Decays to a ``DownQuark``.
public struct StrangeQuark<ColorLike: SingleColor>: Quark {
  public let symbol = "s"
  public let charge = negativeOneThirdOfE
  public let colorLike: ColorLike

  public init(colorLike: ColorLike) { self.colorLike = colorLike }

  public func getMass(
    approximatedBy approximator: Approximator<Measurement<UnitMass>>
  ) -> Measurement<UnitMass> {
    approximator.approximate(baseMass, massStatisticalUncertainty, .zero)
  }
}
