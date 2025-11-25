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

fileprivate struct AngleTests {
  @Test
  func callingTheInitializerProducesAngleWhoseQuantityIsInTheBaseUnit() {
    let angle = Angle(quantityInBaseUnit: 2)
    #expect(angle.quantityInBaseUnit == 2)
    #expect(angle.symbol == Angle.baseUnitSymbol)
  }

  @Test
  func identityIsZeroInBaseUnit() {
    #expect(Angle.zero.quantityInCurrentUnit == 0)
    #expect(Angle.zero.symbol == Angle.baseUnitSymbol)
  }

  @Test(arguments: [UnitRepresentable(unit: \Angle.Type.radians)])
  func negates(in unitRepresentable: UnitRepresentable<Angle>) {
    #expect(
      -Angle.self[keyPath: unitRepresentable.unit](2)
        == Angle.self[keyPath: unitRepresentable.unit](-2)
    )
  }

  @Test(arguments: [(Angle.radians(2), Angle.radians(2))])
  func adds(_ addition: Angle, to measurement: Angle) {
    #expect(
      measurement + addition
        == .init(quantityInBaseUnit: measurement.quantityInBaseUnit + addition.quantityInBaseUnit)
    )
  }

  @Test(arguments: [(Angle.radians(2), Angle.radians(2))])
  func subtracts(_ subtraction: Angle, from measurement: Angle) {
    #expect(
      measurement - subtraction
        == .init(
          quantityInBaseUnit: measurement.quantityInBaseUnit - subtraction.quantityInBaseUnit
        )
    )
  }

  @Test(arguments: zip([Angle.radians(2)], [UnitRepresentable(unit: \Angle.Type.radians)]))
  func converts(_ measurement: Angle, into unitRepresentable: UnitRepresentable<Angle>) {
    let converted = measurement.converted(into: unitRepresentable.unit)
    #expect(
      converted.quantityInBaseUnit == converted.quantityInCurrentUnit
        / measurement.conversionCoefficient
    )
  }

  @Test(arguments: [UnitRepresentable(unit: \Angle.Type.radians)])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Angle>) {
    let angle = Angle.self[keyPath: unitRepresentable.unit](2)
    #expect(
      "\(angle)" == "\(Angle.formatted(quantity: angle.quantityInCurrentUnit)) \(angle.symbol)"
    )
  }
}

fileprivate struct ElectricChargeTests {
  @Test
  func callingTheInitializerProducesElectricChargeWhoseQuantityIsInTheBaseUnit() {
    let electricCharge = ElectricCharge(quantityInBaseUnit: 2)
    #expect(electricCharge.quantityInBaseUnit == 2)
    #expect(electricCharge.symbol == ElectricCharge.baseUnitSymbol)
  }

  @Test
  func identityIsZeroInBaseUnit() {
    #expect(ElectricCharge.zero.quantityInCurrentUnit == 0)
    #expect(ElectricCharge.zero.symbol == ElectricCharge.baseUnitSymbol)
  }

  @Test(arguments: [UnitRepresentable(unit: \ElectricCharge.Type.elementary)])
  func negates(in unitRepresentable: UnitRepresentable<ElectricCharge>) {
    #expect(
      -ElectricCharge.self[keyPath: unitRepresentable.unit](2)
        == ElectricCharge.self[keyPath: unitRepresentable.unit](-2)
    )
  }

  @Test(arguments: [(ElectricCharge.elementary(2), ElectricCharge.elementary(2))])
  func adds(_ addition: ElectricCharge, to measurement: ElectricCharge) {
    #expect(
      measurement + addition
        == .init(quantityInBaseUnit: measurement.quantityInBaseUnit + addition.quantityInBaseUnit)
    )
  }

  @Test(arguments: [(ElectricCharge.elementary(2), ElectricCharge.elementary(2))])
  func subtracts(_ subtraction: ElectricCharge, from measurement: ElectricCharge) {
    #expect(
      measurement - subtraction
        == .init(
          quantityInBaseUnit: measurement.quantityInBaseUnit - subtraction.quantityInBaseUnit
        )
    )
  }

  @Test(
    arguments: zip(
      [ElectricCharge.elementary(2)],
      [UnitRepresentable(unit: \ElectricCharge.Type.elementary)]
    )
  )
  func converts(
    _ measurement: ElectricCharge,
    into unitRepresentable: UnitRepresentable<ElectricCharge>
  ) {
    let converted = measurement.converted(into: unitRepresentable.unit)
    #expect(
      converted.quantityInBaseUnit == converted.quantityInCurrentUnit
        / measurement.conversionCoefficient
    )
  }

  @Test(arguments: [UnitRepresentable(unit: \ElectricCharge.Type.elementary)])
  func isDescribedByQuantityInCurrentUnitAndSymbol(
    _ unitRepresentable: UnitRepresentable<ElectricCharge>
  ) {
    let electricCharge = ElectricCharge.self[keyPath: unitRepresentable.unit](2)
    #expect(
      "\(electricCharge)"
        == "\(ElectricCharge.formatted(quantity: electricCharge.quantityInCurrentUnit)) \(electricCharge.symbol)"
    )
  }
}

