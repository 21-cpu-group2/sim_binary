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

void init_emulator(Emulator* emu, uint32_t pc_init){
    for (int i=0; i<REG_SIZE; i++){
        emu->reg[i] = 0x00000000;
    }
    for (int i=0; i<FREG_SIZE; i++){
        emu->freg[i] = 0x00000000;
    }

    //////////////////////////////////////////
    // とりあえず動くようにする。
    // emu->registers[reg["sp"]] = 0x00100000;
    emu->freg[freg_num["ft0"]] = 0x3FC00000;
    emu->freg[freg_num["ft1"]] = 0x41200000;
    //////////////////////////////////////////
    emu->pc = 0x00000000;

    //メモリを動的に確保
    emu->memory = (uint32_t*)malloc(MEMORY_SIZE);
    emu->instruction_memory = (uint32_t*)malloc(INSTRUCTION_MEMORY_SIZE);
    // emu->cache = (cache_line*)malloc(sizeof(cache_line) / 4 * CACHE_SIZE / CACHE_WAY);

    if (emu->memory == NULL || emu->instruction_memory == NULL){
        printf("error : cannot allocate memory\n");
        exit(1);
    }

    emu->instruction_size = 0x00000000;
    memset(emu->memory, 0, MEMORY_SIZE);
    memset(emu->instruction_memory, 0, INSTRUCTION_MEMORY_SIZE);
    // memset(emu->cache, 0, sizeof(cache_line) / 4 * CACHE_SIZE / CACHE_WAY);
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
    while (getline(ifs, str)){
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
    // float用レジスタの表示
    for (int i=0; i<FREG_SIZE; i++){
        cout << setfill(' ') << right << setw(8) << freg_name[i] << " : " << 
            "0x" << hex << setfill('0') << right << setw(8) << emu->reg[i];
        cout << "     ";
        if (i % 4 == 3) {cout << endl;}
    }
    cout << "----------------------------------------------------------------------------------------------------------------" << endl;
    cout << setfill(' ') << right << setw(8) << "pc" << " : " << 
        "0x" << hex << setfill('0') << right << setw(8) << emu->pc << endl;
    cout << "----------------------------------------------------------------------------------------------------------------" << endl;
}

void print_mem(Emulator* emu){
    // startから 128 byte　表示
    string address_hex;
    cin >> address_hex;
    uint32_t start = hex2int(address_hex);
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
