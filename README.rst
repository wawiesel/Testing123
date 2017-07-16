Testing123 |build|
==================

.. |build| image:: https://travis-ci.org/wawiesel/Testing123.svg?branch=master
    :target: https://travis-ci.org/wawiesel/Testing123

CMake_/TriBITS_ unit testing for C++/Fortran

.. image:: https://c1.staticflickr.com/4/3884/33135230286_66ec1153a4_b.jpg

Testing123 provides a ``t123TestFile`` CMake macro for a declaring a "test
file". A "test file" can contain:

- tests with GoogleTest_ macros in C++
- tests with GoogleTest_-like macros in Fortran
- tests which pass/fail based on the return code (zero/non-zero)
- tests which pass/fail if STDOUT matches something
- tests to confirm a code block compiles
- tests to confirm a code block does not compile


your/test/CMakeLists.txt
------------------------

Here's an example of usage. There is a CMakeLists.txt file that sits in a
special "test" directory (the name can be anything). These files are actually
the test files for this project.

::

    your/test/
    ├── CMakeLists.txt
    ├── failInternalTestCompileCase.cc
    ├── failNoInternalTestCompileCase.cc
    ├── failOverCaseLimit.f90
    ├── passThisCompiles.cc
    ├── passUnderCaseLimit.f90
    ├── tst1.cc
    ├── tst2.cc
    ├── tstFAILS.cc
    ├── tstPASSES.cc
    ├── tstRegexFail.cc
    ├── tstRegexPass.cc
    ├── tstReturnCode0.cc
    ├── tstReturnCode1.cc
    ├── tstTestFile.cc
    └── tstTestFile.f90

The CMakeLists.txt file contains ``t123TestFile`` macro calls to register
the various tests.

.. code-block:: cmake

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

The output of ``ctest`` would look something like this.

::

    Test project /Users/ww5/dev/Testing123/build
          Start  1: Testing123_tstTestFile_cc
     1/18 Test  #1: Testing123_tstTestFile_cc ..........................   Passed    0.01 sec
          Start  2: Testing123_passThisCompiles_cc.Main
     2/18 Test  #2: Testing123_passThisCompiles_cc.Main ................   Passed    0.22 sec
          Start  3: Testing123_failInternalTestCompileCase_cc.Main
     3/18 Test  #3: Testing123_failInternalTestCompileCase_cc.Main .....   Passed    0.22 sec
          Start  4: Testing123_failNoInternalTestCompileCase_cc.Main
     4/18 Test  #4: Testing123_failNoInternalTestCompileCase_cc.Main ...   Passed    0.22 sec
          Start  5: Testing123_tstReturnCode0_cc
     5/18 Test  #5: Testing123_tstReturnCode0_cc .......................   Passed    0.00 sec
          Start  6: Testing123_tstReturnCode1_cc
     6/18 Test  #6: Testing123_tstReturnCode1_cc .......................   Passed    0.00 sec
          Start  7: Testing123_tstRegexPass_cc
     7/18 Test  #7: Testing123_tstRegexPass_cc .........................   Passed    0.00 sec
          Start  8: Testing123_tstRegexFail_cc
     8/18 Test  #8: Testing123_tstRegexFail_cc .........................   Passed    0.00 sec
          Start  9: Testing123_tstTestFile_f90
     9/18 Test  #9: Testing123_tstTestFile_f90 .........................   Passed    0.00 sec
          Start 10: Testing123_tst1_cc
    10/18 Test #10: Testing123_tst1_cc .................................   Passed    0.00 sec
          Start 11: Testing123_tst2_cc
    11/18 Test #11: Testing123_tst2_cc .................................   Passed    0.00 sec
          Start 12: Testing123_passUnderCaseLimit_f90.Main
    12/18 Test #12: Testing123_passUnderCaseLimit_f90.Main .............   Passed    0.22 sec
          Start 13: Testing123_failOverCaseLimit_f90.Main
    13/18 Test #13: Testing123_failOverCaseLimit_f90.Main ..............   Passed    0.27 sec
          Start 14: Testing123_tstPASSES_cc.Null
    14/18 Test #14: Testing123_tstPASSES_cc.Null .......................   Passed    0.22 sec
          Start 15: Testing123_tstPASSES_cc.OperatorParentheses
    15/18 Test #15: Testing123_tstPASSES_cc.OperatorParentheses ........   Passed    0.24 sec
          Start 16: Testing123_tstFAILS_cc.VectorNotDefined
    16/18 Test #16: Testing123_tstFAILS_cc.VectorNotDefined ............   Passed    0.21 sec
          Start 17: Testing123_tstFAILS_cc.BadMath
    17/18 Test #17: Testing123_tstFAILS_cc.BadMath .....................   Passed    0.20 sec
          Start 18: Testing123_tstFAILS_cc.PrivateCtor
    18/18 Test #18: Testing123_tstFAILS_cc.PrivateCtor .................   Passed    0.20 sec

    100% tests passed, 0 tests failed out of 18

    Label Time Summary:
    Testing123    =   0.03 sec (8 tests)

    Total Test time (real) =   2.24 sec

Strategy
--------

All the heavy lifting inside a test file is done by the beautiful GoogleTest_
C++ unit test framework. We just want to add a little layer on top, with
scientific computing as the main target application.

