TRIBITS_PACKAGE( Testing123 )

# Declare expected header path.
INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_SOURCE_DIR}" )

# Set C++ standard.
BOTG_UseCxxStandard( 11 )
BOTG_MinimumCompilerVersion( GNU CXX 4.8 )

# Set C++ sources.
SET(CXX_SOURCES
    t123/TestExe.cc
    t123/internal/cxx_unit_test_main.cc
    t123/internal/c_linkage.cc
)
# Append to full list of sources.
SET(SOURCES ${CXX_SOURCES})

# Install CXX headers.
SET(CXX_HEADERS
    t123/TestExe.hh
    t123/internal/c_linkage.h
)
INSTALL(FILES ${CXX_HEADERS} DESTINATION "include/t123/")

# Add special unit test creation command.
INCLUDE( t123/cmake/AddCxxTest.cmake )

# Create CXX library.
TRIBITS_ADD_LIBRARY(
        Testing123
    NOINSTALLHEADERS
        ${CXX_HEADERS}
    SOURCES
        ${CXX_SOURCES}
)

# Add this package's CXX test directory.
TRIBITS_ADD_TEST_DIRECTORIES( t123/tests )

# Possibly process fortran.
IF(${PROJECT_NAME}_ENABLE_Fortran)

    # 4.9 is required so that C_LOC works as expected.
    BOTG_MinimumCompilerVersion( GNU Fortran 4.9 )

    # Enable fortran goodies.
    BOTG_EnableFortran(
        C_PREPROCESSOR
        UNLIMITED_LINE_LENGTH
    )

    # Set Fortran sources.
    SET(F_SOURCES
        t123/f/TestExe.f90
    )

    # Configure test header.
    FILE(
        READ
        t123/internal/FUNDAMENTAL_MACROS.inc
        FUNDAMENTAL_MACROS_INC
    )

    # Allow access to Fortran modules and this include for other codes.
    GLOBAL_SET( ADD_FORTRAN_TEST_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}")
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_BINARY_DIR}" )

    SET(F_HEADER "${CMAKE_CURRENT_BINARY_DIR}/t123/f/TestExe.inc.f90")
    CONFIGURE_FILE(
        t123/f/TestExe.inc.f90.in "${F_HEADER}"
    )
    INSTALL(FILES ${F_HEADER} DESTINATION "include/t123/f/")

    # Add special unit test creation command.
    INCLUDE( "${CMAKE_CURRENT_LIST_DIR}/t123/cmake/AddFortranTest.cmake" )

    # Create Fortran library.
    TRIBITS_ADD_LIBRARY(
            Testing123_f
        SOURCES
            ${F_SOURCES}
    )
    TARGET_LINK_LIBRARIES( Testing123_f Testing123 )

    # Add this package's Fortran test directory.
    TRIBITS_ADD_TEST_DIRECTORIES( t123/f/tests )

ENDIF()

TRIBITS_PACKAGE_POSTPROCESS()
