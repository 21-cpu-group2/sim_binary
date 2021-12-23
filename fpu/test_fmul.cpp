#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fpu_items.hpp"
#include "fmul.hpp"


int main(){
    vd sig1 = {0x1, 1};
    vd exp1 = {127, 8};
    vd fra1 = {0x400000, 23};
    vd sig2 = {0x0, 1};
    vd exp2 = {127, 8};
    vd fra2 = {0x7fff00, 23};
    my_float f1 = {sig1, exp1, fra1};
    my_float f2 = {sig2, exp2, fra2};
    my_float result = fmul(f1, f2);
    cout << "op1 = " << mf_to_d(f1) << endl;
    cout << "op2 = " << mf_to_d(f2) << endl;
    cout << "result = " << mf_to_d(result) << endl;
    cout << hex;
    cout << result.sgn.data << endl;
    cout << result.exp.data << endl;
    cout << result.fra.data << endl;
    return 0;
}