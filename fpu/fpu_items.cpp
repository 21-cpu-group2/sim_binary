#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fpu_items.hpp"

#define vd velilog_data
using namespace std;

int main(void){
    velilog_data v0 = {0x00000005, 4};
    velilog_data v1 = {0x00000002, 4};
    velilog_data v2 = {0x0000000D, 4};
    vd v3 = {0x0000FE33, 16};
    cout << hex << sr(v3, 4).data << endl;
    cout << sl(v3, 3).data << endl;
    v3 = slice(v3, 11, 4);
    cout << hex << concat2(v0, v1).data << endl;
    cout << concat3(v0, v1, v2).data << endl;
    cout << concat4(v0, v1, v2, v3).data << endl;
    cout << add(v0, v1).data << endl;
    cout << sub(v0, v1).data << endl;
    cout << mul(v1, v2, 4).data << endl;

    return 0;
}
