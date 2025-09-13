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

struct AnySingleColorLikeDiscretionTests {
  @Test(arguments: [
    AnySingleColorLike(red), .init(Anti(red)), .init(green), .init(Anti(green)), .init(blue),
    .init(Anti(blue))
  ])
  func allKnownSingleColorsAndTheirCounterpartsAreIncludedInDiscretion(
    _ singleColorLike: AnySingleColorLike
  ) {
    #expect(
      AnySingleColorLike.discretion.contains(where: { discreteSingleColorLike in
        discreteSingleColorLike == singleColorLike
      })
    )
  }
}

struct AnySingleColorDiscretionTests {
  @Test(arguments: [AnySingleColor(red), .init(green), .init(blue)])
  func allKnownSingleColorsAndTheirCounterpartsAreIncludedInDiscretion(
    _ singleColor: AnySingleColor
  ) {
    #expect(
      AnySingleColor.discretion.contains(where: { discreteSingleColor in
        discreteSingleColor == singleColor
      })
    )
  }
}

struct AnyQuarkLikeDiscretionTests {
  @Test(arguments: [
    AnyQuarkLike(UpQuark(colorLike: red)), .init(Anti(UpQuark(colorLike: red))),
    .init(UpQuark(colorLike: green)), .init(Anti(UpQuark(colorLike: green))),
    .init(UpQuark(colorLike: blue)), .init(Anti(UpQuark(colorLike: blue))),
    .init(DownQuark(colorLike: red)), .init(Anti(DownQuark(colorLike: red))),
    .init(DownQuark(colorLike: green)), .init(Anti(DownQuark(colorLike: green))),
    .init(DownQuark(colorLike: blue)), .init(Anti(DownQuark(colorLike: blue))),
    .init(CharmQuark(colorLike: red)), .init(Anti(CharmQuark(colorLike: red))),
    .init(CharmQuark(colorLike: green)), .init(Anti(CharmQuark(colorLike: green))),
    .init(CharmQuark(colorLike: blue)), .init(Anti(CharmQuark(colorLike: blue))),
    .init(StrangeQuark(colorLike: red)), .init(Anti(StrangeQuark(colorLike: red))),
    .init(StrangeQuark(colorLike: green)), .init(Anti(StrangeQuark(colorLike: green))),
    .init(StrangeQuark(colorLike: blue)), .init(Anti(StrangeQuark(colorLike: blue))),
    .init(BottomQuark(colorLike: red)), .init(Anti(BottomQuark(colorLike: red))),
    .init(BottomQuark(colorLike: green)), .init(Anti(BottomQuark(colorLike: green))),
    .init(BottomQuark(colorLike: blue)), .init(Anti(BottomQuark(colorLike: blue))),
    .init(TopQuark(colorLike: red)), .init(Anti(TopQuark(colorLike: red))),
    .init(TopQuark(colorLike: green)), .init(Anti(TopQuark(colorLike: green))),
    .init(TopQuark(colorLike: blue)), .init(Anti(TopQuark(colorLike: blue)))
  ])
  func allKnownQuarksAndTheirCounterpartsAreIncludedInDiscretion(_ quarkLike: AnyQuarkLike) {
    #expect(
      AnyQuarkLike.discretion.contains(where: { discreteQuarkLike in discreteQuarkLike == quarkLike
        })
    )
  }
}

struct AnyQuarkDiscretionTests {
  @Test(arguments: [
    AnyQuark(UpQuark(colorLike: red)), .init(UpQuark(colorLike: green)),
    .init(UpQuark(colorLike: blue)), .init(DownQuark(colorLike: red)),
    .init(DownQuark(colorLike: green)), .init(DownQuark(colorLike: blue)),
    .init(CharmQuark(colorLike: red)), .init(CharmQuark(colorLike: green)),
    .init(CharmQuark(colorLike: blue)), .init(StrangeQuark(colorLike: red)),
    .init(StrangeQuark(colorLike: green)), .init(StrangeQuark(colorLike: blue)),
    .init(BottomQuark(colorLike: red)), .init(BottomQuark(colorLike: green)),
    .init(BottomQuark(colorLike: blue)), .init(TopQuark(colorLike: red)),
    .init(TopQuark(colorLike: green)), .init(TopQuark(colorLike: blue))
  ])
  func allKnownQuarksAndTheirCounterpartsAreIncludedInDiscretion(_ quark: AnyQuark) {
    #expect(AnyQuark.discretion.contains(where: { discreteQuark in discreteQuark == quark }))
  }
}
