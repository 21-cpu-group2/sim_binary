#ifndef _FTOI
#define _FTOI
#include "fpu_items.hpp"
using namespace std;

vd ftoi(vd op){
    vd result;
    result.bit_num = 32;
    vd sig;
    sig.bit_num = 1;
    vd exp;
    exp.bit_num = 8;
    vd fra;
    fra.bit_num = 23;
    assign(&sig, slice(op, 31, 31), 0, 0);
    assign(&exp, slice(op, 30, 23), 7, 0);
    assign(&fra, slice(op, 22, 0), 22, 0);
    vd flag_ans_top;  // ���1bit
    flag_ans_top.bit_num = 1;
    vd flag_ans_bottom;  // ����32bit
    flag_ans_bottom.bit_num = 32;
    vd sig_reg;
    sig_reg.bit_num = 1;

    // initialization
    assign(&result, constant(0, 32), 31, 0);
    assign(&sig_reg, constant(0, 1), 0, 0);

    for (int i=0; i<2; i++){
        assign(&sig_reg, sig, 0, 0);
        switch (exp.data) {
            case 126:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, constant(0, 32), 31, 0);
            case 127:
                assign(&flag_ans_top, slice(fra, 22, 22), 0, 0);
                assign(&flag_ans_bottom, constant(1, 32), 31, 0);
            case 128:
                assign(&flag_ans_top, slice(fra, 21, 21), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 31), slice(fra, 22, 22)), 31, 0);
            case 129:
                assign(&flag_ans_top, slice(fra, 20, 20), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 30), slice(fra, 22, 21)), 31, 0);
            case 130:
                assign(&flag_ans_top, slice(fra, 19, 19), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 29), slice(fra, 22, 20)), 31, 0);
            case 131:
                assign(&flag_ans_top, slice(fra, 18, 18), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 28), slice(fra, 22, 19)), 31, 0);
            case 132:
                assign(&flag_ans_top, slice(fra, 17, 17), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 27), slice(fra, 22, 18)), 31, 0);
            case 133:
                assign(&flag_ans_top, slice(fra, 16, 16), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 26), slice(fra, 22, 17)), 31, 0);
            case 134:
                assign(&flag_ans_top, slice(fra, 15, 15), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 25), slice(fra, 22, 16)), 31, 0);
            case 135:
                assign(&flag_ans_top, slice(fra, 14, 14), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 24), slice(fra, 22, 15)), 31, 0);
            case 136:
                assign(&flag_ans_top, slice(fra, 13, 13), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 23), slice(fra, 22, 14)), 31, 0);
            case 137:
                assign(&flag_ans_top, slice(fra, 12, 12), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 22), slice(fra, 22, 13)), 31, 0);
            case 138:
                assign(&flag_ans_top, slice(fra, 11, 11), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 21), slice(fra, 22, 12)), 31, 0);
            case 139:
                assign(&flag_ans_top, slice(fra, 10, 10), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 20), slice(fra, 22, 11)), 31, 0);
            case 140:
                assign(&flag_ans_top, slice(fra, 9, 9), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 19), slice(fra, 22, 10)), 31, 0);
            case 141:
                assign(&flag_ans_top, slice(fra, 8, 8), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 18), slice(fra, 22, 9)), 31, 0);
            case 142:
                assign(&flag_ans_top, slice(fra, 7, 7), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 17), slice(fra, 22, 8)), 31, 0);
            case 143:
                assign(&flag_ans_top, slice(fra, 6, 6), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 16), slice(fra, 22, 7)), 31, 0);
            case 144:
                assign(&flag_ans_top, slice(fra, 5, 5), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 15), slice(fra, 22, 6)), 31, 0);
            case 145:
                assign(&flag_ans_top, slice(fra, 4, 4), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 14), slice(fra, 22, 5)), 31, 0);
            case 146:
                assign(&flag_ans_top, slice(fra, 3, 3), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 13), slice(fra, 22, 4)), 31, 0);
            case 147:
                assign(&flag_ans_top, slice(fra, 2, 2), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 12), slice(fra, 22, 3)), 31, 0);
            case 148:
                assign(&flag_ans_top, slice(fra, 1, 1), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 11), slice(fra, 22, 2)), 31, 0);
            case 149:
                assign(&flag_ans_top, slice(fra, 0, 0), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 10), slice(fra, 22, 1)), 31, 0);
            case 150:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat2(constant(1, 9), fra), 31, 0);
            case 151:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat3(constant(1, 8), fra, constant(0, 1)), 31, 0);
            case 152:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat3(constant(1, 7), fra, constant(0, 2)), 31, 0);
            case 153:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat3(constant(1, 6), fra, constant(0, 3)), 31, 0);
            case 154:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat3(constant(1, 5), fra, constant(0, 4)), 31, 0);
            case 155:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat3(constant(1, 4), fra, constant(0, 5)), 31, 0);
            case 156:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat3(constant(1, 3), fra, constant(0, 6)), 31, 0);
            case 157:
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, concat3(constant(1, 2), fra, constant(0, 7)), 31, 0);
            default :
                assign(&flag_ans_top, constant(0, 1), 0, 0);
                assign(&flag_ans_bottom, constant(0, 32), 31, 0);
        }
        cout << flag_ans_top.data << endl;
        cout << flag_ans_bottom.data << endl;
        vd ad;
        ad.bit_num = 32;
        assign(&ad, concat2(constant(0, 31), flag_ans_top), 31, 0);
        vd ans;
        ans.bit_num = 32;
        assign(&ans, flag_ans_bottom, 31, 0);
        vd add_ans;
        add_ans.bit_num = 32;
        assign(&add_ans, add(ad, ans), 31, 0);
        vd add_ans_reverse;
        add_ans_reverse.bit_num = 32;
        assign(&add_ans_reverse, vd_not(add_ans), 31, 0);
        vd minus_add_ans;
        minus_add_ans.bit_num = 32;
        assign(&minus_add_ans, add(add_ans_reverse, constant(1, 32)), 31, 0);
        if (sig_reg.data){
            assign(&result, minus_add_ans, 31, 0);
        }
        else {
            assign(&result, add_ans, 31, 0);
        }
    }
    return result;
}

#endif
