#ifndef _TIME_PRED
#define _TIME_PRED

const double freq = 80000000.0;
const double baudrate = 115200.0;

const uint32_t in_start = 200000;
const uint32_t out_start = 300000;
/*
fabs, fhalf, fisneg, fispos, fiszero, fless, fneg, 
*/
#define fadd_clk 3ll
#define fsub_clk 3ll
#define fdiv_clk 12ll
#define floor_clk 2ll
#define fmul_clk 3ll
#define fsqrt_clk 3ll
#define ftoi_clk 2ll
#define itof_clk 3ll
#define jalr_clk 3ll
#define beq_clk 4ll
#define bne_clk 4ll
#define blt_clk 4ll
#define bge_clk 4ll
#define sw_hit_clk 14ll
#define sw_miss_clk 60ll
#define lw_hit_clk 8ll
#define lw_miss_clk 60ll

#endif