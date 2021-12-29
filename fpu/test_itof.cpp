#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <random>
#include "fpu_items.hpp"
#include "itof.hpp"

using namespace std;

void bit_print(uint32_t n) {
    for (int i=0; i<32; i++){
        if (n & (1 << (31 - i))) {
            cout << "1";
        }
        else {
            cout << "0";
        }
    }
    cout << endl;
    return;
}

int main(){
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