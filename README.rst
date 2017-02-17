Testing123
==========

.. image:: https://travis-ci.org/wawiesel/Testing123.svg?branch=master
    :target: https://travis-ci.org/wawiesel/Testing123

TriBITS/CMake-enabled unit testing for C++/Fortran

.. image:: http://i.imgur.com/RjuuVG0.jpg

Testing123 provides two macros to use in CMakeLists.txt files for 
declaring unit tests.

.. code-block:: cmake

    # MyPackage/src/tests/CMakeLists.txt
    ADD_FORTRAN_TEST( tstMyTestFile.f90 )
    ADD_CXX_TEST( tstMyTestFile.cc )
    
All the heavy lifting is done by the beautiful GoogleTest C++ unit 
test framework. We just want to add a little layer on top, with scientific
computing as the main target application.

- TriBITS dependency management wrapper around Googletest.
- Support for Fortran unit testing (with same style/feel as C++)
- Support for MPI-enabled tests.
- Support for additional comparison macros, such as vector comparisons
  or relative differences.

In the end, ADD_FORTRAN_TEST or ADD_CXX_TEST will call 
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

Testing123_ is not quite ready for prime time. The MPI component is not yet
enabled and the Fortran support only exists for the ``EXPECT_EQ`` macro.

- C++ and Fortran
    - Enable MPI (starts with BootsOnTheGround_)
- Fortran only
    - Other ``EXPECT_*`` macros like ``EXPECT_LE, EXPECT_LT, ...``
    - Fix ``ASSERT_*`` macros to halt the program.
    - Document how exactly Fortran was hacked (it's a good story).
    - Extend macro definitions to handle more than 10 test cases.
    - Fix Fortran literal strings with double quotes. ``EXPECT_EQ("a","a")``
      bombs because the C preprocessor converts ``"a"`` to ``"\"a\""`` but Fortran does
      not understand that kind of escape ``\"`` instead using ``""``. The
      workaround is just to use single quotes in string literals in the
      macros, ``EXPECT_EQ('a','a')``.

Embedded Packages
-----------------

Testing123_ bootstraps the BootsOnTheGround_ package and depends
on GoogleTest as a Third Party Library (TPL). BootsOnTheGround includes TriBITS_.

If you use Testing123 for testing a combined project/package,
i.e. able to be built as both a TriBITS project for development/testing
and as a TriBITS package for linking with other codes, consider adopting
the strategy in Testing123's CMakeLists.txt file.

.. code-block:: cmake

    CMAKE_MINIMUM_REQUIRED(VERSION 3.0 FATAL_ERROR)
    INCLUDE( "${CMAKE_SOURCE_DIR}/external/BootsOnTheGround/cmake/BOTG_INCLUDE.cmake" )
    BOTG_ConfigureProject( "${CMAKE_SOURCE_DIR}" )
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

See Template123_ for a minimal skeleton repo of a Testing123-enabled project.

.. _CMake: https://cmake.org/
.. _TriBITS: https://tribits.org
.. _BootsOnTheGround: http://github.com/wawiesel/BootsOnTheGround
.. _Testing123: http://github.com/wawiesel/Testing123
.. _Template123: http://github.com/wawiesel/Template123

