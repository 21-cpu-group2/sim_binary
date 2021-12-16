#include <iostream>
#include <string>
#include <fstream>
#include <stdlib.h>

#define REG_SIZE 32

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

using namespace std;

static char reg_name[REG_SIZE][16] = {
    "%zero","%ra","%sp","%mc_hp",
    "%in","%out","%a0","%a1",
    "%a2","%a3","%a4","%a5",
    "%a6","%a7","%a8","%a9",
    "%a10","%a11","%a12","%fzero",
    "%f0","%f1","%f2","%f3",
    "%f4","%f5","%f6","%f7",
    "%f8","%f9","%f10","%f11",
};

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

int disassemble_one_instruction(uint32_t instruction){
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
                cout << "beq " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm;
                break;
            case 0b100 : // in risc-v 0'b001
                cout << "bne " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm;
                break;
            case 0b001 : // in risc-v 0'b100
                cout << "blt " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm;
                break;
            case 0b101 :
                cout << "bge " << reg_name[rs1] << " " << reg_name[rs2] << " " << imm;
                break;
            default :
                cout << "no function matched";
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
                cout << "lw " << reg_name[rd] << " " << reg_name[rs1] << " " << imm;
                break;
            default :
                cout << "no function matched";
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
                cout << "sw " << reg_name[rs2] << " " << reg_name[rs1] << " " << imm;
                break;
            default :
                cout << "no function matched";
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
                cout << "addi " << reg_name[rd] << " " << reg_name[rs1] << " " << imm;
                break;
            case 0b001 :
                cout << "slli " << reg_name[rd] << " " << reg_name[rs1] << " " << imm;
                break;
            case 0b101 :
                cout << "srli " << reg_name[rd] << " " << reg_name[rs1] << " " << imm;
                break;
            default :
                cout << "no function matched";
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
                cout << "add " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            case 0b0100000000 :
                cout << "sub " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            case 0b0000000001 :
                cout << "sll " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            default :
                cout << "no function matched";
                return 1;
        }
    }
    else if (opcode == _LUI){
        int imm = instruction & 0xFFFFF000;
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        cout << "lui " << reg_name[rd] << " " << imm;
    }
    else if (opcode == _JAL){
        int imm = (instruction & 0xFFFFF000) >> 12;
        if (imm & (1<<19)){
            // if MSB = 1 then sign extend
            imm = (imm | 0xFFF00000);
        }
        uint32_t rd = (instruction & 0x00000F80) >> 7;
        cout << "jal " << reg_name[rd] << " " << imm;
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
                cout << "jalr " << reg_name[rd] << " " << reg_name[rs1] << " " << imm;
                break;
            default :
                cout << "no function matched";
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
                cout << "fadd " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            case 0b0000100000 :
                cout << "fsub " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            case 0b0001000000 :
                cout << "fmul " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            case 0b0001100000 :
                cout << "fdiv " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            case 0b0001000001:
                if (rs2 != 0){
                    cout << "no function matched";
                    return 1;
                }
                cout << "fhalf " << reg_name[rd] << " " << reg_name[rs1];
                break;
            case 0b0101100000:
                if (rs2 != 0){
                    cout << "no function matched";
                    return 1;
                }
                cout << "sqrt " << reg_name[rd] << " " << reg_name[rs1];
                break;
            case 0b0010000010:
                if (rs2 != 0){
                    cout << "no function matched";
                    return 1;
                }
                cout << "fabs " << reg_name[rd] << " " << reg_name[rs1];
                break;
            case 0b0010000001:
                if (rs2 != 0){
                    cout << "no function matched";
                    return 1;
                }
                cout << "fneg " << reg_name[rd] << " " << reg_name[rs1];
                break;
            case 0b1010000010 :
                if (rs2 != 0b00000){
                    cout << "no function matched";
                    return 1;
                }
                cout << "fiszero " << reg_name[rd] << " " << reg_name[rs1] << " ";
                break;
            case 0b1010000101 :
                if (rs2 != 0b00000){
                    cout << "no function matched";
                    return 1;
                }
                cout << "fisneg " << reg_name[rd] << " " << reg_name[rs1] << " ";
                break;
            case 0b1010000011 :
                if (rs2 != 0b00000){
                    cout << "no function matched";
                    return 1;
                }
                cout << "fispos " << reg_name[rd] << " " << reg_name[rs1] << " ";
                break;
            case 0b1010000001 :
                cout << "fless " << reg_name[rd] << " " << reg_name[rs1] << " " << reg_name[rs2];
                break;
            case 0b1100000001 :
                if (rs2 != 0b00000){
                    cout << "no function matched";
                    return 1;
                }
                cout << "floor " << reg_name[rd] << " " << reg_name[rs1] << " ";
                break;
            case 0b1100000000 :
                if (rs2 != 0b00000){
                    cout << "no function matched";
                    return 1;
                }
                cout << "ftoi " << reg_name[rd] << " " << reg_name[rs1] << " ";
                break;
            case 0b1101000000 :
                if (rs2 != 0b00000){
                    cout << "no function matched";
                    return 1;
                }
                cout << "itof " << reg_name[rd] << " " << reg_name[rs1] << " ";
                break;
            default :
                cout << "no function matched";
                return 1;
        }
    }
    else if (opcode == _NOP){
        if (instruction & 0xFFFFFFFF) {
            cout << "nop ";
        }
    }
    else {
        cout << "no function matched";
        return 1;
    }
    return 0;
}

int disassemble_instructions(string file_path) {
    ifstream ifs(file_path);
    if (ifs.fail()){
        return 1;
    }
    string str;
    bool fst = true;
    int pc = 0;
    while (getline(ifs, str)){
        if (fst) {
            fst = false;
            cout << endl;
            continue;
        }
        uint32_t inst = bin2int(str);
        disassemble_one_instruction(inst);
        cout << "   # pc = " << pc << endl;
        pc++;
    }
    return 0;
}

int main(int argc, char** argv) {
    string file_path = argv[1];
    if (disassemble_instructions(file_path)){
        cout << "cannot open the file" << endl;
    }
    return 0;
}