#ifndef _M_Testing123_internal_MACROS_H
#define _M_Testing123_internal_MACROS_H

#define _M_CAT(a, ...) _M_PRIMITIVE_CAT(a, __VA_ARGS__)
#define _M_PRIMITIVE_CAT(a, ...) a ## __VA_ARGS__

#define _M_IIF(c) _M_PRIMITIVE_CAT(_M_IIF_, c)
#define _M_IIF_0(t, ...) __VA_ARGS__
#define _M_IIF_1(t, ...) t

#define _M_COMPL(b) _M_PRIMITIVE_CAT(_M_COMPL_, b)
#define _M_COMPL_0 1
#define _M_COMPL_1 0

#define _M_BITAND(x) _M_PRIMITIVE_CAT(_M_BITAND_, x)
#define _M_BITAND_0(y) 0
#define _M_BITAND_1(y) y

#define _M_BITAND(x) _M_PRIMITIVE_CAT(_M_BITAND_, x)
#define _M_BITAND_0(y) 0
#define _M_BITAND_1(y) y

#define _M_INC(x) _M_PRIMITIVE_CAT(_M_INC_, x)
#define _M_INC_0 1
#define _M_INC_1 2
#define _M_INC_2 3
#define _M_INC_3 4
#define _M_INC_4 5
#define _M_INC_5 6
#define _M_INC_6 7
#define _M_INC_7 8
#define _M_INC_8 9
#define _M_INC_9 10
#define _M_INC_10 11

#define _M_DEC(x) _M_PRIMITIVE_CAT(_M_DEC_, x)
#define _M_DEC_0 0
#define _M_DEC_1 0
#define _M_DEC_2 1
#define _M_DEC_3 2
#define _M_DEC_4 3
#define _M_DEC_5 4
#define _M_DEC_6 5
#define _M_DEC_7 6
#define _M_DEC_8 7
#define _M_DEC_9 8
#define _M_DEC_10 9
#define _M_DEC_11 10


#define _M_CHECK_N(x, n, ...) n
#define _M_CHECK(...) _M_CHECK_N(__VA_ARGS__, 0,)
#define _M_PROBE(x) x, 1,

#define _M_IS_PAREN(x) _M_CHECK(_M_IS_PAREN_PROBE x)
#define _M_IS_PAREN_PROBE(...) _M_PROBE(~)

#define _M_NOT(x) _M_CHECK(_M_PRIMITIVE_CAT(_M_NOO_, x))
#define _M_NOO_0 _M_PROBE(~)

#define _M_BOOL(x) _M_COMPL(_M_NOT(x))
#define _M_IF(c) _M_IIF(_M_BOOL(c))

#define _M_EAT(...)
#define _M_EXPAND(...) __VA_ARGS__
#define _M_WHEN(c) _M_IF(c)(_M_EXPAND, _M_EAT)

#define _M_EMPTY()
#define _M_DEFER(id) id _M_EMPTY()
#define _M_OBSTRUCT(...) __VA_ARGS__ _M_DEFER(_M_EMPTY)()
#define _M_EXPAND(...) __VA_ARGS__

#define _M_EVAL(...)  _M_EVAL1(_M_EVAL1(_M_EVAL1(__VA_ARGS__)))
#define _M_EVAL1(...) _M_EVAL2(_M_EVAL2(_M_EVAL2(__VA_ARGS__)))
#define _M_EVAL2(...) _M_EVAL3(_M_EVAL3(_M_EVAL3(__VA_ARGS__)))
#define _M_EVAL3(...) _M_EVAL4(_M_EVAL4(_M_EVAL4(__VA_ARGS__)))
#define _M_EVAL4(...) _M_EVAL5(_M_EVAL5(_M_EVAL5(__VA_ARGS__)))
#define _M_EVAL5(...) __VA_ARGS__

#define _M_REPEAT(count, macro, ...) \
    _M_WHEN(count) \
    ( \
        _M_OBSTRUCT(_M_REPEAO_INDIRECT) () \
        ( \
            _M_DEC(count), macro, __VA_ARGS__ \
        ) \
        _M_OBSTRUCT(macro) \
        ( \
            _M_DEC(count), __VA_ARGS__ \
        ) \
    )
#define _M_REPEAO_INDIRECT() _M_REPEAT

#define _M_WHILE(pred, op, ...) \
    _M_IF(pred(__VA_ARGS__)) \
    ( \
        _M_OBSTRUCT(_M_WHILE_INDIRECT) () \
        ( \
            pred, op, op(__VA_ARGS__) \
        ), \
        __VA_ARGS__ \
    )
#define _M_WHILE_INDIRECT() _M_WHILE

#endif
