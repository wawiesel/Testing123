Testing123
----------

.. image:: https://travis-ci.org/wawiesel/Testing123.svg?branch=master
    :target: https://travis-ci.org/wawiesel/Testing123

CMake-enabled unit testing for C++ and Fortran

The main purpose of this unit testing package is to extend the beautiful
GoogleTest C++ unit test framework for scientific computing purposes.

- Add CMake/TriBITS dependency management wrapper around GTest.
- Support for Fortran unit testing (with same style/feel as C++)
- Support for MPI-enabled tests.
- Support for additional comparison macros, such as vector comparisons
  or relative differences.

The Fortran support will never be as complete as the C++ support, but as there
are not really any good Fortran unit testing frameworks out there, it provides
something. The goal with Fortran support is to hook in as directly as possible
to the GTest functions. In some cases we have to hack in to a private method,
which we do with shame, but it's better than completely reimplementing some
functionality on the Fortran side.

To Do
-----

Testing123 is not quite ready for prime time. The MPI component is not yet
enabled and the Fortran support has basically only been shown for the
``EXPECT_EQ`` macro.

- Enable MPI (starts with BootsOnTheGround)
- Other ``EXPECT_*`` macros like ``EXPECT_LE, EXPECT_LT, ...``
- Fix ``ASSERT_*`` macros to halt program.
- Document how exactly Fortran was hacked (it's a good story).
- Extend macro definitions to handle more than 10 test cases.
- Fix Fortran literal strings with double quotes. ``EXPECT_EQ("a","a")``
  bombs because the C preprocessor converts ``"a"`` to ``"\"a\""`` but Fortran does
  not understand that kind of escape ``\"`` instead using ``""``. The
  workaround is just to use single quotes in string literals in the
  macros, ``EXPECT_EQ('a','a')``.

Embedded Packages
-----------------

Testing123 includes the BootsOnTheGround package as a git subtree, and depends
on GoogleTest as a Third Party Library (TPL). BootsOnTheGround includes TriBITS.

If you use Testing123 for testing a combined project/package,
i.e. able to be built as both a TriBITS project for development/testing
and as a TriBITS package for linking with other codes, consider adopting
the strategy in Testing123's CMakeLists.txt file.

.. code-block:: cmake

    CMAKE_MINIMUM_REQUIRED(VERSION 3.0 FATAL_ERROR)

    # Always start with this include OUTSIDE the IF statement below.
    # This sets BOTG_SOURCE_DIR.
    INCLUDE( "${CMAKE_CURRENT_LIST_DIR}/external/BootsOnTheGround/cmake/BOTG_INCLUDE.cmake" )

    # We enter here if this is a being built as a standalone TriBITS **project**.
    IF( NOT TRIBITS_PROCESSING_PACKAGE )

        BOTG_ConfigureProject( "${CMAKE_CURRENT_LIST_DIR}" )

    # We enter here when we build this as a TriBITS **package**, including
    # when we come through a second pass during TRIBITS_PROJECT_ENABLE_ALL.
    ELSE()

        # Initialize the configuration.
        BOTG_ConfigurePackage( Testing123 "src" )

    ENDIF()

The first include handles all the TriBITS setup and everything else. If built
as a **project**, then the ConfigureProject command is executed first, then
the ConfigurePackage command (ConfigureSuperPackage is also available). If you
were to include Testing123 as an external package in a pure project
(I would recommend at ``external/Testing123``, then your CMakeLists.txt
would look like:

.. code-block:: cmake

    CMAKE_MINIMUM_REQUIRED(VERSION 3.0 FATAL_ERROR)

    INCLUDE( "${CMAKE_CURRENT_LIST_DIR}/external/Testing123/external/BootsOnTheGround/cmake/BOTG_INCLUDE.cmake" )

    BOTG_ConfigureProject( "${CMAKE_CURRENT_LIST_DIR}" )

and your TriBITS PackagesList.cmake would look something like:

.. code-block:: cmake

    TRIBITS_REPOSITORY_DEFINE_PACKAGES(
      BootsOnTheGround external/Testing123/external/BootsOnTheGround ST
      Testing123       external/Testing123                           PT
    )

You could of course have your own BootsOnTheGround package and disregard
Testing123's, but why? You get one prettier path in exchange for a bunch of
extra baggage.

To update BootsOnTheGround:

::

    git subtree pull --prefix external/BootsOnTheGround https://github.com/wawiesel/BootsOnTheGround.git develop --squash
