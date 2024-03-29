#ifndef _FPU_ITEMS
#define _FPU_ITEMS
#include <iostream>
#include <string>
#include <stdlib.h>
#include <math.h>
#include <fstream>
#include <istream>
#include <random>
#define eps pow(2, -126)
const float FLOAT_MIN = pow(2, -126);
const float FLOAT_MAX = pow(2, 127);

using namespace std;

typedef struct {
    uint32_t data;
    uint32_t bit_num;
} verilog_data;

typedef struct {
    verilog_data sgn;
    verilog_data exp;
    verilog_data fra;
} my_float;

union fi {
    uint32_t i;
    float f;
};

#define vd verilog_data

inline uint32_t bit_mask(uint32_t n){
    if (n == 0) return 0x00000000;
    return 0xFFFFFFFF >> (32-n);
}

inline verilog_data concat2(verilog_data dat1, verilog_data dat2){
    uint32_t ret_data = 0;
    uint32_t ret_bit_num = 0;
    ret_data |= (dat1.data) & bit_mask(dat1.bit_num);
    ret_bit_num += dat1.bit_num;
    ret_data <<= dat2.bit_num;
    ret_data |= (dat2.data) & bit_mask(dat2.bit_num);
    ret_bit_num += dat2.bit_num;
    ret_data &= bit_mask(ret_bit_num);
    verilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

inline verilog_data concat3(verilog_data dat1, verilog_data dat2, verilog_data dat3){
    uint32_t ret_data = 0;
    uint32_t ret_bit_num = 0;
    ret_data |= (dat1.data) & bit_mask(dat1.bit_num);
    ret_bit_num += dat1.bit_num;
    ret_data <<= dat2.bit_num;
    ret_data |= (dat2.data) & bit_mask(dat2.bit_num);
    ret_bit_num += dat2.bit_num;
    ret_data <<= dat3.bit_num;
    ret_data |= (dat3.data) & bit_mask(dat3.bit_num);
    ret_bit_num += dat3.bit_num;
    ret_data &= bit_mask(ret_bit_num);
    verilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

inline verilog_data concat4(verilog_data dat1, verilog_data dat2, verilog_data dat3, verilog_data dat4){
    uint32_t ret_data = 0;
    uint32_t ret_bit_num = 0;
    ret_data |= (dat1.data) & bit_mask(dat1.bit_num);
    ret_bit_num += dat1.bit_num;
    ret_data <<= dat2.bit_num;
    ret_data |= (dat2.data) & bit_mask(dat2.bit_num);
    ret_bit_num += dat2.bit_num;
    ret_data <<= dat3.bit_num;
    ret_data |= (dat3.data) & bit_mask(dat3.bit_num);
    ret_bit_num += dat3.bit_num;
    ret_data <<= dat4.bit_num;
    ret_data |= (dat4.data) & bit_mask(dat4.bit_num);
    ret_bit_num += dat4.bit_num;
    ret_data &= bit_mask(ret_bit_num);
    verilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

inline verilog_data slice(verilog_data dat, uint32_t to, uint32_t from){
    uint32_t ret_data = 0;
    uint32_t ret_bit_num = to - from + 1;
    ret_data = (dat.data >> from) & bit_mask(to - from + 1);
    verilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

// //adder subtracter multiplier shift
inline verilog_data add(verilog_data r1, verilog_data r2){
    if (r1.bit_num != r2.bit_num) {
        cout << "error input length differ in add" << endl;
        cout << r1.bit_num << " " << r2.bit_num << endl;
        exit(1);
    }
    uint32_t op1 = r1.data;
    uint32_t op2 = r2.data;
    if (op1 & (1 << (r1.bit_num - 1))){
        op1 |= (0xFFFFFFFF << (r1.bit_num));
    }
    if (op2 & (1 << (r2.bit_num - 1))){
        op2 |= (0xFFFFFFFF << (r2.bit_num));
    }
    uint32_t ret_data = (op1 + op2) & bit_mask(r1.bit_num);
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline verilog_data sub(verilog_data r1, verilog_data r2){
    if (r1.bit_num != r2.bit_num) {
        cout << "error input length differ in sub" << endl;
        exit(1);
    }
    // 符号拡張
    uint32_t op1 = r1.data;
    uint32_t op2 = r2.data;
    if (op1 & (1 << (r1.bit_num - 1))){
        op1 |= (0xFFFFFFFF << (r1.bit_num));
    }
    if (op2 & (1 << (r2.bit_num - 1))){
        op2 |= (0xFFFFFFFF << (r2.bit_num));
    }
    uint32_t ret_data = (uint32_t)(op1 - op2) & bit_mask(r1.bit_num);
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline verilog_data addi(verilog_data r1, int imm) {
    uint32_t ret_data = (r1.data + imm) & bit_mask(r1.bit_num);
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline verilog_data subi(verilog_data r1, int imm) {
    uint32_t ret_data = (r1.data - imm) & bit_mask(r1.bit_num);
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline verilog_data mul(verilog_data r1, verilog_data r2, uint32_t output_bit_num){
    // if (r1.bit_num != r2.bit_num) {
    //     cout << "error input length differ in mul" << endl;
    //     exit(1);
    // }
    uint32_t ret_data = (r1.data * r2.data) & bit_mask(output_bit_num);
    verilog_data ret = {ret_data, output_bit_num};
    return ret;
}

// shift right
inline verilog_data sr(verilog_data r1, uint32_t shamt){ 
    uint32_t ret_data = r1.data >> shamt;
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

// shift left
inline verilog_data sl(verilog_data r1, uint32_t shamt){ 
    uint32_t ret_data = (r1.data << shamt) & bit_mask(r1.bit_num);
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline void assign(verilog_data* op1, verilog_data op2, uint32_t to, uint32_t from) {
    if (to == 0xFFFFFFFF) {
        to = op1->bit_num - 1;
        from = 0;
    }
    uint32_t msk1 = bit_mask(to-from+1) << from;
    op1->data &= ~msk1;
    op1->data |= ((op2.data & bit_mask(op2.bit_num)) << from);
}

inline verilog_data vd_not(verilog_data op) {
    verilog_data ret;
    ret.data = ~op.data & bit_mask(op.bit_num);
    ret.bit_num = op.bit_num;
    return ret;
}

inline verilog_data vd_or_red(verilog_data op) {
    verilog_data ret;
    if (op.data & bit_mask(op.bit_num)){
        ret.data = 0x00000001;
        ret.bit_num = 1;
    }
    else {
        ret.data = 0x00000000;
        ret.bit_num = 1;
    }
    return ret;
}

inline verilog_data vd_and_red(verilog_data op) {
    verilog_data ret;
    if (~op.data & bit_mask(op.bit_num)){
        ret.data = 0x00000000;
        ret.bit_num = 1;
    }
    else {
        ret.data = 0x00000001;
        ret.bit_num = 1;
    }
    return ret;
}

inline verilog_data vd_or(verilog_data op1, verilog_data op2) {
    if (op1.bit_num != op2.bit_num) {
        cout << "error : input bit num differ in vd_or" << endl;
    }
    verilog_data ret;
    ret.data = (op1.data | op2.data) & bit_mask(op1.bit_num);
    ret.bit_num = op1.bit_num;
    return ret;
}

inline verilog_data vd_and(verilog_data op1, verilog_data op2) {
    if (op1.bit_num != op2.bit_num) {
        cout << "error : input bit num differ in vd_and" << endl;
    }
    verilog_data ret;
    ret.data = (op1.data & op2.data) & bit_mask(op1.bit_num);
    ret.bit_num = op1.bit_num;
    return ret;
}

inline verilog_data vd_xor(verilog_data op1, verilog_data op2) {
    if (op1.bit_num != op2.bit_num) {
        cout << "error : input length differ in vd_xor" << endl;
        exit(1);
    }
    verilog_data ret;
    ret.data = (op1.data ^ op2.data) & bit_mask(op1.bit_num);
    ret.bit_num = op1.bit_num;
    return ret;
}

inline bool equal(verilog_data r1, verilog_data r2){
    if (r1.bit_num == r2.bit_num){
        if ((r1.data & bit_mask(r1.bit_num)) == (r2.data & bit_mask(r2.bit_num))){
            return true;
        }
    }
    return false;
}

inline bool equali(verilog_data r1, uint32_t imm){
    if ((r1.data & bit_mask(r1.bit_num)) == imm){
        return true;
    }
    return false;
}

inline bool lt(verilog_data r1, verilog_data r2){
    if (r1.bit_num == r2.bit_num){
        if ((r1.data & bit_mask(r1.bit_num)) < (r2.data & bit_mask(r2.bit_num))){
            return true;
        }
    }
    return false;
}

inline verilog_data make_vd(uint32_t bit, uint32_t imm) {
    vd ret = {imm & bit_mask(bit), bit};
    return ret;
}

inline verilog_data constant(uint32_t data, uint32_t bit_num){
    if (pow(2, bit_num) < data){
        cout << "error : constant data declared doesn't fit in indicated len" << endl;
        exit(1);
    }
    verilog_data ret = {data, bit_num};
    return ret;
}

inline double mf_to_d(my_float f){
    double ret;
    if (f.exp.data == 0){
        ret = 0;
    } else {
        ret = f.fra.data * pow(2, -23);
        ret += 1;
        ret *= pow(2, int(f.exp.data) - 127);
        ret *= pow(-1, f.sgn.data);
    }
    return ret;
}

inline double vd_to_d(verilog_data op){
    if (op.bit_num != 32){
        cout << "error : vd.bit_num is not 32 in vd_to_d " << endl;
        exit(1);
    }
    double ret;
    if (slice(op, 30, 23).data == 0){
        ret = 0;
    } else {
        ret = slice(op, 22, 0).data * pow(2, -23);
        ret += 1.0;
        ret *= pow(double(2.0), int(slice(op, 30, 23).data) - 127);
        ret *= pow(-1, slice(op, 31, 31).data);
    }
    return ret;
}

inline bool isNumber(uint32_t n) {
    if ((0x7F800000 & n) == 0) {
        // exp == 0
        if ((0x007FFFFF & n) == 0) {
            // signed zero
            if ((0x80000000 & n) == 0) {
                // positive zero
                return true;
            }
            else {
                // positive zero
                return false;
            }
        }
        else {
            // 非正規化数
            return false;
        }
    }
    else if (((0x7F800000 & n) >> 23) < 255){
        // 0 < exp < 255
        // 正規化数
        return true;
    }
    else {
        // exp == 255
        if ((0x007FFFFF & n) == 0){
            if (0x80000000 & n){
                // 負の無限大
                return false;
            }
            else {
                // 正の無限大
                return false;
            }
        }
        else {
            // 非数
            return false;
        }
    }
}

static void bit_print(uint32_t n) {
    for (int i=0; i<32; i++){
        if (n & (1 << (31 - i))) {
            cout << "1";
        }
        else {
            cout << "0";
        }
    }
    cout << endl;
    return;
}

inline uint32_t make_random_float(){
    random_device rnd;
    uint32_t ret;
    while (1) {
        ret = rnd();
        if (isNumber(ret)) break;
    }
    return ret;
}

#endif

