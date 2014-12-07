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

### Packaging setup
include (InstallRequiredSystemLibraries)
set (CPACK_PACKAGE_DESCRIPTION_SUMMARY "Trut tagging utility")
set (CPACK_PACKAGE_VENDOR "haff")
set (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README")
set (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set (CPACK_PACKAGE_VERSION_MAJOR "${TRUT_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${TRUT_VERSION_MINOR}")
set (CPACK_PACKAGE_VERSION_PATCH "${TRUT_VERSION_PATCH}")
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME
  "${CMAKE_PROJECT_NAME}-${TRUT_VERSION_FULL}")
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
