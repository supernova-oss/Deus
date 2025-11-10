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

struct dTeXLexemeMatcherTests {
  @Test
  func errorsWhenInitializingWithAThisSubmatcherBeingTheFirstOne() async {
    await #expect(processExitsWith: .failure) {
      let _: _dTeXLexemeMatcher<String> = [.recursion, .anyOf(_dTeXIdentifierToken<String>.self)]
    }
  }

  @Test
  func errorsWhenInitializingWithAThisSubmatcherBeingTheLastOne() async {
    await #expect(processExitsWith: .failure) {
      let _: _dTeXLexemeMatcher<String> = [.anyOf(_dTeXIdentifierToken<String>.self), .recursion]
    }
  }

  @Suite("Token type")
  struct TokenType {
    @Test
    func doesNotMatchTokenOfTypeDifferentThatThatWhichWasSpecified()
      throws(_dTeXUnexpectedTokenError<String>)
    {
      let expectedSubmatcher = _dTeXLexemeSubmatcher<String>.anyOf(
        _dTeXIdentifierToken<String>.self
      )
      let matcher: _dTeXLexemeMatcher<String> = [expectedSubmatcher]
      let whitespaceToken = _AnyDTeXToken(_dTeXWhitespaceToken<String>(" "))
      let lexeme: _dTeXUnparsedExpression<String>.SubSequence = [whitespaceToken]
      #expect(
        throws: _dTeXUnexpectedTokenError<String>(
          lexeme: .init(lexeme),
          unexpectedToken: whitespaceToken,
          expectedSubmatcher: expectedSubmatcher
        )
      ) {
        try matcher._match(
          against: lexeme,
          inUnparsedExpressionOfType: _dTeXUnparsedExpression<String>.self
        )
      }
    }

    @Test
    func matchesTokenOfSameTypeWhichWasSpecified() throws(_dTeXUnexpectedTokenError<String>) {
      let matcher: _dTeXLexemeMatcher<String> = [.anyOf(_dTeXIdentifierToken<String>.self)]
      try matcher._match(
        against: [.init(_dTeXIdentifierToken("hbar"))],
        inUnparsedExpressionOfType: _dTeXUnparsedExpression<String>.self
      )
    }
  }

  @Suite("Recursion")
  struct RecursionTests {
    @Test
    func doesNotMatchWhenSyntaxContainsAnUnexpectedToken() throws(_dTeXUnexpectedTokenError<String>)
    {
      let descendantExpressionStartDelimiterSubmatcher = _dTeXLexemeSubmatcher<String>.anyOf(
        _dTeXDescendantExpressionStartDelimiterToken<String>.self
      )
      let descendantExpressionEndDelimiterToken = _AnyDTeXToken(
        _dTeXDescendantExpressionEndDelimiterToken<String>("{")
      )
      let lexeme: _dTeXUnparsedExpression<String>.SubSequence = [
        .init(_dTeXDescendantExpressionEndDelimiterToken("{")),
        descendantExpressionEndDelimiterToken,
        .init(_dTeXDescendantExpressionEndDelimiterToken("}"))
      ]
      #expect(
        throws: _dTeXUnexpectedTokenError<String>(
          lexeme: .init(lexeme),
          unexpectedToken: descendantExpressionEndDelimiterToken,
          expectedSubmatcher: descendantExpressionStartDelimiterSubmatcher
        )
      ) {
        try _dTeXLexemeMatcher(
          arrayLiteral: descendantExpressionStartDelimiterSubmatcher,
          .recursion,
          .anyOf(_dTeXDescendantExpressionEndDelimiterToken<String>.self)
        )._match(against: lexeme, inUnparsedExpressionOfType: _dTeXUnparsedExpression<String>.self)
      }
    }

    @Test
    func matchesSyntaxWithoutNestedExpressions() throws(_dTeXUnexpectedTokenError<String>) {
      let matcher: _dTeXLexemeMatcher<String> = [
        .anyOf(_dTeXDescendantExpressionStartDelimiterToken<String>.self), .recursion,
        .anyOf(_dTeXDescendantExpressionEndDelimiterToken<String>.self)
      ]
      try matcher._match(
        against: [
          .init(_dTeXDescendantExpressionStartDelimiterToken("{")),
          .init(_dTeXIdentifierToken("hbar")),
          .init(_dTeXDescendantExpressionEndDelimiterToken("}"))
        ],
        inUnparsedExpressionOfType: _dTeXUnparsedExpression<String>.self
      )
    }
  }
}
