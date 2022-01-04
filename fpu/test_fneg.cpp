#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fneg.hpp"
#define DEBUG 1
#define CHECK 1

int check(){
    bool flg = true;
    for (uint32_t ite=0; ite<0xFFFFFFFF; ite++){
        if (isNumber(ite)){
            union fi input, correct;
            input.i = ite;
            vd v = {ite, 32};
            vd result = fneg(v);
            if (ite == 0) {
                correct.f = 0.0;
            }
            else {
                correct.f = -(input.f);
            }
            if (result.data != correct.i){
                flg = false;
                bit_print(result.data);
                cout << result.data << endl;
                bit_print(correct.i);
                cout << correct.i << endl;
                break;
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
    ifstream in("../../fpu/fneg/sample_fneg.txt");
    cin.rdbuf(in.rdbuf());
    string op, res;
    union fi op_ui, res_ui;
    cout << dec;
    for (int i=0; i<11001; i++){
        cin >> op >> res;
        // cout << op << " " << res << endl;
        op_ui.i = stoul(op, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v = {op_ui.i, 32};
        vd result = fneg(v);
        if (result.data != res_ui.i){
            cout << "error in " << i+1 << "line" << endl;
            bit_print(op_ui.i);
            bit_print(res_ui.i);
            bit_print(result.data);
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