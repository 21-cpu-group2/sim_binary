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
    add %a2 %a0 %zero #%a0にarray length %a1に初期値が入っている
    add %a0 %min_caml_hp %zero # 返り値にarrayのアドレスをセット
create_array_loop:
    beq %a2 %zero create_array_exit # array lengthが0だったら終了
    sw %a1 %min_caml_hp 0                 # %a1をメモリに格納
    addi %min_caml_hp %min_caml_hp 4       # hpを増やす
    addi %a2 %a2 -1                      # array lengthを1減らす
    beq %zero %zero create_array_loop    # create_array_loopにジャンプ
create_array_exit:
    jalr %zero %ra 0 # 返り値には既にarrayのアドレスが入っているのでなにもせず終了

min_caml_create_float_array: # min_caml_create_arrayとの違いは初期値が%f0に入っていることだけ
    add %a2 %a0 %zero #%a0にarray length %f0に初期値が入っている
    add %a0 %min_caml_hp %zero # 返り値にarrayのアドレスをセット
create_float_array_loop:
    beq %a2 %zero create_float_array_exit
    sw %f0 %min_caml_hp 0                 # %f0をメモリに格納
    addi %min_caml_hp %min_caml_hp 4       # hpを増やす
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
    li %f1 l.1 # PIの値をセット PCの値をセット
    li %f2 l.2 # 2.0をセット
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
    jalr %zero %ra 0  # Aはf0に入っているのでそのまま終了

kernel_sin:
    li %f1 l.3 # S3の値をセット PCの値をセット
    li %f4 l.4 # S5の値をセット PCの値をセット
    li %f6 l.5 # S7の値をセット PCの値をセット
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
    jalr %zero %ra 0  # 終了

kernel_cos:
    li %f1 l.6 # C1 (1.0) の値をセット PCの値をセット
    li %f4 l.7 # C4 (1.0) の値をセット PCの値をセット
    li %f6 l.8 # C6 (1.0) の値をセット PCの値をセット
    fmul %f2 %f0 %f0 # A^2
    fmul %f3 %f2 %f2 # A^4
    fmul %f5 %f2 %f3 # A^6
    fhalf %f2 %f2 # 0.5*A^2
    fmul %f4 %f4 %f3 # C4 * A^4
    fmul %f6 %f6 %f5 # C6 * A^6
    fsub %f0 %f1 %f2 # 1.0 - 0.5*A^2
    fadd %f0 %f0 %f4 # 1.0 - 0.5*A^2 + C4*A^4
    fsub %f0 %f0 %f6 # 1.0 - 0.5*A^2 + C4*A^4 - C6*A^6
    jalr %zero %ra 0  # 終了

reverse:
    beq %a0 %zero a_beq_zero # if %a0 == 0 jump to a_beq_zero
    add %a0 %zero %zero # return 0
    jalr %zero %ra 0  # 終了
a_beq_zero:
    addi %a0 %zero 1 # return 1
    jalr %zero %ra 0  # 終了

min_caml_sin:
    fispos %a1 %f0 # %a1 = flag(%f0), %a0はreduction_2piで使うのでここでは%a1を使う
    fabs %f0 %f0 # A = abs(A)
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reduction_2pi # %f0 = reduction_2pi(%f0)
    addi %sp %sp -8 # return from reduction_2pi
    lw %ra %sp 4
    li %f1 l.1 # PI の値をセット PCの値をセット
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
    jalr %zero %ra 0  # 終了
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
    jalr %zero %ra 0  # 終了

min_caml_cos:
    addi %a1 %zero 1 # FLAG = 1
    fabs %f0 %f0 # A = |A|
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reduction_2pi # A = reduction_2pi(A)
    addi %sp %sp -8 # return from reduction_2pi
    lw %ra %sp 4
    li %f1 l.1 # PI の値をセット PCの値をセット
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
    jalr %zero %ra 0  # 終了
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
    jalr %zero %ra 0  # 終了

kernel_atan:
    li %f1 l.9 # A3の値をセット PCの値をセット
    li %f2 l.10 # A5の値をセット PCの値をセット
    li %f3 l.11 # A7の値をセット PCの値をセット
    li %f4 l.12 # A9の値をセット PCの値をセット
    li %f5 l.13 # A11の値をセット PCの値をセット
    li %f6 l.14 # A13の値をセット PCの値をセット
    fmul %f7 %f0 %f0 # A^2
    fmul %f8 %f0 %f7 # A^3
    fmul %f9 %f7 %f8 # A^5
    fmul %f10 %f7 %f9 # A^7
    fmul %f11 %f7 %f10 # A^9
    fmul %f12 %f7 %f11 # A^11
    fmul %f13 %f7 %f12 # A^13
    fmul %f1 %f1 %f8 # A3 * A^3
    fmul %f2 %f2 %f9 # A5 * A^5
    fmul %f3 %f3 %f10 # A7 * A^7
    fmul %f4 %f4 %f11 # A9 * A^9
    fmul %f5 %f5 %f12 # A11 * A^11
    fmul %f6 %f6 %f13 # A13 * A^13
    fsub %f0 %f0 %f1 # A - A3*A^3
    fadd %f0 %f0 %f2 # A - A3*A^3 + A5*A^5
    fsub %f0 %f0 %f3 # A - A3*A^3 + A5*A^5 - A7*A^7
    fadd %f0 %f0 %f4 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9
    fsub %f0 %f0 %f5 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9 - A11*A^11
    fadd %f0 %f0 %f6 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9 - A11*A^11 + A13*A^13
    jalr %zero %ra 0  # 終了

