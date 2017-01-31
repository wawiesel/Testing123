module t123_TestExe_M
  use ISO_C_BINDING
  ! TEST(TestCaseName,TestName)
  !    ...
  ! END_TEST
  !

  implicit none

  integer,save :: t123_RETURN_CODE=0

    interface

        subroutine t123_TestExe_c_init(argc,argv)&
            BIND(C,name="t123_TestExe_c_init")
              use ISO_C_BINDING
            integer(c_int), intent(in), value :: argc
            type(c_ptr), intent(in) :: argv(argc)
        end subroutine

        subroutine t123_TestExe_c_addTestPartResult(file,line,k,&
            refVariable,refValue,&
            testVariable,testValue,compareOper)&
            BIND(C,name="t123_TestExe_c_addTestPartResult")
              use ISO_C_BINDING
            character(1), VALUE :: file
            integer(C_INT), VALUE          :: line
            integer(C_INT), VALUE :: k
            character(1), VALUE :: refVariable,refValue
            character(1), VALUE :: testVariable,testValue
            character(1), VALUE :: compareOper
        end subroutine

        subroutine t123_TestExe_c_addTest(test_function,file,line,test_case_name,test_name)&
            BIND(C,name="t123_TestExe_c_addTest")
              use ISO_C_BINDING
            type(C_FUNPTR), VALUE :: test_function
            character(1), VALUE :: file
            integer(C_INT), VALUE     :: line
            character(1), VALUE :: test_case_name
            character(1), VALUE :: test_name
        end subroutine

        integer function t123_TestExe_c_finish()&
            BIND(C,name="t123_TestExe_c_finish")
              use ISO_C_BINDING
        end function
    end interface

    interface t123_printToString
        module procedure t123_printToString_C_DOUBLE
        module procedure t123_printToString_C_FLOAT
        module procedure t123_printToString_C_SIZE_T
        module procedure t123_printToString_C_INT
        module procedure t123_printToString_C_BOOL
        module procedure t123_printToString_C_STR
    end interface
contains

function t123_printToString_C_DOUBLE(x) result(y)
real(C_DOUBLE),intent(in) :: x
character(DIGITS(X)+7) :: y
WRITE(y,*)x
end function

function t123_printToString_C_FLOAT(x) result(y)
real(C_FLOAT),intent(in) :: x
character(DIGITS(X)+7) :: y
WRITE(y,*)x
end function

function t123_printToString_C_INT(x) result(y)
integer(C_INT),intent(in) :: x
character(DIGITS(X)+7) :: y
WRITE(y,*)x
end function

function t123_printToString_C_SIZE_T(x) result(y)
integer(C_SIZE_T),intent(in) :: x
character(DIGITS(X)+7) :: y
WRITE(y,*)x
end function

function t123_printToString_C_BOOL(x) result(y)
logical,intent(in) :: x
character(8) :: y
WRITE(y,*)x
end function

function t123_printToString_C_STR(x) result(y)
character(*),intent(in) :: x
character(len(x)) :: y
y=x
end function

subroutine t123_TestExe_addTest(test_function,fileName,fileLine,test_case_name,test_name)

  interface
    subroutine test_function()
    end subroutine
  end interface

character(*),intent(in) :: fileName
integer(C_INT),intent(in) :: fileLine
character(*),intent(in) :: test_case_name
character(*),intent(in) :: test_name

call t123_TestExe_c_addTest(C_FUNLOC(test_function),fileName//C_NULL_CHAR,fileLine,test_case_name//C_NULL_CHAR,test_name//C_NULL_CHAR)

end subroutine

logical function t123_TestExe_addTestPartResult(fileName,fileLine,&
    refVariable,refValue,testVariable,testValue,compareOper,compare,fatal) result(goOn)
character(*),intent(in) :: fileName
integer,intent(in) :: fileLine
character(*),intent(in) :: refVariable,testVariable,compareOper
character(*),intent(in) :: refValue,testValue
logical,intent(in) :: compare
logical,intent(in) :: fatal
integer(C_INT) :: k

if( compare )then
    k=0
else if ( fatal )then
    k=-1
else
    k=1
end if

call t123_TestExe_c_addTestPartResult(fileName//C_NULL_CHAR,fileLine,k,&
    refVariable//C_NULL_CHAR,TRIM(ADJUSTL(refValue))//C_NULL_CHAR,&
    testVariable//C_NULL_CHAR,TRIM(ADJUSTL(testValue))//C_NULL_CHAR,&
    compareOper//C_NULL_CHAR)
goOn = compare
end function

subroutine t123_TestExe_init()
    integer(c_int) :: argc
    type(c_ptr), allocatable :: argv(:)
    integer(c_int) :: l
    character(len=:), pointer :: arg
    integer :: arglen

    ! Get number of arguments
    argc = COMMAND_ARGUMENT_COUNT()+1
    allocate( argv(argc) )

    ! Iterate through arguments and convert to C_PTR.
    do l=0,argc-1
        ! Get command line argument in two passes so
        ! we get the exact length.
        call GET_COMMAND_ARGUMENT(l,length=arglen)
        allocate(character(arglen+1) :: arg)
        call GET_COMMAND_ARGUMENT(l,value=arg)

        ! Add \0 so C understands.
        arg = arg(1:arglen)//C_NULL_CHAR

        ! Convert to C_PTR (assume contiguous).
        argv(l+1) = c_loc(arg)

        ! NOTE: this is not freeing memory and we do not
        ! want it to. ARGC and ARGV must persist
        ! throughout calculation.
        nullify( arg )
    end do

    ! Call C initialization.
    call t123_TestExe_c_init(argc,argv)
end subroutine

subroutine t123_TestExe_finish()

t123_RETURN_CODE = t123_TestExe_c_finish()

end subroutine


end module
