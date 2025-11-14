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

import Geometry
import QuantumMechanics
import SwiftUI

#Preview { Presentation(schwarzschildBlackHoleInitialTime: .seconds(6912e2)) }

struct Presentation: View {
  var body: some View {
    ZStack {
      Color(.black)
      SchwarzschildBlackHole(
        distance: .init(value: 56e2, unit: .kilometers),
        mass: .init(value: 4, unit: .solar),
        initialTime: schwarzschildBlackHoleInitialTime,
        accretionDiskPlane: (.zero, .radians(.pi * 2))
      )
    }
  }

  private let schwarzschildBlackHoleInitialTime: Duration

  init(schwarzschildBlackHoleInitialTime: Duration = Duration.zero) {
    self.schwarzschildBlackHoleInitialTime = schwarzschildBlackHoleInitialTime
  }
}

/// Simulation of a Schwarzschild black hole in SwiftUI, to which are passed in coefficients in
/// physical units and by which these are converted into points in the coordinate space of the
/// framework.
///
/// Influenced by [luminet](https://github.com/bgmeulem/luminet), simulator developed by Bjorge
/// Meulemeester, Ph.D. in Computational Neuroscience at the Max Planck Institute for Neurobiology
/// of Behavior.
///
/// - SeeAlso: ``SwiftUI/GraphicsContext/drawSchwarzschildBlackHole(within:awayBy:atTime:)``
private struct SchwarzschildBlackHole: View {
  var body: some View {
    Canvas { context, viewport in
      context.drawSchwarzschildBlackHole(
        within: viewport,
        awayBy: distance,
        atTime: time,
        ofMass: mass,
        withAccretionDiskAtPlane: accretionDiskPlane
      )
    }.onReceive(timerPublisher) { currentDate in
      time = .seconds(currentDate.timeIntervalSince(startDate))
    }.accessibilityLabel(
      "Schwarzschild black hole, \(distance) away and of mass \(mass), with an accretion disk at "
        + "\(accretionDiskPlane)"
    )
  }

  /// Distance between the observer and the black hole.
  let distance: Measurement<UnitLength>

  /// Unitized quantity by which the black hole distorts spacetime. The radius *rₛ* of the event
  /// horizon is proportional to it, given that *rₛ* = (2*G* × `mass`) / *c*².
  let mass: Measurement<UnitMass>

  /// Configuration of the accretion disk regarding the extent to which the event horizon is
  /// longitudinally wrapped by it and the inclination of the accretion disk toward the poles of the
  /// event horizon.
  let accretionDiskPlane: (colatitude: Angle, longitude: Angle)

  /// Publisher of the timer by which the passage of time is listened to at each second for the
  /// movement of flux of the accretion disk.
  private let timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  /// Moment in time since which the timer was fired.
  private let startDate = Date.now

  /// Time elapsed since the ``startDate``.
  @State
  private var time: Duration

  init(
    distance: Measurement<UnitLength>,
    mass: Measurement<UnitMass>,
    initialTime: Duration = Duration.zero,
    accretionDiskPlane: AccretionDiskPlane
  ) {
    self.distance = distance
    self.mass = mass
    time = initialTime
    self.accretionDiskPlane = accretionDiskPlane
  }
}

// Important: conversions of measurements should be made by the `Measurement/converted(into:)`
// function provided by the `QuantumMechanics` module instead of that of `Foundation`, given that
// ours differs from it in that it does not initialize another measurement eagerly; rather, checks
// whether the given unit equals to that of the measurement and returns such measurement itself if
// so.
//
// Calling `Measurement/converted(to:)` by `Foundation` may introduce perceivable performance
// overhead.
extension GraphicsContext {
  /// The square of the speed of light *c*.
  private static let lightSpeedSquaredInMetersPerSecond = Measurement(
    value: 1,
    unit: UnitSpeed.lightSquared
  ).converted(into: .metersPerSecond).value

