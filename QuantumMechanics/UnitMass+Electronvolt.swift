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

extension UnitMass {
  /// Amount in gigaelectronvolts (GeV/*c*²).
  static let gigaelectronvolt = UnitMass(
    symbol: "GeV",
    converter: UnitConverterLinear(coefficient: 5.6095886 * pow(10, 26) / pow(c.value, 2))
  )

  /// Amount in megaelectronvolts (MeV/*c*²).
  static let megaelectronvolt = UnitMass(
    symbol: "MeV",
    converter: UnitConverterLinear(coefficient: 5.6095886 * pow(10, 29) / pow(c.value, 2))
  )

  /// Amount in electronvolts (eV/*c*²).
  static let electronvolt = UnitMass(
    symbol: "eV",
    converter: UnitConverterLinear(coefficient: 5.6095886 * pow(10, 35) / pow(c.value, 2))
  )
}
