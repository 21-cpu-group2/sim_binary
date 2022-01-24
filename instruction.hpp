#ifndef _INSTRUCTION
#define _INSTRUCTION

#include <iostream>
#include <stdlib.h>
#include <cmath>
#include "simulator.hpp"
#include "fpu/fabs.hpp"
#include "fpu/fadd.hpp"
#include "fpu/fdiv.hpp"
#include "fpu/fhalf.hpp"
#include "fpu/fisneg.hpp"
#include "fpu/fispos.hpp"
#include "fpu/fiszero.hpp"
#include "fpu/fless.hpp"
#include "fpu/floor.hpp"
#include "fpu/fmul.hpp"
#include "fpu/fneg.hpp"
#include "fpu/fsqrt.hpp"
#include "fpu/fsub.hpp"
#include "fpu/ftoi.hpp"
#include "fpu/itof.hpp"

using namespace std;

// union fi{
//     uint32_t i;
//     float f;
// } ;

int disassemble_one_instruction(Emulator * emu, uint32_t instruction);
void disassemble_instructions(Emulator* emu);
int exec_one_instruction(Emulator* emu, uint32_t instruction);



//////////////////////   RV32I   /////////////////////////
///////////   BRANCH   ////////////
inline int BEQ(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 == (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    emu->stats.beq++;
    return 0;
}

inline int BNE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 != (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    emu->stats.bne++;
    return 0;
}

inline int BLT(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 < (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    emu->stats.blt++;
    return 0;
}

inline int BGE(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->pc = ((int)rs1 >= (int)rs2) ? emu->pc + imm : emu->pc + 1; 
    emu->stats.bge++;
    return 0;
}
/*
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
*/
///////////   LOAD   ////////////
// LB & LH & LBU & LHU はエンディアンを意識しないとまずいかも
/*
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
*/
inline int LW(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t address = (rs1 + imm);
    if (cache_hit(emu, address)){
        uint32_t index = (address & INDEX_MASK) >> (OFFSET_BIT);
        uint32_t offset = address & OFFSET_MASK;
        uint32_t dat = emu->cache[index].data[offset/4];
        emu->reg[rd_] = dat;
        if (emu->args.print_asm) cout << "cache hit!!" << endl;
    }
    else {
        cache_save(emu, address);
        emu->reg[rd_] = emu->memory[address/4];
        if (emu->args.print_asm) cout << "cache miss..." << endl;
    }
    emu->reg[rd_] = emu->memory[address/4];
    emu->pc++;
    emu->stats.lw++;
    return 0;
}
/*
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
*/
///////////   STORE   ////////////
/*
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
*/
inline int SW(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    // uint32_t address = (rs1 + imm) / 4;
    uint32_t address = rs1 + imm;
    if (cache_hit(emu, address)){
        uint32_t index = (address & INDEX_MASK) >> (OFFSET_BIT);
        uint32_t offset = address & OFFSET_MASK;
        emu->cache[index].data[offset/4] = rs2;
        emu->memory[address/4] = rs2;
        if (emu->args.print_asm) cout << "cache hit!!" << endl;
    }
    else {
        emu->memory[address/4] = rs2;
        cache_save(emu, address);
        if (emu->args.print_asm) cout << "cache miss..." << endl;
    }
    emu->memory[address/4] = rs2;
    emu->pc++;
    emu->stats.sw++;
    return 0;
}

///////////   IMM   ////////////
inline int ADDI(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1 + imm;
    emu->pc++;
    emu->stats.addi++;
    return 0;
}

inline int SLLI(Emulator* emu, uint32_t rs1_, uint32_t rd_, uint32_t shamt) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1 << shamt;
    emu->pc++;
    emu->stats.slli++;
    return 0;
}

inline int SRLI(Emulator* emu, uint32_t rs1_, uint32_t rd_, uint32_t shamt) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1 >> shamt;
    emu->pc++;
    emu->stats.srli++;
    return 0;
}
/*
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
*/
///////////   OP   ////////////
inline int ADD(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = rs1 + rs2;
    emu->pc++;
    emu->stats.add++;
    return 0;
}

inline int SUB(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->reg[rd_] = rs1 - rs2;
    emu->pc++;
    emu->stats.sub++;
    return 0;
}

inline int SLL(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    uint32_t shift = rs2 & 0x0000001F;
    emu->reg[rd_] = rs1 << shift;
    emu->pc++;
    emu->stats.sll++;
    return 0;
}