  /// Draws a neutrally-charged, non-spinning and spherically-symmetric black hole.
  ///
  /// > Note: The coefficients documented below may appear to be named unconventionally. This is
  /// because Swift-DocC does not support notations in, e.g., TeX, and Unicode contains a limited
  /// subset of mathematical characters (particularly subscript ones).
  ///
  /// A Schwarzschild black hole is, as of November, 2025, the simplest theoretical and classical
  /// black hole. It exists in otherwise empty spacetime, and is uniquely describable by four of
  /// its properties:
  ///
  /// | Property         | Definition                                                                                                                 |
  /// |------------------|----------------------------------------------------------------------------------------------------------------------------|
  /// | Charge           | It is neutrally-charged; no charged particles have crossed its event horizon before `time` or will cross it as `time` → ∞. |
  /// | Angular momentum | Its angular momentum is zero; its event horizon does not rotate around its own axis.                                       |
  /// | Symmetry         | Its event horizon lies on an S² manifold with equidistant neighborhoods.                                                   |
  ///
  /// There are two core concepts behind a black hole of this kind: the **Schwarzschild metric**
  /// *dₛ* and the **Schwarzschild radius** *rₛ*. The first is the exact solution by Karl
  /// Schwarzschild for the field equations of general relativity by Albert Einstein, in which
  /// Einstein related the curvature of spacetime caused by an object to the local energy, the
  /// momentum and the stress of the object; and the second is a parameter of such solution,
  /// corresponding to the radius of the event horizon as a function over the `mass`.
  ///
  /// Considering that the distribution of mass of the black hole is centrally symmetric and its
  /// gravitational field is static (i.e., the aforementioned distribution remains unchanged),
  ///
  /// - *rₛ* = (2*GM*) / *c*², where *M* is the `mass` in kilograms; and
  /// - *dₛ* = -(1 - (2*GM*) / *c*²*r*)*c*²*dt*² + *dr*² / (1 - 2*GM* / *c*²*r*) + *r*²(*dθ*² + (sin² *θ*)*dφ*²).
  ///
  /// ## Physical–coordinate-space conversion
  ///
  /// The parameters of this function pertaining to those of the Schwarzschild metric are passed in
  /// as physical dimensions, differing from simulators in which they are provided in natural units,
  /// where *G* = *c* = 1, with *G* being the ``newtonianGravitationalConstant`` and *c* the speed
  /// of light. Such maintanance of physicality is in accordance with the overall purpose of Deus:
  /// to simulate the Universe as precisely and close to its universal intrisicacies as possible.
  ///
  /// The conversion of the physical dimensions is strictly based on the SI units; therefore, each
  /// meter corresponds to one point in the coordinate space of SwiftUI. The `distance` from which
  /// the black hole would have to be observed in order to be completely visible within the
  /// `viewport` is proportional to its `mass`, which is as proportional to *rₛ* as 2*G* is to *c*².
  ///
  /// - Parameters:
  ///   - viewport: Size available for drawing.
  ///   - distance: Distance between the observer and the black hole.
  ///   - time: Time elapsed since the formation of the black hole. As `time` → ∞, the light
  ///     reaching the black hole begins to orbit around it and compose its accretion disk at the
  ///     given `accretionDiskPlane`.
  ///   - mass: Unitized quantity by which the black hole curves spacetime. The radius *rₛ* of the
  ///     event horizon is proportional to it, given that *rₛ* = (2*G* × `mass`) / *c*².
  ///   - accretionDiskPlane: Configuration of the accretion disk regarding the extent to which the
  ///     event horizon is longitudinally wrapped by it and the inclination of the accretion disk
  ///     toward the poles of the event horizon.
  fileprivate func drawSchwarzschildBlackHole(
    within viewport: CGSize,
    awayBy distance: Measurement<UnitLength>,
    atTime time: Duration,
    ofMass mass: Measurement<UnitMass>,
    withAccretionDiskAtPlane accretionDiskPlane: AccretionDiskPlane
  ) {
    let radius = Self.schwarzschildRadiusInMeters(forMass: mass)
    let distanceInMeters = distance.converted(into: .meters).value
    let eventHorizonRect = makeEventHorizonRect(
      within: viewport,
      awayBy: distanceInMeters,
      ofRadius: radius
    )
    fill(Path(ellipseIn: eventHorizonRect), with: .color(.black))
    drawAccretionDisk(
      atPlane: accretionDiskPlane,
      atTime: time,
      awayBy: distanceInMeters,
      forMass: mass,
      around: eventHorizonRect,
      ofSchwarzschildRadius: radius
    )
  }

