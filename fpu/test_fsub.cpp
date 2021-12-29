#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include <random>
#include "fpu_items.hpp"
#include "fsub.hpp"

using namespace std;

 #define eps pow(2, -126)

int main(){
    union fi a, b, c, d;
    a.f = 2.3;
    b.f = 3.5;
    c.f = -20.0; // 0x41A00000
    d.f = -6.1;
    vd v0 = {a.i, 32};
    vd v1 = {b.i, 32};
    a.i = fsub(v0, v1).data;
    cout << a.f<< endl;

    // random_device rnd;
    // default_random_engine eng(rnd());
    // uniform_real_distribution<> distr(FLOAT_MIN, FLOAT_MAX);
    // mt19937 mt(rnd());
    // for (int ite=0; ite<100000000; ite++){
    //     int ai = mt();
    //     int bi = mt();
    //     // a.i = ai;
    //     // b.i = bi;
    //     a.f = distr(eng);
    //     b.f = distr(eng);
    //     vd v0 = {a.i, 32};
    //     vd v1 = {b.i, 32};
    //     c.i = fdiv(v0, v1).data;
    //     cout << fixed << setprecision(10);
    //     if ((abs(c.f - (a.f / b.f)) >= max(abs(a.f / b.f) * pow(2, -20), eps))) {
    //         cout << "error" << endl;
    //         cout << a.f << endl;
    //         cout << b.f << endl;
    //         cout << c.f << " " << (a.f / b.f) << endl;
    //     }
    //     if ((ite-1) % 10000000 == 0) cout << "10%" << endl;
    // }
    // b.i = floor(v1).data;
    // c.i = floor(v2).data;
    // d.i = floor(v3).data;
    // cout << b.f << endl;
    // cout << c.f << endl;
    // cout << d.f << endl;
    return 0;
}