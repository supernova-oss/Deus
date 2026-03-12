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

#include <LLQM/LLQMColor.h>
#include <LLQM/LLQMQuark.h>
#include <errno.h>
#include <stdlib.h>

#define LLQM_QUARK_FLAVOR_MASK    0b11100000
#define LLQM_QUARK_FLAVOR_UP      0b00000000
#define LLQM_QUARK_FLAVOR_DOWN    0b00100000
#define LLQM_QUARK_FLAVOR_STRANGE 0b01000000
#define LLQM_QUARK_FLAVOR_CHARM   0b01100000
#define LLQM_QUARK_FLAVOR_BOTTOM  0b10000000
#define LLQM_QUARK_FLAVOR_TOP     0b10100000
#define LLQM_QUARK_COLOR_MASK     0b00011000
#define LLQM_QUARK_COLOR_RED      0b00000000
#define LLQM_QUARK_COLOR_GREEN    0b00001000
#define LLQM_QUARK_COLOR_BLUE     0b00010000

#define LLQM_QUARK_FOLD_TYPE(QUARK, FOR_UP_TYPE, FOR_DOWN_TYPE) \
  switch (quark & LLQM_QUARK_FLAVOR_MASK) {                     \
    case LLQM_QUARK_FLAVOR_UP:      return FOR_UP_TYPE;         \
    case LLQM_QUARK_FLAVOR_DOWN:    return FOR_DOWN_TYPE;       \
    case LLQM_QUARK_FLAVOR_STRANGE: return FOR_DOWN_TYPE;       \
    case LLQM_QUARK_FLAVOR_CHARM:   return FOR_UP_TYPE;         \
    case LLQM_QUARK_FLAVOR_BOTTOM:  return FOR_DOWN_TYPE;       \
    case LLQM_QUARK_FLAVOR_TOP:     return FOR_UP_TYPE;         \
    default:                        exit(EINVAL);                                      \
  }

LLQMQuarkFlavor LLQMQuarkGetFlavor(LLQMQuark quark) {
  switch (quark & LLQM_QUARK_FLAVOR_MASK) {
    case LLQM_QUARK_FLAVOR_UP:      return UP;
    case LLQM_QUARK_FLAVOR_DOWN:    return DOWN;
    case LLQM_QUARK_FLAVOR_STRANGE: return STRANGE;
    case LLQM_QUARK_FLAVOR_CHARM:   return CHARM;
    case LLQM_QUARK_FLAVOR_BOTTOM:  return BOTTOM;
    case LLQM_QUARK_FLAVOR_TOP:     return TOP;
    default:                        exit(EINVAL);
  }
}

LLQMColor LLQMQuarkGetColor(LLQMQuark quark) {
  switch (quark & LLQM_QUARK_COLOR_MASK) {
    case LLQM_QUARK_COLOR_RED:   return RED;
    case LLQM_QUARK_COLOR_GREEN: return GREEN;
    case LLQM_QUARK_COLOR_BLUE:  return BLUE;
    default:                     exit(EINVAL);
  }
}

double LLQMQuarkGetElectricCharge(LLQMQuark quark) {
  LLQM_QUARK_FOLD_TYPE(quark, 2.0 / 3.0, -1.0 / 3.0);
}