  /// Calculates the Schwarzschild radius *rₛ* in meters, which is that of the event horizon of a
  /// Schwarzschild black hole. Denotes the point of no return from the center, past which matter
  /// and light cannot escape.
  ///
  /// *rₛ* = (2*GM*) / *c*², where
  ///
  /// - *G* is the ``newtonianGravitationalConstant``;
  /// - *M* is the mass of the black hole; and
  /// - *c* is the speed of light.
  ///
  /// These coefficients are usually converted into natural units in simulations, in which
  /// *G* = *c* = 1. Here, however, they are in SI units: *G* is in cubic meters, per kilogram, per
  /// second squared; *M* in kilograms; and *c* in meters per second.
  private static func schwarzschildRadiusInMeters(forMass mass: Measurement<UnitMass>) -> Double {
    2 * newtonianGravitationalConstant * mass.converted(into: .kilograms).value
      / Self.lightSpeedSquaredInMetersPerSecond
  }

  private func makeEventHorizonRect(
    within viewport: CGSize,
    awayBy distanceInMeters: Double,
    ofRadius radiusInMeters: Double
  ) -> CGRect {
    let undistancedDiameter = radiusInMeters * 2
    let distancedDiameterInMeters = undistancedDiameter * undistancedDiameter / distanceInMeters
    let distancedDiameterHalfInMeters = distancedDiameterInMeters / 2
    return CGRect(
      x: viewport.width / 2 - distancedDiameterHalfInMeters,
      y: viewport.height / 2 - distancedDiameterHalfInMeters,
      width: distancedDiameterInMeters,
      height: distancedDiameterInMeters
    )
  }

  private func drawAccretionDisk(
    atPlane plane: AccretionDiskPlane,
    atTime time: Duration,
    awayBy distanceInMeters: Double,
    forMass mass: Measurement<UnitMass>,
    around eventHorizonRect: CGRect,
    ofSchwarzschildRadius schwarzschildRadiusInMeters: Double
  ) {
    guard time >= .zero else {
      fatalError(
        "Cannot draw the accretion disk at a time previous to the formation of the black hole."
      )
    }
  }

  /// Distance in meters from the singularity of the event horizon of a Schwarzschild black hole
  /// until which the mass of the black hole distorts space time. Determines the extent of the
  /// gravitational field of the black hole.
  private func schwarzschildMetric(
    withAccretionDiskAtPlane plane: AccretionDiskPlane,
    atTime time: Duration,
    awayBy distanceInMeters: Double,
    ofRadius radiusInMeters: Double
  ) -> Double {
    let curvature = (1 - radiusInMeters)
    let timeInSeconds = TimeInterval(time)
    let radiusSquared = radiusInMeters * radiusInMeters
    let colatitudeSinInRadians = sin(plane.colatitude.radians)
    return curvature * Self.lightSpeedSquaredInMetersPerSecond * distanceInMeters * timeInSeconds
      * timeInSeconds + (1 / curvature) * distanceInMeters * radiusSquared + radiusSquared
      * (distanceInMeters * plane.colatitude.radians * plane.colatitude.radians
        + colatitudeSinInRadians * colatitudeSinInRadians * distanceInMeters
        * plane.longitude.radians * plane.longitude.radians)
  }
}

/// Coverage of a black hole by an accretion disk in both of the axes.
///
/// - Parameters:
///   - colatitude: The colatitude *φ* is the inclination toward either poles, inclining toward the
///     north one as *φ* → -∞ and the south one as *φ* → ∞.
///   - longitude: The longitude *θ* determines the extent to which the disk wraps the event horizon
///     horizontally.
private typealias AccretionDiskPlane = (colatitude: Angle, longitude: Angle)
