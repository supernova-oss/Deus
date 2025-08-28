// ===-------------------------------------------------------------------------------------------===
// Copyright © 2025 Deus
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

import Foundation

/// Base value for calculating an approximation of the mass of a charged ``Pion``.
let chargedPionMass = Measurement(value: 139.57039, unit: UnitMass.gigaelectronvolt)

/// Statistical uncertainty for calculating an approximation of the mass of a charged ``Pion``.
let chargedPionMassStatisticalUncertainty = Measurement(value: 180, unit: UnitMass.electronvolt)

/// ``Meson`` composed by ``Quark``-antiquark pairs, produced most commonly via high-energy
/// collisions between ``Hadron``s and specific ``Particle``-antiparticle annihilation.
///
/// ## Etimology
///
/// Its name ("π meson", contracted to "pion") was defined by Hideki Yukawa in 1935 and is
/// indicative of its then-theorized role as a carrier ``Particle`` of strong force, inspired by the
/// visual resemblance between "π" and "介", Kanji that means "to mediate".
///
/// Later, in 1962, Murray Gell-Mann theorized that such force was, rather, mediated by gluons,
/// massless ``Particle``s whose ``Spin`` is 1 *ħ* and which are, consequently, categorized as
/// vector bosons.
///
/// ## Stability
///
/// Because of their lightness, the lifetime of pions is extremely short, resulting in them lasting
/// from 85 attoseconds to ~26.033 ns before their decay into muons and neutrinos (π⁺ → μ + v) or
/// into gamma rays. Therefore, they are considered **unstable**.
public protocol Pion: Meson {}

extension Pion where Self: ParticleLike { public var spin: Spin { .zero } }
