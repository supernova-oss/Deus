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

extension UnitElectricCharge {
  /// Coefficient of the factor of the conversion of the base unit of electric charge, C, into *e*.
  fileprivate static let x = 1.602176634

  /// Amount in elementary charge (*e*). *e* is a fundamental constant as per the SI, equating
  /// 1.602176634 × 10⁻¹⁹ C and representing the least amount of electric charge which can exist
  /// unconfined in the universe.
  public static let elementary = UnitElectricCharge(
    symbol: "e",
    converter: UnitEnergy.electronvolts.converter
  )
}

extension UnitEnergy {
  /// Amount in electronvolts (eV/*c*²).
  @available(*, deprecated, renamed: "electronvolts")
  public static let electronvolt = electronvolts

  /// Unit of energy whose numeric value is equal to that of *e* in C. Represents the amount of
  /// energy gained or lost by an electron moving through an electric potential difference of 1 V.
  ///
  /// - SeeAlso: ``Foundation/UnitElectricCharge/elementary``
  public static let electronvolts = UnitEnergy(
    symbol: "eV",
    converter: UnitConverterLinear(coefficient: UnitElectricCharge.x * pow(10, -19))
  )
}

extension UnitMass {
  /// Coefficient of the factor of the conversion of the base unit of mass, kg, into eV/c² and its
  /// multiples and submultiples.
  private static let x = 1.78266192

  /// Amount in electronvolts (eV/*c*²).
  @available(*, deprecated, renamed: "electronvoltsPerLightSpeedSquared")
  public static let electronvolt = electronvoltsPerLightSpeedSquared

  /// Amount in electronvolts per the square of the speed of light (eV/*c*²).
  ///
  /// - SeeAlso: ``Foundation/UnitSpeed/lightSquared``
  /// - SeeAlso: ``electronvolt``
  public static let electronvoltsPerLightSpeedSquared = UnitMass(
    symbol: "eV/c²",
    converter: UnitConverterLinear(coefficient: x * pow(10, -36))
  )

  /// Amount in gigaelectronvolts (GeV/*c*²).
  @available(*, deprecated, renamed: "gigaelectronvoltsPerLightSpeedSquared")
  public static let gigaelectronvolt = gigaelectronvoltsPerLightSpeedSquared

  /// Amount in gigaelectronvolts per the square of the speed of light (GeV/*c*²).
  ///
  /// - SeeAlso: ``Foundation/UnitSpeed/lightSquared``
  public static let gigaelectronvoltsPerLightSpeedSquared = UnitMass(
    symbol: "GeV/c²",
    converter: UnitConverterLinear(coefficient: x * pow(10, -27))
  )

  /// Amount in megaelectronvolts (MeV/*c*²).
  ///
  /// - SeeAlso: ``Foundation/UnitSpeed/lightSquared``
  @available(*, deprecated, renamed: "megaelectronvoltsPerLightSpeedSquared")
  public static let megaelectronvolt = megaelectronvoltsPerLightSpeedSquared

  /// Amount in gigaelectronvolts per the square of the speed of light (GeV/*c*²).
  ///
  /// - SeeAlso: ``Foundation/UnitSpeed/lightSquared``
  public static let megaelectronvoltsPerLightSpeedSquared = UnitMass(
    symbol: "MeV/c²",
    converter: UnitConverterLinear(coefficient: x * pow(10, -30))
  )
}
