// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Supernova. All rights reserved.
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

/// Base protocol to which single ``Color``s and anticolors conform.
public protocol SingleColorLike: ColorLike {}

extension Anti: SingleColorLike where Counterpart: SingleColor {
  public func `is`(_ other: (some SpecificColorLike).Type) -> Bool {
    let unerasedCounterpartType =
      if let counterpart = counterpart as? AnySingleColor { type(of: counterpart.base) } else {
        Counterpart.self
      }
    return other == Anti<Red>.self && unerasedCounterpartType == Red.self
      || other == Anti<Green>.self && unerasedCounterpartType == Green.self
      || other == Anti<Blue>.self && unerasedCounterpartType == Blue.self
  }
}

/// One direction in the ``Color`` field.
public protocol SingleColor: Color, Opposable, SingleColorLike {}
