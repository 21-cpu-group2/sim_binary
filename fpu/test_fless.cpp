#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fless.hpp"

int main(){
    vd v0 = {0xF01321FF, 32};
    vd v1 = {0x701321FF, 32};
    vd zero = {0x00000000, 32};
    cout << fless(v0, v1).data << endl;
    cout << fless(v1, v0).data << endl;
    cout << fless(v0, v0).data << endl;
    return 0;
}