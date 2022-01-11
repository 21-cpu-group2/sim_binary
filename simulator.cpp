#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <iterator>

#include "simulator.hpp"

uint32_t bin2int(string bin) {
    // std::stoiがうまく機能しないので自分で実装。
    int ofst = (bin.at(1) == 'b') ? 2 : 0;
    uint32_t ret = 0x00000000;
    for (int i=0; i<bin.size()-ofst; i++){
        ret <<= 1;
        if (bin.at(i + ofst) == '1'){
            ret += 1;
        }
    }
    return ret;
}

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

void init_emulator(Emulator* emu){
    for (int i=0; i<REG_SIZE; i++){
        emu->reg[i] = 0x00000000;
    }
    //////////////////////////////////////////
    emu->pc = 0x00000000;

    //メモリを動的に確保
    emu->memory = (uint32_t*)malloc(sizeof(uint32_t) * MEMORY_SIZE);
    emu->instruction_memory = (uint32_t*)malloc(sizeof(uint32_t) * INSTRUCTION_MEMORY_SIZE);
    emu->cache = (cache_line*)malloc(sizeof(cache_line) * BLOCK_NUM);

    if (emu->memory == NULL || emu->instruction_memory == NULL){
        printf("error : cannot allocate memory\n");
        exit(1);
    }
    memset(emu->memory, 0, sizeof(uint32_t) * MEMORY_SIZE);
    memset(emu->instruction_memory, 0, sizeof(uint32_t) * INSTRUCTION_MEMORY_SIZE);
    memset(emu->cache, 0, sizeof(cache_line) * BLOCK_NUM);

    emu->instruction_size = 0x00000000;
    emu->args.flg_p = false;
    emu->args.flg_a = false;
    emu->args.flg_r = false;
    emu->args.flg_s = false;
    emu->args.flg_g = false;
    emu->args.flg_R = false;
    emu->args.flg_m = false;
    emu->args.flg_e = false;
    emu->args.print_asm = false;
    emu->args.start = 0;
    emu->args.goal = 0;
    emu->args.mem_s = 0;
    emu->args.endpc = 0;
    for (int i=0; i<REG_SIZE; i++){
        emu->args.reg_for_print[i] = false;
    }

    emu->stats.beq = 0ll;
    emu->stats.bne = 0ll;
    emu->stats.blt = 0ll;
    emu->stats.bge = 0ll;
    emu->stats.lw = 0ll;
    emu->stats.sw = 0ll;
    emu->stats.addi = 0ll;
    emu->stats.slli = 0ll;
    emu->stats.srli = 0ll;
    emu->stats.add = 0ll;
    emu->stats.sub = 0ll;
    emu->stats.sll = 0ll;
    emu->stats.lui = 0ll;
    emu->stats.jal = 0ll;
    emu->stats.jalr = 0ll;
    emu->stats.fadd = 0ll;
    emu->stats.fsub = 0ll;
    emu->stats.fmul = 0ll;
    emu->stats.fdiv = 0ll;
    emu->stats.fhalf = 0ll;
    emu->stats.fsqrt = 0ll;
    emu->stats.fabs = 0ll;
    emu->stats.fneg = 0ll;
    emu->stats.fiszero = 0ll;
    emu->stats.fisneg = 0ll;
    emu->stats.fispos = 0ll;
    emu->stats.fless = 0ll;
    emu->stats.floor = 0ll;
    emu->stats.ftoi = 0ll;
    emu->stats.itof = 0ll;
    for (int i=0; i<100000; i++){
        emu->stats.exec_times[i] = 0ll;
    }

    // memory <- input_data
    int input_start = 50000; // 200000 / 4
    ifstream ifs("data/contest.txt");
    if (ifs.fail()){
        cout << "cannot open the file \"contest.txt\"" << endl;
        return ;
    }
    string str;
    while (getline(ifs, str)){
        uint32_t n = (uint32_t)stoul(str, nullptr, 10);
        emu->memory[input_start++] = n;
    }

    if (DEBUG) {
        for (int i=0; i<emu->instruction_size; i++){
            cout << hex << "0x" << emu->instruction_memory[i] << endl;
        }
    }

    uint32_t address_mask = 0x07FFFFFF;
    emu->mask.tag_mask = (0xFFFFFFFF << (BLOCK_SIZE_BIT + BLOCK_NUM_BIT)) & address_mask;
    emu->mask.index_mask = ((0xFFFFFFFF << (BLOCK_SIZE_BIT)) ^ emu->mask.tag_mask) & address_mask;
    emu->mask.offset_mask = ((0xFFFFFFFF ^ emu->mask.tag_mask) ^ emu->mask.index_mask) & address_mask;
}

void destroy_emulator(Emulator* emu) {
    free(emu->memory);
    free(emu->instruction_memory);
    free(emu);
}

int load_instructions(Emulator* emu, string file_path){
    // read machine code and keep in instruction-memory
    ifstream ifs(file_path);
    if (ifs.fail()){
        return 1;
    }
    string str;
    bool fst = true;
    while (getline(ifs, str)){
        // if (fst) {
        //     uint32_t pc_init = (uint32_t)stoi(str, nullptr, 10);
        //     emu->pc = pc_init;
        //     fst = false;
        //     continue;
        // }
        if (str.at(0) == '/' && str.at(1) == '/'){
            continue;
        }
        uint32_t inst = bin2int(str);
        emu->instruction_memory[emu->instruction_size++] = inst;
    }
    return 0;
    if (DEBUG) {
        for (int i=0; i<emu->instruction_size; i++){
            cout << hex << "0x" << emu->instruction_memory[i] << endl;
        }
    }
}

