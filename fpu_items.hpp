#include <iostream>
#include <string>

typedef struct {
    uint32_t sgn : 1;
    uint32_t exp : 8;
    uint32_t fra : 23;
} my_float;