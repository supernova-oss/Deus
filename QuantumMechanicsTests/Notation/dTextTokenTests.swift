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

struct dTeXTokenTests {
  private static let tokens = Tokenization.allCases.flatMap { tokenization in
    tokenization.tokenizerType.tokenize(tokenization.source).map(_AnyDTeXToken.init)
  }

  @Test(arguments: tokens)
  func tokenIsOfItsOwnType(_ token: _AnyDTeXToken<String>) {
    guard let erasedType = token.erasedType else {
      fatalError("\(token) was not initialized from a typed token.")
    }
    #expect(token.is(erasedType))
  }

  @Test(arguments: tokens)
  func typeErasedTokenIsOfTypeAnyDTeXToken(_ token: _AnyDTeXToken<String>) {
    #expect(token.is(_AnyDTeXToken<String>.self))
  }

  @Test(
    // This seems more complicated than it is; the extension for initializing an array as
    // `init(count:_:)` to which a closure is passed as the last argument for producing each element
    // based on its index is declared elsewhere. Here, each token is merely associated to a type
    // which is not its own.
    arguments: tokens.flatMap { token in
      var types = tokens.compactMap(\.erasedType)
      let count = types.count - 1
      return [(_AnyDTeXToken<String>, any _dTeXToken<String>.Type)](
        unsafeUninitializedCapacity: count,
        initializingWith: { pointer, initializedCount in
          guard var currentAddress = pointer.baseAddress else { return }
          for type in types {
            guard type != token.erasedType else { continue }
            currentAddress.initialize(to: (token, type))
            currentAddress = currentAddress.successor()
          }
          initializedCount = count
        }
      )
    }
  )
  func token(_ token: _AnyDTeXToken<String>, isNot type: any _dTeXToken<String>.Type) {
    #expect(!token.is(type))
  }
}
