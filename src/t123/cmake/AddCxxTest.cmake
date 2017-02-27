MACRO( T123_AddCxxTest )
  SET(args ${ARGV})
  LIST( GET args 0 test_file )
  LIST( REMOVE_AT args 0 )

  #Enable pthread.
  BOTG_AddCompilerFlags( CXX ANY "Linux"
      "-pthread"
  )

  # Replace the "." with "_" to get a proper test name that will also
  # prevent collisions with C++/C tests of the same base name.
  STRING(REPLACE "." "_" test_name "${test_file}" )

  TRIBITS_ADD_EXECUTABLE_AND_TEST( ${test_name}
    SOURCES
      ${test_file}
    ${args}
  )

ENDMACRO()
