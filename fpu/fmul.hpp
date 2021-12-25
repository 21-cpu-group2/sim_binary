#ifndef _FABS
#define _FABS
#include "fpu_items.hpp"
using namespace std;

inline vd fmul(vd op1, vd op2){
    // my_float result;
    // result.sgn.bit_num = 1;
    // result.exp.bit_num = 8;
    // result.fra.bit_num = 23;
    // assign(&(result.sgn), constant(0, 32), 31, 0);
    // assign(&(result.fra), constant(0, 32), 31, 0);
    // assign(&(result.exp), constant(0, 32), 31, 0);

    vd result = {0, 32};

    vd exp1 = {0, 8};
    vd exp2 = {0, 8};
    vd sig1 = {0, 1};
    vd sig2 = {0, 1};
    assign(&exp1, slice(op1, 30, 23), -1, 0);
    assign(&exp2, slice(op2, 30, 23), -1, 0);
    assign(&sig1, slice(op1, 31, 31), 0, 0);
    assign(&sig2, slice(op2, 31, 31), 0, 0);
    vd H1 = {0, 13};
    vd H2 = {0, 13};
    vd L1 = {0, 11};
    vd L2 = {0, 11};
    assign(&H1, concat2(constant(1, 1), slice(op1, 22, 11)), -1, 0);
    assign(&H2, concat2(constant(1, 1), slice(op2, 22, 11)), -1, 0);
    assign(&L1, slice(op1, 10, 0), -1, 0);
    assign(&L2, slice(op2, 10, 0), -1, 0);

    vd HH = {0, 26};
    vd HL = {0, 26};
    vd LH = {0, 26};
    vd res_exp = {0, 9};
    vd res_sig = {0, 1};

    vd ex_exp1 = {0, 9};
    assign(&ex_exp1, concat2(constant(0, 1), exp1), 8, 0);
    vd ex_exp2 = {0, 9};
    assign(&ex_exp2, concat2(constant(0, 1), exp2), 8, 0);

    vd sum = {0, 26};
    vd res_exp_plus1 = {0, 9};
    vd res_exp_2 = {0, 9};
    vd res_sig_2 = {0, 1};

    //ここから1clk目
    assign(&HH, mul(H1, H2, 26), 25, 0);
    assign(&HL, mul(H1, L2, 26), 25, 0);
    assign(&LH, mul(L1, H2, 26), 25, 0);
    assign(&res_exp, add(add(ex_exp1, ex_exp2), constant(129, 9)), 8, 0);
    // printf("line53 %d \n", res_exp.data);
    assign(&res_sig, vd_xor(sig1, sig2), 0, 0);
    //ここまで1clk目　これから2clk目
    assign(&sum, add(add(add(HH, sr(HL, 11)), sr(LH, 11)), constant(2, 26)), 25, 0);
    assign(&res_exp_plus1, add(res_exp, constant(1, 9)), 8, 0);
    assign(&res_sig_2, res_sig, 0, 0);
    assign(&res_exp_2, res_exp, 8, 0);
    //2-3
    if (slice(sum, 25, 25).data){
        if (slice(res_exp_plus1, 8, 8).data){
            assign(&result, res_sig_2, 31, 31);
            assign(&result, slice(res_exp_plus1, 7, 0), 30, 23);
            assign(&result, slice(sum, 24, 2), 22, 0);
        } else {
            cout << "fmul ovf1" << endl;
        }
    } else {
        if(slice(res_exp_2, 8, 8).data){
            assign(&result, res_sig_2, 31, 31);
            assign(&result, res_exp_2, 30, 23);
            assign(&result, slice(sum, 23, 1), 22, 0);
            // printf("line74 %d \n", res_exp_2.data);
        } else {
            cout << "fmul ovf2" << endl;
        }
    }
    return result;
}

#endif