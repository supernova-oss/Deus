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

import Testing

@testable import Geometry

struct BezierCurveTests {
  @Test
  func makesCubicBezierCurve() {
    let controller = Point(x: 0.25, y: 0.1)
    let start = Point.zero.controlled(by: controller)
    let end = Point(x: 1, y: 1).controlled(by: controller)
    let curve = BezierCurve.make(from: start, to: end)
    let points = [
      Point.zero, Point(x: 0.0685, y: 0.028), Point(x: 0.128, y: 0.056), Point(x: 0.1845, y: 0.09),
      Point(x: 0.244, y: 0.136), Point(x: 0.3125, y: 0.2), Point(x: 0.396, y: 0.288),
      Point(x: 0.5005, y: 0.406), Point(x: 0.632, y: 0.56), Point(x: 0.7965, y: 0.756),
      Point(x: 1, y: 1)
    ]
    for (offset, t) in stride(from: 0, to: 1, by: 0.1).enumerated() {
      let point = curve[t]
      guard offset > 0 else {
        #expect(point == points.first!)
        continue
      }
      guard offset < 10 else {
        #expect(point == points.last!)
        continue
      }
      #expect(point.isApproximate(to: points[offset]))
    }
  }
}
