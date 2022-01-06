#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fsub.hpp"
#define DEBUG 1
#define DEBUG2 0

int test_simulator(){
    ifstream in("../../fpu/fadd/sample_fsub.txt");
    cin.rdbuf(in.rdbuf());
    string op1, op2, res;
    union fi op1_ui, op2_ui, res_ui, result_ui;
    cout << dec;
    for (int i=0; i<20000; i++){
        cin >> op1 >> op2 >> res;
        // cout << op << " " << res << endl;
        op1_ui.i = stoul(op1, 0, 2);
        op2_ui.i = stoul(op2, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v1 = {op1_ui.i, 32};
        vd v2 = {op2_ui.i, 32};
        vd result = fsub(v1, v2);
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

int test_simulator_instance() {
    cout << dec;
    union fi op1_ui, op2_ui, res_ui, result_ui;
    op1_ui.i = 0b01111111010010111100101111001111;
    op2_ui.i = 0b01110101100110011111100011001111;
    vd v1 = {op1_ui.i, 32};
    vd v2 = {op2_ui.i, 32};
    vd result = fsub(v1, v2);
    result_ui.i = result.data;
    res_ui.i = 0b01111111010010111100101111100011;
    cout << endl;
    bit_print(op1_ui.i);
    bit_print(op2_ui.i);
    bit_print(result_ui.i);
    bit_print(res_ui.i);
    return 0;
}

int main(){
    cout << hex ;
    if (DEBUG2) {
        test_simulator_instance();
        return 0;
    }
    if (DEBUG) {
        cout << "testing_simulator" << endl;
        test_simulator();
        return 0;
    }
    return 0;
}