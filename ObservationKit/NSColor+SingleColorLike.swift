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

import AppKit
import QuantumMechanics

extension NSColor {
  /// Converts a color-like from the Standard Model into an `NSColor`.
  ///
  /// - Parameter colorLike: Color-like from which an `NSColor` is to be initialized.
  public convenience init?(_ colorLike: some SingleColorLike) {
    if colorLike.is(Red.self) {
      self.init(cgColor: Self.systemRed.cgColor)
    } else if colorLike.is(Anti<Red>.self) {
      self.init(cgColor: Self.red.cgColor)
    } else if colorLike.is(Green.self) {
      self.init(cgColor: Self.systemGreen.cgColor)
    } else if colorLike.is(Anti<Green>.self) {
      self.init(cgColor: Self.green.cgColor)
    } else if colorLike.is(Blue.self) {
      self.init(cgColor: Self.systemBlue.cgColor)
    } else if colorLike.is(Anti<Blue>.self) {
      self.init(cgColor: Self.blue.cgColor)
    } else {
      return nil
    }
  }
}
