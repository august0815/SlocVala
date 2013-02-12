
cmake_minimum_required (VERSION 2.6)
cmake_policy(VERSION 2.6)

project(Strip)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake )

#
# Base bits

set (GETTEXT_PACKAGE "Projekt")
set (RELEASE_NAME "Beschreibung")
set (VERSION "0.1")
set (VERSION_INFO "Release")


configure_file (${CMAKE_SOURCE_DIR}/src/config.h.cmake ${CMAKE_BINARY_DIR}/src/config.h)

add_subdirectory (src)
add_subdirectory (icons)
add_subdirectory (data)

