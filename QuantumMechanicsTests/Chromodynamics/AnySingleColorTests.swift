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

import Testing

@testable import QuantumMechanics

struct AnySingleColorTests {
  @Suite("Equality")
  struct EqualityTests {
    @Suite("Red")
    struct RedTests {
      @Test
      func isRed() { #expect(AnySingleColor(red).is(Red.self)) }

      @Test
      func isNotAntired() { #expect(!AnySingleColor(red).is(Anti<Red>.self)) }

      @Test
      func isNotGreen() { #expect(!AnySingleColor(red).is(Green.self)) }

      @Test
      func isNotAntigreen() { #expect(!AnySingleColor(red).is(Anti<Green>.self)) }

      @Test
      func isNotBlue() { #expect(!AnySingleColor(red).is(Blue.self)) }

      @Test
      func isNotAntiblue() { #expect(!AnySingleColor(red).is(Anti<Blue>.self)) }
    }

    @Suite("Green")
    struct GreenTests {
      @Test
      func isGreen() { #expect(AnySingleColor(green).is(Green.self)) }

      @Test
      func isNotAntigreen() { #expect(!AnySingleColor(green).is(Anti<Green>.self)) }

      @Test
      func isNotAntired() { #expect(!AnySingleColor(green).is(Anti<Red>.self)) }

      @Test
      func isNotRed() { #expect(!AnySingleColor(green).is(Red.self)) }

      @Test
      func isNotBlue() { #expect(!AnySingleColor(green).is(Blue.self)) }

      @Test
      func isNotAntiblue() { #expect(!AnySingleColor(green).is(Anti<Blue>.self)) }
    }

    @Suite("Blue")
    struct BlueTests {
      @Test
      func blueIsBlue() { #expect(AnySingleColor(blue).is(Blue.self)) }

      @Test
      func isNotAntiblue() { #expect(!AnySingleColor(blue).is(Anti<Blue>.self)) }

      @Test
      func isNotAntired() { #expect(!AnySingleColor(blue).is(Anti<Red>.self)) }

      @Test
      func isNotRed() { #expect(!AnySingleColor(blue).is(Red.self)) }

      @Test
      func isNotGreen() { #expect(!AnySingleColor(blue).is(Green.self)) }

      @Test
      func isNotAntigreen() { #expect(!AnySingleColor(blue).is(Anti<Green>.self)) }
    }
  }
}
