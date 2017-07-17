# All internal unit test commands.
INCLUDE( t123/internal/PreprocessTestFile_Fortran.cmake )
INCLUDE( t123/internal/PreprocessTestFile_CXX.cmake )
INCLUDE( t123/internal/CheckForCompilationTest.cmake )
INCLUDE( t123/internal/ProcessCompilationTest.cmake )

# The most general test command.
MACRO( t123TestFiles )

  # Process arguments.
  SET(options TEST_COMPILE END_CASE_FAIL_REGULAR_EXPRESSION END_CASE_PASS_REGULAR_EXPRESSION)
  SET(one_value_args)
  SET(multi_value_args FILES CASE_PASS_REGULAR_EXPRESSION CASE_FAIL_REGULAR_EXPRESSION )
  CMAKE_PARSE_ARGUMENTS(T123_TF "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN} )

  # Check that FILES argument exists.
  IF( "${T123_TF_FILES}" STREQUAL "" )
    MESSAGE( FATAL_ERROR "[Testing123] t123Test must have FILES argument!")
  ENDIF()

  # For each of the test files.
  FOREACH( test_file ${T123_TF_FILES} )

    # Check existence.
    IF( NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${test_file}" )
      MESSAGE( FATAL_ERROR "[Testing123] test_file='${CMAKE_CURRENT_SOURCE_DIR}/${test_file}' does not exist!" )
    ENDIF()

    # Get any compile directives in the file first.
    t123CheckForCompilationTest( "${test_file}" case_list )

    # Default to NOT treating the file as a simple compile test.
    SET(do_test_compile FALSE)
    # If no compile directives found,
    IF( "${case_list}" STREQUAL "" )
      #and TEST_COMPILE TRUE, then we assume a case list of "Main".
      IF( T123_TF_TEST_COMPILE )
        SET(do_test_compile TRUE)
        SET(case_list "Main")
        MESSAGE( STATUS "[Testing123] setting implicit compilation test case_list='${case_list}' because TEST_COMPILE TRUE but no TEST_COMPILE_CASE directives were found!")
      ENDIF()
    ELSE()
      MESSAGE( STATUS "[Testing123] found compilation test case_list='${case_list}'")
      SET(do_test_compile TRUE)
    ENDIF()

    # Get the extension and remove the first "." if it exists
    GET_FILENAME_COMPONENT(extension "${test_file}" EXT)
    STRING(REGEX REPLACE "^\\." "" extension "${extension}")

    # Defines the extensions for each language.
    SET( CXX_match ";cpp;cxx;cc;C;" )
    SET( Fortran_match ";f90;f;F;f90i;" )

    # Call corresponding language-specific test configuration.
    SET(found false)
    FOREACH( lang CXX Fortran )

      IF( "${${lang}_match}" MATCHES ";${extension};" )
        IF( ${PROJECT_NAME}_ENABLE_${lang} )
          SET(output_test_file)
          #--------------------------------------------------------------------
          # C++
          IF( ${lang} STREQUAL "CXX" )
            t123PreprocessTestFile_CXX( "${test_file}"
              output_test_file
            )
          #--------------------------------------------------------------------
          # Fortran
          ELSEIF( ${lang} STREQUAL "Fortran" )
            t123PreprocessTestFile_Fortran( "${test_file}"
              output_test_file
            )
          #--------------------------------------------------------------------
          # Bad Language
          ELSE()
            MESSAGE( FATAL_ERROR "[Testing123] PROGRAMMER ERROR: lang=${lang}")
          ENDIF()
          #--------------------------------------------------------------------
          MESSAGE(STATUS "[Testing123] continuing to build test='${PACKAGE_NAME}_${test_name}' from file='${output_test_file}'")
          #--------------------------------------------------------------------
          # Add a compile test for each case.
          IF( do_test_compile )
            SET(test_list)
            FOREACH( case ${case_list} )
              t123ProcessCompilationTest(
                "${output_test_file}"
                "${lang}"
                "${test_name}"
                "${case}"
                "${T123_TF_CASE_PASS_REGULAR_EXPRESSION}"
                "${T123_TF_CASE_FAIL_REGULAR_EXPRESSION}"
                ${T123_TF_UNPARSED_ARGUMENTS}
              )
              LIST(APPEND test_list "${PACKAGE_NAME}_${test_name}.${case}")
            ENDFOREACH()
            # Do not allow cases in the same suite to run in parallel.
            SET_TESTS_PROPERTIES(${test_list}
              PROPERTIES
                RUN_SERIAL TRUE
            )
          #--------------------------------------------------------------------
          # Add normal Tribits test.
          ELSE()
            MESSAGE(STATUS "[Testing123] registering test='${PACKAGE_NAME}_${test_name}' with TriBITS")
            TRIBITS_ADD_EXECUTABLE_AND_TEST( ${test_name}
              SOURCES
                ${output_test_file}
              LINKER_LANGUAGE
                ${lang}
              ${T123_TF_UNPARSED_ARGUMENTS}
            )
          ENDIF()
        #----------------------------------------------------------------------
        # Language not enabled
        ELSE()
          MESSAGE( STATUS "[Testing123] test='${test_file}' disabled because ${PROJECT_NAME}_ENABLE_${lang}=${${PROJECT_NAME}_ENABLE_${lang}}...")
        ENDIF()
        #----------------------------------------------------------------------
        SET(found true)
        BREAK()
      ENDIF()

    ENDFOREACH() #lang loop

    IF( NOT found )
      MESSAGE(FATAL_ERROR "[Testing123] could not determine the language of the test='${test_file}'! CXX tests have extensions: ${CXX_match}. Fortran tests have extensions: ${Fortran_match}.")
    ENDIF()

  ENDFOREACH() #file loop

ENDMACRO()

