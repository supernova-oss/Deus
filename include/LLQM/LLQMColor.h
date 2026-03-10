//// ===-----------------------------------------------------------------------===
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

#ifndef LLQMC_COLOR_H
#define LLQMC_COLOR_H

/**
 * Color charge is a fundamental, confined (unobservable while free) property
 * which determines its transformation under the SU(3) gauge symmetry whose
 * field, SU(3)₍color₎ or gluon field, is quantized as gluons, bosons
 * responsible for binding the quarks of a hadron by mediating the strong
 * interactions.
 *
 * Each of the three directions of the vector (red, green and blue) are
 * amplitudes when unmeasured; upon measurement, the probability of this charge
 * being in such direction is produced according to the Born rule. Finally, a
 * definite color is determined, resulting in one of the cases of this enum.
 *
 * These three directions are intrinsically equal to each other: they can be
 * swapped via an SU(3) transformation and the overall state of the system will
 * not be modified. They affect, however, the interactions to be had with them
 * by the gluons, which carry specific color-anticolor combinations; these can,
 * in turn…
 *
 * - …annihilate one direction and redirect;
 * - influence the phase of a direction but not redirect the vector; or
 * - be effectless.
 *
 * NOTE: None of the two mentioned concepts, color and direction, refer to their
 * classical description (respectively, a visual perception of the
 * electromagnetic spectrum and a projection of physical movement from one point
 * toward another). These are uniquely-quantum properties of a colored particle.
 */
enum LLQMColor {
  RED,
  GREEN,
  BLUE
} typedef LLQMColor;

#endif // !LLQMC_COLOR_H
