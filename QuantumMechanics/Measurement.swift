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

/// Curvature of an arc between two vectors sharing an origin or an endpoint.
public struct Angle: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  public static let baseUnitSymbol = "rad"

  /// Ratio of the length of an arc to its radius. 1 rad = (π / 180)º.
  static let radians = Measurable<Self>(conversionCoefficient: 1, symbol: Self.baseUnitSymbol)

  public init(quantityInBaseUnit: Double) {
    self = .init(
      quantityInCurrentUnit: quantityInBaseUnit,
      conversionCoefficient: 1,
      symbol: Self.baseUnitSymbol
    )
  }

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }
}

/// Classically, electric charge can be explained as the Lorentz force experienced on a particle in
/// the electromagnetic field. Fundamentally, it is the quantity which is conserved upon global
/// phase rotations (U(1)) of fields.
public struct ElectricCharge: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  public static let baseUnitSymbol = "e"

  /// Quantity of charge in elementary charge (*e*). *e* is a fundamental constant as per the SI,
  /// equivalent to 1.602176634𝑒⁻¹⁹ coulombs and equating to the least amount of electric charge
  /// which can exist unconfined in the Universe.
  public static let elementary = Measurable<Self>(
    conversionCoefficient: 1,
    symbol: Self.baseUnitSymbol
  )

  public init(quantityInBaseUnit: Double) {
    self = .init(
      quantityInCurrentUnit: quantityInBaseUnit,
      conversionCoefficient: 1,
      symbol: Self.baseUnitSymbol
    )
  }

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }
}

/// Accumulation of matter in an object, indicative of its resistance to motion.
public struct Mass: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  public static let baseUnitSymbol = "eV/c²"

  /// One-millionth of an eV/c².
  ///
  /// - SeeAlso: ``electronvoltsPerLightSpeedSquared``
  public static let gigaelectronvoltsPerLightSpeedSquared = Measurable<Self>(
    conversionCoefficient: 1e6,
    symbol: "GeV/c²"
  )

  /// One-hundredth of an eV/c².
  ///
  /// - SeeAlso: ``electronvoltsPerLightSpeedSquared``
  public static let megaelectronvoltsPerLightSpeedSquared = Measurable<Self>(
    conversionCoefficient: 1e12,
    symbol: "MeV/c²"
  )

  /// Amount of work for accelerating an electron through an electric potential difference of 1 volt
  /// in vacuum per the square of the speed of light. Its value in joules is the same as that of the
  /// constant *e* (standing for the elementary charge): equals to 1.602176634𝑒⁻¹⁹ joules.
  ///
  /// - SeeAlso: ``ElectricCharge/elementary``
  public static let electronvoltsPerLightSpeedSquared = Measurable<Self>(
    conversionCoefficient: 1,
    symbol: Self.baseUnitSymbol
  )

  public init(quantityInBaseUnit: Double) {
    self = .init(
      quantityInCurrentUnit: quantityInBaseUnit,
      conversionCoefficient: 1,
      symbol: Self.baseUnitSymbol
    )
  }

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }
}

/// Length–time rate of change in motion of matter or light.
public struct Speed: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  public static let baseUnitSymbol = "m/s"

  /// Amount of meters traversed by matter or light at each second.
  public static let metersPerSecond = Measurable<Self>(
    conversionCoefficient: 1,
    symbol: Self.baseUnitSymbol
  )

  public init(quantityInBaseUnit: Double) {
    self = .init(
      quantityInCurrentUnit: quantityInBaseUnit,
      conversionCoefficient: 1,
      symbol: Self.baseUnitSymbol
    )
  }

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }
}

/// Quantity attached to a unit.
///
/// A measurement is any given numeric value which is contextualized by a unit, with such unit
/// normally being one of the defined by the
/// [International System of Units](https://www.bipm.org/en/measurement-units) (SI). Because a
/// measurement may be expressed in various units, the base unit is chosen as that in which the
/// quantity is represented by the object internally, from which conversions of the measurement from
/// one unit into another may be performed.
public protocol Measurement: AdditiveArithmetic, Comparable, CustomStringConvertible,
  UnitConvertible
{
  /// Factor by which the value in the base unit is multiplied, resulting in the value in the
  /// current unit.
  ///
  /// Formally, given this value as *x*,
  ///
  /// - ``quantityInCurrentUnit`` = ``quantityInBaseUnit`` / *x*; and
  /// - ``quantityInBaseUnit`` = ``quantityInCurrentUnit`` × *x*.
  var conversionCoefficient: Double { get }

  /// Quantity in the current unit.
  var quantityInCurrentUnit: Double { get }

  /// ``UnitConvertible/symbol`` of the base unit of this ``Measurement``.
  static var baseUnitSymbol: String { get }

  /// Initializes this type of ``Measurement`` from a quantity in its base unit.
  ///
  /// ## Contract
  ///
  /// Because implementing this initializer is a requirement of the protocol, as of Swift 6.2.1, the
  /// compiler cannot enforce consistency. Therefore, by definition every ``Measurement``
  /// initialized by this initializer is expected to have its
  ///
  /// 1. ``quantityInCurrentUnit`` = ``quantityInBaseUnit``;
  /// 2. ``UnitConvertible/conversionCoefficient`` = `1`; and
  /// 3. `symbol` = ``baseUnitSymbol``.
  ///
  /// - Parameter quantityInBaseUnit: Quantity in the base unit.
  init(quantityInBaseUnit: Double)
}

