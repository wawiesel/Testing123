#include <cmath> /*std::abs*/

#define EXPECTORASSERT_VEC_EQ(name,a,b)\
do {\
    name##_EQ(a.size(),b.size());\
    for(size_t i=0; i<a.size(); ++i)\
    {\
        if( i<b.size() )\
            name##_EQ(a[i], b[i] )<<" not equal at element i="<<i;\
    }\
} while(false)

#define EXPECTORASSERT_VEC_NEAR(name,a,b,tol)\
do {\
    name##_EQ(a.size(),b.size());\
    for(size_t i=0; i<a.size(); ++i)\
    {\
        if( i<b.size() )\
            name##_NEAR( a[i], b[i], tol )<<" not near at element i="<<i;\
    }\
} while(false)

#define EXPECTORASSERT_APPROX(name,a,b,tol)\
do {\
    name##_NEAR(a,b,std::abs(tol*a));\
} while(false)

#define EXPECTORASSERT_VEC_APPROX(name,a,b,tol)\
do {\
    name##_EQ(a.size(),b.size());\
    for(size_t i=0; i<a.size(); ++i)\
    {\
        if( i<b.size() )\
            name##_APPROX( a[i], b[i], tol )<<" not approx at element i="<<i;\
    }\
} while(false)

#define EXPECT_VEC_EQ(a,b) EXPECTORASSERT_VEC_EQ(EXPECT,a,b)
#define ASSERT_VEC_EQ(a,b) EXPECTORASSERT_VEC_EQ(ASSERT,a,b)

#define EXPECT_VEC_NEAR(a,b,tol) EXPECTORASSERT_VEC_NEAR(EXPECT,a,b,tol)
#define ASSERT_VEC_NEAR(a,b,tol) EXPECTORASSERT_VEC_NEAR(ASSERT,a,b,tol)

#define EXPECT_APPROX(a,b,tol) EXPECTORASSERT_APPROX(EXPECT,a,b,tol)
#define ASSERT_APPROX(a,b,tol) EXPECTORASSERT_APPROX(ASSERT,a,b,tol)

#define EXPECT_VEC_APPROX(a,b,tol) EXPECTORASSERT_VEC_APPROX(EXPECT,a,b,tol)
#define ASSERT_VEC_APPROX(a,b,tol) EXPECTORASSERT_VEC_APPROX(ASSERT,a,b,tol)
