#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fisneg.hpp"
#define DEBUG 1

int test_simulator(){
    ifstream in("../../fpu/fisneg/sample_fisneg.txt");
    cin.rdbuf(in.rdbuf());
    string op, res;
    union fi op_ui, res_ui;
    for (int i=0; i<11001; i++){
        cin >> op >> res;
        // cout << op << " " << res << endl;
        op_ui.i = stoul(op, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v = {op_ui.i, 32};
        vd result = fisneg(v);
        if (result.data != res_ui.i){
            cout << "error" << endl;
            bit_print(res_ui.i);
            bit_print(result.data);
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
    union fi v_fi1, v_fi2;
    int limit_print = 10;
    int print_num = 0;
    for (uint32_t ite=0x00000000; ite<0xFFFFFFFF; ite++){
        union fi v_fi1, v_fi2;
        v_fi1.i = ite;
        if (!isNumber(v_fi1.f)) continue;
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
