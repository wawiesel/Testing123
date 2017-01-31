#ifndef t123_TestExe_HH
#define t123_TestExe_HH

// All the magic macros come from here!
#include <gtest/gtest.h>

namespace t123
{
class TestExe
{
  public:
    static void init( int argc, char** argv );
    static void addTest( void ( *test_function )(),
                         const char* file,
                         int line,
                         const char* test_case_name,
                         const char* test_name );
    static void addTestPartResult( const char* file,
                                   int line,
                                   int k,
                                   const char* refVariable,
                                   const std::string& refValue,
                                   const char* testVariable,
                                   const std::string& testValue,
                                   const char* compareOper );
    static int finish();
};
}

#endif
