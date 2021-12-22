#ifndef _FISZERO
#define _FISZERO
#include "fpu_items.hpp"
using namespace std;

vd fiszero(vd op){
    vd result = vd_not(vd_or_red(slice(op, 30, 23)));
    return result;
}

#endif