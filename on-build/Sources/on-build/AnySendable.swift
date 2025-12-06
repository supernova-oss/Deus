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

/// Wrapper for erasing the type of a *potentially* sendable instance.
struct AnySendable: @unchecked Sendable {
  /// Instance which *may* be sendable, whose type has been erased. Force-casting it to its original
  /// type is a safe operation.
  let base: Any

  /// Erases the type of an instance which is *potentially* sendable.
  ///
  /// - Parameter base: Instance whose type has been erased. Force-casting it to its original type
  ///   is a safe operation.
  init(_ base: some Any) { self.base = base }
}