extension Measurement {
  /// Reference to the factory of this type of ``Measurement`` in a given unit.
  public typealias Unit = KeyPath<Self.Type, Measurable<Self>>

  /// Quantity in the base unit.
  public var quantityInBaseUnit: Double { quantityInCurrentUnit * conversionCoefficient }

  /// Produces another ``Measurement``, with the sign of its quantities negated.
  ///
  /// - Parameter operand: The ``Measurement`` to be negated.
  public static prefix func - (operand: Self) -> Self {
    return .init(quantityInBaseUnit: -operand.quantityInBaseUnit)
  }

  /// Converts this ``Measurement`` into one in another unit.
  ///
  /// - Parameter unit: Unit into which this ``Measurement`` will be converted.
  public func converted(into unit: Unit) -> Self {
    .init(quantityInBaseUnit: quantityInBaseUnit * Self.self[keyPath: unit].conversionCoefficient)
  }

  /// Formats one of the quantities of this type of ``Measurement``.
  ///
  /// - Parameter quantity: The quantity (e.g., ``quantityInCurrentUnit`` or ``quantityInBaseUnit``)
  ///   to be formatted.
  static func formatted(quantity: Double) -> String {
    FloatingPointFormatStyle<Double>(locale: .autoupdatingCurrent).precision(.fractionLength(0...2))
      .grouping(.automatic).format(quantity)
  }

  /// Obtains the factory which initializes this type of ``Measurement`` in the given unit.
  ///
  /// - Parameter unitRepresentable: Representation of the unit.
  static func `in`(_ unit: Unit) -> Measurable<Self> { Self.self[keyPath: unit] }
}

extension Measurement where Self: AdditiveArithmetic {
  public static var zero: Self { .init(quantityInBaseUnit: 0) }

  public static func - (lhs: Self, rhs: Self) -> Self {
    return .init(quantityInBaseUnit: lhs.quantityInBaseUnit - rhs.quantityInBaseUnit)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    return .init(quantityInBaseUnit: lhs.quantityInBaseUnit + rhs.quantityInBaseUnit)
  }
}

extension Measurement where Self: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.quantityInBaseUnit == rhs.quantityInBaseUnit
  }
}

extension Measurement where Self: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.quantityInBaseUnit < rhs.quantityInBaseUnit
  }
}

extension Measurement where Self: CustomStringConvertible {
  /// Describes the unitized value of this ``Measurement`` (e.g., "2 cm").
  public var description: String {
    return "\(Self.formatted(quantity: quantityInCurrentUnit)) \(symbol)"
  }
}

/// Initial representation of a measurement, by which the only information provided is the
/// coefficient for converting one ``Measurement`` of the specified type into one of the same type
/// in another unit. Allows for initializing a ``Measurement`` of such type directly by being called
/// as a function with the quantity in the current unit; and, therefore, defining static units.
public struct Measurable<MeasurementType: Measurement>: UnitConvertible {
  public let conversionCoefficient: Double
  public let symbol: String

  fileprivate init(conversionCoefficient: Double, symbol: String) {
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }

  /// Initializes a ``Measurement`` of the specified type.
  ///
  /// - Parameter quantityInCurrentUnit: Quantity in the current unit.
  public func callAsFunction(_ quantityInCurrentUnit: Double) -> MeasurementType {
    .init(quantityInBaseUnit: quantityInCurrentUnit * conversionCoefficient)
  }
}

/// Specifier of a coefficient for converting a value in the base unit into another in the current
/// one.
public protocol UnitConvertible: Hashable, Sendable {
  /// Factor by which the value in the base unit is multiplied, resulting in the value in the
  /// current unit.
  var conversionCoefficient: Double { get }

  /// Abbreviated textual representation of the unit as per the SI.
  var symbol: String { get }
}
