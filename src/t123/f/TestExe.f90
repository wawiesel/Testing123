module t123_TestExe_M
  use ISO_C_BINDING
  ! UnitTest -- highest level singleton modeled by this module
  !     TestCase -- a set of related tests
  !         Test -- a single test (modeled by t123_RUN_ONE_TEST)
  ! The macros
  !
  ! TEST(TestCaseName,TestName)
  !    ...
  ! END_TEST
  !
  ! creates a function which looks something like this
  !
  ! function Test_1()
  !    O_A(1)%O_P=>Test_1
  !    O_A(1)%O_Q=TestCaseName
  !    O_A(1)%O_R=TestName
  !    ...
  ! end function
  !
  ! This has the effect of associating this test function with
  ! element 1 in an array of test functions so that it can be
  ! called later in the main. Without the O_P pointer one would
  ! have to loop over all
  !use, intrinsic :: ISO_C_BINDING

  implicit none

  interface
     integer function func()
     end function func
  end interface

  type t123_RUN_ONE_TEST
     !procedure (func), pointer, nopass :: O_P  => NULL()
     character(256) :: O_Q,O_R
     !test pointer to C wrapper here
  end type

  type (t123_RUN_ONE_TEST), dimension (99999),save :: O_A

  integer,save :: O_N=0
  integer,save :: t123_RETURN_CODE=0

    interface
        subroutine t123_TestExe_c_init()&
            BIND(C,name="t123_TestExe_c_init")
        end subroutine
        subroutine t123_TestExe_c_addTestPartResult(file,line)&
            BIND(C,name="t123_TestExe_c_addTestPartResult")
            character(1),intent(in) :: file
            integer, intent(in)          :: line
        end subroutine
        subroutine t123_TestExe_c_addTest(file,line,test_case_name,test_name)&
            BIND(C,name="t123_TestExe_c_addTest")
            character(1),intent(in) :: file
            integer, intent(in)     :: line
            character(1),intent(in) :: test_case_name
            character(1),intent(in) :: test_name
        end subroutine
        integer function t123_TestExe_c_run()&
            BIND(C,name="t123_TestExe_c_run")
        end function
    end interface

contains

logical function t123_addTestPart(fileName,fileLine,refVariable,testVariable,equality) result(compare)
character(*),intent(in) :: fileName
integer,intent(in) :: fileLine
character(*),intent(in) :: refVariable,testVariable
logical,intent(in) :: equality

write(*,*)"refVariable=",refVariable
write(*,*)"testVariable=",testVariable
write(*,*)"equality=",equality

call t123_TestExe_c_addTestPartResult(fileName//C_NULL_CHAR,fileLine)
compare = equality
end function

subroutine t123_init()
!call t123_TestExe_c_init()
end subroutine

subroutine t123_run_all_tests()
integer :: i,o

do i=1,O_N
    write(*,*)'Test',i,': ',trim(O_A(i)%O_Q),".",trim(O_A(i)%O_R)
end do

end subroutine


end module
