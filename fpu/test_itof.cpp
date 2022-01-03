#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <random>
#include "fpu_items.hpp"
#include "itof.hpp"
#define DEBUG 1

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
    cout << hex ;
    if (DEBUG) {
        cout << "testing_simulator" << endl;
        test_simulator();
        return 0;
    }
    union fi a, b, c, d;
    a.f = 2.3;
    b.f = 3.5;
    c.f = -20.0; // 0x41A00000
    d.f = -6.1;
    random_device rnd;
    mt19937 mt(rnd());
    normal_distribution<> norm(0.0, 10000.0);
    for (int ite =0; ite<1000; ite++){
        int a = mt();
        vd a_vd = {a, 32};
        union fi a_fi;
        a_fi.i = (itof(a_vd).data);
        //bit_print((uint32_t)a);
        //cout << (float)a << " " << a_fi.f << endl;
    }
    vd v0 = {3, 32};
    vd v1 = {100, 32};
    vd v2 = {3245, 32};
    vd v3 = {-13245, 32};
    a.i = itof(v0).data;
    b.i = itof(v1).data;
    c.i = itof(v2).data;
    d.i = itof(v3).data;
    cout << fixed << setprecision(10);
    cout << a.f << endl;
    cout << b.f << endl;
    cout << c.f << endl;
    cout << d.f << endl;
    return 0;
}
