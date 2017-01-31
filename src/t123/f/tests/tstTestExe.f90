module tstTestExe_M

#include "t123/f/TestExe.inc.f90"

implicit none

contains

TEST(Case1,A)

!WRITE(*,*)"line=",__LINE__
EXPECT_EQ(1.d0,1.d0)

END_TEST

TEST(Case1,B)

EXPECT_EQ(1.d0,1.d0)

END_TEST

TEST(Case2,A)
real(C_DOUBLE) :: a,b
a=1.d0
b=2.d0
EXPECT_EQ(2*a,b)

END_TEST

end module

program main
use tstTestExe_M
!
RUN_ALL_TESTS()
!
end program
