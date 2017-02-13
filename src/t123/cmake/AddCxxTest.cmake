MACRO( ADD_CXX_TEST )
  SET(args ${ARGV})
  LIST( GET args 0 test_file )
  LIST( REMOVE_AT args 0 )

  #Enable pthread.
  BOTG_AddCompilerFlags( CXX ANY "Linux"
      "-pthread"
  )

  GET_FILENAME_COMPONENT( test_file_we ${test_file} NAME_WE )
  TRIBITS_ADD_EXECUTABLE_AND_TEST( ${test_file_we}
    SOURCES
      ${test_file}
    ${args}
  )

ENDMACRO()
