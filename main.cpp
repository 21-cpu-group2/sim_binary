#include <iostream>
#include <string>
#include <map>
#include <sstream>
#include <fstream>
#include <vector>
#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <iterator>
#include "instruction.hpp"
#include "simulator.hpp"
#include "time_pred.hpp"

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
                    emu->args.start = stoll(argv[i+1], 0, 10);
                    i++;
                    break;
                case 'g':
                    emu->args.flg_g = true;
                    emu->args.goal = stoll(argv[i+1], 0, 10);
                    i++;
                    break;
                case 'm':
                    // -m start
                    // showing memory-state from start to start+128;
                    emu->args.flg_m = true;
                    emu->args.mem_s = stoi(argv[i+1], 0, 10);
                    i++;
                    break;
                case 'e':
                    emu->args.flg_e = true;
                    emu->args.endpc = stoi(argv[i+1], 0, 10);
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
        emu->stats.exec_times[emu->pc]++;
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
        //else if (flg && emu->args.flg_R) print_reg_for_debug(emu);
        else if (flg && emu->args.flg_m) print_mem(emu, emu->args.mem_s);  
        if (iteration % 1000000000 == 0) cout << iteration / 1000000000 << endl;
        if ((pc_pred == emu->pc) || (emu->args.flg_e && (emu->pc-1) == emu->args.endpc)) {
            // pcに変化なし or 指定されたpcなら終了
            break;
        }
    }
    double t_end = elapsed();
    if (PRINT_STAT){
        /*
        cout << t_end - t_start << "[s] elapsed" << endl;
        cout << dec << (iteration-1) << " instructions executed" << endl;
        cout << (iteration-1) / (t_end - t_start) << " instructions/sec" << endl;
        cout << "STATISTICS" << endl; 
        */
        long long int sum = 0ll;
        sum += emu->stats.beq;
        sum += emu->stats.bne;
        sum += emu->stats.blt;
        sum += emu->stats.bge;
        sum += emu->stats.lw;
        sum += emu->stats.sw;
        sum += emu->stats.addi;
        sum += emu->stats.slli;
        sum += emu->stats.srli;
        sum += emu->stats.add;
        sum += emu->stats.sub;
        sum += emu->stats.sll;
        sum += emu->stats.lui;
        sum += emu->stats.jal;
        sum += emu->stats.jalr;
        sum += emu->stats.fadd;
        sum += emu->stats.fsub;
        sum += emu->stats.fmul;
        sum += emu->stats.fdiv;
        sum += emu->stats.fhalf;
        sum += emu->stats.fsqrt;
        sum += emu->stats.fabs;
        sum += emu->stats.fneg;
        sum += emu->stats.fiszero;
        sum += emu->stats.fisneg;
        sum += emu->stats.fispos;
        sum += emu->stats.fless;
        sum += emu->stats.floor;
        sum += emu->stats.ftoi;
        sum += emu->stats.itof; 
        /*
        long long int total_clks = 0ll;
        total_clks += 4ll * emu->stats.beq;
        total_clks += 4ll * emu->stats.bne;
        total_clks += 4ll * emu->stats.blt;
        total_clks += 4ll * emu->stats.bge;
        total_clks += 44ll * emu->stats.lw;
        total_clks += 55ll * emu->stats.sw;
        total_clks += emu->stats.addi;
        total_clks += emu->stats.slli;
        total_clks += emu->stats.srli;
        total_clks += emu->stats.add;
        total_clks += emu->stats.sub;
        total_clks += emu->stats.sll;
        total_clks += emu->stats.lui;
        total_clks += emu->stats.jal;
        total_clks += 3ll * emu->stats.jalr;
        total_clks += fadd_clk * emu->stats.fadd;
        total_clks += fsub_clk * emu->stats.fsub;
        total_clks += fmul_clk * emu->stats.fmul;
        total_clks += fdiv_clk * emu->stats.fdiv;
        total_clks += emu->stats.fhalf;
        total_clks += fsqrt_clk * emu->stats.fsqrt;
        total_clks += emu->stats.fabs;
        total_clks += emu->stats.fneg;
        total_clks += emu->stats.fiszero;
        total_clks += emu->stats.fisneg;
        total_clks += emu->stats.fispos;
        total_clks += emu->stats.fless;
        total_clks += floor_clk * emu->stats.floor;
        total_clks += ftoi_clk * emu->stats.ftoi;
        total_clks += itof_clk * emu->stats.itof; 
        */
        /*
        cout << "  | beq : " << emu->stats.beq << " ( " << ((double)emu->stats.beq / (double)sum ) * 100 << " % )" << endl;
        cout << "  | bne : " << emu->stats.bne << " ( " << ((double)emu->stats.bne / (double)sum ) * 100 << " % )" << endl;
        cout << "  | blt : " << emu->stats.blt << " ( " << ((double)emu->stats.blt / (double)sum ) * 100 << " % )" << endl;
        cout << "  | bge : " << emu->stats.bge << " ( " << ((double)emu->stats.bge / (double)sum ) * 100 << " % )" << endl;
        cout << "  | lw : " << emu->stats.lw << " ( " << ((double)emu->stats.lw / (double)sum ) * 100 << " % )" << endl;
        cout << "  | sw : " << emu->stats.sw << " ( " << ((double)emu->stats.sw / (double)sum ) * 100 << " % )" << endl;
        cout << "  | addi : " << emu->stats.addi << " ( " << ((double)emu->stats.addi / (double)sum ) * 100 << " % )" << endl;
        cout << "  | slli : " << emu->stats.slli << " ( " << ((double)emu->stats.slli / (double)sum ) * 100 << " % )" << endl;
        cout << "  | srli : " << emu->stats.srli << " ( " << ((double)emu->stats.srli / (double)sum ) * 100 << " % )" << endl;
        cout << "  | add : " << emu->stats.add << " ( " << ((double)emu->stats.add / (double)sum ) * 100 << " % )" << endl;
        cout << "  | sub : " << emu->stats.sub << " ( " << ((double)emu->stats.sub / (double)sum ) * 100 << " % )" << endl;
        cout << "  | sll : " << emu->stats.sll << " ( " << ((double)emu->stats.sll / (double)sum ) * 100 << " % )" << endl;
        cout << "  | lui : " << emu->stats.lui << " ( " << ((double)emu->stats.lui / (double)sum ) * 100 << " % )" << endl;
        cout << "  | jal : " << emu->stats.jal << " ( " << ((double)emu->stats.jal / (double)sum ) * 100 << " % )" << endl;
        cout << "  | jalr : " << emu->stats.jalr << " ( " << ((double)emu->stats.jalr / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fadd : " << emu->stats.fadd << " ( " << ((double)emu->stats.fadd / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fsub : " << emu->stats.fsub << " ( " << ((double)emu->stats.fsub / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fmul : " << emu->stats.fmul << " ( " << ((double)emu->stats.fmul / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fdiv : " << emu->stats.fdiv << " ( " << ((double)emu->stats.fdiv / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fhalf : " << emu->stats.fhalf << " ( " << ((double)emu->stats.fhalf / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fsqrt : " << emu->stats.fsqrt << " ( " << ((double)emu->stats.fsqrt / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fabs : " << emu->stats.fabs << " ( " << ((double)emu->stats.fabs / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fneg : " << emu->stats.fneg << " ( " << ((double)emu->stats.fneg / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fiszero : " << emu->stats.fiszero << " ( " << ((double)emu->stats.fiszero / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fisneg : " << emu->stats.fisneg << " ( " << ((double)emu->stats.fisneg / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fispos : " << emu->stats.fispos << " ( " << ((double)emu->stats.fispos / (double)sum ) * 100 << " % )" << endl;
        cout << "  | fless : " << emu->stats.fless << " ( " << ((double)emu->stats.fless / (double)sum ) * 100 << " % )" << endl;
        cout << "  | floor : " << emu->stats.floor << " ( " << ((double)emu->stats.floor / (double)sum ) * 100 << " % )" << endl;
        cout << "  | ftoi : " << emu->stats.ftoi << " ( " << ((double)emu->stats.ftoi / (double)sum ) * 100 << " % )" << endl;
        cout << "  | itof : " << emu->stats.itof << " ( " << ((double)emu->stats.itof / (double)sum ) * 100 << " % )" << endl;
        cout << endl ;
        cout << "cache_hit_num : " << emu->stats.cache_hit << endl;
        cout << "cache_miss_num : " << emu->stats.cache_miss << endl;
        double hit_rate = (double)emu->stats.cache_hit / (double)(emu->stats.cache_hit + emu->stats.cache_miss);
        cout << fixed << setprecision(10) << hit_rate * (double)100.0 << " %" << endl;

        cout << endl;
        cout << "clks : " << total_clks << endl;
        cout << "predicted time (calculate) : " << total_clks / freq << " [s]" << endl;
        */
        cout << "clks : " << emu->clks << endl;
        cout << "predicted time (calculate) : " << (double)emu->clks / freq << " [s]" << endl;
        /*
        double speed_to_write_program_and_sld_to_fpga = (double)(1300 + 84248) / 7.5;
        int program_size = 84248;
        double time_to_write_program_and_sld_to_fpga = (double)(emu->reg[4] - in_start + program_size) / speed_to_write_program_and_sld_to_fpga;
        cout << "time to write_program and sld content to FPGA : " << time_to_write_program_and_sld_to_fpga << endl;
        // time to send output data to server
        double speed_to_send_output_data_to_server = (double)1572896.0 / 75.0;
        double time_to_send_output_data_to_server = (double)(emu->reg[5] - out_start) / speed_to_send_output_data_to_server;
        cout << "time to send output data to server : " << time_to_send_output_data_to_server << " [s]" << endl;
        */

        // print how many times each label is called
        FILE *fp;
        fp = fopen("data/stats.txt", "w");

        fprintf(fp, "%.5f [sec] Elapsed\n", t_end - t_start);
        fprintf(fp, "%lld [Instructions] Executed\n", (iteration -1));
        fprintf(fp, "%lld [Instructions/sec]\n", (iteration - 1)/(long long int)(t_end - t_start));

        // 実行時間予測
        fprintf(fp, "----------Time Prediction----------\n");
        double speed_to_write_program_and_sld_to_fpga = (double)(1300 + 84248) / 7.5;
        int program_size = 84248;
        double time_to_write_program_and_sld_to_fpga = (double)(emu->reg[4] - in_start + program_size) / speed_to_write_program_and_sld_to_fpga;
        fprintf(fp, "time to write program and sld content to FPGA : %.4f [s]\n", time_to_write_program_and_sld_to_fpga);
        double speed_to_send_output_data_to_server = (double)(104770.0 / 8.0);
        double time_to_send_output_data_to_server = (double)(emu->reg[5] - out_start) / speed_to_send_output_data_to_server;
        fprintf(fp, "time to send output data to server : %.4f [s]\n", time_to_send_output_data_to_server);
        double time_to_calculate = (double)emu->clks / freq;
        fprintf(fp, "time to calculate : %.4f [s]\n" ,time_to_calculate);
        double total_time =  time_to_send_output_data_to_server + time_to_write_program_and_sld_to_fpga + time_to_calculate;
        fprintf(fp, "Total time : %4.f [s]\n", total_time);
        double error_ratio = abs(227.6222 - total_time) / (227.6222);
        fprintf(fp, "Error ratio : %.4f %%\n", error_ratio * 100);

        fprintf(fp, "\n\n----------Times Each Registers Used----------\n\n");
        for (int i=0; i<32; i++){
            fprintf(fp, "%10s : %lld\n", reg_name[i], emu->stats.reg_used[i]);
        }
        fprintf(fp, "\n\n----------Ratio Each Instructions Called----------\n");
        fprintf(fp, "       beq : %.4f %% (%lld)\n", ((double)emu->stats.beq / (double)sum) * 100.0, emu->stats.beq);
        fprintf(fp, "       bne : %.4f %% (%lld)\n", ((double)emu->stats.bne / (double)sum) * 100.0, emu->stats.bne);
        fprintf(fp, "       blt : %.4f %% (%lld)\n", ((double)emu->stats.blt / (double)sum) * 100.0, emu->stats.blt);
        fprintf(fp, "       bge : %.4f %% (%lld)\n", ((double)emu->stats.bge / (double)sum) * 100.0, emu->stats.bge);
        fprintf(fp, "        lw : %.4f %% (%lld)\n", ((double)emu->stats.lw / (double)sum) * 100.0, emu->stats.lw);
        fprintf(fp, "        sw : %.4f %% (%lld)\n", ((double)emu->stats.sw / (double)sum) * 100.0, emu->stats.sw);
        fprintf(fp, "      addi : %.4f %% (%lld)\n", ((double)emu->stats.addi / (double)sum) * 100.0, emu->stats.addi);
        fprintf(fp, "      slli : %.4f %% (%lld)\n", ((double)emu->stats.slli / (double)sum) * 100.0, emu->stats.slli);
        fprintf(fp, "      srli : %.4f %% (%lld)\n", ((double)emu->stats.srli / (double)sum) * 100.0, emu->stats.srli);
        fprintf(fp, "       add : %.4f %% (%lld)\n", ((double)emu->stats.add / (double)sum) * 100.0, emu->stats.add);
        fprintf(fp, "       sub : %.4f %% (%lld)\n", ((double)emu->stats.sub / (double)sum) * 100.0, emu->stats.sub);
        fprintf(fp, "       sll : %.4f %% (%lld)\n", ((double)emu->stats.sll / (double)sum) * 100.0, emu->stats.sll);
        fprintf(fp, "       lui : %.4f %% (%lld)\n", ((double)emu->stats.lui / (double)sum) * 100.0, emu->stats.lui);
        fprintf(fp, "       jal : %.4f %% (%lld)\n", ((double)emu->stats.jal / (double)sum) * 100.0, emu->stats.jal);
        fprintf(fp, "      jalr : %.4f %% (%lld)\n", ((double)emu->stats.jalr / (double)sum) * 100.0, emu->stats.jalr);
        fprintf(fp, "      fadd : %.4f %% (%lld)\n", ((double)emu->stats.fadd / (double)sum) * 100.0, emu->stats.fadd);
        fprintf(fp, "      fsub : %.4f %% (%lld)\n", ((double)emu->stats.fsub / (double)sum) * 100.0, emu->stats.fsub);
        fprintf(fp, "      fmul : %.4f %% (%lld)\n", ((double)emu->stats.fmul / (double)sum) * 100.0, emu->stats.fmul);
        fprintf(fp, "      fdiv : %.4f %% (%lld)\n", ((double)emu->stats.fdiv / (double)sum) * 100.0, emu->stats.fdiv);
        fprintf(fp, "     fhalf : %.4f %% (%lld)\n", ((double)emu->stats.fhalf / (double)sum) * 100.0, emu->stats.fhalf);
        fprintf(fp, "     fsqrt : %.4f %% (%lld)\n", ((double)emu->stats.fsqrt / (double)sum) * 100.0, emu->stats.fsqrt);
        fprintf(fp, "      fabs : %.4f %% (%lld)\n", ((double)emu->stats.fabs / (double)sum) * 100.0, emu->stats.fabs);
        fprintf(fp, "      fneg : %.4f %% (%lld)\n", ((double)emu->stats.fneg / (double)sum) * 100.0, emu->stats.fneg);
        fprintf(fp, "   fiszero : %.4f %% (%lld)\n", ((double)emu->stats.fiszero / (double)sum) * 100.0, emu->stats.fiszero);
        fprintf(fp, "    fisneg : %.4f %% (%lld)\n", ((double)emu->stats.fisneg / (double)sum) * 100.0, emu->stats.fisneg);
        fprintf(fp, "    fispos : %.4f %% (%lld)\n", ((double)emu->stats.fispos / (double)sum) * 100.0, emu->stats.fispos);
        fprintf(fp, "     fless : %.4f %% (%lld)\n", ((double)emu->stats.fless / (double)sum) * 100.0, emu->stats.fless);
        fprintf(fp, "     floor : %.4f %% (%lld)\n", ((double)emu->stats.floor / (double)sum) * 100.0, emu->stats.floor);
        fprintf(fp, "      ftoi : %.4f %% (%lld)\n", ((double)emu->stats.ftoi / (double)sum) * 100.0, emu->stats.ftoi);
        fprintf(fp, "      itof : %.4f %% (%lld)\n", ((double)emu->stats.itof / (double)sum) * 100.0, emu->stats.itof);

        // print cache statistics
        fprintf(fp, "\n----------Cache Stats----------\n");
        fprintf(fp, "   cache hit : %lld [times]\n", emu->stats.cache_hit);
        fprintf(fp, "  cache miss : %lld [times]\n", emu->stats.cache_miss);
        fprintf(fp, "total access : %lld [times]\n", emu->stats.cache_hit + emu->stats.cache_miss);
        fprintf(fp, "   hit ratio : %.8f %%\n", (double)emu->stats.cache_hit / (double)(emu->stats.cache_hit + emu->stats.cache_miss) * 100.0);
        fprintf(fp, "  miss ratio : %.8f %%\n", (double)emu->stats.cache_miss / (double)(emu->stats.cache_hit + emu->stats.cache_miss) * 100.0);

        ifstream in("data/pc_label.txt");
        cin.rdbuf(in.rdbuf());
        int pc_temp;
        string label_temp;
        fprintf(fp, "\n\n----------Times Each Label Called----------\n");
        for (int i=0; i<100000; i++){
            cin >> pc_temp >> label_temp;
            if (pc_temp == -1){
                break;
            }
            fprintf(fp, "%30s : %lld\n", label_temp.c_str(), emu->stats.exec_times[pc_temp]);
        }

        fclose(fp);
    }

    print_reg(emu);
    output_image(emu);
    destroy_emulator(emu);

    // for (int ind = 0; ind < 128*128; ind++){
    //     cout << emu->memory[40000 + ind] << endl;
    // }

    return 0;
}