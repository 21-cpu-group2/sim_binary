#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fpu_items.hpp"
#include "fsqrt.hpp"

int main(){
    union fi a, b, c;
    a.f = 2.0;
    b.f = 3.0;
    c.f = 20.0;
    vd v0 = {a.i, 32};
    vd v1 = {b.i, 32};
    vd v2 = {c.i, 32};
    a.i = fsqrt(v0).data;
    b.i = fsqrt(v1).data;
    c.i = fsqrt(v2).data;
    cout << fixed << setprecision(10);
    cout << a.f << endl;
    cout << b.f << endl;
    cout << c.f << endl;
    return 0;
}