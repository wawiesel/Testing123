#include "c_linkage.h"
#include "t123/TestExe.hh"

void t123_TestExe_c_addTestPartResult(const char* file, int line)
{
    t123::TestExe::addTestPartResult(file,line);
}

void t123_TestExe_c_addTest(const char* file, int line,
    const char* test_case_name,
    const char* test_name)
{
    t123::TestExe::addTest(file,line,test_case_name,test_name);
}

void t123_TestExe_c_init(int argc, char **argv)
{
    t123::TestExe::init(argc,argv);

}

int t123_TestExe_c_finish()
{
    return t123::TestExe::finish();
}
