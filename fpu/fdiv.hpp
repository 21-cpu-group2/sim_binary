#ifndef _FDIV
#define _FDIV
#include "fpu_items.hpp"
using namespace std;

vd fdiv(vd op1, vd op2) {
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

    vd fra2_2 = {0, 25};
    vd fra2_3 = {0, 25};
    vd fra2_4 = {0, 25};
    vd fra2_5 = {0, 25};
    vd fra2_6 = {0, 25};
    
    vd ans_sig_reg_2 = {0,1};
    vd ans_sig_reg_3 = {0,1};
    vd ans_sig_reg_4 = {0,1};
    vd ans_sig_reg_5 = {0,1};
    vd ans_sig_reg_6 = {0,1};

    vd ans1_6 = {0, 4};
    vd ans2_6 = {0, 4};
    vd ans3_6 = {0, 4};
    vd ans4_6 = {0, 4};
    vd ans5_6 = {0, 4};
    vd ans6_6 = {0, 4};

    vd ans1_6_2 = {0, 4};
    vd ans1_6_3 = {0, 4};
    vd ans1_6_4 = {0, 4};
    vd ans1_6_5 = {0, 4};
    vd ans1_6_6 = {0, 4};
    vd x4_reg = {0, 25};

    vd ans2_6_3 = {0, 4};
    vd ans2_6_4 = {0, 4};
    vd ans2_6_5 = {0, 4};
    vd ans2_6_6 = {0, 4};
    vd x8_reg = {0, 25};

    vd ans3_6_4 = {0, 4};
    vd ans3_6_5 = {0, 4};
    vd ans3_6_6 = {0, 4};
    vd x12_reg = {0, 25};

    vd ans4_6_5 = {0, 4};
    vd ans4_6_6 = {0, 4};
    vd x16_reg = {0, 25};

    vd ans5_6_6 = {0, 4};
    vd x20_reg = {0, 25};

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
    /*


    vd [24:0] sub5 = x4_reg - fra2_2;
    vd [24:0] x5 = (sub5[24] == 1'b1) ? (x4_reg << 1) : (sub5 << 1);
    assign ans2_6[3] = (sub5[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub6 = x5 - fra2_2;
    vd [24:0] x6 = (sub6[24] == 1'b1) ? (x5 << 1) : (sub6 << 1);
    assign ans2_6[2] = (sub6[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub7 = x6 - fra2_2;
    vd [24:0] x7 = (sub7[24] == 1'b1) ? (x6 << 1) : (sub7 << 1);
    assign ans2_6[1] = (sub7[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub8 = x7 - fra2_2;
    vd [24:0] x8 = (sub8[24] == 1'b1) ? (x7 << 1) : (sub8 << 1);
    assign ans2_6[0] = (sub8[24] == 1'b1) ? 1'b0 : 1'b1;


    vd [24:0] sub9 = x8_reg - fra2_3;
    vd [24:0] x9 = (sub9[24] == 1'b1) ? (x8_reg << 1) : (sub9 << 1);
    assign ans3_6[3] = (sub9[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub10 = x9 - fra2_3;
    vd [24:0] x10 = (sub10[24] == 1'b1) ? (x9 << 1) : (sub10 << 1);
    assign ans3_6[2] = (sub10[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub11 = x10 - fra2_3;
    vd [24:0] x11 = (sub11[24] == 1'b1) ? (x10 << 1) : (sub11 << 1);
    assign ans3_6[1] = (sub11[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub12 = x11 - fra2_3;
    vd [24:0] x12 = (sub12[24] == 1'b1) ? (x11 << 1) : (sub12 << 1);
    assign ans3_6[0] = (sub12[24] == 1'b1) ? 1'b0 : 1'b1;


    vd [24:0] sub13 = x12_reg - fra2_4;
    vd [24:0] x13 = (sub13[24] == 1'b1) ? (x12_reg << 1) : (sub13 << 1);
    assign ans4_6[3] = (sub13[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub14 = x13 - fra2_4;
    vd [24:0] x14 = (sub14[24] == 1'b1) ? (x13 << 1) : (sub14 << 1);
    assign ans4_6[2] = (sub14[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub15 = x14 - fra2_4;
    vd [24:0] x15 = (sub15[24] == 1'b1) ? (x14 << 1) : (sub15 << 1);
    assign ans4_6[1] = (sub15[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub16 = x15 - fra2_4;
    vd [24:0] x16 = (sub16[24] == 1'b1) ? (x15 << 1) : (sub16 << 1);
    assign ans4_6[0] = (sub16[24] == 1'b1) ? 1'b0 : 1'b1;


    vd [24:0] sub17 = x16_reg - fra2_5;
    vd [24:0] x17 = (sub17[24] == 1'b1) ? (x16_reg << 1) : (sub17 << 1);
    assign ans5_6[3] = (sub17[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub18 = x17 - fra2_5;
    vd [24:0] x18 = (sub18[24] == 1'b1) ? (x17 << 1) : (sub18 << 1);
    assign ans5_6[2] = (sub18[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub19 = x18 - fra2_5;
    vd [24:0] x19 = (sub19[24] == 1'b1) ? (x18 << 1) : (sub19 << 1);
    assign ans5_6[1] = (sub19[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub20 = x19 - fra2_5;
    vd [24:0] x20 = (sub20[24] == 1'b1) ? (x19 << 1) : (sub20 << 1);
    assign ans5_6[0] = (sub20[24] == 1'b1) ? 1'b0 : 1'b1;


    vd [24:0] sub21 = x20_reg - fra2_6;
    vd [24:0] x21 = (sub21[24] == 1'b1) ? (x20_reg << 1) : (sub21 << 1);
    assign ans6_6[3] = (sub21[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub22 = x21 - fra2_6;
    vd [24:0] x22 = (sub22[24] == 1'b1) ? (x21 << 1) : (sub22 << 1);
    assign ans6_6[2] = (sub22[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub23 = x22 - fra2_6;
    vd [24:0] x23 = (sub23[24] == 1'b1) ? (x22 << 1) : (sub23 << 1);
    assign ans6_6[1] = (sub23[24] == 1'b1) ? 1'b0 : 1'b1;
    vd [24:0] sub24 = x23 - fra2_6;
    // vd [24:0] x24 = (sub24[24] == 1'b1) ? (x23 << 1) : (sub24 << 1);
    assign ans6_6[0] = (sub24[24] == 1'b1) ? 1'b0 : 1'b1;

    // vd [24:0] sub_p = x_p-1 - fra2;
    // vd [24:0] x_p = (sub_p[24] == 1'b1) ? (x_p-1 << 1) : (sub_p << 1);
    // assign ans_high[12-p] = (sub3[24] == 1'b1) ? 1'b0 : 1'b1;

    reg [8:0] ans_exp_2;
    reg [8:0] ans_exp_3;
    reg [8:0] ans_exp_4;
    reg [8:0] ans_exp_5;
    reg [8:0] ans_exp_6;

    vd [8:0] for_ans_exp;
    assign for_ans_exp = exp1 + 9'd127;
    vd [8:0] ans_exp;
    assign ans_exp = for_ans_exp - exp2;

    vd [8:0] ans_exp_6_minus1;
    assign ans_exp_6_minus1 = ans_exp_6 - 9'd1;
    */
    return result;
}

#endif