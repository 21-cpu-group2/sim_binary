#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fabs.hpp"

int main(){
    cout << hex ;
    union fi v_fi1, v_fi2;
    int limit_print = 10;
    int print_num = 0;
    for (uint32_t ite=0x00000000; ite<0xFFFFFFFF; ite++){
        union fi v_fi1, v_fi2;
        v_fi1.i = ite;
        if (!isNaN(v_fi1.f)) continue;
        vd v = {v_fi1.i, 32};
        vd result;
        result = fabs(v);
        v_fi2.i = result.data;
        if(v_fi2.f != abs(v_fi1.f)) {
            cout << "error" << endl;
            bit_print(v_fi2.i);
            cout << v_fi2.f << " " << abs(v_fi1.f) << endl;
            print_num++;
        }
        if (print_num > limit_print){
            break;
        }
        if ((ite & 0x0FFFFFFF) == 0){
            cout << "10%" << endl;
        }
    }
    return 0;
}
