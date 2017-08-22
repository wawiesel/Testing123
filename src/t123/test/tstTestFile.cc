#include "t123/TestFile.hh"
#include <vector>

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
    EXPECT_NEAR( 4.1, 4.0 , 0.11 ); //0.11 abstol
    EXPECT_APPROX( 1.0, 1.01, 0.011 ); //1.1% reltol
}

// Test on vectors.
TEST( Expect, Vector )
{
    std::vector<double> ref{0.1,0.2};
    {
        std::vector<double> test{0.1,0.2};
        EXPECT_VEC_EQ( ref, test );
    }
    {
        std::vector<double> test{0.11,0.21};
        EXPECT_VEC_NEAR( ref, test, 0.01 ); //0.01 abstol
        EXPECT_VEC_APPROX( ref, test, 0.08 ); //11% reltol
    }
}
