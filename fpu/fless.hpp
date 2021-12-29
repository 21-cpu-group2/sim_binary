#ifndef _FLESS
#define _FLESS
#include "fpu_items.hpp"
using namespace std;

inline vd fless(vd op1, vd op2){
    vd sig1 = slice(op1, 31, 31);
    vd sig2 = slice(op2, 31, 31);
    vd exp1 = slice(op1, 30, 23);
    vd exp2 = slice(op2, 30, 23);
    if (equal(sig1, sig2) && equal(exp1, exp2)) {
        if (lt(op1, op2)){
            return make_vd(1,1);
        }
        else {
            return make_vd(0,1);
        }
    }
    else if (equal(sig1, sig2)) {
        if (lt(exp1, exp2)) {
            return make_vd(1,1);
        }
        else{
            return make_vd(0,1);
        }
    }
    else{
        return sig1;
    }
}

#endif
