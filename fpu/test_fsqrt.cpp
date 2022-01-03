#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <cmath>
#include "fpu_items.hpp"
#include "fsqrt.hpp"

int main(){
    cout << hex ;
    int limit_print = 10;
    int print_num = 0;

    for (uint32_t ite=0x00000000; ite<0xFFFFFFFF; ite++){
        union fi v_fi1, v_fi2, fi3;
        v_fi1.i = ite;
        if (!isNaN(v_fi1.f) || v_fi1.f < 0) continue;
        vd v = {v_fi1.i, 32};
        vd result;
        result = fsqrt(v);
        v_fi2.i = result.data;
        if(abs(v_fi2.f - sqrt(v_fi1.f)) >= max(sqrt(v_fi1.f) * pow(2, -20), eps)) {
            cout << "error" << endl;
            fi3.f = sqrt(v_fi1.f);
            bit_print(v_fi1.i);
            bit_print(v_fi2.i);
            bit_print(fi3.i);
            cout << v_fi2.f << " " << sqrt(v_fi1.f) << endl;
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