fileprivate struct MassTests {
  @Test
  func callingTheInitializerProducesMassWhoseQuantityIsInTheBaseUnit() {
    let mass = Mass(quantityInBaseUnit: 2)
    #expect(mass.quantityInBaseUnit == 2)
    #expect(mass.symbol == Mass.baseUnitSymbol)
  }

  @Test
  func identityIsZeroInBaseUnit() {
    #expect(Mass.zero.quantityInCurrentUnit == 0)
    #expect(Mass.zero.symbol == Mass.baseUnitSymbol)
  }

  @Test(arguments: [
    UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared),
    .init(unit: \.megaelectronvoltsPerLightSpeedSquared),
    .init(unit: \.gigaelectronvoltsPerLightSpeedSquared)
  ])
  func negates(in unitRepresentable: UnitRepresentable<Mass>) {
    #expect(
      -Mass.self[keyPath: unitRepresentable.unit](2)
        == Mass.self[keyPath: unitRepresentable.unit](-2)
    )
  }

  @Test(arguments: [
    (Mass.electronvoltsPerLightSpeedSquared(2), Mass.electronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2))
  ])
  func adds(_ addition: Mass, to measurement: Mass) {
    #expect(
      measurement + addition
        == .init(quantityInBaseUnit: measurement.quantityInBaseUnit + addition.quantityInBaseUnit)
    )
  }

  @Test(arguments: [
    (Mass.electronvoltsPerLightSpeedSquared(2), Mass.electronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2))
  ])
  func subtracts(_ subtraction: Mass, from measurement: Mass) {
    #expect(
      measurement - subtraction
        == .init(
          quantityInBaseUnit: measurement.quantityInBaseUnit - subtraction.quantityInBaseUnit
        )
    )
  }

  @Test(
    arguments: zip(
      [
        Mass.electronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2),
        .gigaelectronvoltsPerLightSpeedSquared(2)
      ],
      [
        UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared),
        .init(unit: \.megaelectronvoltsPerLightSpeedSquared),
        .init(unit: \.gigaelectronvoltsPerLightSpeedSquared)
      ]
    )
  )
  func converts(_ measurement: Mass, into unitRepresentable: UnitRepresentable<Mass>) {
    let converted = measurement.converted(into: unitRepresentable.unit)
    #expect(
      converted.quantityInBaseUnit == converted.quantityInCurrentUnit
        / measurement.conversionCoefficient
    )
  }

  @Test(arguments: [
    UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared),
    .init(unit: \.megaelectronvoltsPerLightSpeedSquared),
    .init(unit: \.gigaelectronvoltsPerLightSpeedSquared)
  ])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Mass>) {
    let mass = Mass.self[keyPath: unitRepresentable.unit](2)
    #expect("\(mass)" == "\(Mass.formatted(quantity: mass.quantityInCurrentUnit)) \(mass.symbol)")
  }
}

