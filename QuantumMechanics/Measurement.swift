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

  /// Ratio of the length of an arc to its radius. 1 rad = (π / 180)º.
  public static let radians = Measurable<Self>(
    conversionCoefficient: 1,
    symbol: Self.baseUnitSymbol
  )

  public static let baseUnitSymbol = "rad"

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }

  public static func _make(
    quantityInCurrentUnit: Double,
    conversionCoefficient: Double,
    symbol: String
  ) -> Angle {
    .init(
      quantityInCurrentUnit: quantityInCurrentUnit,
      conversionCoefficient: conversionCoefficient,
      symbol: symbol
    )
  }
}

/// Classically, electric charge can be explained as the Lorentz force experienced on a particle in
/// the electromagnetic field. Fundamentally, it is the quantity which is conserved upon global
/// phase rotations (U(1)) of fields.
public struct ElectricCharge: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  /// Quantity of ``ElectricCharge`` transported in a current of 1 ampère in 1 second.
  public static let coulombs = Measurable<Self>(
    conversionCoefficient: 1,
    symbol: Self.baseUnitSymbol
  )

  /// Quantity of charge in elementary charge (*e*). *e* is a fundamental constant as per the SI,
  /// equivalent to 1.602176634𝑒⁻¹⁹ coulombs and equating to the least amount of electric charge
  /// which can exist unconfined in the Universe.
  public static let elementary = Measurable<Self>(
    conversionCoefficient: 1.602_176_634e-19,
    symbol: "e"
  )

  public static let baseUnitSymbol = "C"

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }

  public static func _make(
    quantityInCurrentUnit: Double,
    conversionCoefficient: Double,
    symbol: String
  ) -> ElectricCharge {
    .init(
      quantityInCurrentUnit: quantityInCurrentUnit,
      conversionCoefficient: conversionCoefficient,
      symbol: symbol
    )
  }
}

/// Conserved property transferred into a body or system, by which an amount of work performed is
/// quantified. Results in an increase or decrease of heat; light; or both in the physical system
/// upon performance of such work.
public struct Energy: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  /// Amount of work produced by a force of 1 newton onto an object until it is moved by 1 meter in
  /// the direction of such force.
  public static let joules = Measurable<Self>(conversionCoefficient: 1, symbol: Self.baseUnitSymbol)

  /// Amount of work for accelerating an electron through an electric potential difference of 1 volt
  /// in vacuum. Its value in ``joules`` is the same as that of the constant *e* (standing for the
  /// elementary charge): equals to 1.602176634𝑒⁻¹⁹ ``joules``.
  ///
  /// - SeeAlso: ``ElectricCharge/elementary``
  public static let electronvolts = Measurable<Self>(
    conversionCoefficient: 1.602_176_634e-19,
    symbol: "eV"
  )

  public static let baseUnitSymbol = "J"

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }

  public static func _make(
    quantityInCurrentUnit: Double,
    conversionCoefficient: Double,
    symbol: String
  ) -> Energy {
    .init(
      quantityInCurrentUnit: quantityInCurrentUnit,
      conversionCoefficient: conversionCoefficient,
      symbol: symbol
    )
  }
}

/// Accumulation of matter in an object, indicative of its resistance to motion.
public struct Mass: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  public static let kilograms = Measurable<Self>(
    conversionCoefficient: 1,
    symbol: Self.baseUnitSymbol
  )

  /// One-millionth of an eV/c².
  ///
  /// - SeeAlso: ``electronvoltsPerLightSpeedSquared``
  public static let gigaelectronvoltsPerLightSpeedSquared = Measurable<Self>(
    conversionCoefficient: 1.78_266_192e-27,
    symbol: "GeV/c²"
  )

  /// One-hundredth of an eV/c².
  ///
  /// - SeeAlso: ``electronvoltsPerLightSpeedSquared``
  public static let megaelectronvoltsPerLightSpeedSquared = Measurable<Self>(
    conversionCoefficient: 1.78_266_192e-30,
    symbol: "MeV/c²"
  )

  /// Amount of ``Energy/electronvolts`` per the square of the speed of light.
  public static let electronvoltsPerLightSpeedSquared = Measurable<Self>(
    conversionCoefficient: 1.78_266_192e-36,
    symbol: "eV/c²"
  )

  public static let baseUnitSymbol = "kg"

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }

  public static func _make(
    quantityInCurrentUnit: Double,
    conversionCoefficient: Double,
    symbol: String
  ) -> Mass {
    .init(
      quantityInCurrentUnit: quantityInCurrentUnit,
      conversionCoefficient: conversionCoefficient,
      symbol: symbol
    )
  }
}

