#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <stdlib.h>

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
    emu->memory = (uint32_t*)malloc(MEMORY_SIZE);
    emu->instruction_memory = (uint32_t*)malloc(INSTRUCTION_MEMORY_SIZE);
    emu->cache = (cache_line*)malloc(sizeof(cache_line)/sizeof(uint32_t) * BLOCK_NUM);

    if (emu->memory == NULL || emu->instruction_memory == NULL){
        printf("error : cannot allocate memory\n");
        exit(1);
    }
    memset(emu->memory, 0, MEMORY_SIZE);
    memset(emu->instruction_memory, 0, INSTRUCTION_MEMORY_SIZE);
    memset(emu->cache, 0, sizeof(cache_line)/sizeof(uint32_t) * BLOCK_NUM);

    emu->instruction_size = 0x00000000;
    emu->args.flg_p = false;
    emu->args.flg_a = false;
    emu->args.flg_r = false;
    emu->args.flg_s = false;
    emu->args.flg_g = false;
    emu->args.flg_R = false;
    emu->args.flg_m = false;
    emu->args.print_asm = false;
    emu->args.start = 0;
    emu->args.goal = 0;
    emu->args.mem_s = 0;
    for (int i=0; i<REG_SIZE; i++){
        emu->args.reg_for_print[i] = false;
    }

    // memory <- input_data
    int input_start = 25000; // 100000 / 4
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
        if (fst) {
            uint32_t pc_init = (uint32_t)stoi(str, nullptr, 10) - 1;
            emu->pc = pc_init;
            fst = false;
            continue;
        }
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
