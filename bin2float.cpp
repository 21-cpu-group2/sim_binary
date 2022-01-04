#include <iostream>
#include <string>
#include <stdlib.h>
using namespace std;

union fi{
    uint32_t i;
    float f;
} ;

int main(){
    union fi temp;
    string str;
    while (1){
        cin >> str;
        temp.i = stoul(str, 0, 2);
        cout << temp.f << endl;
    }
    return 0;
}