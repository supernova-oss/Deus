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

/// Immutable ``Opposable`` with a finite set of describable states in which an instance of it can
/// be, including both its matter and antimatter variants.
///
/// - SeeAlso: ``discretion``
public protocol Discrete: Opposable, Sendable {
  /// Type of the set which contains the discrete values.
  associatedtype Discretion: Collection<Self>

  /// Set of possible states of an instance of this ``Discrete``.
  ///
  /// > Note: It is implied that all conforming implementations *do* contain at least one possible
  /// state. Therefore, it is expected that the returned collection is populated with at least one
  /// instance.
  static var discretion: Discretion { get }
}
