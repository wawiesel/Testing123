#include "Testing123.hh"
#include "internal/STEAL_PRIVATE_METHOD.hh"

namespace testing {

//static
void Testing123::init(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
}

}

