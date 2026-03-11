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

#ifndef LLQM_QUARK_H
#define LLQM_QUARK_H

#include <stdlib.h>

#include "LLQMColor.h"

/**
 * Discriminator of mass, interaction and, consequently, lifetime of a quark.
 */
enum LLQMQuarkFlavor {
  UP,
  DOWN,
  STRANGE,
  CHARM,
  BOTTOM,
  TOP
} typedef LLQMQuarkFlavor;

/**
 * A quark (q) is an elementary fermion colored particle which is confined,
 * bound to at least another one by gluons via strong force. It is the only
 * particle in the Standard Model which experiences each of the four fundamental
 * forces: strong, weak, electromagnetic and gravitational.
 *
 * ## Classification
 *
 * There are six flavors of quarks, divided into two charge-based types and
 * three generations:
 *
 * Flavor      | Generation | Spin   | Charge | Type    | Lagrangian mass |
 * ----------- | ---------- | ------ | ------ | ------- |
 * --------------------------- | Up (u)      | 1ˢᵗ        | ½ *ħ*  | +⅔ e   | Up
 * | 2.3 ± 0.7 ± 0.5 MeV/c²      | Down (d)    | 1ˢᵗ        | ½ *ħ*  | -⅓ e   |
 * Down    | 4.8 ± 0.5 ± 0.3 MeV/c²      | Strange (s) | 2ⁿᵈ        | ½ *ħ*  |
 * -⅓ e   | Down    | 95 ± 5 MeV/c²               | Charm (c)   | 2ⁿᵈ        | ½
 * *ħ*  | +⅔ e   | Up      | 1.275 ± 0.025 GeV/c²        | Bottom (b)  | 3ʳᵈ | ½
 * *ħ*  | -⅓ e   | Down    | 4.18 ± 30 GeV/c²            | Top (t)     | 3ʳᵈ | ½
 * *ħ*  | +⅔ e   | Up      | 173.21 ± 0.51 ± 0.7 GeV/c²  |
 *
 * NOTE: The names up, down, strange, charm, bottom and top have no intrinsic
 * meaning nor do they describe the behavior of such quarks; they were chosen
 * arbitrarily, with the sole purpose of differentiating each flavor or type.
 *
 * ## Role in matter composition
 *
 * Ordinary matter, such as nucleons and, therefore, atoms, is composed by
 * 1ˢᵗ- generation quarks due to their stability: they have a decay width Γ ≈ 0
 * and, consequently, a lifetime τ ≈ ∞, because them being the lightest ones
 * either diminishes the chances of (d) or prohibits (u) their decay to
 * lighter — unknown or nonexistent — particles of the color field. Scenarios
 * beyond the Standard Model in which up quarks decay are those of Grand
 * Unification Theories, which theorize that the aforementioned four fundamental
 * forces were one in the very early Universe (first picosecond of its
 * existence) and, as described by the theory of proton decay by Andrei
 * Sakharov, such quarks have τ ≈ 10³⁴ years; nonetheless, they are
 * disconsidered here.
 *
 * As for 2ⁿᵈ- and 3ʳᵈ-generation quarks, their masses, ~20 to ~300 times
 * greater than that of the heaviest 1ˢᵗ-generation quark, alongside their
 * ability to emit a W⁺ or W⁻ via weak interaction and, subsequently, decay to
 * lighter quarks, make them unstable and result in τ ⪅ 173 GeV (5 × 10⁻²⁵ s);
 * these are, therefore, mostly present in cosmic rays and other high-energy
 * collisions. Of the four, the top quark is the only one which is heavy and
 * decays fast enough to the extent of being unable to hadronize (form a
 * hadron).
 */
typedef uint8_t LLQMQuark;

const LLQMQuark LLQMQuarkUpRed = 0b00000000;
const LLQMQuark LLQMQuarkUpGreen = 0b00001000;
const LLQMQuark LLQMQuarkUpBlue = 0b00010000;
const LLQMQuark LLQMQuarkDownRed = 0b00100000;
const LLQMQuark LLQMQuarkDownGreen = 0b00101000;
const LLQMQuark LLQMQuarkDownBlue = 0b00110000;
const LLQMQuark LLQMQuarkStrangeRed = 0b01000000;
const LLQMQuark LLQMQuarkStrangeGreen = 0b01001000;
const LLQMQuark LLQMQuarkStrangeBlue = 0b01010000;
const LLQMQuark LLQMQuarkCharmRed = 0b01100000;
const LLQMQuark LLQMQuarkCharmGreen = 0b01101000;
const LLQMQuark LLQMQuarkCharmBlue = 0b01110000;
const LLQMQuark LLQMQuarkBottomRed = 0b10000000;
const LLQMQuark LLQMQuarkBottomGreen = 0b10001000;
const LLQMQuark LLQMQuarkBottomBlue = 0b10010000;
const LLQMQuark LLQMQuarkTopRed = 0b10100000;
const LLQMQuark LLQMQuarkTopGreen = 0b10101000;
const LLQMQuark LLQMQuarkTopBlue = 0b10110000;

/**
 * Returns the flavor of a quark.
 *
 * @param quark Quark whose flavor will be returned.
 */
LLQMQuarkFlavor LLQMQuarkGetFlavor(LLQMQuark quark);

/**
 * Returns the color of a quark.
 *
 * @param quark Quark whose color will be returned.
 */
LLQMColor LLQMQuarkGetColor(LLQMQuark quark);

/**
 * Returns the force experienced by a quark in the electromagnetic field.
 *
 * @param quark Quark whose electric charge will be returned.
 */
double LLQMQuarkGetElectricCharge(LLQMQuark quark);

#endif  // !LLQM_QUARK_H
