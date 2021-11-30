#include <iostream>
#include <string>
#include <map>
#include <sstream>
#include <fstream>
#include <vector>
#include <stdlib.h>
#include "instruction.hpp"
#include "simulator.hpp"

using namespace std;

double elapsed(){
	struct timespec ts;
	clock_gettime(CLOCK_REALTIME, &ts);
	return ts.tv_sec + ts.tv_nsec*1.0e-9;
}

uint32_t hex2int(string hex) {
    uint32_t ret = stoi(hex, nullptr, 16);
    return ret;
}

int main(int argc, char **argv){
    // initialize emulator
    Emulator* emu;
    emu = (Emulator*)malloc(sizeof(Emulator));
    init_emulator(emu, 0x0000);

    cout << "simulator is ready." << endl;
    
    while (1) {
        
        string inst_hex;
        cin >> inst_hex;
        uint32_t inst = hex2int(inst_hex);
        judge_optype(emu, inst);
        
    }
    destroy_emulator(emu);
    return 0;
}