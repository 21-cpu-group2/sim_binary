#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "ftoi.hpp"

int main(){
    vd v0 = {0xC0A9999A, 32}; // -5.0
    vd v1 = {0x40ACCCCD, 32};
    vd zero = {0x00000000, 32};
    cout << hex ;
    cout << ftoi(v0).data << endl;
    cout << ftoi(v1).data << endl;
    cout << ftoi(zero).data << endl;
    return 0;
}