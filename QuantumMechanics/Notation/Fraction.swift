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

/// Ratio of one ``Notation`` to another.
public struct Fraction: Notation {
  public let _terms: [AnyNotation]
  public let _flatDescription: String

  public init(_ first: some Notation, _ second: some Notation) {
    _terms = [.make(first), .make(second)]
    _flatDescription = "\(_terms[0]) / \(_terms[1])"
  }
}

extension Notation { static func / (lhs: Self, rhs: some Notation) -> Fraction { .init(lhs, rhs) } }
