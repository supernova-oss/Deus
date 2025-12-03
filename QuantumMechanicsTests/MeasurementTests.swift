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

@testable import QuantumMechanics
import Testing

fileprivate struct AngleTests {
  @Test(arguments: [UnitRepresentable(unit: \Angle.Type.radians)])
  func makes(in unitRepresentable: UnitRepresentable<Angle>) {
    let measurable = Angle.in(unitRepresentable.unit)
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
    let angle: Angle = 2
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
    let initialAngle = Angle.in(unitRepresentable.unit)(2)
    let negatedAngle = -initialAngle
    #expect(negatedAngle == Angle.in(unitRepresentable.unit)(-2))
    #expect(negatedAngle.symbol == initialAngle.symbol)
  }

  @Test(arguments: [(Angle.radians(2), Angle.radians(2))])
  func adds(_ addition: Angle, to initial: Angle) {
    #expect(
      (initial + addition).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit + addition.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [(Angle.radians(2), Angle.radians(2))])
  func subtracts(_ subtraction: Angle, from initial: Angle) {
    #expect(
      (initial - subtraction).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit - subtraction.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [UnitRepresentable(unit: \Angle.Type.radians)])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Angle>) {
    let angle = Angle.in(unitRepresentable.unit)(2)
    #expect(
      "\(angle)" == "\(Angle.formatted(quantity: angle.quantityInCurrentUnit)) \(angle.symbol)"
    )
  }

  @Test(arguments: zip([Angle.radians(2)], [UnitRepresentable(unit: \Angle.Type.radians)]))
  func converts(_ initial: Angle, into unitRepresentable: UnitRepresentable<Angle>) {
    let converted = initial.converted(into: unitRepresentable.unit)
    #expect(converted.quantityInBaseUnit == initial.quantityInBaseUnit)
    #expect(converted.symbol == Angle.in(unitRepresentable.unit).symbol)
  }
}

fileprivate struct ElectricChargeTests {
  @Test(arguments: [UnitRepresentable(unit: \ElectricCharge.Type.elementary)])
  func makes(in unitRepresentable: UnitRepresentable<ElectricCharge>) {
    let measurable = ElectricCharge.in(unitRepresentable.unit)
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
    let electricCharge: ElectricCharge = 2
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
    let initialElectricCharge = ElectricCharge.in(unitRepresentable.unit)(2)
    let negatedElectricCharge = -initialElectricCharge
    #expect(negatedElectricCharge == ElectricCharge.in(unitRepresentable.unit)(-2))
    #expect(negatedElectricCharge.symbol == initialElectricCharge.symbol)
  }

  @Test(arguments: [(ElectricCharge.elementary(2), ElectricCharge.elementary(2))])
  func adds(_ addition: ElectricCharge, to initial: ElectricCharge) {
    #expect(
      (initial + addition).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit + addition.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [(ElectricCharge.elementary(2), ElectricCharge.elementary(2))])
  func subtracts(_ subtraction: ElectricCharge, from initial: ElectricCharge) {
    #expect(
      (initial - subtraction).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit - subtraction.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [UnitRepresentable(unit: \ElectricCharge.Type.elementary)])
  func isDescribedByQuantityInCurrentUnitAndSymbol(
    _ unitRepresentable: UnitRepresentable<ElectricCharge>
  ) {
    let electricCharge = ElectricCharge.in(unitRepresentable.unit)(2)
    #expect(
      "\(electricCharge)"
        == "\(ElectricCharge.formatted(quantity: electricCharge.quantityInCurrentUnit)) \(electricCharge.symbol)"
    )
  }

  @Test(
    arguments: zip(
      [ElectricCharge.elementary(2)],
      [UnitRepresentable(unit: \ElectricCharge.Type.elementary)]
    )
  )
  func converts(
    _ initial: ElectricCharge,
    into unitRepresentable: UnitRepresentable<ElectricCharge>
  ) {
    let converted = initial.converted(into: unitRepresentable.unit)
    #expect(converted.quantityInBaseUnit == initial.quantityInBaseUnit)
    #expect(converted.symbol == ElectricCharge.in(unitRepresentable.unit).symbol)
  }
}

