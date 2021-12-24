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
    vd f1 = concat3(sig1, exp1, fra1);
    vd f2 = concat3(sig2, exp2, fra2);
    vd result = fmul(f1, f2);
    cout << "op1 = " << vd_to_d(f1) << endl;
    cout << "op2 = " << vd_to_d(f2) << endl;
    cout << "result = " << vd_to_d(result) << endl;
    cout << result.data << endl;
    cout << hex;
    cout << slice(result, 31, 31).data << endl;
    cout << slice(result, 30, 23).data << endl;
    cout << slice(result, 22, 0).data << endl;
    return 0;
}