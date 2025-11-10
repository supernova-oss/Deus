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
import RealityKit
import QuantumMechanics

/// Shape of a quark-like: a sphere.
@MainActor
private let mesh = MeshResource.generateSphere(radius: 0.2)

extension Entity {
  /// Converts a quark-like from the Standard Model into an `Entity`.
  ///
  /// - Parameters:
  ///   - quarkLike: Quark-like from which an `Entity` is to be initialized.
  convenience init?(_ quarkLike: some QuarkLike) {
    self.init()
    guard let materialColor = NSColor(quarkLike.colorLike) else { return nil }
    let metal = SimpleMaterial(color: materialColor, roughness: 0.8, isMetallic: true)
    let component = ModelComponent(mesh: mesh, materials: [metal])
    name = quarkLike.symbol
    components.set(component)
  }
}
