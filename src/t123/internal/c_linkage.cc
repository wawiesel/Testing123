#include "c_linkage.h"
#include "t123/TestExe.hh"

void t123_TestExe_c_addTestPartResult( const char* file,
                                       int line,
                                       int k,
                                       const char* refVariable,
                                       const char* refValue,
                                       const char* testVariable,
                                       const char* testValue,
                                       const char* compareOper )
{
    t123::TestExe::addTestPartResult( file,
                                      line,
                                      k,
                                      refVariable,
                                      refValue,
                                      testVariable,
                                      testValue,
                                      compareOper );
}

void t123_TestExe_c_addTest( void ( *test_function )(),
                             const char* file,
                             int line,
                             const char* test_case_name,
                             const char* test_name )
{
    t123::TestExe::addTest(
        test_function, file, line, test_case_name, test_name );
}

void t123_TestExe_c_init( int argc, char** argv )
{
    t123::TestExe::init( argc, argv );
}

int t123_TestExe_c_finish() { return t123::TestExe::finish(); }
