#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fisneg.hpp"
#define DEBUG 1
#define CHECK 1

int check(){
    bool flg = true;
    for (uint32_t ite=0; ite<0xFFFFFFFF; ite++){
        if (isNumber(ite)){
            union fi input, output, correct;
            input.i = ite;
            vd v = {ite, 32};
            vd result = fisneg(v);
            output.i = result.data;
            if (((input.f < 0) ^ (result.data))){
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

