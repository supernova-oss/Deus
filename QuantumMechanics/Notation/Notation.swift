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

/// TeX expression for richer, more precise definitions of mathematical formulas and symbology.
/// Differs from plaintext (typically encoded in a Unicode format, as is a Swift string in UTF-8) in
/// that its syntax allows for representing complex structures, which may be rendered later on
/// through some medium (e.g., in a command-line interface or GUI).
///
/// ## Syntax validity
///
/// An instance of this struct obtained by calling ``$(_:)`` is always guaranteed to contain valid
/// syntax.
public struct Notation {
  /// ``Notatable`` evaluated to this ``Notation``.
  let syntax: String

  fileprivate init(syntax: String) { self.syntax = syntax }
}

/// Instantiates a ``Notation`` from the given TeX syntax.
///
/// This function is not lenient: passing in an invalid syntax will make it not return and, instead,
/// terminate the process. Such care is due to the importance of the correctness of mathematical
/// expressions in Deus, given that it is, primarily, a simulator of particle physics, and providing
/// incorrect and/or malformed expressions may give rise to incorrect assumptions.
public func `$`(_ syntax: String) -> Notation {
  _TexExpressionValidator.validate(syntax)
  return Notation(syntax: syntax)
}
