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
  @Test(arguments: [UnitRepresentable(unit: \Angle.Type.radians)])
  func makes(in unitRepresentable: UnitRepresentable<Angle>) {
    let measurable = Angle.self[keyPath: unitRepresentable.unit]
    let angle = Angle._make(
      quantityInCurrentUnit: 2,
      conversionCoefficient: measurable.conversionCoefficient,
      symbol: measurable.symbol
    )
    #expect(angle.quantityInCurrentUnit == 2)
    #expect(angle.conversionCoefficient == measurable.conversionCoefficient)
    #expect(angle.symbol == measurable.symbol)
  }

  @Test
  func initializesFromBaseUnit() {
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
      converted.quantityInBaseUnit == measurement.quantityInCurrentUnit
        * converted.conversionCoefficient
    )
    #expect(converted.symbol == Angle.self[keyPath: unitRepresentable.unit].symbol)
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
  @Test(arguments: [UnitRepresentable(unit: \ElectricCharge.Type.elementary)])
  func makes(in unitRepresentable: UnitRepresentable<ElectricCharge>) {
    let measurable = ElectricCharge.self[keyPath: unitRepresentable.unit]
    let electricCharge = ElectricCharge._make(
      quantityInCurrentUnit: 2,
      conversionCoefficient: measurable.conversionCoefficient,
      symbol: measurable.symbol
    )
    #expect(electricCharge.quantityInCurrentUnit == 2)
    #expect(electricCharge.conversionCoefficient == measurable.conversionCoefficient)
    #expect(electricCharge.symbol == measurable.symbol)
  }

  @Test
  func initializesFromBaseUnit() {
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
      converted.quantityInBaseUnit == measurement.quantityInCurrentUnit
        * converted.conversionCoefficient
    )
    #expect(converted.symbol == ElectricCharge.self[keyPath: unitRepresentable.unit].symbol)
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

fileprivate struct EnergyTests {
  @Test(arguments: [UnitRepresentable(unit: \Energy.Type.joules), .init(unit: \.electronvolts)])
  func makes(in unitRepresentable: UnitRepresentable<Energy>) {
    let measurable = Energy.self[keyPath: unitRepresentable.unit]
    let energy = Energy._make(
      quantityInCurrentUnit: 2,
      conversionCoefficient: measurable.conversionCoefficient,
      symbol: measurable.symbol
    )
    #expect(energy.quantityInCurrentUnit == 2)
    #expect(energy.conversionCoefficient == measurable.conversionCoefficient)
    #expect(energy.symbol == measurable.symbol)
  }

  @Test
  func initializesFromBaseUnit() {
    let energy = Energy(quantityInBaseUnit: 2)
    #expect(energy.quantityInBaseUnit == 2)
    #expect(energy.symbol == Energy.baseUnitSymbol)
  }

  @Test
  func identityIsZeroInBaseUnit() {
    #expect(Energy.zero.quantityInCurrentUnit == 0)
    #expect(Energy.zero.symbol == Energy.baseUnitSymbol)
  }

  @Test(arguments: [UnitRepresentable(unit: \Energy.Type.joules), .init(unit: \.electronvolts)])
  func negates(in unitRepresentable: UnitRepresentable<Energy>) {
    #expect(
      -Energy.self[keyPath: unitRepresentable.unit](2)
        == Energy.self[keyPath: unitRepresentable.unit](-2)
    )
  }

  @Test(arguments: [
    (Energy.joules(2), Energy.joules(2)), (.joules(2), .electronvolts(2)),
    (.electronvolts(2), .joules(2)), (.electronvolts(2), .electronvolts(2))
  ])
  func adds(_ addition: Energy, to measurement: Energy) {
    #expect(
      measurement + addition
        == .init(quantityInBaseUnit: measurement.quantityInBaseUnit + addition.quantityInBaseUnit)
    )
  }

  @Test(arguments: [
    (Energy.joules(2), Energy.joules(2)), (.joules(2), .electronvolts(2)),
    (.electronvolts(2), .joules(2)), (.electronvolts(2), .electronvolts(2))
  ])
  func subtracts(_ subtraction: Energy, from measurement: Energy) {
    #expect(
      measurement - subtraction
        == .init(
          quantityInBaseUnit: measurement.quantityInBaseUnit - subtraction.quantityInBaseUnit
        )
    )
  }

  @Test(
    arguments: zip(
      [Energy.joules(2), .electronvolts(2)],
      [UnitRepresentable(unit: \Energy.Type.joules), .init(unit: \.electronvolts)]
    )
  )
  func converts(_ measurement: Energy, into unitRepresentable: UnitRepresentable<Energy>) {
    let converted = measurement.converted(into: unitRepresentable.unit)
    #expect(
      converted.quantityInBaseUnit == measurement.quantityInCurrentUnit
        * converted.conversionCoefficient
    )
    #expect(converted.symbol == Energy.self[keyPath: unitRepresentable.unit].symbol)
  }

  @Test(arguments: [UnitRepresentable(unit: \Energy.Type.joules), .init(unit: \.electronvolts)])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Energy>) {
    let energy = Energy.self[keyPath: unitRepresentable.unit](2)
    #expect(
      "\(energy)" == "\(Energy.formatted(quantity: energy.quantityInCurrentUnit)) \(energy.symbol)"
    )
  }
}

