cmake_minimum_required (VERSION 2.8)

### Name of whole complex
set (PROJECT "tagtree")
set (PROJECT_CLI "tagtree-cli")
set (PROJECT_LIB "tagtree")
project (${PROJECT})

### Project directories
set (SOURCES_DIR "src")
set (INCLUDE_DIR "include")
set (BUILD_DIR "bin")

### Project source files
# common
set (HEADERS
  ${INCLUDE_DIR}/${PROJECT}/init.h)
# client
set (SOURCES_CLI
  ${SOURCES_DIR}/main.c)
set (HEADERS_CLI
  ${HEADERS})
# library
set (SOURCES_LIB
  ${SOURCES_DIR}/init.c)
set (HEADERS_LIB
  ${HEADERS})

include_directories (${INCLUDE_DIR})

### Build library
add_library (${PROJECT_LIB} SHARED ${SOURCES_LIB} ${HEADERS_LIB})
set_target_properties (${PROJECT_LIB}
  PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${BUILD_DIR})

### Build app
add_executable (${PROJECT_CLI} ${SOURCES_CLI} ${HEADERS_CLI})
set_target_properties (${PROJECT_CLI}
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${BUILD_DIR})
target_link_libraries(${PROJECT_CLI} ${PROJECT_LIB})
