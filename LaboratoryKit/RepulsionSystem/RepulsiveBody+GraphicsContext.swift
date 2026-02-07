// ===-------------------------------------------------------------------------------------------===
// Copyright © 2026 Supernova. All rights reserved.
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

import SwiftUI

internal import Collections

extension GraphicsContext {
  func draw(_ body: RepulsiveBody) {
    var path = Path()
    path.addArc(
      center: body.center,
      radius: body.radius,
      startAngle: .zero,
      endAngle: .radians(2 * .pi),
      clockwise: true
    )
    path.closeSubpath()
    fill(path, with: .color(body.color))
    guard let repulsionPoint = body.repulsionPoint else { return }
    drawRepulsionLine(from: body, to: repulsionPoint)
  }

  private func drawRepulsionLine(from body: RepulsiveBody, to repulsionPoint: CGPoint) {
    var path = Path()
    path.move(to: body.center)
    path.addLine(
      to: .init(x: repulsionPoint.x + body.diameter, y: repulsionPoint.y + body.diameter)
    )
    path.closeSubpath()
    stroke(path, with: .color(.orange))
  }
}
