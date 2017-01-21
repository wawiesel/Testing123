FUNCTION( ADD_FORTRAN_TEST )
  # We'll pass the non-processed arguments to the add_test below.
  SET(args ${ARGV})
  LIST( GET args 0 test_file )
  LIST( REMOVE_AT args 0 )

  # Get the name without the extension and make some other key names.
  GET_FILENAME_COMPONENT( test_file_we ${test_file} NAME_WE )
  SET( test_name ${test_file_we}_f )
  SET( copied_file ${test_name}.copied.f90 )
  # First, we need to copy the file in.
  TRIBITS_COPY_FILES_TO_BINARY_DIR( ${test_name}_copied
      SOURCE_FILES
        ${test_file}
      DEST_FILES
        ${copied_file}
  )

  # Then we need to run the C preprocessor on it, for which we need to
  # generate an includes list.
  GET_PROPERTY(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
  SET( includes "" )
  FOREACH(dir ${dirs})
    STRING(STRIP ${dir} dir)
    LIST(APPEND includes -I${dir} )
  ENDFOREACH()
  SET( copied_file ${CMAKE_CURRENT_BINARY_DIR}/${copied_file} )
  SET( preprocessed_file ${CMAKE_CURRENT_BINARY_DIR}/${test_name}.preprocessed.f90 )
  ADD_CUSTOM_COMMAND(
    OUTPUT ${preprocessed_file}
    COMMAND gcc ${includes} -x c -E ${copied_file} > ${preprocessed_file}
    VERBATIM
    DEPENDS ${copied_file}
  )

  # Now we need to find/replace the binary location with the source location,
  # so the error messages look right.
  SET( final_file ${CMAKE_CURRENT_BINARY_DIR}/${test_name}.f90 )
  FILE( GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.cmake" CONTENT
  "FILE( READ \"${preprocessed_file}\" temp )\nSTRING( REPLACE \"${CMAKE_CURRENT_BINARY_DIR}\" \"${CMAKE_CURRENT_SOURCE_DIR}\" temp \"\${temp}\")\nFILE( WRITE \"${final_file}\" \"\${temp}\" )"
  )
  ADD_CUSTOM_COMMAND(
    OUTPUT ${final_file}
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${test_name}.cmake"
    VERBATIM
    DEPENDS ${preprocessed_file}
  )

  # Finally we can add the test with the final output.
  TRIBITS_ADD_EXECUTABLE_AND_TEST( ${test_name}
    SOURCES
      ${final_file}
    LINKER_LANGUAGE Fortran
    ${args}
  )


ENDFUNCTION()
