# coding: utf-8
# ===--------------------------------------------------------------------------------------------===
# Copyright © 2025 Supernova. All rights reserved.
#
# This file is part of the Deus open-source project.
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not,
# see https://www.gnu.org/licenses.
# ===--------------------------------------------------------------------------------------------===

class Conversion:
  def __init__(self, measurable_name: str, coefficient: float):
    self.measurable_name = measurable_name
    self.coefficient = coefficient

class Measurement:
  def __init__(
    self,
    implementation_name: str,
    base_unit_symbol: str,
    conversions: list[Conversion]
  ):
    self.implementation_name = implementation_name
    self.base_unit_symbol = base_unit_symbol
    self.conversions = conversions

def all_measurement_types() -> list[Measurement]:
  return [
    Measurement(
      implementation_name='Angle',
      base_unit_symbol='rad',
      conversions=[Conversion('radians', 1)]
    ),
    Measurement(
      implementation_name='ElectricCharge',
      base_unit_symbol='e',
      conversions=[Conversion('elementary', 1)]
    ),
    Measurement(
      implementation_name='Energy',
      base_unit_symbol='J',
      conversions=[Conversion('joules', 1), Conversion('electronvolts', 0)]
    ),
    Measurement(
      implementation_name='Mass',
      base_unit_symbol='kg',
      conversions=[
        Conversion('electronvoltsPerLightSpeedSquared', 1.78266192e-36),
        Conversion('gigaelectronvoltsPerLightSpeedSquared', 1.78266192e-27),
        Conversion('kilograms', 1),
        Conversion('megaelectronvoltsPerLightSpeedSquared', 1.78266192e-30)
      ]
    ),
    Measurement(
      implementation_name='Speed',
      base_unit_symbol='m/s',
      conversions=[Conversion('metersPerSecond', 1), Conversion('light', 299792458)]
    )
  ]
