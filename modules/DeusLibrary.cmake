#[[
Copyright © 2026 Supernova

This file is part of the Deus open-source project.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see https://www.gnu.org/licenses.
]]

# Performs configuration common to all libraries of Deus. One of the steps
# involved is defining the directories included into the specified target; these
# directories contain dependencies belonging to Deus and external ones.
function(set_up_library target_name)
  target_include_directories(${target_name} PUBLIC ${CMAKE_SOURCE_DIR}/include)
endfunction()
