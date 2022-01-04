#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <random>
#include "fpu_items.hpp"
#include "fdiv.hpp"

using namespace std;

 #define eps pow(2, -126)

#define DEBUG 1

int test_simulator(){
    ifstream in("../../fpu/fdiv/sample_fdiv.txt");
    cin.rdbuf(in.rdbuf());
    string op1, op2, res;
    union fi op1_ui, op2_ui, res_ui, result_ui;
    cout << dec;
    for (int i=0; i<13001; i++){
        cin >> op1 >> op2 >> res;
        // cout << op << " " << res << endl;
        op1_ui.i = stoul(op1, 0, 2);
        op2_ui.i = stoul(op2, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v1 = {op1_ui.i, 32};
        vd v2 = {op2_ui.i, 32};
        vd result = fdiv(v1, v2);
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
    // b.i = floor(v1).data;
    // c.i = floor(v2).data;
    // d.i = floor(v3).data;
    // cout << b.f << endl;
    // cout << c.f << endl;
    // cout << d.f << endl;
    return 0;
}