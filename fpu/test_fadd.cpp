#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fadd.hpp"
#define DEBUG 1

int test_simulator(){
    ifstream in("../../fpu/fadd/sample_fadd.txt");
    cin.rdbuf(in.rdbuf());
    string op1, op2, res;
    union fi op1_ui, op2_ui, res_ui, result_ui;
    cout << dec;
    for (int i=0; i<10001; i++){
        cin >> op1 >> op2 >> res;
        // cout << op << " " << res << endl;
        op1_ui.i = stoul(op1, 0, 2);
        op2_ui.i = stoul(op2, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v1 = {op1_ui.i, 32};
        vd v2 = {op2_ui.i, 32};
        vd result = fadd(v1, v2);
        result_ui.i = result.data;
        if (result.data != res_ui.i){
            cout << "error in " << i+1 << "line" << endl;
            cout << "  op1" << endl;
            bit_print(op1_ui.i);
            cout << op1_ui.f << endl;
            cout << "  op2" << endl;
            bit_print(op2_ui.i);
            cout << op2_ui.f << endl;
            cout << "  result" << endl;
            bit_print(result_ui.i);
            cout << result_ui.f << endl;
            cout << "  correct output" << endl;
            bit_print(res_ui.i);
            cout << res_ui.f << endl << endl; 
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
    vd sig1 = {0x1, 1};
    vd exp1 = {50, 8};
    vd fra1 = {0x123450, 23};
    vd sig2 = {0x0, 1};
    vd exp2 = {51, 8};
    vd fra2 = {0x4fff00, 23};
    vd f1 = concat3(sig1, exp1, fra1);
    vd f2 = concat3(sig2, exp2, fra2);
    vd result = fadd(f1, f2);
    cout << "op1 = " << vd_to_d(f1) << endl;
    cout << "op2 = " << vd_to_d(f2) << endl;
    cout << "result = " << vd_to_d(result) << endl;
    cout << hex;
    cout << result.data << endl;
    cout << slice(result, 31, 31).data << endl;
    cout << slice(result, 30, 23).data << endl;
    cout << slice(result, 22, 0).data << endl;
    return 0;
}