/// Length–time rate of change in motion of matter or light.
public struct Speed: Measurement {
  public let quantityInCurrentUnit: Double
  public let conversionCoefficient: Double
  public let symbol: String

  /// ``Speed`` expressed by the constant *c*, which is that of the of light in vacuum.
  public static let light = Measurable<Self>(conversionCoefficient: 299_792_458, symbol: "c")

  /// Amount of meters traversed by matter or light at each second.
  public static let metersPerSecond = Measurable<Self>(
    conversionCoefficient: 1,
    symbol: Self.baseUnitSymbol
  )

  public static let baseUnitSymbol = "m/s"

  private init(quantityInCurrentUnit: Double, conversionCoefficient: Double, symbol: String) {
    self.quantityInCurrentUnit = quantityInCurrentUnit
    self.conversionCoefficient = conversionCoefficient
    self.symbol = symbol
  }

  public static func _make(
    quantityInCurrentUnit: Double,
    conversionCoefficient: Double,
    symbol: String
  ) -> Speed {
    .init(
      quantityInCurrentUnit: quantityInCurrentUnit,
      conversionCoefficient: conversionCoefficient,
      symbol: symbol
    )
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
public protocol Measurement: Comparable, CustomStringConvertible, SignedNumeric, UnitConvertible {
  /// Divisor by which the quantity in the current unit is divided, resulting in the quantity in the
  /// base unit. Conversely, it is the factor by which the quantity in the base unit is multiplied,
  /// equating to the quantity in the current unit.
  ///
  /// Formally, given this value as *x*,
  ///
  /// - ``quantityInBaseUnit`` = ``quantityInCurrentUnit`` × *x*; and
  /// - ``quantityInCurrentUnit`` = ``quantityInBaseUnit`` / *x*.
  var conversionCoefficient: Double { get }

  /// Quantity in the current unit.
  var quantityInCurrentUnit: Double { get }

  /// ``UnitConvertible/symbol`` of the base unit of this ``Measurement``.
  static var baseUnitSymbol: String { get }

  /// Produces a ``Measurement`` of this type from a quantity in the current unit.
  ///
  /// - Parameters:
  ///   - quantityInCurrentUnit: Quantity in the current unit.
  ///   - conversionCoefficient: Divisor by which the quantity in the current unit is divided,
  ///     resulting in the quantity in the base unit. Conversely, it is the factor by which the
  ///     quantity in the base unit is multiplied, equating to the quantity in the current unit.
  ///
  ///     Formally, given this value as *x*,
  ///
  ///     - ``quantityInBaseUnit`` = ``quantityInCurrentUnit`` × *x*; and
  ///     - ``quantityInCurrentUnit`` = ``quantityInBaseUnit`` / *x*.
  ///   - symbol: Abbreviated textual representation of the unit as per the SI.
  static func _make(
    quantityInCurrentUnit: Double,
    conversionCoefficient: Double,
    symbol: String
  ) -> Self
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
    ._make(
      quantityInCurrentUnit: -operand.quantityInCurrentUnit,
      conversionCoefficient: operand.conversionCoefficient,
      symbol: operand.symbol
    )
  }

  /// Converts this ``Measurement`` into one in another unit.
  ///
  /// - Parameter unit: Unit into which this ``Measurement`` will be converted.
  public func converted(into unit: Unit) -> Self {
    let targetMeasurable = Self.in(unit)
    let targetConversionCoefficient = targetMeasurable.conversionCoefficient
    return ._make(
      quantityInCurrentUnit: quantityInBaseUnit / targetConversionCoefficient,
      conversionCoefficient: targetConversionCoefficient,
      symbol: targetMeasurable.symbol
    )
  }

  /// Obtains the ``Measurable`` by which a quantity in the given `unit` can be measured.
  ///
  /// - Parameter unit: ``Unit`` of the ``Measurement`` resulted from the returned ``Measurable``.
  static func `in`(_ unit: Unit) -> Measurable<Self> { Self.self[keyPath: unit] }

  /// Formats one of the quantities of this type of ``Measurement``.
  ///
  /// - Parameter quantity: The quantity (e.g., ``quantityInCurrentUnit`` or ``quantityInBaseUnit``)
  ///   to be formatted.
  static func formatted(quantity: Double) -> String {
    FloatingPointFormatStyle<Double>(locale: .autoupdatingCurrent).grouping(.automatic).precision(
      .fractionLength(0...2)
    ).format(quantity)
  }
}

extension Measurement where Self: AdditiveArithmetic {
  public static func + (lhs: Self, rhs: Self) -> Self {
    ._make(
      quantityInCurrentUnit: (lhs.quantityInBaseUnit + rhs.quantityInBaseUnit)
        / lhs.conversionCoefficient,
      conversionCoefficient: lhs.conversionCoefficient,
      symbol: lhs.symbol
    )
  }

