#ifndef _FADD
#define _FADD
#include "fpu_items.hpp"
using namespace std;


inline void ZLC(vd op, vd* out, vd* ans_shift_out){
    assign(out, (
                slice(op, 27, 27).data ? constant(0, 5) :
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
    assign(ans_shift_out, (
                slice(op, 27, 27).data ? slice(op, 26, 4) :
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
    vd result = {0, 32};

    vd sig1 = {0, 1};
    vd sig2 = {0, 1};
    vd exp1 = {0, 8};
    vd exp2 = {0, 8};
    vd fra1 = {0, 28};
    vd fra2 = {0, 28};
    assign(&sig1, slice(op1, 31, 31), -1, 0);
    // bit_print(sig1.data);
    assign(&sig2, slice(op2, 31, 31), -1, 0);
    // bit_print(sig2.data);
    assign(&exp1, slice(op1, 30, 23), -1, 0);
    // bit_print(exp1.data);
    assign(&exp2, slice(op2, 30, 23), -1, 0);
    // bit_print(exp2.data);
    assign(&fra1, ((exp1.data == 0) ? concat3(constant(0, 2), slice(op1, 22, 0), constant(0, 3)) : concat3(constant(1, 2), slice(op1, 22, 0), constant(0, 3))), -1, 0);
    // bit_print(fra1.data);
    assign(&fra2, ((exp2.data == 0) ? concat3(constant(0, 2), slice(op2, 22, 0), constant(0, 3)) : concat3(constant(1, 2), slice(op2, 22, 0), constant(0, 3))), -1, 0);
    // bit_print(fra2.data);
    // cout << "end" << endl;

    vd op1_is_abs_bigger = {0, 1};
    assign(&op1_is_abs_bigger, ((exp1.data == exp2.data) ? constant((slice(op1, 22, 0).data > slice(op2, 22, 0).data) ? 1 : 0, 1) : constant((exp1.data > exp2.data)? 1 : 0, 1)), -1, 0);
    // bit_print(op1_is_abs_bigger.data);
    vd shift_1 = {0, 8};
    vd shift_2 = {0, 8};
    assign(&shift_1, sub(exp2, exp1), -1, 0);
    assign(&shift_2, sub(exp1, exp2), -1, 0);
    // bit_print(shift_1.data);
    // bit_print(shift_2.data);

    vd op_big = {0, 28};
    vd op_small = {0, 28};
    vd exp_big = {0, 8};
    vd sig_big = {0, 1};
    vd sig_small = {0, 1};

    //????????????1clk???
    if (op1_is_abs_bigger.data){
        // cout << "pass" << endl;
        assign(&op_big, fra1, -1, 0);
        // bit_print(op_big.data);
        assign(&exp_big, exp1, -1, 0);
        // bit_print(exp_big.data);
        assign(&sig_big, sig1, -1, 0);
        // bit_print(sig_big.data);
        assign(&sig_small, sig2, -1, 0);
        // bit_print(sig_small.data);
        // cout << "end" << endl;
        // cout << shift_2.data << endl;
        switch (shift_2.data) {
            case 0 : assign(&op_small, fra2, -1, 0); break;
            case 1 : assign(&op_small, sr(fra2, 1), -1, 0); break;
            case 2 : assign(&op_small, sr(fra2, 2), -1, 0); break;
            case 3 : assign(&op_small, sr(fra2, 3), -1, 0); break;
            case 4 : assign(&op_small, sr(fra2, 4), -1, 0); break;
            case 5 : assign(&op_small, sr(fra2, 5), -1, 0); break;
            case 6 : assign(&op_small, sr(fra2, 6), -1, 0); break;
            case 7 : assign(&op_small, sr(fra2, 7), -1, 0); break;
            case 8 : assign(&op_small, sr(fra2, 8), -1, 0); break;
            case 9 : assign(&op_small, sr(fra2, 9), -1, 0); break;
            case 10 : assign(&op_small, sr(fra2, 10), -1, 0); break;
            case 11 : assign(&op_small, sr(fra2, 11), -1, 0); break;
            case 12 : assign(&op_small, sr(fra2, 12), -1, 0); break;
            case 13 : assign(&op_small, sr(fra2, 13), -1, 0); break;
            case 14 : assign(&op_small, sr(fra2, 14), -1, 0); break;
            case 15 : assign(&op_small, sr(fra2, 15), -1, 0); break;
            case 16 : assign(&op_small, sr(fra2, 16), -1, 0); break;
            case 17 : assign(&op_small, sr(fra2, 17), -1, 0); break;
            case 18 : assign(&op_small, sr(fra2, 18), -1, 0); break;
            case 19 : assign(&op_small, sr(fra2, 19), -1, 0); break;
            case 20 : assign(&op_small, sr(fra2, 20), -1, 0); break;
            case 21 : assign(&op_small, sr(fra2, 21), -1, 0); break;
            case 22 : assign(&op_small, sr(fra2, 22), -1, 0); break;
            case 23 : assign(&op_small, sr(fra2, 23), -1, 0); break;
            case 24 : assign(&op_small, sr(fra2, 24), -1, 0); break;
            case 25 : assign(&op_small, sr(fra2, 25), -1, 0); break;
            case 26 : assign(&op_small, sr(fra2, 26), -1, 0); break;
            default : assign(&op_small, constant(0, 28), -1, 0); break;
        }
    } else {
        assign(&op_big, fra2, -1, 0);
        assign(&exp_big, exp2, -1, 0);
        assign(&sig_big, sig2, -1, 0);
        assign(&sig_small, sig1, -1, 0);
        switch (shift_1.data) {
            case 0 : assign(&op_small, fra1, -1, 0); break;
            case 1 : assign(&op_small, sr(fra1, 1), -1, 0); break;
            case 2 : assign(&op_small, sr(fra1, 2), -1, 0); break;
            case 3 : assign(&op_small, sr(fra1, 3), -1, 0); break;
            case 4 : assign(&op_small, sr(fra1, 4), -1, 0); break;
            case 5 : assign(&op_small, sr(fra1, 5), -1, 0); break;
            case 6 : assign(&op_small, sr(fra1, 6), -1, 0); break;
            case 7 : assign(&op_small, sr(fra1, 7), -1, 0); break;
            case 8 : assign(&op_small, sr(fra1, 8), -1, 0); break;
            case 9 : assign(&op_small, sr(fra1, 9), -1, 0); break;
            case 10 : assign(&op_small, sr(fra1, 10), -1, 0); break;
            case 11 : assign(&op_small, sr(fra1, 11), -1, 0); break;
            case 12 : assign(&op_small, sr(fra1, 12), -1, 0); break;
            case 13 : assign(&op_small, sr(fra1, 13), -1, 0); break;
            case 14 : assign(&op_small, sr(fra1, 14), -1, 0); break;
            case 15 : assign(&op_small, sr(fra1, 15), -1, 0); break;
            case 16 : assign(&op_small, sr(fra1, 16), -1, 0); break;
            case 17 : assign(&op_small, sr(fra1, 17), -1, 0); break;
            case 18 : assign(&op_small, sr(fra1, 18), -1, 0); break;
            case 19 : assign(&op_small, sr(fra1, 19), -1, 0); break;
            case 20 : assign(&op_small, sr(fra1, 20), -1, 0); break;
            case 21 : assign(&op_small, sr(fra1, 21), -1, 0); break;
            case 22 : assign(&op_small, sr(fra1, 22), -1, 0); break;
            case 23 : assign(&op_small, sr(fra1, 23), -1, 0); break;
            case 24 : assign(&op_small, sr(fra1, 24), -1, 0); break;
            case 25 : assign(&op_small, sr(fra1, 25), -1, 0); break;
            case 26 : assign(&op_small, sr(fra1, 26), -1, 0); break;
            default : assign(&op_small, constant(0, 28), -1, 0); break;
        }
    }
    //1-2
    // bit_print(op_small.data);
    vd ans = {0, 28};
    // cout << vd_xor(sig_big, sig_small).data << endl;
    assign(&ans, (vd_xor(sig_big, sig_small).data) ? sub(op_big, op_small) : add(op_big, op_small), -1, 0);
    // bit_print(sub(op_big, op_small).data);
    // bit_print(add(op_big, op_small).data);
    // bit_print(ans.data);
    vd ans_reg = {0, 28};
    vd zero_count = {0, 5};
    vd ans_shift = {0, 23};
    vd ans_shift_reg = {0, 24};
    ZLC(ans, &zero_count, &ans_shift);
    // bit_print(zero_count.data);
    // bit_print(ans_shift.data);
    // vd marume_up = {0, 1};
    // assign(&marume_up, vd_and(vd_and(vd_not(slice(ans, 27, 27)), vd_or(slice(ans, 26, 26), slice(ans, 1, 1))), vd_and_red(slice(ans, 25, 2))), -1, 0);
    // cout << marume_up.data << endl;
    vd exp_next = {0, 8};
    vd sig_next = {0, 1};
    vd zero_count_reg = {0, 5};

    // vd for_exp_next = {0, 8};
    // assign(&for_exp_next, concat2(constant(0, 7), marume_up), -1, 0);

    assign(&ans_reg, ans, -1, 0);
    // bit_print(ans.data);
    assign(&ans_shift_reg, concat2(constant(0, 1), ans_shift), -1, 0);
    // assign(&exp_next, add(exp_big, for_exp_next), -1, 0);
    assign(&exp_next, exp_big, -1, 0);
    assign(&sig_next, sig_big, -1, 0);
    assign(&zero_count_reg, zero_count, -1, 0);

    vd exp_next_zero = {0, 9};
    assign(&exp_next_zero, concat2(constant(0, 1), exp_next), -1, 0);
    // bit_print(exp_next_zero.data);

    //2-3

    // cout << slice(ans_reg, 3, 0).data << endl;
    // cout << slice(ans_reg, 3, 0).bit_num << endl;
    // cout << vd_or_red(slice(ans_reg, 3, 0)).data << endl;
    vd for_ZLC0_fra = {0, 24};
    assign(&for_ZLC0_fra, concat2(constant(0, 23), vd_or_red(slice(ans_reg, 3, 0))), -1, 0);
    vd for_ZLC0_fra_sum = {0, 24};
    assign(&for_ZLC0_fra_sum, add(ans_shift_reg, for_ZLC0_fra), -1, -1);
    vd ZLC0_fra = {0, 23};
    assign(&ZLC0_fra, 
         (slice(for_ZLC0_fra_sum, 23, 23).data) ? 
         concat2(constant(0, 1), slice(for_ZLC0_fra_sum, 22, 1)) :
         slice(for_ZLC0_fra_sum, 22, 0),
         -1, -1);
    vd ZLC0_exp = {0, 8};
    assign(&ZLC0_exp, 
        (slice(for_ZLC0_fra_sum, 23, 23).data) ?
        add(exp_next, constant(2, 8)) :
        add(exp_next, constant(1, 8)),
        -1, -1);

    vd for_ZLC1_fra = {0, 24};
    assign(&for_ZLC1_fra, concat2(constant(0, 23), vd_or_red(slice(ans_reg, 2, 0))), -1, 0);
    // cout << for_ZLC1_fra.data << endl;
    vd for_ZLC1_fra_sum = {0, 24};
    assign(&for_ZLC1_fra_sum, add(ans_shift_reg, for_ZLC1_fra), -1, -1);
    vd ZLC1_fra = {0, 23};
    // bit_print(ans_shift_reg.data);
    assign(&ZLC1_fra, 
        (slice(for_ZLC1_fra_sum, 23, 23).data) ? 
        concat2(constant(0, 1), slice(for_ZLC1_fra_sum, 22, 1)) :
        slice(for_ZLC1_fra_sum, 22, 0),
        -1, -1);
    vd ZLC1_exp = {0, 8};
    assign(&ZLC1_exp, 
        (slice(for_ZLC1_fra_sum, 23, 23).data) ?
        add(exp_next, constant(1, 8)) :
        exp_next,
        -1, -1);

    vd for_ZLC2_fra = {0, 24};
    assign(&for_ZLC2_fra, concat2(constant(0, 23), vd_or_red(slice(ans_reg, 1, 0))), -1, 0);
    vd for_ZLC2_fra_sum = {0, 24};
    assign(&for_ZLC2_fra_sum, add(ans_shift_reg, for_ZLC2_fra), -1, -1);
    vd ZLC2_fra = {0, 23};
    assign(&ZLC2_fra, 
        (slice(for_ZLC2_fra_sum, 23, 23).data) ? 
        concat2(constant(0, 1), slice(for_ZLC2_fra_sum, 22, 1)) :
        slice(for_ZLC2_fra_sum, 22, 0),
        -1, -1);
    vd ZLC2_exp = {0, 9};
    assign(&ZLC2_exp, 
        (slice(for_ZLC2_fra_sum, 23, 23).data) ?
        exp_next_zero :
        sub(exp_next_zero, constant(1, 9)),
        -1, -1);

    vd for_ZLC3_fra = {0, 24};
    assign(&for_ZLC3_fra, concat2(constant(0, 23), slice(ans_reg, 0, 0)), -1, 0);
    vd for_ZLC3_fra_sum = {0, 24};
    assign(&for_ZLC3_fra_sum, add(ans_shift_reg, for_ZLC3_fra), -1, -1);
    vd ZLC3_fra = {0, 23};
    assign(&ZLC3_fra, 
        (slice(for_ZLC3_fra_sum, 23, 23).data) ?
        concat2(constant(0, 1), slice(for_ZLC3_fra_sum, 22, 1)) :
        slice(for_ZLC3_fra_sum, 22, 0),
        -1, -1);
    vd ZLC3_exp = {0, 9};
    assign(&ZLC3_exp, 
        (slice(for_ZLC3_fra_sum, 23, 23).data) ?
        sub(exp_next_zero, constant(1, 9)) :
        sub(exp_next_zero, constant(2, 9)),
        -1, -1);

    vd ZLC_lt3_fra = {0, 23};
    assign(&ZLC_lt3_fra, slice(ans_shift_reg, 22, 0), -1, 0);
    vd for_ZLC_lt3_exp = {0, 9};
    assign(&for_ZLC_lt3_exp, concat2(constant(0, 4), zero_count_reg), -1, 0);
    vd for2_ZLC_lt3_exp = {0, 9};
    assign(&for2_ZLC_lt3_exp, constant(1, 9), -1, 0);
    vd ZLC_lt3_exp = {0, 9};
    assign(&ZLC_lt3_exp, add(sub(exp_next_zero, for_ZLC_lt3_exp), for2_ZLC_lt3_exp), -1, 0);

    if (zero_count_reg.data == 0){
        // cout << "a" << endl;
        assign(&result, concat3(sig_next, ZLC0_exp, ZLC0_fra), -1, 0);
    } else if (zero_count_reg.data == 1){
        // cout << "b" << endl;
        assign(&result, concat3(sig_next, ZLC1_exp, ZLC1_fra), -1, 0);
    } else if (zero_count_reg.data == 2){
        // cout << "c" << endl;
        if (slice(ZLC2_exp,8, 8).data){
            assign(&result, concat3(sig_next, constant(0, 8), ZLC2_fra), -1, 0);
        } else {
            assign(&result, concat3(sig_next, slice(ZLC2_exp, 7, 0), ZLC2_fra), -1, 0);
        } 
    } else if (zero_count_reg.data == 3){
        // cout << "d" << endl;
        if (slice(ZLC3_exp,8, 8).data){
            // cout << "da" << endl;
            assign(&result, concat3(sig_next, constant(0, 8), ZLC3_fra), -1, 0);
        } else {
            // cout << "db" << endl;
            assign(&result, concat3(sig_next, slice(ZLC3_exp, 7, 0), ZLC3_fra), -1, 0);
        } 
    } else {
        // cout << "e" << endl;
        if (slice(ZLC_lt3_exp, 8, 8).data){
            assign(&result, concat3(sig_next, constant(0, 8), ZLC3_fra), -1, 0);
        } else {
            assign(&result, concat3(sig_next, slice(ZLC_lt3_exp, 7, 0), ZLC_lt3_fra), -1, 0);
        }
    }
    cout << dec;
    // bit_print(concat3(sig_next, ZLC0_exp, ZLC0_fra).data);
    // bit_print(concat3(sig_next, ZLC1_exp, ZLC1_fra).data);
    // bit_print(concat3(sig_next, constant(0, 8), ZLC2_fra).data);
    // bit_print(concat3(sig_next, slice(ZLC2_exp, 7, 0), ZLC2_fra).data);
    // bit_print(concat3(sig_next, constant(0, 8), ZLC3_fra).data);
    // bit_print(concat3(sig_next, slice(ZLC3_exp, 7, 0), ZLC3_fra).data);
    // bit_print(concat3(sig_next, constant(0, 8), ZLC3_fra).data);
    // bit_print(concat3(sig_next, slice(ZLC_lt3_exp, 7, 0), ZLC_lt3_fra).data);
    // cout << hex;
    // cout << "exp1 : " << exp1.data << endl;
    // cout << "exp2 : " << exp2.data << endl;
    // cout << "fra1 : " << fra1.data << endl;
    // cout << "fra2 : " << fra2.data << endl;
    // cout << "op1_is_abs_bigger : " << op1_is_abs_bigger.data << endl;
    // cout << "shift_1 : " << shift_1.data << endl;
    // cout << "shift_2 : " << shift_2.data << endl;
    // cout << "op_big : " << op_big.data << endl;
    // cout << "op_small : " << op_small.data << endl;
    // cout << "exp_big : " << exp_big.data << endl;
    // cout << "sig_big : " << sig_big.data << endl;
    // cout << "sig_small : " << sig_small.data << endl;
    // cout << "ans : " << ans.data << endl;
    // cout << "ans_reg : " << ans_reg.data << endl;
    // cout << "zero_count : " << zero_count.data << endl;
    // cout << "ans_shift : " << ans_shift.data << endl;
    // cout << "ans_shift_reg : " << ans_shift_reg.data << endl;
    // cout << "marume_up : " << marume_up.data << endl;
    // cout << "exp_next : " << exp_next.data << endl;
    // cout << "sig_next : " << sig_next.data << endl;
    // cout << "sig_next.bit_num : " << sig_next.bit_num << endl;
    // cout << "zero_count_reg : " << zero_count_reg.data << endl;
    // cout << "exp_next_zero: " << exp_next_zero.data << endl;
    // cout << "for_exp_next : " << for_exp_next.data << endl;
    // cout << "for_ZLC0_fra : " << for_ZLC0_fra.data << endl;
    // cout << "ZLC0_fra : " << ZLC0_fra.data << endl;
    // cout << "ZLC0_fra.bit_num : " << ZLC0_fra.bit_num << endl;
    // cout << "ZLC0_exp : " << ZLC0_exp.data << endl;
    // cout << "ZLC0_exp.bit_num : " << ZLC0_exp.bit_num << endl;
    // cout << "for_ZLC1_fra : " << for_ZLC1_fra.data << endl;
    // cout << "ZLC1_fra : " << ZLC1_fra.data << endl;
    // cout << "ZLC1_exp : " << ZLC1_exp.data << endl;
    // cout << "for_ZLC2_fra : " << for_ZLC2_fra.data << endl;
    // cout << "ZLC2_fra : " << ZLC2_fra.data << endl;
    // cout << "ZLC2_exp : " << ZLC2_exp.data << endl;
    // cout << "for_ZLC3_fra : " << for_ZLC3_fra.data << endl;
    // cout << "ZLC3_fra : " << ZLC3_fra.data << endl;
    // cout << "ZLC3_exp : " << ZLC3_exp.data << endl;




    return result;
}

#endif