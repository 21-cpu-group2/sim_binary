l.1:	# PI
    1078530011
l.2:	# 2.0
    1073741824
l.3:	# S3
	3190467244
l.4:	# S5
	1007191654
l.5:	# S7
	3108857014
l.6:	# 1.0
	1065353216
l.7:	# C4
	1026205577
l.8:	# C6
	3132326150
l.9:	# A3
	3198855850
l.10:	# A5
	1045220557
l.11:	# A7
	3188869413
l.12:	# A9
	1038323256
l.13:	# A11
	3182941806
l.14:	# A13
	1031137221
l.15:   # 0.4375
    1054867456
l.16:   # 2.4375
    1075576832

min_caml_sll:   #
    slli %a0 %a0 2
    jalr %zero %ra 0

min_caml_srl:
    srli %a0 %a0 1
    jalr %zero %ra 0

min_caml_create_array:
    add %a2 %a0 %zero #%a0???array length %a1???????????¤ã????¥ã?£ã????????
    add %a0 %min_caml_hp %zero # è¿??????¤ã??array?????¢ã???????¹ã????»ã?????
create_array_loop:
    beq %a2 %zero create_array_exit # array length???0?????£ã?????çµ?äº?
    sw %a1 %min_caml_hp 0                 # %a1?????¡ã?¢ã???????¼ç??
    addi %min_caml_hp %min_caml_hp 4       # hp???å¢???????
    addi %a2 %a2 -1                      # array length???1æ¸???????
    beq %zero %zero create_array_loop    # create_array_loop?????¸ã?£ã?³ã??
create_array_exit:
    jalr %zero %ra 0 # è¿??????¤ã???????¢ã??array?????¢ã???????¹ã????¥ã?£ã?????????????§ã??????????????çµ?äº?

min_caml_create_float_array: # min_caml_create_array???????????????????????¤ã??%f0?????¥ã?£ã????????????????????
    add %a2 %a0 %zero #%a0???array length %f0???????????¤ã????¥ã?£ã????????
    add %a0 %min_caml_hp %zero # è¿??????¤ã??array?????¢ã???????¹ã????»ã?????
create_float_array_loop:
    beq %a2 %zero create_float_array_exit
    sw %f0 %min_caml_hp 0                 # %f0?????¡ã?¢ã???????¼ç??
    addi %min_caml_hp %min_caml_hp 4       # hp???å¢???????
    addi %a2 %a2 -1
    beq %zero %zero create_float_array_loop
create_float_array_exit:
    jalr %zero %ra 0

min_caml_fhalf:
    fhalf %f0 %f0
    jalr %zero %ra 0

min_caml_fsqr:
    fmul %f0 %f0 %f0
    jalr %zero %ra 0

min_caml_sqrt:
    sqrt %f0 %f0
    jalr %zero %ra 0

min_caml_fabs:
    fabs %f0 %f0
    jalr %zero %ra 0

min_caml_fneg:
    fneg %f0 %f0
    jalr %zero %ra 0

min_caml_fless:
    fless %a0 %f0 %f1
    jalr %zero %ra 0

min_caml_fiszero:
    fiszero %a0 %f0
    jalr %zero %ra 0

min_caml_fispos:
    fispos %a0 %f0
    jalr %zero %ra 0

min_caml_fisneg:
    fisneg %a0 %f0
    jalr %zero %ra 0

min_caml_floor:
    floor %f0 %f0
    jalr %zero %ra 0

min_caml_int_of_float:
    ftoi %a0 %f0
    jalr %zero %ra 0

min_caml_float_of_int:
    itof %f0 %a0
    jalr %zero %ra 0

reduction_2pi:
    li %f1 l.1 # PI?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f2 l.2 # 2.0?????»ã?????
    fmul %f3 %f1 %f2 # P = PI * 2.0
reduction_continue:
    fless %a0 %f0 %f3   # if A < P
    blt %zero %a0 reduction_break # if A < P then jump reduction_break
    fmul %f3 %f3 %f2  # P = P * 2.0
    beq %zero %zero reduction_continue
reduction_break:
    fmul %f1 %f1 %f2 # PI * 2.0
    fless %a0 %f0 %f1  # if A < PI * 2
    blt %zero %a0 reduction_break2 # if A < PI * 2 then jump reduction_break2
    fless %a0 %f0 %f3  # if A < P
    blt %zero %a0 reduction_break3 # if A < P then  jump reduction_break3
    fsub %f0 %f0 %f3  # A = A - P
reduction_break3:
    fhalf %f3 %f3     # P = P / 2
    beq %zero %zero reduction_break
reduction_break2:
    jalr %zero %ra 0  # A???f0?????¥ã?£ã?????????????§ã???????¾ã?¾ç??äº?

kernel_sin:
    li %f1 l.3 # S3?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f4 l.4 # S5?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f6 l.5 # S7?????¤ã????»ã????? PC?????¤ã????»ã?????
    fmul %f2 %f0 %f0 # A^2
    fmul %f3 %f3 %f0 # A^3
    fmul %f1 %f1 %f3 # S3*A^3
    fmul %f5 %f2 %f3 # A^5
    fmul %f4 %f4 %f5 # S5 * A^5
    fmul %f7 %f2 %f5 # A^7
    fmul %f6 %f6 %f7 # S7 * A^7
    fsub %f0 %f0 %f1 # A - S3*S7
    fadd %f0 %f0 %f4 # A - S3*S7 + S5*A^5
    fsub %f0 %f0 %f6 # A - S3*S7 + S5*A^5 - S7 * A^7
    jalr %zero %ra 0  # çµ?äº?

kernel_cos:
    li %f1 l.6 # C1 (1.0) ?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f4 l.7 # C4 (1.0) ?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f6 l.8 # C6 (1.0) ?????¤ã????»ã????? PC?????¤ã????»ã?????
    fmul %f2 %f0 %f0 # A^2
    fmul %f3 %f2 %f2 # A^4
    fmul %f5 %f2 %f3 # A^6
    fhalf %f2 %f2 # 0.5*A^2
    fmul %f4 %f4 %f3 # C4 * A^4
    fmul %f6 %f6 %f5 # C6 * A^6
    fsub %f0 %f1 %f2 # 1.0 - 0.5*A^2
    fadd %f0 %f0 %f4 # 1.0 - 0.5*A^2 + C4*A^4
    fsub %f0 %f0 %f6 # 1.0 - 0.5*A^2 + C4*A^4 - C6*A^6
    jalr %zero %ra 0  # çµ?äº?

reverse:
    beq %a0 %zero a_beq_zero # if %a0 == 0 jump to a_beq_zero
    add %a0 %zero %zero # return 0
    jalr %zero %ra 0  # çµ?äº?
a_beq_zero:
    addi %a0 %zero 1 # return 1
    jalr %zero %ra 0  # çµ?äº?

min_caml_sin:
    fispos %a1 %f0 # %a1 = flag(%f0), %a0???reduction_2pi??§ä½¿????????§ã???????§ã??%a1???ä½¿ã??
    fabs %f0 %f0 # A = abs(A)
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reduction_2pi # %f0 = reduction_2pi(%f0)
    addi %sp %sp -8 # return from reduction_2pi
    lw %ra %sp 4
    li %f1 l.1 # PI ?????¤ã????»ã????? PC?????¤ã????»ã?????
    fless %a0 %f0 %f1 # if A < PI
    blt %zero %a0 a_less_than_pi # if 0 < %a0 jump to a_less_than_pi
    fsub %f0 %f0 %f1 # A = A - PI
    addi %a0 %a1 0  # %a0 = %a1
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reverse # %a0 = reverse %a0
    addi %sp %sp -8 # return from reverse
    lw %ra %sp 4
    addi %a1 %a0 0 # %a1 = %a0
a_less_than_pi:
    fhalf %f2 %f1 # PI/2
    fless %a0 %f0 %f2 # if A < PI/2
    blt %zero %a0 a_less_than_pi_2 # 0 < %a0 jump to a_less_than_pi_2
    fsub %f0 %f1 %f0 # A = PI - A
a_less_than_pi_2:
    fhalf %f3 %f2 # PI/4
    fless %a0 %f3 %f0 # if A > PI/4
    blt %zero %a0 pi_4_less_than_a # 0 < %a0 jump to pi_4_less_than_a
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra kernel_sin # %f0 = kernel_sin %f0
    addi %sp %sp -8 # return from reverse
    lw %ra %sp 4
    blt %zero %a1 fsin_end # if 0 < FLAG jump to fsin_end
    fneg %f0 %f0 # A = - A
    jalr %zero %ra 0  # çµ?äº?
pi_4_less_than_a:
    fsub %f0 %f2 %f0    # A = PI/2 - A
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra kernel_cos
    addi %sp %sp -8 # return from reverse
    lw %ra %sp 4
    blt %zero %a1 fsin_end # if 0 < FLAG jump to fsin_end
    fneg %f0 %f0 # A = - A
fsin_end:
    jalr %zero %ra 0  # çµ?äº?

min_caml_cos:
    addi %a1 %zero 1 # FLAG = 1
    fabs %f0 %f0 # A = |A|
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reduction_2pi # A = reduction_2pi(A)
    addi %sp %sp -8 # return from reduction_2pi
    lw %ra %sp 4
    li %f1 l.1 # PI ?????¤ã????»ã????? PC?????¤ã????»ã?????
    fless %a0 %f0 %f1 # if A < PI
    blt %zero %a0 a_less_than_pi_cos
    fsub %f0 %f0 %f1 # A = A - PI
    addi %a0 %a1 0  # %a0 = %a1
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reverse # %a0 = reverse(%a0)
    addi %sp %sp -8 # return from reverse
    lw %ra %sp 4
    addi %a1 %a0 0
a_less_than_pi_cos:
    fhalf %f2 %f1 # PI/2
    fless %a0 %f0 %f2 # if A < PI/2
    blt %zero %a0 a_less_than_pi_2_cos # if 0 < %a0 then jump to a_less_than_pi_2_cos
    fsub %f0 %f1 %f0 # A = PI - A
    addi %a0 %a1 0  # call reverse
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reverse # %a0 = reverse(%a0)
    addi %sp %sp -8 # return from reverse
    lw %ra %sp 4
    addi %a1 %a0 0 # %a1 = %a0
a_less_than_pi_2_cos:
    fhalf %f3 %f2 # PI/4
    fless %a0 %f3 %f0 # if A > PI/4
    blt %zero %a0 pi_4_less_than_a_cos # 0 < %a0 then jump to pi_4_less_than_a_cos
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra kernel_cos
    addi %sp %sp -8 # return from kernel_cos
    lw %ra %sp 4
    blt %zero %a1 fcos_end # if 0 < FLAG jump to fcos_end
    fneg %f0 %f0 # A = - A
    jalr %zero %ra 0  # çµ?äº?
pi_4_less_than_a_cos:
    fsub %f0 %f2 %f0    # A = PI/2 - A
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra kernel_sin
    addi %sp %sp -8 # return from kernel_sin
    lw %ra %sp 4
    blt %zero %a1 fcos_end # if FLAG = 1
    fneg %f0 %f0 # A = - A
fcos_end:
    jalr %zero %ra 0  # çµ?äº?

kernel_atan:
    li %f1 l.9 # A3?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f2 l.10 # A5?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f3 l.11 # A7?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f4 l.12 # A9?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f5 l.13 # A11?????¤ã????»ã????? PC?????¤ã????»ã?????
    li %f6 l.14 # A13?????¤ã????»ã????? PC?????¤ã????»ã?????
    fmul %f7 %f0 %f0 # A^2
    fmul %f8 %f0 %f7 # A^3
    fmul %f9 %f7 %f8 # A^5
    fmul %f10 %f7 %f9 # A^7
    fmul %f11 %f7 %f10 # A^9
    fmul %f1 %f1 %f8 # A3 * A^3
    fmul %f2 %f2 %f9 # A5 * A^5
    fmul %f3 %f3 %f10 # A7 * A^7
    fmul %f4 %f4 %f11 # A9 * A^9
    fmul %f8 %f7 %f11 # A^11
    fmul %f9 %f7 %f8 # A^13
    fmul %f5 %f5 %f8 # A11 * A^11
    fmul %f6 %f6 %f9 # A13 * A^13
    fsub %f0 %f0 %f1 # A - A3*A^3
    fadd %f0 %f0 %f2 # A - A3*A^3 + A5*A^5
    fsub %f0 %f0 %f3 # A - A3*A^3 + A5*A^5 - A7*A^7
    fadd %f0 %f0 %f4 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9
    fsub %f0 %f0 %f5 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9 - A11*A^11
    fadd %f0 %f0 %f6 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9 - A11*A^11 + A13*A^13
    jalr %zero %ra 0  # çµ?äº?

min_caml_atan:
    fabs %f1 %f0 # |A|
    li %f2 l.15 # 0.4375 PC?????¤ã????»ã?????
    li %f3 l.16 # 2.4375 PC?????¤ã????»ã?????
    li %f4 l.6 # 1.0 PC?????¤ã????»ã?????
    fless %a0 %f1 %f2 # |A| < 0.4375
    blt %zero %a0 atan_break1 # if 0 < %a0
    fless %a0 %f1 %f3 # |A| < 2.4375
    blt %zero %a0 atan_break2 # if 0 < %a0
    fdiv %f0 %f4 %f1 # 1/|A|
    sw %ra %sp 4 # call kernel_atan
    addi %sp %sp 8
    jal %ra kernel_atan # kernel_atan(1/|A|)
    addi %sp %sp -8 # return from kernel_atan
    lw %ra %sp 4
    li %f5 l.1 # PI PC?????¤ã????»ã?????
    fhalf %f5 %f5 # PI/2
    fsub %f0 %f5 %f0 # PI/2 - kernel_atan(1/|A|)
    jalr %zero %ra 0  # çµ?äº?
atan_break1:
    sw %ra %sp 4 # call kernel_atan
    addi %sp %sp 8
    jal %ra kernel_atan # kernel_atan(A)
    addi %sp %sp -8 # return from kernel_atan
    lw %ra %sp 4
    jalr %zero %ra 0  # çµ?äº?
atan_break2:
    fsub %f5 %f1 %f4 # |A| - 1.0
    fadd %f6 %f1 %f4 # |A| + 1.0
    fdiv %f0 %f5 %f6 # (|A| - 1.0)/(|A| + 1.0)
    sw %ra %sp 4 # call kernel_atan
    addi %sp %sp 8
    jal %ra kernel_atan # kernel_atan (|A| - 1.0)/(|A| + 1.0)
    addi %sp %sp -8 # return from kernel_atan
    lw %ra %sp 4
    li %f5 l.1 # PI PC?????¤ã????»ã?????
    fhalf %f5 %f5 # PI/2
    fhalf %f5 %f5 # PI/4
    fadd %f0 %f5 %f0 # PI/4 kernel_atan((|A| - 1.0)/(|A| + 1.0))
    jalr %zero %ra 0  # çµ?äº?

min_caml_read_int:
    lw %a0 %in 0
    addi %in %in 4
    jalr %zero %ra 0  # çµ?äº?

min_caml_read_float:
    lw %f0 %in 0
    addi %in %in 4
    jalr %zero %ra 0  # çµ?äº?

min_caml_print_int:
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # çµ?äº?

min_caml_print_char:
    addi %a1 %zero 80 # P
    beq %a0 %a1 break_print_char
    addi %a2 %zero 51 # 3
    beq %a0 %a2 break_print_charP3
    addi %a3 %zero 32 # ç©ºç?½æ??å­?
    slli %a3 %a3 8 # ç©ºç?½æ??å­????1byte?????????
    add %a0 %a0 %a3 # 00 00 32 %a0
    slli %a3 %a3 8 # ?????????1byte?????????
    add %a0 %a0 %a3 # 00 32 32 %a0
    slli %a3 %a3 8 # ?????????1byte?????????
    add %a0 %a0 %a3 # 32 32 32 %a0
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # çµ?äº?
break_print_char:
    jalr %zero %ra 0  # çµ?äº?
break_print_charP3:
    slli %a2 %a2 8 # 51???1byte?????????
    add %a0 %a1 %a2 # 00 00 51 80
    addi %a3 %zero 32 # ç©ºç?½æ??å­?
    slli %a3 %a3 16 # ç©ºç?½æ??å­????2byte?????????
    add %a0 %a0 %a3 # 00 32 51 80
    slli %a3 %a3 8 # ?????????1byte?????????
    add %a0 %a0 %a3 # 32 32 51 80
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # çµ?äº?


l.6291:	# 128.000000
	1124073472
l.6242:	# 0.900000
	1063675494
l.6240:	# 0.200000
	1045220557
l.6134:	# 150.000000
	1125515264
l.6131:	# -150.000000
	-1021968384
l.6112:	# 0.100000
	1036831949
l.6108:	# -2.000000
	-1073741824
l.6105:	# 256.000000
	1132462080
l.6072:	# 20.000000
	1101004800
l.6070:	# 0.050000
	1028443341
l.6062:	# 0.250000
	1048576000
l.6053:	# 10.000000
	1092616192
l.6048:	# 0.300000
	1050253722
l.6046:	# 255.000000
	1132396544
l.6042:	# 0.500000
	1056964608
l.6040:	# 0.150000
	1041865114
l.6033:	# 3.141593
	1078530011
l.6031:	# 30.000000
	1106247680
l.6029:	# 15.000000
	1097859072
l.6027:	# 0.000100
	953267991
l.5978:	# 100000000.000000
	1287568416
l.5972:	# 1000000000.000000
	1315859240
l.5949:	# -0.100000
	-1110651699
l.5935:	# 0.010000
	1008981770
l.5933:	# -0.200000
	-1102263091
l.5715:	# 2.000000
	1073741824
l.5678:	# -200.000000
	-1018691584
l.5675:	# 200.000000
	1128792064
l.5670:	# 0.017453
	1016003125
l.5557:	# -1.000000
	-1082130432
l.5555:	# 1.000000
	1065353216
l.5553:	# 0.000000
	0
xor.2233:
	addi %a2 %zero 0 #101
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8449
	addi %a0 %a1 0 #101
	jalr %zero %ra 0 #101
beq_else.8449:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8450
	addi %a0 %zero 1 #101
	jalr %zero %ra 0 #101
beq_else.8450:
	addi %a0 %a2 0 #101
	jalr %zero %ra 0 #101
sgn.2236:
	sw %f0 %sp 0 #107
	sw %ra %sp 12 #107 call dir
	addi %sp %sp 16 #107	
	jal %ra min_caml_fiszero #107
	addi %sp %sp -16 #107
	lw %ra %sp 12 #107
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8451
	lw %f0 %sp 0 #108
	sw %ra %sp 12 #108 call dir
	addi %sp %sp 16 #108	
	jal %ra min_caml_fispos #108
	addi %sp %sp -16 #108
	lw %ra %sp 12 #108
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8452
	li %a0 l.5557 #109
	jalr %zero %ra 0 #109
beq_else.8452:
	li %a0 l.5555 #108
	jalr %zero %ra 0 #108
beq_else.8451:
	li %a0 l.5553 #107
	jalr %zero %ra 0 #107
fneg_cond.2238:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8453
	jal	%zero min_caml_fneg
beq_else.8453:
	jalr %zero %ra 0 #555
add_mod5.2241:
	add %a0 %a0 %a1 #119
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.8454
	addi %a0 %a0 -5 #120
	jalr %zero %ra 0 #120
bge_else.8454:
	jalr %zero %ra 0 #120
vecset.2244:
	sw %f0 %a0 0 #129
	sw %f1 %a0 4 #130
	sw %f2 %a0 8 #131
	jalr %zero %ra 0 #131
vecfill.2249:
	sw %f0 %a0 0 #136
	sw %f0 %a0 4 #137
	sw %f0 %a0 8 #138
	jalr %zero %ra 0 #138
vecbzero.2252:
	li %f0 l.5553 #143
	jal	%zero vecfill.2249
veccpy.2254:
	lw %f0 %a1 0 #148
	sw %f0 %a0 0 #148
	lw %f0 %a1 4 #148
	sw %f0 %a0 4 #149
	lw %f0 %a1 8 #148
	sw %f0 %a0 8 #150
	jalr %zero %ra 0 #150
vecdist2.2257:
	lw %f0 %a0 0 #155
	lw %f1 %a1 0 #155
	fsub %f0 %f0 %f1 #155
	sw %a1 %sp 0 #155
	sw %a0 %sp 4 #155
	sw %ra %sp 12 #155 call dir
	addi %sp %sp 16 #155	
	jal %ra min_caml_fsqr #155
	addi %sp %sp -16 #155
	lw %ra %sp 12 #155
	lw %a0 %sp 4 #155
	lw %f1 %a0 4 #155
	lw %a1 %sp 0 #155
	lw %f2 %a1 4 #155
	fsub %f1 %f1 %f2 #155
	sw %f0 %sp 8 #155
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #155 call dir
	addi %sp %sp 24 #155	
	jal %ra min_caml_fsqr #155
	addi %sp %sp -24 #155
	lw %ra %sp 20 #155
	lw %f1 %sp 8 #155
	fadd %f0 %f1 %f0 #155
	lw %a0 %sp 4 #155
	lw %f1 %a0 8 #155
	lw %a0 %sp 0 #155
	lw %f2 %a0 8 #155
	fsub %f1 %f1 %f2 #155
	sw %f0 %sp 16 #155
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #155 call dir
	addi %sp %sp 32 #155	
	jal %ra min_caml_fsqr #155
	addi %sp %sp -32 #155
	lw %ra %sp 28 #155
	lw %f1 %sp 16 #155
	fadd %f0 %f1 %f0 #155
	jalr %zero %ra 0 #155
vecunit.2260:
	li %f0 l.5555 #160
	lw %f1 %a0 0 #160
	sw %f0 %sp 0 #160
	sw %a0 %sp 8 #160
	fadd %f0 %f1 %fzero
	sw %ra %sp 12 #160 call dir
	addi %sp %sp 16 #160	
	jal %ra min_caml_fsqr #160
	addi %sp %sp -16 #160
	lw %ra %sp 12 #160
	lw %a0 %sp 8 #160
	lw %f1 %a0 4 #160
	sw %f0 %sp 16 #160
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #160 call dir
	addi %sp %sp 32 #160	
	jal %ra min_caml_fsqr #160
	addi %sp %sp -32 #160
	lw %ra %sp 28 #160
	lw %f1 %sp 16 #160
	fadd %f0 %f1 %f0 #160
	lw %a0 %sp 8 #160
	lw %f1 %a0 8 #160
	sw %f0 %sp 24 #160
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #160 call dir
	addi %sp %sp 40 #160	
	jal %ra min_caml_fsqr #160
	addi %sp %sp -40 #160
	lw %ra %sp 36 #160
	lw %f1 %sp 24 #160
	fadd %f0 %f1 %f0 #160
	sw %ra %sp 36 #160 call dir
	addi %sp %sp 40 #160	
	jal %ra min_caml_sqrt #160
	addi %sp %sp -40 #160
	lw %ra %sp 36 #160
	lw %f1 %sp 0 #160
	fdiv %f0 %f1 %f0 #160
	lw %a0 %sp 8 #160
	lw %f1 %a0 0 #160
	fmul %f1 %f1 %f0 #161
	sw %f1 %a0 0 #161
	lw %f1 %a0 4 #160
	fmul %f1 %f1 %f0 #162
	sw %f1 %a0 4 #162
	lw %f1 %a0 8 #160
	fmul %f0 %f1 %f0 #163
	sw %f0 %a0 8 #163
	jalr %zero %ra 0 #163
vecunit_sgn.2262:
	lw %f0 %a0 0 #168
	sw %a1 %sp 0 #168
	sw %a0 %sp 4 #168
	sw %ra %sp 12 #168 call dir
	addi %sp %sp 16 #168	
	jal %ra min_caml_fsqr #168
	addi %sp %sp -16 #168
	lw %ra %sp 12 #168
	lw %a0 %sp 4 #168
	lw %f1 %a0 4 #168
	sw %f0 %sp 8 #168
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #168 call dir
	addi %sp %sp 24 #168	
	jal %ra min_caml_fsqr #168
	addi %sp %sp -24 #168
	lw %ra %sp 20 #168
	lw %f1 %sp 8 #168
	fadd %f0 %f1 %f0 #168
	lw %a0 %sp 4 #168
	lw %f1 %a0 8 #168
	sw %f0 %sp 16 #168
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #168 call dir
	addi %sp %sp 32 #168	
	jal %ra min_caml_fsqr #168
	addi %sp %sp -32 #168
	lw %ra %sp 28 #168
	lw %f1 %sp 16 #168
	fadd %f0 %f1 %f0 #168
	sw %ra %sp 28 #168 call dir
	addi %sp %sp 32 #168	
	jal %ra min_caml_sqrt #168
	addi %sp %sp -32 #168
	lw %ra %sp 28 #168
	sw %f0 %sp 24 #169
	sw %ra %sp 36 #169 call dir
	addi %sp %sp 40 #169	
	jal %ra min_caml_fiszero #169
	addi %sp %sp -40 #169
	lw %ra %sp 36 #169
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8460 # nontail if
	lw %a0 %sp 0 #169
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8462 # nontail if
	li %f0 l.5555 #169
	lw %f1 %sp 24 #169
	fdiv %f0 %f0 %f1 #169
	jal %zero beq_cont.8463 # then sentence ends
beq_else.8462:
	li %f0 l.5557 #169
	lw %f1 %sp 24 #169
	fdiv %f0 %f0 %f1 #169
beq_cont.8463:
	jal %zero beq_cont.8461 # then sentence ends
beq_else.8460:
	li %f0 l.5555 #169
beq_cont.8461:
	lw %a0 %sp 4 #168
	lw %f1 %a0 0 #168
	fmul %f1 %f1 %f0 #170
	sw %f1 %a0 0 #170
	lw %f1 %a0 4 #168
	fmul %f1 %f1 %f0 #171
	sw %f1 %a0 4 #171
	lw %f1 %a0 8 #168
	fmul %f0 %f1 %f0 #172
	sw %f0 %a0 8 #172
	jalr %zero %ra 0 #172
veciprod.2265:
	lw %f0 %a0 0 #177
	lw %f1 %a1 0 #177
	fmul %f0 %f0 %f1 #177
	lw %f1 %a0 4 #177
	lw %f2 %a1 4 #177
	fmul %f1 %f1 %f2 #177
	fadd %f0 %f0 %f1 #177
	lw %f1 %a0 8 #177
	lw %f2 %a1 8 #177
	fmul %f1 %f1 %f2 #177
	fadd %f0 %f0 %f1 #177
	jalr %zero %ra 0 #177
veciprod2.2268:
	lw %f3 %a0 0 #182
	fmul %f0 %f3 %f0 #182
	lw %f3 %a0 4 #182
	fmul %f1 %f3 %f1 #182
	fadd %f0 %f0 %f1 #182
	lw %f1 %a0 8 #182
	fmul %f1 %f1 %f2 #182
	fadd %f0 %f0 %f1 #182
	jalr %zero %ra 0 #182
vecaccum.2273:
	lw %f1 %a0 0 #187
	lw %f2 %a1 0 #187
	fmul %f2 %f0 %f2 #187
	fadd %f1 %f1 %f2 #187
	sw %f1 %a0 0 #187
	lw %f1 %a0 4 #187
	lw %f2 %a1 4 #187
	fmul %f2 %f0 %f2 #188
	fadd %f1 %f1 %f2 #188
	sw %f1 %a0 4 #188
	lw %f1 %a0 8 #187
	lw %f2 %a1 8 #187
	fmul %f0 %f0 %f2 #189
	fadd %f0 %f1 %f0 #189
	sw %f0 %a0 8 #189
	jalr %zero %ra 0 #189
vecadd.2277:
	lw %f0 %a0 0 #194
	lw %f1 %a1 0 #194
	fadd %f0 %f0 %f1 #194
	sw %f0 %a0 0 #194
	lw %f0 %a0 4 #194
	lw %f1 %a1 4 #194
	fadd %f0 %f0 %f1 #195
	sw %f0 %a0 4 #195
	lw %f0 %a0 8 #194
	lw %f1 %a1 8 #194
	fadd %f0 %f0 %f1 #196
	sw %f0 %a0 8 #196
	jalr %zero %ra 0 #196
vecmul.2280:
	lw %f0 %a0 0 #201
	lw %f1 %a1 0 #201
	fmul %f0 %f0 %f1 #201
	sw %f0 %a0 0 #201
	lw %f0 %a0 4 #201
	lw %f1 %a1 4 #201
	fmul %f0 %f0 %f1 #202
	sw %f0 %a0 4 #202
	lw %f0 %a0 8 #201
	lw %f1 %a1 8 #201
	fmul %f0 %f0 %f1 #203
	sw %f0 %a0 8 #203
	jalr %zero %ra 0 #203
vecscale.2283:
	lw %f1 %a0 0 #208
	fmul %f1 %f1 %f0 #208
	sw %f1 %a0 0 #208
	lw %f1 %a0 4 #208
	fmul %f1 %f1 %f0 #209
	sw %f1 %a0 4 #209
	lw %f1 %a0 8 #208
	fmul %f0 %f1 %f0 #210
	sw %f0 %a0 8 #210
	jalr %zero %ra 0 #210
vecaccumv.2286:
	lw %f0 %a0 0 #215
	lw %f1 %a1 0 #215
	lw %f2 %a2 0 #215
	fmul %f1 %f1 %f2 #215
	fadd %f0 %f0 %f1 #215
	sw %f0 %a0 0 #215
	lw %f0 %a0 4 #215
	lw %f1 %a1 4 #215
	lw %f2 %a2 4 #215
	fmul %f1 %f1 %f2 #216
	fadd %f0 %f0 %f1 #216
	sw %f0 %a0 4 #216
	lw %f0 %a0 8 #215
	lw %f1 %a1 8 #215
	lw %f2 %a2 8 #215
	fmul %f1 %f1 %f2 #217
	fadd %f0 %f0 %f1 #217
	sw %f0 %a0 8 #217
	jalr %zero %ra 0 #217
o_texturetype.2290:
	lw %a0 %a0 0 #224
	jalr %zero %ra 0 #229
o_form.2292:
	lw %a0 %a0 4 #234
	jalr %zero %ra 0 #239
o_reflectiontype.2294:
	lw %a0 %a0 8 #244
	jalr %zero %ra 0 #249
o_isinvert.2296:
	lw %a0 %a0 24 #254
	jalr %zero %ra 0 #258
o_isrot.2298:
	lw %a0 %a0 12 #263
	jalr %zero %ra 0 #267
o_param_a.2300:
	lw %a0 %a0 16 #272
	lw %f0 %a0 0 #277
	jalr %zero %ra 0 #277
o_param_b.2302:
	lw %a0 %a0 16 #282
	lw %f0 %a0 4 #287
	jalr %zero %ra 0 #287
o_param_c.2304:
	lw %a0 %a0 16 #292
	lw %f0 %a0 8 #297
	jalr %zero %ra 0 #297
o_param_abc.2306:
	lw %a0 %a0 16 #302
	jalr %zero %ra 0 #307
o_param_x.2308:
	lw %a0 %a0 20 #312
	lw %f0 %a0 0 #317
	jalr %zero %ra 0 #317
o_param_y.2310:
	lw %a0 %a0 20 #322
	lw %f0 %a0 4 #327
	jalr %zero %ra 0 #327
o_param_z.2312:
	lw %a0 %a0 20 #332
	lw %f0 %a0 8 #337
	jalr %zero %ra 0 #337
o_diffuse.2314:
	lw %a0 %a0 28 #342
	lw %f0 %a0 0 #347
	jalr %zero %ra 0 #347
o_hilight.2316:
	lw %a0 %a0 28 #352
	lw %f0 %a0 4 #357
	jalr %zero %ra 0 #357
o_color_red.2318:
	lw %a0 %a0 32 #362
	lw %f0 %a0 0 #367
	jalr %zero %ra 0 #367
o_color_green.2320:
	lw %a0 %a0 32 #372
	lw %f0 %a0 4 #377
	jalr %zero %ra 0 #377
o_color_blue.2322:
	lw %a0 %a0 32 #382
	lw %f0 %a0 8 #387
	jalr %zero %ra 0 #387
o_param_r1.2324:
	lw %a0 %a0 36 #392
	lw %f0 %a0 0 #397
	jalr %zero %ra 0 #397
o_param_r2.2326:
	lw %a0 %a0 36 #402
	lw %f0 %a0 4 #407
	jalr %zero %ra 0 #407
o_param_r3.2328:
	lw %a0 %a0 36 #412
	lw %f0 %a0 8 #417
	jalr %zero %ra 0 #417
o_param_ctbl.2330:
	lw %a0 %a0 40 #423
	jalr %zero %ra 0 #428
p_rgb.2332:
	lw %a0 %a0 0 #435
	jalr %zero %ra 0 #437
p_intersection_points.2334:
	lw %a0 %a0 4 #442
	jalr %zero %ra 0 #444
p_surface_ids.2336:
	lw %a0 %a0 8 #450
	jalr %zero %ra 0 #452
p_calc_diffuse.2338:
	lw %a0 %a0 12 #457
	jalr %zero %ra 0 #459
p_energy.2340:
	lw %a0 %a0 16 #464
	jalr %zero %ra 0 #466
p_received_ray_20percent.2342:
	lw %a0 %a0 20 #471
	jalr %zero %ra 0 #473
p_group_id.2344:
	lw %a0 %a0 24 #480
	lw %a0 %a0 0 #482
	jalr %zero %ra 0 #482
p_set_group_id.2346:
	lw %a0 %a0 24 #487
	sw %a1 %a0 0 #489
	jalr %zero %ra 0 #489
p_nvectors.2349:
	lw %a0 %a0 28 #494
	jalr %zero %ra 0 #496
d_vec.2351:
	lw %a0 %a0 0 #503
	jalr %zero %ra 0 #504
d_const.2353:
	lw %a0 %a0 4 #509
	jalr %zero %ra 0 #510
r_surface_id.2355:
	lw %a0 %a0 0 #517
	jalr %zero %ra 0 #518
r_dvec.2357:
	lw %a0 %a0 4 #523
	jalr %zero %ra 0 #524
r_bright.2359:
	lw %f0 %a0 8 #529
	jalr %zero %ra 0 #94
rad.2361:
	li %f1 l.5670 #537
	fmul %f0 %f0 %f1 #537
	jalr %zero %ra 0 #537
read_screen_settings.2363:
	lw %a0 %a11 20 #541
	lw %a1 %a11 16 #541
	lw %a2 %a11 12 #541
	lw %a3 %a11 8 #541
	lw %a4 %a11 4 #541
	sw %a0 %sp 0 #544
	sw %a2 %sp 4 #544
	sw %a3 %sp 8 #544
	sw %a1 %sp 12 #544
	sw %a4 %sp 16 #544
	sw %ra %sp 20 #544 call dir
	addi %sp %sp 24 #544	
	jal %ra min_caml_read_float #544
	addi %sp %sp -24 #544
	lw %ra %sp 20 #544
	lw %a0 %sp 16 #544
	sw %f0 %a0 0 #544
	sw %ra %sp 20 #545 call dir
	addi %sp %sp 24 #545	
	jal %ra min_caml_read_float #545
	addi %sp %sp -24 #545
	lw %ra %sp 20 #545
	lw %a0 %sp 16 #545
	sw %f0 %a0 4 #545
	sw %ra %sp 20 #546 call dir
	addi %sp %sp 24 #546	
	jal %ra min_caml_read_float #546
	addi %sp %sp -24 #546
	lw %ra %sp 20 #546
	lw %a0 %sp 16 #546
	sw %f0 %a0 8 #546
	sw %ra %sp 20 #548 call dir
	addi %sp %sp 24 #548	
	jal %ra min_caml_read_float #548
	addi %sp %sp -24 #548
	lw %ra %sp 20 #548
	sw %ra %sp 20 #548 call dir
	addi %sp %sp 24 #548	
	jal %ra rad.2361 #548
	addi %sp %sp -24 #548
	lw %ra %sp 20 #548
	sw %f0 %sp 24 #549
	sw %ra %sp 36 #549 call dir
	addi %sp %sp 40 #549	
	jal %ra min_caml_cos #549
	addi %sp %sp -40 #549
	lw %ra %sp 36 #549
	lw %f1 %sp 24 #550
	sw %f0 %sp 32 #550
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #550 call dir
	addi %sp %sp 48 #550	
	jal %ra min_caml_sin #550
	addi %sp %sp -48 #550
	lw %ra %sp 44 #550
	sw %f0 %sp 40 #551
	sw %ra %sp 52 #551 call dir
	addi %sp %sp 56 #551	
	jal %ra min_caml_read_float #551
	addi %sp %sp -56 #551
	lw %ra %sp 52 #551
	sw %ra %sp 52 #551 call dir
	addi %sp %sp 56 #551	
	jal %ra rad.2361 #551
	addi %sp %sp -56 #551
	lw %ra %sp 52 #551
	sw %f0 %sp 48 #552
	sw %ra %sp 60 #552 call dir
	addi %sp %sp 64 #552	
	jal %ra min_caml_cos #552
	addi %sp %sp -64 #552
	lw %ra %sp 60 #552
	lw %f1 %sp 48 #553
	sw %f0 %sp 56 #553
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #553 call dir
	addi %sp %sp 72 #553	
	jal %ra min_caml_sin #553
	addi %sp %sp -72 #553
	lw %ra %sp 68 #553
	lw %f1 %sp 32 #555
	fmul %f2 %f1 %f0 #555
	li %f3 l.5675 #555
	fmul %f2 %f2 %f3 #555
	lw %a0 %sp 12 #555
	sw %f2 %a0 0 #555
	li %f2 l.5678 #556
	lw %f3 %sp 40 #556
	fmul %f2 %f3 %f2 #556
	sw %f2 %a0 4 #556
	lw %f2 %sp 56 #557
	fmul %f4 %f1 %f2 #557
	li %f5 l.5675 #557
	fmul %f4 %f4 %f5 #557
	sw %f4 %a0 8 #557
	lw %a1 %sp 8 #559
	sw %f2 %a1 0 #559
	li %f4 l.5553 #560
	sw %f4 %a1 4 #560
	sw %f0 %sp 64 #561
	sw %ra %sp 76 #561 call dir
	addi %sp %sp 80 #561	
	jal %ra min_caml_fneg #561
	addi %sp %sp -80 #561
	lw %ra %sp 76 #561
	lw %a0 %sp 8 #561
	sw %f0 %a0 8 #561
	lw %f0 %sp 40 #563
	sw %ra %sp 76 #563 call dir
	addi %sp %sp 80 #563	
	jal %ra min_caml_fneg #563
	addi %sp %sp -80 #563
	lw %ra %sp 76 #563
	lw %f1 %sp 64 #563
	fmul %f0 %f0 %f1 #563
	lw %a0 %sp 4 #563
	sw %f0 %a0 0 #563
	lw %f0 %sp 32 #564
	sw %ra %sp 76 #564 call dir
	addi %sp %sp 80 #564	
	jal %ra min_caml_fneg #564
	addi %sp %sp -80 #564
	lw %ra %sp 76 #564
	lw %a0 %sp 4 #564
	sw %f0 %a0 4 #564
	lw %f0 %sp 40 #565
	sw %ra %sp 76 #565 call dir
	addi %sp %sp 80 #565	
	jal %ra min_caml_fneg #565
	addi %sp %sp -80 #565
	lw %ra %sp 76 #565
	lw %f1 %sp 56 #565
	fmul %f0 %f0 %f1 #565
	lw %a0 %sp 4 #565
	sw %f0 %a0 8 #565
	lw %a0 %sp 16 #22
	lw %f0 %a0 0 #22
	lw %a1 %sp 12 #70
	lw %f1 %a1 0 #70
	fsub %f0 %f0 %f1 #567
	lw %a2 %sp 0 #567
	sw %f0 %a2 0 #567
	lw %f0 %a0 4 #22
	lw %f1 %a1 4 #70
	fsub %f0 %f0 %f1 #568
	sw %f0 %a2 4 #568
	lw %f0 %a0 8 #22
	lw %f1 %a1 8 #70
	fsub %f0 %f0 %f1 #569
	sw %f0 %a2 8 #569
	jalr %zero %ra 0 #569
read_light.2365:
	lw %a0 %a11 8 #574
	lw %a1 %a11 4 #574
	sw %a1 %sp 0 #576
	sw %a0 %sp 4 #576
	sw %ra %sp 12 #576 call dir
	addi %sp %sp 16 #576	
	jal %ra min_caml_read_int #576
	addi %sp %sp -16 #576
	lw %ra %sp 12 #576
	sw %ra %sp 12 #579 call dir
	addi %sp %sp 16 #579	
	jal %ra min_caml_read_float #579
	addi %sp %sp -16 #579
	lw %ra %sp 12 #579
	sw %ra %sp 12 #579 call dir
	addi %sp %sp 16 #579	
	jal %ra rad.2361 #579
	addi %sp %sp -16 #579
	lw %ra %sp 12 #579
	sw %f0 %sp 8 #580
	sw %ra %sp 20 #580 call dir
	addi %sp %sp 24 #580	
	jal %ra min_caml_sin #580
	addi %sp %sp -24 #580
	lw %ra %sp 20 #580
	sw %ra %sp 20 #581 call dir
	addi %sp %sp 24 #581	
	jal %ra min_caml_fneg #581
	addi %sp %sp -24 #581
	lw %ra %sp 20 #581
	lw %a0 %sp 4 #581
	sw %f0 %a0 4 #581
	sw %ra %sp 20 #582 call dir
	addi %sp %sp 24 #582	
	jal %ra min_caml_read_float #582
	addi %sp %sp -24 #582
	lw %ra %sp 20 #582
	sw %ra %sp 20 #582 call dir
	addi %sp %sp 24 #582	
	jal %ra rad.2361 #582
	addi %sp %sp -24 #582
	lw %ra %sp 20 #582
	lw %f1 %sp 8 #583
	sw %f0 %sp 16 #583
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #583 call dir
	addi %sp %sp 32 #583	
	jal %ra min_caml_cos #583
	addi %sp %sp -32 #583
	lw %ra %sp 28 #583
	lw %f1 %sp 16 #584
	sw %f0 %sp 24 #584
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #584 call dir
	addi %sp %sp 40 #584	
	jal %ra min_caml_sin #584
	addi %sp %sp -40 #584
	lw %ra %sp 36 #584
	lw %f1 %sp 24 #585
	fmul %f0 %f1 %f0 #585
	lw %a0 %sp 4 #585
	sw %f0 %a0 0 #585
	lw %f0 %sp 16 #586
	sw %ra %sp 36 #586 call dir
	addi %sp %sp 40 #586	
	jal %ra min_caml_cos #586
	addi %sp %sp -40 #586
	lw %ra %sp 36 #586
	lw %f1 %sp 24 #587
	fmul %f0 %f1 %f0 #587
	lw %a0 %sp 4 #587
	sw %f0 %a0 8 #587
	sw %ra %sp 36 #588 call dir
	addi %sp %sp 40 #588	
	jal %ra min_caml_read_float #588
	addi %sp %sp -40 #588
	lw %ra %sp 36 #588
	lw %a0 %sp 0 #588
	sw %f0 %a0 0 #588
	jalr %zero %ra 0 #588
rotate_quadratic_matrix.2367:
	lw %f0 %a1 0 #598
	sw %a0 %sp 0 #598
	sw %a1 %sp 4 #598
	sw %ra %sp 12 #598 call dir
	addi %sp %sp 16 #598	
	jal %ra min_caml_cos #598
	addi %sp %sp -16 #598
	lw %ra %sp 12 #598
	lw %a0 %sp 4 #598
	lw %f1 %a0 0 #598
	sw %f0 %sp 8 #599
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #599 call dir
	addi %sp %sp 24 #599	
	jal %ra min_caml_sin #599
	addi %sp %sp -24 #599
	lw %ra %sp 20 #599
	lw %a0 %sp 4 #598
	lw %f1 %a0 4 #598
	sw %f0 %sp 16 #600
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #600 call dir
	addi %sp %sp 32 #600	
	jal %ra min_caml_cos #600
	addi %sp %sp -32 #600
	lw %ra %sp 28 #600
	lw %a0 %sp 4 #598
	lw %f1 %a0 4 #598
	sw %f0 %sp 24 #601
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #601 call dir
	addi %sp %sp 40 #601	
	jal %ra min_caml_sin #601
	addi %sp %sp -40 #601
	lw %ra %sp 36 #601
	lw %a0 %sp 4 #598
	lw %f1 %a0 8 #598
	sw %f0 %sp 32 #602
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #602 call dir
	addi %sp %sp 48 #602	
	jal %ra min_caml_cos #602
	addi %sp %sp -48 #602
	lw %ra %sp 44 #602
	lw %a0 %sp 4 #598
	lw %f1 %a0 8 #598
	sw %f0 %sp 40 #603
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #603 call dir
	addi %sp %sp 56 #603	
	jal %ra min_caml_sin #603
	addi %sp %sp -56 #603
	lw %ra %sp 52 #603
	lw %f1 %sp 40 #605
	lw %f2 %sp 24 #605
	fmul %f3 %f2 %f1 #605
	lw %f4 %sp 32 #606
	lw %f5 %sp 16 #606
	fmul %f6 %f5 %f4 #606
	fmul %f6 %f6 %f1 #606
	lw %f7 %sp 8 #606
	fmul %f8 %f7 %f0 #606
	fsub %f6 %f6 %f8 #606
	fmul %f8 %f7 %f4 #607
	fmul %f8 %f8 %f1 #607
	fmul %f9 %f5 %f0 #607
	fadd %f8 %f8 %f9 #607
	fmul %f9 %f2 %f0 #609
	fmul %f10 %f5 %f4 #610
	fmul %f10 %f10 %f0 #610
	fmul %f11 %f7 %f1 #610
	fadd %f10 %f10 %f11 #610
	fmul %f11 %f7 %f4 #611
	fmul %f0 %f11 %f0 #611
	fmul %f1 %f5 %f1 #611
	fsub %f0 %f0 %f1 #611
	sw %f0 %sp 48 #613
	sw %f8 %sp 56 #613
	sw %f10 %sp 64 #613
	sw %f6 %sp 72 #613
	sw %f9 %sp 80 #613
	sw %f3 %sp 88 #613
	fadd %f0 %f4 %fzero
	sw %ra %sp 100 #613 call dir
	addi %sp %sp 104 #613	
	jal %ra min_caml_fneg #613
	addi %sp %sp -104 #613
	lw %ra %sp 100 #613
	lw %f1 %sp 24 #614
	lw %f2 %sp 16 #614
	fmul %f2 %f2 %f1 #614
	lw %f3 %sp 8 #615
	fmul %f1 %f3 %f1 #615
	lw %a0 %sp 0 #618
	lw %f3 %a0 0 #618
	lw %f4 %a0 4 #618
	lw %f5 %a0 8 #618
	lw %f6 %sp 88 #625
	sw %f1 %sp 96 #625
	sw %f2 %sp 104 #625
	sw %f5 %sp 112 #625
	sw %f0 %sp 120 #625
	sw %f4 %sp 128 #625
	sw %f3 %sp 136 #625
	fadd %f0 %f6 %fzero
	sw %ra %sp 148 #625 call dir
	addi %sp %sp 152 #625	
	jal %ra min_caml_fsqr #625
	addi %sp %sp -152 #625
	lw %ra %sp 148 #625
	lw %f1 %sp 136 #625
	fmul %f0 %f1 %f0 #625
	lw %f2 %sp 80 #625
	sw %f0 %sp 144 #625
	fadd %f0 %f2 %fzero
	sw %ra %sp 156 #625 call dir
	addi %sp %sp 160 #625	
	jal %ra min_caml_fsqr #625
	addi %sp %sp -160 #625
	lw %ra %sp 156 #625
	lw %f1 %sp 128 #625
	fmul %f0 %f1 %f0 #625
	lw %f2 %sp 144 #625
	fadd %f0 %f2 %f0 #625
	lw %f2 %sp 120 #625
	sw %f0 %sp 152 #625
	fadd %f0 %f2 %fzero
	sw %ra %sp 164 #625 call dir
	addi %sp %sp 168 #625	
	jal %ra min_caml_fsqr #625
	addi %sp %sp -168 #625
	lw %ra %sp 164 #625
	lw %f1 %sp 112 #625
	fmul %f0 %f1 %f0 #625
	lw %f2 %sp 152 #625
	fadd %f0 %f2 %f0 #625
	lw %a0 %sp 0 #625
	sw %f0 %a0 0 #625
	lw %f0 %sp 72 #626
	sw %ra %sp 164 #626 call dir
	addi %sp %sp 168 #626	
	jal %ra min_caml_fsqr #626
	addi %sp %sp -168 #626
	lw %ra %sp 164 #626
	lw %f1 %sp 136 #626
	fmul %f0 %f1 %f0 #626
	lw %f2 %sp 64 #626
	sw %f0 %sp 160 #626
	fadd %f0 %f2 %fzero
	sw %ra %sp 172 #626 call dir
	addi %sp %sp 176 #626	
	jal %ra min_caml_fsqr #626
	addi %sp %sp -176 #626
	lw %ra %sp 172 #626
	lw %f1 %sp 128 #626
	fmul %f0 %f1 %f0 #626
	lw %f2 %sp 160 #626
	fadd %f0 %f2 %f0 #626
	lw %f2 %sp 104 #626
	sw %f0 %sp 168 #626
	fadd %f0 %f2 %fzero
	sw %ra %sp 180 #626 call dir
	addi %sp %sp 184 #626	
	jal %ra min_caml_fsqr #626
	addi %sp %sp -184 #626
	lw %ra %sp 180 #626
	lw %f1 %sp 112 #626
	fmul %f0 %f1 %f0 #626
	lw %f2 %sp 168 #626
	fadd %f0 %f2 %f0 #626
	lw %a0 %sp 0 #626
	sw %f0 %a0 4 #626
	lw %f0 %sp 56 #627
	sw %ra %sp 180 #627 call dir
	addi %sp %sp 184 #627	
	jal %ra min_caml_fsqr #627
	addi %sp %sp -184 #627
	lw %ra %sp 180 #627
	lw %f1 %sp 136 #627
	fmul %f0 %f1 %f0 #627
	lw %f2 %sp 48 #627
	sw %f0 %sp 176 #627
	fadd %f0 %f2 %fzero
	sw %ra %sp 188 #627 call dir
	addi %sp %sp 192 #627	
	jal %ra min_caml_fsqr #627
	addi %sp %sp -192 #627
	lw %ra %sp 188 #627
	lw %f1 %sp 128 #627
	fmul %f0 %f1 %f0 #627
	lw %f2 %sp 176 #627
	fadd %f0 %f2 %f0 #627
	lw %f2 %sp 96 #627
	sw %f0 %sp 184 #627
	fadd %f0 %f2 %fzero
	sw %ra %sp 196 #627 call dir
	addi %sp %sp 200 #627	
	jal %ra min_caml_fsqr #627
	addi %sp %sp -200 #627
	lw %ra %sp 196 #627
	lw %f1 %sp 112 #627
	fmul %f0 %f1 %f0 #627
	lw %f2 %sp 184 #627
	fadd %f0 %f2 %f0 #627
	lw %a0 %sp 0 #627
	sw %f0 %a0 8 #627
	li %f0 l.5715 #630
	lw %f2 %sp 72 #630
	lw %f3 %sp 136 #630
	fmul %f4 %f3 %f2 #630
	lw %f5 %sp 56 #630
	fmul %f4 %f4 %f5 #630
	lw %f6 %sp 64 #630
	lw %f7 %sp 128 #630
	fmul %f8 %f7 %f6 #630
	lw %f9 %sp 48 #630
	fmul %f8 %f8 %f9 #630
	fadd %f4 %f4 %f8 #630
	lw %f8 %sp 104 #630
	fmul %f10 %f1 %f8 #630
	lw %f11 %sp 96 #630
	fmul %f10 %f10 %f11 #630
	fadd %f4 %f4 %f10 #630
	fmul %f0 %f0 %f4 #630
	lw %a0 %sp 4 #630
	sw %f0 %a0 0 #630
	li %f0 l.5715 #631
	lw %f4 %sp 88 #631
	fmul %f10 %f3 %f4 #631
	fmul %f5 %f10 %f5 #631
	lw %f10 %sp 80 #631
	fmul %f8 %f7 %f10 #631
	fmul %f8 %f8 %f9 #631
	fadd %f5 %f5 %f8 #631
	lw %f8 %sp 120 #631
	fmul %f9 %f1 %f8 #631
	fmul %f9 %f9 %f11 #631
	fadd %f5 %f5 %f9 #631
	fmul %f0 %f0 %f5 #631
	sw %f0 %a0 4 #631
	li %f0 l.5715 #632
	fmul %f3 %f3 %f4 #632
	fmul %f2 %f3 %f2 #632
	fmul %f3 %f7 %f10 #632
	fmul %f3 %f3 %f6 #632
	fadd %f2 %f2 %f3 #632
	fmul %f1 %f1 %f8 #632
	lw %f3 %sp 104 #632
	fmul %f1 %f1 %f3 #632
	fadd %f1 %f2 %f1 #632
	fmul %f0 %f0 %f1 #632
	sw %f0 %a0 8 #632
	jalr %zero %ra 0 #632
read_nth_object.2370:
	lw %a1 %a11 4 #637
	sw %a1 %sp 0 #639
	sw %a0 %sp 4 #639
	sw %ra %sp 12 #639 call dir
	addi %sp %sp 16 #639	
	jal %ra min_caml_read_int #639
	addi %sp %sp -16 #639
	lw %ra %sp 12 #639
	addi %a1 %zero 1 #640
	sub %a1 %zero %a1 #640
	bne %a0 %a1 beq_else.8475
	addi %a0 %zero 0 #716
	jalr %zero %ra 0 #716
beq_else.8475:
	sw %a0 %sp 8 #642
	sw %ra %sp 12 #642 call dir
	addi %sp %sp 16 #642	
	jal %ra min_caml_read_int #642
	addi %sp %sp -16 #642
	lw %ra %sp 12 #642
	sw %a0 %sp 12 #643
	sw %ra %sp 20 #643 call dir
	addi %sp %sp 24 #643	
	jal %ra min_caml_read_int #643
	addi %sp %sp -24 #643
	lw %ra %sp 20 #643
	sw %a0 %sp 16 #644
	sw %ra %sp 20 #644 call dir
	addi %sp %sp 24 #644	
	jal %ra min_caml_read_int #644
	addi %sp %sp -24 #644
	lw %ra %sp 20 #644
	addi %a1 %zero 3 #646
	li %f0 l.5553 #646
	sw %a0 %sp 20 #646
	add %a0 %a1 %zero
	sw %ra %sp 28 #646 call dir
	addi %sp %sp 32 #646	
	jal %ra min_caml_create_float_array #646
	addi %sp %sp -32 #646
	lw %ra %sp 28 #646
	sw %a0 %sp 24 #647
	sw %ra %sp 28 #647 call dir
	addi %sp %sp 32 #647	
	jal %ra min_caml_read_float #647
	addi %sp %sp -32 #647
	lw %ra %sp 28 #647
	lw %a0 %sp 24 #647
	sw %f0 %a0 0 #647
	sw %ra %sp 28 #648 call dir
	addi %sp %sp 32 #648	
	jal %ra min_caml_read_float #648
	addi %sp %sp -32 #648
	lw %ra %sp 28 #648
	lw %a0 %sp 24 #648
	sw %f0 %a0 4 #648
	sw %ra %sp 28 #649 call dir
	addi %sp %sp 32 #649	
	jal %ra min_caml_read_float #649
	addi %sp %sp -32 #649
	lw %ra %sp 28 #649
	lw %a0 %sp 24 #649
	sw %f0 %a0 8 #649
	addi %a1 %zero 3 #651
	li %f0 l.5553 #651
	add %a0 %a1 %zero
	sw %ra %sp 28 #651 call dir
	addi %sp %sp 32 #651	
	jal %ra min_caml_create_float_array #651
	addi %sp %sp -32 #651
	lw %ra %sp 28 #651
	sw %a0 %sp 28 #652
	sw %ra %sp 36 #652 call dir
	addi %sp %sp 40 #652	
	jal %ra min_caml_read_float #652
	addi %sp %sp -40 #652
	lw %ra %sp 36 #652
	lw %a0 %sp 28 #652
	sw %f0 %a0 0 #652
	sw %ra %sp 36 #653 call dir
	addi %sp %sp 40 #653	
	jal %ra min_caml_read_float #653
	addi %sp %sp -40 #653
	lw %ra %sp 36 #653
	lw %a0 %sp 28 #653
	sw %f0 %a0 4 #653
	sw %ra %sp 36 #654 call dir
	addi %sp %sp 40 #654	
	jal %ra min_caml_read_float #654
	addi %sp %sp -40 #654
	lw %ra %sp 36 #654
	lw %a0 %sp 28 #654
	sw %f0 %a0 8 #654
	sw %ra %sp 36 #656 call dir
	addi %sp %sp 40 #656	
	jal %ra min_caml_read_float #656
	addi %sp %sp -40 #656
	lw %ra %sp 36 #656
	sw %ra %sp 36 #656 call dir
	addi %sp %sp 40 #656	
	jal %ra min_caml_fisneg #656
	addi %sp %sp -40 #656
	lw %ra %sp 36 #656
	addi %a1 %zero 2 #658
	li %f0 l.5553 #658
	sw %a0 %sp 32 #658
	add %a0 %a1 %zero
	sw %ra %sp 36 #658 call dir
	addi %sp %sp 40 #658	
	jal %ra min_caml_create_float_array #658
	addi %sp %sp -40 #658
	lw %ra %sp 36 #658
	sw %a0 %sp 36 #659
	sw %ra %sp 44 #659 call dir
	addi %sp %sp 48 #659	
	jal %ra min_caml_read_float #659
	addi %sp %sp -48 #659
	lw %ra %sp 44 #659
	lw %a0 %sp 36 #659
	sw %f0 %a0 0 #659
	sw %ra %sp 44 #660 call dir
	addi %sp %sp 48 #660	
	jal %ra min_caml_read_float #660
	addi %sp %sp -48 #660
	lw %ra %sp 44 #660
	lw %a0 %sp 36 #660
	sw %f0 %a0 4 #660
	addi %a1 %zero 3 #662
	li %f0 l.5553 #662
	add %a0 %a1 %zero
	sw %ra %sp 44 #662 call dir
	addi %sp %sp 48 #662	
	jal %ra min_caml_create_float_array #662
	addi %sp %sp -48 #662
	lw %ra %sp 44 #662
	sw %a0 %sp 40 #663
	sw %ra %sp 44 #663 call dir
	addi %sp %sp 48 #663	
	jal %ra min_caml_read_float #663
	addi %sp %sp -48 #663
	lw %ra %sp 44 #663
	lw %a0 %sp 40 #663
	sw %f0 %a0 0 #663
	sw %ra %sp 44 #664 call dir
	addi %sp %sp 48 #664	
	jal %ra min_caml_read_float #664
	addi %sp %sp -48 #664
	lw %ra %sp 44 #664
	lw %a0 %sp 40 #664
	sw %f0 %a0 4 #664
	sw %ra %sp 44 #665 call dir
	addi %sp %sp 48 #665	
	jal %ra min_caml_read_float #665
	addi %sp %sp -48 #665
	lw %ra %sp 44 #665
	lw %a0 %sp 40 #665
	sw %f0 %a0 8 #665
	addi %a1 %zero 3 #667
	li %f0 l.5553 #667
	add %a0 %a1 %zero
	sw %ra %sp 44 #667 call dir
	addi %sp %sp 48 #667	
	jal %ra min_caml_create_float_array #667
	addi %sp %sp -48 #667
	lw %ra %sp 44 #667
	lw %a1 %sp 20 #640
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8476 # nontail if
	jal %zero beq_cont.8477 # then sentence ends
beq_else.8476:
	sw %a0 %sp 44 #670
	sw %ra %sp 52 #670 call dir
	addi %sp %sp 56 #670	
	jal %ra min_caml_read_float #670
	addi %sp %sp -56 #670
	lw %ra %sp 52 #670
	sw %ra %sp 52 #670 call dir
	addi %sp %sp 56 #670	
	jal %ra rad.2361 #670
	addi %sp %sp -56 #670
	lw %ra %sp 52 #670
	lw %a0 %sp 44 #670
	sw %f0 %a0 0 #670
	sw %ra %sp 52 #671 call dir
	addi %sp %sp 56 #671	
	jal %ra min_caml_read_float #671
	addi %sp %sp -56 #671
	lw %ra %sp 52 #671
	sw %ra %sp 52 #671 call dir
	addi %sp %sp 56 #671	
	jal %ra rad.2361 #671
	addi %sp %sp -56 #671
	lw %ra %sp 52 #671
	lw %a0 %sp 44 #671
	sw %f0 %a0 4 #671
	sw %ra %sp 52 #672 call dir
	addi %sp %sp 56 #672	
	jal %ra min_caml_read_float #672
	addi %sp %sp -56 #672
	lw %ra %sp 52 #672
	sw %ra %sp 52 #672 call dir
	addi %sp %sp 56 #672	
	jal %ra rad.2361 #672
	addi %sp %sp -56 #672
	lw %ra %sp 52 #672
	lw %a0 %sp 44 #672
	sw %f0 %a0 8 #672
beq_cont.8477:
	lw %a1 %sp 12 #640
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8478 # nontail if
	addi %a2 %zero 1 #679
	jal %zero beq_cont.8479 # then sentence ends
beq_else.8478:
	lw %a2 %sp 32 #679
beq_cont.8479:
	addi %a3 %zero 4 #680
	li %f0 l.5553 #680
	sw %a2 %sp 48 #680
	sw %a0 %sp 44 #680
	add %a0 %a3 %zero
	sw %ra %sp 52 #680 call dir
	addi %sp %sp 56 #680	
	jal %ra min_caml_create_float_array #680
	addi %sp %sp -56 #680
	lw %ra %sp 52 #680
	addi %a1 %min_caml_hp 0 #683
	addi %min_caml_hp %min_caml_hp 48 #683
	sw %a0 %a1 40 #683
	lw %a0 %sp 44 #683
	sw %a0 %a1 36 #683
	lw %a2 %sp 40 #683
	sw %a2 %a1 32 #683
	lw %a2 %sp 36 #683
	sw %a2 %a1 28 #683
	lw %a2 %sp 48 #683
	sw %a2 %a1 24 #683
	lw %a2 %sp 28 #683
	sw %a2 %a1 20 #683
	lw %a2 %sp 24 #683
	sw %a2 %a1 16 #683
	lw %a3 %sp 20 #683
	sw %a3 %a1 12 #683
	lw %a4 %sp 16 #683
	sw %a4 %a1 8 #683
	lw %a4 %sp 12 #683
	sw %a4 %a1 4 #683
	lw %a5 %sp 8 #683
	sw %a5 %a1 0 #683
	lw %a5 %sp 4 #691
	slli %a5 %a5 2 #691
	lw %a6 %sp 0 #691
	add %a12 %a6 %a5 #691
	sw %a1 %a12 0 #691
	addi %a12 %zero 3
	bne %a4 %a12 beq_else.8480 # nontail if
	lw %f0 %a2 0 #646
	sw %f0 %sp 56 #697
	sw %ra %sp 68 #697 call dir
	addi %sp %sp 72 #697	
	jal %ra min_caml_fiszero #697
	addi %sp %sp -72 #697
	lw %ra %sp 68 #697
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8483 # nontail if
	lw %f0 %sp 56 #697
	sw %ra %sp 68 #697 call dir
	addi %sp %sp 72 #697	
	jal %ra sgn.2236 #697
	addi %sp %sp -72 #697
	lw %ra %sp 68 #697
	lw %f1 %sp 56 #697
	sw %f0 %sp 64 #697
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #697 call dir
	addi %sp %sp 80 #697	
	jal %ra min_caml_fsqr #697
	addi %sp %sp -80 #697
	lw %ra %sp 76 #697
	lw %f1 %sp 64 #697
	fdiv %f0 %f1 %f0 #697
	jal %zero beq_cont.8484 # then sentence ends
beq_else.8483:
	li %f0 l.5553 #697
beq_cont.8484:
	lw %a0 %sp 24 #697
	sw %f0 %a0 0 #697
	lw %f0 %a0 4 #646
	sw %f0 %sp 72 #699
	sw %ra %sp 84 #699 call dir
	addi %sp %sp 88 #699	
	jal %ra min_caml_fiszero #699
	addi %sp %sp -88 #699
	lw %ra %sp 84 #699
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8485 # nontail if
	lw %f0 %sp 72 #699
	sw %ra %sp 84 #699 call dir
	addi %sp %sp 88 #699	
	jal %ra sgn.2236 #699
	addi %sp %sp -88 #699
	lw %ra %sp 84 #699
	lw %f1 %sp 72 #699
	sw %f0 %sp 80 #699
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #699 call dir
	addi %sp %sp 96 #699	
	jal %ra min_caml_fsqr #699
	addi %sp %sp -96 #699
	lw %ra %sp 92 #699
	lw %f1 %sp 80 #699
	fdiv %f0 %f1 %f0 #699
	jal %zero beq_cont.8486 # then sentence ends
beq_else.8485:
	li %f0 l.5553 #699
beq_cont.8486:
	lw %a0 %sp 24 #699
	sw %f0 %a0 4 #699
	lw %f0 %a0 8 #646
	sw %f0 %sp 88 #701
	sw %ra %sp 100 #701 call dir
	addi %sp %sp 104 #701	
	jal %ra min_caml_fiszero #701
	addi %sp %sp -104 #701
	lw %ra %sp 100 #701
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8487 # nontail if
	lw %f0 %sp 88 #701
	sw %ra %sp 100 #701 call dir
	addi %sp %sp 104 #701	
	jal %ra sgn.2236 #701
	addi %sp %sp -104 #701
	lw %ra %sp 100 #701
	lw %f1 %sp 88 #701
	sw %f0 %sp 96 #701
	fadd %f0 %f1 %fzero
	sw %ra %sp 108 #701 call dir
	addi %sp %sp 112 #701	
	jal %ra min_caml_fsqr #701
	addi %sp %sp -112 #701
	lw %ra %sp 108 #701
	lw %f1 %sp 96 #701
	fdiv %f0 %f1 %f0 #701
	jal %zero beq_cont.8488 # then sentence ends
beq_else.8487:
	li %f0 l.5553 #701
beq_cont.8488:
	lw %a0 %sp 24 #701
	sw %f0 %a0 8 #701
	jal %zero beq_cont.8481 # then sentence ends
beq_else.8480:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.8489 # nontail if
	addi %a1 %zero 0 #705
	lw %a4 %sp 32 #679
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.8491 # nontail if
	addi %a1 %zero 1 #705
	jal %zero beq_cont.8492 # then sentence ends
beq_else.8491:
beq_cont.8492:
	add %a0 %a2 %zero
	sw %ra %sp 108 #705 call dir
	addi %sp %sp 112 #705	
	jal %ra vecunit_sgn.2262 #705
	addi %sp %sp -112 #705
	lw %ra %sp 108 #705
	jal %zero beq_cont.8490 # then sentence ends
beq_else.8489:
beq_cont.8490:
beq_cont.8481:
	lw %a0 %sp 20 #640
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8493 # nontail if
	jal %zero beq_cont.8494 # then sentence ends
beq_else.8493:
	lw %a0 %sp 24 #710
	lw %a1 %sp 44 #710
	sw %ra %sp 108 #710 call dir
	addi %sp %sp 112 #710	
	jal %ra rotate_quadratic_matrix.2367 #710
	addi %sp %sp -112 #710
	lw %ra %sp 108 #710
beq_cont.8494:
	addi %a0 %zero 1 #713
	jalr %zero %ra 0 #713
read_object.2372:
	lw %a1 %a11 8 #720
	lw %a2 %a11 4 #720
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.8495
	jalr %zero %ra 0 #726
bge_else.8495:
	sw %a11 %sp 0 #722
	sw %a2 %sp 4 #722
	sw %a0 %sp 8 #722
	add %a11 %a1 %zero
	sw %ra %sp 12 #722 call cls
	lw %a10 %a11 0 #722
	addi %sp %sp 16 #722	
	jalr %ra %a10 0 #722
	addi %sp %sp -16 #722
	lw %ra %sp 12 #722
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8497
	lw %a0 %sp 4 #725
	lw %a1 %sp 8 #725
	sw %a1 %a0 0 #725
	jalr %zero %ra 0 #725
beq_else.8497:
	lw %a0 %sp 8 #723
	addi %a0 %a0 1 #723
	lw %a11 %sp 0 #723
	lw %a10 %a11 0 #723
	jalr %zero %a10 0 #723
read_all_object.2374:
	lw %a11 %a11 4 #729
	addi %a0 %zero 0 #730
	lw %a10 %a11 0 #730
	jalr %zero %a10 0 #730
read_net_item.2376:
	sw %a0 %sp 0 #737
	sw %ra %sp 4 #737 call dir
	addi %sp %sp 8 #737	
	jal %ra min_caml_read_int #737
	addi %sp %sp -8 #737
	lw %ra %sp 4 #737
	addi %a1 %zero 1 #738
	sub %a1 %zero %a1 #738
	bne %a0 %a1 beq_else.8499
	lw %a0 %sp 0 #738
	addi %a0 %a0 1 #738
	addi %a1 %zero 1 #738
	sub %a1 %zero %a1 #738
	jal	%zero min_caml_create_array
beq_else.8499:
	lw %a1 %sp 0 #740
	addi %a2 %a1 1 #740
	sw %a0 %sp 4 #740
	add %a0 %a2 %zero
	sw %ra %sp 12 #740 call dir
	addi %sp %sp 16 #740	
	jal %ra read_net_item.2376 #740
	addi %sp %sp -16 #740
	lw %ra %sp 12 #740
	lw %a1 %sp 0 #741
	slli %a1 %a1 2 #741
	lw %a2 %sp 4 #741
	add %a12 %a0 %a1 #741
	sw %a2 %a12 0 #741
	jalr %zero %ra 0 #741
read_or_network.2378:
	addi %a1 %zero 0 #745
	sw %a0 %sp 0 #745
	add %a0 %a1 %zero
	sw %ra %sp 4 #745 call dir
	addi %sp %sp 8 #745	
	jal %ra read_net_item.2376 #745
	addi %sp %sp -8 #745
	lw %ra %sp 4 #745
	add %a1 %a0 %zero #745
	lw %a0 %a1 0 #741
	addi %a2 %zero 1 #746
	sub %a2 %zero %a2 #746
	bne %a0 %a2 beq_else.8500
	lw %a0 %sp 0 #747
	addi %a0 %a0 1 #747
	jal	%zero min_caml_create_array
beq_else.8500:
	lw %a0 %sp 0 #749
	addi %a2 %a0 1 #749
	sw %a1 %sp 4 #749
	add %a0 %a2 %zero
	sw %ra %sp 12 #749 call dir
	addi %sp %sp 16 #749	
	jal %ra read_or_network.2378 #749
	addi %sp %sp -16 #749
	lw %ra %sp 12 #749
	lw %a1 %sp 0 #750
	slli %a1 %a1 2 #750
	lw %a2 %sp 4 #750
	add %a12 %a0 %a1 #750
	sw %a2 %a12 0 #750
	jalr %zero %ra 0 #750
read_and_network.2380:
	lw %a1 %a11 4 #753
	addi %a2 %zero 0 #754
	sw %a11 %sp 0 #754
	sw %a1 %sp 4 #754
	sw %a0 %sp 8 #754
	add %a0 %a2 %zero
	sw %ra %sp 12 #754 call dir
	addi %sp %sp 16 #754	
	jal %ra read_net_item.2376 #754
	addi %sp %sp -16 #754
	lw %ra %sp 12 #754
	lw %a1 %a0 0 #741
	addi %a2 %zero 1 #755
	sub %a2 %zero %a2 #755
	bne %a1 %a2 beq_else.8501
	jalr %zero %ra 0 #755
beq_else.8501:
	lw %a1 %sp 8 #757
	slli %a2 %a1 2 #757
	lw %a3 %sp 4 #757
	add %a12 %a3 %a2 #757
	sw %a0 %a12 0 #757
	addi %a0 %a1 1 #758
	lw %a11 %sp 0 #758
	lw %a10 %a11 0 #758
	jalr %zero %a10 0 #758
read_parameter.2382:
	lw %a0 %a11 20 #762
	lw %a1 %a11 16 #762
	lw %a2 %a11 12 #762
	lw %a3 %a11 8 #762
	lw %a4 %a11 4 #762
	sw %a4 %sp 0 #764
	sw %a2 %sp 4 #764
	sw %a3 %sp 8 #764
	sw %a1 %sp 12 #764
	add %a11 %a0 %zero
	sw %ra %sp 20 #764 call cls
	lw %a10 %a11 0 #764
	addi %sp %sp 24 #764	
	jalr %ra %a10 0 #764
	addi %sp %sp -24 #764
	lw %ra %sp 20 #764
	lw %a11 %sp 12 #765
	sw %ra %sp 20 #765 call cls
	lw %a10 %a11 0 #765
	addi %sp %sp 24 #765	
	jalr %ra %a10 0 #765
	addi %sp %sp -24 #765
	lw %ra %sp 20 #765
	lw %a11 %sp 8 #766
	sw %ra %sp 20 #766 call cls
	lw %a10 %a11 0 #766
	addi %sp %sp 24 #766	
	jalr %ra %a10 0 #766
	addi %sp %sp -24 #766
	lw %ra %sp 20 #766
	addi %a0 %zero 0 #767
	lw %a11 %sp 4 #767
	sw %ra %sp 20 #767 call cls
	lw %a10 %a11 0 #767
	addi %sp %sp 24 #767	
	jalr %ra %a10 0 #767
	addi %sp %sp -24 #767
	lw %ra %sp 20 #767
	addi %a0 %zero 0 #768
	sw %ra %sp 20 #768 call dir
	addi %sp %sp 24 #768	
	jal %ra read_or_network.2378 #768
	addi %sp %sp -24 #768
	lw %ra %sp 20 #768
	lw %a1 %sp 0 #768
	sw %a0 %a1 0 #768
	jalr %zero %ra 0 #768
solver_rect_surface.2384:
	lw %a5 %a11 4 #778
	slli %a6 %a2 2 #779
	add %a12 %a1 %a6 #779
	lw %f3 %a12 0 #779
	sw %a5 %sp 0 #779
	sw %f2 %sp 8 #779
	sw %a4 %sp 16 #779
	sw %f1 %sp 24 #779
	sw %a3 %sp 32 #779
	sw %f0 %sp 40 #779
	sw %a1 %sp 48 #779
	sw %a2 %sp 52 #779
	sw %a0 %sp 56 #779
	fadd %f0 %f3 %fzero
	sw %ra %sp 60 #779 call dir
	addi %sp %sp 64 #779	
	jal %ra min_caml_fiszero #779
	addi %sp %sp -64 #779
	lw %ra %sp 60 #779
	addi %a1 %zero 0 #779
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8507
	lw %a0 %sp 56 #780
	sw %a1 %sp 60 #780
	sw %ra %sp 68 #780 call dir
	addi %sp %sp 72 #780	
	jal %ra o_param_abc.2306 #780
	addi %sp %sp -72 #780
	lw %ra %sp 68 #780
	lw %a1 %sp 56 #781
	sw %a0 %sp 64 #781
	add %a0 %a1 %zero
	sw %ra %sp 68 #781 call dir
	addi %sp %sp 72 #781	
	jal %ra o_isinvert.2296 #781
	addi %sp %sp -72 #781
	lw %ra %sp 68 #781
	lw %a1 %sp 52 #779
	slli %a2 %a1 2 #779
	lw %a3 %sp 48 #779
	add %a12 %a3 %a2 #779
	lw %f0 %a12 0 #779
	sw %a0 %sp 68 #781
	sw %ra %sp 76 #781 call dir
	addi %sp %sp 80 #781	
	jal %ra min_caml_fisneg #781
	addi %sp %sp -80 #781
	lw %ra %sp 76 #781
	add %a1 %a0 %zero #781
	lw %a0 %sp 68 #781
	sw %ra %sp 76 #781 call dir
	addi %sp %sp 80 #781	
	jal %ra xor.2233 #781
	addi %sp %sp -80 #781
	lw %ra %sp 76 #781
	lw %a1 %sp 52 #781
	slli %a2 %a1 2 #781
	lw %a3 %sp 64 #781
	add %a12 %a3 %a2 #781
	lw %f0 %a12 0 #781
	sw %ra %sp 76 #781 call dir
	addi %sp %sp 80 #781	
	jal %ra fneg_cond.2238 #781
	addi %sp %sp -80 #781
	lw %ra %sp 76 #781
	lw %f1 %sp 40 #783
	fsub %f0 %f0 %f1 #783
	lw %a0 %sp 52 #779
	slli %a0 %a0 2 #779
	lw %a1 %sp 48 #779
	add %a12 %a1 %a0 #779
	lw %f1 %a12 0 #779
	fdiv %f0 %f0 %f1 #783
	lw %a0 %sp 32 #779
	slli %a2 %a0 2 #779
	add %a12 %a1 %a2 #779
	lw %f1 %a12 0 #779
	fmul %f1 %f0 %f1 #784
	lw %f2 %sp 24 #784
	fadd %f1 %f1 %f2 #784
	sw %f0 %sp 72 #784
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #784 call dir
	addi %sp %sp 88 #784	
	jal %ra min_caml_fabs #784
	addi %sp %sp -88 #784
	lw %ra %sp 84 #784
	lw %a0 %sp 32 #781
	slli %a0 %a0 2 #781
	lw %a1 %sp 64 #781
	add %a12 %a1 %a0 #781
	lw %f1 %a12 0 #781
	sw %ra %sp 84 #784 call dir
	addi %sp %sp 88 #784	
	jal %ra min_caml_fless #784
	addi %sp %sp -88 #784
	lw %ra %sp 84 #784
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8508
	lw %a0 %sp 60 #779
	jalr %zero %ra 0 #779
beq_else.8508:
	lw %a0 %sp 16 #779
	slli %a1 %a0 2 #779
	lw %a2 %sp 48 #779
	add %a12 %a2 %a1 #779
	lw %f0 %a12 0 #779
	lw %f1 %sp 72 #785
	fmul %f0 %f1 %f0 #785
	lw %f2 %sp 8 #785
	fadd %f0 %f0 %f2 #785
	sw %ra %sp 84 #785 call dir
	addi %sp %sp 88 #785	
	jal %ra min_caml_fabs #785
	addi %sp %sp -88 #785
	lw %ra %sp 84 #785
	lw %a0 %sp 16 #781
	slli %a0 %a0 2 #781
	lw %a1 %sp 64 #781
	add %a12 %a1 %a0 #781
	lw %f1 %a12 0 #781
	sw %ra %sp 84 #785 call dir
	addi %sp %sp 88 #785	
	jal %ra min_caml_fless #785
	addi %sp %sp -88 #785
	lw %ra %sp 84 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8509
	lw %a0 %sp 60 #779
	jalr %zero %ra 0 #779
beq_else.8509:
	lw %a0 %sp 0 #786
	lw %f0 %sp 72 #786
	sw %f0 %a0 0 #786
	addi %a0 %zero 1 #786
	jalr %zero %ra 0 #786
beq_else.8507:
	addi %a0 %a1 0 #779
	jalr %zero %ra 0 #779
solver_rect.2393:
	lw %a11 %a11 4 #793
	addi %a2 %zero 0 #794
	addi %a3 %zero 1 #794
	addi %a4 %zero 2 #794
	sw %f0 %sp 0 #794
	sw %f2 %sp 8 #794
	sw %f1 %sp 16 #794
	sw %a1 %sp 24 #794
	sw %a0 %sp 28 #794
	sw %a11 %sp 32 #794
	sw %ra %sp 36 #794 call cls
	lw %a10 %a11 0 #794
	addi %sp %sp 40 #794	
	jalr %ra %a10 0 #794
	addi %sp %sp -40 #794
	lw %ra %sp 36 #794
	addi %a4 %zero 0 #794
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8510
	addi %a2 %zero 1 #795
	addi %a3 %zero 2 #795
	lw %f0 %sp 16 #795
	lw %f1 %sp 8 #795
	lw %f2 %sp 0 #795
	lw %a0 %sp 28 #795
	lw %a1 %sp 24 #795
	lw %a11 %sp 32 #795
	sw %a4 %sp 36 #795
	sw %ra %sp 44 #795 call cls
	lw %a10 %a11 0 #795
	addi %sp %sp 48 #795	
	jalr %ra %a10 0 #795
	addi %sp %sp -48 #795
	lw %ra %sp 44 #795
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8511
	addi %a2 %zero 2 #796
	addi %a4 %zero 1 #796
	lw %f0 %sp 8 #796
	lw %f1 %sp 0 #796
	lw %f2 %sp 16 #796
	lw %a0 %sp 28 #796
	lw %a1 %sp 24 #796
	lw %a3 %sp 36 #796
	lw %a11 %sp 32 #796
	sw %ra %sp 44 #796 call cls
	lw %a10 %a11 0 #796
	addi %sp %sp 48 #796	
	jalr %ra %a10 0 #796
	addi %sp %sp -48 #796
	lw %ra %sp 44 #796
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8512
	lw %a0 %sp 36 #794
	jalr %zero %ra 0 #794
beq_else.8512:
	addi %a0 %zero 3 #796
	jalr %zero %ra 0 #796
beq_else.8511:
	addi %a0 %zero 2 #795
	jalr %zero %ra 0 #795
beq_else.8510:
	addi %a0 %zero 1 #794
	jalr %zero %ra 0 #794
solver_surface.2399:
	lw %a2 %a11 4 #802
	sw %a2 %sp 0 #805
	sw %f2 %sp 8 #805
	sw %f1 %sp 16 #805
	sw %f0 %sp 24 #805
	sw %a1 %sp 32 #805
	sw %ra %sp 36 #805 call dir
	addi %sp %sp 40 #805	
	jal %ra o_param_abc.2306 #805
	addi %sp %sp -40 #805
	lw %ra %sp 36 #805
	add %a1 %a0 %zero #805
	lw %a0 %sp 32 #806
	sw %a1 %sp 36 #806
	sw %ra %sp 44 #806 call dir
	addi %sp %sp 48 #806	
	jal %ra veciprod.2265 #806
	addi %sp %sp -48 #806
	lw %ra %sp 44 #806
	sw %f0 %sp 40 #807
	sw %ra %sp 52 #807 call dir
	addi %sp %sp 56 #807	
	jal %ra min_caml_fispos #807
	addi %sp %sp -56 #807
	lw %ra %sp 52 #807
	addi %a1 %zero 0 #807
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8514
	addi %a0 %a1 0 #807
	jalr %zero %ra 0 #807
beq_else.8514:
	lw %f0 %sp 24 #808
	lw %f1 %sp 16 #808
	lw %f2 %sp 8 #808
	lw %a0 %sp 36 #808
	sw %ra %sp 52 #808 call dir
	addi %sp %sp 56 #808	
	jal %ra veciprod2.2268 #808
	addi %sp %sp -56 #808
	lw %ra %sp 52 #808
	sw %ra %sp 52 #808 call dir
	addi %sp %sp 56 #808	
	jal %ra min_caml_fneg #808
	addi %sp %sp -56 #808
	lw %ra %sp 52 #808
	lw %f1 %sp 40 #808
	fdiv %f0 %f0 %f1 #808
	lw %a0 %sp 0 #808
	sw %f0 %a0 0 #808
	addi %a0 %zero 1 #809
	jalr %zero %ra 0 #809
quadratic.2405:
	sw %f0 %sp 0 #818
	sw %f2 %sp 8 #818
	sw %f1 %sp 16 #818
	sw %a0 %sp 24 #818
	sw %ra %sp 28 #818 call dir
	addi %sp %sp 32 #818	
	jal %ra min_caml_fsqr #818
	addi %sp %sp -32 #818
	lw %ra %sp 28 #818
	lw %a0 %sp 24 #818
	sw %f0 %sp 32 #818
	sw %ra %sp 44 #818 call dir
	addi %sp %sp 48 #818	
	jal %ra o_param_a.2300 #818
	addi %sp %sp -48 #818
	lw %ra %sp 44 #818
	lw %f1 %sp 32 #818
	fmul %f0 %f1 %f0 #818
	lw %f1 %sp 16 #818
	sw %f0 %sp 40 #818
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #818 call dir
	addi %sp %sp 56 #818	
	jal %ra min_caml_fsqr #818
	addi %sp %sp -56 #818
	lw %ra %sp 52 #818
	lw %a0 %sp 24 #818
	sw %f0 %sp 48 #818
	sw %ra %sp 60 #818 call dir
	addi %sp %sp 64 #818	
	jal %ra o_param_b.2302 #818
	addi %sp %sp -64 #818
	lw %ra %sp 60 #818
	lw %f1 %sp 48 #818
	fmul %f0 %f1 %f0 #818
	lw %f1 %sp 40 #818
	fadd %f0 %f1 %f0 #818
	lw %f1 %sp 8 #818
	sw %f0 %sp 56 #818
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #818 call dir
	addi %sp %sp 72 #818	
	jal %ra min_caml_fsqr #818
	addi %sp %sp -72 #818
	lw %ra %sp 68 #818
	lw %a0 %sp 24 #818
	sw %f0 %sp 64 #818
	sw %ra %sp 76 #818 call dir
	addi %sp %sp 80 #818	
	jal %ra o_param_c.2304 #818
	addi %sp %sp -80 #818
	lw %ra %sp 76 #818
	lw %f1 %sp 64 #818
	fmul %f0 %f1 %f0 #818
	lw %f1 %sp 56 #818
	fadd %f0 %f1 %f0 #818
	lw %a0 %sp 24 #820
	sw %f0 %sp 72 #820
	sw %ra %sp 84 #820 call dir
	addi %sp %sp 88 #820	
	jal %ra o_isrot.2298 #820
	addi %sp %sp -88 #820
	lw %ra %sp 84 #820
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8516
	lw %f0 %sp 72 #818
	jalr %zero %ra 0 #818
beq_else.8516:
	lw %f0 %sp 8 #824
	lw %f1 %sp 16 #824
	fmul %f2 %f1 %f0 #824
	lw %a0 %sp 24 #824
	sw %f2 %sp 80 #824
	sw %ra %sp 92 #824 call dir
	addi %sp %sp 96 #824	
	jal %ra o_param_r1.2324 #824
	addi %sp %sp -96 #824
	lw %ra %sp 92 #824
	lw %f1 %sp 80 #824
	fmul %f0 %f1 %f0 #824
	lw %f1 %sp 72 #823
	fadd %f0 %f1 %f0 #823
	lw %f1 %sp 0 #825
	lw %f2 %sp 8 #825
	fmul %f2 %f2 %f1 #825
	lw %a0 %sp 24 #825
	sw %f0 %sp 88 #825
	sw %f2 %sp 96 #825
	sw %ra %sp 108 #825 call dir
	addi %sp %sp 112 #825	
	jal %ra o_param_r2.2326 #825
	addi %sp %sp -112 #825
	lw %ra %sp 108 #825
	lw %f1 %sp 96 #825
	fmul %f0 %f1 %f0 #825
	lw %f1 %sp 88 #823
	fadd %f0 %f1 %f0 #823
	lw %f1 %sp 16 #826
	lw %f2 %sp 0 #826
	fmul %f1 %f2 %f1 #826
	lw %a0 %sp 24 #826
	sw %f0 %sp 104 #826
	sw %f1 %sp 112 #826
	sw %ra %sp 124 #826 call dir
	addi %sp %sp 128 #826	
	jal %ra o_param_r3.2328 #826
	addi %sp %sp -128 #826
	lw %ra %sp 124 #826
	lw %f1 %sp 112 #826
	fmul %f0 %f1 %f0 #826
	lw %f1 %sp 104 #823
	fadd %f0 %f1 %f0 #823
	jalr %zero %ra 0 #823
bilinear.2410:
	fmul %f6 %f0 %f3 #833
	sw %f3 %sp 0 #833
	sw %f0 %sp 8 #833
	sw %f5 %sp 16 #833
	sw %f2 %sp 24 #833
	sw %a0 %sp 32 #833
	sw %f4 %sp 40 #833
	sw %f1 %sp 48 #833
	sw %f6 %sp 56 #833
	sw %ra %sp 68 #833 call dir
	addi %sp %sp 72 #833	
	jal %ra o_param_a.2300 #833
	addi %sp %sp -72 #833
	lw %ra %sp 68 #833
	lw %f1 %sp 56 #833
	fmul %f0 %f1 %f0 #833
	lw %f1 %sp 40 #834
	lw %f2 %sp 48 #834
	fmul %f3 %f2 %f1 #834
	lw %a0 %sp 32 #834
	sw %f0 %sp 64 #834
	sw %f3 %sp 72 #834
	sw %ra %sp 84 #834 call dir
	addi %sp %sp 88 #834	
	jal %ra o_param_b.2302 #834
	addi %sp %sp -88 #834
	lw %ra %sp 84 #834
	lw %f1 %sp 72 #834
	fmul %f0 %f1 %f0 #834
	lw %f1 %sp 64 #833
	fadd %f0 %f1 %f0 #833
	lw %f1 %sp 16 #835
	lw %f2 %sp 24 #835
	fmul %f3 %f2 %f1 #835
	lw %a0 %sp 32 #835
	sw %f0 %sp 80 #835
	sw %f3 %sp 88 #835
	sw %ra %sp 100 #835 call dir
	addi %sp %sp 104 #835	
	jal %ra o_param_c.2304 #835
	addi %sp %sp -104 #835
	lw %ra %sp 100 #835
	lw %f1 %sp 88 #835
	fmul %f0 %f1 %f0 #835
	lw %f1 %sp 80 #833
	fadd %f0 %f1 %f0 #833
	lw %a0 %sp 32 #837
	sw %f0 %sp 96 #837
	sw %ra %sp 108 #837 call dir
	addi %sp %sp 112 #837	
	jal %ra o_isrot.2298 #837
	addi %sp %sp -112 #837
	lw %ra %sp 108 #837
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8518
	lw %f0 %sp 96 #833
	jalr %zero %ra 0 #833
beq_else.8518:
	lw %f0 %sp 40 #841
	lw %f1 %sp 24 #841
	fmul %f2 %f1 %f0 #841
	lw %f3 %sp 16 #841
	lw %f4 %sp 48 #841
	fmul %f5 %f4 %f3 #841
	fadd %f2 %f2 %f5 #841
	lw %a0 %sp 32 #841
	sw %f2 %sp 104 #841
	sw %ra %sp 116 #841 call dir
	addi %sp %sp 120 #841	
	jal %ra o_param_r1.2324 #841
	addi %sp %sp -120 #841
	lw %ra %sp 116 #841
	lw %f1 %sp 104 #841
	fmul %f0 %f1 %f0 #841
	lw %f1 %sp 16 #842
	lw %f2 %sp 8 #842
	fmul %f1 %f2 %f1 #842
	lw %f3 %sp 0 #842
	lw %f4 %sp 24 #842
	fmul %f4 %f4 %f3 #842
	fadd %f1 %f1 %f4 #842
	lw %a0 %sp 32 #842
	sw %f0 %sp 112 #842
	sw %f1 %sp 120 #842
	sw %ra %sp 132 #842 call dir
	addi %sp %sp 136 #842	
	jal %ra o_param_r2.2326 #842
	addi %sp %sp -136 #842
	lw %ra %sp 132 #842
	lw %f1 %sp 120 #842
	fmul %f0 %f1 %f0 #842
	lw %f1 %sp 112 #841
	fadd %f0 %f1 %f0 #841
	lw %f1 %sp 40 #843
	lw %f2 %sp 8 #843
	fmul %f1 %f2 %f1 #843
	lw %f2 %sp 0 #843
	lw %f3 %sp 48 #843
	fmul %f2 %f3 %f2 #843
	fadd %f1 %f1 %f2 #843
	lw %a0 %sp 32 #843
	sw %f0 %sp 128 #843
	sw %f1 %sp 136 #843
	sw %ra %sp 148 #843 call dir
	addi %sp %sp 152 #843	
	jal %ra o_param_r3.2328 #843
	addi %sp %sp -152 #843
	lw %ra %sp 148 #843
	lw %f1 %sp 136 #843
	fmul %f0 %f1 %f0 #843
	lw %f1 %sp 128 #841
	fadd %f0 %f1 %f0 #841
	sw %ra %sp 148 #840 call dir
	addi %sp %sp 152 #840	
	jal %ra min_caml_fhalf #840
	addi %sp %sp -152 #840
	lw %ra %sp 148 #840
	lw %f1 %sp 96 #840
	fadd %f0 %f1 %f0 #840
	jalr %zero %ra 0 #840
solver_second.2418:
	lw %a2 %a11 4 #850
	lw %f3 %a1 0 #854
	lw %f4 %a1 4 #854
	lw %f5 %a1 8 #854
	sw %a2 %sp 0 #854
	sw %f2 %sp 8 #854
	sw %f1 %sp 16 #854
	sw %f0 %sp 24 #854
	sw %a0 %sp 32 #854
	sw %a1 %sp 36 #854
	fadd %f2 %f5 %fzero
	fadd %f1 %f4 %fzero
	fadd %f0 %f3 %fzero
	sw %ra %sp 44 #854 call dir
	addi %sp %sp 48 #854	
	jal %ra quadratic.2405 #854
	addi %sp %sp -48 #854
	lw %ra %sp 44 #854
	sw %f0 %sp 40 #856
	sw %ra %sp 52 #856 call dir
	addi %sp %sp 56 #856	
	jal %ra min_caml_fiszero #856
	addi %sp %sp -56 #856
	lw %ra %sp 52 #856
	addi %a1 %zero 0 #856
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8520
	lw %a0 %sp 36 #854
	lw %f0 %a0 0 #854
	lw %f1 %a0 4 #854
	lw %f2 %a0 8 #854
	lw %f3 %sp 24 #861
	lw %f4 %sp 16 #861
	lw %f5 %sp 8 #861
	lw %a0 %sp 32 #861
	sw %a1 %sp 48 #861
	sw %ra %sp 52 #861 call dir
	addi %sp %sp 56 #861	
	jal %ra bilinear.2410 #861
	addi %sp %sp -56 #861
	lw %ra %sp 52 #861
	lw %f1 %sp 24 #863
	lw %f2 %sp 16 #863
	lw %f3 %sp 8 #863
	lw %a0 %sp 32 #863
	sw %f0 %sp 56 #863
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 68 #863 call dir
	addi %sp %sp 72 #863	
	jal %ra quadratic.2405 #863
	addi %sp %sp -72 #863
	lw %ra %sp 68 #863
	lw %a0 %sp 32 #864
	sw %f0 %sp 64 #864
	sw %ra %sp 76 #864 call dir
	addi %sp %sp 80 #864	
	jal %ra o_form.2292 #864
	addi %sp %sp -80 #864
	lw %ra %sp 76 #864
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8522 # nontail if
	li %f0 l.5555 #864
	lw %f1 %sp 64 #864
	fsub %f0 %f1 %f0 #864
	jal %zero beq_cont.8523 # then sentence ends
beq_else.8522:
	lw %f0 %sp 64 #818
beq_cont.8523:
	lw %f1 %sp 56 #866
	sw %f0 %sp 72 #866
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #866 call dir
	addi %sp %sp 88 #866	
	jal %ra min_caml_fsqr #866
	addi %sp %sp -88 #866
	lw %ra %sp 84 #866
	lw %f1 %sp 72 #866
	lw %f2 %sp 40 #866
	fmul %f1 %f2 %f1 #866
	fsub %f0 %f0 %f1 #866
	sw %f0 %sp 80 #868
	sw %ra %sp 92 #868 call dir
	addi %sp %sp 96 #868	
	jal %ra min_caml_fispos #868
	addi %sp %sp -96 #868
	lw %ra %sp 92 #868
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8524
	lw %a0 %sp 48 #856
	jalr %zero %ra 0 #856
beq_else.8524:
	lw %f0 %sp 80 #869
	sw %ra %sp 92 #869 call dir
	addi %sp %sp 96 #869	
	jal %ra min_caml_sqrt #869
	addi %sp %sp -96 #869
	lw %ra %sp 92 #869
	lw %a0 %sp 32 #870
	sw %f0 %sp 88 #870
	sw %ra %sp 100 #870 call dir
	addi %sp %sp 104 #870	
	jal %ra o_isinvert.2296 #870
	addi %sp %sp -104 #870
	lw %ra %sp 100 #870
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8525 # nontail if
	lw %f0 %sp 88 #870
	sw %ra %sp 100 #870 call dir
	addi %sp %sp 104 #870	
	jal %ra min_caml_fneg #870
	addi %sp %sp -104 #870
	lw %ra %sp 100 #870
	jal %zero beq_cont.8526 # then sentence ends
beq_else.8525:
	lw %f0 %sp 88 #160
beq_cont.8526:
	lw %f1 %sp 56 #871
	fsub %f0 %f0 %f1 #871
	lw %f1 %sp 40 #871
	fdiv %f0 %f0 %f1 #871
	lw %a0 %sp 0 #871
	sw %f0 %a0 0 #871
	addi %a0 %zero 1 #871
	jalr %zero %ra 0 #871
beq_else.8520:
	addi %a0 %a1 0 #856
	jalr %zero %ra 0 #856
solver.2424:
	lw %a3 %a11 16 #879
	lw %a4 %a11 12 #879
	lw %a5 %a11 8 #879
	lw %a6 %a11 4 #879
	slli %a0 %a0 2 #19
	add %a12 %a6 %a0 #19
	lw %a0 %a12 0 #19
	lw %f0 %a2 0 #882
	sw %a4 %sp 0 #882
	sw %a3 %sp 4 #882
	sw %a1 %sp 8 #882
	sw %a5 %sp 12 #882
	sw %a0 %sp 16 #882
	sw %a2 %sp 20 #882
	sw %f0 %sp 24 #882
	sw %ra %sp 36 #882 call dir
	addi %sp %sp 40 #882	
	jal %ra o_param_x.2308 #882
	addi %sp %sp -40 #882
	lw %ra %sp 36 #882
	lw %f1 %sp 24 #882
	fsub %f0 %f1 %f0 #882
	lw %a0 %sp 20 #882
	lw %f1 %a0 4 #882
	lw %a1 %sp 16 #883
	sw %f0 %sp 32 #883
	sw %f1 %sp 40 #883
	add %a0 %a1 %zero
	sw %ra %sp 52 #883 call dir
	addi %sp %sp 56 #883	
	jal %ra o_param_y.2310 #883
	addi %sp %sp -56 #883
	lw %ra %sp 52 #883
	lw %f1 %sp 40 #883
	fsub %f0 %f1 %f0 #883
	lw %a0 %sp 20 #882
	lw %f1 %a0 8 #882
	lw %a0 %sp 16 #884
	sw %f0 %sp 48 #884
	sw %f1 %sp 56 #884
	sw %ra %sp 68 #884 call dir
	addi %sp %sp 72 #884	
	jal %ra o_param_z.2312 #884
	addi %sp %sp -72 #884
	lw %ra %sp 68 #884
	lw %f1 %sp 56 #884
	fsub %f0 %f1 %f0 #884
	lw %a0 %sp 16 #885
	sw %f0 %sp 64 #885
	sw %ra %sp 76 #885 call dir
	addi %sp %sp 80 #885	
	jal %ra o_form.2292 #885
	addi %sp %sp -80 #885
	lw %ra %sp 76 #885
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8527
	lw %f0 %sp 32 #887
	lw %f1 %sp 48 #887
	lw %f2 %sp 64 #887
	lw %a0 %sp 16 #887
	lw %a1 %sp 8 #887
	lw %a11 %sp 12 #887
	lw %a10 %a11 0 #887
	jalr %zero %a10 0 #887
beq_else.8527:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8528
	lw %f0 %sp 32 #888
	lw %f1 %sp 48 #888
	lw %f2 %sp 64 #888
	lw %a0 %sp 16 #888
	lw %a1 %sp 8 #888
	lw %a11 %sp 4 #888
	lw %a10 %a11 0 #888
	jalr %zero %a10 0 #888
beq_else.8528:
	lw %f0 %sp 32 #889
	lw %f1 %sp 48 #889
	lw %f2 %sp 64 #889
	lw %a0 %sp 16 #889
	lw %a1 %sp 8 #889
	lw %a11 %sp 0 #889
	lw %a10 %a11 0 #889
	jalr %zero %a10 0 #889
solver_rect_fast.2428:
	lw %a3 %a11 4 #896
	lw %f3 %a2 0 #897
	fsub %f3 %f3 %f0 #897
	lw %f4 %a2 4 #897
	fmul %f3 %f3 %f4 #897
	lw %f4 %a1 4 #899
	fmul %f4 %f3 %f4 #899
	fadd %f4 %f4 %f1 #899
	sw %a3 %sp 0 #899
	sw %f0 %sp 8 #899
	sw %f1 %sp 16 #899
	sw %a2 %sp 24 #899
	sw %f2 %sp 32 #899
	sw %f3 %sp 40 #899
	sw %a1 %sp 48 #899
	sw %a0 %sp 52 #899
	fadd %f0 %f4 %fzero
	sw %ra %sp 60 #899 call dir
	addi %sp %sp 64 #899	
	jal %ra min_caml_fabs #899
	addi %sp %sp -64 #899
	lw %ra %sp 60 #899
	lw %a0 %sp 52 #899
	sw %f0 %sp 56 #899
	sw %ra %sp 68 #899 call dir
	addi %sp %sp 72 #899	
	jal %ra o_param_b.2302 #899
	addi %sp %sp -72 #899
	lw %ra %sp 68 #899
	fadd %f1 %f0 %fzero #899
	lw %f0 %sp 56 #899
	sw %ra %sp 68 #899 call dir
	addi %sp %sp 72 #899	
	jal %ra min_caml_fless #899
	addi %sp %sp -72 #899
	lw %ra %sp 68 #899
	addi %a1 %zero 0 #899
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8531 # nontail if
	addi %a0 %a1 0 #899
	jal %zero beq_cont.8532 # then sentence ends
beq_else.8531:
	lw %a0 %sp 48 #899
	lw %f0 %a0 8 #899
	lw %f1 %sp 40 #900
	fmul %f0 %f1 %f0 #900
	lw %f2 %sp 32 #900
	fadd %f0 %f0 %f2 #900
	sw %a1 %sp 64 #900
	sw %ra %sp 68 #900 call dir
	addi %sp %sp 72 #900	
	jal %ra min_caml_fabs #900
	addi %sp %sp -72 #900
	lw %ra %sp 68 #900
	lw %a0 %sp 52 #900
	sw %f0 %sp 72 #900
	sw %ra %sp 84 #900 call dir
	addi %sp %sp 88 #900	
	jal %ra o_param_c.2304 #900
	addi %sp %sp -88 #900
	lw %ra %sp 84 #900
	fadd %f1 %f0 %fzero #900
	lw %f0 %sp 72 #900
	sw %ra %sp 84 #900 call dir
	addi %sp %sp 88 #900	
	jal %ra min_caml_fless #900
	addi %sp %sp -88 #900
	lw %ra %sp 84 #900
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8534 # nontail if
	lw %a0 %sp 64 #899
	jal %zero beq_cont.8535 # then sentence ends
beq_else.8534:
	lw %a0 %sp 24 #897
	lw %f0 %a0 4 #897
	sw %ra %sp 84 #901 call dir
	addi %sp %sp 88 #901	
	jal %ra min_caml_fiszero #901
	addi %sp %sp -88 #901
	lw %ra %sp 84 #901
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8536 # nontail if
	addi %a0 %zero 1 #901
	jal %zero beq_cont.8537 # then sentence ends
beq_else.8536:
	lw %a0 %sp 64 #899
beq_cont.8537:
beq_cont.8535:
beq_cont.8532:
	addi %a1 %zero 0 #898
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8538
	lw %a0 %sp 24 #897
	lw %f0 %a0 8 #897
	lw %f1 %sp 16 #906
	fsub %f0 %f0 %f1 #906
	lw %f2 %a0 12 #897
	fmul %f0 %f0 %f2 #906
	lw %a2 %sp 48 #899
	lw %f2 %a2 0 #899
	fmul %f2 %f0 %f2 #908
	lw %f3 %sp 8 #908
	fadd %f2 %f2 %f3 #908
	sw %f0 %sp 80 #908
	sw %a1 %sp 88 #908
	fadd %f0 %f2 %fzero
	sw %ra %sp 92 #908 call dir
	addi %sp %sp 96 #908	
	jal %ra min_caml_fabs #908
	addi %sp %sp -96 #908
	lw %ra %sp 92 #908
	lw %a0 %sp 52 #908
	sw %f0 %sp 96 #908
	sw %ra %sp 108 #908 call dir
	addi %sp %sp 112 #908	
	jal %ra o_param_a.2300 #908
	addi %sp %sp -112 #908
	lw %ra %sp 108 #908
	fadd %f1 %f0 %fzero #908
	lw %f0 %sp 96 #908
	sw %ra %sp 108 #908 call dir
	addi %sp %sp 112 #908	
	jal %ra min_caml_fless #908
	addi %sp %sp -112 #908
	lw %ra %sp 108 #908
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8540 # nontail if
	lw %a0 %sp 88 #898
	jal %zero beq_cont.8541 # then sentence ends
beq_else.8540:
	lw %a0 %sp 48 #899
	lw %f0 %a0 8 #899
	lw %f1 %sp 80 #909
	fmul %f0 %f1 %f0 #909
	lw %f2 %sp 32 #909
	fadd %f0 %f0 %f2 #909
	sw %ra %sp 108 #909 call dir
	addi %sp %sp 112 #909	
	jal %ra min_caml_fabs #909
	addi %sp %sp -112 #909
	lw %ra %sp 108 #909
	lw %a0 %sp 52 #909
	sw %f0 %sp 104 #909
	sw %ra %sp 116 #909 call dir
	addi %sp %sp 120 #909	
	jal %ra o_param_c.2304 #909
	addi %sp %sp -120 #909
	lw %ra %sp 116 #909
	fadd %f1 %f0 %fzero #909
	lw %f0 %sp 104 #909
	sw %ra %sp 116 #909 call dir
	addi %sp %sp 120 #909	
	jal %ra min_caml_fless #909
	addi %sp %sp -120 #909
	lw %ra %sp 116 #909
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8542 # nontail if
	lw %a0 %sp 88 #898
	jal %zero beq_cont.8543 # then sentence ends
beq_else.8542:
	lw %a0 %sp 24 #897
	lw %f0 %a0 12 #897
	sw %ra %sp 116 #910 call dir
	addi %sp %sp 120 #910	
	jal %ra min_caml_fiszero #910
	addi %sp %sp -120 #910
	lw %ra %sp 116 #910
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8544 # nontail if
	addi %a0 %zero 1 #910
	jal %zero beq_cont.8545 # then sentence ends
beq_else.8544:
	lw %a0 %sp 88 #898
beq_cont.8545:
beq_cont.8543:
beq_cont.8541:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8546
	lw %a0 %sp 24 #897
	lw %f0 %a0 16 #897
	lw %f1 %sp 32 #915
	fsub %f0 %f0 %f1 #915
	lw %f1 %a0 20 #897
	fmul %f0 %f0 %f1 #915
	lw %a1 %sp 48 #899
	lw %f1 %a1 0 #899
	fmul %f1 %f0 %f1 #917
	lw %f2 %sp 8 #917
	fadd %f1 %f1 %f2 #917
	sw %f0 %sp 112 #917
	fadd %f0 %f1 %fzero
	sw %ra %sp 124 #917 call dir
	addi %sp %sp 128 #917	
	jal %ra min_caml_fabs #917
	addi %sp %sp -128 #917
	lw %ra %sp 124 #917
	lw %a0 %sp 52 #917
	sw %f0 %sp 120 #917
	sw %ra %sp 132 #917 call dir
	addi %sp %sp 136 #917	
	jal %ra o_param_a.2300 #917
	addi %sp %sp -136 #917
	lw %ra %sp 132 #917
	fadd %f1 %f0 %fzero #917
	lw %f0 %sp 120 #917
	sw %ra %sp 132 #917 call dir
	addi %sp %sp 136 #917	
	jal %ra min_caml_fless #917
	addi %sp %sp -136 #917
	lw %ra %sp 132 #917
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8547 # nontail if
	lw %a0 %sp 88 #898
	jal %zero beq_cont.8548 # then sentence ends
beq_else.8547:
	lw %a0 %sp 48 #899
	lw %f0 %a0 4 #899
	lw %f1 %sp 112 #918
	fmul %f0 %f1 %f0 #918
	lw %f2 %sp 16 #918
	fadd %f0 %f0 %f2 #918
	sw %ra %sp 132 #918 call dir
	addi %sp %sp 136 #918	
	jal %ra min_caml_fabs #918
	addi %sp %sp -136 #918
	lw %ra %sp 132 #918
	lw %a0 %sp 52 #918
	sw %f0 %sp 128 #918
	sw %ra %sp 140 #918 call dir
	addi %sp %sp 144 #918	
	jal %ra o_param_b.2302 #918
	addi %sp %sp -144 #918
	lw %ra %sp 140 #918
	fadd %f1 %f0 %fzero #918
	lw %f0 %sp 128 #918
	sw %ra %sp 140 #918 call dir
	addi %sp %sp 144 #918	
	jal %ra min_caml_fless #918
	addi %sp %sp -144 #918
	lw %ra %sp 140 #918
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8549 # nontail if
	lw %a0 %sp 88 #898
	jal %zero beq_cont.8550 # then sentence ends
beq_else.8549:
	lw %a0 %sp 24 #897
	lw %f0 %a0 20 #897
	sw %ra %sp 140 #919 call dir
	addi %sp %sp 144 #919	
	jal %ra min_caml_fiszero #919
	addi %sp %sp -144 #919
	lw %ra %sp 140 #919
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8551 # nontail if
	addi %a0 %zero 1 #919
	jal %zero beq_cont.8552 # then sentence ends
beq_else.8551:
	lw %a0 %sp 88 #898
beq_cont.8552:
beq_cont.8550:
beq_cont.8548:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8553
	lw %a0 %sp 88 #898
	jalr %zero %ra 0 #898
beq_else.8553:
	lw %a0 %sp 0 #923
	lw %f0 %sp 112 #923
	sw %f0 %a0 0 #923
	addi %a0 %zero 3 #923
	jalr %zero %ra 0 #923
beq_else.8546:
	lw %a0 %sp 0 #914
	lw %f0 %sp 80 #914
	sw %f0 %a0 0 #914
	addi %a0 %zero 2 #914
	jalr %zero %ra 0 #914
beq_else.8538:
	lw %a0 %sp 0 #905
	lw %f0 %sp 40 #905
	sw %f0 %a0 0 #905
	addi %a0 %zero 1 #905
	jalr %zero %ra 0 #905
solver_surface_fast.2435:
	lw %a0 %a11 4 #929
	lw %f3 %a1 0 #930
	sw %a0 %sp 0 #930
	sw %f2 %sp 8 #930
	sw %f1 %sp 16 #930
	sw %f0 %sp 24 #930
	sw %a1 %sp 32 #930
	fadd %f0 %f3 %fzero
	sw %ra %sp 36 #930 call dir
	addi %sp %sp 40 #930	
	jal %ra min_caml_fisneg #930
	addi %sp %sp -40 #930
	lw %ra %sp 36 #930
	addi %a1 %zero 0 #930
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8555
	addi %a0 %a1 0 #930
	jalr %zero %ra 0 #930
beq_else.8555:
	lw %a0 %sp 32 #930
	lw %f0 %a0 4 #930
	lw %f1 %sp 24 #932
	fmul %f0 %f0 %f1 #932
	lw %f1 %a0 8 #930
	lw %f2 %sp 16 #932
	fmul %f1 %f1 %f2 #932
	fadd %f0 %f0 %f1 #932
	lw %f1 %a0 12 #930
	lw %f2 %sp 8 #932
	fmul %f1 %f1 %f2 #932
	fadd %f0 %f0 %f1 #932
	lw %a0 %sp 0 #931
	sw %f0 %a0 0 #931
	addi %a0 %zero 1 #933
	jalr %zero %ra 0 #933
solver_second_fast.2441:
	lw %a2 %a11 4 #938
	lw %f3 %a1 0 #940
	sw %a2 %sp 0 #941
	sw %f3 %sp 8 #941
	sw %a0 %sp 16 #941
	sw %f2 %sp 24 #941
	sw %f1 %sp 32 #941
	sw %f0 %sp 40 #941
	sw %a1 %sp 48 #941
	fadd %f0 %f3 %fzero
	sw %ra %sp 52 #941 call dir
	addi %sp %sp 56 #941	
	jal %ra min_caml_fiszero #941
	addi %sp %sp -56 #941
	lw %ra %sp 52 #941
	addi %a1 %zero 0 #941
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8558
	lw %a0 %sp 48 #940
	lw %f0 %a0 4 #940
	lw %f1 %sp 40 #944
	fmul %f0 %f0 %f1 #944
	lw %f2 %a0 8 #940
	lw %f3 %sp 32 #944
	fmul %f2 %f2 %f3 #944
	fadd %f0 %f0 %f2 #944
	lw %f2 %a0 12 #940
	lw %f4 %sp 24 #944
	fmul %f2 %f2 %f4 #944
	fadd %f0 %f0 %f2 #944
	lw %a2 %sp 16 #945
	sw %a1 %sp 52 #945
	sw %f0 %sp 56 #945
	add %a0 %a2 %zero
	fadd %f2 %f4 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f3 %fzero
	sw %ra %sp 68 #945 call dir
	addi %sp %sp 72 #945	
	jal %ra quadratic.2405 #945
	addi %sp %sp -72 #945
	lw %ra %sp 68 #945
	lw %a0 %sp 16 #946
	sw %f0 %sp 64 #946
	sw %ra %sp 76 #946 call dir
	addi %sp %sp 80 #946	
	jal %ra o_form.2292 #946
	addi %sp %sp -80 #946
	lw %ra %sp 76 #946
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8559 # nontail if
	li %f0 l.5555 #946
	lw %f1 %sp 64 #946
	fsub %f0 %f1 %f0 #946
	jal %zero beq_cont.8560 # then sentence ends
beq_else.8559:
	lw %f0 %sp 64 #818
beq_cont.8560:
	lw %f1 %sp 56 #947
	sw %f0 %sp 72 #947
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #947 call dir
	addi %sp %sp 88 #947	
	jal %ra min_caml_fsqr #947
	addi %sp %sp -88 #947
	lw %ra %sp 84 #947
	lw %f1 %sp 72 #947
	lw %f2 %sp 8 #947
	fmul %f1 %f2 %f1 #947
	fsub %f0 %f0 %f1 #947
	sw %f0 %sp 80 #948
	sw %ra %sp 92 #948 call dir
	addi %sp %sp 96 #948	
	jal %ra min_caml_fispos #948
	addi %sp %sp -96 #948
	lw %ra %sp 92 #948
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8561
	lw %a0 %sp 52 #941
	jalr %zero %ra 0 #941
beq_else.8561:
	lw %a0 %sp 16 #949
	sw %ra %sp 92 #949 call dir
	addi %sp %sp 96 #949	
	jal %ra o_isinvert.2296 #949
	addi %sp %sp -96 #949
	lw %ra %sp 92 #949
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8562 # nontail if
	lw %f0 %sp 80 #952
	sw %ra %sp 92 #952 call dir
	addi %sp %sp 96 #952	
	jal %ra min_caml_sqrt #952
	addi %sp %sp -96 #952
	lw %ra %sp 92 #952
	lw %f1 %sp 56 #952
	fsub %f0 %f1 %f0 #952
	lw %a0 %sp 48 #940
	lw %f1 %a0 16 #940
	fmul %f0 %f0 %f1 #952
	lw %a0 %sp 0 #952
	sw %f0 %a0 0 #952
	jal %zero beq_cont.8563 # then sentence ends
beq_else.8562:
	lw %f0 %sp 80 #950
	sw %ra %sp 92 #950 call dir
	addi %sp %sp 96 #950	
	jal %ra min_caml_sqrt #950
	addi %sp %sp -96 #950
	lw %ra %sp 92 #950
	lw %f1 %sp 56 #950
	fadd %f0 %f1 %f0 #950
	lw %a0 %sp 48 #940
	lw %f1 %a0 16 #940
	fmul %f0 %f0 %f1 #950
	lw %a0 %sp 0 #950
	sw %f0 %a0 0 #950
beq_cont.8563:
	addi %a0 %zero 1 #953
	jalr %zero %ra 0 #953
beq_else.8558:
	addi %a0 %a1 0 #941
	jalr %zero %ra 0 #941
solver_fast.2447:
	lw %a3 %a11 16 #958
	lw %a4 %a11 12 #958
	lw %a5 %a11 8 #958
	lw %a6 %a11 4 #958
	slli %a7 %a0 2 #19
	add %a12 %a6 %a7 #19
	lw %a6 %a12 0 #19
	lw %f0 %a2 0 #960
	sw %a4 %sp 0 #960
	sw %a3 %sp 4 #960
	sw %a5 %sp 8 #960
	sw %a0 %sp 12 #960
	sw %a1 %sp 16 #960
	sw %a6 %sp 20 #960
	sw %a2 %sp 24 #960
	sw %f0 %sp 32 #960
	add %a0 %a6 %zero
	sw %ra %sp 44 #960 call dir
	addi %sp %sp 48 #960	
	jal %ra o_param_x.2308 #960
	addi %sp %sp -48 #960
	lw %ra %sp 44 #960
	lw %f1 %sp 32 #960
	fsub %f0 %f1 %f0 #960
	lw %a0 %sp 24 #960
	lw %f1 %a0 4 #960
	lw %a1 %sp 20 #961
	sw %f0 %sp 40 #961
	sw %f1 %sp 48 #961
	add %a0 %a1 %zero
	sw %ra %sp 60 #961 call dir
	addi %sp %sp 64 #961	
	jal %ra o_param_y.2310 #961
	addi %sp %sp -64 #961
	lw %ra %sp 60 #961
	lw %f1 %sp 48 #961
	fsub %f0 %f1 %f0 #961
	lw %a0 %sp 24 #960
	lw %f1 %a0 8 #960
	lw %a0 %sp 20 #962
	sw %f0 %sp 56 #962
	sw %f1 %sp 64 #962
	sw %ra %sp 76 #962 call dir
	addi %sp %sp 80 #962	
	jal %ra o_param_z.2312 #962
	addi %sp %sp -80 #962
	lw %ra %sp 76 #962
	lw %f1 %sp 64 #962
	fsub %f0 %f1 %f0 #962
	lw %a0 %sp 16 #963
	sw %f0 %sp 72 #963
	sw %ra %sp 84 #963 call dir
	addi %sp %sp 88 #963	
	jal %ra d_const.2353 #963
	addi %sp %sp -88 #963
	lw %ra %sp 84 #963
	lw %a1 %sp 12 #964
	slli %a1 %a1 2 #964
	add %a12 %a0 %a1 #964
	lw %a0 %a12 0 #964
	lw %a1 %sp 20 #965
	sw %a0 %sp 80 #965
	add %a0 %a1 %zero
	sw %ra %sp 84 #965 call dir
	addi %sp %sp 88 #965	
	jal %ra o_form.2292 #965
	addi %sp %sp -88 #965
	lw %ra %sp 84 #965
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8565
	lw %a0 %sp 16 #967
	sw %ra %sp 84 #967 call dir
	addi %sp %sp 88 #967	
	jal %ra d_vec.2351 #967
	addi %sp %sp -88 #967
	lw %ra %sp 84 #967
	add %a1 %a0 %zero #967
	lw %f0 %sp 40 #967
	lw %f1 %sp 56 #967
	lw %f2 %sp 72 #967
	lw %a0 %sp 20 #967
	lw %a2 %sp 80 #967
	lw %a11 %sp 8 #967
	lw %a10 %a11 0 #967
	jalr %zero %a10 0 #967
beq_else.8565:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8566
	lw %f0 %sp 40 #969
	lw %f1 %sp 56 #969
	lw %f2 %sp 72 #969
	lw %a0 %sp 20 #969
	lw %a1 %sp 80 #969
	lw %a11 %sp 4 #969
	lw %a10 %a11 0 #969
	jalr %zero %a10 0 #969
beq_else.8566:
	lw %f0 %sp 40 #971
	lw %f1 %sp 56 #971
	lw %f2 %sp 72 #971
	lw %a0 %sp 20 #971
	lw %a1 %sp 80 #971
	lw %a11 %sp 0 #971
	lw %a10 %a11 0 #971
	jalr %zero %a10 0 #971
solver_surface_fast2.2451:
	lw %a0 %a11 4 #978
	lw %f0 %a1 0 #979
	sw %a0 %sp 0 #979
	sw %a2 %sp 4 #979
	sw %a1 %sp 8 #979
	sw %ra %sp 12 #979 call dir
	addi %sp %sp 16 #979	
	jal %ra min_caml_fisneg #979
	addi %sp %sp -16 #979
	lw %ra %sp 12 #979
	addi %a1 %zero 0 #979
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8567
	addi %a0 %a1 0 #979
	jalr %zero %ra 0 #979
beq_else.8567:
	lw %a0 %sp 8 #979
	lw %f0 %a0 0 #979
	lw %a0 %sp 4 #980
	lw %f1 %a0 12 #980
	fmul %f0 %f0 %f1 #980
	lw %a0 %sp 0 #980
	sw %f0 %a0 0 #980
	addi %a0 %zero 1 #981
	jalr %zero %ra 0 #981
solver_second_fast2.2458:
	lw %a3 %a11 4 #986
	lw %f3 %a1 0 #988
	sw %a3 %sp 0 #989
	sw %a0 %sp 4 #989
	sw %f3 %sp 8 #989
	sw %a2 %sp 16 #989
	sw %f2 %sp 24 #989
	sw %f1 %sp 32 #989
	sw %f0 %sp 40 #989
	sw %a1 %sp 48 #989
	fadd %f0 %f3 %fzero
	sw %ra %sp 52 #989 call dir
	addi %sp %sp 56 #989	
	jal %ra min_caml_fiszero #989
	addi %sp %sp -56 #989
	lw %ra %sp 52 #989
	addi %a1 %zero 0 #989
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8569
	lw %a0 %sp 48 #988
	lw %f0 %a0 4 #988
	lw %f1 %sp 40 #992
	fmul %f0 %f0 %f1 #992
	lw %f1 %a0 8 #988
	lw %f2 %sp 32 #992
	fmul %f1 %f1 %f2 #992
	fadd %f0 %f0 %f1 #992
	lw %f1 %a0 12 #988
	lw %f2 %sp 24 #992
	fmul %f1 %f1 %f2 #992
	fadd %f0 %f0 %f1 #992
	lw %a2 %sp 16 #993
	lw %f1 %a2 12 #993
	sw %f0 %sp 56 #994
	sw %a1 %sp 64 #994
	sw %f1 %sp 72 #994
	sw %ra %sp 84 #994 call dir
	addi %sp %sp 88 #994	
	jal %ra min_caml_fsqr #994
	addi %sp %sp -88 #994
	lw %ra %sp 84 #994
	lw %f1 %sp 72 #994
	lw %f2 %sp 8 #994
	fmul %f1 %f2 %f1 #994
	fsub %f0 %f0 %f1 #994
	sw %f0 %sp 80 #995
	sw %ra %sp 92 #995 call dir
	addi %sp %sp 96 #995	
	jal %ra min_caml_fispos #995
	addi %sp %sp -96 #995
	lw %ra %sp 92 #995
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8572
	lw %a0 %sp 64 #989
	jalr %zero %ra 0 #989
beq_else.8572:
	lw %a0 %sp 4 #996
	sw %ra %sp 92 #996 call dir
	addi %sp %sp 96 #996	
	jal %ra o_isinvert.2296 #996
	addi %sp %sp -96 #996
	lw %ra %sp 92 #996
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8573 # nontail if
	lw %f0 %sp 80 #999
	sw %ra %sp 92 #999 call dir
	addi %sp %sp 96 #999	
	jal %ra min_caml_sqrt #999
	addi %sp %sp -96 #999
	lw %ra %sp 92 #999
	lw %f1 %sp 56 #999
	fsub %f0 %f1 %f0 #999
	lw %a0 %sp 48 #988
	lw %f1 %a0 16 #988
	fmul %f0 %f0 %f1 #999
	lw %a0 %sp 0 #999
	sw %f0 %a0 0 #999
	jal %zero beq_cont.8574 # then sentence ends
beq_else.8573:
	lw %f0 %sp 80 #997
	sw %ra %sp 92 #997 call dir
	addi %sp %sp 96 #997	
	jal %ra min_caml_sqrt #997
	addi %sp %sp -96 #997
	lw %ra %sp 92 #997
	lw %f1 %sp 56 #997
	fadd %f0 %f1 %f0 #997
	lw %a0 %sp 48 #988
	lw %f1 %a0 16 #988
	fmul %f0 %f0 %f1 #997
	lw %a0 %sp 0 #997
	sw %f0 %a0 0 #997
beq_cont.8574:
	addi %a0 %zero 1 #1000
	jalr %zero %ra 0 #1000
beq_else.8569:
	addi %a0 %a1 0 #989
	jalr %zero %ra 0 #989
solver_fast2.2465:
	lw %a2 %a11 16 #1005
	lw %a3 %a11 12 #1005
	lw %a4 %a11 8 #1005
	lw %a5 %a11 4 #1005
	slli %a6 %a0 2 #19
	add %a12 %a5 %a6 #19
	lw %a5 %a12 0 #19
	sw %a3 %sp 0 #1007
	sw %a2 %sp 4 #1007
	sw %a4 %sp 8 #1007
	sw %a5 %sp 12 #1007
	sw %a0 %sp 16 #1007
	sw %a1 %sp 20 #1007
	add %a0 %a5 %zero
	sw %ra %sp 28 #1007 call dir
	addi %sp %sp 32 #1007	
	jal %ra o_param_ctbl.2330 #1007
	addi %sp %sp -32 #1007
	lw %ra %sp 28 #1007
	lw %f0 %a0 0 #18
	lw %f1 %a0 4 #18
	lw %f2 %a0 8 #18
	lw %a1 %sp 20 #1011
	sw %a0 %sp 24 #1011
	sw %f2 %sp 32 #1011
	sw %f1 %sp 40 #1011
	sw %f0 %sp 48 #1011
	add %a0 %a1 %zero
	sw %ra %sp 60 #1011 call dir
	addi %sp %sp 64 #1011	
	jal %ra d_const.2353 #1011
	addi %sp %sp -64 #1011
	lw %ra %sp 60 #1011
	lw %a1 %sp 16 #964
	slli %a1 %a1 2 #964
	add %a12 %a0 %a1 #964
	lw %a0 %a12 0 #964
	lw %a1 %sp 12 #1013
	sw %a0 %sp 56 #1013
	add %a0 %a1 %zero
	sw %ra %sp 60 #1013 call dir
	addi %sp %sp 64 #1013	
	jal %ra o_form.2292 #1013
	addi %sp %sp -64 #1013
	lw %ra %sp 60 #1013
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8576
	lw %a0 %sp 20 #1015
	sw %ra %sp 60 #1015 call dir
	addi %sp %sp 64 #1015	
	jal %ra d_vec.2351 #1015
	addi %sp %sp -64 #1015
	lw %ra %sp 60 #1015
	add %a1 %a0 %zero #1015
	lw %f0 %sp 48 #1015
	lw %f1 %sp 40 #1015
	lw %f2 %sp 32 #1015
	lw %a0 %sp 12 #1015
	lw %a2 %sp 56 #1015
	lw %a11 %sp 8 #1015
	lw %a10 %a11 0 #1015
	jalr %zero %a10 0 #1015
beq_else.8576:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8577
	lw %f0 %sp 48 #1017
	lw %f1 %sp 40 #1017
	lw %f2 %sp 32 #1017
	lw %a0 %sp 12 #1017
	lw %a1 %sp 56 #1017
	lw %a2 %sp 24 #1017
	lw %a11 %sp 4 #1017
	lw %a10 %a11 0 #1017
	jalr %zero %a10 0 #1017
beq_else.8577:
	lw %f0 %sp 48 #1019
	lw %f1 %sp 40 #1019
	lw %f2 %sp 32 #1019
	lw %a0 %sp 12 #1019
	lw %a1 %sp 56 #1019
	lw %a2 %sp 24 #1019
	lw %a11 %sp 0 #1019
	lw %a10 %a11 0 #1019
	jalr %zero %a10 0 #1019
setup_rect_table.2468:
	addi %a2 %zero 6 #1026
	li %f0 l.5553 #1026
	sw %a1 %sp 0 #1026
	sw %a0 %sp 4 #1026
	add %a0 %a2 %zero
	sw %ra %sp 12 #1026 call dir
	addi %sp %sp 16 #1026	
	jal %ra min_caml_create_float_array #1026
	addi %sp %sp -16 #1026
	lw %ra %sp 12 #1026
	lw %a1 %sp 4 #1028
	lw %f0 %a1 0 #1028
	sw %a0 %sp 8 #1028
	sw %ra %sp 12 #1028 call dir
	addi %sp %sp 16 #1028	
	jal %ra min_caml_fiszero #1028
	addi %sp %sp -16 #1028
	lw %ra %sp 12 #1028
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8578 # nontail if
	lw %a0 %sp 0 #1032
	sw %ra %sp 12 #1032 call dir
	addi %sp %sp 16 #1032	
	jal %ra o_isinvert.2296 #1032
	addi %sp %sp -16 #1032
	lw %ra %sp 12 #1032
	lw %a1 %sp 4 #1028
	lw %f0 %a1 0 #1028
	sw %a0 %sp 12 #1032
	sw %ra %sp 20 #1032 call dir
	addi %sp %sp 24 #1032	
	jal %ra min_caml_fisneg #1032
	addi %sp %sp -24 #1032
	lw %ra %sp 20 #1032
	add %a1 %a0 %zero #1032
	lw %a0 %sp 12 #1032
	sw %ra %sp 20 #1032 call dir
	addi %sp %sp 24 #1032	
	jal %ra xor.2233 #1032
	addi %sp %sp -24 #1032
	lw %ra %sp 20 #1032
	lw %a1 %sp 0 #1032
	sw %a0 %sp 16 #1032
	add %a0 %a1 %zero
	sw %ra %sp 20 #1032 call dir
	addi %sp %sp 24 #1032	
	jal %ra o_param_a.2300 #1032
	addi %sp %sp -24 #1032
	lw %ra %sp 20 #1032
	lw %a0 %sp 16 #1032
	sw %ra %sp 20 #1032 call dir
	addi %sp %sp 24 #1032	
	jal %ra fneg_cond.2238 #1032
	addi %sp %sp -24 #1032
	lw %ra %sp 20 #1032
	lw %a0 %sp 8 #1032
	sw %f0 %a0 0 #1032
	li %f0 l.5555 #1034
	lw %a1 %sp 4 #1028
	lw %f1 %a1 0 #1028
	fdiv %f0 %f0 %f1 #1034
	sw %f0 %a0 4 #1034
	jal %zero beq_cont.8579 # then sentence ends
beq_else.8578:
	li %f0 l.5553 #1029
	lw %a0 %sp 8 #1029
	sw %f0 %a0 4 #1029
beq_cont.8579:
	lw %a1 %sp 4 #1028
	lw %f0 %a1 4 #1028
	sw %ra %sp 20 #1036 call dir
	addi %sp %sp 24 #1036	
	jal %ra min_caml_fiszero #1036
	addi %sp %sp -24 #1036
	lw %ra %sp 20 #1036
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8580 # nontail if
	lw %a0 %sp 0 #1039
	sw %ra %sp 20 #1039 call dir
	addi %sp %sp 24 #1039	
	jal %ra o_isinvert.2296 #1039
	addi %sp %sp -24 #1039
	lw %ra %sp 20 #1039
	lw %a1 %sp 4 #1028
	lw %f0 %a1 4 #1028
	sw %a0 %sp 20 #1039
	sw %ra %sp 28 #1039 call dir
	addi %sp %sp 32 #1039	
	jal %ra min_caml_fisneg #1039
	addi %sp %sp -32 #1039
	lw %ra %sp 28 #1039
	add %a1 %a0 %zero #1039
	lw %a0 %sp 20 #1039
	sw %ra %sp 28 #1039 call dir
	addi %sp %sp 32 #1039	
	jal %ra xor.2233 #1039
	addi %sp %sp -32 #1039
	lw %ra %sp 28 #1039
	lw %a1 %sp 0 #1039
	sw %a0 %sp 24 #1039
	add %a0 %a1 %zero
	sw %ra %sp 28 #1039 call dir
	addi %sp %sp 32 #1039	
	jal %ra o_param_b.2302 #1039
	addi %sp %sp -32 #1039
	lw %ra %sp 28 #1039
	lw %a0 %sp 24 #1039
	sw %ra %sp 28 #1039 call dir
	addi %sp %sp 32 #1039	
	jal %ra fneg_cond.2238 #1039
	addi %sp %sp -32 #1039
	lw %ra %sp 28 #1039
	lw %a0 %sp 8 #1039
	sw %f0 %a0 8 #1039
	li %f0 l.5555 #1040
	lw %a1 %sp 4 #1028
	lw %f1 %a1 4 #1028
	fdiv %f0 %f0 %f1 #1040
	sw %f0 %a0 12 #1040
	jal %zero beq_cont.8581 # then sentence ends
beq_else.8580:
	li %f0 l.5553 #1037
	lw %a0 %sp 8 #1037
	sw %f0 %a0 12 #1037
beq_cont.8581:
	lw %a1 %sp 4 #1028
	lw %f0 %a1 8 #1028
	sw %ra %sp 28 #1042 call dir
	addi %sp %sp 32 #1042	
	jal %ra min_caml_fiszero #1042
	addi %sp %sp -32 #1042
	lw %ra %sp 28 #1042
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8582 # nontail if
	lw %a0 %sp 0 #1045
	sw %ra %sp 28 #1045 call dir
	addi %sp %sp 32 #1045	
	jal %ra o_isinvert.2296 #1045
	addi %sp %sp -32 #1045
	lw %ra %sp 28 #1045
	lw %a1 %sp 4 #1028
	lw %f0 %a1 8 #1028
	sw %a0 %sp 28 #1045
	sw %ra %sp 36 #1045 call dir
	addi %sp %sp 40 #1045	
	jal %ra min_caml_fisneg #1045
	addi %sp %sp -40 #1045
	lw %ra %sp 36 #1045
	add %a1 %a0 %zero #1045
	lw %a0 %sp 28 #1045
	sw %ra %sp 36 #1045 call dir
	addi %sp %sp 40 #1045	
	jal %ra xor.2233 #1045
	addi %sp %sp -40 #1045
	lw %ra %sp 36 #1045
	lw %a1 %sp 0 #1045
	sw %a0 %sp 32 #1045
	add %a0 %a1 %zero
	sw %ra %sp 36 #1045 call dir
	addi %sp %sp 40 #1045	
	jal %ra o_param_c.2304 #1045
	addi %sp %sp -40 #1045
	lw %ra %sp 36 #1045
	lw %a0 %sp 32 #1045
	sw %ra %sp 36 #1045 call dir
	addi %sp %sp 40 #1045	
	jal %ra fneg_cond.2238 #1045
	addi %sp %sp -40 #1045
	lw %ra %sp 36 #1045
	lw %a0 %sp 8 #1045
	sw %f0 %a0 16 #1045
	li %f0 l.5555 #1046
	lw %a1 %sp 4 #1028
	lw %f1 %a1 8 #1028
	fdiv %f0 %f0 %f1 #1046
	sw %f0 %a0 20 #1046
	jal %zero beq_cont.8583 # then sentence ends
beq_else.8582:
	li %f0 l.5553 #1043
	lw %a0 %sp 8 #1043
	sw %f0 %a0 20 #1043
beq_cont.8583:
	jalr %zero %ra 0 #1048
setup_surface_table.2471:
	addi %a2 %zero 4 #1053
	li %f0 l.5553 #1053
	sw %a1 %sp 0 #1053
	sw %a0 %sp 4 #1053
	add %a0 %a2 %zero
	sw %ra %sp 12 #1053 call dir
	addi %sp %sp 16 #1053	
	jal %ra min_caml_create_float_array #1053
	addi %sp %sp -16 #1053
	lw %ra %sp 12 #1053
	lw %a1 %sp 4 #1055
	lw %f0 %a1 0 #1055
	lw %a2 %sp 0 #1055
	sw %a0 %sp 8 #1055
	sw %f0 %sp 16 #1055
	add %a0 %a2 %zero
	sw %ra %sp 28 #1055 call dir
	addi %sp %sp 32 #1055	
	jal %ra o_param_a.2300 #1055
	addi %sp %sp -32 #1055
	lw %ra %sp 28 #1055
	lw %f1 %sp 16 #1055
	fmul %f0 %f1 %f0 #1055
	lw %a0 %sp 4 #1055
	lw %f1 %a0 4 #1055
	lw %a1 %sp 0 #1055
	sw %f0 %sp 24 #1055
	sw %f1 %sp 32 #1055
	add %a0 %a1 %zero
	sw %ra %sp 44 #1055 call dir
	addi %sp %sp 48 #1055	
	jal %ra o_param_b.2302 #1055
	addi %sp %sp -48 #1055
	lw %ra %sp 44 #1055
	lw %f1 %sp 32 #1055
	fmul %f0 %f1 %f0 #1055
	lw %f1 %sp 24 #1055
	fadd %f0 %f1 %f0 #1055
	lw %a0 %sp 4 #1055
	lw %f1 %a0 8 #1055
	lw %a0 %sp 0 #1055
	sw %f0 %sp 40 #1055
	sw %f1 %sp 48 #1055
	sw %ra %sp 60 #1055 call dir
	addi %sp %sp 64 #1055	
	jal %ra o_param_c.2304 #1055
	addi %sp %sp -64 #1055
	lw %ra %sp 60 #1055
	lw %f1 %sp 48 #1055
	fmul %f0 %f1 %f0 #1055
	lw %f1 %sp 40 #1055
	fadd %f0 %f1 %f0 #1055
	sw %f0 %sp 56 #1057
	sw %ra %sp 68 #1057 call dir
	addi %sp %sp 72 #1057	
	jal %ra min_caml_fispos #1057
	addi %sp %sp -72 #1057
	lw %ra %sp 68 #1057
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8585 # nontail if
	li %f0 l.5553 #1065
	lw %a0 %sp 8 #1065
	sw %f0 %a0 0 #1065
	jal %zero beq_cont.8586 # then sentence ends
beq_else.8585:
	li %f0 l.5557 #1059
	lw %f1 %sp 56 #1059
	fdiv %f0 %f0 %f1 #1059
	lw %a0 %sp 8 #1059
	sw %f0 %a0 0 #1059
	lw %a1 %sp 0 #1061
	add %a0 %a1 %zero
	sw %ra %sp 68 #1061 call dir
	addi %sp %sp 72 #1061	
	jal %ra o_param_a.2300 #1061
	addi %sp %sp -72 #1061
	lw %ra %sp 68 #1061
	lw %f1 %sp 56 #1061
	fdiv %f0 %f0 %f1 #1061
	sw %ra %sp 68 #1061 call dir
	addi %sp %sp 72 #1061	
	jal %ra min_caml_fneg #1061
	addi %sp %sp -72 #1061
	lw %ra %sp 68 #1061
	lw %a0 %sp 8 #1061
	sw %f0 %a0 4 #1061
	lw %a1 %sp 0 #1062
	add %a0 %a1 %zero
	sw %ra %sp 68 #1062 call dir
	addi %sp %sp 72 #1062	
	jal %ra o_param_b.2302 #1062
	addi %sp %sp -72 #1062
	lw %ra %sp 68 #1062
	lw %f1 %sp 56 #1062
	fdiv %f0 %f0 %f1 #1062
	sw %ra %sp 68 #1062 call dir
	addi %sp %sp 72 #1062	
	jal %ra min_caml_fneg #1062
	addi %sp %sp -72 #1062
	lw %ra %sp 68 #1062
	lw %a0 %sp 8 #1062
	sw %f0 %a0 8 #1062
	lw %a1 %sp 0 #1063
	add %a0 %a1 %zero
	sw %ra %sp 68 #1063 call dir
	addi %sp %sp 72 #1063	
	jal %ra o_param_c.2304 #1063
	addi %sp %sp -72 #1063
	lw %ra %sp 68 #1063
	lw %f1 %sp 56 #1063
	fdiv %f0 %f0 %f1 #1063
	sw %ra %sp 68 #1063 call dir
	addi %sp %sp 72 #1063	
	jal %ra min_caml_fneg #1063
	addi %sp %sp -72 #1063
	lw %ra %sp 68 #1063
	lw %a0 %sp 8 #1063
	sw %f0 %a0 12 #1063
beq_cont.8586:
	jalr %zero %ra 0 #1066
setup_second_table.2474:
	addi %a2 %zero 5 #1072
	li %f0 l.5553 #1072
	sw %a1 %sp 0 #1072
	sw %a0 %sp 4 #1072
	add %a0 %a2 %zero
	sw %ra %sp 12 #1072 call dir
	addi %sp %sp 16 #1072	
	jal %ra min_caml_create_float_array #1072
	addi %sp %sp -16 #1072
	lw %ra %sp 12 #1072
	lw %a1 %sp 4 #1074
	lw %f0 %a1 0 #1074
	lw %f1 %a1 4 #1074
	lw %f2 %a1 8 #1074
	lw %a2 %sp 0 #1074
	sw %a0 %sp 8 #1074
	add %a0 %a2 %zero
	sw %ra %sp 12 #1074 call dir
	addi %sp %sp 16 #1074	
	jal %ra quadratic.2405 #1074
	addi %sp %sp -16 #1074
	lw %ra %sp 12 #1074
	lw %a0 %sp 4 #1074
	lw %f1 %a0 0 #1074
	lw %a1 %sp 0 #1075
	sw %f0 %sp 16 #1075
	sw %f1 %sp 24 #1075
	add %a0 %a1 %zero
	sw %ra %sp 36 #1075 call dir
	addi %sp %sp 40 #1075	
	jal %ra o_param_a.2300 #1075
	addi %sp %sp -40 #1075
	lw %ra %sp 36 #1075
	lw %f1 %sp 24 #1075
	fmul %f0 %f1 %f0 #1075
	sw %ra %sp 36 #1075 call dir
	addi %sp %sp 40 #1075	
	jal %ra min_caml_fneg #1075
	addi %sp %sp -40 #1075
	lw %ra %sp 36 #1075
	lw %a0 %sp 4 #1074
	lw %f1 %a0 4 #1074
	lw %a1 %sp 0 #1076
	sw %f0 %sp 32 #1076
	sw %f1 %sp 40 #1076
	add %a0 %a1 %zero
	sw %ra %sp 52 #1076 call dir
	addi %sp %sp 56 #1076	
	jal %ra o_param_b.2302 #1076
	addi %sp %sp -56 #1076
	lw %ra %sp 52 #1076
	lw %f1 %sp 40 #1076
	fmul %f0 %f1 %f0 #1076
	sw %ra %sp 52 #1076 call dir
	addi %sp %sp 56 #1076	
	jal %ra min_caml_fneg #1076
	addi %sp %sp -56 #1076
	lw %ra %sp 52 #1076
	lw %a0 %sp 4 #1074
	lw %f1 %a0 8 #1074
	lw %a1 %sp 0 #1077
	sw %f0 %sp 48 #1077
	sw %f1 %sp 56 #1077
	add %a0 %a1 %zero
	sw %ra %sp 68 #1077 call dir
	addi %sp %sp 72 #1077	
	jal %ra o_param_c.2304 #1077
	addi %sp %sp -72 #1077
	lw %ra %sp 68 #1077
	lw %f1 %sp 56 #1077
	fmul %f0 %f1 %f0 #1077
	sw %ra %sp 68 #1077 call dir
	addi %sp %sp 72 #1077	
	jal %ra min_caml_fneg #1077
	addi %sp %sp -72 #1077
	lw %ra %sp 68 #1077
	lw %a0 %sp 8 #1079
	lw %f1 %sp 16 #1079
	sw %f1 %a0 0 #1079
	lw %a1 %sp 0 #1082
	sw %f0 %sp 64 #1082
	add %a0 %a1 %zero
	sw %ra %sp 76 #1082 call dir
	addi %sp %sp 80 #1082	
	jal %ra o_isrot.2298 #1082
	addi %sp %sp -80 #1082
	lw %ra %sp 76 #1082
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8588 # nontail if
	lw %a0 %sp 8 #1087
	lw %f0 %sp 32 #1087
	sw %f0 %a0 4 #1087
	lw %f0 %sp 48 #1088
	sw %f0 %a0 8 #1088
	lw %f0 %sp 64 #1089
	sw %f0 %a0 12 #1089
	jal %zero beq_cont.8589 # then sentence ends
beq_else.8588:
	lw %a0 %sp 4 #1074
	lw %f0 %a0 8 #1074
	lw %a1 %sp 0 #1083
	sw %f0 %sp 72 #1083
	add %a0 %a1 %zero
	sw %ra %sp 84 #1083 call dir
	addi %sp %sp 88 #1083	
	jal %ra o_param_r2.2326 #1083
	addi %sp %sp -88 #1083
	lw %ra %sp 84 #1083
	lw %f1 %sp 72 #1083
	fmul %f0 %f1 %f0 #1083
	lw %a0 %sp 4 #1074
	lw %f1 %a0 4 #1074
	lw %a1 %sp 0 #1083
	sw %f0 %sp 80 #1083
	sw %f1 %sp 88 #1083
	add %a0 %a1 %zero
	sw %ra %sp 100 #1083 call dir
	addi %sp %sp 104 #1083	
	jal %ra o_param_r3.2328 #1083
	addi %sp %sp -104 #1083
	lw %ra %sp 100 #1083
	lw %f1 %sp 88 #1083
	fmul %f0 %f1 %f0 #1083
	lw %f1 %sp 80 #1083
	fadd %f0 %f1 %f0 #1083
	sw %ra %sp 100 #1083 call dir
	addi %sp %sp 104 #1083	
	jal %ra min_caml_fhalf #1083
	addi %sp %sp -104 #1083
	lw %ra %sp 100 #1083
	lw %f1 %sp 32 #1083
	fsub %f0 %f1 %f0 #1083
	lw %a0 %sp 8 #1083
	sw %f0 %a0 4 #1083
	lw %a1 %sp 4 #1074
	lw %f0 %a1 8 #1074
	lw %a2 %sp 0 #1084
	sw %f0 %sp 96 #1084
	add %a0 %a2 %zero
	sw %ra %sp 108 #1084 call dir
	addi %sp %sp 112 #1084	
	jal %ra o_param_r1.2324 #1084
	addi %sp %sp -112 #1084
	lw %ra %sp 108 #1084
	lw %f1 %sp 96 #1084
	fmul %f0 %f1 %f0 #1084
	lw %a0 %sp 4 #1074
	lw %f1 %a0 0 #1074
	lw %a1 %sp 0 #1084
	sw %f0 %sp 104 #1084
	sw %f1 %sp 112 #1084
	add %a0 %a1 %zero
	sw %ra %sp 124 #1084 call dir
	addi %sp %sp 128 #1084	
	jal %ra o_param_r3.2328 #1084
	addi %sp %sp -128 #1084
	lw %ra %sp 124 #1084
	lw %f1 %sp 112 #1084
	fmul %f0 %f1 %f0 #1084
	lw %f1 %sp 104 #1084
	fadd %f0 %f1 %f0 #1084
	sw %ra %sp 124 #1084 call dir
	addi %sp %sp 128 #1084	
	jal %ra min_caml_fhalf #1084
	addi %sp %sp -128 #1084
	lw %ra %sp 124 #1084
	lw %f1 %sp 48 #1084
	fsub %f0 %f1 %f0 #1084
	lw %a0 %sp 8 #1084
	sw %f0 %a0 8 #1084
	lw %a1 %sp 4 #1074
	lw %f0 %a1 4 #1074
	lw %a2 %sp 0 #1085
	sw %f0 %sp 120 #1085
	add %a0 %a2 %zero
	sw %ra %sp 132 #1085 call dir
	addi %sp %sp 136 #1085	
	jal %ra o_param_r1.2324 #1085
	addi %sp %sp -136 #1085
	lw %ra %sp 132 #1085
	lw %f1 %sp 120 #1085
	fmul %f0 %f1 %f0 #1085
	lw %a0 %sp 4 #1074
	lw %f1 %a0 0 #1074
	lw %a0 %sp 0 #1085
	sw %f0 %sp 128 #1085
	sw %f1 %sp 136 #1085
	sw %ra %sp 148 #1085 call dir
	addi %sp %sp 152 #1085	
	jal %ra o_param_r2.2326 #1085
	addi %sp %sp -152 #1085
	lw %ra %sp 148 #1085
	lw %f1 %sp 136 #1085
	fmul %f0 %f1 %f0 #1085
	lw %f1 %sp 128 #1085
	fadd %f0 %f1 %f0 #1085
	sw %ra %sp 148 #1085 call dir
	addi %sp %sp 152 #1085	
	jal %ra min_caml_fhalf #1085
	addi %sp %sp -152 #1085
	lw %ra %sp 148 #1085
	lw %f1 %sp 64 #1085
	fsub %f0 %f1 %f0 #1085
	lw %a0 %sp 8 #1085
	sw %f0 %a0 12 #1085
beq_cont.8589:
	lw %f0 %sp 16 #1091
	sw %ra %sp 148 #1091 call dir
	addi %sp %sp 152 #1091	
	jal %ra min_caml_fiszero #1091
	addi %sp %sp -152 #1091
	lw %ra %sp 148 #1091
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8590 # nontail if
	li %f0 l.5555 #1092
	lw %f1 %sp 16 #1092
	fdiv %f0 %f0 %f1 #1092
	lw %a0 %sp 8 #1092
	sw %f0 %a0 16 #1092
	jal %zero beq_cont.8591 # then sentence ends
beq_else.8590:
beq_cont.8591:
	lw %a0 %sp 8 #1094
	jalr %zero %ra 0 #1094
iter_setup_dirvec_constants.2477:
	lw %a2 %a11 4 #1099
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8592
	slli %a3 %a1 2 #19
	add %a12 %a2 %a3 #19
	lw %a2 %a12 0 #19
	sw %a11 %sp 0 #1102
	sw %a1 %sp 4 #1102
	sw %a2 %sp 8 #1102
	sw %a0 %sp 12 #1102
	sw %ra %sp 20 #1102 call dir
	addi %sp %sp 24 #1102	
	jal %ra d_const.2353 #1102
	addi %sp %sp -24 #1102
	lw %ra %sp 20 #1102
	lw %a1 %sp 12 #1103
	sw %a0 %sp 16 #1103
	add %a0 %a1 %zero
	sw %ra %sp 20 #1103 call dir
	addi %sp %sp 24 #1103	
	jal %ra d_vec.2351 #1103
	addi %sp %sp -24 #1103
	lw %ra %sp 20 #1103
	lw %a1 %sp 8 #1104
	sw %a0 %sp 20 #1104
	add %a0 %a1 %zero
	sw %ra %sp 28 #1104 call dir
	addi %sp %sp 32 #1104	
	jal %ra o_form.2292 #1104
	addi %sp %sp -32 #1104
	lw %ra %sp 28 #1104
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8593 # nontail if
	lw %a0 %sp 20 #1106
	lw %a1 %sp 8 #1106
	sw %ra %sp 28 #1106 call dir
	addi %sp %sp 32 #1106	
	jal %ra setup_rect_table.2468 #1106
	addi %sp %sp -32 #1106
	lw %ra %sp 28 #1106
	lw %a1 %sp 4 #1106
	slli %a2 %a1 2 #1106
	lw %a3 %sp 16 #1106
	add %a12 %a3 %a2 #1106
	sw %a0 %a12 0 #1106
	jal %zero beq_cont.8594 # then sentence ends
beq_else.8593:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8595 # nontail if
	lw %a0 %sp 20 #1108
	lw %a1 %sp 8 #1108
	sw %ra %sp 28 #1108 call dir
	addi %sp %sp 32 #1108	
	jal %ra setup_surface_table.2471 #1108
	addi %sp %sp -32 #1108
	lw %ra %sp 28 #1108
	lw %a1 %sp 4 #1108
	slli %a2 %a1 2 #1108
	lw %a3 %sp 16 #1108
	add %a12 %a3 %a2 #1108
	sw %a0 %a12 0 #1108
	jal %zero beq_cont.8596 # then sentence ends
beq_else.8595:
	lw %a0 %sp 20 #1110
	lw %a1 %sp 8 #1110
	sw %ra %sp 28 #1110 call dir
	addi %sp %sp 32 #1110	
	jal %ra setup_second_table.2474 #1110
	addi %sp %sp -32 #1110
	lw %ra %sp 28 #1110
	lw %a1 %sp 4 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 16 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
beq_cont.8596:
beq_cont.8594:
	addi %a1 %a1 -1 #1112
	lw %a0 %sp 12 #1112
	lw %a11 %sp 0 #1112
	lw %a10 %a11 0 #1112
	jalr %zero %a10 0 #1112
bge_else.8592:
	jalr %zero %ra 0 #1113
setup_dirvec_constants.2480:
	lw %a1 %a11 8 #1116
	lw %a11 %a11 4 #1116
	lw %a1 %a1 0 #14
	addi %a1 %a1 -1 #1117
	lw %a10 %a11 0 #1117
	jalr %zero %a10 0 #1117
setup_startp_constants.2482:
	lw %a2 %a11 4 #1122
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8598
	slli %a3 %a1 2 #19
	add %a12 %a2 %a3 #19
	lw %a2 %a12 0 #19
	sw %a11 %sp 0 #1125
	sw %a1 %sp 4 #1125
	sw %a0 %sp 8 #1125
	sw %a2 %sp 12 #1125
	add %a0 %a2 %zero
	sw %ra %sp 20 #1125 call dir
	addi %sp %sp 24 #1125	
	jal %ra o_param_ctbl.2330 #1125
	addi %sp %sp -24 #1125
	lw %ra %sp 20 #1125
	lw %a1 %sp 12 #1126
	sw %a0 %sp 16 #1126
	add %a0 %a1 %zero
	sw %ra %sp 20 #1126 call dir
	addi %sp %sp 24 #1126	
	jal %ra o_form.2292 #1126
	addi %sp %sp -24 #1126
	lw %ra %sp 20 #1126
	lw %a1 %sp 8 #1127
	lw %f0 %a1 0 #1127
	lw %a2 %sp 12 #1127
	sw %a0 %sp 20 #1127
	sw %f0 %sp 24 #1127
	add %a0 %a2 %zero
	sw %ra %sp 36 #1127 call dir
	addi %sp %sp 40 #1127	
	jal %ra o_param_x.2308 #1127
	addi %sp %sp -40 #1127
	lw %ra %sp 36 #1127
	lw %f1 %sp 24 #1127
	fsub %f0 %f1 %f0 #1127
	lw %a0 %sp 16 #1127
	sw %f0 %a0 0 #1127
	lw %a1 %sp 8 #1127
	lw %f0 %a1 4 #1127
	lw %a2 %sp 12 #1128
	sw %f0 %sp 32 #1128
	add %a0 %a2 %zero
	sw %ra %sp 44 #1128 call dir
	addi %sp %sp 48 #1128	
	jal %ra o_param_y.2310 #1128
	addi %sp %sp -48 #1128
	lw %ra %sp 44 #1128
	lw %f1 %sp 32 #1128
	fsub %f0 %f1 %f0 #1128
	lw %a0 %sp 16 #1128
	sw %f0 %a0 4 #1128
	lw %a1 %sp 8 #1127
	lw %f0 %a1 8 #1127
	lw %a2 %sp 12 #1129
	sw %f0 %sp 40 #1129
	add %a0 %a2 %zero
	sw %ra %sp 52 #1129 call dir
	addi %sp %sp 56 #1129	
	jal %ra o_param_z.2312 #1129
	addi %sp %sp -56 #1129
	lw %ra %sp 52 #1129
	lw %f1 %sp 40 #1129
	fsub %f0 %f1 %f0 #1129
	lw %a0 %sp 16 #1129
	sw %f0 %a0 8 #1129
	lw %a1 %sp 20 #864
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8599 # nontail if
	lw %a1 %sp 12 #1132
	add %a0 %a1 %zero
	sw %ra %sp 52 #1132 call dir
	addi %sp %sp 56 #1132	
	jal %ra o_param_abc.2306 #1132
	addi %sp %sp -56 #1132
	lw %ra %sp 52 #1132
	lw %a1 %sp 16 #18
	lw %f0 %a1 0 #18
	lw %f1 %a1 4 #18
	lw %f2 %a1 8 #18
	sw %ra %sp 52 #1132 call dir
	addi %sp %sp 56 #1132	
	jal %ra veciprod2.2268 #1132
	addi %sp %sp -56 #1132
	lw %ra %sp 52 #1132
	lw %a0 %sp 16 #1131
	sw %f0 %a0 12 #1131
	jal %zero beq_cont.8600 # then sentence ends
beq_else.8599:
	addi %a12 %zero 2
	blt %a12 %a1 bge_else.8601 # nontail if
	jal %zero bge_cont.8602 # then sentence ends
bge_else.8601:
	lw %f0 %a0 0 #18
	lw %f1 %a0 4 #18
	lw %f2 %a0 8 #18
	lw %a2 %sp 12 #1134
	add %a0 %a2 %zero
	sw %ra %sp 52 #1134 call dir
	addi %sp %sp 56 #1134	
	jal %ra quadratic.2405 #1134
	addi %sp %sp -56 #1134
	lw %ra %sp 52 #1134
	lw %a0 %sp 20 #864
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8603 # nontail if
	li %f1 l.5555 #1135
	fsub %f0 %f0 %f1 #1135
	jal %zero beq_cont.8604 # then sentence ends
beq_else.8603:
beq_cont.8604:
	lw %a0 %sp 16 #1135
	sw %f0 %a0 12 #1135
bge_cont.8602:
beq_cont.8600:
	lw %a0 %sp 4 #1137
	addi %a1 %a0 -1 #1137
	lw %a0 %sp 8 #1137
	lw %a11 %sp 0 #1137
	lw %a10 %a11 0 #1137
	jalr %zero %a10 0 #1137
bge_else.8598:
	jalr %zero %ra 0 #1138
setup_startp.2485:
	lw %a1 %a11 12 #1141
	lw %a2 %a11 8 #1141
	lw %a3 %a11 4 #1141
	sw %a0 %sp 0 #1142
	sw %a2 %sp 4 #1142
	sw %a3 %sp 8 #1142
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 12 #1142 call dir
	addi %sp %sp 16 #1142	
	jal %ra veccpy.2254 #1142
	addi %sp %sp -16 #1142
	lw %ra %sp 12 #1142
	lw %a0 %sp 8 #14
	lw %a0 %a0 0 #14
	addi %a1 %a0 -1 #1143
	lw %a0 %sp 0 #1143
	lw %a11 %sp 4 #1143
	lw %a10 %a11 0 #1143
	jalr %zero %a10 0 #1143
is_rect_outside.2487:
	sw %f2 %sp 0 #1153
	sw %f1 %sp 8 #1153
	sw %a0 %sp 16 #1153
	sw %ra %sp 20 #1153 call dir
	addi %sp %sp 24 #1153	
	jal %ra min_caml_fabs #1153
	addi %sp %sp -24 #1153
	lw %ra %sp 20 #1153
	lw %a0 %sp 16 #1153
	sw %f0 %sp 24 #1153
	sw %ra %sp 36 #1153 call dir
	addi %sp %sp 40 #1153	
	jal %ra o_param_a.2300 #1153
	addi %sp %sp -40 #1153
	lw %ra %sp 36 #1153
	fadd %f1 %f0 %fzero #1153
	lw %f0 %sp 24 #1153
	sw %ra %sp 36 #1153 call dir
	addi %sp %sp 40 #1153	
	jal %ra min_caml_fless #1153
	addi %sp %sp -40 #1153
	lw %ra %sp 36 #1153
	addi %a1 %zero 0 #1153
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8607 # nontail if
	addi %a0 %a1 0 #1153
	jal %zero beq_cont.8608 # then sentence ends
beq_else.8607:
	lw %f0 %sp 8 #1154
	sw %a1 %sp 32 #1154
	sw %ra %sp 36 #1154 call dir
	addi %sp %sp 40 #1154	
	jal %ra min_caml_fabs #1154
	addi %sp %sp -40 #1154
	lw %ra %sp 36 #1154
	lw %a0 %sp 16 #1154
	sw %f0 %sp 40 #1154
	sw %ra %sp 52 #1154 call dir
	addi %sp %sp 56 #1154	
	jal %ra o_param_b.2302 #1154
	addi %sp %sp -56 #1154
	lw %ra %sp 52 #1154
	fadd %f1 %f0 %fzero #1154
	lw %f0 %sp 40 #1154
	sw %ra %sp 52 #1154 call dir
	addi %sp %sp 56 #1154	
	jal %ra min_caml_fless #1154
	addi %sp %sp -56 #1154
	lw %ra %sp 52 #1154
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8610 # nontail if
	lw %a0 %sp 32 #1153
	jal %zero beq_cont.8611 # then sentence ends
beq_else.8610:
	lw %f0 %sp 0 #1155
	sw %ra %sp 52 #1155 call dir
	addi %sp %sp 56 #1155	
	jal %ra min_caml_fabs #1155
	addi %sp %sp -56 #1155
	lw %ra %sp 52 #1155
	lw %a0 %sp 16 #1155
	sw %f0 %sp 48 #1155
	sw %ra %sp 60 #1155 call dir
	addi %sp %sp 64 #1155	
	jal %ra o_param_c.2304 #1155
	addi %sp %sp -64 #1155
	lw %ra %sp 60 #1155
	fadd %f1 %f0 %fzero #1155
	lw %f0 %sp 48 #1155
	sw %ra %sp 60 #1155 call dir
	addi %sp %sp 64 #1155	
	jal %ra min_caml_fless #1155
	addi %sp %sp -64 #1155
	lw %ra %sp 60 #1155
beq_cont.8611:
beq_cont.8608:
	addi %a1 %zero 0 #1152
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8612
	lw %a0 %sp 16 #1158
	sw %a1 %sp 56 #1158
	sw %ra %sp 60 #1158 call dir
	addi %sp %sp 64 #1158	
	jal %ra o_isinvert.2296 #1158
	addi %sp %sp -64 #1158
	lw %ra %sp 60 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8613
	addi %a0 %zero 1 #1158
	jalr %zero %ra 0 #1158
beq_else.8613:
	lw %a0 %sp 56 #1152
	jalr %zero %ra 0 #1152
beq_else.8612:
	lw %a0 %sp 16 #1158
	jal	%zero o_isinvert.2296
is_plane_outside.2492:
	sw %a0 %sp 0 #1163
	sw %f2 %sp 8 #1163
	sw %f1 %sp 16 #1163
	sw %f0 %sp 24 #1163
	sw %ra %sp 36 #1163 call dir
	addi %sp %sp 40 #1163	
	jal %ra o_param_abc.2306 #1163
	addi %sp %sp -40 #1163
	lw %ra %sp 36 #1163
	lw %f0 %sp 24 #1163
	lw %f1 %sp 16 #1163
	lw %f2 %sp 8 #1163
	sw %ra %sp 36 #1163 call dir
	addi %sp %sp 40 #1163	
	jal %ra veciprod2.2268 #1163
	addi %sp %sp -40 #1163
	lw %ra %sp 36 #1163
	lw %a0 %sp 0 #1164
	sw %f0 %sp 32 #1164
	sw %ra %sp 44 #1164 call dir
	addi %sp %sp 48 #1164	
	jal %ra o_isinvert.2296 #1164
	addi %sp %sp -48 #1164
	lw %ra %sp 44 #1164
	lw %f0 %sp 32 #1164
	sw %a0 %sp 40 #1164
	sw %ra %sp 44 #1164 call dir
	addi %sp %sp 48 #1164	
	jal %ra min_caml_fisneg #1164
	addi %sp %sp -48 #1164
	lw %ra %sp 44 #1164
	add %a1 %a0 %zero #1164
	lw %a0 %sp 40 #1164
	sw %ra %sp 44 #1164 call dir
	addi %sp %sp 48 #1164	
	jal %ra xor.2233 #1164
	addi %sp %sp -48 #1164
	lw %ra %sp 44 #1164
	addi %a1 %zero 0 #1164
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8615
	addi %a0 %zero 1 #1164
	jalr %zero %ra 0 #1164
beq_else.8615:
	addi %a0 %a1 0 #1164
	jalr %zero %ra 0 #1164
is_second_outside.2497:
	sw %a0 %sp 0 #1169
	sw %ra %sp 4 #1169 call dir
	addi %sp %sp 8 #1169	
	jal %ra quadratic.2405 #1169
	addi %sp %sp -8 #1169
	lw %ra %sp 4 #1169
	lw %a0 %sp 0 #1170
	sw %f0 %sp 8 #1170
	sw %ra %sp 20 #1170 call dir
	addi %sp %sp 24 #1170	
	jal %ra o_form.2292 #1170
	addi %sp %sp -24 #1170
	lw %ra %sp 20 #1170
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8617 # nontail if
	li %f0 l.5555 #1170
	lw %f1 %sp 8 #1170
	fsub %f0 %f1 %f0 #1170
	jal %zero beq_cont.8618 # then sentence ends
beq_else.8617:
	lw %f0 %sp 8 #818
beq_cont.8618:
	lw %a0 %sp 0 #1171
	sw %f0 %sp 16 #1171
	sw %ra %sp 28 #1171 call dir
	addi %sp %sp 32 #1171	
	jal %ra o_isinvert.2296 #1171
	addi %sp %sp -32 #1171
	lw %ra %sp 28 #1171
	lw %f0 %sp 16 #1171
	sw %a0 %sp 24 #1171
	sw %ra %sp 28 #1171 call dir
	addi %sp %sp 32 #1171	
	jal %ra min_caml_fisneg #1171
	addi %sp %sp -32 #1171
	lw %ra %sp 28 #1171
	add %a1 %a0 %zero #1171
	lw %a0 %sp 24 #1171
	sw %ra %sp 28 #1171 call dir
	addi %sp %sp 32 #1171	
	jal %ra xor.2233 #1171
	addi %sp %sp -32 #1171
	lw %ra %sp 28 #1171
	addi %a1 %zero 0 #1171
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8619
	addi %a0 %zero 1 #1171
	jalr %zero %ra 0 #1171
beq_else.8619:
	addi %a0 %a1 0 #1171
	jalr %zero %ra 0 #1171
is_outside.2502:
	sw %f2 %sp 0 #1176
	sw %f1 %sp 8 #1176
	sw %a0 %sp 16 #1176
	sw %f0 %sp 24 #1176
	sw %ra %sp 36 #1176 call dir
	addi %sp %sp 40 #1176	
	jal %ra o_param_x.2308 #1176
	addi %sp %sp -40 #1176
	lw %ra %sp 36 #1176
	lw %f1 %sp 24 #1176
	fsub %f0 %f1 %f0 #1176
	lw %a0 %sp 16 #1177
	sw %f0 %sp 32 #1177
	sw %ra %sp 44 #1177 call dir
	addi %sp %sp 48 #1177	
	jal %ra o_param_y.2310 #1177
	addi %sp %sp -48 #1177
	lw %ra %sp 44 #1177
	lw %f1 %sp 8 #1177
	fsub %f0 %f1 %f0 #1177
	lw %a0 %sp 16 #1178
	sw %f0 %sp 40 #1178
	sw %ra %sp 52 #1178 call dir
	addi %sp %sp 56 #1178	
	jal %ra o_param_z.2312 #1178
	addi %sp %sp -56 #1178
	lw %ra %sp 52 #1178
	lw %f1 %sp 0 #1178
	fsub %f0 %f1 %f0 #1178
	lw %a0 %sp 16 #1179
	sw %f0 %sp 48 #1179
	sw %ra %sp 60 #1179 call dir
	addi %sp %sp 64 #1179	
	jal %ra o_form.2292 #1179
	addi %sp %sp -64 #1179
	lw %ra %sp 60 #1179
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8621
	lw %f0 %sp 32 #1181
	lw %f1 %sp 40 #1181
	lw %f2 %sp 48 #1181
	lw %a0 %sp 16 #1181
	jal	%zero is_rect_outside.2487
beq_else.8621:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8622
	lw %f0 %sp 32 #1183
	lw %f1 %sp 40 #1183
	lw %f2 %sp 48 #1183
	lw %a0 %sp 16 #1183
	jal	%zero is_plane_outside.2492
beq_else.8622:
	lw %f0 %sp 32 #1185
	lw %f1 %sp 40 #1185
	lw %f2 %sp 48 #1185
	lw %a0 %sp 16 #1185
	jal	%zero is_second_outside.2497
check_all_inside.2507:
	lw %a2 %a11 4 #1189
	slli %a3 %a0 2 #1190
	add %a12 %a1 %a3 #1190
	lw %a3 %a12 0 #1190
	addi %a4 %zero 1 #1191
	sub %a4 %zero %a4 #1191
	bne %a3 %a4 beq_else.8623
	addi %a0 %zero 1 #1192
	jalr %zero %ra 0 #1192
beq_else.8623:
	slli %a3 %a3 2 #19
	add %a12 %a2 %a3 #19
	lw %a2 %a12 0 #19
	sw %f2 %sp 0 #1194
	sw %f1 %sp 8 #1194
	sw %f0 %sp 16 #1194
	sw %a1 %sp 24 #1194
	sw %a11 %sp 28 #1194
	sw %a0 %sp 32 #1194
	add %a0 %a2 %zero
	sw %ra %sp 36 #1194 call dir
	addi %sp %sp 40 #1194	
	jal %ra is_outside.2502 #1194
	addi %sp %sp -40 #1194
	lw %ra %sp 36 #1194
	addi %a1 %zero 0 #1194
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8624
	lw %a0 %sp 32 #1197
	addi %a0 %a0 1 #1197
	lw %f0 %sp 16 #1197
	lw %f1 %sp 8 #1197
	lw %f2 %sp 0 #1197
	lw %a1 %sp 24 #1197
	lw %a11 %sp 28 #1197
	lw %a10 %a11 0 #1197
	jalr %zero %a10 0 #1197
beq_else.8624:
	addi %a0 %a1 0 #1194
	jalr %zero %ra 0 #1194
shadow_check_and_group.2513:
	lw %a2 %a11 28 #1207
	lw %a3 %a11 24 #1207
	lw %a4 %a11 20 #1207
	lw %a5 %a11 16 #1207
	lw %a6 %a11 12 #1207
	lw %a7 %a11 8 #1207
	lw %a8 %a11 4 #1207
	slli %a9 %a0 2 #1208
	add %a12 %a1 %a9 #1208
	lw %a9 %a12 0 #1208
	addi %a10 %zero 1 #1208
	sub %a10 %zero %a10 #1208
	bne %a9 %a10 beq_else.8625
	addi %a0 %zero 0 #1209
	jalr %zero %ra 0 #1209
beq_else.8625:
	sw %a8 %sp 0 #1212
	sw %a7 %sp 4 #1212
	sw %a6 %sp 8 #1212
	sw %a1 %sp 12 #1212
	sw %a11 %sp 16 #1212
	sw %a0 %sp 20 #1212
	sw %a4 %sp 24 #1212
	sw %a9 %sp 28 #1212
	sw %a3 %sp 32 #1212
	add %a1 %a5 %zero
	add %a0 %a9 %zero
	add %a11 %a2 %zero
	add %a2 %a7 %zero
	sw %ra %sp 36 #1212 call cls
	lw %a10 %a11 0 #1212
	addi %sp %sp 40 #1212	
	jalr %ra %a10 0 #1212
	addi %sp %sp -40 #1212
	lw %ra %sp 36 #1212
	lw %a1 %sp 32 #36
	lw %f0 %a1 0 #36
	addi %a1 %zero 0 #1214
	sw %f0 %sp 40 #905
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8627 # nontail if
	addi %a0 %a1 0 #1214
	jal %zero beq_cont.8628 # then sentence ends
beq_else.8627:
	li %f1 l.5933 #1214
	sw %ra %sp 52 #1214 call dir
	addi %sp %sp 56 #1214	
	jal %ra min_caml_fless #1214
	addi %sp %sp -56 #1214
	lw %ra %sp 52 #1214
beq_cont.8628:
	addi %a1 %zero 0 #1214
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8629
	lw %a0 %sp 28 #19
	slli %a0 %a0 2 #19
	lw %a2 %sp 24 #19
	add %a12 %a2 %a0 #19
	lw %a0 %a12 0 #19
	sw %a1 %sp 48 #1230
	sw %ra %sp 52 #1230 call dir
	addi %sp %sp 56 #1230	
	jal %ra o_isinvert.2296 #1230
	addi %sp %sp -56 #1230
	lw %ra %sp 52 #1230
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8630
	lw %a0 %sp 48 #1214
	jalr %zero %ra 0 #1214
beq_else.8630:
	lw %a0 %sp 20 #1231
	addi %a0 %a0 1 #1231
	lw %a1 %sp 12 #1231
	lw %a11 %sp 16 #1231
	lw %a10 %a11 0 #1231
	jalr %zero %a10 0 #1231
beq_else.8629:
	li %f0 l.5935 #1217
	lw %f1 %sp 40 #1217
	fadd %f0 %f1 %f0 #1217
	lw %a0 %sp 8 #26
	lw %f1 %a0 0 #26
	fmul %f1 %f1 %f0 #1218
	lw %a2 %sp 4 #42
	lw %f2 %a2 0 #42
	fadd %f1 %f1 %f2 #1218
	lw %f2 %a0 4 #26
	fmul %f2 %f2 %f0 #1219
	lw %f3 %a2 4 #42
	fadd %f2 %f2 %f3 #1219
	lw %f3 %a0 8 #26
	fmul %f0 %f3 %f0 #1220
	lw %f3 %a2 8 #42
	fadd %f0 %f0 %f3 #1220
	lw %a0 %sp 12 #1221
	lw %a11 %sp 0 #1221
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 52 #1221 call cls
	lw %a10 %a11 0 #1221
	addi %sp %sp 56 #1221	
	jalr %ra %a10 0 #1221
	addi %sp %sp -56 #1221
	lw %ra %sp 52 #1221
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8631
	lw %a0 %sp 20 #1224
	addi %a0 %a0 1 #1224
	lw %a1 %sp 12 #1224
	lw %a11 %sp 16 #1224
	lw %a10 %a11 0 #1224
	jalr %zero %a10 0 #1224
beq_else.8631:
	addi %a0 %zero 1 #1222
	jalr %zero %ra 0 #1222
shadow_check_one_or_group.2516:
	lw %a2 %a11 8 #1237
	lw %a3 %a11 4 #1237
	slli %a4 %a0 2 #1238
	add %a12 %a1 %a4 #1238
	lw %a4 %a12 0 #1238
	addi %a5 %zero 1 #1239
	sub %a5 %zero %a5 #1239
	bne %a4 %a5 beq_else.8632
	addi %a0 %zero 0 #1240
	jalr %zero %ra 0 #1240
beq_else.8632:
	slli %a4 %a4 2 #30
	add %a12 %a3 %a4 #30
	lw %a3 %a12 0 #30
	addi %a4 %zero 0 #1243
	sw %a1 %sp 0 #1243
	sw %a11 %sp 4 #1243
	sw %a0 %sp 8 #1243
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	add %a11 %a2 %zero
	sw %ra %sp 12 #1243 call cls
	lw %a10 %a11 0 #1243
	addi %sp %sp 16 #1243	
	jalr %ra %a10 0 #1243
	addi %sp %sp -16 #1243
	lw %ra %sp 12 #1243
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8633
	lw %a0 %sp 8 #1247
	addi %a0 %a0 1 #1247
	lw %a1 %sp 0 #1247
	lw %a11 %sp 4 #1247
	lw %a10 %a11 0 #1247
	jalr %zero %a10 0 #1247
beq_else.8633:
	addi %a0 %zero 1 #1245
	jalr %zero %ra 0 #1245
shadow_check_one_or_matrix.2519:
	lw %a2 %a11 20 #1252
	lw %a3 %a11 16 #1252
	lw %a4 %a11 12 #1252
	lw %a5 %a11 8 #1252
	lw %a6 %a11 4 #1252
	slli %a7 %a0 2 #1253
	add %a12 %a1 %a7 #1253
	lw %a7 %a12 0 #1253
	lw %a8 %a7 0 #1254
	addi %a9 %zero 1 #1255
	sub %a9 %zero %a9 #1255
	bne %a8 %a9 beq_else.8634
	addi %a0 %zero 0 #1256
	jalr %zero %ra 0 #1256
beq_else.8634:
	sw %a7 %sp 0 #1255
	sw %a4 %sp 4 #1255
	sw %a1 %sp 8 #1255
	sw %a11 %sp 12 #1255
	sw %a0 %sp 16 #1255
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.8635 # nontail if
	addi %a0 %zero 1 #1260
	jal %zero beq_cont.8636 # then sentence ends
beq_else.8635:
	sw %a3 %sp 20 #1262
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	add %a11 %a2 %zero
	add %a2 %a6 %zero
	sw %ra %sp 28 #1262 call cls
	lw %a10 %a11 0 #1262
	addi %sp %sp 32 #1262	
	jalr %ra %a10 0 #1262
	addi %sp %sp -32 #1262
	lw %ra %sp 28 #1262
	addi %a1 %zero 0 #1265
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8637 # nontail if
	addi %a0 %a1 0 #1265
	jal %zero beq_cont.8638 # then sentence ends
beq_else.8637:
	lw %a0 %sp 20 #36
	lw %f0 %a0 0 #36
	li %f1 l.5949 #1266
	sw %a1 %sp 24 #1266
	sw %ra %sp 28 #1266 call dir
	addi %sp %sp 32 #1266	
	jal %ra min_caml_fless #1266
	addi %sp %sp -32 #1266
	lw %ra %sp 28 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8639 # nontail if
	lw %a0 %sp 24 #1265
	jal %zero beq_cont.8640 # then sentence ends
beq_else.8639:
	addi %a0 %zero 1 #1267
	lw %a1 %sp 0 #1267
	lw %a11 %sp 4 #1267
	sw %ra %sp 28 #1267 call cls
	lw %a10 %a11 0 #1267
	addi %sp %sp 32 #1267	
	jalr %ra %a10 0 #1267
	addi %sp %sp -32 #1267
	lw %ra %sp 28 #1267
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8641 # nontail if
	lw %a0 %sp 24 #1265
	jal %zero beq_cont.8642 # then sentence ends
beq_else.8641:
	addi %a0 %zero 1 #1268
beq_cont.8642:
beq_cont.8640:
beq_cont.8638:
beq_cont.8636:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8643
	lw %a0 %sp 16 #1278
	addi %a0 %a0 1 #1278
	lw %a1 %sp 8 #1278
	lw %a11 %sp 12 #1278
	lw %a10 %a11 0 #1278
	jalr %zero %a10 0 #1278
beq_else.8643:
	addi %a0 %zero 1 #1273
	lw %a1 %sp 0 #1273
	lw %a11 %sp 4 #1273
	sw %ra %sp 28 #1273 call cls
	lw %a10 %a11 0 #1273
	addi %sp %sp 32 #1273	
	jalr %ra %a10 0 #1273
	addi %sp %sp -32 #1273
	lw %ra %sp 28 #1273
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8644
	lw %a0 %sp 16 #1276
	addi %a0 %a0 1 #1276
	lw %a1 %sp 8 #1276
	lw %a11 %sp 12 #1276
	lw %a10 %a11 0 #1276
	jalr %zero %a10 0 #1276
beq_else.8644:
	addi %a0 %zero 1 #1274
	jalr %zero %ra 0 #1274
solve_each_element.2522:
	lw %a3 %a11 36 #1286
	lw %a4 %a11 32 #1286
	lw %a5 %a11 28 #1286
	lw %a6 %a11 24 #1286
	lw %a7 %a11 20 #1286
	lw %a8 %a11 16 #1286
	lw %a9 %a11 12 #1286
	lw %a10 %a11 8 #1286
	sw %a8 %sp 0 #1286
	lw %a8 %a11 4 #1286
	sw %a10 %sp 4 #1287
	slli %a10 %a0 2 #1287
	add %a12 %a1 %a10 #1287
	lw %a10 %a12 0 #1287
	sw %a9 %sp 8 #1288
	addi %a9 %zero 1 #1288
	sub %a9 %zero %a9 #1288
	bne %a10 %a9 beq_else.8645
	jalr %zero %ra 0 #1288
beq_else.8645:
	sw %a8 %sp 12 #1290
	sw %a4 %sp 16 #1290
	sw %a3 %sp 20 #1290
	sw %a5 %sp 24 #1290
	sw %a2 %sp 28 #1290
	sw %a1 %sp 32 #1290
	sw %a11 %sp 36 #1290
	sw %a0 %sp 40 #1290
	sw %a7 %sp 44 #1290
	sw %a10 %sp 48 #1290
	add %a1 %a2 %zero
	add %a0 %a10 %zero
	add %a11 %a6 %zero
	add %a2 %a4 %zero
	sw %ra %sp 52 #1290 call cls
	lw %a10 %a11 0 #1290
	addi %sp %sp 56 #1290	
	jalr %ra %a10 0 #1290
	addi %sp %sp -56 #1290
	lw %ra %sp 52 #1290
	addi %a1 %zero 0 #1291
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8647
	lw %a0 %sp 48 #19
	slli %a0 %a0 2 #19
	lw %a1 %sp 44 #19
	add %a12 %a1 %a0 #19
	lw %a0 %a12 0 #19
	sw %ra %sp 52 #1319 call dir
	addi %sp %sp 56 #1319	
	jal %ra o_isinvert.2296 #1319
	addi %sp %sp -56 #1319
	lw %ra %sp 52 #1319
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8648
	jalr %zero %ra 0 #1321
beq_else.8648:
	lw %a0 %sp 40 #1320
	addi %a0 %a0 1 #1320
	lw %a1 %sp 32 #1320
	lw %a2 %sp 28 #1320
	lw %a11 %sp 36 #1320
	lw %a10 %a11 0 #1320
	jalr %zero %a10 0 #1320
beq_else.8647:
	lw %a2 %sp 24 #36
	lw %f1 %a2 0 #36
	li %f0 l.5553 #1297
	sw %a0 %sp 52 #1297
	sw %a1 %sp 56 #1297
	sw %f1 %sp 64 #1297
	sw %ra %sp 76 #1297 call dir
	addi %sp %sp 80 #1297	
	jal %ra min_caml_fless #1297
	addi %sp %sp -80 #1297
	lw %ra %sp 76 #1297
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8651 # nontail if
	jal %zero beq_cont.8652 # then sentence ends
beq_else.8651:
	lw %a0 %sp 20 #40
	lw %f1 %a0 0 #40
	lw %f0 %sp 64 #1298
	sw %ra %sp 76 #1298 call dir
	addi %sp %sp 80 #1298	
	jal %ra min_caml_fless #1298
	addi %sp %sp -80 #1298
	lw %ra %sp 76 #1298
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8653 # nontail if
	jal %zero beq_cont.8654 # then sentence ends
beq_else.8653:
	li %f0 l.5935 #1300
	lw %f1 %sp 64 #1300
	fadd %f0 %f1 %f0 #1300
	lw %a0 %sp 28 #779
	lw %f1 %a0 0 #779
	fmul %f1 %f1 %f0 #1301
	lw %a1 %sp 16 #63
	lw %f2 %a1 0 #63
	fadd %f1 %f1 %f2 #1301
	lw %f2 %a0 4 #779
	fmul %f2 %f2 %f0 #1302
	lw %f3 %a1 4 #63
	fadd %f2 %f2 %f3 #1302
	lw %f3 %a0 8 #779
	fmul %f3 %f3 %f0 #1303
	lw %f4 %a1 8 #63
	fadd %f3 %f3 %f4 #1303
	lw %a1 %sp 56 #1304
	lw %a2 %sp 32 #1304
	lw %a11 %sp 12 #1304
	sw %f3 %sp 72 #1304
	sw %f2 %sp 80 #1304
	sw %f1 %sp 88 #1304
	sw %f0 %sp 96 #1304
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 108 #1304 call cls
	lw %a10 %a11 0 #1304
	addi %sp %sp 112 #1304	
	jalr %ra %a10 0 #1304
	addi %sp %sp -112 #1304
	lw %ra %sp 108 #1304
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8655 # nontail if
	jal %zero beq_cont.8656 # then sentence ends
beq_else.8655:
	lw %a0 %sp 20 #1306
	lw %f0 %sp 96 #1306
	sw %f0 %a0 0 #1306
	lw %f0 %sp 88 #1307
	lw %f1 %sp 80 #1307
	lw %f2 %sp 72 #1307
	lw %a0 %sp 8 #1307
	sw %ra %sp 108 #1307 call dir
	addi %sp %sp 112 #1307	
	jal %ra vecset.2244 #1307
	addi %sp %sp -112 #1307
	lw %ra %sp 108 #1307
	lw %a0 %sp 4 #1308
	lw %a1 %sp 48 #1308
	sw %a1 %a0 0 #1308
	lw %a0 %sp 0 #1309
	lw %a1 %sp 52 #1309
	sw %a1 %a0 0 #1309
beq_cont.8656:
beq_cont.8654:
beq_cont.8652:
	lw %a0 %sp 40 #1315
	addi %a0 %a0 1 #1315
	lw %a1 %sp 32 #1315
	lw %a2 %sp 28 #1315
	lw %a11 %sp 36 #1315
	lw %a10 %a11 0 #1315
	jalr %zero %a10 0 #1315
solve_one_or_network.2526:
	lw %a3 %a11 8 #1327
	lw %a4 %a11 4 #1327
	slli %a5 %a0 2 #1328
	add %a12 %a1 %a5 #1328
	lw %a5 %a12 0 #1328
	addi %a6 %zero 1 #1329
	sub %a6 %zero %a6 #1329
	bne %a5 %a6 beq_else.8657
	jalr %zero %ra 0 #1332
beq_else.8657:
	slli %a5 %a5 2 #30
	add %a12 %a4 %a5 #30
	lw %a4 %a12 0 #30
	addi %a5 %zero 0 #1330
	sw %a2 %sp 0 #1330
	sw %a1 %sp 4 #1330
	sw %a11 %sp 8 #1330
	sw %a0 %sp 12 #1330
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1330 call cls
	lw %a10 %a11 0 #1330
	addi %sp %sp 24 #1330	
	jalr %ra %a10 0 #1330
	addi %sp %sp -24 #1330
	lw %ra %sp 20 #1330
	lw %a0 %sp 12 #1331
	addi %a0 %a0 1 #1331
	lw %a1 %sp 4 #1331
	lw %a2 %sp 0 #1331
	lw %a11 %sp 8 #1331
	lw %a10 %a11 0 #1331
	jalr %zero %a10 0 #1331
trace_or_matrix.2530:
	lw %a3 %a11 20 #1336
	lw %a4 %a11 16 #1336
	lw %a5 %a11 12 #1336
	lw %a6 %a11 8 #1336
	lw %a7 %a11 4 #1336
	slli %a8 %a0 2 #1337
	add %a12 %a1 %a8 #1337
	lw %a8 %a12 0 #1337
	lw %a9 %a8 0 #1338
	addi %a10 %zero 1 #1339
	sub %a10 %zero %a10 #1339
	bne %a9 %a10 beq_else.8659
	jalr %zero %ra 0 #1340
beq_else.8659:
	sw %a2 %sp 0 #1339
	sw %a1 %sp 4 #1339
	sw %a11 %sp 8 #1339
	sw %a0 %sp 12 #1339
	addi %a12 %zero 99
	bne %a9 %a12 beq_else.8661 # nontail if
	addi %a3 %zero 1 #1343
	add %a1 %a8 %zero
	add %a0 %a3 %zero
	add %a11 %a7 %zero
	sw %ra %sp 20 #1343 call cls
	lw %a10 %a11 0 #1343
	addi %sp %sp 24 #1343	
	jalr %ra %a10 0 #1343
	addi %sp %sp -24 #1343
	lw %ra %sp 20 #1343
	jal %zero beq_cont.8662 # then sentence ends
beq_else.8661:
	sw %a8 %sp 16 #1347
	sw %a7 %sp 20 #1347
	sw %a3 %sp 24 #1347
	sw %a5 %sp 28 #1347
	add %a1 %a2 %zero
	add %a0 %a9 %zero
	add %a11 %a6 %zero
	add %a2 %a4 %zero
	sw %ra %sp 36 #1347 call cls
	lw %a10 %a11 0 #1347
	addi %sp %sp 40 #1347	
	jalr %ra %a10 0 #1347
	addi %sp %sp -40 #1347
	lw %ra %sp 36 #1347
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8663 # nontail if
	jal %zero beq_cont.8664 # then sentence ends
beq_else.8663:
	lw %a0 %sp 28 #36
	lw %f0 %a0 0 #36
	lw %a0 %sp 24 #40
	lw %f1 %a0 0 #40
	sw %ra %sp 36 #1350 call dir
	addi %sp %sp 40 #1350	
	jal %ra min_caml_fless #1350
	addi %sp %sp -40 #1350
	lw %ra %sp 36 #1350
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8665 # nontail if
	jal %zero beq_cont.8666 # then sentence ends
beq_else.8665:
	addi %a0 %zero 1 #1351
	lw %a1 %sp 16 #1351
	lw %a2 %sp 0 #1351
	lw %a11 %sp 20 #1351
	sw %ra %sp 36 #1351 call cls
	lw %a10 %a11 0 #1351
	addi %sp %sp 40 #1351	
	jalr %ra %a10 0 #1351
	addi %sp %sp -40 #1351
	lw %ra %sp 36 #1351
beq_cont.8666:
beq_cont.8664:
beq_cont.8662:
	lw %a0 %sp 12 #1355
	addi %a0 %a0 1 #1355
	lw %a1 %sp 4 #1355
	lw %a2 %sp 0 #1355
	lw %a11 %sp 8 #1355
	lw %a10 %a11 0 #1355
	jalr %zero %a10 0 #1355
judge_intersection.2534:
	lw %a1 %a11 12 #1363
	lw %a2 %a11 8 #1363
	lw %a3 %a11 4 #1363
	li %f0 l.5972 #1364
	sw %f0 %a2 0 #1364
	addi %a4 %zero 0 #1365
	lw %a3 %a3 0 #32
	sw %a2 %sp 0 #1365
	add %a2 %a0 %zero
	add %a11 %a1 %zero
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	sw %ra %sp 4 #1365 call cls
	lw %a10 %a11 0 #1365
	addi %sp %sp 8 #1365	
	jalr %ra %a10 0 #1365
	addi %sp %sp -8 #1365
	lw %ra %sp 4 #1365
	lw %a0 %sp 0 #40
	lw %f1 %a0 0 #40
	li %f0 l.5949 #1368
	sw %f1 %sp 8 #1368
	sw %ra %sp 20 #1368 call dir
	addi %sp %sp 24 #1368	
	jal %ra min_caml_fless #1368
	addi %sp %sp -24 #1368
	lw %ra %sp 20 #1368
	addi %a1 %zero 0 #1368
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8668
	addi %a0 %a1 0 #1368
	jalr %zero %ra 0 #1368
beq_else.8668:
	li %f1 l.5978 #1369
	lw %f0 %sp 8 #1369
	jal	%zero min_caml_fless
solve_each_element_fast.2536:
	lw %a3 %a11 36 #1376
	lw %a4 %a11 32 #1376
	lw %a5 %a11 28 #1376
	lw %a6 %a11 24 #1376
	lw %a7 %a11 20 #1376
	lw %a8 %a11 16 #1376
	lw %a9 %a11 12 #1376
	lw %a10 %a11 8 #1376
	sw %a8 %sp 0 #1376
	lw %a8 %a11 4 #1376
	sw %a10 %sp 4 #1377
	sw %a9 %sp 8 #1377
	sw %a8 %sp 12 #1377
	sw %a4 %sp 16 #1377
	sw %a3 %sp 20 #1377
	sw %a6 %sp 24 #1377
	sw %a11 %sp 28 #1377
	sw %a7 %sp 32 #1377
	sw %a2 %sp 36 #1377
	sw %a5 %sp 40 #1377
	sw %a1 %sp 44 #1377
	sw %a0 %sp 48 #1377
	add %a0 %a2 %zero
	sw %ra %sp 52 #1377 call dir
	addi %sp %sp 56 #1377	
	jal %ra d_vec.2351 #1377
	addi %sp %sp -56 #1377
	lw %ra %sp 52 #1377
	lw %a1 %sp 48 #1378
	slli %a2 %a1 2 #1378
	lw %a3 %sp 44 #1378
	add %a12 %a3 %a2 #1378
	lw %a2 %a12 0 #1378
	addi %a4 %zero 1 #1379
	sub %a4 %zero %a4 #1379
	bne %a2 %a4 beq_else.8669
	jalr %zero %ra 0 #1379
beq_else.8669:
	lw %a4 %sp 36 #1381
	lw %a11 %sp 40 #1381
	sw %a0 %sp 52 #1381
	sw %a2 %sp 56 #1381
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 60 #1381 call cls
	lw %a10 %a11 0 #1381
	addi %sp %sp 64 #1381	
	jalr %ra %a10 0 #1381
	addi %sp %sp -64 #1381
	lw %ra %sp 60 #1381
	addi %a1 %zero 0 #1382
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8671
	lw %a0 %sp 56 #19
	slli %a0 %a0 2 #19
	lw %a1 %sp 32 #19
	add %a12 %a1 %a0 #19
	lw %a0 %a12 0 #19
	sw %ra %sp 60 #1410 call dir
	addi %sp %sp 64 #1410	
	jal %ra o_isinvert.2296 #1410
	addi %sp %sp -64 #1410
	lw %ra %sp 60 #1410
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8672
	jalr %zero %ra 0 #1412
beq_else.8672:
	lw %a0 %sp 48 #1411
	addi %a0 %a0 1 #1411
	lw %a1 %sp 44 #1411
	lw %a2 %sp 36 #1411
	lw %a11 %sp 28 #1411
	lw %a10 %a11 0 #1411
	jalr %zero %a10 0 #1411
beq_else.8671:
	lw %a2 %sp 24 #36
	lw %f1 %a2 0 #36
	li %f0 l.5553 #1388
	sw %a0 %sp 60 #1388
	sw %a1 %sp 64 #1388
	sw %f1 %sp 72 #1388
	sw %ra %sp 84 #1388 call dir
	addi %sp %sp 88 #1388	
	jal %ra min_caml_fless #1388
	addi %sp %sp -88 #1388
	lw %ra %sp 84 #1388
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8675 # nontail if
	jal %zero beq_cont.8676 # then sentence ends
beq_else.8675:
	lw %a0 %sp 20 #40
	lw %f1 %a0 0 #40
	lw %f0 %sp 72 #1389
	sw %ra %sp 84 #1389 call dir
	addi %sp %sp 88 #1389	
	jal %ra min_caml_fless #1389
	addi %sp %sp -88 #1389
	lw %ra %sp 84 #1389
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8677 # nontail if
	jal %zero beq_cont.8678 # then sentence ends
beq_else.8677:
	li %f0 l.5935 #1391
	lw %f1 %sp 72 #1391
	fadd %f0 %f1 %f0 #1391
	lw %a0 %sp 52 #899
	lw %f1 %a0 0 #899
	fmul %f1 %f1 %f0 #1392
	lw %a1 %sp 16 #65
	lw %f2 %a1 0 #65
	fadd %f1 %f1 %f2 #1392
	lw %f2 %a0 4 #899
	fmul %f2 %f2 %f0 #1393
	lw %f3 %a1 4 #65
	fadd %f2 %f2 %f3 #1393
	lw %f3 %a0 8 #899
	fmul %f3 %f3 %f0 #1394
	lw %f4 %a1 8 #65
	fadd %f3 %f3 %f4 #1394
	lw %a0 %sp 64 #1395
	lw %a1 %sp 44 #1395
	lw %a11 %sp 12 #1395
	sw %f3 %sp 80 #1395
	sw %f2 %sp 88 #1395
	sw %f1 %sp 96 #1395
	sw %f0 %sp 104 #1395
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 116 #1395 call cls
	lw %a10 %a11 0 #1395
	addi %sp %sp 120 #1395	
	jalr %ra %a10 0 #1395
	addi %sp %sp -120 #1395
	lw %ra %sp 116 #1395
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8679 # nontail if
	jal %zero beq_cont.8680 # then sentence ends
beq_else.8679:
	lw %a0 %sp 20 #1397
	lw %f0 %sp 104 #1397
	sw %f0 %a0 0 #1397
	lw %f0 %sp 96 #1398
	lw %f1 %sp 88 #1398
	lw %f2 %sp 80 #1398
	lw %a0 %sp 8 #1398
	sw %ra %sp 116 #1398 call dir
	addi %sp %sp 120 #1398	
	jal %ra vecset.2244 #1398
	addi %sp %sp -120 #1398
	lw %ra %sp 116 #1398
	lw %a0 %sp 4 #1399
	lw %a1 %sp 56 #1399
	sw %a1 %a0 0 #1399
	lw %a0 %sp 0 #1400
	lw %a1 %sp 60 #1400
	sw %a1 %a0 0 #1400
beq_cont.8680:
beq_cont.8678:
beq_cont.8676:
	lw %a0 %sp 48 #1406
	addi %a0 %a0 1 #1406
	lw %a1 %sp 44 #1406
	lw %a2 %sp 36 #1406
	lw %a11 %sp 28 #1406
	lw %a10 %a11 0 #1406
	jalr %zero %a10 0 #1406
solve_one_or_network_fast.2540:
	lw %a3 %a11 8 #1417
	lw %a4 %a11 4 #1417
	slli %a5 %a0 2 #1418
	add %a12 %a1 %a5 #1418
	lw %a5 %a12 0 #1418
	addi %a6 %zero 1 #1419
	sub %a6 %zero %a6 #1419
	bne %a5 %a6 beq_else.8681
	jalr %zero %ra 0 #1423
beq_else.8681:
	slli %a5 %a5 2 #30
	add %a12 %a4 %a5 #30
	lw %a4 %a12 0 #30
	addi %a5 %zero 0 #1421
	sw %a2 %sp 0 #1421
	sw %a1 %sp 4 #1421
	sw %a11 %sp 8 #1421
	sw %a0 %sp 12 #1421
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1421 call cls
	lw %a10 %a11 0 #1421
	addi %sp %sp 24 #1421	
	jalr %ra %a10 0 #1421
	addi %sp %sp -24 #1421
	lw %ra %sp 20 #1421
	lw %a0 %sp 12 #1422
	addi %a0 %a0 1 #1422
	lw %a1 %sp 4 #1422
	lw %a2 %sp 0 #1422
	lw %a11 %sp 8 #1422
	lw %a10 %a11 0 #1422
	jalr %zero %a10 0 #1422
trace_or_matrix_fast.2544:
	lw %a3 %a11 16 #1427
	lw %a4 %a11 12 #1427
	lw %a5 %a11 8 #1427
	lw %a6 %a11 4 #1427
	slli %a7 %a0 2 #1428
	add %a12 %a1 %a7 #1428
	lw %a7 %a12 0 #1428
	lw %a8 %a7 0 #1429
	addi %a9 %zero 1 #1430
	sub %a9 %zero %a9 #1430
	bne %a8 %a9 beq_else.8683
	jalr %zero %ra 0 #1431
beq_else.8683:
	sw %a2 %sp 0 #1430
	sw %a1 %sp 4 #1430
	sw %a11 %sp 8 #1430
	sw %a0 %sp 12 #1430
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.8685 # nontail if
	addi %a3 %zero 1 #1434
	add %a1 %a7 %zero
	add %a0 %a3 %zero
	add %a11 %a6 %zero
	sw %ra %sp 20 #1434 call cls
	lw %a10 %a11 0 #1434
	addi %sp %sp 24 #1434	
	jalr %ra %a10 0 #1434
	addi %sp %sp -24 #1434
	lw %ra %sp 20 #1434
	jal %zero beq_cont.8686 # then sentence ends
beq_else.8685:
	sw %a7 %sp 16 #1438
	sw %a6 %sp 20 #1438
	sw %a3 %sp 24 #1438
	sw %a5 %sp 28 #1438
	add %a1 %a2 %zero
	add %a0 %a8 %zero
	add %a11 %a4 %zero
	sw %ra %sp 36 #1438 call cls
	lw %a10 %a11 0 #1438
	addi %sp %sp 40 #1438	
	jalr %ra %a10 0 #1438
	addi %sp %sp -40 #1438
	lw %ra %sp 36 #1438
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8687 # nontail if
	jal %zero beq_cont.8688 # then sentence ends
beq_else.8687:
	lw %a0 %sp 28 #36
	lw %f0 %a0 0 #36
	lw %a0 %sp 24 #40
	lw %f1 %a0 0 #40
	sw %ra %sp 36 #1441 call dir
	addi %sp %sp 40 #1441	
	jal %ra min_caml_fless #1441
	addi %sp %sp -40 #1441
	lw %ra %sp 36 #1441
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8689 # nontail if
	jal %zero beq_cont.8690 # then sentence ends
beq_else.8689:
	addi %a0 %zero 1 #1442
	lw %a1 %sp 16 #1442
	lw %a2 %sp 0 #1442
	lw %a11 %sp 20 #1442
	sw %ra %sp 36 #1442 call cls
	lw %a10 %a11 0 #1442
	addi %sp %sp 40 #1442	
	jalr %ra %a10 0 #1442
	addi %sp %sp -40 #1442
	lw %ra %sp 36 #1442
beq_cont.8690:
beq_cont.8688:
beq_cont.8686:
	lw %a0 %sp 12 #1446
	addi %a0 %a0 1 #1446
	lw %a1 %sp 4 #1446
	lw %a2 %sp 0 #1446
	lw %a11 %sp 8 #1446
	lw %a10 %a11 0 #1446
	jalr %zero %a10 0 #1446
judge_intersection_fast.2548:
	lw %a1 %a11 12 #1451
	lw %a2 %a11 8 #1451
	lw %a3 %a11 4 #1451
	li %f0 l.5972 #1453
	sw %f0 %a2 0 #1453
	addi %a4 %zero 0 #1454
	lw %a3 %a3 0 #32
	sw %a2 %sp 0 #1454
	add %a2 %a0 %zero
	add %a11 %a1 %zero
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	sw %ra %sp 4 #1454 call cls
	lw %a10 %a11 0 #1454
	addi %sp %sp 8 #1454	
	jalr %ra %a10 0 #1454
	addi %sp %sp -8 #1454
	lw %ra %sp 4 #1454
	lw %a0 %sp 0 #40
	lw %f1 %a0 0 #40
	li %f0 l.5949 #1457
	sw %f1 %sp 8 #1457
	sw %ra %sp 20 #1457 call dir
	addi %sp %sp 24 #1457	
	jal %ra min_caml_fless #1457
	addi %sp %sp -24 #1457
	lw %ra %sp 20 #1457
	addi %a1 %zero 0 #1457
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8692
	addi %a0 %a1 0 #1457
	jalr %zero %ra 0 #1457
beq_else.8692:
	li %f1 l.5978 #1458
	lw %f0 %sp 8 #1458
	jal	%zero min_caml_fless
get_nvector_rect.2550:
	lw %a1 %a11 8 #1470
	lw %a2 %a11 4 #1470
	lw %a2 %a2 0 #38
	sw %a1 %sp 0 #1473
	sw %a0 %sp 4 #1473
	sw %a2 %sp 8 #1473
	add %a0 %a1 %zero
	sw %ra %sp 12 #1473 call dir
	addi %sp %sp 16 #1473	
	jal %ra vecbzero.2252 #1473
	addi %sp %sp -16 #1473
	lw %ra %sp 12 #1473
	lw %a0 %sp 8 #1474
	addi %a1 %a0 -1 #1474
	addi %a0 %a0 -1 #1474
	slli %a0 %a0 2 #1474
	lw %a2 %sp 4 #1474
	add %a12 %a2 %a0 #1474
	lw %f0 %a12 0 #1474
	sw %a1 %sp 12 #1474
	sw %ra %sp 20 #1474 call dir
	addi %sp %sp 24 #1474	
	jal %ra sgn.2236 #1474
	addi %sp %sp -24 #1474
	lw %ra %sp 20 #1474
	sw %ra %sp 20 #1474 call dir
	addi %sp %sp 24 #1474	
	jal %ra min_caml_fneg #1474
	addi %sp %sp -24 #1474
	lw %ra %sp 20 #1474
	lw %a0 %sp 12 #1474
	slli %a0 %a0 2 #1474
	lw %a1 %sp 0 #1474
	add %a12 %a1 %a0 #1474
	sw %f0 %a12 0 #1474
	jalr %zero %ra 0 #1474
get_nvector_plane.2552:
	lw %a1 %a11 4 #1478
	sw %a0 %sp 0 #1480
	sw %a1 %sp 4 #1480
	sw %ra %sp 12 #1480 call dir
	addi %sp %sp 16 #1480	
	jal %ra o_param_a.2300 #1480
	addi %sp %sp -16 #1480
	lw %ra %sp 12 #1480
	sw %ra %sp 12 #1480 call dir
	addi %sp %sp 16 #1480	
	jal %ra min_caml_fneg #1480
	addi %sp %sp -16 #1480
	lw %ra %sp 12 #1480
	lw %a0 %sp 4 #1480
	sw %f0 %a0 0 #1480
	lw %a1 %sp 0 #1481
	add %a0 %a1 %zero
	sw %ra %sp 12 #1481 call dir
	addi %sp %sp 16 #1481	
	jal %ra o_param_b.2302 #1481
	addi %sp %sp -16 #1481
	lw %ra %sp 12 #1481
	sw %ra %sp 12 #1481 call dir
	addi %sp %sp 16 #1481	
	jal %ra min_caml_fneg #1481
	addi %sp %sp -16 #1481
	lw %ra %sp 12 #1481
	lw %a0 %sp 4 #1481
	sw %f0 %a0 4 #1481
	lw %a1 %sp 0 #1482
	add %a0 %a1 %zero
	sw %ra %sp 12 #1482 call dir
	addi %sp %sp 16 #1482	
	jal %ra o_param_c.2304 #1482
	addi %sp %sp -16 #1482
	lw %ra %sp 12 #1482
	sw %ra %sp 12 #1482 call dir
	addi %sp %sp 16 #1482	
	jal %ra min_caml_fneg #1482
	addi %sp %sp -16 #1482
	lw %ra %sp 12 #1482
	lw %a0 %sp 4 #1482
	sw %f0 %a0 8 #1482
	jalr %zero %ra 0 #1482
get_nvector_second.2554:
	lw %a1 %a11 8 #1486
	lw %a2 %a11 4 #1486
	lw %f0 %a2 0 #42
	sw %a1 %sp 0 #1487
	sw %a0 %sp 4 #1487
	sw %a2 %sp 8 #1487
	sw %f0 %sp 16 #1487
	sw %ra %sp 28 #1487 call dir
	addi %sp %sp 32 #1487	
	jal %ra o_param_x.2308 #1487
	addi %sp %sp -32 #1487
	lw %ra %sp 28 #1487
	lw %f1 %sp 16 #1487
	fsub %f0 %f1 %f0 #1487
	lw %a0 %sp 8 #42
	lw %f1 %a0 4 #42
	lw %a1 %sp 4 #1488
	sw %f0 %sp 24 #1488
	sw %f1 %sp 32 #1488
	add %a0 %a1 %zero
	sw %ra %sp 44 #1488 call dir
	addi %sp %sp 48 #1488	
	jal %ra o_param_y.2310 #1488
	addi %sp %sp -48 #1488
	lw %ra %sp 44 #1488
	lw %f1 %sp 32 #1488
	fsub %f0 %f1 %f0 #1488
	lw %a0 %sp 8 #42
	lw %f1 %a0 8 #42
	lw %a0 %sp 4 #1489
	sw %f0 %sp 40 #1489
	sw %f1 %sp 48 #1489
	sw %ra %sp 60 #1489 call dir
	addi %sp %sp 64 #1489	
	jal %ra o_param_z.2312 #1489
	addi %sp %sp -64 #1489
	lw %ra %sp 60 #1489
	lw %f1 %sp 48 #1489
	fsub %f0 %f1 %f0 #1489
	lw %a0 %sp 4 #1491
	sw %f0 %sp 56 #1491
	sw %ra %sp 68 #1491 call dir
	addi %sp %sp 72 #1491	
	jal %ra o_param_a.2300 #1491
	addi %sp %sp -72 #1491
	lw %ra %sp 68 #1491
	lw %f1 %sp 24 #1491
	fmul %f0 %f1 %f0 #1491
	lw %a0 %sp 4 #1492
	sw %f0 %sp 64 #1492
	sw %ra %sp 76 #1492 call dir
	addi %sp %sp 80 #1492	
	jal %ra o_param_b.2302 #1492
	addi %sp %sp -80 #1492
	lw %ra %sp 76 #1492
	lw %f1 %sp 40 #1492
	fmul %f0 %f1 %f0 #1492
	lw %a0 %sp 4 #1493
	sw %f0 %sp 72 #1493
	sw %ra %sp 84 #1493 call dir
	addi %sp %sp 88 #1493	
	jal %ra o_param_c.2304 #1493
	addi %sp %sp -88 #1493
	lw %ra %sp 84 #1493
	lw %f1 %sp 56 #1493
	fmul %f0 %f1 %f0 #1493
	lw %a0 %sp 4 #1495
	sw %f0 %sp 80 #1495
	sw %ra %sp 92 #1495 call dir
	addi %sp %sp 96 #1495	
	jal %ra o_isrot.2298 #1495
	addi %sp %sp -96 #1495
	lw %ra %sp 92 #1495
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8696 # nontail if
	lw %a0 %sp 0 #1496
	lw %f0 %sp 64 #1496
	sw %f0 %a0 0 #1496
	lw %f0 %sp 72 #1497
	sw %f0 %a0 4 #1497
	lw %f0 %sp 80 #1498
	sw %f0 %a0 8 #1498
	jal %zero beq_cont.8697 # then sentence ends
beq_else.8696:
	lw %a0 %sp 4 #1500
	sw %ra %sp 92 #1500 call dir
	addi %sp %sp 96 #1500	
	jal %ra o_param_r3.2328 #1500
	addi %sp %sp -96 #1500
	lw %ra %sp 92 #1500
	lw %f1 %sp 40 #1500
	fmul %f0 %f1 %f0 #1500
	lw %a0 %sp 4 #1500
	sw %f0 %sp 88 #1500
	sw %ra %sp 100 #1500 call dir
	addi %sp %sp 104 #1500	
	jal %ra o_param_r2.2326 #1500
	addi %sp %sp -104 #1500
	lw %ra %sp 100 #1500
	lw %f1 %sp 56 #1500
	fmul %f0 %f1 %f0 #1500
	lw %f2 %sp 88 #1500
	fadd %f0 %f2 %f0 #1500
	sw %ra %sp 100 #1500 call dir
	addi %sp %sp 104 #1500	
	jal %ra min_caml_fhalf #1500
	addi %sp %sp -104 #1500
	lw %ra %sp 100 #1500
	lw %f1 %sp 64 #1500
	fadd %f0 %f1 %f0 #1500
	lw %a0 %sp 0 #1500
	sw %f0 %a0 0 #1500
	lw %a1 %sp 4 #1501
	add %a0 %a1 %zero
	sw %ra %sp 100 #1501 call dir
	addi %sp %sp 104 #1501	
	jal %ra o_param_r3.2328 #1501
	addi %sp %sp -104 #1501
	lw %ra %sp 100 #1501
	lw %f1 %sp 24 #1501
	fmul %f0 %f1 %f0 #1501
	lw %a0 %sp 4 #1501
	sw %f0 %sp 96 #1501
	sw %ra %sp 108 #1501 call dir
	addi %sp %sp 112 #1501	
	jal %ra o_param_r1.2324 #1501
	addi %sp %sp -112 #1501
	lw %ra %sp 108 #1501
	lw %f1 %sp 56 #1501
	fmul %f0 %f1 %f0 #1501
	lw %f1 %sp 96 #1501
	fadd %f0 %f1 %f0 #1501
	sw %ra %sp 108 #1501 call dir
	addi %sp %sp 112 #1501	
	jal %ra min_caml_fhalf #1501
	addi %sp %sp -112 #1501
	lw %ra %sp 108 #1501
	lw %f1 %sp 72 #1501
	fadd %f0 %f1 %f0 #1501
	lw %a0 %sp 0 #1501
	sw %f0 %a0 4 #1501
	lw %a1 %sp 4 #1502
	add %a0 %a1 %zero
	sw %ra %sp 108 #1502 call dir
	addi %sp %sp 112 #1502	
	jal %ra o_param_r2.2326 #1502
	addi %sp %sp -112 #1502
	lw %ra %sp 108 #1502
	lw %f1 %sp 24 #1502
	fmul %f0 %f1 %f0 #1502
	lw %a0 %sp 4 #1502
	sw %f0 %sp 104 #1502
	sw %ra %sp 116 #1502 call dir
	addi %sp %sp 120 #1502	
	jal %ra o_param_r1.2324 #1502
	addi %sp %sp -120 #1502
	lw %ra %sp 116 #1502
	lw %f1 %sp 40 #1502
	fmul %f0 %f1 %f0 #1502
	lw %f1 %sp 104 #1502
	fadd %f0 %f1 %f0 #1502
	sw %ra %sp 116 #1502 call dir
	addi %sp %sp 120 #1502	
	jal %ra min_caml_fhalf #1502
	addi %sp %sp -120 #1502
	lw %ra %sp 116 #1502
	lw %f1 %sp 80 #1502
	fadd %f0 %f1 %f0 #1502
	lw %a0 %sp 0 #1502
	sw %f0 %a0 8 #1502
beq_cont.8697:
	lw %a1 %sp 4 #1504
	add %a0 %a1 %zero
	sw %ra %sp 116 #1504 call dir
	addi %sp %sp 120 #1504	
	jal %ra o_isinvert.2296 #1504
	addi %sp %sp -120 #1504
	lw %ra %sp 116 #1504
	add %a1 %a0 %zero #1504
	lw %a0 %sp 0 #1504
	jal	%zero vecunit_sgn.2262
get_nvector.2556:
	lw %a2 %a11 12 #1508
	lw %a3 %a11 8 #1508
	lw %a4 %a11 4 #1508
	sw %a2 %sp 0 #1509
	sw %a0 %sp 4 #1509
	sw %a4 %sp 8 #1509
	sw %a1 %sp 12 #1509
	sw %a3 %sp 16 #1509
	sw %ra %sp 20 #1509 call dir
	addi %sp %sp 24 #1509	
	jal %ra o_form.2292 #1509
	addi %sp %sp -24 #1509
	lw %ra %sp 20 #1509
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8698
	lw %a0 %sp 12 #1511
	lw %a11 %sp 16 #1511
	lw %a10 %a11 0 #1511
	jalr %zero %a10 0 #1511
beq_else.8698:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8699
	lw %a0 %sp 4 #1513
	lw %a11 %sp 8 #1513
	lw %a10 %a11 0 #1513
	jalr %zero %a10 0 #1513
beq_else.8699:
	lw %a0 %sp 4 #1515
	lw %a11 %sp 0 #1515
	lw %a10 %a11 0 #1515
	jalr %zero %a10 0 #1515
utexture.2559:
	lw %a2 %a11 4 #1522
	sw %a1 %sp 0 #1523
	sw %a2 %sp 4 #1523
	sw %a0 %sp 8 #1523
	sw %ra %sp 12 #1523 call dir
	addi %sp %sp 16 #1523	
	jal %ra o_texturetype.2290 #1523
	addi %sp %sp -16 #1523
	lw %ra %sp 12 #1523
	lw %a1 %sp 8 #1525
	sw %a0 %sp 12 #1525
	add %a0 %a1 %zero
	sw %ra %sp 20 #1525 call dir
	addi %sp %sp 24 #1525	
	jal %ra o_color_red.2318 #1525
	addi %sp %sp -24 #1525
	lw %ra %sp 20 #1525
	lw %a0 %sp 4 #1525
	sw %f0 %a0 0 #1525
	lw %a1 %sp 8 #1526
	add %a0 %a1 %zero
	sw %ra %sp 20 #1526 call dir
	addi %sp %sp 24 #1526	
	jal %ra o_color_green.2320 #1526
	addi %sp %sp -24 #1526
	lw %ra %sp 20 #1526
	lw %a0 %sp 4 #1526
	sw %f0 %a0 4 #1526
	lw %a1 %sp 8 #1527
	add %a0 %a1 %zero
	sw %ra %sp 20 #1527 call dir
	addi %sp %sp 24 #1527	
	jal %ra o_color_blue.2322 #1527
	addi %sp %sp -24 #1527
	lw %ra %sp 20 #1527
	lw %a0 %sp 4 #1527
	sw %f0 %a0 8 #1527
	lw %a1 %sp 12 #1528
	addi %a12 %zero 1
	bne %a1 %a12 beq_else.8700
	lw %a1 %sp 0 #1531
	lw %f0 %a1 0 #1531
	lw %a2 %sp 8 #1531
	sw %f0 %sp 16 #1531
	add %a0 %a2 %zero
	sw %ra %sp 28 #1531 call dir
	addi %sp %sp 32 #1531	
	jal %ra o_param_x.2308 #1531
	addi %sp %sp -32 #1531
	lw %ra %sp 28 #1531
	lw %f1 %sp 16 #1531
	fsub %f0 %f1 %f0 #1531
	li %f1 l.6070 #1533
	fmul %f1 %f0 %f1 #1533
	sw %f0 %sp 24 #1533
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #1533 call dir
	addi %sp %sp 40 #1533	
	jal %ra min_caml_floor #1533
	addi %sp %sp -40 #1533
	lw %ra %sp 36 #1533
	li %f1 l.6072 #1533
	fmul %f0 %f0 %f1 #1533
	lw %f1 %sp 24 #1534
	fsub %f0 %f1 %f0 #1534
	li %f1 l.6053 #1534
	sw %ra %sp 36 #1534 call dir
	addi %sp %sp 40 #1534	
	jal %ra min_caml_fless #1534
	addi %sp %sp -40 #1534
	lw %ra %sp 36 #1534
	lw %a1 %sp 0 #1531
	lw %f0 %a1 8 #1531
	lw %a1 %sp 8 #1536
	sw %a0 %sp 32 #1536
	sw %f0 %sp 40 #1536
	add %a0 %a1 %zero
	sw %ra %sp 52 #1536 call dir
	addi %sp %sp 56 #1536	
	jal %ra o_param_z.2312 #1536
	addi %sp %sp -56 #1536
	lw %ra %sp 52 #1536
	lw %f1 %sp 40 #1536
	fsub %f0 %f1 %f0 #1536
	li %f1 l.6070 #1538
	fmul %f1 %f0 %f1 #1538
	sw %f0 %sp 48 #1538
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #1538 call dir
	addi %sp %sp 64 #1538	
	jal %ra min_caml_floor #1538
	addi %sp %sp -64 #1538
	lw %ra %sp 60 #1538
	li %f1 l.6072 #1538
	fmul %f0 %f0 %f1 #1538
	lw %f1 %sp 48 #1539
	fsub %f0 %f1 %f0 #1539
	li %f1 l.6053 #1539
	sw %ra %sp 60 #1539 call dir
	addi %sp %sp 64 #1539	
	jal %ra min_caml_fless #1539
	addi %sp %sp -64 #1539
	lw %ra %sp 60 #1539
	lw %a1 %sp 32 #784
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8702 # nontail if
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8704 # nontail if
	li %f0 l.6046 #1544
	jal %zero beq_cont.8705 # then sentence ends
beq_else.8704:
	li %f0 l.5553 #1544
beq_cont.8705:
	jal %zero beq_cont.8703 # then sentence ends
beq_else.8702:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8706 # nontail if
	li %f0 l.5553 #1543
	jal %zero beq_cont.8707 # then sentence ends
beq_else.8706:
	li %f0 l.6046 #1543
beq_cont.8707:
beq_cont.8703:
	lw %a0 %sp 4 #1541
	sw %f0 %a0 4 #1541
	jalr %zero %ra 0 #1541
beq_else.8700:
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8709
	lw %a1 %sp 0 #1531
	lw %f0 %a1 4 #1531
	li %f1 l.6062 #1549
	fmul %f0 %f0 %f1 #1549
	sw %ra %sp 60 #1549 call dir
	addi %sp %sp 64 #1549	
	jal %ra min_caml_sin #1549
	addi %sp %sp -64 #1549
	lw %ra %sp 60 #1549
	sw %ra %sp 60 #1549 call dir
	addi %sp %sp 64 #1549	
	jal %ra min_caml_fsqr #1549
	addi %sp %sp -64 #1549
	lw %ra %sp 60 #1549
	li %f1 l.6046 #1550
	fmul %f1 %f1 %f0 #1550
	lw %a0 %sp 4 #1550
	sw %f1 %a0 0 #1550
	li %f1 l.6046 #1551
	li %f2 l.5555 #1551
	fsub %f0 %f2 %f0 #1551
	fmul %f0 %f1 %f0 #1551
	sw %f0 %a0 4 #1551
	jalr %zero %ra 0 #1551
beq_else.8709:
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.8711
	lw %a1 %sp 0 #1531
	lw %f0 %a1 0 #1531
	lw %a2 %sp 8 #1556
	sw %f0 %sp 56 #1556
	add %a0 %a2 %zero
	sw %ra %sp 68 #1556 call dir
	addi %sp %sp 72 #1556	
	jal %ra o_param_x.2308 #1556
	addi %sp %sp -72 #1556
	lw %ra %sp 68 #1556
	lw %f1 %sp 56 #1556
	fsub %f0 %f1 %f0 #1556
	lw %a0 %sp 0 #1531
	lw %f1 %a0 8 #1531
	lw %a0 %sp 8 #1557
	sw %f0 %sp 64 #1557
	sw %f1 %sp 72 #1557
	sw %ra %sp 84 #1557 call dir
	addi %sp %sp 88 #1557	
	jal %ra o_param_z.2312 #1557
	addi %sp %sp -88 #1557
	lw %ra %sp 84 #1557
	lw %f1 %sp 72 #1557
	fsub %f0 %f1 %f0 #1557
	lw %f1 %sp 64 #1558
	sw %f0 %sp 80 #1558
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #1558 call dir
	addi %sp %sp 96 #1558	
	jal %ra min_caml_fsqr #1558
	addi %sp %sp -96 #1558
	lw %ra %sp 92 #1558
	lw %f1 %sp 80 #1558
	sw %f0 %sp 88 #1558
	fadd %f0 %f1 %fzero
	sw %ra %sp 100 #1558 call dir
	addi %sp %sp 104 #1558	
	jal %ra min_caml_fsqr #1558
	addi %sp %sp -104 #1558
	lw %ra %sp 100 #1558
	lw %f1 %sp 88 #1558
	fadd %f0 %f1 %f0 #1558
	sw %ra %sp 100 #1558 call dir
	addi %sp %sp 104 #1558	
	jal %ra min_caml_sqrt #1558
	addi %sp %sp -104 #1558
	lw %ra %sp 100 #1558
	li %f1 l.6053 #1558
	fdiv %f0 %f0 %f1 #1558
	sw %f0 %sp 96 #1559
	sw %ra %sp 108 #1559 call dir
	addi %sp %sp 112 #1559	
	jal %ra min_caml_floor #1559
	addi %sp %sp -112 #1559
	lw %ra %sp 108 #1559
	lw %f1 %sp 96 #1559
	fsub %f0 %f1 %f0 #1559
	li %f1 l.6033 #1559
	fmul %f0 %f0 %f1 #1559
	sw %ra %sp 108 #1560 call dir
	addi %sp %sp 112 #1560	
	jal %ra min_caml_cos #1560
	addi %sp %sp -112 #1560
	lw %ra %sp 108 #1560
	sw %ra %sp 108 #1560 call dir
	addi %sp %sp 112 #1560	
	jal %ra min_caml_fsqr #1560
	addi %sp %sp -112 #1560
	lw %ra %sp 108 #1560
	li %f1 l.6046 #1561
	fmul %f1 %f0 %f1 #1561
	lw %a0 %sp 4 #1561
	sw %f1 %a0 4 #1561
	li %f1 l.5555 #1562
	fsub %f0 %f1 %f0 #1562
	li %f1 l.6046 #1562
	fmul %f0 %f0 %f1 #1562
	sw %f0 %a0 8 #1562
	jalr %zero %ra 0 #1562
beq_else.8711:
	addi %a12 %zero 4
	bne %a1 %a12 beq_else.8713
	lw %a1 %sp 0 #1531
	lw %f0 %a1 0 #1531
	lw %a2 %sp 8 #1566
	sw %f0 %sp 104 #1566
	add %a0 %a2 %zero
	sw %ra %sp 116 #1566 call dir
	addi %sp %sp 120 #1566	
	jal %ra o_param_x.2308 #1566
	addi %sp %sp -120 #1566
	lw %ra %sp 116 #1566
	lw %f1 %sp 104 #1566
	fsub %f0 %f1 %f0 #1566
	lw %a0 %sp 8 #1566
	sw %f0 %sp 112 #1566
	sw %ra %sp 124 #1566 call dir
	addi %sp %sp 128 #1566	
	jal %ra o_param_a.2300 #1566
	addi %sp %sp -128 #1566
	lw %ra %sp 124 #1566
	sw %ra %sp 124 #1566 call dir
	addi %sp %sp 128 #1566	
	jal %ra min_caml_sqrt #1566
	addi %sp %sp -128 #1566
	lw %ra %sp 124 #1566
	lw %f1 %sp 112 #1566
	fmul %f0 %f1 %f0 #1566
	lw %a0 %sp 0 #1531
	lw %f1 %a0 8 #1531
	lw %a1 %sp 8 #1567
	sw %f0 %sp 120 #1567
	sw %f1 %sp 128 #1567
	add %a0 %a1 %zero
	sw %ra %sp 140 #1567 call dir
	addi %sp %sp 144 #1567	
	jal %ra o_param_z.2312 #1567
	addi %sp %sp -144 #1567
	lw %ra %sp 140 #1567
	lw %f1 %sp 128 #1567
	fsub %f0 %f1 %f0 #1567
	lw %a0 %sp 8 #1567
	sw %f0 %sp 136 #1567
	sw %ra %sp 148 #1567 call dir
	addi %sp %sp 152 #1567	
	jal %ra o_param_c.2304 #1567
	addi %sp %sp -152 #1567
	lw %ra %sp 148 #1567
	sw %ra %sp 148 #1567 call dir
	addi %sp %sp 152 #1567	
	jal %ra min_caml_sqrt #1567
	addi %sp %sp -152 #1567
	lw %ra %sp 148 #1567
	lw %f1 %sp 136 #1567
	fmul %f0 %f1 %f0 #1567
	lw %f1 %sp 120 #1568
	sw %f0 %sp 144 #1568
	fadd %f0 %f1 %fzero
	sw %ra %sp 156 #1568 call dir
	addi %sp %sp 160 #1568	
	jal %ra min_caml_fsqr #1568
	addi %sp %sp -160 #1568
	lw %ra %sp 156 #1568
	lw %f1 %sp 144 #1568
	sw %f0 %sp 152 #1568
	fadd %f0 %f1 %fzero
	sw %ra %sp 164 #1568 call dir
	addi %sp %sp 168 #1568	
	jal %ra min_caml_fsqr #1568
	addi %sp %sp -168 #1568
	lw %ra %sp 164 #1568
	lw %f1 %sp 152 #1568
	fadd %f0 %f1 %f0 #1568
	lw %f1 %sp 120 #1570
	sw %f0 %sp 160 #1570
	fadd %f0 %f1 %fzero
	sw %ra %sp 172 #1570 call dir
	addi %sp %sp 176 #1570	
	jal %ra min_caml_fabs #1570
	addi %sp %sp -176 #1570
	lw %ra %sp 172 #1570
	li %f1 l.6027 #1570
	sw %ra %sp 172 #1570 call dir
	addi %sp %sp 176 #1570	
	jal %ra min_caml_fless #1570
	addi %sp %sp -176 #1570
	lw %ra %sp 172 #1570
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8714 # nontail if
	lw %f0 %sp 120 #1573
	lw %f1 %sp 144 #1573
	fdiv %f0 %f1 %f0 #1573
	sw %ra %sp 172 #1573 call dir
	addi %sp %sp 176 #1573	
	jal %ra min_caml_fabs #1573
	addi %sp %sp -176 #1573
	lw %ra %sp 172 #1573
	sw %ra %sp 172 #1575 call dir
	addi %sp %sp 176 #1575	
	jal %ra min_caml_atan #1575
	addi %sp %sp -176 #1575
	lw %ra %sp 172 #1575
	li %f1 l.6031 #1575
	fmul %f0 %f0 %f1 #1575
	li %f1 l.6033 #1575
	fdiv %f0 %f0 %f1 #1575
	jal %zero beq_cont.8715 # then sentence ends
beq_else.8714:
	li %f0 l.6029 #1571
beq_cont.8715:
	sw %f0 %sp 168 #1577
	sw %ra %sp 180 #1577 call dir
	addi %sp %sp 184 #1577	
	jal %ra min_caml_floor #1577
	addi %sp %sp -184 #1577
	lw %ra %sp 180 #1577
	lw %f1 %sp 168 #1577
	fsub %f0 %f1 %f0 #1577
	lw %a0 %sp 0 #1531
	lw %f1 %a0 4 #1531
	lw %a0 %sp 8 #1579
	sw %f0 %sp 176 #1579
	sw %f1 %sp 184 #1579
	sw %ra %sp 196 #1579 call dir
	addi %sp %sp 200 #1579	
	jal %ra o_param_y.2310 #1579
	addi %sp %sp -200 #1579
	lw %ra %sp 196 #1579
	lw %f1 %sp 184 #1579
	fsub %f0 %f1 %f0 #1579
	lw %a0 %sp 8 #1579
	sw %f0 %sp 192 #1579
	sw %ra %sp 204 #1579 call dir
	addi %sp %sp 208 #1579	
	jal %ra o_param_b.2302 #1579
	addi %sp %sp -208 #1579
	lw %ra %sp 204 #1579
	sw %ra %sp 204 #1579 call dir
	addi %sp %sp 208 #1579	
	jal %ra min_caml_sqrt #1579
	addi %sp %sp -208 #1579
	lw %ra %sp 204 #1579
	lw %f1 %sp 192 #1579
	fmul %f0 %f1 %f0 #1579
	lw %f1 %sp 160 #1581
	sw %f0 %sp 200 #1581
	fadd %f0 %f1 %fzero
	sw %ra %sp 212 #1581 call dir
	addi %sp %sp 216 #1581	
	jal %ra min_caml_fabs #1581
	addi %sp %sp -216 #1581
	lw %ra %sp 212 #1581
	li %f1 l.6027 #1581
	sw %ra %sp 212 #1581 call dir
	addi %sp %sp 216 #1581	
	jal %ra min_caml_fless #1581
	addi %sp %sp -216 #1581
	lw %ra %sp 212 #1581
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8716 # nontail if
	lw %f0 %sp 160 #1584
	lw %f1 %sp 200 #1584
	fdiv %f0 %f1 %f0 #1584
	sw %ra %sp 212 #1584 call dir
	addi %sp %sp 216 #1584	
	jal %ra min_caml_fabs #1584
	addi %sp %sp -216 #1584
	lw %ra %sp 212 #1584
	sw %ra %sp 212 #1585 call dir
	addi %sp %sp 216 #1585	
	jal %ra min_caml_atan #1585
	addi %sp %sp -216 #1585
	lw %ra %sp 212 #1585
	li %f1 l.6031 #1585
	fmul %f0 %f0 %f1 #1585
	li %f1 l.6033 #1585
	fdiv %f0 %f0 %f1 #1585
	jal %zero beq_cont.8717 # then sentence ends
beq_else.8716:
	li %f0 l.6029 #1582
beq_cont.8717:
	sw %f0 %sp 208 #1587
	sw %ra %sp 220 #1587 call dir
	addi %sp %sp 224 #1587	
	jal %ra min_caml_floor #1587
	addi %sp %sp -224 #1587
	lw %ra %sp 220 #1587
	lw %f1 %sp 208 #1587
	fsub %f0 %f1 %f0 #1587
	li %f1 l.6040 #1588
	li %f2 l.6042 #1588
	lw %f3 %sp 176 #1588
	fsub %f2 %f2 %f3 #1588
	sw %f0 %sp 216 #1588
	sw %f1 %sp 224 #1588
	fadd %f0 %f2 %fzero
	sw %ra %sp 236 #1588 call dir
	addi %sp %sp 240 #1588	
	jal %ra min_caml_fsqr #1588
	addi %sp %sp -240 #1588
	lw %ra %sp 236 #1588
	lw %f1 %sp 224 #1588
	fsub %f0 %f1 %f0 #1588
	li %f1 l.6042 #1588
	lw %f2 %sp 216 #1588
	fsub %f1 %f1 %f2 #1588
	sw %f0 %sp 232 #1588
	fadd %f0 %f1 %fzero
	sw %ra %sp 244 #1588 call dir
	addi %sp %sp 248 #1588	
	jal %ra min_caml_fsqr #1588
	addi %sp %sp -248 #1588
	lw %ra %sp 244 #1588
	lw %f1 %sp 232 #1588
	fsub %f0 %f1 %f0 #1588
	sw %f0 %sp 240 #1589
	sw %ra %sp 252 #1589 call dir
	addi %sp %sp 256 #1589	
	jal %ra min_caml_fisneg #1589
	addi %sp %sp -256 #1589
	lw %ra %sp 252 #1589
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8718 # nontail if
	lw %f0 %sp 240 #1588
	jal %zero beq_cont.8719 # then sentence ends
beq_else.8718:
	li %f0 l.5553 #1589
beq_cont.8719:
	li %f1 l.6046 #1590
	fmul %f0 %f1 %f0 #1590
	li %f1 l.6048 #1590
	fdiv %f0 %f0 %f1 #1590
	lw %a0 %sp 4 #1590
	sw %f0 %a0 8 #1590
	jalr %zero %ra 0 #1590
beq_else.8713:
	jalr %zero %ra 0 #1592
add_light.2562:
	lw %a0 %a11 8 #1598
	lw %a1 %a11 4 #1598
	sw %f2 %sp 0 #1601
	sw %f1 %sp 8 #1601
	sw %f0 %sp 16 #1601
	sw %a0 %sp 24 #1601
	sw %a1 %sp 28 #1601
	sw %ra %sp 36 #1601 call dir
	addi %sp %sp 40 #1601	
	jal %ra min_caml_fispos #1601
	addi %sp %sp -40 #1601
	lw %ra %sp 36 #1601
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8722 # nontail if
	jal %zero beq_cont.8723 # then sentence ends
beq_else.8722:
	lw %f0 %sp 16 #1602
	lw %a0 %sp 28 #1602
	lw %a1 %sp 24 #1602
	sw %ra %sp 36 #1602 call dir
	addi %sp %sp 40 #1602	
	jal %ra vecaccum.2273 #1602
	addi %sp %sp -40 #1602
	lw %ra %sp 36 #1602
beq_cont.8723:
	lw %f0 %sp 8 #1606
	sw %ra %sp 36 #1606 call dir
	addi %sp %sp 40 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -40 #1606
	lw %ra %sp 36 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8724
	jalr %zero %ra 0 #1611
beq_else.8724:
	lw %f0 %sp 8 #1607
	sw %ra %sp 36 #1607 call dir
	addi %sp %sp 40 #1607	
	jal %ra min_caml_fsqr #1607
	addi %sp %sp -40 #1607
	lw %ra %sp 36 #1607
	sw %ra %sp 36 #1607 call dir
	addi %sp %sp 40 #1607	
	jal %ra min_caml_fsqr #1607
	addi %sp %sp -40 #1607
	lw %ra %sp 36 #1607
	lw %f1 %sp 0 #1607
	fmul %f0 %f0 %f1 #1607
	lw %a0 %sp 28 #53
	lw %f1 %a0 0 #53
	fadd %f1 %f1 %f0 #1608
	sw %f1 %a0 0 #1608
	lw %f1 %a0 4 #53
	fadd %f1 %f1 %f0 #1609
	sw %f1 %a0 4 #1609
	lw %f1 %a0 8 #53
	fadd %f0 %f1 %f0 #1610
	sw %f0 %a0 8 #1610
	jalr %zero %ra 0 #1610
trace_reflections.2566:
	lw %a2 %a11 32 #1615
	lw %a3 %a11 28 #1615
	lw %a4 %a11 24 #1615
	lw %a5 %a11 20 #1615
	lw %a6 %a11 16 #1615
	lw %a7 %a11 12 #1615
	lw %a8 %a11 8 #1615
	lw %a9 %a11 4 #1615
	addi %a10 %zero 0 #1617
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8727
	sw %a11 %sp 0 #94
	slli %a11 %a0 2 #94
	add %a12 %a3 %a11 #94
	lw %a3 %a12 0 #94
	sw %a0 %sp 4 #1619
	sw %f1 %sp 8 #1619
	sw %a9 %sp 16 #1619
	sw %a1 %sp 20 #1619
	sw %f0 %sp 24 #1619
	sw %a5 %sp 32 #1619
	sw %a10 %sp 36 #1619
	sw %a2 %sp 40 #1619
	sw %a4 %sp 44 #1619
	sw %a3 %sp 48 #1619
	sw %a7 %sp 52 #1619
	sw %a8 %sp 56 #1619
	sw %a6 %sp 60 #1619
	add %a0 %a3 %zero
	sw %ra %sp 68 #1619 call dir
	addi %sp %sp 72 #1619	
	jal %ra r_dvec.2357 #1619
	addi %sp %sp -72 #1619
	lw %ra %sp 68 #1619
	lw %a11 %sp 60 #1622
	sw %a0 %sp 64 #1622
	sw %ra %sp 68 #1622 call cls
	lw %a10 %a11 0 #1622
	addi %sp %sp 72 #1622	
	jalr %ra %a10 0 #1622
	addi %sp %sp -72 #1622
	lw %ra %sp 68 #1622
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8728 # nontail if
	jal %zero beq_cont.8729 # then sentence ends
beq_else.8728:
	lw %a0 %sp 56 #44
	lw %a0 %a0 0 #44
	addi %a1 %zero 4 #1623
	sw %ra %sp 68 #1623 call dir
	addi %sp %sp 72 #1623	
	jal %ra min_caml_sll #1623
	addi %sp %sp -72 #1623
	lw %ra %sp 68 #1623
	lw %a1 %sp 52 #38
	lw %a1 %a1 0 #38
	add %a0 %a0 %a1 #1623
	lw %a1 %sp 48 #1625
	sw %a0 %sp 68 #1625
	add %a0 %a1 %zero
	sw %ra %sp 76 #1625 call dir
	addi %sp %sp 80 #1625	
	jal %ra r_surface_id.2355 #1625
	addi %sp %sp -80 #1625
	lw %ra %sp 76 #1625
	lw %a1 %sp 68 #1623
	bne %a1 %a0 beq_else.8730 # nontail if
	lw %a0 %sp 44 #32
	lw %a1 %a0 0 #32
	lw %a0 %sp 36 #1627
	lw %a11 %sp 40 #1627
	sw %ra %sp 76 #1627 call cls
	lw %a10 %a11 0 #1627
	addi %sp %sp 80 #1627	
	jalr %ra %a10 0 #1627
	addi %sp %sp -80 #1627
	lw %ra %sp 76 #1627
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8732 # nontail if
	lw %a0 %sp 64 #1629
	sw %ra %sp 76 #1629 call dir
	addi %sp %sp 80 #1629	
	jal %ra d_vec.2351 #1629
	addi %sp %sp -80 #1629
	lw %ra %sp 76 #1629
	add %a1 %a0 %zero #1629
	lw %a0 %sp 32 #1629
	sw %ra %sp 76 #1629 call dir
	addi %sp %sp 80 #1629	
	jal %ra veciprod.2265 #1629
	addi %sp %sp -80 #1629
	lw %ra %sp 76 #1629
	lw %a0 %sp 48 #1630
	sw %f0 %sp 72 #1630
	sw %ra %sp 84 #1630 call dir
	addi %sp %sp 88 #1630	
	jal %ra r_bright.2359 #1630
	addi %sp %sp -88 #1630
	lw %ra %sp 84 #1630
	lw %f1 %sp 24 #1631
	fmul %f2 %f0 %f1 #1631
	lw %f3 %sp 72 #1631
	fmul %f2 %f2 %f3 #1631
	lw %a0 %sp 64 #1632
	sw %f2 %sp 80 #1632
	sw %f0 %sp 88 #1632
	sw %ra %sp 100 #1632 call dir
	addi %sp %sp 104 #1632	
	jal %ra d_vec.2351 #1632
	addi %sp %sp -104 #1632
	lw %ra %sp 100 #1632
	add %a1 %a0 %zero #1632
	lw %a0 %sp 20 #1632
	sw %ra %sp 100 #1632 call dir
	addi %sp %sp 104 #1632	
	jal %ra veciprod.2265 #1632
	addi %sp %sp -104 #1632
	lw %ra %sp 100 #1632
	lw %f1 %sp 88 #1632
	fmul %f1 %f1 %f0 #1632
	lw %f0 %sp 80 #1633
	lw %f2 %sp 8 #1633
	lw %a11 %sp 16 #1633
	sw %ra %sp 100 #1633 call cls
	lw %a10 %a11 0 #1633
	addi %sp %sp 104 #1633	
	jalr %ra %a10 0 #1633
	addi %sp %sp -104 #1633
	lw %ra %sp 100 #1633
	jal %zero beq_cont.8733 # then sentence ends
beq_else.8732:
beq_cont.8733:
	jal %zero beq_cont.8731 # then sentence ends
beq_else.8730:
beq_cont.8731:
beq_cont.8729:
	lw %a0 %sp 4 #1637
	addi %a0 %a0 -1 #1637
	lw %f0 %sp 24 #1637
	lw %f1 %sp 8 #1637
	lw %a1 %sp 20 #1637
	lw %a11 %sp 0 #1637
	lw %a10 %a11 0 #1637
	jalr %zero %a10 0 #1637
bge_else.8727:
	jalr %zero %ra 0 #1638
trace_ray.2571:
	lw %a3 %a11 80 #1643
	lw %a4 %a11 76 #1643
	lw %a5 %a11 72 #1643
	lw %a6 %a11 68 #1643
	lw %a7 %a11 64 #1643
	lw %a8 %a11 60 #1643
	lw %a9 %a11 56 #1643
	lw %a10 %a11 52 #1643
	sw %a5 %sp 0 #1643
	lw %a5 %a11 48 #1643
	sw %a4 %sp 4 #1643
	lw %a4 %a11 44 #1643
	sw %a9 %sp 8 #1643
	lw %a9 %a11 40 #1643
	sw %a8 %sp 12 #1643
	lw %a8 %a11 36 #1643
	sw %a8 %sp 16 #1643
	lw %a8 %a11 32 #1643
	sw %a5 %sp 20 #1643
	lw %a5 %a11 28 #1643
	sw %a9 %sp 24 #1643
	lw %a9 %a11 24 #1643
	sw %a6 %sp 28 #1643
	lw %a6 %a11 20 #1643
	sw %a9 %sp 32 #1643
	lw %a9 %a11 16 #1643
	sw %a3 %sp 36 #1643
	lw %a3 %a11 12 #1643
	sw %a6 %sp 40 #1643
	lw %a6 %a11 8 #1643
	sw %a11 %sp 44 #1643
	lw %a11 %a11 4 #1643
	sw %a11 %sp 48 #1644
	addi %a11 %zero 4 #1644
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.8735
	sw %f1 %sp 56 #1645
	sw %a2 %sp 64 #1645
	sw %a11 %sp 68 #1645
	sw %a7 %sp 72 #1645
	sw %a3 %sp 76 #1645
	sw %a4 %sp 80 #1645
	sw %a9 %sp 84 #1645
	sw %a10 %sp 88 #1645
	sw %a6 %sp 92 #1645
	sw %f0 %sp 96 #1645
	sw %a8 %sp 104 #1645
	sw %a0 %sp 108 #1645
	sw %a1 %sp 112 #1645
	sw %a5 %sp 116 #1645
	add %a0 %a2 %zero
	sw %ra %sp 124 #1645 call dir
	addi %sp %sp 128 #1645	
	jal %ra p_surface_ids.2336 #1645
	addi %sp %sp -128 #1645
	lw %ra %sp 124 #1645
	lw %a1 %sp 112 #1646
	lw %a11 %sp 116 #1646
	sw %a0 %sp 120 #1646
	add %a0 %a1 %zero
	sw %ra %sp 124 #1646 call cls
	lw %a10 %a11 0 #1646
	addi %sp %sp 128 #1646	
	jalr %ra %a10 0 #1646
	addi %sp %sp -128 #1646
	lw %ra %sp 124 #1646
	addi %a1 %zero 0 #1646
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8737
	addi %a0 %zero 1 #1710
	sub %a0 %zero %a0 #1710
	lw %a1 %sp 108 #1710
	slli %a2 %a1 2 #1710
	lw %a3 %sp 120 #1710
	add %a12 %a3 %a2 #1710
	sw %a0 %a12 0 #1710
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8738
	jalr %zero %ra 0 #1724
beq_else.8738:
	lw %a0 %sp 112 #1713
	lw %a1 %sp 104 #1713
	sw %ra %sp 124 #1713 call dir
	addi %sp %sp 128 #1713	
	jal %ra veciprod.2265 #1713
	addi %sp %sp -128 #1713
	lw %ra %sp 124 #1713
	sw %ra %sp 124 #1713 call dir
	addi %sp %sp 128 #1713	
	jal %ra min_caml_fneg #1713
	addi %sp %sp -128 #1713
	lw %ra %sp 124 #1713
	sw %f0 %sp 128 #1715
	sw %ra %sp 140 #1715 call dir
	addi %sp %sp 144 #1715	
	jal %ra min_caml_fispos #1715
	addi %sp %sp -144 #1715
	lw %ra %sp 140 #1715
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8741
	jalr %zero %ra 0 #1723
beq_else.8741:
	lw %f0 %sp 128 #1718
	sw %ra %sp 140 #1718 call dir
	addi %sp %sp 144 #1718	
	jal %ra min_caml_fsqr #1718
	addi %sp %sp -144 #1718
	lw %ra %sp 140 #1718
	lw %f1 %sp 128 #1718
	fmul %f0 %f0 %f1 #1718
	lw %f1 %sp 96 #1718
	fmul %f0 %f0 %f1 #1718
	lw %a0 %sp 92 #28
	lw %f1 %a0 0 #28
	fmul %f0 %f0 %f1 #1718
	lw %a0 %sp 88 #53
	lw %f1 %a0 0 #53
	fadd %f1 %f1 %f0 #1719
	sw %f1 %a0 0 #1719
	lw %f1 %a0 4 #53
	fadd %f1 %f1 %f0 #1720
	sw %f1 %a0 4 #1720
	lw %f1 %a0 8 #53
	fadd %f0 %f1 %f0 #1721
	sw %f0 %a0 8 #1721
	jalr %zero %ra 0 #1721
beq_else.8737:
	lw %a0 %sp 84 #44
	lw %a0 %a0 0 #44
	slli %a2 %a0 2 #19
	lw %a3 %sp 80 #19
	add %a12 %a3 %a2 #19
	lw %a2 %a12 0 #19
	sw %a1 %sp 136 #1650
	sw %a0 %sp 140 #1650
	sw %a2 %sp 144 #1650
	add %a0 %a2 %zero
	sw %ra %sp 148 #1650 call dir
	addi %sp %sp 152 #1650	
	jal %ra o_reflectiontype.2294 #1650
	addi %sp %sp -152 #1650
	lw %ra %sp 148 #1650
	lw %a1 %sp 144 #1651
	sw %a0 %sp 148 #1651
	add %a0 %a1 %zero
	sw %ra %sp 156 #1651 call dir
	addi %sp %sp 160 #1651	
	jal %ra o_diffuse.2314 #1651
	addi %sp %sp -160 #1651
	lw %ra %sp 156 #1651
	lw %f1 %sp 96 #1651
	fmul %f0 %f0 %f1 #1651
	lw %a0 %sp 144 #1653
	lw %a1 %sp 112 #1653
	lw %a11 %sp 76 #1653
	sw %f0 %sp 152 #1653
	sw %ra %sp 164 #1653 call cls
	lw %a10 %a11 0 #1653
	addi %sp %sp 168 #1653	
	jalr %ra %a10 0 #1653
	addi %sp %sp -168 #1653
	lw %ra %sp 164 #1653
	lw %a0 %sp 72 #1654
	lw %a1 %sp 40 #1654
	sw %ra %sp 164 #1654 call dir
	addi %sp %sp 168 #1654	
	jal %ra veccpy.2254 #1654
	addi %sp %sp -168 #1654
	lw %ra %sp 164 #1654
	lw %a0 %sp 144 #1655
	lw %a1 %sp 40 #1655
	lw %a11 %sp 36 #1655
	sw %ra %sp 164 #1655 call cls
	lw %a10 %a11 0 #1655
	addi %sp %sp 168 #1655	
	jalr %ra %a10 0 #1655
	addi %sp %sp -168 #1655
	lw %ra %sp 164 #1655
	lw %a0 %sp 140 #1658
	lw %a1 %sp 68 #1658
	sw %ra %sp 164 #1658 call dir
	addi %sp %sp 168 #1658	
	jal %ra min_caml_sll #1658
	addi %sp %sp -168 #1658
	lw %ra %sp 164 #1658
	lw %a1 %sp 32 #38
	lw %a1 %a1 0 #38
	add %a0 %a0 %a1 #1658
	lw %a1 %sp 108 #1658
	slli %a2 %a1 2 #1658
	lw %a3 %sp 120 #1658
	add %a12 %a3 %a2 #1658
	sw %a0 %a12 0 #1658
	lw %a0 %sp 64 #1660
	sw %ra %sp 164 #1660 call dir
	addi %sp %sp 168 #1660	
	jal %ra p_intersection_points.2334 #1660
	addi %sp %sp -168 #1660
	lw %ra %sp 164 #1660
	lw %a1 %sp 108 #1661
	slli %a2 %a1 2 #1661
	add %a12 %a0 %a2 #1661
	lw %a0 %a12 0 #1661
	lw %a2 %sp 40 #1661
	add %a1 %a2 %zero
	sw %ra %sp 164 #1661 call dir
	addi %sp %sp 168 #1661	
	jal %ra veccpy.2254 #1661
	addi %sp %sp -168 #1661
	lw %ra %sp 164 #1661
	lw %a0 %sp 64 #1664
	sw %ra %sp 164 #1664 call dir
	addi %sp %sp 168 #1664	
	jal %ra p_calc_diffuse.2338 #1664
	addi %sp %sp -168 #1664
	lw %ra %sp 164 #1664
	lw %a1 %sp 144 #1665
	sw %a0 %sp 160 #1665
	add %a0 %a1 %zero
	sw %ra %sp 164 #1665 call dir
	addi %sp %sp 168 #1665	
	jal %ra o_diffuse.2314 #1665
	addi %sp %sp -168 #1665
	lw %ra %sp 164 #1665
	li %f1 l.6042 #1665
	sw %ra %sp 164 #1665 call dir
	addi %sp %sp 168 #1665	
	jal %ra min_caml_fless #1665
	addi %sp %sp -168 #1665
	lw %ra %sp 164 #1665
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8744 # nontail if
	addi %a0 %zero 1 #1668
	lw %a1 %sp 108 #1668
	slli %a2 %a1 2 #1668
	lw %a3 %sp 160 #1668
	add %a12 %a3 %a2 #1668
	sw %a0 %a12 0 #1668
	lw %a0 %sp 64 #1669
	sw %ra %sp 164 #1669 call dir
	addi %sp %sp 168 #1669	
	jal %ra p_energy.2340 #1669
	addi %sp %sp -168 #1669
	lw %ra %sp 164 #1669
	lw %a1 %sp 108 #1670
	slli %a2 %a1 2 #1670
	add %a12 %a0 %a2 #1670
	lw %a2 %a12 0 #1670
	lw %a3 %sp 28 #1670
	sw %a0 %sp 164 #1670
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 172 #1670 call dir
	addi %sp %sp 176 #1670	
	jal %ra veccpy.2254 #1670
	addi %sp %sp -176 #1670
	lw %ra %sp 172 #1670
	lw %a0 %sp 108 #1670
	slli %a1 %a0 2 #1670
	lw %a2 %sp 164 #1670
	add %a12 %a2 %a1 #1670
	lw %a1 %a12 0 #1670
	li %f0 l.5555 #1671
	li %f1 l.6105 #1671
	fdiv %f0 %f0 %f1 #1671
	lw %f1 %sp 152 #1671
	fmul %f0 %f0 %f1 #1671
	add %a0 %a1 %zero
	sw %ra %sp 172 #1671 call dir
	addi %sp %sp 176 #1671	
	jal %ra vecscale.2283 #1671
	addi %sp %sp -176 #1671
	lw %ra %sp 172 #1671
	lw %a0 %sp 64 #1672
	sw %ra %sp 172 #1672 call dir
	addi %sp %sp 176 #1672	
	jal %ra p_nvectors.2349 #1672
	addi %sp %sp -176 #1672
	lw %ra %sp 172 #1672
	lw %a1 %sp 108 #1673
	slli %a2 %a1 2 #1673
	add %a12 %a0 %a2 #1673
	lw %a0 %a12 0 #1673
	lw %a2 %sp 24 #1673
	add %a1 %a2 %zero
	sw %ra %sp 172 #1673 call dir
	addi %sp %sp 176 #1673	
	jal %ra veccpy.2254 #1673
	addi %sp %sp -176 #1673
	lw %ra %sp 172 #1673
	jal %zero beq_cont.8745 # then sentence ends
beq_else.8744:
	lw %a0 %sp 108 #1666
	slli %a1 %a0 2 #1666
	lw %a2 %sp 160 #1666
	lw %a3 %sp 136 #1666
	add %a12 %a2 %a1 #1666
	sw %a3 %a12 0 #1666
beq_cont.8745:
	li %f0 l.6108 #1676
	lw %a0 %sp 112 #1676
	lw %a1 %sp 24 #1676
	sw %f0 %sp 168 #1676
	sw %ra %sp 180 #1676 call dir
	addi %sp %sp 184 #1676	
	jal %ra veciprod.2265 #1676
	addi %sp %sp -184 #1676
	lw %ra %sp 180 #1676
	lw %f1 %sp 168 #1676
	fmul %f0 %f1 %f0 #1676
	lw %a0 %sp 112 #1678
	lw %a1 %sp 24 #1678
	sw %ra %sp 180 #1678 call dir
	addi %sp %sp 184 #1678	
	jal %ra vecaccum.2273 #1678
	addi %sp %sp -184 #1678
	lw %ra %sp 180 #1678
	lw %a0 %sp 144 #1680
	sw %ra %sp 180 #1680 call dir
	addi %sp %sp 184 #1680	
	jal %ra o_hilight.2316 #1680
	addi %sp %sp -184 #1680
	lw %ra %sp 180 #1680
	lw %f1 %sp 96 #1680
	fmul %f0 %f1 %f0 #1680
	lw %a0 %sp 20 #32
	lw %a1 %a0 0 #32
	lw %a0 %sp 136 #1683
	lw %a11 %sp 12 #1683
	sw %f0 %sp 176 #1683
	sw %ra %sp 188 #1683 call cls
	lw %a10 %a11 0 #1683
	addi %sp %sp 192 #1683	
	jalr %ra %a10 0 #1683
	addi %sp %sp -192 #1683
	lw %ra %sp 188 #1683
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8746 # nontail if
	lw %a0 %sp 24 #1684
	lw %a1 %sp 104 #1684
	sw %ra %sp 188 #1684 call dir
	addi %sp %sp 192 #1684	
	jal %ra veciprod.2265 #1684
	addi %sp %sp -192 #1684
	lw %ra %sp 188 #1684
	sw %ra %sp 188 #1684 call dir
	addi %sp %sp 192 #1684	
	jal %ra min_caml_fneg #1684
	addi %sp %sp -192 #1684
	lw %ra %sp 188 #1684
	lw %f1 %sp 152 #1684
	fmul %f0 %f0 %f1 #1684
	lw %a0 %sp 112 #1685
	lw %a1 %sp 104 #1685
	sw %f0 %sp 184 #1685
	sw %ra %sp 196 #1685 call dir
	addi %sp %sp 200 #1685	
	jal %ra veciprod.2265 #1685
	addi %sp %sp -200 #1685
	lw %ra %sp 196 #1685
	sw %ra %sp 196 #1685 call dir
	addi %sp %sp 200 #1685	
	jal %ra min_caml_fneg #1685
	addi %sp %sp -200 #1685
	lw %ra %sp 196 #1685
	fadd %f1 %f0 %fzero #1685
	lw %f0 %sp 184 #1686
	lw %f2 %sp 176 #1686
	lw %a11 %sp 48 #1686
	sw %ra %sp 196 #1686 call cls
	lw %a10 %a11 0 #1686
	addi %sp %sp 200 #1686	
	jalr %ra %a10 0 #1686
	addi %sp %sp -200 #1686
	lw %ra %sp 196 #1686
	jal %zero beq_cont.8747 # then sentence ends
beq_else.8746:
beq_cont.8747:
	lw %a0 %sp 40 #1690
	lw %a11 %sp 8 #1690
	sw %ra %sp 196 #1690 call cls
	lw %a10 %a11 0 #1690
	addi %sp %sp 200 #1690	
	jalr %ra %a10 0 #1690
	addi %sp %sp -200 #1690
	lw %ra %sp 196 #1690
	lw %a0 %sp 16 #98
	lw %a0 %a0 0 #98
	addi %a0 %a0 -1 #1691
	lw %f0 %sp 152 #1691
	lw %f1 %sp 176 #1691
	lw %a1 %sp 112 #1691
	lw %a11 %sp 4 #1691
	sw %ra %sp 196 #1691 call cls
	lw %a10 %a11 0 #1691
	addi %sp %sp 200 #1691	
	jalr %ra %a10 0 #1691
	addi %sp %sp -200 #1691
	lw %ra %sp 196 #1691
	li %f0 l.6112 #1694
	lw %f1 %sp 96 #1694
	sw %ra %sp 196 #1694 call dir
	addi %sp %sp 200 #1694	
	jal %ra min_caml_fless #1694
	addi %sp %sp -200 #1694
	lw %ra %sp 196 #1694
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8748
	jalr %zero %ra 0 #1705
beq_else.8748:
	lw %a0 %sp 108 #1644
	addi %a12 %zero 4
	blt %a0 %a12 bge_else.8750 # nontail if
	jal %zero bge_cont.8751 # then sentence ends
bge_else.8750:
	addi %a1 %a0 1 #1697
	addi %a2 %zero 1 #1697
	sub %a2 %zero %a2 #1697
	slli %a1 %a1 2 #1697
	lw %a3 %sp 120 #1697
	add %a12 %a3 %a1 #1697
	sw %a2 %a12 0 #1697
bge_cont.8751:
	lw %a1 %sp 148 #19
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8752
	li %f0 l.5555 #1701
	lw %a1 %sp 144 #1701
	sw %f0 %sp 192 #1701
	add %a0 %a1 %zero
	sw %ra %sp 204 #1701 call dir
	addi %sp %sp 208 #1701	
	jal %ra o_diffuse.2314 #1701
	addi %sp %sp -208 #1701
	lw %ra %sp 204 #1701
	lw %f1 %sp 192 #1701
	fsub %f0 %f1 %f0 #1701
	lw %f1 %sp 96 #1701
	fmul %f0 %f1 %f0 #1701
	lw %a0 %sp 108 #1702
	addi %a0 %a0 1 #1702
	lw %a1 %sp 0 #40
	lw %f1 %a1 0 #40
	lw %f2 %sp 56 #1702
	fadd %f1 %f2 %f1 #1702
	lw %a1 %sp 112 #1702
	lw %a2 %sp 64 #1702
	lw %a11 %sp 44 #1702
	lw %a10 %a11 0 #1702
	jalr %zero %a10 0 #1702
beq_else.8752:
	jalr %zero %ra 0 #1703
bge_else.8735:
	jalr %zero %ra 0 #1726
trace_diffuse_ray.2577:
	lw %a1 %a11 48 #1734
	lw %a2 %a11 44 #1734
	lw %a3 %a11 40 #1734
	lw %a4 %a11 36 #1734
	lw %a5 %a11 32 #1734
	lw %a6 %a11 28 #1734
	lw %a7 %a11 24 #1734
	lw %a8 %a11 20 #1734
	lw %a9 %a11 16 #1734
	lw %a10 %a11 12 #1734
	sw %a2 %sp 0 #1734
	lw %a2 %a11 8 #1734
	lw %a11 %a11 4 #1734
	sw %a11 %sp 4 #1737
	sw %f0 %sp 8 #1737
	sw %a7 %sp 16 #1737
	sw %a6 %sp 20 #1737
	sw %a3 %sp 24 #1737
	sw %a4 %sp 28 #1737
	sw %a9 %sp 32 #1737
	sw %a1 %sp 36 #1737
	sw %a2 %sp 40 #1737
	sw %a0 %sp 44 #1737
	sw %a5 %sp 48 #1737
	sw %a10 %sp 52 #1737
	add %a11 %a8 %zero
	sw %ra %sp 60 #1737 call cls
	lw %a10 %a11 0 #1737
	addi %sp %sp 64 #1737	
	jalr %ra %a10 0 #1737
	addi %sp %sp -64 #1737
	lw %ra %sp 60 #1737
	addi %a1 %zero 0 #1737
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8755
	jalr %zero %ra 0 #1748
beq_else.8755:
	lw %a0 %sp 52 #44
	lw %a0 %a0 0 #44
	slli %a0 %a0 2 #19
	lw %a2 %sp 48 #19
	add %a12 %a2 %a0 #19
	lw %a0 %a12 0 #19
	lw %a2 %sp 44 #1739
	sw %a1 %sp 56 #1739
	sw %a0 %sp 60 #1739
	add %a0 %a2 %zero
	sw %ra %sp 68 #1739 call dir
	addi %sp %sp 72 #1739	
	jal %ra d_vec.2351 #1739
	addi %sp %sp -72 #1739
	lw %ra %sp 68 #1739
	add %a1 %a0 %zero #1739
	lw %a0 %sp 60 #1739
	lw %a11 %sp 40 #1739
	sw %ra %sp 68 #1739 call cls
	lw %a10 %a11 0 #1739
	addi %sp %sp 72 #1739	
	jalr %ra %a10 0 #1739
	addi %sp %sp -72 #1739
	lw %ra %sp 68 #1739
	lw %a0 %sp 60 #1740
	lw %a1 %sp 32 #1740
	lw %a11 %sp 36 #1740
	sw %ra %sp 68 #1740 call cls
	lw %a10 %a11 0 #1740
	addi %sp %sp 72 #1740	
	jalr %ra %a10 0 #1740
	addi %sp %sp -72 #1740
	lw %ra %sp 68 #1740
	lw %a0 %sp 28 #32
	lw %a1 %a0 0 #32
	lw %a0 %sp 56 #1743
	lw %a11 %sp 24 #1743
	sw %ra %sp 68 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 72 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -72 #1743
	lw %ra %sp 68 #1743
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8757
	lw %a0 %sp 20 #1744
	lw %a1 %sp 16 #1744
	sw %ra %sp 68 #1744 call dir
	addi %sp %sp 72 #1744	
	jal %ra veciprod.2265 #1744
	addi %sp %sp -72 #1744
	lw %ra %sp 68 #1744
	sw %ra %sp 68 #1744 call dir
	addi %sp %sp 72 #1744	
	jal %ra min_caml_fneg #1744
	addi %sp %sp -72 #1744
	lw %ra %sp 68 #1744
	sw %f0 %sp 64 #1745
	sw %ra %sp 76 #1745 call dir
	addi %sp %sp 80 #1745	
	jal %ra min_caml_fispos #1745
	addi %sp %sp -80 #1745
	lw %ra %sp 76 #1745
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8758 # nontail if
	li %f0 l.5553 #1745
	jal %zero beq_cont.8759 # then sentence ends
beq_else.8758:
	lw %f0 %sp 64 #555
beq_cont.8759:
	lw %f1 %sp 8 #1746
	fmul %f0 %f1 %f0 #1746
	lw %a0 %sp 60 #1746
	sw %f0 %sp 72 #1746
	sw %ra %sp 84 #1746 call dir
	addi %sp %sp 88 #1746	
	jal %ra o_diffuse.2314 #1746
	addi %sp %sp -88 #1746
	lw %ra %sp 84 #1746
	lw %f1 %sp 72 #1746
	fmul %f0 %f1 %f0 #1746
	lw %a0 %sp 4 #1746
	lw %a1 %sp 0 #1746
	jal	%zero vecaccum.2273
beq_else.8757:
	jalr %zero %ra 0 #1747
iter_trace_diffuse_rays.2580:
	lw %a4 %a11 4 #1752
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.8761
	slli %a5 %a3 2 #1754
	add %a12 %a0 %a5 #1754
	lw %a5 %a12 0 #1754
	sw %a2 %sp 0 #1754
	sw %a11 %sp 4 #1754
	sw %a4 %sp 8 #1754
	sw %a0 %sp 12 #1754
	sw %a3 %sp 16 #1754
	sw %a1 %sp 20 #1754
	add %a0 %a5 %zero
	sw %ra %sp 28 #1754 call dir
	addi %sp %sp 32 #1754	
	jal %ra d_vec.2351 #1754
	addi %sp %sp -32 #1754
	lw %ra %sp 28 #1754
	lw %a1 %sp 20 #1754
	sw %ra %sp 28 #1754 call dir
	addi %sp %sp 32 #1754	
	jal %ra veciprod.2265 #1754
	addi %sp %sp -32 #1754
	lw %ra %sp 28 #1754
	sw %f0 %sp 24 #1757
	sw %ra %sp 36 #1757 call dir
	addi %sp %sp 40 #1757	
	jal %ra min_caml_fisneg #1757
	addi %sp %sp -40 #1757
	lw %ra %sp 36 #1757
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8762 # nontail if
	lw %a0 %sp 16 #1754
	slli %a1 %a0 2 #1754
	lw %a2 %sp 12 #1754
	add %a12 %a2 %a1 #1754
	lw %a1 %a12 0 #1754
	li %f0 l.6134 #1760
	lw %f1 %sp 24 #1760
	fdiv %f0 %f1 %f0 #1760
	lw %a11 %sp 8 #1760
	add %a0 %a1 %zero
	sw %ra %sp 36 #1760 call cls
	lw %a10 %a11 0 #1760
	addi %sp %sp 40 #1760	
	jalr %ra %a10 0 #1760
	addi %sp %sp -40 #1760
	lw %ra %sp 36 #1760
	jal %zero beq_cont.8763 # then sentence ends
beq_else.8762:
	lw %a0 %sp 16 #1758
	addi %a1 %a0 1 #1758
	slli %a1 %a1 2 #1754
	lw %a2 %sp 12 #1754
	add %a12 %a2 %a1 #1754
	lw %a1 %a12 0 #1754
	li %f0 l.6131 #1758
	lw %f1 %sp 24 #1758
	fdiv %f0 %f1 %f0 #1758
	lw %a11 %sp 8 #1758
	add %a0 %a1 %zero
	sw %ra %sp 36 #1758 call cls
	lw %a10 %a11 0 #1758
	addi %sp %sp 40 #1758	
	jalr %ra %a10 0 #1758
	addi %sp %sp -40 #1758
	lw %ra %sp 36 #1758
beq_cont.8763:
	lw %a0 %sp 16 #1762
	addi %a3 %a0 -2 #1762
	lw %a0 %sp 12 #1762
	lw %a1 %sp 20 #1762
	lw %a2 %sp 0 #1762
	lw %a11 %sp 4 #1762
	lw %a10 %a11 0 #1762
	jalr %zero %a10 0 #1762
bge_else.8761:
	jalr %zero %ra 0 #1763
trace_diffuse_rays.2585:
	lw %a3 %a11 8 #1767
	lw %a4 %a11 4 #1767
	sw %a2 %sp 0 #1768
	sw %a1 %sp 4 #1768
	sw %a0 %sp 8 #1768
	sw %a4 %sp 12 #1768
	add %a0 %a2 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1768 call cls
	lw %a10 %a11 0 #1768
	addi %sp %sp 24 #1768	
	jalr %ra %a10 0 #1768
	addi %sp %sp -24 #1768
	lw %ra %sp 20 #1768
	addi %a3 %zero 118 #1771
	lw %a0 %sp 8 #1771
	lw %a1 %sp 4 #1771
	lw %a2 %sp 0 #1771
	lw %a11 %sp 12 #1771
	lw %a10 %a11 0 #1771
	jalr %zero %a10 0 #1771
trace_diffuse_ray_80percent.2589:
	lw %a3 %a11 8 #1775
	lw %a4 %a11 4 #1775
	sw %a2 %sp 0 #1777
	sw %a1 %sp 4 #1777
	sw %a3 %sp 8 #1777
	sw %a4 %sp 12 #1777
	sw %a0 %sp 16 #1777
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8765 # nontail if
	jal %zero beq_cont.8766 # then sentence ends
beq_else.8765:
	lw %a5 %a4 0 #80
	add %a0 %a5 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1778 call cls
	lw %a10 %a11 0 #1778
	addi %sp %sp 24 #1778	
	jalr %ra %a10 0 #1778
	addi %sp %sp -24 #1778
	lw %ra %sp 20 #1778
beq_cont.8766:
	lw %a0 %sp 16 #1777
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8767 # nontail if
	jal %zero beq_cont.8768 # then sentence ends
beq_else.8767:
	lw %a1 %sp 12 #80
	lw %a2 %a1 4 #80
	lw %a3 %sp 4 #1782
	lw %a4 %sp 0 #1782
	lw %a11 %sp 8 #1782
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 20 #1782 call cls
	lw %a10 %a11 0 #1782
	addi %sp %sp 24 #1782	
	jalr %ra %a10 0 #1782
	addi %sp %sp -24 #1782
	lw %ra %sp 20 #1782
beq_cont.8768:
	lw %a0 %sp 16 #1777
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8769 # nontail if
	jal %zero beq_cont.8770 # then sentence ends
beq_else.8769:
	lw %a1 %sp 12 #80
	lw %a2 %a1 8 #80
	lw %a3 %sp 4 #1786
	lw %a4 %sp 0 #1786
	lw %a11 %sp 8 #1786
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 20 #1786 call cls
	lw %a10 %a11 0 #1786
	addi %sp %sp 24 #1786	
	jalr %ra %a10 0 #1786
	addi %sp %sp -24 #1786
	lw %ra %sp 20 #1786
beq_cont.8770:
	lw %a0 %sp 16 #1777
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8771 # nontail if
	jal %zero beq_cont.8772 # then sentence ends
beq_else.8771:
	lw %a1 %sp 12 #80
	lw %a2 %a1 12 #80
	lw %a3 %sp 4 #1790
	lw %a4 %sp 0 #1790
	lw %a11 %sp 8 #1790
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 20 #1790 call cls
	lw %a10 %a11 0 #1790
	addi %sp %sp 24 #1790	
	jalr %ra %a10 0 #1790
	addi %sp %sp -24 #1790
	lw %ra %sp 20 #1790
beq_cont.8772:
	lw %a0 %sp 16 #1777
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.8773
	jalr %zero %ra 0 #1795
beq_else.8773:
	lw %a0 %sp 12 #80
	lw %a0 %a0 16 #80
	lw %a1 %sp 4 #1794
	lw %a2 %sp 0 #1794
	lw %a11 %sp 8 #1794
	lw %a10 %a11 0 #1794
	jalr %zero %a10 0 #1794
calc_diffuse_using_1point.2593:
	lw %a2 %a11 12 #1800
	lw %a3 %a11 8 #1800
	lw %a4 %a11 4 #1800
	sw %a3 %sp 0 #1802
	sw %a2 %sp 4 #1802
	sw %a4 %sp 8 #1802
	sw %a1 %sp 12 #1802
	sw %a0 %sp 16 #1802
	sw %ra %sp 20 #1802 call dir
	addi %sp %sp 24 #1802	
	jal %ra p_received_ray_20percent.2342 #1802
	addi %sp %sp -24 #1802
	lw %ra %sp 20 #1802
	lw %a1 %sp 16 #1803
	sw %a0 %sp 20 #1803
	add %a0 %a1 %zero
	sw %ra %sp 28 #1803 call dir
	addi %sp %sp 32 #1803	
	jal %ra p_nvectors.2349 #1803
	addi %sp %sp -32 #1803
	lw %ra %sp 28 #1803
	lw %a1 %sp 16 #1804
	sw %a0 %sp 24 #1804
	add %a0 %a1 %zero
	sw %ra %sp 28 #1804 call dir
	addi %sp %sp 32 #1804	
	jal %ra p_intersection_points.2334 #1804
	addi %sp %sp -32 #1804
	lw %ra %sp 28 #1804
	lw %a1 %sp 16 #1805
	sw %a0 %sp 28 #1805
	add %a0 %a1 %zero
	sw %ra %sp 36 #1805 call dir
	addi %sp %sp 40 #1805	
	jal %ra p_energy.2340 #1805
	addi %sp %sp -40 #1805
	lw %ra %sp 36 #1805
	lw %a1 %sp 12 #1807
	slli %a2 %a1 2 #1807
	lw %a3 %sp 20 #1807
	add %a12 %a3 %a2 #1807
	lw %a2 %a12 0 #1807
	lw %a3 %sp 8 #1807
	sw %a0 %sp 32 #1807
	add %a1 %a2 %zero
	add %a0 %a3 %zero
	sw %ra %sp 36 #1807 call dir
	addi %sp %sp 40 #1807	
	jal %ra veccpy.2254 #1807
	addi %sp %sp -40 #1807
	lw %ra %sp 36 #1807
	lw %a0 %sp 16 #1809
	sw %ra %sp 36 #1809 call dir
	addi %sp %sp 40 #1809	
	jal %ra p_group_id.2344 #1809
	addi %sp %sp -40 #1809
	lw %ra %sp 36 #1809
	lw %a1 %sp 12 #1673
	slli %a2 %a1 2 #1673
	lw %a3 %sp 24 #1673
	add %a12 %a3 %a2 #1673
	lw %a2 %a12 0 #1673
	slli %a3 %a1 2 #1661
	lw %a4 %sp 28 #1661
	add %a12 %a4 %a3 #1661
	lw %a3 %a12 0 #1661
	lw %a11 %sp 4 #1808
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 36 #1808 call cls
	lw %a10 %a11 0 #1808
	addi %sp %sp 40 #1808	
	jalr %ra %a10 0 #1808
	addi %sp %sp -40 #1808
	lw %ra %sp 36 #1808
	lw %a0 %sp 12 #1670
	slli %a0 %a0 2 #1670
	lw %a1 %sp 32 #1670
	add %a12 %a1 %a0 #1670
	lw %a1 %a12 0 #1670
	lw %a0 %sp 0 #1812
	lw %a2 %sp 8 #1812
	jal	%zero vecaccumv.2286
calc_diffuse_using_5points.2596:
	lw %a5 %a11 8 #1818
	lw %a6 %a11 4 #1818
	slli %a7 %a0 2 #1820
	add %a12 %a1 %a7 #1820
	lw %a1 %a12 0 #1820
	sw %a5 %sp 0 #1820
	sw %a6 %sp 4 #1820
	sw %a4 %sp 8 #1820
	sw %a3 %sp 12 #1820
	sw %a2 %sp 16 #1820
	sw %a0 %sp 20 #1820
	add %a0 %a1 %zero
	sw %ra %sp 28 #1820 call dir
	addi %sp %sp 32 #1820	
	jal %ra p_received_ray_20percent.2342 #1820
	addi %sp %sp -32 #1820
	lw %ra %sp 28 #1820
	lw %a1 %sp 20 #1821
	addi %a2 %a1 -1 #1821
	slli %a2 %a2 2 #1821
	lw %a3 %sp 16 #1821
	add %a12 %a3 %a2 #1821
	lw %a2 %a12 0 #1821
	sw %a0 %sp 24 #1821
	add %a0 %a2 %zero
	sw %ra %sp 28 #1821 call dir
	addi %sp %sp 32 #1821	
	jal %ra p_received_ray_20percent.2342 #1821
	addi %sp %sp -32 #1821
	lw %ra %sp 28 #1821
	lw %a1 %sp 20 #1821
	slli %a2 %a1 2 #1821
	lw %a3 %sp 16 #1821
	add %a12 %a3 %a2 #1821
	lw %a2 %a12 0 #1821
	sw %a0 %sp 28 #1822
	add %a0 %a2 %zero
	sw %ra %sp 36 #1822 call dir
	addi %sp %sp 40 #1822	
	jal %ra p_received_ray_20percent.2342 #1822
	addi %sp %sp -40 #1822
	lw %ra %sp 36 #1822
	lw %a1 %sp 20 #1823
	addi %a2 %a1 1 #1823
	slli %a2 %a2 2 #1821
	lw %a3 %sp 16 #1821
	add %a12 %a3 %a2 #1821
	lw %a2 %a12 0 #1821
	sw %a0 %sp 32 #1823
	add %a0 %a2 %zero
	sw %ra %sp 36 #1823 call dir
	addi %sp %sp 40 #1823	
	jal %ra p_received_ray_20percent.2342 #1823
	addi %sp %sp -40 #1823
	lw %ra %sp 36 #1823
	lw %a1 %sp 20 #1824
	slli %a2 %a1 2 #1824
	lw %a3 %sp 12 #1824
	add %a12 %a3 %a2 #1824
	lw %a2 %a12 0 #1824
	sw %a0 %sp 36 #1824
	add %a0 %a2 %zero
	sw %ra %sp 44 #1824 call dir
	addi %sp %sp 48 #1824	
	jal %ra p_received_ray_20percent.2342 #1824
	addi %sp %sp -48 #1824
	lw %ra %sp 44 #1824
	lw %a1 %sp 8 #1807
	slli %a2 %a1 2 #1807
	lw %a3 %sp 24 #1807
	add %a12 %a3 %a2 #1807
	lw %a2 %a12 0 #1807
	lw %a3 %sp 4 #1826
	sw %a0 %sp 40 #1826
	add %a1 %a2 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1826 call dir
	addi %sp %sp 48 #1826	
	jal %ra veccpy.2254 #1826
	addi %sp %sp -48 #1826
	lw %ra %sp 44 #1826
	lw %a0 %sp 8 #1807
	slli %a1 %a0 2 #1807
	lw %a2 %sp 28 #1807
	add %a12 %a2 %a1 #1807
	lw %a1 %a12 0 #1807
	lw %a2 %sp 4 #1827
	add %a0 %a2 %zero
	sw %ra %sp 44 #1827 call dir
	addi %sp %sp 48 #1827	
	jal %ra vecadd.2277 #1827
	addi %sp %sp -48 #1827
	lw %ra %sp 44 #1827
	lw %a0 %sp 8 #1807
	slli %a1 %a0 2 #1807
	lw %a2 %sp 32 #1807
	add %a12 %a2 %a1 #1807
	lw %a1 %a12 0 #1807
	lw %a2 %sp 4 #1828
	add %a0 %a2 %zero
	sw %ra %sp 44 #1828 call dir
	addi %sp %sp 48 #1828	
	jal %ra vecadd.2277 #1828
	addi %sp %sp -48 #1828
	lw %ra %sp 44 #1828
	lw %a0 %sp 8 #1807
	slli %a1 %a0 2 #1807
	lw %a2 %sp 36 #1807
	add %a12 %a2 %a1 #1807
	lw %a1 %a12 0 #1807
	lw %a2 %sp 4 #1829
	add %a0 %a2 %zero
	sw %ra %sp 44 #1829 call dir
	addi %sp %sp 48 #1829	
	jal %ra vecadd.2277 #1829
	addi %sp %sp -48 #1829
	lw %ra %sp 44 #1829
	lw %a0 %sp 8 #1807
	slli %a1 %a0 2 #1807
	lw %a2 %sp 40 #1807
	add %a12 %a2 %a1 #1807
	lw %a1 %a12 0 #1807
	lw %a2 %sp 4 #1830
	add %a0 %a2 %zero
	sw %ra %sp 44 #1830 call dir
	addi %sp %sp 48 #1830	
	jal %ra vecadd.2277 #1830
	addi %sp %sp -48 #1830
	lw %ra %sp 44 #1830
	lw %a0 %sp 20 #1821
	slli %a0 %a0 2 #1821
	lw %a1 %sp 16 #1821
	add %a12 %a1 %a0 #1821
	lw %a0 %a12 0 #1821
	sw %ra %sp 44 #1832 call dir
	addi %sp %sp 48 #1832	
	jal %ra p_energy.2340 #1832
	addi %sp %sp -48 #1832
	lw %ra %sp 44 #1832
	lw %a1 %sp 8 #1670
	slli %a1 %a1 2 #1670
	add %a12 %a0 %a1 #1670
	lw %a1 %a12 0 #1670
	lw %a0 %sp 0 #1833
	lw %a2 %sp 4 #1833
	jal	%zero vecaccumv.2286
do_without_neighbors.2602:
	lw %a2 %a11 4 #1838
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.8775
	sw %a11 %sp 0 #1841
	sw %a2 %sp 4 #1841
	sw %a0 %sp 8 #1841
	sw %a1 %sp 12 #1841
	sw %ra %sp 20 #1841 call dir
	addi %sp %sp 24 #1841	
	jal %ra p_surface_ids.2336 #1841
	addi %sp %sp -24 #1841
	lw %ra %sp 20 #1841
	lw %a1 %sp 12 #1658
	slli %a2 %a1 2 #1658
	add %a12 %a0 %a2 #1658
	lw %a0 %a12 0 #1658
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8776
	lw %a0 %sp 8 #1843
	sw %ra %sp 20 #1843 call dir
	addi %sp %sp 24 #1843	
	jal %ra p_calc_diffuse.2338 #1843
	addi %sp %sp -24 #1843
	lw %ra %sp 20 #1843
	lw %a1 %sp 12 #1666
	slli %a2 %a1 2 #1666
	add %a12 %a0 %a2 #1666
	lw %a0 %a12 0 #1666
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8777 # nontail if
	jal %zero beq_cont.8778 # then sentence ends
beq_else.8777:
	lw %a0 %sp 8 #1845
	lw %a11 %sp 4 #1845
	sw %ra %sp 20 #1845 call cls
	lw %a10 %a11 0 #1845
	addi %sp %sp 24 #1845	
	jalr %ra %a10 0 #1845
	addi %sp %sp -24 #1845
	lw %ra %sp 20 #1845
beq_cont.8778:
	lw %a0 %sp 12 #1847
	addi %a1 %a0 1 #1847
	lw %a0 %sp 8 #1847
	lw %a11 %sp 0 #1847
	lw %a10 %a11 0 #1847
	jalr %zero %a10 0 #1847
bge_else.8776:
	jalr %zero %ra 0 #1848
bge_else.8775:
	jalr %zero %ra 0 #1849
neighbors_exist.2605:
	lw %a2 %a11 4 #1853
	lw %a3 %a2 4 #56
	addi %a4 %a1 1 #1854
	blt %a4 %a3 bge_else.8781
	addi %a0 %zero 0 #1862
	jalr %zero %ra 0 #1862
bge_else.8781:
	addi %a3 %zero 0 #1855
	addi %a12 %zero 0
	blt %a12 %a1 bge_else.8782
	addi %a0 %a3 0 #1855
	jalr %zero %ra 0 #1855
bge_else.8782:
	lw %a1 %a2 0 #56
	addi %a2 %a0 1 #1856
	blt %a2 %a1 bge_else.8783
	addi %a0 %a3 0 #1855
	jalr %zero %ra 0 #1855
bge_else.8783:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.8784
	addi %a0 %a3 0 #1855
	jalr %zero %ra 0 #1855
bge_else.8784:
	addi %a0 %zero 1 #1858
	jalr %zero %ra 0 #1858
get_surface_id.2609:
	sw %a1 %sp 0 #1866
	sw %ra %sp 4 #1866 call dir
	addi %sp %sp 8 #1866	
	jal %ra p_surface_ids.2336 #1866
	addi %sp %sp -8 #1866
	lw %ra %sp 4 #1866
	lw %a1 %sp 0 #1658
	slli %a1 %a1 2 #1658
	add %a12 %a0 %a1 #1658
	lw %a0 %a12 0 #1658
	jalr %zero %ra 0 #1658
neighbors_are_available.2612:
	slli %a5 %a0 2 #1872
	add %a12 %a2 %a5 #1872
	lw %a5 %a12 0 #1872
	sw %a2 %sp 0 #1872
	sw %a3 %sp 4 #1872
	sw %a4 %sp 8 #1872
	sw %a1 %sp 12 #1872
	sw %a0 %sp 16 #1872
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	sw %ra %sp 20 #1872 call dir
	addi %sp %sp 24 #1872	
	jal %ra get_surface_id.2609 #1872
	addi %sp %sp -24 #1872
	lw %ra %sp 20 #1872
	lw %a1 %sp 16 #1874
	slli %a2 %a1 2 #1874
	lw %a3 %sp 12 #1874
	add %a12 %a3 %a2 #1874
	lw %a2 %a12 0 #1874
	lw %a3 %sp 8 #1874
	sw %a0 %sp 20 #1874
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #1874 call dir
	addi %sp %sp 32 #1874	
	jal %ra get_surface_id.2609 #1874
	addi %sp %sp -32 #1874
	lw %ra %sp 28 #1874
	lw %a1 %sp 20 #1658
	bne %a0 %a1 beq_else.8785
	lw %a0 %sp 16 #1875
	slli %a2 %a0 2 #1875
	lw %a3 %sp 4 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a3 %sp 8 #1875
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #1875 call dir
	addi %sp %sp 32 #1875	
	jal %ra get_surface_id.2609 #1875
	addi %sp %sp -32 #1875
	lw %ra %sp 28 #1875
	lw %a1 %sp 20 #1658
	bne %a0 %a1 beq_else.8786
	lw %a0 %sp 16 #1876
	addi %a2 %a0 -1 #1876
	slli %a2 %a2 2 #1872
	lw %a3 %sp 0 #1872
	add %a12 %a3 %a2 #1872
	lw %a2 %a12 0 #1872
	lw %a4 %sp 8 #1876
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #1876 call dir
	addi %sp %sp 32 #1876	
	jal %ra get_surface_id.2609 #1876
	addi %sp %sp -32 #1876
	lw %ra %sp 28 #1876
	lw %a1 %sp 20 #1658
	bne %a0 %a1 beq_else.8787
	lw %a0 %sp 16 #1877
	addi %a0 %a0 1 #1877
	slli %a0 %a0 2 #1872
	lw %a2 %sp 0 #1872
	add %a12 %a2 %a0 #1872
	lw %a0 %a12 0 #1872
	lw %a2 %sp 8 #1877
	add %a1 %a2 %zero
	sw %ra %sp 28 #1877 call dir
	addi %sp %sp 32 #1877	
	jal %ra get_surface_id.2609 #1877
	addi %sp %sp -32 #1877
	lw %ra %sp 28 #1877
	lw %a1 %sp 20 #1658
	bne %a0 %a1 beq_else.8788
	addi %a0 %zero 1 #1878
	jalr %zero %ra 0 #1878
beq_else.8788:
	addi %a0 %zero 0 #1879
	jalr %zero %ra 0 #1879
beq_else.8787:
	addi %a0 %zero 0 #1880
	jalr %zero %ra 0 #1880
beq_else.8786:
	addi %a0 %zero 0 #1881
	jalr %zero %ra 0 #1881
beq_else.8785:
	addi %a0 %zero 0 #1882
	jalr %zero %ra 0 #1882
try_exploit_neighbors.2618:
	lw %a6 %a11 8 #1887
	lw %a7 %a11 4 #1887
	slli %a8 %a0 2 #1888
	add %a12 %a3 %a8 #1888
	lw %a8 %a12 0 #1888
	addi %a12 %zero 4
	blt %a12 %a5 bge_else.8789
	sw %a1 %sp 0 #1892
	sw %a11 %sp 4 #1892
	sw %a7 %sp 8 #1892
	sw %a8 %sp 12 #1892
	sw %a6 %sp 16 #1892
	sw %a5 %sp 20 #1892
	sw %a4 %sp 24 #1892
	sw %a3 %sp 28 #1892
	sw %a2 %sp 32 #1892
	sw %a0 %sp 36 #1892
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	sw %ra %sp 44 #1892 call dir
	addi %sp %sp 48 #1892	
	jal %ra get_surface_id.2609 #1892
	addi %sp %sp -48 #1892
	lw %ra %sp 44 #1892
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8790
	lw %a0 %sp 36 #1894
	lw %a1 %sp 32 #1894
	lw %a2 %sp 28 #1894
	lw %a3 %sp 24 #1894
	lw %a4 %sp 20 #1894
	sw %ra %sp 44 #1894 call dir
	addi %sp %sp 48 #1894	
	jal %ra neighbors_are_available.2612 #1894
	addi %sp %sp -48 #1894
	lw %ra %sp 44 #1894
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8791
	lw %a0 %sp 12 #1906
	lw %a1 %sp 20 #1906
	lw %a11 %sp 16 #1906
	lw %a10 %a11 0 #1906
	jalr %zero %a10 0 #1906
beq_else.8791:
	lw %a0 %sp 12 #1897
	sw %ra %sp 44 #1897 call dir
	addi %sp %sp 48 #1897	
	jal %ra p_calc_diffuse.2338 #1897
	addi %sp %sp -48 #1897
	lw %ra %sp 44 #1897
	lw %a4 %sp 20 #1666
	slli %a1 %a4 2 #1666
	add %a12 %a0 %a1 #1666
	lw %a0 %a12 0 #1666
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8792 # nontail if
	jal %zero beq_cont.8793 # then sentence ends
beq_else.8792:
	lw %a0 %sp 36 #1899
	lw %a1 %sp 32 #1899
	lw %a2 %sp 28 #1899
	lw %a3 %sp 24 #1899
	lw %a11 %sp 8 #1899
	sw %ra %sp 44 #1899 call cls
	lw %a10 %a11 0 #1899
	addi %sp %sp 48 #1899	
	jalr %ra %a10 0 #1899
	addi %sp %sp -48 #1899
	lw %ra %sp 44 #1899
beq_cont.8793:
	lw %a0 %sp 20 #1903
	addi %a5 %a0 1 #1903
	lw %a0 %sp 36 #1903
	lw %a1 %sp 0 #1903
	lw %a2 %sp 32 #1903
	lw %a3 %sp 28 #1903
	lw %a4 %sp 24 #1903
	lw %a11 %sp 4 #1903
	lw %a10 %a11 0 #1903
	jalr %zero %a10 0 #1903
bge_else.8790:
	jalr %zero %ra 0 #1907
bge_else.8789:
	jalr %zero %ra 0 #1908
write_ppm_header.2625:
	lw %a0 %a11 4 #1912
	addi %a1 %zero 80 #1914
	sw %a0 %sp 0 #1914
	add %a0 %a1 %zero
	sw %ra %sp 4 #1914 call dir
	addi %sp %sp 8 #1914	
	jal %ra min_caml_print_char #1914
	addi %sp %sp -8 #1914
	lw %ra %sp 4 #1914
	addi %a0 %zero 48 #1915
	addi %a0 %a0 3 #1915
	sw %ra %sp 4 #1915 call dir
	addi %sp %sp 8 #1915	
	jal %ra min_caml_print_char #1915
	addi %sp %sp -8 #1915
	lw %ra %sp 4 #1915
	addi %a0 %zero 10 #1916
	sw %ra %sp 4 #1916 call dir
	addi %sp %sp 8 #1916	
	jal %ra min_caml_print_char #1916
	addi %sp %sp -8 #1916
	lw %ra %sp 4 #1916
	lw %a0 %sp 0 #56
	lw %a1 %a0 0 #56
	add %a0 %a1 %zero
	sw %ra %sp 4 #1917 call dir
	addi %sp %sp 8 #1917	
	jal %ra min_caml_print_int #1917
	addi %sp %sp -8 #1917
	lw %ra %sp 4 #1917
	addi %a0 %zero 32 #1918
	sw %ra %sp 4 #1918 call dir
	addi %sp %sp 8 #1918	
	jal %ra min_caml_print_char #1918
	addi %sp %sp -8 #1918
	lw %ra %sp 4 #1918
	lw %a0 %sp 0 #56
	lw %a0 %a0 4 #56
	sw %ra %sp 4 #1919 call dir
	addi %sp %sp 8 #1919	
	jal %ra min_caml_print_int #1919
	addi %sp %sp -8 #1919
	lw %ra %sp 4 #1919
	addi %a0 %zero 32 #1920
	sw %ra %sp 4 #1920 call dir
	addi %sp %sp 8 #1920	
	jal %ra min_caml_print_char #1920
	addi %sp %sp -8 #1920
	lw %ra %sp 4 #1920
	addi %a0 %zero 255 #1921
	sw %ra %sp 4 #1921 call dir
	addi %sp %sp 8 #1921	
	jal %ra min_caml_print_int #1921
	addi %sp %sp -8 #1921
	lw %ra %sp 4 #1921
	addi %a0 %zero 10 #1922
	jal	%zero min_caml_print_char
write_rgb_element.2627:
	sw %ra %sp 4 #1927 call dir
	addi %sp %sp 8 #1927	
	jal %ra min_caml_int_of_float #1927
	addi %sp %sp -8 #1927
	lw %ra %sp 4 #1927
	addi %a1 %zero 255 #1928
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.8796 # nontail if
	addi %a1 %zero 0 #1928
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8798 # nontail if
	jal %zero bge_cont.8799 # then sentence ends
bge_else.8798:
	addi %a0 %a1 0 #1928
bge_cont.8799:
	jal %zero bge_cont.8797 # then sentence ends
bge_else.8796:
	addi %a0 %a1 0 #1928
bge_cont.8797:
	jal	%zero min_caml_print_int
write_rgb.2629:
	lw %a0 %a11 4 #1932
	lw %f0 %a0 0 #53
	sw %a0 %sp 0 #1933
	sw %ra %sp 4 #1933 call dir
	addi %sp %sp 8 #1933	
	jal %ra write_rgb_element.2627 #1933
	addi %sp %sp -8 #1933
	lw %ra %sp 4 #1933
	addi %a0 %zero 32 #1934
	sw %ra %sp 4 #1934 call dir
	addi %sp %sp 8 #1934	
	jal %ra min_caml_print_char #1934
	addi %sp %sp -8 #1934
	lw %ra %sp 4 #1934
	lw %a0 %sp 0 #53
	lw %f0 %a0 4 #53
	sw %ra %sp 4 #1935 call dir
	addi %sp %sp 8 #1935	
	jal %ra write_rgb_element.2627 #1935
	addi %sp %sp -8 #1935
	lw %ra %sp 4 #1935
	addi %a0 %zero 32 #1936
	sw %ra %sp 4 #1936 call dir
	addi %sp %sp 8 #1936	
	jal %ra min_caml_print_char #1936
	addi %sp %sp -8 #1936
	lw %ra %sp 4 #1936
	lw %a0 %sp 0 #53
	lw %f0 %a0 8 #53
	sw %ra %sp 4 #1937 call dir
	addi %sp %sp 8 #1937	
	jal %ra write_rgb_element.2627 #1937
	addi %sp %sp -8 #1937
	lw %ra %sp 4 #1937
	addi %a0 %zero 10 #1938
	jal	%zero min_caml_print_char
pretrace_diffuse_rays.2631:
	lw %a2 %a11 12 #1946
	lw %a3 %a11 8 #1946
	lw %a4 %a11 4 #1946
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.8800
	sw %a11 %sp 0 #1950
	sw %a2 %sp 4 #1950
	sw %a3 %sp 8 #1950
	sw %a4 %sp 12 #1950
	sw %a1 %sp 16 #1950
	sw %a0 %sp 20 #1950
	sw %ra %sp 28 #1950 call dir
	addi %sp %sp 32 #1950	
	jal %ra get_surface_id.2609 #1950
	addi %sp %sp -32 #1950
	lw %ra %sp 28 #1950
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8801
	lw %a0 %sp 20 #1953
	sw %ra %sp 28 #1953 call dir
	addi %sp %sp 32 #1953	
	jal %ra p_calc_diffuse.2338 #1953
	addi %sp %sp -32 #1953
	lw %ra %sp 28 #1953
	lw %a1 %sp 16 #1666
	slli %a2 %a1 2 #1666
	add %a12 %a0 %a2 #1666
	lw %a0 %a12 0 #1666
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8802 # nontail if
	jal %zero beq_cont.8803 # then sentence ends
beq_else.8802:
	lw %a0 %sp 20 #1955
	sw %ra %sp 28 #1955 call dir
	addi %sp %sp 32 #1955	
	jal %ra p_group_id.2344 #1955
	addi %sp %sp -32 #1955
	lw %ra %sp 28 #1955
	lw %a1 %sp 12 #1956
	sw %a0 %sp 24 #1956
	add %a0 %a1 %zero
	sw %ra %sp 28 #1956 call dir
	addi %sp %sp 32 #1956	
	jal %ra vecbzero.2252 #1956
	addi %sp %sp -32 #1956
	lw %ra %sp 28 #1956
	lw %a0 %sp 20 #1959
	sw %ra %sp 28 #1959 call dir
	addi %sp %sp 32 #1959	
	jal %ra p_nvectors.2349 #1959
	addi %sp %sp -32 #1959
	lw %ra %sp 28 #1959
	lw %a1 %sp 20 #1960
	sw %a0 %sp 28 #1960
	add %a0 %a1 %zero
	sw %ra %sp 36 #1960 call dir
	addi %sp %sp 40 #1960	
	jal %ra p_intersection_points.2334 #1960
	addi %sp %sp -40 #1960
	lw %ra %sp 36 #1960
	lw %a1 %sp 24 #80
	slli %a1 %a1 2 #80
	lw %a2 %sp 8 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	lw %a2 %sp 16 #1673
	slli %a3 %a2 2 #1673
	lw %a4 %sp 28 #1673
	add %a12 %a4 %a3 #1673
	lw %a3 %a12 0 #1673
	slli %a4 %a2 2 #1661
	add %a12 %a0 %a4 #1661
	lw %a0 %a12 0 #1661
	lw %a11 %sp 4 #1961
	add %a2 %a0 %zero
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 36 #1961 call cls
	lw %a10 %a11 0 #1961
	addi %sp %sp 40 #1961	
	jalr %ra %a10 0 #1961
	addi %sp %sp -40 #1961
	lw %ra %sp 36 #1961
	lw %a0 %sp 20 #1965
	sw %ra %sp 36 #1965 call dir
	addi %sp %sp 40 #1965	
	jal %ra p_received_ray_20percent.2342 #1965
	addi %sp %sp -40 #1965
	lw %ra %sp 36 #1965
	lw %a1 %sp 16 #1807
	slli %a2 %a1 2 #1807
	add %a12 %a0 %a2 #1807
	lw %a0 %a12 0 #1807
	lw %a2 %sp 12 #1966
	add %a1 %a2 %zero
	sw %ra %sp 36 #1966 call dir
	addi %sp %sp 40 #1966	
	jal %ra veccpy.2254 #1966
	addi %sp %sp -40 #1966
	lw %ra %sp 36 #1966
beq_cont.8803:
	lw %a0 %sp 16 #1968
	addi %a1 %a0 1 #1968
	lw %a0 %sp 20 #1968
	lw %a11 %sp 0 #1968
	lw %a10 %a11 0 #1968
	jalr %zero %a10 0 #1968
bge_else.8801:
	jalr %zero %ra 0 #1969
bge_else.8800:
	jalr %zero %ra 0 #1970
pretrace_pixels.2634:
	lw %a3 %a11 36 #1975
	lw %a4 %a11 32 #1975
	lw %a5 %a11 28 #1975
	lw %a6 %a11 24 #1975
	lw %a7 %a11 20 #1975
	lw %a8 %a11 16 #1975
	lw %a9 %a11 12 #1975
	lw %a10 %a11 8 #1975
	sw %a11 %sp 0 #1975
	lw %a11 %a11 4 #1975
	sw %a10 %sp 4 #1976
	addi %a10 %zero 0 #1976
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8806
	lw %f3 %a7 0 #60
	lw %a7 %a11 0 #58
	sub %a7 %a1 %a7 #1978
	sw %a2 %sp 8 #1978
	sw %a4 %sp 12 #1978
	sw %a0 %sp 16 #1978
	sw %a1 %sp 20 #1978
	sw %a3 %sp 24 #1978
	sw %a5 %sp 28 #1978
	sw %a8 %sp 32 #1978
	sw %a10 %sp 36 #1978
	sw %f2 %sp 40 #1978
	sw %f1 %sp 48 #1978
	sw %a9 %sp 56 #1978
	sw %f0 %sp 64 #1978
	sw %a6 %sp 72 #1978
	sw %f3 %sp 80 #1978
	add %a0 %a7 %zero
	sw %ra %sp 92 #1978 call dir
	addi %sp %sp 96 #1978	
	jal %ra min_caml_float_of_int #1978
	addi %sp %sp -96 #1978
	lw %ra %sp 92 #1978
	lw %f1 %sp 80 #1978
	fmul %f0 %f1 %f0 #1978
	lw %a0 %sp 72 #68
	lw %f1 %a0 0 #68
	fmul %f1 %f0 %f1 #1979
	lw %f2 %sp 64 #1979
	fadd %f1 %f1 %f2 #1979
	lw %a1 %sp 56 #1979
	sw %f1 %a1 0 #1979
	lw %f1 %a0 4 #68
	fmul %f1 %f0 %f1 #1980
	lw %f3 %sp 48 #1980
	fadd %f1 %f1 %f3 #1980
	sw %f1 %a1 4 #1980
	lw %f1 %a0 8 #68
	fmul %f0 %f0 %f1 #1981
	lw %f1 %sp 40 #1981
	fadd %f0 %f0 %f1 #1981
	sw %f0 %a1 8 #1981
	lw %a0 %sp 36 #1982
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 92 #1982 call dir
	addi %sp %sp 96 #1982	
	jal %ra vecunit_sgn.2262 #1982
	addi %sp %sp -96 #1982
	lw %ra %sp 92 #1982
	lw %a0 %sp 32 #1983
	sw %ra %sp 92 #1983 call dir
	addi %sp %sp 96 #1983	
	jal %ra vecbzero.2252 #1983
	addi %sp %sp -96 #1983
	lw %ra %sp 92 #1983
	lw %a0 %sp 28 #1984
	lw %a1 %sp 24 #1984
	sw %ra %sp 92 #1984 call dir
	addi %sp %sp 96 #1984	
	jal %ra veccpy.2254 #1984
	addi %sp %sp -96 #1984
	lw %ra %sp 92 #1984
	li %f0 l.5555 #1987
	lw %a0 %sp 20 #1987
	slli %a1 %a0 2 #1987
	lw %a2 %sp 16 #1987
	add %a12 %a2 %a1 #1987
	lw %a1 %a12 0 #1987
	li %f1 l.5553 #1987
	lw %a3 %sp 36 #1987
	lw %a4 %sp 56 #1987
	lw %a11 %sp 12 #1987
	add %a2 %a1 %zero
	add %a0 %a3 %zero
	add %a1 %a4 %zero
	sw %ra %sp 92 #1987 call cls
	lw %a10 %a11 0 #1987
	addi %sp %sp 96 #1987	
	jalr %ra %a10 0 #1987
	addi %sp %sp -96 #1987
	lw %ra %sp 92 #1987
	lw %a0 %sp 20 #1987
	slli %a1 %a0 2 #1987
	lw %a2 %sp 16 #1987
	add %a12 %a2 %a1 #1987
	lw %a1 %a12 0 #1987
	add %a0 %a1 %zero
	sw %ra %sp 92 #1988 call dir
	addi %sp %sp 96 #1988	
	jal %ra p_rgb.2332 #1988
	addi %sp %sp -96 #1988
	lw %ra %sp 92 #1988
	lw %a1 %sp 32 #1988
	sw %ra %sp 92 #1988 call dir
	addi %sp %sp 96 #1988	
	jal %ra veccpy.2254 #1988
	addi %sp %sp -96 #1988
	lw %ra %sp 92 #1988
	lw %a0 %sp 20 #1987
	slli %a1 %a0 2 #1987
	lw %a2 %sp 16 #1987
	add %a12 %a2 %a1 #1987
	lw %a1 %a12 0 #1987
	lw %a3 %sp 8 #1989
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 92 #1989 call dir
	addi %sp %sp 96 #1989	
	jal %ra p_set_group_id.2346 #1989
	addi %sp %sp -96 #1989
	lw %ra %sp 92 #1989
	lw %a0 %sp 20 #1987
	slli %a1 %a0 2 #1987
	lw %a2 %sp 16 #1987
	add %a12 %a2 %a1 #1987
	lw %a1 %a12 0 #1987
	lw %a3 %sp 36 #1992
	lw %a11 %sp 4 #1992
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 92 #1992 call cls
	lw %a10 %a11 0 #1992
	addi %sp %sp 96 #1992	
	jalr %ra %a10 0 #1992
	addi %sp %sp -96 #1992
	lw %ra %sp 92 #1992
	lw %a0 %sp 20 #1994
	addi %a0 %a0 -1 #1994
	addi %a1 %zero 1 #1994
	lw %a2 %sp 8 #1994
	sw %a0 %sp 88 #1994
	add %a0 %a2 %zero
	sw %ra %sp 92 #1994 call dir
	addi %sp %sp 96 #1994	
	jal %ra add_mod5.2241 #1994
	addi %sp %sp -96 #1994
	lw %ra %sp 92 #1994
	add %a2 %a0 %zero #1994
	lw %f0 %sp 64 #1994
	lw %f1 %sp 48 #1994
	lw %f2 %sp 40 #1994
	lw %a0 %sp 16 #1994
	lw %a1 %sp 88 #1994
	lw %a11 %sp 0 #1994
	lw %a10 %a11 0 #1994
	jalr %zero %a10 0 #1994
bge_else.8806:
	jalr %zero %ra 0 #1996
pretrace_line.2641:
	lw %a3 %a11 24 #2000
	lw %a4 %a11 20 #2000
	lw %a5 %a11 16 #2000
	lw %a6 %a11 12 #2000
	lw %a7 %a11 8 #2000
	lw %a8 %a11 4 #2000
	lw %f0 %a5 0 #60
	lw %a5 %a8 4 #58
	sub %a1 %a1 %a5 #2001
	sw %a2 %sp 0 #2001
	sw %a0 %sp 4 #2001
	sw %a6 %sp 8 #2001
	sw %a7 %sp 12 #2001
	sw %a3 %sp 16 #2001
	sw %a4 %sp 20 #2001
	sw %f0 %sp 24 #2001
	add %a0 %a1 %zero
	sw %ra %sp 36 #2001 call dir
	addi %sp %sp 40 #2001	
	jal %ra min_caml_float_of_int #2001
	addi %sp %sp -40 #2001
	lw %ra %sp 36 #2001
	lw %f1 %sp 24 #2001
	fmul %f0 %f1 %f0 #2001
	lw %a0 %sp 20 #69
	lw %f1 %a0 0 #69
	fmul %f1 %f0 %f1 #2004
	lw %a1 %sp 16 #70
	lw %f2 %a1 0 #70
	fadd %f1 %f1 %f2 #2004
	lw %f2 %a0 4 #69
	fmul %f2 %f0 %f2 #2005
	lw %f3 %a1 4 #70
	fadd %f2 %f2 %f3 #2005
	lw %f3 %a0 8 #69
	fmul %f0 %f0 %f3 #2006
	lw %f3 %a1 8 #70
	fadd %f0 %f0 %f3 #2006
	lw %a0 %sp 12 #56
	lw %a0 %a0 0 #56
	addi %a1 %a0 -1 #2007
	lw %a0 %sp 4 #2007
	lw %a2 %sp 0 #2007
	lw %a11 %sp 8 #2007
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	lw %a10 %a11 0 #2007
	jalr %zero %a10 0 #2007
scan_pixel.2645:
	lw %a5 %a11 24 #2014
	lw %a6 %a11 20 #2014
	lw %a7 %a11 16 #2014
	lw %a8 %a11 12 #2014
	lw %a9 %a11 8 #2014
	lw %a10 %a11 4 #2014
	lw %a9 %a9 0 #56
	blt %a0 %a9 bge_else.8810
	jalr %zero %ra 0 #2030
bge_else.8810:
	slli %a9 %a0 2 #2018
	add %a12 %a3 %a9 #2018
	lw %a9 %a12 0 #2018
	sw %a11 %sp 0 #2018
	sw %a5 %sp 4 #2018
	sw %a2 %sp 8 #2018
	sw %a6 %sp 12 #2018
	sw %a10 %sp 16 #2018
	sw %a3 %sp 20 #2018
	sw %a4 %sp 24 #2018
	sw %a1 %sp 28 #2018
	sw %a0 %sp 32 #2018
	sw %a8 %sp 36 #2018
	sw %a7 %sp 40 #2018
	add %a0 %a9 %zero
	sw %ra %sp 44 #2018 call dir
	addi %sp %sp 48 #2018	
	jal %ra p_rgb.2332 #2018
	addi %sp %sp -48 #2018
	lw %ra %sp 44 #2018
	add %a1 %a0 %zero #2018
	lw %a0 %sp 40 #2018
	sw %ra %sp 44 #2018 call dir
	addi %sp %sp 48 #2018	
	jal %ra veccpy.2254 #2018
	addi %sp %sp -48 #2018
	lw %ra %sp 44 #2018
	lw %a0 %sp 32 #2021
	lw %a1 %sp 28 #2021
	lw %a2 %sp 24 #2021
	lw %a11 %sp 36 #2021
	sw %ra %sp 44 #2021 call cls
	lw %a10 %a11 0 #2021
	addi %sp %sp 48 #2021	
	jalr %ra %a10 0 #2021
	addi %sp %sp -48 #2021
	lw %ra %sp 44 #2021
	addi %a1 %zero 0 #2021
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8812 # nontail if
	lw %a0 %sp 32 #2018
	slli %a2 %a0 2 #2018
	lw %a3 %sp 20 #2018
	add %a12 %a3 %a2 #2018
	lw %a2 %a12 0 #2018
	lw %a11 %sp 16 #2024
	add %a0 %a2 %zero
	sw %ra %sp 44 #2024 call cls
	lw %a10 %a11 0 #2024
	addi %sp %sp 48 #2024	
	jalr %ra %a10 0 #2024
	addi %sp %sp -48 #2024
	lw %ra %sp 44 #2024
	jal %zero beq_cont.8813 # then sentence ends
beq_else.8812:
	lw %a0 %sp 32 #2022
	lw %a2 %sp 28 #2022
	lw %a3 %sp 8 #2022
	lw %a4 %sp 20 #2022
	lw %a5 %sp 24 #2022
	lw %a11 %sp 12 #2022
	add %a10 %a5 %zero
	add %a5 %a1 %zero
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	add %a3 %a4 %zero
	add %a4 %a10 %zero
	sw %ra %sp 44 #2022 call cls
	lw %a10 %a11 0 #2022
	addi %sp %sp 48 #2022	
	jalr %ra %a10 0 #2022
	addi %sp %sp -48 #2022
	lw %ra %sp 44 #2022
beq_cont.8813:
	lw %a11 %sp 4 #2027
	sw %ra %sp 44 #2027 call cls
	lw %a10 %a11 0 #2027
	addi %sp %sp 48 #2027	
	jalr %ra %a10 0 #2027
	addi %sp %sp -48 #2027
	lw %ra %sp 44 #2027
	lw %a0 %sp 32 #2029
	addi %a0 %a0 1 #2029
	lw %a1 %sp 28 #2029
	lw %a2 %sp 8 #2029
	lw %a3 %sp 20 #2029
	lw %a4 %sp 24 #2029
	lw %a11 %sp 0 #2029
	lw %a10 %a11 0 #2029
	jalr %zero %a10 0 #2029
scan_line.2651:
	lw %a5 %a11 12 #2034
	lw %a6 %a11 8 #2034
	lw %a7 %a11 4 #2034
	lw %a8 %a7 4 #56
	blt %a0 %a8 bge_else.8814
	jalr %zero %ra 0 #2043
bge_else.8814:
	lw %a7 %a7 4 #56
	addi %a7 %a7 -1 #2038
	sw %a11 %sp 0 #2038
	sw %a4 %sp 4 #2038
	sw %a3 %sp 8 #2038
	sw %a2 %sp 12 #2038
	sw %a1 %sp 16 #2038
	sw %a0 %sp 20 #2038
	sw %a5 %sp 24 #2038
	blt %a0 %a7 bge_else.8816 # nontail if
	jal %zero bge_cont.8817 # then sentence ends
bge_else.8816:
	addi %a7 %a0 1 #2039
	add %a2 %a4 %zero
	add %a1 %a7 %zero
	add %a0 %a3 %zero
	add %a11 %a6 %zero
	sw %ra %sp 28 #2039 call cls
	lw %a10 %a11 0 #2039
	addi %sp %sp 32 #2039	
	jalr %ra %a10 0 #2039
	addi %sp %sp -32 #2039
	lw %ra %sp 28 #2039
bge_cont.8817:
	addi %a0 %zero 0 #2041
	lw %a1 %sp 20 #2041
	lw %a2 %sp 16 #2041
	lw %a3 %sp 12 #2041
	lw %a4 %sp 8 #2041
	lw %a11 %sp 24 #2041
	sw %ra %sp 28 #2041 call cls
	lw %a10 %a11 0 #2041
	addi %sp %sp 32 #2041	
	jalr %ra %a10 0 #2041
	addi %sp %sp -32 #2041
	lw %ra %sp 28 #2041
	lw %a0 %sp 20 #2042
	addi %a0 %a0 1 #2042
	addi %a1 %zero 2 #2042
	lw %a2 %sp 4 #2042
	sw %a0 %sp 28 #2042
	add %a0 %a2 %zero
	sw %ra %sp 36 #2042 call dir
	addi %sp %sp 40 #2042	
	jal %ra add_mod5.2241 #2042
	addi %sp %sp -40 #2042
	lw %ra %sp 36 #2042
	add %a4 %a0 %zero #2042
	lw %a0 %sp 28 #2042
	lw %a1 %sp 12 #2042
	lw %a2 %sp 8 #2042
	lw %a3 %sp 16 #2042
	lw %a11 %sp 0 #2042
	lw %a10 %a11 0 #2042
	jalr %zero %a10 0 #2042
create_float5x3array.2657:
	addi %a0 %zero 3 #2051
	li %f0 l.5553 #2051
	sw %ra %sp 4 #2051 call dir
	addi %sp %sp 8 #2051	
	jal %ra min_caml_create_float_array #2051
	addi %sp %sp -8 #2051
	lw %ra %sp 4 #2051
	add %a1 %a0 %zero #2051
	addi %a0 %zero 5 #2052
	sw %ra %sp 4 #2052 call dir
	addi %sp %sp 8 #2052	
	jal %ra min_caml_create_array #2052
	addi %sp %sp -8 #2052
	lw %ra %sp 4 #2052
	addi %a1 %zero 3 #2053
	li %f0 l.5553 #2053
	sw %a0 %sp 0 #2053
	add %a0 %a1 %zero
	sw %ra %sp 4 #2053 call dir
	addi %sp %sp 8 #2053	
	jal %ra min_caml_create_float_array #2053
	addi %sp %sp -8 #2053
	lw %ra %sp 4 #2053
	lw %a1 %sp 0 #2053
	sw %a0 %a1 4 #2053
	addi %a0 %zero 3 #2054
	li %f0 l.5553 #2054
	sw %ra %sp 4 #2054 call dir
	addi %sp %sp 8 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -8 #2054
	lw %ra %sp 4 #2054
	lw %a1 %sp 0 #2054
	sw %a0 %a1 8 #2054
	addi %a0 %zero 3 #2055
	li %f0 l.5553 #2055
	sw %ra %sp 4 #2055 call dir
	addi %sp %sp 8 #2055	
	jal %ra min_caml_create_float_array #2055
	addi %sp %sp -8 #2055
	lw %ra %sp 4 #2055
	lw %a1 %sp 0 #2055
	sw %a0 %a1 12 #2055
	addi %a0 %zero 3 #2056
	li %f0 l.5553 #2056
	sw %ra %sp 4 #2056 call dir
	addi %sp %sp 8 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -8 #2056
	lw %ra %sp 4 #2056
	lw %a1 %sp 0 #2056
	sw %a0 %a1 16 #2056
	addi %a0 %a1 0 #2057
	jalr %zero %ra 0 #2057
create_pixel.2659:
	addi %a0 %zero 3 #2063
	li %f0 l.5553 #2063
	sw %ra %sp 4 #2063 call dir
	addi %sp %sp 8 #2063	
	jal %ra min_caml_create_float_array #2063
	addi %sp %sp -8 #2063
	lw %ra %sp 4 #2063
	sw %a0 %sp 0 #2064
	sw %ra %sp 4 #2064 call dir
	addi %sp %sp 8 #2064	
	jal %ra create_float5x3array.2657 #2064
	addi %sp %sp -8 #2064
	lw %ra %sp 4 #2064
	addi %a1 %zero 5 #2065
	addi %a2 %zero 0 #2065
	sw %a0 %sp 4 #2065
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 12 #2065 call dir
	addi %sp %sp 16 #2065	
	jal %ra min_caml_create_array #2065
	addi %sp %sp -16 #2065
	lw %ra %sp 12 #2065
	addi %a1 %zero 5 #2066
	addi %a2 %zero 0 #2066
	sw %a0 %sp 8 #2066
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 12 #2066 call dir
	addi %sp %sp 16 #2066	
	jal %ra min_caml_create_array #2066
	addi %sp %sp -16 #2066
	lw %ra %sp 12 #2066
	sw %a0 %sp 12 #2067
	sw %ra %sp 20 #2067 call dir
	addi %sp %sp 24 #2067	
	jal %ra create_float5x3array.2657 #2067
	addi %sp %sp -24 #2067
	lw %ra %sp 20 #2067
	sw %a0 %sp 16 #2068
	sw %ra %sp 20 #2068 call dir
	addi %sp %sp 24 #2068	
	jal %ra create_float5x3array.2657 #2068
	addi %sp %sp -24 #2068
	lw %ra %sp 20 #2068
	addi %a1 %zero 1 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 20 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 28 #2069 call dir
	addi %sp %sp 32 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -32 #2069
	lw %ra %sp 28 #2069
	sw %a0 %sp 24 #2070
	sw %ra %sp 28 #2070 call dir
	addi %sp %sp 32 #2070	
	jal %ra create_float5x3array.2657 #2070
	addi %sp %sp -32 #2070
	lw %ra %sp 28 #2070
	addi %a1 %min_caml_hp 0 #2071
	addi %min_caml_hp %min_caml_hp 32 #2071
	sw %a0 %a1 28 #2071
	lw %a0 %sp 24 #2071
	sw %a0 %a1 24 #2071
	lw %a0 %sp 20 #2071
	sw %a0 %a1 20 #2071
	lw %a0 %sp 16 #2071
	sw %a0 %a1 16 #2071
	lw %a0 %sp 12 #2071
	sw %a0 %a1 12 #2071
	lw %a0 %sp 8 #2071
	sw %a0 %a1 8 #2071
	lw %a0 %sp 4 #2071
	sw %a0 %a1 4 #2071
	lw %a0 %sp 0 #2071
	sw %a0 %a1 0 #2071
	addi %a0 %a1 0 #2071
	jalr %zero %ra 0 #2071
init_line_elements.2661:
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8818
	sw %a0 %sp 0 #2077
	sw %a1 %sp 4 #2077
	sw %ra %sp 12 #2077 call dir
	addi %sp %sp 16 #2077	
	jal %ra create_pixel.2659 #2077
	addi %sp %sp -16 #2077
	lw %ra %sp 12 #2077
	lw %a1 %sp 4 #2077
	slli %a2 %a1 2 #2077
	lw %a3 %sp 0 #2077
	add %a12 %a3 %a2 #2077
	sw %a0 %a12 0 #2077
	addi %a1 %a1 -1 #2078
	add %a0 %a3 %zero
	jal	%zero init_line_elements.2661
bge_else.8818:
	jalr %zero %ra 0 #2080
create_pixelline.2664:
	lw %a0 %a11 4 #2084
	lw %a1 %a0 0 #56
	sw %a0 %sp 0 #2085
	sw %a1 %sp 4 #2085
	sw %ra %sp 12 #2085 call dir
	addi %sp %sp 16 #2085	
	jal %ra create_pixel.2659 #2085
	addi %sp %sp -16 #2085
	lw %ra %sp 12 #2085
	add %a1 %a0 %zero #2085
	lw %a0 %sp 4 #2085
	sw %ra %sp 12 #2085 call dir
	addi %sp %sp 16 #2085	
	jal %ra min_caml_create_array #2085
	addi %sp %sp -16 #2085
	lw %ra %sp 12 #2085
	lw %a1 %sp 0 #56
	lw %a1 %a1 0 #56
	addi %a1 %a1 -2 #2086
	jal	%zero init_line_elements.2661
tan.2666:
	sw %f0 %sp 0 #2094
	sw %ra %sp 12 #2094 call dir
	addi %sp %sp 16 #2094	
	jal %ra min_caml_sin #2094
	addi %sp %sp -16 #2094
	lw %ra %sp 12 #2094
	lw %f1 %sp 0 #2094
	sw %f0 %sp 8 #2094
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #2094 call dir
	addi %sp %sp 24 #2094	
	jal %ra min_caml_cos #2094
	addi %sp %sp -24 #2094
	lw %ra %sp 20 #2094
	lw %f1 %sp 8 #2094
	fdiv %f0 %f1 %f0 #2094
	jalr %zero %ra 0 #2094
adjust_position.2668:
	fmul %f0 %f0 %f0 #2099
	li %f2 l.6112 #2099
	fadd %f0 %f0 %f2 #2099
	sw %f1 %sp 0 #2099
	sw %ra %sp 12 #2099 call dir
	addi %sp %sp 16 #2099	
	jal %ra min_caml_sqrt #2099
	addi %sp %sp -16 #2099
	lw %ra %sp 12 #2099
	li %f1 l.5555 #2100
	fdiv %f1 %f1 %f0 #2100
	sw %f0 %sp 8 #2101
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #2101 call dir
	addi %sp %sp 24 #2101	
	jal %ra min_caml_atan #2101
	addi %sp %sp -24 #2101
	lw %ra %sp 20 #2101
	lw %f1 %sp 0 #2102
	fmul %f0 %f0 %f1 #2102
	sw %ra %sp 20 #2102 call dir
	addi %sp %sp 24 #2102	
	jal %ra tan.2666 #2102
	addi %sp %sp -24 #2102
	lw %ra %sp 20 #2102
	lw %f1 %sp 8 #2103
	fmul %f0 %f0 %f1 #2103
	jalr %zero %ra 0 #2103
calc_dirvec.2671:
	lw %a3 %a11 4 #2107
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.8819
	sw %a2 %sp 0 #2109
	sw %a3 %sp 4 #2109
	sw %a1 %sp 8 #2109
	sw %f0 %sp 16 #2109
	sw %f1 %sp 24 #2109
	sw %ra %sp 36 #2109 call dir
	addi %sp %sp 40 #2109	
	jal %ra min_caml_fsqr #2109
	addi %sp %sp -40 #2109
	lw %ra %sp 36 #2109
	lw %f1 %sp 24 #2109
	sw %f0 %sp 32 #2109
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #2109 call dir
	addi %sp %sp 48 #2109	
	jal %ra min_caml_fsqr #2109
	addi %sp %sp -48 #2109
	lw %ra %sp 44 #2109
	lw %f1 %sp 32 #2109
	fadd %f0 %f1 %f0 #2109
	li %f1 l.5555 #2109
	fadd %f0 %f0 %f1 #2109
	sw %ra %sp 44 #2109 call dir
	addi %sp %sp 48 #2109	
	jal %ra min_caml_sqrt #2109
	addi %sp %sp -48 #2109
	lw %ra %sp 44 #2109
	lw %f1 %sp 16 #2110
	fdiv %f1 %f1 %f0 #2110
	lw %f2 %sp 24 #2111
	fdiv %f2 %f2 %f0 #2111
	li %f3 l.5555 #2112
	fdiv %f0 %f3 %f0 #2112
	lw %a0 %sp 8 #80
	slli %a0 %a0 2 #80
	lw %a1 %sp 4 #80
	add %a12 %a1 %a0 #80
	lw %a0 %a12 0 #80
	lw %a1 %sp 0 #79
	slli %a2 %a1 2 #79
	add %a12 %a0 %a2 #79
	lw %a2 %a12 0 #79
	sw %a0 %sp 40 #2116
	sw %f0 %sp 48 #2116
	sw %f2 %sp 56 #2116
	sw %f1 %sp 64 #2116
	add %a0 %a2 %zero
	sw %ra %sp 76 #2116 call dir
	addi %sp %sp 80 #2116	
	jal %ra d_vec.2351 #2116
	addi %sp %sp -80 #2116
	lw %ra %sp 76 #2116
	lw %f0 %sp 64 #2116
	lw %f1 %sp 56 #2116
	lw %f2 %sp 48 #2116
	sw %ra %sp 76 #2116 call dir
	addi %sp %sp 80 #2116	
	jal %ra vecset.2244 #2116
	addi %sp %sp -80 #2116
	lw %ra %sp 76 #2116
	lw %a0 %sp 0 #2117
	addi %a1 %a0 40 #2117
	slli %a1 %a1 2 #79
	lw %a2 %sp 40 #79
	add %a12 %a2 %a1 #79
	lw %a1 %a12 0 #79
	add %a0 %a1 %zero
	sw %ra %sp 76 #2117 call dir
	addi %sp %sp 80 #2117	
	jal %ra d_vec.2351 #2117
	addi %sp %sp -80 #2117
	lw %ra %sp 76 #2117
	lw %f0 %sp 56 #2117
	sw %a0 %sp 72 #2117
	sw %ra %sp 76 #2117 call dir
	addi %sp %sp 80 #2117	
	jal %ra min_caml_fneg #2117
	addi %sp %sp -80 #2117
	lw %ra %sp 76 #2117
	fadd %f2 %f0 %fzero #2117
	lw %f0 %sp 64 #2117
	lw %f1 %sp 48 #2117
	lw %a0 %sp 72 #2117
	sw %ra %sp 76 #2117 call dir
	addi %sp %sp 80 #2117	
	jal %ra vecset.2244 #2117
	addi %sp %sp -80 #2117
	lw %ra %sp 76 #2117
	lw %a0 %sp 0 #2118
	addi %a1 %a0 80 #2118
	slli %a1 %a1 2 #79
	lw %a2 %sp 40 #79
	add %a12 %a2 %a1 #79
	lw %a1 %a12 0 #79
	add %a0 %a1 %zero
	sw %ra %sp 76 #2118 call dir
	addi %sp %sp 80 #2118	
	jal %ra d_vec.2351 #2118
	addi %sp %sp -80 #2118
	lw %ra %sp 76 #2118
	lw %f0 %sp 64 #2118
	sw %a0 %sp 76 #2118
	sw %ra %sp 84 #2118 call dir
	addi %sp %sp 88 #2118	
	jal %ra min_caml_fneg #2118
	addi %sp %sp -88 #2118
	lw %ra %sp 84 #2118
	lw %f1 %sp 56 #2118
	sw %f0 %sp 80 #2118
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #2118 call dir
	addi %sp %sp 96 #2118	
	jal %ra min_caml_fneg #2118
	addi %sp %sp -96 #2118
	lw %ra %sp 92 #2118
	fadd %f2 %f0 %fzero #2118
	lw %f0 %sp 48 #2118
	lw %f1 %sp 80 #2118
	lw %a0 %sp 76 #2118
	sw %ra %sp 92 #2118 call dir
	addi %sp %sp 96 #2118	
	jal %ra vecset.2244 #2118
	addi %sp %sp -96 #2118
	lw %ra %sp 92 #2118
	lw %a0 %sp 0 #2119
	addi %a1 %a0 1 #2119
	slli %a1 %a1 2 #79
	lw %a2 %sp 40 #79
	add %a12 %a2 %a1 #79
	lw %a1 %a12 0 #79
	add %a0 %a1 %zero
	sw %ra %sp 92 #2119 call dir
	addi %sp %sp 96 #2119	
	jal %ra d_vec.2351 #2119
	addi %sp %sp -96 #2119
	lw %ra %sp 92 #2119
	lw %f0 %sp 64 #2119
	sw %a0 %sp 88 #2119
	sw %ra %sp 92 #2119 call dir
	addi %sp %sp 96 #2119	
	jal %ra min_caml_fneg #2119
	addi %sp %sp -96 #2119
	lw %ra %sp 92 #2119
	lw %f1 %sp 56 #2119
	sw %f0 %sp 96 #2119
	fadd %f0 %f1 %fzero
	sw %ra %sp 108 #2119 call dir
	addi %sp %sp 112 #2119	
	jal %ra min_caml_fneg #2119
	addi %sp %sp -112 #2119
	lw %ra %sp 108 #2119
	lw %f1 %sp 48 #2119
	sw %f0 %sp 104 #2119
	fadd %f0 %f1 %fzero
	sw %ra %sp 116 #2119 call dir
	addi %sp %sp 120 #2119	
	jal %ra min_caml_fneg #2119
	addi %sp %sp -120 #2119
	lw %ra %sp 116 #2119
	fadd %f2 %f0 %fzero #2119
	lw %f0 %sp 96 #2119
	lw %f1 %sp 104 #2119
	lw %a0 %sp 88 #2119
	sw %ra %sp 116 #2119 call dir
	addi %sp %sp 120 #2119	
	jal %ra vecset.2244 #2119
	addi %sp %sp -120 #2119
	lw %ra %sp 116 #2119
	lw %a0 %sp 0 #2120
	addi %a1 %a0 41 #2120
	slli %a1 %a1 2 #79
	lw %a2 %sp 40 #79
	add %a12 %a2 %a1 #79
	lw %a1 %a12 0 #79
	add %a0 %a1 %zero
	sw %ra %sp 116 #2120 call dir
	addi %sp %sp 120 #2120	
	jal %ra d_vec.2351 #2120
	addi %sp %sp -120 #2120
	lw %ra %sp 116 #2120
	lw %f0 %sp 64 #2120
	sw %a0 %sp 112 #2120
	sw %ra %sp 116 #2120 call dir
	addi %sp %sp 120 #2120	
	jal %ra min_caml_fneg #2120
	addi %sp %sp -120 #2120
	lw %ra %sp 116 #2120
	lw %f1 %sp 48 #2120
	sw %f0 %sp 120 #2120
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #2120 call dir
	addi %sp %sp 136 #2120	
	jal %ra min_caml_fneg #2120
	addi %sp %sp -136 #2120
	lw %ra %sp 132 #2120
	fadd %f1 %f0 %fzero #2120
	lw %f0 %sp 120 #2120
	lw %f2 %sp 56 #2120
	lw %a0 %sp 112 #2120
	sw %ra %sp 132 #2120 call dir
	addi %sp %sp 136 #2120	
	jal %ra vecset.2244 #2120
	addi %sp %sp -136 #2120
	lw %ra %sp 132 #2120
	lw %a0 %sp 0 #2121
	addi %a0 %a0 81 #2121
	slli %a0 %a0 2 #79
	lw %a1 %sp 40 #79
	add %a12 %a1 %a0 #79
	lw %a0 %a12 0 #79
	sw %ra %sp 132 #2121 call dir
	addi %sp %sp 136 #2121	
	jal %ra d_vec.2351 #2121
	addi %sp %sp -136 #2121
	lw %ra %sp 132 #2121
	lw %f0 %sp 48 #2121
	sw %a0 %sp 128 #2121
	sw %ra %sp 132 #2121 call dir
	addi %sp %sp 136 #2121	
	jal %ra min_caml_fneg #2121
	addi %sp %sp -136 #2121
	lw %ra %sp 132 #2121
	lw %f1 %sp 64 #2121
	lw %f2 %sp 56 #2121
	lw %a0 %sp 128 #2121
	jal	%zero vecset.2244
bge_else.8819:
	sw %f2 %sp 136 #2123
	sw %a2 %sp 0 #2123
	sw %a1 %sp 8 #2123
	sw %a11 %sp 144 #2123
	sw %f3 %sp 152 #2123
	sw %a0 %sp 160 #2123
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	sw %ra %sp 164 #2123 call dir
	addi %sp %sp 168 #2123	
	jal %ra adjust_position.2668 #2123
	addi %sp %sp -168 #2123
	lw %ra %sp 164 #2123
	lw %a0 %sp 160 #2124
	addi %a0 %a0 1 #2124
	lw %f1 %sp 152 #2124
	sw %f0 %sp 168 #2124
	sw %a0 %sp 176 #2124
	sw %ra %sp 180 #2124 call dir
	addi %sp %sp 184 #2124	
	jal %ra adjust_position.2668 #2124
	addi %sp %sp -184 #2124
	lw %ra %sp 180 #2124
	fadd %f1 %f0 %fzero #2124
	lw %f0 %sp 168 #2124
	lw %f2 %sp 136 #2124
	lw %f3 %sp 152 #2124
	lw %a0 %sp 176 #2124
	lw %a1 %sp 8 #2124
	lw %a2 %sp 0 #2124
	lw %a11 %sp 144 #2124
	lw %a10 %a11 0 #2124
	jalr %zero %a10 0 #2124
calc_dirvecs.2679:
	lw %a3 %a11 4 #2128
	addi %a4 %zero 0 #2129
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8827
	sw %a11 %sp 0 #2131
	sw %a0 %sp 4 #2131
	sw %f0 %sp 8 #2131
	sw %a2 %sp 16 #2131
	sw %a1 %sp 20 #2131
	sw %a4 %sp 24 #2131
	sw %a3 %sp 28 #2131
	sw %ra %sp 36 #2131 call dir
	addi %sp %sp 40 #2131	
	jal %ra min_caml_float_of_int #2131
	addi %sp %sp -40 #2131
	lw %ra %sp 36 #2131
	li %f1 l.6240 #2131
	fmul %f0 %f0 %f1 #2131
	li %f1 l.6242 #2131
	fsub %f2 %f0 %f1 #2131
	li %f0 l.5553 #2132
	li %f1 l.5553 #2132
	lw %f3 %sp 8 #2132
	lw %a0 %sp 24 #2132
	lw %a1 %sp 20 #2132
	lw %a2 %sp 16 #2132
	lw %a11 %sp 28 #2132
	sw %ra %sp 36 #2132 call cls
	lw %a10 %a11 0 #2132
	addi %sp %sp 40 #2132	
	jalr %ra %a10 0 #2132
	addi %sp %sp -40 #2132
	lw %ra %sp 36 #2132
	lw %a0 %sp 4 #2134
	sw %ra %sp 36 #2134 call dir
	addi %sp %sp 40 #2134	
	jal %ra min_caml_float_of_int #2134
	addi %sp %sp -40 #2134
	lw %ra %sp 36 #2134
	li %f1 l.6240 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.6112 #2134
	fadd %f2 %f0 %f1 #2134
	li %f0 l.5553 #2135
	li %f1 l.5553 #2135
	lw %a0 %sp 16 #2135
	addi %a2 %a0 2 #2135
	lw %f3 %sp 8 #2135
	lw %a1 %sp 24 #2135
	lw %a3 %sp 20 #2135
	lw %a11 %sp 28 #2135
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 36 #2135 call cls
	lw %a10 %a11 0 #2135
	addi %sp %sp 40 #2135	
	jalr %ra %a10 0 #2135
	addi %sp %sp -40 #2135
	lw %ra %sp 36 #2135
	lw %a0 %sp 4 #2137
	addi %a0 %a0 -1 #2137
	addi %a1 %zero 1 #2137
	lw %a2 %sp 20 #2137
	sw %a0 %sp 32 #2137
	add %a0 %a2 %zero
	sw %ra %sp 36 #2137 call dir
	addi %sp %sp 40 #2137	
	jal %ra add_mod5.2241 #2137
	addi %sp %sp -40 #2137
	lw %ra %sp 36 #2137
	add %a1 %a0 %zero #2137
	lw %f0 %sp 8 #2137
	lw %a0 %sp 32 #2137
	lw %a2 %sp 16 #2137
	lw %a11 %sp 0 #2137
	lw %a10 %a11 0 #2137
	jalr %zero %a10 0 #2137
bge_else.8827:
	jalr %zero %ra 0 #2138
calc_dirvec_rows.2684:
	lw %a3 %a11 4 #2142
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8829
	sw %a11 %sp 0 #2144
	sw %a0 %sp 4 #2144
	sw %a2 %sp 8 #2144
	sw %a1 %sp 12 #2144
	sw %a3 %sp 16 #2144
	sw %ra %sp 20 #2144 call dir
	addi %sp %sp 24 #2144	
	jal %ra min_caml_float_of_int #2144
	addi %sp %sp -24 #2144
	lw %ra %sp 20 #2144
	li %f1 l.6240 #2144
	fmul %f0 %f0 %f1 #2144
	li %f1 l.6242 #2144
	fsub %f0 %f0 %f1 #2144
	addi %a0 %zero 4 #2145
	lw %a1 %sp 12 #2145
	lw %a2 %sp 8 #2145
	lw %a11 %sp 16 #2145
	sw %ra %sp 20 #2145 call cls
	lw %a10 %a11 0 #2145
	addi %sp %sp 24 #2145	
	jalr %ra %a10 0 #2145
	addi %sp %sp -24 #2145
	lw %ra %sp 20 #2145
	lw %a0 %sp 4 #2146
	addi %a0 %a0 -1 #2146
	addi %a1 %zero 2 #2146
	lw %a2 %sp 12 #2146
	sw %a0 %sp 20 #2146
	add %a0 %a2 %zero
	sw %ra %sp 28 #2146 call dir
	addi %sp %sp 32 #2146	
	jal %ra add_mod5.2241 #2146
	addi %sp %sp -32 #2146
	lw %ra %sp 28 #2146
	add %a1 %a0 %zero #2146
	lw %a0 %sp 8 #2146
	addi %a2 %a0 4 #2146
	lw %a0 %sp 20 #2146
	lw %a11 %sp 0 #2146
	lw %a10 %a11 0 #2146
	jalr %zero %a10 0 #2146
bge_else.8829:
	jalr %zero %ra 0 #2147
create_dirvec.2688:
	lw %a0 %a11 4 #2153
	addi %a1 %zero 3 #2154
	li %f0 l.5553 #2154
	sw %a0 %sp 0 #2154
	add %a0 %a1 %zero
	sw %ra %sp 4 #2154 call dir
	addi %sp %sp 8 #2154	
	jal %ra min_caml_create_float_array #2154
	addi %sp %sp -8 #2154
	lw %ra %sp 4 #2154
	add %a1 %a0 %zero #2154
	lw %a0 %sp 0 #14
	lw %a0 %a0 0 #14
	sw %a1 %sp 4 #2155
	sw %ra %sp 12 #2155 call dir
	addi %sp %sp 16 #2155	
	jal %ra min_caml_create_array #2155
	addi %sp %sp -16 #2155
	lw %ra %sp 12 #2155
	addi %a1 %min_caml_hp 0 #2156
	addi %min_caml_hp %min_caml_hp 8 #2156
	sw %a0 %a1 4 #2156
	lw %a0 %sp 4 #2156
	sw %a0 %a1 0 #2156
	addi %a0 %a1 0 #2156
	jalr %zero %ra 0 #2156
create_dirvec_elements.2690:
	lw %a2 %a11 4 #2159
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8831
	sw %a11 %sp 0 #2161
	sw %a0 %sp 4 #2161
	sw %a1 %sp 8 #2161
	add %a11 %a2 %zero
	sw %ra %sp 12 #2161 call cls
	lw %a10 %a11 0 #2161
	addi %sp %sp 16 #2161	
	jalr %ra %a10 0 #2161
	addi %sp %sp -16 #2161
	lw %ra %sp 12 #2161
	lw %a1 %sp 8 #2161
	slli %a2 %a1 2 #2161
	lw %a3 %sp 4 #2161
	add %a12 %a3 %a2 #2161
	sw %a0 %a12 0 #2161
	addi %a1 %a1 -1 #2162
	lw %a11 %sp 0 #2162
	add %a0 %a3 %zero
	lw %a10 %a11 0 #2162
	jalr %zero %a10 0 #2162
bge_else.8831:
	jalr %zero %ra 0 #2163
create_dirvecs.2693:
	lw %a1 %a11 12 #2166
	lw %a2 %a11 8 #2166
	lw %a3 %a11 4 #2166
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8833
	addi %a4 %zero 120 #2168
	sw %a11 %sp 0 #2168
	sw %a2 %sp 4 #2168
	sw %a1 %sp 8 #2168
	sw %a0 %sp 12 #2168
	sw %a4 %sp 16 #2168
	add %a11 %a3 %zero
	sw %ra %sp 20 #2168 call cls
	lw %a10 %a11 0 #2168
	addi %sp %sp 24 #2168	
	jalr %ra %a10 0 #2168
	addi %sp %sp -24 #2168
	lw %ra %sp 20 #2168
	add %a1 %a0 %zero #2168
	lw %a0 %sp 16 #2168
	sw %ra %sp 20 #2168 call dir
	addi %sp %sp 24 #2168	
	jal %ra min_caml_create_array #2168
	addi %sp %sp -24 #2168
	lw %ra %sp 20 #2168
	lw %a1 %sp 12 #2168
	slli %a2 %a1 2 #2168
	lw %a3 %sp 8 #2168
	add %a12 %a3 %a2 #2168
	sw %a0 %a12 0 #2168
	slli %a0 %a1 2 #80
	add %a12 %a3 %a0 #80
	lw %a0 %a12 0 #80
	addi %a2 %zero 118 #2169
	lw %a11 %sp 4 #2169
	add %a1 %a2 %zero
	sw %ra %sp 20 #2169 call cls
	lw %a10 %a11 0 #2169
	addi %sp %sp 24 #2169	
	jalr %ra %a10 0 #2169
	addi %sp %sp -24 #2169
	lw %ra %sp 20 #2169
	lw %a0 %sp 12 #2170
	addi %a0 %a0 -1 #2170
	lw %a11 %sp 0 #2170
	lw %a10 %a11 0 #2170
	jalr %zero %a10 0 #2170
bge_else.8833:
	jalr %zero %ra 0 #2171
init_dirvec_constants.2695:
	lw %a2 %a11 4 #2176
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8835
	slli %a3 %a1 2 #2178
	add %a12 %a0 %a3 #2178
	lw %a3 %a12 0 #2178
	sw %a0 %sp 0 #2178
	sw %a11 %sp 4 #2178
	sw %a1 %sp 8 #2178
	add %a0 %a3 %zero
	add %a11 %a2 %zero
	sw %ra %sp 12 #2178 call cls
	lw %a10 %a11 0 #2178
	addi %sp %sp 16 #2178	
	jalr %ra %a10 0 #2178
	addi %sp %sp -16 #2178
	lw %ra %sp 12 #2178
	lw %a0 %sp 8 #2179
	addi %a1 %a0 -1 #2179
	lw %a0 %sp 0 #2179
	lw %a11 %sp 4 #2179
	lw %a10 %a11 0 #2179
	jalr %zero %a10 0 #2179
bge_else.8835:
	jalr %zero %ra 0 #2180
init_vecset_constants.2698:
	lw %a1 %a11 8 #2183
	lw %a2 %a11 4 #2183
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8837
	slli %a3 %a0 2 #80
	add %a12 %a2 %a3 #80
	lw %a2 %a12 0 #80
	addi %a3 %zero 119 #2185
	sw %a11 %sp 0 #2185
	sw %a0 %sp 4 #2185
	add %a0 %a2 %zero
	add %a11 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 12 #2185 call cls
	lw %a10 %a11 0 #2185
	addi %sp %sp 16 #2185	
	jalr %ra %a10 0 #2185
	addi %sp %sp -16 #2185
	lw %ra %sp 12 #2185
	lw %a0 %sp 4 #2186
	addi %a0 %a0 -1 #2186
	lw %a11 %sp 0 #2186
	lw %a10 %a11 0 #2186
	jalr %zero %a10 0 #2186
bge_else.8837:
	jalr %zero %ra 0 #2187
init_dirvecs.2700:
	lw %a0 %a11 12 #2190
	lw %a1 %a11 8 #2190
	lw %a2 %a11 4 #2190
	addi %a3 %zero 4 #2191
	sw %a0 %sp 0 #2191
	sw %a2 %sp 4 #2191
	add %a0 %a3 %zero
	add %a11 %a1 %zero
	sw %ra %sp 12 #2191 call cls
	lw %a10 %a11 0 #2191
	addi %sp %sp 16 #2191	
	jalr %ra %a10 0 #2191
	addi %sp %sp -16 #2191
	lw %ra %sp 12 #2191
	addi %a0 %zero 9 #2192
	addi %a1 %zero 0 #2192
	addi %a2 %zero 0 #2192
	lw %a11 %sp 4 #2192
	sw %ra %sp 12 #2192 call cls
	lw %a10 %a11 0 #2192
	addi %sp %sp 16 #2192	
	jalr %ra %a10 0 #2192
	addi %sp %sp -16 #2192
	lw %ra %sp 12 #2192
	addi %a0 %zero 4 #2193
	lw %a11 %sp 0 #2193
	lw %a10 %a11 0 #2193
	jalr %zero %a10 0 #2193
add_reflection.2702:
	lw %a2 %a11 12 #2199
	lw %a3 %a11 8 #2199
	lw %a11 %a11 4 #2199
	sw %a3 %sp 0 #2200
	sw %a0 %sp 4 #2200
	sw %a1 %sp 8 #2200
	sw %f0 %sp 16 #2200
	sw %a2 %sp 24 #2200
	sw %f3 %sp 32 #2200
	sw %f2 %sp 40 #2200
	sw %f1 %sp 48 #2200
	sw %ra %sp 60 #2200 call cls
	lw %a10 %a11 0 #2200
	addi %sp %sp 64 #2200	
	jalr %ra %a10 0 #2200
	addi %sp %sp -64 #2200
	lw %ra %sp 60 #2200
	sw %a0 %sp 56 #2201
	sw %ra %sp 60 #2201 call dir
	addi %sp %sp 64 #2201	
	jal %ra d_vec.2351 #2201
	addi %sp %sp -64 #2201
	lw %ra %sp 60 #2201
	lw %f0 %sp 48 #2201
	lw %f1 %sp 40 #2201
	lw %f2 %sp 32 #2201
	sw %ra %sp 60 #2201 call dir
	addi %sp %sp 64 #2201	
	jal %ra vecset.2244 #2201
	addi %sp %sp -64 #2201
	lw %ra %sp 60 #2201
	lw %a0 %sp 56 #2202
	lw %a11 %sp 24 #2202
	sw %ra %sp 60 #2202 call cls
	lw %a10 %a11 0 #2202
	addi %sp %sp 64 #2202	
	jalr %ra %a10 0 #2202
	addi %sp %sp -64 #2202
	lw %ra %sp 60 #2202
	addi %a0 %min_caml_hp 0 #2204
	addi %min_caml_hp %min_caml_hp 16 #2204
	lw %f0 %sp 16 #2204
	sw %f0 %a0 8 #2204
	lw %a1 %sp 56 #2204
	sw %a1 %a0 4 #2204
	lw %a1 %sp 8 #2204
	sw %a1 %a0 0 #2204
	lw %a1 %sp 4 #2204
	slli %a1 %a1 2 #2204
	lw %a2 %sp 0 #2204
	add %a12 %a2 %a1 #2204
	sw %a0 %a12 0 #2204
	jalr %zero %ra 0 #2204
setup_rect_reflection.2709:
	lw %a2 %a11 12 #2208
	lw %a3 %a11 8 #2208
	lw %a4 %a11 4 #2208
	addi %a5 %zero 4 #2209
	sw %a4 %sp 0 #2209
	sw %a3 %sp 4 #2209
	sw %a1 %sp 8 #2209
	sw %a2 %sp 12 #2209
	add %a1 %a5 %zero
	sw %ra %sp 20 #2209 call dir
	addi %sp %sp 24 #2209	
	jal %ra min_caml_sll #2209
	addi %sp %sp -24 #2209
	lw %ra %sp 20 #2209
	lw %a1 %sp 12 #98
	lw %a2 %a1 0 #98
	li %f0 l.5555 #2212
	lw %a3 %sp 8 #2212
	sw %a2 %sp 16 #2212
	sw %a0 %sp 20 #2212
	sw %f0 %sp 24 #2212
	add %a0 %a3 %zero
	sw %ra %sp 36 #2212 call dir
	addi %sp %sp 40 #2212	
	jal %ra o_diffuse.2314 #2212
	addi %sp %sp -40 #2212
	lw %ra %sp 36 #2212
	lw %f1 %sp 24 #2212
	fsub %f0 %f1 %f0 #2212
	lw %a0 %sp 4 #26
	lw %f1 %a0 0 #26
	sw %f0 %sp 32 #2213
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #2213 call dir
	addi %sp %sp 48 #2213	
	jal %ra min_caml_fneg #2213
	addi %sp %sp -48 #2213
	lw %ra %sp 44 #2213
	lw %a0 %sp 4 #26
	lw %f1 %a0 4 #26
	sw %f0 %sp 40 #2214
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #2214 call dir
	addi %sp %sp 56 #2214	
	jal %ra min_caml_fneg #2214
	addi %sp %sp -56 #2214
	lw %ra %sp 52 #2214
	lw %a0 %sp 4 #26
	lw %f1 %a0 8 #26
	sw %f0 %sp 48 #2215
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #2215 call dir
	addi %sp %sp 64 #2215	
	jal %ra min_caml_fneg #2215
	addi %sp %sp -64 #2215
	lw %ra %sp 60 #2215
	fadd %f3 %f0 %fzero #2215
	lw %a0 %sp 20 #2216
	addi %a1 %a0 1 #2216
	lw %a2 %sp 4 #26
	lw %f1 %a2 0 #26
	lw %f0 %sp 32 #2216
	lw %f2 %sp 48 #2216
	lw %a3 %sp 16 #2216
	lw %a11 %sp 0 #2216
	sw %f3 %sp 56 #2216
	add %a0 %a3 %zero
	sw %ra %sp 68 #2216 call cls
	lw %a10 %a11 0 #2216
	addi %sp %sp 72 #2216	
	jalr %ra %a10 0 #2216
	addi %sp %sp -72 #2216
	lw %ra %sp 68 #2216
	lw %a0 %sp 16 #2217
	addi %a1 %a0 1 #2217
	lw %a2 %sp 20 #2217
	addi %a3 %a2 2 #2217
	lw %a4 %sp 4 #26
	lw %f2 %a4 4 #26
	lw %f0 %sp 32 #2217
	lw %f1 %sp 40 #2217
	lw %f3 %sp 56 #2217
	lw %a11 %sp 0 #2217
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 68 #2217 call cls
	lw %a10 %a11 0 #2217
	addi %sp %sp 72 #2217	
	jalr %ra %a10 0 #2217
	addi %sp %sp -72 #2217
	lw %ra %sp 68 #2217
	lw %a0 %sp 16 #2218
	addi %a1 %a0 2 #2218
	lw %a2 %sp 20 #2218
	addi %a2 %a2 3 #2218
	lw %a3 %sp 4 #26
	lw %f3 %a3 8 #26
	lw %f0 %sp 32 #2218
	lw %f1 %sp 40 #2218
	lw %f2 %sp 48 #2218
	lw %a11 %sp 0 #2218
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 68 #2218 call cls
	lw %a10 %a11 0 #2218
	addi %sp %sp 72 #2218	
	jalr %ra %a10 0 #2218
	addi %sp %sp -72 #2218
	lw %ra %sp 68 #2218
	lw %a0 %sp 16 #2219
	addi %a0 %a0 3 #2219
	lw %a1 %sp 12 #2219
	sw %a0 %a1 0 #2219
	jalr %zero %ra 0 #2219
setup_surface_reflection.2712:
	lw %a2 %a11 12 #2223
	lw %a3 %a11 8 #2223
	lw %a4 %a11 4 #2223
	add %a5 %a0 %a0 #2224
	add %a5 %a5 %a0 #2224
	add %a0 %a5 %a0 #2224
	addi %a0 %a0 1 #2224
	lw %a5 %a2 0 #98
	li %f0 l.5555 #2226
	sw %a2 %sp 0 #2226
	sw %a0 %sp 4 #2226
	sw %a5 %sp 8 #2226
	sw %a4 %sp 12 #2226
	sw %a3 %sp 16 #2226
	sw %a1 %sp 20 #2226
	sw %f0 %sp 24 #2226
	add %a0 %a1 %zero
	sw %ra %sp 36 #2226 call dir
	addi %sp %sp 40 #2226	
	jal %ra o_diffuse.2314 #2226
	addi %sp %sp -40 #2226
	lw %ra %sp 36 #2226
	lw %f1 %sp 24 #2226
	fsub %f0 %f1 %f0 #2226
	lw %a0 %sp 20 #2227
	sw %f0 %sp 32 #2227
	sw %ra %sp 44 #2227 call dir
	addi %sp %sp 48 #2227	
	jal %ra o_param_abc.2306 #2227
	addi %sp %sp -48 #2227
	lw %ra %sp 44 #2227
	add %a1 %a0 %zero #2227
	lw %a0 %sp 16 #2227
	sw %ra %sp 44 #2227 call dir
	addi %sp %sp 48 #2227	
	jal %ra veciprod.2265 #2227
	addi %sp %sp -48 #2227
	lw %ra %sp 44 #2227
	li %f1 l.5715 #2230
	lw %a0 %sp 20 #2230
	sw %f0 %sp 40 #2230
	sw %f1 %sp 48 #2230
	sw %ra %sp 60 #2230 call dir
	addi %sp %sp 64 #2230	
	jal %ra o_param_a.2300 #2230
	addi %sp %sp -64 #2230
	lw %ra %sp 60 #2230
	lw %f1 %sp 48 #2230
	fmul %f0 %f1 %f0 #2230
	lw %f1 %sp 40 #2230
	fmul %f0 %f0 %f1 #2230
	lw %a0 %sp 16 #26
	lw %f2 %a0 0 #26
	fsub %f0 %f0 %f2 #2230
	li %f2 l.5715 #2231
	lw %a1 %sp 20 #2231
	sw %f0 %sp 56 #2231
	sw %f2 %sp 64 #2231
	add %a0 %a1 %zero
	sw %ra %sp 76 #2231 call dir
	addi %sp %sp 80 #2231	
	jal %ra o_param_b.2302 #2231
	addi %sp %sp -80 #2231
	lw %ra %sp 76 #2231
	lw %f1 %sp 64 #2231
	fmul %f0 %f1 %f0 #2231
	lw %f1 %sp 40 #2231
	fmul %f0 %f0 %f1 #2231
	lw %a0 %sp 16 #26
	lw %f2 %a0 4 #26
	fsub %f0 %f0 %f2 #2231
	li %f2 l.5715 #2232
	lw %a1 %sp 20 #2232
	sw %f0 %sp 72 #2232
	sw %f2 %sp 80 #2232
	add %a0 %a1 %zero
	sw %ra %sp 92 #2232 call dir
	addi %sp %sp 96 #2232	
	jal %ra o_param_c.2304 #2232
	addi %sp %sp -96 #2232
	lw %ra %sp 92 #2232
	lw %f1 %sp 80 #2232
	fmul %f0 %f1 %f0 #2232
	lw %f1 %sp 40 #2232
	fmul %f0 %f0 %f1 #2232
	lw %a0 %sp 16 #26
	lw %f1 %a0 8 #26
	fsub %f3 %f0 %f1 #2232
	lw %f0 %sp 32 #2229
	lw %f1 %sp 56 #2229
	lw %f2 %sp 72 #2229
	lw %a0 %sp 8 #2229
	lw %a1 %sp 4 #2229
	lw %a11 %sp 12 #2229
	sw %ra %sp 92 #2229 call cls
	lw %a10 %a11 0 #2229
	addi %sp %sp 96 #2229	
	jalr %ra %a10 0 #2229
	addi %sp %sp -96 #2229
	lw %ra %sp 92 #2229
	lw %a0 %sp 8 #2233
	addi %a0 %a0 1 #2233
	lw %a1 %sp 0 #2233
	sw %a0 %a1 0 #2233
	jalr %zero %ra 0 #2233
setup_reflections.2715:
	lw %a1 %a11 12 #2238
	lw %a2 %a11 8 #2238
	lw %a3 %a11 4 #2238
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8844
	slli %a4 %a0 2 #19
	add %a12 %a3 %a4 #19
	lw %a3 %a12 0 #19
	sw %a1 %sp 0 #2241
	sw %a0 %sp 4 #2241
	sw %a2 %sp 8 #2241
	sw %a3 %sp 12 #2241
	add %a0 %a3 %zero
	sw %ra %sp 20 #2241 call dir
	addi %sp %sp 24 #2241	
	jal %ra o_reflectiontype.2294 #2241
	addi %sp %sp -24 #2241
	lw %ra %sp 20 #2241
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8845
	lw %a0 %sp 12 #2242
	sw %ra %sp 20 #2242 call dir
	addi %sp %sp 24 #2242	
	jal %ra o_diffuse.2314 #2242
	addi %sp %sp -24 #2242
	lw %ra %sp 20 #2242
	li %f1 l.5555 #2242
	sw %ra %sp 20 #2242 call dir
	addi %sp %sp 24 #2242	
	jal %ra min_caml_fless #2242
	addi %sp %sp -24 #2242
	lw %ra %sp 20 #2242
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8846
	jalr %zero %ra 0 #2250
beq_else.8846:
	lw %a0 %sp 12 #2243
	sw %ra %sp 20 #2243 call dir
	addi %sp %sp 24 #2243	
	jal %ra o_form.2292 #2243
	addi %sp %sp -24 #2243
	lw %ra %sp 20 #2243
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8848
	lw %a0 %sp 4 #2246
	lw %a1 %sp 12 #2246
	lw %a11 %sp 8 #2246
	lw %a10 %a11 0 #2246
	jalr %zero %a10 0 #2246
beq_else.8848:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8849
	lw %a0 %sp 4 #2248
	lw %a1 %sp 12 #2248
	lw %a11 %sp 0 #2248
	lw %a10 %a11 0 #2248
	jalr %zero %a10 0 #2248
beq_else.8849:
	jalr %zero %ra 0 #2249
beq_else.8845:
	jalr %zero %ra 0 #2251
bge_else.8844:
	jalr %zero %ra 0 #2252
rt.2717:
	lw %a2 %a11 56 #2258
	lw %a3 %a11 52 #2258
	lw %a4 %a11 48 #2258
	lw %a5 %a11 44 #2258
	lw %a6 %a11 40 #2258
	lw %a7 %a11 36 #2258
	lw %a8 %a11 32 #2258
	lw %a9 %a11 28 #2258
	lw %a10 %a11 24 #2258
	sw %a6 %sp 0 #2258
	lw %a6 %a11 20 #2258
	sw %a8 %sp 4 #2258
	lw %a8 %a11 16 #2258
	sw %a3 %sp 8 #2258
	lw %a3 %a11 12 #2258
	sw %a9 %sp 12 #2258
	lw %a9 %a11 8 #2258
	lw %a11 %a11 4 #2258
	sw %a0 %a3 0 #2260
	sw %a1 %a3 4 #2261
	addi %a3 %zero 2 #2262
	sw %a4 %sp 16 #2262
	sw %a6 %sp 20 #2262
	sw %a10 %sp 24 #2262
	sw %a8 %sp 28 #2262
	sw %a2 %sp 32 #2262
	sw %a7 %sp 36 #2262
	sw %a11 %sp 40 #2262
	sw %a5 %sp 44 #2262
	sw %a0 %sp 48 #2262
	sw %a1 %sp 52 #2262
	sw %a9 %sp 56 #2262
	add %a1 %a3 %zero
	sw %ra %sp 60 #2262 call dir
	addi %sp %sp 64 #2262	
	jal %ra min_caml_srl #2262
	addi %sp %sp -64 #2262
	lw %ra %sp 60 #2262
	lw %a1 %sp 56 #2262
	sw %a0 %a1 0 #2262
	addi %a0 %zero 2 #2263
	lw %a2 %sp 52 #2263
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 60 #2263 call dir
	addi %sp %sp 64 #2263	
	jal %ra min_caml_srl #2263
	addi %sp %sp -64 #2263
	lw %ra %sp 60 #2263
	lw %a1 %sp 56 #2263
	sw %a0 %a1 4 #2263
	li %f0 l.6291 #2264
	lw %a0 %sp 48 #2264
	sw %f0 %sp 64 #2264
	sw %ra %sp 76 #2264 call dir
	addi %sp %sp 80 #2264	
	jal %ra min_caml_float_of_int #2264
	addi %sp %sp -80 #2264
	lw %ra %sp 76 #2264
	lw %f1 %sp 64 #2264
	fdiv %f0 %f1 %f0 #2264
	lw %a0 %sp 44 #2264
	sw %f0 %a0 0 #2264
	lw %a11 %sp 40 #2265
	sw %ra %sp 76 #2265 call cls
	lw %a10 %a11 0 #2265
	addi %sp %sp 80 #2265	
	jalr %ra %a10 0 #2265
	addi %sp %sp -80 #2265
	lw %ra %sp 76 #2265
	lw %a11 %sp 40 #2266
	sw %a0 %sp 72 #2266
	sw %ra %sp 76 #2266 call cls
	lw %a10 %a11 0 #2266
	addi %sp %sp 80 #2266	
	jalr %ra %a10 0 #2266
	addi %sp %sp -80 #2266
	lw %ra %sp 76 #2266
	lw %a11 %sp 40 #2267
	sw %a0 %sp 76 #2267
	sw %ra %sp 84 #2267 call cls
	lw %a10 %a11 0 #2267
	addi %sp %sp 88 #2267	
	jalr %ra %a10 0 #2267
	addi %sp %sp -88 #2267
	lw %ra %sp 84 #2267
	lw %a11 %sp 36 #2268
	sw %a0 %sp 80 #2268
	sw %ra %sp 84 #2268 call cls
	lw %a10 %a11 0 #2268
	addi %sp %sp 88 #2268	
	jalr %ra %a10 0 #2268
	addi %sp %sp -88 #2268
	lw %ra %sp 84 #2268
	lw %a11 %sp 32 #2269
	sw %ra %sp 84 #2269 call cls
	lw %a10 %a11 0 #2269
	addi %sp %sp 88 #2269	
	jalr %ra %a10 0 #2269
	addi %sp %sp -88 #2269
	lw %ra %sp 84 #2269
	lw %a11 %sp 28 #2270
	sw %ra %sp 84 #2270 call cls
	lw %a10 %a11 0 #2270
	addi %sp %sp 88 #2270	
	jalr %ra %a10 0 #2270
	addi %sp %sp -88 #2270
	lw %ra %sp 84 #2270
	lw %a0 %sp 24 #2271
	sw %ra %sp 84 #2271 call dir
	addi %sp %sp 88 #2271	
	jal %ra d_vec.2351 #2271
	addi %sp %sp -88 #2271
	lw %ra %sp 84 #2271
	lw %a1 %sp 20 #2271
	sw %ra %sp 84 #2271 call dir
	addi %sp %sp 88 #2271	
	jal %ra veccpy.2254 #2271
	addi %sp %sp -88 #2271
	lw %ra %sp 84 #2271
	lw %a0 %sp 24 #2272
	lw %a11 %sp 16 #2272
	sw %ra %sp 84 #2272 call cls
	lw %a10 %a11 0 #2272
	addi %sp %sp 88 #2272	
	jalr %ra %a10 0 #2272
	addi %sp %sp -88 #2272
	lw %ra %sp 84 #2272
	lw %a0 %sp 12 #14
	lw %a0 %a0 0 #14
	addi %a0 %a0 -1 #2273
	lw %a11 %sp 8 #2273
	sw %ra %sp 84 #2273 call cls
	lw %a10 %a11 0 #2273
	addi %sp %sp 88 #2273	
	jalr %ra %a10 0 #2273
	addi %sp %sp -88 #2273
	lw %ra %sp 84 #2273
	addi %a1 %zero 0 #2274
	addi %a2 %zero 0 #2274
	lw %a0 %sp 76 #2274
	lw %a11 %sp 4 #2274
	sw %ra %sp 84 #2274 call cls
	lw %a10 %a11 0 #2274
	addi %sp %sp 88 #2274	
	jalr %ra %a10 0 #2274
	addi %sp %sp -88 #2274
	lw %ra %sp 84 #2274
	addi %a0 %zero 0 #2275
	addi %a4 %zero 2 #2275
	lw %a1 %sp 72 #2275
	lw %a2 %sp 76 #2275
	lw %a3 %sp 80 #2275
	lw %a11 %sp 0 #2275
	lw %a10 %a11 0 #2275
	jalr %zero %a10 0 #2275
min_caml_start:
	li %sp 44000
	li %in 200000
	li %out 300000
	li %min_caml_hp 10000000
	addi %a0 %zero 1 #14
	addi %a1 %zero 0 #14
	sw %ra %sp 4 #14 call dir
	addi %sp %sp 8 #14	
	jal %ra min_caml_create_array #14
	addi %sp %sp -8 #14
	lw %ra %sp 4 #14
	addi %a1 %zero 0 #18
	li %f0 l.5553 #18
	sw %a0 %sp 0 #18
	add %a0 %a1 %zero
	sw %ra %sp 4 #18 call dir
	addi %sp %sp 8 #18	
	jal %ra min_caml_create_float_array #18
	addi %sp %sp -8 #18
	lw %ra %sp 4 #18
	addi %a1 %zero 60 #19
	addi %a2 %zero 0 #19
	addi %a3 %zero 0 #19
	addi %a4 %zero 0 #19
	addi %a5 %zero 0 #19
	addi %a6 %zero 0 #19
	addi %a7 %min_caml_hp 0 #19
	addi %min_caml_hp %min_caml_hp 48 #19
	sw %a0 %a7 40 #19
	sw %a0 %a7 36 #19
	sw %a0 %a7 32 #19
	sw %a0 %a7 28 #19
	sw %a6 %a7 24 #19
	sw %a0 %a7 20 #19
	sw %a0 %a7 16 #19
	sw %a5 %a7 12 #19
	sw %a4 %a7 8 #19
	sw %a3 %a7 4 #19
	sw %a2 %a7 0 #19
	addi %a0 %a7 0 #19
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 4 #19 call dir
	addi %sp %sp 8 #19	
	jal %ra min_caml_create_array #19
	addi %sp %sp -8 #19
	lw %ra %sp 4 #19
	addi %a1 %zero 3 #22
	li %f0 l.5553 #22
	sw %a0 %sp 4 #22
	add %a0 %a1 %zero
	sw %ra %sp 12 #22 call dir
	addi %sp %sp 16 #22	
	jal %ra min_caml_create_float_array #22
	addi %sp %sp -16 #22
	lw %ra %sp 12 #22
	addi %a1 %zero 3 #24
	li %f0 l.5553 #24
	sw %a0 %sp 8 #24
	add %a0 %a1 %zero
	sw %ra %sp 12 #24 call dir
	addi %sp %sp 16 #24	
	jal %ra min_caml_create_float_array #24
	addi %sp %sp -16 #24
	lw %ra %sp 12 #24
	addi %a1 %zero 3 #26
	li %f0 l.5553 #26
	sw %a0 %sp 12 #26
	add %a0 %a1 %zero
	sw %ra %sp 20 #26 call dir
	addi %sp %sp 24 #26	
	jal %ra min_caml_create_float_array #26
	addi %sp %sp -24 #26
	lw %ra %sp 20 #26
	addi %a1 %zero 1 #28
	li %f0 l.6046 #28
	sw %a0 %sp 16 #28
	add %a0 %a1 %zero
	sw %ra %sp 20 #28 call dir
	addi %sp %sp 24 #28	
	jal %ra min_caml_create_float_array #28
	addi %sp %sp -24 #28
	lw %ra %sp 20 #28
	addi %a1 %zero 50 #30
	addi %a2 %zero 1 #30
	sub %a3 %zero %a2 #30
	sw %a0 %sp 20 #30
	sw %a1 %sp 24 #30
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #30 call dir
	addi %sp %sp 32 #30	
	jal %ra min_caml_create_array #30
	addi %sp %sp -32 #30
	lw %ra %sp 28 #30
	add %a1 %a0 %zero #30
	lw %a0 %sp 24 #30
	sw %ra %sp 28 #30 call dir
	addi %sp %sp 32 #30	
	jal %ra min_caml_create_array #30
	addi %sp %sp -32 #30
	lw %ra %sp 28 #30
	addi %a1 %zero 1 #32
	lw %a2 %a0 0 #30
	sw %a0 %sp 28 #32
	sw %a1 %sp 32 #32
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 36 #32 call dir
	addi %sp %sp 40 #32	
	jal %ra min_caml_create_array #32
	addi %sp %sp -40 #32
	lw %ra %sp 36 #32
	add %a1 %a0 %zero #32
	lw %a0 %sp 32 #32
	sw %ra %sp 36 #32 call dir
	addi %sp %sp 40 #32	
	jal %ra min_caml_create_array #32
	addi %sp %sp -40 #32
	lw %ra %sp 36 #32
	addi %a1 %zero 1 #36
	li %f0 l.5553 #36
	sw %a0 %sp 36 #36
	add %a0 %a1 %zero
	sw %ra %sp 44 #36 call dir
	addi %sp %sp 48 #36	
	jal %ra min_caml_create_float_array #36
	addi %sp %sp -48 #36
	lw %ra %sp 44 #36
	addi %a1 %zero 1 #38
	addi %a2 %zero 0 #38
	sw %a0 %sp 40 #38
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 44 #38 call dir
	addi %sp %sp 48 #38	
	jal %ra min_caml_create_array #38
	addi %sp %sp -48 #38
	lw %ra %sp 44 #38
	addi %a1 %zero 1 #40
	li %f0 l.5972 #40
	sw %a0 %sp 44 #40
	add %a0 %a1 %zero
	sw %ra %sp 52 #40 call dir
	addi %sp %sp 56 #40	
	jal %ra min_caml_create_float_array #40
	addi %sp %sp -56 #40
	lw %ra %sp 52 #40
	addi %a1 %zero 3 #42
	li %f0 l.5553 #42
	sw %a0 %sp 48 #42
	add %a0 %a1 %zero
	sw %ra %sp 52 #42 call dir
	addi %sp %sp 56 #42	
	jal %ra min_caml_create_float_array #42
	addi %sp %sp -56 #42
	lw %ra %sp 52 #42
	addi %a1 %zero 1 #44
	addi %a2 %zero 0 #44
	sw %a0 %sp 52 #44
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 60 #44 call dir
	addi %sp %sp 64 #44	
	jal %ra min_caml_create_array #44
	addi %sp %sp -64 #44
	lw %ra %sp 60 #44
	addi %a1 %zero 3 #46
	li %f0 l.5553 #46
	sw %a0 %sp 56 #46
	add %a0 %a1 %zero
	sw %ra %sp 60 #46 call dir
	addi %sp %sp 64 #46	
	jal %ra min_caml_create_float_array #46
	addi %sp %sp -64 #46
	lw %ra %sp 60 #46
	addi %a1 %zero 3 #48
	li %f0 l.5553 #48
	sw %a0 %sp 60 #48
	add %a0 %a1 %zero
	sw %ra %sp 68 #48 call dir
	addi %sp %sp 72 #48	
	jal %ra min_caml_create_float_array #48
	addi %sp %sp -72 #48
	lw %ra %sp 68 #48
	addi %a1 %zero 3 #51
	li %f0 l.5553 #51
	sw %a0 %sp 64 #51
	add %a0 %a1 %zero
	sw %ra %sp 68 #51 call dir
	addi %sp %sp 72 #51	
	jal %ra min_caml_create_float_array #51
	addi %sp %sp -72 #51
	lw %ra %sp 68 #51
	addi %a1 %zero 3 #53
	li %f0 l.5553 #53
	sw %a0 %sp 68 #53
	add %a0 %a1 %zero
	sw %ra %sp 76 #53 call dir
	addi %sp %sp 80 #53	
	jal %ra min_caml_create_float_array #53
	addi %sp %sp -80 #53
	lw %ra %sp 76 #53
	addi %a1 %zero 2 #56
	addi %a2 %zero 0 #56
	sw %a0 %sp 72 #56
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 76 #56 call dir
	addi %sp %sp 80 #56	
	jal %ra min_caml_create_array #56
	addi %sp %sp -80 #56
	lw %ra %sp 76 #56
	addi %a1 %zero 2 #58
	addi %a2 %zero 0 #58
	sw %a0 %sp 76 #58
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 84 #58 call dir
	addi %sp %sp 88 #58	
	jal %ra min_caml_create_array #58
	addi %sp %sp -88 #58
	lw %ra %sp 84 #58
	addi %a1 %zero 1 #60
	li %f0 l.5553 #60
	sw %a0 %sp 80 #60
	add %a0 %a1 %zero
	sw %ra %sp 84 #60 call dir
	addi %sp %sp 88 #60	
	jal %ra min_caml_create_float_array #60
	addi %sp %sp -88 #60
	lw %ra %sp 84 #60
	addi %a1 %zero 3 #63
	li %f0 l.5553 #63
	sw %a0 %sp 84 #63
	add %a0 %a1 %zero
	sw %ra %sp 92 #63 call dir
	addi %sp %sp 96 #63	
	jal %ra min_caml_create_float_array #63
	addi %sp %sp -96 #63
	lw %ra %sp 92 #63
	addi %a1 %zero 3 #65
	li %f0 l.5553 #65
	sw %a0 %sp 88 #65
	add %a0 %a1 %zero
	sw %ra %sp 92 #65 call dir
	addi %sp %sp 96 #65	
	jal %ra min_caml_create_float_array #65
	addi %sp %sp -96 #65
	lw %ra %sp 92 #65
	addi %a1 %zero 3 #68
	li %f0 l.5553 #68
	sw %a0 %sp 92 #68
	add %a0 %a1 %zero
	sw %ra %sp 100 #68 call dir
	addi %sp %sp 104 #68	
	jal %ra min_caml_create_float_array #68
	addi %sp %sp -104 #68
	lw %ra %sp 100 #68
	addi %a1 %zero 3 #69
	li %f0 l.5553 #69
	sw %a0 %sp 96 #69
	add %a0 %a1 %zero
	sw %ra %sp 100 #69 call dir
	addi %sp %sp 104 #69	
	jal %ra min_caml_create_float_array #69
	addi %sp %sp -104 #69
	lw %ra %sp 100 #69
	addi %a1 %zero 3 #70
	li %f0 l.5553 #70
	sw %a0 %sp 100 #70
	add %a0 %a1 %zero
	sw %ra %sp 108 #70 call dir
	addi %sp %sp 112 #70	
	jal %ra min_caml_create_float_array #70
	addi %sp %sp -112 #70
	lw %ra %sp 108 #70
	addi %a1 %zero 3 #73
	li %f0 l.5553 #73
	sw %a0 %sp 104 #73
	add %a0 %a1 %zero
	sw %ra %sp 108 #73 call dir
	addi %sp %sp 112 #73	
	jal %ra min_caml_create_float_array #73
	addi %sp %sp -112 #73
	lw %ra %sp 108 #73
	addi %a1 %zero 0 #77
	li %f0 l.5553 #77
	sw %a0 %sp 108 #77
	add %a0 %a1 %zero
	sw %ra %sp 116 #77 call dir
	addi %sp %sp 120 #77	
	jal %ra min_caml_create_float_array #77
	addi %sp %sp -120 #77
	lw %ra %sp 116 #77
	add %a1 %a0 %zero #77
	addi %a0 %zero 0 #78
	sw %a1 %sp 112 #78
	sw %ra %sp 116 #78 call dir
	addi %sp %sp 120 #78	
	jal %ra min_caml_create_array #78
	addi %sp %sp -120 #78
	lw %ra %sp 116 #78
	addi %a1 %zero 0 #79
	addi %a2 %min_caml_hp 0 #79
	addi %min_caml_hp %min_caml_hp 8 #79
	sw %a0 %a2 4 #79
	lw %a0 %sp 112 #79
	sw %a0 %a2 0 #79
	addi %a0 %a2 0 #79
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 116 #79 call dir
	addi %sp %sp 120 #79	
	jal %ra min_caml_create_array #79
	addi %sp %sp -120 #79
	lw %ra %sp 116 #79
	add %a1 %a0 %zero #79
	addi %a0 %zero 5 #80
	sw %ra %sp 116 #80 call dir
	addi %sp %sp 120 #80	
	jal %ra min_caml_create_array #80
	addi %sp %sp -120 #80
	lw %ra %sp 116 #80
	addi %a1 %zero 0 #84
	li %f0 l.5553 #84
	sw %a0 %sp 116 #84
	add %a0 %a1 %zero
	sw %ra %sp 124 #84 call dir
	addi %sp %sp 128 #84	
	jal %ra min_caml_create_float_array #84
	addi %sp %sp -128 #84
	lw %ra %sp 124 #84
	addi %a1 %zero 3 #85
	li %f0 l.5553 #85
	sw %a0 %sp 120 #85
	add %a0 %a1 %zero
	sw %ra %sp 124 #85 call dir
	addi %sp %sp 128 #85	
	jal %ra min_caml_create_float_array #85
	addi %sp %sp -128 #85
	lw %ra %sp 124 #85
	addi %a1 %zero 60 #86
	lw %a2 %sp 120 #86
	sw %a0 %sp 124 #86
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 132 #86 call dir
	addi %sp %sp 136 #86	
	jal %ra min_caml_create_array #86
	addi %sp %sp -136 #86
	lw %ra %sp 132 #86
	addi %a1 %min_caml_hp 0 #87
	addi %min_caml_hp %min_caml_hp 8 #87
	sw %a0 %a1 4 #87
	lw %a0 %sp 124 #87
	sw %a0 %a1 0 #87
	addi %a0 %a1 0 #87
	addi %a1 %zero 0 #91
	li %f0 l.5553 #91
	sw %a0 %sp 128 #91
	add %a0 %a1 %zero
	sw %ra %sp 132 #91 call dir
	addi %sp %sp 136 #91	
	jal %ra min_caml_create_float_array #91
	addi %sp %sp -136 #91
	lw %ra %sp 132 #91
	add %a1 %a0 %zero #91
	addi %a0 %zero 0 #92
	sw %a1 %sp 132 #92
	sw %ra %sp 140 #92 call dir
	addi %sp %sp 144 #92	
	jal %ra min_caml_create_array #92
	addi %sp %sp -144 #92
	lw %ra %sp 140 #92
	addi %a1 %min_caml_hp 0 #93
	addi %min_caml_hp %min_caml_hp 8 #93
	sw %a0 %a1 4 #93
	lw %a0 %sp 132 #93
	sw %a0 %a1 0 #93
	addi %a0 %a1 0 #93
	addi %a1 %zero 180 #94
	addi %a2 %zero 0 #94
	li %f0 l.5553 #94
	addi %a3 %min_caml_hp 0 #94
	addi %min_caml_hp %min_caml_hp 16 #94
	sw %f0 %a3 8 #94
	sw %a0 %a3 4 #94
	sw %a2 %a3 0 #94
	addi %a0 %a3 0 #94
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 140 #94 call dir
	addi %sp %sp 144 #94	
	jal %ra min_caml_create_array #94
	addi %sp %sp -144 #94
	lw %ra %sp 140 #94
	addi %a1 %zero 1 #98
	addi %a2 %zero 0 #98
	sw %a0 %sp 136 #98
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 140 #98 call dir
	addi %sp %sp 144 #98	
	jal %ra min_caml_create_array #98
	addi %sp %sp -144 #98
	lw %ra %sp 140 #98
	addi %a1 %min_caml_hp 0 #541
	addi %min_caml_hp %min_caml_hp 24 #541
	li %a2 read_screen_settings.2363 #541
	sw %a2 %a1 0 #541
	lw %a2 %sp 12 #541
	sw %a2 %a1 20 #541
	lw %a3 %sp 104 #541
	sw %a3 %a1 16 #541
	lw %a4 %sp 100 #541
	sw %a4 %a1 12 #541
	lw %a5 %sp 96 #541
	sw %a5 %a1 8 #541
	lw %a6 %sp 8 #541
	sw %a6 %a1 4 #541
	addi %a6 %min_caml_hp 0 #574
	addi %min_caml_hp %min_caml_hp 16 #574
	li %a7 read_light.2365 #574
	sw %a7 %a6 0 #574
	lw %a7 %sp 16 #574
	sw %a7 %a6 8 #574
	lw %a8 %sp 20 #574
	sw %a8 %a6 4 #574
	addi %a9 %min_caml_hp 0 #637
	addi %min_caml_hp %min_caml_hp 8 #637
	li %a10 read_nth_object.2370 #637
	sw %a10 %a9 0 #637
	lw %a10 %sp 4 #637
	sw %a10 %a9 4 #637
	addi %a11 %min_caml_hp 0 #720
	addi %min_caml_hp %min_caml_hp 16 #720
	li %a4 read_object.2372 #720
	sw %a4 %a11 0 #720
	sw %a9 %a11 8 #720
	lw %a4 %sp 0 #720
	sw %a4 %a11 4 #720
	addi %a9 %min_caml_hp 0 #729
	addi %min_caml_hp %min_caml_hp 8 #729
	li %a3 read_all_object.2374 #729
	sw %a3 %a9 0 #729
	sw %a11 %a9 4 #729
	addi %a3 %min_caml_hp 0 #753
	addi %min_caml_hp %min_caml_hp 8 #753
	li %a11 read_and_network.2380 #753
	sw %a11 %a3 0 #753
	lw %a11 %sp 28 #753
	sw %a11 %a3 4 #753
	addi %a5 %min_caml_hp 0 #762
	addi %min_caml_hp %min_caml_hp 24 #762
	li %a2 read_parameter.2382 #762
	sw %a2 %a5 0 #762
	sw %a1 %a5 20 #762
	sw %a6 %a5 16 #762
	sw %a3 %a5 12 #762
	sw %a9 %a5 8 #762
	lw %a1 %sp 36 #762
	sw %a1 %a5 4 #762
	addi %a2 %min_caml_hp 0 #778
	addi %min_caml_hp %min_caml_hp 8 #778
	li %a3 solver_rect_surface.2384 #778
	sw %a3 %a2 0 #778
	lw %a3 %sp 40 #778
	sw %a3 %a2 4 #778
	addi %a6 %min_caml_hp 0 #793
	addi %min_caml_hp %min_caml_hp 8 #793
	li %a9 solver_rect.2393 #793
	sw %a9 %a6 0 #793
	sw %a2 %a6 4 #793
	addi %a2 %min_caml_hp 0 #802
	addi %min_caml_hp %min_caml_hp 8 #802
	li %a9 solver_surface.2399 #802
	sw %a9 %a2 0 #802
	sw %a3 %a2 4 #802
	addi %a9 %min_caml_hp 0 #850
	addi %min_caml_hp %min_caml_hp 8 #850
	sw %a5 %sp 140 #850
	li %a5 solver_second.2418 #850
	sw %a5 %a9 0 #850
	sw %a3 %a9 4 #850
	addi %a5 %min_caml_hp 0 #879
	addi %min_caml_hp %min_caml_hp 24 #879
	li %a8 solver.2424 #879
	sw %a8 %a5 0 #879
	sw %a2 %a5 16 #879
	sw %a9 %a5 12 #879
	sw %a6 %a5 8 #879
	sw %a10 %a5 4 #879
	addi %a2 %min_caml_hp 0 #896
	addi %min_caml_hp %min_caml_hp 8 #896
	li %a6 solver_rect_fast.2428 #896
	sw %a6 %a2 0 #896
	sw %a3 %a2 4 #896
	addi %a6 %min_caml_hp 0 #929
	addi %min_caml_hp %min_caml_hp 8 #929
	li %a8 solver_surface_fast.2435 #929
	sw %a8 %a6 0 #929
	sw %a3 %a6 4 #929
	addi %a8 %min_caml_hp 0 #938
	addi %min_caml_hp %min_caml_hp 8 #938
	li %a9 solver_second_fast.2441 #938
	sw %a9 %a8 0 #938
	sw %a3 %a8 4 #938
	addi %a9 %min_caml_hp 0 #958
	addi %min_caml_hp %min_caml_hp 24 #958
	sw %a0 %sp 144 #958
	li %a0 solver_fast.2447 #958
	sw %a0 %a9 0 #958
	sw %a6 %a9 16 #958
	sw %a8 %a9 12 #958
	sw %a2 %a9 8 #958
	sw %a10 %a9 4 #958
	addi %a0 %min_caml_hp 0 #978
	addi %min_caml_hp %min_caml_hp 8 #978
	li %a6 solver_surface_fast2.2451 #978
	sw %a6 %a0 0 #978
	sw %a3 %a0 4 #978
	addi %a6 %min_caml_hp 0 #986
	addi %min_caml_hp %min_caml_hp 8 #986
	li %a8 solver_second_fast2.2458 #986
	sw %a8 %a6 0 #986
	sw %a3 %a6 4 #986
	addi %a8 %min_caml_hp 0 #1005
	addi %min_caml_hp %min_caml_hp 24 #1005
	li %a1 solver_fast2.2465 #1005
	sw %a1 %a8 0 #1005
	sw %a0 %a8 16 #1005
	sw %a6 %a8 12 #1005
	sw %a2 %a8 8 #1005
	sw %a10 %a8 4 #1005
	addi %a0 %min_caml_hp 0 #1099
	addi %min_caml_hp %min_caml_hp 8 #1099
	li %a1 iter_setup_dirvec_constants.2477 #1099
	sw %a1 %a0 0 #1099
	sw %a10 %a0 4 #1099
	addi %a1 %min_caml_hp 0 #1116
	addi %min_caml_hp %min_caml_hp 16 #1116
	li %a2 setup_dirvec_constants.2480 #1116
	sw %a2 %a1 0 #1116
	sw %a4 %a1 8 #1116
	sw %a0 %a1 4 #1116
	addi %a0 %min_caml_hp 0 #1122
	addi %min_caml_hp %min_caml_hp 8 #1122
	li %a2 setup_startp_constants.2482 #1122
	sw %a2 %a0 0 #1122
	sw %a10 %a0 4 #1122
	addi %a2 %min_caml_hp 0 #1141
	addi %min_caml_hp %min_caml_hp 16 #1141
	li %a6 setup_startp.2485 #1141
	sw %a6 %a2 0 #1141
	lw %a6 %sp 92 #1141
	sw %a6 %a2 12 #1141
	sw %a0 %a2 8 #1141
	sw %a4 %a2 4 #1141
	addi %a0 %min_caml_hp 0 #1189
	addi %min_caml_hp %min_caml_hp 8 #1189
	sw %a1 %sp 148 #1189
	li %a1 check_all_inside.2507 #1189
	sw %a1 %a0 0 #1189
	sw %a10 %a0 4 #1189
	addi %a1 %min_caml_hp 0 #1207
	addi %min_caml_hp %min_caml_hp 32 #1207
	li %a4 shadow_check_and_group.2513 #1207
	sw %a4 %a1 0 #1207
	sw %a9 %a1 28 #1207
	sw %a3 %a1 24 #1207
	sw %a10 %a1 20 #1207
	lw %a4 %sp 128 #1207
	sw %a4 %a1 16 #1207
	sw %a7 %a1 12 #1207
	lw %a7 %sp 52 #1207
	sw %a7 %a1 8 #1207
	sw %a0 %a1 4 #1207
	sw %a2 %sp 152 #1237
	addi %a2 %min_caml_hp 0 #1237
	addi %min_caml_hp %min_caml_hp 16 #1237
	sw %a8 %sp 156 #1237
	li %a8 shadow_check_one_or_group.2516 #1237
	sw %a8 %a2 0 #1237
	sw %a1 %a2 8 #1237
	sw %a11 %a2 4 #1237
	addi %a1 %min_caml_hp 0 #1252
	addi %min_caml_hp %min_caml_hp 24 #1252
	li %a8 shadow_check_one_or_matrix.2519 #1252
	sw %a8 %a1 0 #1252
	sw %a9 %a1 20 #1252
	sw %a3 %a1 16 #1252
	sw %a2 %a1 12 #1252
	sw %a4 %a1 8 #1252
	sw %a7 %a1 4 #1252
	addi %a2 %min_caml_hp 0 #1286
	addi %min_caml_hp %min_caml_hp 40 #1286
	li %a8 solve_each_element.2522 #1286
	sw %a8 %a2 0 #1286
	lw %a8 %sp 48 #1286
	sw %a8 %a2 36 #1286
	lw %a9 %sp 88 #1286
	sw %a9 %a2 32 #1286
	sw %a3 %a2 28 #1286
	sw %a5 %a2 24 #1286
	sw %a10 %a2 20 #1286
	lw %a4 %sp 44 #1286
	sw %a4 %a2 16 #1286
	sw %a7 %a2 12 #1286
	sw %a1 %sp 160 #1286
	lw %a1 %sp 56 #1286
	sw %a1 %a2 8 #1286
	sw %a0 %a2 4 #1286
	sw %a0 %sp 164 #1327
	addi %a0 %min_caml_hp 0 #1327
	addi %min_caml_hp %min_caml_hp 16 #1327
	li %a1 solve_one_or_network.2526 #1327
	sw %a1 %a0 0 #1327
	sw %a2 %a0 8 #1327
	sw %a11 %a0 4 #1327
	addi %a1 %min_caml_hp 0 #1336
	addi %min_caml_hp %min_caml_hp 24 #1336
	li %a2 trace_or_matrix.2530 #1336
	sw %a2 %a1 0 #1336
	sw %a8 %a1 20 #1336
	sw %a9 %a1 16 #1336
	sw %a3 %a1 12 #1336
	sw %a5 %a1 8 #1336
	sw %a0 %a1 4 #1336
	addi %a0 %min_caml_hp 0 #1363
	addi %min_caml_hp %min_caml_hp 16 #1363
	li %a2 judge_intersection.2534 #1363
	sw %a2 %a0 0 #1363
	sw %a1 %a0 12 #1363
	sw %a8 %a0 8 #1363
	lw %a1 %sp 36 #1363
	sw %a1 %a0 4 #1363
	addi %a2 %min_caml_hp 0 #1376
	addi %min_caml_hp %min_caml_hp 40 #1376
	li %a5 solve_each_element_fast.2536 #1376
	sw %a5 %a2 0 #1376
	sw %a8 %a2 36 #1376
	sw %a6 %a2 32 #1376
	lw %a5 %sp 156 #1376
	sw %a5 %a2 28 #1376
	sw %a3 %a2 24 #1376
	sw %a10 %a2 20 #1376
	sw %a4 %a2 16 #1376
	sw %a7 %a2 12 #1376
	lw %a6 %sp 56 #1376
	sw %a6 %a2 8 #1376
	sw %a0 %sp 168 #1376
	lw %a0 %sp 164 #1376
	sw %a0 %a2 4 #1376
	addi %a0 %min_caml_hp 0 #1417
	addi %min_caml_hp %min_caml_hp 16 #1417
	li %a10 solve_one_or_network_fast.2540 #1417
	sw %a10 %a0 0 #1417
	sw %a2 %a0 8 #1417
	sw %a11 %a0 4 #1417
	addi %a2 %min_caml_hp 0 #1427
	addi %min_caml_hp %min_caml_hp 24 #1427
	li %a10 trace_or_matrix_fast.2544 #1427
	sw %a10 %a2 0 #1427
	sw %a8 %a2 16 #1427
	sw %a5 %a2 12 #1427
	sw %a3 %a2 8 #1427
	sw %a0 %a2 4 #1427
	addi %a0 %min_caml_hp 0 #1451
	addi %min_caml_hp %min_caml_hp 16 #1451
	li %a3 judge_intersection_fast.2548 #1451
	sw %a3 %a0 0 #1451
	sw %a2 %a0 12 #1451
	sw %a8 %a0 8 #1451
	sw %a1 %a0 4 #1451
	addi %a2 %min_caml_hp 0 #1470
	addi %min_caml_hp %min_caml_hp 16 #1470
	li %a3 get_nvector_rect.2550 #1470
	sw %a3 %a2 0 #1470
	lw %a3 %sp 60 #1470
	sw %a3 %a2 8 #1470
	sw %a4 %a2 4 #1470
	addi %a5 %min_caml_hp 0 #1478
	addi %min_caml_hp %min_caml_hp 8 #1478
	li %a10 get_nvector_plane.2552 #1478
	sw %a10 %a5 0 #1478
	sw %a3 %a5 4 #1478
	addi %a10 %min_caml_hp 0 #1486
	addi %min_caml_hp %min_caml_hp 16 #1486
	li %a11 get_nvector_second.2554 #1486
	sw %a11 %a10 0 #1486
	sw %a3 %a10 8 #1486
	sw %a7 %a10 4 #1486
	addi %a11 %min_caml_hp 0 #1508
	addi %min_caml_hp %min_caml_hp 16 #1508
	li %a7 get_nvector.2556 #1508
	sw %a7 %a11 0 #1508
	sw %a10 %a11 12 #1508
	sw %a2 %a11 8 #1508
	sw %a5 %a11 4 #1508
	addi %a2 %min_caml_hp 0 #1522
	addi %min_caml_hp %min_caml_hp 8 #1522
	li %a5 utexture.2559 #1522
	sw %a5 %a2 0 #1522
	lw %a5 %sp 64 #1522
	sw %a5 %a2 4 #1522
	addi %a7 %min_caml_hp 0 #1598
	addi %min_caml_hp %min_caml_hp 16 #1598
	li %a10 add_light.2562 #1598
	sw %a10 %a7 0 #1598
	sw %a5 %a7 8 #1598
	lw %a10 %sp 72 #1598
	sw %a10 %a7 4 #1598
	sw %a11 %sp 172 #1615
	addi %a11 %min_caml_hp 0 #1615
	addi %min_caml_hp %min_caml_hp 40 #1615
	li %a10 trace_reflections.2566 #1615
	sw %a10 %a11 0 #1615
	lw %a10 %sp 160 #1615
	sw %a10 %a11 32 #1615
	lw %a10 %sp 136 #1615
	sw %a10 %a11 28 #1615
	sw %a1 %a11 24 #1615
	sw %a3 %a11 20 #1615
	sw %a0 %a11 16 #1615
	sw %a4 %a11 12 #1615
	sw %a6 %a11 8 #1615
	sw %a7 %a11 4 #1615
	addi %a10 %min_caml_hp 0 #1643
	addi %min_caml_hp %min_caml_hp 88 #1643
	sw %a0 %sp 176 #1643
	li %a0 trace_ray.2571 #1643
	sw %a0 %a10 0 #1643
	sw %a2 %a10 80 #1643
	sw %a11 %a10 76 #1643
	sw %a8 %a10 72 #1643
	sw %a5 %a10 68 #1643
	sw %a9 %a10 64 #1643
	lw %a0 %sp 160 #1643
	sw %a0 %a10 60 #1643
	lw %a8 %sp 152 #1643
	sw %a8 %a10 56 #1643
	lw %a11 %sp 72 #1643
	sw %a11 %a10 52 #1643
	sw %a1 %a10 48 #1643
	lw %a9 %sp 4 #1643
	sw %a9 %a10 44 #1643
	sw %a3 %a10 40 #1643
	lw %a11 %sp 144 #1643
	sw %a11 %a10 36 #1643
	lw %a11 %sp 16 #1643
	sw %a11 %a10 32 #1643
	lw %a8 %sp 168 #1643
	sw %a8 %a10 28 #1643
	sw %a4 %a10 24 #1643
	lw %a4 %sp 52 #1643
	sw %a4 %a10 20 #1643
	sw %a6 %a10 16 #1643
	lw %a8 %sp 172 #1643
	sw %a8 %a10 12 #1643
	lw %a8 %sp 20 #1643
	sw %a8 %a10 8 #1643
	sw %a7 %a10 4 #1643
	addi %a7 %min_caml_hp 0 #1734
	addi %min_caml_hp %min_caml_hp 56 #1734
	li %a8 trace_diffuse_ray.2577 #1734
	sw %a8 %a7 0 #1734
	sw %a2 %a7 48 #1734
	sw %a5 %a7 44 #1734
	sw %a0 %a7 40 #1734
	sw %a1 %a7 36 #1734
	sw %a9 %a7 32 #1734
	sw %a3 %a7 28 #1734
	sw %a11 %a7 24 #1734
	lw %a0 %sp 176 #1734
	sw %a0 %a7 20 #1734
	sw %a4 %a7 16 #1734
	sw %a6 %a7 12 #1734
	lw %a0 %sp 172 #1734
	sw %a0 %a7 8 #1734
	lw %a0 %sp 68 #1734
	sw %a0 %a7 4 #1734
	addi %a1 %min_caml_hp 0 #1752
	addi %min_caml_hp %min_caml_hp 8 #1752
	li %a2 iter_trace_diffuse_rays.2580 #1752
	sw %a2 %a1 0 #1752
	sw %a7 %a1 4 #1752
	addi %a2 %min_caml_hp 0 #1767
	addi %min_caml_hp %min_caml_hp 16 #1767
	li %a3 trace_diffuse_rays.2585 #1767
	sw %a3 %a2 0 #1767
	lw %a3 %sp 152 #1767
	sw %a3 %a2 8 #1767
	sw %a1 %a2 4 #1767
	addi %a1 %min_caml_hp 0 #1775
	addi %min_caml_hp %min_caml_hp 16 #1775
	li %a3 trace_diffuse_ray_80percent.2589 #1775
	sw %a3 %a1 0 #1775
	sw %a2 %a1 8 #1775
	lw %a3 %sp 116 #1775
	sw %a3 %a1 4 #1775
	addi %a4 %min_caml_hp 0 #1800
	addi %min_caml_hp %min_caml_hp 16 #1800
	li %a5 calc_diffuse_using_1point.2593 #1800
	sw %a5 %a4 0 #1800
	sw %a1 %a4 12 #1800
	lw %a1 %sp 72 #1800
	sw %a1 %a4 8 #1800
	sw %a0 %a4 4 #1800
	addi %a5 %min_caml_hp 0 #1818
	addi %min_caml_hp %min_caml_hp 16 #1818
	li %a6 calc_diffuse_using_5points.2596 #1818
	sw %a6 %a5 0 #1818
	sw %a1 %a5 8 #1818
	sw %a0 %a5 4 #1818
	addi %a6 %min_caml_hp 0 #1838
	addi %min_caml_hp %min_caml_hp 8 #1838
	li %a7 do_without_neighbors.2602 #1838
	sw %a7 %a6 0 #1838
	sw %a4 %a6 4 #1838
	addi %a4 %min_caml_hp 0 #1853
	addi %min_caml_hp %min_caml_hp 8 #1853
	li %a7 neighbors_exist.2605 #1853
	sw %a7 %a4 0 #1853
	lw %a7 %sp 76 #1853
	sw %a7 %a4 4 #1853
	addi %a8 %min_caml_hp 0 #1887
	addi %min_caml_hp %min_caml_hp 16 #1887
	li %a9 try_exploit_neighbors.2618 #1887
	sw %a9 %a8 0 #1887
	sw %a6 %a8 8 #1887
	sw %a5 %a8 4 #1887
	addi %a5 %min_caml_hp 0 #1912
	addi %min_caml_hp %min_caml_hp 8 #1912
	li %a9 write_ppm_header.2625 #1912
	sw %a9 %a5 0 #1912
	sw %a7 %a5 4 #1912
	addi %a9 %min_caml_hp 0 #1932
	addi %min_caml_hp %min_caml_hp 8 #1932
	sw %a5 %sp 180 #1932
	li %a5 write_rgb.2629 #1932
	sw %a5 %a9 0 #1932
	sw %a1 %a9 4 #1932
	addi %a5 %min_caml_hp 0 #1946
	addi %min_caml_hp %min_caml_hp 16 #1946
	li %a11 pretrace_diffuse_rays.2631 #1946
	sw %a11 %a5 0 #1946
	sw %a2 %a5 12 #1946
	sw %a3 %a5 8 #1946
	sw %a0 %a5 4 #1946
	addi %a0 %min_caml_hp 0 #1975
	addi %min_caml_hp %min_caml_hp 40 #1975
	li %a2 pretrace_pixels.2634 #1975
	sw %a2 %a0 0 #1975
	lw %a2 %sp 12 #1975
	sw %a2 %a0 36 #1975
	sw %a10 %a0 32 #1975
	lw %a2 %sp 88 #1975
	sw %a2 %a0 28 #1975
	lw %a2 %sp 96 #1975
	sw %a2 %a0 24 #1975
	lw %a2 %sp 84 #1975
	sw %a2 %a0 20 #1975
	sw %a1 %a0 16 #1975
	lw %a10 %sp 108 #1975
	sw %a10 %a0 12 #1975
	sw %a5 %a0 8 #1975
	lw %a5 %sp 80 #1975
	sw %a5 %a0 4 #1975
	addi %a10 %min_caml_hp 0 #2000
	addi %min_caml_hp %min_caml_hp 32 #2000
	li %a11 pretrace_line.2641 #2000
	sw %a11 %a10 0 #2000
	lw %a11 %sp 104 #2000
	sw %a11 %a10 24 #2000
	lw %a11 %sp 100 #2000
	sw %a11 %a10 20 #2000
	sw %a2 %a10 16 #2000
	sw %a0 %a10 12 #2000
	sw %a7 %a10 8 #2000
	sw %a5 %a10 4 #2000
	addi %a0 %min_caml_hp 0 #2014
	addi %min_caml_hp %min_caml_hp 32 #2014
	li %a11 scan_pixel.2645 #2014
	sw %a11 %a0 0 #2014
	sw %a9 %a0 24 #2014
	sw %a8 %a0 20 #2014
	sw %a1 %a0 16 #2014
	sw %a4 %a0 12 #2014
	sw %a7 %a0 8 #2014
	sw %a6 %a0 4 #2014
	addi %a1 %min_caml_hp 0 #2034
	addi %min_caml_hp %min_caml_hp 16 #2034
	li %a4 scan_line.2651 #2034
	sw %a4 %a1 0 #2034
	sw %a0 %a1 12 #2034
	sw %a10 %a1 8 #2034
	sw %a7 %a1 4 #2034
	addi %a0 %min_caml_hp 0 #2084
	addi %min_caml_hp %min_caml_hp 8 #2084
	li %a4 create_pixelline.2664 #2084
	sw %a4 %a0 0 #2084
	sw %a7 %a0 4 #2084
	addi %a4 %min_caml_hp 0 #2107
	addi %min_caml_hp %min_caml_hp 8 #2107
	li %a6 calc_dirvec.2671 #2107
	sw %a6 %a4 0 #2107
	sw %a3 %a4 4 #2107
	addi %a6 %min_caml_hp 0 #2128
	addi %min_caml_hp %min_caml_hp 8 #2128
	li %a8 calc_dirvecs.2679 #2128
	sw %a8 %a6 0 #2128
	sw %a4 %a6 4 #2128
	addi %a4 %min_caml_hp 0 #2142
	addi %min_caml_hp %min_caml_hp 8 #2142
	li %a8 calc_dirvec_rows.2684 #2142
	sw %a8 %a4 0 #2142
	sw %a6 %a4 4 #2142
	addi %a6 %min_caml_hp 0 #2153
	addi %min_caml_hp %min_caml_hp 8 #2153
	li %a8 create_dirvec.2688 #2153
	sw %a8 %a6 0 #2153
	lw %a8 %sp 0 #2153
	sw %a8 %a6 4 #2153
	addi %a9 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	li %a11 create_dirvec_elements.2690 #2159
	sw %a11 %a9 0 #2159
	sw %a6 %a9 4 #2159
	addi %a11 %min_caml_hp 0 #2166
	addi %min_caml_hp %min_caml_hp 16 #2166
	sw %a0 %sp 184 #2166
	li %a0 create_dirvecs.2693 #2166
	sw %a0 %a11 0 #2166
	sw %a3 %a11 12 #2166
	sw %a9 %a11 8 #2166
	sw %a6 %a11 4 #2166
	addi %a0 %min_caml_hp 0 #2176
	addi %min_caml_hp %min_caml_hp 8 #2176
	li %a9 init_dirvec_constants.2695 #2176
	sw %a9 %a0 0 #2176
	lw %a9 %sp 148 #2176
	sw %a9 %a0 4 #2176
	addi %a5 %min_caml_hp 0 #2183
	addi %min_caml_hp %min_caml_hp 16 #2183
	li %a7 init_vecset_constants.2698 #2183
	sw %a7 %a5 0 #2183
	sw %a0 %a5 8 #2183
	sw %a3 %a5 4 #2183
	addi %a0 %min_caml_hp 0 #2190
	addi %min_caml_hp %min_caml_hp 16 #2190
	li %a3 init_dirvecs.2700 #2190
	sw %a3 %a0 0 #2190
	sw %a5 %a0 12 #2190
	sw %a11 %a0 8 #2190
	sw %a4 %a0 4 #2190
	addi %a3 %min_caml_hp 0 #2199
	addi %min_caml_hp %min_caml_hp 16 #2199
	li %a4 add_reflection.2702 #2199
	sw %a4 %a3 0 #2199
	sw %a9 %a3 12 #2199
	lw %a4 %sp 136 #2199
	sw %a4 %a3 8 #2199
	sw %a6 %a3 4 #2199
	addi %a4 %min_caml_hp 0 #2208
	addi %min_caml_hp %min_caml_hp 16 #2208
	li %a5 setup_rect_reflection.2709 #2208
	sw %a5 %a4 0 #2208
	lw %a5 %sp 144 #2208
	sw %a5 %a4 12 #2208
	lw %a6 %sp 16 #2208
	sw %a6 %a4 8 #2208
	sw %a3 %a4 4 #2208
	addi %a7 %min_caml_hp 0 #2223
	addi %min_caml_hp %min_caml_hp 16 #2223
	li %a11 setup_surface_reflection.2712 #2223
	sw %a11 %a7 0 #2223
	sw %a5 %a7 12 #2223
	sw %a6 %a7 8 #2223
	sw %a3 %a7 4 #2223
	addi %a3 %min_caml_hp 0 #2238
	addi %min_caml_hp %min_caml_hp 16 #2238
	li %a5 setup_reflections.2715 #2238
	sw %a5 %a3 0 #2238
	sw %a7 %a3 12 #2238
	sw %a4 %a3 8 #2238
	lw %a4 %sp 4 #2238
	sw %a4 %a3 4 #2238
	addi %a11 %min_caml_hp 0 #2258
	addi %min_caml_hp %min_caml_hp 64 #2258
	li %a4 rt.2717 #2258
	sw %a4 %a11 0 #2258
	lw %a4 %sp 180 #2258
	sw %a4 %a11 56 #2258
	sw %a3 %a11 52 #2258
	sw %a9 %a11 48 #2258
	sw %a2 %a11 44 #2258
	sw %a1 %a11 40 #2258
	lw %a1 %sp 140 #2258
	sw %a1 %a11 36 #2258
	sw %a10 %a11 32 #2258
	sw %a8 %a11 28 #2258
	lw %a1 %sp 128 #2258
	sw %a1 %a11 24 #2258
	sw %a6 %a11 20 #2258
	sw %a0 %a11 16 #2258
	lw %a0 %sp 76 #2258
	sw %a0 %a11 12 #2258
	lw %a0 %sp 80 #2258
	sw %a0 %a11 8 #2258
	lw %a0 %sp 184 #2258
	sw %a0 %a11 4 #2258
	addi %a0 %zero 128 #2279
	addi %a1 %zero 128 #2279
	sw %ra %sp 188 #2279 call cls
	lw %a10 %a11 0 #2279
	addi %sp %sp 192 #2279	
	jalr %ra %a10 0 #2279
	addi %sp %sp -192 #2279
	lw %ra %sp 188 #2279
	addi %a0 %zero 0 #2281