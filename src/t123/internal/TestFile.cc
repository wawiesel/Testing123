#include "t123/TestFile.hh"
#include "t123/internal/STEAL_PRIVATE_METHOD.hh"
#include <cassert>
#include <cstring>

namespace testing
{
// creates type TestFunction
typedef void ( *TestFunction )();

class TestFileRunner : public ::testing::Test
{
  public:
    ::testing::TestFunction b_test_function;
    TestFileRunner( TestFunction tf ) : b_test_function( tf ) {}
    virtual void TestBody() { this->b_test_function(); }
};

class TestFileFactory : public ::testing::internal::TestFactoryBase
{
  public:
    ::testing::TestFunction b_test_function;
    TestFileFactory( TestFunction tf ) : b_test_function( tf ) {}
    virtual ::testing::Test* CreateTest()
    {
        return new TestFileRunner( this->b_test_function );
    }
};
}

// Anonymous namespace for unspeakable acts of evil.
namespace
{
// AddTestPartResult
M_STEAL_PRIVATE_METHOD(::testing::UnitTest,
                       AddTestPartResult,
                       ::testing::TestPartResult::Type,
                       const char*,
                       int,
                       const std::string&,
                       const std::string& );
}

namespace t123
{
// static
void TestFile::init( int argc, char** argv )
{
    ::testing::InitGoogleTest( &argc, argv );
}

// static
void TestFile::addTestPartResult( const char* file,
                                 int line,
                                 int k,
                                 const char* refVariable,
                                 const std::string& refValue,
                                 const char* testVariable,
                                 const std::string& testValue,
                                 const char* compareOper )
{
    // Determine how fatal failure is.
    auto kResult = ::testing::TestPartResult::kSuccess;
    std::stringstream msg;
    if( k != 0 )
    {
        if( strncmp(compareOper,"==",2)==0 )
        {
            auto failure = ::testing::internal::EqHelper<false>::Compare(
                refVariable, testVariable, refValue, testValue );
            msg << failure.message();
        }
        else if( strncmp(compareOper,"/=",2)==0 )
        {
            auto failure = ::testing::internal::CmpHelperNE(
                refVariable, testVariable, refValue, testValue );
            msg << failure.message();
        }
        else if( strncmp(compareOper,"<",1)==0 )
        {
            auto failure = ::testing::internal::CmpHelperLT(
                refVariable, testVariable, refValue, testValue );
            msg << failure.message();
        }
        else if( strncmp(compareOper,">",1)==0 )
        {
            auto failure = ::testing::internal::CmpHelperGT(
                refVariable, testVariable, refValue, testValue );
            msg << failure.message();
        }
        else if( strncmp(compareOper,"<=",2)==0 )
        {
            auto failure = ::testing::internal::CmpHelperLE(
                refVariable, testVariable, refValue, testValue );
            msg << failure.message();
        }
        else if( strncmp(compareOper,">=",2)==0 )
        {
            auto failure = ::testing::internal::CmpHelperGE(
                refVariable, testVariable, refValue, testValue );
            msg << failure.message();
        }
        else
        {
            assert(false); //operator not recognized
        }

        if( k < 0 )
        {
            kResult = ::testing::TestPartResult::kFatalFailure;
        }
        else if( k > 0 )
        {
            kResult = ::testing::TestPartResult::kNonFatalFailure;
        }
    }
    M_CALL_STOLEN_METHOD( *::testing::UnitTest::GetInstance(),
                          AddTestPartResult )
    ( kResult, file, line, msg.str(), "" );
}

// static
void TestFile::addTest(::testing::TestFunction test_function,
                      const char* file,
                      int line,
                      const char* test_case_name,
                      const char* test_name )
{
    ::testing::internal::TestFactoryBase* tef =
        new ::testing::TestFileFactory( test_function );
    auto x = ::testing::internal::MakeAndRegisterTestInfo(
        test_case_name,
        test_name,
        nullptr,
        nullptr,
        ::testing::internal::CodeLocation( file, line ),
        ::testing::internal::GetTestTypeId(),
        ::testing::Test::SetUpTestCase,
        ::testing::Test::TearDownTestCase,
        tef );
    static std::map<std::string, decltype( x )> storage;
    storage[std::string( test_case_name ) + "." + test_name] = x;
}

// static
int TestFile::finish() { return RUN_ALL_TESTS(); }
}
