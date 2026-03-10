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

#include <errno.h>
#include <LLQM/LLQMColor.h>
#include <LLQM/LLQMQuark.h>
#include <stdlib.h>

#define LLQM_QUARK_FLAVOR_MASK  0b11100000
#define LLQM_QUARK_COLOR_MASK   0b00011000

LLQMQuarkFlavor LLQMQuarkGetFlavor(LLQMQuark quark) {
  switch (quark & LLQM_QUARK_FLAVOR_MASK) {
    case 0b00000000:  return UP;
    case 0b00100000:  return DOWN;
    case 0b01000000:  return CHARM;
    case 0b01100000:  return STRANGE;
    case 0b10000000:  return BOTTOM;
    case 0b10100000:  return TOP;
    default:          exit(EINVAL);
  }
}

LLQMColor LLQMQuarkGetColor(LLQMQuark quark) {
  switch (quark & LLQM_QUARK_COLOR_MASK) {
    case 0b00000000: return RED;
    case 0b00001000: return GREEN;
    case 0b00010000: return BLUE;
    default:         exit(EINVAL);
  }
}

double LLQMQuarkGetElectricCharge(LLQMQuark quark) {
  switch (LLQMQuarkGetFlavor(quark)) {
    case UP:      return 2 / 3;
    case DOWN:    return -1 / 3;
    case CHARM:   return 2 / 3;
    case STRANGE: return -1 / 3;
    case BOTTOM:  return -1 / 3;
    case TOP:     return 2 / 3;
    default:      exit(EINVAL);
  }
}
