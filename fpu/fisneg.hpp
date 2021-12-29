#ifndef _FISNEG
#define _FISNEG
#include "fpu_items.hpp"
using namespace std;

inline vd fisneg(vd op){
    vd non_zero = vd_or_red(slice(op, 30, 23));
    vd result = vd_and(non_zero, slice(op, 31, 31));
    return result;
}

#endif