fileprivate struct SpeedTests {
  @Test
  func callingTheInitializerProducesSpeedWhoseQuantityIsInTheBaseUnit() {
    let speed = Speed(quantityInBaseUnit: 2)
    #expect(speed.quantityInBaseUnit == 2)
    #expect(speed.symbol == Speed.baseUnitSymbol)
  }

  @Test
  func identityIsZeroInBaseUnit() {
    #expect(Speed.zero.quantityInCurrentUnit == 0)
    #expect(Speed.zero.symbol == Speed.baseUnitSymbol)
  }

  @Test(arguments: [UnitRepresentable(unit: \Speed.Type.metersPerSecond)])
  func negates(in unitRepresentable: UnitRepresentable<Speed>) {
    #expect(
      -Speed.self[keyPath: unitRepresentable.unit](2)
        == Speed.self[keyPath: unitRepresentable.unit](-2)
    )
  }

  @Test(arguments: [(Speed.metersPerSecond(2), Speed.metersPerSecond(2))])
  func adds(_ addition: Speed, to measurement: Speed) {
    #expect(
      measurement + addition
        == .init(quantityInBaseUnit: measurement.quantityInBaseUnit + addition.quantityInBaseUnit)
    )
  }

  @Test(arguments: [(Speed.metersPerSecond(2), Speed.metersPerSecond(2))])
  func subtracts(_ subtraction: Speed, from measurement: Speed) {
    #expect(
      measurement - subtraction
        == .init(
          quantityInBaseUnit: measurement.quantityInBaseUnit - subtraction.quantityInBaseUnit
        )
    )
  }

  @Test(
    arguments: zip(
      [Speed.metersPerSecond(2)],
      [UnitRepresentable(unit: \Speed.Type.metersPerSecond)]
    )
  )
  func converts(_ measurement: Speed, into unitRepresentable: UnitRepresentable<Speed>) {
    let converted = measurement.converted(into: unitRepresentable.unit)
    #expect(
      converted.quantityInBaseUnit == converted.quantityInCurrentUnit
        / measurement.conversionCoefficient
    )
  }

  @Test(arguments: [UnitRepresentable(unit: \Speed.Type.metersPerSecond)])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Speed>) {
    let speed = Speed.self[keyPath: unitRepresentable.unit](2)
    #expect(
      "\(speed)" == "\(Speed.formatted(quantity: speed.quantityInCurrentUnit)) \(speed.symbol)"
    )
  }
}

/// Representation of an SI unit in which a quantity of a ``Measurement`` may be. Exists merely for
/// debugging purposes, allowing for displaying the actual name of the unit while testing rather
/// than the string of the key path.
private struct UnitRepresentable<MeasurementType> where MeasurementType: Measurement {
  /// The unit of the specified ``Measurement`` being represented.
  let unit: MeasurementType.Unit
}

extension UnitRepresentable: CustomDebugStringConvertible {
  var debugDescription: String {
    switch unit {
    case _ where unit == \ElectricCharge.Type.elementary: "elementary"
    case _ where unit == \Speed.Type.metersPerSecond: "metersPerSecond"
    case _ where unit == \Mass.Type.gigaelectronvoltsPerLightSpeedSquared:
      "gigaelectronvoltsPerLightSpeedSquared"
    case _ where unit == \Angle.Type.radians: "radians"
    case _ where unit == \Mass.Type.electronvoltsPerLightSpeedSquared:
      "electronvoltsPerLightSpeedSquared"
    case _ where unit == \Mass.Type.megaelectronvoltsPerLightSpeedSquared:
      "megaelectronvoltsPerLightSpeedSquared"
    default: "Unknown instance of UnitRepresentable<\(MeasurementType.self)>"
    }
  }
}
