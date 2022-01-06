#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fpu_items.hpp"
#include "fmul.hpp"
#include "test_fmul.hpp"
#define DEBUG 1
#define CHECK 1
#define CHECK_INSTANCE 0

int check(){
    bool flg = true;
    random_device rd;
    default_random_engine eng(rd());
    uniform_real_distribution<float> distr1(FLOAT_MIN, FLOAT_MAX);
    uniform_real_distribution<float> distr2(-FLOAT_MAX, -FLOAT_MIN);
    for (uint32_t ite=0; ite<0xFFFFFFFF; ite++){
        if (isNumber(ite)){
            union fi op1_fi, op2_fi, op3_fi, op4_fi, op5_fi, op6_fi, op7_fi;
            union fi min_fi, max_fi, min_fi_minus, max_fi_minus;

            op1_fi.i = ite;
            op2_fi.f = distr1(eng);
            op3_fi.f = distr1(eng);
            op4_fi.f = distr1(eng);
            op5_fi.f = distr2(eng);
            op6_fi.f = distr2(eng);
            op7_fi.f = distr2(eng);
            min_fi.f = FLOAT_MIN;
            max_fi.f = FLOAT_MAX; max_fi.i -= 1;
            min_fi_minus.f = -FLOAT_MIN;
            max_fi_minus.f = -FLOAT_MAX; max_fi_minus.i += 1;

            vd op1 = {op1_fi.i, 32};
            vd op2 = {op2_fi.i, 32};
            vd op3 = {op3_fi.i, 32};
            vd op4 = {op4_fi.i, 32};
            vd op5 = {op5_fi.i, 32};
            vd op6 = {op6_fi.i, 32};
            vd op7 = {op7_fi.i, 32};
            vd zero = {0, 32};
            vd min_f = {min_fi.i, 32}; 
            vd max_f = {max_fi.i, 32}; 
            vd min_minus_f = {min_fi_minus.i, 32};
            vd max_minus_f = {max_fi_minus.i, 32};

            union fi res1, res2, res3, res4, res5, res6, res7, res8, res9, res10, res11;
            res1.i = fmul(op1, op2).data;
            res2.i = fmul(op1, op3).data;
            res3.i = fmul(op1, op4).data;
            res4.i = fmul(op1, op5).data;
            res5.i = fmul(op1, op6).data;
            res6.i = fmul(op1, op7).data;
            res7.i = fmul(op1, constant(0, 32)).data;
            res8.i = fmul(op1, min_f).data;
            res9.i = fmul(op1, max_f).data;
            res10.i = fmul(op1, min_minus_f).data;
            res11.i = fmul(op1, max_minus_f).data;
            if (!check_instance(op1_fi.f, op2_fi.f, res1.f) ||
                !check_instance(op1_fi.f, op3_fi.f, res2.f) ||
                !check_instance(op1_fi.f, op4_fi.f, res3.f) ||
                !check_instance(op1_fi.f, op5_fi.f, res4.f) ||
                !check_instance(op1_fi.f, op6_fi.f, res5.f) ||
                !check_instance(op1_fi.f, op7_fi.f, res6.f) ||
                !check_instance(op1_fi.f, 0.0, res7.f) ||
                !check_instance(op1_fi.f, min_fi.f, res8.f) ||
                !check_instance(op1_fi.f, max_fi.f, res9.f) ||
                !check_instance(op1_fi.f, min_fi_minus.f, res10.f) ||
                !check_instance(op1_fi.f, max_fi_minus.f, res11.f)
                ){
                cout << "error1" << endl;
                bit_print(op1_fi.i);
                bit_print(op2_fi.i);
                bit_print(op3_fi.i);
                bit_print(op4_fi.i);
                bit_print(op5_fi.i);
                bit_print(op6_fi.i);
                bit_print(op7_fi.i);
                bit_print(min_fi.i);
                bit_print(max_fi.i);
                bit_print(min_fi_minus.i);
                bit_print(max_fi_minus.i);
                return 1;
            }
            res1.i = fmul(op2, op1).data;
            res2.i = fmul(op3, op1).data;
            res3.i = fmul(op4, op1).data;
            res4.i = fmul(op5, op1).data;
            res5.i = fmul(op6, op1).data;
            res6.i = fmul(op7, op1).data;
            res7.i = fmul(constant(0, 32), op1).data;
            res8.i = fmul(min_f, op1).data;
            res9.i = fmul(max_f, op1).data;
            res10.i = fmul(min_minus_f, op1).data;
            res11.i = fmul(max_minus_f, op1).data;
            if (!check_instance(op2_fi.f, op1_fi.f, res1.f) ||
                !check_instance(op3_fi.f, op1_fi.f, res2.f) ||
                !check_instance(op4_fi.f, op1_fi.f, res3.f) ||
                !check_instance(op5_fi.f, op1_fi.f, res4.f) ||
                !check_instance(op6_fi.f, op1_fi.f, res5.f) ||
                !check_instance(op7_fi.f, op1_fi.f, res6.f) ||
                !check_instance(0.0, op1_fi.f, res7.f) ||
                !check_instance(min_fi.f, op1_fi.f, res8.f) ||
                !check_instance(max_fi.f, op1_fi.f, res9.f) ||
                !check_instance(min_fi_minus.f, op1_fi.f, res10.f) ||
                !check_instance(max_fi_minus.f, op1_fi.f, res11.f)
                ){
                cout << "error2" << endl;
                bit_print(op1_fi.i);
                bit_print(op2_fi.i);
                bit_print(op3_fi.i);
                bit_print(op4_fi.i);
                bit_print(op5_fi.i);
                bit_print(op6_fi.i);
                bit_print(op7_fi.i);
                bit_print(min_fi.i);
                bit_print(max_fi.i);
                bit_print(min_fi_minus.i);
                bit_print(max_fi_minus.i);
                return 1;
            }
        }
        if ((ite & 0x07FFFFFF) == 0){
            cout << 3 << "%" << endl;
        }
    }
    return 1;
}
int test_simulator(){
    ifstream in("../../fpu/fmul/sample_fmul.txt");
    cin.rdbuf(in.rdbuf());
    string op1, op2, res;
    union fi op1_ui, op2_ui, res_ui, result_ui;
    cout << dec;
    for (int i=0; i<1001; i++){
        cin >> op1 >> op2 >> res;
        // cout << op << " " << res << endl;
        op1_ui.i = stoul(op1, 0, 2);
        op2_ui.i = stoul(op2, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v1 = {op1_ui.i, 32};
        vd v2 = {op2_ui.i, 32};
        vd result = fmul(v1, v2);
        result_ui.i = result.data;
        if (result.data != res_ui.i){
            cout << "error in " << i+1 << "line" << endl;
            cout << "op1" << endl;
            bit_print(op1_ui.i);
            cout << op1_ui.f << endl;
            cout << "op1" << endl;
            bit_print(op2_ui.i);
            cout << op2_ui.f << endl;
            cout << "result" << endl;
            bit_print(result_ui.i);
            cout << result_ui.f << endl;
            cout << "correct output" << endl;
            bit_print(res_ui.i);
            cout << res_ui.f << endl << endl; 
        }
    }
    return 0;
}
int test_instance(){
    union fi op1_fi, op2_fi, op3_fi, op4_fi, op5_fi, op6_fi, op7_fi, op8_fi, op9_fi, op10_fi, op11_fi, fmax, fmin;
    union fi result2_fi, result3_fi, result4_fi, result5_fi, result6_fi, result7_fi, result8_fi, result9_fi, result10_fi, result11_fi;
    fmax.f = FLOAT_MAX; fmax.i -= 1;
    fmin.f = FLOAT_MIN;
    op1_fi.i = 0b00111111100000000000000000000000;
    op2_fi.i = 0b01111110110010101011000110011010;
    op3_fi.i = 0b01111110101001101010000010101111;
    op4_fi.i = 0b01111101001000110001010110011101;
    op5_fi.i = 0b11111101100000111010000100001100;
    op6_fi.i = 0b11111110111100101011000011001100;
    op7_fi.i = 0b11111110010011011001110010001100;
    op8_fi.i = 0b00000000100000000000000000000000;
    op9_fi.i = 0b01111110111111111111111111111111;
    op10_fi.i = 0b10000000100000000000000000000000;
    op11_fi.i = 0b11111111000000000000000000000001;
    vd op1 = {op1_fi.i, 32};
    vd op2 = {op2_fi.i, 32};
    vd op3 = {op3_fi.i, 32};
    vd op4 = {op4_fi.i, 32};
    vd op5 = {op5_fi.i, 32};
    vd op6 = {op6_fi.i, 32};
    vd op7 = {op7_fi.i, 32};
    vd op8 = {op8_fi.i, 32};
    vd op9 = {op9_fi.i, 32};
    vd op10 = {op10_fi.i, 32};
    vd op11 = {op11_fi.i, 32};
    vd result2 = fmul(op1, op2);
    vd result3 = fmul(op1, op3);
    vd result4 = fmul(op1, op4);
    vd result5 = fmul(op1, op5);
    vd result6 = fmul(op1, op6);
    vd result7 = fmul(op1, op7);
    vd result8 = fmul(op1, op8);
    vd result9 = fmul(op1, op9);
    vd result10 = fmul(op1, op10);
    vd result11 = fmul(op1, op11);
    result2_fi.i = result2.data;
    result3_fi.i = result3.data;
    result4_fi.i = result4.data;
    result5_fi.i = result5.data;
    result6_fi.i = result6.data;
    result7_fi.i = result7.data;
    result8_fi.i = result8.data;
    result9_fi.i = result9.data;
    result10_fi.i = result10.data;
    result11_fi.i = result11.data;
    cout << (check_instance(op1_fi.f, op2_fi.f, result2_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op3_fi.f, result3_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op4_fi.f, result4_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op5_fi.f, result5_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op6_fi.f, result6_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op7_fi.f, result7_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op8_fi.f, result8_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op9_fi.f, result9_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op10_fi.f, result10_fi.f)) << endl;
    cout << (check_instance(op1_fi.f, op11_fi.f, result11_fi.f)) << endl;
    return 0;
// 00111111100000000000000000000000
// 01111110110010101011000110011010
// 01111110101001101010000010101111
// 01111101001000110001010110011101
// 11111101100000111010000100001100
// 11111110111100101011000011001100
// 11111110010011011001110010001100
// 00000000100000000000000000000000
// 01111110111111111111111111111111
// 10000000100000000000000000000000
// 11111111000000000000000000000001
}

int main(){

    if (CHECK_INSTANCE){
        cout << "test instance" << endl;
        test_instance();
        return 0;
    }
    if (CHECK){
        cout << "check_simulator" << endl;
        check();
        return 0;
    }
    cout << hex ;
    if (DEBUG) {
        cout << "testing_simulator" << endl;
        test_simulator();
        return 0;
    }
    return 0;
}