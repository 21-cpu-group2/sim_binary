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

int main(int argc, char **argv){
    // initialize emulator
    Emulator* emu;
    emu = (Emulator*)malloc(sizeof(Emulator));
    init_emulator(emu, 0x0000);

    // load machine code to instruction-memory
    string file_path = argv[1];
    load_instructions(emu, file_path);
    
    //  test 
    // test


    cout << "simulator is ready." << endl;

    int iteration = 0;
    if (DEBUG2) {
        while (1){
            uint32_t pc_pred = emu->pc;
            uint32_t inst = emu->instruction_memory[emu->pc];
            exec_one_instruction(emu, inst);
            iteration++;
            print_reg_for_debug(emu);
            if (pc_pred == emu->pc) break; 
        } 
        destroy_emulator(emu);
        return 0;
    }
    while (1) {
        
        string query; cin >> query;
        if (query == "reg") {
            print_reg(emu); 
            continue;
        }
        else if (query == "mem") {
            print_mem(emu); 
            continue;
        }
        else if (query == "n") {
            uint32_t inst = emu->instruction_memory[emu->pc];
            exec_one_instruction(emu, inst);
            continue;
        }
        else if (query == "p") {
            int n; cin >> n;
            for (int i=0; i<n; i++){
                uint32_t inst = emu->instruction_memory[emu->pc];
                exec_one_instruction(emu, inst);
            }
        }
        else if (query == "all") {
            double t_start = elapsed();
            int iteration = 0;
            while (1){
                uint32_t pc_pred = emu->pc;
                uint32_t inst = emu->instruction_memory[emu->pc];
                exec_one_instruction(emu, inst);
                iteration++;
                if (DEBUG) print_reg(emu);
                if (pc_pred == emu->pc) break;  
            }
            double t_end = elapsed();
            cout << t_end - t_start << "[s] elapsed" << endl;
            cout << iteration << " instructions executed" << endl;
            cout << iteration / (t_end - t_start) << " instructions/sec" << endl;
        }
        else if (query == "exit") {
            break;
        }
    }
    destroy_emulator(emu);
    return 0;
}