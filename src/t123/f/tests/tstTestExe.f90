module tstTestExe_M

#include "t123/f/TestExe.inc.f90"

implicit none

contains

! Test basic expect on scalar values: string, int, double, float.
TEST( Expect, Scalars ){

    ! Reference value first, test value second.
    EXPECT_EQ( 700, 700 );
    EXPECT_EQ( '700', '700' );
    !EXPECT_LT( 1, 2 );
    !EXPECT_GT( 4.1, 3.5 );
    !EXPECT_NE( 0, 1e-19 );
    !EXPECT_NE( "", "done" );
    !EXPECT_LE( 1, 1 );
    !EXPECT_GE( 4.1, 3.5 );
}

TEST( Demo, Calcs ){
    real(C_DOUBLE) :: a,b
    a=1.d0
    b=2.d0
    ASSERT_EQ(2*a,b)
    EXPECT_EQ(2*a,b)
    EXPECT_EQ(2*a,b,"here's a message!")
}

end module

program main
use tstTestExe_M
!
RUN_ALL_TESTS()
!
end program