- TriBITS dependency management wrapper around Googletest.
- Support for Fortran unit testing (with same style/feel as C++)
- Support for MPI-enabled tests.
- Support for additional comparison macros, such as vector comparisons
  or relative differences.

In the end, t123TestFile will call
`TRIBITS_ADD_EXECUTABLE_AND_TEST <https://tribits.org/doc/TribitsDevelopersGuide.html#tribits-add-executable-and-test>`_,
so the possibilities are endless.

.. code-block:: cmake

    TRIBITS_ADD_EXECUTABLE_AND_TEST(
      <exeRootName>  [NOEXEPREFIX]  [NOEXESUFFIX]  [ADD_DIR_TO_NAME]
      SOURCES <src0> <src1> ...
      [NAME <testName> | NAME_POSTFIX <testNamePostfix>]
      [CATEGORIES <category0>  <category1> ...]
      [HOST <host0> <host1> ...]
      [XHOST <xhost0> <xhost1> ...]
      [XHOST_TEST <xhost0> <xhost1> ...]
      [HOSTTYPE <hosttype0> <hosttype1> ...]
      [XHOSTTYPE <xhosttype0> <xhosttype1> ...]
      [XHOSTTYPE_TEST <xhosttype0> <xhosttype1> ...]
      [EXCLUDE_IF_NOT_TRUE <varname0> <varname1> ...]
      [DIRECTORY <dir>]
      [TESTONLYLIBS <lib0> <lib1> ...]
      [IMPORTEDLIBS <lib0> <lib1> ...]
      [COMM [serial] [mpi]]
      [ARGS "<arg0> <arg1> ..." "<arg2> <arg3> ..." ...]
      [NUM_MPI_PROCS <numProcs>]
      [LINKER_LANGUAGE (C|CXX|Fortran)]
      [STANDARD_PASS_OUTPUT
        | PASS_REGULAR_EXPRESSION "<regex0>;<regex1>;..."]
      [FAIL_REGULAR_EXPRESSION "<regex0>;<regex1>;..."]
      [WILL_FAIL]
      [ENVIRONMENT <var0>=<value0> <var1>=<value1> ...]
      [INSTALLABLE]
      [TIMEOUT <maxSeconds>]
      [ADDED_EXE_TARGET_NAME_OUT <exeTargetName>]
      [ADDED_TESTS_NAMES_OUT <testsNames>]
      )

The Fortran support will never be as complete as the C++ support, but it's
probably still the best unit testing framework for Fortran out there.
The goal with Fortran support is to hook in as directly as possible
to the Googletest functions. In some cases we have to hack in to a private method,
which we do with shame, but it's better than completely reimplementing some
functionality on the Fortran side.

To Do
-----

Testing123_ is not quite ready for prime time. The MPI component is not full
enabled and the Fortran support could use more work.

- C++ and Fortran
    - Enable MPI (starts with BootsOnTheGround_)
- Fortran only
    - Fix ``ASSERT_*`` macros to halt the program.
    - Document how exactly Fortran was hacked (it's a good story).
    - Fix Fortran literal strings with double quotes. ``EXPECT_EQ("a","a")``
      bombs because the C preprocessor converts ``"a"`` to ``"\"a\""`` but Fortran does
      not understand that kind of escape ``\"`` instead using ``""``. The
      workaround is just to use single quotes in string literals in the
      macros, ``EXPECT_EQ('a','a')``.

Embedded Packages
-----------------

Testing123_ bootstraps the BootsOnTheGround_ package and depends
on GoogleTest_ as a Third Party Library (TPL). BootsOnTheGround includes TriBITS_.

If you use Testing123 for testing a combined project/package,
i.e. able to be built as both a TriBITS project for development/testing
and as a TriBITS package for linking with other codes, consider adopting
the strategy in Testing123's CMakeLists.txt file.

.. code-block:: cmake

    CMAKE_MINIMUM_REQUIRED(VERSION 3.0 FATAL_ERROR)
    INCLUDE( "${CMAKE_SOURCE_DIR}/external/BootsOnTheGround/cmake/BOTG_INCLUDE.cmake" )
    botgConfigureProject( "${CMAKE_SOURCE_DIR}" )
    TRIBITS_PROJECT_ENABLE_ALL()

The first include handles all the TriBITS setup and everything else. If you
want to include Testing123_ as an external **package** in your own project,
you would just include it in your PackagesList.cmake:

.. code-block:: cmake

    TRIBITS_REPOSITORY_DEFINE_PACKAGES(
      BootsOnTheGround external/BootsOnTheGround/src                     ST
      Testing123       external/Testing123/src                           PT
    )

You could of course have your own BootsOnTheGround package and disregard
Testing123's, but why? You get one prettier path in exchange for a bunch of
extra baggage. Note the ``src`` directory at the end. This is the location
of the CMakeLists.txt file corresponding to the **package**, not the
**project** CMakeLists.txt which is at the root level.

.. _GoogleTest: https://github.com/google/googletest
.. _CMake: https://cmake.org/
.. _TriBITS: https://tribits.org
.. _BootsOnTheGround: http://github.com/wawiesel/BootsOnTheGround
.. _Testing123: http://github.com/wawiesel/Testing123

