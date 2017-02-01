TRIBITS_PACKAGE( Testing123 )

PRINT_VAR(CMAKE_CURRENT_SOURCE_DIR)
# Allow access to Fortran modules for other codes.
INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_BINARY_DIR}" )

# Declare expected header path.
INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_SOURCE_DIR}" )

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

    # This needs to be arbitrary.
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree-line-length-none -cpp")

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
    SET(F_HEADER "${CMAKE_CURRENT_BINARY_DIR}/t123/f/TestExe.inc.f90")
    CONFIGURE_FILE(
        t123/f/TestExe.inc.f90 "${F_HEADER}"
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
    #TARGET_LINK_LIBRARIES( TestExe_f TestExe )

    # Add this package's Fortran test directory.
    TRIBITS_ADD_TEST_DIRECTORIES( t123/f/tests )

ENDIF()

TRIBITS_PACKAGE_POSTPROCESS()
