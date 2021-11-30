#ifndef _INSTRUCTION
#define _INSTRUCTION

#include <iostream>
#include <stdlib.h>
#include "simulator.hpp"
using namespace std;

//////////////////////   RV32I   /////////////////////////
int judge_optype(Emulator* emu, uint32_t instruction);

// BRANCH
inline int BEQ(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 == (int)rs2) ? emu->pc + (int)imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BNE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 != (int)rs2) ? emu->pc + (int)imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BLT(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 < (int)rs2) ? emu->pc + (int)imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BGE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 >= (int)rs2) ? emu->pc + (int)imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BLTU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = (rs1 < rs2) ? emu->pc + (int)imm / 4 : emu->pc + 1; 
    return 0;
}

inline int BGEU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = (rs1 >= rs2) ? emu->pc + (int)imm / 4 : emu->pc + 1; 
    return 0;
}

#endif