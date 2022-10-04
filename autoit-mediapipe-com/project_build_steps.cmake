message(STATUS "BUILD_STEP: ${BUILD_STEP}")

if("${BUILD_STEP}" STREQUAL "patch")
    foreach(item ${PATCH_FILE})
        message(STATUS "patch -d '${SOURCE_DIR}' -p1 -i '${item}' -N --dry-run -R")
        execute_process(
            COMMAND patch -p1 -i "${item}" -N --dry-run -R
            WORKING_DIRECTORY "${SOURCE_DIR}"
            RESULT_VARIABLE retval
            ERROR_QUIET
            COMMAND_ECHO STDOUT
        )
        if(NOT ${retval} EQUAL "0")
            message(STATUS "patch -d '${SOURCE_DIR}' -p1 -i '${item}'")
            execute_process(COMMAND patch -p1 -i "${item}" WORKING_DIRECTORY "${SOURCE_DIR}")
        endif()
    endforeach()
endif()
