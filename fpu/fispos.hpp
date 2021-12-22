#ifndef _FISPOS
#define _FISPOS
#include "fpu_items.hpp"
using namespace std;

vd fispos(vd op){
    vd non_zero = vd_or_red(slice(op, 30, 23));
    vd result = vd_and(non_zero, vd_not(slice(op, 31, 31)));
    return result;
}

#endif