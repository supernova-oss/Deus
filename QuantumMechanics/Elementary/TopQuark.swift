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

/// Base value for calculating an approximation of the mass of a ``TopQuark``.
private let topBaseMass = Measurement(value: 173.21, unit: UnitMass.gigaelectronvolt)

/// Statistical uncertainty for calculating an approximation of the mass of a ``TopQuark``.
private let topMassStatisticalUncertainty = Measurement(
  value: 0.51,
  unit: UnitMass.gigaelectronvolt
)

/// Systematic uncertainty for calculating an approxiumation to the mass of a ``TopQuark``.
private let topMassSystematicUncertainty = Measurement(value: 0.7, unit: UnitMass.gigaelectronvolt)

/// Heaviest ``Quark``, with a Lagrangian mass of 173.21 ± 0.51 ± 0.7 GeV/*c*². Decays to a
/// ``BottomQuark``.
struct TopQuark<ColorLike: SingleColor>: Quark {
  public let symbol = "t"
  public let charge = twoThirdsOfE
  public let colorLike: ColorLike

  public init(colorLike: ColorLike) { self.colorLike = colorLike }

  func getMass(
    approximatedBy approximator: Approximator<Measurement<UnitMass>>
  ) -> Measurement<UnitMass> {
    approximator.approximate(
      topBaseMass,
      topMassStatisticalUncertainty,
      topMassSystematicUncertainty
    )
  }
}
