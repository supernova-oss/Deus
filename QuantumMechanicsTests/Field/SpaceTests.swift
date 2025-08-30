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

@testable import QuantumMechanics

struct SpaceTests {
  private let space = _1DSpace(mass: 2)

  @Test
  func calculatesLagrangian() {
    #expect(space.lagrangian(coordinate: 4, velocity: 8, time: 16) == 8.881784197001252e-16)
  }

  @Test
  func calculatesLorentzFactor() {
    #expect(
      space.lorentzFactor(velocity: 2).isApproximatelyEqual(
        to: (1 - 1 / (50 * UnitSpeed.light.converter.baseUnitValue(fromValue: 1))).squareRoot()
      )
    )
  }
}
