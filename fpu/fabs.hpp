#ifndef _FABS
#define _FABS
#include "fpu_items.hpp"
using namespace std;

inline vd fabs(vd op){
    vd result;
    vd pos = {0,1};
    assign(&result, pos, 31, 31);
    assign(&result, slice(op, 30, 0), 30, 0);
    return result;
}

#endif