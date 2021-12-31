#ifndef _FHALF
#define _FHALF
#include "fpu_items.hpp"
using namespace std;

inline vd fhalf(vd op){
    vd result;
    vd exp = slice(op, 30, 23);
    vd exp_sub1 = subi(slice(op, 30, 23), 1);
    vd fra_shift = sr(slice(op, 22, 0), 1);
    if (equal(exp, make_vd(8,0))) {
        assign(&result, concat2(slice(op, 31, 23), fra_shift), 31, 0);
    }
    else if (equal(exp, make_vd(8,1))){
        assign(&result, concat4(slice(op, 31, 31), make_vd(8,0), make_vd(1,1), slice(op, 22, 1)), 31, 0);
    }
    else {
        assign(&result, concat3(slice(op, 31, 31), exp_sub1, slice(op, 22, 0)), 31, 0);
    }
    return result;
}

#endif