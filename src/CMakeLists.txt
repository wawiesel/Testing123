botgPackage( Testing123 )
#===============================================================================
#
# Public unit test command.
#
INCLUDE( t123/AddTest.cmake )
#-------------------------------------------------------------------------------
#
# Set CXX options.
#
botgUseCxxStandard( 11 )
botgMinimumCompilerVersion( CXX GNU 4.8 )
botgAddCompilerFlags( CXX Intel Linux
    "-fp-model source"
)
#-------------------------------------------------------------------------------
#
# Create CXX library.
#
botgLibrary( Testing123
    SOURCES
        t123/internal/TestExe.cc
        t123/internal/cxx_unit_test_main.cc
        t123/internal/c_linkage.cc
    HEADERS
        t123/TestExe.hh
        t123/internal/MORE_GTEST_MACROS.hh
        t123/internal/c_linkage.h
)
#-------------------------------------------------------------------------------
#
# Set Fortran options.
# 4.9 is required so that C_LOC works as expected.
#
botgMinimumCompilerVersion( Fortran GNU 4.9 )
botgEnableFortran(
    C_PREPROCESSOR
    UNLIMITED_LINE_LENGTH
)
botgAddCompilerFlags( Fortran Intel Linux
    "-names lowercase"
    "-fp-model source"
    "-fpp"
    "-traceback"
    "-heap-arrays 100"
    "-assume byterecl"
)
#-------------------------------------------------------------------------------
#
# Create a Fortran library (files ending in .in are automatically configured).
#
botgLibrary( Testing123_Fortran
    LANGUAGE Fortran
    SOURCES
        t123/internal/TestExe.f90
    HEADERS
        t123/TestExe.f90i.in
        t123/internal/TEST_END.f90i.in
    LINK_TO
        Testing123
)
#-------------------------------------------------------------------------------
#
# Add unit test directory.
#
botgTestDir( t123/test )
#===============================================================================
botgEnd()
