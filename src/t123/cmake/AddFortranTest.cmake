# Optional fortran test.
MACRO( T123_AddOptionalFortranTest )
    IF(${PROJECT_NAME}_ENABLE_Fortran)
        t123AddFortranTest( ${ARGV} )
    ELSE()
        MESSAGE( STATUS "[Testing123] optional fortran test $ARGV0 is being disabled because ${PROJECT_NAME}_ENABLE_Fortran=${${PROJECT_NAME}_ENABLE_Fortran}...")
    ENDIF()
ENDMACRO()

# Required fortran test.
MACRO( t123AddFortranTest )
  # We'll pass the non-processed arguments to the add_test below.
  SET(args ${ARGV})
  LIST( GET args 0 test_file )
  LIST( REMOVE_AT args 0 )

  # Enable fortran goodies.
  botgEnableFortran( C_PREPROCESSOR UNLIMITED_LINE_LENGTH )

  #Enable pthread.
  botgAddCompilerFlags( Fortran "Clang|GNU" "Linux"
      "-pthread"
  )

  # Replace the "." with "_" to get a proper test name that will also
  # prevent collisions with C++/C tests of the same base name.
  STRING(REPLACE "." "_" test_name "${test_file}" )

  # First, we need to copy the file in.
  IF( NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${test_file}" )
    MESSAGE(FATAL_ERROR "[Testing123] test file for AddFortranTest(${CMAKE_CURRENT_SOURCE_DIR}/${test_file}) does not exist!")
  ENDIF()

  TRIBITS_COPY_FILES_TO_BINARY_DIR( COPY_${test_name}
      SOURCE_FILES
        ${test_file}
      DEST_FILES
        ${test_file}
  )

  # Then we need to run the C preprocessor on it.
  # The T123_AddFortranTest_INCLUDE_DIR is set in Testing123/src/CMakeLists.txt!
  SET(includes )
  IF( DEFINED T123_AddFortranTest_INCLUDE_DIR )
    STRING(STRIP ${T123_AddFortranTest_INCLUDE_DIR} T123_AddFortranTest_INCLUDE_DIR)
    LIST(APPEND includes "-I${T123_AddFortranTest_INCLUDE_DIR}" )
  ENDIF()
  # Add locals.
  GET_PROPERTY( dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES )
  FOREACH( dir ${dirs} )
    STRING(STRIP ${dir} dir)
    LIST(APPEND includes "-I${dir}" )
  ENDFOREACH()
  SET( copied_file "${CMAKE_CURRENT_BINARY_DIR}/${test_file}" )

  # This is a tricky way to deal with endsubroutine;endsubroutine being
  # invalid fortran. We want to remove { and replace } with the equivalent
  # of end subroutine ; end subroutine but on two lines. This is why we
  # couldn't use the c preprocessor--it has to be on one line for cpp.
  # The trickiest thing we do is put an include file in so we can keep
  # track of line numbers DESPITE having expanded } to two lines!
  SET( copied_n_file "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.newline.f90" )
  FILE( GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.newline.cmake" CONTENT
  "FILE( READ \"${copied_file}\" temp )\nSTRING( REPLACE \"{\" \"\" temp \"\${temp}\")\nSTRING( REGEX REPLACE \"[\\n] *![^\\n]*\" \"\\n\" temp \"\${temp}\")\nSTRING( REGEX REPLACE \"\\n *}\" \";end subroutine\n\#include \\\"t123/internal/TEST_END.f90i\\\"\" temp \"\${temp}\")\nFILE( WRITE \"${copied_n_file}\" \"\${temp}\" )"
  )
  ADD_CUSTOM_COMMAND(
    OUTPUT ${copied_n_file}
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.newline.cmake"
    VERBATIM
    DEPENDS ${copied_file}
  )

  # Now preprocess the file.
  SET( preprocessed_file "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.preprocessed.f90" )
  ADD_CUSTOM_COMMAND(
    OUTPUT "${preprocessed_file}"
    COMMAND gcc ${includes} -x c -E "${copied_n_file}" > "${preprocessed_file}"
    VERBATIM
    IMPLICIT_DEPENDS C "${copied_n_file}"
  )


  # Now we need to find/replace the binary location with the source location,
  # so the error messages look right.
  SET( final_file "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.f90" )
  FILE( GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.cmake" CONTENT
  "FILE( READ \"${preprocessed_file}\" temp )\nSTRING( REPLACE \"${copied_n_file}\" \"${CMAKE_CURRENT_SOURCE_DIR}/${test_file}\" temp \"\${temp}\")\nFILE( WRITE \"${final_file}\" \"\${temp}\" )"
  )
  ADD_CUSTOM_COMMAND(
    OUTPUT ${final_file}
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.cmake"
    VERBATIM
    DEPENDS ${preprocessed_file}
  )

  # Add both source and binary dirs for includes and fortran modules.
  INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_SOURCE_DIR}" )
  INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_BINARY_DIR}" )

  # Finally we can add the test with the final output.
  TRIBITS_ADD_EXECUTABLE_AND_TEST( ${test_name}
    SOURCES
      ${final_file}
    LINKER_LANGUAGE Fortran
    ${args}
  )


ENDMACRO()
