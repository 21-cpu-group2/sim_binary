#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "ftoi.hpp"
#define DEBUG 1

int test_simulator(){
    ifstream in("../../fpu/ftoi/sample_ftoi.txt");
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
        vd result = ftoi(v);
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
    cout << hex ;
    if (DEBUG) {
        cout << "testing_simulator" << endl;
        test_simulator();
        return 0;
    }
    vd v0 = {0xC0A9999A, 32}; // -5.0
    vd v1 = {0x40ACCCCD, 32};
    vd zero = {0x00000000, 32};
    cout << hex ;
    cout << ftoi(v0).data << endl;
    cout << ftoi(v1).data << endl;
    cout << ftoi(zero).data << endl;
    return 0;
}
