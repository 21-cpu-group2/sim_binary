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

    // for command line option
    string file_path;
    for (int i=0; i<argc; i++){
        if (argv[i][0] == '-'){
            switch (argv[i][1]) {
                case 'p':
                    emu->args.flg_p = true;
                    file_path = argv[i+1];
                    i++;
                    break;
                case 'a':
                    emu->args.flg_a = true;
                    break;
                case 'r':
                    emu->args.flg_r = true;
                    break;
                case 's':
                    emu->args.flg_s = true;
                    emu->args.start = stoi(argv[i+1], 0, 10);
                    i++;
                    break;
                case 'g':
                    emu->args.flg_g = true;
                    emu->args.goal = stoi(argv[i+1], 0, 10);
                    i++;
                    break;
                default :
                    cout << "option \"" << argv[i][1] << "\" unsupported" << endl;
            }
        }
    }
    if (!emu->args.flg_p){
        cout << "error : no file input" << endl;
        return 1;
    }

    // load machine code to instruction-memory
    load_instructions(emu, file_path);
    
    cout << "simulator is ready." << endl;

    /*
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
    */
    double t_start = elapsed();
    int iteration = 1;
    if (emu->args.flg_a){
        while (1){
            uint32_t pc_pred = emu->pc;
            uint32_t inst = emu->instruction_memory[emu->pc];
            if ((!emu->args.flg_s || emu->args.start <= iteration)
                && (!emu->args.flg_g || emu->args.goal >= iteration)){
                emu->args.flg_a = true;
            } 
            else {
                emu->args.flg_a = false;
            }
            if (emu->args.flg_a) {
                cout << dec << endl;
                if (iteration % 10 == 1) cout << iteration << "st instruction" << endl;
                else if (iteration % 10 == 2) cout << iteration << "nd instruction" << endl;
                else if (iteration % 10 == 3) cout << iteration << "rd instruction" << endl;
                else cout << iteration << "th instruction" << endl;
            }
            exec_one_instruction(emu, inst);
            iteration++;
            if (emu->args.flg_a && emu->args.flg_r) print_reg(emu);
            if (pc_pred == emu->pc) break;  
        }
    }
    else {
        while (1){
            uint32_t pc_pred = emu->pc;
            uint32_t inst = emu->instruction_memory[emu->pc];
            bool flg = false;
            if ((!emu->args.flg_s || emu->args.start <= iteration)
                && (!emu->args.flg_g || emu->args.goal >= iteration)){
                flg = true;
            } 
            else {
                flg = false;
            }
            if (flg && emu->args.flg_r) {
                cout << dec << endl;
                if (iteration % 10 == 1) cout << iteration << "st instruction" << endl;
                else if (iteration % 10 == 2) cout << iteration << "nd instruction" << endl;
                else if (iteration % 10 == 3) cout << iteration << "rd instruction" << endl;
                else cout << iteration << "th instruction" << endl;
            }
            exec_one_instruction(emu, inst);
            iteration++;
            if (emu->args.flg_r && flg) print_reg(emu);
            if (pc_pred == emu->pc) break;  
        }
    }
    double t_end = elapsed();
    cout << t_end - t_start << "[s] elapsed" << endl;
    cout << dec << (iteration-1) << " instructions executed" << endl;
    cout << (iteration-1) / (t_end - t_start) << " instructions/sec" << endl;
    /*
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
            int iteration = 1;
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
    */
    destroy_emulator(emu);
    return 0;
}