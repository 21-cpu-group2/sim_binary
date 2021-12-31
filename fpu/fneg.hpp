#ifndef _FNEG
#define _FNEG
#include "fpu_items.hpp"
using namespace std;

inline vd fneg(vd op){
    vd result;
    assign(&result, vd_not(slice(op, 31, 31)), 31, 31);
    assign(&result, slice(op, 30, 0), 30, 0);
    return result;
}

#endif