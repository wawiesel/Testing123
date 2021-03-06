#ifndef t123_TestFile_internal_c_linkage_H
#define t123_TestFile_internal_c_linkage_H

#ifdef __cplusplus
extern "C" {
#endif

void t123_TestFile_c_addTest( void ( *test_function )(),
                             const char* file,
                             int line,
                             const char* test_case_name,
                             const char* test_name );
void t123_TestFile_c_addTestPartResult( const char* file,
                                       int line,
                                       int k,
                                       const char* refVariable,
                                       const char* refValue,
                                       const char* testVariable,
                                       const char* testValue,
                                       const char* compareOper );

void t123_TestFile_c_init( int argc, char** argv );
int t123_TestFile_c_finish();

#ifdef __cplusplus
}
#endif

#endif
