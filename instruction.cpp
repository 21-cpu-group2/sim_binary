#include <iostream>
#include <stdlib.h>
#include "instruction.hpp"
#include "simulator.hpp"

using namespace std;

//////// opecode start /////////
// RV32I
#define _BRANCH  0b1100011 // beq, bne, blt, bge, bltu, bgeu
#define _LOAD    0b0000011 // lb, lh, lw, lbu, lhu, 
#define _STORE   0b0100011 // sb, sh, sw
#define _IMM     0b0010011 // addi, slti, sltiu, xori, ori, andi, slli, srli, srai
#define _OP      0b0110011 // add, sub, sll, slt, sltu, xor, srl, sra, or, and
#define _LUI     0b0110111 // lui
#define _AUIPC   0b0010111 // auipc
#define _JAL     0b1101111 // jal
#define _JALR    0b1100111 // jalr
#define _NOP     0b1111111 // nop

// RV32F
#define _FLW     0b0000111 // flw
#define _FSW     0b0100111 // fsw
#define _FMADDS  0b1000011 // fmadd.s
#define _FMSUBS  0b1000111 // fmsub.s
#define _FNMSUBS 0b1001011 // fnmsub.s
#define _FNMADDS 0b1001111 // fnmadd.s
#define _FOP     0b1010011 // fadd.s, fsub.s, fmul.s, fdiv.s, fsqrt.s, fsgnj.s, fsgnjn.s, fsgnnjx.s,
                           // fmin.s, fmax.s, fcvt.w.s, fcvt.wu.s, fmv.x.w, feq.s, flt.s, fle.s, 
                           // fclass.s, fcvt.s.w, fcvt.s.wu, fmv.w.x
//////// opecode end /////////