fileprivate struct MassTests {
  @Test(arguments: [
    UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared), .init(unit: \.kilograms),
    .init(unit: \.megaelectronvoltsPerLightSpeedSquared),
    .init(unit: \.gigaelectronvoltsPerLightSpeedSquared)
  ])
  func makes(in unitRepresentable: UnitRepresentable<Mass>) {
    let measurable = Mass.self[keyPath: unitRepresentable.unit]
    let mass = Mass._make(
      quantityInCurrentUnit: 2,
      conversionCoefficient: measurable.conversionCoefficient,
      symbol: measurable.symbol
    )
    #expect(mass.quantityInCurrentUnit == 2)
    #expect(mass.conversionCoefficient == measurable.conversionCoefficient)
    #expect(mass.symbol == measurable.symbol)
  }

  @Test
  func initializesFromBaseUnit() {
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
    UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared), .init(unit: \.kilograms),
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
    (.electronvoltsPerLightSpeedSquared(2), .kilograms(2)),
    (.electronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.kilograms(2), .electronvoltsPerLightSpeedSquared(2)), (.kilograms(2), .kilograms(2)),
    (.kilograms(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.kilograms(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .kilograms(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .kilograms(2)),
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
    (.electronvoltsPerLightSpeedSquared(2), .kilograms(2)),
    (.electronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.kilograms(2), .electronvoltsPerLightSpeedSquared(2)), (.kilograms(2), .kilograms(2)),
    (.kilograms(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.kilograms(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .kilograms(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .kilograms(2)),
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
        Mass.electronvoltsPerLightSpeedSquared(2), .kilograms(2),
        .megaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)
      ],
      [
        UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared),
        .init(unit: \.kilograms), .init(unit: \.megaelectronvoltsPerLightSpeedSquared),
        .init(unit: \.gigaelectronvoltsPerLightSpeedSquared)
      ]
    )
  )
  func converts(_ measurement: Mass, into unitRepresentable: UnitRepresentable<Mass>) {
    let converted = measurement.converted(into: unitRepresentable.unit)
    #expect(
      converted.quantityInBaseUnit == measurement.quantityInCurrentUnit
        * converted.conversionCoefficient
    )
    #expect(converted.symbol == Mass.self[keyPath: unitRepresentable.unit].symbol)
  }

  @Test(arguments: [
    UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared), .init(unit: \.kilograms),
    .init(unit: \.megaelectronvoltsPerLightSpeedSquared),
    .init(unit: \.gigaelectronvoltsPerLightSpeedSquared)
  ])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Mass>) {
    let mass = Mass.self[keyPath: unitRepresentable.unit](2)
    #expect("\(mass)" == "\(Mass.formatted(quantity: mass.quantityInCurrentUnit)) \(mass.symbol)")
  }
}

