execute_process (
    COMMAND ${GIT_EXECUTABLE} rev-list --tags --max-count=1
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE EXITCODE1
    OUTPUT_VARIABLE TAGHASH
    OUTPUT_STRIP_TRAILING_WHITESPACE)

execute_process (
    COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE EXITCODE2
    OUTPUT_VARIABLE COMMITHASH
    OUTPUT_STRIP_TRAILING_WHITESPACE)

string (COMPARE EQUAL "${EXITCODE1}:${EXITCODE2}" "0:0" SUCCESS)
if (SUCCESS)
    set(OPENMW_VERSION_COMMITHASH "${COMMITHASH}")
    set(OPENMW_VERSION_TAGHASH "${TAGHASH}")
    message(STATUS "OpenMW version ${OPENMW_VERSION}")
else (SUCCESS)
    message(WARNING "Failed to get valid version information from Git")
endif (SUCCESS)

configure_file(${VERSION_IN_FILE} ${VERSION_FILE})
