#ifndef _FLESS
#define _FLESS
#include "fpu_items.hpp"
using namespace std;

inline vd fless(vd op1, vd op2){
    vd sig1 = {0, 1};
    assign(&sig1, slice(op1, 31, 31), -1, -1);
    vd sig2 = {0, 1};
    assign(&sig2, slice(op2, 31, 31), -1, -1);
    vd exp1 = {0, 8};
    assign(&exp1, slice(op1, 30, 23), -1, -1);
    vd exp2 = {0, 8};
    assign(&exp2, slice(op2, 30, 23), -1, -1);

    if ((sig1.data == sig2.data) && (exp1.data == exp2.data)) {
        if ((slice(op1, 22, 0).data < slice(op2, 22, 0).data) ^ (sig1.data == 1)){
            return constant(1,1);
        }
        else {
            return constant(0,1);
        }
    }
    else if (sig1.data ==  sig2.data) {
        if ((exp1.data < exp2.data) ^ (sig1.data == 1)) {
            return constant(1,1);
        }
        else{
            return constant(0,1);
        }
    }
    else{
        return sig1;
    }
}

#endif
