#ifndef TestExe_STEAL_PRIVATE_METHOD_H
#define TestExe_STEAL_PRIVATE_METHOD_H

// I stole this from:
// http://bloglitb.blogspot.com/2010/07/access-to-private-members-thats-easy.html

// I need to use it because some very important GTest methods are hidden
// behind private.

namespace
{
template <typename Tag>
struct result
{
    /* export it ... */
    typedef typename Tag::type type;
    static type ptr;
};

template <typename Tag>
typename result<Tag>::type result<Tag>::ptr;

template <typename Tag, typename Tag::type p>
struct ROB : result<Tag>
{
    /* fill it ... */
    struct filler
    {
        filler() { result<Tag>::ptr = p; }
    };
    static filler filler_obj;
};
}

template <typename Tag, typename Tag::type p>
typename ROB<Tag, p>::filler ROB<Tag, p>::filler_obj;

#define M_STEAL_PRIVATE_METHOD( CLASS, METHOD, ... )  \
    struct STEAL_##METHOD                             \
    {                                                 \
        typedef void ( CLASS::*type )( __VA_ARGS__ ); \
    };                                                \
    template class ROB<STEAL_##METHOD, &CLASS::METHOD>

#define M_CALL_STOLEN_METHOD( X, Z ) ( X.*result<STEAL_##Z>::ptr )

#endif
