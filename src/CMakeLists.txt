set (SOURCES
  init.c)

### Build library
add_library (${PROJECT} SHARED ${SOURCES} ${HEADERS})
set_target_properties(${PROJECT} PROPERTIES OUTPUT_NAME ${PROJECT}) 
set_target_properties (${PROJECT}
  PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY ${BUILD_DIR})
