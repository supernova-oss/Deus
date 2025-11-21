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

import Testing

@testable import QuantumMechanics

struct MeasurementTests {
  @Test
  func callingTheInitializerProducesChargeWhoseQuantityIsInTheBaseUnit() {
    let charge = ElectricCharge(quantityInBaseUnit: 2)
    #expect(charge.quantityInBaseUnit == 2)
    #expect(charge.symbol == ElectricCharge.baseUnitSymbol)
  }

  @Suite("Additive arithmetic")
  struct AdditiveArithmeticTests {
    @Test
    func identityIsZeroInBaseUnit() {
      #expect(ElectricCharge.zero.quantityInCurrentUnit == 0)
      #expect(ElectricCharge.zero.symbol == ElectricCharge.baseUnitSymbol)
    }

    @Test
    func negates() { #expect(-ElectricCharge.elementary(2) == ElectricCharge.elementary(-2)) }

    @Test(arguments: [
      ElectricCharge.elementary(0): ElectricCharge.elementary(2), .elementary(2): .elementary(4)
    ])
    func adds(_ addition: ElectricCharge, to measurement: ElectricCharge) {
      #expect(
        measurement + addition
          == .init(quantityInBaseUnit: measurement.quantityInBaseUnit + addition.quantityInBaseUnit)
      )
    }

    @Test(arguments: [
      ElectricCharge.elementary(0): ElectricCharge.elementary(2), .elementary(4): .elementary(2)
    ])
    func subtracts(_ subtraction: ElectricCharge, from measurement: ElectricCharge) {
      #expect(
        measurement - subtraction
          == .init(
            quantityInBaseUnit: measurement.quantityInBaseUnit - subtraction.quantityInBaseUnit
          )
      )
    }
  }

  @Suite("Conversion")
  struct ConversionTests {
    @Test
    func convertingInElementaryIntoItsOwnUnitReturnsItself() {
      #expect(ElectricCharge.elementary(2).converted(into: \.elementary) == .elementary(2))
    }

    @Test(
      arguments: [\.megaelectronvoltsPerLightSpeedSquared, \.gigaelectronvoltsPerLightSpeedSquared]
        as [KeyPath<Mass.Type, Measurable<Mass>>]
    )
    func converts(into converter: Mass.Converter) {
      let original = Mass.electronvoltsPerLightSpeedSquared(2)
      let converted = original.converted(into: converter)
      #expect(
        converted.quantityInBaseUnit == original.quantityInBaseUnit
          * converted.conversionCoefficient
      )
    }
  }
}
