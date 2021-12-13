#ifndef _SIMULATOR
#define _SIMULATOR

#define MEMORY_SIZE  (1024*1024*32) // 2^25(1024*1024*32)だけ欲しい
#define INSTRUCTION_MEMORY_SIZE (1024*1024) //どのくらい必要?
#define REG_SIZE 32
#define FREG_SIZE 32

#define DEBUG 0
#define PRINT_STAT 0
#define DISASSEMBLE 0
//#define DEBUG2 0 // if 1 then showing specific registers
#define RM 0b000 // Round Mode(float)

#include <stdlib.h>
#include <string>
#include <map>
#include "cache.hpp"

using namespace std;

enum Register { zero, ra, sp, gp, tp, t0, t1, t2, 
                s0, s1, a0, a1, a2, a3, a4, a5, 
                a6, a7, s2, s3, s4, s5, s6, s7, 
                s8, s9, s10, s11, t3, t4, t5, t6};

enum fRegister { ft0, ft1, ft2, ft3, ft4, ft5, ft6, ft7, 
                fs0, fs1, fa0, fa1, fa2, fa3, fa4, fa5, 
                fa6, fa7, fs2, fs3, fs4, fs5, fs6, fs7, 
                fs8, fs9, fs10, fs11, ft8, ft9, ft10, ft11};

static char reg_name[REG_SIZE][16] = {
    "%zero","%ra","%sp","%min_caml_hp",
    "%in","%out","%a0","%a1",
    "%a2","%a3","%a4","%a5",
    "%a6","%a7","%a8","%a9",
    "%a10","%a11","%a12","%fzero",
    "%f0","%f1","%f2","%f3",
    "%f4","%f5","%f6","%f7",
    "%f8","%f9","%f10","%f11",
};
/*
static char freg_name[REG_SIZE][8] = {
                "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7", 
                "fs0", "fs1", "fa0", "fa1", "fa2", "fa3", "fa4", "fa5", 
                "fa6", "fa7", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7", 
                "fs8", "fs9", "fs10", "fs11", "ft8", "ft9", "ft10", "ft11",
                };
*/
static char freg_name[REG_SIZE][8] = {
                "f0", "f1", "f2", "f3", "f4", "f5", "f6", "f7", 
                "f8", "f9", "f10", "f11", "f12", "f13", "f14", "f15", 
                "f16", "f17", "f18", "f19", "f20", "f21", "f22", "f23", 
                "f24", "f25", "f26", "f27", "f28", "f29", "f30", "f31", 
};

static map<string, int> reg_num{
    { "zero", 0 }, { "ra", 1 }, { "sp", 2 }, { "gp", 3 }, 
    { "tp", 4 }, { "t0", 5 }, { "t1", 6 }, { "t2", 7 }, 
    { "s0", 8 }, { "s1", 9 }, { "a0", 10 }, { "a1", 11 }, 
    { "a2", 12 }, { "a3", 13 }, { "a4", 14 }, { "a5", 15 }, 
    { "a6", 16 }, { "a7", 17 }, { "s2", 18 }, { "s3", 19 }, 
    { "s4", 20 }, { "s5", 21 }, { "s6", 22 }, { "s7", 23 }, 
    { "s8", 24 }, { "s9", 25 }, { "s10", 26 }, { "s11", 27 }, 
    { "t3", 28 }, { "t4", 29 }, { "t5", 30 }, { "t6", 31 }
};

static map<string, int> freg_num{
    { "ft0", 0 },{ "ft1", 1 },{ "ft2", 2 },{ "ft3", 3 },
    { "ft4", 4 },{ "ft5", 5 },{ "ft6", 6 },{ "ft7", 7 },
    { "fs0", 8 },{ "fs1", 9 },{ "fa0", 10 },{ "fa1", 11 },
    { "fa2", 12 },{ "fa3", 13 },{ "fa4", 14 },{ "fa5", 15 },
    { "fa6", 16 },{ "fa7", 17 },{ "fs2", 18 },{ "fs3", 19 },
    { "fs4", 20 },{ "fs5", 21 },{ "fs6", 22 },{ "fs7", 23 },
    { "fs8", 24 },{ "fs9", 25 },{ "fs10", 26 },{ "fs11", 27 },
    { "ft8", 28 },{ "ft9", 29 },{ "ft10", 30 },{ "ft11", 31 }
};

typedef struct {
    bool flg_p;
    bool flg_a;
    bool flg_r;
    bool flg_s;
    bool flg_g;
    bool flg_R;
    bool flg_m;
    bool print_asm;
    int start;
    int goal;
    int mem_s; // if print memory, show from memory address "mem_s"
    bool reg_for_print[64];
} cmdline_args;

typedef struct {
    uint32_t reg[REG_SIZE];
    // uint32_t freg[FREG_SIZE];
    int32_t pc;
    uint32_t* memory;
    uint32_t *instruction_memory;
    int instruction_size;
    cmdline_args args;
    cache_line *cache;
    masks mask;
} Emulator;

uint32_t bin2int(string bin);
uint32_t hex2int(string hex);
void init_emulator(Emulator* emu);
void destroy_emulator(Emulator* emu);
int load_instructions(Emulator* emu, string file_path);
void print_reg(Emulator* emu);
void print_reg_for_debug(Emulator* emu);
void print_mem(Emulator* emu, int start);
bool cache_hit(Emulator* emu, uint32_t mem_address);
#endif