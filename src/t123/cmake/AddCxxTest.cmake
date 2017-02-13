MACRO( ADD_CXX_TEST )
  SET(args ${ARGV})
  LIST( GET args 0 test_file )
  LIST( REMOVE_AT args 0 )

  GET_FILENAME_COMPONENT( test_file_we ${test_file} NAME_WE )
  TRIBITS_ADD_EXECUTABLE_AND_TEST( ${test_file_we}
    SOURCES
      ${test_file}
    ${args}
  )
  #TARGET_LINK_LIBRARIES( ${PACKAGE_NAME}_${test_file_we} TestExe )

ENDMACRO()
