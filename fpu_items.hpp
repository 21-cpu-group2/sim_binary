#include <iostream>
#include <string>
#include <stdlib.h>

using namespace std;

typedef struct {
    uint32_t data;
    uint32_t bit_num;
} velilog_data;

typedef struct {
    velilog_data sgn;
    velilog_data exp;
    velilog_data fra;
} my_float;

inline uint32_t bit_mask(uint32_t n){
    if (n == 0) return 0x00000000;
    return 0xFFFFFFFF >> (32-n);
}

inline velilog_data concat2(velilog_data dat1, velilog_data dat2){
    uint32_t ret_data = 0;
    uint32_t ret_bit_num = 0;
    ret_data |= (dat1.data) & bit_mask(dat1.bit_num);
    ret_bit_num += dat1.bit_num;
    ret_data <<= dat2.bit_num;
    ret_data |= (dat2.data) & bit_mask(dat2.bit_num);
    ret_bit_num += dat2.bit_num;
    velilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

inline velilog_data concat3(velilog_data dat1, velilog_data dat2, velilog_data dat3){
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
    velilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

inline velilog_data concat4(velilog_data dat1, velilog_data dat2, velilog_data dat3, velilog_data dat4){
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
    velilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

inline velilog_data slice(velilog_data dat, uint32_t to, uint32_t from){
    uint32_t ret_data = 0;
    uint32_t ret_bit_num = to - from + 1;
    ret_data = (dat.data >> from) & bit_mask(to - from + 1);
    velilog_data ret = {ret_data, ret_bit_num};
    return ret;
}

// //adder subtracter multiplier shift
inline velilog_data add(velilog_data r1, velilog_data r2){
    if (r1.bit_num != r2.bit_num) {
        cout << "error input length differ" << endl;
        exit(1);
    }
    uint32_t ret_data = 0;
    ret_data = (r1.data + r2.data) & bit_mask(r1.bit_num);
    velilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline velilog_data sub(velilog_data r1, velilog_data r2){
    if (r1.bit_num != r2.bit_num) {
        cout << "error input length differ" << endl;
        exit(1);
    }
    uint32_t ret_data = 0;
    ret_data = (r1.data - r2.data) & bit_mask(r1.bit_num);
    velilog_data ret = {ret_data, r1.bit_num};
    return ret;
}

inline velilog_data mul(velilog_data r1, velilog_data r2){
    if (r1.bit_num != r2.bit_num) {
        cout << "error input length differ" << endl;
        exit(1);
    }
    uint32_t ret_data = 0;
    ret_data = (r1.data * r2.data) & bit_mask(r1.bit_num);
    velilog_data ret = {ret_data, r1.bit_num};
    return ret;
}