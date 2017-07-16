# Need this so that the macro can find the right directory.
GLOBAL_SET( T123_TestFile_Fortran_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}")

# Required fortran test.
MACRO( t123PreprocessTestFile_Fortran TEST_FILE OUTPUT_TEST_FILE )

    # Enable pthread.
    botgAddLinkerFlags( Clang|GNU Linux "-pthread" )
    botgEnableFortran(
        C_PREPROCESSOR
        UNLIMITED_LINE_LENGTH
    )

    # Replace the "." with "_" to get a proper test name that will also
    # prevent collisions with C++/C tests of the same base name.
    STRING(REPLACE "." "_" test_name "${TEST_FILE}" )
    MESSAGE(STATUS "[Testing123] preprocessing Fortran test='${test_name}' from test_file='${TEST_FILE}'.")

    # First, we need to copy the file in.
    SET(original_file "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_FILE}")
    IF( NOT EXISTS "${original_file}" )
      MESSAGE(FATAL_ERROR "[Testing123] Fortran test_file='${original_file}' does not exist!")
    ENDIF()

    SET( copied_file "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.1-copied.f90" )
    ADD_CUSTOM_COMMAND(
        OUTPUT "${copied_file}"
        COMMAND ${CMAKE_COMMAND} -E copy  "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_FILE}" "${copied_file}"
        VERBATIM
        DEPENDS "${original_file}"
    )

    # Then we need to run the C preprocessor on it.
    # The T123_TestFile_Fortran_INCLUDE_DIR is set in Testing123/src/CMakeLists.txt!
    SET(includes )
    IF( DEFINED T123_TestFile_Fortran_INCLUDE_DIR )
        STRING(STRIP ${T123_TestFile_Fortran_INCLUDE_DIR} T123_TestFile_Fortran_INCLUDE_DIR)
        LIST(APPEND includes "-I${T123_TestFile_Fortran_INCLUDE_DIR}" )
    ENDIF()

    # Add locals.
    GET_PROPERTY( dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES )
    FOREACH( dir ${dirs} )
        STRING(STRIP ${dir} dir)
        LIST(APPEND includes "-I${dir}" )
    ENDFOREACH()

    # This is a tricky way to deal with endsubroutine;endsubroutine being
    # invalid fortran. We want to replace 'END TEST' with the equivalent
    # of end subroutine ; end subroutine but on two lines. This is why we
    # couldn't use the c preprocessor--it has to be on one line for cpp.
    # The trickiest thing we do is put an include file in so we can keep
    # track of line numbers DESPITE having expanded 'END TEST' to two lines!
    SET( regexed_file "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.2-regexed.f90" )
    SET( regexed_cmake "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.2-regexed.cmake" )
    FILE( GENERATE OUTPUT "${regexed_cmake}" CONTENT
    "FILE( READ \"${copied_file}\" temp )\nSTRING( REGEX REPLACE \"[\\n] *![^\\n]*\" \"\\n\" temp \"\${temp}\")\nSTRING( REGEX REPLACE \"\\n *END *TEST\" \";end subroutine\n\#include \\\"t123/internal/TEST_END.f90i\\\"\" temp \"\${temp}\")\nFILE( WRITE \"${regexed_file}\" \"\${temp}\" )"
    )
    ADD_CUSTOM_COMMAND(
        OUTPUT "${regexed_file}"
        COMMAND "${CMAKE_COMMAND}" -P "${regexed_cmake}"
        VERBATIM
        DEPENDS "${copied_file}"
    )

    # Now preprocess the file.
    SET( preprocessed_file "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.3-preprocessed.f90" )
    ADD_CUSTOM_COMMAND(
        OUTPUT "${preprocessed_file}"
        COMMAND gcc ${includes} -x c -E "${regexed_file}" > "${preprocessed_file}"
        VERBATIM
        IMPLICIT_DEPENDS C "${regexed_file}"
    )


    # Now we need to find/replace the binary location with the source location,
    # so the error messages look right.
    SET( final_file "${CMAKE_CURRENT_BINARY_DIR}/${TEST_FILE}" )
    SET( final_cmake "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.cmake" )
    FILE( GENERATE OUTPUT "${final_cmake}" CONTENT
    "FILE( READ \"${preprocessed_file}\" temp )\nSTRING( REPLACE \"${regexed_file}\" \"${original_file}\" temp \"\${temp}\")\nFILE( WRITE \"${final_file}\" \"\${temp}\" )"
    )
    ADD_CUSTOM_COMMAND(
        OUTPUT "${final_file}"
        COMMAND "${CMAKE_COMMAND}" -P "${final_cmake}"
        VERBATIM
        DEPENDS "${preprocessed_file}"
    )

    # Add both source and binary dirs for includes and fortran modules.
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_SOURCE_DIR}" )
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_BINARY_DIR}" )

    # Set output variable.
    SET( ${OUTPUT_TEST_FILE} "${final_file}" )
ENDMACRO()
