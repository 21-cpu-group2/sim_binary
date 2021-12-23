#ifndef _FABS
#define _FABS
#include "fpu_items.hpp"
using namespace std;

inline my_float fabs(my_float op){
    my_float result;
    assign(&(result.sgn), constant(0, 32), 31, 0);
    assign(&(result.fra), constant(0, 32), 31, 0);
    assign(&(result.exp), constant(0, 32), 31, 0);
    vd pos = {0,1};
    assign(&(result.sgn), pos, 0, 0);
    assign(&(result.fra), op.fra, 22, 0);
    assign(&(result.exp), op.exp, 7, 0);
    return result;
}

#endif