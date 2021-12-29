#ifndef _ITOF
#define _ITOF
#include "fpu_items.hpp"
using namespace std;

vd ZLC_exp(vd op) {
    vd out = {0, 28};
    assign(&out, (slice(op, 30, 30).data) ? concat2(constant(0, 3), slice(op, 30, 6)) :
                 (slice(op, 29, 29).data) ? concat2(constant(1, 3), slice(op, 29, 5)) :
                 (slice(op, 28, 28).data) ? concat2(constant(2, 3), slice(op, 28, 4)) :
                 (slice(op, 27, 27).data) ? concat2(constant(3, 3), slice(op, 27, 3)) :
                 (slice(op, 26, 26).data) ? concat2(constant(4, 3), slice(op, 26, 2)) :
                 (slice(op, 25, 25).data) ? concat2(constant(5, 3), slice(op, 25, 1)) :
                 concat2(constant(6, 3), slice(op, 24, 0)), -1, -1);
    return out;
}

vd ZLC_fra(vd op){
    vd out = {0, 29};
    assign(&out,(slice(op, 23, 23).data) ? concat3(constant(0, 5), slice(op, 22, 0), constant(0, 1)) :
                (slice(op, 22, 22).data) ? concat3(constant(1, 5), slice(op, 21, 0), constant(0, 2)) :
                (slice(op, 21, 21).data) ? concat3(constant(2, 5), slice(op, 20, 0), constant(0, 3)) :
                (slice(op, 20, 20).data) ? concat3(constant(3, 5), slice(op, 19, 0), constant(0, 4)) :
                (slice(op, 19, 19).data) ? concat3(constant(4, 5), slice(op, 18, 0), constant(0, 5)) :
                (slice(op, 18, 18).data) ? concat3(constant(5, 5), slice(op, 17, 0), constant(0, 6)) :
                (slice(op, 17, 17).data) ? concat3(constant(6, 5), slice(op, 16, 0), constant(0, 7)) :
                (slice(op, 16, 16).data) ? concat3(constant(7, 5), slice(op, 15, 0), constant(0, 8)) :
                (slice(op, 15, 15).data) ? concat3(constant(8, 5), slice(op, 14, 0), constant(0, 9)) :
                (slice(op, 14, 14).data) ? concat3(constant(9, 5), slice(op, 13, 0), constant(0, 10)) :
                (slice(op, 13, 13).data) ? concat3(constant(10, 5), slice(op, 12, 0), constant(0, 11)) :
                (slice(op, 12, 12).data) ? concat3(constant(11, 5), slice(op, 11, 0), constant(0, 12)) :
                (slice(op, 11, 11).data) ? concat3(constant(12, 5), slice(op, 10, 0), constant(0, 13)) :
                (slice(op, 10, 10).data) ? concat3(constant(13, 5), slice(op, 9, 0), constant(0, 14)) :
                (slice(op, 9, 9).data) ? concat3(constant(14, 5), slice(op, 8, 0), constant(0, 15)) :
                (slice(op, 8, 8).data) ? concat3(constant(15, 5), slice(op, 7, 0), constant(0, 16)) :
                (slice(op, 7, 7).data) ? concat3(constant(16, 5), slice(op, 6, 0), constant(0, 17)) :
                (slice(op, 6, 6).data) ? concat3(constant(17, 5), slice(op, 5, 0), constant(0, 18)) :
                (slice(op, 5, 5).data) ? concat3(constant(18, 5), slice(op, 4, 0), constant(0, 19)) :
                (slice(op, 4, 4).data) ? concat3(constant(19, 5), slice(op, 3, 0), constant(0, 20)) :
                (slice(op, 3, 3).data) ? concat3(constant(20, 5), slice(op, 2, 0), constant(0, 21)) :
                (slice(op, 2, 2).data) ? concat3(constant(21, 5), slice(op, 1, 0), constant(0, 22)) :
                (slice(op, 1, 1).data) ? concat3(constant(22, 5), slice(op, 0, 0), constant(0, 23)) :
                (slice(op, 0, 0).data) ? concat2(constant(23, 5), constant(0, 24)) :
                concat3(constant(24, 5), constant(0, 23), constant(1,1)), -1, -1);
    return out;
}

// 01100000001100110110001101101110

