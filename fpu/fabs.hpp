#ifndef _FABS
#define _FABS
#include "fpu_items.hpp"
using namespace std;

// inline my_float fabs(my_float op){
//     my_float result;
//     result.sgn.bit_num = 1;
//     result.exp.bit_num = 8;
//     result.fra.bit_num = 23;
//     assign(&(result.sgn), constant(0, 32), 31, 0);
//     assign(&(result.fra), constant(0, 32), 31, 0);
//     assign(&(result.exp), constant(0, 32), 31, 0);
//     vd pos = {0,1};
//     assign(&(result.sgn), pos, 0, 0);
//     assign(&(result.fra), op.fra, 22, 0);
//     assign(&(result.exp), op.exp, 7, 0);
//     return result;
// }

inline vd fabs(vd op) {
    vd result = {0, 32};
    assign(&result, constant(0, 1), 31, 31);
    assign(&result, slice(op, 30, 0), 30, 0);
    // assign(&result, concat2(constant(0,1), slice(op, 30, 0)), -1, -1);
    if (result.data & 0x80000000){
        cout << result.bit_num << endl;
        cout << "error in fabs" << endl;
    }
    return result;
}

#endif