fileprivate struct SpeedTests {
  @Test(arguments: [UnitRepresentable(unit: \Speed.Type.metersPerSecond), .init(unit: \.light)])
  func makes(in unitRepresentable: UnitRepresentable<Speed>) {
    let measurable = Speed.self[keyPath: unitRepresentable.unit]
    let speed = Speed._make(
      quantityInCurrentUnit: 2,
      conversionCoefficient: measurable.conversionCoefficient,
      symbol: measurable.symbol
    )
    #expect(speed.quantityInCurrentUnit == 2)
    #expect(speed.conversionCoefficient == measurable.conversionCoefficient)
    #expect(speed.symbol == measurable.symbol)
  }

  @Test
  func initializesFromBaseUnit() {
    let speed = Speed(quantityInBaseUnit: 2)
    #expect(speed.quantityInBaseUnit == 2)
    #expect(speed.symbol == Speed.baseUnitSymbol)
  }

  @Test
  func identityIsZeroInBaseUnit() {
    #expect(Speed.zero.quantityInCurrentUnit == 0)
    #expect(Speed.zero.symbol == Speed.baseUnitSymbol)
  }

  @Test(arguments: [UnitRepresentable(unit: \Speed.Type.metersPerSecond), .init(unit: \.light)])
  func negates(in unitRepresentable: UnitRepresentable<Speed>) {
    #expect(
      -Speed.self[keyPath: unitRepresentable.unit](2)
        == Speed.self[keyPath: unitRepresentable.unit](-2)
    )
  }

  @Test(arguments: [
    (Speed.metersPerSecond(2), Speed.metersPerSecond(2)), (.metersPerSecond(2), .light(2)),
    (.light(2), .metersPerSecond(2)), (.light(2), .light(2))
  ])
  func adds(_ addition: Speed, to measurement: Speed) {
    #expect(
      measurement + addition
        == .init(quantityInBaseUnit: measurement.quantityInBaseUnit + addition.quantityInBaseUnit)
    )
  }

  @Test(arguments: [
    (Speed.metersPerSecond(2), Speed.metersPerSecond(2)), (.metersPerSecond(2), .light(2)),
    (.light(2), .metersPerSecond(2)), (.light(2), .light(2))
  ])
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
      [Speed.metersPerSecond(2), .light(2)],
      [UnitRepresentable(unit: \Speed.Type.metersPerSecond), .init(unit: \.light)]
    )
  )
  func converts(_ measurement: Speed, into unitRepresentable: UnitRepresentable<Speed>) {
    let converted = measurement.converted(into: unitRepresentable.unit)
    #expect(
      converted.quantityInBaseUnit == measurement.quantityInCurrentUnit
        * converted.conversionCoefficient
    )
    #expect(converted.symbol == Speed.self[keyPath: unitRepresentable.unit].symbol)
  }

  @Test(arguments: [UnitRepresentable(unit: \Speed.Type.metersPerSecond), .init(unit: \.light)])
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
private struct UnitRepresentable<MeasurementType>: @unchecked Sendable
where MeasurementType: Measurement {
  /// The unit of the specified ``Measurement`` being represented.
  let unit: MeasurementType.Unit
}

extension UnitRepresentable: CustomDebugStringConvertible {
  var debugDescription: String {
    switch unit {
    case _ where unit == \Angle.Type.radians: "radians"
    case _ where unit == \ElectricCharge.Type.elementary: "elementary"
    case _ where unit == \Energy.Type.electronvolts: "electronvolts"
    case _ where unit == \Energy.Type.joules: "joules"
    case _ where unit == \Mass.Type.electronvoltsPerLightSpeedSquared:
      "electronvoltsPerLightSpeedSquared"
    case _ where unit == \Mass.Type.gigaelectronvoltsPerLightSpeedSquared:
      "gigaelectronvoltsPerLightSpeedSquared"
    case _ where unit == \Mass.Type.kilograms: "kilograms"
    case _ where unit == \Mass.Type.megaelectronvoltsPerLightSpeedSquared:
      "megaelectronvoltsPerLightSpeedSquared"
    case _ where unit == \Speed.Type.light: "light"
    case _ where unit == \Speed.Type.metersPerSecond: "metersPerSecond"
    default: "Unknown instance of UnitRepresentable<\(MeasurementType.self)>"
    }
  }
}
