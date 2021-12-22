#ifndef _FABS
#define _FABS
#include "fpu_items.hpp"
using namespace std;

vd fabs(vd op){
    vd result;
    vd zero = {0,1};
    assign(&result, zero, 31, 31);
    assign(&result, slice(op, 30, 0), 30, 0);
    return result;
}

#endif