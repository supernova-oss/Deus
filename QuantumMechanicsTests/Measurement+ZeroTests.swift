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
import Testing

@Suite("Measurement+Zero tests")
struct MeasurementZeroTests {
  @Test
  func valueOfZeroUnitAngleIsZero() { #expect(Measurement<UnitAngle>.zero.value == 0) }

  @Test
  func valueOfZeroUnitElectricChargeIsZero() {
    #expect(Measurement<UnitElectricCharge>.zero.value == 0)
  }

  @Test
  func valueOfZeroUnitEnergyIsZero() { #expect(Measurement<UnitEnergy>.zero.value == 0) }

  @Test
  func valueOfZeroUnitMassIsZero() { #expect(Measurement<UnitMass>.zero.value == 0) }
}