int inst_branch(Emulator* emu, uint32_t instruction) {
    // B-type
    //  beq, bne, blt, bge, bltu, bgeu

    //  imm1   rs2    rs1    funct3   imm2   opcode
    //   7      5      5        3      5        7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    uint32_t imm1 = (instruction & 0xFE000000) >> 20;
    uint32_t imm2 = (instruction & 0x00000F80) >> 7;
    int imm = imm1 + imm2;
    if (imm & (1<<11)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFFFF000);
    }
    uint32_t rs2 = (instruction & 0x01F00000) >> 20;
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    switch (funct3) {
        case 0b000 :
            BEQ(emu, rs1, rs2, imm);
            if (emu->args.print_asm) {
                cout << "beq " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
            }
            break;
        case 0b100 : // in risc-v 0'b001
            BNE(emu, rs1, rs2, imm);
            if (emu->args.print_asm) {
                cout << "bne " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
            }
            break;
        case 0b001 : // in risc-v 0'b100
            BLT(emu, rs1, rs2, imm);
            if (emu->args.print_asm) {
                cout << "blt " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
            }
            break;
        case 0b101 :
            BGE(emu, rs1, rs2, imm);
            if (emu->args.print_asm) {
                cout << "bge " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
            }
            break;
        
        // case 0b110 :
        //     BLTU(emu, rs1, rs2, imm);
        //     if (DEBUG) cout << "BLTU" << endl;
        //     break;
        // case 0b111 :
        //     BGEU(emu, rs1, rs2, imm);
        //     if (DEBUG) cout << "BGEU" << endl;
        //     break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}

int inst_load(Emulator* emu, uint32_t instruction) {
    // I-type
    //  lb, lh, lw, lbu, lhu

    //  imm   rs1   funct3   rd   opcode
    //   12    5      3       5    7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    int imm = (instruction & 0xFFF00000) >> 20;
    if (imm & (1<<11)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFFFF000);
    }
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    switch (funct3) {
        // case 0b000 :
        //     LB(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "LB" << endl;
        //     break;
        // case 0b001 :
        //     LH(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "LH" << endl;
        //     break;
        case 0b010 :
            LW(emu, rs1, rd, imm);
            if (emu->args.print_asm) {
                cout << "lw " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
            }
            break;
        // case 0b100 :
        //     LBU(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "LBU" << endl;
        //     break;
        // case 0b101 :
        //     LHU(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "LHU" << endl;
        //     break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}

int inst_store(Emulator* emu, uint32_t instruction) {
    // S-type
    //  sb, sh, sw

    //  imm1   rs2    rs1    funct3   imm2   opcode
    //   7      5      5        3      5        7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    uint32_t imm1 = (instruction & 0xFE000000) >> 20;
    uint32_t imm2 = (instruction & 0x00000F80) >> 7;
    int imm = imm1 + imm2;
    if (imm & (1<<11)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFFFF000);
    }
    uint32_t rs2 = (instruction & 0x01F00000) >> 20;
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    switch (funct3) {
        // case 0b000 :
        //     SB(emu, rs1, rs2, imm);
        //     if (DEBUG) cout << "SB" << endl;
        //     break;
        // case 0b001 :
        //     SH(emu, rs1, rs2, imm);
        //     if (DEBUG) cout << "SH" << endl;
        //     break;
        case 0b010 :
            SW(emu, rs1, rs2, imm);
            if (emu->args.print_asm) {
                cout << "sw " << reg_name[rs2] << " " << reg_name[rs1] << " " << imm << endl;
            }
            break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}

int inst_imm(Emulator* emu, uint32_t instruction) {
    // I-type
    //  addi, slti, sltiu, xori, ori, andi, slli, srli, srai

    //  imm   rs1   funct3   rd   opcode
    //   12    5      3       5    7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    int imm = (instruction & 0xFFF00000) >> 20;
    if (imm & (1<<11)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFFFF000);
    }
    uint32_t shamt = (uint32_t)(imm & 0x0000001F);
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    switch (funct3) {
        case 0b000 :
            ADDI(emu, rs1, rd, imm);
            if (emu->args.print_asm) {
                cout << "addi " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
            }
            break;
        // case 0b010 :
        //     SLTI(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "SLTI" << endl;
        //     break;
        // case 0b011 :
        //     SLTIU(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "SLTIU" << endl;
        //     break;
        // case 0b100 :
        //     XORI(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "XORI" << endl;
        //     break;
        // case 0b110 :
        //     ORI(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "ORI" << endl;
        //     break;
        // case 0b111 :
        //     ANDI(emu, rs1, rd, imm);
        //     if (DEBUG) cout << "ANDI" << endl;
        //     break;
        case 0b001 :
            SLLI(emu, rs1, rd, shamt);
            if (emu->args.print_asm) {
                cout << "slli " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
            }
            break;
        case 0b101 :
            SRLI(emu, rs1, rd, shamt);
            if (emu->args.print_asm) {
                cout << "srli " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
            }
            break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}

int inst_op(Emulator* emu, uint32_t instruction) {
    // R-type
    //  add, sub, sll, slt, sltu, xor, srl, sra, or, and

    //  funct7   rs2    rs1    funct3   rd   opcode
    //     7      5      5        3      5      7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    uint32_t funct7 = (instruction & 0xFE000000) >> 22;
    uint32_t funct = funct7 + funct3;
    uint32_t rs2 = (instruction & 0x01F00000) >> 20;
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    switch (funct) {
        // 下位10bit(7bit->funct7, 3bit->funct3)
        case 0b0000000000 :
            ADD(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "add " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        case 0b0100000000 :
            SUB(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "sub " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        case 0b0000000001 :
            SLL(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "sll " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        // case 0b0000000010 :
        //     SLT(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "SLT" << endl;
        //     break;
        // case 0b0000000011 :
        //     SLTU(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "SLTU" << endl;
        //     break;
        // case 0b0000000100 :
        //     XOR(emu, rs1, rs2, rd);
        //     if (emu->args.print_asm) {
        //         cout << "xor " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
        //     }
        //     break;
        // case 0b0000000101 :
        //     SRL(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "SRL" << endl;
        //     break;
        // case 0b0100000101 :
        //     SRA(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "SRA" << endl;
        //     break;
        // case 0b0000000110 :
        //     OR(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "OR" << endl;
        //     break;
        // case 0b0000000111 :
        //     AND(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "AND" << endl;
        //     break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}

int inst_lui(Emulator* emu, uint32_t instruction) {
    // U-type
    //  LUI

    //  imm   rd   opcode
    //   20    5    7

    int imm = instruction & 0xFFFFF000;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    LUI(emu, rd, imm);
    if (emu->args.print_asm) {
        cout << "lui " << reg_name[rd] << " " << imm << endl;
    }
    return 0;
}
/*
int inst_auipc(Emulator* emu, uint32_t instruction) {
    // U-type
    //  AUIPC

    //  imm   rd   opcode
    //   20    5    7

    int imm = instruction & 0xFFFFF000;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    if (DEBUG) {
        cout << dec;
        cout << "----------------" << endl;
        cout << "imm : " << imm << endl
             << "rd : " << rd << " (-> " << reg_name[rd] << ")" << endl;
    }
    AUIPC(emu, rd, imm);
    if (DEBUG) cout << "AUIPC" << endl;
    return 0;
}
*/
int inst_jal(Emulator* emu, uint32_t instruction) {
    // U-type
    //  AUIPC

    //  imm   rd   opcode
    //   20    5    7

    int imm = (instruction & 0xFFFFF000) >> 12;
    if (imm & (1<<19)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFF00000);
    }
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    JAL(emu, rd, imm);
    if (emu->args.print_asm) {
        cout << "jal " << reg_name[rd] << " " << imm << endl;
    }
    return 0;
}

int inst_jalr(Emulator* emu, uint32_t instruction) {
    // I-type
    //  addi, slti, sltiu, xori, ori, andi, slli, srli, srai

    //  imm   rs1   funct3   rd   opcode
    //   12    5      3       5    7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    int imm = (instruction & 0xFFF00000) >> 20;
    if (imm & (1<<11)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFFFF000);
    }
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    switch (funct3) {
        case 0b000 :
            JALR(emu, rs1, rd, imm);
            if (emu->args.print_asm) {
                cout << "jalr " << reg_name[rs1] << " " << reg_name[rd] << " " << imm << endl;
            }
            break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}
/*
int inst_flw(Emulator* emu, uint32_t instruction) {
    // I-type
    //  flw

    //  imm   rs1   funct3   rd   opcode
    //   12    5      3       5    7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    int imm = (instruction & 0xFFF00000) >> 20;
    if (imm & (1<<11)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFFFF000);
    }
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    if (DEBUG) {
        cout << dec;
        cout << "imm : " << imm << endl
             << "rs1 : " << rs1 << " (-> " << reg_name[rs1] << ")" << endl
             << "rd : " << rd << " (-> " << reg_name[rd] << ")" << endl;
        cout << "----------------" << endl;
    }
    switch (funct3) {
        case 0b010 :
            FLW(emu, rs1, rd, imm);
            if (DEBUG) cout << "FLW" << endl;
            break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}
*/
/*
int inst_fsw(Emulator* emu, uint32_t instruction) {
    // S-type
    //  fsw

    //  imm1   rs2    rs1    funct3   imm2   opcode
    //   7      5      5        3      5        7

    uint32_t funct3 = (instruction & 0x00007000) >> 12;
    uint32_t imm1 = (instruction & 0xFE000000) >> 20;
    uint32_t imm2 = (instruction & 0x00000F80) >> 7;
    int imm = imm1 + imm2;
    if (imm & (1<<11)){
        // if MSB = 1 then sign extend
        imm = (imm | 0xFFFFF000);
    }
    uint32_t rs2 = (instruction & 0x01F00000) >> 20;
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    if (DEBUG) {
        cout << dec;
        cout << "----------------" << endl;
        cout << "imm : " << imm << endl
             << "rs1 : " << rs1 << " (-> " << reg_name[rs1] << ")" << endl
             << "rs2 : " << rs2 << " (-> " << reg_name[rs2] << ")" << endl;
    }
    switch (funct3) {
        case 0b010 :
            FSW(emu, rs1, rs2, imm);
            if (DEBUG) cout << "FSW" << endl;
            break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}
*/
int inst_fop(Emulator* emu, uint32_t instruction) {
    // R-type
    //  fadd.s, fsub.s, fmul.s, fdiv.s, fsqrt.s, fsgnj.s, fsgnjn.s, fsgnnjx.s,
    //  fmin.s, fmax.s, fcvt.w.s, fcvt.wu.s, fmv.x.w, feq.s, flt.s, fle.s, 
    //  fclass.s, fcvt.s.w, fcvt.s.wu, fmv.w.x

    //  funct7   rs2    rs1    funct3   rd   opcode
    //     7      5      5        3      5      7

    uint32_t rm = (instruction & 0x00007000) >> 12;
    uint32_t funct7 = (instruction & 0xFE000000) >> 22;
    uint32_t funct = funct7 + rm;
    uint32_t rs2 = (instruction & 0x01F00000) >> 20;
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    switch (funct) {
        // 上位7bit->funct7, 下位3bit->funct3
        case 0b0000000000 :
            FADDS(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "fadd " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        case 0b0000100000 :
            FSUBS(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "fsub " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        case 0b0001000000 :
            FMULS(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "fmul " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        case 0b0001100000 :
            FDIVS(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "fdiv " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        case 0b0001000001:
            if (rs2 != 0){
                cout << "no function matched" << endl;
                return 1;
            }
            FHALF(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "fhalf " << reg_name[rd] << " " << reg_name[rs1] << endl;
            }
            break;
        case 0b0101100000:
            if (rs2 != 0){
                cout << "no function matched" << endl;
                return 1;
            }
            FSQRT(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "sqrt " << reg_name[rd] << " " << reg_name[rs1] << endl;
            }
            break;
        case 0b0010000010:
            if (rs2 != 0){
                cout << "no function matched" << endl;
                return 1;
            }
            FABS(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "fabs " << reg_name[rd] << " " << reg_name[rs1] << endl;
            }
            break;
        case 0b0010000001:
            if (rs2 != 0){
                cout << "no function matched" << endl;
                return 1;
            }
            FNEG(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "fneg " << reg_name[rd] << " " << reg_name[rs1] << endl;
            }
            break;
        // case 0b0010000000 :
        //     FSGNJS(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "FSGNJS" << endl;
        //     break;
        // case 0b0010000001 :
        //     FSGNJNS(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "FSGNJNS" << endl;
        //     break;
        // case 0b0010000010 :
        //     FSGNJXS(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "FSGNJXS" << endl;
        //     break;
        // case 0b0010100000 :
        //     FMINS(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "FMINS" << endl;
        //     break;
        // case 0b0010100001 :
        //     FMAXS(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "FMAXS" << endl;
        //     break;
        // case 0b1100000000 :
        //     if (rs2 == 0b00000){
        //         FCVTWS(emu, rs1, rs2, rd);
        //         if (DEBUG) cout << "FCVTWS" << endl;
        //     }
        //     else if (rs2 == 0b00001) {
        //         FCVTWUS(emu, rs1, rs2, rd);
        //         if (DEBUG) cout << "FCVTWUS" << endl;
        //     }
        //     else {
        //         cout << "no function matched" << endl;
        //         return 1;
        //     }
        //     break;
        // case 0b1110000000 :
        //     if (rs2 != 0b00000) {
        //         cout << "no function matched" << endl;
        //         return 1;
                
        //     }
        //     FMVXW(emu, rs1, rs2, rd);
        //     break;
        case 0b1010000010 :
            if (rs2 != 0b00000){
                cout << "no function matched" << endl;
                return 1;
            }
            FISZERO(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "fiszero " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
            }
            break;
        case 0b1010000101 :
            if (rs2 != 0b00000){
                cout << "no function matched" << endl;
                return 1;
            }
            FISNEG(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "fisneg " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
            }
            break;
        case 0b1010000011 :
            if (rs2 != 0b00000){
                cout << "no function matched" << endl;
                return 1;
            }
            FISPOS(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "fispos " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
            }
            break;
        case 0b1010000001 :
            FLESS(emu, rs1, rs2, rd);
            if (emu->args.print_asm) {
                cout << "fless " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
            }
            break;
        case 0b1100000001 :
            if (rs2 != 0b00000){
                cout << "no function matched" << endl;
                return 1;
            }
            FLOOR(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "floor " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
            }
            break;
        case 0b1100000000 :
            if (rs2 != 0b00000){
                cout << "no function matched" << endl;
                return 1;
            }
            FTOI(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "ftoi " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
            }
            break;
        case 0b1101000000 :
            if (rs2 != 0b00000){
                cout << "no function matched" << endl;
                return 1;
            }
            ITOF(emu, rs1, rd);
            if (emu->args.print_asm) {
                cout << "itof " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
            }
            break;
        // case 0b1010000000 :
        //     FLES(emu, rs1, rs2, rd);
        //     if (DEBUG) cout << "FLES" << endl;
        //     break;
        // case 0b1110000001 :
        //     if (rs2 == 0b00000) {
        //         FCLASSS(emu, rs1, rs2, rd);
        //         if (DEBUG) cout << "FCLASSS" << endl;
        //     }
        //     else {
        //         cout << "no function matched" << endl;
        //         return 1;
        //     }
        //     break;
        // case 0b1101000000 :
        //     if (rs2 == 0b00000) {
        //         FCVTSW(emu, rs1, rs2, rd);
        //         if (DEBUG) cout << "FCVTSW" << endl;
        //     }
        //     else if (rs2 == 0b00001) {
        //         FCVTSWU(emu, rs1, rs2, rd);
        //         if (DEBUG) cout << "FCVTSWU" << endl;
        //     }
        //     else {
        //         cout << "no function matched" << endl;
        //         return 1;
        //     }
        //     break;
        // case 0b1111000000 :
        //     if (rs2 == 0b00001) {
        //         FMVWX(emu, rs1, rs2, rd);
        //         if (DEBUG) cout << "FMVWX" << endl;
        //     }
        //     else {
        //         cout << "no function matched" << endl;
        //         return 1;
        //     }
        //     break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}

int exec_one_instruction(Emulator* emu, uint32_t instruction){
    uint32_t opcode = instruction & 0x007F;
    if (DEBUG) cout << dec << "pc : " << emu->pc << endl;
    switch (opcode) {
        // RV32I
        case _BRANCH :
            inst_branch(emu, instruction);
            break;
        case _LOAD :
            inst_load(emu, instruction);
            break;
        case _STORE :
            inst_store(emu, instruction);
            break;
        case _IMM :
            inst_imm(emu, instruction);
            break;
        case _OP :
            inst_op(emu, instruction);
            break;
        case _LUI :
            inst_lui(emu, instruction);
            break;
        // case _AUIPC :
        //     inst_auipc(emu, instruction);
        //     break;
        case _JAL :
            inst_jal(emu, instruction);
            break;
        case _JALR :
            inst_jalr(emu, instruction);
            break;
        // RV32F
        // case _FLW :
        //     inst_flw(emu, instruction);
        //     break;
        // case _FSW :
        //     inst_fsw(emu, instruction);
        //     break;
        // case _FMADDS :
        //     inst_fmadds(emu, instruction);
        //     break;
        // case _FMSUBS :
        //     inst_fmsubs(emu, instruction);
        //     break;
        // case _FNMSUBS :
        //     inst_fnmsubs(emu, instruction);
        //     break;
        // case _FNMADDS :
        //     inst_fnmadds(emu, instruction);
        //     break;
        case _FOP :
            inst_fop(emu, instruction);
            break;
        case _NOP  :
            if (instruction & 0xFFFFFFFF) {
                if (emu->args.print_asm) {
                cout << "nop " << endl;
                }
            }
            break;
        default :
            cout << "no opcode matched" << endl;
            return 1;
    }
    emu->reg[0] = 0x00000000;
    return 0;
}

int disassemble_one_instruction(Emulator* emu, uint32_t instruction){
    uint32_t opcode = instruction & 0x007F;
    if (opcode == _BRANCH){
        uint32_t funct3 = (instruction & 0x00007000) >> 12;
        uint32_t imm1 = (instruction & 0xFE000000) >> 20;
        uint32_t imm2 = (instruction & 0x00000F80) >> 7;
        int imm = imm1 + imm2;
        if (imm & (1<<11)){
            // if MSB = 1 then sign extend
            imm = (imm | 0xFFFFF000);
        }
        uint32_t rs2 = (instruction & 0x01F00000) >> 20;
        uint32_t rs1 = (instruction & 0x000F8000) >> 15;
        switch (funct3) {
            case 0b000 :
                cout << "beq " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
                break;
            case 0b100 : // in risc-v 0'b001
                cout << "bne " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
                break;
            case 0b001 : // in risc-v 0'b100
                cout << "blt " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
                break;
            case 0b101 :
                cout << "bge " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm << endl;
                break;
            default :
                cout << "no function matched" << endl;
                return 1;
        }
    }
    else if (opcode == _LOAD){
            uint32_t funct3 = (instruction & 0x00007000) >> 12;
        int imm = (instruction & 0xFFF00000) >> 20;
        if (imm & (1<<11)){
            // if MSB = 1 then sign extend
            imm = (imm | 0xFFFFF000);
        }
        uint32_t rs1 = (instruction & 0x000F8000) >> 15;
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        switch (funct3) {
            case 0b010 :
                cout << "lw " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
                break;
            default :
                cout << "no function matched" << endl;
                return 1;
        }
    }
    else if (opcode == _STORE){
        uint32_t funct3 = (instruction & 0x00007000) >> 12;
        uint32_t imm1 = (instruction & 0xFE000000) >> 20;
        uint32_t imm2 = (instruction & 0x00000F80) >> 7;
        int imm = imm1 + imm2;
        if (imm & (1<<11)){
            // if MSB = 1 then sign extend
            imm = (imm | 0xFFFFF000);
        }
        uint32_t rs2 = (instruction & 0x01F00000) >> 20;
        uint32_t rs1 = (instruction & 0x000F8000) >> 15;
        switch (funct3) {
            case 0b010 :
                cout << "sw " << reg_name[rs2] << " " << reg_name[rs1] << " " << imm << endl;
                break;
            default :
                cout << "no function matched" << endl;
                return 1;
        }
    }
    else if (opcode == _IMM){
        uint32_t funct3 = (instruction & 0x00007000) >> 12;
        int imm = (instruction & 0xFFF00000) >> 20;
        if (imm & (1<<11)){
            // if MSB = 1 then sign extend
            imm = (imm | 0xFFFFF000);
        }
        uint32_t shamt = (uint32_t)(imm & 0x0000001F);
        uint32_t rs1 = (instruction & 0x000F8000) >> 15;
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        switch (funct3) {
            case 0b000 :
                cout << "addi " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
                break;
            case 0b001 :
                cout << "slli " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
                break;
            case 0b101 :
                cout << "srli " << reg_name[rd] << " " << reg_name[rs1] << " " << imm << endl;
                break;
            default :
                cout << "no function matched" << endl;
                return 1;
        }
    }
    else if (opcode == _OP){
        uint32_t funct3 = (instruction & 0x00007000) >> 12;
        uint32_t funct7 = (instruction & 0xFE000000) >> 22;
        uint32_t funct = funct7 + funct3;
        uint32_t rs2 = (instruction & 0x01F00000) >> 20;
        uint32_t rs1 = (instruction & 0x000F8000) >> 15;
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        switch (funct) {
            // 下位10bit(7bit->funct7, 3bit->funct3)
            case 0b0000000000 :
                cout << "add " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            case 0b0100000000 :
                cout << "sub " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            case 0b0000000001 :
                cout << "sll " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            default :
                cout << "no function matched" << endl;
                return 1;
        }
    }
    else if (opcode == _LUI){
        int imm = instruction & 0xFFFFF000;
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        cout << "lui " << reg_name[rd] << " " << imm << endl;
    }
    else if (opcode == _JAL){
        int imm = (instruction & 0xFFFFF000) >> 12;
        if (imm & (1<<19)){
            // if MSB = 1 then sign extend
            imm = (imm | 0xFFF00000);
        }
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        cout << "jal " << reg_name[rd] << " " << imm << endl;
    }
    else if (opcode == _JALR){
        uint32_t funct3 = (instruction & 0x00007000) >> 12;
        int imm = (instruction & 0xFFF00000) >> 20;
        if (imm & (1<<11)){
            // if MSB = 1 then sign extend
            imm = (imm | 0xFFFFF000);
        }
        uint32_t rs1 = (instruction & 0x000F8000) >> 15;
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        switch (funct3) {
            case 0b000 :
                cout << "jalr " << reg_name[rs1] << " " << reg_name[rd] << " " << imm << endl;
                break;
            default :
                cout << "no function matched" << endl;
                return 1;
        }
    }
    else if (opcode == _FOP){
        uint32_t rm = (instruction & 0x00007000) >> 12;
        uint32_t funct7 = (instruction & 0xFE000000) >> 22;
        uint32_t funct = funct7 + rm;
        uint32_t rs2 = (instruction & 0x01F00000) >> 20;
        uint32_t rs1 = (instruction & 0x000F8000) >> 15;
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        switch (funct) {
            // 上位7bit->funct7, 下位3bit->funct3
            case 0b0000000000 :
                cout << "fadd " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            case 0b0000100000 :
                cout << "fsub " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            case 0b0001000000 :
                cout << "fmul " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            case 0b0001100000 :
                cout << "fdiv " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            case 0b0001000001:
                if (rs2 != 0){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "fhalf " << reg_name[rd] << " " << reg_name[rs1] << endl;
                break;
            case 0b0101100000:
                if (rs2 != 0){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "sqrt " << reg_name[rd] << " " << reg_name[rs1] << endl;
                break;
            case 0b0010000010:
                if (rs2 != 0){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "fabs " << reg_name[rd] << " " << reg_name[rs1] << endl;
                break;
            case 0b0010000001:
                if (rs2 != 0){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "fneg " << reg_name[rd] << " " << reg_name[rs1] << endl;
                break;
            case 0b1010000010 :
                if (rs2 != 0b00000){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "fiszero " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
                break;
            case 0b1010000101 :
                if (rs2 != 0b00000){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "fisneg " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
                break;
            case 0b1010000011 :
                if (rs2 != 0b00000){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "fispos " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
                break;
            case 0b1010000001 :
                cout << "fless " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2] << endl;
                break;
            case 0b1100000001 :
                if (rs2 != 0b00000){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "floor " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
                break;
            case 0b1100000000 :
                if (rs2 != 0b00000){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "ftoi " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
                break;
            case 0b1101000000 :
                if (rs2 != 0b00000){
                    cout << "no function matched" << endl;
                    return 1;
                }
                cout << "itof " << reg_name[rd] << " " << reg_name[rs1] << " " << endl;
                break;
            default :
                cout << "no function matched" << endl;
                return 1;
        }
    }
    else if (opcode == _NOP){
        if (instruction & 0xFFFFFFFF) {
            cout << "nop " << endl;
        }
    }
    else {
        cout << "no function matched" << endl;
        return 1;
    }
    return 0;
}

void disassemble_instructions(Emulator* emu) {
    for (int i=0; i<emu->instruction_size; i++){
        disassemble_one_instruction(emu, emu->instruction_memory[i]);
    }
}
