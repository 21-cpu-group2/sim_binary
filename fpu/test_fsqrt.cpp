#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <cmath>
#include "fpu_items.hpp"
#include "fsqrt.hpp"
#define DEBUG 1
#define CHECK 1

int check(){
    bool flg = true;
    for (uint32_t ite=0; ite<0xFFFFFFFF; ite++){
        if (isNumber(ite) && (ite & 0x80000000) == 0){
            union fi input, output;
            input.i = ite;
            vd v = {ite, 32};
            vd result = fsqrt(v);
            output.i = result.data;
            double correct = sqrt((double)input.f);
            if (abs((double)output.f - correct) >= max(abs(correct)*pow(2, -20), eps)){
                flg = false;
            }
        }
    }
    if (flg){
        cout << "test passed" << endl;
    }
    else {
        cout << "test failed" << endl;
    }
    return 0;
}

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
    if (CHECK){
        cout << "check_simulator" << endl;
        check();
        return 0;
    }
    cout << hex ;
    if (DEBUG) {
        cout << "testing_simulator" << endl;
        test_simulator();
        return 0;
    }
    return 0;
}
