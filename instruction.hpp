#ifndef _INSTRUCTION
#define _INSTRUCTION

#include <iostream>
#include <stdlib.h>
#include <cmath>
#include "simulator.hpp"
using namespace std;

union fi{
    uint32_t i;
    float f;
} ;

int exec_one_instruction(Emulator* emu, uint32_t instruction);
//////////////////////   RV32I   /////////////////////////
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
    // if (rd_ == 0){
    //     rd_ = 1; // x1 register
    // }
    emu->reg[rd_] = emu->pc + 1;
    emu->pc += imm;
    return 0;
}

///////////   JALR   ////////////
inline int JALR(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    // if (rd_ == 0){
    //     rd_ = 1; // x1 register
    // }
    uint32_t rs1 = emu->reg[rs1_];
    emu->pc = rs1 + imm;
    emu->reg[rd_] = rs1 + 4;
    return 0;
}

//////////////////////   RV32F   /////////////////////////
///////////   FLW   ////////////
inline int FLW(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    if (rd_ == 0){
        rd_ = 1; // x1 register
    }
    uint32_t rs1 = emu->reg[rs1_];
    emu->freg[rd_] = emu->memory[(rs1 + imm)/4];
    return 0;
}

///////////   FSW   ////////////
inline int FSW(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    emu->memory[(rs1 + imm)/4] = rs2;
    emu->pc++;
    return 0;
}

// fmadd, fmsub, fnmsub, fnmadd -> suspended

///////////   FOP   ////////////
inline int FADDS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2, frd;
    frs1.i = rs1;
    frs2.i = rs2;
    frd.f = frs1.f + frs2.f;
    emu->freg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FSUBS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2, frd;
    frs1.i = rs1;
    frs2.i = rs2;
    frd.f = frs1.f - frs2.f;
    emu->freg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FMULS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2, frd;
    frs1.i = rs1;
    frs2.i = rs2;
    frd.f = frs1.f * frs2.f;
    emu->freg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FDIVS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2, frd;
    frs1.i = rs1;
    frs2.i = rs2;
    frd.f = frs1.f / frs2.f;
    emu->freg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FSQRTS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    union fi frs1, frd;
    frs1.i = rs1;
    frd.f = sqrt(frs1.f);
    emu->freg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FSGNJS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    if (rs2 & (1<<31)){
        emu->freg[rd_] = rs1 | 0x80000000;
    }
    else {
        emu->freg[rd_] = rs1 & 0x7FFFFFFF;
    }
    emu->pc++;
    return 0;
}

inline int FSGNJNS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    if (rs2 & (1<<31)){
        emu->freg[rd_] = rs1 & 0x7FFFFFFF;
    }
    else {
        emu->freg[rd_] = rs1 | 0x80000000;
    }
    emu->pc++;
    return 0;
}

inline int FSGNJXS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    if ((rs1 & (1<<31)) ^ (rs2 & (1<<31))){
        emu->freg[rd_] = rs1 | 0x80000000;
    }
    else {
        emu->freg[rd_] = rs1 & 0x7FFFFFFF;
    }
    emu->pc++;
    return 0;
}

inline int FMINS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2;
    frs1.i = rs1;
    frs2.i = rs2;
    emu->freg[rd_] = (frs1.f < frs2.f) ? frs1.i : frs2.i;
    emu->pc++;
    return 0;
}

inline int FMAXS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2;
    frs1.i = rs1;
    frs2.i = rs2;
    emu->freg[rd_] = (frs1.f > frs2.f) ? frs1.i : frs2.i;
    emu->pc++;
    return 0;
}

inline int FCVTWS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    union fi frs1;
    frs1.i = rs1;
    emu->freg[rd_] = (int)frs1.f;
    emu->pc++;
    return 0;
}

inline int FCVTWUS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    union fi frs1;
    frs1.i = rs1;
    emu->freg[rd_] = (uint32_t)frs1.f;
    emu->pc++;
    return 0;
}

inline int FMVXW(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    cout << "inst. \"fmv.x.w\" unsupported" << endl;
    return 0;
}

inline int FEQS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2;
    frs1.i = rs1;
    frs2.i = rs2;
    emu->reg[rd_] = (frs1.f == frs2.f) ? 1 : 0;
    emu->pc++;
    return 0;
}

inline int FLTS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2;
    frs1.i = rs1;
    frs2.i = rs2;
    emu->reg[rd_] = (frs1.f < frs2.f) ? 1 : 0;
    emu->pc++;
    return 0;
}

inline int FLES(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->freg[rs1_];
    uint32_t rs2 = emu->freg[rs2_];
    union fi frs1, frs2;
    frs1.i = rs1;
    frs2.i = rs2;
    emu->reg[rd_] = (frs1.f <= frs2.f) ? 1 : 0;
    emu->pc++;
    return 0;
}

inline int FCLASSS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    cout << "inst. \"fclass.s\" unsupported" << endl;
    return 0;
}

inline int FCVTSW(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    int rs1 = (int)emu->reg[rs1_];
    union fi frd;
    frd.f = (float)rs1;
    emu->freg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FCVTSWU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    union fi frd;
    frd.f = (float)rs1;
    emu->freg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FMVWX(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->freg[rd_] = rs1;
    emu->pc++;
    return 0;
}

#endif