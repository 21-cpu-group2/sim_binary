#ifndef _FDIV
#define _FDIV
#include "fpu_items.hpp"

#define DEBUG 1

using namespace std;

void bit_print(uint32_t n) {
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

inline vd fdiv(vd op1, vd op2) {
    vd result = {0, 32};

    vd fra1 = {0, 25};
    vd fra2 = {0, 25};
    vd exp1 = {0, 9};
    vd exp2 = {0, 9};
    vd sig1 = {0, 1};
    vd sig2 = {0, 1};

    assign(&fra1, (slice(op1, 30, 23).data == 0) ? concat2(constant(0, 2), slice(op1, 22, 0)) : 
                concat2(constant(1, 2), slice(op1, 22, 0)), -1, -1);
    assign(&fra2, (slice(op2, 30, 23).data == 0) ? concat2(constant(0, 2), slice(op2, 22, 0)) : 
                concat2(constant(1, 2), slice(op2, 22, 0)), -1, -1);
    assign(&exp1, concat2(constant(0, 1), slice(op1, 30, 23)), -1, -1);
    assign(&exp2, concat2(constant(0, 1), slice(op2, 30, 23)), -1, -1);
    assign(&sig1, slice(op1, 31, 31), -1, -1);
    assign(&sig2, slice(op2, 31, 31), -1, -1);

    vd ans1_6 = {0, 4};
    vd ans2_6 = {0, 4};
    vd ans3_6 = {0, 4};
    vd ans4_6 = {0, 4};
    vd ans5_6 = {0, 4};
    vd ans6_6 = {0, 4};

    vd for_ans_exp = add(exp1, constant(127, 9));
    vd ans_exp = sub(for_ans_exp, exp2);

    // 1clk目
    vd sub1 = sub(fra1, fra2);
    vd x1 = (slice(sub1, 24, 24).data == 1) ? sl(fra1, 1) : sl(sub1, 1);
    assign(&ans1_6, (slice(sub1, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 3, 3);
    
    vd sub2 = sub(x1, fra2);
    vd x2 = (slice(sub2, 24, 24).data == 1) ? sl(x1, 1) : sl(sub2, 1);
    assign(&ans1_6, (slice(sub2, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 2, 2);

    vd sub3 = sub(x2, fra2);
    vd x3 = (slice(sub3, 24, 24).data == 1) ? sl(x2, 1) : sl(sub3, 1);
    assign(&ans1_6, (slice(sub3, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub4 = sub(x3, fra2);
    vd x4 = (slice(sub4, 24, 24).data == 1) ? sl(x3, 1) : sl(sub4, 1);
    assign(&ans1_6, (slice(sub4, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 2clk目
    vd ans1_6_2 = ans1_6;
    vd x4_reg = x4;
    vd fra2_2 = fra2;
    vd ans_exp_2 = ans_exp;
    vd ans_sig_reg_2 = vd_xor(sig1, sig2);

    vd sub5 = sub(x4_reg, fra2_2);
    vd x5 = (slice(sub5, 24, 24).data == 1) ? sl(x4_reg, 1) : sl(sub5, 1);
    assign(&ans2_6, (slice(sub5, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 3, 3);
    
    vd sub6 = sub(x5, fra2_2);
    vd x6 = (slice(sub6, 24, 24).data == 1) ? sl(x5, 1) : sl(sub6, 1);
    assign(&ans2_6, (slice(sub6, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 2, 2);

    vd sub7 = sub(x6, fra2_2);
    vd x7 = (slice(sub7, 24, 24).data == 1) ? sl(x6, 1) : sl(sub7, 1);
    assign(&ans2_6, (slice(sub7, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub8 = sub(x7, fra2_2);
    vd x8 = (slice(sub8, 24, 24).data == 1) ? sl(x7, 1) : sl(sub8, 1);
    assign(&ans2_6, (slice(sub8, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 3clk目
    vd ans1_6_3 = ans1_6_2;
    vd ans2_6_3 = ans2_6;
    vd x8_reg = x8;
    vd fra2_3 = fra2_2;
    vd ans_exp_3 = ans_exp_2;
    vd ans_sig_reg_3 = ans_sig_reg_2;

    vd sub9 = sub(x8_reg, fra2_3);
    vd x9 = (slice(sub9, 24, 24).data == 1) ? sl(x8_reg, 1) : sl(sub9, 1);
    assign(&ans3_6, (slice(sub9, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 3, 3);
    
    vd sub10 = sub(x9, fra2_3);
    vd x10 = (slice(sub10, 24, 24).data == 1) ? sl(x9, 1) : sl(sub10, 1);
    assign(&ans3_6, (slice(sub10, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 2, 2);

    vd sub11 = sub(x10, fra2_3);
    vd x11 = (slice(sub11, 24, 24).data == 1) ? sl(x10, 1) : sl(sub11, 1);
    assign(&ans3_6, (slice(sub11, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub12 = sub(x11, fra2_3);
    vd x12 = (slice(sub12, 24, 24).data == 1) ? sl(x11, 1) : sl(sub12, 1);
    assign(&ans3_6, (slice(sub12, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 4clk目
    vd ans1_6_4 = ans1_6_3;
    vd ans2_6_4 = ans2_6_3;
    vd ans3_6_4 = ans3_6;
    vd x12_reg = x12;
    vd fra2_4 = fra2_3;
    vd ans_exp_4 = ans_exp_3;
    vd ans_sig_reg_4 = ans_sig_reg_3;

    vd sub13 = sub(x12_reg, fra2_4);
    vd x13 = (slice(sub13, 24, 24).data == 1) ? sl(x12_reg, 1) : sl(sub13, 1);
    assign(&ans4_6, (slice(sub13, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 3, 3);
    
    vd sub14 = sub(x13, fra2_4);
    vd x14 = (slice(sub14, 24, 24).data == 1) ? sl(x13, 1) : sl(sub14, 1);
    assign(&ans4_6, (slice(sub14, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 2, 2);

    vd sub15 = sub(x14, fra2_4);
    vd x15 = (slice(sub15, 24, 24).data == 1) ? sl(x14, 1) : sl(sub15, 1);
    assign(&ans4_6, (slice(sub15, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub16 = sub(x15, fra2_4);
    vd x16 = (slice(sub16, 24, 24).data == 1) ? sl(x15, 1) : sl(sub16, 1);
    assign(&ans4_6, (slice(sub16, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);


    // 5clk目
    vd ans1_6_5 = ans1_6_4;
    vd ans2_6_5 = ans2_6_4;
    vd ans3_6_5 = ans3_6_4;
    vd ans4_6_5 = ans4_6;
    vd x16_reg = x16;
    vd fra2_5 = fra2_4;
    vd ans_exp_5 = ans_exp_4;
    vd ans_sig_reg_5 = ans_sig_reg_4;

    vd sub17 = sub(x16_reg, fra2_5);
    vd x17 = (slice(sub17, 24, 24).data == 1) ? sl(x16_reg, 1) : sl(sub17, 1);
    assign(&ans5_6, (slice(sub17, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 3, 3);
    
    vd sub18 = sub(x17, fra2_5);
    vd x18 = (slice(sub18, 24, 24).data == 1) ? sl(x17, 1) : sl(sub18, 1);
    assign(&ans5_6, (slice(sub18, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 2, 2);

    vd sub19 = sub(x18, fra2_5);
    vd x19 = (slice(sub19, 24, 24).data == 1) ? sl(x18, 1) : sl(sub19, 1);
    assign(&ans5_6, (slice(sub19, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub20 = sub(x19, fra2_5);
    vd x20 = (slice(sub20, 24, 24).data == 1) ? sl(x19, 1) : sl(sub20, 1);
    assign(&ans5_6, (slice(sub20, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    // 6clk目
    vd ans1_6_6 = ans1_6_5;
    vd ans2_6_6 = ans2_6_5;
    vd ans3_6_6 = ans3_6_5;
    vd ans4_6_6 = ans4_6_5;
    vd ans5_6_6 = ans5_6;
    vd x20_reg = x20;
    vd fra2_6 = fra2_5;
    vd ans_exp_6 = ans_exp_5;
    vd ans_sig_reg_6 = ans_sig_reg_5;

    vd sub21 = sub(x20_reg, fra2_6);
    vd x21 = (slice(sub21, 24, 24).data == 1) ? sl(x20_reg, 1) : sl(sub21, 1);
    assign(&ans6_6, (slice(sub21, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 3, 3);
    
    vd sub22 = sub(x21, fra2_6);
    vd x22 = (slice(sub22, 24, 24).data == 1) ? sl(x21, 1) : sl(sub22, 1);
    assign(&ans6_6, (slice(sub22, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 2, 2);

    vd sub23 = sub(x22, fra2_6);
    vd x23 = (slice(sub23, 24, 24).data == 1) ? sl(x22, 1) : sl(sub23, 1);
    assign(&ans6_6, (slice(sub23, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 1, 1);

    vd sub24 = sub(x23, fra2_6);
    vd x24 = (slice(sub24, 24, 24).data == 1) ? sl(x23, 1) : sl(sub24, 1);
    assign(&ans6_6, (slice(sub24, 24, 24).data == 1) ? constant(0, 1) : constant(1, 1), 0, 0);

    vd ans_exp_6_minus1 = sub(ans_exp_6, constant(1, 9));


    if (slice(ans1_6_6, 3, 3).data == 1) {
        if (slice(ans_exp_6, 8, 8).data == 1) {
            assign(&result, constant(0, 32), -1, -1);
        }
        else {
            vd temp1 = {0, 16};
            vd temp2 = {0, 16};
            assign(&temp1, concat4(ans_sig_reg_6, slice(ans_exp_6, 7, 0), slice(ans1_6_6, 2, 0), ans2_6_6), -1, -1);
            assign(&temp2, concat4(ans3_6_6, ans4_6_6, ans5_6_6, ans6_6), -1, -1);
            assign(&result, concat2(temp1, temp2), -1, -1);
        }
    }
    else {
        if (slice(ans_exp_6_minus1, 8, 8).data == 1){
            assign(&result, constant(0, 32), -1, -1);
        }
        else{
            vd temp1 = {0, 15};
            vd temp2 = {0, 16};

            // cout << "ans_sig_reg_6 : " << ans_sig_reg_6.data << endl;
            // cout << slice(ans_exp_6_minus1, 7, 0).data << endl;
            // cout << "ans1_6_6 : " << slice(ans1_6_6, 1, 0).data << endl;
            // cout << "ans2_6_6 : " << ans2_6_6.data << endl;
            // cout << "ans3_6_6 : " << ans3_6_6.data << endl;
            // cout << "ans4_6_6 : " << ans4_6_6.data << endl;
            // cout << "ans5_6_6 : " << ans5_6_6.data << endl;
            // cout << "ans6_6_6 : " << ans6_6.data << endl;
            assign(&temp1, concat4(ans_sig_reg_6, slice(ans_exp_6_minus1, 7, 0), slice(ans1_6_6, 1, 0), ans2_6_6), -1, -1);
            assign(&temp2, concat4(ans3_6_6, ans4_6_6, ans5_6_6, ans6_6), -1, -1);
            // cout << temp1.data << endl;
            // cout << temp2.data << endl;
            assign(&result, concat3(temp1, temp2, constant(0, 1)), -1, -1);
            // cout << result.data << endl;
        }
    }
    return result;
}
#endif