void print_reg(Emulator* emu){
    // 普通のレジスタの表示
    cout << "----------------------------------------------------------------------------------------------------------------" << endl;
    for (int i=0; i<REG_SIZE; i++){
        cout << setfill(' ') << right << setw(8) << reg_name[i] << " : " << 
            "0x" << hex << setfill('0') << right << setw(8) << emu->reg[i];
        cout << "     ";
        if (i % 4 == 3) {cout << endl;}
    }
    cout << "----------------------------------------------------------------------------------------------------------------" << endl;
    // cout << setfill(' ') << right << setw(8) << "pc" << " : " << 
    //     "0x" << hex << setfill('0') << right << setw(8) << emu->pc << endl;
    // cout << "----------------------------------------------------------------------------------------------------------------" << endl;
}

void print_reg_for_debug(Emulator* emu){
    //cout << "----------------------------------------------------------------------------------------------------------------" << endl;
    for (int i=0; i<REG_SIZE; i++){
        if (emu->args.reg_for_print[i]){
            cout << dec << setfill('0') << right << setw(8) << emu->reg[i];
            cout << "     ";
        }
    }
    cout << dec << setfill('0') << right << setw(8) << emu->pc << endl;
}

void print_mem(Emulator* emu, int start){
    // startから 128 byte　表示
    // string address_hex;
    // cin >> address_hex;
    // uint32_t start = hex2int(address_hex);
    start /= 4;
    cout << "----------------------------------------------------------------------------------------------------------------" << endl;
    for (int i=0; i<4; i++){
        cout << "" << hex << setfill(' ') << right << setw(10) << "address  " << " : ";
        cout << "   " << hex << setfill(' ') << left << setw(8) << "data" ;
        cout << "    ";
    }
    cout << endl;
    for (int i=0; i<32; i++){
        cout << "0x" << hex << setfill('0') << right << setw(8) << (start + i) * 4 << " : ";
        cout << "0x" << hex << setfill('0') << right << setw(8) << emu->memory[start+i] ;
        cout << "     ";
        if (i % 4 == 3) {cout << endl;}
    }
    cout << "----------------------------------------------------------------------------------------------------------------" << endl;
}
// void output_image(Emulator* emu){
//     // %out ?γ???? : 300000
//     // %out ?ν?λ?? : 6591488 if 512 * 512
//     //                693248 if 128 * 128
//     int out_start = 300000;
//     int out_goal = 693248; // if 128 * 128
//     // int out_goal = 6591488; // if 512 * 512
//     ofstream writing_file;
//     FILE *fp;
//     fp = fopen("output.ppm", "w");
//     for (int i=out_start; i<out_goal; i += 4){
//         if (emu->memory[i/4] == 538981200){
//             fprintf(fp, "P3");
//         }
//         else if (emu->memory[i/4] == 538976266){ // 0x2020200A SPC SPC SPC LF
//             fprintf(fp, "\n");
//         }
//         else if (emu->memory[i/4] == 538976288){ // 0x20202020 SPC SPC SPC SPC
//             fprintf(fp, " ");
//         }
//         else{
//             fprintf(fp, "%03d", (emu->memory[i/4]));
//         }
//     }
//     return;
// }
void output_image(Emulator* emu){
    // %out の開始時 : 300000
    // %out の終了時 : 6591488 if 512 * 512
    //                693248 if 128 * 128
    int out_start = 300000;
    int out_goal = 693248; // if 128 * 128
    // int out_goal = 6591488; // if 512 * 512
    ofstream writing_file;
    FILE *fp;
    fp = fopen("output.ppm", "w");
    for (int i=out_start; i<out_goal; i += 4){
        uint32_t temp = emu->memory[i/4];
        uint32_t t1, t2, t3, t4;
        t1 = (temp & 0xFF000000) >> 24;
        t2 = (temp & 0x00FF0000) >> 16;
        t3 = (temp & 0x0000FF00) >> 8;
        t4 = (temp & 0x000000FF);
        fprintf(fp, "%c", t1);
        fprintf(fp, "%c", t2);
        fprintf(fp, "%c", t3);
        fprintf(fp, "%c", t4);
    }
    return;
}

void cache_save(Emulator* emu, uint32_t mem_address) {
    uint32_t block_address = (mem_address & emu->mask.index_mask) >> BLOCK_SIZE_BIT;
    uint32_t tag = (mem_address & emu->mask.tag_mask) >> (BLOCK_SIZE_BIT + BLOCK_NUM_BIT);
    //uint32_t index = (mem_address & )
    emu->cache[block_address].valid = true;
    emu->cache[block_address].tag = tag;
    // emu->cache[block_address].index = block_address;
    uint32_t start_ind = (mem_address >> BLOCK_SIZE_BIT) << (BLOCK_SIZE_BIT - 2);
    for (int i=0; i<BLOCK_SIZE/4; i++) {
        emu->cache[block_address].data[i] = emu->memory[start_ind + i];
    }
}

bool cache_hit(Emulator* emu, uint32_t mem_address) {
    // 暫定的に
    uint32_t block_address = (mem_address & emu->mask.index_mask) >> BLOCK_SIZE_BIT;
    uint32_t tag = (mem_address & emu->mask.tag_mask) >> (BLOCK_SIZE_BIT + BLOCK_NUM_BIT);
    if (emu->cache[block_address].tag == tag){
        return true;
    }
    return false;
}
