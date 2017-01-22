!This file is to be INCLUDED in a test file.
!
!#include "t123/f/Testing123.inc.f90"
!
!It uses the Testing123 module which contains
!Fortran data structures for the test excecutation, as
!well as further includes of important macros and
!special test definition macros.
!

use testing_Testing123_M

@FUNDAMENTAL_MACROS_INC@

#define SETUP_TEST(A,B,i)\
subroutine _M_CAT(Test_,i)();;;\
O_N = _M_INC(i);;; \
O_A(O_N) % O_Q = #A;;; \
O_A(O_N) % O_R = #B;;;

#define TEST(A,B) SETUP_TEST(A,B,__COUNTER__)
#define END_TEST end subroutine

#define _M_LOOP(i, _) _M_CAT(call Test_,i)();;;

#undef RUNALL_TESTS

#define RUN_ALL_TESTS() \
_M_EVAL(_M_REPEAT(__COUNTER__, _M_LOOP, ~))\
call testing_RUN_ALL()

#define EXPECT_EQ(ref,test) if( .not.testing_addTestPart(__FILE__,__LINE__,#ref,#test,ref==test) )write(6,'(a)',advance='no')