/*
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
*/
///////////   LUI   ////////////
inline int LUI(Emulator* emu, uint32_t rd_, int imm) {
    // lui命令は必ずaddiが一つ前にくる。
    // lui命令の前のaddiは、単に下位12bitに数値をぶち込みたいだけ。
    // -> addiのimmが負だとrdに突っ込まれる値は0xFFFFF???になるが、0x00000???にしておきたい。
    // luiでは、上位20bitをマスクしてから計算を進める。
    uint32_t rd = emu->reg[rd_] & 0x00000FFF;
    emu->reg[rd_] = (imm << 12) | rd;
    emu->pc++;
    emu->stats.lui++;
    return 0;
}
/*
///////////   AUIPC   ////////////
inline int AUIPC(Emulator* emu, uint32_t rd_, int imm) {
    // 現在のpcに足すのか、それとも4(sim上では1)を足してから足すのか
    emu->reg[rd_] = emu->pc + imm;
    emu->pc++;
    return 0;
}
*/
///////////   JAL   ////////////
inline int JAL(Emulator* emu, uint32_t rd_, int imm) {
    // if (rd_ == 0){
    //     rd_ = 1; // x1 register
    // }
    emu->reg[rd_] = emu->pc + 1;
    emu->pc += imm;
    emu->stats.jal++;
    return 0;
}

///////////   JALR   ////////////
inline int JALR(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    // if (rd_ == 0){
    //     rd_ = 1; // x1 register
    // }
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = emu->pc + 1;
    emu->pc = rs1 + imm;
    emu->stats.jalr++;
    return 0;
}

//////////////////////   RV32F   /////////////////////////
///////////   FLW   ////////////
/*
inline int FLW(Emulator* emu, uint32_t rs1_, uint32_t rd_, int imm) {
    if (rd_ == 0){
        rd_ = 1; // x1 register
    }
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = emu->memory[(rs1 + imm)/4];
    return 0;
}

///////////   FSW   ////////////
inline int FSW(Emulator* emu, uint32_t rs1_, uint32_t rs2_, int imm) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    emu->memory[(rs1 + imm)/4] = rs2;
    emu->pc++;
    return 0;
}

// fmadd, fmsub, fnmsub, fnmadd -> suspended
*/
///////////   FOP   ////////////
inline int FADDS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    // union fi frs1, frs2, frd;
    // frs1.i = rs1;
    // frs2.i = rs2;
    vd rs1_vd = {rs1, 32};
    vd rs2_vd = {rs2, 32};
    // frd.f = frs1.f + frs2.f;
    emu->reg[rd_] = fadd(rs1_vd, rs2_vd).data;
    emu->pc++;
    emu->stats.fadd++;
    return 0;
}

inline int FSUBS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    // union fi frs1, frs2, frd;
    // frs1.i = rs1;
    // frs2.i = rs2;
    vd rs1_vd = {rs1, 32};
    vd rs2_vd = {rs2, 32};
    // frd.f = frs1.f + frs2.f;
    emu->reg[rd_] = fsub(rs1_vd, rs2_vd).data;
    emu->pc++;
    emu->stats.fsub++;
    return 0;
}

inline int FMULS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    // union fi frs1, frs2, frd;
    // frs1.i = rs1;
    // frs2.i = rs2;
    // frd.f = frs1.f * frs2.f;
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    vd rs2_vd = {rs2, 32};
    // frd.f = frs1.f + frs2.f;
    emu->reg[rd_] = fmul(rs1_vd, rs2_vd).data;
    emu->pc++;
    emu->stats.fmul++;
    return 0;
}

inline int FDIVS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    // union fi frs1, frs2, frd;
    // frs1.i = rs1;
    // frs2.i = rs2;
    // frd.f = frs1.f / frs2.f;
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    vd rs2_vd = {rs2, 32};
    emu->reg[rd_] = fdiv(rs1_vd, rs2_vd).data;
    emu->pc++;
    emu->stats.fdiv++;
    return 0;
}

inline int FHALF(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // union fi frs1, frd;
    // frs1.i = rs1;
    // frd.f = frs1.f / 2.;
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = fhalf(rs1_vd).data;
    emu->pc++;
    emu->stats.fhalf++;
    return 0;
}

inline int FSQRT(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // union fi frs1, frd;
    // frs1.i = rs1;
    // frd.f = sqrt(frs1.f);
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = fsqrt(rs1_vd).data;
    emu->pc++;
    emu->stats.fsqrt++;
    return 0;
}

inline int FABS(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // union fi frs1, frd;
    // frs1.i = rs1;
    // frd.f = abs(frs1.f);
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = fabs(rs1_vd).data;
    emu->pc++;
    emu->stats.fabs++;
    return 0;
}

inline int FNEG(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // union fi frs1, frd;
    // frs1.i = rs1;
    // frd.f = -frs1.f;
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = fneg(rs1_vd).data;
    emu->pc++;
    emu->stats.fneg++;
    return 0;
}

