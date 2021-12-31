#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fisneg.hpp"

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
        result = fisneg(v);
        v_fi2.i = result.data;
        if(((result.data == 1) ^ (v_fi1.f < 0))) {
            cout << "error" << endl;
            bit_print(v_fi1.i);
            bit_print(v_fi2.i);
            cout << v_fi1.f << endl;
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