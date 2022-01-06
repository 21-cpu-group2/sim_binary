#include <iostream>
#include <string>
#include <stdlib.h>
#include <iomanip>
#include "fadd.hpp"
#define DEBUG 1
#define DEBUG2 0
#define CHECK 0

bool check_instance(float op1, float op2, float res){
    double correct = (double)op1 + (double)op2;
    if (abs((double)res - correct) < 
        max(
            max(abs(op1)*pow(2, -23), abs(op2)*pow(2, -23)), 
            max(abs(correct)*pow(2, -23), eps)
        )){
        return true;
    }
    if (abs(correct) < FLOAT_MIN || abs(correct) >= FLOAT_MAX){
        return true;
    }
    return false;
}
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
            res1.i = fadd(op1, op2).data;
            res2.i = fadd(op1, op3).data;
            res3.i = fadd(op1, op4).data;
            res4.i = fadd(op1, op5).data;
            res5.i = fadd(op1, op6).data;
            res6.i = fadd(op1, op7).data;
            res7.i = fadd(op1, constant(0, 32)).data;
            res8.i = fadd(op1, min_f).data;
            res9.i = fadd(op1, max_f).data;
            res10.i = fadd(op1, min_minus_f).data;
            res11.i = fadd(op1, max_minus_f).data;
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
            res1.i = fadd(op2, op1).data;
            res2.i = fadd(op3, op1).data;
            res3.i = fadd(op4, op1).data;
            res4.i = fadd(op5, op1).data;
            res5.i = fadd(op6, op1).data;
            res6.i = fadd(op7, op1).data;
            res7.i = fadd(constant(0, 32), op1).data;
            res8.i = fadd(min_f, op1).data;
            res9.i = fadd(max_f, op1).data;
            res10.i = fadd(min_minus_f, op1).data;
            res11.i = fadd(max_minus_f, op1).data;
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
    ifstream in("../../fpu/fadd/sample_fadd.txt");
    cin.rdbuf(in.rdbuf());
    string op1, op2, res;
    union fi op1_ui, op2_ui, res_ui, result_ui;
    cout << dec;
    for (int i=0; i<14001; i++){
        cin >> op1 >> op2 >> res;
        // cout << op << " " << res << endl;
        op1_ui.i = stoul(op1, 0, 2);
        op2_ui.i = stoul(op2, 0, 2);
        res_ui.i = stoul(res, 0, 2);
        vd v1 = {op1_ui.i, 32};
        vd v2 = {op2_ui.i, 32};
        vd result = fadd(v1, v2);
        result_ui.i = result.data;
        if (result.data != res_ui.i){
            cout << "error in " << i+1 << "line" << endl;
            cout << "  op1" << endl;
            bit_print(op1_ui.i);
            cout << op1_ui.f << endl;
            cout << "  op2" << endl;
            bit_print(op2_ui.i);
            cout << op2_ui.f << endl;
            cout << "  result" << endl;
            bit_print(result_ui.i);
            cout << result_ui.f << endl;
            cout << "  correct output" << endl;
            bit_print(res_ui.i);
            cout << res_ui.f << endl << endl; 
        }
    }
    return 0;
}

int test_simulator_instance() {
    cout << dec;
    union fi op1_ui, op2_ui, res_ui, result_ui;
    op1_ui.i = 0b10000000001101000101010111000100;
    op2_ui.i = 0b00000000000000000000000000000000;
    // op1_ui.i = 0x7F3A1DC2;
    // op2_ui.i = 0x881DB280;
    vd v1 = {op1_ui.i, 32};
    vd v2 = {op2_ui.i, 32};
    vd result = fadd(v1, v2);
    result_ui.i = result.data;
    res_ui.i = 0b10000000010100010101011100010000;
    cout << endl;
    bit_print(op1_ui.i);
    bit_print(op2_ui.i);
    bit_print(result_ui.i);
    bit_print(res_ui.i);
    return 0;
}

int main(){
    if (CHECK){
        cout << "check_simulator" << endl;
        check();
        return 0;
    }
    if (DEBUG2){
        test_simulator_instance();
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
