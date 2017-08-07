# Macro to process the case-specific regex.
MACRO( t123ProcessRegexList REGEX_BASE TEST_CASE CASE_REGEX REGEX_LIST)
  SET(regex_list "${REGEX_BASE}")
  # Macro arguments are NOT variables so we need to set local to proceed.
  SET(case_regex "${CASE_REGEX}")
  LIST(LENGTH case_regex len)
  IF( "${len}" GREATER 0 )
    MATH(EXPR max "${len}-1")
    #these are CASE REGEX pairs
    #loop over case names
    FOREACH(n RANGE 0 ${max} 2 )
      LIST(GET case_regex ${n} case0)
      IF( "${case0}" STREQUAL "${TEST_CASE}" )
        MATH(EXPR m "${n}+1")
        LIST(GET case_regex ${m} regex0)
        LIST(APPEND regex_list "${regex0}")
      ENDIF()
    ENDFOREACH()
  ENDIF()
  # // have to be used to separate the REGEX
  STRING(REPLACE "//" ";" ${REGEX_LIST} "${regex_list}" )
ENDMACRO()

# Process the test file as a compilation test.
MACRO( t123ProcessCompilationTest TEST_FILE LANG TEST_NAME TEST_CASE CASE_PASS_REGEX CASE_FAIL_REGEX)

  # For some reason, versions less than 3.6 produce erratic behavior with these
  # compilation failure tests.
  CMAKE_MINIMUM_REQUIRED(VERSION 3.6)

  # Process WILL_FAIL flag.
  SET(options WILL_FAIL)
  SET(one_value_args PASS_REGULAR_EXPRESSION FAIL_REGULAR_EXPRESSION)
  SET(multi_value_args)
  CMAKE_PARSE_ARGUMENTS(T123_PCT "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # Get regex.
  t123ProcessRegexList( "${T123_PCT_PASS_REGULAR_EXPRESSION}" "${TEST_CASE}" "${CASE_PASS_REGEX}" pass_regex )
  t123ProcessRegexList( "${T123_PCT_FAIL_REGULAR_EXPRESSION}" "${TEST_CASE}" "${CASE_FAIL_REGEX}" fail_regex )

  # Add the executable.
  TRIBITS_ADD_EXECUTABLE( "${TEST_NAME}.${TEST_CASE}"
    SOURCES
      "${TEST_FILE}"
    LINKER_LANGUAGE
      ${LANG}
    ${T123_PCT_UNPARSED_ARGUMENTS}
  )

  # Create the full test name (Above, TriBITS prepends the PACKAGE_NAME).
  SET( full_test_name "${PACKAGE_NAME}_${TEST_NAME}.${TEST_CASE}")
  MESSAGE(STATUS "[Testing123] registering test='${full_test_name}' as a compilation test with WILL_FAIL='${T123_PCT_WILL_FAIL}' and PASS_REGULAR_EXPRESSION='${pass_regex}' and FAIL_REGULAR_EXPRESSION='${fail_regex}'")

  # Target properties.
  SET_TARGET_PROPERTIES("${full_test_name}"
    PROPERTIES
      EXCLUDE_FROM_ALL TRUE
      EXCLUDE_FROM_DEFAULT_BUILD TRUE
  )

  # Define the variable TEST_COMPILE_CASE_<test_case>.
  TARGET_COMPILE_DEFINITIONS("${full_test_name}"
    PRIVATE
      "TEST_COMPILE_CASE_${TEST_CASE}"
  )

  # Add the test that just builds the target.
  ADD_TEST(
    NAME
      "${full_test_name}"
    COMMAND
      ${CMAKE_COMMAND} --build . --target "${full_test_name}" --config $<CONFIGURATION>
    WORKING_DIRECTORY
      ${CMAKE_BINARY_DIR}
  )

  # Create variables we can paste directly.
  IF( pass_regex )
    SET(pass_regex "PASS_REGULAR_EXPRESSION \"${pass_regex}\"")
  ENDIF()
  IF( fail_regex )
    SET(fail_regex "FAIL_REGULAR_EXPRESSION \"${fail_regex}\"")
  ENDIF()

  # Modify the test properties to check failure.
  SET_TESTS_PROPERTIES( "${full_test_name}"
    PROPERTIES
      WILL_FAIL ${T123_PCT_WILL_FAIL}
      "${pass_regex}"
      "${fail_regex}"
  )

ENDMACRO()
