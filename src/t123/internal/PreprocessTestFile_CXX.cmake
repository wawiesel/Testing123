MACRO( t123PreprocessTestFile_CXX TEST_FILE OUTPUT_TEST_FILE )

    # Enable pthread.
    botgAddLinkerFlags( Clang|GNU Linux "-pthread" )

    # Replace the "." with "_" to get a proper test name that will also
    # prevent collisions with Fortran/C tests of the same base name.
    STRING(REPLACE "." "_" test_name "${TEST_FILE}" )
    MESSAGE(STATUS "[Testing123] preprocessing CXX test='${test_name}' from test_file='${TEST_FILE}'.")

    # Add both source and binary dirs for normal and configured headers.
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_SOURCE_DIR}" )
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_BINARY_DIR}" )

    # Set output variables.
    SET( ${OUTPUT_TEST_FILE} "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_FILE}" )
ENDMACRO()
