#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fless.hpp"
#define DEBUG 1
#define CHECK 1

const float FLOAT_MIN = pow(2, -126);
const float FLOAT_MAX = pow(2, 127);

int check(){
    bool flg = true;
    random_device rd;
    default_random_engine eng(rd());
    uniform_real_distribution<float> distr(FLOAT_MIN, FLOAT_MAX);
    for (uint32_t ite=0; ite<0xFFFFFFFF; ite++){
        if (isNumber(ite)){
            union fi op1_fi, op2_fi, min_fi, max_fi;
            op1_fi.i = ite;
            op2_fi.f = distr(eng);
            min_fi.f = FLOAT_MIN;
            max_fi.f = FLOAT_MAX;
            vd op1 = {op1_fi.i, 32};
            vd op2 = {op2_fi.i, 32};
            vd zero = {0, 32};
            vd min_f = {min_fi.i, 32}; 
            vd max_f = {max_fi.i, 32}; 
            if ((fless(op1, op2).data == 1) ^ (op1_fi.f < op2_fi.f)){
                cout << "error" << endl;
            } 
            if ((fless(op1, constant(0, 32)).data == 1) ^ (op1_fi.f < 0.0)){
                cout << "error" << endl;
            }
            if ((fless(op1, min_f).data == 1) ^ (op1_fi.f < FLOAT_MIN)){
                cout << "error" << endl;
            }
            if ((fless(op1, max_f).data == 1) ^ (op1_fi.f < FLOAT_MAX)){
                cout << "error" << endl;
            }
        }
    }
    cout << "half" << endl;
    for (uint32_t ite=0; ite<0xFFFFFFFF; ite++){
        if (isNumber(ite)){
            union fi op1_fi, op2_fi, min_fi, max_fi;
            op2_fi.i = ite;
            op1_fi.i = distr(eng);
            min_fi.f = FLOAT_MIN;
            max_fi.f = FLOAT_MAX;
            vd op1 = {op1_fi.i, 32};
            vd op2 = {op2_fi.i, 32};
            vd zero = {0, 32};
            vd min_f = {min_fi.i, 32}; 
            vd max_f = {max_fi.i, 32}; 
            if ((fless(op1, op2).data == 1) ^ (op1_fi.f < op2_fi.f)){
                cout << "error" << endl;
            } 
            if ((fless(constant(0, 32), op2).data == 1) ^ (0.0 < op2_fi.f)){
                cout << "error" << endl;
            }
            if ((fless(min_f, op2).data == 1) ^ (FLOAT_MIN < op2_fi.f)){
                cout << "error" << endl;
            }
            if ((fless(max_f, op2).data == 1) ^ (FLOAT_MAX < op2_fi.f)){
                cout << "error" << endl;
            }
        }
    }
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