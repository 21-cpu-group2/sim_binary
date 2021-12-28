#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fpu_items.hpp"
#include "itof.hpp"

int main(){
    union fi a, b, c, d;
    a.f = 2.3;
    b.f = 3.5;
    c.f = -20.0; // 0x41A00000
    d.f = -6.1;
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