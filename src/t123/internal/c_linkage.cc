#include "c_linkage.h"
#include <gtest/gtest.h>
#include "STEAL_PRIVATE_METHOD.hh"

// Note this file must be treated like C++!

// Anonymous namespace for unspeakable acts of evil.
namespace {
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

// Binding for adding a test part result.
void testing_Testing123_c_AddTestPartResult(const char* file, int line)
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

