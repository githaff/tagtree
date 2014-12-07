set (SOURCES
  main.c)
set (HEADERS
  config.h)

find_package (extopts)
include_directories(${EXTOPTS_INCLUDE_DIR})

configure_file(config.h.in config.h @ONLY)

### Build app
add_executable (${PROJECT_CLI} ${SOURCES} ${HEADERS})
set_target_properties (${PROJECT_CLI}
  PROPERTIES
  OUTPUT_NAME ${PROJECT}
  RUNTIME_OUTPUT_DIRECTORY ${BUILD_DIR})
target_link_libraries(${PROJECT_CLI} ${PROJECT})
target_link_libraries (${PROJECT_CLI} ${EXTOPTS_LIBRARY})

install (TARGETS ${PROJECT_CLI} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