vd itof(vd op){
    vd result = {0, 32};
    vd sig = {0, 1};
    vd abs_op = {0, 31};
    vd outpre = {0, 28};
    vd exp_zero_count = {0, 3};
    vd fra = {0, 24};
    vd kuriagari = {0, 1};
    vd fra_all_one = {0, 1};

    vd exp_zero_count_reg = {0, 3};
    vd zero_exp_zero_count = {0, 8};
    vd fra_result = {0, 23};
    vd sig_result = {0, 1};
    vd sub_from = {0, 8};
    vd use_fra_plus_1 = {0, 1};
    vd for_fra_plus_1 = {0, 24};

    vd outpre_2 = {0, 29};
    vd fra_zero_count = {0, 5};
    vd fra_2 = {0, 23};
    vd is_zero = {0, 1};

    vd fra_zero_count_reg = {0, 5};
    vd zero_fra_zero_count = {0, 8};

    vd is_zero_reg = {0, 1};
    vd exact = {0, 1};

    vd fra_plus_1 = {0, 24};
    vd exp_exact = {0, 8};
    vd exp_not_exact = {0, 8};

    vd result_use_fra_plus_1 = {0, 32};
    vd result_not_exact = {0, 32};
    vd result_exact = {0, 32};
    

    // always 
    if (slice(op, 31, 31).data){
        assign(&sig, constant(1,1), -1, -1);
        assign(&abs_op, add(vd_not(slice(op, 30, 0)), constant(1, 31)), -1, -1);
    }
    else{
        assign(&sig, constant(0,1), -1, -1);
        assign(&abs_op, slice(op, 30, 0), -1, -1);
    }
    // 次のクロックで代入
    assign(&sig_result, sig, -1, -1);
    outpre = ZLC_exp(abs_op);
    assign(&exp_zero_count, slice(outpre, 27, 25), -1, -1);
    assign(&exp_zero_count_reg, exp_zero_count, -1, -1);
    outpre_2 = ZLC_fra(slice(abs_op, 23, 0));
    assign(&fra_zero_count, slice(outpre_2, 28, 24), -1, -1);
    assign(&fra_zero_count_reg, fra_zero_count, -1, -1);
    assign(&fra, slice(outpre, 24, 1), -1, -1);
    assign(&for_fra_plus_1, fra, -1, -1);
    assign(&fra_plus_1, add(for_fra_plus_1, constant(1, 24)), -1, -1);

    assign(&kuriagari, slice(outpre, 0, 0), -1, -1);
    assign(&fra_all_one, vd_and_red(fra), -1, -1);
    assign(&fra_2, slice(outpre_2, 23, 1), -1, -1);
    assign(&is_zero, slice(outpre_2, 0, 0), -1, -1);
    if (vd_or_red(slice(abs_op, 30, 24)).data) {
        assign(&exact, constant(0, 1), -1, -1);
        assign(&is_zero_reg, constant(0, 1), -1 ,-1);
        if (kuriagari.data == 1 && fra_all_one.data == 1) {
            assign(&fra_result, constant(0, 23), -1, -1);
            assign(&sub_from, constant(158, 8), -1, -1);
            assign(&use_fra_plus_1, constant(0, 1), -1, -1);
        }
        else if (kuriagari.data == 1){
            assign(&fra_result, constant(0, 23), -1, -1);
            assign(&sub_from, constant(157, 8), -1, -1);
            assign(&use_fra_plus_1, constant(1, 1), -1, -1);
        }
        else {
            assign(&fra_result, slice(fra, 22, 0), -1, -1);
            assign(&sub_from, constant(157, 8), -1, -1);
            assign(&use_fra_plus_1, constant(0, 1), -1, -1);
        }
    }
    else {
        assign(&exact, constant(1, 1), -1, -1);
        assign(&fra_result, fra_2, -1, -1);
        assign(&sub_from, constant(150, 8), -1, -1);
        assign(&use_fra_plus_1, constant(0, 1), -1, -1);
        assign(&is_zero_reg, is_zero, -1, -1);
    }

    assign(&zero_fra_zero_count, concat2(constant(0, 3), fra_zero_count_reg), -1, -1);
    assign(&exp_exact, sub(sub_from, zero_fra_zero_count), -1, -1);
    assign(&zero_exp_zero_count, concat2(constant(0, 5), exp_zero_count_reg), -1, -1);
    assign(&exp_not_exact, sub(sub_from, zero_exp_zero_count), -1, -1);
    assign(&result_use_fra_plus_1, concat3(sig_result, exp_not_exact, slice(fra_plus_1, 22, 0)), -1, -1);
    assign(&result_not_exact, concat3(sig_result, exp_not_exact, fra_result), -1, -1);
    assign(&result_exact, concat3(sig_result, exp_exact, fra_result), -1, -1);
    if (exact.data == 0) {
        if (use_fra_plus_1.data) {
            assign(&result, result_use_fra_plus_1, -1, -1);
        }
        else {
            assign(&result, result_not_exact, -1, -1);
        }
    }
    else if (is_zero_reg.data) {
        assign(&result, constant(0, 32), -1, -1);
    }
    else if (exact.data) {
        assign(&result, result_exact, -1, -1);
    }
    return result;
}

#endif