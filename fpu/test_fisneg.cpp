#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fisneg.hpp"

int main(){
    vd v0 = {0xF01321FF, 32};
    vd v1 = {0x701321FF, 32};
    vd zero = {0x00000000, 32};
    cout << fisneg(v0).data << endl;
    cout << fisneg(v1).data << endl;
    cout << fisneg(zero).data << endl;
    return 0;
}