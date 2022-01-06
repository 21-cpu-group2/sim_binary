#include "fpu_items.hpp"

inline bool check_instance(float op1, float op2, float res){
    double correct = (double)op1 * (double)op2;
    if (abs((double)res - correct) < 
        max(
            abs(correct)*pow(2, -22), 
            eps
        )){
        return true;
    }
    union fi temp;
    temp.f = res;
    if (abs(correct) < FLOAT_MIN || abs(correct) >= FLOAT_MAX){
        return true;
    }
    return false;
}