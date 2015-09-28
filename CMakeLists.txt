cmake_minimum_required (VERSION 2.8)

### Name of whole complex
set (PROJECT "tone")
set (PROJECT_CLI "tone-cli")
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

### Version control
include (git-ver)

include_directories (${INCLUDE_DIR})

## Installation paths if not specified
if (NOT DEFINED CMAKE_INSTALL_BINDIR)
  set (CMAKE_INSTALL_BINDIR "bin")
endif (NOT DEFINED CMAKE_INSTALL_BINDIR)
if (NOT DEFINED CMAKE_INSTALL_LIBDIR)
  set (CMAKE_INSTALL_LIBDIR "lib")
endif (NOT DEFINED CMAKE_INSTALL_LIBDIR)
if (NOT DEFINED CMAKE_INSTALL_INCLUDEDIR)
  set (CMAKE_INSTALL_INCLUDEDIR "include")
endif (NOT DEFINED CMAKE_INSTALL_INCLUDEDIR)
set (CMAKE_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/${PROJECT}")

### Project source files
## public include files
set (HEADERS_PUBLIC
  ${INCLUDE_DIR}/${PROJECT}/tone.h)
install (FILES ${HEADERS_PUBLIC} DESTINATION
  "${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT}")
## tests
set (TESTS_BIN
  ${TESTS_DIR}/main.sh)

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
configure_file(tone.pc.in tone.pc @ONLY)
install (FILES tone.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

### CMake find module generation
set (TONE_INCLUDE_DIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_INCLUDEDIR}")
set (TONE_LIB_DIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
configure_file(tone-config.cmake.in tone-config.cmake @ONLY)
configure_file(tone-config-version.cmake.in tone-config-version.cmake @ONLY)
install (FILES tone-config.cmake
  DESTINATION ${CMAKE_INSTALL_CMAKEDIR})
install (FILES tone-config-version.cmake
  DESTINATION ${CMAKE_INSTALL_CMAKEDIR})

### Packaging setup
include (InstallRequiredSystemLibraries)
set (CPACK_PACKAGE_DESCRIPTION_SUMMARY "Tone tagging utility")
set (CPACK_PACKAGE_VENDOR "haff")
set (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set (CPACK_PACKAGE_VERSION_MAJOR "${TONE_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${TONE_VERSION_MINOR}")
set (CPACK_PACKAGE_VERSION_PATCH "${TONE_VERSION_PATCH}")
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME
  "${CMAKE_PROJECT_NAME}-${TONE_VERSION_FULL}")
set (CPACK_SOURCE_IGNORE_FILES
  ".*~"
  "#.*#"
  ".*.tar.gz"
  ".*.pc$"
  "/.git"
  "/build"
  "/_CPack_Packages"
  ".gitignore"
  "CMakeCache.txt"
  "CMakeFiles"
  "CPackConfig.cmake"
  "CPackSourceConfig.cmake"
  "Makefile"
  "cmake_install.cmake"
  "install_manifest.txt"
)
include (CPack)
## Add alias to default 'dist' target
add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)
