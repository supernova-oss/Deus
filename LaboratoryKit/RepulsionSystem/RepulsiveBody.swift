// ===-----------------------------------------------------------------------===
// Copyright © 2026 Supernova
//
// This file is part of the Deus open-source project.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program. If not, see https://www.gnu.org/licenses.
// ===-----------------------------------------------------------------------===

import SwiftUI

final class RepulsiveBody {
  var center: CGPoint {
    .init(x: position.x + diameter, y: position.y + diameter)
  }
  var diameter: CGFloat { radius / 2 }

  let color: Color
  let radius: CGFloat

  private(set) var position: CGPoint
  private(set) var repulsionPoint: CGPoint?

  private var velocity: CGVector

  init(x: CGFloat, y: CGFloat, color: Color, radius: CGFloat) {
    self.position = .init(x: x, y: y)
    self.velocity = .init(
      dx: Self.generateRandomVelocityDelta(),
      dy: Self.generateRandomVelocityDelta()
    )
    self.color = color
    self.radius = radius
  }

  func move(
    boundTo bounds: CGRect,
    in system: some Sequence<RepulsiveBody>,
    repulsingFromDistanceOfAtLeast repulsionDistance: CGFloat,
    repulsingBy repulsionForce: CGFloat
  ) {
    move(boundTo: bounds)
    for repulsedBody in system {
      let distance = CGVector(
        dx: position.x + radius - repulsedBody.position.x + repulsedBody.radius,
        dy: position.y + radius - repulsedBody.position.y + repulsedBody.radius
      )
      .length
      guard distance <= repulsionDistance else {
        repulsionPoint = nil
        continue
      }
      repulse(repulsedBody, boundTo: bounds, by: repulsionForce)
    }
  }

  func contain(within bounds: CGRect) {
    guard
      position.x - diameter <= bounds.minX || position.x + radius >= bounds.maxX
        || position.y - diameter <= bounds.minY
        || position.y + radius >= bounds.maxY
    else { return }
    velocity.dx *= -1
    velocity.dy *= -1
    move(boundTo: bounds)
  }

  private func repulse(
    _ other: RepulsiveBody,
    boundTo bounds: CGRect,
    by force: CGFloat
  ) {
    var direction = position.direction(toward: other.position)
    direction.dx *= force
    direction.dy *= force
    repulsionPoint = other.position
    velocity += direction
    move(boundTo: bounds)
    other.repulsionPoint = position
    other.velocity -= direction
    other.move(boundTo: bounds)
  }

  private func move(boundTo bounds: CGRect) {
    move()
    contain(within: bounds)
  }

  private func move() {
    position.x += velocity.dx
    position.y += velocity.dy
  }

  private static func generateRandomVelocityDelta() -> CGFloat {
    let velocityDelta = CGFloat.random(in: -1...1)
    return velocityDelta != 0 ? velocityDelta : generateRandomVelocityDelta()
  }
}

extension RepulsiveBody: Equatable {
  static func == (lhs: RepulsiveBody, rhs: RepulsiveBody) -> Bool {
    lhs === rhs
  }
}

extension RepulsiveBody: Hashable {
  func hash(into hasher: inout Hasher) {
    ObjectIdentifier(self).hash(into: &hasher)
    position.hash(into: &hasher)
    velocity.hash(into: &hasher)
    radius.hash(into: &hasher)
    repulsionPoint.hash(into: &hasher)
  }
}