/*
inline int FSGNJS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    if (rs2 & (1<<31)){
        emu->reg[rd_] = rs1 | 0x80000000;
    }
    else {
        emu->reg[rd_] = rs1 & 0x7FFFFFFF;
    }
    emu->pc++;
    return 0;
}

inline int FSGNJNS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    if (rs2 & (1<<31)){
        emu->reg[rd_] = rs1 & 0x7FFFFFFF;
    }
    else {
        emu->reg[rd_] = rs1 | 0x80000000;
    }
    emu->pc++;
    return 0;
}

inline int FSGNJXS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    if ((rs1 & (1<<31)) ^ (rs2 & (1<<31))){
        emu->reg[rd_] = rs1 | 0x80000000;
    }
    else {
        emu->reg[rd_] = rs1 & 0x7FFFFFFF;
    }
    emu->pc++;
    return 0;
}

inline int FMINS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    union fi frs1, frs2;
    frs1.i = rs1;
    frs2.i = rs2;
    emu->reg[rd_] = (frs1.f < frs2.f) ? frs1.i : frs2.i;
    emu->pc++;
    return 0;
}

inline int FMAXS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    union fi frs1, frs2;
    frs1.i = rs1;
    frs2.i = rs2;
    emu->reg[rd_] = (frs1.f > frs2.f) ? frs1.i : frs2.i;
    emu->pc++;
    return 0;
}

inline int FCVTWS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    union fi frs1;
    frs1.i = rs1;
    emu->reg[rd_] = (int)frs1.f;
    emu->pc++;
    return 0;
}

inline int FCVTWUS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    union fi frs1;
    frs1.i = rs1;
    emu->reg[rd_] = (uint32_t)frs1.f;
    emu->pc++;
    return 0;
}

inline int FMVXW(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    cout << "inst. \"fmv.x.w\" unsupported" << endl;
    return 0;
}
*/
inline int FISZERO(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // uint32_t float_zero = emu->reg[19]; // %fzero
    // union fi frs1, fzero;
    // frs1.i = rs1;
    // fzero.i = float_zero;
    // emu->reg[rd_] = (frs1.f == fzero.f) ? 1 : 0;
    // emu->reg[rd_] = (frs1.f == 0.0) ? 1 : 0;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = fiszero(rs1_vd).data;
    emu->pc++;
    emu->stats.fiszero++;
    return 0;
}

inline int FISNEG(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // uint32_t float_zero = emu->reg[19]; // %fzero
    // union fi frs1, fzero;
    // frs1.i = rs1;
    // fzero.i = float_zero;
    // emu->reg[rd_] = (frs1.f < fzero.f) ? 1 : 0;
    // emu->reg[rd_] = (frs1.f < 0.0) ? 1 : 0;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = fisneg(rs1_vd).data;
    emu->pc++;
    emu->stats.fisneg++;
    return 0;
}

inline int FISPOS(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // uint32_t float_zero = emu->reg[19]; // %fzero
    // union fi frs1, fzero;
    // frs1.i = rs1;
    // fzero.i = float_zero;
    // emu->reg[rd_] = (frs1.f > fzero.f) ? 1 : 0;
    // emu->reg[rd_] = (frs1.f > 0.0) ? 1 : 0;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = fispos(rs1_vd).data;
    emu->pc++;
    emu->stats.fispos++;
    return 0;
}

inline int FLESS(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
    // union fi frs1, frs2;
    // frs1.i = rs1;
    // frs2.i = rs2;
    // emu->reg[rd_] = (frs1.f < frs2.f) ? 1 : 0;
    vd rs1_vd = {rs1, 32};
    vd rs2_vd = {rs2, 32};
    emu->reg[rd_] = fless(rs1_vd, rs2_vd).data;
    emu->pc++;
    emu->stats.fless++;
    return 0;
}

inline int FLOOR(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // union fi frs1, frd;
    // frs1.i = rs1;
    // frd.f = floor(frs1.f);
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = floor(rs1_vd).data;
    emu->pc++;
    emu->stats.floor++;
    return 0;
}

inline int ITOF(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    // int rs1 = (int)emu->reg[rs1_];
    uint32_t rs1 = emu->reg[rs1_];
    // union fi frd;
    // frd.f = (float)rs1;
    // emu->reg[rd_] = frd.i;
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = itof(rs1_vd).data;
    emu->pc++;
    emu->stats.itof++;
    return 0;
}

inline int FTOI(Emulator* emu, uint32_t rs1_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    // union fi frs1, ret;
    // frs1.i = rs1;
    // int approx = (int)frs1.f;
    // if ((float)approx > frs1.f){
    //     if( (float)approx - frs1.f < 0.5) {
    //         emu->reg[rd_] = approx;
    //     }
    //     else{
    //         emu->reg[rd_] = approx -1;
    //     }
    // }
    // else {
    //     if (frs1.f - (float)approx < 0.5) {
    //         emu->reg[rd_] = approx;
    //     }
    //     else {
    //         emu->reg[rd_] = approx + 1;
    //     }
    // }
    vd rs1_vd = {rs1, 32};
    emu->reg[rd_] = ftoi(rs1_vd).data;
    emu->pc++;
    emu->stats.ftoi++;
    return 0;
}

/*
inline int FLES(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    uint32_t rs2 = emu->reg[rs2_];
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
    emu->reg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FCVTSWU(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    union fi frd;
    frd.f = (float)rs1;
    emu->reg[rd_] = frd.i;
    emu->pc++;
    return 0;
}

inline int FMVWX(Emulator* emu, uint32_t rs1_, uint32_t rs2_, uint32_t rd_) {
    uint32_t rs1 = emu->reg[rs1_];
    emu->reg[rd_] = rs1;
    emu->pc++;
    return 0;
}
*/
#endif