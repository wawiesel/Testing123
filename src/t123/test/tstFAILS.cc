
#ifdef TEST_COMPILE_CASE_VectorNotDefined
int main(){
    std::vector<double> x;
    return 0;
}
#endif

#ifdef TEST_COMPILE_CASE_BadMath
int main(){
    double x = 1.0*;
    return 0;
}
#endif

#ifdef TEST_COMPILE_CASE_PrivateCtor
class A
{
    private:
        A(){}
};
int main(){
    A a;
    return 0;
}
#endif

