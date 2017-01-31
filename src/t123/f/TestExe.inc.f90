!This file is to be INCLUDED in a test file.
!
!#include "t123/f/TestExe.inc.f90"
!
!It uses the TestExe module which contains
!Fortran data structures for the test excecutation, as
!well as further includes of important macros and
!special test definition macros.
!

use t123_TestExe_M

@FUNDAMENTAL_MACROS_INC@

#define SETUP_TEST(A,B,i)\
recursive subroutine _M_CAT(Test_,i)();;; \
logical,save :: register = .true.;;;\
if( register )then;;; \
call t123_TestExe_addTest(_M_CAT(Test_,i),__FILE__,__LINE__,#A,#B);;; \
register = .false.;;; \
else;;; \
call _M_CAT(InternalTest_,i)();;; \
endif;;; \
contains;;;\
subroutine _M_CAT(InternalTest_,i)();;;\

#define TEST(A,B) SETUP_TEST(A,B,__COUNTER__)
#define END_TEST end subroutine;;;end subroutine

#define _M_LOOP(i, _) _M_CAT(call Test_,i)();;;

#undef RUN_ALL_TESTS

#define RUN_ALL_TESTS() \
call t123_TestExe_init();;;\
_M_EVAL(_M_REPEAT(__COUNTER__, _M_LOOP, ~));;;\
call t123_TestExe_finish();;;\
if( t123_RETURN_CODE/=0 )STOP 1

#define EXPECT_OR_ASSERT(OPER,FATAL,ref,test) if( .not.t123_TestExe_addTestPartResult(__FILE__,__LINE__,#ref,t123_printToString(ref),#test,t123_printToString(test),#OPER,ref OPER test,FATAL) )write(6,'(a)',advance='no')
#define EXPECT_EQ(ref,test) EXPECT_OR_ASSERT(==,.FALSE.,ref,test)
#define ASSERT_EQ(ref,test) EXPECT_OR_ASSERT(==,.TRUE.,ref,test)