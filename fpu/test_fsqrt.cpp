#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <cmath>
#include "fpu_items.hpp"
#include "fsqrt.hpp"
#define DEBUG 1

int test_simulator(){
    ifstream in("../../fpu/fsqrt/sample_fsqrt.txt");
    cin.rdbuf(in.rdbuf());
    string op, res;
    union fi op_ui, res_ui, result_ui;
    cout << dec;
    for (int i=0; i<11001; i++){
        cin >> op >> res;
        // cout << op << " " << res << endl;
        op_ui.i = stoul(op, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v = {op_ui.i, 32};
        vd result = fsqrt(v);
        result_ui.i = result.data;
        if (result.data != res_ui.i){
            cout << "error in " << i+1 << "line" << endl;
            bit_print(op_ui.i);
            cout << op_ui.f << endl;
            bit_print(res_ui.i);
            cout << res_ui.f << endl;
            bit_print(result_ui.i);
            cout << result_ui.f << endl << endl;;
        }
    }
    return 0;
}

int main(){
    cout << hex ;
    if (DEBUG) {
        cout << "testing_simulator" << endl;
        test_simulator();
        return 0;
    }
    int limit_print = 10;
    int print_num = 0;

    for (uint32_t ite=0x00000000; ite<0xFFFFFFFF; ite++){
        union fi v_fi1, v_fi2, fi3;
        v_fi1.i = ite;
        if (!isNumber(v_fi1.f) || v_fi1.f < 0) continue;
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
