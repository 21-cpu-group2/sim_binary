#ifndef _INSTRUCTION
#define _INSTRUCTION

#include <iostream>
#include <stdlib.h>
#include "simulator.hpp"
using namespace std;

//////////////////////   RV32I   /////////////////////////
int judge_optype(Emulator* emu, uint32_t instruction);

///////////   BRANCH   ////////////
inline int BEQ(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 == (int)rs2) ? emu->pc + imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BNE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 != (int)rs2) ? emu->pc + imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BLT(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 < (int)rs2) ? emu->pc + imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BGE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 >= (int)rs2) ? emu->pc + imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BLTU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = (rs1 < rs2) ? emu->pc + imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BGEU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = (rs1 >= rs2) ? emu->pc + imm / 4 : emu->pc + 1; 
    return 0;
}

///////////   LOAD   ////////////
// LB & LH & LBU & LHU はエンディアンを意識しないとまずいかも
inline int LB(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = (emu->memory[address] & 0xFF000000) >> 24;
    if (emu->reg[rd_] & (1<<7)){
        // if MSB = 1 then extend sign
        emu->reg[rd_] |= 0xFFFFFF00;
    }
    return 0;
}

inline int LH(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = (emu->memory[address] & 0xFFFF0000) >> 16;
    if (emu->reg[rd_] & (1<<15)){
        // if MSB = 1 then extend sign
        emu->reg[rd_] |= 0xFFFF0000;
    }
    return 0;
}

inline int LW(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = emu->memory[address];
    return 0;
}

inline int LBU(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = (emu->memory[address] & 0xFF000000) >> 24;
    return 0;
}

inline int LHU(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = (emu->memory[address] & 0xFFFF0000) >> 16;
    return 0;
}
#endif