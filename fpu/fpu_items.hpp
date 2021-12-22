#ifndef _FPU_ITEMS
#define _FPU_ITEMS
#include <iostream>
#include <string>
#include <stdlib.h>

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
        cout << "error input length differ" << endl;
        exit(1);
    }
    uint32_t ret_data = (r1.data + r2.data) & bit_mask(r1.bit_num);
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline verilog_data sub(verilog_data r1, verilog_data r2){
    if (r1.bit_num != r2.bit_num) {
        cout << "error input length differ" << endl;
        exit(1);
    }
    uint32_t ret_data = (r1.data - r2.data) & bit_mask(r1.bit_num);
    verilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline verilog_data mul(verilog_data r1, verilog_data r2, uint32_t output_bit_num){
    if (r1.bit_num != r2.bit_num) {
        cout << "error input length differ" << endl;
        exit(1);
    }
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
    uint32_t msk1 = bit_mask(to-from+1) << from;
    op1->data &= ~msk1;
    op1->data |= ((op2.data & bit_mask(op2.bit_num)) << from);
}

inline verilog_data vd_or(verilog_data op) {
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

inline verilog_data vd_and(verilog_data op) {
    verilog_data ret;
    if (~op.data & bit_mask(op.bit_num)){
        ret.data = 0x00000001;
        ret.bit_num = 1;
    }
    else {
        ret.data = 0x00000000;
        ret.bit_num = 1;
    }
    return ret;
}

#endif