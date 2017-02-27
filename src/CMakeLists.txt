TRIBITS_PACKAGE( Testing123 )

# Declare expected header path.
INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_SOURCE_DIR}" )

# Set C++ standard.
BOTG_UseCxxStandard( 11 )
BOTG_MinimumCompilerVersion( CXX GNU 4.8 )
BOTG_AddCompilerFlags( CXX Intel Linux
    "-fp-model source"
)

# Set C++ sources.
SET(CXX_SOURCES
    t123/internal/TestExe.cc
    t123/internal/cxx_unit_test_main.cc
    t123/internal/c_linkage.cc
)
# Append to full list of sources.
SET(SOURCES ${CXX_SOURCES})

# Install CXX headers.
SET(CXX_HEADERS
    t123/TestExe.hh
    t123/internal/AdditionalMacros.hh
    t123/internal/c_linkage.h
)
INSTALL(FILES ${CXX_HEADERS} DESTINATION "include/t123/")

# Create CXX library.
TRIBITS_ADD_LIBRARY(
        Testing123
    NOINSTALLHEADERS
        ${CXX_HEADERS}
    SOURCES
        ${CXX_SOURCES}
)

# Possibly process Fortran.
IF(${PROJECT_NAME}_ENABLE_Fortran)

    # Fortran modules will be found here.
    INCLUDE_DIRECTORIES( "${CMAKE_CURRENT_BINARY_DIR}" )

    # 4.9 is required so that C_LOC works as expected.
    BOTG_MinimumCompilerVersion( Fortran GNU 4.9 )
    BOTG_AddCompilerFlags( Fortran Intel Linux
        " -names lowercase"
        " -fp-model source"
        " -fpp"
        " -traceback"
        " -heap-arrays 100"
        " -assume byterecl"
    )

    # Enable Fortran goodies.
    BOTG_EnableFortran(
        C_PREPROCESSOR
        UNLIMITED_LINE_LENGTH
    )

    # Set Fortran sources.
    SET(F_SOURCES
        t123/internal/TestExe.f90
    )

    # Configure test header.
    FILE(
        READ
        t123/internal/FUNDAMENTAL_MACROS.inc
        FUNDAMENTAL_MACROS_INC
    )

    # Allow access to Fortran modules and this include for other codes.
    GLOBAL_SET( T123_AddFortranTest_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}")

    #Configure main include.
    SET( main_include "${CMAKE_CURRENT_BINARY_DIR}/t123/TestExe.f90i")
    CONFIGURE_FILE(
        t123/TestExe.f90i.in "${main_include}"
    )

    #Configure include to end a test.
    SET( end_test_include "${CMAKE_CURRENT_BINARY_DIR}/t123/internal/TEST_END.f90i")
    CONFIGURE_FILE(
        t123/internal/TEST_END.f90i.in "${end_test_include}"
    )

    #Install headers.
    SET(F_HEADERS
        "${main_include}"
        "${test_end_include}"
    )
    INSTALL(FILES ${F_HEADERS} DESTINATION "include/t123")

    # Create Fortran library.
    TRIBITS_ADD_LIBRARY(
            Testing123_Fortran
        SOURCES
            ${F_SOURCES}
    )
    TARGET_LINK_LIBRARIES( Testing123_Fortran Testing123 )

ENDIF()

# Add special unit test creation command.
INCLUDE( t123/cmake/AddCxxTest.cmake )
INCLUDE( t123/cmake/AddFortranTest.cmake )

# Add this package's test directory.
TRIBITS_ADD_TEST_DIRECTORIES( t123/test )

TRIBITS_PACKAGE_POSTPROCESS()
