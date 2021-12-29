#ifndef _FLOOR
#define _FLOOR
#include "fpu_items.hpp"
using namespace std;

inline vd floor(vd op){
    vd result = {0, 32};
    vd sig = {0, 1};
    vd exp = {0, 8};
    vd fra = {0, 23};
    assign(&sig, slice(op, 31, 31), -1, -1);
    assign(&exp, slice(op, 30, 23), -1, -1);
    assign(&fra, slice(op, 22, 0), -1, -1);

    vd new_sig_reg = {0, 1};
    vd new_exp_reg = {0, 8};
    vd new_fra_reg = {0, 25};

    vd fra_decimal = {0, 23};
    vd for_add = {0, 25};

    vd add_fra = {0, 25};
    vd exp_plus_1 = {0, 8};

    // first clk
    assign(&new_sig_reg, sig, -1, -1);
    if (slice(exp, 7, 7).data == 0 && ((vd_and_red(slice(exp, 6, 0))).data == 0)){
        assign(&fra_decimal, constant(0, 23), -1, -1);
        assign(&for_add, constant(0, 25), -1, -1);
        if (sig.data) {
            assign(&new_exp_reg, constant(127, 8), -1, -1);
            assign(&new_fra_reg, concat2(constant(1, 2), constant(0, 23)), -1, -1);
        }
        else {
            assign(&new_exp_reg, constant(0, 8), -1, -1);
            assign(&new_fra_reg, constant(0, 25), -1, -1);
        }
    }
    else {
        assign(&new_exp_reg, exp, -1 ,-1);
        cout << dec << "exp : " << exp.data << endl;
        switch (exp.data) {
            case 127 : 
                assign(&new_fra_reg, concat2(constant(1,2), constant(0, 23)), -1, -1);
                assign(&fra_decimal, fra, -1, -1);
                assign(&for_add, concat2(constant(1, 2), constant(0, 23)), -1, -1);
                break;
            case 128 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 22), constant(0, 22)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 1), slice(fra, 21, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 3), constant(0, 22)), -1, -1);
                break;
            case 129 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 21), constant(0, 21)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 2), slice(fra, 20, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 4), constant(0, 21)), -1, -1);
                break;
            case 130 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 20), constant(0, 20)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 3), slice(fra, 19, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 5), constant(0, 20)), -1, -1);
                break;
            case 131 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 19), constant(0, 19)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 4), slice(fra, 18, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 6), constant(0, 19)), -1, -1);
                break;
            case 132 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 18), constant(0, 18)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 5), slice(fra, 17, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 7), constant(0, 18)), -1, -1);
                break;
            case 133 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 17), constant(0, 17)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 6), slice(fra, 16, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 8), constant(0, 17)), -1, -1);
                break;
            case 134 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 16), constant(0, 16)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 7), slice(fra, 15, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 9), constant(0, 16)), -1, -1);
                break;
            case 135 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 15), constant(0, 15)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 8), slice(fra, 14, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 10), constant(0, 15)), -1, -1);
                break;
            case 136 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 14), constant(0, 14)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 9), slice(fra, 13, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 11), constant(0, 14)), -1, -1);
                break;
            case 137 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 13), constant(0, 13)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 10), slice(fra, 12, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 12), constant(0, 13)), -1, -1);
                break;
            case 138 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 12), constant(0, 12)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 11), slice(fra, 11, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 13), constant(0, 12)), -1, -1);
                break;
            case 139 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 11), constant(0, 11)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 12), slice(fra, 10, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 14), constant(0, 11)), -1, -1);
                break;
            case 140 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 10), constant(0, 10)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 13), slice(fra, 9, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 15), constant(0, 10)), -1, -1);
                break;
            case 141 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 9), constant(0, 9)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 14), slice(fra, 8, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 16), constant(0, 9)), -1, -1);
                break;
            case 142 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 8), constant(0, 8)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 15), slice(fra, 7, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 17), constant(0, 8)), -1, -1);
                break;
            case 143 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 7), constant(0, 7)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 16), slice(fra, 6, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 18), constant(0, 7)), -1, -1);
                break;
            case 144 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 6), constant(0, 6)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 17), slice(fra, 5, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 19), constant(0, 6)), -1, -1);
                break;
            case 145 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 5), constant(0, 5)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 18), slice(fra, 4, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 20), constant(0, 5)), -1, -1);
                break;
            case 146 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 4), constant(0, 4)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 19), slice(fra, 3, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 21), constant(0, 4)), -1, -1);
                break;
            case 147 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 3), constant(0, 3)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 20), slice(fra, 2, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 22), constant(0, 3)), -1, -1);
                break;
            case 148 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 2), constant(0, 2)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 21), slice(fra, 1, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 23), constant(0, 2)), -1, -1);
                break;
            case 149 : 
                assign(&new_fra_reg, concat3(constant(1,2), slice(fra, 22, 1), constant(0, 1)), -1, -1);
                assign(&fra_decimal, concat2(constant(0, 22), slice(fra, 0, 0)), -1, -1);
                assign(&for_add, concat2(constant(1, 24), constant(0, 1)), -1, -1);
                break;
            default :
                assign(&new_fra_reg, concat2(constant(1,2), fra), -1, -1);
                assign(&fra_decimal, constant(0 ,23), -1, -1);
                assign(&for_add, constant(0, 25), -1, -1);
        }
    }
    cout << hex;
    assign(&add_fra, add(new_fra_reg, for_add), -1, -1);
    cout << new_fra_reg.data << endl;
    cout << for_add.data << endl;
    cout << add_fra.data << endl;
    assign(&exp_plus_1, add(new_exp_reg, constant(1, 8)), -1, -1);
    if (new_sig_reg.data == 0 || (vd_or_red(fra_decimal)).data == 0) {
        assign(&result, concat3(new_sig_reg, new_exp_reg, slice(new_fra_reg, 22, 0)), -1, -1);
    }
    else if (slice(add_fra, 24, 24).data){
        assign(&result, concat3(new_sig_reg, exp_plus_1, constant(0, 23)), -1, -1);
    }
    else {
        assign(&result, concat3(new_sig_reg, new_exp_reg, slice(add_fra, 22, 0)), -1, -1);
    }
    return result;
}

#endif