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

final class Point {
  var center: CGPoint { .init(x: position.x + diameter, y: position.y + diameter) }
  var diameter: CGFloat { radius / 2 }

  let color: Color
  let radius: CGFloat

  private(set) var position: CGPoint
  private(set) var opposite: CGPoint?

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
    in system: some Sequence<Point>,
    repulsingFromDistanceOfAtLeast repulsionDistance: CGFloat,
    repulsingBy repulsionForce: CGFloat
  ) {
    move(boundTo: bounds)
    for point in system {
      let distance = position - point.position
      guard abs(distance.x) <= repulsionDistance && abs(distance.y) <= repulsionDistance else {
        opposite = nil
        continue
      }
      repulse(point, boundTo: bounds, by: repulsionForce)
    }
  }

  func contain(within bounds: CGRect) {
    guard
      position.x - diameter <= bounds.minX || position.x + diameter >= bounds.maxX
        || position.y - diameter <= bounds.minY || position.y + diameter >= bounds.maxY
    else { return }
    velocity.dx *= -1
    velocity.dy *= -1
    move()
  }

  private func repulse(_ other: Point, boundTo bounds: CGRect, by force: CGFloat) {
    var direction = position.direction(toward: other.position)
    direction.dx *= force
    direction.dy *= force
    opposite = other.position
    velocity += direction
    move()
    other.opposite = position
    other.velocity -= direction
    other.move()
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

extension Point: Equatable { static func == (lhs: Point, rhs: Point) -> Bool { lhs === rhs } }

extension Point: Hashable {
  func hash(into hasher: inout Hasher) {
    ObjectIdentifier(self).hash(into: &hasher)
    position.hash(into: &hasher)
    velocity.hash(into: &hasher)
    radius.hash(into: &hasher)
  }
}
