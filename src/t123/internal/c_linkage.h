#ifndef t123_TestExe_internal_c_linkage_H
#define t123_TestExe_internal_c_linkage_H

#ifdef __cplusplus
extern "C" {
#endif

void t123_TestExe_c_addTest(const char* file, int line,
    const char* test_case_name,
    const char* test_name);
void t123_TestExe_c_addTestPartResult(const char* file, int line);

void t123_TestExe_c_init(int argc, char **argv);
int t123_TestExe_c_finish();

#ifdef __cplusplus
}
#endif

#endif
