#ifndef _FABS
#define _FABS
#include "fpu_items.hpp"
using namespace std;

inline vd fmul(my_float op1, my_float op2){
    my_float result;
    vd exp1 = op1.exp;
    vd exp2 = op2.exp;
    vd sig1 = op1.sgn;
    vd sig2 = op2.sgn;
    vd H1 = concat2(constant(1, 1), slice(op1.fra, 22, 11));
    vd H2 = concat2(constant(1, 1), slice(op2.fra, 22, 11));
    vd L1 = slice(op1.fra, 10, 0);
    vd L2 = slice(op2.fra, 10, 0);
}

#endif