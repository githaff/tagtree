cmake_minimum_required (VERSION 2.8)

### Name of whole complex
set (PROJECT "trut")
set (PROJECT_CLI "trut-cli")
project (${PROJECT})

# Set compile parameters
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11 -O0 -g3 -ggdb")
# Set additional warnings
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-long-long -pedantic")

### Project directories
set (CMAKE_MODULE_PATH "cmake")
set (SOURCES_DIR "${CMAKE_SOURCE_DIR}/src")
set (SOURCES_CLI_DIR "${SOURCES_DIR}/cli")
set (INCLUDE_DIR "${CMAKE_SOURCE_DIR}/include")
set (TESTS_DIR "${CMAKE_SOURCE_DIR}/tests")
set (BUILD_DIR "${CMAKE_SOURCE_DIR}/build")
if (NOT EXISTS "${BUILD_DIR}")
  file (MAKE_DIRECTORY "${BUILD_DIR}")
endif()

### Project source files
## tests
set (TESTS_BIN
  ${TESTS_DIR}/main.sh)

### Version control
include (git-ver)

include_directories (${INCLUDE_DIR})

add_subdirectory (${SOURCES_DIR})
add_subdirectory (${SOURCES_CLI_DIR})

### Tests execution target
add_custom_target ("tests"
  DEPENDS ${PROJECT_CLI}
  COMMENT "Running tests")
add_custom_command (
  COMMAND sh
  ARGS ${TESTS_BIN}
  TARGET "tests")

### Pkg-config generation
set(prefix ${CMAKE_INSTALL_PREFIX})
configure_file(trut.pc.in trut.pc @ONLY)
install (FILES trut.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

### CMake find module generation
configure_file(trut-config.cmake.in trut-config.cmake @ONLY)
configure_file(trut-config-version.cmake.in trut-config-version.cmake @ONLY)
