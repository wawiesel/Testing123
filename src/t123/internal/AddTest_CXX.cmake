MACRO( t123AddTest_CXX test_file )

    #Enable pthread.
    botgAddLinkerFlags( Clang|GNU Linux "-pthread" )

    # Replace the "." with "_" to get a proper test name that will also
    # prevent collisions with Fortran/C tests of the same base name.
    STRING(REPLACE "." "_" test_name "${test_file}" )
    MESSAGE(STATUS "[Testing123] adding CXX test=${test_name} from test_file='${test_file}'.")

    # Add both source and binary dirs for normal and configured headers.
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_SOURCE_DIR}" )
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_BINARY_DIR}" )

    TRIBITS_ADD_EXECUTABLE_AND_TEST( ${test_name}
        SOURCES
            ${test_file}
        LINKER_LANGUAGE
            CXX
        ${ARGN}
    )

ENDMACRO()
