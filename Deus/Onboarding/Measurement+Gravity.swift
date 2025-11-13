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

import Foundation

/// The gravitational constant *G* in m³ ⋅ kg⁻¹ ⋅ s⁻² as per the
/// [2022 Committee on Data for Science and Technology (CODATA) recommended values](https://physics.nist.gov/cgi-bin/cuu/Value?bg).
let newtonianGravitationalConstant = 6.6743e-11

// MARK: - Solar mass

extension UnitMass {
  /// The solar mass *M☉* in kg.
  private static let coefficient = 1.988_416e30

  /// The solar mass *M☉*, an approximation to the mass of the Sun, as per the
  /// [International Astronomical Union (IAU) 2015 Resolution B3](https://iopscience.iop.org/article/10.3847/0004-6256/152/2/41).
  static let solar = UnitMass(
    symbol: "M☉",
    converter: UnitConverterLinear(coefficient: coefficient)
  )
}
