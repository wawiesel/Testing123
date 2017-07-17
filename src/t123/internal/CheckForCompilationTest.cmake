# Returns a fully-qualified list of test cases for this file
# based on #ifdef TEST_COMPILE_CASE_<case> found in the file.
MACRO( t123CheckForCompilationTest TEST_FILE CASE_LIST )

  #Extract TEST_COMPILE_CASE_<case> directives so multiple "mains"
  #can be in one file.
  FILE(READ "${TEST_FILE}" contents)
  STRING(REGEX MATCHALL
    "#ifdef *TEST_COMPILE_CASE_[A-Za-z]+[A-Za-z_0-9]*"
    case_list0
    "${contents}"
  )

  #Get the name of each case.
  SET(case_list)
  FOREACH( case0 ${case_list0} )
    STRING( REGEX REPLACE "#ifdef *TEST_COMPILE_CASE_" "" case "${case0}")
    LIST(APPEND case_list ${case})
  ENDFOREACH()

  #Update list to return.
  SET(${CASE_LIST} "${case_list}" )

ENDMACRO()

