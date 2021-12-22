#ifndef _FNEG
#define _FNEG
#include "fpu_items.hpp"
using namespace std;

inline vd fneg(vd op){
    vd result;
    vd neg = {1,1};
    assign(&result, neg, 31, 31);
    assign(&result, slice(op, 30, 0), 30, 0);
    return result;
}

#endif