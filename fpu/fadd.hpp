#ifndef _FADD
#define _FADD
#include "fpu_items.hpp"
using namespace std;


inline void fadd(vd op, vd* out, vd* ans_shift_out){
    assign(out, (slice(op, 27, 27).data ? constant(0, 5) :
                slice(op, 26, 26).data ? constant(1, 5) :
                slice(op, 25, 25).data ? constant(2, 5) :
                slice(op, 24, 24).data ? constant(3, 5) :
                slice(op, 23, 23).data ? constant(4, 5) :
                slice(op, 22, 22).data ? constant(5, 5) :
                slice(op, 21, 21).data ? constant(6, 5) :
                slice(op, 20, 20).data ? constant(7, 5) :
                slice(op, 19, 19).data ? constant(8, 5) :
                slice(op, 18, 18).data ? constant(9, 5) :
                slice(op, 17, 17).data ? constant(10, 5) :
                slice(op, 16, 16).data ? constant(11, 5) :
                slice(op, 15, 15).data ? constant(12, 5) :
                slice(op, 14, 14).data ? constant(13, 5) :
                slice(op, 13, 13).data ? constant(14, 5) :
                slice(op, 12, 12).data ? constant(15, 5) :
                slice(op, 11, 11).data ? constant(16, 5) :
                slice(op, 10, 10).data ? constant(17, 5) :
                slice(op, 9, 9).data ? constant(18, 5) :
                slice(op, 8, 8).data ? constant(19, 5) :
                slice(op, 7, 7).data ? constant(20, 5) :
                slice(op, 6, 6).data ? constant(21, 5) :
                slice(op, 5, 5).data ? constant(22, 5) :
                slice(op, 4, 4).data ? constant(23, 5) :
                slice(op, 3, 3).data ? constant(24, 5) :
                slice(op, 2, 2).data ? constant(25, 5) : constant(28, 5)), -1, 0);
    assign(ans_shift_out, (slice(op, 27, 27).data ? slice(op, 26, 4) :
                slice(op, 26, 26).data ? slice(op, 25, 3) :
                slice(op, 25, 25).data ? slice(op, 24, 2) :
                slice(op, 24, 24).data ? slice(op, 23, 1) :
                slice(op, 23, 23).data ? slice(op, 22, 0) :
                slice(op, 22, 22).data ? concat2(slice(op, 21, 0), constant(0, 1)) :
                slice(op, 21, 21).data ? concat2(slice(op, 20, 0), constant(0, 2)) :
                slice(op, 20, 20).data ? concat2(slice(op, 19, 0), constant(0, 3)) :
                slice(op, 19, 19).data ? concat2(slice(op, 18, 0), constant(0, 4)) :
                slice(op, 18, 18).data ? concat2(slice(op, 17, 0), constant(0, 5)) :
                slice(op, 17, 17).data ? concat2(slice(op, 16, 0), constant(0, 6)) :
                slice(op, 16, 16).data ? concat2(slice(op, 15, 0), constant(0, 7)) :
                slice(op, 15, 15).data ? concat2(slice(op, 14, 0), constant(0, 8)) :
                slice(op, 14, 14).data ? concat2(slice(op, 13, 0), constant(0, 9)) :
                slice(op, 13, 13).data ? concat2(slice(op, 12, 0), constant(0, 10)) :
                slice(op, 12, 12).data ? concat2(slice(op, 11, 0), constant(0, 11)) :
                slice(op, 11, 11).data ? concat2(slice(op, 10, 0), constant(0, 12)) :
                slice(op, 10, 10).data ? concat2(slice(op, 9, 0), constant(0, 13)) :
                slice(op, 9, 9).data ? concat2(slice(op, 8, 0), constant(0, 14)) :
                slice(op, 8, 8).data ? concat2(slice(op, 7, 0), constant(0, 15)) :
                slice(op, 7, 7).data ? concat2(slice(op, 6, 0), constant(0, 16)) :
                slice(op, 6, 6).data ? concat2(slice(op, 5, 0), constant(0, 17)) :
                slice(op, 5, 5).data ? concat2(slice(op, 4, 0), constant(0, 18)) :
                slice(op, 4, 4).data ? concat2(slice(op, 3, 0), constant(0, 19)) :
                slice(op, 3, 3).data ? concat2(slice(op, 2, 0), constant(0, 20)) :
                slice(op, 2, 2).data ? concat2(slice(op, 1, 0), constant(0, 21)) : constant(0, 23)), -1, 0);
}

inline vd fadd(vd op1, vd op2){
    vd sig1 = {0, 1};
    vd sig2 = {0, 1};
    vd exp1 = {0, 8};
    vd exp2 = {0, 8};
    vd fra1 = {0, 28};
    vd fra2 = {0, 28};
    assign(&sig1, slice(op1, 31, 31), -1, 0);
    assign(&sig2, slice(op2, 31, 31), -1, 0);
    assign(&exp1, slice(op1, 30, 23), -1, 0);
    assign(&exp2, slice(op2, 30, 23), -1, 0);
    assign(&fra1, ((exp1.data == 0) ? concat3(constant(0, 2), slice(op1, 22, 0), constant(0, 3)) : concat3(constant(1, 2), slice(op1, 22, 0), constant(0, 3))), -1, 0);
    assign(&fra2, ((exp2.data == 0) ? concat3(constant(0, 2), slice(op2, 22, 0), constant(0, 3)) : concat3(constant(1, 2), slice(op2, 22, 0), constant(0, 3))), -1, 0);

    vd op1_is_abs_bigger = {0, 1};
    assign(&op1_is_abs_bigger, ((exp1.data == exp2.data) ? constant(uint32_t (slice(op1, 22, 0).data > slice(op2, 22, 0).data), 1) : constant(uint32_t (exp1.data > exp2.data), 1)), -1, 0);

    vd shift_1 = {0, 8};
    vd shift_2 = {0, 8};
    assign(&shift_1, sub(exp1, exp2), -1, 0);
    assign(&shift_2, sub(exp2, exp1), -1, 0);

    vd op_big = {0, 28};
    vd op_small = {0, 28};
    vd exp_big = {0, 8};
    vd sig_big = {0, 1};
    vd sig_small = {0, 1};

    //ここから1clk目

    // vd ans = {0, 28};
    // assign(&ans, ((sig_big)), -1, 0)
}

#endif