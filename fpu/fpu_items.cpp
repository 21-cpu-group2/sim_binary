#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fpu_items.hpp"
#include "fabs.hpp"
#include "fisneg.hpp"

using namespace std;

int main(void){
    verilog_data v0 = {0x0000000F, 4};
    verilog_data v1 = {0x00000002, 4};
    verilog_data v2 = {0x0000000D, 4};
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
    vd v4 = {0x12345678, 32};
    vd zero = {0, 32};
    cout << fisneg(v4).data << endl;
    cout << fisneg(v4).bit_num << endl;
    assign(&v4, v0, 31, 28);
    cout << hex << fabs(v4).data << endl;
    cout << fisneg(v4).data << endl;
    cout << fisneg(zero).data << endl;
    return 0;
}
