#include "t123/TestFile.hh"

// Test basic expect on scalar values: string, int, double, float.
TEST( Expect, Scalars )
{
    // Reference value first, test value second.
    EXPECT_EQ( 700, 700 );
    EXPECT_EQ( "700", "700" );
    EXPECT_LT( 1, 2 );
    EXPECT_GT( 4.1, 3.5 );
    EXPECT_NE( 0, 1e-19 );
    EXPECT_NE( "", "done" );
    EXPECT_LE( 1, 1 );
    EXPECT_GE( 4.1, 3.5 );
}
