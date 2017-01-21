module tstTesting123_M

#include "t123/f/Testing123.inc.f90"

implicit none

contains

TEST(Case1,A)

EXPECT_EQ(1.d0,1.d0)

END_TEST

TEST(Case1,B)

EXPECT_EQ(1.d0,1.d0)

END_TEST

TEST(Case2,A)

EXPECT_EQ(1.d0,2.d0)

END_TEST

end module

program main
use tstTesting123_M
!
RUN_ALL_TESTS()
!
end program
