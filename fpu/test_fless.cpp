#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fless.hpp"
#define DEBUG 1
#define CHECK 0

int check(){
    return 1;
}

int test_simulator(){
    ifstream in("../../fpu/fless/sample_fless.txt");
    cin.rdbuf(in.rdbuf());
    string op1, op2, res;
    union fi op1_ui, op2_ui, res_ui;
    for (int i=0; i<11001; i++){
        cin >> op1 >> op2 >> res;
        // cout << op << " " << res << endl;
        op1_ui.i = stoul(op1, 0, 2);
        op2_ui.i = stoul(op2, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v1 = {op1_ui.i, 32};
        vd v2 = {op2_ui.i, 32};
        vd result = fless(v1, v2);
        if ((result.data == 1) ^ (res_ui.i == 1)){
            cout << "error" << endl;
            cout << op1_ui.f << endl;
            cout << op2_ui.f << endl;
            cout << (op1_ui.f < op2_ui.f) << endl;
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