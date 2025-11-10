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
@preconcurrency import RealityKit
import QuantumMechanics
import Testing

@testable import ObservationKit

@Suite("Entity+QuarkLike tests")
struct EntityQuarkLikeTests {
  @Test(
    .disabled("Entity initializer fails only when testing."),
    arguments: AnyQuarkLike.discretion
  )
  func entityIsColored(withColorOf quarkLike: AnyQuarkLike) async {
    guard let entity = await Entity(quarkLike) else {
      fatalError("Entity initialization has failed.")
    }
    async let components = entity.components
    #expect(await components.count == 1)
    guard let singleComponent = await components[components.startIndex] as? ModelComponent else {
      fatalError("Single component of entity is not a ModelComponent.")
    }
    let materials = singleComponent.materials
    #expect(materials.count == 1)
    guard let singleMaterial = materials[materials.startIndex] as? SimpleMaterial else {
      fatalError("Single material of entity is not a simple one.")
    }
    #expect(singleMaterial.color.tint == NSColor(quarkLike.colorLike))
  }
}
