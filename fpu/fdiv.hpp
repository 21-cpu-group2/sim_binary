#ifndef _FDIV
#define _FDIV
#include "fpu_items.hpp"

#define DEBUG 1

using namespace std;

// void bit_print(uint32_t n) {
//     for (int i=0; i<32; i++){
//         if (n & (1 << (31 - i))) {
//             cout << "1";
//         }
//         else {
//             cout << "0";
//         }
//     }
//     cout << endl;
//     return;
// }

inline vd fdiv(vd op1, vd op2) {
    vd result = {0, 32};

    vd fra1 = {0, 25};
    vd fra2 = {0, 25};
    vd exp1 = {0, 9};
    vd exp2 = {0, 9};
    vd sig1 = {0, 1};
    vd sig2 = {0, 1};

    assign(&fra1, (slice(op1, 30, 23).data == 0) ? constant(0, 25) : 
                concat2(constant(1, 2), slice(op1, 22, 0)), -1, -1);
    assign(&fra2, (slice(op2, 30, 23).data == 0) ? concat2(constant(0, 2), slice(op2, 22, 0)) : 
                concat2(constant(1, 2), slice(op2, 22, 0)), -1, -1);
    assign(&exp1, concat2(constant(0, 1), slice(op1, 30, 23)), -1, -1);
    assign(&exp2, concat2(constant(0, 1), slice(op2, 30, 23)), -1, -1);
    assign(&sig1, slice(op1, 31, 31), -1, -1);
    assign(&sig2, slice(op2, 31, 31), -1, -1);

    vd ans1_12 = {0, 2};
    vd ans2_12 = {0, 2};
    vd ans3_12 = {0, 2};
    vd ans4_12 = {0, 2};
    vd ans5_12 = {0, 2};
    vd ans6_12 = {0, 2};
    vd ans7_12 = {0, 2};
    vd ans8_12 = {0, 2};
    vd ans9_12 = {0, 2};
    vd ans10_12 = {0, 2};
    vd ans11_12 = {0, 2};
    vd ans12_12 = {0, 2};

    vd for_ans_exp = add(exp1, constant(127, 9));
    vd ans_exp = {0, 9};
    if (exp1.data == 0) {
        ans_exp = constant(pow(2, 8), 9);
    } else {
        ans_exp = sub(for_ans_exp, exp2);
    }


    // 1clk???
    vd sub1 = sub(fra1, fra2);
    vd x1 = (slice(sub1, 24, 24).data == 1) ? sl(fra1, 1) : sl(sub1, 1);
    assign(&ans1_12, (slice(sub1, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);
    
    vd sub2 = sub(x1, fra2);
    vd x2 = (slice(sub2, 24, 24).data == 1) ? sl(x1, 1) : sl(sub2, 1);
    assign(&ans1_12, (slice(sub2, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    //2clk???
    vd ans1to1 = ans1_12;
    vd x2_reg = x2;
    vd fra2_2 = fra2;
    vd ans_exp_2 = ans_exp;
    vd ans_sig_reg_2 = vd_xor(sig1, sig2);

    vd sub3 = sub(x2_reg, fra2_2);
    vd x3 = (slice(sub3, 24, 24).data == 1) ? sl(x2_reg, 1) : sl(sub3, 1);
    assign(&ans2_12, (slice(sub3, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub4 = sub(x3, fra2_2);
    vd x4 = (slice(sub4, 24, 24).data == 1) ? sl(x3, 1) : sl(sub4, 1);
    assign(&ans2_12, (slice(sub4, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 3clk???
    vd ans1to2 = concat2(ans1to1, ans2_12);
    vd x4_reg = x4;
    vd fra2_3 = fra2_2;
    vd ans_exp_3 = ans_exp_2;
    vd ans_sig_reg_3 = ans_sig_reg_2;

    vd sub5 = sub(x4_reg, fra2_3);
    vd x5 = (slice(sub5, 24, 24).data == 1) ? sl(x4_reg, 1) : sl(sub5, 1);
    assign(&ans3_12, (slice(sub5, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);
    
    vd sub6 = sub(x5, fra2_3);
    vd x6 = (slice(sub6, 24, 24).data == 1) ? sl(x5, 1) : sl(sub6, 1);
    assign(&ans3_12, (slice(sub6, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 4clk???
    vd ans1to3 = concat2(ans1to2, ans3_12);
    vd x6_reg = x6;
    vd fra2_4 = fra2_3;
    vd ans_exp_4 = ans_exp_3;
    vd ans_sig_reg_4 = ans_sig_reg_3;

    vd sub7 = sub(x6_reg, fra2_4);
    vd x7 = (slice(sub7, 24, 24).data == 1) ? sl(x6_reg, 1) : sl(sub7, 1);
    assign(&ans4_12, (slice(sub7, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub8 = sub(x7, fra2_4);
    vd x8 = (slice(sub8, 24, 24).data == 1) ? sl(x7, 1) : sl(sub8, 1);
    assign(&ans4_12, (slice(sub8, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 5clk???
    vd ans1to4 = concat2(ans1to3, ans4_12);
    vd x8_reg = x8;
    vd fra2_5 = fra2_4;
    vd ans_exp_5 = ans_exp_4;
    vd ans_sig_reg_5 = ans_sig_reg_4;

    vd sub9 = sub(x8_reg, fra2_5);
    vd x9 = (slice(sub9, 24, 24).data == 1) ? sl(x8_reg, 1) : sl(sub9, 1);
    assign(&ans5_12, (slice(sub9, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);
    
    vd sub10 = sub(x9, fra2_5);
    vd x10 = (slice(sub10, 24, 24).data == 1) ? sl(x9, 1) : sl(sub10, 1);
    assign(&ans5_12, (slice(sub10, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 6clk???
    vd ans1to5 = concat2(ans1to4, ans5_12);
    vd x10_reg = x10;
    vd fra2_6 = fra2_5;
    vd ans_exp_6 = ans_exp_5;
    vd ans_sig_reg_6 = ans_sig_reg_5;

    vd sub11 = sub(x10_reg, fra2_6);
    vd x11 = (slice(sub11, 24, 24).data == 1) ? sl(x10_reg, 1) : sl(sub11, 1);
    assign(&ans6_12, (slice(sub11, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub12 = sub(x11, fra2_6);
    vd x12 = (slice(sub12, 24, 24).data == 1) ? sl(x11, 1) : sl(sub12, 1);
    assign(&ans6_12, (slice(sub12, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 7clk???
    vd ans1to6 = concat2(ans1to5, ans6_12);
    vd x12_reg = x12;
    vd fra2_7 = fra2_6;
    vd ans_exp_7 = ans_exp_6;
    vd ans_sig_reg_7 = ans_sig_reg_6;

    vd sub13 = sub(x12_reg, fra2_7);
    vd x13 = (slice(sub13, 24, 24).data == 1) ? sl(x12_reg, 1) : sl(sub13, 1);
    assign(&ans7_12, (slice(sub13, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);
    
    vd sub14 = sub(x13, fra2_7);
    vd x14 = (slice(sub14, 24, 24).data == 1) ? sl(x13, 1) : sl(sub14, 1);
    assign(&ans7_12, (slice(sub14, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 8clk???
    vd ans1to7 = concat2(ans1to6, ans7_12);
    vd x14_reg = x14;
    vd fra2_8 = fra2_7;
    vd ans_exp_8 = ans_exp_7;
    vd ans_sig_reg_8 = ans_sig_reg_7;

    vd sub15 = sub(x14_reg, fra2_8);
    vd x15 = (slice(sub15, 24, 24).data == 1) ? sl(x14_reg, 1) : sl(sub15, 1);
    assign(&ans8_12, (slice(sub15, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub16 = sub(x15, fra2_8);
    vd x16 = (slice(sub16, 24, 24).data == 1) ? sl(x15, 1) : sl(sub16, 1);
    assign(&ans8_12, (slice(sub16, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 9clk???
    vd ans1to8 = concat2(ans1to7, ans8_12);
    vd x16_reg = x16;
    vd fra2_9 = fra2_8;
    vd ans_exp_9 = ans_exp_8;
    vd ans_sig_reg_9 = ans_sig_reg_8;

    vd sub17 = sub(x16_reg, fra2_9);
    vd x17 = (slice(sub17, 24, 24).data == 1) ? sl(x16_reg, 1) : sl(sub17, 1);
    assign(&ans9_12, (slice(sub17, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);
    
    vd sub18 = sub(x17, fra2_9);
    vd x18 = (slice(sub18, 24, 24).data == 1) ? sl(x17, 1) : sl(sub18, 1);
    assign(&ans9_12, (slice(sub18, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 10clk???
    vd ans1to9 = concat2(ans1to8, ans9_12);
    vd x18_reg = x18;
    vd fra2_10 = fra2_9;
    vd ans_exp_10 = ans_exp_9;
    vd ans_sig_reg_10 = ans_sig_reg_9;

    vd sub19 = sub(x18_reg, fra2_10);
    vd x19 = (slice(sub19, 24, 24).data == 1) ? sl(x18_reg, 1) : sl(sub19, 1);
    assign(&ans10_12, (slice(sub19, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub20 = sub(x19, fra2_10);
    vd x20 = (slice(sub20, 24, 24).data == 1) ? sl(x19, 1) : sl(sub20, 1);
    assign(&ans10_12, (slice(sub20, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 11clk???
    vd ans1to10 = concat2(ans1to9, ans10_12);
    vd x20_reg = x20;
    vd fra2_11 = fra2_10;
    vd ans_exp_11 = ans_exp_10;
    vd ans_sig_reg_11 = ans_sig_reg_10;

    vd sub21 = sub(x20_reg, fra2_11);
    vd x21 = (slice(sub21, 24, 24).data == 1) ? sl(x20_reg, 1) : sl(sub21, 1);
    assign(&ans11_12, (slice(sub21, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);
    
    vd sub22 = sub(x21, fra2_11);
    vd x22 = (slice(sub22, 24, 24).data == 1) ? sl(x21, 1) : sl(sub22, 1);
    assign(&ans11_12, (slice(sub22, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 12clk???
    vd ans1to11 = concat2(ans1to10, ans11_12);
    vd x22_reg = x22;
    vd fra2_12 = fra2_11;
    vd ans_exp_12 = ans_exp_11;
    vd ans_sig_reg_12 = ans_sig_reg_11;

    vd sub23 = sub(x22_reg, fra2_12);
    vd x23 = (slice(sub23, 24, 24).data == 1) ? sl(x22_reg, 1) : sl(sub23, 1);
    assign(&ans12_12, (slice(sub23, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub24 = {(sub(x23, fra2_12).data < 0) ? 1 : 0, 1};
    assign(&ans12_12, (sub24.data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    vd ans_exp_12_minus1 = {0, 9};
    if (exp1.data == 0){
        ans_exp_12_minus1 = constant(pow(2, 8), 9);
    } else {
        ans_exp_12_minus1 = sub(ans_exp_12, constant(1, 9));
    }


    if (slice(ans1to11, 21, 21).data == 1) {
        if (slice(ans_exp_12, 8, 8).data == 1) {
            assign(&result, constant(0, 32), -1, -1);
        }
        else {
            assign(&result, concat4(ans_sig_reg_12, slice(ans_exp_12, 7, 0), slice(ans1to11, 20, 0), ans12_12), -1, -1);
        }
    }
    else {
        if (slice(ans_exp_12_minus1, 8, 8).data == 1){
            assign(&result, constant(0, 32), -1, -1);
        }
        else{
            vd temp = {0, 31};
            assign(&temp, concat4(ans_sig_reg_12, slice(ans_exp_12_minus1, 7, 0), slice(ans1to11, 19, 0), ans12_12), -1, -1);
            assign(&result, concat2(temp, constant(0, 1)), -1, -1);

            // cout << "ans_sig_reg_6 : " << ans_sig_reg_6.data << endl;
            // cout << slice(ans_exp_6_minus1, 7, 0).data << endl;
            // cout << "ans1_6_6 : " << slice(ans1_6_6, 1, 0).data << endl;
            // cout << "ans2_6_6 : " << ans2_6_6.data << endl;
            // cout << "ans3_6_6 : " << ans3_6_6.data << endl;
            // cout << "ans4_6_6 : " << ans4_6_6.data << endl;
            // cout << "ans5_6_6 : " << ans5_6_6.data << endl;
            // cout << "ans6_6_6 : " << ans6_6.data << endl;
            // assign(&temp1, concat4(ans_sig_reg_6, slice(ans_exp_6_minus1, 7, 0), slice(ans1_6_6, 1, 0), ans2_6_6), -1, -1);
            // assign(&temp2, concat4(ans3_6_6, ans4_6_6, ans5_6_6, ans6_6), -1, -1);
            // cout << temp1.data << endl;
            // cout << temp2.data << endl;
            // assign(&result, concat3(temp1, temp2, constant(0, 1)), -1, -1);
            // cout << result.data << endl;
        }
    }
    return result;
}
#endif