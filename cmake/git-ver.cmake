### Version control policy
###
### Extract current version from version control if present.  If
### source is not under source control - take from .version
### file. Otherwise current version is 0.0

## Get version
if (EXISTS "${CMAKE_SOURCE_DIR}/.git")
  execute_process (COMMAND git describe
    OUTPUT_VARIABLE GIT_TAG_VERSION)
else ()
  if (EXISTS "${CMAKE_SOURCE_DIR}/.version")
    execute_process (COMMAND cat .version
      OUTPUT_VARIABLE GIT_TAG_VERSION)
  endif ()
endif ()

## Parse version
if (NOT GIT_TAG_VERSION)
  message (WARNING "No version information was found! "
    "Package should be built from correct source tree.")
  set (TONE_VERSION_MAJOR 0)
  set (TONE_VERSION_MINOR 0)
  set (TONE_VERSION_PATCH 0)
else ()
  execute_process (COMMAND echo "${GIT_TAG_VERSION}"
    COMMAND sed -ne "s/^v\\([[:digit:]]*\\)\\..*/\\1/p"
    OUTPUT_VARIABLE TONE_VERSION_MAJOR
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process (COMMAND echo "${GIT_TAG_VERSION}"
    COMMAND sed -ne "s/^v[[:digit:]]*\\.\\([[:digit:]]*\\)\\..*/\\1/p"
    OUTPUT_VARIABLE TONE_VERSION_MINOR
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process (COMMAND echo "${GIT_TAG_VERSION}"
    COMMAND sed -ne "s/^v[[:digit:]]*\\.[[:digit:]]*\\.\\([[:digit:]]*\\).*/\\1/p"
    OUTPUT_VARIABLE TONE_VERSION_PATCH
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process (COMMAND echo "${GIT_TAG_VERSION}"
    COMMAND sed -ne "s/.*-\\(.*\\)/\\1/p"
    OUTPUT_VARIABLE TONE_VERSION_DIRT
    OUTPUT_STRIP_TRAILING_WHITESPACE)
endif ()

## Compose version strings
set (TONE_VERSION "${TONE_VERSION_MAJOR}.${TONE_VERSION_MINOR}.${TONE_VERSION_PATCH}")
if (TONE_VERSION_DIRT)
  set (TONE_VERSION_FULL "${TONE_VERSION}-${TONE_VERSION_DIRT}")
else ()
  set (TONE_VERSION_FULL "${TONE_VERSION}")
endif ()

## Create version file
file (WRITE .version "v${TONE_VERSION_FULL}")

message (STATUS "Building version: ${TONE_VERSION_FULL}")
