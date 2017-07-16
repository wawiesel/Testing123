INCLUDE( t123/TestFiles.cmake )

# Register a single test file.
MACRO( t123TestFile test_file )

  # Call general driver (unparsed arguments MUST be first).
  t123TestFiles(
    "${ARGN}"
    FILES
      "${test_file}"
  )

ENDMACRO()

