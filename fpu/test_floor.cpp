#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fpu_items.hpp"
#include "floor.hpp"

int main(){
    union fi a, b, c, d;
    a.f = 2.3;
    b.f = 3.5;
    c.f = -20.0; // 0x41A00000
    d.f = -6.1;
    vd v0 = {a.i, 32};
    vd v1 = {b.i, 32};
    vd v2 = {c.i, 32};
    vd v3 = {d.i, 32};
    a.i = floor(v0).data;
    b.i = floor(v1).data;
    c.i = floor(v2).data;
    d.i = floor(v3).data;
    cout << fixed << setprecision(10);
    cout << a.f << endl;
    cout << b.f << endl;
    cout << c.f << endl;
    cout << d.f << endl;
    return 0;
}