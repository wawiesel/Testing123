#include "t123/TestExe.hh"
#include "t123/internal/STEAL_PRIVATE_METHOD.hh"

namespace testing
{
// creates type TestFunction
typedef void ( *TestFunction )();

class TestExeRunner : public ::testing::Test
{
  public:
    ::testing::TestFunction b_test_function;
    TestExeRunner( TestFunction tf ) : b_test_function( tf ) {}
    virtual void TestBody() { this->b_test_function(); }
};

class TestExeFactory : public ::testing::internal::TestFactoryBase
{
  public:
    ::testing::TestFunction b_test_function;
    TestExeFactory( TestFunction tf ) : b_test_function( tf ) {}
    virtual ::testing::Test* CreateTest()
    {
        return new TestExeRunner( this->b_test_function );
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
void TestExe::init( int argc, char** argv )
{
    ::testing::InitGoogleTest( &argc, argv );
}

// static
void TestExe::addTestPartResult( const char* file,
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
        auto eq_failure = ::testing::internal::EqHelper<false>::Compare(
            refVariable, testVariable, refValue, testValue );
        msg << eq_failure.message();
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
void TestExe::addTest(::testing::TestFunction test_function,
                      const char* file,
                      int line,
                      const char* test_case_name,
                      const char* test_name )
{
    ::testing::internal::TestFactoryBase* tef =
        new ::testing::TestExeFactory( test_function );
    auto x = ::testing::internal::MakeAndRegisterTestInfo(
        test_case_name,
        test_name,
        NULL,
        NULL,
        ::testing::internal::CodeLocation( file, line ),
        ::testing::internal::GetTestTypeId(),
        ::testing::Test::SetUpTestCase,
        ::testing::Test::TearDownTestCase,
        tef );
    static std::map<std::string, decltype( x )> storage;
    storage[std::string( test_case_name ) + "." + test_name] = x;
}

// static
int TestExe::finish() { return RUN_ALL_TESTS(); }
}
