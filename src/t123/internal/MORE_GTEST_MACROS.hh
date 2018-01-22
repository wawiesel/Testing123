#include <cmath> /*std::abs*/
#include <algorithm> /*std::min*/
//-----------------------------------------------------------------------------

template <typename T1, typename T2>
inline
T1 MIN_SIZE_INTEGER( T1 n1, T2 n2 ) {
    return std::min(n1,static_cast<T1>(n2));
}

//-----------------------------------------------------------------------------

template <typename T1, typename T2>
inline
::testing::AssertionResult FUNCTION_COMPARE_VEC_EQ(const std::string& ref_name, const T1& ref, const std::string& test_name, const T2& test) {
    std::stringstream msg;
    bool pass = true;

    //test sizes first
    if( ref.size() != test.size() )
    {
        pass=false;
        msg << "vector sizes not equal:\n"<<
               " reference vector, "<<ref_name<<".size()="<<ref.size()<<"\n"<<
               " test vector, "<<test_name<<".size()="<<test.size()<<"\n";
    }

    //test any elements we can
    for( size_t i=0; i<MIN_SIZE_INTEGER(ref.size(),test.size()); ++i)
    {
        //use equality operator == instead of != to catch more custom comparison
        //operators that may not have != implemented
        if( !( ref[i] == test[i] ) )
        {
            pass=false;
            msg<<"vector element "<<i<<" not equal:\n"<<
               " reference, "<<ref_name<<"["<<i<<"]="<<ref[i]<<"\n"<<
               " test, "<<test_name<<"["<<i<<"]="<<test[i]<<"\n";
        }
    }

    if( pass )return ::testing::AssertionSuccess();

    return ::testing::AssertionFailure() << "\n"<<msg.str();
}

#define COMPARE_VEC_EQ(a,b) FUNCTION_COMPARE_VEC_EQ(#a,a,#b,b)
#define EXPECTORASSERT_VEC_EQ(name,a,b) name##_TRUE( COMPARE_VEC_EQ(a,b) )
#define EXPECT_VEC_EQ(a,b) EXPECTORASSERT_VEC_EQ(EXPECT,a,b)
#define ASSERT_VEC_EQ(a,b) EXPECTORASSERT_VEC_EQ(ASSERT,a,b)

//-----------------------------------------------------------------------------

template <typename T, typename U>
inline
::testing::AssertionResult FUNCTION_COMPARE_VEC_NEAR(const std::string& ref_name, const T& ref, const std::string& test_name, const T& test, const std::string& tol_name, const U& tol) {
    std::stringstream msg;
    bool pass = true;

    //test sizes first
    if( ref.size() != test.size() )
    {
        pass=false;
        msg << "  vector sizes not equal:\n"<<
               "    reference vector, "<<ref_name<<".size()="<<ref.size()<<"\n"<<
               "    test vector, "<<test_name<<".size()="<<test.size()<<"\n";
    }

    //test any elements we can
    for( size_t i=0; i<MIN_SIZE_INTEGER(ref.size(),test.size()); ++i)
    {
        //absolute tolerance
        if( std::abs(ref[i]-test[i]) > std::abs(tol) )
        {
            pass=false;
            msg<<"  vector element "<<i<<" not near:\n"<<
                 "    reference, "<<ref_name<<"["<<i<<"]="<<ref[i]<<"\n"<<
                 "    test, "<<test_name<<"["<<i<<"]="<<test[i]<<"\n";
        }
    }

    if( pass )return ::testing::AssertionSuccess();

    return ::testing::AssertionFailure() << "\n"<<
               "    with absolute tolerance, "<<tol_name<<" -> "<<tol<<"\n" << msg.str();
}

#define COMPARE_VEC_NEAR(a,b,tol) FUNCTION_COMPARE_VEC_NEAR(#a,a,#b,b,#tol,tol)
#define EXPECTORASSERT_VEC_NEAR(name,a,b,tol) name##_TRUE( COMPARE_VEC_NEAR(a,b,tol) )
#define EXPECT_VEC_NEAR(a,b,tol) EXPECTORASSERT_VEC_NEAR(EXPECT,a,b,tol)
#define ASSERT_VEC_NEAR(a,b,tol) EXPECTORASSERT_VEC_NEAR(ASSERT,a,b,tol)

//-----------------------------------------------------------------------------

template <typename T, typename U>
inline
::testing::AssertionResult FUNCTION_COMPARE_VEC_APPROX(const std::string& ref_name, const T& ref, const std::string& test_name, const T& test, const std::string& tol_name, const U& tol) {
    std::stringstream msg;
    bool pass = true;

    //test sizes first
    if( ref.size() != test.size() )
    {
        pass=false;
        msg << "  vector sizes not equal:\n"<<
               "    reference vector, "<<ref_name<<".size()="<<ref.size()<<"\n"<<
               "    test vector, "<<test_name<<".size()="<<test.size()<<"\n";
    }

    //test any elements we can
    for( size_t i=0; i<MIN_SIZE_INTEGER(ref.size(),test.size()); ++i)
    {
        //relative tolerance
        if( std::abs(ref[i]-test[i]) > std::abs(tol*ref[i]) )
        {
            pass=false;
            msg<<"  vector element "<<i<<" not approximately equal:\n"<<
               "    reference, "<<ref_name<<"["<<i<<"]="<<ref[i]<<"\n"<<
               "    test, "<<test_name<<"["<<i<<"]="<<test[i]<<"\n";
        }
    }

    if( pass )return ::testing::AssertionSuccess();

    return ::testing::AssertionFailure() << "\n"<<
               "    with relative tolerance, "<<tol_name<<" -> "<<tol<<"\n" << msg.str();
}

#define COMPARE_VEC_APPROX(a,b,tol) FUNCTION_COMPARE_VEC_APPROX(#a,a,#b,b,#tol,tol)
#define EXPECTORASSERT_VEC_APPROX(name,a,b,tol) name##_TRUE( COMPARE_VEC_APPROX(a,b,tol) )
#define EXPECT_VEC_APPROX(a,b,tol) EXPECTORASSERT_VEC_APPROX(EXPECT,a,b,tol)
#define ASSERT_VEC_APPROX(a,b,tol) EXPECTORASSERT_VEC_APPROX(ASSERT,a,b,tol)

//-----------------------------------------------------------------------------

#define EXPECTORASSERT_APPROX(name,a,b,tol) name##_NEAR(a,b,std::abs(tol*a))
#define EXPECT_APPROX(a,b,tol) EXPECTORASSERT_APPROX(EXPECT,a,b,tol)
#define ASSERT_APPROX(a,b,tol) EXPECTORASSERT_APPROX(ASSERT,a,b,tol)

//-----------------------------------------------------------------------------