fileprivate struct MassTests {
  @Test(arguments: [
    UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared),
    .init(unit: \.gigaelectronvoltsPerLightSpeedSquared),
    .init(unit: \.megaelectronvoltsPerLightSpeedSquared)
  ])
  func makes(in unitRepresentable: UnitRepresentable<Mass>) {
    let measurable = Mass.in(unitRepresentable.unit)
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
    let mass: Mass = 2
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
    .init(unit: \.gigaelectronvoltsPerLightSpeedSquared),
    .init(unit: \.megaelectronvoltsPerLightSpeedSquared)
  ])
  func negates(in unitRepresentable: UnitRepresentable<Mass>) {
    let initialMass = Mass.in(unitRepresentable.unit)(2)
    let negatedMass = -initialMass
    #expect(negatedMass == Mass.in(unitRepresentable.unit)(-2))
    #expect(negatedMass.symbol == initialMass.symbol)
  }

  @Test(arguments: [
    (Mass.electronvoltsPerLightSpeedSquared(2), Mass.electronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2))
  ])
  func adds(_ addition: Mass, to initial: Mass) {
    #expect(
      (initial + addition).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit + addition.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [
    (Mass.electronvoltsPerLightSpeedSquared(2), Mass.electronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.electronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.gigaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .electronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2)),
    (.megaelectronvoltsPerLightSpeedSquared(2), .megaelectronvoltsPerLightSpeedSquared(2))
  ])
  func subtracts(_ subtraction: Mass, from initial: Mass) {
    #expect(
      (initial - subtraction).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit - subtraction.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [
    UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared),
    .init(unit: \.gigaelectronvoltsPerLightSpeedSquared),
    .init(unit: \.megaelectronvoltsPerLightSpeedSquared)
  ])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Mass>) {
    let mass = Mass.in(unitRepresentable.unit)(2)
    #expect("\(mass)" == "\(Mass.formatted(quantity: mass.quantityInCurrentUnit)) \(mass.symbol)")
  }

  @Test(
    arguments: zip(
      [
        Mass.electronvoltsPerLightSpeedSquared(2), .gigaelectronvoltsPerLightSpeedSquared(2),
        .megaelectronvoltsPerLightSpeedSquared(2)
      ],
      [
        UnitRepresentable(unit: \Mass.Type.electronvoltsPerLightSpeedSquared),
        .init(unit: \.gigaelectronvoltsPerLightSpeedSquared),
        .init(unit: \.megaelectronvoltsPerLightSpeedSquared)
      ]
    )
  )
  func converts(_ initial: Mass, into unitRepresentable: UnitRepresentable<Mass>) {
    let converted = initial.converted(into: unitRepresentable.unit)
    #expect(converted.quantityInBaseUnit == initial.quantityInBaseUnit)
    #expect(converted.symbol == Mass.in(unitRepresentable.unit).symbol)
  }
}

fileprivate struct SpeedTests {
  @Test(arguments: [UnitRepresentable(unit: \Speed.Type.metersPerSecond)])
  func makes(in unitRepresentable: UnitRepresentable<Speed>) {
    let measurable = Speed.in(unitRepresentable.unit)
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
    let speed: Speed = 2
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
    let initialSpeed = Speed.in(unitRepresentable.unit)(2)
    let negatedSpeed = -initialSpeed
    #expect(negatedSpeed == Speed.in(unitRepresentable.unit)(-2))
    #expect(negatedSpeed.symbol == initialSpeed.symbol)
  }

  @Test(arguments: [(Speed.metersPerSecond(2), Speed.metersPerSecond(2))])
  func adds(_ addition: Speed, to initial: Speed) {
    #expect(
      (initial + addition).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit + addition.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [(Speed.metersPerSecond(2), Speed.metersPerSecond(2))])
  func subtracts(_ subtraction: Speed, from initial: Speed) {
    #expect(
      (initial - subtraction).quantityInBaseUnit.isApproximatelyEqual(
        to: initial.quantityInBaseUnit - subtraction.quantityInBaseUnit
      )
    )
  }

  @Test(arguments: [UnitRepresentable(unit: \Speed.Type.metersPerSecond)])
  func isDescribedByQuantityInCurrentUnitAndSymbol(_ unitRepresentable: UnitRepresentable<Speed>) {
    let speed = Speed.in(unitRepresentable.unit)(2)
    #expect(
      "\(speed)" == "\(Speed.formatted(quantity: speed.quantityInCurrentUnit)) \(speed.symbol)"
    )
  }

  @Test(
    arguments: zip(
      [Speed.metersPerSecond(2)],
      [UnitRepresentable(unit: \Speed.Type.metersPerSecond)]
    )
  )
  func converts(_ initial: Speed, into unitRepresentable: UnitRepresentable<Speed>) {
    let converted = initial.converted(into: unitRepresentable.unit)
    #expect(converted.quantityInBaseUnit == initial.quantityInBaseUnit)
    #expect(converted.symbol == Speed.in(unitRepresentable.unit).symbol)
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
    case _ where unit == \Mass.Type.electronvoltsPerLightSpeedSquared:
      "electronvoltsPerLightSpeedSquared"
    case _ where unit == \Mass.Type.gigaelectronvoltsPerLightSpeedSquared:
      "gigaelectronvoltsPerLightSpeedSquared"
    case _ where unit == \Mass.Type.megaelectronvoltsPerLightSpeedSquared:
      "megaelectronvoltsPerLightSpeedSquared"
    case _ where unit == \Speed.Type.metersPerSecond: "metersPerSecond"
    default: "Unknown instance of UnitRepresentable<\(MeasurementType.self)>"
    }
  }
}