min_caml_atan:
    fabs %f1 %f0 # |A|
    li %f2 l.15 # 0.4375 PCの値をセット
    li %f3 l.16 # 2.4375 PCの値をセット
    li %f4 l.6 # 1.0 PCの値をセット
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
    li %f5 l.1 # PI PCの値をセット
    fhalf %f5 %f5 # PI/2
    fsub %f0 %f5 %f0 # PI/2 - kernel_atan(1/|A|)
    jalr %zero %ra 0  # 終了
atan_break1:
    sw %ra %sp 4 # call kernel_atan
    addi %sp %sp 8
    jal %ra kernel_atan # kernel_atan(A)
    addi %sp %sp -8 # return from kernel_atan
    lw %ra %sp 4
    jalr %zero %ra 0  # 終了
atan_break2:
    fsub %f5 %f1 %f4 # |A| - 1.0
    fadd %f6 %f1 %f4 # |A| + 1.0
    fdiv %f0 %f5 %f6 # (|A| - 1.0)/(|A| + 1.0)
    sw %ra %sp 4 # call kernel_atan
    addi %sp %sp 8
    jal %ra kernel_atan # kernel_atan (|A| - 1.0)/(|A| + 1.0)
    addi %sp %sp -8 # return from kernel_atan
    lw %ra %sp 4
    li %f5 l.1 # PI PCの値をセット
    fhalf %f5 %f5 # PI/2
    fhalf %f5 %f5 # PI/4
    fadd %f0 %f5 %f0 # PI/4 kernel_atan((|A| - 1.0)/(|A| + 1.0))
    jalr %zero %ra 0  # 終了

min_caml_read_int:
    lw %a0 %in 0
    addi %in %in 4
    jalr %zero %ra 0  # 終了

min_caml_read_float:
    lw %f0 %in 0
    addi %in %in 4
    jalr %zero %ra 0  # 終了

min_caml_print_int:
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # 終了

min_caml_print_char:
    addi %a1 %zero 80 # P
    beq %a0 %a1 break_print_char
    addi %a2 %zero 51 # 3
    beq %a0 %a2 break_print_charP3
    addi %a3 %zero 32 # 空白文字
    slli %a3 %a3 8 # 空白文字を1byteずらす
    add %a0 %a0 %a3 # 00 00 32 %a0
    slli %a3 %a3 8 # さらに1byteずらす
    add %a0 %a0 %a3 # 00 32 32 %a0
    slli %a3 %a3 8 # さらに1byteずらす
    add %a0 %a0 %a3 # 32 32 32 %a0
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # 終了
break_print_char:
    jalr %zero %ra 0  # 終了
break_print_charP3:
    slli %a2 %a2 8 # 51を1byteずらす
    add %a0 %a0 %a2 # 00 00 51 80
    addi %a3 %zero 32 # 空白文字
    slli %a3 %a3 16 # 空白文字を2byteずらす
    add %a0 %a0 %a3 # 00 32 51 80
    slli %a3 %a3 8 # さらに1byteずらす
    add %a0 %a0 %a3 # 32 32 51 80
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # 終了


fib.6:
	addi %a12 %zero 1
	blt %a12 %a0 bge_else.18
	jalr %zero %ra 0 #2
bge_else.18:
	addi %a1 %a0 -1 #3
	sw %a0 %sp 0 #3
	add %a0 %a1 %zero
	sw %ra %sp 4 #3 call dir
	addi %sp %sp 8 #3	
	jal %ra fib.6 #3
	addi %sp %sp -8 #3
	lw %ra %sp 4 #3
	lw %a1 %sp 0 #4
	addi %a1 %a1 -2 #4
	sw %a0 %sp 4 #4
	add %a0 %a1 %zero
	sw %ra %sp 12 #4 call dir
	addi %sp %sp 16 #4	
	jal %ra fib.6 #4
	addi %sp %sp -16 #4
	lw %ra %sp 12 #4
	lw %a1 %sp 4 #5
	add %a0 %a1 %a0 #5
	jalr %zero %ra 0 #5
min_caml_start:
	li %sp 44000
	li %in 200000
	li %out 300000
	li %min_caml_hp 400000
	addi %a0 %zero 35 #6
	sw %ra %sp 4 #6 call dir
	addi %sp %sp 8 #6	
	jal %ra fib.6 #6
	addi %sp %sp -8 #6
	lw %ra %sp 4 #6