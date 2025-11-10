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

import RealityKit
import QuantumMechanics
import SwiftUI

/// `View` by which a simulation of particle physics is displayed.
public struct ObservationView: View {
  public init() {}

  public var body: some View {
    GeometryReader { geometry in ObservationARView(geometry: geometry) }
  }
}

/// Wrapper around an `ARView` to which the responsabilities of the ``ObservationView`` are
/// delegated.
private struct ObservationARView: NSViewRepresentable {
  /// ``GeometryProxy`` by which the frame of the backing `ARView` is defined.
  private let geometry: GeometryProxy

  init(geometry: GeometryProxy) { self.geometry = geometry }

  func makeNSView(context: Context) -> ARView {
    let nsView = ARView(frame: geometry.frame(in: .local))
    nsView.environment.background = .color(.windowBackgroundColor)
    let anchor = AnchorEntity()
    let entity = Entity(Anti(UpQuark(colorLike: red)))
    precondition(
      entity != nil,
      "Conversion of an antired up antiquark into an entity should never fail."
    )
    anchor.addChild(entity!)
    nsView.scene.addAnchor(anchor)
    return nsView
  }

  func updateNSView(_ nsView: ARView, context: Context) {}
}
