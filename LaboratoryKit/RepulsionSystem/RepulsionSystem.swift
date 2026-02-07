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

import Combine
import SwiftUI

internal import Collections

#Preview { RepulsionSystem(populationCount: 30, repulsionDistance: 20, repulsionForce: 0.3) }

private struct RepulsionSystem: View {
  @State
  private var bounds: CGRect?

  private let startDate = Date.now

  @State
  private var elapsedDate = Date.now

  private let timerPublisher =
    Timer.publish(
      every: NSApplication.shared.keyWindow?.screen?.displayUpdateGranularity ?? 1 / 60,
      on: .main,
      in: .default
    )
    .autoconnect()

  @State
  private var repulsiveBodies: OrderedSet<RepulsiveBody>

  private let populationCount: Int
  private let repulsionDistance: CGFloat
  private let repulsionForce: CGFloat

  private static let pointRadius: CGFloat = 5

  init(populationCount: Int, repulsionDistance: CGFloat, repulsionForce: CGFloat) {
    self.repulsiveBodies = .init(minimumCapacity: populationCount)
    self.populationCount = populationCount
    self.repulsionDistance = repulsionDistance
    self.repulsionForce = repulsionForce
  }

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      Canvas { context, size in
        context.drawGrid(within: size)
        for repulsiveBody in repulsiveBodies { context.draw(repulsiveBody) }
      }
      Text(Duration.seconds(elapsedDate.timeIntervalSince(startDate)).formatted())
        .fontDesign(.monospaced).padding()
        .background(.ultraThinMaterial, in: ButtonBorderShape.roundedRectangle)
        .padding([.trailing, .bottom])
    }
    .onGeometryChange(for: CGSize.self, of: { geometry in geometry.frame(in: .local).size }) {
      size in
      let bounds = CGRect(origin: .zero, size: size)
      if repulsiveBodies.isEmpty {
        for _ in repulsiveBodies.startIndex..<populationCount {
          repulsiveBodies.append(Self.generateRepulsiveBody(boundTo: bounds))
        }
      } else {
        for repulsiveBody in repulsiveBodies { repulsiveBody.contain(within: bounds) }
      }
      self.bounds = bounds
    }
    .onReceive(timerPublisher) { date in
      elapsedDate += date.timeIntervalSince(elapsedDate)
      guard let bounds else { return }
      for repulsiveBody in repulsiveBodies {
        repulsiveBody.move(
          boundTo: bounds,
          in: repulsiveBodies,
          repulsingFromDistanceOfAtLeast: repulsionDistance,
          repulsingBy: repulsionForce
        )
      }
    }
  }

  private static func generateRepulsiveBody(boundTo bounds: CGRect) -> RepulsiveBody {
    .init(
      x: .random(in: bounds.minX...bounds.maxX),
      y: .random(in: bounds.minY...bounds.maxY),
      color: .random,
      radius: Self.pointRadius
    )
  }
}

extension GraphicsContext {
  private static let gridLineSpacing: CGFloat = 25

  fileprivate func drawGrid(within size: CGSize) {
    var path = Path()
    var coordinate = Self.gridLineSpacing
    while coordinate < size.width || coordinate < size.height {
      path.move(to: .init(x: coordinate, y: 0))
      path.addLine(to: .init(x: coordinate, y: size.height))
      path.move(to: .init(x: 0, y: coordinate))
      path.addLine(to: .init(x: size.width, y: coordinate))
      coordinate += Self.gridLineSpacing
    }
    stroke(path, with: .color(.green), lineWidth: 0.5)
  }
}