  public static func - (lhs: Self, rhs: Self) -> Self {
    ._make(
      quantityInCurrentUnit: (lhs.quantityInBaseUnit - rhs.quantityInBaseUnit)
        / lhs.conversionCoefficient,
      conversionCoefficient: lhs.conversionCoefficient,
      symbol: lhs.symbol
    )
  }
}

extension Measurement where Self: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.quantityInBaseUnit < rhs.quantityInBaseUnit
  }
}

extension Measurement where Self: CustomStringConvertible {
  /// Describes the unitized value of this ``Measurement`` (e.g., "2 cm").
  public var description: String { "\(Self.formatted(quantity: quantityInCurrentUnit)) \(symbol)" }
}

extension Measurement where Self: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.quantityInBaseUnit == rhs.quantityInBaseUnit
  }
}

extension Measurement where Self: ExpressibleByIntegerLiteral {
  /// Initializes this type of ``Measurement`` from a quantity in its base unit.
  ///
  /// ## Contract
  ///
  /// By definition, every ``Measurement`` initialized by this initializer satisfies the following
  /// criteria:
  ///
  /// 1. ``quantityInCurrentUnit`` = ``quantityInBaseUnit``;
  /// 2. ``UnitConvertible/conversionCoefficient`` = `1`; and
  /// 3. ``UnitConvertible/symbol`` = ``baseUnitSymbol``.
  ///
  /// - Parameter value: Quantity in the base unit.
  public init(integerLiteral value: Double) {
    self = ._make(
      quantityInCurrentUnit: value,
      conversionCoefficient: 1,
      symbol: Self.baseUnitSymbol
    )
  }
}

extension Measurement where Self: Numeric {
  public var magnitude: Double { abs(quantityInBaseUnit) }

  public init?<T>(exactly source: T) where T: BinaryInteger {
    self = .init(integerLiteral: .init(source))
  }

  public static func * (lhs: Self, rhs: Self) -> Self {
    ._make(
      quantityInCurrentUnit: (lhs.quantityInBaseUnit * rhs.quantityInBaseUnit)
        / lhs.conversionCoefficient,
      conversionCoefficient: lhs.conversionCoefficient,
      symbol: lhs.symbol
    )
  }

  public static func *= (lhs: inout Self, rhs: Self) { lhs = lhs * rhs }
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
    ._make(
      quantityInCurrentUnit: quantityInCurrentUnit,
      conversionCoefficient: conversionCoefficient,
      symbol: symbol
    )
  }
}

/// Specifier of a coefficient for converting a value in the base unit into another in the current
/// one.
public protocol UnitConvertible: Hashable, Sendable {
  /// Divisor by which the quantity in the current unit is divided, resulting in the quantity in the
  /// base unit. Conversely, it is the factor by which the quantity in the base unit is multiplied,
  /// equating to the quantity in the current unit.
  ///
  /// Formally, given a quantity *a* in the base unit, a quantity *b* in the current unit and this
  /// coefficient *x*, *a* = *b* / *x*; *b* = *a* × *x*; *x* = *a* / *b*.
  var conversionCoefficient: Double { get }

  /// Abbreviated textual representation of the unit as per the SI.
  var symbol: String { get }
}
