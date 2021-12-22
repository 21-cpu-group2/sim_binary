#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fispos.hpp"

int main(){
    vd v0 = {0xF01321FF, 32};
    vd v1 = {0x701321FF, 32};
    vd zero = {0x00000000, 32};
    cout << fispos(v0).data << endl;
    cout << fispos(v1).data << endl;
    cout << fispos(zero).data << endl;
    return 0;
}