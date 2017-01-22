#include "TestExe.hh"
#include "internal/STEAL_PRIVATE_METHOD.hh"

// Anonymous namespace for unspeakable acts of evil.
namespace {
    //AddTestPartResult
    M_STEAL_PRIVATE_METHOD(
        ::testing::UnitTest,
        AddTestPartResult,
        ::testing::TestPartResult::Type,
        const char *,
        int,
        const std::string &,
        const std::string &
    );
}

namespace t123 {

class DummyTest : public ::testing::Test
{
    void TestBody(){}
};

//static
void TestExe::init(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
}

//static
void TestExe::addTestPartResult(const char* file, int line)
{
    M_CALL_STOLEN_METHOD(
        *::testing::UnitTest::GetInstance(),
        AddTestPartResult
    )
    (
        ::testing::TestPartResult::kSuccess,
        file,  // No info about the source file where the exception occurred.
        line,    // We have no info on which line caused the exception.
        "",
        ""     // No stack trace, either.
    );
}

//static
void TestExe::addTest(const char* file, int line,
    const char* test_case_name,
    const char* test_name)
{
    auto x = ::testing::internal::MakeAndRegisterTestInfo(
        test_case_name, test_name, NULL, NULL,
        ::testing::internal::CodeLocation(file,line),
        ::testing::internal::GetTestTypeId(),
        ::testing::Test::SetUpTestCase,
        ::testing::Test::TearDownTestCase,
        new ::testing::internal::TestFactoryImpl<::t123::DummyTest>);
}

//static
int TestExe::finish()
{
    return 0;
}

}

