#include <iostream>
#include <stdlib.h>
#include "instruction.hpp"
#include "simulator.hpp"

using namespace std;

// オペコード
#define BRANCH 0b1100011 // beq, bne, blt, bge, bltu, bgeu
#define LOAD   0b0000011 // lb, lh, lw, lbu, lhu, 
#define STORE  0b0100011 // sb, sh, sw
#define IMM    0b0010011 // addi, slti, sltiu, xori, ori, andi, slli, srli, srai
#define OP     0b0110011 // add, sub, sll, slt, sltu, xor, srl, sra, or, and
#define LUI    0b0110111 // lui
#define AUIPC  0b0010111 // auipc
#define JAL    0b1101111 // jal
#define JALR   0b1100111 // jalr

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
        // if MSB = 1 then change sign
        imm = (imm ^ 0x00000FFF) + 1;
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
        case 0b000 :
            BEQ(emu, rs1, rs2, imm);
            if (DEBUG) cout << "BEQ" << endl;
            break;
        case 0b001 :
            BNE(emu, rs1, rs2, imm);
            if (DEBUG) cout << "BNE" << endl;
            break;
        case 0b100 :
            BLT(emu, rs1, rs2, imm);
            if (DEBUG) cout << "BLT" << endl;
            break;
        case 0b101 :
            BGE(emu, rs1, rs2, imm);
            if (DEBUG) cout << "BGE" << endl;
            break;
        case 0b110 :
            BLTU(emu, rs1, rs2, imm);
            if (DEBUG) cout << "BLTU" << endl;
            break;
        case 0b111 :
            BGEU(emu, rs1, rs2, imm);
            if (DEBUG) cout << "BGEU" << endl;
            break;
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
        // if MSB = 1 then change sign
        imm = (imm ^ 0x00000FFF) + 1;
    }
    uint32_t rs1 = (instruction & 0x000F8000) >> 15;
    uint32_t rd = (instruction & 0x00000F80) >> 7;
    if (DEBUG) {
        cout << dec;
        cout << "----------------" << endl;
        cout << "imm : " << imm << endl
             << "rs1 : " << rs1 << " (-> " << reg_name[rs1] << ")" << endl
             << "rd : " << rd << " (-> " << reg_name[rd] << ")" << endl;
    }
    switch (funct3) {
        case 0b000 :
            LB(emu, rs1, rd, imm);
            if (DEBUG) cout << "LB" << endl;
            break;
        case 0b001 :
            LH(emu, rs1, rd, imm);
            if (DEBUG) cout << "LH" << endl;
            break;
        case 0b010 :
            LW(emu, rs1, rd, imm);
            if (DEBUG) cout << "LW" << endl;
            break;
        case 0b100 :
            LBU(emu, rs1, rd, imm);
            if (DEBUG) cout << "LBU" << endl;
            break;
        case 0b101 :
            LHU(emu, rs1, rd, imm);
            if (DEBUG) cout << "LHU" << endl;
            break;
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
        // if MSB = 1 then change sign
        imm = (imm ^ 0x00000FFF) + 1;
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
        case 0b000 :
            SB(emu, rs1, rs2, imm);
            if (DEBUG) cout << "SB" << endl;
            break;
        case 0b001 :
            SH(emu, rs1, rs2, imm);
            if (DEBUG) cout << "SH" << endl;
            break;
        case 0b010 :
            SW(emu, rs1, rs2, imm);
            if (DEBUG) cout << "SW" << endl;
            break;
        default :
            cout << "no function matched" << endl;
            return 1;
    }
    return 0;
}

int judge_optype(Emulator* emu, uint32_t instruction){
    uint32_t opcode = instruction & 0x007F;
    switch (opcode) {
        case BRANCH :
            inst_branch(emu, instruction);
            break;
        case LOAD :
            inst_load(emu, instruction);
            break;
        case STORE :
            inst_store(emu, instruction);
            break;
        /*
        case IMM :
            inst_imm(instruction);
            break;
        case OP :
            inst_op(instruction);
            break;
        case LUI :
            inst_lui(instruction);
            break;
        case AUIPC :
            inst_auipc(instruction);
            break;
        case JAL :
            inst_jal(instruction);
            break;
        case JALR :
            inst_jalr(instruction);
            break;
        */
        default :
            cout << "nothing matched" << endl;
            return 1;
    }
    return 0;
}
