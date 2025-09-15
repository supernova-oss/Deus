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

/// Smooth set ranging from one number to another.
public struct Interval: Notation {
  public let _terms: [AnyNotation]
  public let _flatDescription: String

  /// Defines whether the first and last elements of this ``Interval`` are included in the notation.
  private let inclusiveness: Inclusiveness

  /// Indicates the values in the extremity of an ``Interval`` to be included and those which are to
  /// be considered as excluded in the notation.
  public enum Inclusiveness {
    /// The first element of the ``Interval`` is notated as included, while the last one is as
    /// excluded.
    case first

    /// The last element of the ``Interval`` is notated as included, while the first one is as
    /// excluded.
    case last

    /// Both first and last elements of the ``Interval`` are notated as included.
    case both

    /// Both first and last elements of the ``Interval`` are notated as excluded.
    case neither
  }

  public init(_ terms: [AnyNotation], including inclusiveness: Inclusiveness = .both) {
    let opener: Character =
      switch inclusiveness {
      case .first, .both: "("
      case .last, .neither: "["
      }
    let closer: Character =
      switch inclusiveness {
      case .last, .both: ")"
      case .first, .neither: "]"
      }
    self._terms = terms
    _flatDescription = "\(opener)" + _terms.map(\.description).joined() + "\(closer)"
    self.inclusiveness = inclusiveness
  }
}

extension Interval: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: AnyNotation...) { self = .init(elements) }
}
