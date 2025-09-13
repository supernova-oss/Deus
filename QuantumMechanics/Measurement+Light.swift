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

/// The speed of light.
///
/// - SeeAlso: ``cSquared``
@available(*, deprecated, message: "The speed of light c is now a unit (UnitSpeed.light).")
public let c = Measurement(value: 1, unit: UnitSpeed.light)

/// The speed of light, squared.
///
/// - SeeAlso: ``c``
@available(
  *,
  deprecated,
  message: "The square of the speed of light is now a unit (UnitSpeed.lightSquared)."
)
public let cSquared = Measurement(value: 1, unit: UnitSpeed.lightSquared)

extension UnitSpeed {
  /// The speed of light *c* in m/s.
  private static let coefficient = 299_792_458.0

  /// The speed of light *c*.
  ///
  /// - SeeAlso: ``lightSquared``
  public static let light = UnitSpeed(
    symbol: "c",
    converter: UnitConverterLinear(coefficient: coefficient)
  )

  /// The speed of light *c*, squared: *c*².
  ///
  /// - SeeAlso: ``light``
  public static let lightSquared = UnitSpeed(
    symbol: "c²",
    converter: UnitConverterLinear(coefficient: pow(coefficient, 2))
  )
}
