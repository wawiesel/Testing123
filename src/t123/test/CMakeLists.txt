#------------------------------------------------------------------------------
# Create normal C++ test executable with TriBITS test flag for a serial
# communicator (as opposed to MPI).
t123TestFile( tstTestFile.cc
    COMM serial
)

#------------------------------------------------------------------------------
# Create a compilation test.
t123TestFile( passThisCompiles.cc
  TEST_COMPILE
)

#------------------------------------------------------------------------------
# Create compilation test executable which contains TEST_COMPILE_CASE_*.
# A compilation test always needs to know whether it WILL_FAIL.
t123TestFile( failInternalTestCompileCase.cc
  WILL_FAIL
)

#------------------------------------------------------------------------------
# Create compilation test executable which does not contain
# TEST_COMPILE_CASE_* and therefore requires TEST_COMPILE.
# A compilation test always needs to know whether it WILL_FAIL.
t123TestFile( failNoInternalTestCompileCase.cc
  TEST_COMPILE
  WILL_FAIL
)

#------------------------------------------------------------------------------
# Simple test with return code 0.
t123TestFile( tstReturnCode0.cc )

#------------------------------------------------------------------------------
# Simple test with return code 1.
t123TestFile( tstReturnCode1.cc
  WILL_FAIL
)

#------------------------------------------------------------------------------
# Simple passing test with a regular expression.
t123TestFile( tstRegexPass.cc
  PASS_REGULAR_EXPRESSION "hello world"
)

#------------------------------------------------------------------------------
# Simple failing test with a regular expression.
t123TestFile( tstRegexFail.cc
  PASS_REGULAR_EXPRESSION "hello world"
  WILL_FAIL
)

#------------------------------------------------------------------------------
# Create normal Fortran test executable.
t123TestFile( tstTestFile.f90 )

#------------------------------------------------------------------------------
# Version which allows a file list (given files are not GTest but just return 0).
t123TestFiles(
    FILES
        tst1.cc
        tst2.cc
)

#------------------------------------------------------------------------------
# Compiler passing test (fails if it does find REGEX)
t123TestFile( passUnderCaseLimit.f90
    TEST_COMPILE
    FAIL_REGULAR_EXPRESSION "[Ee]rror"
)

#------------------------------------------------------------------------------
# Compiler failure test (fails if doesn't find REGEX).
t123TestFile( failOverCaseLimit.f90
    TEST_COMPILE
    FAIL_REGULAR_EXPRESSION "[Ee]rror"
    WILL_FAIL
)

#------------------------------------------------------------------------------
# Compiler passing test with multiple cases in the same file without
# indicating 'TEST_COMPILE' because file has TEST_COMPILE_CASE_*.

t123TestFile( tstPASSES.cc )

#------------------------------------------------------------------------------
# Compilation failure test (multiple cases in the same file)

#There are two ways to add other compilers.
# 1) Use BOTG variables to construct.
#IF( "${BOTG_CXX_COMPILER}" STREQUAL "Clang" )
#
#ELSEIF( "${BOTG_CXX_COMPILER}" STREQUAL "Intel" )
#
#ENDIF()
# 2) Just add the error message from other compilers as another one in the lists.
# Note, cannot use ; to separate values because that would make one long list
# out of everything in a CASE_*_REGULAR_EXPRESSION.
SET( REGEX_VectorNotDefined "undeclared identifier 'std'//‘vector’ is not a member of ‘std’" )
SET( REGEX_BadMath "expected (primary-)?expression" )
SET( REGEX_PrivateCtor "private constructor//is private" )

# This code will not compile, so it's natural state is failure.
# So to make it a stronger test, we will turn it into a "passing" test
# with a PASS expression that matches the begin of anything ^.
# Then we match for failure.
# Matching ANY of the FAIL REGEX, causes a failure.
# Matching ANY of the PASS REGEX, causes a pass.
t123TestFile( tstFAILS.cc
    PASS_REGULAR_EXPRESSION "^"
    CASE_FAIL_REGULAR_EXPRESSION
        VectorNotDefined "${REGEX_VectorNotDefined}"
        BadMath          "${REGEX_BadMath}"
        PrivateCtor      "${REGEX_PrivateCtor}"
    END_CASE_FAIL_REGULAR_EXPRESSION
    WILL_FAIL
)

