ll.1:	# PI
    1078530011
ll.2:	# 2.0
    1073741824
ll.3:	# S3
	3190467244
ll.4:	# S5
	1007191654
ll.5:	# S7
	3108857014
ll.6:	# 1.0
	1065353216
ll.7:	# C4
	1026205577
ll.8:	# C6
	3132326150
ll.9:	# A3
	3198855850
ll.10:	# A5
	1045220557
ll.11:	# A7
	3188869413
ll.12:	# A9
	1038323256
ll.13:	# A11
	3182941806
ll.14:	# A13
	1031137221
ll.15:   # 0.4375
    1054867456
ll.16:   # 2.4375
    1075576832

min_caml_sll:   #
    slli %a0 %a0 2
    jalr %zero %ra 0

min_caml_srl:
    srli %a0 %a0 1
    jalr %zero %ra 0

min_caml_create_array:
    add %a2 %a0 %zero #%a0���array length %a1�����������ゃ����ャ�ｃ��������
    add %a0 %min_caml_hp %zero # 菴������ゃ��array�����≪�������鴻����祉�����
create_array_loop:
    beq %a2 %zero create_array_exit # array length���0�����ｃ�����腟�篋�
    sw %a1 %min_caml_hp 0                 # %a1�����＜�≪�������主��
    addi %min_caml_hp %min_caml_hp 4       # hp���紜�������
    addi %a2 %a2 -1                      # array length���1羝�������
    beq %zero %zero create_array_loop    # create_array_loop�����吾�ｃ�潟��
create_array_exit:
    jalr %zero %ra 0 # 菴������ゃ�������≪��array�����≪�������鴻����ャ�ｃ�������������с��������������腟�篋�

min_caml_create_float_array: # min_caml_create_array�����������������������ゃ��%f0�����ャ�ｃ��������������������
    add %a2 %a0 %zero #%a0���array length %f0�����������ゃ����ャ�ｃ��������
    add %a0 %min_caml_hp %zero # 菴������ゃ��array�����≪�������鴻����祉�����
create_float_array_loop:
    beq %a2 %zero create_float_array_exit
    sw %f0 %min_caml_hp 0                 # %f0�����＜�≪�������主��
    addi %min_caml_hp %min_caml_hp 4       # hp���紜�������
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
    li %f1 ll.1 # PI�����ゃ����祉����� PC�����ゃ����祉�����
    li %f2 ll.2 # 2.0�����祉�����
    fmul %f3 %f1 %f2 # P = PI * 2.0
    fmul %f1 %f1 %f2 # PI * 2.0 PC:53 26th
reduction_continue:
    fless %a0 %f0 %f3   # if A < P
    blt %zero %a0 reduction_break # if A < P then jump reduction_break
    fmul %f3 %f3 %f2  # P = P * 2.0
    beq %zero %zero reduction_continue
reduction_break:
    fless %a0 %f0 %f1  # if A < PI * 2
    blt %zero %a0 reduction_break2 # if A < PI * 2 then jump reduction_break2
    fless %a0 %f0 %f3  # if A < P PC:56
    blt %zero %a0 reduction_break3 # if A < P then  jump reduction_break3
    fsub %f0 %f0 %f3  # A = A - P PC: 58
reduction_break3:
    fhalf %f3 %f3     # P = P / 2
    beq %zero %zero reduction_break
reduction_break2:
    jalr %zero %ra 0  # A���f0�����ャ�ｃ�������������с�������障�丞��篋� PC: 61 29th

kernel_sin:
    li %f1 ll.3 # S3�����ゃ����祉����� PC�����ゃ����祉�����
    li %f4 ll.4 # S5�����ゃ����祉����� PC�����ゃ����祉�����
    li %f6 ll.5 # S7�����ゃ����祉����� PC�����ゃ����祉�����
    fmul %f2 %f0 %f0 # A^2
    fmul %f3 %f2 %f0 # A^3
    fmul %f1 %f1 %f3 # S3*A^3
    fmul %f5 %f2 %f3 # A^5
    fmul %f4 %f4 %f5 # S5 * A^5
    fmul %f7 %f2 %f5 # A^7
    fmul %f6 %f6 %f7 # S7 * A^7
    fadd %f0 %f0 %f1 # A - S3*S7
    fadd %f0 %f0 %f4 # A - S3*S7 + S5*A^5
    fadd %f0 %f0 %f6 # A - S3*S7 + S5*A^5 - S7 * A^7
    jalr %zero %ra 0  # 腟�篋�

kernel_cos:
    li %f1 ll.6 # C1 (1.0) �����ゃ����祉����� PC�����ゃ����祉�����
    li %f4 ll.7 # C4 (1.0) �����ゃ����祉����� PC�����ゃ����祉�����
    li %f6 ll.8 # C6 (1.0) �����ゃ����祉����� PC�����ゃ����祉�����
    fmul %f2 %f0 %f0 # A^2
    fmul %f3 %f2 %f2 # A^4
    fmul %f5 %f2 %f3 # A^6
    fhalf %f2 %f2 # 0.5*A^2
    fmul %f4 %f4 %f3 # C4 * A^4
    fmul %f6 %f6 %f5 # C6 * A^6
    fsub %f0 %f1 %f2 # 1.0 - 0.5*A^2
    fadd %f0 %f0 %f4 # 1.0 - 0.5*A^2 + C4*A^4
    fadd %f0 %f0 %f6 # 1.0 - 0.5*A^2 + C4*A^4 - C6*A^6
    jalr %zero %ra 0  # 腟�篋�

reverse:
    beq %a0 %zero a_beq_zero # if %a0 == 0 jump to a_beq_zero
    add %a0 %zero %zero # return 0
    jalr %zero %ra 0  # 腟�篋�
a_beq_zero:
    addi %a0 %zero 1 # return 1
    jalr %zero %ra 0  # 腟�篋�

min_caml_sin:
    fispos %a1 %f0 # %a1 = flag(%f0), %a0���reduction_2pi��т戎��������с�������с��%a1���篏帥��
    fabs %f0 %f0 # A = abs(A)
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reduction_2pi # %f0 = reduction_2pi(%f0)
    addi %sp %sp -8 # return from reduction_2pi PC:105 30th
    lw %ra %sp 4
    li %f1 ll.1 # PI �����ゃ����祉����� PC�����ゃ����祉�����
    fless %a0 %f0 %f1 # if A < PI PC:109 34th
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
    fhalf %f2 %f1 # PI/2 PC:119 36th
    fless %a0 %f0 %f2 # if A < PI/2
    blt %zero %a0 a_less_than_pi_2 # 0 < %a0 jump to a_less_than_pi_2
    fsub %f0 %f1 %f0 # A = PI - A
a_less_than_pi_2:
    fhalf %f3 %f2 # PI/4 PC: 123 39th
    fless %a0 %f3 %f0 # if A > PI/4
    blt %zero %a0 pi_4_less_than_a # 0 < %a0 jump to pi_4_less_than_a
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra kernel_sin # %f0 = kernel_sin %f0
    addi %sp %sp -8 # return from reverse
    lw %ra %sp 4
    blt %zero %a1 fsin_end # if 0 < FLAG jump to fsin_end
    fneg %f0 %f0 # A = - A
    jalr %zero %ra 0  # 腟�篋�
pi_4_less_than_a:
    fsub %f0 %f2 %f0    # A = PI/2 - A PC: 134
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra kernel_cos
    addi %sp %sp -8 # return from reverse
    lw %ra %sp 4
    blt %zero %a1 fsin_end # if 0 < FLAG jump to fsin_end
    fneg %f0 %f0 # A = - A
fsin_end:
    jalr %zero %ra 0  # 腟�篋�

min_caml_cos:
    addi %a1 %zero 1 # FLAG = 1
    fabs %f0 %f0 # A = |A|
    sw %ra %sp 4
    addi %sp %sp 8
    jal %ra reduction_2pi # A = reduction_2pi(A)
    addi %sp %sp -8 # return from reduction_2pi
    lw %ra %sp 4
    li %f1 ll.1 # PI �����ゃ����祉����� PC�����ゃ����祉�����
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
    jalr %zero %ra 0  # 腟�篋�
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
    jalr %zero %ra 0  # 腟�篋�

kernel_atan:
    li %f1 ll.9 # A3�����ゃ����祉����� PC�����ゃ����祉�����
    li %f2 ll.10 # A5�����ゃ����祉����� PC�����ゃ����祉�����
    li %f3 ll.11 # A7�����ゃ����祉����� PC�����ゃ����祉�����
    li %f4 ll.12 # A9�����ゃ����祉����� PC�����ゃ����祉�����
    li %f5 ll.13 # A11�����ゃ����祉����� PC�����ゃ����祉�����
    li %f6 ll.14 # A13�����ゃ����祉����� PC�����ゃ����祉�����
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
    fadd %f0 %f0 %f1 # A - A3*A^3
    fadd %f0 %f0 %f2 # A - A3*A^3 + A5*A^5
    fadd %f0 %f0 %f3 # A - A3*A^3 + A5*A^5 - A7*A^7
    fadd %f0 %f0 %f4 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9
    fadd %f0 %f0 %f5 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9 - A11*A^11
    fadd %f0 %f0 %f6 # A - A3*A^3 + A5*A^5 - A7*A^7 + A9*A^9 - A11*A^11 + A13*A^13
    jalr %zero %ra 0  # 腟�篋�

min_caml_atan:
    fispos %a11 %f0
    fabs %f1 %f0 # |A|
    li %f2 ll.15 # 0.4375 PC�����ゃ����祉�����
    li %f3 ll.16 # 2.4375 PC�����ゃ����祉�����
    li %f4 ll.6 # 1.0 PC�����ゃ����祉�����
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
    li %f5 ll.1 # PI PC�����ゃ����祉�����
    fhalf %f5 %f5 # PI/2
    fsub %f0 %f5 %f0 # PI/2 - kernel_atan(1/|A|)
    beq %a11 %zero atan_neg
    jalr %zero %ra 0  # 腟�篋�
atan_neg:
    fneg %f0 %f0
    jalr %zero %ra 0  # 腟�篋�
atan_break1:
    sw %ra %sp 4 # call kernel_atan
    addi %sp %sp 8
    jal %ra kernel_atan # kernel_atan(A)
    addi %sp %sp -8 # return from kernel_atan
    lw %ra %sp 4
    jalr %zero %ra 0  # 腟�篋�
atan_break2:
    fsub %f5 %f1 %f4 # |A| - 1.0
    fadd %f6 %f1 %f4 # |A| + 1.0
    fdiv %f0 %f5 %f6 # (|A| - 1.0)/(|A| + 1.0)
    sw %ra %sp 4 # call kernel_atan
    addi %sp %sp 8
    jal %ra kernel_atan # kernel_atan (|A| - 1.0)/(|A| + 1.0)
    addi %sp %sp -8 # return from kernel_atan
    lw %ra %sp 4
    li %f5 ll.1 # PI PC�����ゃ����祉�����
    fhalf %f5 %f5 # PI/2
    fhalf %f5 %f5 # PI/4
    fadd %f0 %f5 %f0 # PI/4 + kernel_atan((|A| - 1.0)/(|A| + 1.0))
    beq %a11 %zero atan_break2_neg # if A < 0 then jump
    jalr %zero %ra 0  # 腟�篋�
atan_break2_neg:
    fneg %f0 %f0
    jalr %zero %ra 0  # 腟�篋�

min_caml_read_int:
    lw %a0 %in 0
    addi %in %in 4
    jalr %zero %ra 0  # 腟�篋�

min_caml_read_float:
    lw %f0 %in 0
    addi %in %in 4
    jalr %zero %ra 0  # 腟�篋�

min_caml_print_float:
    sw %f0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # 腟�篋�

min_caml_print_int:
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # 腟�篋�

min_caml_print_char:
    addi %a1 %zero 80 # P
    beq %a0 %a1 break_print_char
    addi %a2 %zero 51 # 3
    beq %a0 %a2 break_print_charP3
    addi %a3 %zero 32 # 腥榊�醇��絖�
    slli %a3 %a3 8 # 腥榊�醇��絖����1byte���������
    add %a0 %a0 %a3 # 00 00 32 %a0
    slli %a3 %a3 8 # ���������1byte���������
    add %a0 %a0 %a3 # 00 32 32 %a0
    slli %a3 %a3 8 # ���������1byte���������
    add %a0 %a0 %a3 # 32 32 32 %a0
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # 腟�篋�
break_print_char:
    jalr %zero %ra 0  # 腟�篋�
break_print_charP3:
    slli %a2 %a2 8 # 51���1byte���������
    add %a0 %a1 %a2 # 00 00 51 80
    addi %a3 %zero 32 # 腥榊�醇��絖�
    slli %a3 %a3 16 # 腥榊�醇��絖����2byte���������
    add %a0 %a0 %a3 # 00 32 51 80
    slli %a3 %a3 8 # ���������1byte���������
    add %a0 %a0 %a3 # 32 32 51 80
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0  # 腟�篋�


l.6289:	# 128.000000
	1124073472
l.6240:	# 0.900000
	1063675494
l.6238:	# 0.200000
	1045220557
l.6132:	# 150.000000
	1125515264
l.6129:	# -150.000000
	-1021968384
l.6110:	# 0.100000
	1036831949
l.6106:	# -2.000000
	-1073741824
l.6103:	# 256.000000
	1132462080
l.6070:	# 20.000000
	1101004800
l.6068:	# 0.050000
	1028443341
l.6060:	# 0.250000
	1048576000
l.6051:	# 10.000000
	1092616192
l.6046:	# 0.300000
	1050253722
l.6044:	# 255.000000
	1132396544
l.6040:	# 0.500000
	1056964608
l.6038:	# 0.150000
	1041865114
l.6031:	# 3.141593
	1078530011
l.6029:	# 30.000000
	1106247680
l.6027:	# 15.000000
	1097859072
l.6025:	# 0.000100
	953267991
l.5976:	# 100000000.000000
	1287568416
l.5970:	# 1000000000.000000
	1315859240
l.5947:	# -0.100000
	-1110651699
l.5933:	# 0.010000
	1008981770
l.5931:	# -0.200000
	-1102263091
l.5713:	# 2.000000
	1073741824
l.5676:	# -200.000000
	-1018691584
l.5673:	# 200.000000
	1128792064
l.5668:	# 0.017453
	1016003125
l.5555:	# -1.000000
	-1082130432
l.5553:	# 1.000000
	1065353216
l.5551:	# 0.000000
	0
xor.2232:
	addi %a2 %zero 0 #105
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8449
	addi %a0 %a1 0 #105
	jalr %zero %ra 0 #105
beq_else.8449:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8450
	addi %a0 %zero 1 #105
	jalr %zero %ra 0 #105
beq_else.8450:
	addi %a0 %a2 0 #105
	jalr %zero %ra 0 #105
sgn.2235:
	sw %f0 %sp 0 #111
	sw %ra %sp 12 #111 call dir
	addi %sp %sp 16 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -16 #111
	lw %ra %sp 12 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8451
	lw %f0 %sp 0 #112
	sw %ra %sp 12 #112 call dir
	addi %sp %sp 16 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -16 #112
	lw %ra %sp 12 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8452
	li %f0 l.5555 #113
	jalr %zero %ra 0 #113
beq_else.8452:
	li %f0 l.5553 #112
	jalr %zero %ra 0 #112
beq_else.8451:
	li %f0 l.5551 #111
	jalr %zero %ra 0 #111
fneg_cond.2237:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8453
	jal	%zero min_caml_fneg
beq_else.8453:
	jalr %zero %ra 0 #559
add_mod5.2240:
	add %a0 %a0 %a1 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.8454
	addi %a0 %a0 -5 #124
	jalr %zero %ra 0 #124
bge_else.8454:
	jalr %zero %ra 0 #124
vecset.2243:
	sw %f0 %a0 0 #133
	sw %f1 %a0 4 #134
	sw %f2 %a0 8 #135
	jalr %zero %ra 0 #135
vecfill.2248:
	sw %f0 %a0 0 #140
	sw %f0 %a0 4 #141
	sw %f0 %a0 8 #142
	jalr %zero %ra 0 #142
vecbzero.2251:
	li %f0 l.5551 #147
	jal	%zero vecfill.2248
veccpy.2253:
	lw %f0 %a1 0 #152
	sw %f0 %a0 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a0 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a0 8 #154
	jalr %zero %ra 0 #154
vecdist2.2256:
	lw %f0 %a0 0 #159
	lw %f1 %a1 0 #159
	fsub %f0 %f0 %f1 #159
	sw %a1 %sp 0 #159
	sw %a0 %sp 4 #159
	sw %ra %sp 12 #159 call dir
	addi %sp %sp 16 #159	
	jal %ra min_caml_fsqr #159
	addi %sp %sp -16 #159
	lw %ra %sp 12 #159
	lw %a0 %sp 4 #159
	lw %f1 %a0 4 #159
	lw %a1 %sp 0 #159
	lw %f2 %a1 4 #159
	fsub %f1 %f1 %f2 #159
	sw %f0 %sp 8 #159
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #159 call dir
	addi %sp %sp 24 #159	
	jal %ra min_caml_fsqr #159
	addi %sp %sp -24 #159
	lw %ra %sp 20 #159
	lw %f1 %sp 8 #159
	fadd %f0 %f1 %f0 #159
	lw %a0 %sp 4 #159
	lw %f1 %a0 8 #159
	lw %a0 %sp 0 #159
	lw %f2 %a0 8 #159
	fsub %f1 %f1 %f2 #159
	sw %f0 %sp 16 #159
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #159 call dir
	addi %sp %sp 32 #159	
	jal %ra min_caml_fsqr #159
	addi %sp %sp -32 #159
	lw %ra %sp 28 #159
	lw %f1 %sp 16 #159
	fadd %f0 %f1 %f0 #159
	jalr %zero %ra 0 #159
vecunit.2259:
	li %f0 l.5553 #164
	lw %f1 %a0 0 #164
	sw %f0 %sp 0 #164
	sw %a0 %sp 8 #164
	fadd %f0 %f1 %fzero
	sw %ra %sp 12 #164 call dir
	addi %sp %sp 16 #164	
	jal %ra min_caml_fsqr #164
	addi %sp %sp -16 #164
	lw %ra %sp 12 #164
	lw %a0 %sp 8 #164
	lw %f1 %a0 4 #164
	sw %f0 %sp 16 #164
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #164 call dir
	addi %sp %sp 32 #164	
	jal %ra min_caml_fsqr #164
	addi %sp %sp -32 #164
	lw %ra %sp 28 #164
	lw %f1 %sp 16 #164
	fadd %f0 %f1 %f0 #164
	lw %a0 %sp 8 #164
	lw %f1 %a0 8 #164
	sw %f0 %sp 24 #164
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #164 call dir
	addi %sp %sp 40 #164	
	jal %ra min_caml_fsqr #164
	addi %sp %sp -40 #164
	lw %ra %sp 36 #164
	lw %f1 %sp 24 #164
	fadd %f0 %f1 %f0 #164
	sw %ra %sp 36 #164 call dir
	addi %sp %sp 40 #164	
	jal %ra min_caml_sqrt #164
	addi %sp %sp -40 #164
	lw %ra %sp 36 #164
	lw %f1 %sp 0 #164
	fdiv %f0 %f1 %f0 #164
	lw %a0 %sp 8 #164
	lw %f1 %a0 0 #164
	fmul %f1 %f1 %f0 #165
	sw %f1 %a0 0 #165
	lw %f1 %a0 4 #164
	fmul %f1 %f1 %f0 #166
	sw %f1 %a0 4 #166
	lw %f1 %a0 8 #164
	fmul %f0 %f1 %f0 #167
	sw %f0 %a0 8 #167
	jalr %zero %ra 0 #167
vecunit_sgn.2261:
	lw %f0 %a0 0 #172
	sw %a1 %sp 0 #172
	sw %a0 %sp 4 #172
	sw %ra %sp 12 #172 call dir
	addi %sp %sp 16 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -16 #172
	lw %ra %sp 12 #172
	lw %a0 %sp 4 #172
	lw %f1 %a0 4 #172
	sw %f0 %sp 8 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #172 call dir
	addi %sp %sp 24 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -24 #172
	lw %ra %sp 20 #172
	lw %f1 %sp 8 #172
	fadd %f0 %f1 %f0 #172
	lw %a0 %sp 4 #172
	lw %f1 %a0 8 #172
	sw %f0 %sp 16 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #172 call dir
	addi %sp %sp 32 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -32 #172
	lw %ra %sp 28 #172
	lw %f1 %sp 16 #172
	fadd %f0 %f1 %f0 #172
	sw %ra %sp 28 #172 call dir
	addi %sp %sp 32 #172	
	jal %ra min_caml_sqrt #172
	addi %sp %sp -32 #172
	lw %ra %sp 28 #172
	sw %f0 %sp 24 #173
	sw %ra %sp 36 #173 call dir
	addi %sp %sp 40 #173	
	jal %ra min_caml_fiszero #173
	addi %sp %sp -40 #173
	lw %ra %sp 36 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8460 # nontail if
	lw %a0 %sp 0 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8462 # nontail if
	li %f0 l.5553 #173
	lw %f1 %sp 24 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.8463 # then sentence ends
beq_else.8462:
	li %f0 l.5555 #173
	lw %f1 %sp 24 #173
	fdiv %f0 %f0 %f1 #173
beq_cont.8463:
	jal %zero beq_cont.8461 # then sentence ends
beq_else.8460:
	li %f0 l.5553 #173
beq_cont.8461:
	lw %a0 %sp 4 #172
	lw %f1 %a0 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a0 0 #174
	lw %f1 %a0 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a0 4 #175
	lw %f1 %a0 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a0 8 #176
	jalr %zero %ra 0 #176
veciprod.2264:
	lw %f0 %a0 0 #181
	lw %f1 %a1 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a0 4 #181
	lw %f2 %a1 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a0 8 #181
	lw %f2 %a1 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	jalr %zero %ra 0 #181
veciprod2.2267:
	lw %f3 %a0 0 #186
	fmul %f0 %f3 %f0 #186
	lw %f3 %a0 4 #186
	fmul %f1 %f3 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a0 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	jalr %zero %ra 0 #186
vecaccum.2272:
	lw %f1 %a0 0 #191
	lw %f2 %a1 0 #191
	fmul %f2 %f0 %f2 #191
	fadd %f1 %f1 %f2 #191
	sw %f1 %a0 0 #191
	lw %f1 %a0 4 #191
	lw %f2 %a1 4 #191
	fmul %f2 %f0 %f2 #192
	fadd %f1 %f1 %f2 #192
	sw %f1 %a0 4 #192
	lw %f1 %a0 8 #191
	lw %f2 %a1 8 #191
	fmul %f0 %f0 %f2 #193
	fadd %f0 %f1 %f0 #193
	sw %f0 %a0 8 #193
	jalr %zero %ra 0 #193
vecadd.2276:
	lw %f0 %a0 0 #198
	lw %f1 %a1 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a0 0 #198
	lw %f0 %a0 4 #198
	lw %f1 %a1 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a0 4 #199
	lw %f0 %a0 8 #198
	lw %f1 %a1 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a0 8 #200
	jalr %zero %ra 0 #200
vecmul.2279:
	lw %f0 %a0 0 #205
	lw %f1 %a1 0 #205
	fmul %f0 %f0 %f1 #205
	sw %f0 %a0 0 #205
	lw %f0 %a0 4 #205
	lw %f1 %a1 4 #205
	fmul %f0 %f0 %f1 #206
	sw %f0 %a0 4 #206
	lw %f0 %a0 8 #205
	lw %f1 %a1 8 #205
	fmul %f0 %f0 %f1 #207
	sw %f0 %a0 8 #207
	jalr %zero %ra 0 #207
vecscale.2282:
	lw %f1 %a0 0 #212
	fmul %f1 %f1 %f0 #212
	sw %f1 %a0 0 #212
	lw %f1 %a0 4 #212
	fmul %f1 %f1 %f0 #213
	sw %f1 %a0 4 #213
	lw %f1 %a0 8 #212
	fmul %f0 %f1 %f0 #214
	sw %f0 %a0 8 #214
	jalr %zero %ra 0 #214
vecaccumv.2285:
	lw %f0 %a0 0 #219
	lw %f1 %a1 0 #219
	lw %f2 %a2 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a0 0 #219
	lw %f0 %a0 4 #219
	lw %f1 %a1 4 #219
	lw %f2 %a2 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a0 4 #220
	lw %f0 %a0 8 #219
	lw %f1 %a1 8 #219
	lw %f2 %a2 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a0 8 #221
	jalr %zero %ra 0 #221
o_texturetype.2289:
	lw %a0 %a0 0 #228
	jalr %zero %ra 0 #233
o_form.2291:
	lw %a0 %a0 4 #238
	jalr %zero %ra 0 #243
o_reflectiontype.2293:
	lw %a0 %a0 8 #248
	jalr %zero %ra 0 #253
o_isinvert.2295:
	lw %a0 %a0 24 #258
	jalr %zero %ra 0 #262
o_isrot.2297:
	lw %a0 %a0 12 #267
	jalr %zero %ra 0 #271
o_param_a.2299:
	lw %a0 %a0 16 #276
	lw %f0 %a0 0 #281
	jalr %zero %ra 0 #281
o_param_b.2301:
	lw %a0 %a0 16 #286
	lw %f0 %a0 4 #291
	jalr %zero %ra 0 #291
o_param_c.2303:
	lw %a0 %a0 16 #296
	lw %f0 %a0 8 #301
	jalr %zero %ra 0 #301
o_param_abc.2305:
	lw %a0 %a0 16 #306
	jalr %zero %ra 0 #311
o_param_x.2307:
	lw %a0 %a0 20 #316
	lw %f0 %a0 0 #321
	jalr %zero %ra 0 #321
o_param_y.2309:
	lw %a0 %a0 20 #326
	lw %f0 %a0 4 #331
	jalr %zero %ra 0 #331
o_param_z.2311:
	lw %a0 %a0 20 #336
	lw %f0 %a0 8 #341
	jalr %zero %ra 0 #341
o_diffuse.2313:
	lw %a0 %a0 28 #346
	lw %f0 %a0 0 #351
	jalr %zero %ra 0 #351
o_hilight.2315:
	lw %a0 %a0 28 #356
	lw %f0 %a0 4 #361
	jalr %zero %ra 0 #361
o_color_red.2317:
	lw %a0 %a0 32 #366
	lw %f0 %a0 0 #371
	jalr %zero %ra 0 #371
o_color_green.2319:
	lw %a0 %a0 32 #376
	lw %f0 %a0 4 #381
	jalr %zero %ra 0 #381
o_color_blue.2321:
	lw %a0 %a0 32 #386
	lw %f0 %a0 8 #391
	jalr %zero %ra 0 #391
o_param_r1.2323:
	lw %a0 %a0 36 #396
	lw %f0 %a0 0 #401
	jalr %zero %ra 0 #401
o_param_r2.2325:
	lw %a0 %a0 36 #406
	lw %f0 %a0 4 #411
	jalr %zero %ra 0 #411
o_param_r3.2327:
	lw %a0 %a0 36 #416
	lw %f0 %a0 8 #421
	jalr %zero %ra 0 #421
o_param_ctbl.2329:
	lw %a0 %a0 40 #427
	jalr %zero %ra 0 #432
p_rgb.2331:
	lw %a0 %a0 0 #439
	jalr %zero %ra 0 #441
p_intersection_points.2333:
	lw %a0 %a0 4 #446
	jalr %zero %ra 0 #448
p_surface_ids.2335:
	lw %a0 %a0 8 #454
	jalr %zero %ra 0 #456
p_calc_diffuse.2337:
	lw %a0 %a0 12 #461
	jalr %zero %ra 0 #463
p_energy.2339:
	lw %a0 %a0 16 #468
	jalr %zero %ra 0 #470
p_received_ray_20percent.2341:
	lw %a0 %a0 20 #475
	jalr %zero %ra 0 #477
p_group_id.2343:
	lw %a0 %a0 24 #484
	lw %a0 %a0 0 #486
	jalr %zero %ra 0 #486
p_set_group_id.2345:
	lw %a0 %a0 24 #491
	sw %a1 %a0 0 #493
	jalr %zero %ra 0 #493
p_nvectors.2348:
	lw %a0 %a0 28 #498
	jalr %zero %ra 0 #500
d_vec.2350:
	lw %a0 %a0 0 #507
	jalr %zero %ra 0 #508
d_const.2352:
	lw %a0 %a0 4 #513
	jalr %zero %ra 0 #514
r_surface_id.2354:
	lw %a0 %a0 0 #521
	jalr %zero %ra 0 #522
r_dvec.2356:
	lw %a0 %a0 4 #527
	jalr %zero %ra 0 #528
r_bright.2358:
	lw %f0 %a0 8 #533
	jalr %zero %ra 0 #95
rad.2360:
	li %f1 l.5668 #541
	fmul %f0 %f0 %f1 #541
	jalr %zero %ra 0 #541
read_screen_settings.2362:
	lw %a0 %a11 20 #545
	lw %a1 %a11 16 #545
	lw %a2 %a11 12 #545
	lw %a3 %a11 8 #545
	lw %a4 %a11 4 #545
	sw %a0 %sp 0 #548
	sw %a2 %sp 4 #548
	sw %a3 %sp 8 #548
	sw %a1 %sp 12 #548
	sw %a4 %sp 16 #548
	sw %ra %sp 20 #548 call dir
	addi %sp %sp 24 #548	
	jal %ra min_caml_read_float #548
	addi %sp %sp -24 #548
	lw %ra %sp 20 #548
	lw %a0 %sp 16 #548
	sw %f0 %a0 0 #548
	sw %ra %sp 20 #549 call dir
	addi %sp %sp 24 #549	
	jal %ra min_caml_read_float #549
	addi %sp %sp -24 #549
	lw %ra %sp 20 #549
	lw %a0 %sp 16 #549
	sw %f0 %a0 4 #549
	sw %ra %sp 20 #550 call dir
	addi %sp %sp 24 #550	
	jal %ra min_caml_read_float #550
	addi %sp %sp -24 #550
	lw %ra %sp 20 #550
	lw %a0 %sp 16 #550
	sw %f0 %a0 8 #550
	sw %ra %sp 20 #552 call dir
	addi %sp %sp 24 #552	
	jal %ra min_caml_read_float #552
	addi %sp %sp -24 #552
	lw %ra %sp 20 #552
	sw %ra %sp 20 #552 call dir
	addi %sp %sp 24 #552	
	jal %ra rad.2360 #552
	addi %sp %sp -24 #552
	lw %ra %sp 20 #552
	sw %f0 %sp 24 #553
	sw %ra %sp 36 #553 call dir
	addi %sp %sp 40 #553	
	jal %ra min_caml_cos #553
	addi %sp %sp -40 #553
	lw %ra %sp 36 #553
	lw %f1 %sp 24 #554
	sw %f0 %sp 32 #554
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #554 call dir
	addi %sp %sp 48 #554	
	jal %ra min_caml_sin #554
	addi %sp %sp -48 #554
	lw %ra %sp 44 #554
	sw %f0 %sp 40 #555
	sw %ra %sp 52 #555 call dir
	addi %sp %sp 56 #555	
	jal %ra min_caml_read_float #555
	addi %sp %sp -56 #555
	lw %ra %sp 52 #555
	sw %ra %sp 52 #555 call dir
	addi %sp %sp 56 #555	
	jal %ra rad.2360 #555
	addi %sp %sp -56 #555
	lw %ra %sp 52 #555
	sw %f0 %sp 48 #556
	sw %ra %sp 60 #556 call dir
	addi %sp %sp 64 #556	
	jal %ra min_caml_cos #556
	addi %sp %sp -64 #556
	lw %ra %sp 60 #556
	lw %f1 %sp 48 #557
	sw %f0 %sp 56 #557
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #557 call dir
	addi %sp %sp 72 #557	
	jal %ra min_caml_sin #557
	addi %sp %sp -72 #557
	lw %ra %sp 68 #557
	lw %f1 %sp 32 #559
	fmul %f2 %f1 %f0 #559
	li %f3 l.5673 #559
	fmul %f2 %f2 %f3 #559
	lw %a0 %sp 12 #559
	sw %f2 %a0 0 #559
	li %f2 l.5676 #560
	lw %f3 %sp 40 #560
	fmul %f2 %f3 %f2 #560
	sw %f2 %a0 4 #560
	lw %f2 %sp 56 #561
	fmul %f4 %f1 %f2 #561
	li %f5 l.5673 #561
	fmul %f4 %f4 %f5 #561
	sw %f4 %a0 8 #561
	lw %a1 %sp 8 #563
	sw %f2 %a1 0 #563
	li %f4 l.5551 #564
	sw %f4 %a1 4 #564
	sw %f0 %sp 64 #565
	sw %ra %sp 76 #565 call dir
	addi %sp %sp 80 #565	
	jal %ra min_caml_fneg #565
	addi %sp %sp -80 #565
	lw %ra %sp 76 #565
	lw %a0 %sp 8 #565
	sw %f0 %a0 8 #565
	lw %f0 %sp 40 #567
	sw %ra %sp 76 #567 call dir
	addi %sp %sp 80 #567	
	jal %ra min_caml_fneg #567
	addi %sp %sp -80 #567
	lw %ra %sp 76 #567
	lw %f1 %sp 64 #567
	fmul %f0 %f0 %f1 #567
	lw %a0 %sp 4 #567
	sw %f0 %a0 0 #567
	lw %f0 %sp 32 #568
	sw %ra %sp 76 #568 call dir
	addi %sp %sp 80 #568	
	jal %ra min_caml_fneg #568
	addi %sp %sp -80 #568
	lw %ra %sp 76 #568
	lw %a0 %sp 4 #568
	sw %f0 %a0 4 #568
	lw %f0 %sp 40 #569
	sw %ra %sp 76 #569 call dir
	addi %sp %sp 80 #569	
	jal %ra min_caml_fneg #569
	addi %sp %sp -80 #569
	lw %ra %sp 76 #569
	lw %f1 %sp 56 #569
	fmul %f0 %f0 %f1 #569
	lw %a0 %sp 4 #569
	sw %f0 %a0 8 #569
	lw %a0 %sp 16 #23
	lw %f0 %a0 0 #23
	lw %a1 %sp 12 #71
	lw %f1 %a1 0 #71
	fsub %f0 %f0 %f1 #571
	lw %a2 %sp 0 #571
	sw %f0 %a2 0 #571
	lw %f0 %a0 4 #23
	lw %f1 %a1 4 #71
	fsub %f0 %f0 %f1 #572
	sw %f0 %a2 4 #572
	lw %f0 %a0 8 #23
	lw %f1 %a1 8 #71
	fsub %f0 %f0 %f1 #573
	sw %f0 %a2 8 #573
	jalr %zero %ra 0 #573
read_light.2364:
	lw %a0 %a11 8 #578
	lw %a1 %a11 4 #578
	sw %a1 %sp 0 #580
	sw %a0 %sp 4 #580
	sw %ra %sp 12 #580 call dir
	addi %sp %sp 16 #580	
	jal %ra min_caml_read_int #580
	addi %sp %sp -16 #580
	lw %ra %sp 12 #580
	sw %ra %sp 12 #583 call dir
	addi %sp %sp 16 #583	
	jal %ra min_caml_read_float #583
	addi %sp %sp -16 #583
	lw %ra %sp 12 #583
	sw %ra %sp 12 #583 call dir
	addi %sp %sp 16 #583	
	jal %ra rad.2360 #583
	addi %sp %sp -16 #583
	lw %ra %sp 12 #583
	sw %f0 %sp 8 #584
	sw %ra %sp 20 #584 call dir
	addi %sp %sp 24 #584	
	jal %ra min_caml_sin #584
	addi %sp %sp -24 #584
	lw %ra %sp 20 #584
	sw %ra %sp 20 #585 call dir
	addi %sp %sp 24 #585	
	jal %ra min_caml_fneg #585
	addi %sp %sp -24 #585
	lw %ra %sp 20 #585
	lw %a0 %sp 4 #585
	sw %f0 %a0 4 #585
	sw %ra %sp 20 #586 call dir
	addi %sp %sp 24 #586	
	jal %ra min_caml_read_float #586
	addi %sp %sp -24 #586
	lw %ra %sp 20 #586
	sw %ra %sp 20 #586 call dir
	addi %sp %sp 24 #586	
	jal %ra rad.2360 #586
	addi %sp %sp -24 #586
	lw %ra %sp 20 #586
	lw %f1 %sp 8 #587
	sw %f0 %sp 16 #587
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #587 call dir
	addi %sp %sp 32 #587	
	jal %ra min_caml_cos #587
	addi %sp %sp -32 #587
	lw %ra %sp 28 #587
	lw %f1 %sp 16 #588
	sw %f0 %sp 24 #588
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #588 call dir
	addi %sp %sp 40 #588	
	jal %ra min_caml_sin #588
	addi %sp %sp -40 #588
	lw %ra %sp 36 #588
	lw %f1 %sp 24 #589
	fmul %f0 %f1 %f0 #589
	lw %a0 %sp 4 #589
	sw %f0 %a0 0 #589
	lw %f0 %sp 16 #590
	sw %ra %sp 36 #590 call dir
	addi %sp %sp 40 #590	
	jal %ra min_caml_cos #590
	addi %sp %sp -40 #590
	lw %ra %sp 36 #590
	lw %f1 %sp 24 #591
	fmul %f0 %f1 %f0 #591
	lw %a0 %sp 4 #591
	sw %f0 %a0 8 #591
	sw %ra %sp 36 #592 call dir
	addi %sp %sp 40 #592	
	jal %ra min_caml_read_float #592
	addi %sp %sp -40 #592
	lw %ra %sp 36 #592
	lw %a0 %sp 0 #592
	sw %f0 %a0 0 #592
	jalr %zero %ra 0 #592
rotate_quadratic_matrix.2366:
	lw %f0 %a1 0 #602
	sw %a0 %sp 0 #602
	sw %a1 %sp 4 #602
	sw %ra %sp 12 #602 call dir
	addi %sp %sp 16 #602	
	jal %ra min_caml_cos #602
	addi %sp %sp -16 #602
	lw %ra %sp 12 #602
	lw %a0 %sp 4 #602
	lw %f1 %a0 0 #602
	sw %f0 %sp 8 #603
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #603 call dir
	addi %sp %sp 24 #603	
	jal %ra min_caml_sin #603
	addi %sp %sp -24 #603
	lw %ra %sp 20 #603
	lw %a0 %sp 4 #602
	lw %f1 %a0 4 #602
	sw %f0 %sp 16 #604
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #604 call dir
	addi %sp %sp 32 #604	
	jal %ra min_caml_cos #604
	addi %sp %sp -32 #604
	lw %ra %sp 28 #604
	lw %a0 %sp 4 #602
	lw %f1 %a0 4 #602
	sw %f0 %sp 24 #605
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #605 call dir
	addi %sp %sp 40 #605	
	jal %ra min_caml_sin #605
	addi %sp %sp -40 #605
	lw %ra %sp 36 #605
	lw %a0 %sp 4 #602
	lw %f1 %a0 8 #602
	sw %f0 %sp 32 #606
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #606 call dir
	addi %sp %sp 48 #606	
	jal %ra min_caml_cos #606
	addi %sp %sp -48 #606
	lw %ra %sp 44 #606
	lw %a0 %sp 4 #602
	lw %f1 %a0 8 #602
	sw %f0 %sp 40 #607
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #607 call dir
	addi %sp %sp 56 #607	
	jal %ra min_caml_sin #607
	addi %sp %sp -56 #607
	lw %ra %sp 52 #607
	lw %f1 %sp 40 #609
	lw %f2 %sp 24 #609
	fmul %f3 %f2 %f1 #609
	lw %f4 %sp 32 #610
	lw %f5 %sp 16 #610
	fmul %f6 %f5 %f4 #610
	fmul %f6 %f6 %f1 #610
	lw %f7 %sp 8 #610
	fmul %f8 %f7 %f0 #610
	fsub %f6 %f6 %f8 #610
	fmul %f8 %f7 %f4 #611
	fmul %f8 %f8 %f1 #611
	fmul %f9 %f5 %f0 #611
	fadd %f8 %f8 %f9 #611
	fmul %f9 %f2 %f0 #613
	fmul %f10 %f5 %f4 #614
	fmul %f10 %f10 %f0 #614
	fmul %f11 %f7 %f1 #614
	fadd %f10 %f10 %f11 #614
	fmul %f11 %f7 %f4 #615
	fmul %f0 %f11 %f0 #615
	fmul %f1 %f5 %f1 #615
	fsub %f0 %f0 %f1 #615
	sw %f0 %sp 48 #617
	sw %f8 %sp 56 #617
	sw %f10 %sp 64 #617
	sw %f6 %sp 72 #617
	sw %f9 %sp 80 #617
	sw %f3 %sp 88 #617
	fadd %f0 %f4 %fzero
	sw %ra %sp 100 #617 call dir
	addi %sp %sp 104 #617	
	jal %ra min_caml_fneg #617
	addi %sp %sp -104 #617
	lw %ra %sp 100 #617
	lw %f1 %sp 24 #618
	lw %f2 %sp 16 #618
	fmul %f2 %f2 %f1 #618
	lw %f3 %sp 8 #619
	fmul %f1 %f3 %f1 #619
	lw %a0 %sp 0 #622
	lw %f3 %a0 0 #622
	lw %f4 %a0 4 #622
	lw %f5 %a0 8 #622
	lw %f6 %sp 88 #629
	sw %f1 %sp 96 #629
	sw %f2 %sp 104 #629
	sw %f5 %sp 112 #629
	sw %f0 %sp 120 #629
	sw %f4 %sp 128 #629
	sw %f3 %sp 136 #629
	fadd %f0 %f6 %fzero
	sw %ra %sp 148 #629 call dir
	addi %sp %sp 152 #629	
	jal %ra min_caml_fsqr #629
	addi %sp %sp -152 #629
	lw %ra %sp 148 #629
	lw %f1 %sp 136 #629
	fmul %f0 %f1 %f0 #629
	lw %f2 %sp 80 #629
	sw %f0 %sp 144 #629
	fadd %f0 %f2 %fzero
	sw %ra %sp 156 #629 call dir
	addi %sp %sp 160 #629	
	jal %ra min_caml_fsqr #629
	addi %sp %sp -160 #629
	lw %ra %sp 156 #629
	lw %f1 %sp 128 #629
	fmul %f0 %f1 %f0 #629
	lw %f2 %sp 144 #629
	fadd %f0 %f2 %f0 #629
	lw %f2 %sp 120 #629
	sw %f0 %sp 152 #629
	fadd %f0 %f2 %fzero
	sw %ra %sp 164 #629 call dir
	addi %sp %sp 168 #629	
	jal %ra min_caml_fsqr #629
	addi %sp %sp -168 #629
	lw %ra %sp 164 #629
	lw %f1 %sp 112 #629
	fmul %f0 %f1 %f0 #629
	lw %f2 %sp 152 #629
	fadd %f0 %f2 %f0 #629
	lw %a0 %sp 0 #629
	sw %f0 %a0 0 #629
	lw %f0 %sp 72 #630
	sw %ra %sp 164 #630 call dir
	addi %sp %sp 168 #630	
	jal %ra min_caml_fsqr #630
	addi %sp %sp -168 #630
	lw %ra %sp 164 #630
	lw %f1 %sp 136 #630
	fmul %f0 %f1 %f0 #630
	lw %f2 %sp 64 #630
	sw %f0 %sp 160 #630
	fadd %f0 %f2 %fzero
	sw %ra %sp 172 #630 call dir
	addi %sp %sp 176 #630	
	jal %ra min_caml_fsqr #630
	addi %sp %sp -176 #630
	lw %ra %sp 172 #630
	lw %f1 %sp 128 #630
	fmul %f0 %f1 %f0 #630
	lw %f2 %sp 160 #630
	fadd %f0 %f2 %f0 #630
	lw %f2 %sp 104 #630
	sw %f0 %sp 168 #630
	fadd %f0 %f2 %fzero
	sw %ra %sp 180 #630 call dir
	addi %sp %sp 184 #630	
	jal %ra min_caml_fsqr #630
	addi %sp %sp -184 #630
	lw %ra %sp 180 #630
	lw %f1 %sp 112 #630
	fmul %f0 %f1 %f0 #630
	lw %f2 %sp 168 #630
	fadd %f0 %f2 %f0 #630
	lw %a0 %sp 0 #630
	sw %f0 %a0 4 #630
	lw %f0 %sp 56 #631
	sw %ra %sp 180 #631 call dir
	addi %sp %sp 184 #631	
	jal %ra min_caml_fsqr #631
	addi %sp %sp -184 #631
	lw %ra %sp 180 #631
	lw %f1 %sp 136 #631
	fmul %f0 %f1 %f0 #631
	lw %f2 %sp 48 #631
	sw %f0 %sp 176 #631
	fadd %f0 %f2 %fzero
	sw %ra %sp 188 #631 call dir
	addi %sp %sp 192 #631	
	jal %ra min_caml_fsqr #631
	addi %sp %sp -192 #631
	lw %ra %sp 188 #631
	lw %f1 %sp 128 #631
	fmul %f0 %f1 %f0 #631
	lw %f2 %sp 176 #631
	fadd %f0 %f2 %f0 #631
	lw %f2 %sp 96 #631
	sw %f0 %sp 184 #631
	fadd %f0 %f2 %fzero
	sw %ra %sp 196 #631 call dir
	addi %sp %sp 200 #631	
	jal %ra min_caml_fsqr #631
	addi %sp %sp -200 #631
	lw %ra %sp 196 #631
	lw %f1 %sp 112 #631
	fmul %f0 %f1 %f0 #631
	lw %f2 %sp 184 #631
	fadd %f0 %f2 %f0 #631
	lw %a0 %sp 0 #631
	sw %f0 %a0 8 #631
	li %f0 l.5713 #634
	lw %f2 %sp 72 #634
	lw %f3 %sp 136 #634
	fmul %f4 %f3 %f2 #634
	lw %f5 %sp 56 #634
	fmul %f4 %f4 %f5 #634
	lw %f6 %sp 64 #634
	lw %f7 %sp 128 #634
	fmul %f8 %f7 %f6 #634
	lw %f9 %sp 48 #634
	fmul %f8 %f8 %f9 #634
	fadd %f4 %f4 %f8 #634
	lw %f8 %sp 104 #634
	fmul %f10 %f1 %f8 #634
	lw %f11 %sp 96 #634
	fmul %f10 %f10 %f11 #634
	fadd %f4 %f4 %f10 #634
	fmul %f0 %f0 %f4 #634
	lw %a0 %sp 4 #634
	sw %f0 %a0 0 #634
	li %f0 l.5713 #635
	lw %f4 %sp 88 #635
	fmul %f10 %f3 %f4 #635
	fmul %f5 %f10 %f5 #635
	lw %f10 %sp 80 #635
	fmul %f8 %f7 %f10 #635
	fmul %f8 %f8 %f9 #635
	fadd %f5 %f5 %f8 #635
	lw %f8 %sp 120 #635
	fmul %f9 %f1 %f8 #635
	fmul %f9 %f9 %f11 #635
	fadd %f5 %f5 %f9 #635
	fmul %f0 %f0 %f5 #635
	sw %f0 %a0 4 #635
	li %f0 l.5713 #636
	fmul %f3 %f3 %f4 #636
	fmul %f2 %f3 %f2 #636
	fmul %f3 %f7 %f10 #636
	fmul %f3 %f3 %f6 #636
	fadd %f2 %f2 %f3 #636
	fmul %f1 %f1 %f8 #636
	lw %f3 %sp 104 #636
	fmul %f1 %f1 %f3 #636
	fadd %f1 %f2 %f1 #636
	fmul %f0 %f0 %f1 #636
	sw %f0 %a0 8 #636
	jalr %zero %ra 0 #636
read_nth_object.2369:
	lw %a1 %a11 4 #641
	sw %a1 %sp 0 #643
	sw %a0 %sp 4 #643
	sw %ra %sp 12 #643 call dir
	addi %sp %sp 16 #643	
	jal %ra min_caml_read_int #643
	addi %sp %sp -16 #643
	lw %ra %sp 12 #643
	addi %a1 %zero 1 #644
	sub %a1 %zero %a1 #644
	bne %a0 %a1 beq_else.8475
	addi %a0 %zero 0 #720
	jalr %zero %ra 0 #720
beq_else.8475:
	sw %a0 %sp 8 #646
	sw %ra %sp 12 #646 call dir
	addi %sp %sp 16 #646	
	jal %ra min_caml_read_int #646
	addi %sp %sp -16 #646
	lw %ra %sp 12 #646
	sw %a0 %sp 12 #647
	sw %ra %sp 20 #647 call dir
	addi %sp %sp 24 #647	
	jal %ra min_caml_read_int #647
	addi %sp %sp -24 #647
	lw %ra %sp 20 #647
	sw %a0 %sp 16 #648
	sw %ra %sp 20 #648 call dir
	addi %sp %sp 24 #648	
	jal %ra min_caml_read_int #648
	addi %sp %sp -24 #648
	lw %ra %sp 20 #648
	addi %a1 %zero 3 #650
	li %f0 l.5551 #650
	sw %a0 %sp 20 #650
	add %a0 %a1 %zero
	sw %ra %sp 28 #650 call dir
	addi %sp %sp 32 #650	
	jal %ra min_caml_create_float_array #650
	addi %sp %sp -32 #650
	lw %ra %sp 28 #650
	sw %a0 %sp 24 #651
	sw %ra %sp 28 #651 call dir
	addi %sp %sp 32 #651	
	jal %ra min_caml_read_float #651
	addi %sp %sp -32 #651
	lw %ra %sp 28 #651
	lw %a0 %sp 24 #651
	sw %f0 %a0 0 #651
	sw %ra %sp 28 #652 call dir
	addi %sp %sp 32 #652	
	jal %ra min_caml_read_float #652
	addi %sp %sp -32 #652
	lw %ra %sp 28 #652
	lw %a0 %sp 24 #652
	sw %f0 %a0 4 #652
	sw %ra %sp 28 #653 call dir
	addi %sp %sp 32 #653	
	jal %ra min_caml_read_float #653
	addi %sp %sp -32 #653
	lw %ra %sp 28 #653
	lw %a0 %sp 24 #653
	sw %f0 %a0 8 #653
	addi %a1 %zero 3 #655
	li %f0 l.5551 #655
	add %a0 %a1 %zero
	sw %ra %sp 28 #655 call dir
	addi %sp %sp 32 #655	
	jal %ra min_caml_create_float_array #655
	addi %sp %sp -32 #655
	lw %ra %sp 28 #655
	sw %a0 %sp 28 #656
	sw %ra %sp 36 #656 call dir
	addi %sp %sp 40 #656	
	jal %ra min_caml_read_float #656
	addi %sp %sp -40 #656
	lw %ra %sp 36 #656
	lw %a0 %sp 28 #656
	sw %f0 %a0 0 #656
	sw %ra %sp 36 #657 call dir
	addi %sp %sp 40 #657	
	jal %ra min_caml_read_float #657
	addi %sp %sp -40 #657
	lw %ra %sp 36 #657
	lw %a0 %sp 28 #657
	sw %f0 %a0 4 #657
	sw %ra %sp 36 #658 call dir
	addi %sp %sp 40 #658	
	jal %ra min_caml_read_float #658
	addi %sp %sp -40 #658
	lw %ra %sp 36 #658
	lw %a0 %sp 28 #658
	sw %f0 %a0 8 #658
	sw %ra %sp 36 #660 call dir
	addi %sp %sp 40 #660	
	jal %ra min_caml_read_float #660
	addi %sp %sp -40 #660
	lw %ra %sp 36 #660
	sw %ra %sp 36 #660 call dir
	addi %sp %sp 40 #660	
	jal %ra min_caml_fisneg #660
	addi %sp %sp -40 #660
	lw %ra %sp 36 #660
	addi %a1 %zero 2 #662
	li %f0 l.5551 #662
	sw %a0 %sp 32 #662
	add %a0 %a1 %zero
	sw %ra %sp 36 #662 call dir
	addi %sp %sp 40 #662	
	jal %ra min_caml_create_float_array #662
	addi %sp %sp -40 #662
	lw %ra %sp 36 #662
	sw %a0 %sp 36 #663
	sw %ra %sp 44 #663 call dir
	addi %sp %sp 48 #663	
	jal %ra min_caml_read_float #663
	addi %sp %sp -48 #663
	lw %ra %sp 44 #663
	lw %a0 %sp 36 #663
	sw %f0 %a0 0 #663
	sw %ra %sp 44 #664 call dir
	addi %sp %sp 48 #664	
	jal %ra min_caml_read_float #664
	addi %sp %sp -48 #664
	lw %ra %sp 44 #664
	lw %a0 %sp 36 #664
	sw %f0 %a0 4 #664
	addi %a1 %zero 3 #666
	li %f0 l.5551 #666
	add %a0 %a1 %zero
	sw %ra %sp 44 #666 call dir
	addi %sp %sp 48 #666	
	jal %ra min_caml_create_float_array #666
	addi %sp %sp -48 #666
	lw %ra %sp 44 #666
	sw %a0 %sp 40 #667
	sw %ra %sp 44 #667 call dir
	addi %sp %sp 48 #667	
	jal %ra min_caml_read_float #667
	addi %sp %sp -48 #667
	lw %ra %sp 44 #667
	lw %a0 %sp 40 #667
	sw %f0 %a0 0 #667
	sw %ra %sp 44 #668 call dir
	addi %sp %sp 48 #668	
	jal %ra min_caml_read_float #668
	addi %sp %sp -48 #668
	lw %ra %sp 44 #668
	lw %a0 %sp 40 #668
	sw %f0 %a0 4 #668
	sw %ra %sp 44 #669 call dir
	addi %sp %sp 48 #669	
	jal %ra min_caml_read_float #669
	addi %sp %sp -48 #669
	lw %ra %sp 44 #669
	lw %a0 %sp 40 #669
	sw %f0 %a0 8 #669
	addi %a1 %zero 3 #671
	li %f0 l.5551 #671
	add %a0 %a1 %zero
	sw %ra %sp 44 #671 call dir
	addi %sp %sp 48 #671	
	jal %ra min_caml_create_float_array #671
	addi %sp %sp -48 #671
	lw %ra %sp 44 #671
	lw %a1 %sp 20 #644
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8476 # nontail if
	jal %zero beq_cont.8477 # then sentence ends
beq_else.8476:
	sw %a0 %sp 44 #674
	sw %ra %sp 52 #674 call dir
	addi %sp %sp 56 #674	
	jal %ra min_caml_read_float #674
	addi %sp %sp -56 #674
	lw %ra %sp 52 #674
	sw %ra %sp 52 #674 call dir
	addi %sp %sp 56 #674	
	jal %ra rad.2360 #674
	addi %sp %sp -56 #674
	lw %ra %sp 52 #674
	lw %a0 %sp 44 #674
	sw %f0 %a0 0 #674
	sw %ra %sp 52 #675 call dir
	addi %sp %sp 56 #675	
	jal %ra min_caml_read_float #675
	addi %sp %sp -56 #675
	lw %ra %sp 52 #675
	sw %ra %sp 52 #675 call dir
	addi %sp %sp 56 #675	
	jal %ra rad.2360 #675
	addi %sp %sp -56 #675
	lw %ra %sp 52 #675
	lw %a0 %sp 44 #675
	sw %f0 %a0 4 #675
	sw %ra %sp 52 #676 call dir
	addi %sp %sp 56 #676	
	jal %ra min_caml_read_float #676
	addi %sp %sp -56 #676
	lw %ra %sp 52 #676
	sw %ra %sp 52 #676 call dir
	addi %sp %sp 56 #676	
	jal %ra rad.2360 #676
	addi %sp %sp -56 #676
	lw %ra %sp 52 #676
	lw %a0 %sp 44 #676
	sw %f0 %a0 8 #676
beq_cont.8477:
	lw %a1 %sp 12 #644
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8478 # nontail if
	addi %a2 %zero 1 #683
	jal %zero beq_cont.8479 # then sentence ends
beq_else.8478:
	lw %a2 %sp 32 #683
beq_cont.8479:
	addi %a3 %zero 4 #684
	li %f0 l.5551 #684
	sw %a2 %sp 48 #684
	sw %a0 %sp 44 #684
	add %a0 %a3 %zero
	sw %ra %sp 52 #684 call dir
	addi %sp %sp 56 #684	
	jal %ra min_caml_create_float_array #684
	addi %sp %sp -56 #684
	lw %ra %sp 52 #684
	addi %a1 %min_caml_hp 0 #687
	addi %min_caml_hp %min_caml_hp 48 #687
	sw %a0 %a1 40 #687
	lw %a0 %sp 44 #687
	sw %a0 %a1 36 #687
	lw %a2 %sp 40 #687
	sw %a2 %a1 32 #687
	lw %a2 %sp 36 #687
	sw %a2 %a1 28 #687
	lw %a2 %sp 48 #687
	sw %a2 %a1 24 #687
	lw %a2 %sp 28 #687
	sw %a2 %a1 20 #687
	lw %a2 %sp 24 #687
	sw %a2 %a1 16 #687
	lw %a3 %sp 20 #687
	sw %a3 %a1 12 #687
	lw %a4 %sp 16 #687
	sw %a4 %a1 8 #687
	lw %a4 %sp 12 #687
	sw %a4 %a1 4 #687
	lw %a5 %sp 8 #687
	sw %a5 %a1 0 #687
	lw %a5 %sp 4 #695
	slli %a5 %a5 2 #695
	lw %a6 %sp 0 #695
	add %a12 %a6 %a5 #695
	sw %a1 %a12 0 #695
	addi %a12 %zero 3
	bne %a4 %a12 beq_else.8480 # nontail if
	lw %f0 %a2 0 #650
	sw %f0 %sp 56 #701
	sw %ra %sp 68 #701 call dir
	addi %sp %sp 72 #701	
	jal %ra min_caml_fiszero #701
	addi %sp %sp -72 #701
	lw %ra %sp 68 #701
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8483 # nontail if
	lw %f0 %sp 56 #701
	sw %ra %sp 68 #701 call dir
	addi %sp %sp 72 #701	
	jal %ra sgn.2235 #701
	addi %sp %sp -72 #701
	lw %ra %sp 68 #701
	lw %f1 %sp 56 #701
	sw %f0 %sp 64 #701
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #701 call dir
	addi %sp %sp 80 #701	
	jal %ra min_caml_fsqr #701
	addi %sp %sp -80 #701
	lw %ra %sp 76 #701
	lw %f1 %sp 64 #701
	fdiv %f0 %f1 %f0 #701
	jal %zero beq_cont.8484 # then sentence ends
beq_else.8483:
	li %f0 l.5551 #701
beq_cont.8484:
	lw %a0 %sp 24 #701
	sw %f0 %a0 0 #701
	lw %f0 %a0 4 #650
	sw %f0 %sp 72 #703
	sw %ra %sp 84 #703 call dir
	addi %sp %sp 88 #703	
	jal %ra min_caml_fiszero #703
	addi %sp %sp -88 #703
	lw %ra %sp 84 #703
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8485 # nontail if
	lw %f0 %sp 72 #703
	sw %ra %sp 84 #703 call dir
	addi %sp %sp 88 #703	
	jal %ra sgn.2235 #703
	addi %sp %sp -88 #703
	lw %ra %sp 84 #703
	lw %f1 %sp 72 #703
	sw %f0 %sp 80 #703
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #703 call dir
	addi %sp %sp 96 #703	
	jal %ra min_caml_fsqr #703
	addi %sp %sp -96 #703
	lw %ra %sp 92 #703
	lw %f1 %sp 80 #703
	fdiv %f0 %f1 %f0 #703
	jal %zero beq_cont.8486 # then sentence ends
beq_else.8485:
	li %f0 l.5551 #703
beq_cont.8486:
	lw %a0 %sp 24 #703
	sw %f0 %a0 4 #703
	lw %f0 %a0 8 #650
	sw %f0 %sp 88 #705
	sw %ra %sp 100 #705 call dir
	addi %sp %sp 104 #705	
	jal %ra min_caml_fiszero #705
	addi %sp %sp -104 #705
	lw %ra %sp 100 #705
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8487 # nontail if
	lw %f0 %sp 88 #705
	sw %ra %sp 100 #705 call dir
	addi %sp %sp 104 #705	
	jal %ra sgn.2235 #705
	addi %sp %sp -104 #705
	lw %ra %sp 100 #705
	lw %f1 %sp 88 #705
	sw %f0 %sp 96 #705
	fadd %f0 %f1 %fzero
	sw %ra %sp 108 #705 call dir
	addi %sp %sp 112 #705	
	jal %ra min_caml_fsqr #705
	addi %sp %sp -112 #705
	lw %ra %sp 108 #705
	lw %f1 %sp 96 #705
	fdiv %f0 %f1 %f0 #705
	jal %zero beq_cont.8488 # then sentence ends
beq_else.8487:
	li %f0 l.5551 #705
beq_cont.8488:
	lw %a0 %sp 24 #705
	sw %f0 %a0 8 #705
	jal %zero beq_cont.8481 # then sentence ends
beq_else.8480:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.8489 # nontail if
	addi %a1 %zero 0 #709
	lw %a4 %sp 32 #683
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.8491 # nontail if
	addi %a1 %zero 1 #709
	jal %zero beq_cont.8492 # then sentence ends
beq_else.8491:
beq_cont.8492:
	add %a0 %a2 %zero
	sw %ra %sp 108 #709 call dir
	addi %sp %sp 112 #709	
	jal %ra vecunit_sgn.2261 #709
	addi %sp %sp -112 #709
	lw %ra %sp 108 #709
	jal %zero beq_cont.8490 # then sentence ends
beq_else.8489:
beq_cont.8490:
beq_cont.8481:
	lw %a0 %sp 20 #644
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8493 # nontail if
	jal %zero beq_cont.8494 # then sentence ends
beq_else.8493:
	lw %a0 %sp 24 #714
	lw %a1 %sp 44 #714
	sw %ra %sp 108 #714 call dir
	addi %sp %sp 112 #714	
	jal %ra rotate_quadratic_matrix.2366 #714
	addi %sp %sp -112 #714
	lw %ra %sp 108 #714
beq_cont.8494:
	addi %a0 %zero 1 #717
	jalr %zero %ra 0 #717
read_object.2371:
	lw %a1 %a11 8 #724
	lw %a2 %a11 4 #724
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.8495
	jalr %zero %ra 0 #730
bge_else.8495:
	sw %a11 %sp 0 #726
	sw %a2 %sp 4 #726
	sw %a0 %sp 8 #726
	add %a11 %a1 %zero
	sw %ra %sp 12 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 16 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -16 #726
	lw %ra %sp 12 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8497
	lw %a0 %sp 4 #729
	lw %a1 %sp 8 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.8497:
	lw %a0 %sp 8 #727
	addi %a0 %a0 1 #727
	lw %a11 %sp 0 #727
	lw %a10 %a11 0 #727
	jalr %zero %a10 0 #727
read_all_object.2373:
	lw %a11 %a11 4 #733
	addi %a0 %zero 0 #734
	lw %a10 %a11 0 #734
	jalr %zero %a10 0 #734
read_net_item.2375:
	sw %a0 %sp 0 #741
	sw %ra %sp 4 #741 call dir
	addi %sp %sp 8 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -8 #741
	lw %ra %sp 4 #741
	addi %a1 %zero 1 #742
	sub %a1 %zero %a1 #742
	bne %a0 %a1 beq_else.8499
	lw %a0 %sp 0 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero 1 #742
	sub %a1 %zero %a1 #742
	jal	%zero min_caml_create_array
beq_else.8499:
	lw %a1 %sp 0 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 4 #744
	add %a0 %a2 %zero
	sw %ra %sp 12 #744 call dir
	addi %sp %sp 16 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -16 #744
	lw %ra %sp 12 #744
	lw %a1 %sp 0 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 4 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
	jalr %zero %ra 0 #745
read_or_network.2377:
	addi %a1 %zero 0 #749
	sw %a0 %sp 0 #749
	add %a0 %a1 %zero
	sw %ra %sp 4 #749 call dir
	addi %sp %sp 8 #749	
	jal %ra read_net_item.2375 #749
	addi %sp %sp -8 #749
	lw %ra %sp 4 #749
	add %a1 %a0 %zero #749
	lw %a0 %a1 0 #745
	addi %a2 %zero 1 #750
	sub %a2 %zero %a2 #750
	bne %a0 %a2 beq_else.8500
	lw %a0 %sp 0 #751
	addi %a0 %a0 1 #751
	jal	%zero min_caml_create_array
beq_else.8500:
	lw %a0 %sp 0 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 4 #753
	add %a0 %a2 %zero
	sw %ra %sp 12 #753 call dir
	addi %sp %sp 16 #753	
	jal %ra read_or_network.2377 #753
	addi %sp %sp -16 #753
	lw %ra %sp 12 #753
	lw %a1 %sp 0 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 4 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
	jalr %zero %ra 0 #754
read_and_network.2379:
	lw %a1 %a11 4 #757
	addi %a2 %zero 0 #758
	sw %a11 %sp 0 #758
	sw %a1 %sp 4 #758
	sw %a0 %sp 8 #758
	add %a0 %a2 %zero
	sw %ra %sp 12 #758 call dir
	addi %sp %sp 16 #758	
	jal %ra read_net_item.2375 #758
	addi %sp %sp -16 #758
	lw %ra %sp 12 #758
	lw %a1 %a0 0 #745
	addi %a2 %zero 1 #759
	sub %a2 %zero %a2 #759
	bne %a1 %a2 beq_else.8501
	jalr %zero %ra 0 #759
beq_else.8501:
	lw %a1 %sp 8 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	lw %a11 %sp 0 #762
	lw %a10 %a11 0 #762
	jalr %zero %a10 0 #762
read_parameter.2381:
	lw %a0 %a11 20 #766
	lw %a1 %a11 16 #766
	lw %a2 %a11 12 #766
	lw %a3 %a11 8 #766
	lw %a4 %a11 4 #766
	sw %a4 %sp 0 #768
	sw %a2 %sp 4 #768
	sw %a3 %sp 8 #768
	sw %a1 %sp 12 #768
	add %a11 %a0 %zero
	sw %ra %sp 20 #768 call cls
	lw %a10 %a11 0 #768
	addi %sp %sp 24 #768	
	jalr %ra %a10 0 #768
	addi %sp %sp -24 #768
	lw %ra %sp 20 #768
	lw %a11 %sp 12 #769
	sw %ra %sp 20 #769 call cls
	lw %a10 %a11 0 #769
	addi %sp %sp 24 #769	
	jalr %ra %a10 0 #769
	addi %sp %sp -24 #769
	lw %ra %sp 20 #769
	lw %a11 %sp 8 #770
	sw %ra %sp 20 #770 call cls
	lw %a10 %a11 0 #770
	addi %sp %sp 24 #770	
	jalr %ra %a10 0 #770
	addi %sp %sp -24 #770
	lw %ra %sp 20 #770
	addi %a0 %zero 0 #771
	lw %a11 %sp 4 #771
	sw %ra %sp 20 #771 call cls
	lw %a10 %a11 0 #771
	addi %sp %sp 24 #771	
	jalr %ra %a10 0 #771
	addi %sp %sp -24 #771
	lw %ra %sp 20 #771
	addi %a0 %zero 0 #772
	sw %ra %sp 20 #772 call dir
	addi %sp %sp 24 #772	
	jal %ra read_or_network.2377 #772
	addi %sp %sp -24 #772
	lw %ra %sp 20 #772
	lw %a1 %sp 0 #772
	sw %a0 %a1 0 #772
	jalr %zero %ra 0 #772
solver_rect_surface.2383:
	lw %a5 %a11 4 #782
	slli %a6 %a2 2 #783
	add %a12 %a1 %a6 #783
	lw %f3 %a12 0 #783
	sw %a5 %sp 0 #783
	sw %f2 %sp 8 #783
	sw %a4 %sp 16 #783
	sw %f1 %sp 24 #783
	sw %a3 %sp 32 #783
	sw %f0 %sp 40 #783
	sw %a1 %sp 48 #783
	sw %a2 %sp 52 #783
	sw %a0 %sp 56 #783
	fadd %f0 %f3 %fzero
	sw %ra %sp 60 #783 call dir
	addi %sp %sp 64 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -64 #783
	lw %ra %sp 60 #783
	addi %a1 %zero 0 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8507
	lw %a0 %sp 56 #784
	sw %a1 %sp 60 #784
	sw %ra %sp 68 #784 call dir
	addi %sp %sp 72 #784	
	jal %ra o_param_abc.2305 #784
	addi %sp %sp -72 #784
	lw %ra %sp 68 #784
	lw %a1 %sp 56 #785
	sw %a0 %sp 64 #785
	add %a0 %a1 %zero
	sw %ra %sp 68 #785 call dir
	addi %sp %sp 72 #785	
	jal %ra o_isinvert.2295 #785
	addi %sp %sp -72 #785
	lw %ra %sp 68 #785
	lw %a1 %sp 52 #783
	slli %a2 %a1 2 #783
	lw %a3 %sp 48 #783
	add %a12 %a3 %a2 #783
	lw %f0 %a12 0 #783
	sw %a0 %sp 68 #785
	sw %ra %sp 76 #785 call dir
	addi %sp %sp 80 #785	
	jal %ra min_caml_fisneg #785
	addi %sp %sp -80 #785
	lw %ra %sp 76 #785
	add %a1 %a0 %zero #785
	lw %a0 %sp 68 #785
	sw %ra %sp 76 #785 call dir
	addi %sp %sp 80 #785	
	jal %ra xor.2232 #785
	addi %sp %sp -80 #785
	lw %ra %sp 76 #785
	lw %a1 %sp 52 #785
	slli %a2 %a1 2 #785
	lw %a3 %sp 64 #785
	add %a12 %a3 %a2 #785
	lw %f0 %a12 0 #785
	sw %ra %sp 76 #785 call dir
	addi %sp %sp 80 #785	
	jal %ra fneg_cond.2237 #785
	addi %sp %sp -80 #785
	lw %ra %sp 76 #785
	lw %f1 %sp 40 #787
	fsub %f0 %f0 %f1 #787
	lw %a0 %sp 52 #783
	slli %a0 %a0 2 #783
	lw %a1 %sp 48 #783
	add %a12 %a1 %a0 #783
	lw %f1 %a12 0 #783
	fdiv %f0 %f0 %f1 #787
	lw %a0 %sp 32 #783
	slli %a2 %a0 2 #783
	add %a12 %a1 %a2 #783
	lw %f1 %a12 0 #783
	fmul %f1 %f0 %f1 #788
	lw %f2 %sp 24 #788
	fadd %f1 %f1 %f2 #788
	sw %f0 %sp 72 #788
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #788 call dir
	addi %sp %sp 88 #788	
	jal %ra min_caml_fabs #788
	addi %sp %sp -88 #788
	lw %ra %sp 84 #788
	lw %a0 %sp 32 #785
	slli %a0 %a0 2 #785
	lw %a1 %sp 64 #785
	add %a12 %a1 %a0 #785
	lw %f1 %a12 0 #785
	sw %ra %sp 84 #788 call dir
	addi %sp %sp 88 #788	
	jal %ra min_caml_fless #788
	addi %sp %sp -88 #788
	lw %ra %sp 84 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8508
	lw %a0 %sp 60 #783
	jalr %zero %ra 0 #783
beq_else.8508:
	lw %a0 %sp 16 #783
	slli %a1 %a0 2 #783
	lw %a2 %sp 48 #783
	add %a12 %a2 %a1 #783
	lw %f0 %a12 0 #783
	lw %f1 %sp 72 #789
	fmul %f0 %f1 %f0 #789
	lw %f2 %sp 8 #789
	fadd %f0 %f0 %f2 #789
	sw %ra %sp 84 #789 call dir
	addi %sp %sp 88 #789	
	jal %ra min_caml_fabs #789
	addi %sp %sp -88 #789
	lw %ra %sp 84 #789
	lw %a0 %sp 16 #785
	slli %a0 %a0 2 #785
	lw %a1 %sp 64 #785
	add %a12 %a1 %a0 #785
	lw %f1 %a12 0 #785
	sw %ra %sp 84 #789 call dir
	addi %sp %sp 88 #789	
	jal %ra min_caml_fless #789
	addi %sp %sp -88 #789
	lw %ra %sp 84 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8509
	lw %a0 %sp 60 #783
	jalr %zero %ra 0 #783
beq_else.8509:
	lw %a0 %sp 0 #790
	lw %f0 %sp 72 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
	jalr %zero %ra 0 #790
beq_else.8507:
	addi %a0 %a1 0 #783
	jalr %zero %ra 0 #783
solver_rect.2392:
	lw %a11 %a11 4 #797
	addi %a2 %zero 0 #798
	addi %a3 %zero 1 #798
	addi %a4 %zero 2 #798
	sw %f0 %sp 0 #798
	sw %f2 %sp 8 #798
	sw %f1 %sp 16 #798
	sw %a1 %sp 24 #798
	sw %a0 %sp 28 #798
	sw %a11 %sp 32 #798
	sw %ra %sp 36 #798 call cls
	lw %a10 %a11 0 #798
	addi %sp %sp 40 #798	
	jalr %ra %a10 0 #798
	addi %sp %sp -40 #798
	lw %ra %sp 36 #798
	addi %a4 %zero 0 #798
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8510
	addi %a2 %zero 1 #799
	addi %a3 %zero 2 #799
	lw %f0 %sp 16 #799
	lw %f1 %sp 8 #799
	lw %f2 %sp 0 #799
	lw %a0 %sp 28 #799
	lw %a1 %sp 24 #799
	lw %a11 %sp 32 #799
	sw %a4 %sp 36 #799
	sw %ra %sp 44 #799 call cls
	lw %a10 %a11 0 #799
	addi %sp %sp 48 #799	
	jalr %ra %a10 0 #799
	addi %sp %sp -48 #799
	lw %ra %sp 44 #799
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8511
	addi %a2 %zero 2 #800
	addi %a4 %zero 1 #800
	lw %f0 %sp 8 #800
	lw %f1 %sp 0 #800
	lw %f2 %sp 16 #800
	lw %a0 %sp 28 #800
	lw %a1 %sp 24 #800
	lw %a3 %sp 36 #800
	lw %a11 %sp 32 #800
	sw %ra %sp 44 #800 call cls
	lw %a10 %a11 0 #800
	addi %sp %sp 48 #800	
	jalr %ra %a10 0 #800
	addi %sp %sp -48 #800
	lw %ra %sp 44 #800
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8512
	lw %a0 %sp 36 #798
	jalr %zero %ra 0 #798
beq_else.8512:
	addi %a0 %zero 3 #800
	jalr %zero %ra 0 #800
beq_else.8511:
	addi %a0 %zero 2 #799
	jalr %zero %ra 0 #799
beq_else.8510:
	addi %a0 %zero 1 #798
	jalr %zero %ra 0 #798
solver_surface.2398:
	lw %a2 %a11 4 #806
	sw %a2 %sp 0 #809
	sw %f2 %sp 8 #809
	sw %f1 %sp 16 #809
	sw %f0 %sp 24 #809
	sw %a1 %sp 32 #809
	sw %ra %sp 36 #809 call dir
	addi %sp %sp 40 #809	
	jal %ra o_param_abc.2305 #809
	addi %sp %sp -40 #809
	lw %ra %sp 36 #809
	add %a1 %a0 %zero #809
	lw %a0 %sp 32 #810
	sw %a1 %sp 36 #810
	sw %ra %sp 44 #810 call dir
	addi %sp %sp 48 #810	
	jal %ra veciprod.2264 #810
	addi %sp %sp -48 #810
	lw %ra %sp 44 #810
	sw %f0 %sp 40 #811
	sw %ra %sp 52 #811 call dir
	addi %sp %sp 56 #811	
	jal %ra min_caml_fispos #811
	addi %sp %sp -56 #811
	lw %ra %sp 52 #811
	addi %a1 %zero 0 #811
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8514
	addi %a0 %a1 0 #811
	jalr %zero %ra 0 #811
beq_else.8514:
	lw %f0 %sp 24 #812
	lw %f1 %sp 16 #812
	lw %f2 %sp 8 #812
	lw %a0 %sp 36 #812
	sw %ra %sp 52 #812 call dir
	addi %sp %sp 56 #812	
	jal %ra veciprod2.2267 #812
	addi %sp %sp -56 #812
	lw %ra %sp 52 #812
	sw %ra %sp 52 #812 call dir
	addi %sp %sp 56 #812	
	jal %ra min_caml_fneg #812
	addi %sp %sp -56 #812
	lw %ra %sp 52 #812
	lw %f1 %sp 40 #812
	fdiv %f0 %f0 %f1 #812
	lw %a0 %sp 0 #812
	sw %f0 %a0 0 #812
	addi %a0 %zero 1 #813
	jalr %zero %ra 0 #813
quadratic.2404:
	sw %f0 %sp 0 #822
	sw %f2 %sp 8 #822
	sw %f1 %sp 16 #822
	sw %a0 %sp 24 #822
	sw %ra %sp 28 #822 call dir
	addi %sp %sp 32 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -32 #822
	lw %ra %sp 28 #822
	lw %a0 %sp 24 #822
	sw %f0 %sp 32 #822
	sw %ra %sp 44 #822 call dir
	addi %sp %sp 48 #822	
	jal %ra o_param_a.2299 #822
	addi %sp %sp -48 #822
	lw %ra %sp 44 #822
	lw %f1 %sp 32 #822
	fmul %f0 %f1 %f0 #822
	lw %f1 %sp 16 #822
	sw %f0 %sp 40 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #822 call dir
	addi %sp %sp 56 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -56 #822
	lw %ra %sp 52 #822
	lw %a0 %sp 24 #822
	sw %f0 %sp 48 #822
	sw %ra %sp 60 #822 call dir
	addi %sp %sp 64 #822	
	jal %ra o_param_b.2301 #822
	addi %sp %sp -64 #822
	lw %ra %sp 60 #822
	lw %f1 %sp 48 #822
	fmul %f0 %f1 %f0 #822
	lw %f1 %sp 40 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 8 #822
	sw %f0 %sp 56 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #822 call dir
	addi %sp %sp 72 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -72 #822
	lw %ra %sp 68 #822
	lw %a0 %sp 24 #822
	sw %f0 %sp 64 #822
	sw %ra %sp 76 #822 call dir
	addi %sp %sp 80 #822	
	jal %ra o_param_c.2303 #822
	addi %sp %sp -80 #822
	lw %ra %sp 76 #822
	lw %f1 %sp 64 #822
	fmul %f0 %f1 %f0 #822
	lw %f1 %sp 56 #822
	fadd %f0 %f1 %f0 #822
	lw %a0 %sp 24 #824
	sw %f0 %sp 72 #824
	sw %ra %sp 84 #824 call dir
	addi %sp %sp 88 #824	
	jal %ra o_isrot.2297 #824
	addi %sp %sp -88 #824
	lw %ra %sp 84 #824
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8516
	lw %f0 %sp 72 #822
	jalr %zero %ra 0 #822
beq_else.8516:
	lw %f0 %sp 8 #828
	lw %f1 %sp 16 #828
	fmul %f2 %f1 %f0 #828
	lw %a0 %sp 24 #828
	sw %f2 %sp 80 #828
	sw %ra %sp 92 #828 call dir
	addi %sp %sp 96 #828	
	jal %ra o_param_r1.2323 #828
	addi %sp %sp -96 #828
	lw %ra %sp 92 #828
	lw %f1 %sp 80 #828
	fmul %f0 %f1 %f0 #828
	lw %f1 %sp 72 #827
	fadd %f0 %f1 %f0 #827
	lw %f1 %sp 0 #829
	lw %f2 %sp 8 #829
	fmul %f2 %f2 %f1 #829
	lw %a0 %sp 24 #829
	sw %f0 %sp 88 #829
	sw %f2 %sp 96 #829
	sw %ra %sp 108 #829 call dir
	addi %sp %sp 112 #829	
	jal %ra o_param_r2.2325 #829
	addi %sp %sp -112 #829
	lw %ra %sp 108 #829
	lw %f1 %sp 96 #829
	fmul %f0 %f1 %f0 #829
	lw %f1 %sp 88 #827
	fadd %f0 %f1 %f0 #827
	lw %f1 %sp 16 #830
	lw %f2 %sp 0 #830
	fmul %f1 %f2 %f1 #830
	lw %a0 %sp 24 #830
	sw %f0 %sp 104 #830
	sw %f1 %sp 112 #830
	sw %ra %sp 124 #830 call dir
	addi %sp %sp 128 #830	
	jal %ra o_param_r3.2327 #830
	addi %sp %sp -128 #830
	lw %ra %sp 124 #830
	lw %f1 %sp 112 #830
	fmul %f0 %f1 %f0 #830
	lw %f1 %sp 104 #827
	fadd %f0 %f1 %f0 #827
	jalr %zero %ra 0 #827
bilinear.2409:
	fmul %f6 %f0 %f3 #837
	sw %f3 %sp 0 #837
	sw %f0 %sp 8 #837
	sw %f5 %sp 16 #837
	sw %f2 %sp 24 #837
	sw %a0 %sp 32 #837
	sw %f4 %sp 40 #837
	sw %f1 %sp 48 #837
	sw %f6 %sp 56 #837
	sw %ra %sp 68 #837 call dir
	addi %sp %sp 72 #837	
	jal %ra o_param_a.2299 #837
	addi %sp %sp -72 #837
	lw %ra %sp 68 #837
	lw %f1 %sp 56 #837
	fmul %f0 %f1 %f0 #837
	lw %f1 %sp 40 #838
	lw %f2 %sp 48 #838
	fmul %f3 %f2 %f1 #838
	lw %a0 %sp 32 #838
	sw %f0 %sp 64 #838
	sw %f3 %sp 72 #838
	sw %ra %sp 84 #838 call dir
	addi %sp %sp 88 #838	
	jal %ra o_param_b.2301 #838
	addi %sp %sp -88 #838
	lw %ra %sp 84 #838
	lw %f1 %sp 72 #838
	fmul %f0 %f1 %f0 #838
	lw %f1 %sp 64 #837
	fadd %f0 %f1 %f0 #837
	lw %f1 %sp 16 #839
	lw %f2 %sp 24 #839
	fmul %f3 %f2 %f1 #839
	lw %a0 %sp 32 #839
	sw %f0 %sp 80 #839
	sw %f3 %sp 88 #839
	sw %ra %sp 100 #839 call dir
	addi %sp %sp 104 #839	
	jal %ra o_param_c.2303 #839
	addi %sp %sp -104 #839
	lw %ra %sp 100 #839
	lw %f1 %sp 88 #839
	fmul %f0 %f1 %f0 #839
	lw %f1 %sp 80 #837
	fadd %f0 %f1 %f0 #837
	lw %a0 %sp 32 #841
	sw %f0 %sp 96 #841
	sw %ra %sp 108 #841 call dir
	addi %sp %sp 112 #841	
	jal %ra o_isrot.2297 #841
	addi %sp %sp -112 #841
	lw %ra %sp 108 #841
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8518
	lw %f0 %sp 96 #837
	jalr %zero %ra 0 #837
beq_else.8518:
	lw %f0 %sp 40 #845
	lw %f1 %sp 24 #845
	fmul %f2 %f1 %f0 #845
	lw %f3 %sp 16 #845
	lw %f4 %sp 48 #845
	fmul %f5 %f4 %f3 #845
	fadd %f2 %f2 %f5 #845
	lw %a0 %sp 32 #845
	sw %f2 %sp 104 #845
	sw %ra %sp 116 #845 call dir
	addi %sp %sp 120 #845	
	jal %ra o_param_r1.2323 #845
	addi %sp %sp -120 #845
	lw %ra %sp 116 #845
	lw %f1 %sp 104 #845
	fmul %f0 %f1 %f0 #845
	lw %f1 %sp 16 #846
	lw %f2 %sp 8 #846
	fmul %f1 %f2 %f1 #846
	lw %f3 %sp 0 #846
	lw %f4 %sp 24 #846
	fmul %f4 %f4 %f3 #846
	fadd %f1 %f1 %f4 #846
	lw %a0 %sp 32 #846
	sw %f0 %sp 112 #846
	sw %f1 %sp 120 #846
	sw %ra %sp 132 #846 call dir
	addi %sp %sp 136 #846	
	jal %ra o_param_r2.2325 #846
	addi %sp %sp -136 #846
	lw %ra %sp 132 #846
	lw %f1 %sp 120 #846
	fmul %f0 %f1 %f0 #846
	lw %f1 %sp 112 #845
	fadd %f0 %f1 %f0 #845
	lw %f1 %sp 40 #847
	lw %f2 %sp 8 #847
	fmul %f1 %f2 %f1 #847
	lw %f2 %sp 0 #847
	lw %f3 %sp 48 #847
	fmul %f2 %f3 %f2 #847
	fadd %f1 %f1 %f2 #847
	lw %a0 %sp 32 #847
	sw %f0 %sp 128 #847
	sw %f1 %sp 136 #847
	sw %ra %sp 148 #847 call dir
	addi %sp %sp 152 #847	
	jal %ra o_param_r3.2327 #847
	addi %sp %sp -152 #847
	lw %ra %sp 148 #847
	lw %f1 %sp 136 #847
	fmul %f0 %f1 %f0 #847
	lw %f1 %sp 128 #845
	fadd %f0 %f1 %f0 #845
	sw %ra %sp 148 #844 call dir
	addi %sp %sp 152 #844	
	jal %ra min_caml_fhalf #844
	addi %sp %sp -152 #844
	lw %ra %sp 148 #844
	lw %f1 %sp 96 #844
	fadd %f0 %f1 %f0 #844
	jalr %zero %ra 0 #844
solver_second.2417:
	lw %a2 %a11 4 #854
	lw %f3 %a1 0 #858
	lw %f4 %a1 4 #858
	lw %f5 %a1 8 #858
	sw %a2 %sp 0 #858
	sw %f2 %sp 8 #858
	sw %f1 %sp 16 #858
	sw %f0 %sp 24 #858
	sw %a0 %sp 32 #858
	sw %a1 %sp 36 #858
	fadd %f2 %f5 %fzero
	fadd %f1 %f4 %fzero
	fadd %f0 %f3 %fzero
	sw %ra %sp 44 #858 call dir
	addi %sp %sp 48 #858	
	jal %ra quadratic.2404 #858
	addi %sp %sp -48 #858
	lw %ra %sp 44 #858
	sw %f0 %sp 40 #860
	sw %ra %sp 52 #860 call dir
	addi %sp %sp 56 #860	
	jal %ra min_caml_fiszero #860
	addi %sp %sp -56 #860
	lw %ra %sp 52 #860
	addi %a1 %zero 0 #860
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8520
	lw %a0 %sp 36 #858
	lw %f0 %a0 0 #858
	lw %f1 %a0 4 #858
	lw %f2 %a0 8 #858
	lw %f3 %sp 24 #865
	lw %f4 %sp 16 #865
	lw %f5 %sp 8 #865
	lw %a0 %sp 32 #865
	sw %a1 %sp 48 #865
	sw %ra %sp 52 #865 call dir
	addi %sp %sp 56 #865	
	jal %ra bilinear.2409 #865
	addi %sp %sp -56 #865
	lw %ra %sp 52 #865
	lw %f1 %sp 24 #867
	lw %f2 %sp 16 #867
	lw %f3 %sp 8 #867
	lw %a0 %sp 32 #867
	sw %f0 %sp 56 #867
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 68 #867 call dir
	addi %sp %sp 72 #867	
	jal %ra quadratic.2404 #867
	addi %sp %sp -72 #867
	lw %ra %sp 68 #867
	lw %a0 %sp 32 #868
	sw %f0 %sp 64 #868
	sw %ra %sp 76 #868 call dir
	addi %sp %sp 80 #868	
	jal %ra o_form.2291 #868
	addi %sp %sp -80 #868
	lw %ra %sp 76 #868
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8522 # nontail if
	li %f0 l.5553 #868
	lw %f1 %sp 64 #868
	fsub %f0 %f1 %f0 #868
	jal %zero beq_cont.8523 # then sentence ends
beq_else.8522:
	lw %f0 %sp 64 #822
beq_cont.8523:
	lw %f1 %sp 56 #870
	sw %f0 %sp 72 #870
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #870 call dir
	addi %sp %sp 88 #870	
	jal %ra min_caml_fsqr #870
	addi %sp %sp -88 #870
	lw %ra %sp 84 #870
	lw %f1 %sp 72 #870
	lw %f2 %sp 40 #870
	fmul %f1 %f2 %f1 #870
	fsub %f0 %f0 %f1 #870
	sw %f0 %sp 80 #872
	sw %ra %sp 92 #872 call dir
	addi %sp %sp 96 #872	
	jal %ra min_caml_fispos #872
	addi %sp %sp -96 #872
	lw %ra %sp 92 #872
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8524
	lw %a0 %sp 48 #860
	jalr %zero %ra 0 #860
beq_else.8524:
	lw %f0 %sp 80 #873
	sw %ra %sp 92 #873 call dir
	addi %sp %sp 96 #873	
	jal %ra min_caml_sqrt #873
	addi %sp %sp -96 #873
	lw %ra %sp 92 #873
	lw %a0 %sp 32 #874
	sw %f0 %sp 88 #874
	sw %ra %sp 100 #874 call dir
	addi %sp %sp 104 #874	
	jal %ra o_isinvert.2295 #874
	addi %sp %sp -104 #874
	lw %ra %sp 100 #874
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8525 # nontail if
	lw %f0 %sp 88 #874
	sw %ra %sp 100 #874 call dir
	addi %sp %sp 104 #874	
	jal %ra min_caml_fneg #874
	addi %sp %sp -104 #874
	lw %ra %sp 100 #874
	jal %zero beq_cont.8526 # then sentence ends
beq_else.8525:
	lw %f0 %sp 88 #164
beq_cont.8526:
	lw %f1 %sp 56 #875
	fsub %f0 %f0 %f1 #875
	lw %f1 %sp 40 #875
	fdiv %f0 %f0 %f1 #875
	lw %a0 %sp 0 #875
	sw %f0 %a0 0 #875
	addi %a0 %zero 1 #875
	jalr %zero %ra 0 #875
beq_else.8520:
	addi %a0 %a1 0 #860
	jalr %zero %ra 0 #860
solver.2423:
	lw %a3 %a11 16 #883
	lw %a4 %a11 12 #883
	lw %a5 %a11 8 #883
	lw %a6 %a11 4 #883
	slli %a0 %a0 2 #20
	add %a12 %a6 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %a2 0 #886
	sw %a4 %sp 0 #886
	sw %a3 %sp 4 #886
	sw %a1 %sp 8 #886
	sw %a5 %sp 12 #886
	sw %a0 %sp 16 #886
	sw %a2 %sp 20 #886
	sw %f0 %sp 24 #886
	sw %ra %sp 36 #886 call dir
	addi %sp %sp 40 #886	
	jal %ra o_param_x.2307 #886
	addi %sp %sp -40 #886
	lw %ra %sp 36 #886
	lw %f1 %sp 24 #886
	fsub %f0 %f1 %f0 #886
	lw %a0 %sp 20 #886
	lw %f1 %a0 4 #886
	lw %a1 %sp 16 #887
	sw %f0 %sp 32 #887
	sw %f1 %sp 40 #887
	add %a0 %a1 %zero
	sw %ra %sp 52 #887 call dir
	addi %sp %sp 56 #887	
	jal %ra o_param_y.2309 #887
	addi %sp %sp -56 #887
	lw %ra %sp 52 #887
	lw %f1 %sp 40 #887
	fsub %f0 %f1 %f0 #887
	lw %a0 %sp 20 #886
	lw %f1 %a0 8 #886
	lw %a0 %sp 16 #888
	sw %f0 %sp 48 #888
	sw %f1 %sp 56 #888
	sw %ra %sp 68 #888 call dir
	addi %sp %sp 72 #888	
	jal %ra o_param_z.2311 #888
	addi %sp %sp -72 #888
	lw %ra %sp 68 #888
	lw %f1 %sp 56 #888
	fsub %f0 %f1 %f0 #888
	lw %a0 %sp 16 #889
	sw %f0 %sp 64 #889
	sw %ra %sp 76 #889 call dir
	addi %sp %sp 80 #889	
	jal %ra o_form.2291 #889
	addi %sp %sp -80 #889
	lw %ra %sp 76 #889
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8527
	lw %f0 %sp 32 #891
	lw %f1 %sp 48 #891
	lw %f2 %sp 64 #891
	lw %a0 %sp 16 #891
	lw %a1 %sp 8 #891
	lw %a11 %sp 12 #891
	lw %a10 %a11 0 #891
	jalr %zero %a10 0 #891
beq_else.8527:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8528
	lw %f0 %sp 32 #892
	lw %f1 %sp 48 #892
	lw %f2 %sp 64 #892
	lw %a0 %sp 16 #892
	lw %a1 %sp 8 #892
	lw %a11 %sp 4 #892
	lw %a10 %a11 0 #892
	jalr %zero %a10 0 #892
beq_else.8528:
	lw %f0 %sp 32 #893
	lw %f1 %sp 48 #893
	lw %f2 %sp 64 #893
	lw %a0 %sp 16 #893
	lw %a1 %sp 8 #893
	lw %a11 %sp 0 #893
	lw %a10 %a11 0 #893
	jalr %zero %a10 0 #893
solver_rect_fast.2427:
	lw %a3 %a11 4 #900
	lw %f3 %a2 0 #901
	fsub %f3 %f3 %f0 #901
	lw %f4 %a2 4 #901
	fmul %f3 %f3 %f4 #901
	lw %f4 %a1 4 #903
	fmul %f4 %f3 %f4 #903
	fadd %f4 %f4 %f1 #903
	sw %a3 %sp 0 #903
	sw %f0 %sp 8 #903
	sw %f1 %sp 16 #903
	sw %a2 %sp 24 #903
	sw %f2 %sp 32 #903
	sw %f3 %sp 40 #903
	sw %a1 %sp 48 #903
	sw %a0 %sp 52 #903
	fadd %f0 %f4 %fzero
	sw %ra %sp 60 #903 call dir
	addi %sp %sp 64 #903	
	jal %ra min_caml_fabs #903
	addi %sp %sp -64 #903
	lw %ra %sp 60 #903
	lw %a0 %sp 52 #903
	sw %f0 %sp 56 #903
	sw %ra %sp 68 #903 call dir
	addi %sp %sp 72 #903	
	jal %ra o_param_b.2301 #903
	addi %sp %sp -72 #903
	lw %ra %sp 68 #903
	fadd %f1 %f0 %fzero #903
	lw %f0 %sp 56 #903
	sw %ra %sp 68 #903 call dir
	addi %sp %sp 72 #903	
	jal %ra min_caml_fless #903
	addi %sp %sp -72 #903
	lw %ra %sp 68 #903
	addi %a1 %zero 0 #903
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8531 # nontail if
	addi %a0 %a1 0 #903
	jal %zero beq_cont.8532 # then sentence ends
beq_else.8531:
	lw %a0 %sp 48 #903
	lw %f0 %a0 8 #903
	lw %f1 %sp 40 #904
	fmul %f0 %f1 %f0 #904
	lw %f2 %sp 32 #904
	fadd %f0 %f0 %f2 #904
	sw %a1 %sp 64 #904
	sw %ra %sp 68 #904 call dir
	addi %sp %sp 72 #904	
	jal %ra min_caml_fabs #904
	addi %sp %sp -72 #904
	lw %ra %sp 68 #904
	lw %a0 %sp 52 #904
	sw %f0 %sp 72 #904
	sw %ra %sp 84 #904 call dir
	addi %sp %sp 88 #904	
	jal %ra o_param_c.2303 #904
	addi %sp %sp -88 #904
	lw %ra %sp 84 #904
	fadd %f1 %f0 %fzero #904
	lw %f0 %sp 72 #904
	sw %ra %sp 84 #904 call dir
	addi %sp %sp 88 #904	
	jal %ra min_caml_fless #904
	addi %sp %sp -88 #904
	lw %ra %sp 84 #904
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8534 # nontail if
	lw %a0 %sp 64 #903
	jal %zero beq_cont.8535 # then sentence ends
beq_else.8534:
	lw %a0 %sp 24 #901
	lw %f0 %a0 4 #901
	sw %ra %sp 84 #905 call dir
	addi %sp %sp 88 #905	
	jal %ra min_caml_fiszero #905
	addi %sp %sp -88 #905
	lw %ra %sp 84 #905
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8536 # nontail if
	addi %a0 %zero 1 #905
	jal %zero beq_cont.8537 # then sentence ends
beq_else.8536:
	lw %a0 %sp 64 #903
beq_cont.8537:
beq_cont.8535:
beq_cont.8532:
	addi %a1 %zero 0 #902
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8538
	lw %a0 %sp 24 #901
	lw %f0 %a0 8 #901
	lw %f1 %sp 16 #910
	fsub %f0 %f0 %f1 #910
	lw %f2 %a0 12 #901
	fmul %f0 %f0 %f2 #910
	lw %a2 %sp 48 #903
	lw %f2 %a2 0 #903
	fmul %f2 %f0 %f2 #912
	lw %f3 %sp 8 #912
	fadd %f2 %f2 %f3 #912
	sw %f0 %sp 80 #912
	sw %a1 %sp 88 #912
	fadd %f0 %f2 %fzero
	sw %ra %sp 92 #912 call dir
	addi %sp %sp 96 #912	
	jal %ra min_caml_fabs #912
	addi %sp %sp -96 #912
	lw %ra %sp 92 #912
	lw %a0 %sp 52 #912
	sw %f0 %sp 96 #912
	sw %ra %sp 108 #912 call dir
	addi %sp %sp 112 #912	
	jal %ra o_param_a.2299 #912
	addi %sp %sp -112 #912
	lw %ra %sp 108 #912
	fadd %f1 %f0 %fzero #912
	lw %f0 %sp 96 #912
	sw %ra %sp 108 #912 call dir
	addi %sp %sp 112 #912	
	jal %ra min_caml_fless #912
	addi %sp %sp -112 #912
	lw %ra %sp 108 #912
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8540 # nontail if
	lw %a0 %sp 88 #902
	jal %zero beq_cont.8541 # then sentence ends
beq_else.8540:
	lw %a0 %sp 48 #903
	lw %f0 %a0 8 #903
	lw %f1 %sp 80 #913
	fmul %f0 %f1 %f0 #913
	lw %f2 %sp 32 #913
	fadd %f0 %f0 %f2 #913
	sw %ra %sp 108 #913 call dir
	addi %sp %sp 112 #913	
	jal %ra min_caml_fabs #913
	addi %sp %sp -112 #913
	lw %ra %sp 108 #913
	lw %a0 %sp 52 #913
	sw %f0 %sp 104 #913
	sw %ra %sp 116 #913 call dir
	addi %sp %sp 120 #913	
	jal %ra o_param_c.2303 #913
	addi %sp %sp -120 #913
	lw %ra %sp 116 #913
	fadd %f1 %f0 %fzero #913
	lw %f0 %sp 104 #913
	sw %ra %sp 116 #913 call dir
	addi %sp %sp 120 #913	
	jal %ra min_caml_fless #913
	addi %sp %sp -120 #913
	lw %ra %sp 116 #913
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8542 # nontail if
	lw %a0 %sp 88 #902
	jal %zero beq_cont.8543 # then sentence ends
beq_else.8542:
	lw %a0 %sp 24 #901
	lw %f0 %a0 12 #901
	sw %ra %sp 116 #914 call dir
	addi %sp %sp 120 #914	
	jal %ra min_caml_fiszero #914
	addi %sp %sp -120 #914
	lw %ra %sp 116 #914
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8544 # nontail if
	addi %a0 %zero 1 #914
	jal %zero beq_cont.8545 # then sentence ends
beq_else.8544:
	lw %a0 %sp 88 #902
beq_cont.8545:
beq_cont.8543:
beq_cont.8541:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8546
	lw %a0 %sp 24 #901
	lw %f0 %a0 16 #901
	lw %f1 %sp 32 #919
	fsub %f0 %f0 %f1 #919
	lw %f1 %a0 20 #901
	fmul %f0 %f0 %f1 #919
	lw %a1 %sp 48 #903
	lw %f1 %a1 0 #903
	fmul %f1 %f0 %f1 #921
	lw %f2 %sp 8 #921
	fadd %f1 %f1 %f2 #921
	sw %f0 %sp 112 #921
	fadd %f0 %f1 %fzero
	sw %ra %sp 124 #921 call dir
	addi %sp %sp 128 #921	
	jal %ra min_caml_fabs #921
	addi %sp %sp -128 #921
	lw %ra %sp 124 #921
	lw %a0 %sp 52 #921
	sw %f0 %sp 120 #921
	sw %ra %sp 132 #921 call dir
	addi %sp %sp 136 #921	
	jal %ra o_param_a.2299 #921
	addi %sp %sp -136 #921
	lw %ra %sp 132 #921
	fadd %f1 %f0 %fzero #921
	lw %f0 %sp 120 #921
	sw %ra %sp 132 #921 call dir
	addi %sp %sp 136 #921	
	jal %ra min_caml_fless #921
	addi %sp %sp -136 #921
	lw %ra %sp 132 #921
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8547 # nontail if
	lw %a0 %sp 88 #902
	jal %zero beq_cont.8548 # then sentence ends
beq_else.8547:
	lw %a0 %sp 48 #903
	lw %f0 %a0 4 #903
	lw %f1 %sp 112 #922
	fmul %f0 %f1 %f0 #922
	lw %f2 %sp 16 #922
	fadd %f0 %f0 %f2 #922
	sw %ra %sp 132 #922 call dir
	addi %sp %sp 136 #922	
	jal %ra min_caml_fabs #922
	addi %sp %sp -136 #922
	lw %ra %sp 132 #922
	lw %a0 %sp 52 #922
	sw %f0 %sp 128 #922
	sw %ra %sp 140 #922 call dir
	addi %sp %sp 144 #922	
	jal %ra o_param_b.2301 #922
	addi %sp %sp -144 #922
	lw %ra %sp 140 #922
	fadd %f1 %f0 %fzero #922
	lw %f0 %sp 128 #922
	sw %ra %sp 140 #922 call dir
	addi %sp %sp 144 #922	
	jal %ra min_caml_fless #922
	addi %sp %sp -144 #922
	lw %ra %sp 140 #922
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8549 # nontail if
	lw %a0 %sp 88 #902
	jal %zero beq_cont.8550 # then sentence ends
beq_else.8549:
	lw %a0 %sp 24 #901
	lw %f0 %a0 20 #901
	sw %ra %sp 140 #923 call dir
	addi %sp %sp 144 #923	
	jal %ra min_caml_fiszero #923
	addi %sp %sp -144 #923
	lw %ra %sp 140 #923
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8551 # nontail if
	addi %a0 %zero 1 #923
	jal %zero beq_cont.8552 # then sentence ends
beq_else.8551:
	lw %a0 %sp 88 #902
beq_cont.8552:
beq_cont.8550:
beq_cont.8548:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8553
	lw %a0 %sp 88 #902
	jalr %zero %ra 0 #902
beq_else.8553:
	lw %a0 %sp 0 #927
	lw %f0 %sp 112 #927
	sw %f0 %a0 0 #927
	addi %a0 %zero 3 #927
	jalr %zero %ra 0 #927
beq_else.8546:
	lw %a0 %sp 0 #918
	lw %f0 %sp 80 #918
	sw %f0 %a0 0 #918
	addi %a0 %zero 2 #918
	jalr %zero %ra 0 #918
beq_else.8538:
	lw %a0 %sp 0 #909
	lw %f0 %sp 40 #909
	sw %f0 %a0 0 #909
	addi %a0 %zero 1 #909
	jalr %zero %ra 0 #909
solver_surface_fast.2434:
	lw %a0 %a11 4 #933
	lw %f3 %a1 0 #934
	sw %a0 %sp 0 #934
	sw %f2 %sp 8 #934
	sw %f1 %sp 16 #934
	sw %f0 %sp 24 #934
	sw %a1 %sp 32 #934
	fadd %f0 %f3 %fzero
	sw %ra %sp 36 #934 call dir
	addi %sp %sp 40 #934	
	jal %ra min_caml_fisneg #934
	addi %sp %sp -40 #934
	lw %ra %sp 36 #934
	addi %a1 %zero 0 #934
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8555
	addi %a0 %a1 0 #934
	jalr %zero %ra 0 #934
beq_else.8555:
	lw %a0 %sp 32 #934
	lw %f0 %a0 4 #934
	lw %f1 %sp 24 #936
	fmul %f0 %f0 %f1 #936
	lw %f1 %a0 8 #934
	lw %f2 %sp 16 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a0 12 #934
	lw %f2 %sp 8 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a0 %sp 0 #935
	sw %f0 %a0 0 #935
	addi %a0 %zero 1 #937
	jalr %zero %ra 0 #937
solver_second_fast.2440:
	lw %a2 %a11 4 #942
	lw %f3 %a1 0 #944
	sw %a2 %sp 0 #945
	sw %f3 %sp 8 #945
	sw %a0 %sp 16 #945
	sw %f2 %sp 24 #945
	sw %f1 %sp 32 #945
	sw %f0 %sp 40 #945
	sw %a1 %sp 48 #945
	fadd %f0 %f3 %fzero
	sw %ra %sp 52 #945 call dir
	addi %sp %sp 56 #945	
	jal %ra min_caml_fiszero #945
	addi %sp %sp -56 #945
	lw %ra %sp 52 #945
	addi %a1 %zero 0 #945
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8558
	lw %a0 %sp 48 #944
	lw %f0 %a0 4 #944
	lw %f1 %sp 40 #948
	fmul %f0 %f0 %f1 #948
	lw %f2 %a0 8 #944
	lw %f3 %sp 32 #948
	fmul %f2 %f2 %f3 #948
	fadd %f0 %f0 %f2 #948
	lw %f2 %a0 12 #944
	lw %f4 %sp 24 #948
	fmul %f2 %f2 %f4 #948
	fadd %f0 %f0 %f2 #948
	lw %a2 %sp 16 #949
	sw %a1 %sp 52 #949
	sw %f0 %sp 56 #949
	add %a0 %a2 %zero
	fadd %f2 %f4 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f3 %fzero
	sw %ra %sp 68 #949 call dir
	addi %sp %sp 72 #949	
	jal %ra quadratic.2404 #949
	addi %sp %sp -72 #949
	lw %ra %sp 68 #949
	lw %a0 %sp 16 #950
	sw %f0 %sp 64 #950
	sw %ra %sp 76 #950 call dir
	addi %sp %sp 80 #950	
	jal %ra o_form.2291 #950
	addi %sp %sp -80 #950
	lw %ra %sp 76 #950
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8559 # nontail if
	li %f0 l.5553 #950
	lw %f1 %sp 64 #950
	fsub %f0 %f1 %f0 #950
	jal %zero beq_cont.8560 # then sentence ends
beq_else.8559:
	lw %f0 %sp 64 #822
beq_cont.8560:
	lw %f1 %sp 56 #951
	sw %f0 %sp 72 #951
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #951 call dir
	addi %sp %sp 88 #951	
	jal %ra min_caml_fsqr #951
	addi %sp %sp -88 #951
	lw %ra %sp 84 #951
	lw %f1 %sp 72 #951
	lw %f2 %sp 8 #951
	fmul %f1 %f2 %f1 #951
	fsub %f0 %f0 %f1 #951
	sw %f0 %sp 80 #952
	sw %ra %sp 92 #952 call dir
	addi %sp %sp 96 #952	
	jal %ra min_caml_fispos #952
	addi %sp %sp -96 #952
	lw %ra %sp 92 #952
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8561
	lw %a0 %sp 52 #945
	jalr %zero %ra 0 #945
beq_else.8561:
	lw %a0 %sp 16 #953
	sw %ra %sp 92 #953 call dir
	addi %sp %sp 96 #953	
	jal %ra o_isinvert.2295 #953
	addi %sp %sp -96 #953
	lw %ra %sp 92 #953
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8562 # nontail if
	lw %f0 %sp 80 #956
	sw %ra %sp 92 #956 call dir
	addi %sp %sp 96 #956	
	jal %ra min_caml_sqrt #956
	addi %sp %sp -96 #956
	lw %ra %sp 92 #956
	lw %f1 %sp 56 #956
	fsub %f0 %f1 %f0 #956
	lw %a0 %sp 48 #944
	lw %f1 %a0 16 #944
	fmul %f0 %f0 %f1 #956
	lw %a0 %sp 0 #956
	sw %f0 %a0 0 #956
	jal %zero beq_cont.8563 # then sentence ends
beq_else.8562:
	lw %f0 %sp 80 #954
	sw %ra %sp 92 #954 call dir
	addi %sp %sp 96 #954	
	jal %ra min_caml_sqrt #954
	addi %sp %sp -96 #954
	lw %ra %sp 92 #954
	lw %f1 %sp 56 #954
	fadd %f0 %f1 %f0 #954
	lw %a0 %sp 48 #944
	lw %f1 %a0 16 #944
	fmul %f0 %f0 %f1 #954
	lw %a0 %sp 0 #954
	sw %f0 %a0 0 #954
beq_cont.8563:
	addi %a0 %zero 1 #957
	jalr %zero %ra 0 #957
beq_else.8558:
	addi %a0 %a1 0 #945
	jalr %zero %ra 0 #945
solver_fast.2446:
	lw %a3 %a11 16 #962
	lw %a4 %a11 12 #962
	lw %a5 %a11 8 #962
	lw %a6 %a11 4 #962
	slli %a7 %a0 2 #20
	add %a12 %a6 %a7 #20
	lw %a6 %a12 0 #20
	lw %f0 %a2 0 #964
	sw %a4 %sp 0 #964
	sw %a3 %sp 4 #964
	sw %a5 %sp 8 #964
	sw %a0 %sp 12 #964
	sw %a1 %sp 16 #964
	sw %a6 %sp 20 #964
	sw %a2 %sp 24 #964
	sw %f0 %sp 32 #964
	add %a0 %a6 %zero
	sw %ra %sp 44 #964 call dir
	addi %sp %sp 48 #964	
	jal %ra o_param_x.2307 #964
	addi %sp %sp -48 #964
	lw %ra %sp 44 #964
	lw %f1 %sp 32 #964
	fsub %f0 %f1 %f0 #964
	lw %a0 %sp 24 #964
	lw %f1 %a0 4 #964
	lw %a1 %sp 20 #965
	sw %f0 %sp 40 #965
	sw %f1 %sp 48 #965
	add %a0 %a1 %zero
	sw %ra %sp 60 #965 call dir
	addi %sp %sp 64 #965	
	jal %ra o_param_y.2309 #965
	addi %sp %sp -64 #965
	lw %ra %sp 60 #965
	lw %f1 %sp 48 #965
	fsub %f0 %f1 %f0 #965
	lw %a0 %sp 24 #964
	lw %f1 %a0 8 #964
	lw %a0 %sp 20 #966
	sw %f0 %sp 56 #966
	sw %f1 %sp 64 #966
	sw %ra %sp 76 #966 call dir
	addi %sp %sp 80 #966	
	jal %ra o_param_z.2311 #966
	addi %sp %sp -80 #966
	lw %ra %sp 76 #966
	lw %f1 %sp 64 #966
	fsub %f0 %f1 %f0 #966
	lw %a0 %sp 16 #967
	sw %f0 %sp 72 #967
	sw %ra %sp 84 #967 call dir
	addi %sp %sp 88 #967	
	jal %ra d_const.2352 #967
	addi %sp %sp -88 #967
	lw %ra %sp 84 #967
	lw %a1 %sp 12 #968
	slli %a1 %a1 2 #968
	add %a12 %a0 %a1 #968
	lw %a0 %a12 0 #968
	lw %a1 %sp 20 #969
	sw %a0 %sp 80 #969
	add %a0 %a1 %zero
	sw %ra %sp 84 #969 call dir
	addi %sp %sp 88 #969	
	jal %ra o_form.2291 #969
	addi %sp %sp -88 #969
	lw %ra %sp 84 #969
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8565
	lw %a0 %sp 16 #971
	sw %ra %sp 84 #971 call dir
	addi %sp %sp 88 #971	
	jal %ra d_vec.2350 #971
	addi %sp %sp -88 #971
	lw %ra %sp 84 #971
	add %a1 %a0 %zero #971
	lw %f0 %sp 40 #971
	lw %f1 %sp 56 #971
	lw %f2 %sp 72 #971
	lw %a0 %sp 20 #971
	lw %a2 %sp 80 #971
	lw %a11 %sp 8 #971
	lw %a10 %a11 0 #971
	jalr %zero %a10 0 #971
beq_else.8565:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8566
	lw %f0 %sp 40 #973
	lw %f1 %sp 56 #973
	lw %f2 %sp 72 #973
	lw %a0 %sp 20 #973
	lw %a1 %sp 80 #973
	lw %a11 %sp 4 #973
	lw %a10 %a11 0 #973
	jalr %zero %a10 0 #973
beq_else.8566:
	lw %f0 %sp 40 #975
	lw %f1 %sp 56 #975
	lw %f2 %sp 72 #975
	lw %a0 %sp 20 #975
	lw %a1 %sp 80 #975
	lw %a11 %sp 0 #975
	lw %a10 %a11 0 #975
	jalr %zero %a10 0 #975
solver_surface_fast2.2450:
	lw %a0 %a11 4 #982
	lw %f0 %a1 0 #983
	sw %a0 %sp 0 #983
	sw %a2 %sp 4 #983
	sw %a1 %sp 8 #983
	sw %ra %sp 12 #983 call dir
	addi %sp %sp 16 #983	
	jal %ra min_caml_fisneg #983
	addi %sp %sp -16 #983
	lw %ra %sp 12 #983
	addi %a1 %zero 0 #983
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8567
	addi %a0 %a1 0 #983
	jalr %zero %ra 0 #983
beq_else.8567:
	lw %a0 %sp 8 #983
	lw %f0 %a0 0 #983
	lw %a0 %sp 4 #984
	lw %f1 %a0 12 #984
	fmul %f0 %f0 %f1 #984
	lw %a0 %sp 0 #984
	sw %f0 %a0 0 #984
	addi %a0 %zero 1 #985
	jalr %zero %ra 0 #985
solver_second_fast2.2457:
	lw %a3 %a11 4 #990
	lw %f3 %a1 0 #992
	sw %a3 %sp 0 #993
	sw %a0 %sp 4 #993
	sw %f3 %sp 8 #993
	sw %a2 %sp 16 #993
	sw %f2 %sp 24 #993
	sw %f1 %sp 32 #993
	sw %f0 %sp 40 #993
	sw %a1 %sp 48 #993
	fadd %f0 %f3 %fzero
	sw %ra %sp 52 #993 call dir
	addi %sp %sp 56 #993	
	jal %ra min_caml_fiszero #993
	addi %sp %sp -56 #993
	lw %ra %sp 52 #993
	addi %a1 %zero 0 #993
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8569
	lw %a0 %sp 48 #992
	lw %f0 %a0 4 #992
	lw %f1 %sp 40 #996
	fmul %f0 %f0 %f1 #996
	lw %f1 %a0 8 #992
	lw %f2 %sp 32 #996
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a0 12 #992
	lw %f2 %sp 24 #996
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %a2 %sp 16 #997
	lw %f1 %a2 12 #997
	sw %f0 %sp 56 #998
	sw %a1 %sp 64 #998
	sw %f1 %sp 72 #998
	sw %ra %sp 84 #998 call dir
	addi %sp %sp 88 #998	
	jal %ra min_caml_fsqr #998
	addi %sp %sp -88 #998
	lw %ra %sp 84 #998
	lw %f1 %sp 72 #998
	lw %f2 %sp 8 #998
	fmul %f1 %f2 %f1 #998
	fsub %f0 %f0 %f1 #998
	sw %f0 %sp 80 #999
	sw %ra %sp 92 #999 call dir
	addi %sp %sp 96 #999	
	jal %ra min_caml_fispos #999
	addi %sp %sp -96 #999
	lw %ra %sp 92 #999
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8572
	lw %a0 %sp 64 #993
	jalr %zero %ra 0 #993
beq_else.8572:
	lw %a0 %sp 4 #1000
	sw %ra %sp 92 #1000 call dir
	addi %sp %sp 96 #1000	
	jal %ra o_isinvert.2295 #1000
	addi %sp %sp -96 #1000
	lw %ra %sp 92 #1000
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8573 # nontail if
	lw %f0 %sp 80 #1003
	sw %ra %sp 92 #1003 call dir
	addi %sp %sp 96 #1003	
	jal %ra min_caml_sqrt #1003
	addi %sp %sp -96 #1003
	lw %ra %sp 92 #1003
	lw %f1 %sp 56 #1003
	fsub %f0 %f1 %f0 #1003
	lw %a0 %sp 48 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1003
	lw %a0 %sp 0 #1003
	sw %f0 %a0 0 #1003
	jal %zero beq_cont.8574 # then sentence ends
beq_else.8573:
	lw %f0 %sp 80 #1001
	sw %ra %sp 92 #1001 call dir
	addi %sp %sp 96 #1001	
	jal %ra min_caml_sqrt #1001
	addi %sp %sp -96 #1001
	lw %ra %sp 92 #1001
	lw %f1 %sp 56 #1001
	fadd %f0 %f1 %f0 #1001
	lw %a0 %sp 48 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1001
	lw %a0 %sp 0 #1001
	sw %f0 %a0 0 #1001
beq_cont.8574:
	addi %a0 %zero 1 #1004
	jalr %zero %ra 0 #1004
beq_else.8569:
	addi %a0 %a1 0 #993
	jalr %zero %ra 0 #993
solver_fast2.2464:
	lw %a2 %a11 16 #1009
	lw %a3 %a11 12 #1009
	lw %a4 %a11 8 #1009
	lw %a5 %a11 4 #1009
	slli %a6 %a0 2 #20
	add %a12 %a5 %a6 #20
	lw %a5 %a12 0 #20
	sw %a3 %sp 0 #1011
	sw %a2 %sp 4 #1011
	sw %a4 %sp 8 #1011
	sw %a5 %sp 12 #1011
	sw %a0 %sp 16 #1011
	sw %a1 %sp 20 #1011
	add %a0 %a5 %zero
	sw %ra %sp 28 #1011 call dir
	addi %sp %sp 32 #1011	
	jal %ra o_param_ctbl.2329 #1011
	addi %sp %sp -32 #1011
	lw %ra %sp 28 #1011
	lw %f0 %a0 0 #19
	lw %f1 %a0 4 #19
	lw %f2 %a0 8 #19
	lw %a1 %sp 20 #1015
	sw %a0 %sp 24 #1015
	sw %f2 %sp 32 #1015
	sw %f1 %sp 40 #1015
	sw %f0 %sp 48 #1015
	add %a0 %a1 %zero
	sw %ra %sp 60 #1015 call dir
	addi %sp %sp 64 #1015	
	jal %ra d_const.2352 #1015
	addi %sp %sp -64 #1015
	lw %ra %sp 60 #1015
	lw %a1 %sp 16 #968
	slli %a1 %a1 2 #968
	add %a12 %a0 %a1 #968
	lw %a0 %a12 0 #968
	lw %a1 %sp 12 #1017
	sw %a0 %sp 56 #1017
	add %a0 %a1 %zero
	sw %ra %sp 60 #1017 call dir
	addi %sp %sp 64 #1017	
	jal %ra o_form.2291 #1017
	addi %sp %sp -64 #1017
	lw %ra %sp 60 #1017
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8576
	lw %a0 %sp 20 #1019
	sw %ra %sp 60 #1019 call dir
	addi %sp %sp 64 #1019	
	jal %ra d_vec.2350 #1019
	addi %sp %sp -64 #1019
	lw %ra %sp 60 #1019
	add %a1 %a0 %zero #1019
	lw %f0 %sp 48 #1019
	lw %f1 %sp 40 #1019
	lw %f2 %sp 32 #1019
	lw %a0 %sp 12 #1019
	lw %a2 %sp 56 #1019
	lw %a11 %sp 8 #1019
	lw %a10 %a11 0 #1019
	jalr %zero %a10 0 #1019
beq_else.8576:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8577
	lw %f0 %sp 48 #1021
	lw %f1 %sp 40 #1021
	lw %f2 %sp 32 #1021
	lw %a0 %sp 12 #1021
	lw %a1 %sp 56 #1021
	lw %a2 %sp 24 #1021
	lw %a11 %sp 4 #1021
	lw %a10 %a11 0 #1021
	jalr %zero %a10 0 #1021
beq_else.8577:
	lw %f0 %sp 48 #1023
	lw %f1 %sp 40 #1023
	lw %f2 %sp 32 #1023
	lw %a0 %sp 12 #1023
	lw %a1 %sp 56 #1023
	lw %a2 %sp 24 #1023
	lw %a11 %sp 0 #1023
	lw %a10 %a11 0 #1023
	jalr %zero %a10 0 #1023
setup_rect_table.2467:
	addi %a2 %zero 6 #1030
	li %f0 l.5551 #1030
	sw %a1 %sp 0 #1030
	sw %a0 %sp 4 #1030
	add %a0 %a2 %zero
	sw %ra %sp 12 #1030 call dir
	addi %sp %sp 16 #1030	
	jal %ra min_caml_create_float_array #1030
	addi %sp %sp -16 #1030
	lw %ra %sp 12 #1030
	lw %a1 %sp 4 #1032
	lw %f0 %a1 0 #1032
	sw %a0 %sp 8 #1032
	sw %ra %sp 12 #1032 call dir
	addi %sp %sp 16 #1032	
	jal %ra min_caml_fiszero #1032
	addi %sp %sp -16 #1032
	lw %ra %sp 12 #1032
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8578 # nontail if
	lw %a0 %sp 0 #1036
	sw %ra %sp 12 #1036 call dir
	addi %sp %sp 16 #1036	
	jal %ra o_isinvert.2295 #1036
	addi %sp %sp -16 #1036
	lw %ra %sp 12 #1036
	lw %a1 %sp 4 #1032
	lw %f0 %a1 0 #1032
	sw %a0 %sp 12 #1036
	sw %ra %sp 20 #1036 call dir
	addi %sp %sp 24 #1036	
	jal %ra min_caml_fisneg #1036
	addi %sp %sp -24 #1036
	lw %ra %sp 20 #1036
	add %a1 %a0 %zero #1036
	lw %a0 %sp 12 #1036
	sw %ra %sp 20 #1036 call dir
	addi %sp %sp 24 #1036	
	jal %ra xor.2232 #1036
	addi %sp %sp -24 #1036
	lw %ra %sp 20 #1036
	lw %a1 %sp 0 #1036
	sw %a0 %sp 16 #1036
	add %a0 %a1 %zero
	sw %ra %sp 20 #1036 call dir
	addi %sp %sp 24 #1036	
	jal %ra o_param_a.2299 #1036
	addi %sp %sp -24 #1036
	lw %ra %sp 20 #1036
	lw %a0 %sp 16 #1036
	sw %ra %sp 20 #1036 call dir
	addi %sp %sp 24 #1036	
	jal %ra fneg_cond.2237 #1036
	addi %sp %sp -24 #1036
	lw %ra %sp 20 #1036
	lw %a0 %sp 8 #1036
	sw %f0 %a0 0 #1036
	li %f0 l.5553 #1038
	lw %a1 %sp 4 #1032
	lw %f1 %a1 0 #1032
	fdiv %f0 %f0 %f1 #1038
	sw %f0 %a0 4 #1038
	jal %zero beq_cont.8579 # then sentence ends
beq_else.8578:
	li %f0 l.5551 #1033
	lw %a0 %sp 8 #1033
	sw %f0 %a0 4 #1033
beq_cont.8579:
	lw %a1 %sp 4 #1032
	lw %f0 %a1 4 #1032
	sw %ra %sp 20 #1040 call dir
	addi %sp %sp 24 #1040	
	jal %ra min_caml_fiszero #1040
	addi %sp %sp -24 #1040
	lw %ra %sp 20 #1040
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8580 # nontail if
	lw %a0 %sp 0 #1043
	sw %ra %sp 20 #1043 call dir
	addi %sp %sp 24 #1043	
	jal %ra o_isinvert.2295 #1043
	addi %sp %sp -24 #1043
	lw %ra %sp 20 #1043
	lw %a1 %sp 4 #1032
	lw %f0 %a1 4 #1032
	sw %a0 %sp 20 #1043
	sw %ra %sp 28 #1043 call dir
	addi %sp %sp 32 #1043	
	jal %ra min_caml_fisneg #1043
	addi %sp %sp -32 #1043
	lw %ra %sp 28 #1043
	add %a1 %a0 %zero #1043
	lw %a0 %sp 20 #1043
	sw %ra %sp 28 #1043 call dir
	addi %sp %sp 32 #1043	
	jal %ra xor.2232 #1043
	addi %sp %sp -32 #1043
	lw %ra %sp 28 #1043
	lw %a1 %sp 0 #1043
	sw %a0 %sp 24 #1043
	add %a0 %a1 %zero
	sw %ra %sp 28 #1043 call dir
	addi %sp %sp 32 #1043	
	jal %ra o_param_b.2301 #1043
	addi %sp %sp -32 #1043
	lw %ra %sp 28 #1043
	lw %a0 %sp 24 #1043
	sw %ra %sp 28 #1043 call dir
	addi %sp %sp 32 #1043	
	jal %ra fneg_cond.2237 #1043
	addi %sp %sp -32 #1043
	lw %ra %sp 28 #1043
	lw %a0 %sp 8 #1043
	sw %f0 %a0 8 #1043
	li %f0 l.5553 #1044
	lw %a1 %sp 4 #1032
	lw %f1 %a1 4 #1032
	fdiv %f0 %f0 %f1 #1044
	sw %f0 %a0 12 #1044
	jal %zero beq_cont.8581 # then sentence ends
beq_else.8580:
	li %f0 l.5551 #1041
	lw %a0 %sp 8 #1041
	sw %f0 %a0 12 #1041
beq_cont.8581:
	lw %a1 %sp 4 #1032
	lw %f0 %a1 8 #1032
	sw %ra %sp 28 #1046 call dir
	addi %sp %sp 32 #1046	
	jal %ra min_caml_fiszero #1046
	addi %sp %sp -32 #1046
	lw %ra %sp 28 #1046
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8582 # nontail if
	lw %a0 %sp 0 #1049
	sw %ra %sp 28 #1049 call dir
	addi %sp %sp 32 #1049	
	jal %ra o_isinvert.2295 #1049
	addi %sp %sp -32 #1049
	lw %ra %sp 28 #1049
	lw %a1 %sp 4 #1032
	lw %f0 %a1 8 #1032
	sw %a0 %sp 28 #1049
	sw %ra %sp 36 #1049 call dir
	addi %sp %sp 40 #1049	
	jal %ra min_caml_fisneg #1049
	addi %sp %sp -40 #1049
	lw %ra %sp 36 #1049
	add %a1 %a0 %zero #1049
	lw %a0 %sp 28 #1049
	sw %ra %sp 36 #1049 call dir
	addi %sp %sp 40 #1049	
	jal %ra xor.2232 #1049
	addi %sp %sp -40 #1049
	lw %ra %sp 36 #1049
	lw %a1 %sp 0 #1049
	sw %a0 %sp 32 #1049
	add %a0 %a1 %zero
	sw %ra %sp 36 #1049 call dir
	addi %sp %sp 40 #1049	
	jal %ra o_param_c.2303 #1049
	addi %sp %sp -40 #1049
	lw %ra %sp 36 #1049
	lw %a0 %sp 32 #1049
	sw %ra %sp 36 #1049 call dir
	addi %sp %sp 40 #1049	
	jal %ra fneg_cond.2237 #1049
	addi %sp %sp -40 #1049
	lw %ra %sp 36 #1049
	lw %a0 %sp 8 #1049
	sw %f0 %a0 16 #1049
	li %f0 l.5553 #1050
	lw %a1 %sp 4 #1032
	lw %f1 %a1 8 #1032
	fdiv %f0 %f0 %f1 #1050
	sw %f0 %a0 20 #1050
	jal %zero beq_cont.8583 # then sentence ends
beq_else.8582:
	li %f0 l.5551 #1047
	lw %a0 %sp 8 #1047
	sw %f0 %a0 20 #1047
beq_cont.8583:
	jalr %zero %ra 0 #1052
setup_surface_table.2470:
	addi %a2 %zero 4 #1057
	li %f0 l.5551 #1057
	sw %a1 %sp 0 #1057
	sw %a0 %sp 4 #1057
	add %a0 %a2 %zero
	sw %ra %sp 12 #1057 call dir
	addi %sp %sp 16 #1057	
	jal %ra min_caml_create_float_array #1057
	addi %sp %sp -16 #1057
	lw %ra %sp 12 #1057
	lw %a1 %sp 4 #1059
	lw %f0 %a1 0 #1059
	lw %a2 %sp 0 #1059
	sw %a0 %sp 8 #1059
	sw %f0 %sp 16 #1059
	add %a0 %a2 %zero
	sw %ra %sp 28 #1059 call dir
	addi %sp %sp 32 #1059	
	jal %ra o_param_a.2299 #1059
	addi %sp %sp -32 #1059
	lw %ra %sp 28 #1059
	lw %f1 %sp 16 #1059
	fmul %f0 %f1 %f0 #1059
	lw %a0 %sp 4 #1059
	lw %f1 %a0 4 #1059
	lw %a1 %sp 0 #1059
	sw %f0 %sp 24 #1059
	sw %f1 %sp 32 #1059
	add %a0 %a1 %zero
	sw %ra %sp 44 #1059 call dir
	addi %sp %sp 48 #1059	
	jal %ra o_param_b.2301 #1059
	addi %sp %sp -48 #1059
	lw %ra %sp 44 #1059
	lw %f1 %sp 32 #1059
	fmul %f0 %f1 %f0 #1059
	lw %f1 %sp 24 #1059
	fadd %f0 %f1 %f0 #1059
	lw %a0 %sp 4 #1059
	lw %f1 %a0 8 #1059
	lw %a0 %sp 0 #1059
	sw %f0 %sp 40 #1059
	sw %f1 %sp 48 #1059
	sw %ra %sp 60 #1059 call dir
	addi %sp %sp 64 #1059	
	jal %ra o_param_c.2303 #1059
	addi %sp %sp -64 #1059
	lw %ra %sp 60 #1059
	lw %f1 %sp 48 #1059
	fmul %f0 %f1 %f0 #1059
	lw %f1 %sp 40 #1059
	fadd %f0 %f1 %f0 #1059
	sw %f0 %sp 56 #1061
	sw %ra %sp 68 #1061 call dir
	addi %sp %sp 72 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -72 #1061
	lw %ra %sp 68 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8585 # nontail if
	li %f0 l.5551 #1069
	lw %a0 %sp 8 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.8586 # then sentence ends
beq_else.8585:
	li %f0 l.5555 #1063
	lw %f1 %sp 56 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 8 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 0 #1065
	add %a0 %a1 %zero
	sw %ra %sp 68 #1065 call dir
	addi %sp %sp 72 #1065	
	jal %ra o_param_a.2299 #1065
	addi %sp %sp -72 #1065
	lw %ra %sp 68 #1065
	lw %f1 %sp 56 #1065
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 68 #1065 call dir
	addi %sp %sp 72 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -72 #1065
	lw %ra %sp 68 #1065
	lw %a0 %sp 8 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 0 #1066
	add %a0 %a1 %zero
	sw %ra %sp 68 #1066 call dir
	addi %sp %sp 72 #1066	
	jal %ra o_param_b.2301 #1066
	addi %sp %sp -72 #1066
	lw %ra %sp 68 #1066
	lw %f1 %sp 56 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 68 #1066 call dir
	addi %sp %sp 72 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -72 #1066
	lw %ra %sp 68 #1066
	lw %a0 %sp 8 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 0 #1067
	add %a0 %a1 %zero
	sw %ra %sp 68 #1067 call dir
	addi %sp %sp 72 #1067	
	jal %ra o_param_c.2303 #1067
	addi %sp %sp -72 #1067
	lw %ra %sp 68 #1067
	lw %f1 %sp 56 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 68 #1067 call dir
	addi %sp %sp 72 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -72 #1067
	lw %ra %sp 68 #1067
	lw %a0 %sp 8 #1067
	sw %f0 %a0 12 #1067
beq_cont.8586:
	jalr %zero %ra 0 #1070
setup_second_table.2473:
	addi %a2 %zero 5 #1076
	li %f0 l.5551 #1076
	sw %a1 %sp 0 #1076
	sw %a0 %sp 4 #1076
	add %a0 %a2 %zero
	sw %ra %sp 12 #1076 call dir
	addi %sp %sp 16 #1076	
	jal %ra min_caml_create_float_array #1076
	addi %sp %sp -16 #1076
	lw %ra %sp 12 #1076
	lw %a1 %sp 4 #1078
	lw %f0 %a1 0 #1078
	lw %f1 %a1 4 #1078
	lw %f2 %a1 8 #1078
	lw %a2 %sp 0 #1078
	sw %a0 %sp 8 #1078
	add %a0 %a2 %zero
	sw %ra %sp 12 #1078 call dir
	addi %sp %sp 16 #1078	
	jal %ra quadratic.2404 #1078
	addi %sp %sp -16 #1078
	lw %ra %sp 12 #1078
	lw %a0 %sp 4 #1078
	lw %f1 %a0 0 #1078
	lw %a1 %sp 0 #1079
	sw %f0 %sp 16 #1079
	sw %f1 %sp 24 #1079
	add %a0 %a1 %zero
	sw %ra %sp 36 #1079 call dir
	addi %sp %sp 40 #1079	
	jal %ra o_param_a.2299 #1079
	addi %sp %sp -40 #1079
	lw %ra %sp 36 #1079
	lw %f1 %sp 24 #1079
	fmul %f0 %f1 %f0 #1079
	sw %ra %sp 36 #1079 call dir
	addi %sp %sp 40 #1079	
	jal %ra min_caml_fneg #1079
	addi %sp %sp -40 #1079
	lw %ra %sp 36 #1079
	lw %a0 %sp 4 #1078
	lw %f1 %a0 4 #1078
	lw %a1 %sp 0 #1080
	sw %f0 %sp 32 #1080
	sw %f1 %sp 40 #1080
	add %a0 %a1 %zero
	sw %ra %sp 52 #1080 call dir
	addi %sp %sp 56 #1080	
	jal %ra o_param_b.2301 #1080
	addi %sp %sp -56 #1080
	lw %ra %sp 52 #1080
	lw %f1 %sp 40 #1080
	fmul %f0 %f1 %f0 #1080
	sw %ra %sp 52 #1080 call dir
	addi %sp %sp 56 #1080	
	jal %ra min_caml_fneg #1080
	addi %sp %sp -56 #1080
	lw %ra %sp 52 #1080
	lw %a0 %sp 4 #1078
	lw %f1 %a0 8 #1078
	lw %a1 %sp 0 #1081
	sw %f0 %sp 48 #1081
	sw %f1 %sp 56 #1081
	add %a0 %a1 %zero
	sw %ra %sp 68 #1081 call dir
	addi %sp %sp 72 #1081	
	jal %ra o_param_c.2303 #1081
	addi %sp %sp -72 #1081
	lw %ra %sp 68 #1081
	lw %f1 %sp 56 #1081
	fmul %f0 %f1 %f0 #1081
	sw %ra %sp 68 #1081 call dir
	addi %sp %sp 72 #1081	
	jal %ra min_caml_fneg #1081
	addi %sp %sp -72 #1081
	lw %ra %sp 68 #1081
	lw %a0 %sp 8 #1083
	lw %f1 %sp 16 #1083
	sw %f1 %a0 0 #1083
	lw %a1 %sp 0 #1086
	sw %f0 %sp 64 #1086
	add %a0 %a1 %zero
	sw %ra %sp 76 #1086 call dir
	addi %sp %sp 80 #1086	
	jal %ra o_isrot.2297 #1086
	addi %sp %sp -80 #1086
	lw %ra %sp 76 #1086
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8588 # nontail if
	lw %a0 %sp 8 #1091
	lw %f0 %sp 32 #1091
	sw %f0 %a0 4 #1091
	lw %f0 %sp 48 #1092
	sw %f0 %a0 8 #1092
	lw %f0 %sp 64 #1093
	sw %f0 %a0 12 #1093
	jal %zero beq_cont.8589 # then sentence ends
beq_else.8588:
	lw %a0 %sp 4 #1078
	lw %f0 %a0 8 #1078
	lw %a1 %sp 0 #1087
	sw %f0 %sp 72 #1087
	add %a0 %a1 %zero
	sw %ra %sp 84 #1087 call dir
	addi %sp %sp 88 #1087	
	jal %ra o_param_r2.2325 #1087
	addi %sp %sp -88 #1087
	lw %ra %sp 84 #1087
	lw %f1 %sp 72 #1087
	fmul %f0 %f1 %f0 #1087
	lw %a0 %sp 4 #1078
	lw %f1 %a0 4 #1078
	lw %a1 %sp 0 #1087
	sw %f0 %sp 80 #1087
	sw %f1 %sp 88 #1087
	add %a0 %a1 %zero
	sw %ra %sp 100 #1087 call dir
	addi %sp %sp 104 #1087	
	jal %ra o_param_r3.2327 #1087
	addi %sp %sp -104 #1087
	lw %ra %sp 100 #1087
	lw %f1 %sp 88 #1087
	fmul %f0 %f1 %f0 #1087
	lw %f1 %sp 80 #1087
	fadd %f0 %f1 %f0 #1087
	sw %ra %sp 100 #1087 call dir
	addi %sp %sp 104 #1087	
	jal %ra min_caml_fhalf #1087
	addi %sp %sp -104 #1087
	lw %ra %sp 100 #1087
	lw %f1 %sp 32 #1087
	fsub %f0 %f1 %f0 #1087
	lw %a0 %sp 8 #1087
	sw %f0 %a0 4 #1087
	lw %a1 %sp 4 #1078
	lw %f0 %a1 8 #1078
	lw %a2 %sp 0 #1088
	sw %f0 %sp 96 #1088
	add %a0 %a2 %zero
	sw %ra %sp 108 #1088 call dir
	addi %sp %sp 112 #1088	
	jal %ra o_param_r1.2323 #1088
	addi %sp %sp -112 #1088
	lw %ra %sp 108 #1088
	lw %f1 %sp 96 #1088
	fmul %f0 %f1 %f0 #1088
	lw %a0 %sp 4 #1078
	lw %f1 %a0 0 #1078
	lw %a1 %sp 0 #1088
	sw %f0 %sp 104 #1088
	sw %f1 %sp 112 #1088
	add %a0 %a1 %zero
	sw %ra %sp 124 #1088 call dir
	addi %sp %sp 128 #1088	
	jal %ra o_param_r3.2327 #1088
	addi %sp %sp -128 #1088
	lw %ra %sp 124 #1088
	lw %f1 %sp 112 #1088
	fmul %f0 %f1 %f0 #1088
	lw %f1 %sp 104 #1088
	fadd %f0 %f1 %f0 #1088
	sw %ra %sp 124 #1088 call dir
	addi %sp %sp 128 #1088	
	jal %ra min_caml_fhalf #1088
	addi %sp %sp -128 #1088
	lw %ra %sp 124 #1088
	lw %f1 %sp 48 #1088
	fsub %f0 %f1 %f0 #1088
	lw %a0 %sp 8 #1088
	sw %f0 %a0 8 #1088
	lw %a1 %sp 4 #1078
	lw %f0 %a1 4 #1078
	lw %a2 %sp 0 #1089
	sw %f0 %sp 120 #1089
	add %a0 %a2 %zero
	sw %ra %sp 132 #1089 call dir
	addi %sp %sp 136 #1089	
	jal %ra o_param_r1.2323 #1089
	addi %sp %sp -136 #1089
	lw %ra %sp 132 #1089
	lw %f1 %sp 120 #1089
	fmul %f0 %f1 %f0 #1089
	lw %a0 %sp 4 #1078
	lw %f1 %a0 0 #1078
	lw %a0 %sp 0 #1089
	sw %f0 %sp 128 #1089
	sw %f1 %sp 136 #1089
	sw %ra %sp 148 #1089 call dir
	addi %sp %sp 152 #1089	
	jal %ra o_param_r2.2325 #1089
	addi %sp %sp -152 #1089
	lw %ra %sp 148 #1089
	lw %f1 %sp 136 #1089
	fmul %f0 %f1 %f0 #1089
	lw %f1 %sp 128 #1089
	fadd %f0 %f1 %f0 #1089
	sw %ra %sp 148 #1089 call dir
	addi %sp %sp 152 #1089	
	jal %ra min_caml_fhalf #1089
	addi %sp %sp -152 #1089
	lw %ra %sp 148 #1089
	lw %f1 %sp 64 #1089
	fsub %f0 %f1 %f0 #1089
	lw %a0 %sp 8 #1089
	sw %f0 %a0 12 #1089
beq_cont.8589:
	lw %f0 %sp 16 #1095
	sw %ra %sp 148 #1095 call dir
	addi %sp %sp 152 #1095	
	jal %ra min_caml_fiszero #1095
	addi %sp %sp -152 #1095
	lw %ra %sp 148 #1095
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8590 # nontail if
	li %f0 l.5553 #1096
	lw %f1 %sp 16 #1096
	fdiv %f0 %f0 %f1 #1096
	lw %a0 %sp 8 #1096
	sw %f0 %a0 16 #1096
	jal %zero beq_cont.8591 # then sentence ends
beq_else.8590:
beq_cont.8591:
	lw %a0 %sp 8 #1098
	jalr %zero %ra 0 #1098
iter_setup_dirvec_constants.2476:
	lw %a2 %a11 4 #1103
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8592
	slli %a3 %a1 2 #20
	add %a12 %a2 %a3 #20
	lw %a2 %a12 0 #20
	sw %a11 %sp 0 #1106
	sw %a1 %sp 4 #1106
	sw %a2 %sp 8 #1106
	sw %a0 %sp 12 #1106
	sw %ra %sp 20 #1106 call dir
	addi %sp %sp 24 #1106	
	jal %ra d_const.2352 #1106
	addi %sp %sp -24 #1106
	lw %ra %sp 20 #1106
	lw %a1 %sp 12 #1107
	sw %a0 %sp 16 #1107
	add %a0 %a1 %zero
	sw %ra %sp 20 #1107 call dir
	addi %sp %sp 24 #1107	
	jal %ra d_vec.2350 #1107
	addi %sp %sp -24 #1107
	lw %ra %sp 20 #1107
	lw %a1 %sp 8 #1108
	sw %a0 %sp 20 #1108
	add %a0 %a1 %zero
	sw %ra %sp 28 #1108 call dir
	addi %sp %sp 32 #1108	
	jal %ra o_form.2291 #1108
	addi %sp %sp -32 #1108
	lw %ra %sp 28 #1108
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8593 # nontail if
	lw %a0 %sp 20 #1110
	lw %a1 %sp 8 #1110
	sw %ra %sp 28 #1110 call dir
	addi %sp %sp 32 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -32 #1110
	lw %ra %sp 28 #1110
	lw %a1 %sp 4 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 16 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.8594 # then sentence ends
beq_else.8593:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8595 # nontail if
	lw %a0 %sp 20 #1112
	lw %a1 %sp 8 #1112
	sw %ra %sp 28 #1112 call dir
	addi %sp %sp 32 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -32 #1112
	lw %ra %sp 28 #1112
	lw %a1 %sp 4 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 16 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.8596 # then sentence ends
beq_else.8595:
	lw %a0 %sp 20 #1114
	lw %a1 %sp 8 #1114
	sw %ra %sp 28 #1114 call dir
	addi %sp %sp 32 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -32 #1114
	lw %ra %sp 28 #1114
	lw %a1 %sp 4 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 16 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.8596:
beq_cont.8594:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 12 #1116
	lw %a11 %sp 0 #1116
	lw %a10 %a11 0 #1116
	jalr %zero %a10 0 #1116
bge_else.8592:
	jalr %zero %ra 0 #1117
setup_dirvec_constants.2479:
	lw %a1 %a11 8 #1120
	lw %a11 %a11 4 #1120
	lw %a1 %a1 0 #15
	addi %a1 %a1 -1 #1121
	lw %a10 %a11 0 #1121
	jalr %zero %a10 0 #1121
setup_startp_constants.2481:
	lw %a2 %a11 4 #1126
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8598
	slli %a3 %a1 2 #20
	add %a12 %a2 %a3 #20
	lw %a2 %a12 0 #20
	sw %a11 %sp 0 #1129
	sw %a1 %sp 4 #1129
	sw %a0 %sp 8 #1129
	sw %a2 %sp 12 #1129
	add %a0 %a2 %zero
	sw %ra %sp 20 #1129 call dir
	addi %sp %sp 24 #1129	
	jal %ra o_param_ctbl.2329 #1129
	addi %sp %sp -24 #1129
	lw %ra %sp 20 #1129
	lw %a1 %sp 12 #1130
	sw %a0 %sp 16 #1130
	add %a0 %a1 %zero
	sw %ra %sp 20 #1130 call dir
	addi %sp %sp 24 #1130	
	jal %ra o_form.2291 #1130
	addi %sp %sp -24 #1130
	lw %ra %sp 20 #1130
	lw %a1 %sp 8 #1131
	lw %f0 %a1 0 #1131
	lw %a2 %sp 12 #1131
	sw %a0 %sp 20 #1131
	sw %f0 %sp 24 #1131
	add %a0 %a2 %zero
	sw %ra %sp 36 #1131 call dir
	addi %sp %sp 40 #1131	
	jal %ra o_param_x.2307 #1131
	addi %sp %sp -40 #1131
	lw %ra %sp 36 #1131
	lw %f1 %sp 24 #1131
	fsub %f0 %f1 %f0 #1131
	lw %a0 %sp 16 #1131
	sw %f0 %a0 0 #1131
	lw %a1 %sp 8 #1131
	lw %f0 %a1 4 #1131
	lw %a2 %sp 12 #1132
	sw %f0 %sp 32 #1132
	add %a0 %a2 %zero
	sw %ra %sp 44 #1132 call dir
	addi %sp %sp 48 #1132	
	jal %ra o_param_y.2309 #1132
	addi %sp %sp -48 #1132
	lw %ra %sp 44 #1132
	lw %f1 %sp 32 #1132
	fsub %f0 %f1 %f0 #1132
	lw %a0 %sp 16 #1132
	sw %f0 %a0 4 #1132
	lw %a1 %sp 8 #1131
	lw %f0 %a1 8 #1131
	lw %a2 %sp 12 #1133
	sw %f0 %sp 40 #1133
	add %a0 %a2 %zero
	sw %ra %sp 52 #1133 call dir
	addi %sp %sp 56 #1133	
	jal %ra o_param_z.2311 #1133
	addi %sp %sp -56 #1133
	lw %ra %sp 52 #1133
	lw %f1 %sp 40 #1133
	fsub %f0 %f1 %f0 #1133
	lw %a0 %sp 16 #1133
	sw %f0 %a0 8 #1133
	lw %a1 %sp 20 #868
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8599 # nontail if
	lw %a1 %sp 12 #1136
	add %a0 %a1 %zero
	sw %ra %sp 52 #1136 call dir
	addi %sp %sp 56 #1136	
	jal %ra o_param_abc.2305 #1136
	addi %sp %sp -56 #1136
	lw %ra %sp 52 #1136
	lw %a1 %sp 16 #19
	lw %f0 %a1 0 #19
	lw %f1 %a1 4 #19
	lw %f2 %a1 8 #19
	sw %ra %sp 52 #1136 call dir
	addi %sp %sp 56 #1136	
	jal %ra veciprod2.2267 #1136
	addi %sp %sp -56 #1136
	lw %ra %sp 52 #1136
	lw %a0 %sp 16 #1135
	sw %f0 %a0 12 #1135
	jal %zero beq_cont.8600 # then sentence ends
beq_else.8599:
	addi %a12 %zero 2
	blt %a12 %a1 bge_else.8601 # nontail if
	jal %zero bge_cont.8602 # then sentence ends
bge_else.8601:
	lw %f0 %a0 0 #19
	lw %f1 %a0 4 #19
	lw %f2 %a0 8 #19
	lw %a2 %sp 12 #1138
	add %a0 %a2 %zero
	sw %ra %sp 52 #1138 call dir
	addi %sp %sp 56 #1138	
	jal %ra quadratic.2404 #1138
	addi %sp %sp -56 #1138
	lw %ra %sp 52 #1138
	lw %a0 %sp 20 #868
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8603 # nontail if
	li %f1 l.5553 #1139
	fsub %f0 %f0 %f1 #1139
	jal %zero beq_cont.8604 # then sentence ends
beq_else.8603:
beq_cont.8604:
	lw %a0 %sp 16 #1139
	sw %f0 %a0 12 #1139
bge_cont.8602:
beq_cont.8600:
	lw %a0 %sp 4 #1141
	addi %a1 %a0 -1 #1141
	lw %a0 %sp 8 #1141
	lw %a11 %sp 0 #1141
	lw %a10 %a11 0 #1141
	jalr %zero %a10 0 #1141
bge_else.8598:
	jalr %zero %ra 0 #1142
setup_startp.2484:
	lw %a1 %a11 12 #1145
	lw %a2 %a11 8 #1145
	lw %a3 %a11 4 #1145
	sw %a0 %sp 0 #1146
	sw %a2 %sp 4 #1146
	sw %a3 %sp 8 #1146
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 12 #1146 call dir
	addi %sp %sp 16 #1146	
	jal %ra veccpy.2253 #1146
	addi %sp %sp -16 #1146
	lw %ra %sp 12 #1146
	lw %a0 %sp 8 #15
	lw %a0 %a0 0 #15
	addi %a1 %a0 -1 #1147
	lw %a0 %sp 0 #1147
	lw %a11 %sp 4 #1147
	lw %a10 %a11 0 #1147
	jalr %zero %a10 0 #1147
is_rect_outside.2486:
	sw %f2 %sp 0 #1157
	sw %f1 %sp 8 #1157
	sw %a0 %sp 16 #1157
	sw %ra %sp 20 #1157 call dir
	addi %sp %sp 24 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -24 #1157
	lw %ra %sp 20 #1157
	lw %a0 %sp 16 #1157
	sw %f0 %sp 24 #1157
	sw %ra %sp 36 #1157 call dir
	addi %sp %sp 40 #1157	
	jal %ra o_param_a.2299 #1157
	addi %sp %sp -40 #1157
	lw %ra %sp 36 #1157
	fadd %f1 %f0 %fzero #1157
	lw %f0 %sp 24 #1157
	sw %ra %sp 36 #1157 call dir
	addi %sp %sp 40 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -40 #1157
	lw %ra %sp 36 #1157
	addi %a1 %zero 0 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8607 # nontail if
	addi %a0 %a1 0 #1157
	jal %zero beq_cont.8608 # then sentence ends
beq_else.8607:
	lw %f0 %sp 8 #1158
	sw %a1 %sp 32 #1158
	sw %ra %sp 36 #1158 call dir
	addi %sp %sp 40 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -40 #1158
	lw %ra %sp 36 #1158
	lw %a0 %sp 16 #1158
	sw %f0 %sp 40 #1158
	sw %ra %sp 52 #1158 call dir
	addi %sp %sp 56 #1158	
	jal %ra o_param_b.2301 #1158
	addi %sp %sp -56 #1158
	lw %ra %sp 52 #1158
	fadd %f1 %f0 %fzero #1158
	lw %f0 %sp 40 #1158
	sw %ra %sp 52 #1158 call dir
	addi %sp %sp 56 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -56 #1158
	lw %ra %sp 52 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8610 # nontail if
	lw %a0 %sp 32 #1157
	jal %zero beq_cont.8611 # then sentence ends
beq_else.8610:
	lw %f0 %sp 0 #1159
	sw %ra %sp 52 #1159 call dir
	addi %sp %sp 56 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -56 #1159
	lw %ra %sp 52 #1159
	lw %a0 %sp 16 #1159
	sw %f0 %sp 48 #1159
	sw %ra %sp 60 #1159 call dir
	addi %sp %sp 64 #1159	
	jal %ra o_param_c.2303 #1159
	addi %sp %sp -64 #1159
	lw %ra %sp 60 #1159
	fadd %f1 %f0 %fzero #1159
	lw %f0 %sp 48 #1159
	sw %ra %sp 60 #1159 call dir
	addi %sp %sp 64 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -64 #1159
	lw %ra %sp 60 #1159
beq_cont.8611:
beq_cont.8608:
	addi %a1 %zero 0 #1156
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8612
	lw %a0 %sp 16 #1162
	sw %a1 %sp 56 #1162
	sw %ra %sp 60 #1162 call dir
	addi %sp %sp 64 #1162	
	jal %ra o_isinvert.2295 #1162
	addi %sp %sp -64 #1162
	lw %ra %sp 60 #1162
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8613
	addi %a0 %zero 1 #1162
	jalr %zero %ra 0 #1162
beq_else.8613:
	lw %a0 %sp 56 #1156
	jalr %zero %ra 0 #1156
beq_else.8612:
	lw %a0 %sp 16 #1162
	jal	%zero o_isinvert.2295
is_plane_outside.2491:
	sw %a0 %sp 0 #1167
	sw %f2 %sp 8 #1167
	sw %f1 %sp 16 #1167
	sw %f0 %sp 24 #1167
	sw %ra %sp 36 #1167 call dir
	addi %sp %sp 40 #1167	
	jal %ra o_param_abc.2305 #1167
	addi %sp %sp -40 #1167
	lw %ra %sp 36 #1167
	lw %f0 %sp 24 #1167
	lw %f1 %sp 16 #1167
	lw %f2 %sp 8 #1167
	sw %ra %sp 36 #1167 call dir
	addi %sp %sp 40 #1167	
	jal %ra veciprod2.2267 #1167
	addi %sp %sp -40 #1167
	lw %ra %sp 36 #1167
	lw %a0 %sp 0 #1168
	sw %f0 %sp 32 #1168
	sw %ra %sp 44 #1168 call dir
	addi %sp %sp 48 #1168	
	jal %ra o_isinvert.2295 #1168
	addi %sp %sp -48 #1168
	lw %ra %sp 44 #1168
	lw %f0 %sp 32 #1168
	sw %a0 %sp 40 #1168
	sw %ra %sp 44 #1168 call dir
	addi %sp %sp 48 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -48 #1168
	lw %ra %sp 44 #1168
	add %a1 %a0 %zero #1168
	lw %a0 %sp 40 #1168
	sw %ra %sp 44 #1168 call dir
	addi %sp %sp 48 #1168	
	jal %ra xor.2232 #1168
	addi %sp %sp -48 #1168
	lw %ra %sp 44 #1168
	addi %a1 %zero 0 #1168
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8615
	addi %a0 %zero 1 #1168
	jalr %zero %ra 0 #1168
beq_else.8615:
	addi %a0 %a1 0 #1168
	jalr %zero %ra 0 #1168
is_second_outside.2496:
	sw %a0 %sp 0 #1173
	sw %ra %sp 4 #1173 call dir
	addi %sp %sp 8 #1173	
	jal %ra quadratic.2404 #1173
	addi %sp %sp -8 #1173
	lw %ra %sp 4 #1173
	lw %a0 %sp 0 #1174
	sw %f0 %sp 8 #1174
	sw %ra %sp 20 #1174 call dir
	addi %sp %sp 24 #1174	
	jal %ra o_form.2291 #1174
	addi %sp %sp -24 #1174
	lw %ra %sp 20 #1174
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8617 # nontail if
	li %f0 l.5553 #1174
	lw %f1 %sp 8 #1174
	fsub %f0 %f1 %f0 #1174
	jal %zero beq_cont.8618 # then sentence ends
beq_else.8617:
	lw %f0 %sp 8 #822
beq_cont.8618:
	lw %a0 %sp 0 #1175
	sw %f0 %sp 16 #1175
	sw %ra %sp 28 #1175 call dir
	addi %sp %sp 32 #1175	
	jal %ra o_isinvert.2295 #1175
	addi %sp %sp -32 #1175
	lw %ra %sp 28 #1175
	lw %f0 %sp 16 #1175
	sw %a0 %sp 24 #1175
	sw %ra %sp 28 #1175 call dir
	addi %sp %sp 32 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -32 #1175
	lw %ra %sp 28 #1175
	add %a1 %a0 %zero #1175
	lw %a0 %sp 24 #1175
	sw %ra %sp 28 #1175 call dir
	addi %sp %sp 32 #1175	
	jal %ra xor.2232 #1175
	addi %sp %sp -32 #1175
	lw %ra %sp 28 #1175
	addi %a1 %zero 0 #1175
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8619
	addi %a0 %zero 1 #1175
	jalr %zero %ra 0 #1175
beq_else.8619:
	addi %a0 %a1 0 #1175
	jalr %zero %ra 0 #1175
is_outside.2501:
	sw %f2 %sp 0 #1180
	sw %f1 %sp 8 #1180
	sw %a0 %sp 16 #1180
	sw %f0 %sp 24 #1180
	sw %ra %sp 36 #1180 call dir
	addi %sp %sp 40 #1180	
	jal %ra o_param_x.2307 #1180
	addi %sp %sp -40 #1180
	lw %ra %sp 36 #1180
	lw %f1 %sp 24 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a0 %sp 16 #1181
	sw %f0 %sp 32 #1181
	sw %ra %sp 44 #1181 call dir
	addi %sp %sp 48 #1181	
	jal %ra o_param_y.2309 #1181
	addi %sp %sp -48 #1181
	lw %ra %sp 44 #1181
	lw %f1 %sp 8 #1181
	fsub %f0 %f1 %f0 #1181
	lw %a0 %sp 16 #1182
	sw %f0 %sp 40 #1182
	sw %ra %sp 52 #1182 call dir
	addi %sp %sp 56 #1182	
	jal %ra o_param_z.2311 #1182
	addi %sp %sp -56 #1182
	lw %ra %sp 52 #1182
	lw %f1 %sp 0 #1182
	fsub %f0 %f1 %f0 #1182
	lw %a0 %sp 16 #1183
	sw %f0 %sp 48 #1183
	sw %ra %sp 60 #1183 call dir
	addi %sp %sp 64 #1183	
	jal %ra o_form.2291 #1183
	addi %sp %sp -64 #1183
	lw %ra %sp 60 #1183
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8621
	lw %f0 %sp 32 #1185
	lw %f1 %sp 40 #1185
	lw %f2 %sp 48 #1185
	lw %a0 %sp 16 #1185
	jal	%zero is_rect_outside.2486
beq_else.8621:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8622
	lw %f0 %sp 32 #1187
	lw %f1 %sp 40 #1187
	lw %f2 %sp 48 #1187
	lw %a0 %sp 16 #1187
	jal	%zero is_plane_outside.2491
beq_else.8622:
	lw %f0 %sp 32 #1189
	lw %f1 %sp 40 #1189
	lw %f2 %sp 48 #1189
	lw %a0 %sp 16 #1189
	jal	%zero is_second_outside.2496
check_all_inside.2506:
	lw %a2 %a11 4 #1193
	slli %a3 %a0 2 #1194
	add %a12 %a1 %a3 #1194
	lw %a3 %a12 0 #1194
	addi %a4 %zero 1 #1195
	sub %a4 %zero %a4 #1195
	bne %a3 %a4 beq_else.8623
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.8623:
	slli %a3 %a3 2 #20
	add %a12 %a2 %a3 #20
	lw %a2 %a12 0 #20
	sw %f2 %sp 0 #1198
	sw %f1 %sp 8 #1198
	sw %f0 %sp 16 #1198
	sw %a1 %sp 24 #1198
	sw %a11 %sp 28 #1198
	sw %a0 %sp 32 #1198
	add %a0 %a2 %zero
	sw %ra %sp 36 #1198 call dir
	addi %sp %sp 40 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -40 #1198
	lw %ra %sp 36 #1198
	addi %a1 %zero 0 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8624
	lw %a0 %sp 32 #1201
	addi %a0 %a0 1 #1201
	lw %f0 %sp 16 #1201
	lw %f1 %sp 8 #1201
	lw %f2 %sp 0 #1201
	lw %a1 %sp 24 #1201
	lw %a11 %sp 28 #1201
	lw %a10 %a11 0 #1201
	jalr %zero %a10 0 #1201
beq_else.8624:
	addi %a0 %a1 0 #1198
	jalr %zero %ra 0 #1198
shadow_check_and_group.2512:
	lw %a2 %a11 28 #1211
	lw %a3 %a11 24 #1211
	lw %a4 %a11 20 #1211
	lw %a5 %a11 16 #1211
	lw %a6 %a11 12 #1211
	lw %a7 %a11 8 #1211
	lw %a8 %a11 4 #1211
	slli %a9 %a0 2 #1212
	add %a12 %a1 %a9 #1212
	lw %a9 %a12 0 #1212
	addi %a10 %zero 1 #1212
	sub %a10 %zero %a10 #1212
	bne %a9 %a10 beq_else.8625
	addi %a0 %zero 0 #1213
	jalr %zero %ra 0 #1213
beq_else.8625:
	sw %a8 %sp 0 #1216
	sw %a7 %sp 4 #1216
	sw %a6 %sp 8 #1216
	sw %a1 %sp 12 #1216
	sw %a11 %sp 16 #1216
	sw %a0 %sp 20 #1216
	sw %a4 %sp 24 #1216
	sw %a9 %sp 28 #1216
	sw %a3 %sp 32 #1216
	add %a1 %a5 %zero
	add %a0 %a9 %zero
	add %a11 %a2 %zero
	add %a2 %a7 %zero
	sw %ra %sp 36 #1216 call cls
	lw %a10 %a11 0 #1216
	addi %sp %sp 40 #1216	
	jalr %ra %a10 0 #1216
	addi %sp %sp -40 #1216
	lw %ra %sp 36 #1216
	lw %a1 %sp 32 #37
	lw %f0 %a1 0 #37
	addi %a1 %zero 0 #1218
	sw %f0 %sp 40 #909
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8627 # nontail if
	addi %a0 %a1 0 #1218
	jal %zero beq_cont.8628 # then sentence ends
beq_else.8627:
	li %f1 l.5931 #1218
	sw %ra %sp 52 #1218 call dir
	addi %sp %sp 56 #1218	
	jal %ra min_caml_fless #1218
	addi %sp %sp -56 #1218
	lw %ra %sp 52 #1218
beq_cont.8628:
	addi %a1 %zero 0 #1218
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8629
	lw %a0 %sp 28 #20
	slli %a0 %a0 2 #20
	lw %a2 %sp 24 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	sw %a1 %sp 48 #1234
	sw %ra %sp 52 #1234 call dir
	addi %sp %sp 56 #1234	
	jal %ra o_isinvert.2295 #1234
	addi %sp %sp -56 #1234
	lw %ra %sp 52 #1234
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8630
	lw %a0 %sp 48 #1218
	jalr %zero %ra 0 #1218
beq_else.8630:
	lw %a0 %sp 20 #1235
	addi %a0 %a0 1 #1235
	lw %a1 %sp 12 #1235
	lw %a11 %sp 16 #1235
	lw %a10 %a11 0 #1235
	jalr %zero %a10 0 #1235
beq_else.8629:
	li %f0 l.5933 #1221
	lw %f1 %sp 40 #1221
	fadd %f0 %f1 %f0 #1221
	lw %a0 %sp 8 #27
	lw %f1 %a0 0 #27
	fmul %f1 %f1 %f0 #1222
	lw %a2 %sp 4 #43
	lw %f2 %a2 0 #43
	fadd %f1 %f1 %f2 #1222
	lw %f2 %a0 4 #27
	fmul %f2 %f2 %f0 #1223
	lw %f3 %a2 4 #43
	fadd %f2 %f2 %f3 #1223
	lw %f3 %a0 8 #27
	fmul %f0 %f3 %f0 #1224
	lw %f3 %a2 8 #43
	fadd %f0 %f0 %f3 #1224
	lw %a0 %sp 12 #1225
	lw %a11 %sp 0 #1225
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 52 #1225 call cls
	lw %a10 %a11 0 #1225
	addi %sp %sp 56 #1225	
	jalr %ra %a10 0 #1225
	addi %sp %sp -56 #1225
	lw %ra %sp 52 #1225
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8631
	lw %a0 %sp 20 #1228
	addi %a0 %a0 1 #1228
	lw %a1 %sp 12 #1228
	lw %a11 %sp 16 #1228
	lw %a10 %a11 0 #1228
	jalr %zero %a10 0 #1228
beq_else.8631:
	addi %a0 %zero 1 #1226
	jalr %zero %ra 0 #1226
shadow_check_one_or_group.2515:
	lw %a2 %a11 8 #1241
	lw %a3 %a11 4 #1241
	slli %a4 %a0 2 #1242
	add %a12 %a1 %a4 #1242
	lw %a4 %a12 0 #1242
	addi %a5 %zero 1 #1243
	sub %a5 %zero %a5 #1243
	bne %a4 %a5 beq_else.8632
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.8632:
	slli %a4 %a4 2 #31
	add %a12 %a3 %a4 #31
	lw %a3 %a12 0 #31
	addi %a4 %zero 0 #1247
	sw %a1 %sp 0 #1247
	sw %a11 %sp 4 #1247
	sw %a0 %sp 8 #1247
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	add %a11 %a2 %zero
	sw %ra %sp 12 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 16 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -16 #1247
	lw %ra %sp 12 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8633
	lw %a0 %sp 8 #1251
	addi %a0 %a0 1 #1251
	lw %a1 %sp 0 #1251
	lw %a11 %sp 4 #1251
	lw %a10 %a11 0 #1251
	jalr %zero %a10 0 #1251
beq_else.8633:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
shadow_check_one_or_matrix.2518:
	lw %a2 %a11 20 #1256
	lw %a3 %a11 16 #1256
	lw %a4 %a11 12 #1256
	lw %a5 %a11 8 #1256
	lw %a6 %a11 4 #1256
	slli %a7 %a0 2 #1257
	add %a12 %a1 %a7 #1257
	lw %a7 %a12 0 #1257
	lw %a8 %a7 0 #1258
	addi %a9 %zero 1 #1259
	sub %a9 %zero %a9 #1259
	bne %a8 %a9 beq_else.8634
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.8634:
	sw %a7 %sp 0 #1259
	sw %a4 %sp 4 #1259
	sw %a1 %sp 8 #1259
	sw %a11 %sp 12 #1259
	sw %a0 %sp 16 #1259
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.8635 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.8636 # then sentence ends
beq_else.8635:
	sw %a3 %sp 20 #1266
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	add %a11 %a2 %zero
	add %a2 %a6 %zero
	sw %ra %sp 28 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 32 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -32 #1266
	lw %ra %sp 28 #1266
	addi %a1 %zero 0 #1269
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8637 # nontail if
	addi %a0 %a1 0 #1269
	jal %zero beq_cont.8638 # then sentence ends
beq_else.8637:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	li %f1 l.5947 #1270
	sw %a1 %sp 24 #1270
	sw %ra %sp 28 #1270 call dir
	addi %sp %sp 32 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -32 #1270
	lw %ra %sp 28 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8639 # nontail if
	lw %a0 %sp 24 #1269
	jal %zero beq_cont.8640 # then sentence ends
beq_else.8639:
	addi %a0 %zero 1 #1271
	lw %a1 %sp 0 #1271
	lw %a11 %sp 4 #1271
	sw %ra %sp 28 #1271 call cls
	lw %a10 %a11 0 #1271
	addi %sp %sp 32 #1271	
	jalr %ra %a10 0 #1271
	addi %sp %sp -32 #1271
	lw %ra %sp 28 #1271
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8641 # nontail if
	lw %a0 %sp 24 #1269
	jal %zero beq_cont.8642 # then sentence ends
beq_else.8641:
	addi %a0 %zero 1 #1272
beq_cont.8642:
beq_cont.8640:
beq_cont.8638:
beq_cont.8636:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8643
	lw %a0 %sp 16 #1282
	addi %a0 %a0 1 #1282
	lw %a1 %sp 8 #1282
	lw %a11 %sp 12 #1282
	lw %a10 %a11 0 #1282
	jalr %zero %a10 0 #1282
beq_else.8643:
	addi %a0 %zero 1 #1277
	lw %a1 %sp 0 #1277
	lw %a11 %sp 4 #1277
	sw %ra %sp 28 #1277 call cls
	lw %a10 %a11 0 #1277
	addi %sp %sp 32 #1277	
	jalr %ra %a10 0 #1277
	addi %sp %sp -32 #1277
	lw %ra %sp 28 #1277
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8644
	lw %a0 %sp 16 #1280
	addi %a0 %a0 1 #1280
	lw %a1 %sp 8 #1280
	lw %a11 %sp 12 #1280
	lw %a10 %a11 0 #1280
	jalr %zero %a10 0 #1280
beq_else.8644:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
solve_each_element.2521:
	lw %a3 %a11 36 #1290
	lw %a4 %a11 32 #1290
	lw %a5 %a11 28 #1290
	lw %a6 %a11 24 #1290
	lw %a7 %a11 20 #1290
	lw %a8 %a11 16 #1290
	lw %a9 %a11 12 #1290
	lw %a10 %a11 8 #1290
	sw %a8 %sp 0 #1290
	lw %a8 %a11 4 #1290
	sw %a10 %sp 4 #1291
	slli %a10 %a0 2 #1291
	add %a12 %a1 %a10 #1291
	lw %a10 %a12 0 #1291
	sw %a9 %sp 8 #1292
	addi %a9 %zero 1 #1292
	sub %a9 %zero %a9 #1292
	bne %a10 %a9 beq_else.8645
	jalr %zero %ra 0 #1292
beq_else.8645:
	sw %a8 %sp 12 #1294
	sw %a4 %sp 16 #1294
	sw %a3 %sp 20 #1294
	sw %a5 %sp 24 #1294
	sw %a2 %sp 28 #1294
	sw %a1 %sp 32 #1294
	sw %a11 %sp 36 #1294
	sw %a0 %sp 40 #1294
	sw %a7 %sp 44 #1294
	sw %a10 %sp 48 #1294
	add %a1 %a2 %zero
	add %a0 %a10 %zero
	add %a11 %a6 %zero
	add %a2 %a4 %zero
	sw %ra %sp 52 #1294 call cls
	lw %a10 %a11 0 #1294
	addi %sp %sp 56 #1294	
	jalr %ra %a10 0 #1294
	addi %sp %sp -56 #1294
	lw %ra %sp 52 #1294
	addi %a1 %zero 0 #1295
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8647
	lw %a0 %sp 48 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 44 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	sw %ra %sp 52 #1323 call dir
	addi %sp %sp 56 #1323	
	jal %ra o_isinvert.2295 #1323
	addi %sp %sp -56 #1323
	lw %ra %sp 52 #1323
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8648
	jalr %zero %ra 0 #1325
beq_else.8648:
	lw %a0 %sp 40 #1324
	addi %a0 %a0 1 #1324
	lw %a1 %sp 32 #1324
	lw %a2 %sp 28 #1324
	lw %a11 %sp 36 #1324
	lw %a10 %a11 0 #1324
	jalr %zero %a10 0 #1324
beq_else.8647:
	lw %a2 %sp 24 #37
	lw %f1 %a2 0 #37
	li %f0 l.5551 #1301
	sw %a0 %sp 52 #1301
	sw %a1 %sp 56 #1301
	sw %f1 %sp 64 #1301
	sw %ra %sp 76 #1301 call dir
	addi %sp %sp 80 #1301	
	jal %ra min_caml_fless #1301
	addi %sp %sp -80 #1301
	lw %ra %sp 76 #1301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8651 # nontail if
	jal %zero beq_cont.8652 # then sentence ends
beq_else.8651:
	lw %a0 %sp 20 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 64 #1302
	sw %ra %sp 76 #1302 call dir
	addi %sp %sp 80 #1302	
	jal %ra min_caml_fless #1302
	addi %sp %sp -80 #1302
	lw %ra %sp 76 #1302
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8653 # nontail if
	jal %zero beq_cont.8654 # then sentence ends
beq_else.8653:
	li %f0 l.5933 #1304
	lw %f1 %sp 64 #1304
	fadd %f0 %f1 %f0 #1304
	lw %a0 %sp 28 #783
	lw %f1 %a0 0 #783
	fmul %f1 %f1 %f0 #1305
	lw %a1 %sp 16 #64
	lw %f2 %a1 0 #64
	fadd %f1 %f1 %f2 #1305
	lw %f2 %a0 4 #783
	fmul %f2 %f2 %f0 #1306
	lw %f3 %a1 4 #64
	fadd %f2 %f2 %f3 #1306
	lw %f3 %a0 8 #783
	fmul %f3 %f3 %f0 #1307
	lw %f4 %a1 8 #64
	fadd %f3 %f3 %f4 #1307
	lw %a1 %sp 56 #1308
	lw %a2 %sp 32 #1308
	lw %a11 %sp 12 #1308
	sw %f3 %sp 72 #1308
	sw %f2 %sp 80 #1308
	sw %f1 %sp 88 #1308
	sw %f0 %sp 96 #1308
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 108 #1308 call cls
	lw %a10 %a11 0 #1308
	addi %sp %sp 112 #1308	
	jalr %ra %a10 0 #1308
	addi %sp %sp -112 #1308
	lw %ra %sp 108 #1308
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8655 # nontail if
	jal %zero beq_cont.8656 # then sentence ends
beq_else.8655:
	lw %a0 %sp 20 #1310
	lw %f0 %sp 96 #1310
	sw %f0 %a0 0 #1310
	lw %f0 %sp 88 #1311
	lw %f1 %sp 80 #1311
	lw %f2 %sp 72 #1311
	lw %a0 %sp 8 #1311
	sw %ra %sp 108 #1311 call dir
	addi %sp %sp 112 #1311	
	jal %ra vecset.2243 #1311
	addi %sp %sp -112 #1311
	lw %ra %sp 108 #1311
	lw %a0 %sp 4 #1312
	lw %a1 %sp 48 #1312
	sw %a1 %a0 0 #1312
	lw %a0 %sp 0 #1313
	lw %a1 %sp 52 #1313
	sw %a1 %a0 0 #1313
beq_cont.8656:
beq_cont.8654:
beq_cont.8652:
	lw %a0 %sp 40 #1319
	addi %a0 %a0 1 #1319
	lw %a1 %sp 32 #1319
	lw %a2 %sp 28 #1319
	lw %a11 %sp 36 #1319
	lw %a10 %a11 0 #1319
	jalr %zero %a10 0 #1319
solve_one_or_network.2525:
	lw %a3 %a11 8 #1331
	lw %a4 %a11 4 #1331
	slli %a5 %a0 2 #1332
	add %a12 %a1 %a5 #1332
	lw %a5 %a12 0 #1332
	addi %a6 %zero 1 #1333
	sub %a6 %zero %a6 #1333
	bne %a5 %a6 beq_else.8657
	jalr %zero %ra 0 #1337
beq_else.8657:
	slli %a5 %a5 2 #31
	add %a12 %a4 %a5 #31
	lw %a4 %a12 0 #31
	addi %a5 %zero 0 #1335
	sw %a2 %sp 0 #1335
	sw %a1 %sp 4 #1335
	sw %a11 %sp 8 #1335
	sw %a0 %sp 12 #1335
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 24 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -24 #1335
	lw %ra %sp 20 #1335
	lw %a0 %sp 12 #1336
	addi %a0 %a0 1 #1336
	lw %a1 %sp 4 #1336
	lw %a2 %sp 0 #1336
	lw %a11 %sp 8 #1336
	lw %a10 %a11 0 #1336
	jalr %zero %a10 0 #1336
trace_or_matrix.2529:
	lw %a3 %a11 20 #1341
	lw %a4 %a11 16 #1341
	lw %a5 %a11 12 #1341
	lw %a6 %a11 8 #1341
	lw %a7 %a11 4 #1341
	slli %a8 %a0 2 #1342
	add %a12 %a1 %a8 #1342
	lw %a8 %a12 0 #1342
	lw %a9 %a8 0 #1343
	addi %a10 %zero 1 #1344
	sub %a10 %zero %a10 #1344
	bne %a9 %a10 beq_else.8659
	jalr %zero %ra 0 #1345
beq_else.8659:
	sw %a2 %sp 0 #1344
	sw %a1 %sp 4 #1344
	sw %a11 %sp 8 #1344
	sw %a0 %sp 12 #1344
	addi %a12 %zero 99
	bne %a9 %a12 beq_else.8661 # nontail if
	addi %a3 %zero 1 #1348
	add %a1 %a8 %zero
	add %a0 %a3 %zero
	add %a11 %a7 %zero
	sw %ra %sp 20 #1348 call cls
	lw %a10 %a11 0 #1348
	addi %sp %sp 24 #1348	
	jalr %ra %a10 0 #1348
	addi %sp %sp -24 #1348
	lw %ra %sp 20 #1348
	jal %zero beq_cont.8662 # then sentence ends
beq_else.8661:
	sw %a8 %sp 16 #1352
	sw %a7 %sp 20 #1352
	sw %a3 %sp 24 #1352
	sw %a5 %sp 28 #1352
	add %a1 %a2 %zero
	add %a0 %a9 %zero
	add %a11 %a6 %zero
	add %a2 %a4 %zero
	sw %ra %sp 36 #1352 call cls
	lw %a10 %a11 0 #1352
	addi %sp %sp 40 #1352	
	jalr %ra %a10 0 #1352
	addi %sp %sp -40 #1352
	lw %ra %sp 36 #1352
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8663 # nontail if
	jal %zero beq_cont.8664 # then sentence ends
beq_else.8663:
	lw %a0 %sp 28 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 24 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 36 #1355 call dir
	addi %sp %sp 40 #1355	
	jal %ra min_caml_fless #1355
	addi %sp %sp -40 #1355
	lw %ra %sp 36 #1355
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8665 # nontail if
	jal %zero beq_cont.8666 # then sentence ends
beq_else.8665:
	addi %a0 %zero 1 #1356
	lw %a1 %sp 16 #1356
	lw %a2 %sp 0 #1356
	lw %a11 %sp 20 #1356
	sw %ra %sp 36 #1356 call cls
	lw %a10 %a11 0 #1356
	addi %sp %sp 40 #1356	
	jalr %ra %a10 0 #1356
	addi %sp %sp -40 #1356
	lw %ra %sp 36 #1356
beq_cont.8666:
beq_cont.8664:
beq_cont.8662:
	lw %a0 %sp 12 #1360
	addi %a0 %a0 1 #1360
	lw %a1 %sp 4 #1360
	lw %a2 %sp 0 #1360
	lw %a11 %sp 8 #1360
	lw %a10 %a11 0 #1360
	jalr %zero %a10 0 #1360
judge_intersection.2533:
	lw %a1 %a11 12 #1368
	lw %a2 %a11 8 #1368
	lw %a3 %a11 4 #1368
	li %f0 l.5970 #1369
	sw %f0 %a2 0 #1369
	addi %a4 %zero 0 #1370
	lw %a3 %a3 0 #33
	sw %a2 %sp 0 #1370
	add %a2 %a0 %zero
	add %a11 %a1 %zero
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	sw %ra %sp 4 #1370 call cls
	lw %a10 %a11 0 #1370
	addi %sp %sp 8 #1370	
	jalr %ra %a10 0 #1370
	addi %sp %sp -8 #1370
	lw %ra %sp 4 #1370
	lw %a0 %sp 0 #41
	lw %f1 %a0 0 #41
	li %f0 l.5947 #1373
	sw %f1 %sp 8 #1373
	sw %ra %sp 20 #1373 call dir
	addi %sp %sp 24 #1373	
	jal %ra min_caml_fless #1373
	addi %sp %sp -24 #1373
	lw %ra %sp 20 #1373
	addi %a1 %zero 0 #1373
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8668
	addi %a0 %a1 0 #1373
	jalr %zero %ra 0 #1373
beq_else.8668:
	li %f1 l.5976 #1374
	lw %f0 %sp 8 #1374
	jal	%zero min_caml_fless
solve_each_element_fast.2535:
	lw %a3 %a11 36 #1381
	lw %a4 %a11 32 #1381
	lw %a5 %a11 28 #1381
	lw %a6 %a11 24 #1381
	lw %a7 %a11 20 #1381
	lw %a8 %a11 16 #1381
	lw %a9 %a11 12 #1381
	lw %a10 %a11 8 #1381
	sw %a8 %sp 0 #1381
	lw %a8 %a11 4 #1381
	sw %a10 %sp 4 #1382
	sw %a9 %sp 8 #1382
	sw %a8 %sp 12 #1382
	sw %a4 %sp 16 #1382
	sw %a3 %sp 20 #1382
	sw %a6 %sp 24 #1382
	sw %a11 %sp 28 #1382
	sw %a7 %sp 32 #1382
	sw %a2 %sp 36 #1382
	sw %a5 %sp 40 #1382
	sw %a1 %sp 44 #1382
	sw %a0 %sp 48 #1382
	add %a0 %a2 %zero
	sw %ra %sp 52 #1382 call dir
	addi %sp %sp 56 #1382	
	jal %ra d_vec.2350 #1382
	addi %sp %sp -56 #1382
	lw %ra %sp 52 #1382
	lw %a1 %sp 48 #1383
	slli %a2 %a1 2 #1383
	lw %a3 %sp 44 #1383
	add %a12 %a3 %a2 #1383
	lw %a2 %a12 0 #1383
	addi %a4 %zero 1 #1384
	sub %a4 %zero %a4 #1384
	bne %a2 %a4 beq_else.8669
	jalr %zero %ra 0 #1384
beq_else.8669:
	lw %a4 %sp 36 #1386
	lw %a11 %sp 40 #1386
	sw %a0 %sp 52 #1386
	sw %a2 %sp 56 #1386
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 60 #1386 call cls
	lw %a10 %a11 0 #1386
	addi %sp %sp 64 #1386	
	jalr %ra %a10 0 #1386
	addi %sp %sp -64 #1386
	lw %ra %sp 60 #1386
	addi %a1 %zero 0 #1387
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8671
	lw %a0 %sp 56 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 32 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	sw %ra %sp 60 #1415 call dir
	addi %sp %sp 64 #1415	
	jal %ra o_isinvert.2295 #1415
	addi %sp %sp -64 #1415
	lw %ra %sp 60 #1415
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8672
	jalr %zero %ra 0 #1417
beq_else.8672:
	lw %a0 %sp 48 #1416
	addi %a0 %a0 1 #1416
	lw %a1 %sp 44 #1416
	lw %a2 %sp 36 #1416
	lw %a11 %sp 28 #1416
	lw %a10 %a11 0 #1416
	jalr %zero %a10 0 #1416
beq_else.8671:
	lw %a2 %sp 24 #37
	lw %f1 %a2 0 #37
	li %f0 l.5551 #1393
	sw %a0 %sp 60 #1393
	sw %a1 %sp 64 #1393
	sw %f1 %sp 72 #1393
	sw %ra %sp 84 #1393 call dir
	addi %sp %sp 88 #1393	
	jal %ra min_caml_fless #1393
	addi %sp %sp -88 #1393
	lw %ra %sp 84 #1393
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8675 # nontail if
	jal %zero beq_cont.8676 # then sentence ends
beq_else.8675:
	lw %a0 %sp 20 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 72 #1394
	sw %ra %sp 84 #1394 call dir
	addi %sp %sp 88 #1394	
	jal %ra min_caml_fless #1394
	addi %sp %sp -88 #1394
	lw %ra %sp 84 #1394
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8677 # nontail if
	jal %zero beq_cont.8678 # then sentence ends
beq_else.8677:
	li %f0 l.5933 #1396
	lw %f1 %sp 72 #1396
	fadd %f0 %f1 %f0 #1396
	lw %a0 %sp 52 #903
	lw %f1 %a0 0 #903
	fmul %f1 %f1 %f0 #1397
	lw %a1 %sp 16 #66
	lw %f2 %a1 0 #66
	fadd %f1 %f1 %f2 #1397
	lw %f2 %a0 4 #903
	fmul %f2 %f2 %f0 #1398
	lw %f3 %a1 4 #66
	fadd %f2 %f2 %f3 #1398
	lw %f3 %a0 8 #903
	fmul %f3 %f3 %f0 #1399
	lw %f4 %a1 8 #66
	fadd %f3 %f3 %f4 #1399
	lw %a0 %sp 64 #1400
	lw %a1 %sp 44 #1400
	lw %a11 %sp 12 #1400
	sw %f3 %sp 80 #1400
	sw %f2 %sp 88 #1400
	sw %f1 %sp 96 #1400
	sw %f0 %sp 104 #1400
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 116 #1400 call cls
	lw %a10 %a11 0 #1400
	addi %sp %sp 120 #1400	
	jalr %ra %a10 0 #1400
	addi %sp %sp -120 #1400
	lw %ra %sp 116 #1400
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8679 # nontail if
	jal %zero beq_cont.8680 # then sentence ends
beq_else.8679:
	lw %a0 %sp 20 #1402
	lw %f0 %sp 104 #1402
	sw %f0 %a0 0 #1402
	lw %f0 %sp 96 #1403
	lw %f1 %sp 88 #1403
	lw %f2 %sp 80 #1403
	lw %a0 %sp 8 #1403
	sw %ra %sp 116 #1403 call dir
	addi %sp %sp 120 #1403	
	jal %ra vecset.2243 #1403
	addi %sp %sp -120 #1403
	lw %ra %sp 116 #1403
	lw %a0 %sp 4 #1404
	lw %a1 %sp 56 #1404
	sw %a1 %a0 0 #1404
	lw %a0 %sp 0 #1405
	lw %a1 %sp 60 #1405
	sw %a1 %a0 0 #1405
beq_cont.8680:
beq_cont.8678:
beq_cont.8676:
	lw %a0 %sp 48 #1411
	addi %a0 %a0 1 #1411
	lw %a1 %sp 44 #1411
	lw %a2 %sp 36 #1411
	lw %a11 %sp 28 #1411
	lw %a10 %a11 0 #1411
	jalr %zero %a10 0 #1411
solve_one_or_network_fast.2539:
	lw %a3 %a11 8 #1422
	lw %a4 %a11 4 #1422
	slli %a5 %a0 2 #1423
	add %a12 %a1 %a5 #1423
	lw %a5 %a12 0 #1423
	addi %a6 %zero 1 #1424
	sub %a6 %zero %a6 #1424
	bne %a5 %a6 beq_else.8681
	jalr %zero %ra 0 #1428
beq_else.8681:
	slli %a5 %a5 2 #31
	add %a12 %a4 %a5 #31
	lw %a4 %a12 0 #31
	addi %a5 %zero 0 #1426
	sw %a2 %sp 0 #1426
	sw %a1 %sp 4 #1426
	sw %a11 %sp 8 #1426
	sw %a0 %sp 12 #1426
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 24 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -24 #1426
	lw %ra %sp 20 #1426
	lw %a0 %sp 12 #1427
	addi %a0 %a0 1 #1427
	lw %a1 %sp 4 #1427
	lw %a2 %sp 0 #1427
	lw %a11 %sp 8 #1427
	lw %a10 %a11 0 #1427
	jalr %zero %a10 0 #1427
trace_or_matrix_fast.2543:
	lw %a3 %a11 16 #1432
	lw %a4 %a11 12 #1432
	lw %a5 %a11 8 #1432
	lw %a6 %a11 4 #1432
	slli %a7 %a0 2 #1433
	add %a12 %a1 %a7 #1433
	lw %a7 %a12 0 #1433
	lw %a8 %a7 0 #1434
	addi %a9 %zero 1 #1435
	sub %a9 %zero %a9 #1435
	bne %a8 %a9 beq_else.8683
	jalr %zero %ra 0 #1436
beq_else.8683:
	sw %a2 %sp 0 #1435
	sw %a1 %sp 4 #1435
	sw %a11 %sp 8 #1435
	sw %a0 %sp 12 #1435
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.8685 # nontail if
	addi %a3 %zero 1 #1439
	add %a1 %a7 %zero
	add %a0 %a3 %zero
	add %a11 %a6 %zero
	sw %ra %sp 20 #1439 call cls
	lw %a10 %a11 0 #1439
	addi %sp %sp 24 #1439	
	jalr %ra %a10 0 #1439
	addi %sp %sp -24 #1439
	lw %ra %sp 20 #1439
	jal %zero beq_cont.8686 # then sentence ends
beq_else.8685:
	sw %a7 %sp 16 #1443
	sw %a6 %sp 20 #1443
	sw %a3 %sp 24 #1443
	sw %a5 %sp 28 #1443
	add %a1 %a2 %zero
	add %a0 %a8 %zero
	add %a11 %a4 %zero
	sw %ra %sp 36 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 40 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -40 #1443
	lw %ra %sp 36 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8687 # nontail if
	jal %zero beq_cont.8688 # then sentence ends
beq_else.8687:
	lw %a0 %sp 28 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 24 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 36 #1446 call dir
	addi %sp %sp 40 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -40 #1446
	lw %ra %sp 36 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8689 # nontail if
	jal %zero beq_cont.8690 # then sentence ends
beq_else.8689:
	addi %a0 %zero 1 #1447
	lw %a1 %sp 16 #1447
	lw %a2 %sp 0 #1447
	lw %a11 %sp 20 #1447
	sw %ra %sp 36 #1447 call cls
	lw %a10 %a11 0 #1447
	addi %sp %sp 40 #1447	
	jalr %ra %a10 0 #1447
	addi %sp %sp -40 #1447
	lw %ra %sp 36 #1447
beq_cont.8690:
beq_cont.8688:
beq_cont.8686:
	lw %a0 %sp 12 #1451
	addi %a0 %a0 1 #1451
	lw %a1 %sp 4 #1451
	lw %a2 %sp 0 #1451
	lw %a11 %sp 8 #1451
	lw %a10 %a11 0 #1451
	jalr %zero %a10 0 #1451
judge_intersection_fast.2547:
	lw %a1 %a11 12 #1456
	lw %a2 %a11 8 #1456
	lw %a3 %a11 4 #1456
	li %f0 l.5970 #1458
	sw %f0 %a2 0 #1458
	addi %a4 %zero 0 #1459
	lw %a3 %a3 0 #33
	sw %a2 %sp 0 #1459
	add %a2 %a0 %zero
	add %a11 %a1 %zero
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	sw %ra %sp 4 #1459 call cls
	lw %a10 %a11 0 #1459
	addi %sp %sp 8 #1459	
	jalr %ra %a10 0 #1459
	addi %sp %sp -8 #1459
	lw %ra %sp 4 #1459
	lw %a0 %sp 0 #41
	lw %f1 %a0 0 #41
	li %f0 l.5947 #1462
	sw %f1 %sp 8 #1462
	sw %ra %sp 20 #1462 call dir
	addi %sp %sp 24 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -24 #1462
	lw %ra %sp 20 #1462
	addi %a1 %zero 0 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8692
	addi %a0 %a1 0 #1462
	jalr %zero %ra 0 #1462
beq_else.8692:
	li %f1 l.5976 #1463
	lw %f0 %sp 8 #1463
	jal	%zero min_caml_fless
get_nvector_rect.2549:
	lw %a1 %a11 8 #1475
	lw %a2 %a11 4 #1475
	lw %a2 %a2 0 #39
	sw %a1 %sp 0 #1478
	sw %a0 %sp 4 #1478
	sw %a2 %sp 8 #1478
	add %a0 %a1 %zero
	sw %ra %sp 12 #1478 call dir
	addi %sp %sp 16 #1478	
	jal %ra vecbzero.2251 #1478
	addi %sp %sp -16 #1478
	lw %ra %sp 12 #1478
	lw %a0 %sp 8 #1479
	addi %a1 %a0 -1 #1479
	addi %a0 %a0 -1 #1479
	slli %a0 %a0 2 #1479
	lw %a2 %sp 4 #1479
	add %a12 %a2 %a0 #1479
	lw %f0 %a12 0 #1479
	sw %a1 %sp 12 #1479
	sw %ra %sp 20 #1479 call dir
	addi %sp %sp 24 #1479	
	jal %ra sgn.2235 #1479
	addi %sp %sp -24 #1479
	lw %ra %sp 20 #1479
	sw %ra %sp 20 #1479 call dir
	addi %sp %sp 24 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -24 #1479
	lw %ra %sp 20 #1479
	lw %a0 %sp 12 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 0 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jalr %zero %ra 0 #1479
get_nvector_plane.2551:
	lw %a1 %a11 4 #1483
	sw %a0 %sp 0 #1485
	sw %a1 %sp 4 #1485
	sw %ra %sp 12 #1485 call dir
	addi %sp %sp 16 #1485	
	jal %ra o_param_a.2299 #1485
	addi %sp %sp -16 #1485
	lw %ra %sp 12 #1485
	sw %ra %sp 12 #1485 call dir
	addi %sp %sp 16 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -16 #1485
	lw %ra %sp 12 #1485
	lw %a0 %sp 4 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 0 #1486
	add %a0 %a1 %zero
	sw %ra %sp 12 #1486 call dir
	addi %sp %sp 16 #1486	
	jal %ra o_param_b.2301 #1486
	addi %sp %sp -16 #1486
	lw %ra %sp 12 #1486
	sw %ra %sp 12 #1486 call dir
	addi %sp %sp 16 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -16 #1486
	lw %ra %sp 12 #1486
	lw %a0 %sp 4 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 0 #1487
	add %a0 %a1 %zero
	sw %ra %sp 12 #1487 call dir
	addi %sp %sp 16 #1487	
	jal %ra o_param_c.2303 #1487
	addi %sp %sp -16 #1487
	lw %ra %sp 12 #1487
	sw %ra %sp 12 #1487 call dir
	addi %sp %sp 16 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -16 #1487
	lw %ra %sp 12 #1487
	lw %a0 %sp 4 #1487
	sw %f0 %a0 8 #1487
	jalr %zero %ra 0 #1487
get_nvector_second.2553:
	lw %a1 %a11 8 #1491
	lw %a2 %a11 4 #1491
	lw %f0 %a2 0 #43
	sw %a1 %sp 0 #1492
	sw %a0 %sp 4 #1492
	sw %a2 %sp 8 #1492
	sw %f0 %sp 16 #1492
	sw %ra %sp 28 #1492 call dir
	addi %sp %sp 32 #1492	
	jal %ra o_param_x.2307 #1492
	addi %sp %sp -32 #1492
	lw %ra %sp 28 #1492
	lw %f1 %sp 16 #1492
	fsub %f0 %f1 %f0 #1492
	lw %a0 %sp 8 #43
	lw %f1 %a0 4 #43
	lw %a1 %sp 4 #1493
	sw %f0 %sp 24 #1493
	sw %f1 %sp 32 #1493
	add %a0 %a1 %zero
	sw %ra %sp 44 #1493 call dir
	addi %sp %sp 48 #1493	
	jal %ra o_param_y.2309 #1493
	addi %sp %sp -48 #1493
	lw %ra %sp 44 #1493
	lw %f1 %sp 32 #1493
	fsub %f0 %f1 %f0 #1493
	lw %a0 %sp 8 #43
	lw %f1 %a0 8 #43
	lw %a0 %sp 4 #1494
	sw %f0 %sp 40 #1494
	sw %f1 %sp 48 #1494
	sw %ra %sp 60 #1494 call dir
	addi %sp %sp 64 #1494	
	jal %ra o_param_z.2311 #1494
	addi %sp %sp -64 #1494
	lw %ra %sp 60 #1494
	lw %f1 %sp 48 #1494
	fsub %f0 %f1 %f0 #1494
	lw %a0 %sp 4 #1496
	sw %f0 %sp 56 #1496
	sw %ra %sp 68 #1496 call dir
	addi %sp %sp 72 #1496	
	jal %ra o_param_a.2299 #1496
	addi %sp %sp -72 #1496
	lw %ra %sp 68 #1496
	lw %f1 %sp 24 #1496
	fmul %f0 %f1 %f0 #1496
	lw %a0 %sp 4 #1497
	sw %f0 %sp 64 #1497
	sw %ra %sp 76 #1497 call dir
	addi %sp %sp 80 #1497	
	jal %ra o_param_b.2301 #1497
	addi %sp %sp -80 #1497
	lw %ra %sp 76 #1497
	lw %f1 %sp 40 #1497
	fmul %f0 %f1 %f0 #1497
	lw %a0 %sp 4 #1498
	sw %f0 %sp 72 #1498
	sw %ra %sp 84 #1498 call dir
	addi %sp %sp 88 #1498	
	jal %ra o_param_c.2303 #1498
	addi %sp %sp -88 #1498
	lw %ra %sp 84 #1498
	lw %f1 %sp 56 #1498
	fmul %f0 %f1 %f0 #1498
	lw %a0 %sp 4 #1500
	sw %f0 %sp 80 #1500
	sw %ra %sp 92 #1500 call dir
	addi %sp %sp 96 #1500	
	jal %ra o_isrot.2297 #1500
	addi %sp %sp -96 #1500
	lw %ra %sp 92 #1500
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8696 # nontail if
	lw %a0 %sp 0 #1501
	lw %f0 %sp 64 #1501
	sw %f0 %a0 0 #1501
	lw %f0 %sp 72 #1502
	sw %f0 %a0 4 #1502
	lw %f0 %sp 80 #1503
	sw %f0 %a0 8 #1503
	jal %zero beq_cont.8697 # then sentence ends
beq_else.8696:
	lw %a0 %sp 4 #1505
	sw %ra %sp 92 #1505 call dir
	addi %sp %sp 96 #1505	
	jal %ra o_param_r3.2327 #1505
	addi %sp %sp -96 #1505
	lw %ra %sp 92 #1505
	lw %f1 %sp 40 #1505
	fmul %f0 %f1 %f0 #1505
	lw %a0 %sp 4 #1505
	sw %f0 %sp 88 #1505
	sw %ra %sp 100 #1505 call dir
	addi %sp %sp 104 #1505	
	jal %ra o_param_r2.2325 #1505
	addi %sp %sp -104 #1505
	lw %ra %sp 100 #1505
	lw %f1 %sp 56 #1505
	fmul %f0 %f1 %f0 #1505
	lw %f2 %sp 88 #1505
	fadd %f0 %f2 %f0 #1505
	sw %ra %sp 100 #1505 call dir
	addi %sp %sp 104 #1505	
	jal %ra min_caml_fhalf #1505
	addi %sp %sp -104 #1505
	lw %ra %sp 100 #1505
	lw %f1 %sp 64 #1505
	fadd %f0 %f1 %f0 #1505
	lw %a0 %sp 0 #1505
	sw %f0 %a0 0 #1505
	lw %a1 %sp 4 #1506
	add %a0 %a1 %zero
	sw %ra %sp 100 #1506 call dir
	addi %sp %sp 104 #1506	
	jal %ra o_param_r3.2327 #1506
	addi %sp %sp -104 #1506
	lw %ra %sp 100 #1506
	lw %f1 %sp 24 #1506
	fmul %f0 %f1 %f0 #1506
	lw %a0 %sp 4 #1506
	sw %f0 %sp 96 #1506
	sw %ra %sp 108 #1506 call dir
	addi %sp %sp 112 #1506	
	jal %ra o_param_r1.2323 #1506
	addi %sp %sp -112 #1506
	lw %ra %sp 108 #1506
	lw %f1 %sp 56 #1506
	fmul %f0 %f1 %f0 #1506
	lw %f1 %sp 96 #1506
	fadd %f0 %f1 %f0 #1506
	sw %ra %sp 108 #1506 call dir
	addi %sp %sp 112 #1506	
	jal %ra min_caml_fhalf #1506
	addi %sp %sp -112 #1506
	lw %ra %sp 108 #1506
	lw %f1 %sp 72 #1506
	fadd %f0 %f1 %f0 #1506
	lw %a0 %sp 0 #1506
	sw %f0 %a0 4 #1506
	lw %a1 %sp 4 #1507
	add %a0 %a1 %zero
	sw %ra %sp 108 #1507 call dir
	addi %sp %sp 112 #1507	
	jal %ra o_param_r2.2325 #1507
	addi %sp %sp -112 #1507
	lw %ra %sp 108 #1507
	lw %f1 %sp 24 #1507
	fmul %f0 %f1 %f0 #1507
	lw %a0 %sp 4 #1507
	sw %f0 %sp 104 #1507
	sw %ra %sp 116 #1507 call dir
	addi %sp %sp 120 #1507	
	jal %ra o_param_r1.2323 #1507
	addi %sp %sp -120 #1507
	lw %ra %sp 116 #1507
	lw %f1 %sp 40 #1507
	fmul %f0 %f1 %f0 #1507
	lw %f1 %sp 104 #1507
	fadd %f0 %f1 %f0 #1507
	sw %ra %sp 116 #1507 call dir
	addi %sp %sp 120 #1507	
	jal %ra min_caml_fhalf #1507
	addi %sp %sp -120 #1507
	lw %ra %sp 116 #1507
	lw %f1 %sp 80 #1507
	fadd %f0 %f1 %f0 #1507
	lw %a0 %sp 0 #1507
	sw %f0 %a0 8 #1507
beq_cont.8697:
	lw %a1 %sp 4 #1509
	add %a0 %a1 %zero
	sw %ra %sp 116 #1509 call dir
	addi %sp %sp 120 #1509	
	jal %ra o_isinvert.2295 #1509
	addi %sp %sp -120 #1509
	lw %ra %sp 116 #1509
	add %a1 %a0 %zero #1509
	lw %a0 %sp 0 #1509
	jal	%zero vecunit_sgn.2261
get_nvector.2555:
	lw %a2 %a11 12 #1513
	lw %a3 %a11 8 #1513
	lw %a4 %a11 4 #1513
	sw %a2 %sp 0 #1514
	sw %a0 %sp 4 #1514
	sw %a4 %sp 8 #1514
	sw %a1 %sp 12 #1514
	sw %a3 %sp 16 #1514
	sw %ra %sp 20 #1514 call dir
	addi %sp %sp 24 #1514	
	jal %ra o_form.2291 #1514
	addi %sp %sp -24 #1514
	lw %ra %sp 20 #1514
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8698
	lw %a0 %sp 12 #1516
	lw %a11 %sp 16 #1516
	lw %a10 %a11 0 #1516
	jalr %zero %a10 0 #1516
beq_else.8698:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8699
	lw %a0 %sp 4 #1518
	lw %a11 %sp 8 #1518
	lw %a10 %a11 0 #1518
	jalr %zero %a10 0 #1518
beq_else.8699:
	lw %a0 %sp 4 #1520
	lw %a11 %sp 0 #1520
	lw %a10 %a11 0 #1520
	jalr %zero %a10 0 #1520
utexture.2558:
	lw %a2 %a11 4 #1527
	sw %a1 %sp 0 #1528
	sw %a2 %sp 4 #1528
	sw %a0 %sp 8 #1528
	sw %ra %sp 12 #1528 call dir
	addi %sp %sp 16 #1528	
	jal %ra o_texturetype.2289 #1528
	addi %sp %sp -16 #1528
	lw %ra %sp 12 #1528
	lw %a1 %sp 8 #1530
	sw %a0 %sp 12 #1530
	add %a0 %a1 %zero
	sw %ra %sp 20 #1530 call dir
	addi %sp %sp 24 #1530	
	jal %ra o_color_red.2317 #1530
	addi %sp %sp -24 #1530
	lw %ra %sp 20 #1530
	lw %a0 %sp 4 #1530
	sw %f0 %a0 0 #1530
	lw %a1 %sp 8 #1531
	add %a0 %a1 %zero
	sw %ra %sp 20 #1531 call dir
	addi %sp %sp 24 #1531	
	jal %ra o_color_green.2319 #1531
	addi %sp %sp -24 #1531
	lw %ra %sp 20 #1531
	lw %a0 %sp 4 #1531
	sw %f0 %a0 4 #1531
	lw %a1 %sp 8 #1532
	add %a0 %a1 %zero
	sw %ra %sp 20 #1532 call dir
	addi %sp %sp 24 #1532	
	jal %ra o_color_blue.2321 #1532
	addi %sp %sp -24 #1532
	lw %ra %sp 20 #1532
	lw %a0 %sp 4 #1532
	sw %f0 %a0 8 #1532
	lw %a1 %sp 12 #1533
	addi %a12 %zero 1
	bne %a1 %a12 beq_else.8700
	lw %a1 %sp 0 #1536
	lw %f0 %a1 0 #1536
	lw %a2 %sp 8 #1536
	sw %f0 %sp 16 #1536
	add %a0 %a2 %zero
	sw %ra %sp 28 #1536 call dir
	addi %sp %sp 32 #1536	
	jal %ra o_param_x.2307 #1536
	addi %sp %sp -32 #1536
	lw %ra %sp 28 #1536
	lw %f1 %sp 16 #1536
	fsub %f0 %f1 %f0 #1536
	li %f1 l.6068 #1538
	fmul %f1 %f0 %f1 #1538
	sw %f0 %sp 24 #1538
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #1538 call dir
	addi %sp %sp 40 #1538	
	jal %ra min_caml_floor #1538
	addi %sp %sp -40 #1538
	lw %ra %sp 36 #1538
	li %f1 l.6070 #1538
	fmul %f0 %f0 %f1 #1538
	lw %f1 %sp 24 #1539
	fsub %f0 %f1 %f0 #1539
	li %f1 l.6051 #1539
	sw %ra %sp 36 #1539 call dir
	addi %sp %sp 40 #1539	
	jal %ra min_caml_fless #1539
	addi %sp %sp -40 #1539
	lw %ra %sp 36 #1539
	lw %a1 %sp 0 #1536
	lw %f0 %a1 8 #1536
	lw %a1 %sp 8 #1541
	sw %a0 %sp 32 #1541
	sw %f0 %sp 40 #1541
	add %a0 %a1 %zero
	sw %ra %sp 52 #1541 call dir
	addi %sp %sp 56 #1541	
	jal %ra o_param_z.2311 #1541
	addi %sp %sp -56 #1541
	lw %ra %sp 52 #1541
	lw %f1 %sp 40 #1541
	fsub %f0 %f1 %f0 #1541
	li %f1 l.6068 #1543
	fmul %f1 %f0 %f1 #1543
	sw %f0 %sp 48 #1543
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #1543 call dir
	addi %sp %sp 64 #1543	
	jal %ra min_caml_floor #1543
	addi %sp %sp -64 #1543
	lw %ra %sp 60 #1543
	li %f1 l.6070 #1543
	fmul %f0 %f0 %f1 #1543
	lw %f1 %sp 48 #1544
	fsub %f0 %f1 %f0 #1544
	li %f1 l.6051 #1544
	sw %ra %sp 60 #1544 call dir
	addi %sp %sp 64 #1544	
	jal %ra min_caml_fless #1544
	addi %sp %sp -64 #1544
	lw %ra %sp 60 #1544
	lw %a1 %sp 32 #788
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8702 # nontail if
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8704 # nontail if
	li %f0 l.6044 #1549
	jal %zero beq_cont.8705 # then sentence ends
beq_else.8704:
	li %f0 l.5551 #1549
beq_cont.8705:
	jal %zero beq_cont.8703 # then sentence ends
beq_else.8702:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8706 # nontail if
	li %f0 l.5551 #1548
	jal %zero beq_cont.8707 # then sentence ends
beq_else.8706:
	li %f0 l.6044 #1548
beq_cont.8707:
beq_cont.8703:
	lw %a0 %sp 4 #1546
	sw %f0 %a0 4 #1546
	jalr %zero %ra 0 #1546
beq_else.8700:
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8709
	lw %a1 %sp 0 #1536
	lw %f0 %a1 4 #1536
	li %f1 l.6060 #1554
	fmul %f0 %f0 %f1 #1554
	sw %ra %sp 60 #1554 call dir
	addi %sp %sp 64 #1554	
	jal %ra min_caml_sin #1554
	addi %sp %sp -64 #1554
	lw %ra %sp 60 #1554
	sw %ra %sp 60 #1554 call dir
	addi %sp %sp 64 #1554	
	jal %ra min_caml_fsqr #1554
	addi %sp %sp -64 #1554
	lw %ra %sp 60 #1554
	li %f1 l.6044 #1555
	fmul %f1 %f1 %f0 #1555
	lw %a0 %sp 4 #1555
	sw %f1 %a0 0 #1555
	li %f1 l.6044 #1556
	li %f2 l.5553 #1556
	fsub %f0 %f2 %f0 #1556
	fmul %f0 %f1 %f0 #1556
	sw %f0 %a0 4 #1556
	jalr %zero %ra 0 #1556
beq_else.8709:
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.8711
	lw %a1 %sp 0 #1536
	lw %f0 %a1 0 #1536
	lw %a2 %sp 8 #1561
	sw %f0 %sp 56 #1561
	add %a0 %a2 %zero
	sw %ra %sp 68 #1561 call dir
	addi %sp %sp 72 #1561	
	jal %ra o_param_x.2307 #1561
	addi %sp %sp -72 #1561
	lw %ra %sp 68 #1561
	lw %f1 %sp 56 #1561
	fsub %f0 %f1 %f0 #1561
	lw %a0 %sp 0 #1536
	lw %f1 %a0 8 #1536
	lw %a0 %sp 8 #1562
	sw %f0 %sp 64 #1562
	sw %f1 %sp 72 #1562
	sw %ra %sp 84 #1562 call dir
	addi %sp %sp 88 #1562	
	jal %ra o_param_z.2311 #1562
	addi %sp %sp -88 #1562
	lw %ra %sp 84 #1562
	lw %f1 %sp 72 #1562
	fsub %f0 %f1 %f0 #1562
	lw %f1 %sp 64 #1563
	sw %f0 %sp 80 #1563
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #1563 call dir
	addi %sp %sp 96 #1563	
	jal %ra min_caml_fsqr #1563
	addi %sp %sp -96 #1563
	lw %ra %sp 92 #1563
	lw %f1 %sp 80 #1563
	sw %f0 %sp 88 #1563
	fadd %f0 %f1 %fzero
	sw %ra %sp 100 #1563 call dir
	addi %sp %sp 104 #1563	
	jal %ra min_caml_fsqr #1563
	addi %sp %sp -104 #1563
	lw %ra %sp 100 #1563
	lw %f1 %sp 88 #1563
	fadd %f0 %f1 %f0 #1563
	sw %ra %sp 100 #1563 call dir
	addi %sp %sp 104 #1563	
	jal %ra min_caml_sqrt #1563
	addi %sp %sp -104 #1563
	lw %ra %sp 100 #1563
	li %f1 l.6051 #1563
	fdiv %f0 %f0 %f1 #1563
	sw %f0 %sp 96 #1564
	sw %ra %sp 108 #1564 call dir
	addi %sp %sp 112 #1564	
	jal %ra min_caml_floor #1564
	addi %sp %sp -112 #1564
	lw %ra %sp 108 #1564
	lw %f1 %sp 96 #1564
	fsub %f0 %f1 %f0 #1564
	li %f1 l.6031 #1564
	fmul %f0 %f0 %f1 #1564
	sw %ra %sp 108 #1565 call dir
	addi %sp %sp 112 #1565	
	jal %ra min_caml_cos #1565
	addi %sp %sp -112 #1565
	lw %ra %sp 108 #1565
	sw %ra %sp 108 #1565 call dir
	addi %sp %sp 112 #1565	
	jal %ra min_caml_fsqr #1565
	addi %sp %sp -112 #1565
	lw %ra %sp 108 #1565
	li %f1 l.6044 #1566
	fmul %f1 %f0 %f1 #1566
	lw %a0 %sp 4 #1566
	sw %f1 %a0 4 #1566
	li %f1 l.5553 #1567
	fsub %f0 %f1 %f0 #1567
	li %f1 l.6044 #1567
	fmul %f0 %f0 %f1 #1567
	sw %f0 %a0 8 #1567
	jalr %zero %ra 0 #1567
beq_else.8711:
	addi %a12 %zero 4
	bne %a1 %a12 beq_else.8713
	lw %a1 %sp 0 #1536
	lw %f0 %a1 0 #1536
	lw %a2 %sp 8 #1571
	sw %f0 %sp 104 #1571
	add %a0 %a2 %zero
	sw %ra %sp 116 #1571 call dir
	addi %sp %sp 120 #1571	
	jal %ra o_param_x.2307 #1571
	addi %sp %sp -120 #1571
	lw %ra %sp 116 #1571
	lw %f1 %sp 104 #1571
	fsub %f0 %f1 %f0 #1571
	lw %a0 %sp 8 #1571
	sw %f0 %sp 112 #1571
	sw %ra %sp 124 #1571 call dir
	addi %sp %sp 128 #1571	
	jal %ra o_param_a.2299 #1571
	addi %sp %sp -128 #1571
	lw %ra %sp 124 #1571
	sw %ra %sp 124 #1571 call dir
	addi %sp %sp 128 #1571	
	jal %ra min_caml_sqrt #1571
	addi %sp %sp -128 #1571
	lw %ra %sp 124 #1571
	lw %f1 %sp 112 #1571
	fmul %f0 %f1 %f0 #1571
	lw %a0 %sp 0 #1536
	lw %f1 %a0 8 #1536
	lw %a1 %sp 8 #1572
	sw %f0 %sp 120 #1572
	sw %f1 %sp 128 #1572
	add %a0 %a1 %zero
	sw %ra %sp 140 #1572 call dir
	addi %sp %sp 144 #1572	
	jal %ra o_param_z.2311 #1572
	addi %sp %sp -144 #1572
	lw %ra %sp 140 #1572
	lw %f1 %sp 128 #1572
	fsub %f0 %f1 %f0 #1572
	lw %a0 %sp 8 #1572
	sw %f0 %sp 136 #1572
	sw %ra %sp 148 #1572 call dir
	addi %sp %sp 152 #1572	
	jal %ra o_param_c.2303 #1572
	addi %sp %sp -152 #1572
	lw %ra %sp 148 #1572
	sw %ra %sp 148 #1572 call dir
	addi %sp %sp 152 #1572	
	jal %ra min_caml_sqrt #1572
	addi %sp %sp -152 #1572
	lw %ra %sp 148 #1572
	lw %f1 %sp 136 #1572
	fmul %f0 %f1 %f0 #1572
	lw %f1 %sp 120 #1573
	sw %f0 %sp 144 #1573
	fadd %f0 %f1 %fzero
	sw %ra %sp 156 #1573 call dir
	addi %sp %sp 160 #1573	
	jal %ra min_caml_fsqr #1573
	addi %sp %sp -160 #1573
	lw %ra %sp 156 #1573
	lw %f1 %sp 144 #1573
	sw %f0 %sp 152 #1573
	fadd %f0 %f1 %fzero
	sw %ra %sp 164 #1573 call dir
	addi %sp %sp 168 #1573	
	jal %ra min_caml_fsqr #1573
	addi %sp %sp -168 #1573
	lw %ra %sp 164 #1573
	lw %f1 %sp 152 #1573
	fadd %f0 %f1 %f0 #1573
	lw %f1 %sp 120 #1575
	sw %f0 %sp 160 #1575
	fadd %f0 %f1 %fzero
	sw %ra %sp 172 #1575 call dir
	addi %sp %sp 176 #1575	
	jal %ra min_caml_fabs #1575
	addi %sp %sp -176 #1575
	lw %ra %sp 172 #1575
	li %f1 l.6025 #1575
	sw %ra %sp 172 #1575 call dir
	addi %sp %sp 176 #1575	
	jal %ra min_caml_fless #1575
	addi %sp %sp -176 #1575
	lw %ra %sp 172 #1575
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8714 # nontail if
	lw %f0 %sp 120 #1578
	lw %f1 %sp 144 #1578
	fdiv %f0 %f1 %f0 #1578
	sw %ra %sp 172 #1578 call dir
	addi %sp %sp 176 #1578	
	jal %ra min_caml_fabs #1578
	addi %sp %sp -176 #1578
	lw %ra %sp 172 #1578
	sw %ra %sp 172 #1580 call dir
	addi %sp %sp 176 #1580	
	jal %ra min_caml_atan #1580
	addi %sp %sp -176 #1580
	lw %ra %sp 172 #1580
	li %f1 l.6029 #1580
	fmul %f0 %f0 %f1 #1580
	li %f1 l.6031 #1580
	fdiv %f0 %f0 %f1 #1580
	jal %zero beq_cont.8715 # then sentence ends
beq_else.8714:
	li %f0 l.6027 #1576
beq_cont.8715:
	sw %f0 %sp 168 #1582
	sw %ra %sp 180 #1582 call dir
	addi %sp %sp 184 #1582	
	jal %ra min_caml_floor #1582
	addi %sp %sp -184 #1582
	lw %ra %sp 180 #1582
	lw %f1 %sp 168 #1582
	fsub %f0 %f1 %f0 #1582
	lw %a0 %sp 0 #1536
	lw %f1 %a0 4 #1536
	lw %a0 %sp 8 #1584
	sw %f0 %sp 176 #1584
	sw %f1 %sp 184 #1584
	sw %ra %sp 196 #1584 call dir
	addi %sp %sp 200 #1584	
	jal %ra o_param_y.2309 #1584
	addi %sp %sp -200 #1584
	lw %ra %sp 196 #1584
	lw %f1 %sp 184 #1584
	fsub %f0 %f1 %f0 #1584
	lw %a0 %sp 8 #1584
	sw %f0 %sp 192 #1584
	sw %ra %sp 204 #1584 call dir
	addi %sp %sp 208 #1584	
	jal %ra o_param_b.2301 #1584
	addi %sp %sp -208 #1584
	lw %ra %sp 204 #1584
	sw %ra %sp 204 #1584 call dir
	addi %sp %sp 208 #1584	
	jal %ra min_caml_sqrt #1584
	addi %sp %sp -208 #1584
	lw %ra %sp 204 #1584
	lw %f1 %sp 192 #1584
	fmul %f0 %f1 %f0 #1584
	lw %f1 %sp 160 #1586
	sw %f0 %sp 200 #1586
	fadd %f0 %f1 %fzero
	sw %ra %sp 212 #1586 call dir
	addi %sp %sp 216 #1586	
	jal %ra min_caml_fabs #1586
	addi %sp %sp -216 #1586
	lw %ra %sp 212 #1586
	li %f1 l.6025 #1586
	sw %ra %sp 212 #1586 call dir
	addi %sp %sp 216 #1586	
	jal %ra min_caml_fless #1586
	addi %sp %sp -216 #1586
	lw %ra %sp 212 #1586
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8716 # nontail if
	lw %f0 %sp 160 #1589
	lw %f1 %sp 200 #1589
	fdiv %f0 %f1 %f0 #1589
	sw %ra %sp 212 #1589 call dir
	addi %sp %sp 216 #1589	
	jal %ra min_caml_fabs #1589
	addi %sp %sp -216 #1589
	lw %ra %sp 212 #1589
	sw %ra %sp 212 #1590 call dir
	addi %sp %sp 216 #1590	
	jal %ra min_caml_atan #1590
	addi %sp %sp -216 #1590
	lw %ra %sp 212 #1590
	li %f1 l.6029 #1590
	fmul %f0 %f0 %f1 #1590
	li %f1 l.6031 #1590
	fdiv %f0 %f0 %f1 #1590
	jal %zero beq_cont.8717 # then sentence ends
beq_else.8716:
	li %f0 l.6027 #1587
beq_cont.8717:
	sw %f0 %sp 208 #1592
	sw %ra %sp 220 #1592 call dir
	addi %sp %sp 224 #1592	
	jal %ra min_caml_floor #1592
	addi %sp %sp -224 #1592
	lw %ra %sp 220 #1592
	lw %f1 %sp 208 #1592
	fsub %f0 %f1 %f0 #1592
	li %f1 l.6038 #1593
	li %f2 l.6040 #1593
	lw %f3 %sp 176 #1593
	fsub %f2 %f2 %f3 #1593
	sw %f0 %sp 216 #1593
	sw %f1 %sp 224 #1593
	fadd %f0 %f2 %fzero
	sw %ra %sp 236 #1593 call dir
	addi %sp %sp 240 #1593	
	jal %ra min_caml_fsqr #1593
	addi %sp %sp -240 #1593
	lw %ra %sp 236 #1593
	lw %f1 %sp 224 #1593
	fsub %f0 %f1 %f0 #1593
	li %f1 l.6040 #1593
	lw %f2 %sp 216 #1593
	fsub %f1 %f1 %f2 #1593
	sw %f0 %sp 232 #1593
	fadd %f0 %f1 %fzero
	sw %ra %sp 244 #1593 call dir
	addi %sp %sp 248 #1593	
	jal %ra min_caml_fsqr #1593
	addi %sp %sp -248 #1593
	lw %ra %sp 244 #1593
	lw %f1 %sp 232 #1593
	fsub %f0 %f1 %f0 #1593
	sw %f0 %sp 240 #1594
	sw %ra %sp 252 #1594 call dir
	addi %sp %sp 256 #1594	
	jal %ra min_caml_fisneg #1594
	addi %sp %sp -256 #1594
	lw %ra %sp 252 #1594
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8718 # nontail if
	lw %f0 %sp 240 #1593
	jal %zero beq_cont.8719 # then sentence ends
beq_else.8718:
	li %f0 l.5551 #1594
beq_cont.8719:
	li %f1 l.6044 #1595
	fmul %f0 %f1 %f0 #1595
	li %f1 l.6046 #1595
	fdiv %f0 %f0 %f1 #1595
	lw %a0 %sp 4 #1595
	sw %f0 %a0 8 #1595
	jalr %zero %ra 0 #1595
beq_else.8713:
	jalr %zero %ra 0 #1597
add_light.2561:
	lw %a0 %a11 8 #1603
	lw %a1 %a11 4 #1603
	sw %f2 %sp 0 #1606
	sw %f1 %sp 8 #1606
	sw %f0 %sp 16 #1606
	sw %a0 %sp 24 #1606
	sw %a1 %sp 28 #1606
	sw %ra %sp 36 #1606 call dir
	addi %sp %sp 40 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -40 #1606
	lw %ra %sp 36 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8722 # nontail if
	jal %zero beq_cont.8723 # then sentence ends
beq_else.8722:
	lw %f0 %sp 16 #1607
	lw %a0 %sp 28 #1607
	lw %a1 %sp 24 #1607
	sw %ra %sp 36 #1607 call dir
	addi %sp %sp 40 #1607	
	jal %ra vecaccum.2272 #1607
	addi %sp %sp -40 #1607
	lw %ra %sp 36 #1607
beq_cont.8723:
	lw %f0 %sp 8 #1611
	sw %ra %sp 36 #1611 call dir
	addi %sp %sp 40 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -40 #1611
	lw %ra %sp 36 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8724
	jalr %zero %ra 0 #1616
beq_else.8724:
	lw %f0 %sp 8 #1612
	sw %ra %sp 36 #1612 call dir
	addi %sp %sp 40 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -40 #1612
	lw %ra %sp 36 #1612
	sw %ra %sp 36 #1612 call dir
	addi %sp %sp 40 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -40 #1612
	lw %ra %sp 36 #1612
	lw %f1 %sp 0 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 28 #54
	lw %f1 %a0 0 #54
	fadd %f1 %f1 %f0 #1613
	sw %f1 %a0 0 #1613
	lw %f1 %a0 4 #54
	fadd %f1 %f1 %f0 #1614
	sw %f1 %a0 4 #1614
	lw %f1 %a0 8 #54
	fadd %f0 %f1 %f0 #1615
	sw %f0 %a0 8 #1615
	jalr %zero %ra 0 #1615
trace_reflections.2565:
	lw %a2 %a11 32 #1620
	lw %a3 %a11 28 #1620
	lw %a4 %a11 24 #1620
	lw %a5 %a11 20 #1620
	lw %a6 %a11 16 #1620
	lw %a7 %a11 12 #1620
	lw %a8 %a11 8 #1620
	lw %a9 %a11 4 #1620
	addi %a10 %zero 0 #1622
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8727
	sw %a11 %sp 0 #95
	slli %a11 %a0 2 #95
	add %a12 %a3 %a11 #95
	lw %a3 %a12 0 #95
	sw %a0 %sp 4 #1624
	sw %f1 %sp 8 #1624
	sw %a9 %sp 16 #1624
	sw %a1 %sp 20 #1624
	sw %f0 %sp 24 #1624
	sw %a5 %sp 32 #1624
	sw %a10 %sp 36 #1624
	sw %a2 %sp 40 #1624
	sw %a4 %sp 44 #1624
	sw %a3 %sp 48 #1624
	sw %a7 %sp 52 #1624
	sw %a8 %sp 56 #1624
	sw %a6 %sp 60 #1624
	add %a0 %a3 %zero
	sw %ra %sp 68 #1624 call dir
	addi %sp %sp 72 #1624	
	jal %ra r_dvec.2356 #1624
	addi %sp %sp -72 #1624
	lw %ra %sp 68 #1624
	lw %a11 %sp 60 #1627
	sw %a0 %sp 64 #1627
	sw %ra %sp 68 #1627 call cls
	lw %a10 %a11 0 #1627
	addi %sp %sp 72 #1627	
	jalr %ra %a10 0 #1627
	addi %sp %sp -72 #1627
	lw %ra %sp 68 #1627
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8728 # nontail if
	jal %zero beq_cont.8729 # then sentence ends
beq_else.8728:
	lw %a0 %sp 56 #45
	lw %a0 %a0 0 #45
	addi %a1 %zero 4 #1628
	sw %ra %sp 68 #1628 call dir
	addi %sp %sp 72 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -72 #1628
	lw %ra %sp 68 #1628
	lw %a1 %sp 52 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1628
	lw %a1 %sp 48 #1629
	sw %a0 %sp 68 #1629
	add %a0 %a1 %zero
	sw %ra %sp 76 #1629 call dir
	addi %sp %sp 80 #1629	
	jal %ra r_surface_id.2354 #1629
	addi %sp %sp -80 #1629
	lw %ra %sp 76 #1629
	lw %a1 %sp 68 #1628
	bne %a1 %a0 beq_else.8730 # nontail if
	lw %a0 %sp 44 #33
	lw %a1 %a0 0 #33
	lw %a0 %sp 36 #1631
	lw %a11 %sp 40 #1631
	sw %ra %sp 76 #1631 call cls
	lw %a10 %a11 0 #1631
	addi %sp %sp 80 #1631	
	jalr %ra %a10 0 #1631
	addi %sp %sp -80 #1631
	lw %ra %sp 76 #1631
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8732 # nontail if
	lw %a0 %sp 64 #1633
	sw %ra %sp 76 #1633 call dir
	addi %sp %sp 80 #1633	
	jal %ra d_vec.2350 #1633
	addi %sp %sp -80 #1633
	lw %ra %sp 76 #1633
	add %a1 %a0 %zero #1633
	lw %a0 %sp 32 #1633
	sw %ra %sp 76 #1633 call dir
	addi %sp %sp 80 #1633	
	jal %ra veciprod.2264 #1633
	addi %sp %sp -80 #1633
	lw %ra %sp 76 #1633
	lw %a0 %sp 48 #1634
	sw %f0 %sp 72 #1634
	sw %ra %sp 84 #1634 call dir
	addi %sp %sp 88 #1634	
	jal %ra r_bright.2358 #1634
	addi %sp %sp -88 #1634
	lw %ra %sp 84 #1634
	lw %f1 %sp 24 #1635
	fmul %f2 %f0 %f1 #1635
	lw %f3 %sp 72 #1635
	fmul %f2 %f2 %f3 #1635
	lw %a0 %sp 64 #1636
	sw %f2 %sp 80 #1636
	sw %f0 %sp 88 #1636
	sw %ra %sp 100 #1636 call dir
	addi %sp %sp 104 #1636	
	jal %ra d_vec.2350 #1636
	addi %sp %sp -104 #1636
	lw %ra %sp 100 #1636
	add %a1 %a0 %zero #1636
	lw %a0 %sp 20 #1636
	sw %ra %sp 100 #1636 call dir
	addi %sp %sp 104 #1636	
	jal %ra veciprod.2264 #1636
	addi %sp %sp -104 #1636
	lw %ra %sp 100 #1636
	lw %f1 %sp 88 #1636
	fmul %f1 %f1 %f0 #1636
	lw %f0 %sp 80 #1637
	lw %f2 %sp 8 #1637
	lw %a11 %sp 16 #1637
	sw %ra %sp 100 #1637 call cls
	lw %a10 %a11 0 #1637
	addi %sp %sp 104 #1637	
	jalr %ra %a10 0 #1637
	addi %sp %sp -104 #1637
	lw %ra %sp 100 #1637
	jal %zero beq_cont.8733 # then sentence ends
beq_else.8732:
beq_cont.8733:
	jal %zero beq_cont.8731 # then sentence ends
beq_else.8730:
beq_cont.8731:
beq_cont.8729:
	lw %a0 %sp 4 #1641
	addi %a0 %a0 -1 #1641
	lw %f0 %sp 24 #1641
	lw %f1 %sp 8 #1641
	lw %a1 %sp 20 #1641
	lw %a11 %sp 0 #1641
	lw %a10 %a11 0 #1641
	jalr %zero %a10 0 #1641
bge_else.8727:
	jalr %zero %ra 0 #1642
trace_ray.2570:
	lw %a3 %a11 80 #1647
	lw %a4 %a11 76 #1647
	lw %a5 %a11 72 #1647
	lw %a6 %a11 68 #1647
	lw %a7 %a11 64 #1647
	lw %a8 %a11 60 #1647
	lw %a9 %a11 56 #1647
	lw %a10 %a11 52 #1647
	sw %a5 %sp 0 #1647
	lw %a5 %a11 48 #1647
	sw %a4 %sp 4 #1647
	lw %a4 %a11 44 #1647
	sw %a9 %sp 8 #1647
	lw %a9 %a11 40 #1647
	sw %a8 %sp 12 #1647
	lw %a8 %a11 36 #1647
	sw %a8 %sp 16 #1647
	lw %a8 %a11 32 #1647
	sw %a5 %sp 20 #1647
	lw %a5 %a11 28 #1647
	sw %a9 %sp 24 #1647
	lw %a9 %a11 24 #1647
	sw %a6 %sp 28 #1647
	lw %a6 %a11 20 #1647
	sw %a9 %sp 32 #1647
	lw %a9 %a11 16 #1647
	sw %a3 %sp 36 #1647
	lw %a3 %a11 12 #1647
	sw %a6 %sp 40 #1647
	lw %a6 %a11 8 #1647
	sw %a11 %sp 44 #1647
	lw %a11 %a11 4 #1647
	sw %a11 %sp 48 #1648
	addi %a11 %zero 4 #1648
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.8735
	sw %f1 %sp 56 #1649
	sw %a2 %sp 64 #1649
	sw %a11 %sp 68 #1649
	sw %a7 %sp 72 #1649
	sw %a3 %sp 76 #1649
	sw %a4 %sp 80 #1649
	sw %a9 %sp 84 #1649
	sw %a10 %sp 88 #1649
	sw %a6 %sp 92 #1649
	sw %f0 %sp 96 #1649
	sw %a8 %sp 104 #1649
	sw %a0 %sp 108 #1649
	sw %a1 %sp 112 #1649
	sw %a5 %sp 116 #1649
	add %a0 %a2 %zero
	sw %ra %sp 124 #1649 call dir
	addi %sp %sp 128 #1649	
	jal %ra p_surface_ids.2335 #1649
	addi %sp %sp -128 #1649
	lw %ra %sp 124 #1649
	lw %a1 %sp 112 #1650
	lw %a11 %sp 116 #1650
	sw %a0 %sp 120 #1650
	add %a0 %a1 %zero
	sw %ra %sp 124 #1650 call cls
	lw %a10 %a11 0 #1650
	addi %sp %sp 128 #1650	
	jalr %ra %a10 0 #1650
	addi %sp %sp -128 #1650
	lw %ra %sp 124 #1650
	addi %a1 %zero 0 #1650
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8737
	addi %a0 %zero 1 #1713
	sub %a0 %zero %a0 #1713
	lw %a1 %sp 108 #1713
	slli %a2 %a1 2 #1713
	lw %a3 %sp 120 #1713
	add %a12 %a3 %a2 #1713
	sw %a0 %a12 0 #1713
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.8738
	jalr %zero %ra 0 #1727
beq_else.8738:
	lw %a0 %sp 112 #1716
	lw %a1 %sp 104 #1716
	sw %ra %sp 124 #1716 call dir
	addi %sp %sp 128 #1716	
	jal %ra veciprod.2264 #1716
	addi %sp %sp -128 #1716
	lw %ra %sp 124 #1716
	sw %ra %sp 124 #1716 call dir
	addi %sp %sp 128 #1716	
	jal %ra min_caml_fneg #1716
	addi %sp %sp -128 #1716
	lw %ra %sp 124 #1716
	sw %f0 %sp 128 #1718
	sw %ra %sp 140 #1718 call dir
	addi %sp %sp 144 #1718	
	jal %ra min_caml_fispos #1718
	addi %sp %sp -144 #1718
	lw %ra %sp 140 #1718
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8741
	jalr %zero %ra 0 #1726
beq_else.8741:
	lw %f0 %sp 128 #1721
	sw %ra %sp 140 #1721 call dir
	addi %sp %sp 144 #1721	
	jal %ra min_caml_fsqr #1721
	addi %sp %sp -144 #1721
	lw %ra %sp 140 #1721
	lw %f1 %sp 128 #1721
	fmul %f0 %f0 %f1 #1721
	lw %f1 %sp 96 #1721
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 92 #29
	lw %f1 %a0 0 #29
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 88 #54
	lw %f1 %a0 0 #54
	fadd %f1 %f1 %f0 #1722
	sw %f1 %a0 0 #1722
	lw %f1 %a0 4 #54
	fadd %f1 %f1 %f0 #1723
	sw %f1 %a0 4 #1723
	lw %f1 %a0 8 #54
	fadd %f0 %f1 %f0 #1724
	sw %f0 %a0 8 #1724
	jalr %zero %ra 0 #1724
beq_else.8737:
	lw %a0 %sp 84 #45
	lw %a0 %a0 0 #45
	slli %a2 %a0 2 #20
	lw %a3 %sp 80 #20
	add %a12 %a3 %a2 #20
	lw %a2 %a12 0 #20
	sw %a1 %sp 136 #1654
	sw %a0 %sp 140 #1654
	sw %a2 %sp 144 #1654
	add %a0 %a2 %zero
	sw %ra %sp 148 #1654 call dir
	addi %sp %sp 152 #1654	
	jal %ra o_reflectiontype.2293 #1654
	addi %sp %sp -152 #1654
	lw %ra %sp 148 #1654
	lw %a1 %sp 144 #1655
	sw %a0 %sp 148 #1655
	add %a0 %a1 %zero
	sw %ra %sp 156 #1655 call dir
	addi %sp %sp 160 #1655	
	jal %ra o_diffuse.2313 #1655
	addi %sp %sp -160 #1655
	lw %ra %sp 156 #1655
	lw %f1 %sp 96 #1655
	fmul %f0 %f0 %f1 #1655
	lw %a0 %sp 144 #1657
	lw %a1 %sp 112 #1657
	lw %a11 %sp 76 #1657
	sw %f0 %sp 152 #1657
	sw %ra %sp 164 #1657 call cls
	lw %a10 %a11 0 #1657
	addi %sp %sp 168 #1657	
	jalr %ra %a10 0 #1657
	addi %sp %sp -168 #1657
	lw %ra %sp 164 #1657
	lw %a0 %sp 72 #1658
	lw %a1 %sp 40 #1658
	sw %ra %sp 164 #1658 call dir
	addi %sp %sp 168 #1658	
	jal %ra veccpy.2253 #1658
	addi %sp %sp -168 #1658
	lw %ra %sp 164 #1658
	lw %a0 %sp 144 #1659
	lw %a1 %sp 40 #1659
	lw %a11 %sp 36 #1659
	sw %ra %sp 164 #1659 call cls
	lw %a10 %a11 0 #1659
	addi %sp %sp 168 #1659	
	jalr %ra %a10 0 #1659
	addi %sp %sp -168 #1659
	lw %ra %sp 164 #1659
	lw %a0 %sp 140 #1662
	lw %a1 %sp 68 #1662
	sw %ra %sp 164 #1662 call dir
	addi %sp %sp 168 #1662	
	jal %ra min_caml_sll #1662
	addi %sp %sp -168 #1662
	lw %ra %sp 164 #1662
	lw %a1 %sp 32 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1662
	lw %a1 %sp 108 #1662
	slli %a2 %a1 2 #1662
	lw %a3 %sp 120 #1662
	add %a12 %a3 %a2 #1662
	sw %a0 %a12 0 #1662
	lw %a0 %sp 64 #1663
	sw %ra %sp 164 #1663 call dir
	addi %sp %sp 168 #1663	
	jal %ra p_intersection_points.2333 #1663
	addi %sp %sp -168 #1663
	lw %ra %sp 164 #1663
	lw %a1 %sp 108 #1664
	slli %a2 %a1 2 #1664
	add %a12 %a0 %a2 #1664
	lw %a0 %a12 0 #1664
	lw %a2 %sp 40 #1664
	add %a1 %a2 %zero
	sw %ra %sp 164 #1664 call dir
	addi %sp %sp 168 #1664	
	jal %ra veccpy.2253 #1664
	addi %sp %sp -168 #1664
	lw %ra %sp 164 #1664
	lw %a0 %sp 64 #1667
	sw %ra %sp 164 #1667 call dir
	addi %sp %sp 168 #1667	
	jal %ra p_calc_diffuse.2337 #1667
	addi %sp %sp -168 #1667
	lw %ra %sp 164 #1667
	lw %a1 %sp 144 #1668
	sw %a0 %sp 160 #1668
	add %a0 %a1 %zero
	sw %ra %sp 164 #1668 call dir
	addi %sp %sp 168 #1668	
	jal %ra o_diffuse.2313 #1668
	addi %sp %sp -168 #1668
	lw %ra %sp 164 #1668
	li %f1 l.6040 #1668
	sw %ra %sp 164 #1668 call dir
	addi %sp %sp 168 #1668	
	jal %ra min_caml_fless #1668
	addi %sp %sp -168 #1668
	lw %ra %sp 164 #1668
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8744 # nontail if
	addi %a0 %zero 1 #1671
	lw %a1 %sp 108 #1671
	slli %a2 %a1 2 #1671
	lw %a3 %sp 160 #1671
	add %a12 %a3 %a2 #1671
	sw %a0 %a12 0 #1671
	lw %a0 %sp 64 #1672
	sw %ra %sp 164 #1672 call dir
	addi %sp %sp 168 #1672	
	jal %ra p_energy.2339 #1672
	addi %sp %sp -168 #1672
	lw %ra %sp 164 #1672
	lw %a1 %sp 108 #1673
	slli %a2 %a1 2 #1673
	add %a12 %a0 %a2 #1673
	lw %a2 %a12 0 #1673
	lw %a3 %sp 28 #1673
	sw %a0 %sp 164 #1673
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 172 #1673 call dir
	addi %sp %sp 176 #1673	
	jal %ra veccpy.2253 #1673
	addi %sp %sp -176 #1673
	lw %ra %sp 172 #1673
	lw %a0 %sp 108 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 164 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	li %f0 l.5553 #1674
	li %f1 l.6103 #1674
	fdiv %f0 %f0 %f1 #1674
	lw %f1 %sp 152 #1674
	fmul %f0 %f0 %f1 #1674
	add %a0 %a1 %zero
	sw %ra %sp 172 #1674 call dir
	addi %sp %sp 176 #1674	
	jal %ra vecscale.2282 #1674
	addi %sp %sp -176 #1674
	lw %ra %sp 172 #1674
	lw %a0 %sp 64 #1675
	sw %ra %sp 172 #1675 call dir
	addi %sp %sp 176 #1675	
	jal %ra p_nvectors.2348 #1675
	addi %sp %sp -176 #1675
	lw %ra %sp 172 #1675
	lw %a1 %sp 108 #1676
	slli %a2 %a1 2 #1676
	add %a12 %a0 %a2 #1676
	lw %a0 %a12 0 #1676
	lw %a2 %sp 24 #1676
	add %a1 %a2 %zero
	sw %ra %sp 172 #1676 call dir
	addi %sp %sp 176 #1676	
	jal %ra veccpy.2253 #1676
	addi %sp %sp -176 #1676
	lw %ra %sp 172 #1676
	jal %zero beq_cont.8745 # then sentence ends
beq_else.8744:
	lw %a0 %sp 108 #1669
	slli %a1 %a0 2 #1669
	lw %a2 %sp 160 #1669
	lw %a3 %sp 136 #1669
	add %a12 %a2 %a1 #1669
	sw %a3 %a12 0 #1669
beq_cont.8745:
	li %f0 l.6106 #1679
	lw %a0 %sp 112 #1679
	lw %a1 %sp 24 #1679
	sw %f0 %sp 168 #1679
	sw %ra %sp 180 #1679 call dir
	addi %sp %sp 184 #1679	
	jal %ra veciprod.2264 #1679
	addi %sp %sp -184 #1679
	lw %ra %sp 180 #1679
	lw %f1 %sp 168 #1679
	fmul %f0 %f1 %f0 #1679
	lw %a0 %sp 112 #1681
	lw %a1 %sp 24 #1681
	sw %ra %sp 180 #1681 call dir
	addi %sp %sp 184 #1681	
	jal %ra vecaccum.2272 #1681
	addi %sp %sp -184 #1681
	lw %ra %sp 180 #1681
	lw %a0 %sp 144 #1683
	sw %ra %sp 180 #1683 call dir
	addi %sp %sp 184 #1683	
	jal %ra o_hilight.2315 #1683
	addi %sp %sp -184 #1683
	lw %ra %sp 180 #1683
	lw %f1 %sp 96 #1683
	fmul %f0 %f1 %f0 #1683
	lw %a0 %sp 20 #33
	lw %a1 %a0 0 #33
	lw %a0 %sp 136 #1686
	lw %a11 %sp 12 #1686
	sw %f0 %sp 176 #1686
	sw %ra %sp 188 #1686 call cls
	lw %a10 %a11 0 #1686
	addi %sp %sp 192 #1686	
	jalr %ra %a10 0 #1686
	addi %sp %sp -192 #1686
	lw %ra %sp 188 #1686
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8746 # nontail if
	lw %a0 %sp 24 #1687
	lw %a1 %sp 104 #1687
	sw %ra %sp 188 #1687 call dir
	addi %sp %sp 192 #1687	
	jal %ra veciprod.2264 #1687
	addi %sp %sp -192 #1687
	lw %ra %sp 188 #1687
	sw %ra %sp 188 #1687 call dir
	addi %sp %sp 192 #1687	
	jal %ra min_caml_fneg #1687
	addi %sp %sp -192 #1687
	lw %ra %sp 188 #1687
	lw %f1 %sp 152 #1687
	fmul %f0 %f0 %f1 #1687
	lw %a0 %sp 112 #1688
	lw %a1 %sp 104 #1688
	sw %f0 %sp 184 #1688
	sw %ra %sp 196 #1688 call dir
	addi %sp %sp 200 #1688	
	jal %ra veciprod.2264 #1688
	addi %sp %sp -200 #1688
	lw %ra %sp 196 #1688
	sw %ra %sp 196 #1688 call dir
	addi %sp %sp 200 #1688	
	jal %ra min_caml_fneg #1688
	addi %sp %sp -200 #1688
	lw %ra %sp 196 #1688
	fadd %f1 %f0 %fzero #1688
	lw %f0 %sp 184 #1689
	lw %f2 %sp 176 #1689
	lw %a11 %sp 48 #1689
	sw %ra %sp 196 #1689 call cls
	lw %a10 %a11 0 #1689
	addi %sp %sp 200 #1689	
	jalr %ra %a10 0 #1689
	addi %sp %sp -200 #1689
	lw %ra %sp 196 #1689
	jal %zero beq_cont.8747 # then sentence ends
beq_else.8746:
beq_cont.8747:
	lw %a0 %sp 40 #1693
	lw %a11 %sp 8 #1693
	sw %ra %sp 196 #1693 call cls
	lw %a10 %a11 0 #1693
	addi %sp %sp 200 #1693	
	jalr %ra %a10 0 #1693
	addi %sp %sp -200 #1693
	lw %ra %sp 196 #1693
	lw %a0 %sp 16 #99
	lw %a0 %a0 0 #99
	addi %a0 %a0 -1 #1694
	lw %f0 %sp 152 #1694
	lw %f1 %sp 176 #1694
	lw %a1 %sp 112 #1694
	lw %a11 %sp 4 #1694
	sw %ra %sp 196 #1694 call cls
	lw %a10 %a11 0 #1694
	addi %sp %sp 200 #1694	
	jalr %ra %a10 0 #1694
	addi %sp %sp -200 #1694
	lw %ra %sp 196 #1694
	li %f0 l.6110 #1697
	lw %f1 %sp 96 #1697
	sw %ra %sp 196 #1697 call dir
	addi %sp %sp 200 #1697	
	jal %ra min_caml_fless #1697
	addi %sp %sp -200 #1697
	lw %ra %sp 196 #1697
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8748
	jalr %zero %ra 0 #1708
beq_else.8748:
	lw %a0 %sp 108 #1648
	addi %a12 %zero 4
	blt %a0 %a12 bge_else.8750 # nontail if
	jal %zero bge_cont.8751 # then sentence ends
bge_else.8750:
	addi %a1 %a0 1 #1700
	addi %a2 %zero 1 #1700
	sub %a2 %zero %a2 #1700
	slli %a1 %a1 2 #1700
	lw %a3 %sp 120 #1700
	add %a12 %a3 %a1 #1700
	sw %a2 %a12 0 #1700
bge_cont.8751:
	lw %a1 %sp 148 #20
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.8752
	li %f0 l.5553 #1704
	lw %a1 %sp 144 #1704
	sw %f0 %sp 192 #1704
	add %a0 %a1 %zero
	sw %ra %sp 204 #1704 call dir
	addi %sp %sp 208 #1704	
	jal %ra o_diffuse.2313 #1704
	addi %sp %sp -208 #1704
	lw %ra %sp 204 #1704
	lw %f1 %sp 192 #1704
	fsub %f0 %f1 %f0 #1704
	lw %f1 %sp 96 #1704
	fmul %f0 %f1 %f0 #1704
	lw %a0 %sp 108 #1705
	addi %a0 %a0 1 #1705
	lw %a1 %sp 0 #41
	lw %f1 %a1 0 #41
	lw %f2 %sp 56 #1705
	fadd %f1 %f2 %f1 #1705
	lw %a1 %sp 112 #1705
	lw %a2 %sp 64 #1705
	lw %a11 %sp 44 #1705
	lw %a10 %a11 0 #1705
	jalr %zero %a10 0 #1705
beq_else.8752:
	jalr %zero %ra 0 #1706
bge_else.8735:
	jalr %zero %ra 0 #1729
trace_diffuse_ray.2576:
	lw %a1 %a11 48 #1737
	lw %a2 %a11 44 #1737
	lw %a3 %a11 40 #1737
	lw %a4 %a11 36 #1737
	lw %a5 %a11 32 #1737
	lw %a6 %a11 28 #1737
	lw %a7 %a11 24 #1737
	lw %a8 %a11 20 #1737
	lw %a9 %a11 16 #1737
	lw %a10 %a11 12 #1737
	sw %a2 %sp 0 #1737
	lw %a2 %a11 8 #1737
	lw %a11 %a11 4 #1737
	sw %a11 %sp 4 #1740
	sw %f0 %sp 8 #1740
	sw %a7 %sp 16 #1740
	sw %a6 %sp 20 #1740
	sw %a3 %sp 24 #1740
	sw %a4 %sp 28 #1740
	sw %a9 %sp 32 #1740
	sw %a1 %sp 36 #1740
	sw %a2 %sp 40 #1740
	sw %a0 %sp 44 #1740
	sw %a5 %sp 48 #1740
	sw %a10 %sp 52 #1740
	add %a11 %a8 %zero
	sw %ra %sp 60 #1740 call cls
	lw %a10 %a11 0 #1740
	addi %sp %sp 64 #1740	
	jalr %ra %a10 0 #1740
	addi %sp %sp -64 #1740
	lw %ra %sp 60 #1740
	addi %a1 %zero 0 #1740
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8755
	jalr %zero %ra 0 #1751
beq_else.8755:
	lw %a0 %sp 52 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a2 %sp 44 #1742
	sw %a1 %sp 56 #1742
	sw %a0 %sp 60 #1742
	add %a0 %a2 %zero
	sw %ra %sp 68 #1742 call dir
	addi %sp %sp 72 #1742	
	jal %ra d_vec.2350 #1742
	addi %sp %sp -72 #1742
	lw %ra %sp 68 #1742
	add %a1 %a0 %zero #1742
	lw %a0 %sp 60 #1742
	lw %a11 %sp 40 #1742
	sw %ra %sp 68 #1742 call cls
	lw %a10 %a11 0 #1742
	addi %sp %sp 72 #1742	
	jalr %ra %a10 0 #1742
	addi %sp %sp -72 #1742
	lw %ra %sp 68 #1742
	lw %a0 %sp 60 #1743
	lw %a1 %sp 32 #1743
	lw %a11 %sp 36 #1743
	sw %ra %sp 68 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 72 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -72 #1743
	lw %ra %sp 68 #1743
	lw %a0 %sp 28 #33
	lw %a1 %a0 0 #33
	lw %a0 %sp 56 #1746
	lw %a11 %sp 24 #1746
	sw %ra %sp 68 #1746 call cls
	lw %a10 %a11 0 #1746
	addi %sp %sp 72 #1746	
	jalr %ra %a10 0 #1746
	addi %sp %sp -72 #1746
	lw %ra %sp 68 #1746
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8757
	lw %a0 %sp 20 #1747
	lw %a1 %sp 16 #1747
	sw %ra %sp 68 #1747 call dir
	addi %sp %sp 72 #1747	
	jal %ra veciprod.2264 #1747
	addi %sp %sp -72 #1747
	lw %ra %sp 68 #1747
	sw %ra %sp 68 #1747 call dir
	addi %sp %sp 72 #1747	
	jal %ra min_caml_fneg #1747
	addi %sp %sp -72 #1747
	lw %ra %sp 68 #1747
	sw %f0 %sp 64 #1748
	sw %ra %sp 76 #1748 call dir
	addi %sp %sp 80 #1748	
	jal %ra min_caml_fispos #1748
	addi %sp %sp -80 #1748
	lw %ra %sp 76 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8758 # nontail if
	li %f0 l.5551 #1748
	jal %zero beq_cont.8759 # then sentence ends
beq_else.8758:
	lw %f0 %sp 64 #559
beq_cont.8759:
	lw %f1 %sp 8 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 60 #1749
	sw %f0 %sp 72 #1749
	sw %ra %sp 84 #1749 call dir
	addi %sp %sp 88 #1749	
	jal %ra o_diffuse.2313 #1749
	addi %sp %sp -88 #1749
	lw %ra %sp 84 #1749
	lw %f1 %sp 72 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 4 #1749
	lw %a1 %sp 0 #1749
	jal	%zero vecaccum.2272
beq_else.8757:
	jalr %zero %ra 0 #1750
iter_trace_diffuse_rays.2579:
	lw %a4 %a11 4 #1755
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.8761
	slli %a5 %a3 2 #1757
	add %a12 %a0 %a5 #1757
	lw %a5 %a12 0 #1757
	sw %a2 %sp 0 #1757
	sw %a11 %sp 4 #1757
	sw %a4 %sp 8 #1757
	sw %a0 %sp 12 #1757
	sw %a3 %sp 16 #1757
	sw %a1 %sp 20 #1757
	add %a0 %a5 %zero
	sw %ra %sp 28 #1757 call dir
	addi %sp %sp 32 #1757	
	jal %ra d_vec.2350 #1757
	addi %sp %sp -32 #1757
	lw %ra %sp 28 #1757
	lw %a1 %sp 20 #1757
	sw %ra %sp 28 #1757 call dir
	addi %sp %sp 32 #1757	
	jal %ra veciprod.2264 #1757
	addi %sp %sp -32 #1757
	lw %ra %sp 28 #1757
	sw %f0 %sp 24 #1760
	sw %ra %sp 36 #1760 call dir
	addi %sp %sp 40 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -40 #1760
	lw %ra %sp 36 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8762 # nontail if
	lw %a0 %sp 16 #1757
	slli %a1 %a0 2 #1757
	lw %a2 %sp 12 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.6132 #1763
	lw %f1 %sp 24 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 8 #1763
	add %a0 %a1 %zero
	sw %ra %sp 36 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 40 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -40 #1763
	lw %ra %sp 36 #1763
	jal %zero beq_cont.8763 # then sentence ends
beq_else.8762:
	lw %a0 %sp 16 #1761
	addi %a1 %a0 1 #1761
	slli %a1 %a1 2 #1757
	lw %a2 %sp 12 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.6129 #1761
	lw %f1 %sp 24 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 8 #1761
	add %a0 %a1 %zero
	sw %ra %sp 36 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 40 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -40 #1761
	lw %ra %sp 36 #1761
beq_cont.8763:
	lw %a0 %sp 16 #1765
	addi %a3 %a0 -2 #1765
	lw %a0 %sp 12 #1765
	lw %a1 %sp 20 #1765
	lw %a2 %sp 0 #1765
	lw %a11 %sp 4 #1765
	lw %a10 %a11 0 #1765
	jalr %zero %a10 0 #1765
bge_else.8761:
	jalr %zero %ra 0 #1766
trace_diffuse_rays.2584:
	lw %a3 %a11 8 #1770
	lw %a4 %a11 4 #1770
	sw %a2 %sp 0 #1771
	sw %a1 %sp 4 #1771
	sw %a0 %sp 8 #1771
	sw %a4 %sp 12 #1771
	add %a0 %a2 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 24 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -24 #1771
	lw %ra %sp 20 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 8 #1774
	lw %a1 %sp 4 #1774
	lw %a2 %sp 0 #1774
	lw %a11 %sp 12 #1774
	lw %a10 %a11 0 #1774
	jalr %zero %a10 0 #1774
trace_diffuse_ray_80percent.2588:
	lw %a3 %a11 8 #1778
	lw %a4 %a11 4 #1778
	sw %a2 %sp 0 #1780
	sw %a1 %sp 4 #1780
	sw %a3 %sp 8 #1780
	sw %a4 %sp 12 #1780
	sw %a0 %sp 16 #1780
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8765 # nontail if
	jal %zero beq_cont.8766 # then sentence ends
beq_else.8765:
	lw %a5 %a4 0 #81
	add %a0 %a5 %zero
	add %a11 %a3 %zero
	sw %ra %sp 20 #1781 call cls
	lw %a10 %a11 0 #1781
	addi %sp %sp 24 #1781	
	jalr %ra %a10 0 #1781
	addi %sp %sp -24 #1781
	lw %ra %sp 20 #1781
beq_cont.8766:
	lw %a0 %sp 16 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8767 # nontail if
	jal %zero beq_cont.8768 # then sentence ends
beq_else.8767:
	lw %a1 %sp 12 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 4 #1785
	lw %a4 %sp 0 #1785
	lw %a11 %sp 8 #1785
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 20 #1785 call cls
	lw %a10 %a11 0 #1785
	addi %sp %sp 24 #1785	
	jalr %ra %a10 0 #1785
	addi %sp %sp -24 #1785
	lw %ra %sp 20 #1785
beq_cont.8768:
	lw %a0 %sp 16 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8769 # nontail if
	jal %zero beq_cont.8770 # then sentence ends
beq_else.8769:
	lw %a1 %sp 12 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 4 #1789
	lw %a4 %sp 0 #1789
	lw %a11 %sp 8 #1789
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 20 #1789 call cls
	lw %a10 %a11 0 #1789
	addi %sp %sp 24 #1789	
	jalr %ra %a10 0 #1789
	addi %sp %sp -24 #1789
	lw %ra %sp 20 #1789
beq_cont.8770:
	lw %a0 %sp 16 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.8771 # nontail if
	jal %zero beq_cont.8772 # then sentence ends
beq_else.8771:
	lw %a1 %sp 12 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 4 #1793
	lw %a4 %sp 0 #1793
	lw %a11 %sp 8 #1793
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 20 #1793 call cls
	lw %a10 %a11 0 #1793
	addi %sp %sp 24 #1793	
	jalr %ra %a10 0 #1793
	addi %sp %sp -24 #1793
	lw %ra %sp 20 #1793
beq_cont.8772:
	lw %a0 %sp 16 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.8773
	jalr %zero %ra 0 #1798
beq_else.8773:
	lw %a0 %sp 12 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 4 #1797
	lw %a2 %sp 0 #1797
	lw %a11 %sp 8 #1797
	lw %a10 %a11 0 #1797
	jalr %zero %a10 0 #1797
calc_diffuse_using_1point.2592:
	lw %a2 %a11 12 #1803
	lw %a3 %a11 8 #1803
	lw %a4 %a11 4 #1803
	sw %a3 %sp 0 #1805
	sw %a2 %sp 4 #1805
	sw %a4 %sp 8 #1805
	sw %a1 %sp 12 #1805
	sw %a0 %sp 16 #1805
	sw %ra %sp 20 #1805 call dir
	addi %sp %sp 24 #1805	
	jal %ra p_received_ray_20percent.2341 #1805
	addi %sp %sp -24 #1805
	lw %ra %sp 20 #1805
	lw %a1 %sp 16 #1806
	sw %a0 %sp 20 #1806
	add %a0 %a1 %zero
	sw %ra %sp 28 #1806 call dir
	addi %sp %sp 32 #1806	
	jal %ra p_nvectors.2348 #1806
	addi %sp %sp -32 #1806
	lw %ra %sp 28 #1806
	lw %a1 %sp 16 #1807
	sw %a0 %sp 24 #1807
	add %a0 %a1 %zero
	sw %ra %sp 28 #1807 call dir
	addi %sp %sp 32 #1807	
	jal %ra p_intersection_points.2333 #1807
	addi %sp %sp -32 #1807
	lw %ra %sp 28 #1807
	lw %a1 %sp 16 #1808
	sw %a0 %sp 28 #1808
	add %a0 %a1 %zero
	sw %ra %sp 36 #1808 call dir
	addi %sp %sp 40 #1808	
	jal %ra p_energy.2339 #1808
	addi %sp %sp -40 #1808
	lw %ra %sp 36 #1808
	lw %a1 %sp 12 #1810
	slli %a2 %a1 2 #1810
	lw %a3 %sp 20 #1810
	add %a12 %a3 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %a3 %sp 8 #1810
	sw %a0 %sp 32 #1810
	add %a1 %a2 %zero
	add %a0 %a3 %zero
	sw %ra %sp 36 #1810 call dir
	addi %sp %sp 40 #1810	
	jal %ra veccpy.2253 #1810
	addi %sp %sp -40 #1810
	lw %ra %sp 36 #1810
	lw %a0 %sp 16 #1812
	sw %ra %sp 36 #1812 call dir
	addi %sp %sp 40 #1812	
	jal %ra p_group_id.2343 #1812
	addi %sp %sp -40 #1812
	lw %ra %sp 36 #1812
	lw %a1 %sp 12 #1676
	slli %a2 %a1 2 #1676
	lw %a3 %sp 24 #1676
	add %a12 %a3 %a2 #1676
	lw %a2 %a12 0 #1676
	slli %a3 %a1 2 #1664
	lw %a4 %sp 28 #1664
	add %a12 %a4 %a3 #1664
	lw %a3 %a12 0 #1664
	lw %a11 %sp 4 #1811
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 36 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 40 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -40 #1811
	lw %ra %sp 36 #1811
	lw %a0 %sp 12 #1673
	slli %a0 %a0 2 #1673
	lw %a1 %sp 32 #1673
	add %a12 %a1 %a0 #1673
	lw %a1 %a12 0 #1673
	lw %a0 %sp 0 #1815
	lw %a2 %sp 8 #1815
	jal	%zero vecaccumv.2285
calc_diffuse_using_5points.2595:
	lw %a5 %a11 8 #1821
	lw %a6 %a11 4 #1821
	slli %a7 %a0 2 #1823
	add %a12 %a1 %a7 #1823
	lw %a1 %a12 0 #1823
	sw %a5 %sp 0 #1823
	sw %a6 %sp 4 #1823
	sw %a4 %sp 8 #1823
	sw %a3 %sp 12 #1823
	sw %a2 %sp 16 #1823
	sw %a0 %sp 20 #1823
	add %a0 %a1 %zero
	sw %ra %sp 28 #1823 call dir
	addi %sp %sp 32 #1823	
	jal %ra p_received_ray_20percent.2341 #1823
	addi %sp %sp -32 #1823
	lw %ra %sp 28 #1823
	lw %a1 %sp 20 #1824
	addi %a2 %a1 -1 #1824
	slli %a2 %a2 2 #1824
	lw %a3 %sp 16 #1824
	add %a12 %a3 %a2 #1824
	lw %a2 %a12 0 #1824
	sw %a0 %sp 24 #1824
	add %a0 %a2 %zero
	sw %ra %sp 28 #1824 call dir
	addi %sp %sp 32 #1824	
	jal %ra p_received_ray_20percent.2341 #1824
	addi %sp %sp -32 #1824
	lw %ra %sp 28 #1824
	lw %a1 %sp 20 #1824
	slli %a2 %a1 2 #1824
	lw %a3 %sp 16 #1824
	add %a12 %a3 %a2 #1824
	lw %a2 %a12 0 #1824
	sw %a0 %sp 28 #1825
	add %a0 %a2 %zero
	sw %ra %sp 36 #1825 call dir
	addi %sp %sp 40 #1825	
	jal %ra p_received_ray_20percent.2341 #1825
	addi %sp %sp -40 #1825
	lw %ra %sp 36 #1825
	lw %a1 %sp 20 #1826
	addi %a2 %a1 1 #1826
	slli %a2 %a2 2 #1824
	lw %a3 %sp 16 #1824
	add %a12 %a3 %a2 #1824
	lw %a2 %a12 0 #1824
	sw %a0 %sp 32 #1826
	add %a0 %a2 %zero
	sw %ra %sp 36 #1826 call dir
	addi %sp %sp 40 #1826	
	jal %ra p_received_ray_20percent.2341 #1826
	addi %sp %sp -40 #1826
	lw %ra %sp 36 #1826
	lw %a1 %sp 20 #1827
	slli %a2 %a1 2 #1827
	lw %a3 %sp 12 #1827
	add %a12 %a3 %a2 #1827
	lw %a2 %a12 0 #1827
	sw %a0 %sp 36 #1827
	add %a0 %a2 %zero
	sw %ra %sp 44 #1827 call dir
	addi %sp %sp 48 #1827	
	jal %ra p_received_ray_20percent.2341 #1827
	addi %sp %sp -48 #1827
	lw %ra %sp 44 #1827
	lw %a1 %sp 8 #1810
	slli %a2 %a1 2 #1810
	lw %a3 %sp 24 #1810
	add %a12 %a3 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %a3 %sp 4 #1829
	sw %a0 %sp 40 #1829
	add %a1 %a2 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1829 call dir
	addi %sp %sp 48 #1829	
	jal %ra veccpy.2253 #1829
	addi %sp %sp -48 #1829
	lw %ra %sp 44 #1829
	lw %a0 %sp 8 #1810
	slli %a1 %a0 2 #1810
	lw %a2 %sp 28 #1810
	add %a12 %a2 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %a2 %sp 4 #1830
	add %a0 %a2 %zero
	sw %ra %sp 44 #1830 call dir
	addi %sp %sp 48 #1830	
	jal %ra vecadd.2276 #1830
	addi %sp %sp -48 #1830
	lw %ra %sp 44 #1830
	lw %a0 %sp 8 #1810
	slli %a1 %a0 2 #1810
	lw %a2 %sp 32 #1810
	add %a12 %a2 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %a2 %sp 4 #1831
	add %a0 %a2 %zero
	sw %ra %sp 44 #1831 call dir
	addi %sp %sp 48 #1831	
	jal %ra vecadd.2276 #1831
	addi %sp %sp -48 #1831
	lw %ra %sp 44 #1831
	lw %a0 %sp 8 #1810
	slli %a1 %a0 2 #1810
	lw %a2 %sp 36 #1810
	add %a12 %a2 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %a2 %sp 4 #1832
	add %a0 %a2 %zero
	sw %ra %sp 44 #1832 call dir
	addi %sp %sp 48 #1832	
	jal %ra vecadd.2276 #1832
	addi %sp %sp -48 #1832
	lw %ra %sp 44 #1832
	lw %a0 %sp 8 #1810
	slli %a1 %a0 2 #1810
	lw %a2 %sp 40 #1810
	add %a12 %a2 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %a2 %sp 4 #1833
	add %a0 %a2 %zero
	sw %ra %sp 44 #1833 call dir
	addi %sp %sp 48 #1833	
	jal %ra vecadd.2276 #1833
	addi %sp %sp -48 #1833
	lw %ra %sp 44 #1833
	lw %a0 %sp 20 #1824
	slli %a0 %a0 2 #1824
	lw %a1 %sp 16 #1824
	add %a12 %a1 %a0 #1824
	lw %a0 %a12 0 #1824
	sw %ra %sp 44 #1835 call dir
	addi %sp %sp 48 #1835	
	jal %ra p_energy.2339 #1835
	addi %sp %sp -48 #1835
	lw %ra %sp 44 #1835
	lw %a1 %sp 8 #1673
	slli %a1 %a1 2 #1673
	add %a12 %a0 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a0 %sp 0 #1836
	lw %a2 %sp 4 #1836
	jal	%zero vecaccumv.2285
do_without_neighbors.2601:
	lw %a2 %a11 4 #1841
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.8775
	sw %a11 %sp 0 #1844
	sw %a2 %sp 4 #1844
	sw %a0 %sp 8 #1844
	sw %a1 %sp 12 #1844
	sw %ra %sp 20 #1844 call dir
	addi %sp %sp 24 #1844	
	jal %ra p_surface_ids.2335 #1844
	addi %sp %sp -24 #1844
	lw %ra %sp 20 #1844
	lw %a1 %sp 12 #1662
	slli %a2 %a1 2 #1662
	add %a12 %a0 %a2 #1662
	lw %a0 %a12 0 #1662
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8776
	lw %a0 %sp 8 #1846
	sw %ra %sp 20 #1846 call dir
	addi %sp %sp 24 #1846	
	jal %ra p_calc_diffuse.2337 #1846
	addi %sp %sp -24 #1846
	lw %ra %sp 20 #1846
	lw %a1 %sp 12 #1669
	slli %a2 %a1 2 #1669
	add %a12 %a0 %a2 #1669
	lw %a0 %a12 0 #1669
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8777 # nontail if
	jal %zero beq_cont.8778 # then sentence ends
beq_else.8777:
	lw %a0 %sp 8 #1848
	lw %a11 %sp 4 #1848
	sw %ra %sp 20 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 24 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -24 #1848
	lw %ra %sp 20 #1848
beq_cont.8778:
	lw %a0 %sp 12 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 8 #1850
	lw %a11 %sp 0 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.8776:
	jalr %zero %ra 0 #1851
bge_else.8775:
	jalr %zero %ra 0 #1852
neighbors_exist.2604:
	lw %a2 %a11 4 #1856
	lw %a3 %a2 4 #57
	addi %a4 %a1 1 #1857
	blt %a4 %a3 bge_else.8781
	addi %a0 %zero 0 #1865
	jalr %zero %ra 0 #1865
bge_else.8781:
	addi %a3 %zero 0 #1858
	addi %a12 %zero 0
	blt %a12 %a1 bge_else.8782
	addi %a0 %a3 0 #1858
	jalr %zero %ra 0 #1858
bge_else.8782:
	lw %a1 %a2 0 #57
	addi %a2 %a0 1 #1859
	blt %a2 %a1 bge_else.8783
	addi %a0 %a3 0 #1858
	jalr %zero %ra 0 #1858
bge_else.8783:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.8784
	addi %a0 %a3 0 #1858
	jalr %zero %ra 0 #1858
bge_else.8784:
	addi %a0 %zero 1 #1861
	jalr %zero %ra 0 #1861
get_surface_id.2608:
	sw %a1 %sp 0 #1869
	sw %ra %sp 4 #1869 call dir
	addi %sp %sp 8 #1869	
	jal %ra p_surface_ids.2335 #1869
	addi %sp %sp -8 #1869
	lw %ra %sp 4 #1869
	lw %a1 %sp 0 #1662
	slli %a1 %a1 2 #1662
	add %a12 %a0 %a1 #1662
	lw %a0 %a12 0 #1662
	jalr %zero %ra 0 #1662
neighbors_are_available.2611:
	slli %a5 %a0 2 #1875
	add %a12 %a2 %a5 #1875
	lw %a5 %a12 0 #1875
	sw %a2 %sp 0 #1875
	sw %a3 %sp 4 #1875
	sw %a4 %sp 8 #1875
	sw %a1 %sp 12 #1875
	sw %a0 %sp 16 #1875
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	sw %ra %sp 20 #1875 call dir
	addi %sp %sp 24 #1875	
	jal %ra get_surface_id.2608 #1875
	addi %sp %sp -24 #1875
	lw %ra %sp 20 #1875
	lw %a1 %sp 16 #1877
	slli %a2 %a1 2 #1877
	lw %a3 %sp 12 #1877
	add %a12 %a3 %a2 #1877
	lw %a2 %a12 0 #1877
	lw %a3 %sp 8 #1877
	sw %a0 %sp 20 #1877
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #1877 call dir
	addi %sp %sp 32 #1877	
	jal %ra get_surface_id.2608 #1877
	addi %sp %sp -32 #1877
	lw %ra %sp 28 #1877
	lw %a1 %sp 20 #1662
	bne %a0 %a1 beq_else.8785
	lw %a0 %sp 16 #1878
	slli %a2 %a0 2 #1878
	lw %a3 %sp 4 #1878
	add %a12 %a3 %a2 #1878
	lw %a2 %a12 0 #1878
	lw %a3 %sp 8 #1878
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #1878 call dir
	addi %sp %sp 32 #1878	
	jal %ra get_surface_id.2608 #1878
	addi %sp %sp -32 #1878
	lw %ra %sp 28 #1878
	lw %a1 %sp 20 #1662
	bne %a0 %a1 beq_else.8786
	lw %a0 %sp 16 #1879
	addi %a2 %a0 -1 #1879
	slli %a2 %a2 2 #1875
	lw %a3 %sp 0 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a4 %sp 8 #1879
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #1879 call dir
	addi %sp %sp 32 #1879	
	jal %ra get_surface_id.2608 #1879
	addi %sp %sp -32 #1879
	lw %ra %sp 28 #1879
	lw %a1 %sp 20 #1662
	bne %a0 %a1 beq_else.8787
	lw %a0 %sp 16 #1880
	addi %a0 %a0 1 #1880
	slli %a0 %a0 2 #1875
	lw %a2 %sp 0 #1875
	add %a12 %a2 %a0 #1875
	lw %a0 %a12 0 #1875
	lw %a2 %sp 8 #1880
	add %a1 %a2 %zero
	sw %ra %sp 28 #1880 call dir
	addi %sp %sp 32 #1880	
	jal %ra get_surface_id.2608 #1880
	addi %sp %sp -32 #1880
	lw %ra %sp 28 #1880
	lw %a1 %sp 20 #1662
	bne %a0 %a1 beq_else.8788
	addi %a0 %zero 1 #1881
	jalr %zero %ra 0 #1881
beq_else.8788:
	addi %a0 %zero 0 #1882
	jalr %zero %ra 0 #1882
beq_else.8787:
	addi %a0 %zero 0 #1883
	jalr %zero %ra 0 #1883
beq_else.8786:
	addi %a0 %zero 0 #1884
	jalr %zero %ra 0 #1884
beq_else.8785:
	addi %a0 %zero 0 #1885
	jalr %zero %ra 0 #1885
try_exploit_neighbors.2617:
	lw %a6 %a11 8 #1890
	lw %a7 %a11 4 #1890
	slli %a8 %a0 2 #1891
	add %a12 %a3 %a8 #1891
	lw %a8 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a5 bge_else.8789
	sw %a1 %sp 0 #1895
	sw %a11 %sp 4 #1895
	sw %a7 %sp 8 #1895
	sw %a8 %sp 12 #1895
	sw %a6 %sp 16 #1895
	sw %a5 %sp 20 #1895
	sw %a4 %sp 24 #1895
	sw %a3 %sp 28 #1895
	sw %a2 %sp 32 #1895
	sw %a0 %sp 36 #1895
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	sw %ra %sp 44 #1895 call dir
	addi %sp %sp 48 #1895	
	jal %ra get_surface_id.2608 #1895
	addi %sp %sp -48 #1895
	lw %ra %sp 44 #1895
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8790
	lw %a0 %sp 36 #1897
	lw %a1 %sp 32 #1897
	lw %a2 %sp 28 #1897
	lw %a3 %sp 24 #1897
	lw %a4 %sp 20 #1897
	sw %ra %sp 44 #1897 call dir
	addi %sp %sp 48 #1897	
	jal %ra neighbors_are_available.2611 #1897
	addi %sp %sp -48 #1897
	lw %ra %sp 44 #1897
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8791
	lw %a0 %sp 12 #1909
	lw %a1 %sp 20 #1909
	lw %a11 %sp 16 #1909
	lw %a10 %a11 0 #1909
	jalr %zero %a10 0 #1909
beq_else.8791:
	lw %a0 %sp 12 #1900
	sw %ra %sp 44 #1900 call dir
	addi %sp %sp 48 #1900	
	jal %ra p_calc_diffuse.2337 #1900
	addi %sp %sp -48 #1900
	lw %ra %sp 44 #1900
	lw %a4 %sp 20 #1669
	slli %a1 %a4 2 #1669
	add %a12 %a0 %a1 #1669
	lw %a0 %a12 0 #1669
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8792 # nontail if
	jal %zero beq_cont.8793 # then sentence ends
beq_else.8792:
	lw %a0 %sp 36 #1902
	lw %a1 %sp 32 #1902
	lw %a2 %sp 28 #1902
	lw %a3 %sp 24 #1902
	lw %a11 %sp 8 #1902
	sw %ra %sp 44 #1902 call cls
	lw %a10 %a11 0 #1902
	addi %sp %sp 48 #1902	
	jalr %ra %a10 0 #1902
	addi %sp %sp -48 #1902
	lw %ra %sp 44 #1902
beq_cont.8793:
	lw %a0 %sp 20 #1906
	addi %a5 %a0 1 #1906
	lw %a0 %sp 36 #1906
	lw %a1 %sp 0 #1906
	lw %a2 %sp 32 #1906
	lw %a3 %sp 28 #1906
	lw %a4 %sp 24 #1906
	lw %a11 %sp 4 #1906
	lw %a10 %a11 0 #1906
	jalr %zero %a10 0 #1906
bge_else.8790:
	jalr %zero %ra 0 #1910
bge_else.8789:
	jalr %zero %ra 0 #1911
write_ppm_header.2624:
	lw %a0 %a11 4 #1915
	addi %a1 %zero 80 #1917
	sw %a0 %sp 0 #1917
	add %a0 %a1 %zero
	sw %ra %sp 4 #1917 call dir
	addi %sp %sp 8 #1917	
	jal %ra min_caml_print_char #1917
	addi %sp %sp -8 #1917
	lw %ra %sp 4 #1917
	addi %a0 %zero 48 #1918
	addi %a0 %a0 3 #1918
	sw %ra %sp 4 #1918 call dir
	addi %sp %sp 8 #1918	
	jal %ra min_caml_print_char #1918
	addi %sp %sp -8 #1918
	lw %ra %sp 4 #1918
	addi %a0 %zero 10 #1919
	sw %ra %sp 4 #1919 call dir
	addi %sp %sp 8 #1919	
	jal %ra min_caml_print_char #1919
	addi %sp %sp -8 #1919
	lw %ra %sp 4 #1919
	lw %a0 %sp 0 #57
	lw %a1 %a0 0 #57
	add %a0 %a1 %zero
	sw %ra %sp 4 #1920 call dir
	addi %sp %sp 8 #1920	
	jal %ra min_caml_print_int #1920
	addi %sp %sp -8 #1920
	lw %ra %sp 4 #1920
	addi %a0 %zero 32 #1921
	sw %ra %sp 4 #1921 call dir
	addi %sp %sp 8 #1921	
	jal %ra min_caml_print_char #1921
	addi %sp %sp -8 #1921
	lw %ra %sp 4 #1921
	lw %a0 %sp 0 #57
	lw %a0 %a0 4 #57
	sw %ra %sp 4 #1922 call dir
	addi %sp %sp 8 #1922	
	jal %ra min_caml_print_int #1922
	addi %sp %sp -8 #1922
	lw %ra %sp 4 #1922
	addi %a0 %zero 32 #1923
	sw %ra %sp 4 #1923 call dir
	addi %sp %sp 8 #1923	
	jal %ra min_caml_print_char #1923
	addi %sp %sp -8 #1923
	lw %ra %sp 4 #1923
	addi %a0 %zero 255 #1924
	sw %ra %sp 4 #1924 call dir
	addi %sp %sp 8 #1924	
	jal %ra min_caml_print_int #1924
	addi %sp %sp -8 #1924
	lw %ra %sp 4 #1924
	addi %a0 %zero 10 #1925
	jal	%zero min_caml_print_char
write_rgb_element.2626:
	sw %ra %sp 4 #1930 call dir
	addi %sp %sp 8 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -8 #1930
	lw %ra %sp 4 #1930
	addi %a1 %zero 255 #1931
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.8796 # nontail if
	addi %a1 %zero 0 #1931
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8798 # nontail if
	jal %zero bge_cont.8799 # then sentence ends
bge_else.8798:
	addi %a0 %a1 0 #1931
bge_cont.8799:
	jal %zero bge_cont.8797 # then sentence ends
bge_else.8796:
	addi %a0 %a1 0 #1931
bge_cont.8797:
	jal	%zero min_caml_print_int
write_rgb.2628:
	lw %a0 %a11 4 #1935
	lw %f0 %a0 0 #54
	sw %a0 %sp 0 #1936
	sw %ra %sp 4 #1936 call dir
	addi %sp %sp 8 #1936	
	jal %ra write_rgb_element.2626 #1936
	addi %sp %sp -8 #1936
	lw %ra %sp 4 #1936
	addi %a0 %zero 32 #1937
	sw %ra %sp 4 #1937 call dir
	addi %sp %sp 8 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -8 #1937
	lw %ra %sp 4 #1937
	lw %a0 %sp 0 #54
	lw %f0 %a0 4 #54
	sw %ra %sp 4 #1938 call dir
	addi %sp %sp 8 #1938	
	jal %ra write_rgb_element.2626 #1938
	addi %sp %sp -8 #1938
	lw %ra %sp 4 #1938
	addi %a0 %zero 32 #1939
	sw %ra %sp 4 #1939 call dir
	addi %sp %sp 8 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -8 #1939
	lw %ra %sp 4 #1939
	lw %a0 %sp 0 #54
	lw %f0 %a0 8 #54
	sw %ra %sp 4 #1940 call dir
	addi %sp %sp 8 #1940	
	jal %ra write_rgb_element.2626 #1940
	addi %sp %sp -8 #1940
	lw %ra %sp 4 #1940
	addi %a0 %zero 10 #1941
	jal	%zero min_caml_print_char
pretrace_diffuse_rays.2630:
	lw %a2 %a11 12 #1949
	lw %a3 %a11 8 #1949
	lw %a4 %a11 4 #1949
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.8800
	sw %a11 %sp 0 #1953
	sw %a2 %sp 4 #1953
	sw %a3 %sp 8 #1953
	sw %a4 %sp 12 #1953
	sw %a1 %sp 16 #1953
	sw %a0 %sp 20 #1953
	sw %ra %sp 28 #1953 call dir
	addi %sp %sp 32 #1953	
	jal %ra get_surface_id.2608 #1953
	addi %sp %sp -32 #1953
	lw %ra %sp 28 #1953
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8801
	lw %a0 %sp 20 #1956
	sw %ra %sp 28 #1956 call dir
	addi %sp %sp 32 #1956	
	jal %ra p_calc_diffuse.2337 #1956
	addi %sp %sp -32 #1956
	lw %ra %sp 28 #1956
	lw %a1 %sp 16 #1669
	slli %a2 %a1 2 #1669
	add %a12 %a0 %a2 #1669
	lw %a0 %a12 0 #1669
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8802 # nontail if
	jal %zero beq_cont.8803 # then sentence ends
beq_else.8802:
	lw %a0 %sp 20 #1958
	sw %ra %sp 28 #1958 call dir
	addi %sp %sp 32 #1958	
	jal %ra p_group_id.2343 #1958
	addi %sp %sp -32 #1958
	lw %ra %sp 28 #1958
	lw %a1 %sp 12 #1959
	sw %a0 %sp 24 #1959
	add %a0 %a1 %zero
	sw %ra %sp 28 #1959 call dir
	addi %sp %sp 32 #1959	
	jal %ra vecbzero.2251 #1959
	addi %sp %sp -32 #1959
	lw %ra %sp 28 #1959
	lw %a0 %sp 20 #1962
	sw %ra %sp 28 #1962 call dir
	addi %sp %sp 32 #1962	
	jal %ra p_nvectors.2348 #1962
	addi %sp %sp -32 #1962
	lw %ra %sp 28 #1962
	lw %a1 %sp 20 #1963
	sw %a0 %sp 28 #1963
	add %a0 %a1 %zero
	sw %ra %sp 36 #1963 call dir
	addi %sp %sp 40 #1963	
	jal %ra p_intersection_points.2333 #1963
	addi %sp %sp -40 #1963
	lw %ra %sp 36 #1963
	lw %a1 %sp 24 #81
	slli %a1 %a1 2 #81
	lw %a2 %sp 8 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	lw %a2 %sp 16 #1676
	slli %a3 %a2 2 #1676
	lw %a4 %sp 28 #1676
	add %a12 %a4 %a3 #1676
	lw %a3 %a12 0 #1676
	slli %a4 %a2 2 #1664
	add %a12 %a0 %a4 #1664
	lw %a0 %a12 0 #1664
	lw %a11 %sp 4 #1964
	add %a2 %a0 %zero
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 36 #1964 call cls
	lw %a10 %a11 0 #1964
	addi %sp %sp 40 #1964	
	jalr %ra %a10 0 #1964
	addi %sp %sp -40 #1964
	lw %ra %sp 36 #1964
	lw %a0 %sp 20 #1968
	sw %ra %sp 36 #1968 call dir
	addi %sp %sp 40 #1968	
	jal %ra p_received_ray_20percent.2341 #1968
	addi %sp %sp -40 #1968
	lw %ra %sp 36 #1968
	lw %a1 %sp 16 #1810
	slli %a2 %a1 2 #1810
	add %a12 %a0 %a2 #1810
	lw %a0 %a12 0 #1810
	lw %a2 %sp 12 #1969
	add %a1 %a2 %zero
	sw %ra %sp 36 #1969 call dir
	addi %sp %sp 40 #1969	
	jal %ra veccpy.2253 #1969
	addi %sp %sp -40 #1969
	lw %ra %sp 36 #1969
beq_cont.8803:
	lw %a0 %sp 16 #1971
	addi %a1 %a0 1 #1971
	lw %a0 %sp 20 #1971
	lw %a11 %sp 0 #1971
	lw %a10 %a11 0 #1971
	jalr %zero %a10 0 #1971
bge_else.8801:
	jalr %zero %ra 0 #1972
bge_else.8800:
	jalr %zero %ra 0 #1973
pretrace_pixels.2633:
	lw %a3 %a11 36 #1978
	lw %a4 %a11 32 #1978
	lw %a5 %a11 28 #1978
	lw %a6 %a11 24 #1978
	lw %a7 %a11 20 #1978
	lw %a8 %a11 16 #1978
	lw %a9 %a11 12 #1978
	lw %a10 %a11 8 #1978
	sw %a11 %sp 0 #1978
	lw %a11 %a11 4 #1978
	sw %a10 %sp 4 #1979
	addi %a10 %zero 0 #1979
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8806
	lw %f3 %a7 0 #61
	lw %a7 %a11 0 #59
	sub %a7 %a1 %a7 #1981
	sw %a2 %sp 8 #1981
	sw %a4 %sp 12 #1981
	sw %a0 %sp 16 #1981
	sw %a1 %sp 20 #1981
	sw %a3 %sp 24 #1981
	sw %a5 %sp 28 #1981
	sw %a8 %sp 32 #1981
	sw %a10 %sp 36 #1981
	sw %f2 %sp 40 #1981
	sw %f1 %sp 48 #1981
	sw %a9 %sp 56 #1981
	sw %f0 %sp 64 #1981
	sw %a6 %sp 72 #1981
	sw %f3 %sp 80 #1981
	add %a0 %a7 %zero
	sw %ra %sp 92 #1981 call dir
	addi %sp %sp 96 #1981	
	jal %ra min_caml_float_of_int #1981
	addi %sp %sp -96 #1981
	lw %ra %sp 92 #1981
	lw %f1 %sp 80 #1981
	fmul %f0 %f1 %f0 #1981
	lw %a0 %sp 72 #69
	lw %f1 %a0 0 #69
	fmul %f1 %f0 %f1 #1982
	lw %f2 %sp 64 #1982
	fadd %f1 %f1 %f2 #1982
	lw %a1 %sp 56 #1982
	sw %f1 %a1 0 #1982
	lw %f1 %a0 4 #69
	fmul %f1 %f0 %f1 #1983
	lw %f3 %sp 48 #1983
	fadd %f1 %f1 %f3 #1983
	sw %f1 %a1 4 #1983
	lw %f1 %a0 8 #69
	fmul %f0 %f0 %f1 #1984
	lw %f1 %sp 40 #1984
	fadd %f0 %f0 %f1 #1984
	sw %f0 %a1 8 #1984
	lw %a0 %sp 36 #1985
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 92 #1985 call dir
	addi %sp %sp 96 #1985	
	jal %ra vecunit_sgn.2261 #1985
	addi %sp %sp -96 #1985
	lw %ra %sp 92 #1985
	lw %a0 %sp 32 #1986
	sw %ra %sp 92 #1986 call dir
	addi %sp %sp 96 #1986	
	jal %ra vecbzero.2251 #1986
	addi %sp %sp -96 #1986
	lw %ra %sp 92 #1986
	lw %a0 %sp 28 #1987
	lw %a1 %sp 24 #1987
	sw %ra %sp 92 #1987 call dir
	addi %sp %sp 96 #1987	
	jal %ra veccpy.2253 #1987
	addi %sp %sp -96 #1987
	lw %ra %sp 92 #1987
	li %f0 l.5553 #1990
	lw %a0 %sp 20 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 16 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	li %f1 l.5551 #1990
	lw %a3 %sp 36 #1990
	lw %a4 %sp 56 #1990
	lw %a11 %sp 12 #1990
	add %a2 %a1 %zero
	add %a0 %a3 %zero
	add %a1 %a4 %zero
	sw %ra %sp 92 #1990 call cls
	lw %a10 %a11 0 #1990
	addi %sp %sp 96 #1990	
	jalr %ra %a10 0 #1990
	addi %sp %sp -96 #1990
	lw %ra %sp 92 #1990
	lw %a0 %sp 20 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 16 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	add %a0 %a1 %zero
	sw %ra %sp 92 #1991 call dir
	addi %sp %sp 96 #1991	
	jal %ra p_rgb.2331 #1991
	addi %sp %sp -96 #1991
	lw %ra %sp 92 #1991
	lw %a1 %sp 32 #1991
	sw %ra %sp 92 #1991 call dir
	addi %sp %sp 96 #1991	
	jal %ra veccpy.2253 #1991
	addi %sp %sp -96 #1991
	lw %ra %sp 92 #1991
	lw %a0 %sp 20 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 16 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a3 %sp 8 #1992
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 92 #1992 call dir
	addi %sp %sp 96 #1992	
	jal %ra p_set_group_id.2345 #1992
	addi %sp %sp -96 #1992
	lw %ra %sp 92 #1992
	lw %a0 %sp 20 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 16 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a3 %sp 36 #1995
	lw %a11 %sp 4 #1995
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 92 #1995 call cls
	lw %a10 %a11 0 #1995
	addi %sp %sp 96 #1995	
	jalr %ra %a10 0 #1995
	addi %sp %sp -96 #1995
	lw %ra %sp 92 #1995
	lw %a0 %sp 20 #1997
	addi %a0 %a0 -1 #1997
	addi %a1 %zero 1 #1997
	lw %a2 %sp 8 #1997
	sw %a0 %sp 88 #1997
	add %a0 %a2 %zero
	sw %ra %sp 92 #1997 call dir
	addi %sp %sp 96 #1997	
	jal %ra add_mod5.2240 #1997
	addi %sp %sp -96 #1997
	lw %ra %sp 92 #1997
	add %a2 %a0 %zero #1997
	lw %f0 %sp 64 #1997
	lw %f1 %sp 48 #1997
	lw %f2 %sp 40 #1997
	lw %a0 %sp 16 #1997
	lw %a1 %sp 88 #1997
	lw %a11 %sp 0 #1997
	lw %a10 %a11 0 #1997
	jalr %zero %a10 0 #1997
bge_else.8806:
	jalr %zero %ra 0 #1999
pretrace_line.2640:
	lw %a3 %a11 24 #2003
	lw %a4 %a11 20 #2003
	lw %a5 %a11 16 #2003
	lw %a6 %a11 12 #2003
	lw %a7 %a11 8 #2003
	lw %a8 %a11 4 #2003
	lw %f0 %a5 0 #61
	lw %a5 %a8 4 #59
	sub %a1 %a1 %a5 #2004
	sw %a2 %sp 0 #2004
	sw %a0 %sp 4 #2004
	sw %a6 %sp 8 #2004
	sw %a7 %sp 12 #2004
	sw %a3 %sp 16 #2004
	sw %a4 %sp 20 #2004
	sw %f0 %sp 24 #2004
	add %a0 %a1 %zero
	sw %ra %sp 36 #2004 call dir
	addi %sp %sp 40 #2004	
	jal %ra min_caml_float_of_int #2004
	addi %sp %sp -40 #2004
	lw %ra %sp 36 #2004
	lw %f1 %sp 24 #2004
	fmul %f0 %f1 %f0 #2004
	lw %a0 %sp 20 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 16 #71
	lw %f2 %a1 0 #71
	fadd %f1 %f1 %f2 #2007
	lw %f2 %a0 4 #70
	fmul %f2 %f0 %f2 #2008
	lw %f3 %a1 4 #71
	fadd %f2 %f2 %f3 #2008
	lw %f3 %a0 8 #70
	fmul %f0 %f0 %f3 #2009
	lw %f3 %a1 8 #71
	fadd %f0 %f0 %f3 #2009
	lw %a0 %sp 12 #57
	lw %a0 %a0 0 #57
	addi %a1 %a0 -1 #2010
	lw %a0 %sp 4 #2010
	lw %a2 %sp 0 #2010
	lw %a11 %sp 8 #2010
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	lw %a10 %a11 0 #2010
	jalr %zero %a10 0 #2010
scan_pixel.2644:
	lw %a5 %a11 24 #2017
	lw %a6 %a11 20 #2017
	lw %a7 %a11 16 #2017
	lw %a8 %a11 12 #2017
	lw %a9 %a11 8 #2017
	lw %a10 %a11 4 #2017
	lw %a9 %a9 0 #57
	blt %a0 %a9 bge_else.8810
	jalr %zero %ra 0 #2033
bge_else.8810:
	slli %a9 %a0 2 #2021
	add %a12 %a3 %a9 #2021
	lw %a9 %a12 0 #2021
	sw %a11 %sp 0 #2021
	sw %a5 %sp 4 #2021
	sw %a2 %sp 8 #2021
	sw %a6 %sp 12 #2021
	sw %a10 %sp 16 #2021
	sw %a3 %sp 20 #2021
	sw %a4 %sp 24 #2021
	sw %a1 %sp 28 #2021
	sw %a0 %sp 32 #2021
	sw %a8 %sp 36 #2021
	sw %a7 %sp 40 #2021
	add %a0 %a9 %zero
	sw %ra %sp 44 #2021 call dir
	addi %sp %sp 48 #2021	
	jal %ra p_rgb.2331 #2021
	addi %sp %sp -48 #2021
	lw %ra %sp 44 #2021
	add %a1 %a0 %zero #2021
	lw %a0 %sp 40 #2021
	sw %ra %sp 44 #2021 call dir
	addi %sp %sp 48 #2021	
	jal %ra veccpy.2253 #2021
	addi %sp %sp -48 #2021
	lw %ra %sp 44 #2021
	lw %a0 %sp 32 #2024
	lw %a1 %sp 28 #2024
	lw %a2 %sp 24 #2024
	lw %a11 %sp 36 #2024
	sw %ra %sp 44 #2024 call cls
	lw %a10 %a11 0 #2024
	addi %sp %sp 48 #2024	
	jalr %ra %a10 0 #2024
	addi %sp %sp -48 #2024
	lw %ra %sp 44 #2024
	addi %a1 %zero 0 #2024
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8812 # nontail if
	lw %a0 %sp 32 #2021
	slli %a2 %a0 2 #2021
	lw %a3 %sp 20 #2021
	add %a12 %a3 %a2 #2021
	lw %a2 %a12 0 #2021
	lw %a11 %sp 16 #2027
	add %a0 %a2 %zero
	sw %ra %sp 44 #2027 call cls
	lw %a10 %a11 0 #2027
	addi %sp %sp 48 #2027	
	jalr %ra %a10 0 #2027
	addi %sp %sp -48 #2027
	lw %ra %sp 44 #2027
	jal %zero beq_cont.8813 # then sentence ends
beq_else.8812:
	lw %a0 %sp 32 #2025
	lw %a2 %sp 28 #2025
	lw %a3 %sp 8 #2025
	lw %a4 %sp 20 #2025
	lw %a5 %sp 24 #2025
	lw %a11 %sp 12 #2025
	add %a10 %a5 %zero
	add %a5 %a1 %zero
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	add %a3 %a4 %zero
	add %a4 %a10 %zero
	sw %ra %sp 44 #2025 call cls
	lw %a10 %a11 0 #2025
	addi %sp %sp 48 #2025	
	jalr %ra %a10 0 #2025
	addi %sp %sp -48 #2025
	lw %ra %sp 44 #2025
beq_cont.8813:
	lw %a11 %sp 4 #2030
	sw %ra %sp 44 #2030 call cls
	lw %a10 %a11 0 #2030
	addi %sp %sp 48 #2030	
	jalr %ra %a10 0 #2030
	addi %sp %sp -48 #2030
	lw %ra %sp 44 #2030
	lw %a0 %sp 32 #2032
	addi %a0 %a0 1 #2032
	lw %a1 %sp 28 #2032
	lw %a2 %sp 8 #2032
	lw %a3 %sp 20 #2032
	lw %a4 %sp 24 #2032
	lw %a11 %sp 0 #2032
	lw %a10 %a11 0 #2032
	jalr %zero %a10 0 #2032
scan_line.2650:
	lw %a5 %a11 12 #2037
	lw %a6 %a11 8 #2037
	lw %a7 %a11 4 #2037
	lw %a8 %a7 4 #57
	blt %a0 %a8 bge_else.8814
	jalr %zero %ra 0 #2046
bge_else.8814:
	lw %a7 %a7 4 #57
	addi %a7 %a7 -1 #2041
	sw %a11 %sp 0 #2041
	sw %a4 %sp 4 #2041
	sw %a3 %sp 8 #2041
	sw %a2 %sp 12 #2041
	sw %a1 %sp 16 #2041
	sw %a0 %sp 20 #2041
	sw %a5 %sp 24 #2041
	blt %a0 %a7 bge_else.8816 # nontail if
	jal %zero bge_cont.8817 # then sentence ends
bge_else.8816:
	addi %a7 %a0 1 #2042
	add %a2 %a4 %zero
	add %a1 %a7 %zero
	add %a0 %a3 %zero
	add %a11 %a6 %zero
	sw %ra %sp 28 #2042 call cls
	lw %a10 %a11 0 #2042
	addi %sp %sp 32 #2042	
	jalr %ra %a10 0 #2042
	addi %sp %sp -32 #2042
	lw %ra %sp 28 #2042
bge_cont.8817:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 20 #2044
	lw %a2 %sp 16 #2044
	lw %a3 %sp 12 #2044
	lw %a4 %sp 8 #2044
	lw %a11 %sp 24 #2044
	sw %ra %sp 28 #2044 call cls
	lw %a10 %a11 0 #2044
	addi %sp %sp 32 #2044	
	jalr %ra %a10 0 #2044
	addi %sp %sp -32 #2044
	lw %ra %sp 28 #2044
	lw %a0 %sp 20 #2045
	addi %a0 %a0 1 #2045
	addi %a1 %zero 2 #2045
	lw %a2 %sp 4 #2045
	sw %a0 %sp 28 #2045
	add %a0 %a2 %zero
	sw %ra %sp 36 #2045 call dir
	addi %sp %sp 40 #2045	
	jal %ra add_mod5.2240 #2045
	addi %sp %sp -40 #2045
	lw %ra %sp 36 #2045
	add %a4 %a0 %zero #2045
	lw %a0 %sp 28 #2045
	lw %a1 %sp 12 #2045
	lw %a2 %sp 8 #2045
	lw %a3 %sp 16 #2045
	lw %a11 %sp 0 #2045
	lw %a10 %a11 0 #2045
	jalr %zero %a10 0 #2045
create_float5x3array.2656:
	addi %a0 %zero 3 #2054
	li %f0 l.5551 #2054
	sw %ra %sp 4 #2054 call dir
	addi %sp %sp 8 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -8 #2054
	lw %ra %sp 4 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 4 #2055 call dir
	addi %sp %sp 8 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -8 #2055
	lw %ra %sp 4 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.5551 #2056
	sw %a0 %sp 0 #2056
	add %a0 %a1 %zero
	sw %ra %sp 4 #2056 call dir
	addi %sp %sp 8 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -8 #2056
	lw %ra %sp 4 #2056
	lw %a1 %sp 0 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.5551 #2057
	sw %ra %sp 4 #2057 call dir
	addi %sp %sp 8 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -8 #2057
	lw %ra %sp 4 #2057
	lw %a1 %sp 0 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.5551 #2058
	sw %ra %sp 4 #2058 call dir
	addi %sp %sp 8 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -8 #2058
	lw %ra %sp 4 #2058
	lw %a1 %sp 0 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.5551 #2059
	sw %ra %sp 4 #2059 call dir
	addi %sp %sp 8 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -8 #2059
	lw %ra %sp 4 #2059
	lw %a1 %sp 0 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %a1 0 #2060
	jalr %zero %ra 0 #2060
create_pixel.2658:
	addi %a0 %zero 3 #2066
	li %f0 l.5551 #2066
	sw %ra %sp 4 #2066 call dir
	addi %sp %sp 8 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -8 #2066
	lw %ra %sp 4 #2066
	sw %a0 %sp 0 #2067
	sw %ra %sp 4 #2067 call dir
	addi %sp %sp 8 #2067	
	jal %ra create_float5x3array.2656 #2067
	addi %sp %sp -8 #2067
	lw %ra %sp 4 #2067
	addi %a1 %zero 5 #2068
	addi %a2 %zero 0 #2068
	sw %a0 %sp 4 #2068
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 12 #2068 call dir
	addi %sp %sp 16 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -16 #2068
	lw %ra %sp 12 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 8 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 12 #2069 call dir
	addi %sp %sp 16 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -16 #2069
	lw %ra %sp 12 #2069
	sw %a0 %sp 12 #2070
	sw %ra %sp 20 #2070 call dir
	addi %sp %sp 24 #2070	
	jal %ra create_float5x3array.2656 #2070
	addi %sp %sp -24 #2070
	lw %ra %sp 20 #2070
	sw %a0 %sp 16 #2071
	sw %ra %sp 20 #2071 call dir
	addi %sp %sp 24 #2071	
	jal %ra create_float5x3array.2656 #2071
	addi %sp %sp -24 #2071
	lw %ra %sp 20 #2071
	addi %a1 %zero 1 #2072
	addi %a2 %zero 0 #2072
	sw %a0 %sp 20 #2072
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 28 #2072 call dir
	addi %sp %sp 32 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -32 #2072
	lw %ra %sp 28 #2072
	sw %a0 %sp 24 #2073
	sw %ra %sp 28 #2073 call dir
	addi %sp %sp 32 #2073	
	jal %ra create_float5x3array.2656 #2073
	addi %sp %sp -32 #2073
	lw %ra %sp 28 #2073
	addi %a1 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a0 %a1 28 #2074
	lw %a0 %sp 24 #2074
	sw %a0 %a1 24 #2074
	lw %a0 %sp 20 #2074
	sw %a0 %a1 20 #2074
	lw %a0 %sp 16 #2074
	sw %a0 %a1 16 #2074
	lw %a0 %sp 12 #2074
	sw %a0 %a1 12 #2074
	lw %a0 %sp 8 #2074
	sw %a0 %a1 8 #2074
	lw %a0 %sp 4 #2074
	sw %a0 %a1 4 #2074
	lw %a0 %sp 0 #2074
	sw %a0 %a1 0 #2074
	addi %a0 %a1 0 #2074
	jalr %zero %ra 0 #2074
init_line_elements.2660:
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8818
	sw %a0 %sp 0 #2080
	sw %a1 %sp 4 #2080
	sw %ra %sp 12 #2080 call dir
	addi %sp %sp 16 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -16 #2080
	lw %ra %sp 12 #2080
	lw %a1 %sp 4 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 0 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	jal	%zero init_line_elements.2660
bge_else.8818:
	jalr %zero %ra 0 #2083
create_pixelline.2663:
	lw %a0 %a11 4 #2087
	lw %a1 %a0 0 #57
	sw %a0 %sp 0 #2088
	sw %a1 %sp 4 #2088
	sw %ra %sp 12 #2088 call dir
	addi %sp %sp 16 #2088	
	jal %ra create_pixel.2658 #2088
	addi %sp %sp -16 #2088
	lw %ra %sp 12 #2088
	add %a1 %a0 %zero #2088
	lw %a0 %sp 4 #2088
	sw %ra %sp 12 #2088 call dir
	addi %sp %sp 16 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -16 #2088
	lw %ra %sp 12 #2088
	lw %a1 %sp 0 #57
	lw %a1 %a1 0 #57
	addi %a1 %a1 -2 #2089
	jal	%zero init_line_elements.2660
tan.2665:
	sw %f0 %sp 0 #2097
	sw %ra %sp 12 #2097 call dir
	addi %sp %sp 16 #2097	
	jal %ra min_caml_sin #2097
	addi %sp %sp -16 #2097
	lw %ra %sp 12 #2097
	lw %f1 %sp 0 #2097
	sw %f0 %sp 8 #2097
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #2097 call dir
	addi %sp %sp 24 #2097	
	jal %ra min_caml_cos #2097
	addi %sp %sp -24 #2097
	lw %ra %sp 20 #2097
	lw %f1 %sp 8 #2097
	fdiv %f0 %f1 %f0 #2097
	jalr %zero %ra 0 #2097
adjust_position.2667:
	fmul %f0 %f0 %f0 #2102
	li %f2 l.6110 #2102
	fadd %f0 %f0 %f2 #2102
	sw %f1 %sp 0 #2102
	sw %ra %sp 12 #2102 call dir
	addi %sp %sp 16 #2102	
	jal %ra min_caml_sqrt #2102
	addi %sp %sp -16 #2102
	lw %ra %sp 12 #2102
	li %f1 l.5553 #2103
	fdiv %f1 %f1 %f0 #2103
	sw %f0 %sp 8 #2104
	fadd %f0 %f1 %fzero
	sw %ra %sp 20 #2104 call dir
	addi %sp %sp 24 #2104	
	jal %ra min_caml_atan #2104
	addi %sp %sp -24 #2104
	lw %ra %sp 20 #2104
	lw %f1 %sp 0 #2105
	fmul %f0 %f0 %f1 #2105
	sw %ra %sp 20 #2105 call dir
	addi %sp %sp 24 #2105	
	jal %ra tan.2665 #2105
	addi %sp %sp -24 #2105
	lw %ra %sp 20 #2105
	lw %f1 %sp 8 #2106
	fmul %f0 %f0 %f1 #2106
	jalr %zero %ra 0 #2106
calc_dirvec.2670:
	lw %a3 %a11 4 #2110
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.8819
	sw %a2 %sp 0 #2112
	sw %a3 %sp 4 #2112
	sw %a1 %sp 8 #2112
	sw %f0 %sp 16 #2112
	sw %f1 %sp 24 #2112
	sw %ra %sp 36 #2112 call dir
	addi %sp %sp 40 #2112	
	jal %ra min_caml_fsqr #2112
	addi %sp %sp -40 #2112
	lw %ra %sp 36 #2112
	lw %f1 %sp 24 #2112
	sw %f0 %sp 32 #2112
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #2112 call dir
	addi %sp %sp 48 #2112	
	jal %ra min_caml_fsqr #2112
	addi %sp %sp -48 #2112
	lw %ra %sp 44 #2112
	lw %f1 %sp 32 #2112
	fadd %f0 %f1 %f0 #2112
	li %f1 l.5553 #2112
	fadd %f0 %f0 %f1 #2112
	sw %ra %sp 44 #2112 call dir
	addi %sp %sp 48 #2112	
	jal %ra min_caml_sqrt #2112
	addi %sp %sp -48 #2112
	lw %ra %sp 44 #2112
	lw %f1 %sp 16 #2113
	fdiv %f1 %f1 %f0 #2113
	lw %f2 %sp 24 #2114
	fdiv %f2 %f2 %f0 #2114
	li %f3 l.5553 #2115
	fdiv %f0 %f3 %f0 #2115
	lw %a0 %sp 8 #81
	slli %a0 %a0 2 #81
	lw %a1 %sp 4 #81
	add %a12 %a1 %a0 #81
	lw %a0 %a12 0 #81
	lw %a1 %sp 0 #80
	slli %a2 %a1 2 #80
	add %a12 %a0 %a2 #80
	lw %a2 %a12 0 #80
	sw %a0 %sp 40 #2119
	sw %f0 %sp 48 #2119
	sw %f2 %sp 56 #2119
	sw %f1 %sp 64 #2119
	add %a0 %a2 %zero
	sw %ra %sp 76 #2119 call dir
	addi %sp %sp 80 #2119	
	jal %ra d_vec.2350 #2119
	addi %sp %sp -80 #2119
	lw %ra %sp 76 #2119
	lw %f0 %sp 64 #2119
	lw %f1 %sp 56 #2119
	lw %f2 %sp 48 #2119
	sw %ra %sp 76 #2119 call dir
	addi %sp %sp 80 #2119	
	jal %ra vecset.2243 #2119
	addi %sp %sp -80 #2119
	lw %ra %sp 76 #2119
	lw %a0 %sp 0 #2120
	addi %a1 %a0 40 #2120
	slli %a1 %a1 2 #80
	lw %a2 %sp 40 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	add %a0 %a1 %zero
	sw %ra %sp 76 #2120 call dir
	addi %sp %sp 80 #2120	
	jal %ra d_vec.2350 #2120
	addi %sp %sp -80 #2120
	lw %ra %sp 76 #2120
	lw %f0 %sp 56 #2120
	sw %a0 %sp 72 #2120
	sw %ra %sp 76 #2120 call dir
	addi %sp %sp 80 #2120	
	jal %ra min_caml_fneg #2120
	addi %sp %sp -80 #2120
	lw %ra %sp 76 #2120
	fadd %f2 %f0 %fzero #2120
	lw %f0 %sp 64 #2120
	lw %f1 %sp 48 #2120
	lw %a0 %sp 72 #2120
	sw %ra %sp 76 #2120 call dir
	addi %sp %sp 80 #2120	
	jal %ra vecset.2243 #2120
	addi %sp %sp -80 #2120
	lw %ra %sp 76 #2120
	lw %a0 %sp 0 #2121
	addi %a1 %a0 80 #2121
	slli %a1 %a1 2 #80
	lw %a2 %sp 40 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	add %a0 %a1 %zero
	sw %ra %sp 76 #2121 call dir
	addi %sp %sp 80 #2121	
	jal %ra d_vec.2350 #2121
	addi %sp %sp -80 #2121
	lw %ra %sp 76 #2121
	lw %f0 %sp 64 #2121
	sw %a0 %sp 76 #2121
	sw %ra %sp 84 #2121 call dir
	addi %sp %sp 88 #2121	
	jal %ra min_caml_fneg #2121
	addi %sp %sp -88 #2121
	lw %ra %sp 84 #2121
	lw %f1 %sp 56 #2121
	sw %f0 %sp 80 #2121
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #2121 call dir
	addi %sp %sp 96 #2121	
	jal %ra min_caml_fneg #2121
	addi %sp %sp -96 #2121
	lw %ra %sp 92 #2121
	fadd %f2 %f0 %fzero #2121
	lw %f0 %sp 48 #2121
	lw %f1 %sp 80 #2121
	lw %a0 %sp 76 #2121
	sw %ra %sp 92 #2121 call dir
	addi %sp %sp 96 #2121	
	jal %ra vecset.2243 #2121
	addi %sp %sp -96 #2121
	lw %ra %sp 92 #2121
	lw %a0 %sp 0 #2122
	addi %a1 %a0 1 #2122
	slli %a1 %a1 2 #80
	lw %a2 %sp 40 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	add %a0 %a1 %zero
	sw %ra %sp 92 #2122 call dir
	addi %sp %sp 96 #2122	
	jal %ra d_vec.2350 #2122
	addi %sp %sp -96 #2122
	lw %ra %sp 92 #2122
	lw %f0 %sp 64 #2122
	sw %a0 %sp 88 #2122
	sw %ra %sp 92 #2122 call dir
	addi %sp %sp 96 #2122	
	jal %ra min_caml_fneg #2122
	addi %sp %sp -96 #2122
	lw %ra %sp 92 #2122
	lw %f1 %sp 56 #2122
	sw %f0 %sp 96 #2122
	fadd %f0 %f1 %fzero
	sw %ra %sp 108 #2122 call dir
	addi %sp %sp 112 #2122	
	jal %ra min_caml_fneg #2122
	addi %sp %sp -112 #2122
	lw %ra %sp 108 #2122
	lw %f1 %sp 48 #2122
	sw %f0 %sp 104 #2122
	fadd %f0 %f1 %fzero
	sw %ra %sp 116 #2122 call dir
	addi %sp %sp 120 #2122	
	jal %ra min_caml_fneg #2122
	addi %sp %sp -120 #2122
	lw %ra %sp 116 #2122
	fadd %f2 %f0 %fzero #2122
	lw %f0 %sp 96 #2122
	lw %f1 %sp 104 #2122
	lw %a0 %sp 88 #2122
	sw %ra %sp 116 #2122 call dir
	addi %sp %sp 120 #2122	
	jal %ra vecset.2243 #2122
	addi %sp %sp -120 #2122
	lw %ra %sp 116 #2122
	lw %a0 %sp 0 #2123
	addi %a1 %a0 41 #2123
	slli %a1 %a1 2 #80
	lw %a2 %sp 40 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	add %a0 %a1 %zero
	sw %ra %sp 116 #2123 call dir
	addi %sp %sp 120 #2123	
	jal %ra d_vec.2350 #2123
	addi %sp %sp -120 #2123
	lw %ra %sp 116 #2123
	lw %f0 %sp 64 #2123
	sw %a0 %sp 112 #2123
	sw %ra %sp 116 #2123 call dir
	addi %sp %sp 120 #2123	
	jal %ra min_caml_fneg #2123
	addi %sp %sp -120 #2123
	lw %ra %sp 116 #2123
	lw %f1 %sp 48 #2123
	sw %f0 %sp 120 #2123
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #2123 call dir
	addi %sp %sp 136 #2123	
	jal %ra min_caml_fneg #2123
	addi %sp %sp -136 #2123
	lw %ra %sp 132 #2123
	fadd %f1 %f0 %fzero #2123
	lw %f0 %sp 120 #2123
	lw %f2 %sp 56 #2123
	lw %a0 %sp 112 #2123
	sw %ra %sp 132 #2123 call dir
	addi %sp %sp 136 #2123	
	jal %ra vecset.2243 #2123
	addi %sp %sp -136 #2123
	lw %ra %sp 132 #2123
	lw %a0 %sp 0 #2124
	addi %a0 %a0 81 #2124
	slli %a0 %a0 2 #80
	lw %a1 %sp 40 #80
	add %a12 %a1 %a0 #80
	lw %a0 %a12 0 #80
	sw %ra %sp 132 #2124 call dir
	addi %sp %sp 136 #2124	
	jal %ra d_vec.2350 #2124
	addi %sp %sp -136 #2124
	lw %ra %sp 132 #2124
	lw %f0 %sp 48 #2124
	sw %a0 %sp 128 #2124
	sw %ra %sp 132 #2124 call dir
	addi %sp %sp 136 #2124	
	jal %ra min_caml_fneg #2124
	addi %sp %sp -136 #2124
	lw %ra %sp 132 #2124
	lw %f1 %sp 64 #2124
	lw %f2 %sp 56 #2124
	lw %a0 %sp 128 #2124
	jal	%zero vecset.2243
bge_else.8819:
	sw %f2 %sp 136 #2126
	sw %a2 %sp 0 #2126
	sw %a1 %sp 8 #2126
	sw %a11 %sp 144 #2126
	sw %f3 %sp 152 #2126
	sw %a0 %sp 160 #2126
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	sw %ra %sp 164 #2126 call dir
	addi %sp %sp 168 #2126	
	jal %ra adjust_position.2667 #2126
	addi %sp %sp -168 #2126
	lw %ra %sp 164 #2126
	lw %a0 %sp 160 #2127
	addi %a0 %a0 1 #2127
	lw %f1 %sp 152 #2127
	sw %f0 %sp 168 #2127
	sw %a0 %sp 176 #2127
	sw %ra %sp 180 #2127 call dir
	addi %sp %sp 184 #2127	
	jal %ra adjust_position.2667 #2127
	addi %sp %sp -184 #2127
	lw %ra %sp 180 #2127
	fadd %f1 %f0 %fzero #2127
	lw %f0 %sp 168 #2127
	lw %f2 %sp 136 #2127
	lw %f3 %sp 152 #2127
	lw %a0 %sp 176 #2127
	lw %a1 %sp 8 #2127
	lw %a2 %sp 0 #2127
	lw %a11 %sp 144 #2127
	lw %a10 %a11 0 #2127
	jalr %zero %a10 0 #2127
calc_dirvecs.2678:
	lw %a3 %a11 4 #2131
	addi %a4 %zero 0 #2132
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8827
	sw %a11 %sp 0 #2134
	sw %a0 %sp 4 #2134
	sw %f0 %sp 8 #2134
	sw %a2 %sp 16 #2134
	sw %a1 %sp 20 #2134
	sw %a4 %sp 24 #2134
	sw %a3 %sp 28 #2134
	sw %ra %sp 36 #2134 call dir
	addi %sp %sp 40 #2134	
	jal %ra min_caml_float_of_int #2134
	addi %sp %sp -40 #2134
	lw %ra %sp 36 #2134
	li %f1 l.6238 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.6240 #2134
	fsub %f2 %f0 %f1 #2134
	li %f0 l.5551 #2135
	li %f1 l.5551 #2135
	lw %f3 %sp 8 #2135
	lw %a0 %sp 24 #2135
	lw %a1 %sp 20 #2135
	lw %a2 %sp 16 #2135
	lw %a11 %sp 28 #2135
	sw %ra %sp 36 #2135 call cls
	lw %a10 %a11 0 #2135
	addi %sp %sp 40 #2135	
	jalr %ra %a10 0 #2135
	addi %sp %sp -40 #2135
	lw %ra %sp 36 #2135
	lw %a0 %sp 4 #2137
	sw %ra %sp 36 #2137 call dir
	addi %sp %sp 40 #2137	
	jal %ra min_caml_float_of_int #2137
	addi %sp %sp -40 #2137
	lw %ra %sp 36 #2137
	li %f1 l.6238 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.6110 #2137
	fadd %f2 %f0 %f1 #2137
	li %f0 l.5551 #2138
	li %f1 l.5551 #2138
	lw %a0 %sp 16 #2138
	addi %a2 %a0 2 #2138
	lw %f3 %sp 8 #2138
	lw %a1 %sp 24 #2138
	lw %a3 %sp 20 #2138
	lw %a11 %sp 28 #2138
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 36 #2138 call cls
	lw %a10 %a11 0 #2138
	addi %sp %sp 40 #2138	
	jalr %ra %a10 0 #2138
	addi %sp %sp -40 #2138
	lw %ra %sp 36 #2138
	lw %a0 %sp 4 #2140
	addi %a0 %a0 -1 #2140
	addi %a1 %zero 1 #2140
	lw %a2 %sp 20 #2140
	sw %a0 %sp 32 #2140
	add %a0 %a2 %zero
	sw %ra %sp 36 #2140 call dir
	addi %sp %sp 40 #2140	
	jal %ra add_mod5.2240 #2140
	addi %sp %sp -40 #2140
	lw %ra %sp 36 #2140
	add %a1 %a0 %zero #2140
	lw %f0 %sp 8 #2140
	lw %a0 %sp 32 #2140
	lw %a2 %sp 16 #2140
	lw %a11 %sp 0 #2140
	lw %a10 %a11 0 #2140
	jalr %zero %a10 0 #2140
bge_else.8827:
	jalr %zero %ra 0 #2141
calc_dirvec_rows.2683:
	lw %a3 %a11 4 #2145
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8829
	sw %a11 %sp 0 #2147
	sw %a0 %sp 4 #2147
	sw %a2 %sp 8 #2147
	sw %a1 %sp 12 #2147
	sw %a3 %sp 16 #2147
	sw %ra %sp 20 #2147 call dir
	addi %sp %sp 24 #2147	
	jal %ra min_caml_float_of_int #2147
	addi %sp %sp -24 #2147
	lw %ra %sp 20 #2147
	li %f1 l.6238 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.6240 #2147
	fsub %f0 %f0 %f1 #2147
	addi %a0 %zero 4 #2148
	lw %a1 %sp 12 #2148
	lw %a2 %sp 8 #2148
	lw %a11 %sp 16 #2148
	sw %ra %sp 20 #2148 call cls
	lw %a10 %a11 0 #2148
	addi %sp %sp 24 #2148	
	jalr %ra %a10 0 #2148
	addi %sp %sp -24 #2148
	lw %ra %sp 20 #2148
	lw %a0 %sp 4 #2149
	addi %a0 %a0 -1 #2149
	addi %a1 %zero 2 #2149
	lw %a2 %sp 12 #2149
	sw %a0 %sp 20 #2149
	add %a0 %a2 %zero
	sw %ra %sp 28 #2149 call dir
	addi %sp %sp 32 #2149	
	jal %ra add_mod5.2240 #2149
	addi %sp %sp -32 #2149
	lw %ra %sp 28 #2149
	add %a1 %a0 %zero #2149
	lw %a0 %sp 8 #2149
	addi %a2 %a0 4 #2149
	lw %a0 %sp 20 #2149
	lw %a11 %sp 0 #2149
	lw %a10 %a11 0 #2149
	jalr %zero %a10 0 #2149
bge_else.8829:
	jalr %zero %ra 0 #2150
create_dirvec.2687:
	lw %a0 %a11 4 #2156
	addi %a1 %zero 3 #2157
	li %f0 l.5551 #2157
	sw %a0 %sp 0 #2157
	add %a0 %a1 %zero
	sw %ra %sp 4 #2157 call dir
	addi %sp %sp 8 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -8 #2157
	lw %ra %sp 4 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 0 #15
	lw %a0 %a0 0 #15
	sw %a1 %sp 4 #2158
	sw %ra %sp 12 #2158 call dir
	addi %sp %sp 16 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -16 #2158
	lw %ra %sp 12 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 4 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	jalr %zero %ra 0 #2159
create_dirvec_elements.2689:
	lw %a2 %a11 4 #2162
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8831
	sw %a11 %sp 0 #2164
	sw %a0 %sp 4 #2164
	sw %a1 %sp 8 #2164
	add %a11 %a2 %zero
	sw %ra %sp 12 #2164 call cls
	lw %a10 %a11 0 #2164
	addi %sp %sp 16 #2164	
	jalr %ra %a10 0 #2164
	addi %sp %sp -16 #2164
	lw %ra %sp 12 #2164
	lw %a1 %sp 8 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a1 %a1 -1 #2165
	lw %a11 %sp 0 #2165
	add %a0 %a3 %zero
	lw %a10 %a11 0 #2165
	jalr %zero %a10 0 #2165
bge_else.8831:
	jalr %zero %ra 0 #2166
create_dirvecs.2692:
	lw %a1 %a11 12 #2169
	lw %a2 %a11 8 #2169
	lw %a3 %a11 4 #2169
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8833
	addi %a4 %zero 120 #2171
	sw %a11 %sp 0 #2171
	sw %a2 %sp 4 #2171
	sw %a1 %sp 8 #2171
	sw %a0 %sp 12 #2171
	sw %a4 %sp 16 #2171
	add %a11 %a3 %zero
	sw %ra %sp 20 #2171 call cls
	lw %a10 %a11 0 #2171
	addi %sp %sp 24 #2171	
	jalr %ra %a10 0 #2171
	addi %sp %sp -24 #2171
	lw %ra %sp 20 #2171
	add %a1 %a0 %zero #2171
	lw %a0 %sp 16 #2171
	sw %ra %sp 20 #2171 call dir
	addi %sp %sp 24 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -24 #2171
	lw %ra %sp 20 #2171
	lw %a1 %sp 12 #2171
	slli %a2 %a1 2 #2171
	lw %a3 %sp 8 #2171
	add %a12 %a3 %a2 #2171
	sw %a0 %a12 0 #2171
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	addi %a2 %zero 118 #2172
	lw %a11 %sp 4 #2172
	add %a1 %a2 %zero
	sw %ra %sp 20 #2172 call cls
	lw %a10 %a11 0 #2172
	addi %sp %sp 24 #2172	
	jalr %ra %a10 0 #2172
	addi %sp %sp -24 #2172
	lw %ra %sp 20 #2172
	lw %a0 %sp 12 #2173
	addi %a0 %a0 -1 #2173
	lw %a11 %sp 0 #2173
	lw %a10 %a11 0 #2173
	jalr %zero %a10 0 #2173
bge_else.8833:
	jalr %zero %ra 0 #2174
init_dirvec_constants.2694:
	lw %a2 %a11 4 #2179
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.8835
	slli %a3 %a1 2 #2181
	add %a12 %a0 %a3 #2181
	lw %a3 %a12 0 #2181
	sw %a0 %sp 0 #2181
	sw %a11 %sp 4 #2181
	sw %a1 %sp 8 #2181
	add %a0 %a3 %zero
	add %a11 %a2 %zero
	sw %ra %sp 12 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 16 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -16 #2181
	lw %ra %sp 12 #2181
	lw %a0 %sp 8 #2182
	addi %a1 %a0 -1 #2182
	lw %a0 %sp 0 #2182
	lw %a11 %sp 4 #2182
	lw %a10 %a11 0 #2182
	jalr %zero %a10 0 #2182
bge_else.8835:
	jalr %zero %ra 0 #2183
init_vecset_constants.2697:
	lw %a1 %a11 8 #2186
	lw %a2 %a11 4 #2186
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8837
	slli %a3 %a0 2 #81
	add %a12 %a2 %a3 #81
	lw %a2 %a12 0 #81
	addi %a3 %zero 119 #2188
	sw %a11 %sp 0 #2188
	sw %a0 %sp 4 #2188
	add %a0 %a2 %zero
	add %a11 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 12 #2188 call cls
	lw %a10 %a11 0 #2188
	addi %sp %sp 16 #2188	
	jalr %ra %a10 0 #2188
	addi %sp %sp -16 #2188
	lw %ra %sp 12 #2188
	lw %a0 %sp 4 #2189
	addi %a0 %a0 -1 #2189
	lw %a11 %sp 0 #2189
	lw %a10 %a11 0 #2189
	jalr %zero %a10 0 #2189
bge_else.8837:
	jalr %zero %ra 0 #2190
init_dirvecs.2699:
	lw %a0 %a11 12 #2193
	lw %a1 %a11 8 #2193
	lw %a2 %a11 4 #2193
	addi %a3 %zero 4 #2194
	sw %a0 %sp 0 #2194
	sw %a2 %sp 4 #2194
	add %a0 %a3 %zero
	add %a11 %a1 %zero
	sw %ra %sp 12 #2194 call cls
	lw %a10 %a11 0 #2194
	addi %sp %sp 16 #2194	
	jalr %ra %a10 0 #2194
	addi %sp %sp -16 #2194
	lw %ra %sp 12 #2194
	addi %a0 %zero 9 #2195
	addi %a1 %zero 0 #2195
	addi %a2 %zero 0 #2195
	lw %a11 %sp 4 #2195
	sw %ra %sp 12 #2195 call cls
	lw %a10 %a11 0 #2195
	addi %sp %sp 16 #2195	
	jalr %ra %a10 0 #2195
	addi %sp %sp -16 #2195
	lw %ra %sp 12 #2195
	addi %a0 %zero 4 #2196
	lw %a11 %sp 0 #2196
	lw %a10 %a11 0 #2196
	jalr %zero %a10 0 #2196
add_reflection.2701:
	lw %a2 %a11 12 #2202
	lw %a3 %a11 8 #2202
	lw %a11 %a11 4 #2202
	sw %a3 %sp 0 #2203
	sw %a0 %sp 4 #2203
	sw %a1 %sp 8 #2203
	sw %f0 %sp 16 #2203
	sw %a2 %sp 24 #2203
	sw %f3 %sp 32 #2203
	sw %f2 %sp 40 #2203
	sw %f1 %sp 48 #2203
	sw %ra %sp 60 #2203 call cls
	lw %a10 %a11 0 #2203
	addi %sp %sp 64 #2203	
	jalr %ra %a10 0 #2203
	addi %sp %sp -64 #2203
	lw %ra %sp 60 #2203
	sw %a0 %sp 56 #2204
	sw %ra %sp 60 #2204 call dir
	addi %sp %sp 64 #2204	
	jal %ra d_vec.2350 #2204
	addi %sp %sp -64 #2204
	lw %ra %sp 60 #2204
	lw %f0 %sp 48 #2204
	lw %f1 %sp 40 #2204
	lw %f2 %sp 32 #2204
	sw %ra %sp 60 #2204 call dir
	addi %sp %sp 64 #2204	
	jal %ra vecset.2243 #2204
	addi %sp %sp -64 #2204
	lw %ra %sp 60 #2204
	lw %a0 %sp 56 #2205
	lw %a11 %sp 24 #2205
	sw %ra %sp 60 #2205 call cls
	lw %a10 %a11 0 #2205
	addi %sp %sp 64 #2205	
	jalr %ra %a10 0 #2205
	addi %sp %sp -64 #2205
	lw %ra %sp 60 #2205
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 16 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 56 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 8 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 4 #2207
	slli %a1 %a1 2 #2207
	lw %a2 %sp 0 #2207
	add %a12 %a2 %a1 #2207
	sw %a0 %a12 0 #2207
	jalr %zero %ra 0 #2207
setup_rect_reflection.2708:
	lw %a2 %a11 12 #2211
	lw %a3 %a11 8 #2211
	lw %a4 %a11 4 #2211
	addi %a5 %zero 4 #2212
	sw %a4 %sp 0 #2212
	sw %a3 %sp 4 #2212
	sw %a1 %sp 8 #2212
	sw %a2 %sp 12 #2212
	add %a1 %a5 %zero
	sw %ra %sp 20 #2212 call dir
	addi %sp %sp 24 #2212	
	jal %ra min_caml_sll #2212
	addi %sp %sp -24 #2212
	lw %ra %sp 20 #2212
	lw %a1 %sp 12 #99
	lw %a2 %a1 0 #99
	li %f0 l.5553 #2214
	lw %a3 %sp 8 #2214
	sw %a2 %sp 16 #2214
	sw %a0 %sp 20 #2214
	sw %f0 %sp 24 #2214
	add %a0 %a3 %zero
	sw %ra %sp 36 #2214 call dir
	addi %sp %sp 40 #2214	
	jal %ra o_diffuse.2313 #2214
	addi %sp %sp -40 #2214
	lw %ra %sp 36 #2214
	lw %f1 %sp 24 #2214
	fsub %f0 %f1 %f0 #2214
	lw %a0 %sp 4 #27
	lw %f1 %a0 0 #27
	sw %f0 %sp 32 #2215
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #2215 call dir
	addi %sp %sp 48 #2215	
	jal %ra min_caml_fneg #2215
	addi %sp %sp -48 #2215
	lw %ra %sp 44 #2215
	lw %a0 %sp 4 #27
	lw %f1 %a0 4 #27
	sw %f0 %sp 40 #2216
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #2216 call dir
	addi %sp %sp 56 #2216	
	jal %ra min_caml_fneg #2216
	addi %sp %sp -56 #2216
	lw %ra %sp 52 #2216
	lw %a0 %sp 4 #27
	lw %f1 %a0 8 #27
	sw %f0 %sp 48 #2217
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #2217 call dir
	addi %sp %sp 64 #2217	
	jal %ra min_caml_fneg #2217
	addi %sp %sp -64 #2217
	lw %ra %sp 60 #2217
	fadd %f3 %f0 %fzero #2217
	lw %a0 %sp 20 #2218
	addi %a1 %a0 1 #2218
	lw %a2 %sp 4 #27
	lw %f1 %a2 0 #27
	lw %f0 %sp 32 #2218
	lw %f2 %sp 48 #2218
	lw %a3 %sp 16 #2218
	lw %a11 %sp 0 #2218
	sw %f3 %sp 56 #2218
	add %a0 %a3 %zero
	sw %ra %sp 68 #2218 call cls
	lw %a10 %a11 0 #2218
	addi %sp %sp 72 #2218	
	jalr %ra %a10 0 #2218
	addi %sp %sp -72 #2218
	lw %ra %sp 68 #2218
	lw %a0 %sp 16 #2219
	addi %a1 %a0 1 #2219
	lw %a2 %sp 20 #2219
	addi %a3 %a2 2 #2219
	lw %a4 %sp 4 #27
	lw %f2 %a4 4 #27
	lw %f0 %sp 32 #2219
	lw %f1 %sp 40 #2219
	lw %f3 %sp 56 #2219
	lw %a11 %sp 0 #2219
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 68 #2219 call cls
	lw %a10 %a11 0 #2219
	addi %sp %sp 72 #2219	
	jalr %ra %a10 0 #2219
	addi %sp %sp -72 #2219
	lw %ra %sp 68 #2219
	lw %a0 %sp 16 #2220
	addi %a1 %a0 2 #2220
	lw %a2 %sp 20 #2220
	addi %a2 %a2 3 #2220
	lw %a3 %sp 4 #27
	lw %f3 %a3 8 #27
	lw %f0 %sp 32 #2220
	lw %f1 %sp 40 #2220
	lw %f2 %sp 48 #2220
	lw %a11 %sp 0 #2220
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 68 #2220 call cls
	lw %a10 %a11 0 #2220
	addi %sp %sp 72 #2220	
	jalr %ra %a10 0 #2220
	addi %sp %sp -72 #2220
	lw %ra %sp 68 #2220
	lw %a0 %sp 16 #2221
	addi %a0 %a0 3 #2221
	lw %a1 %sp 12 #2221
	sw %a0 %a1 0 #2221
	jalr %zero %ra 0 #2221
setup_surface_reflection.2711:
	lw %a2 %a11 12 #2225
	lw %a3 %a11 8 #2225
	lw %a4 %a11 4 #2225
	addi %a5 %zero 4 #2226
	sw %a4 %sp 0 #2226
	sw %a3 %sp 4 #2226
	sw %a1 %sp 8 #2226
	sw %a2 %sp 12 #2226
	add %a1 %a5 %zero
	sw %ra %sp 20 #2226 call dir
	addi %sp %sp 24 #2226	
	jal %ra min_caml_sll #2226
	addi %sp %sp -24 #2226
	lw %ra %sp 20 #2226
	addi %a0 %a0 1 #2226
	lw %a1 %sp 12 #99
	lw %a2 %a1 0 #99
	li %f0 l.5553 #2228
	lw %a3 %sp 8 #2228
	sw %a0 %sp 16 #2228
	sw %a2 %sp 20 #2228
	sw %f0 %sp 24 #2228
	add %a0 %a3 %zero
	sw %ra %sp 36 #2228 call dir
	addi %sp %sp 40 #2228	
	jal %ra o_diffuse.2313 #2228
	addi %sp %sp -40 #2228
	lw %ra %sp 36 #2228
	lw %f1 %sp 24 #2228
	fsub %f0 %f1 %f0 #2228
	lw %a0 %sp 8 #2229
	sw %f0 %sp 32 #2229
	sw %ra %sp 44 #2229 call dir
	addi %sp %sp 48 #2229	
	jal %ra o_param_abc.2305 #2229
	addi %sp %sp -48 #2229
	lw %ra %sp 44 #2229
	add %a1 %a0 %zero #2229
	lw %a0 %sp 4 #2229
	sw %ra %sp 44 #2229 call dir
	addi %sp %sp 48 #2229	
	jal %ra veciprod.2264 #2229
	addi %sp %sp -48 #2229
	lw %ra %sp 44 #2229
	li %f1 l.5713 #2232
	lw %a0 %sp 8 #2232
	sw %f0 %sp 40 #2232
	sw %f1 %sp 48 #2232
	sw %ra %sp 60 #2232 call dir
	addi %sp %sp 64 #2232	
	jal %ra o_param_a.2299 #2232
	addi %sp %sp -64 #2232
	lw %ra %sp 60 #2232
	lw %f1 %sp 48 #2232
	fmul %f0 %f1 %f0 #2232
	lw %f1 %sp 40 #2232
	fmul %f0 %f0 %f1 #2232
	lw %a0 %sp 4 #27
	lw %f2 %a0 0 #27
	fsub %f0 %f0 %f2 #2232
	li %f2 l.5713 #2233
	lw %a1 %sp 8 #2233
	sw %f0 %sp 56 #2233
	sw %f2 %sp 64 #2233
	add %a0 %a1 %zero
	sw %ra %sp 76 #2233 call dir
	addi %sp %sp 80 #2233	
	jal %ra o_param_b.2301 #2233
	addi %sp %sp -80 #2233
	lw %ra %sp 76 #2233
	lw %f1 %sp 64 #2233
	fmul %f0 %f1 %f0 #2233
	lw %f1 %sp 40 #2233
	fmul %f0 %f0 %f1 #2233
	lw %a0 %sp 4 #27
	lw %f2 %a0 4 #27
	fsub %f0 %f0 %f2 #2233
	li %f2 l.5713 #2234
	lw %a1 %sp 8 #2234
	sw %f0 %sp 72 #2234
	sw %f2 %sp 80 #2234
	add %a0 %a1 %zero
	sw %ra %sp 92 #2234 call dir
	addi %sp %sp 96 #2234	
	jal %ra o_param_c.2303 #2234
	addi %sp %sp -96 #2234
	lw %ra %sp 92 #2234
	lw %f1 %sp 80 #2234
	fmul %f0 %f1 %f0 #2234
	lw %f1 %sp 40 #2234
	fmul %f0 %f0 %f1 #2234
	lw %a0 %sp 4 #27
	lw %f1 %a0 8 #27
	fsub %f3 %f0 %f1 #2234
	lw %f0 %sp 32 #2231
	lw %f1 %sp 56 #2231
	lw %f2 %sp 72 #2231
	lw %a0 %sp 20 #2231
	lw %a1 %sp 16 #2231
	lw %a11 %sp 0 #2231
	sw %ra %sp 92 #2231 call cls
	lw %a10 %a11 0 #2231
	addi %sp %sp 96 #2231	
	jalr %ra %a10 0 #2231
	addi %sp %sp -96 #2231
	lw %ra %sp 92 #2231
	lw %a0 %sp 20 #2235
	addi %a0 %a0 1 #2235
	lw %a1 %sp 12 #2235
	sw %a0 %a1 0 #2235
	jalr %zero %ra 0 #2235
setup_reflections.2714:
	lw %a1 %a11 12 #2240
	lw %a2 %a11 8 #2240
	lw %a3 %a11 4 #2240
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.8844
	slli %a4 %a0 2 #20
	add %a12 %a3 %a4 #20
	lw %a3 %a12 0 #20
	sw %a1 %sp 0 #2243
	sw %a0 %sp 4 #2243
	sw %a2 %sp 8 #2243
	sw %a3 %sp 12 #2243
	add %a0 %a3 %zero
	sw %ra %sp 20 #2243 call dir
	addi %sp %sp 24 #2243	
	jal %ra o_reflectiontype.2293 #2243
	addi %sp %sp -24 #2243
	lw %ra %sp 20 #2243
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8845
	lw %a0 %sp 12 #2244
	sw %ra %sp 20 #2244 call dir
	addi %sp %sp 24 #2244	
	jal %ra o_diffuse.2313 #2244
	addi %sp %sp -24 #2244
	lw %ra %sp 20 #2244
	li %f1 l.5553 #2244
	sw %ra %sp 20 #2244 call dir
	addi %sp %sp 24 #2244	
	jal %ra min_caml_fless #2244
	addi %sp %sp -24 #2244
	lw %ra %sp 20 #2244
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.8846
	jalr %zero %ra 0 #2252
beq_else.8846:
	lw %a0 %sp 12 #2245
	sw %ra %sp 20 #2245 call dir
	addi %sp %sp 24 #2245	
	jal %ra o_form.2291 #2245
	addi %sp %sp -24 #2245
	lw %ra %sp 20 #2245
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.8848
	lw %a0 %sp 4 #2248
	lw %a1 %sp 12 #2248
	lw %a11 %sp 8 #2248
	lw %a10 %a11 0 #2248
	jalr %zero %a10 0 #2248
beq_else.8848:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.8849
	lw %a0 %sp 4 #2250
	lw %a1 %sp 12 #2250
	lw %a11 %sp 0 #2250
	lw %a10 %a11 0 #2250
	jalr %zero %a10 0 #2250
beq_else.8849:
	jalr %zero %ra 0 #2251
beq_else.8845:
	jalr %zero %ra 0 #2253
bge_else.8844:
	jalr %zero %ra 0 #2254
rt.2716:
	lw %a2 %a11 56 #2260
	lw %a3 %a11 52 #2260
	lw %a4 %a11 48 #2260
	lw %a5 %a11 44 #2260
	lw %a6 %a11 40 #2260
	lw %a7 %a11 36 #2260
	lw %a8 %a11 32 #2260
	lw %a9 %a11 28 #2260
	lw %a10 %a11 24 #2260
	sw %a6 %sp 0 #2260
	lw %a6 %a11 20 #2260
	sw %a8 %sp 4 #2260
	lw %a8 %a11 16 #2260
	sw %a3 %sp 8 #2260
	lw %a3 %a11 12 #2260
	sw %a9 %sp 12 #2260
	lw %a9 %a11 8 #2260
	lw %a11 %a11 4 #2260
	sw %a0 %a3 0 #2262
	sw %a1 %a3 4 #2263
	addi %a3 %zero 2 #2264
	sw %a4 %sp 16 #2264
	sw %a6 %sp 20 #2264
	sw %a10 %sp 24 #2264
	sw %a8 %sp 28 #2264
	sw %a2 %sp 32 #2264
	sw %a7 %sp 36 #2264
	sw %a11 %sp 40 #2264
	sw %a5 %sp 44 #2264
	sw %a0 %sp 48 #2264
	sw %a1 %sp 52 #2264
	sw %a9 %sp 56 #2264
	add %a1 %a3 %zero
	sw %ra %sp 60 #2264 call dir
	addi %sp %sp 64 #2264	
	jal %ra min_caml_srl #2264
	addi %sp %sp -64 #2264
	lw %ra %sp 60 #2264
	lw %a1 %sp 56 #2264
	sw %a0 %a1 0 #2264
	addi %a0 %zero 2 #2265
	lw %a2 %sp 52 #2265
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 60 #2265 call dir
	addi %sp %sp 64 #2265	
	jal %ra min_caml_srl #2265
	addi %sp %sp -64 #2265
	lw %ra %sp 60 #2265
	lw %a1 %sp 56 #2265
	sw %a0 %a1 4 #2265
	li %f0 l.6289 #2266
	lw %a0 %sp 48 #2266
	sw %f0 %sp 64 #2266
	sw %ra %sp 76 #2266 call dir
	addi %sp %sp 80 #2266	
	jal %ra min_caml_float_of_int #2266
	addi %sp %sp -80 #2266
	lw %ra %sp 76 #2266
	lw %f1 %sp 64 #2266
	fdiv %f0 %f1 %f0 #2266
	lw %a0 %sp 44 #2266
	sw %f0 %a0 0 #2266
	lw %a11 %sp 40 #2267
	sw %ra %sp 76 #2267 call cls
	lw %a10 %a11 0 #2267
	addi %sp %sp 80 #2267	
	jalr %ra %a10 0 #2267
	addi %sp %sp -80 #2267
	lw %ra %sp 76 #2267
	lw %a11 %sp 40 #2268
	sw %a0 %sp 72 #2268
	sw %ra %sp 76 #2268 call cls
	lw %a10 %a11 0 #2268
	addi %sp %sp 80 #2268	
	jalr %ra %a10 0 #2268
	addi %sp %sp -80 #2268
	lw %ra %sp 76 #2268
	lw %a11 %sp 40 #2269
	sw %a0 %sp 76 #2269
	sw %ra %sp 84 #2269 call cls
	lw %a10 %a11 0 #2269
	addi %sp %sp 88 #2269	
	jalr %ra %a10 0 #2269
	addi %sp %sp -88 #2269
	lw %ra %sp 84 #2269
	lw %a11 %sp 36 #2270
	sw %a0 %sp 80 #2270
	sw %ra %sp 84 #2270 call cls
	lw %a10 %a11 0 #2270
	addi %sp %sp 88 #2270	
	jalr %ra %a10 0 #2270
	addi %sp %sp -88 #2270
	lw %ra %sp 84 #2270
	lw %a11 %sp 32 #2271
	sw %ra %sp 84 #2271 call cls
	lw %a10 %a11 0 #2271
	addi %sp %sp 88 #2271	
	jalr %ra %a10 0 #2271
	addi %sp %sp -88 #2271
	lw %ra %sp 84 #2271
	lw %a11 %sp 28 #2272
	sw %ra %sp 84 #2272 call cls
	lw %a10 %a11 0 #2272
	addi %sp %sp 88 #2272	
	jalr %ra %a10 0 #2272
	addi %sp %sp -88 #2272
	lw %ra %sp 84 #2272
	lw %a0 %sp 24 #2273
	sw %ra %sp 84 #2273 call dir
	addi %sp %sp 88 #2273	
	jal %ra d_vec.2350 #2273
	addi %sp %sp -88 #2273
	lw %ra %sp 84 #2273
	lw %a1 %sp 20 #2273
	sw %ra %sp 84 #2273 call dir
	addi %sp %sp 88 #2273	
	jal %ra veccpy.2253 #2273
	addi %sp %sp -88 #2273
	lw %ra %sp 84 #2273
	lw %a0 %sp 24 #2274
	lw %a11 %sp 16 #2274
	sw %ra %sp 84 #2274 call cls
	lw %a10 %a11 0 #2274
	addi %sp %sp 88 #2274	
	jalr %ra %a10 0 #2274
	addi %sp %sp -88 #2274
	lw %ra %sp 84 #2274
	lw %a0 %sp 12 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #2275
	lw %a11 %sp 8 #2275
	sw %ra %sp 84 #2275 call cls
	lw %a10 %a11 0 #2275
	addi %sp %sp 88 #2275	
	jalr %ra %a10 0 #2275
	addi %sp %sp -88 #2275
	lw %ra %sp 84 #2275
	addi %a1 %zero 0 #2276
	addi %a2 %zero 0 #2276
	lw %a0 %sp 76 #2276
	lw %a11 %sp 4 #2276
	sw %ra %sp 84 #2276 call cls
	lw %a10 %a11 0 #2276
	addi %sp %sp 88 #2276	
	jalr %ra %a10 0 #2276
	addi %sp %sp -88 #2276
	lw %ra %sp 84 #2276
	addi %a0 %zero 0 #2277
	addi %a4 %zero 2 #2277
	lw %a1 %sp 72 #2277
	lw %a2 %sp 76 #2277
	lw %a3 %sp 80 #2277
	lw %a11 %sp 0 #2277
	lw %a10 %a11 0 #2277
	jalr %zero %a10 0 #2277
min_caml_start:
	li %sp 44000
	li %in 200000
	li %out 300000
	li %min_caml_hp 10000000
	addi %a0 %zero 1 #15
	addi %a1 %zero 0 #15
	sw %ra %sp 4 #15 call dir
	addi %sp %sp 8 #15	
	jal %ra min_caml_create_array #15
	addi %sp %sp -8 #15
	lw %ra %sp 4 #15
	addi %a1 %zero 0 #19
	li %f0 l.5551 #19
	sw %a0 %sp 0 #19
	add %a0 %a1 %zero
	sw %ra %sp 4 #19 call dir
	addi %sp %sp 8 #19	
	jal %ra min_caml_create_float_array #19
	addi %sp %sp -8 #19
	lw %ra %sp 4 #19
	addi %a1 %zero 60 #20
	addi %a2 %zero 0 #20
	addi %a3 %zero 0 #20
	addi %a4 %zero 0 #20
	addi %a5 %zero 0 #20
	addi %a6 %zero 0 #20
	addi %a7 %min_caml_hp 0 #20
	addi %min_caml_hp %min_caml_hp 48 #20
	sw %a0 %a7 40 #20
	sw %a0 %a7 36 #20
	sw %a0 %a7 32 #20
	sw %a0 %a7 28 #20
	sw %a6 %a7 24 #20
	sw %a0 %a7 20 #20
	sw %a0 %a7 16 #20
	sw %a5 %a7 12 #20
	sw %a4 %a7 8 #20
	sw %a3 %a7 4 #20
	sw %a2 %a7 0 #20
	addi %a0 %a7 0 #20
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 4 #20 call dir
	addi %sp %sp 8 #20	
	jal %ra min_caml_create_array #20
	addi %sp %sp -8 #20
	lw %ra %sp 4 #20
	addi %a1 %zero 3 #23
	li %f0 l.5551 #23
	sw %a0 %sp 4 #23
	add %a0 %a1 %zero
	sw %ra %sp 12 #23 call dir
	addi %sp %sp 16 #23	
	jal %ra min_caml_create_float_array #23
	addi %sp %sp -16 #23
	lw %ra %sp 12 #23
	addi %a1 %zero 3 #25
	li %f0 l.5551 #25
	sw %a0 %sp 8 #25
	add %a0 %a1 %zero
	sw %ra %sp 12 #25 call dir
	addi %sp %sp 16 #25	
	jal %ra min_caml_create_float_array #25
	addi %sp %sp -16 #25
	lw %ra %sp 12 #25
	addi %a1 %zero 3 #27
	li %f0 l.5551 #27
	sw %a0 %sp 12 #27
	add %a0 %a1 %zero
	sw %ra %sp 20 #27 call dir
	addi %sp %sp 24 #27	
	jal %ra min_caml_create_float_array #27
	addi %sp %sp -24 #27
	lw %ra %sp 20 #27
	addi %a1 %zero 1 #29
	li %f0 l.6044 #29
	sw %a0 %sp 16 #29
	add %a0 %a1 %zero
	sw %ra %sp 20 #29 call dir
	addi %sp %sp 24 #29	
	jal %ra min_caml_create_float_array #29
	addi %sp %sp -24 #29
	lw %ra %sp 20 #29
	addi %a1 %zero 50 #31
	addi %a2 %zero 1 #31
	sub %a3 %zero %a2 #31
	sw %a0 %sp 20 #31
	sw %a1 %sp 24 #31
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 28 #31 call dir
	addi %sp %sp 32 #31	
	jal %ra min_caml_create_array #31
	addi %sp %sp -32 #31
	lw %ra %sp 28 #31
	add %a1 %a0 %zero #31
	lw %a0 %sp 24 #31
	sw %ra %sp 28 #31 call dir
	addi %sp %sp 32 #31	
	jal %ra min_caml_create_array #31
	addi %sp %sp -32 #31
	lw %ra %sp 28 #31
	addi %a1 %zero 1 #33
	lw %a2 %a0 0 #31
	sw %a0 %sp 28 #33
	sw %a1 %sp 32 #33
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 36 #33 call dir
	addi %sp %sp 40 #33	
	jal %ra min_caml_create_array #33
	addi %sp %sp -40 #33
	lw %ra %sp 36 #33
	add %a1 %a0 %zero #33
	lw %a0 %sp 32 #33
	sw %ra %sp 36 #33 call dir
	addi %sp %sp 40 #33	
	jal %ra min_caml_create_array #33
	addi %sp %sp -40 #33
	lw %ra %sp 36 #33
	addi %a1 %zero 1 #37
	li %f0 l.5551 #37
	sw %a0 %sp 36 #37
	add %a0 %a1 %zero
	sw %ra %sp 44 #37 call dir
	addi %sp %sp 48 #37	
	jal %ra min_caml_create_float_array #37
	addi %sp %sp -48 #37
	lw %ra %sp 44 #37
	addi %a1 %zero 1 #39
	addi %a2 %zero 0 #39
	sw %a0 %sp 40 #39
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 44 #39 call dir
	addi %sp %sp 48 #39	
	jal %ra min_caml_create_array #39
	addi %sp %sp -48 #39
	lw %ra %sp 44 #39
	addi %a1 %zero 1 #41
	li %f0 l.5970 #41
	sw %a0 %sp 44 #41
	add %a0 %a1 %zero
	sw %ra %sp 52 #41 call dir
	addi %sp %sp 56 #41	
	jal %ra min_caml_create_float_array #41
	addi %sp %sp -56 #41
	lw %ra %sp 52 #41
	addi %a1 %zero 3 #43
	li %f0 l.5551 #43
	sw %a0 %sp 48 #43
	add %a0 %a1 %zero
	sw %ra %sp 52 #43 call dir
	addi %sp %sp 56 #43	
	jal %ra min_caml_create_float_array #43
	addi %sp %sp -56 #43
	lw %ra %sp 52 #43
	addi %a1 %zero 1 #45
	addi %a2 %zero 0 #45
	sw %a0 %sp 52 #45
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 60 #45 call dir
	addi %sp %sp 64 #45	
	jal %ra min_caml_create_array #45
	addi %sp %sp -64 #45
	lw %ra %sp 60 #45
	addi %a1 %zero 3 #47
	li %f0 l.5551 #47
	sw %a0 %sp 56 #47
	add %a0 %a1 %zero
	sw %ra %sp 60 #47 call dir
	addi %sp %sp 64 #47	
	jal %ra min_caml_create_float_array #47
	addi %sp %sp -64 #47
	lw %ra %sp 60 #47
	addi %a1 %zero 3 #49
	li %f0 l.5551 #49
	sw %a0 %sp 60 #49
	add %a0 %a1 %zero
	sw %ra %sp 68 #49 call dir
	addi %sp %sp 72 #49	
	jal %ra min_caml_create_float_array #49
	addi %sp %sp -72 #49
	lw %ra %sp 68 #49
	addi %a1 %zero 3 #52
	li %f0 l.5551 #52
	sw %a0 %sp 64 #52
	add %a0 %a1 %zero
	sw %ra %sp 68 #52 call dir
	addi %sp %sp 72 #52	
	jal %ra min_caml_create_float_array #52
	addi %sp %sp -72 #52
	lw %ra %sp 68 #52
	addi %a1 %zero 3 #54
	li %f0 l.5551 #54
	sw %a0 %sp 68 #54
	add %a0 %a1 %zero
	sw %ra %sp 76 #54 call dir
	addi %sp %sp 80 #54	
	jal %ra min_caml_create_float_array #54
	addi %sp %sp -80 #54
	lw %ra %sp 76 #54
	addi %a1 %zero 2 #57
	addi %a2 %zero 0 #57
	sw %a0 %sp 72 #57
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 76 #57 call dir
	addi %sp %sp 80 #57	
	jal %ra min_caml_create_array #57
	addi %sp %sp -80 #57
	lw %ra %sp 76 #57
	addi %a1 %zero 2 #59
	addi %a2 %zero 0 #59
	sw %a0 %sp 76 #59
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 84 #59 call dir
	addi %sp %sp 88 #59	
	jal %ra min_caml_create_array #59
	addi %sp %sp -88 #59
	lw %ra %sp 84 #59
	addi %a1 %zero 1 #61
	li %f0 l.5551 #61
	sw %a0 %sp 80 #61
	add %a0 %a1 %zero
	sw %ra %sp 84 #61 call dir
	addi %sp %sp 88 #61	
	jal %ra min_caml_create_float_array #61
	addi %sp %sp -88 #61
	lw %ra %sp 84 #61
	addi %a1 %zero 3 #64
	li %f0 l.5551 #64
	sw %a0 %sp 84 #64
	add %a0 %a1 %zero
	sw %ra %sp 92 #64 call dir
	addi %sp %sp 96 #64	
	jal %ra min_caml_create_float_array #64
	addi %sp %sp -96 #64
	lw %ra %sp 92 #64
	addi %a1 %zero 3 #66
	li %f0 l.5551 #66
	sw %a0 %sp 88 #66
	add %a0 %a1 %zero
	sw %ra %sp 92 #66 call dir
	addi %sp %sp 96 #66	
	jal %ra min_caml_create_float_array #66
	addi %sp %sp -96 #66
	lw %ra %sp 92 #66
	addi %a1 %zero 3 #69
	li %f0 l.5551 #69
	sw %a0 %sp 92 #69
	add %a0 %a1 %zero
	sw %ra %sp 100 #69 call dir
	addi %sp %sp 104 #69	
	jal %ra min_caml_create_float_array #69
	addi %sp %sp -104 #69
	lw %ra %sp 100 #69
	addi %a1 %zero 3 #70
	li %f0 l.5551 #70
	sw %a0 %sp 96 #70
	add %a0 %a1 %zero
	sw %ra %sp 100 #70 call dir
	addi %sp %sp 104 #70	
	jal %ra min_caml_create_float_array #70
	addi %sp %sp -104 #70
	lw %ra %sp 100 #70
	addi %a1 %zero 3 #71
	li %f0 l.5551 #71
	sw %a0 %sp 100 #71
	add %a0 %a1 %zero
	sw %ra %sp 108 #71 call dir
	addi %sp %sp 112 #71	
	jal %ra min_caml_create_float_array #71
	addi %sp %sp -112 #71
	lw %ra %sp 108 #71
	addi %a1 %zero 3 #74
	li %f0 l.5551 #74
	sw %a0 %sp 104 #74
	add %a0 %a1 %zero
	sw %ra %sp 108 #74 call dir
	addi %sp %sp 112 #74	
	jal %ra min_caml_create_float_array #74
	addi %sp %sp -112 #74
	lw %ra %sp 108 #74
	addi %a1 %zero 0 #78
	li %f0 l.5551 #78
	sw %a0 %sp 108 #78
	add %a0 %a1 %zero
	sw %ra %sp 116 #78 call dir
	addi %sp %sp 120 #78	
	jal %ra min_caml_create_float_array #78
	addi %sp %sp -120 #78
	lw %ra %sp 116 #78
	add %a1 %a0 %zero #78
	addi %a0 %zero 0 #79
	sw %a1 %sp 112 #79
	sw %ra %sp 116 #79 call dir
	addi %sp %sp 120 #79	
	jal %ra min_caml_create_array #79
	addi %sp %sp -120 #79
	lw %ra %sp 116 #79
	addi %a1 %zero 0 #80
	addi %a2 %min_caml_hp 0 #80
	addi %min_caml_hp %min_caml_hp 8 #80
	sw %a0 %a2 4 #80
	lw %a0 %sp 112 #80
	sw %a0 %a2 0 #80
	addi %a0 %a2 0 #80
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 116 #80 call dir
	addi %sp %sp 120 #80	
	jal %ra min_caml_create_array #80
	addi %sp %sp -120 #80
	lw %ra %sp 116 #80
	add %a1 %a0 %zero #80
	addi %a0 %zero 5 #81
	sw %ra %sp 116 #81 call dir
	addi %sp %sp 120 #81	
	jal %ra min_caml_create_array #81
	addi %sp %sp -120 #81
	lw %ra %sp 116 #81
	addi %a1 %zero 0 #85
	li %f0 l.5551 #85
	sw %a0 %sp 116 #85
	add %a0 %a1 %zero
	sw %ra %sp 124 #85 call dir
	addi %sp %sp 128 #85	
	jal %ra min_caml_create_float_array #85
	addi %sp %sp -128 #85
	lw %ra %sp 124 #85
	addi %a1 %zero 3 #86
	li %f0 l.5551 #86
	sw %a0 %sp 120 #86
	add %a0 %a1 %zero
	sw %ra %sp 124 #86 call dir
	addi %sp %sp 128 #86	
	jal %ra min_caml_create_float_array #86
	addi %sp %sp -128 #86
	lw %ra %sp 124 #86
	addi %a1 %zero 60 #87
	lw %a2 %sp 120 #87
	sw %a0 %sp 124 #87
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 132 #87 call dir
	addi %sp %sp 136 #87	
	jal %ra min_caml_create_array #87
	addi %sp %sp -136 #87
	lw %ra %sp 132 #87
	addi %a1 %min_caml_hp 0 #88
	addi %min_caml_hp %min_caml_hp 8 #88
	sw %a0 %a1 4 #88
	lw %a0 %sp 124 #88
	sw %a0 %a1 0 #88
	addi %a0 %a1 0 #88
	addi %a1 %zero 0 #92
	li %f0 l.5551 #92
	sw %a0 %sp 128 #92
	add %a0 %a1 %zero
	sw %ra %sp 132 #92 call dir
	addi %sp %sp 136 #92	
	jal %ra min_caml_create_float_array #92
	addi %sp %sp -136 #92
	lw %ra %sp 132 #92
	add %a1 %a0 %zero #92
	addi %a0 %zero 0 #93
	sw %a1 %sp 132 #93
	sw %ra %sp 140 #93 call dir
	addi %sp %sp 144 #93	
	jal %ra min_caml_create_array #93
	addi %sp %sp -144 #93
	lw %ra %sp 140 #93
	addi %a1 %min_caml_hp 0 #94
	addi %min_caml_hp %min_caml_hp 8 #94
	sw %a0 %a1 4 #94
	lw %a0 %sp 132 #94
	sw %a0 %a1 0 #94
	addi %a0 %a1 0 #94
	addi %a1 %zero 180 #95
	addi %a2 %zero 0 #95
	li %f0 l.5551 #95
	addi %a3 %min_caml_hp 0 #95
	addi %min_caml_hp %min_caml_hp 16 #95
	sw %f0 %a3 8 #95
	sw %a0 %a3 4 #95
	sw %a2 %a3 0 #95
	addi %a0 %a3 0 #95
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 140 #95 call dir
	addi %sp %sp 144 #95	
	jal %ra min_caml_create_array #95
	addi %sp %sp -144 #95
	lw %ra %sp 140 #95
	addi %a1 %zero 1 #99
	addi %a2 %zero 0 #99
	sw %a0 %sp 136 #99
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 140 #99 call dir
	addi %sp %sp 144 #99	
	jal %ra min_caml_create_array #99
	addi %sp %sp -144 #99
	lw %ra %sp 140 #99
	addi %a1 %min_caml_hp 0 #545
	addi %min_caml_hp %min_caml_hp 24 #545
	li %a2 read_screen_settings.2362 #545
	sw %a2 %a1 0 #545
	lw %a2 %sp 12 #545
	sw %a2 %a1 20 #545
	lw %a3 %sp 104 #545
	sw %a3 %a1 16 #545
	lw %a4 %sp 100 #545
	sw %a4 %a1 12 #545
	lw %a5 %sp 96 #545
	sw %a5 %a1 8 #545
	lw %a6 %sp 8 #545
	sw %a6 %a1 4 #545
	addi %a6 %min_caml_hp 0 #578
	addi %min_caml_hp %min_caml_hp 16 #578
	li %a7 read_light.2364 #578
	sw %a7 %a6 0 #578
	lw %a7 %sp 16 #578
	sw %a7 %a6 8 #578
	lw %a8 %sp 20 #578
	sw %a8 %a6 4 #578
	addi %a9 %min_caml_hp 0 #641
	addi %min_caml_hp %min_caml_hp 8 #641
	li %a10 read_nth_object.2369 #641
	sw %a10 %a9 0 #641
	lw %a10 %sp 4 #641
	sw %a10 %a9 4 #641
	addi %a11 %min_caml_hp 0 #724
	addi %min_caml_hp %min_caml_hp 16 #724
	li %a4 read_object.2371 #724
	sw %a4 %a11 0 #724
	sw %a9 %a11 8 #724
	lw %a4 %sp 0 #724
	sw %a4 %a11 4 #724
	addi %a9 %min_caml_hp 0 #733
	addi %min_caml_hp %min_caml_hp 8 #733
	li %a3 read_all_object.2373 #733
	sw %a3 %a9 0 #733
	sw %a11 %a9 4 #733
	addi %a3 %min_caml_hp 0 #757
	addi %min_caml_hp %min_caml_hp 8 #757
	li %a11 read_and_network.2379 #757
	sw %a11 %a3 0 #757
	lw %a11 %sp 28 #757
	sw %a11 %a3 4 #757
	addi %a5 %min_caml_hp 0 #766
	addi %min_caml_hp %min_caml_hp 24 #766
	li %a2 read_parameter.2381 #766
	sw %a2 %a5 0 #766
	sw %a1 %a5 20 #766
	sw %a6 %a5 16 #766
	sw %a3 %a5 12 #766
	sw %a9 %a5 8 #766
	lw %a1 %sp 36 #766
	sw %a1 %a5 4 #766
	addi %a2 %min_caml_hp 0 #782
	addi %min_caml_hp %min_caml_hp 8 #782
	li %a3 solver_rect_surface.2383 #782
	sw %a3 %a2 0 #782
	lw %a3 %sp 40 #782
	sw %a3 %a2 4 #782
	addi %a6 %min_caml_hp 0 #797
	addi %min_caml_hp %min_caml_hp 8 #797
	li %a9 solver_rect.2392 #797
	sw %a9 %a6 0 #797
	sw %a2 %a6 4 #797
	addi %a2 %min_caml_hp 0 #806
	addi %min_caml_hp %min_caml_hp 8 #806
	li %a9 solver_surface.2398 #806
	sw %a9 %a2 0 #806
	sw %a3 %a2 4 #806
	addi %a9 %min_caml_hp 0 #854
	addi %min_caml_hp %min_caml_hp 8 #854
	sw %a5 %sp 140 #854
	li %a5 solver_second.2417 #854
	sw %a5 %a9 0 #854
	sw %a3 %a9 4 #854
	addi %a5 %min_caml_hp 0 #883
	addi %min_caml_hp %min_caml_hp 24 #883
	li %a8 solver.2423 #883
	sw %a8 %a5 0 #883
	sw %a2 %a5 16 #883
	sw %a9 %a5 12 #883
	sw %a6 %a5 8 #883
	sw %a10 %a5 4 #883
	addi %a2 %min_caml_hp 0 #900
	addi %min_caml_hp %min_caml_hp 8 #900
	li %a6 solver_rect_fast.2427 #900
	sw %a6 %a2 0 #900
	sw %a3 %a2 4 #900
	addi %a6 %min_caml_hp 0 #933
	addi %min_caml_hp %min_caml_hp 8 #933
	li %a8 solver_surface_fast.2434 #933
	sw %a8 %a6 0 #933
	sw %a3 %a6 4 #933
	addi %a8 %min_caml_hp 0 #942
	addi %min_caml_hp %min_caml_hp 8 #942
	li %a9 solver_second_fast.2440 #942
	sw %a9 %a8 0 #942
	sw %a3 %a8 4 #942
	addi %a9 %min_caml_hp 0 #962
	addi %min_caml_hp %min_caml_hp 24 #962
	sw %a0 %sp 144 #962
	li %a0 solver_fast.2446 #962
	sw %a0 %a9 0 #962
	sw %a6 %a9 16 #962
	sw %a8 %a9 12 #962
	sw %a2 %a9 8 #962
	sw %a10 %a9 4 #962
	addi %a0 %min_caml_hp 0 #982
	addi %min_caml_hp %min_caml_hp 8 #982
	li %a6 solver_surface_fast2.2450 #982
	sw %a6 %a0 0 #982
	sw %a3 %a0 4 #982
	addi %a6 %min_caml_hp 0 #990
	addi %min_caml_hp %min_caml_hp 8 #990
	li %a8 solver_second_fast2.2457 #990
	sw %a8 %a6 0 #990
	sw %a3 %a6 4 #990
	addi %a8 %min_caml_hp 0 #1009
	addi %min_caml_hp %min_caml_hp 24 #1009
	li %a1 solver_fast2.2464 #1009
	sw %a1 %a8 0 #1009
	sw %a0 %a8 16 #1009
	sw %a6 %a8 12 #1009
	sw %a2 %a8 8 #1009
	sw %a10 %a8 4 #1009
	addi %a0 %min_caml_hp 0 #1103
	addi %min_caml_hp %min_caml_hp 8 #1103
	li %a1 iter_setup_dirvec_constants.2476 #1103
	sw %a1 %a0 0 #1103
	sw %a10 %a0 4 #1103
	addi %a1 %min_caml_hp 0 #1120
	addi %min_caml_hp %min_caml_hp 16 #1120
	li %a2 setup_dirvec_constants.2479 #1120
	sw %a2 %a1 0 #1120
	sw %a4 %a1 8 #1120
	sw %a0 %a1 4 #1120
	addi %a0 %min_caml_hp 0 #1126
	addi %min_caml_hp %min_caml_hp 8 #1126
	li %a2 setup_startp_constants.2481 #1126
	sw %a2 %a0 0 #1126
	sw %a10 %a0 4 #1126
	addi %a2 %min_caml_hp 0 #1145
	addi %min_caml_hp %min_caml_hp 16 #1145
	li %a6 setup_startp.2484 #1145
	sw %a6 %a2 0 #1145
	lw %a6 %sp 92 #1145
	sw %a6 %a2 12 #1145
	sw %a0 %a2 8 #1145
	sw %a4 %a2 4 #1145
	addi %a0 %min_caml_hp 0 #1193
	addi %min_caml_hp %min_caml_hp 8 #1193
	sw %a1 %sp 148 #1193
	li %a1 check_all_inside.2506 #1193
	sw %a1 %a0 0 #1193
	sw %a10 %a0 4 #1193
	addi %a1 %min_caml_hp 0 #1211
	addi %min_caml_hp %min_caml_hp 32 #1211
	li %a4 shadow_check_and_group.2512 #1211
	sw %a4 %a1 0 #1211
	sw %a9 %a1 28 #1211
	sw %a3 %a1 24 #1211
	sw %a10 %a1 20 #1211
	lw %a4 %sp 128 #1211
	sw %a4 %a1 16 #1211
	sw %a7 %a1 12 #1211
	lw %a7 %sp 52 #1211
	sw %a7 %a1 8 #1211
	sw %a0 %a1 4 #1211
	sw %a2 %sp 152 #1241
	addi %a2 %min_caml_hp 0 #1241
	addi %min_caml_hp %min_caml_hp 16 #1241
	sw %a8 %sp 156 #1241
	li %a8 shadow_check_one_or_group.2515 #1241
	sw %a8 %a2 0 #1241
	sw %a1 %a2 8 #1241
	sw %a11 %a2 4 #1241
	addi %a1 %min_caml_hp 0 #1256
	addi %min_caml_hp %min_caml_hp 24 #1256
	li %a8 shadow_check_one_or_matrix.2518 #1256
	sw %a8 %a1 0 #1256
	sw %a9 %a1 20 #1256
	sw %a3 %a1 16 #1256
	sw %a2 %a1 12 #1256
	sw %a4 %a1 8 #1256
	sw %a7 %a1 4 #1256
	addi %a2 %min_caml_hp 0 #1290
	addi %min_caml_hp %min_caml_hp 40 #1290
	li %a8 solve_each_element.2521 #1290
	sw %a8 %a2 0 #1290
	lw %a8 %sp 48 #1290
	sw %a8 %a2 36 #1290
	lw %a9 %sp 88 #1290
	sw %a9 %a2 32 #1290
	sw %a3 %a2 28 #1290
	sw %a5 %a2 24 #1290
	sw %a10 %a2 20 #1290
	lw %a4 %sp 44 #1290
	sw %a4 %a2 16 #1290
	sw %a7 %a2 12 #1290
	sw %a1 %sp 160 #1290
	lw %a1 %sp 56 #1290
	sw %a1 %a2 8 #1290
	sw %a0 %a2 4 #1290
	sw %a0 %sp 164 #1331
	addi %a0 %min_caml_hp 0 #1331
	addi %min_caml_hp %min_caml_hp 16 #1331
	li %a1 solve_one_or_network.2525 #1331
	sw %a1 %a0 0 #1331
	sw %a2 %a0 8 #1331
	sw %a11 %a0 4 #1331
	addi %a1 %min_caml_hp 0 #1341
	addi %min_caml_hp %min_caml_hp 24 #1341
	li %a2 trace_or_matrix.2529 #1341
	sw %a2 %a1 0 #1341
	sw %a8 %a1 20 #1341
	sw %a9 %a1 16 #1341
	sw %a3 %a1 12 #1341
	sw %a5 %a1 8 #1341
	sw %a0 %a1 4 #1341
	addi %a0 %min_caml_hp 0 #1368
	addi %min_caml_hp %min_caml_hp 16 #1368
	li %a2 judge_intersection.2533 #1368
	sw %a2 %a0 0 #1368
	sw %a1 %a0 12 #1368
	sw %a8 %a0 8 #1368
	lw %a1 %sp 36 #1368
	sw %a1 %a0 4 #1368
	addi %a2 %min_caml_hp 0 #1381
	addi %min_caml_hp %min_caml_hp 40 #1381
	li %a5 solve_each_element_fast.2535 #1381
	sw %a5 %a2 0 #1381
	sw %a8 %a2 36 #1381
	sw %a6 %a2 32 #1381
	lw %a5 %sp 156 #1381
	sw %a5 %a2 28 #1381
	sw %a3 %a2 24 #1381
	sw %a10 %a2 20 #1381
	sw %a4 %a2 16 #1381
	sw %a7 %a2 12 #1381
	lw %a6 %sp 56 #1381
	sw %a6 %a2 8 #1381
	sw %a0 %sp 168 #1381
	lw %a0 %sp 164 #1381
	sw %a0 %a2 4 #1381
	addi %a0 %min_caml_hp 0 #1422
	addi %min_caml_hp %min_caml_hp 16 #1422
	li %a10 solve_one_or_network_fast.2539 #1422
	sw %a10 %a0 0 #1422
	sw %a2 %a0 8 #1422
	sw %a11 %a0 4 #1422
	addi %a2 %min_caml_hp 0 #1432
	addi %min_caml_hp %min_caml_hp 24 #1432
	li %a10 trace_or_matrix_fast.2543 #1432
	sw %a10 %a2 0 #1432
	sw %a8 %a2 16 #1432
	sw %a5 %a2 12 #1432
	sw %a3 %a2 8 #1432
	sw %a0 %a2 4 #1432
	addi %a0 %min_caml_hp 0 #1456
	addi %min_caml_hp %min_caml_hp 16 #1456
	li %a3 judge_intersection_fast.2547 #1456
	sw %a3 %a0 0 #1456
	sw %a2 %a0 12 #1456
	sw %a8 %a0 8 #1456
	sw %a1 %a0 4 #1456
	addi %a2 %min_caml_hp 0 #1475
	addi %min_caml_hp %min_caml_hp 16 #1475
	li %a3 get_nvector_rect.2549 #1475
	sw %a3 %a2 0 #1475
	lw %a3 %sp 60 #1475
	sw %a3 %a2 8 #1475
	sw %a4 %a2 4 #1475
	addi %a5 %min_caml_hp 0 #1483
	addi %min_caml_hp %min_caml_hp 8 #1483
	li %a10 get_nvector_plane.2551 #1483
	sw %a10 %a5 0 #1483
	sw %a3 %a5 4 #1483
	addi %a10 %min_caml_hp 0 #1491
	addi %min_caml_hp %min_caml_hp 16 #1491
	li %a11 get_nvector_second.2553 #1491
	sw %a11 %a10 0 #1491
	sw %a3 %a10 8 #1491
	sw %a7 %a10 4 #1491
	addi %a11 %min_caml_hp 0 #1513
	addi %min_caml_hp %min_caml_hp 16 #1513
	li %a7 get_nvector.2555 #1513
	sw %a7 %a11 0 #1513
	sw %a10 %a11 12 #1513
	sw %a2 %a11 8 #1513
	sw %a5 %a11 4 #1513
	addi %a2 %min_caml_hp 0 #1527
	addi %min_caml_hp %min_caml_hp 8 #1527
	li %a5 utexture.2558 #1527
	sw %a5 %a2 0 #1527
	lw %a5 %sp 64 #1527
	sw %a5 %a2 4 #1527
	addi %a7 %min_caml_hp 0 #1603
	addi %min_caml_hp %min_caml_hp 16 #1603
	li %a10 add_light.2561 #1603
	sw %a10 %a7 0 #1603
	sw %a5 %a7 8 #1603
	lw %a10 %sp 72 #1603
	sw %a10 %a7 4 #1603
	sw %a11 %sp 172 #1620
	addi %a11 %min_caml_hp 0 #1620
	addi %min_caml_hp %min_caml_hp 40 #1620
	li %a10 trace_reflections.2565 #1620
	sw %a10 %a11 0 #1620
	lw %a10 %sp 160 #1620
	sw %a10 %a11 32 #1620
	lw %a10 %sp 136 #1620
	sw %a10 %a11 28 #1620
	sw %a1 %a11 24 #1620
	sw %a3 %a11 20 #1620
	sw %a0 %a11 16 #1620
	sw %a4 %a11 12 #1620
	sw %a6 %a11 8 #1620
	sw %a7 %a11 4 #1620
	addi %a10 %min_caml_hp 0 #1647
	addi %min_caml_hp %min_caml_hp 88 #1647
	sw %a0 %sp 176 #1647
	li %a0 trace_ray.2570 #1647
	sw %a0 %a10 0 #1647
	sw %a2 %a10 80 #1647
	sw %a11 %a10 76 #1647
	sw %a8 %a10 72 #1647
	sw %a5 %a10 68 #1647
	sw %a9 %a10 64 #1647
	lw %a0 %sp 160 #1647
	sw %a0 %a10 60 #1647
	lw %a8 %sp 152 #1647
	sw %a8 %a10 56 #1647
	lw %a11 %sp 72 #1647
	sw %a11 %a10 52 #1647
	sw %a1 %a10 48 #1647
	lw %a9 %sp 4 #1647
	sw %a9 %a10 44 #1647
	sw %a3 %a10 40 #1647
	lw %a11 %sp 144 #1647
	sw %a11 %a10 36 #1647
	lw %a11 %sp 16 #1647
	sw %a11 %a10 32 #1647
	lw %a8 %sp 168 #1647
	sw %a8 %a10 28 #1647
	sw %a4 %a10 24 #1647
	lw %a4 %sp 52 #1647
	sw %a4 %a10 20 #1647
	sw %a6 %a10 16 #1647
	lw %a8 %sp 172 #1647
	sw %a8 %a10 12 #1647
	lw %a8 %sp 20 #1647
	sw %a8 %a10 8 #1647
	sw %a7 %a10 4 #1647
	addi %a7 %min_caml_hp 0 #1737
	addi %min_caml_hp %min_caml_hp 56 #1737
	li %a8 trace_diffuse_ray.2576 #1737
	sw %a8 %a7 0 #1737
	sw %a2 %a7 48 #1737
	sw %a5 %a7 44 #1737
	sw %a0 %a7 40 #1737
	sw %a1 %a7 36 #1737
	sw %a9 %a7 32 #1737
	sw %a3 %a7 28 #1737
	sw %a11 %a7 24 #1737
	lw %a0 %sp 176 #1737
	sw %a0 %a7 20 #1737
	sw %a4 %a7 16 #1737
	sw %a6 %a7 12 #1737
	lw %a0 %sp 172 #1737
	sw %a0 %a7 8 #1737
	lw %a0 %sp 68 #1737
	sw %a0 %a7 4 #1737
	addi %a1 %min_caml_hp 0 #1755
	addi %min_caml_hp %min_caml_hp 8 #1755
	li %a2 iter_trace_diffuse_rays.2579 #1755
	sw %a2 %a1 0 #1755
	sw %a7 %a1 4 #1755
	addi %a2 %min_caml_hp 0 #1770
	addi %min_caml_hp %min_caml_hp 16 #1770
	li %a3 trace_diffuse_rays.2584 #1770
	sw %a3 %a2 0 #1770
	lw %a3 %sp 152 #1770
	sw %a3 %a2 8 #1770
	sw %a1 %a2 4 #1770
	addi %a1 %min_caml_hp 0 #1778
	addi %min_caml_hp %min_caml_hp 16 #1778
	li %a3 trace_diffuse_ray_80percent.2588 #1778
	sw %a3 %a1 0 #1778
	sw %a2 %a1 8 #1778
	lw %a3 %sp 116 #1778
	sw %a3 %a1 4 #1778
	addi %a4 %min_caml_hp 0 #1803
	addi %min_caml_hp %min_caml_hp 16 #1803
	li %a5 calc_diffuse_using_1point.2592 #1803
	sw %a5 %a4 0 #1803
	sw %a1 %a4 12 #1803
	lw %a1 %sp 72 #1803
	sw %a1 %a4 8 #1803
	sw %a0 %a4 4 #1803
	addi %a5 %min_caml_hp 0 #1821
	addi %min_caml_hp %min_caml_hp 16 #1821
	li %a6 calc_diffuse_using_5points.2595 #1821
	sw %a6 %a5 0 #1821
	sw %a1 %a5 8 #1821
	sw %a0 %a5 4 #1821
	addi %a6 %min_caml_hp 0 #1841
	addi %min_caml_hp %min_caml_hp 8 #1841
	li %a7 do_without_neighbors.2601 #1841
	sw %a7 %a6 0 #1841
	sw %a4 %a6 4 #1841
	addi %a4 %min_caml_hp 0 #1856
	addi %min_caml_hp %min_caml_hp 8 #1856
	li %a7 neighbors_exist.2604 #1856
	sw %a7 %a4 0 #1856
	lw %a7 %sp 76 #1856
	sw %a7 %a4 4 #1856
	addi %a8 %min_caml_hp 0 #1890
	addi %min_caml_hp %min_caml_hp 16 #1890
	li %a9 try_exploit_neighbors.2617 #1890
	sw %a9 %a8 0 #1890
	sw %a6 %a8 8 #1890
	sw %a5 %a8 4 #1890
	addi %a5 %min_caml_hp 0 #1915
	addi %min_caml_hp %min_caml_hp 8 #1915
	li %a9 write_ppm_header.2624 #1915
	sw %a9 %a5 0 #1915
	sw %a7 %a5 4 #1915
	addi %a9 %min_caml_hp 0 #1935
	addi %min_caml_hp %min_caml_hp 8 #1935
	sw %a5 %sp 180 #1935
	li %a5 write_rgb.2628 #1935
	sw %a5 %a9 0 #1935
	sw %a1 %a9 4 #1935
	addi %a5 %min_caml_hp 0 #1949
	addi %min_caml_hp %min_caml_hp 16 #1949
	li %a11 pretrace_diffuse_rays.2630 #1949
	sw %a11 %a5 0 #1949
	sw %a2 %a5 12 #1949
	sw %a3 %a5 8 #1949
	sw %a0 %a5 4 #1949
	addi %a0 %min_caml_hp 0 #1978
	addi %min_caml_hp %min_caml_hp 40 #1978
	li %a2 pretrace_pixels.2633 #1978
	sw %a2 %a0 0 #1978
	lw %a2 %sp 12 #1978
	sw %a2 %a0 36 #1978
	sw %a10 %a0 32 #1978
	lw %a2 %sp 88 #1978
	sw %a2 %a0 28 #1978
	lw %a2 %sp 96 #1978
	sw %a2 %a0 24 #1978
	lw %a2 %sp 84 #1978
	sw %a2 %a0 20 #1978
	sw %a1 %a0 16 #1978
	lw %a10 %sp 108 #1978
	sw %a10 %a0 12 #1978
	sw %a5 %a0 8 #1978
	lw %a5 %sp 80 #1978
	sw %a5 %a0 4 #1978
	addi %a10 %min_caml_hp 0 #2003
	addi %min_caml_hp %min_caml_hp 32 #2003
	li %a11 pretrace_line.2640 #2003
	sw %a11 %a10 0 #2003
	lw %a11 %sp 104 #2003
	sw %a11 %a10 24 #2003
	lw %a11 %sp 100 #2003
	sw %a11 %a10 20 #2003
	sw %a2 %a10 16 #2003
	sw %a0 %a10 12 #2003
	sw %a7 %a10 8 #2003
	sw %a5 %a10 4 #2003
	addi %a0 %min_caml_hp 0 #2017
	addi %min_caml_hp %min_caml_hp 32 #2017
	li %a11 scan_pixel.2644 #2017
	sw %a11 %a0 0 #2017
	sw %a9 %a0 24 #2017
	sw %a8 %a0 20 #2017
	sw %a1 %a0 16 #2017
	sw %a4 %a0 12 #2017
	sw %a7 %a0 8 #2017
	sw %a6 %a0 4 #2017
	addi %a1 %min_caml_hp 0 #2037
	addi %min_caml_hp %min_caml_hp 16 #2037
	li %a4 scan_line.2650 #2037
	sw %a4 %a1 0 #2037
	sw %a0 %a1 12 #2037
	sw %a10 %a1 8 #2037
	sw %a7 %a1 4 #2037
	addi %a0 %min_caml_hp 0 #2087
	addi %min_caml_hp %min_caml_hp 8 #2087
	li %a4 create_pixelline.2663 #2087
	sw %a4 %a0 0 #2087
	sw %a7 %a0 4 #2087
	addi %a4 %min_caml_hp 0 #2110
	addi %min_caml_hp %min_caml_hp 8 #2110
	li %a6 calc_dirvec.2670 #2110
	sw %a6 %a4 0 #2110
	sw %a3 %a4 4 #2110
	addi %a6 %min_caml_hp 0 #2131
	addi %min_caml_hp %min_caml_hp 8 #2131
	li %a8 calc_dirvecs.2678 #2131
	sw %a8 %a6 0 #2131
	sw %a4 %a6 4 #2131
	addi %a4 %min_caml_hp 0 #2145
	addi %min_caml_hp %min_caml_hp 8 #2145
	li %a8 calc_dirvec_rows.2683 #2145
	sw %a8 %a4 0 #2145
	sw %a6 %a4 4 #2145
	addi %a6 %min_caml_hp 0 #2156
	addi %min_caml_hp %min_caml_hp 8 #2156
	li %a8 create_dirvec.2687 #2156
	sw %a8 %a6 0 #2156
	lw %a8 %sp 0 #2156
	sw %a8 %a6 4 #2156
	addi %a9 %min_caml_hp 0 #2162
	addi %min_caml_hp %min_caml_hp 8 #2162
	li %a11 create_dirvec_elements.2689 #2162
	sw %a11 %a9 0 #2162
	sw %a6 %a9 4 #2162
	addi %a11 %min_caml_hp 0 #2169
	addi %min_caml_hp %min_caml_hp 16 #2169
	sw %a0 %sp 184 #2169
	li %a0 create_dirvecs.2692 #2169
	sw %a0 %a11 0 #2169
	sw %a3 %a11 12 #2169
	sw %a9 %a11 8 #2169
	sw %a6 %a11 4 #2169
	addi %a0 %min_caml_hp 0 #2179
	addi %min_caml_hp %min_caml_hp 8 #2179
	li %a9 init_dirvec_constants.2694 #2179
	sw %a9 %a0 0 #2179
	lw %a9 %sp 148 #2179
	sw %a9 %a0 4 #2179
	addi %a5 %min_caml_hp 0 #2186
	addi %min_caml_hp %min_caml_hp 16 #2186
	li %a7 init_vecset_constants.2697 #2186
	sw %a7 %a5 0 #2186
	sw %a0 %a5 8 #2186
	sw %a3 %a5 4 #2186
	addi %a0 %min_caml_hp 0 #2193
	addi %min_caml_hp %min_caml_hp 16 #2193
	li %a3 init_dirvecs.2699 #2193
	sw %a3 %a0 0 #2193
	sw %a5 %a0 12 #2193
	sw %a11 %a0 8 #2193
	sw %a4 %a0 4 #2193
	addi %a3 %min_caml_hp 0 #2202
	addi %min_caml_hp %min_caml_hp 16 #2202
	li %a4 add_reflection.2701 #2202
	sw %a4 %a3 0 #2202
	sw %a9 %a3 12 #2202
	lw %a4 %sp 136 #2202
	sw %a4 %a3 8 #2202
	sw %a6 %a3 4 #2202
	addi %a4 %min_caml_hp 0 #2211
	addi %min_caml_hp %min_caml_hp 16 #2211
	li %a5 setup_rect_reflection.2708 #2211
	sw %a5 %a4 0 #2211
	lw %a5 %sp 144 #2211
	sw %a5 %a4 12 #2211
	lw %a6 %sp 16 #2211
	sw %a6 %a4 8 #2211
	sw %a3 %a4 4 #2211
	addi %a7 %min_caml_hp 0 #2225
	addi %min_caml_hp %min_caml_hp 16 #2225
	li %a11 setup_surface_reflection.2711 #2225
	sw %a11 %a7 0 #2225
	sw %a5 %a7 12 #2225
	sw %a6 %a7 8 #2225
	sw %a3 %a7 4 #2225
	addi %a3 %min_caml_hp 0 #2240
	addi %min_caml_hp %min_caml_hp 16 #2240
	li %a5 setup_reflections.2714 #2240
	sw %a5 %a3 0 #2240
	sw %a7 %a3 12 #2240
	sw %a4 %a3 8 #2240
	lw %a4 %sp 4 #2240
	sw %a4 %a3 4 #2240
	addi %a11 %min_caml_hp 0 #2260
	addi %min_caml_hp %min_caml_hp 64 #2260
	li %a4 rt.2716 #2260
	sw %a4 %a11 0 #2260
	lw %a4 %sp 180 #2260
	sw %a4 %a11 56 #2260
	sw %a3 %a11 52 #2260
	sw %a9 %a11 48 #2260
	sw %a2 %a11 44 #2260
	sw %a1 %a11 40 #2260
	lw %a1 %sp 140 #2260
	sw %a1 %a11 36 #2260
	sw %a10 %a11 32 #2260
	sw %a8 %a11 28 #2260
	lw %a1 %sp 128 #2260
	sw %a1 %a11 24 #2260
	sw %a6 %a11 20 #2260
	sw %a0 %a11 16 #2260
	lw %a0 %sp 76 #2260
	sw %a0 %a11 12 #2260
	lw %a0 %sp 80 #2260
	sw %a0 %a11 8 #2260
	lw %a0 %sp 184 #2260
	sw %a0 %a11 4 #2260
	addi %a0 %zero 128 #2281
	addi %a1 %zero 128 #2281
	sw %ra %sp 188 #2281 call cls
	lw %a10 %a11 0 #2281
	addi %sp %sp 192 #2281	
	jalr %ra %a10 0 #2281
	addi %sp %sp -192 #2281
	lw %ra %sp 188 #2281
	addi %a0 %zero 0 #2283