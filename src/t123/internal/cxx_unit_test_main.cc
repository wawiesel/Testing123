#include "t123/TestFile.hh"

int main( int argc, char **argv )
{
    t123::TestFile::init( argc, argv );
    return RUN_ALL_TESTS();
}
