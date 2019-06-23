# Copyright 2017 Pedro Cuadra <pjcuadra@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Define project
project(neopixel)

# Define required cmake version
cmake_minimum_required(VERSION 2.8)

# Include macros
include(cmake/macros.cmake)
include(cmake/vhdl_test_macros.cmake)

# Enable testing
enable_testing()

add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND})

# Parse all sources
add_subdirectory(vhdl/)

add_custom_target(index ALL COMMAND ghdl -i --std=08 --workdir=${CMAKE_CURRENT_BINARY_DIR} ${VHDL_SOURCES})

# Add compile test target
set(CTEST_OUTPUT_ON_FAILURE 1)
