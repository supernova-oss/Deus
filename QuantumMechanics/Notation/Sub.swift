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

/// Denotes that the target onto which this is applied should be subscripted: notated as being below
/// the base line of the ``Notation`` which is the parent of this one, meaning that targets may be
/// represented as lower and lower, smaller and smaller than their predecessors.
public struct Sub<Term: Notation>: Notation {
  public let _terms: [Term]
  public let _flatDescription: String
  public let _compoundDescription: String

  public init(_ term: Term) {
    self._terms = [term]
    _flatDescription = "_\(term)"
    _compoundDescription = "_(\(term))"
  }
}
