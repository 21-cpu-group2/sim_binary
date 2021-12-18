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
    init_emulator(emu);
    // for (int i=0; i<100; i++){
    //     cout << emu->memory[40000 +i] << endl;
    // }
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
                case 'm':
                    // -m start
                    // showing memory-state from start to start+128;
                    emu->args.flg_m = true;
                    emu->args.mem_s = stoi(argv[i+1], 0, 10);
                    i++;
                    break;
                case 'R':
                    emu->args.flg_R = true;
                    int j;
                    for (j=i+1; j<argc; j++){
                        emu->args.reg_for_print[stoi(argv[j], 0, 10)] = true;
                    }
                    i = j + 1;
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
    // if (!(emu->args.flg_R && !emu->args.flg_r && !emu->args.flg_a && !emu->args.flg_m) &&
    //      !(!emu->args.flg_R && emu->args.flg_r && !emu->args.flg_a && !emu->args.flg_m) &&
    //      !(!emu->args.flg_R && !emu->args.flg_r && emu->args.flg_a && !emu->args.flg_m) &&
    //      !(!emu->args.flg_R && !emu->args.flg_r && !emu->args.flg_a && emu->args.flg_m) &&
    //      !(!emu->args.flg_R && !emu->args.flg_r && !emu->args.flg_a && !emu->args.flg_m)) {
    //     cout << (!emu->args.flg_R && !emu->args.flg_r && emu->args.flg_a && !emu->args.flg_m) << endl;
    //     cout << "you can selece atmost one option of (-a, -r, -R, -m)" << endl;
    //     return 1;
    // }

    // load machine code to instruction-memory
    load_instructions(emu, file_path);

    double t_start = elapsed();
    long long int iteration = 1;
    
    // showing like vivado simulator
    if (emu->args.flg_R){ 
        for (int i=0; i<REG_SIZE + FREG_SIZE; i++){
            if (emu->args.reg_for_print[i]){
                if (i < 10){ // r0 - r9
                    cout << dec << "   r" << i << "   ";
                }
                else if (i < 32){ // r10 - r31
                    cout << dec << "   r" << i << "  ";
                }
                else if (i < 42){ // f0 - f9
                    cout << dec << "   f" << i-32 << "   ";
                }
                else { // f10 - f31
                    cout << dec << "   f" << i-32 << "  ";
                }
                cout << "     ";
            }
        }
        cout << dec << "   pc   " << endl;
    }
    bool flg;
    while (1){
        uint32_t pc_pred = emu->pc;
        uint32_t inst = emu->instruction_memory[emu->pc];
        flg = ((!emu->args.flg_s || emu->args.start <= iteration)
            && (!emu->args.flg_g || emu->args.goal >= iteration)) ? true : false;
        
        if (flg && (emu->args.flg_r || emu->args.flg_m || emu->args.flg_a)) {
            cout << dec << endl;
            if (iteration % 10 == 1) cout << iteration << "st instruction";
            else if (iteration % 10 == 2) cout << iteration << "nd instruction";
            else if (iteration % 10 == 3) cout << iteration << "rd instruction";
            else cout << iteration << "th instruction";
            cout << "  (pc : " << emu->pc << ")"<< endl;
        }
        // print assembly code ?
        emu->args.print_asm = (flg && emu->args.flg_a) ? true : false;
        exec_one_instruction(emu, inst);
        iteration++;
        if (flg && emu->args.flg_r) print_reg(emu);
        else if (flg && emu->args.flg_R) print_reg_for_debug(emu);
        else if (flg && emu->args.flg_m) print_mem(emu, emu->args.mem_s);
        if (pc_pred == emu->pc) break;  
        if (iteration % 1000000000 == 0) cout << iteration / 1000000000 << endl;
    }
    double t_end = elapsed();
    if (PRINT_STAT){
        cout << t_end - t_start << "[s] elapsed" << endl;
        cout << dec << (iteration-1) << " instructions executed" << endl;
        cout << (iteration-1) / (t_end - t_start) << " instructions/sec" << endl;
    }

    print_reg(emu);
    output_image(emu);
    destroy_emulator(emu);

    // for (int ind = 0; ind < 128*128; ind++){
    //     cout << emu->memory[40000 + ind] << endl;
    // }

    return 0;
}