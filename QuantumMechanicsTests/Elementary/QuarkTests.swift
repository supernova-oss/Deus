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

struct UpQuarkTests {
  @Test(arguments: AnySingleColor.discretion.map({ color in UpQuark(colorLike: color) }))
  func baseMassIsTwoPointThreeMev(_ quark: UpQuark<AnySingleColor>) {
    #expect(quark.getMass(approximatedBy: .base) == .megaelectronvoltsPerLightSpeedSquared(2.3))
  }

  @Test(arguments: AnySingleColor.discretion.map({ color in UpQuark(colorLike: color) }))
  func symbolIsU(_ quark: UpQuark<AnySingleColor>) { #expect(quark.symbol == "u") }
}

struct DownQuarkTests {
  @Test(arguments: AnySingleColor.discretion.map({ color in DownQuark(colorLike: color) }))
  func baseMassIsFourPointEightMev(_ quark: DownQuark<AnySingleColor>) {
    #expect(quark.getMass(approximatedBy: .base) == .megaelectronvoltsPerLightSpeedSquared(4.8))
  }

  @Test(arguments: AnySingleColor.discretion.map({ color in DownQuark(colorLike: color) }))
  func symbolIsD(_ quark: DownQuark<AnySingleColor>) { #expect(quark.symbol == "d") }
}

struct StrangeQuarkTests {
  @Test(arguments: AnySingleColor.discretion.map({ color in StrangeQuark(colorLike: color) }))
  func baseMassIsNinetyFivePointZeroMev(_ quark: StrangeQuark<AnySingleColor>) {
    #expect(quark.getMass(approximatedBy: .base) == .megaelectronvoltsPerLightSpeedSquared(95.0))
  }

  @Test(arguments: AnySingleColor.discretion.map({ color in StrangeQuark(colorLike: color) }))
  func symbolIsS(_ quark: StrangeQuark<AnySingleColor>) { #expect(quark.symbol == "s") }
}

struct CharmQuarkTests {
  @Test(arguments: AnySingleColor.discretion.map({ color in CharmQuark(colorLike: color) }))
  func baseMassIsOnePointTwoSevenFiveGev(_ quark: CharmQuark<AnySingleColor>) {
    #expect(quark.getMass(approximatedBy: .base) == .gigaelectronvoltsPerLightSpeedSquared(1.275))
  }

  @Test(arguments: AnySingleColor.discretion.map({ color in CharmQuark(colorLike: color) }))
  func symbolIsC(_ quark: CharmQuark<AnySingleColor>) { #expect(quark.symbol == "c") }
}

struct BottomQuarkTests {
  @Test(arguments: AnySingleColor.discretion.map({ color in BottomQuark(colorLike: color) }))
  func baseMassIsFourPointOneEightGev(_ quark: BottomQuark<AnySingleColor>) {
    #expect(quark.getMass(approximatedBy: .base) == .gigaelectronvoltsPerLightSpeedSquared(4.18))
  }

  @Test(arguments: AnySingleColor.discretion.map({ color in BottomQuark(colorLike: color) }))
  func symbolIsB(_ quark: BottomQuark<AnySingleColor>) { #expect(quark.symbol == "b") }
}

struct TopQuarkTests {
  @Test(arguments: AnySingleColor.discretion.map({ color in TopQuark(colorLike: color) }))
  func baseMassIsOneHundredAndSeventyThreePointTwoOneGev(_ quark: TopQuark<AnySingleColor>) {
    #expect(quark.getMass(approximatedBy: .base) == .gigaelectronvoltsPerLightSpeedSquared(173.21))
  }

  @Test(arguments: AnySingleColor.discretion.map({ color in TopQuark(colorLike: color) }))
  func symbolIsT(_ quark: TopQuark<AnySingleColor>) { #expect(quark.symbol == "t") }
}
