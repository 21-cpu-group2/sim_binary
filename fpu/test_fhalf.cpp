#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fhalf.hpp"

int main(){
    union fi a, b, c;
    a.f = 2.0;
    b.f = 3.0;
    c.f = -20.0;
    vd v0 = {a.i, 32};
    vd v1 = {b.i, 32};
    vd v2 = {c.i, 32};
    a.i = fhalf(v0).data;
    b.i = fhalf(v1).data;
    c.i = fhalf(v2).data;
    cout << a.f << endl;
    cout << b.f << endl;
    cout << c.f << endl;
    return 0;
}