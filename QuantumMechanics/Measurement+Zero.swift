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

extension Measurement where UnitType == UnitAngle {
  /// An angle of 0º.
  public static let zero = Measurement(value: 0, unit: UnitType.baseUnit())
}

extension Measurement where UnitType == UnitElectricCharge {
  /// An electric charge of 0 C.
  public static let zero = Measurement(value: 0, unit: UnitType.baseUnit())
}

extension Measurement where UnitType == UnitEnergy {
  /// An energy of 0 J.
  public static let zero = Measurement(value: 0, unit: UnitType.baseUnit())
}

extension Measurement where UnitType == UnitMass {
  /// A mass of 0 kg.
  public static let zero = Measurement(value: 0, unit: UnitType.baseUnit())
}
