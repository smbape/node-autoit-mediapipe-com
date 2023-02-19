math(EXPR ARGS_END "${CMAKE_ARGC} - 1" OUTPUT_FORMAT DECIMAL)
math(EXPR ARGS_LAST "${CMAKE_ARGC} - 2" OUTPUT_FORMAT DECIMAL)

set(destination "${CMAKE_ARGV${ARGS_END}}")
set(glob_args files)

set(START_PARSE OFF)
foreach(n RANGE 0 ${ARGS_LAST})
    if ("${CMAKE_ARGV${n}}" STREQUAL "--")
        set(START_PARSE ON)
        continue()
    endif()

    if (NOT START_PARSE)
        continue()
    endif()

    list(APPEND glob_args "${CMAKE_ARGV${n}}")
endforeach()

file(GLOB ${glob_args})
file(COPY ${files} DESTINATION ${destination})
