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

/// dTeX expression for richer, more precise definitions of mathematical formulas and symbology.
/// Differs from plaintext (typically encoded in a Unicode format, as is a Swift string in UTF-8) in
/// that its syntax allows for representing complex structures, which may be rendered later on
/// through some medium (e.g., in a command-line interface or GUI).
///
/// ## What is dTeX?
///
/// dTeX is the language in which the notations of Deus are written. It is a subset of the TeX
/// language, meaning that any valid expressions in dTeX are also valid TeX expressions; however,
/// not every feature of TeX is available in dTeX.
///
/// The primary goal of dTeX is for its syntax to encompass only the features of TeX which are
/// required by Deus in order for it to notate its expressions. Such simplicity stems from the
/// fact that the team is composed by only one person — the original author — and that there is no
/// known framework-independent Swift package for lexing and parsing TeX expressions.
///
/// So… why not store such notations directly as strings?
///
/// ## The problem with strings
///
/// Simply put: [strings are error-prone](https://youtu.be/-lVVfxsRjcY?t=1199).
///
/// The author of Deus is not familiar with the syntax of TeX, and the project is nowhere near
/// publishable by the time this lexer is being written (two months have passed, and there is not
/// even a UI to begin with).
///
/// Notations are an integral part of the program, given that they may dictate substantial decisions
/// on bug-fixing on the software and overall theorization on the Big Bang. Therefore, negligence
/// with regards to this aspect has the potential of slowing down or compromising development
/// negatively by, e.g, inducing one to false physical/mathematical assumptions.
///
/// ## Syntax
///
/// Because dTeX is a less complex subset of TeX, the syntax for the features which are
/// interoperable between both languages is identical. The complete specification of TeX can be
/// found on [The TeXbook](https://web.math.ucsb.edu/~bigelow/books/texbook.pdf), whose copy is
/// provided by the University of California, Santa Barbara (UCSB).
///
/// dTeX being simpler means that only some of the features of TeX are supported by it. These
/// "features" — called "expression elements" in the source of this lexer, which comprise references
/// to constants and calls to both functions and operators — are the ones listed in the table below.
///
/// | Constant    | Function       | Operator  |
/// |-------------|----------------|-----------|
/// | `\hbar`     | `\frac{a}{b}`  | `{a}^{b}` |
/// | `\pi`       | `\overline{a}` | `{a}_{b}` |
///
/// > Important: Any TeX-specific expression containing elements other than the ones cited above is
/// considered an invalid dTeX expression.
///
/// ## Future plans
///
/// The entire validation process, which includes both lexing and parsing, was initially idealized
/// by the author of Deus as being part of a macro in Swift (such as the `#/`…`/#` one for regular
/// expressions). Due to time and personnel constraints, the runtime validation will be maintained
/// until such portion of the project can be given the attention it requires in order for such a
/// macro to be developed responsibly.
///
/// The macro is inteded to be written as an expression in inline math mode is in TeX, with
/// surrounding dollar signs ($). Below is the de Broglie thermal wavelength of a massive,
/// non-interacting ``Particle``, notated in dTeX with the idealized Swift macro:
///
/// ```swift
/// $(\sqrt{fraction{2 \pi \hbar ^2}{mk_{B}T}}$
/// ```
///
/// ## Syntax validity
///
/// An instance of this struct obtained by calling ``$(_:)`` is always guaranteed to contain valid
/// syntax.
public struct Notation {
  /// ``Notatable`` evaluated to this ``Notation``.

  // The parser distinguishes between main and descendant expressions; no need to do so here.
  let expression: String

  fileprivate init(syntax: String) { self.expression = syntax }
}

/// Instantiates a ``Notation`` from the given dTeX syntax.
///
/// This function is not lenient: passing in an invalid syntax will make it not return and, instead,
/// terminate the process. Such care is due to the importance of the correctness of mathematical
/// expressions in Deus, given that it is, primarily, a simulator of particle physics, and providing
/// incorrect and/or malformed expressions may give rise to incorrect assumptions.
///
/// For a more detailed explanation, refer to the ``Notation`` documentation.
public func `$`(_ syntax: String) -> Notation {
  let _ = dTeXLexer.tokenize(syntax)
  return Notation(syntax: syntax)
}
