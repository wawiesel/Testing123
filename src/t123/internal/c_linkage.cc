#include "c_linkage.h"
#include <gtest/gtest.h>
#include "STEAL_PRIVATE_METHOD.hh"

//Note this file must be treated like C++!

    //anonymous namespace for unspeakable acts of evil
    namespace {
      M_STEAL_PRIVATE_METHOD( ::testing::UnitTest, AddTestPartResult, ::testing::TestPartResult::Type, const char *, int, const std::string &, const std::string &);
    }

    void testing_Testing123_c_AddTestPartResult()
    {
      M_CALL_STOLEN_METHOD( *::testing::UnitTest::GetInstance(), AddTestPartResult )(
    ::testing::TestPartResult::kSuccess,
      NULL,  // No info about the source file where the exception occurred.
      -1,    // We have no info on which line caused the exception.
      "",
      "");   // No stack trace, either.
    }

