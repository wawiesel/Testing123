module tstTestExe_M

#include "t123/TestExe.f90i"

implicit none

contains

! Test basic expect on scalar values: string, int, double, float.
TEST( Expect, Scalars )

    ! Reference value first, test value second.
    EXPECT_EQ( 700, 700 )
    EXPECT_EQ( '700', '700' )
    EXPECT_LT( 1, 2 )
    EXPECT_GT( 4.1, 3.5 )
    EXPECT_LE( 1, 1 )
    EXPECT_GE( 4.1, 3.5 )
    EXPECT_NE( 0, 1e-19 )
    EXPECT_NE( ' ', 'done' )

ENDTEST

! Test basic assert on scalar values: string, int, double, float.
TEST( Expect, Scalars )

    ! Reference value first, test value second.
    ASSERT_EQ( 700, 700 )
    ASSERT_EQ( '700', '700' )
    ASSERT_LT( 1, 2 )
    ASSERT_GT( 4.1, 3.5 )
    ASSERT_LE( 1, 1 )
    ASSERT_GE( 4.1, 3.5 )
    ASSERT_NE( 0, 1e-19 )
    ASSERT_NE( ' ', 'done' )

ENDTEST

! Test values with variables.
TEST( Demo, Calcs )
    real(C_DOUBLE) :: a,b

    a=1.d0
    b=2.d0
    ASSERT_EQ(2*a,b)
    EXPECT_NE(a,b)
    EXPECT_EQ(2*a,b,"here's a message!")

    !different types
    EXPECT_LT(0,1e-23,"tolerance!");

END TEST

end module

program main
use tstTestExe_M
!
RUN_ALL_TESTS()
!
end program
