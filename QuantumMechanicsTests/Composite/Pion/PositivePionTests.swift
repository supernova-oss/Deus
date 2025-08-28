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

struct PositivePionTests {
  private let upQuark = UpQuark(colorLike: red)
  private let downAntiquark = Anti(DownQuark(colorLike: red))
  private lazy var positivePion = upQuark + downAntiquark

  @Test("u + d̄ → π⁺")
  mutating func resultsFromCombiningAnUpQuarkAndADownAntiquark() {
    #expect(positivePion.quarks.elementsEqual([.init(upQuark), .init(downAntiquark)]))
  }

  @Test
  mutating func chargeIsOneE() {
    #expect(positivePion.charge == Measurement(value: 1, unit: .elementary))
  }

  @Test
  mutating func massIsOneHundredAndThirtyNinePointFiftySevenThousandAndThirtyNineGeV() {
    #expect(
      positivePion.getMass(approximatedBy: .base)
        == Measurement(value: 139.57039, unit: .gigaelectronvolt)
    )
  }
}
