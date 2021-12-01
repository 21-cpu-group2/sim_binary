#ifndef _INSTRUCTION
#define _INSTRUCTION

#include <iostream>
#include <stdlib.h>
#include "simulator.hpp"
using namespace std;

//////////////////////   RV32I   /////////////////////////
int exec_one_instruction(Emulator* emu, uint32_t instruction);

///////////   BRANCH   ////////////
inline int BEQ(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 == (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    return 0;
}

inline int BNE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 != (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    return 0;
}

inline int BLT(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 < (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    return 0;
}

inline int BGE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 >= (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    return 0;
}

inline int BLTU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = (rs1 < rs2) ? emu->pc + imm : emu->pc + 1; 
    return 0;
}

inline int BGEU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = (rs1 >= rs2) ? emu->pc + imm : emu->pc + 1; 
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
    emu->pc++;
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
    emu->pc++;
    return 0;
}

inline int LW(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = emu->memory[address];
    emu->pc++;
    return 0;
}

inline int LBU(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = (emu->memory[address] & 0xFF000000) >> 24;
    emu->pc++;
    return 0;
}

inline int LHU(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm) / 4;
    emu->reg[rd_] = (emu->memory[address] & 0xFFFF0000) >> 16;
    emu->pc++;
    return 0;
}

///////////   STORE   ////////////
inline int SB(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->memory[(rs1 + imm)/4] = rs2 & 0x000000FF;
    emu->pc++;
    return 0;
}

inline int SH(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->memory[(rs1 + imm)/4] = rs2 & 0x0000FFFF;
    emu->pc++;
    return 0;
}

inline int SW(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->memory[(rs1 + imm)/4] = rs2;
    emu->pc++;
    return 0;
}

///////////   IMM   ////////////
inline int ADDI(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1 + imm;
    emu->pc++;
    return 0;
}

inline int SLTI(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = ((int)rs1 < imm) ? 1 : 0;
    emu->pc++;
    return 0;
}

inline int SLTIU(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = (rs1 < (uint32_t)imm) ? 1 : 0;
    emu->pc++;
    return 0;
}

inline int XORI(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1 ^ imm;
    emu->pc++;
    return 0;
}

inline int ORI(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1 | imm;
    emu->pc++;
    return 0;
}

inline int ANDI(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1 & imm;
    emu->pc++;
    return 0;
}

///////////   OP   ////////////
inline int ADD(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = rs1 + rs2;
    emu->pc++;
    return 0;
}

inline int SUB(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = rs1 - rs2;
    emu->pc++;
    return 0;
}

inline int SLL(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    uint32_t shift = rs2 & 0x0000001F;
    emu->reg[rd_] = rs1 << rs2;
    emu->pc++;
    return 0;
}

inline int SLT(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = ((int)rs1 < (int)rs2) ? 1 : 0;
    emu->pc++;
    return 0;
}

inline int SLTU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = (rs1 < rs2) ? 1 : 0;
    emu->pc++;
    return 0;
}

inline int XOR(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = rs1 ^ rs2;
    emu->pc++;
    return 0;
}

inline int SRL(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    uint32_t shift = rs2 & 0x0000001F;
    emu->reg[rd_] = rs1 >> rs2;
    emu->pc++;
    return 0;
}

inline int SRA(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    uint32_t shift = rs2 & 0x0000001F;
    emu->reg[rd_] = rs1 >> rs2;
    if (rs1 & (1<<31)){
        // if rs1 is neg
        uint32_t mask = 0xFFFFFFFF << (32-rs2);
        emu->reg[rd_] |= mask;
    }
    emu->pc++;
    return 0;
}

inline int OR(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = rs1 | rs2;
    emu->pc++;
    return 0;
}

inline int AND(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = rs1 & rs2;
    emu->pc++;
    return 0;
}

///////////   LUI   ////////////
inline int LUI(Emulator* emu, uint32_t rd_, int imm) {
    emu->reg[rd_] = imm;
    emu->pc++;
    return 0;
}

///////////   AUIPC   ////////////
inline int AUIPC(Emulator* emu, uint32_t rd_, int imm) {
    // 現在のpcに足すのか、それとも4(sim上では1)を足してから足すのか
    emu->reg[rd_] = emu->pc + imm;
    emu->pc++;
    return 0;
}

///////////   JAL   ////////////
inline int JAL(Emulator* emu, uint32_t rd_, int imm) {
    // 現在のpcに足すのか、それとも4(sim上では1)を足してから足すのか
    if (rd_ == 0){
        rd_ = 1; // x1 register
    }
    emu->reg[rd_] = emu->pc + 1;
    emu->pc += imm/4;
    return 0;
}

///////////   JALR   ////////////
inline int JALR(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    if (rd_ == 0){
        rd_ = 1; // x1 register
    }
    uint32_t rs1 = emu->reg[rs1_];
    emu->pc = rs1 + imm;
    emu->reg[rd_] = rs1 + 4;
    return 0;
}

#endif