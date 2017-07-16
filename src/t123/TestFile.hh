#ifndef t123_TestFile_HH
#define t123_TestFile_HH

// All the magic GoogleTest macros come from here!
#include <gtest/gtest.h>

// We added our own here!
#include "internal/MORE_GTEST_MACROS.hh"

namespace t123
{
class TestFile
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
