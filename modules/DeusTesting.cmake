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

include(DeusLibrary)

# Performs configuration common to every testing library of Deus, including both
# internal and external dependencies for production code; and ones specific for
# testing, such as the doctest framework.
function(set_up_testing target_name)
  set_up_library(${target_name})
  target_include_directories(${target_name} PRIVATE
    ${CMAKE_SOURCE_DIR}/external/testing)
endfunction()
