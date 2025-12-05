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

from datetime import date
from inspect import stack
from pathlib import Path

def header() -> str:
  """Generates a comment to be placed at beginning of a Swift file, before imports, declarations or
  expressions, containing a notice about the licence of the project. Every Swift file generated from
  a GYB template **should** have the return of this function as its first lines.

  The maximum amount of characters within a line is implied to be 100. Whenever a change to that
  amount occurs, the returned license header should be updated accordingly.
  """

  caller_file_path = Path(stack()[0].filename)
  caller_file_creation_year = date.fromtimestamp(caller_file_path.stat().st_birthtime).year
  return f"""// ===-------------------------------------------------------------------------------------------===
  // Copyright © {caller_file_creation_year} Supernova. All rights reserved.
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
  """
