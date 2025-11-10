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

struct AnySingleColorLikeTests {
  @Test(arguments: AnySingleColorLike.discretion)
  func isBaseColorLike(_ colorLike: AnySingleColorLike) {
    if colorLike.base is Red {
      #expect(colorLike.is(Red.self))
    } else if colorLike.base is Anti<Red> {
      #expect(colorLike.is(Anti<Red>.self))
    } else if colorLike.base is Green {
      #expect(colorLike.is(Green.self))
    } else if colorLike.base is Anti<Green> {
      #expect(colorLike.is(Anti<Green>.self))
    } else if colorLike.base is Blue {
      #expect(colorLike.is(Blue.self))
    } else if colorLike.base is Anti<Blue> {
      #expect(colorLike.is(Anti<Blue>.self))
    }
  }

  @Suite("Equality")
  struct EqualityTests {
    @Suite("Antired")
    struct AntiredTests {
      @Test
      func isAntired() { #expect(AnySingleColorLike(Anti(red)).is(Anti<Red>.self)) }

      @Test
      func isNotRed() { #expect(!AnySingleColorLike(Anti(red)).is(Red.self)) }

      @Test
      func isNotGreen() { #expect(!AnySingleColorLike(Anti(red)).is(Green.self)) }

      @Test
      func isNotAntigreen() { #expect(!AnySingleColorLike(Anti(red)).is(Anti<Green>.self)) }

      @Test
      func isNotBlue() { #expect(!AnySingleColorLike(Anti(red)).is(Blue.self)) }

      @Test
      func isNotAntiblue() { #expect(!AnySingleColorLike(Anti(red)).is(Anti<Blue>.self)) }
    }

    @Suite("Antigreen")
    struct AntigreenTests {
      @Test
      func isAntigreen() { #expect(AnySingleColorLike(Anti(green)).is(Anti<Green>.self)) }

      @Test
      func isNotGreen() { #expect(!AnySingleColorLike(Anti(green)).is(Green.self)) }

      @Test
      func isNotAntired() { #expect(!AnySingleColorLike(Anti(green)).is(Anti<Red>.self)) }

      @Test
      func isNotRed() { #expect(!AnySingleColorLike(Anti(green)).is(Red.self)) }

      @Test
      func isNotBlue() { #expect(!AnySingleColorLike(Anti(green)).is(Blue.self)) }

      @Test
      func isNotAntiblue() { #expect(!AnySingleColorLike(Anti(green)).is(Anti<Blue>.self)) }
    }

    @Suite("Antiblue")
    struct AntiblueTests {
      @Test
      func isAntiblue() { #expect(AnySingleColorLike(Anti(blue)).is(Anti<Blue>.self)) }

      @Test
      func isNotBlue() { #expect(!AnySingleColorLike(Anti(blue)).is(Blue.self)) }

      @Test
      func isNotAntired() { #expect(!AnySingleColorLike(Anti(blue)).is(Anti<Red>.self)) }

      @Test
      func isNotRed() { #expect(!AnySingleColorLike(Anti(blue)).is(Red.self)) }

      @Test
      func isNotAntigreen() { #expect(!AnySingleColorLike(Anti(blue)).is(Anti<Green>.self)) }

      @Test
      func isNotGreen() { #expect(!AnySingleColorLike(Anti(blue)).is(Green.self)) }
    }
  }
}
