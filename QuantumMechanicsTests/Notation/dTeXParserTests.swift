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

struct dTeXParserTests {
  @Test
  func constantIdentifierInitializationFailsUponUnexpectedTokens() async {
    await #expect(processExitsWith: .failure) {
      let _ = _dTeXConstantIdentifier<String>.init(
        detachedSyntax: [.init(_dTeXWhitespaceToken(" "))],
        attachedSyntax: []
      )
    }
  }

  @Test(
    arguments: zip(
      _dTeXConstantIdentifier<String>.discretion,
      [_dTeXConstantIdentifier<String>.hbar("hbar"), .pi("pi")]
    )
  )
  func parses(
    constantIdentification: _dTeXSyntax<String>,
    into expression: _dTeXConstantIdentifier<String>
  ) { #expect(_dTeXConstantIdentifier<String>.find(in: constantIdentification) == [expression]) }
}
