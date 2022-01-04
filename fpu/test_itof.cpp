#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <random>
#include "fpu_items.hpp"
#include "itof.hpp"
#define DEBUG 1
#define CHECK 1

int check(){
    bool flg = true;
    for (uint32_t ite=0; ite<0xFFFFFFFF; ite++){
        int i = (int)ite;
        union fi result_fi;
        vd op = {ite, 32};
        vd result = itof(op);
        result_fi.i = result.data;
        if (ite == 0) {
            if (result_fi.i == 0) continue;
        }
        // 候補
        union fi c1, c2, c3;
        c2.i = result_fi.i - 1;
        c3.i = result_fi.i + 1;
        if ( ((abs((double)c2.f - (double)i) < abs((double)result_fi.f - (double)i))
           || (abs((double)c3.f - (double)i) < abs((double)result_fi.f - (double)i))) ){
            cout << c2.f << endl;
            cout << result_fi.f << endl;
            flg = false;
            break;
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
    ifstream in("../../fpu/itof/sample_itof.txt");
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
        vd result = itof(v);
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
