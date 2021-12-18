#include <iostream>
#include <string>
#include <stdlib.h>
using namespace std;

union fi{
    uint32_t i;
    float f;
} ;

uint32_t hex2int(string hex) {
    // std::stoiがうまく機能しないので自分で実装。
    int ofst = (hex.at(1) == 'x') ? 2 : 0;
    uint32_t ret = 0x00000000;
    for (int i=0; i<hex.size()-ofst; i++){
        ret <<= 4;
        if ((uint32_t)(hex.at(i + ofst) - '0') < 10){ // num
            ret += (uint32_t)(hex.at(i + ofst) - '0');
        } 
        else {
            ret += (uint32_t)(hex.at(i + ofst) - 'A') + (uint32_t)10;
        }
    }
    return ret;
}

int main (){
    while (1) {
        string s;
        cin >> s;
        uint32_t float_bit = hex2int(s);
        union fi fl;
        fl.i = float_bit;
        cout << hex << float_bit << endl;
        printf("%8.8f\n", fl.f);
        cout << hex << "0x" << fl.i << endl;
    }
    return 0;
}