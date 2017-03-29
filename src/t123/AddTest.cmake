MACRO( t123AddTest )
  SET( test_file "${ARGV0}")

  #First get the extension. It could be .f90 or .cpp or .f90.in
  GET_FILENAME_COMPONENT(extension "${test_file}" EXT)

  #Remove the last ".in" and first "." if it exists
  STRING(REGEX REPLACE "\\.in$" "" extension "${extension}")
  STRING(REGEX REPLACE "^\\." "" extension "${extension}")

  #Defines the extensions for each type.
  SET( CXX_match ";cpp;cxx;cc;C;" )
  SET( Fortran_match ";f90;f;F;f90i;" )

  #Call corresponding language-specific test configuration.
  SET(found false)
  FOREACH( lang CXX Fortran )
    IF( "${${lang}_match}" MATCHES ";${extension};" )
      IF( ${PROJECT_NAME}_ENABLE_${lang} )
        IF( ${lang} STREQUAL "CXX" )
          t123AddTest_CXX( "${ARGV}" )
        ELSE()
          t123AddTest_Fortran( "${ARGV}" )
        ENDIF()
      ELSE()
        MESSAGE( STATUS "[Testing123] test='${test_file}' disabled because ${PROJECT_NAME}_ENABLE_${lang}=${${PROJECT_NAME}_ENABLE_${lang}}...")
      ENDIF()
      SET(found true)
      BREAK()
    ENDIF()
  ENDFOREACH()

  IF( NOT found )
    MESSAGE(FATAL_ERROR "[Testing123] could not determine the language of the test='${test_file}'! CXX tests have extensions: ${CXX_match}. Fortran tests have extensions: ${Fortran_match}.")
  ENDIF()

ENDMACRO()
