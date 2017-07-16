#ifdef TEST_COMPILE_CASE_Null
int main(){
    //return 1 so it would fail if it was run as an actual test
    return 1;
}
#endif

#ifdef TEST_COMPILE_CASE_OperatorParentheses
class X
{
    public:
        bool operator()(){ return true; }
};
int main(){
    X x;
    auto z = x();
    //return 1 so it would fail if it was run as an actual test
    return 1;
}
#endif


