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
    addi %a1 %zero 0
    addi %a2 %zero 0
    addi %a3 %zero 0
    addi %a4 %zero 0
    addi %a5 %zero 0
    addi %a6 %zero 0
    addi %a7 %zero 0
    addi %a8 %zero 48
find_100_digit:
    blt %a0 %a1 finish_find_100_digit
    addi %a4 %a4 1
    addi %a1 %a1 100
    beq %zero %zero find_100_digit
finish_find_100_digit:
    addi %a4 %a4 -1 # cancel addi %a4 %a4 1
    add %a9 %a4 %a8
    add %a7 %a7 %a9 # convert to ascii
    slli %a7 %a7 8
    addi %a1 %a1 -100 # cancel addi %a1 %a1 100
    sub %a0 %a0 %a1
find_10_digit:
    blt %a0 %a2 finish_find_10_digit
    addi %a5 %a5 1
    addi %a2 %a2 10
    beq %zero %zero find_10_digit
finish_find_10_digit:
    addi %a5 %a5 -1
    add %a9 %a5 %a8
    add %a7 %a7 %a9 # convert to ascii
    slli %a7 %a7 8
    addi %a2 %a2 -10
    sub %a0 %a0 %a2
find_1_digit:
    blt %a0 %a3 finish_find_1_digit
    addi %a6 %a6 1
    addi %a3 %a3 1
    beq %zero %zero find_1_digit
finish_find_1_digit:
    addi %a6 %a6 -1
    add %a9 %a6 %a8
    add %a7 %a7 %a9 # convert to ascii
    slli %a7 %a7 8
    addi %a0 %a7 32 # add space 0x20
finish_print_int:
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
    slli %a1 %a1 8
    add %a0 %a1 %a2 # 00 00 80 51
    addi %a3 %zero 32
    slli %a0 %a0 8
    add %a0 %a0 %a3 # 00 80 51 32
    slli %a0 %a0 8
    add %a0 %a0 %a3 # 80 51 32 32
    sw %a0 %out 0
    addi %out %out 4
    jalr %zero %ra 0

l.40359:	# 128.000000
	1124073472
l.40053:	# 0.900000
	1063675494
l.40051:	# 0.200000
	1045220557
l.39011:	# 150.000000
	1125515264
l.38946:	# -150.000000
	-1021968384
l.38835:	# 0.100000
	1036831949
l.38698:	# -2.000000
	-1073741824
l.38683:	# 0.003906
	998244352
l.38516:	# 100000000.000000
	1287568416
l.38510:	# 1000000000.000000
	1315859240
l.38481:	# 20.000000
	1101004800
l.38479:	# 0.050000
	1028443341
l.38470:	# 0.250000
	1048576000
l.38461:	# 10.000000
	1092616192
l.38454:	# 0.300000
	1050253722
l.38452:	# 255.000000
	1132396544
l.38448:	# 0.500000
	1056964608
l.38446:	# 0.150000
	1041865114
l.38437:	# 3.141593
	1078530011
l.38435:	# 30.000000
	1106247680
l.38433:	# 15.000000
	1097859072
l.38431:	# 0.000100
	953267991
l.37986:	# -0.100000
	-1110651699
l.37930:	# 0.010000
	1008981770
l.37928:	# -0.200000
	-1102263091
l.37443:	# -1.000000
	-1082130432
l.37441:	# 1.000000
	1065353216
l.37395:	# 2.000000
	1073741824
l.37367:	# 0.000000
	0
l.37361:	# -200.000000
	-1018691584
l.37358:	# 200.000000
	1128792064
l.37355:	# 0.017453
	1016003125
read_screen_settings.2591:
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
	li %f1 l.37355 #541
	fmul %f0 %f0 %f1 #541
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
	li %f1 l.37355 #541
	fmul %f0 %f0 %f1 #541
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
	li %f3 l.37358 #559
	fmul %f2 %f2 %f3 #559
	lw %a0 %sp 12 #559
	sw %f2 %a0 0 #559
	li %f2 l.37361 #560
	lw %f3 %sp 40 #560
	fmul %f2 %f3 %f2 #560
	sw %f2 %a0 4 #560
	lw %f2 %sp 56 #561
	fmul %f4 %f1 %f2 #561
	li %f5 l.37358 #561
	fmul %f4 %f4 %f5 #561
	sw %f4 %a0 8 #561
	lw %a1 %sp 8 #563
	sw %f2 %a1 0 #563
	li %f4 l.37367 #564
	sw %f4 %a1 4 #564
	fneg %f4 %f0 #565
	sw %f4 %a1 8 #565
	fneg %f4 %f3 #567
	fmul %f0 %f4 %f0 #567
	lw %a1 %sp 4 #567
	sw %f0 %a1 0 #567
	fneg %f0 %f1 #568
	sw %f0 %a1 4 #568
	fneg %f0 %f3 #569
	fmul %f0 %f0 %f2 #569
	sw %f0 %a1 8 #569
	lw %a1 %sp 16 #23
	lw %f0 %a1 0 #23
	lw %f1 %a0 0 #71
	fsub %f0 %f0 %f1 #571
	lw %a2 %sp 0 #571
	sw %f0 %a2 0 #571
	lw %f0 %a1 4 #23
	lw %f1 %a0 4 #71
	fsub %f0 %f0 %f1 #572
	sw %f0 %a2 4 #572
	lw %f0 %a1 8 #23
	lw %f1 %a0 8 #71
	fsub %f0 %f0 %f1 #573
	sw %f0 %a2 8 #573
	jalr %zero %ra 0 #573
rotate_quadratic_matrix.2595:
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
	fneg %f1 %f4 #617
	fmul %f4 %f5 %f2 #618
	fmul %f2 %f7 %f2 #619
	lw %a0 %sp 0 #622
	lw %f5 %a0 0 #622
	lw %f7 %a0 4 #622
	lw %f11 %a0 8 #622
	sw %f3 %sp 48 #629
	fmul %f3 %f3 %f3 #629
	fmul %f3 %f5 %f3 #629
	sw %f9 %sp 56 #629
	fmul %f9 %f9 %f9 #629
	fmul %f9 %f7 %f9 #629
	fadd %f3 %f3 %f9 #629
	fmul %f9 %f1 %f1 #629
	fmul %f9 %f11 %f9 #629
	fadd %f3 %f3 %f9 #629
	sw %f3 %a0 0 #629
	fmul %f3 %f6 %f6 #630
	fmul %f3 %f5 %f3 #630
	fmul %f9 %f10 %f10 #630
	fmul %f9 %f7 %f9 #630
	fadd %f3 %f3 %f9 #630
	fmul %f9 %f4 %f4 #630
	fmul %f9 %f11 %f9 #630
	fadd %f3 %f3 %f9 #630
	sw %f3 %a0 4 #630
	fmul %f3 %f8 %f8 #631
	fmul %f3 %f5 %f3 #631
	fmul %f9 %f0 %f0 #631
	fmul %f9 %f7 %f9 #631
	fadd %f3 %f3 %f9 #631
	fmul %f9 %f2 %f2 #631
	fmul %f9 %f11 %f9 #631
	fadd %f3 %f3 %f9 #631
	sw %f3 %a0 8 #631
	li %f3 l.37395 #634
	fmul %f9 %f5 %f6 #634
	fmul %f9 %f9 %f8 #634
	sw %f10 %sp 64 #634
	fmul %f10 %f7 %f10 #634
	fmul %f10 %f10 %f0 #634
	fadd %f9 %f9 %f10 #634
	fmul %f10 %f11 %f4 #634
	fmul %f10 %f10 %f2 #634
	fadd %f9 %f9 %f10 #634
	fmul %f3 %f3 %f9 #634
	lw %a0 %sp 4 #634
	sw %f3 %a0 0 #634
	li %f3 l.37395 #635
	lw %f9 %sp 48 #635
	fmul %f10 %f5 %f9 #635
	fmul %f8 %f10 %f8 #635
	sw %f4 %sp 72 #635
	lw %f10 %sp 56 #635
	fmul %f4 %f7 %f10 #635
	fmul %f0 %f4 %f0 #635
	fadd %f0 %f8 %f0 #635
	fmul %f4 %f11 %f1 #635
	fmul %f2 %f4 %f2 #635
	fadd %f0 %f0 %f2 #635
	fmul %f0 %f3 %f0 #635
	sw %f0 %a0 4 #635
	li %f0 l.37395 #636
	fmul %f2 %f5 %f9 #636
	fmul %f2 %f2 %f6 #636
	fmul %f3 %f7 %f10 #636
	lw %f4 %sp 64 #636
	fmul %f3 %f3 %f4 #636
	fadd %f2 %f2 %f3 #636
	fmul %f1 %f11 %f1 #636
	lw %f3 %sp 72 #636
	fmul %f1 %f1 %f3 #636
	fadd %f1 %f2 %f1 #636
	fmul %f0 %f0 %f1 #636
	sw %f0 %a0 8 #636
	jalr %zero %ra 0 #636
read_nth_object.2598:
	lw %a1 %a11 4 #641
	sw %a1 %sp 0 #643
	sw %a0 %sp 4 #643
	sw %ra %sp 12 #643 call dir
	addi %sp %sp 16 #643	
	jal %ra min_caml_read_int #643
	addi %sp %sp -16 #643
	lw %ra %sp 12 #643
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44225
	addi %a0 %zero 0 #720
	jalr %zero %ra 0 #720
beq_else.44225:
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
	li %f0 l.37367 #650
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
	li %f0 l.37367 #655
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
	fisneg %a0 %f0 #660
	addi %a1 %zero 2 #662
	li %f0 l.37367 #662
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
	li %f0 l.37367 #666
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
	li %f0 l.37367 #671
	add %a0 %a1 %zero
	sw %ra %sp 44 #671 call dir
	addi %sp %sp 48 #671	
	jal %ra min_caml_create_float_array #671
	addi %sp %sp -48 #671
	lw %ra %sp 44 #671
	lw %a1 %sp 20 #644
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44226 # nontail if
	jal %zero beq_cont.44227 # then sentence ends
beq_else.44226:
	sw %a0 %sp 44 #674
	sw %ra %sp 52 #674 call dir
	addi %sp %sp 56 #674	
	jal %ra min_caml_read_float #674
	addi %sp %sp -56 #674
	lw %ra %sp 52 #674
	li %f1 l.37355 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #674
	sw %f0 %a0 0 #674
	sw %ra %sp 52 #675 call dir
	addi %sp %sp 56 #675	
	jal %ra min_caml_read_float #675
	addi %sp %sp -56 #675
	lw %ra %sp 52 #675
	li %f1 l.37355 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #675
	sw %f0 %a0 4 #675
	sw %ra %sp 52 #676 call dir
	addi %sp %sp 56 #676	
	jal %ra min_caml_read_float #676
	addi %sp %sp -56 #676
	lw %ra %sp 52 #676
	li %f1 l.37355 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #676
	sw %f0 %a0 8 #676
beq_cont.44227:
	lw %a1 %sp 12 #644
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.44228 # nontail if
	addi %a2 %zero 1 #683
	jal %zero beq_cont.44229 # then sentence ends
beq_else.44228:
	lw %a2 %sp 32 #683
beq_cont.44229:
	addi %a3 %zero 4 #684
	li %f0 l.37367 #684
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
	bne %a4 %a12 beq_else.44230 # nontail if
	lw %f0 %a2 0 #650
	fiszero %a1 %f0 #701
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44232 # nontail if
	fiszero %a1 %f0 #111
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44234 # nontail if
	fispos %a1 %f0 #112
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44236 # nontail if
	li %f1 l.37443 #113
	jal %zero beq_cont.44237 # then sentence ends
beq_else.44236:
	li %f1 l.37441 #112
beq_cont.44237:
	jal %zero beq_cont.44235 # then sentence ends
beq_else.44234:
	li %f1 l.37367 #111
beq_cont.44235:
	fmul %f0 %f0 %f0 #701
	fdiv %f0 %f1 %f0 #701
	jal %zero beq_cont.44233 # then sentence ends
beq_else.44232:
	li %f0 l.37367 #701
beq_cont.44233:
	sw %f0 %a2 0 #701
	lw %f0 %a2 4 #650
	fiszero %a1 %f0 #703
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44238 # nontail if
	fiszero %a1 %f0 #111
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44240 # nontail if
	fispos %a1 %f0 #112
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44242 # nontail if
	li %f1 l.37443 #113
	jal %zero beq_cont.44243 # then sentence ends
beq_else.44242:
	li %f1 l.37441 #112
beq_cont.44243:
	jal %zero beq_cont.44241 # then sentence ends
beq_else.44240:
	li %f1 l.37367 #111
beq_cont.44241:
	fmul %f0 %f0 %f0 #703
	fdiv %f0 %f1 %f0 #703
	jal %zero beq_cont.44239 # then sentence ends
beq_else.44238:
	li %f0 l.37367 #703
beq_cont.44239:
	sw %f0 %a2 4 #703
	lw %f0 %a2 8 #650
	fiszero %a1 %f0 #705
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44244 # nontail if
	fiszero %a1 %f0 #111
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44246 # nontail if
	fispos %a1 %f0 #112
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44248 # nontail if
	li %f1 l.37443 #113
	jal %zero beq_cont.44249 # then sentence ends
beq_else.44248:
	li %f1 l.37441 #112
beq_cont.44249:
	jal %zero beq_cont.44247 # then sentence ends
beq_else.44246:
	li %f1 l.37367 #111
beq_cont.44247:
	fmul %f0 %f0 %f0 #705
	fdiv %f0 %f1 %f0 #705
	jal %zero beq_cont.44245 # then sentence ends
beq_else.44244:
	li %f0 l.37367 #705
beq_cont.44245:
	sw %f0 %a2 8 #705
	jal %zero beq_cont.44231 # then sentence ends
beq_else.44230:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.44250 # nontail if
	lw %a1 %sp 32 #660
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44252 # nontail if
	addi %a1 %zero 1 #709
	jal %zero beq_cont.44253 # then sentence ends
beq_else.44252:
	addi %a1 %zero 0 #709
beq_cont.44253:
	lw %f0 %a2 0 #172
	fmul %f0 %f0 %f0 #172
	lw %f1 %a2 4 #172
	fmul %f1 %f1 %f1 #172
	fadd %f0 %f0 %f1 #172
	lw %f1 %a2 8 #172
	fmul %f1 %f1 %f1 #172
	fadd %f0 %f0 %f1 #172
	sqrt %f0 %f0 #172
	fiszero %a4 %f0 #173
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44254 # nontail if
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44256 # nontail if
	li %f1 l.37441 #173
	fdiv %f0 %f1 %f0 #173
	jal %zero beq_cont.44257 # then sentence ends
beq_else.44256:
	li %f1 l.37443 #173
	fdiv %f0 %f1 %f0 #173
beq_cont.44257:
	jal %zero beq_cont.44255 # then sentence ends
beq_else.44254:
	li %f0 l.37441 #173
beq_cont.44255:
	lw %f1 %a2 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a2 0 #174
	lw %f1 %a2 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a2 4 #175
	lw %f1 %a2 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a2 8 #176
	jal %zero beq_cont.44251 # then sentence ends
beq_else.44250:
beq_cont.44251:
beq_cont.44231:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44258 # nontail if
	jal %zero beq_cont.44259 # then sentence ends
beq_else.44258:
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 52 #714 call dir
	addi %sp %sp 56 #714	
	jal %ra rotate_quadratic_matrix.2595 #714
	addi %sp %sp -56 #714
	lw %ra %sp 52 #714
beq_cont.44259:
	addi %a0 %zero 1 #717
	jalr %zero %ra 0 #717
read_object.2600:
	lw %a1 %a11 8 #724
	lw %a2 %a11 4 #724
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44260
	jalr %zero %ra 0 #730
bge_else.44260:
	sw %a11 %sp 0 #726
	sw %a1 %sp 4 #726
	sw %a2 %sp 8 #726
	sw %a0 %sp 12 #726
	add %a11 %a1 %zero
	sw %ra %sp 20 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 24 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -24 #726
	lw %ra %sp 20 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44262
	lw %a0 %sp 8 #729
	lw %a1 %sp 12 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44262:
	lw %a0 %sp 12 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44264
	jalr %zero %ra 0 #730
bge_else.44264:
	lw %a11 %sp 4 #726
	sw %a0 %sp 16 #726
	sw %ra %sp 20 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 24 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -24 #726
	lw %ra %sp 20 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44266
	lw %a0 %sp 8 #729
	lw %a1 %sp 16 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44266:
	lw %a0 %sp 16 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44268
	jalr %zero %ra 0 #730
bge_else.44268:
	lw %a11 %sp 4 #726
	sw %a0 %sp 20 #726
	sw %ra %sp 28 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 32 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -32 #726
	lw %ra %sp 28 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44270
	lw %a0 %sp 8 #729
	lw %a1 %sp 20 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44270:
	lw %a0 %sp 20 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44272
	jalr %zero %ra 0 #730
bge_else.44272:
	lw %a11 %sp 4 #726
	sw %a0 %sp 24 #726
	sw %ra %sp 28 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 32 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -32 #726
	lw %ra %sp 28 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44274
	lw %a0 %sp 8 #729
	lw %a1 %sp 24 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44274:
	lw %a0 %sp 24 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44276
	jalr %zero %ra 0 #730
bge_else.44276:
	lw %a11 %sp 4 #726
	sw %a0 %sp 28 #726
	sw %ra %sp 36 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 40 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -40 #726
	lw %ra %sp 36 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44278
	lw %a0 %sp 8 #729
	lw %a1 %sp 28 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44278:
	lw %a0 %sp 28 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44280
	jalr %zero %ra 0 #730
bge_else.44280:
	lw %a11 %sp 4 #726
	sw %a0 %sp 32 #726
	sw %ra %sp 36 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 40 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -40 #726
	lw %ra %sp 36 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44282
	lw %a0 %sp 8 #729
	lw %a1 %sp 32 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44282:
	lw %a0 %sp 32 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44284
	jalr %zero %ra 0 #730
bge_else.44284:
	lw %a11 %sp 4 #726
	sw %a0 %sp 36 #726
	sw %ra %sp 44 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 48 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -48 #726
	lw %ra %sp 44 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44286
	lw %a0 %sp 8 #729
	lw %a1 %sp 36 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44286:
	lw %a0 %sp 36 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.44288
	jalr %zero %ra 0 #730
bge_else.44288:
	lw %a11 %sp 4 #726
	sw %a0 %sp 40 #726
	sw %ra %sp 44 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 48 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -48 #726
	lw %ra %sp 44 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44290
	lw %a0 %sp 8 #729
	lw %a1 %sp 40 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.44290:
	lw %a0 %sp 40 #727
	addi %a0 %a0 1 #727
	lw %a11 %sp 0 #727
	lw %a10 %a11 0 #727
	jalr %zero %a10 0 #727
read_net_item.2604:
	sw %a0 %sp 0 #741
	sw %ra %sp 4 #741 call dir
	addi %sp %sp 8 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -8 #741
	lw %ra %sp 4 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44292
	lw %a0 %sp 0 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	jal	%zero min_caml_create_array
beq_else.44292:
	lw %a1 %sp 0 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 4 #741
	sw %a2 %sp 8 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44293 # nontail if
	lw %a0 %sp 8 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.44294 # then sentence ends
beq_else.44293:
	lw %a1 %sp 8 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 12 #741
	sw %a2 %sp 16 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44295 # nontail if
	lw %a0 %sp 16 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.44296 # then sentence ends
beq_else.44295:
	lw %a1 %sp 16 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 20 #741
	sw %a2 %sp 24 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44297 # nontail if
	lw %a0 %sp 24 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.44298 # then sentence ends
beq_else.44297:
	lw %a1 %sp 24 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 28 #744
	add %a0 %a2 %zero
	sw %ra %sp 36 #744 call dir
	addi %sp %sp 40 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -40 #744
	lw %ra %sp 36 #744
	lw %a1 %sp 24 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 28 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.44298:
	lw %a1 %sp 16 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 20 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.44296:
	lw %a1 %sp 8 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 12 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.44294:
	lw %a1 %sp 0 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 4 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
	jalr %zero %ra 0 #745
read_or_network.2606:
	sw %a0 %sp 0 #741
	sw %ra %sp 4 #741 call dir
	addi %sp %sp 8 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -8 #741
	lw %ra %sp 4 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44299 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 4 #742 call dir
	addi %sp %sp 8 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -8 #742
	lw %ra %sp 4 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.44300 # then sentence ends
beq_else.44299:
	sw %a0 %sp 4 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44301 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.44302 # then sentence ends
beq_else.44301:
	sw %a0 %sp 8 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44303 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.44304 # then sentence ends
beq_else.44303:
	addi %a1 %zero 3 #744
	sw %a0 %sp 12 #744
	add %a0 %a1 %zero
	sw %ra %sp 20 #744 call dir
	addi %sp %sp 24 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -24 #744
	lw %ra %sp 20 #744
	lw %a1 %sp 12 #745
	sw %a1 %a0 8 #745
beq_cont.44304:
	lw %a1 %sp 8 #745
	sw %a1 %a0 4 #745
beq_cont.44302:
	lw %a1 %sp 4 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.44300:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44305
	lw %a0 %sp 0 #751
	addi %a0 %a0 1 #751
	jal	%zero min_caml_create_array
beq_else.44305:
	lw %a0 %sp 0 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 16 #741
	sw %a2 %sp 20 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44306 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.44307 # then sentence ends
beq_else.44306:
	sw %a0 %sp 24 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44308 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.44309 # then sentence ends
beq_else.44308:
	addi %a1 %zero 2 #744
	sw %a0 %sp 28 #744
	add %a0 %a1 %zero
	sw %ra %sp 36 #744 call dir
	addi %sp %sp 40 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -40 #744
	lw %ra %sp 36 #744
	lw %a1 %sp 28 #745
	sw %a1 %a0 4 #745
beq_cont.44309:
	lw %a1 %sp 24 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.44307:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44310 # nontail if
	lw %a0 %sp 20 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 36 #751 call dir
	addi %sp %sp 40 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -40 #751
	lw %ra %sp 36 #751
	jal %zero beq_cont.44311 # then sentence ends
beq_else.44310:
	lw %a0 %sp 20 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 32 #741
	sw %a2 %sp 36 #741
	sw %ra %sp 44 #741 call dir
	addi %sp %sp 48 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -48 #741
	lw %ra %sp 44 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44312 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.44313 # then sentence ends
beq_else.44312:
	addi %a1 %zero 1 #744
	sw %a0 %sp 40 #744
	add %a0 %a1 %zero
	sw %ra %sp 44 #744 call dir
	addi %sp %sp 48 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -48 #744
	lw %ra %sp 44 #744
	lw %a1 %sp 40 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.44313:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44314 # nontail if
	lw %a0 %sp 36 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 44 #751 call dir
	addi %sp %sp 48 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -48 #751
	lw %ra %sp 44 #751
	jal %zero beq_cont.44315 # then sentence ends
beq_else.44314:
	lw %a0 %sp 36 #753
	addi %a2 %a0 1 #753
	addi %a3 %zero 0 #749
	sw %a1 %sp 44 #749
	sw %a2 %sp 48 #749
	add %a0 %a3 %zero
	sw %ra %sp 52 #749 call dir
	addi %sp %sp 56 #749	
	jal %ra read_net_item.2604 #749
	addi %sp %sp -56 #749
	lw %ra %sp 52 #749
	add %a1 %a0 %zero #749
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44316 # nontail if
	lw %a0 %sp 48 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 52 #751 call dir
	addi %sp %sp 56 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -56 #751
	lw %ra %sp 52 #751
	jal %zero beq_cont.44317 # then sentence ends
beq_else.44316:
	lw %a0 %sp 48 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 52 #753
	add %a0 %a2 %zero
	sw %ra %sp 60 #753 call dir
	addi %sp %sp 64 #753	
	jal %ra read_or_network.2606 #753
	addi %sp %sp -64 #753
	lw %ra %sp 60 #753
	lw %a1 %sp 48 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 52 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.44317:
	lw %a1 %sp 36 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 44 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.44315:
	lw %a1 %sp 20 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 32 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.44311:
	lw %a1 %sp 0 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 16 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
	jalr %zero %ra 0 #754
read_and_network.2608:
	lw %a1 %a11 4 #757
	sw %a11 %sp 0 #741
	sw %a1 %sp 4 #741
	sw %a0 %sp 8 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44318 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.44319 # then sentence ends
beq_else.44318:
	sw %a0 %sp 12 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44320 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.44321 # then sentence ends
beq_else.44320:
	sw %a0 %sp 16 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44322 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.44323 # then sentence ends
beq_else.44322:
	addi %a1 %zero 3 #744
	sw %a0 %sp 20 #744
	add %a0 %a1 %zero
	sw %ra %sp 28 #744 call dir
	addi %sp %sp 32 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -32 #744
	lw %ra %sp 28 #744
	lw %a1 %sp 20 #745
	sw %a1 %a0 8 #745
beq_cont.44323:
	lw %a1 %sp 16 #745
	sw %a1 %a0 4 #745
beq_cont.44321:
	lw %a1 %sp 12 #745
	sw %a1 %a0 0 #745
beq_cont.44319:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44324
	jalr %zero %ra 0 #759
beq_else.44324:
	lw %a1 %sp 8 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	sw %a0 %sp 24 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44326 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.44327 # then sentence ends
beq_else.44326:
	sw %a0 %sp 28 #741
	sw %ra %sp 36 #741 call dir
	addi %sp %sp 40 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -40 #741
	lw %ra %sp 36 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44328 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 36 #742 call dir
	addi %sp %sp 40 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -40 #742
	lw %ra %sp 36 #742
	jal %zero beq_cont.44329 # then sentence ends
beq_else.44328:
	addi %a1 %zero 2 #744
	sw %a0 %sp 32 #744
	add %a0 %a1 %zero
	sw %ra %sp 36 #744 call dir
	addi %sp %sp 40 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -40 #744
	lw %ra %sp 36 #744
	lw %a1 %sp 32 #745
	sw %a1 %a0 4 #745
beq_cont.44329:
	lw %a1 %sp 28 #745
	sw %a1 %a0 0 #745
beq_cont.44327:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44330
	jalr %zero %ra 0 #759
beq_else.44330:
	lw %a1 %sp 24 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	sw %a0 %sp 36 #741
	sw %ra %sp 44 #741 call dir
	addi %sp %sp 48 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -48 #741
	lw %ra %sp 44 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44332 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	jal %zero beq_cont.44333 # then sentence ends
beq_else.44332:
	addi %a1 %zero 1 #744
	sw %a0 %sp 40 #744
	add %a0 %a1 %zero
	sw %ra %sp 44 #744 call dir
	addi %sp %sp 48 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -48 #744
	lw %ra %sp 44 #744
	lw %a1 %sp 40 #745
	sw %a1 %a0 0 #745
beq_cont.44333:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44334
	jalr %zero %ra 0 #759
beq_else.44334:
	lw %a1 %sp 36 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	addi %a1 %zero 0 #758
	sw %a0 %sp 44 #758
	add %a0 %a1 %zero
	sw %ra %sp 52 #758 call dir
	addi %sp %sp 56 #758	
	jal %ra read_net_item.2604 #758
	addi %sp %sp -56 #758
	lw %ra %sp 52 #758
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44336
	jalr %zero %ra 0 #759
beq_else.44336:
	lw %a1 %sp 44 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	lw %a11 %sp 0 #762
	lw %a10 %a11 0 #762
	jalr %zero %a10 0 #762
read_parameter.2610:
	lw %a0 %a11 36 #766
	lw %a1 %a11 32 #766
	lw %a2 %a11 28 #766
	lw %a3 %a11 24 #766
	lw %a4 %a11 20 #766
	lw %a5 %a11 16 #766
	lw %a6 %a11 12 #766
	lw %a7 %a11 8 #766
	lw %a8 %a11 4 #766
	sw %a4 %sp 0 #768
	sw %a3 %sp 4 #768
	sw %a8 %sp 8 #768
	sw %a1 %sp 12 #768
	sw %a5 %sp 16 #768
	sw %a2 %sp 20 #768
	sw %a7 %sp 24 #768
	sw %a6 %sp 28 #768
	add %a11 %a0 %zero
	sw %ra %sp 36 #768 call cls
	lw %a10 %a11 0 #768
	addi %sp %sp 40 #768	
	jalr %ra %a10 0 #768
	addi %sp %sp -40 #768
	lw %ra %sp 36 #768
	sw %ra %sp 36 #580 call dir
	addi %sp %sp 40 #580	
	jal %ra min_caml_read_int #580
	addi %sp %sp -40 #580
	lw %ra %sp 36 #580
	sw %ra %sp 36 #583 call dir
	addi %sp %sp 40 #583	
	jal %ra min_caml_read_float #583
	addi %sp %sp -40 #583
	lw %ra %sp 36 #583
	li %f1 l.37355 #541
	fmul %f0 %f0 %f1 #541
	sw %f0 %sp 32 #584
	sw %ra %sp 44 #584 call dir
	addi %sp %sp 48 #584	
	jal %ra min_caml_sin #584
	addi %sp %sp -48 #584
	lw %ra %sp 44 #584
	fneg %f0 %f0 #585
	lw %a0 %sp 28 #585
	sw %f0 %a0 4 #585
	sw %ra %sp 44 #586 call dir
	addi %sp %sp 48 #586	
	jal %ra min_caml_read_float #586
	addi %sp %sp -48 #586
	lw %ra %sp 44 #586
	li %f1 l.37355 #541
	fmul %f0 %f0 %f1 #541
	lw %f1 %sp 32 #587
	sw %f0 %sp 40 #587
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #587 call dir
	addi %sp %sp 56 #587	
	jal %ra min_caml_cos #587
	addi %sp %sp -56 #587
	lw %ra %sp 52 #587
	lw %f1 %sp 40 #588
	sw %f0 %sp 48 #588
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #588 call dir
	addi %sp %sp 64 #588	
	jal %ra min_caml_sin #588
	addi %sp %sp -64 #588
	lw %ra %sp 60 #588
	lw %f1 %sp 48 #589
	fmul %f0 %f1 %f0 #589
	lw %a0 %sp 28 #589
	sw %f0 %a0 0 #589
	lw %f0 %sp 40 #590
	sw %ra %sp 60 #590 call dir
	addi %sp %sp 64 #590	
	jal %ra min_caml_cos #590
	addi %sp %sp -64 #590
	lw %ra %sp 60 #590
	lw %f1 %sp 48 #591
	fmul %f0 %f1 %f0 #591
	lw %a0 %sp 28 #591
	sw %f0 %a0 8 #591
	sw %ra %sp 60 #592 call dir
	addi %sp %sp 64 #592	
	jal %ra min_caml_read_float #592
	addi %sp %sp -64 #592
	lw %ra %sp 60 #592
	lw %a0 %sp 24 #592
	sw %f0 %a0 0 #592
	addi %a0 %zero 0 #734
	lw %a11 %sp 20 #726
	sw %a0 %sp 56 #726
	sw %ra %sp 60 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 64 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -64 #726
	lw %ra %sp 60 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44338 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 56 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.44339 # then sentence ends
beq_else.44338:
	addi %a0 %zero 1 #727
	lw %a11 %sp 20 #726
	sw %a0 %sp 60 #726
	sw %ra %sp 68 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 72 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -72 #726
	lw %ra %sp 68 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44340 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 60 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.44341 # then sentence ends
beq_else.44340:
	addi %a0 %zero 2 #727
	lw %a11 %sp 20 #726
	sw %a0 %sp 64 #726
	sw %ra %sp 68 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 72 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -72 #726
	lw %ra %sp 68 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44342 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 64 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.44343 # then sentence ends
beq_else.44342:
	addi %a0 %zero 3 #727
	lw %a11 %sp 20 #726
	sw %a0 %sp 68 #726
	sw %ra %sp 76 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 80 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -80 #726
	lw %ra %sp 76 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44344 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 68 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.44345 # then sentence ends
beq_else.44344:
	addi %a0 %zero 4 #727
	lw %a11 %sp 20 #726
	sw %a0 %sp 72 #726
	sw %ra %sp 76 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 80 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -80 #726
	lw %ra %sp 76 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44346 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 72 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.44347 # then sentence ends
beq_else.44346:
	addi %a0 %zero 5 #727
	lw %a11 %sp 20 #726
	sw %a0 %sp 76 #726
	sw %ra %sp 84 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 88 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -88 #726
	lw %ra %sp 84 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44348 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 76 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.44349 # then sentence ends
beq_else.44348:
	addi %a0 %zero 6 #727
	lw %a11 %sp 12 #727
	sw %ra %sp 84 #727 call cls
	lw %a10 %a11 0 #727
	addi %sp %sp 88 #727	
	jalr %ra %a10 0 #727
	addi %sp %sp -88 #727
	lw %ra %sp 84 #727
beq_cont.44349:
beq_cont.44347:
beq_cont.44345:
beq_cont.44343:
beq_cont.44341:
beq_cont.44339:
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44350 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.44351 # then sentence ends
beq_else.44350:
	sw %a0 %sp 80 #741
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44352 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.44353 # then sentence ends
beq_else.44352:
	addi %a1 %zero 2 #744
	sw %a0 %sp 84 #744
	add %a0 %a1 %zero
	sw %ra %sp 92 #744 call dir
	addi %sp %sp 96 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -96 #744
	lw %ra %sp 92 #744
	lw %a1 %sp 84 #745
	sw %a1 %a0 4 #745
beq_cont.44353:
	lw %a1 %sp 80 #745
	sw %a1 %a0 0 #745
beq_cont.44351:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44354 # nontail if
	jal %zero beq_cont.44355 # then sentence ends
beq_else.44354:
	lw %a1 %sp 8 #761
	sw %a0 %a1 0 #761
	sw %ra %sp 92 #741 call dir
	addi %sp %sp 96 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -96 #741
	lw %ra %sp 92 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44356 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 92 #742 call dir
	addi %sp %sp 96 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -96 #742
	lw %ra %sp 92 #742
	jal %zero beq_cont.44357 # then sentence ends
beq_else.44356:
	addi %a1 %zero 1 #744
	sw %a0 %sp 88 #744
	add %a0 %a1 %zero
	sw %ra %sp 92 #744 call dir
	addi %sp %sp 96 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -96 #744
	lw %ra %sp 92 #744
	lw %a1 %sp 88 #745
	sw %a1 %a0 0 #745
beq_cont.44357:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44358 # nontail if
	jal %zero beq_cont.44359 # then sentence ends
beq_else.44358:
	lw %a1 %sp 8 #761
	sw %a0 %a1 4 #761
	addi %a0 %zero 0 #758
	sw %ra %sp 92 #758 call dir
	addi %sp %sp 96 #758	
	jal %ra read_net_item.2604 #758
	addi %sp %sp -96 #758
	lw %ra %sp 92 #758
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44360 # nontail if
	jal %zero beq_cont.44361 # then sentence ends
beq_else.44360:
	lw %a1 %sp 8 #761
	sw %a0 %a1 8 #761
	addi %a0 %zero 3 #762
	lw %a11 %sp 4 #762
	sw %ra %sp 92 #762 call cls
	lw %a10 %a11 0 #762
	addi %sp %sp 96 #762	
	jalr %ra %a10 0 #762
	addi %sp %sp -96 #762
	lw %ra %sp 92 #762
beq_cont.44361:
beq_cont.44359:
beq_cont.44355:
	sw %ra %sp 92 #741 call dir
	addi %sp %sp 96 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -96 #741
	lw %ra %sp 92 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44362 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 92 #742 call dir
	addi %sp %sp 96 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -96 #742
	lw %ra %sp 92 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.44363 # then sentence ends
beq_else.44362:
	sw %a0 %sp 92 #741
	sw %ra %sp 100 #741 call dir
	addi %sp %sp 104 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -104 #741
	lw %ra %sp 100 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44364 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 100 #742 call dir
	addi %sp %sp 104 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -104 #742
	lw %ra %sp 100 #742
	jal %zero beq_cont.44365 # then sentence ends
beq_else.44364:
	addi %a1 %zero 2 #744
	sw %a0 %sp 96 #744
	add %a0 %a1 %zero
	sw %ra %sp 100 #744 call dir
	addi %sp %sp 104 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -104 #744
	lw %ra %sp 100 #744
	lw %a1 %sp 96 #745
	sw %a1 %a0 4 #745
beq_cont.44365:
	lw %a1 %sp 92 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.44363:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44366 # nontail if
	addi %a0 %zero 1 #751
	sw %ra %sp 100 #751 call dir
	addi %sp %sp 104 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -104 #751
	lw %ra %sp 100 #751
	jal %zero beq_cont.44367 # then sentence ends
beq_else.44366:
	sw %a1 %sp 100 #741
	sw %ra %sp 108 #741 call dir
	addi %sp %sp 112 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -112 #741
	lw %ra %sp 108 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44368 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 108 #742 call dir
	addi %sp %sp 112 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -112 #742
	lw %ra %sp 108 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.44369 # then sentence ends
beq_else.44368:
	addi %a1 %zero 1 #744
	sw %a0 %sp 104 #744
	add %a0 %a1 %zero
	sw %ra %sp 108 #744 call dir
	addi %sp %sp 112 #744	
	jal %ra read_net_item.2604 #744
	addi %sp %sp -112 #744
	lw %ra %sp 108 #744
	lw %a1 %sp 104 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.44369:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44370 # nontail if
	addi %a0 %zero 2 #751
	sw %ra %sp 108 #751 call dir
	addi %sp %sp 112 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -112 #751
	lw %ra %sp 108 #751
	jal %zero beq_cont.44371 # then sentence ends
beq_else.44370:
	addi %a0 %zero 0 #749
	sw %a1 %sp 108 #749
	sw %ra %sp 116 #749 call dir
	addi %sp %sp 120 #749	
	jal %ra read_net_item.2604 #749
	addi %sp %sp -120 #749
	lw %ra %sp 116 #749
	add %a1 %a0 %zero #749
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44372 # nontail if
	addi %a0 %zero 3 #751
	sw %ra %sp 116 #751 call dir
	addi %sp %sp 120 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -120 #751
	lw %ra %sp 116 #751
	jal %zero beq_cont.44373 # then sentence ends
beq_else.44372:
	addi %a0 %zero 3 #753
	sw %a1 %sp 112 #753
	sw %ra %sp 116 #753 call dir
	addi %sp %sp 120 #753	
	jal %ra read_or_network.2606 #753
	addi %sp %sp -120 #753
	lw %ra %sp 116 #753
	lw %a1 %sp 112 #754
	sw %a1 %a0 8 #754
beq_cont.44373:
	lw %a1 %sp 108 #754
	sw %a1 %a0 4 #754
beq_cont.44371:
	lw %a1 %sp 100 #754
	sw %a1 %a0 0 #754
beq_cont.44367:
	lw %a1 %sp 0 #772
	sw %a0 %a1 0 #772
	jalr %zero %ra 0 #772
solver_rect.2621:
	lw %a2 %a11 4 #797
	lw %f3 %a1 0 #783
	fiszero %a3 %f3 #783
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44375 # nontail if
	lw %a3 %a0 16 #306
	lw %a4 %a0 24 #258
	lw %f3 %a1 0 #783
	fisneg %a5 %f3 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44377 # nontail if
	addi %a4 %a5 0 #105
	jal %zero beq_cont.44378 # then sentence ends
beq_else.44377:
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.44379 # nontail if
	addi %a4 %zero 1 #105
	jal %zero beq_cont.44380 # then sentence ends
beq_else.44379:
	addi %a4 %zero 0 #105
beq_cont.44380:
beq_cont.44378:
	lw %f3 %a3 0 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44381 # nontail if
	fneg %f3 %f3 #118
	jal %zero beq_cont.44382 # then sentence ends
beq_else.44381:
beq_cont.44382:
	fsub %f3 %f3 %f0 #787
	lw %f4 %a1 0 #783
	fdiv %f3 %f3 %f4 #787
	lw %f4 %a1 4 #783
	fmul %f4 %f3 %f4 #788
	fadd %f4 %f4 %f1 #788
	fabs %f4 %f4 #788
	lw %f5 %a3 4 #785
	fless %a4 %f4 %f5 #788
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44383 # nontail if
	addi %a3 %zero 0 #792
	jal %zero beq_cont.44384 # then sentence ends
beq_else.44383:
	lw %f4 %a1 8 #783
	fmul %f4 %f3 %f4 #789
	fadd %f4 %f4 %f2 #789
	fabs %f4 %f4 #789
	lw %f5 %a3 8 #785
	fless %a3 %f4 %f5 #789
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44385 # nontail if
	addi %a3 %zero 0 #791
	jal %zero beq_cont.44386 # then sentence ends
beq_else.44385:
	sw %f3 %a2 0 #790
	addi %a3 %zero 1 #790
beq_cont.44386:
beq_cont.44384:
	jal %zero beq_cont.44376 # then sentence ends
beq_else.44375:
	addi %a3 %zero 0 #783
beq_cont.44376:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44387
	lw %f3 %a1 4 #783
	fiszero %a3 %f3 #783
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44388 # nontail if
	lw %a3 %a0 16 #306
	lw %a4 %a0 24 #258
	lw %f3 %a1 4 #783
	fisneg %a5 %f3 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44390 # nontail if
	addi %a4 %a5 0 #105
	jal %zero beq_cont.44391 # then sentence ends
beq_else.44390:
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.44392 # nontail if
	addi %a4 %zero 1 #105
	jal %zero beq_cont.44393 # then sentence ends
beq_else.44392:
	addi %a4 %zero 0 #105
beq_cont.44393:
beq_cont.44391:
	lw %f3 %a3 4 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44394 # nontail if
	fneg %f3 %f3 #118
	jal %zero beq_cont.44395 # then sentence ends
beq_else.44394:
beq_cont.44395:
	fsub %f3 %f3 %f1 #787
	lw %f4 %a1 4 #783
	fdiv %f3 %f3 %f4 #787
	lw %f4 %a1 8 #783
	fmul %f4 %f3 %f4 #788
	fadd %f4 %f4 %f2 #788
	fabs %f4 %f4 #788
	lw %f5 %a3 8 #785
	fless %a4 %f4 %f5 #788
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44396 # nontail if
	addi %a3 %zero 0 #792
	jal %zero beq_cont.44397 # then sentence ends
beq_else.44396:
	lw %f4 %a1 0 #783
	fmul %f4 %f3 %f4 #789
	fadd %f4 %f4 %f0 #789
	fabs %f4 %f4 #789
	lw %f5 %a3 0 #785
	fless %a3 %f4 %f5 #789
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44398 # nontail if
	addi %a3 %zero 0 #791
	jal %zero beq_cont.44399 # then sentence ends
beq_else.44398:
	sw %f3 %a2 0 #790
	addi %a3 %zero 1 #790
beq_cont.44399:
beq_cont.44397:
	jal %zero beq_cont.44389 # then sentence ends
beq_else.44388:
	addi %a3 %zero 0 #783
beq_cont.44389:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44400
	lw %f3 %a1 8 #783
	fiszero %a3 %f3 #783
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44401 # nontail if
	lw %a3 %a0 16 #306
	lw %a0 %a0 24 #258
	lw %f3 %a1 8 #783
	fisneg %a4 %f3 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44403 # nontail if
	addi %a0 %a4 0 #105
	jal %zero beq_cont.44404 # then sentence ends
beq_else.44403:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44405 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.44406 # then sentence ends
beq_else.44405:
	addi %a0 %zero 0 #105
beq_cont.44406:
beq_cont.44404:
	lw %f3 %a3 8 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44407 # nontail if
	fneg %f3 %f3 #118
	jal %zero beq_cont.44408 # then sentence ends
beq_else.44407:
beq_cont.44408:
	fsub %f2 %f3 %f2 #787
	lw %f3 %a1 8 #783
	fdiv %f2 %f2 %f3 #787
	lw %f3 %a1 0 #783
	fmul %f3 %f2 %f3 #788
	fadd %f0 %f3 %f0 #788
	fabs %f0 %f0 #788
	lw %f3 %a3 0 #785
	fless %a0 %f0 %f3 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44409 # nontail if
	addi %a0 %zero 0 #792
	jal %zero beq_cont.44410 # then sentence ends
beq_else.44409:
	lw %f0 %a1 4 #783
	fmul %f0 %f2 %f0 #789
	fadd %f0 %f0 %f1 #789
	fabs %f0 %f0 #789
	lw %f1 %a3 4 #785
	fless %a0 %f0 %f1 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44411 # nontail if
	addi %a0 %zero 0 #791
	jal %zero beq_cont.44412 # then sentence ends
beq_else.44411:
	sw %f2 %a2 0 #790
	addi %a0 %zero 1 #790
beq_cont.44412:
beq_cont.44410:
	jal %zero beq_cont.44402 # then sentence ends
beq_else.44401:
	addi %a0 %zero 0 #783
beq_cont.44402:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44413
	addi %a0 %zero 0 #801
	jalr %zero %ra 0 #801
beq_else.44413:
	addi %a0 %zero 3 #800
	jalr %zero %ra 0 #800
beq_else.44400:
	addi %a0 %zero 2 #799
	jalr %zero %ra 0 #799
beq_else.44387:
	addi %a0 %zero 1 #798
	jalr %zero %ra 0 #798
solver_second.2646:
	lw %a2 %a11 4 #854
	lw %f3 %a1 0 #858
	lw %f4 %a1 4 #858
	lw %f5 %a1 8 #858
	fmul %f6 %f3 %f3 #822
	lw %a3 %a0 16 #276
	lw %f7 %a3 0 #281
	fmul %f6 %f6 %f7 #822
	fmul %f7 %f4 %f4 #822
	lw %a3 %a0 16 #286
	lw %f8 %a3 4 #291
	fmul %f7 %f7 %f8 #822
	fadd %f6 %f6 %f7 #822
	fmul %f7 %f5 %f5 #822
	lw %a3 %a0 16 #296
	lw %f8 %a3 8 #301
	fmul %f7 %f7 %f8 #822
	fadd %f6 %f6 %f7 #822
	lw %a3 %a0 12 #267
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44414 # nontail if
	fadd %f3 %f6 %fzero #822
	jal %zero beq_cont.44415 # then sentence ends
beq_else.44414:
	fmul %f7 %f4 %f5 #828
	lw %a3 %a0 36 #396
	lw %f8 %a3 0 #401
	fmul %f7 %f7 %f8 #828
	fadd %f6 %f6 %f7 #827
	fmul %f5 %f5 %f3 #829
	lw %a3 %a0 36 #406
	lw %f7 %a3 4 #411
	fmul %f5 %f5 %f7 #829
	fadd %f5 %f6 %f5 #827
	fmul %f3 %f3 %f4 #830
	lw %a3 %a0 36 #416
	lw %f4 %a3 8 #421
	fmul %f3 %f3 %f4 #830
	fadd %f3 %f5 %f3 #827
beq_cont.44415:
	fiszero %a3 %f3 #860
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44416
	lw %f4 %a1 0 #858
	lw %f5 %a1 4 #858
	lw %f6 %a1 8 #858
	fmul %f7 %f4 %f0 #837
	lw %a1 %a0 16 #276
	lw %f8 %a1 0 #281
	fmul %f7 %f7 %f8 #837
	fmul %f8 %f5 %f1 #838
	lw %a1 %a0 16 #286
	lw %f9 %a1 4 #291
	fmul %f8 %f8 %f9 #838
	fadd %f7 %f7 %f8 #837
	fmul %f8 %f6 %f2 #839
	lw %a1 %a0 16 #296
	lw %f9 %a1 8 #301
	fmul %f8 %f8 %f9 #839
	fadd %f7 %f7 %f8 #837
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44417 # nontail if
	fadd %f4 %f7 %fzero #837
	jal %zero beq_cont.44418 # then sentence ends
beq_else.44417:
	fmul %f8 %f6 %f1 #845
	fmul %f9 %f5 %f2 #845
	fadd %f8 %f8 %f9 #845
	lw %a1 %a0 36 #396
	lw %f9 %a1 0 #401
	fmul %f8 %f8 %f9 #845
	fmul %f9 %f4 %f2 #846
	fmul %f6 %f6 %f0 #846
	fadd %f6 %f9 %f6 #846
	lw %a1 %a0 36 #406
	lw %f9 %a1 4 #411
	fmul %f6 %f6 %f9 #846
	fadd %f6 %f8 %f6 #845
	fmul %f4 %f4 %f1 #847
	fmul %f5 %f5 %f0 #847
	fadd %f4 %f4 %f5 #847
	lw %a1 %a0 36 #416
	lw %f5 %a1 8 #421
	fmul %f4 %f4 %f5 #847
	fadd %f4 %f6 %f4 #845
	fhalf %f4 %f4 #844
	fadd %f4 %f7 %f4 #844
beq_cont.44418:
	fmul %f5 %f0 %f0 #822
	lw %a1 %a0 16 #276
	lw %f6 %a1 0 #281
	fmul %f5 %f5 %f6 #822
	fmul %f6 %f1 %f1 #822
	lw %a1 %a0 16 #286
	lw %f7 %a1 4 #291
	fmul %f6 %f6 %f7 #822
	fadd %f5 %f5 %f6 #822
	fmul %f6 %f2 %f2 #822
	lw %a1 %a0 16 #296
	lw %f7 %a1 8 #301
	fmul %f6 %f6 %f7 #822
	fadd %f5 %f5 %f6 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44419 # nontail if
	fadd %f0 %f5 %fzero #822
	jal %zero beq_cont.44420 # then sentence ends
beq_else.44419:
	fmul %f6 %f1 %f2 #828
	lw %a1 %a0 36 #396
	lw %f7 %a1 0 #401
	fmul %f6 %f6 %f7 #828
	fadd %f5 %f5 %f6 #827
	fmul %f2 %f2 %f0 #829
	lw %a1 %a0 36 #406
	lw %f6 %a1 4 #411
	fmul %f2 %f2 %f6 #829
	fadd %f2 %f5 %f2 #827
	fmul %f0 %f0 %f1 #830
	lw %a1 %a0 36 #416
	lw %f1 %a1 8 #421
	fmul %f0 %f0 %f1 #830
	fadd %f0 %f2 %f0 #827
beq_cont.44420:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.44421 # nontail if
	li %f1 l.37441 #868
	fsub %f0 %f0 %f1 #868
	jal %zero beq_cont.44422 # then sentence ends
beq_else.44421:
beq_cont.44422:
	fmul %f1 %f4 %f4 #870
	fmul %f0 %f3 %f0 #870
	fsub %f0 %f1 %f0 #870
	fispos %a1 %f0 #872
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44423
	addi %a0 %zero 0 #878
	jalr %zero %ra 0 #878
beq_else.44423:
	sqrt %f0 %f0 #873
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44424 # nontail if
	fneg %f0 %f0 #874
	jal %zero beq_cont.44425 # then sentence ends
beq_else.44424:
beq_cont.44425:
	fsub %f0 %f0 %f4 #875
	fdiv %f0 %f0 %f3 #875
	sw %f0 %a2 0 #875
	addi %a0 %zero 1 #875
	jalr %zero %ra 0 #875
beq_else.44416:
	addi %a0 %zero 0 #861
	jalr %zero %ra 0 #861
solver.2652:
	lw %a3 %a11 8 #883
	lw %a4 %a11 4 #883
	slli %a0 %a0 2 #20
	add %a12 %a4 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %a2 0 #886
	lw %a4 %a0 20 #316
	lw %f1 %a4 0 #321
	fsub %f0 %f0 %f1 #886
	lw %f1 %a2 4 #886
	lw %a4 %a0 20 #326
	lw %f2 %a4 4 #331
	fsub %f1 %f1 %f2 #887
	lw %f2 %a2 8 #886
	lw %a2 %a0 20 #336
	lw %f3 %a2 8 #341
	fsub %f2 %f2 %f3 #888
	lw %a2 %a0 4 #238
	addi %a12 %zero 1
	bne %a2 %a12 beq_else.44426
	lw %f3 %a1 0 #783
	fiszero %a2 %f3 #783
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44427 # nontail if
	lw %a2 %a0 16 #306
	lw %a4 %a0 24 #258
	lw %f3 %a1 0 #783
	fisneg %a5 %f3 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44429 # nontail if
	addi %a4 %a5 0 #105
	jal %zero beq_cont.44430 # then sentence ends
beq_else.44429:
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.44431 # nontail if
	addi %a4 %zero 1 #105
	jal %zero beq_cont.44432 # then sentence ends
beq_else.44431:
	addi %a4 %zero 0 #105
beq_cont.44432:
beq_cont.44430:
	lw %f3 %a2 0 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44433 # nontail if
	fneg %f3 %f3 #118
	jal %zero beq_cont.44434 # then sentence ends
beq_else.44433:
beq_cont.44434:
	fsub %f3 %f3 %f0 #787
	lw %f4 %a1 0 #783
	fdiv %f3 %f3 %f4 #787
	lw %f4 %a1 4 #783
	fmul %f4 %f3 %f4 #788
	fadd %f4 %f4 %f1 #788
	fabs %f4 %f4 #788
	lw %f5 %a2 4 #785
	fless %a4 %f4 %f5 #788
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44435 # nontail if
	addi %a2 %zero 0 #792
	jal %zero beq_cont.44436 # then sentence ends
beq_else.44435:
	lw %f4 %a1 8 #783
	fmul %f4 %f3 %f4 #789
	fadd %f4 %f4 %f2 #789
	fabs %f4 %f4 #789
	lw %f5 %a2 8 #785
	fless %a2 %f4 %f5 #789
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44437 # nontail if
	addi %a2 %zero 0 #791
	jal %zero beq_cont.44438 # then sentence ends
beq_else.44437:
	sw %f3 %a3 0 #790
	addi %a2 %zero 1 #790
beq_cont.44438:
beq_cont.44436:
	jal %zero beq_cont.44428 # then sentence ends
beq_else.44427:
	addi %a2 %zero 0 #783
beq_cont.44428:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44439
	lw %f3 %a1 4 #783
	fiszero %a2 %f3 #783
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44440 # nontail if
	lw %a2 %a0 16 #306
	lw %a4 %a0 24 #258
	lw %f3 %a1 4 #783
	fisneg %a5 %f3 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44442 # nontail if
	addi %a4 %a5 0 #105
	jal %zero beq_cont.44443 # then sentence ends
beq_else.44442:
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.44444 # nontail if
	addi %a4 %zero 1 #105
	jal %zero beq_cont.44445 # then sentence ends
beq_else.44444:
	addi %a4 %zero 0 #105
beq_cont.44445:
beq_cont.44443:
	lw %f3 %a2 4 #785
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44446 # nontail if
	fneg %f3 %f3 #118
	jal %zero beq_cont.44447 # then sentence ends
beq_else.44446:
beq_cont.44447:
	fsub %f3 %f3 %f1 #787
	lw %f4 %a1 4 #783
	fdiv %f3 %f3 %f4 #787
	lw %f4 %a1 8 #783
	fmul %f4 %f3 %f4 #788
	fadd %f4 %f4 %f2 #788
	fabs %f4 %f4 #788
	lw %f5 %a2 8 #785
	fless %a4 %f4 %f5 #788
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44448 # nontail if
	addi %a2 %zero 0 #792
	jal %zero beq_cont.44449 # then sentence ends
beq_else.44448:
	lw %f4 %a1 0 #783
	fmul %f4 %f3 %f4 #789
	fadd %f4 %f4 %f0 #789
	fabs %f4 %f4 #789
	lw %f5 %a2 0 #785
	fless %a2 %f4 %f5 #789
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44450 # nontail if
	addi %a2 %zero 0 #791
	jal %zero beq_cont.44451 # then sentence ends
beq_else.44450:
	sw %f3 %a3 0 #790
	addi %a2 %zero 1 #790
beq_cont.44451:
beq_cont.44449:
	jal %zero beq_cont.44441 # then sentence ends
beq_else.44440:
	addi %a2 %zero 0 #783
beq_cont.44441:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44452
	lw %f3 %a1 8 #783
	fiszero %a2 %f3 #783
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44453 # nontail if
	lw %a2 %a0 16 #306
	lw %a0 %a0 24 #258
	lw %f3 %a1 8 #783
	fisneg %a4 %f3 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44455 # nontail if
	addi %a0 %a4 0 #105
	jal %zero beq_cont.44456 # then sentence ends
beq_else.44455:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44457 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.44458 # then sentence ends
beq_else.44457:
	addi %a0 %zero 0 #105
beq_cont.44458:
beq_cont.44456:
	lw %f3 %a2 8 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44459 # nontail if
	fneg %f3 %f3 #118
	jal %zero beq_cont.44460 # then sentence ends
beq_else.44459:
beq_cont.44460:
	fsub %f2 %f3 %f2 #787
	lw %f3 %a1 8 #783
	fdiv %f2 %f2 %f3 #787
	lw %f3 %a1 0 #783
	fmul %f3 %f2 %f3 #788
	fadd %f0 %f3 %f0 #788
	fabs %f0 %f0 #788
	lw %f3 %a2 0 #785
	fless %a0 %f0 %f3 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44461 # nontail if
	addi %a0 %zero 0 #792
	jal %zero beq_cont.44462 # then sentence ends
beq_else.44461:
	lw %f0 %a1 4 #783
	fmul %f0 %f2 %f0 #789
	fadd %f0 %f0 %f1 #789
	fabs %f0 %f0 #789
	lw %f1 %a2 4 #785
	fless %a0 %f0 %f1 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44463 # nontail if
	addi %a0 %zero 0 #791
	jal %zero beq_cont.44464 # then sentence ends
beq_else.44463:
	sw %f2 %a3 0 #790
	addi %a0 %zero 1 #790
beq_cont.44464:
beq_cont.44462:
	jal %zero beq_cont.44454 # then sentence ends
beq_else.44453:
	addi %a0 %zero 0 #783
beq_cont.44454:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44465
	addi %a0 %zero 0 #801
	jalr %zero %ra 0 #801
beq_else.44465:
	addi %a0 %zero 3 #800
	jalr %zero %ra 0 #800
beq_else.44452:
	addi %a0 %zero 2 #799
	jalr %zero %ra 0 #799
beq_else.44439:
	addi %a0 %zero 1 #798
	jalr %zero %ra 0 #798
beq_else.44426:
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.44466
	lw %a0 %a0 16 #306
	lw %f3 %a1 0 #181
	lw %f4 %a0 0 #181
	fmul %f3 %f3 %f4 #181
	lw %f4 %a1 4 #181
	lw %f5 %a0 4 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	lw %f4 %a1 8 #181
	lw %f5 %a0 8 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	fispos %a1 %f3 #811
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44467
	addi %a0 %zero 0 #814
	jalr %zero %ra 0 #814
beq_else.44467:
	lw %f4 %a0 0 #186
	fmul %f0 %f4 %f0 #186
	lw %f4 %a0 4 #186
	fmul %f1 %f4 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a0 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	fneg %f0 %f0 #812
	fdiv %f0 %f0 %f3 #812
	sw %f0 %a3 0 #812
	addi %a0 %zero 1 #813
	jalr %zero %ra 0 #813
beq_else.44466:
	lw %f3 %a1 0 #858
	lw %f4 %a1 4 #858
	lw %f5 %a1 8 #858
	fmul %f6 %f3 %f3 #822
	lw %a2 %a0 16 #276
	lw %f7 %a2 0 #281
	fmul %f6 %f6 %f7 #822
	fmul %f7 %f4 %f4 #822
	lw %a2 %a0 16 #286
	lw %f8 %a2 4 #291
	fmul %f7 %f7 %f8 #822
	fadd %f6 %f6 %f7 #822
	fmul %f7 %f5 %f5 #822
	lw %a2 %a0 16 #296
	lw %f8 %a2 8 #301
	fmul %f7 %f7 %f8 #822
	fadd %f6 %f6 %f7 #822
	lw %a2 %a0 12 #267
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44468 # nontail if
	fadd %f3 %f6 %fzero #822
	jal %zero beq_cont.44469 # then sentence ends
beq_else.44468:
	fmul %f7 %f4 %f5 #828
	lw %a2 %a0 36 #396
	lw %f8 %a2 0 #401
	fmul %f7 %f7 %f8 #828
	fadd %f6 %f6 %f7 #827
	fmul %f5 %f5 %f3 #829
	lw %a2 %a0 36 #406
	lw %f7 %a2 4 #411
	fmul %f5 %f5 %f7 #829
	fadd %f5 %f6 %f5 #827
	fmul %f3 %f3 %f4 #830
	lw %a2 %a0 36 #416
	lw %f4 %a2 8 #421
	fmul %f3 %f3 %f4 #830
	fadd %f3 %f5 %f3 #827
beq_cont.44469:
	fiszero %a2 %f3 #860
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44470
	lw %f4 %a1 0 #858
	lw %f5 %a1 4 #858
	lw %f6 %a1 8 #858
	fmul %f7 %f4 %f0 #837
	lw %a1 %a0 16 #276
	lw %f8 %a1 0 #281
	fmul %f7 %f7 %f8 #837
	fmul %f8 %f5 %f1 #838
	lw %a1 %a0 16 #286
	lw %f9 %a1 4 #291
	fmul %f8 %f8 %f9 #838
	fadd %f7 %f7 %f8 #837
	fmul %f8 %f6 %f2 #839
	lw %a1 %a0 16 #296
	lw %f9 %a1 8 #301
	fmul %f8 %f8 %f9 #839
	fadd %f7 %f7 %f8 #837
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44471 # nontail if
	fadd %f4 %f7 %fzero #837
	jal %zero beq_cont.44472 # then sentence ends
beq_else.44471:
	fmul %f8 %f6 %f1 #845
	fmul %f9 %f5 %f2 #845
	fadd %f8 %f8 %f9 #845
	lw %a1 %a0 36 #396
	lw %f9 %a1 0 #401
	fmul %f8 %f8 %f9 #845
	fmul %f9 %f4 %f2 #846
	fmul %f6 %f6 %f0 #846
	fadd %f6 %f9 %f6 #846
	lw %a1 %a0 36 #406
	lw %f9 %a1 4 #411
	fmul %f6 %f6 %f9 #846
	fadd %f6 %f8 %f6 #845
	fmul %f4 %f4 %f1 #847
	fmul %f5 %f5 %f0 #847
	fadd %f4 %f4 %f5 #847
	lw %a1 %a0 36 #416
	lw %f5 %a1 8 #421
	fmul %f4 %f4 %f5 #847
	fadd %f4 %f6 %f4 #845
	fhalf %f4 %f4 #844
	fadd %f4 %f7 %f4 #844
beq_cont.44472:
	fmul %f5 %f0 %f0 #822
	lw %a1 %a0 16 #276
	lw %f6 %a1 0 #281
	fmul %f5 %f5 %f6 #822
	fmul %f6 %f1 %f1 #822
	lw %a1 %a0 16 #286
	lw %f7 %a1 4 #291
	fmul %f6 %f6 %f7 #822
	fadd %f5 %f5 %f6 #822
	fmul %f6 %f2 %f2 #822
	lw %a1 %a0 16 #296
	lw %f7 %a1 8 #301
	fmul %f6 %f6 %f7 #822
	fadd %f5 %f5 %f6 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44473 # nontail if
	fadd %f0 %f5 %fzero #822
	jal %zero beq_cont.44474 # then sentence ends
beq_else.44473:
	fmul %f6 %f1 %f2 #828
	lw %a1 %a0 36 #396
	lw %f7 %a1 0 #401
	fmul %f6 %f6 %f7 #828
	fadd %f5 %f5 %f6 #827
	fmul %f2 %f2 %f0 #829
	lw %a1 %a0 36 #406
	lw %f6 %a1 4 #411
	fmul %f2 %f2 %f6 #829
	fadd %f2 %f5 %f2 #827
	fmul %f0 %f0 %f1 #830
	lw %a1 %a0 36 #416
	lw %f1 %a1 8 #421
	fmul %f0 %f0 %f1 #830
	fadd %f0 %f2 %f0 #827
beq_cont.44474:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.44475 # nontail if
	li %f1 l.37441 #868
	fsub %f0 %f0 %f1 #868
	jal %zero beq_cont.44476 # then sentence ends
beq_else.44475:
beq_cont.44476:
	fmul %f1 %f4 %f4 #870
	fmul %f0 %f3 %f0 #870
	fsub %f0 %f1 %f0 #870
	fispos %a1 %f0 #872
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44477
	addi %a0 %zero 0 #878
	jalr %zero %ra 0 #878
beq_else.44477:
	sqrt %f0 %f0 #873
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44478 # nontail if
	fneg %f0 %f0 #874
	jal %zero beq_cont.44479 # then sentence ends
beq_else.44478:
beq_cont.44479:
	fsub %f0 %f0 %f4 #875
	fdiv %f0 %f0 %f3 #875
	sw %f0 %a3 0 #875
	addi %a0 %zero 1 #875
	jalr %zero %ra 0 #875
beq_else.44470:
	addi %a0 %zero 0 #861
	jalr %zero %ra 0 #861
solver_rect_fast.2656:
	lw %a3 %a11 4 #900
	lw %f3 %a2 0 #901
	fsub %f3 %f3 %f0 #901
	lw %f4 %a2 4 #901
	fmul %f3 %f3 %f4 #901
	lw %f4 %a1 4 #903
	fmul %f4 %f3 %f4 #903
	fadd %f4 %f4 %f1 #903
	fabs %f4 %f4 #903
	lw %a4 %a0 16 #286
	lw %f5 %a4 4 #291
	fless %a4 %f4 %f5 #903
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44480 # nontail if
	addi %a4 %zero 0 #907
	jal %zero beq_cont.44481 # then sentence ends
beq_else.44480:
	lw %f4 %a1 8 #903
	fmul %f4 %f3 %f4 #904
	fadd %f4 %f4 %f2 #904
	fabs %f4 %f4 #904
	lw %a4 %a0 16 #296
	lw %f5 %a4 8 #301
	fless %a4 %f4 %f5 #904
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44482 # nontail if
	addi %a4 %zero 0 #906
	jal %zero beq_cont.44483 # then sentence ends
beq_else.44482:
	lw %f4 %a2 4 #901
	fiszero %a4 %f4 #905
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44484 # nontail if
	addi %a4 %zero 1 #905
	jal %zero beq_cont.44485 # then sentence ends
beq_else.44484:
	addi %a4 %zero 0 #905
beq_cont.44485:
beq_cont.44483:
beq_cont.44481:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44486
	lw %f3 %a2 8 #901
	fsub %f3 %f3 %f1 #910
	lw %f4 %a2 12 #901
	fmul %f3 %f3 %f4 #910
	lw %f4 %a1 0 #903
	fmul %f4 %f3 %f4 #912
	fadd %f4 %f4 %f0 #912
	fabs %f4 %f4 #912
	lw %a4 %a0 16 #276
	lw %f5 %a4 0 #281
	fless %a4 %f4 %f5 #912
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44487 # nontail if
	addi %a4 %zero 0 #916
	jal %zero beq_cont.44488 # then sentence ends
beq_else.44487:
	lw %f4 %a1 8 #903
	fmul %f4 %f3 %f4 #913
	fadd %f4 %f4 %f2 #913
	fabs %f4 %f4 #913
	lw %a4 %a0 16 #296
	lw %f5 %a4 8 #301
	fless %a4 %f4 %f5 #913
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44489 # nontail if
	addi %a4 %zero 0 #915
	jal %zero beq_cont.44490 # then sentence ends
beq_else.44489:
	lw %f4 %a2 12 #901
	fiszero %a4 %f4 #914
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44491 # nontail if
	addi %a4 %zero 1 #914
	jal %zero beq_cont.44492 # then sentence ends
beq_else.44491:
	addi %a4 %zero 0 #914
beq_cont.44492:
beq_cont.44490:
beq_cont.44488:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44493
	lw %f3 %a2 16 #901
	fsub %f2 %f3 %f2 #919
	lw %f3 %a2 20 #901
	fmul %f2 %f2 %f3 #919
	lw %f3 %a1 0 #903
	fmul %f3 %f2 %f3 #921
	fadd %f0 %f3 %f0 #921
	fabs %f0 %f0 #921
	lw %a4 %a0 16 #276
	lw %f3 %a4 0 #281
	fless %a4 %f0 %f3 #921
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44494 # nontail if
	addi %a0 %zero 0 #925
	jal %zero beq_cont.44495 # then sentence ends
beq_else.44494:
	lw %f0 %a1 4 #903
	fmul %f0 %f2 %f0 #922
	fadd %f0 %f0 %f1 #922
	fabs %f0 %f0 #922
	lw %a0 %a0 16 #286
	lw %f1 %a0 4 #291
	fless %a0 %f0 %f1 #922
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44496 # nontail if
	addi %a0 %zero 0 #924
	jal %zero beq_cont.44497 # then sentence ends
beq_else.44496:
	lw %f0 %a2 20 #901
	fiszero %a0 %f0 #923
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44498 # nontail if
	addi %a0 %zero 1 #923
	jal %zero beq_cont.44499 # then sentence ends
beq_else.44498:
	addi %a0 %zero 0 #923
beq_cont.44499:
beq_cont.44497:
beq_cont.44495:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44500
	addi %a0 %zero 0 #929
	jalr %zero %ra 0 #929
beq_else.44500:
	sw %f2 %a3 0 #927
	addi %a0 %zero 3 #927
	jalr %zero %ra 0 #927
beq_else.44493:
	sw %f3 %a3 0 #918
	addi %a0 %zero 2 #918
	jalr %zero %ra 0 #918
beq_else.44486:
	sw %f3 %a3 0 #909
	addi %a0 %zero 1 #909
	jalr %zero %ra 0 #909
solver_second_fast.2669:
	lw %a2 %a11 4 #942
	lw %f3 %a1 0 #944
	fiszero %a3 %f3 #945
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44501
	lw %f4 %a1 4 #944
	fmul %f4 %f4 %f0 #948
	lw %f5 %a1 8 #944
	fmul %f5 %f5 %f1 #948
	fadd %f4 %f4 %f5 #948
	lw %f5 %a1 12 #944
	fmul %f5 %f5 %f2 #948
	fadd %f4 %f4 %f5 #948
	fmul %f5 %f0 %f0 #822
	lw %a3 %a0 16 #276
	lw %f6 %a3 0 #281
	fmul %f5 %f5 %f6 #822
	fmul %f6 %f1 %f1 #822
	lw %a3 %a0 16 #286
	lw %f7 %a3 4 #291
	fmul %f6 %f6 %f7 #822
	fadd %f5 %f5 %f6 #822
	fmul %f6 %f2 %f2 #822
	lw %a3 %a0 16 #296
	lw %f7 %a3 8 #301
	fmul %f6 %f6 %f7 #822
	fadd %f5 %f5 %f6 #822
	lw %a3 %a0 12 #267
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44502 # nontail if
	fadd %f0 %f5 %fzero #822
	jal %zero beq_cont.44503 # then sentence ends
beq_else.44502:
	fmul %f6 %f1 %f2 #828
	lw %a3 %a0 36 #396
	lw %f7 %a3 0 #401
	fmul %f6 %f6 %f7 #828
	fadd %f5 %f5 %f6 #827
	fmul %f2 %f2 %f0 #829
	lw %a3 %a0 36 #406
	lw %f6 %a3 4 #411
	fmul %f2 %f2 %f6 #829
	fadd %f2 %f5 %f2 #827
	fmul %f0 %f0 %f1 #830
	lw %a3 %a0 36 #416
	lw %f1 %a3 8 #421
	fmul %f0 %f0 %f1 #830
	fadd %f0 %f2 %f0 #827
beq_cont.44503:
	lw %a3 %a0 4 #238
	addi %a12 %zero 3
	bne %a3 %a12 beq_else.44504 # nontail if
	li %f1 l.37441 #950
	fsub %f0 %f0 %f1 #950
	jal %zero beq_cont.44505 # then sentence ends
beq_else.44504:
beq_cont.44505:
	fmul %f1 %f4 %f4 #951
	fmul %f0 %f3 %f0 #951
	fsub %f0 %f1 %f0 #951
	fispos %a3 %f0 #952
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44506
	addi %a0 %zero 0 #958
	jalr %zero %ra 0 #958
beq_else.44506:
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44507 # nontail if
	sqrt %f0 %f0 #956
	fsub %f0 %f4 %f0 #956
	lw %f1 %a1 16 #944
	fmul %f0 %f0 %f1 #956
	sw %f0 %a2 0 #956
	jal %zero beq_cont.44508 # then sentence ends
beq_else.44507:
	sqrt %f0 %f0 #954
	fadd %f0 %f4 %f0 #954
	lw %f1 %a1 16 #944
	fmul %f0 %f0 %f1 #954
	sw %f0 %a2 0 #954
beq_cont.44508:
	addi %a0 %zero 1 #957
	jalr %zero %ra 0 #957
beq_else.44501:
	addi %a0 %zero 0 #946
	jalr %zero %ra 0 #946
solver_fast2.2693:
	lw %a2 %a11 12 #1009
	lw %a3 %a11 8 #1009
	lw %a4 %a11 4 #1009
	slli %a5 %a0 2 #20
	add %a12 %a4 %a5 #20
	lw %a4 %a12 0 #20
	lw %a5 %a4 40 #427
	lw %f0 %a5 0 #19
	lw %f1 %a5 4 #19
	lw %f2 %a5 8 #19
	lw %a6 %a1 4 #513
	slli %a0 %a0 2 #968
	add %a12 %a6 %a0 #968
	lw %a0 %a12 0 #968
	lw %a6 %a4 4 #238
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.44509
	lw %a1 %a1 0 #507
	add %a11 %a2 %zero
	add %a2 %a0 %zero
	add %a0 %a4 %zero
	lw %a10 %a11 0 #1019
	jalr %zero %a10 0 #1019
beq_else.44509:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.44510
	lw %f0 %a0 0 #983
	fisneg %a1 %f0 #983
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44511
	addi %a0 %zero 0 #986
	jalr %zero %ra 0 #986
beq_else.44511:
	lw %f0 %a0 0 #983
	lw %f1 %a5 12 #984
	fmul %f0 %f0 %f1 #984
	sw %f0 %a3 0 #984
	addi %a0 %zero 1 #985
	jalr %zero %ra 0 #985
beq_else.44510:
	lw %f3 %a0 0 #992
	fiszero %a1 %f3 #993
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44512
	lw %f4 %a0 4 #992
	fmul %f0 %f4 %f0 #996
	lw %f4 %a0 8 #992
	fmul %f1 %f4 %f1 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a0 12 #992
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a5 12 #997
	fmul %f2 %f0 %f0 #998
	fmul %f1 %f3 %f1 #998
	fsub %f1 %f2 %f1 #998
	fispos %a1 %f1 #999
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44513
	addi %a0 %zero 0 #1005
	jalr %zero %ra 0 #1005
beq_else.44513:
	lw %a1 %a4 24 #258
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44514 # nontail if
	sqrt %f1 %f1 #1003
	fsub %f0 %f0 %f1 #1003
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1003
	sw %f0 %a3 0 #1003
	jal %zero beq_cont.44515 # then sentence ends
beq_else.44514:
	sqrt %f1 %f1 #1001
	fadd %f0 %f0 %f1 #1001
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1001
	sw %f0 %a3 0 #1001
beq_cont.44515:
	addi %a0 %zero 1 #1004
	jalr %zero %ra 0 #1004
beq_else.44512:
	addi %a0 %zero 0 #994
	jalr %zero %ra 0 #994
setup_rect_table.2696:
	addi %a2 %zero 6 #1030
	li %f0 l.37367 #1030
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
	fiszero %a2 %f0 #1032
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44516 # nontail if
	lw %a2 %sp 0 #258
	lw %a3 %a2 24 #258
	lw %f0 %a1 0 #1032
	fisneg %a4 %f0 #1036
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44518 # nontail if
	addi %a3 %a4 0 #105
	jal %zero beq_cont.44519 # then sentence ends
beq_else.44518:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44520 # nontail if
	addi %a3 %zero 1 #105
	jal %zero beq_cont.44521 # then sentence ends
beq_else.44520:
	addi %a3 %zero 0 #105
beq_cont.44521:
beq_cont.44519:
	lw %a4 %a2 16 #276
	lw %f0 %a4 0 #281
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44522 # nontail if
	fneg %f0 %f0 #118
	jal %zero beq_cont.44523 # then sentence ends
beq_else.44522:
beq_cont.44523:
	sw %f0 %a0 0 #1036
	li %f0 l.37441 #1038
	lw %f1 %a1 0 #1032
	fdiv %f0 %f0 %f1 #1038
	sw %f0 %a0 4 #1038
	jal %zero beq_cont.44517 # then sentence ends
beq_else.44516:
	li %f0 l.37367 #1033
	sw %f0 %a0 4 #1033
beq_cont.44517:
	lw %f0 %a1 4 #1032
	fiszero %a2 %f0 #1040
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44524 # nontail if
	lw %a2 %sp 0 #258
	lw %a3 %a2 24 #258
	lw %f0 %a1 4 #1032
	fisneg %a4 %f0 #1043
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44526 # nontail if
	addi %a3 %a4 0 #105
	jal %zero beq_cont.44527 # then sentence ends
beq_else.44526:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44528 # nontail if
	addi %a3 %zero 1 #105
	jal %zero beq_cont.44529 # then sentence ends
beq_else.44528:
	addi %a3 %zero 0 #105
beq_cont.44529:
beq_cont.44527:
	lw %a4 %a2 16 #286
	lw %f0 %a4 4 #291
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44530 # nontail if
	fneg %f0 %f0 #118
	jal %zero beq_cont.44531 # then sentence ends
beq_else.44530:
beq_cont.44531:
	sw %f0 %a0 8 #1043
	li %f0 l.37441 #1044
	lw %f1 %a1 4 #1032
	fdiv %f0 %f0 %f1 #1044
	sw %f0 %a0 12 #1044
	jal %zero beq_cont.44525 # then sentence ends
beq_else.44524:
	li %f0 l.37367 #1041
	sw %f0 %a0 12 #1041
beq_cont.44525:
	lw %f0 %a1 8 #1032
	fiszero %a2 %f0 #1046
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44532 # nontail if
	lw %a2 %sp 0 #258
	lw %a3 %a2 24 #258
	lw %f0 %a1 8 #1032
	fisneg %a4 %f0 #1049
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44534 # nontail if
	addi %a3 %a4 0 #105
	jal %zero beq_cont.44535 # then sentence ends
beq_else.44534:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44536 # nontail if
	addi %a3 %zero 1 #105
	jal %zero beq_cont.44537 # then sentence ends
beq_else.44536:
	addi %a3 %zero 0 #105
beq_cont.44537:
beq_cont.44535:
	lw %a2 %a2 16 #296
	lw %f0 %a2 8 #301
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44538 # nontail if
	fneg %f0 %f0 #118
	jal %zero beq_cont.44539 # then sentence ends
beq_else.44538:
beq_cont.44539:
	sw %f0 %a0 16 #1049
	li %f0 l.37441 #1050
	lw %f1 %a1 8 #1032
	fdiv %f0 %f0 %f1 #1050
	sw %f0 %a0 20 #1050
	jal %zero beq_cont.44533 # then sentence ends
beq_else.44532:
	li %f0 l.37367 #1047
	sw %f0 %a0 20 #1047
beq_cont.44533:
	jalr %zero %ra 0 #1052
setup_surface_table.2699:
	addi %a2 %zero 4 #1057
	li %f0 l.37367 #1057
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
	lw %a2 %sp 0 #276
	lw %a3 %a2 16 #276
	lw %f1 %a3 0 #281
	fmul %f0 %f0 %f1 #1059
	lw %f1 %a1 4 #1059
	lw %a3 %a2 16 #286
	lw %f2 %a3 4 #291
	fmul %f1 %f1 %f2 #1059
	fadd %f0 %f0 %f1 #1059
	lw %f1 %a1 8 #1059
	lw %a1 %a2 16 #296
	lw %f2 %a1 8 #301
	fmul %f1 %f1 %f2 #1059
	fadd %f0 %f0 %f1 #1059
	fispos %a1 %f0 #1061
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44540 # nontail if
	li %f0 l.37367 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.44541 # then sentence ends
beq_else.44540:
	li %f1 l.37443 #1063
	fdiv %f1 %f1 %f0 #1063
	sw %f1 %a0 0 #1063
	lw %a1 %a2 16 #276
	lw %f1 %a1 0 #281
	fdiv %f1 %f1 %f0 #1065
	fneg %f1 %f1 #1065
	sw %f1 %a0 4 #1065
	lw %a1 %a2 16 #286
	lw %f1 %a1 4 #291
	fdiv %f1 %f1 %f0 #1066
	fneg %f1 %f1 #1066
	sw %f1 %a0 8 #1066
	lw %a1 %a2 16 #296
	lw %f1 %a1 8 #301
	fdiv %f0 %f1 %f0 #1067
	fneg %f0 %f0 #1067
	sw %f0 %a0 12 #1067
beq_cont.44541:
	jalr %zero %ra 0 #1070
setup_second_table.2702:
	addi %a2 %zero 5 #1076
	li %f0 l.37367 #1076
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
	fmul %f3 %f0 %f0 #822
	lw %a2 %sp 0 #276
	lw %a3 %a2 16 #276
	lw %f4 %a3 0 #281
	fmul %f3 %f3 %f4 #822
	fmul %f4 %f1 %f1 #822
	lw %a3 %a2 16 #286
	lw %f5 %a3 4 #291
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	fmul %f4 %f2 %f2 #822
	lw %a3 %a2 16 #296
	lw %f5 %a3 8 #301
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	lw %a3 %a2 12 #267
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44542 # nontail if
	fadd %f0 %f3 %fzero #822
	jal %zero beq_cont.44543 # then sentence ends
beq_else.44542:
	fmul %f4 %f1 %f2 #828
	lw %a3 %a2 36 #396
	lw %f5 %a3 0 #401
	fmul %f4 %f4 %f5 #828
	fadd %f3 %f3 %f4 #827
	fmul %f2 %f2 %f0 #829
	lw %a3 %a2 36 #406
	lw %f4 %a3 4 #411
	fmul %f2 %f2 %f4 #829
	fadd %f2 %f3 %f2 #827
	fmul %f0 %f0 %f1 #830
	lw %a3 %a2 36 #416
	lw %f1 %a3 8 #421
	fmul %f0 %f0 %f1 #830
	fadd %f0 %f2 %f0 #827
beq_cont.44543:
	lw %f1 %a1 0 #1078
	lw %a3 %a2 16 #276
	lw %f2 %a3 0 #281
	fmul %f1 %f1 %f2 #1079
	fneg %f1 %f1 #1079
	lw %f2 %a1 4 #1078
	lw %a3 %a2 16 #286
	lw %f3 %a3 4 #291
	fmul %f2 %f2 %f3 #1080
	fneg %f2 %f2 #1080
	lw %f3 %a1 8 #1078
	lw %a3 %a2 16 #296
	lw %f4 %a3 8 #301
	fmul %f3 %f3 %f4 #1081
	fneg %f3 %f3 #1081
	sw %f0 %a0 0 #1083
	lw %a3 %a2 12 #267
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44544 # nontail if
	sw %f1 %a0 4 #1091
	sw %f2 %a0 8 #1092
	sw %f3 %a0 12 #1093
	jal %zero beq_cont.44545 # then sentence ends
beq_else.44544:
	lw %f4 %a1 8 #1078
	lw %a3 %a2 36 #406
	lw %f5 %a3 4 #411
	fmul %f4 %f4 %f5 #1087
	lw %f5 %a1 4 #1078
	lw %a3 %a2 36 #416
	lw %f6 %a3 8 #421
	fmul %f5 %f5 %f6 #1087
	fadd %f4 %f4 %f5 #1087
	fhalf %f4 %f4 #1087
	fsub %f1 %f1 %f4 #1087
	sw %f1 %a0 4 #1087
	lw %f1 %a1 8 #1078
	lw %a3 %a2 36 #396
	lw %f4 %a3 0 #401
	fmul %f1 %f1 %f4 #1088
	lw %f4 %a1 0 #1078
	lw %a3 %a2 36 #416
	lw %f5 %a3 8 #421
	fmul %f4 %f4 %f5 #1088
	fadd %f1 %f1 %f4 #1088
	fhalf %f1 %f1 #1088
	fsub %f1 %f2 %f1 #1088
	sw %f1 %a0 8 #1088
	lw %f1 %a1 4 #1078
	lw %a3 %a2 36 #396
	lw %f2 %a3 0 #401
	fmul %f1 %f1 %f2 #1089
	lw %f2 %a1 0 #1078
	lw %a1 %a2 36 #406
	lw %f4 %a1 4 #411
	fmul %f2 %f2 %f4 #1089
	fadd %f1 %f1 %f2 #1089
	fhalf %f1 %f1 #1089
	fsub %f1 %f3 %f1 #1089
	sw %f1 %a0 12 #1089
beq_cont.44545:
	fiszero %a1 %f0 #1095
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44546 # nontail if
	li %f1 l.37441 #1096
	fdiv %f0 %f1 %f0 #1096
	sw %f0 %a0 16 #1096
	jal %zero beq_cont.44547 # then sentence ends
beq_else.44546:
beq_cont.44547:
	jalr %zero %ra 0 #1098
iter_setup_dirvec_constants.2705:
	lw %a2 %a11 4 #1103
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.44548
	slli %a3 %a1 2 #20
	add %a12 %a2 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %a0 4 #513
	lw %a5 %a0 0 #507
	lw %a6 %a3 4 #238
	sw %a11 %sp 0 #868
	sw %a0 %sp 4 #868
	sw %a2 %sp 8 #868
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.44549 # nontail if
	sw %a4 %sp 12 #1110
	sw %a1 %sp 16 #1110
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 20 #1110 call dir
	addi %sp %sp 24 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -24 #1110
	lw %ra %sp 20 #1110
	lw %a1 %sp 16 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 12 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.44550 # then sentence ends
beq_else.44549:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.44551 # nontail if
	addi %a6 %zero 4 #1057
	li %f0 l.37367 #1057
	sw %a4 %sp 12 #1057
	sw %a1 %sp 16 #1057
	sw %a3 %sp 20 #1057
	sw %a5 %sp 24 #1057
	add %a0 %a6 %zero
	sw %ra %sp 28 #1057 call dir
	addi %sp %sp 32 #1057	
	jal %ra min_caml_create_float_array #1057
	addi %sp %sp -32 #1057
	lw %ra %sp 28 #1057
	lw %a1 %sp 24 #1059
	lw %f0 %a1 0 #1059
	lw %a2 %sp 20 #276
	lw %a3 %a2 16 #276
	lw %f1 %a3 0 #281
	fmul %f0 %f0 %f1 #1059
	lw %f1 %a1 4 #1059
	lw %a3 %a2 16 #286
	lw %f2 %a3 4 #291
	fmul %f1 %f1 %f2 #1059
	fadd %f0 %f0 %f1 #1059
	lw %f1 %a1 8 #1059
	lw %a1 %a2 16 #296
	lw %f2 %a1 8 #301
	fmul %f1 %f1 %f2 #1059
	fadd %f0 %f0 %f1 #1059
	fispos %a1 %f0 #1061
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44553 # nontail if
	li %f0 l.37367 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.44554 # then sentence ends
beq_else.44553:
	li %f1 l.37443 #1063
	fdiv %f1 %f1 %f0 #1063
	sw %f1 %a0 0 #1063
	lw %a1 %a2 16 #276
	lw %f1 %a1 0 #281
	fdiv %f1 %f1 %f0 #1065
	fneg %f1 %f1 #1065
	sw %f1 %a0 4 #1065
	lw %a1 %a2 16 #286
	lw %f1 %a1 4 #291
	fdiv %f1 %f1 %f0 #1066
	fneg %f1 %f1 #1066
	sw %f1 %a0 8 #1066
	lw %a1 %a2 16 #296
	lw %f1 %a1 8 #301
	fdiv %f0 %f1 %f0 #1067
	fneg %f0 %f0 #1067
	sw %f0 %a0 12 #1067
beq_cont.44554:
	lw %a1 %sp 16 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 12 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.44552 # then sentence ends
beq_else.44551:
	sw %a4 %sp 12 #1114
	sw %a1 %sp 16 #1114
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 28 #1114 call dir
	addi %sp %sp 32 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -32 #1114
	lw %ra %sp 28 #1114
	lw %a1 %sp 16 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 12 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.44552:
beq_cont.44550:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.44555
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a2 %sp 4 #513
	lw %a3 %a2 4 #513
	lw %a4 %a2 0 #507
	lw %a5 %a1 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.44556 # nontail if
	sw %a3 %sp 28 #1110
	sw %a0 %sp 32 #1110
	add %a0 %a4 %zero
	sw %ra %sp 36 #1110 call dir
	addi %sp %sp 40 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -40 #1110
	lw %ra %sp 36 #1110
	lw %a1 %sp 32 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 28 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.44557 # then sentence ends
beq_else.44556:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.44558 # nontail if
	sw %a3 %sp 28 #1112
	sw %a0 %sp 32 #1112
	add %a0 %a4 %zero
	sw %ra %sp 36 #1112 call dir
	addi %sp %sp 40 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -40 #1112
	lw %ra %sp 36 #1112
	lw %a1 %sp 32 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 28 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.44559 # then sentence ends
beq_else.44558:
	sw %a3 %sp 28 #1114
	sw %a0 %sp 32 #1114
	add %a0 %a4 %zero
	sw %ra %sp 36 #1114 call dir
	addi %sp %sp 40 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -40 #1114
	lw %ra %sp 36 #1114
	lw %a1 %sp 32 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 28 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.44559:
beq_cont.44557:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 4 #1116
	lw %a11 %sp 0 #1116
	lw %a10 %a11 0 #1116
	jalr %zero %a10 0 #1116
bge_else.44555:
	jalr %zero %ra 0 #1117
bge_else.44548:
	jalr %zero %ra 0 #1117
setup_startp_constants.2710:
	lw %a2 %a11 4 #1126
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.44562
	slli %a3 %a1 2 #20
	add %a12 %a2 %a3 #20
	lw %a2 %a12 0 #20
	lw %a3 %a2 40 #427
	lw %a4 %a2 4 #238
	lw %f0 %a0 0 #1131
	lw %a5 %a2 20 #316
	lw %f1 %a5 0 #321
	fsub %f0 %f0 %f1 #1131
	sw %f0 %a3 0 #1131
	lw %f0 %a0 4 #1131
	lw %a5 %a2 20 #326
	lw %f1 %a5 4 #331
	fsub %f0 %f0 %f1 #1132
	sw %f0 %a3 4 #1132
	lw %f0 %a0 8 #1131
	lw %a5 %a2 20 #336
	lw %f1 %a5 8 #341
	fsub %f0 %f0 %f1 #1133
	sw %f0 %a3 8 #1133
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.44563 # nontail if
	lw %a2 %a2 16 #306
	lw %f0 %a3 0 #19
	lw %f1 %a3 4 #19
	lw %f2 %a3 8 #19
	lw %f3 %a2 0 #186
	fmul %f0 %f3 %f0 #186
	lw %f3 %a2 4 #186
	fmul %f1 %f3 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a2 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	sw %f0 %a3 12 #1135
	jal %zero beq_cont.44564 # then sentence ends
beq_else.44563:
	addi %a12 %zero 2
	blt %a12 %a4 bge_else.44565 # nontail if
	jal %zero bge_cont.44566 # then sentence ends
bge_else.44565:
	lw %f0 %a3 0 #19
	lw %f1 %a3 4 #19
	lw %f2 %a3 8 #19
	fmul %f3 %f0 %f0 #822
	lw %a5 %a2 16 #276
	lw %f4 %a5 0 #281
	fmul %f3 %f3 %f4 #822
	fmul %f4 %f1 %f1 #822
	lw %a5 %a2 16 #286
	lw %f5 %a5 4 #291
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	fmul %f4 %f2 %f2 #822
	lw %a5 %a2 16 #296
	lw %f5 %a5 8 #301
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	lw %a5 %a2 12 #267
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.44567 # nontail if
	fadd %f0 %f3 %fzero #822
	jal %zero beq_cont.44568 # then sentence ends
beq_else.44567:
	fmul %f4 %f1 %f2 #828
	lw %a5 %a2 36 #396
	lw %f5 %a5 0 #401
	fmul %f4 %f4 %f5 #828
	fadd %f3 %f3 %f4 #827
	fmul %f2 %f2 %f0 #829
	lw %a5 %a2 36 #406
	lw %f4 %a5 4 #411
	fmul %f2 %f2 %f4 #829
	fadd %f2 %f3 %f2 #827
	fmul %f0 %f0 %f1 #830
	lw %a2 %a2 36 #416
	lw %f1 %a2 8 #421
	fmul %f0 %f0 %f1 #830
	fadd %f0 %f2 %f0 #827
beq_cont.44568:
	addi %a12 %zero 3
	bne %a4 %a12 beq_else.44569 # nontail if
	li %f1 l.37441 #1139
	fsub %f0 %f0 %f1 #1139
	jal %zero beq_cont.44570 # then sentence ends
beq_else.44569:
beq_cont.44570:
	sw %f0 %a3 12 #1139
bge_cont.44566:
beq_cont.44564:
	addi %a1 %a1 -1 #1141
	lw %a10 %a11 0 #1141
	jalr %zero %a10 0 #1141
bge_else.44562:
	jalr %zero %ra 0 #1142
is_second_outside.2725:
	fmul %f3 %f0 %f0 #822
	lw %a1 %a0 16 #276
	lw %f4 %a1 0 #281
	fmul %f3 %f3 %f4 #822
	fmul %f4 %f1 %f1 #822
	lw %a1 %a0 16 #286
	lw %f5 %a1 4 #291
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	fmul %f4 %f2 %f2 #822
	lw %a1 %a0 16 #296
	lw %f5 %a1 8 #301
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44572 # nontail if
	fadd %f0 %f3 %fzero #822
	jal %zero beq_cont.44573 # then sentence ends
beq_else.44572:
	fmul %f4 %f1 %f2 #828
	lw %a1 %a0 36 #396
	lw %f5 %a1 0 #401
	fmul %f4 %f4 %f5 #828
	fadd %f3 %f3 %f4 #827
	fmul %f2 %f2 %f0 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f2 %f2 %f4 #829
	fadd %f2 %f3 %f2 #827
	fmul %f0 %f0 %f1 #830
	lw %a1 %a0 36 #416
	lw %f1 %a1 8 #421
	fmul %f0 %f0 %f1 #830
	fadd %f0 %f2 %f0 #827
beq_cont.44573:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.44574 # nontail if
	li %f1 l.37441 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.44575 # then sentence ends
beq_else.44574:
beq_cont.44575:
	lw %a0 %a0 24 #258
	fisneg %a1 %f0 #1175
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44576 # nontail if
	addi %a0 %a1 0 #105
	jal %zero beq_cont.44577 # then sentence ends
beq_else.44576:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44578 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.44579 # then sentence ends
beq_else.44578:
	addi %a0 %zero 0 #105
beq_cont.44579:
beq_cont.44577:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44580
	addi %a0 %zero 1 #1175
	jalr %zero %ra 0 #1175
beq_else.44580:
	addi %a0 %zero 0 #1175
	jalr %zero %ra 0 #1175
is_outside.2730:
	lw %a1 %a0 20 #316
	lw %f3 %a1 0 #321
	fsub %f0 %f0 %f3 #1180
	lw %a1 %a0 20 #326
	lw %f3 %a1 4 #331
	fsub %f1 %f1 %f3 #1181
	lw %a1 %a0 20 #336
	lw %f3 %a1 8 #341
	fsub %f2 %f2 %f3 #1182
	lw %a1 %a0 4 #238
	addi %a12 %zero 1
	bne %a1 %a12 beq_else.44581
	fabs %f0 %f0 #1157
	lw %a1 %a0 16 #276
	lw %f3 %a1 0 #281
	fless %a1 %f0 %f3 #1157
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44582 # nontail if
	addi %a1 %zero 0 #1161
	jal %zero beq_cont.44583 # then sentence ends
beq_else.44582:
	fabs %f0 %f1 #1158
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fless %a1 %f0 %f1 #1158
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44584 # nontail if
	addi %a1 %zero 0 #1160
	jal %zero beq_cont.44585 # then sentence ends
beq_else.44584:
	fabs %f0 %f2 #1159
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fless %a1 %f0 %f1 #1159
beq_cont.44585:
beq_cont.44583:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44586
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44587
	addi %a0 %zero 1 #1162
	jalr %zero %ra 0 #1162
beq_else.44587:
	addi %a0 %zero 0 #1162
	jalr %zero %ra 0 #1162
beq_else.44586:
	lw %a0 %a0 24 #258
	jalr %zero %ra 0 #262
beq_else.44581:
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.44588
	lw %a1 %a0 16 #306
	lw %f3 %a1 0 #186
	fmul %f0 %f3 %f0 #186
	lw %f3 %a1 4 #186
	fmul %f1 %f3 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a1 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	lw %a0 %a0 24 #258
	fisneg %a1 %f0 #1168
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44589 # nontail if
	addi %a0 %a1 0 #105
	jal %zero beq_cont.44590 # then sentence ends
beq_else.44589:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44591 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.44592 # then sentence ends
beq_else.44591:
	addi %a0 %zero 0 #105
beq_cont.44592:
beq_cont.44590:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44593
	addi %a0 %zero 1 #1168
	jalr %zero %ra 0 #1168
beq_else.44593:
	addi %a0 %zero 0 #1168
	jalr %zero %ra 0 #1168
beq_else.44588:
	fmul %f3 %f0 %f0 #822
	lw %a1 %a0 16 #276
	lw %f4 %a1 0 #281
	fmul %f3 %f3 %f4 #822
	fmul %f4 %f1 %f1 #822
	lw %a1 %a0 16 #286
	lw %f5 %a1 4 #291
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	fmul %f4 %f2 %f2 #822
	lw %a1 %a0 16 #296
	lw %f5 %a1 8 #301
	fmul %f4 %f4 %f5 #822
	fadd %f3 %f3 %f4 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44594 # nontail if
	fadd %f0 %f3 %fzero #822
	jal %zero beq_cont.44595 # then sentence ends
beq_else.44594:
	fmul %f4 %f1 %f2 #828
	lw %a1 %a0 36 #396
	lw %f5 %a1 0 #401
	fmul %f4 %f4 %f5 #828
	fadd %f3 %f3 %f4 #827
	fmul %f2 %f2 %f0 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f2 %f2 %f4 #829
	fadd %f2 %f3 %f2 #827
	fmul %f0 %f0 %f1 #830
	lw %a1 %a0 36 #416
	lw %f1 %a1 8 #421
	fmul %f0 %f0 %f1 #830
	fadd %f0 %f2 %f0 #827
beq_cont.44595:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.44596 # nontail if
	li %f1 l.37441 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.44597 # then sentence ends
beq_else.44596:
beq_cont.44597:
	lw %a0 %a0 24 #258
	fisneg %a1 %f0 #1175
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44598 # nontail if
	addi %a0 %a1 0 #105
	jal %zero beq_cont.44599 # then sentence ends
beq_else.44598:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44600 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.44601 # then sentence ends
beq_else.44600:
	addi %a0 %zero 0 #105
beq_cont.44601:
beq_cont.44599:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44602
	addi %a0 %zero 1 #1175
	jalr %zero %ra 0 #1175
beq_else.44602:
	addi %a0 %zero 0 #1175
	jalr %zero %ra 0 #1175
check_all_inside.2735:
	lw %a2 %a11 4 #1193
	slli %a3 %a0 2 #1194
	add %a12 %a1 %a3 #1194
	lw %a3 %a12 0 #1194
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.44603
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.44603:
	slli %a3 %a3 2 #20
	add %a12 %a2 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %a3 20 #316
	lw %f3 %a4 0 #321
	fsub %f3 %f0 %f3 #1180
	lw %a4 %a3 20 #326
	lw %f4 %a4 4 #331
	fsub %f4 %f1 %f4 #1181
	lw %a4 %a3 20 #336
	lw %f5 %a4 8 #341
	fsub %f5 %f2 %f5 #1182
	lw %a4 %a3 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.44604 # nontail if
	fabs %f3 %f3 #1157
	lw %a4 %a3 16 #276
	lw %f6 %a4 0 #281
	fless %a4 %f3 %f6 #1157
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44606 # nontail if
	addi %a4 %zero 0 #1161
	jal %zero beq_cont.44607 # then sentence ends
beq_else.44606:
	fabs %f3 %f4 #1158
	lw %a4 %a3 16 #286
	lw %f4 %a4 4 #291
	fless %a4 %f3 %f4 #1158
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44608 # nontail if
	addi %a4 %zero 0 #1160
	jal %zero beq_cont.44609 # then sentence ends
beq_else.44608:
	fabs %f3 %f5 #1159
	lw %a4 %a3 16 #296
	lw %f4 %a4 8 #301
	fless %a4 %f3 %f4 #1159
beq_cont.44609:
beq_cont.44607:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44610 # nontail if
	lw %a3 %a3 24 #258
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44612 # nontail if
	addi %a3 %zero 1 #1162
	jal %zero beq_cont.44613 # then sentence ends
beq_else.44612:
	addi %a3 %zero 0 #1162
beq_cont.44613:
	jal %zero beq_cont.44611 # then sentence ends
beq_else.44610:
	lw %a3 %a3 24 #258
beq_cont.44611:
	jal %zero beq_cont.44605 # then sentence ends
beq_else.44604:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.44614 # nontail if
	lw %a4 %a3 16 #306
	lw %f6 %a4 0 #186
	fmul %f3 %f6 %f3 #186
	lw %f6 %a4 4 #186
	fmul %f4 %f6 %f4 #186
	fadd %f3 %f3 %f4 #186
	lw %f4 %a4 8 #186
	fmul %f4 %f4 %f5 #186
	fadd %f3 %f3 %f4 #186
	lw %a3 %a3 24 #258
	fisneg %a4 %f3 #1168
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44616 # nontail if
	addi %a3 %a4 0 #105
	jal %zero beq_cont.44617 # then sentence ends
beq_else.44616:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44618 # nontail if
	addi %a3 %zero 1 #105
	jal %zero beq_cont.44619 # then sentence ends
beq_else.44618:
	addi %a3 %zero 0 #105
beq_cont.44619:
beq_cont.44617:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44620 # nontail if
	addi %a3 %zero 1 #1168
	jal %zero beq_cont.44621 # then sentence ends
beq_else.44620:
	addi %a3 %zero 0 #1168
beq_cont.44621:
	jal %zero beq_cont.44615 # then sentence ends
beq_else.44614:
	fmul %f6 %f3 %f3 #822
	lw %a4 %a3 16 #276
	lw %f7 %a4 0 #281
	fmul %f6 %f6 %f7 #822
	fmul %f7 %f4 %f4 #822
	lw %a4 %a3 16 #286
	lw %f8 %a4 4 #291
	fmul %f7 %f7 %f8 #822
	fadd %f6 %f6 %f7 #822
	fmul %f7 %f5 %f5 #822
	lw %a4 %a3 16 #296
	lw %f8 %a4 8 #301
	fmul %f7 %f7 %f8 #822
	fadd %f6 %f6 %f7 #822
	lw %a4 %a3 12 #267
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44622 # nontail if
	fadd %f3 %f6 %fzero #822
	jal %zero beq_cont.44623 # then sentence ends
beq_else.44622:
	fmul %f7 %f4 %f5 #828
	lw %a4 %a3 36 #396
	lw %f8 %a4 0 #401
	fmul %f7 %f7 %f8 #828
	fadd %f6 %f6 %f7 #827
	fmul %f5 %f5 %f3 #829
	lw %a4 %a3 36 #406
	lw %f7 %a4 4 #411
	fmul %f5 %f5 %f7 #829
	fadd %f5 %f6 %f5 #827
	fmul %f3 %f3 %f4 #830
	lw %a4 %a3 36 #416
	lw %f4 %a4 8 #421
	fmul %f3 %f3 %f4 #830
	fadd %f3 %f5 %f3 #827
beq_cont.44623:
	lw %a4 %a3 4 #238
	addi %a12 %zero 3
	bne %a4 %a12 beq_else.44624 # nontail if
	li %f4 l.37441 #1174
	fsub %f3 %f3 %f4 #1174
	jal %zero beq_cont.44625 # then sentence ends
beq_else.44624:
beq_cont.44625:
	lw %a3 %a3 24 #258
	fisneg %a4 %f3 #1175
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44626 # nontail if
	addi %a3 %a4 0 #105
	jal %zero beq_cont.44627 # then sentence ends
beq_else.44626:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44628 # nontail if
	addi %a3 %zero 1 #105
	jal %zero beq_cont.44629 # then sentence ends
beq_else.44628:
	addi %a3 %zero 0 #105
beq_cont.44629:
beq_cont.44627:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44630 # nontail if
	addi %a3 %zero 1 #1175
	jal %zero beq_cont.44631 # then sentence ends
beq_else.44630:
	addi %a3 %zero 0 #1175
beq_cont.44631:
beq_cont.44615:
beq_cont.44605:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44632
	addi %a0 %a0 1 #1201
	slli %a3 %a0 2 #1194
	add %a12 %a1 %a3 #1194
	lw %a3 %a12 0 #1194
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.44633
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.44633:
	slli %a3 %a3 2 #20
	add %a12 %a2 %a3 #20
	lw %a3 %a12 0 #20
	sw %a11 %sp 0 #1198
	sw %f2 %sp 8 #1198
	sw %f1 %sp 16 #1198
	sw %f0 %sp 24 #1198
	sw %a2 %sp 32 #1198
	sw %a1 %sp 36 #1198
	sw %a0 %sp 40 #1198
	add %a0 %a3 %zero
	sw %ra %sp 44 #1198 call dir
	addi %sp %sp 48 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -48 #1198
	lw %ra %sp 44 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44635
	lw %a0 %sp 40 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44636
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.44636:
	slli %a1 %a1 2 #20
	lw %a3 %sp 32 #20
	add %a12 %a3 %a1 #20
	lw %a1 %a12 0 #20
	lw %a4 %a1 20 #316
	lw %f0 %a4 0 #321
	lw %f1 %sp 24 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a4 %a1 20 #326
	lw %f2 %a4 4 #331
	lw %f3 %sp 16 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a4 %a1 20 #336
	lw %f4 %a4 8 #341
	lw %f5 %sp 8 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a4 %a1 4 #238
	sw %a0 %sp 44 #868
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.44637 # nontail if
	fabs %f0 %f0 #1157
	lw %a4 %a1 16 #276
	lw %f6 %a4 0 #281
	fless %a4 %f0 %f6 #1157
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44639 # nontail if
	addi %a4 %zero 0 #1161
	jal %zero beq_cont.44640 # then sentence ends
beq_else.44639:
	fabs %f0 %f2 #1158
	lw %a4 %a1 16 #286
	lw %f2 %a4 4 #291
	fless %a4 %f0 %f2 #1158
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44641 # nontail if
	addi %a4 %zero 0 #1160
	jal %zero beq_cont.44642 # then sentence ends
beq_else.44641:
	fabs %f0 %f4 #1159
	lw %a4 %a1 16 #296
	lw %f2 %a4 8 #301
	fless %a4 %f0 %f2 #1159
beq_cont.44642:
beq_cont.44640:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44643 # nontail if
	lw %a1 %a1 24 #258
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44645 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.44646 # then sentence ends
beq_else.44645:
	addi %a0 %zero 0 #1162
beq_cont.44646:
	jal %zero beq_cont.44644 # then sentence ends
beq_else.44643:
	lw %a1 %a1 24 #258
	addi %a0 %a1 0 #262
beq_cont.44644:
	jal %zero beq_cont.44638 # then sentence ends
beq_else.44637:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.44647 # nontail if
	lw %a4 %a1 16 #306
	lw %f6 %a4 0 #186
	fmul %f0 %f6 %f0 #186
	lw %f6 %a4 4 #186
	fmul %f2 %f6 %f2 #186
	fadd %f0 %f0 %f2 #186
	lw %f2 %a4 8 #186
	fmul %f2 %f2 %f4 #186
	fadd %f0 %f0 %f2 #186
	lw %a1 %a1 24 #258
	fisneg %a4 %f0 #1168
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44649 # nontail if
	addi %a1 %a4 0 #105
	jal %zero beq_cont.44650 # then sentence ends
beq_else.44649:
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44651 # nontail if
	addi %a1 %zero 1 #105
	jal %zero beq_cont.44652 # then sentence ends
beq_else.44651:
	addi %a1 %zero 0 #105
beq_cont.44652:
beq_cont.44650:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44653 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.44654 # then sentence ends
beq_else.44653:
	addi %a0 %zero 0 #1168
beq_cont.44654:
	jal %zero beq_cont.44648 # then sentence ends
beq_else.44647:
	add %a0 %a1 %zero
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 52 #1189 call dir
	addi %sp %sp 56 #1189	
	jal %ra is_second_outside.2725 #1189
	addi %sp %sp -56 #1189
	lw %ra %sp 52 #1189
beq_cont.44648:
beq_cont.44638:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44655
	lw %a0 %sp 44 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44656
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.44656:
	slli %a1 %a1 2 #20
	lw %a3 %sp 32 #20
	add %a12 %a3 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 24 #1198
	lw %f1 %sp 16 #1198
	lw %f2 %sp 8 #1198
	sw %a0 %sp 48 #1198
	add %a0 %a1 %zero
	sw %ra %sp 52 #1198 call dir
	addi %sp %sp 56 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -56 #1198
	lw %ra %sp 52 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44657
	lw %a0 %sp 48 #1201
	addi %a0 %a0 1 #1201
	lw %f0 %sp 24 #1201
	lw %f1 %sp 16 #1201
	lw %f2 %sp 8 #1201
	lw %a1 %sp 36 #1201
	lw %a11 %sp 0 #1201
	lw %a10 %a11 0 #1201
	jalr %zero %a10 0 #1201
beq_else.44657:
	addi %a0 %zero 0 #1199
	jalr %zero %ra 0 #1199
beq_else.44655:
	addi %a0 %zero 0 #1199
	jalr %zero %ra 0 #1199
beq_else.44635:
	addi %a0 %zero 0 #1199
	jalr %zero %ra 0 #1199
beq_else.44632:
	addi %a0 %zero 0 #1199
	jalr %zero %ra 0 #1199
shadow_check_and_group.2741:
	lw %a2 %a11 36 #1211
	lw %a3 %a11 32 #1211
	lw %a4 %a11 28 #1211
	lw %a5 %a11 24 #1211
	lw %a6 %a11 20 #1211
	lw %a7 %a11 16 #1211
	lw %a8 %a11 12 #1211
	lw %a9 %a11 8 #1211
	lw %a10 %a11 4 #1211
	sw %a10 %sp 0 #1212
	slli %a10 %a0 2 #1212
	add %a12 %a1 %a10 #1212
	lw %a10 %a12 0 #1212
	addi %a12 %zero -1
	bne %a10 %a12 beq_else.44658
	addi %a0 %zero 0 #1213
	jalr %zero %ra 0 #1213
beq_else.44658:
	slli %a10 %a0 2 #1212
	add %a12 %a1 %a10 #1212
	lw %a10 %a12 0 #1212
	sw %a7 %sp 4 #20
	slli %a7 %a10 2 #20
	add %a12 %a6 %a7 #20
	lw %a7 %a12 0 #20
	lw %f0 %a8 0 #964
	sw %a1 %sp 8 #316
	lw %a1 %a7 20 #316
	lw %f1 %a1 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a8 4 #964
	lw %a1 %a7 20 #326
	lw %f2 %a1 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a8 8 #964
	lw %a1 %a7 20 #336
	lw %f3 %a1 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a1 %a10 2 #968
	add %a12 %a9 %a1 #968
	lw %a1 %a12 0 #968
	lw %a9 %a7 4 #238
	sw %a8 %sp 12 #868
	sw %a11 %sp 16 #868
	sw %a0 %sp 20 #868
	sw %a6 %sp 24 #868
	sw %a10 %sp 28 #868
	sw %a5 %sp 32 #868
	addi %a12 %zero 1
	bne %a9 %a12 beq_else.44659 # nontail if
	add %a0 %a7 %zero
	add %a11 %a4 %zero
	add %a10 %a2 %zero
	add %a2 %a1 %zero
	add %a1 %a10 %zero
	sw %ra %sp 36 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 40 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -40 #971
	lw %ra %sp 36 #971
	jal %zero beq_cont.44660 # then sentence ends
beq_else.44659:
	addi %a12 %zero 2
	bne %a9 %a12 beq_else.44661 # nontail if
	lw %f3 %a1 0 #934
	fisneg %a2 %f3 #934
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44663 # nontail if
	addi %a0 %zero 0 #938
	jal %zero beq_cont.44664 # then sentence ends
beq_else.44663:
	lw %f3 %a1 4 #934
	fmul %f0 %f3 %f0 #936
	lw %f3 %a1 8 #934
	fmul %f1 %f3 %f1 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a1 12 #934
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	sw %f0 %a5 0 #935
	addi %a0 %zero 1 #937
beq_cont.44664:
	jal %zero beq_cont.44662 # then sentence ends
beq_else.44661:
	add %a0 %a7 %zero
	add %a11 %a3 %zero
	sw %ra %sp 36 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 40 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -40 #975
	lw %ra %sp 36 #975
beq_cont.44662:
beq_cont.44660:
	lw %a1 %sp 32 #37
	lw %f0 %a1 0 #37
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44665 # nontail if
	addi %a0 %zero 0 #1218
	jal %zero beq_cont.44666 # then sentence ends
beq_else.44665:
	li %f1 l.37928 #1218
	fless %a0 %f0 %f1 #1218
beq_cont.44666:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44667
	lw %a0 %sp 28 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 24 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44668
	addi %a0 %zero 0 #1237
	jalr %zero %ra 0 #1237
beq_else.44668:
	lw %a0 %sp 20 #1235
	addi %a0 %a0 1 #1235
	lw %a1 %sp 8 #1235
	lw %a11 %sp 16 #1235
	lw %a10 %a11 0 #1235
	jalr %zero %a10 0 #1235
beq_else.44667:
	li %f1 l.37930 #1221
	fadd %f0 %f0 %f1 #1221
	lw %a0 %sp 4 #27
	lw %f1 %a0 0 #27
	fmul %f1 %f1 %f0 #1222
	lw %a1 %sp 12 #43
	lw %f2 %a1 0 #43
	fadd %f1 %f1 %f2 #1222
	lw %f2 %a0 4 #27
	fmul %f2 %f2 %f0 #1223
	lw %f3 %a1 4 #43
	fadd %f2 %f2 %f3 #1223
	lw %f3 %a0 8 #27
	fmul %f0 %f3 %f0 #1224
	lw %f3 %a1 8 #43
	fadd %f0 %f0 %f3 #1224
	lw %a1 %sp 8 #1194
	lw %a0 %a1 0 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44669 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.44670 # then sentence ends
beq_else.44669:
	slli %a0 %a0 2 #20
	lw %a2 %sp 24 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	sw %f0 %sp 40 #1198
	sw %f2 %sp 48 #1198
	sw %f1 %sp 56 #1198
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 68 #1198 call dir
	addi %sp %sp 72 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -72 #1198
	lw %ra %sp 68 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44672 # nontail if
	lw %a1 %sp 8 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44674 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.44675 # then sentence ends
beq_else.44674:
	slli %a0 %a0 2 #20
	lw %a2 %sp 24 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 56 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a0 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 48 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a0 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 40 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.44676 # nontail if
	fabs %f0 %f0 #1157
	lw %a3 %a0 16 #276
	lw %f6 %a3 0 #281
	fless %a3 %f0 %f6 #1157
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44678 # nontail if
	addi %a3 %zero 0 #1161
	jal %zero beq_cont.44679 # then sentence ends
beq_else.44678:
	fabs %f0 %f2 #1158
	lw %a3 %a0 16 #286
	lw %f2 %a3 4 #291
	fless %a3 %f0 %f2 #1158
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44680 # nontail if
	addi %a3 %zero 0 #1160
	jal %zero beq_cont.44681 # then sentence ends
beq_else.44680:
	fabs %f0 %f4 #1159
	lw %a3 %a0 16 #296
	lw %f2 %a3 8 #301
	fless %a3 %f0 %f2 #1159
beq_cont.44681:
beq_cont.44679:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44682 # nontail if
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44684 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.44685 # then sentence ends
beq_else.44684:
	addi %a0 %zero 0 #1162
beq_cont.44685:
	jal %zero beq_cont.44683 # then sentence ends
beq_else.44682:
	lw %a0 %a0 24 #258
beq_cont.44683:
	jal %zero beq_cont.44677 # then sentence ends
beq_else.44676:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.44686 # nontail if
	lw %a3 %a0 16 #306
	lw %f6 %a3 0 #186
	fmul %f0 %f6 %f0 #186
	lw %f6 %a3 4 #186
	fmul %f2 %f6 %f2 #186
	fadd %f0 %f0 %f2 #186
	lw %f2 %a3 8 #186
	fmul %f2 %f2 %f4 #186
	fadd %f0 %f0 %f2 #186
	lw %a0 %a0 24 #258
	fisneg %a3 %f0 #1168
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44688 # nontail if
	addi %a0 %a3 0 #105
	jal %zero beq_cont.44689 # then sentence ends
beq_else.44688:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44690 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.44691 # then sentence ends
beq_else.44690:
	addi %a0 %zero 0 #105
beq_cont.44691:
beq_cont.44689:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44692 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.44693 # then sentence ends
beq_else.44692:
	addi %a0 %zero 0 #1168
beq_cont.44693:
	jal %zero beq_cont.44687 # then sentence ends
beq_else.44686:
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 68 #1189 call dir
	addi %sp %sp 72 #1189	
	jal %ra is_second_outside.2725 #1189
	addi %sp %sp -72 #1189
	lw %ra %sp 68 #1189
beq_cont.44687:
beq_cont.44677:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44694 # nontail if
	lw %a1 %sp 8 #1194
	lw %a0 %a1 8 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44696 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.44697 # then sentence ends
beq_else.44696:
	slli %a0 %a0 2 #20
	lw %a2 %sp 24 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 56 #1198
	lw %f1 %sp 48 #1198
	lw %f2 %sp 40 #1198
	sw %ra %sp 68 #1198 call dir
	addi %sp %sp 72 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -72 #1198
	lw %ra %sp 68 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44698 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 56 #1201
	lw %f1 %sp 48 #1201
	lw %f2 %sp 40 #1201
	lw %a1 %sp 8 #1201
	lw %a11 %sp 0 #1201
	sw %ra %sp 68 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 72 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -72 #1201
	lw %ra %sp 68 #1201
	jal %zero beq_cont.44699 # then sentence ends
beq_else.44698:
	addi %a0 %zero 0 #1199
beq_cont.44699:
beq_cont.44697:
	jal %zero beq_cont.44695 # then sentence ends
beq_else.44694:
	addi %a0 %zero 0 #1199
beq_cont.44695:
beq_cont.44675:
	jal %zero beq_cont.44673 # then sentence ends
beq_else.44672:
	addi %a0 %zero 0 #1199
beq_cont.44673:
beq_cont.44670:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44700
	lw %a0 %sp 20 #1228
	addi %a0 %a0 1 #1228
	lw %a1 %sp 8 #1228
	lw %a11 %sp 16 #1228
	lw %a10 %a11 0 #1228
	jalr %zero %a10 0 #1228
beq_else.44700:
	addi %a0 %zero 1 #1226
	jalr %zero %ra 0 #1226
shadow_check_one_or_group.2744:
	lw %a2 %a11 8 #1241
	lw %a3 %a11 4 #1241
	slli %a4 %a0 2 #1242
	add %a12 %a1 %a4 #1242
	lw %a4 %a12 0 #1242
	addi %a12 %zero -1
	bne %a4 %a12 beq_else.44701
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44701:
	slli %a4 %a4 2 #31
	add %a12 %a3 %a4 #31
	lw %a4 %a12 0 #31
	addi %a5 %zero 0 #1247
	sw %a11 %sp 0 #1247
	sw %a2 %sp 4 #1247
	sw %a3 %sp 8 #1247
	sw %a1 %sp 12 #1247
	sw %a0 %sp 16 #1247
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	add %a11 %a2 %zero
	sw %ra %sp 20 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 24 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -24 #1247
	lw %ra %sp 20 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44702
	lw %a0 %sp 16 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44703
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44703:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 20 #1247
	add %a0 %a4 %zero
	sw %ra %sp 28 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 32 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -32 #1247
	lw %ra %sp 28 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44704
	lw %a0 %sp 20 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44705
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44705:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 24 #1247
	add %a0 %a4 %zero
	sw %ra %sp 28 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 32 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -32 #1247
	lw %ra %sp 28 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44706
	lw %a0 %sp 24 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44707
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44707:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 28 #1247
	add %a0 %a4 %zero
	sw %ra %sp 36 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 40 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -40 #1247
	lw %ra %sp 36 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44708
	lw %a0 %sp 28 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44709
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44709:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 32 #1247
	add %a0 %a4 %zero
	sw %ra %sp 36 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 40 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -40 #1247
	lw %ra %sp 36 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44710
	lw %a0 %sp 32 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44711
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44711:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 36 #1247
	add %a0 %a4 %zero
	sw %ra %sp 44 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 48 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -48 #1247
	lw %ra %sp 44 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44712
	lw %a0 %sp 36 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44713
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44713:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 40 #1247
	add %a0 %a4 %zero
	sw %ra %sp 44 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 48 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -48 #1247
	lw %ra %sp 44 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44714
	lw %a0 %sp 40 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44715
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.44715:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 44 #1247
	add %a0 %a3 %zero
	sw %ra %sp 52 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 56 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -56 #1247
	lw %ra %sp 52 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44716
	lw %a0 %sp 44 #1251
	addi %a0 %a0 1 #1251
	lw %a1 %sp 12 #1251
	lw %a11 %sp 0 #1251
	lw %a10 %a11 0 #1251
	jalr %zero %a10 0 #1251
beq_else.44716:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.44714:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.44712:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.44710:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.44708:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.44706:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.44704:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.44702:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
shadow_check_one_or_matrix.2747:
	lw %a2 %a11 40 #1256
	lw %a3 %a11 36 #1256
	lw %a4 %a11 32 #1256
	lw %a5 %a11 28 #1256
	lw %a6 %a11 24 #1256
	lw %a7 %a11 20 #1256
	lw %a8 %a11 16 #1256
	lw %a9 %a11 12 #1256
	lw %a10 %a11 8 #1256
	sw %a11 %sp 0 #1256
	lw %a11 %a11 4 #1256
	sw %a0 %sp 4 #1257
	slli %a0 %a0 2 #1257
	add %a12 %a1 %a0 #1257
	lw %a0 %a12 0 #1257
	sw %a1 %sp 8 #1258
	lw %a1 %a0 0 #1258
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44717
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.44717:
	sw %a0 %sp 12 #1259
	sw %a6 %sp 16 #1259
	sw %a7 %sp 20 #1259
	sw %a11 %sp 24 #1259
	sw %a3 %sp 28 #1259
	sw %a5 %sp 32 #1259
	sw %a2 %sp 36 #1259
	sw %a4 %sp 40 #1259
	sw %a10 %sp 44 #1259
	sw %a9 %sp 48 #1259
	sw %a8 %sp 52 #1259
	addi %a12 %zero 99
	bne %a1 %a12 beq_else.44718 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.44719 # then sentence ends
beq_else.44718:
	slli %a6 %a1 2 #20
	add %a12 %a8 %a6 #20
	lw %a6 %a12 0 #20
	lw %f0 %a9 0 #964
	lw %a8 %a6 20 #316
	lw %f1 %a8 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a9 4 #964
	lw %a8 %a6 20 #326
	lw %f2 %a8 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a9 8 #964
	lw %a8 %a6 20 #336
	lw %f3 %a8 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a1 %a1 2 #968
	add %a12 %a10 %a1 #968
	lw %a1 %a12 0 #968
	lw %a8 %a6 4 #238
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.44720 # nontail if
	add %a0 %a6 %zero
	add %a11 %a4 %zero
	add %a10 %a2 %zero
	add %a2 %a1 %zero
	add %a1 %a10 %zero
	sw %ra %sp 60 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 64 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -64 #971
	lw %ra %sp 60 #971
	jal %zero beq_cont.44721 # then sentence ends
beq_else.44720:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.44722 # nontail if
	lw %f3 %a1 0 #934
	fisneg %a6 %f3 #934
	addi %a12 %zero 0
	bne %a6 %a12 beq_else.44724 # nontail if
	addi %a0 %zero 0 #938
	jal %zero beq_cont.44725 # then sentence ends
beq_else.44724:
	lw %f3 %a1 4 #934
	fmul %f0 %f3 %f0 #936
	lw %f3 %a1 8 #934
	fmul %f1 %f3 %f1 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a1 12 #934
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	sw %f0 %a5 0 #935
	addi %a0 %zero 1 #937
beq_cont.44725:
	jal %zero beq_cont.44723 # then sentence ends
beq_else.44722:
	add %a0 %a6 %zero
	add %a11 %a3 %zero
	sw %ra %sp 60 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 64 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -64 #975
	lw %ra %sp 60 #975
beq_cont.44723:
beq_cont.44721:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44726 # nontail if
	addi %a0 %zero 0 #1275
	jal %zero beq_cont.44727 # then sentence ends
beq_else.44726:
	lw %a0 %sp 32 #37
	lw %f0 %a0 0 #37
	li %f1 l.37986 #1270
	fless %a1 %f0 %f1 #1270
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44728 # nontail if
	addi %a0 %zero 0 #1274
	jal %zero beq_cont.44729 # then sentence ends
beq_else.44728:
	lw %a1 %sp 12 #1242
	lw %a2 %a1 4 #1242
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.44730 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44731 # then sentence ends
beq_else.44730:
	slli %a2 %a2 2 #31
	lw %a3 %sp 24 #31
	add %a12 %a3 %a2 #31
	lw %a2 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	sw %ra %sp 60 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 64 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -64 #1247
	lw %ra %sp 60 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44732 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44734 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44735 # then sentence ends
beq_else.44734:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 60 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 64 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -64 #1247
	lw %ra %sp 60 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44736 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44738 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44739 # then sentence ends
beq_else.44738:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 60 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 64 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -64 #1247
	lw %ra %sp 60 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44740 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44742 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44743 # then sentence ends
beq_else.44742:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 60 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 64 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -64 #1247
	lw %ra %sp 60 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44744 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44746 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44747 # then sentence ends
beq_else.44746:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 60 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 64 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -64 #1247
	lw %ra %sp 60 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44748 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44750 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44751 # then sentence ends
beq_else.44750:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 60 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 64 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -64 #1247
	lw %ra %sp 60 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44752 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 28 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44754 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44755 # then sentence ends
beq_else.44754:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 60 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 64 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -64 #1247
	lw %ra %sp 60 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44756 # nontail if
	addi %a0 %zero 8 #1251
	lw %a1 %sp 12 #1251
	lw %a11 %sp 16 #1251
	sw %ra %sp 60 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 64 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -64 #1251
	lw %ra %sp 60 #1251
	jal %zero beq_cont.44757 # then sentence ends
beq_else.44756:
	addi %a0 %zero 1 #1249
beq_cont.44757:
beq_cont.44755:
	jal %zero beq_cont.44753 # then sentence ends
beq_else.44752:
	addi %a0 %zero 1 #1249
beq_cont.44753:
beq_cont.44751:
	jal %zero beq_cont.44749 # then sentence ends
beq_else.44748:
	addi %a0 %zero 1 #1249
beq_cont.44749:
beq_cont.44747:
	jal %zero beq_cont.44745 # then sentence ends
beq_else.44744:
	addi %a0 %zero 1 #1249
beq_cont.44745:
beq_cont.44743:
	jal %zero beq_cont.44741 # then sentence ends
beq_else.44740:
	addi %a0 %zero 1 #1249
beq_cont.44741:
beq_cont.44739:
	jal %zero beq_cont.44737 # then sentence ends
beq_else.44736:
	addi %a0 %zero 1 #1249
beq_cont.44737:
beq_cont.44735:
	jal %zero beq_cont.44733 # then sentence ends
beq_else.44732:
	addi %a0 %zero 1 #1249
beq_cont.44733:
beq_cont.44731:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44758 # nontail if
	addi %a0 %zero 0 #1273
	jal %zero beq_cont.44759 # then sentence ends
beq_else.44758:
	addi %a0 %zero 1 #1272
beq_cont.44759:
beq_cont.44729:
beq_cont.44727:
beq_cont.44719:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44760
	lw %a0 %sp 4 #1282
	addi %a0 %a0 1 #1282
	slli %a1 %a0 2 #1257
	lw %a2 %sp 8 #1257
	add %a12 %a2 %a1 #1257
	lw %a1 %a12 0 #1257
	lw %a3 %a1 0 #1258
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.44761
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.44761:
	sw %a1 %sp 56 #1259
	sw %a0 %sp 60 #1259
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.44762 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.44763 # then sentence ends
beq_else.44762:
	slli %a4 %a3 2 #20
	lw %a5 %sp 52 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	lw %a5 %sp 48 #964
	lw %f0 %a5 0 #964
	lw %a6 %a4 20 #316
	lw %f1 %a6 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a5 4 #964
	lw %a6 %a4 20 #326
	lw %f2 %a6 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a5 8 #964
	lw %a5 %a4 20 #336
	lw %f3 %a5 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a3 %a3 2 #968
	lw %a5 %sp 44 #968
	add %a12 %a5 %a3 #968
	lw %a3 %a12 0 #968
	lw %a5 %a4 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.44764 # nontail if
	lw %a5 %sp 36 #971
	lw %a11 %sp 40 #971
	add %a2 %a3 %zero
	add %a1 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 68 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 72 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -72 #971
	lw %ra %sp 68 #971
	jal %zero beq_cont.44765 # then sentence ends
beq_else.44764:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.44766 # nontail if
	lw %f3 %a3 0 #934
	fisneg %a4 %f3 #934
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44768 # nontail if
	addi %a0 %zero 0 #938
	jal %zero beq_cont.44769 # then sentence ends
beq_else.44768:
	lw %f3 %a3 4 #934
	fmul %f0 %f3 %f0 #936
	lw %f3 %a3 8 #934
	fmul %f1 %f3 %f1 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a3 12 #934
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a3 %sp 32 #935
	sw %f0 %a3 0 #935
	addi %a0 %zero 1 #937
beq_cont.44769:
	jal %zero beq_cont.44767 # then sentence ends
beq_else.44766:
	lw %a11 %sp 28 #975
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	sw %ra %sp 68 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 72 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -72 #975
	lw %ra %sp 68 #975
beq_cont.44767:
beq_cont.44765:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44770 # nontail if
	addi %a0 %zero 0 #1275
	jal %zero beq_cont.44771 # then sentence ends
beq_else.44770:
	lw %a0 %sp 32 #37
	lw %f0 %a0 0 #37
	li %f1 l.37986 #1270
	fless %a0 %f0 %f1 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44772 # nontail if
	addi %a0 %zero 0 #1274
	jal %zero beq_cont.44773 # then sentence ends
beq_else.44772:
	lw %a0 %sp 56 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44774 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44775 # then sentence ends
beq_else.44774:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44776 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44778 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44779 # then sentence ends
beq_else.44778:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44780 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44782 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44783 # then sentence ends
beq_else.44782:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44784 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44786 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44787 # then sentence ends
beq_else.44786:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44788 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44790 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44791 # then sentence ends
beq_else.44790:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44792 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44794 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44795 # then sentence ends
beq_else.44794:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44796 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 56 #1251
	lw %a11 %sp 16 #1251
	sw %ra %sp 68 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 72 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -72 #1251
	lw %ra %sp 68 #1251
	jal %zero beq_cont.44797 # then sentence ends
beq_else.44796:
	addi %a0 %zero 1 #1249
beq_cont.44797:
beq_cont.44795:
	jal %zero beq_cont.44793 # then sentence ends
beq_else.44792:
	addi %a0 %zero 1 #1249
beq_cont.44793:
beq_cont.44791:
	jal %zero beq_cont.44789 # then sentence ends
beq_else.44788:
	addi %a0 %zero 1 #1249
beq_cont.44789:
beq_cont.44787:
	jal %zero beq_cont.44785 # then sentence ends
beq_else.44784:
	addi %a0 %zero 1 #1249
beq_cont.44785:
beq_cont.44783:
	jal %zero beq_cont.44781 # then sentence ends
beq_else.44780:
	addi %a0 %zero 1 #1249
beq_cont.44781:
beq_cont.44779:
	jal %zero beq_cont.44777 # then sentence ends
beq_else.44776:
	addi %a0 %zero 1 #1249
beq_cont.44777:
beq_cont.44775:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44798 # nontail if
	addi %a0 %zero 0 #1273
	jal %zero beq_cont.44799 # then sentence ends
beq_else.44798:
	addi %a0 %zero 1 #1272
beq_cont.44799:
beq_cont.44773:
beq_cont.44771:
beq_cont.44763:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44800
	lw %a0 %sp 60 #1282
	addi %a0 %a0 1 #1282
	lw %a1 %sp 8 #1282
	lw %a11 %sp 0 #1282
	lw %a10 %a11 0 #1282
	jalr %zero %a10 0 #1282
beq_else.44800:
	lw %a0 %sp 56 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44801 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44802 # then sentence ends
beq_else.44801:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44803 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44805 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44806 # then sentence ends
beq_else.44805:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44807 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44809 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44810 # then sentence ends
beq_else.44809:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44811 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44813 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44814 # then sentence ends
beq_else.44813:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44815 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44817 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44818 # then sentence ends
beq_else.44817:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44819 # nontail if
	lw %a0 %sp 56 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44821 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44822 # then sentence ends
beq_else.44821:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a2 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44823 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 56 #1251
	lw %a11 %sp 16 #1251
	sw %ra %sp 68 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 72 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -72 #1251
	lw %ra %sp 68 #1251
	jal %zero beq_cont.44824 # then sentence ends
beq_else.44823:
	addi %a0 %zero 1 #1249
beq_cont.44824:
beq_cont.44822:
	jal %zero beq_cont.44820 # then sentence ends
beq_else.44819:
	addi %a0 %zero 1 #1249
beq_cont.44820:
beq_cont.44818:
	jal %zero beq_cont.44816 # then sentence ends
beq_else.44815:
	addi %a0 %zero 1 #1249
beq_cont.44816:
beq_cont.44814:
	jal %zero beq_cont.44812 # then sentence ends
beq_else.44811:
	addi %a0 %zero 1 #1249
beq_cont.44812:
beq_cont.44810:
	jal %zero beq_cont.44808 # then sentence ends
beq_else.44807:
	addi %a0 %zero 1 #1249
beq_cont.44808:
beq_cont.44806:
	jal %zero beq_cont.44804 # then sentence ends
beq_else.44803:
	addi %a0 %zero 1 #1249
beq_cont.44804:
beq_cont.44802:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44825
	lw %a0 %sp 60 #1280
	addi %a0 %a0 1 #1280
	lw %a1 %sp 8 #1280
	lw %a11 %sp 0 #1280
	lw %a10 %a11 0 #1280
	jalr %zero %a10 0 #1280
beq_else.44825:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
beq_else.44760:
	lw %a0 %sp 12 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44826 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44827 # then sentence ends
beq_else.44826:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44828 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44830 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44831 # then sentence ends
beq_else.44830:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44832 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44834 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44835 # then sentence ends
beq_else.44834:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44836 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44838 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44839 # then sentence ends
beq_else.44838:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44840 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44842 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44843 # then sentence ends
beq_else.44842:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44844 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44846 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44847 # then sentence ends
beq_else.44846:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44848 # nontail if
	lw %a0 %sp 12 #1242
	lw %a1 %a0 28 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44850 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44851 # then sentence ends
beq_else.44850:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 68 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 72 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -72 #1247
	lw %ra %sp 68 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44852 # nontail if
	addi %a0 %zero 8 #1251
	lw %a1 %sp 12 #1251
	lw %a11 %sp 16 #1251
	sw %ra %sp 68 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 72 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -72 #1251
	lw %ra %sp 68 #1251
	jal %zero beq_cont.44853 # then sentence ends
beq_else.44852:
	addi %a0 %zero 1 #1249
beq_cont.44853:
beq_cont.44851:
	jal %zero beq_cont.44849 # then sentence ends
beq_else.44848:
	addi %a0 %zero 1 #1249
beq_cont.44849:
beq_cont.44847:
	jal %zero beq_cont.44845 # then sentence ends
beq_else.44844:
	addi %a0 %zero 1 #1249
beq_cont.44845:
beq_cont.44843:
	jal %zero beq_cont.44841 # then sentence ends
beq_else.44840:
	addi %a0 %zero 1 #1249
beq_cont.44841:
beq_cont.44839:
	jal %zero beq_cont.44837 # then sentence ends
beq_else.44836:
	addi %a0 %zero 1 #1249
beq_cont.44837:
beq_cont.44835:
	jal %zero beq_cont.44833 # then sentence ends
beq_else.44832:
	addi %a0 %zero 1 #1249
beq_cont.44833:
beq_cont.44831:
	jal %zero beq_cont.44829 # then sentence ends
beq_else.44828:
	addi %a0 %zero 1 #1249
beq_cont.44829:
beq_cont.44827:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44854
	lw %a0 %sp 4 #1280
	addi %a0 %a0 1 #1280
	slli %a1 %a0 2 #1257
	lw %a2 %sp 8 #1257
	add %a12 %a2 %a1 #1257
	lw %a1 %a12 0 #1257
	lw %a3 %a1 0 #1258
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.44855
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.44855:
	sw %a1 %sp 64 #1259
	sw %a0 %sp 68 #1259
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.44856 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.44857 # then sentence ends
beq_else.44856:
	slli %a4 %a3 2 #20
	lw %a5 %sp 52 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	lw %a5 %sp 48 #964
	lw %f0 %a5 0 #964
	lw %a6 %a4 20 #316
	lw %f1 %a6 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a5 4 #964
	lw %a6 %a4 20 #326
	lw %f2 %a6 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a5 8 #964
	lw %a5 %a4 20 #336
	lw %f3 %a5 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a3 %a3 2 #968
	lw %a5 %sp 44 #968
	add %a12 %a5 %a3 #968
	lw %a3 %a12 0 #968
	lw %a5 %a4 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.44858 # nontail if
	lw %a5 %sp 36 #971
	lw %a11 %sp 40 #971
	add %a2 %a3 %zero
	add %a1 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 76 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 80 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -80 #971
	lw %ra %sp 76 #971
	jal %zero beq_cont.44859 # then sentence ends
beq_else.44858:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.44860 # nontail if
	lw %f3 %a3 0 #934
	fisneg %a4 %f3 #934
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.44862 # nontail if
	addi %a0 %zero 0 #938
	jal %zero beq_cont.44863 # then sentence ends
beq_else.44862:
	lw %f3 %a3 4 #934
	fmul %f0 %f3 %f0 #936
	lw %f3 %a3 8 #934
	fmul %f1 %f3 %f1 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a3 12 #934
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a3 %sp 32 #935
	sw %f0 %a3 0 #935
	addi %a0 %zero 1 #937
beq_cont.44863:
	jal %zero beq_cont.44861 # then sentence ends
beq_else.44860:
	lw %a11 %sp 28 #975
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	sw %ra %sp 76 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 80 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -80 #975
	lw %ra %sp 76 #975
beq_cont.44861:
beq_cont.44859:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44864 # nontail if
	addi %a0 %zero 0 #1275
	jal %zero beq_cont.44865 # then sentence ends
beq_else.44864:
	lw %a0 %sp 32 #37
	lw %f0 %a0 0 #37
	li %f1 l.37986 #1270
	fless %a0 %f0 %f1 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44866 # nontail if
	addi %a0 %zero 0 #1274
	jal %zero beq_cont.44867 # then sentence ends
beq_else.44866:
	lw %a0 %sp 64 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44868 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44869 # then sentence ends
beq_else.44868:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44870 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44872 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44873 # then sentence ends
beq_else.44872:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44874 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44876 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44877 # then sentence ends
beq_else.44876:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44878 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44880 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44881 # then sentence ends
beq_else.44880:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44882 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44884 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44885 # then sentence ends
beq_else.44884:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44886 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44888 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44889 # then sentence ends
beq_else.44888:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44890 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 64 #1251
	lw %a11 %sp 16 #1251
	sw %ra %sp 76 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 80 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -80 #1251
	lw %ra %sp 76 #1251
	jal %zero beq_cont.44891 # then sentence ends
beq_else.44890:
	addi %a0 %zero 1 #1249
beq_cont.44891:
beq_cont.44889:
	jal %zero beq_cont.44887 # then sentence ends
beq_else.44886:
	addi %a0 %zero 1 #1249
beq_cont.44887:
beq_cont.44885:
	jal %zero beq_cont.44883 # then sentence ends
beq_else.44882:
	addi %a0 %zero 1 #1249
beq_cont.44883:
beq_cont.44881:
	jal %zero beq_cont.44879 # then sentence ends
beq_else.44878:
	addi %a0 %zero 1 #1249
beq_cont.44879:
beq_cont.44877:
	jal %zero beq_cont.44875 # then sentence ends
beq_else.44874:
	addi %a0 %zero 1 #1249
beq_cont.44875:
beq_cont.44873:
	jal %zero beq_cont.44871 # then sentence ends
beq_else.44870:
	addi %a0 %zero 1 #1249
beq_cont.44871:
beq_cont.44869:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44892 # nontail if
	addi %a0 %zero 0 #1273
	jal %zero beq_cont.44893 # then sentence ends
beq_else.44892:
	addi %a0 %zero 1 #1272
beq_cont.44893:
beq_cont.44867:
beq_cont.44865:
beq_cont.44857:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44894
	lw %a0 %sp 68 #1282
	addi %a0 %a0 1 #1282
	lw %a1 %sp 8 #1282
	lw %a11 %sp 0 #1282
	lw %a10 %a11 0 #1282
	jalr %zero %a10 0 #1282
beq_else.44894:
	lw %a0 %sp 64 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44895 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44896 # then sentence ends
beq_else.44895:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44897 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44899 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44900 # then sentence ends
beq_else.44899:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44901 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44903 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44904 # then sentence ends
beq_else.44903:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44905 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44907 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44908 # then sentence ends
beq_else.44907:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44909 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44911 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44912 # then sentence ends
beq_else.44911:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44913 # nontail if
	lw %a0 %sp 64 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44915 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.44916 # then sentence ends
beq_else.44915:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a2 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44917 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 64 #1251
	lw %a11 %sp 16 #1251
	sw %ra %sp 76 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 80 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -80 #1251
	lw %ra %sp 76 #1251
	jal %zero beq_cont.44918 # then sentence ends
beq_else.44917:
	addi %a0 %zero 1 #1249
beq_cont.44918:
beq_cont.44916:
	jal %zero beq_cont.44914 # then sentence ends
beq_else.44913:
	addi %a0 %zero 1 #1249
beq_cont.44914:
beq_cont.44912:
	jal %zero beq_cont.44910 # then sentence ends
beq_else.44909:
	addi %a0 %zero 1 #1249
beq_cont.44910:
beq_cont.44908:
	jal %zero beq_cont.44906 # then sentence ends
beq_else.44905:
	addi %a0 %zero 1 #1249
beq_cont.44906:
beq_cont.44904:
	jal %zero beq_cont.44902 # then sentence ends
beq_else.44901:
	addi %a0 %zero 1 #1249
beq_cont.44902:
beq_cont.44900:
	jal %zero beq_cont.44898 # then sentence ends
beq_else.44897:
	addi %a0 %zero 1 #1249
beq_cont.44898:
beq_cont.44896:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44919
	lw %a0 %sp 68 #1280
	addi %a0 %a0 1 #1280
	lw %a1 %sp 8 #1280
	lw %a11 %sp 0 #1280
	lw %a10 %a11 0 #1280
	jalr %zero %a10 0 #1280
beq_else.44919:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
beq_else.44854:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
solve_each_element.2750:
	lw %a3 %a11 40 #1290
	lw %a4 %a11 36 #1290
	lw %a5 %a11 32 #1290
	lw %a6 %a11 28 #1290
	lw %a7 %a11 24 #1290
	lw %a8 %a11 20 #1290
	lw %a9 %a11 16 #1290
	lw %a10 %a11 12 #1290
	sw %a9 %sp 0 #1290
	lw %a9 %a11 8 #1290
	sw %a9 %sp 4 #1290
	lw %a9 %a11 4 #1290
	sw %a10 %sp 8 #1291
	slli %a10 %a0 2 #1291
	add %a12 %a1 %a10 #1291
	lw %a10 %a12 0 #1291
	addi %a12 %zero -1
	bne %a10 %a12 beq_else.44920
	jalr %zero %ra 0 #1292
beq_else.44920:
	sw %a9 %sp 12 #20
	slli %a9 %a10 2 #20
	add %a12 %a8 %a9 #20
	lw %a9 %a12 0 #20
	lw %f0 %a4 0 #886
	sw %a3 %sp 16 #316
	lw %a3 %a9 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #886
	lw %f1 %a4 4 #886
	lw %a3 %a9 20 #326
	lw %f2 %a3 4 #331
	fsub %f1 %f1 %f2 #887
	lw %f2 %a4 8 #886
	lw %a3 %a9 20 #336
	lw %f3 %a3 8 #341
	fsub %f2 %f2 %f3 #888
	lw %a3 %a9 4 #238
	sw %a4 %sp 20 #868
	sw %a7 %sp 24 #868
	sw %a2 %sp 28 #868
	sw %a1 %sp 32 #868
	sw %a11 %sp 36 #868
	sw %a0 %sp 40 #868
	sw %a8 %sp 44 #868
	sw %a10 %sp 48 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.44922 # nontail if
	add %a1 %a2 %zero
	add %a0 %a9 %zero
	add %a11 %a6 %zero
	sw %ra %sp 52 #891 call cls
	lw %a10 %a11 0 #891
	addi %sp %sp 56 #891	
	jalr %ra %a10 0 #891
	addi %sp %sp -56 #891
	lw %ra %sp 52 #891
	jal %zero beq_cont.44923 # then sentence ends
beq_else.44922:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.44924 # nontail if
	lw %a3 %a9 16 #306
	lw %f3 %a2 0 #181
	lw %f4 %a3 0 #181
	fmul %f3 %f3 %f4 #181
	lw %f4 %a2 4 #181
	lw %f5 %a3 4 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	lw %f4 %a2 8 #181
	lw %f5 %a3 8 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	fispos %a5 %f3 #811
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.44926 # nontail if
	addi %a0 %zero 0 #814
	jal %zero beq_cont.44927 # then sentence ends
beq_else.44926:
	lw %f4 %a3 0 #186
	fmul %f0 %f4 %f0 #186
	lw %f4 %a3 4 #186
	fmul %f1 %f4 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a3 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	fneg %f0 %f0 #812
	fdiv %f0 %f0 %f3 #812
	sw %f0 %a7 0 #812
	addi %a0 %zero 1 #813
beq_cont.44927:
	jal %zero beq_cont.44925 # then sentence ends
beq_else.44924:
	add %a1 %a2 %zero
	add %a0 %a9 %zero
	add %a11 %a5 %zero
	sw %ra %sp 52 #893 call cls
	lw %a10 %a11 0 #893
	addi %sp %sp 56 #893	
	jalr %ra %a10 0 #893
	addi %sp %sp -56 #893
	lw %ra %sp 52 #893
beq_cont.44925:
beq_cont.44923:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44928
	lw %a0 %sp 48 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 44 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44929
	jalr %zero %ra 0 #1325
beq_else.44929:
	lw %a0 %sp 40 #1324
	addi %a0 %a0 1 #1324
	lw %a1 %sp 32 #1324
	lw %a2 %sp 28 #1324
	lw %a11 %sp 36 #1324
	lw %a10 %a11 0 #1324
	jalr %zero %a10 0 #1324
beq_else.44928:
	lw %a1 %sp 24 #37
	lw %f0 %a1 0 #37
	li %f1 l.37367 #1301
	fless %a1 %f1 %f0 #1301
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.44931 # nontail if
	jal %zero beq_cont.44932 # then sentence ends
beq_else.44931:
	lw %a1 %sp 16 #41
	lw %f1 %a1 0 #41
	fless %a2 %f0 %f1 #1302
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.44933 # nontail if
	jal %zero beq_cont.44934 # then sentence ends
beq_else.44933:
	li %f1 l.37930 #1304
	fadd %f0 %f0 %f1 #1304
	lw %a2 %sp 28 #783
	lw %f1 %a2 0 #783
	fmul %f1 %f1 %f0 #1305
	lw %a3 %sp 20 #64
	lw %f2 %a3 0 #64
	fadd %f1 %f1 %f2 #1305
	lw %f2 %a2 4 #783
	fmul %f2 %f2 %f0 #1306
	lw %f3 %a3 4 #64
	fadd %f2 %f2 %f3 #1306
	lw %f3 %a2 8 #783
	fmul %f3 %f3 %f0 #1307
	lw %f4 %a3 8 #64
	fadd %f3 %f3 %f4 #1307
	lw %a3 %sp 32 #1194
	lw %a4 %a3 0 #1194
	sw %a0 %sp 52 #1195
	sw %f3 %sp 56 #1195
	sw %f2 %sp 64 #1195
	sw %f1 %sp 72 #1195
	sw %f0 %sp 80 #1195
	addi %a12 %zero -1
	bne %a4 %a12 beq_else.44935 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.44936 # then sentence ends
beq_else.44935:
	slli %a4 %a4 2 #20
	lw %a5 %sp 44 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	add %a0 %a4 %zero
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 92 #1198 call dir
	addi %sp %sp 96 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -96 #1198
	lw %ra %sp 92 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44937 # nontail if
	lw %a1 %sp 32 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44939 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.44940 # then sentence ends
beq_else.44939:
	slli %a0 %a0 2 #20
	lw %a2 %sp 44 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 72 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a0 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 64 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a0 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 56 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.44941 # nontail if
	fabs %f0 %f0 #1157
	lw %a3 %a0 16 #276
	lw %f6 %a3 0 #281
	fless %a3 %f0 %f6 #1157
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44943 # nontail if
	addi %a3 %zero 0 #1161
	jal %zero beq_cont.44944 # then sentence ends
beq_else.44943:
	fabs %f0 %f2 #1158
	lw %a3 %a0 16 #286
	lw %f2 %a3 4 #291
	fless %a3 %f0 %f2 #1158
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44945 # nontail if
	addi %a3 %zero 0 #1160
	jal %zero beq_cont.44946 # then sentence ends
beq_else.44945:
	fabs %f0 %f4 #1159
	lw %a3 %a0 16 #296
	lw %f2 %a3 8 #301
	fless %a3 %f0 %f2 #1159
beq_cont.44946:
beq_cont.44944:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44947 # nontail if
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44949 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.44950 # then sentence ends
beq_else.44949:
	addi %a0 %zero 0 #1162
beq_cont.44950:
	jal %zero beq_cont.44948 # then sentence ends
beq_else.44947:
	lw %a0 %a0 24 #258
beq_cont.44948:
	jal %zero beq_cont.44942 # then sentence ends
beq_else.44941:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.44951 # nontail if
	lw %a3 %a0 16 #306
	lw %f6 %a3 0 #186
	fmul %f0 %f6 %f0 #186
	lw %f6 %a3 4 #186
	fmul %f2 %f6 %f2 #186
	fadd %f0 %f0 %f2 #186
	lw %f2 %a3 8 #186
	fmul %f2 %f2 %f4 #186
	fadd %f0 %f0 %f2 #186
	lw %a0 %a0 24 #258
	fisneg %a3 %f0 #1168
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44953 # nontail if
	addi %a0 %a3 0 #105
	jal %zero beq_cont.44954 # then sentence ends
beq_else.44953:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.44955 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.44956 # then sentence ends
beq_else.44955:
	addi %a0 %zero 0 #105
beq_cont.44956:
beq_cont.44954:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44957 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.44958 # then sentence ends
beq_else.44957:
	addi %a0 %zero 0 #1168
beq_cont.44958:
	jal %zero beq_cont.44952 # then sentence ends
beq_else.44951:
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 92 #1189 call dir
	addi %sp %sp 96 #1189	
	jal %ra is_second_outside.2725 #1189
	addi %sp %sp -96 #1189
	lw %ra %sp 92 #1189
beq_cont.44952:
beq_cont.44942:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44959 # nontail if
	lw %a1 %sp 32 #1194
	lw %a0 %a1 8 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.44961 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.44962 # then sentence ends
beq_else.44961:
	slli %a0 %a0 2 #20
	lw %a2 %sp 44 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 72 #1198
	lw %f1 %sp 64 #1198
	lw %f2 %sp 56 #1198
	sw %ra %sp 92 #1198 call dir
	addi %sp %sp 96 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -96 #1198
	lw %ra %sp 92 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44963 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 72 #1201
	lw %f1 %sp 64 #1201
	lw %f2 %sp 56 #1201
	lw %a1 %sp 32 #1201
	lw %a11 %sp 12 #1201
	sw %ra %sp 92 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 96 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -96 #1201
	lw %ra %sp 92 #1201
	jal %zero beq_cont.44964 # then sentence ends
beq_else.44963:
	addi %a0 %zero 0 #1199
beq_cont.44964:
beq_cont.44962:
	jal %zero beq_cont.44960 # then sentence ends
beq_else.44959:
	addi %a0 %zero 0 #1199
beq_cont.44960:
beq_cont.44940:
	jal %zero beq_cont.44938 # then sentence ends
beq_else.44937:
	addi %a0 %zero 0 #1199
beq_cont.44938:
beq_cont.44936:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.44965 # nontail if
	jal %zero beq_cont.44966 # then sentence ends
beq_else.44965:
	lw %a0 %sp 16 #1310
	lw %f0 %sp 80 #1310
	sw %f0 %a0 0 #1310
	lw %a0 %sp 8 #133
	lw %f0 %sp 72 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 64 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 56 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1312
	lw %a1 %sp 48 #1312
	sw %a1 %a0 0 #1312
	lw %a0 %sp 0 #1313
	lw %a1 %sp 52 #1313
	sw %a1 %a0 0 #1313
beq_cont.44966:
beq_cont.44934:
beq_cont.44932:
	lw %a0 %sp 40 #1319
	addi %a0 %a0 1 #1319
	lw %a1 %sp 32 #1319
	lw %a2 %sp 28 #1319
	lw %a11 %sp 36 #1319
	lw %a10 %a11 0 #1319
	jalr %zero %a10 0 #1319
solve_one_or_network.2754:
	lw %a3 %a11 8 #1331
	lw %a4 %a11 4 #1331
	slli %a5 %a0 2 #1332
	add %a12 %a1 %a5 #1332
	lw %a5 %a12 0 #1332
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.44967
	jalr %zero %ra 0 #1337
beq_else.44967:
	slli %a5 %a5 2 #31
	add %a12 %a4 %a5 #31
	lw %a5 %a12 0 #31
	addi %a6 %zero 0 #1335
	sw %a11 %sp 0 #1335
	sw %a2 %sp 4 #1335
	sw %a3 %sp 8 #1335
	sw %a4 %sp 12 #1335
	sw %a1 %sp 16 #1335
	sw %a0 %sp 20 #1335
	add %a1 %a5 %zero
	add %a0 %a6 %zero
	add %a11 %a3 %zero
	sw %ra %sp 28 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 32 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -32 #1335
	lw %ra %sp 28 #1335
	lw %a0 %sp 20 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 16 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44969
	jalr %zero %ra 0 #1337
beq_else.44969:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1335
	lw %a5 %sp 4 #1335
	lw %a11 %sp 8 #1335
	sw %a0 %sp 24 #1335
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 28 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 32 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -32 #1335
	lw %ra %sp 28 #1335
	lw %a0 %sp 24 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 16 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44971
	jalr %zero %ra 0 #1337
beq_else.44971:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1335
	lw %a5 %sp 4 #1335
	lw %a11 %sp 8 #1335
	sw %a0 %sp 28 #1335
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 36 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 40 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -40 #1335
	lw %ra %sp 36 #1335
	lw %a0 %sp 28 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 16 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44973
	jalr %zero %ra 0 #1337
beq_else.44973:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1335
	lw %a5 %sp 4 #1335
	lw %a11 %sp 8 #1335
	sw %a0 %sp 32 #1335
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 36 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 40 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -40 #1335
	lw %ra %sp 36 #1335
	lw %a0 %sp 32 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 16 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44975
	jalr %zero %ra 0 #1337
beq_else.44975:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1335
	lw %a5 %sp 4 #1335
	lw %a11 %sp 8 #1335
	sw %a0 %sp 36 #1335
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 44 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 48 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -48 #1335
	lw %ra %sp 44 #1335
	lw %a0 %sp 36 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 16 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44977
	jalr %zero %ra 0 #1337
beq_else.44977:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1335
	lw %a5 %sp 4 #1335
	lw %a11 %sp 8 #1335
	sw %a0 %sp 40 #1335
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 44 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 48 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -48 #1335
	lw %ra %sp 44 #1335
	lw %a0 %sp 40 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 16 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44979
	jalr %zero %ra 0 #1337
beq_else.44979:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1335
	lw %a5 %sp 4 #1335
	lw %a11 %sp 8 #1335
	sw %a0 %sp 44 #1335
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 16 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44981
	jalr %zero %ra 0 #1337
beq_else.44981:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 4 #1335
	lw %a11 %sp 8 #1335
	sw %a0 %sp 48 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 48 #1336
	addi %a0 %a0 1 #1336
	lw %a1 %sp 16 #1336
	lw %a2 %sp 4 #1336
	lw %a11 %sp 0 #1336
	lw %a10 %a11 0 #1336
	jalr %zero %a10 0 #1336
trace_or_matrix.2758:
	lw %a3 %a11 40 #1341
	lw %a4 %a11 36 #1341
	lw %a5 %a11 32 #1341
	lw %a6 %a11 28 #1341
	lw %a7 %a11 24 #1341
	lw %a8 %a11 20 #1341
	lw %a9 %a11 16 #1341
	lw %a10 %a11 12 #1341
	sw %a8 %sp 0 #1341
	lw %a8 %a11 8 #1341
	sw %a11 %sp 4 #1341
	lw %a11 %a11 4 #1341
	sw %a0 %sp 8 #1342
	slli %a0 %a0 2 #1342
	add %a12 %a1 %a0 #1342
	lw %a0 %a12 0 #1342
	sw %a1 %sp 12 #1343
	lw %a1 %a0 0 #1343
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44983
	jalr %zero %ra 0 #1345
beq_else.44983:
	sw %a3 %sp 16 #1344
	sw %a7 %sp 20 #1344
	sw %a4 %sp 24 #1344
	sw %a9 %sp 28 #1344
	sw %a2 %sp 32 #1344
	sw %a10 %sp 36 #1344
	sw %a11 %sp 40 #1344
	addi %a12 %zero 99
	bne %a1 %a12 beq_else.44985 # nontail if
	lw %a1 %a0 4 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44987 # nontail if
	jal %zero beq_cont.44988 # then sentence ends
beq_else.44987:
	slli %a1 %a1 2 #31
	add %a12 %a11 %a1 #31
	lw %a1 %a12 0 #31
	addi %a5 %zero 0 #1335
	sw %a0 %sp 44 #1335
	add %a0 %a5 %zero
	add %a11 %a10 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 8 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44989 # nontail if
	jal %zero beq_cont.44990 # then sentence ends
beq_else.44989:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 12 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44991 # nontail if
	jal %zero beq_cont.44992 # then sentence ends
beq_else.44991:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 16 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44993 # nontail if
	jal %zero beq_cont.44994 # then sentence ends
beq_else.44993:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 20 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44995 # nontail if
	jal %zero beq_cont.44996 # then sentence ends
beq_else.44995:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 24 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44997 # nontail if
	jal %zero beq_cont.44998 # then sentence ends
beq_else.44997:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 28 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.44999 # nontail if
	jal %zero beq_cont.45000 # then sentence ends
beq_else.44999:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	addi %a0 %zero 8 #1336
	lw %a1 %sp 44 #1336
	lw %a2 %sp 32 #1336
	lw %a11 %sp 28 #1336
	sw %ra %sp 52 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 56 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -56 #1336
	lw %ra %sp 52 #1336
beq_cont.45000:
beq_cont.44998:
beq_cont.44996:
beq_cont.44994:
beq_cont.44992:
beq_cont.44990:
beq_cont.44988:
	jal %zero beq_cont.44986 # then sentence ends
beq_else.44985:
	slli %a1 %a1 2 #20
	add %a12 %a8 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %a4 0 #886
	lw %a8 %a1 20 #316
	lw %f1 %a8 0 #321
	fsub %f0 %f0 %f1 #886
	lw %f1 %a4 4 #886
	lw %a8 %a1 20 #326
	lw %f2 %a8 4 #331
	fsub %f1 %f1 %f2 #887
	lw %f2 %a4 8 #886
	lw %a8 %a1 20 #336
	lw %f3 %a8 8 #341
	fsub %f2 %f2 %f3 #888
	lw %a8 %a1 4 #238
	sw %a0 %sp 44 #868
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.45001 # nontail if
	add %a0 %a1 %zero
	add %a11 %a6 %zero
	add %a1 %a2 %zero
	sw %ra %sp 52 #891 call cls
	lw %a10 %a11 0 #891
	addi %sp %sp 56 #891	
	jalr %ra %a10 0 #891
	addi %sp %sp -56 #891
	lw %ra %sp 52 #891
	jal %zero beq_cont.45002 # then sentence ends
beq_else.45001:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.45003 # nontail if
	lw %a1 %a1 16 #306
	lw %f3 %a2 0 #181
	lw %f4 %a1 0 #181
	fmul %f3 %f3 %f4 #181
	lw %f4 %a2 4 #181
	lw %f5 %a1 4 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	lw %f4 %a2 8 #181
	lw %f5 %a1 8 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	fispos %a5 %f3 #811
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.45005 # nontail if
	addi %a0 %zero 0 #814
	jal %zero beq_cont.45006 # then sentence ends
beq_else.45005:
	lw %f4 %a1 0 #186
	fmul %f0 %f4 %f0 #186
	lw %f4 %a1 4 #186
	fmul %f1 %f4 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a1 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	fneg %f0 %f0 #812
	fdiv %f0 %f0 %f3 #812
	sw %f0 %a7 0 #812
	addi %a0 %zero 1 #813
beq_cont.45006:
	jal %zero beq_cont.45004 # then sentence ends
beq_else.45003:
	add %a0 %a1 %zero
	add %a11 %a5 %zero
	add %a1 %a2 %zero
	sw %ra %sp 52 #893 call cls
	lw %a10 %a11 0 #893
	addi %sp %sp 56 #893	
	jalr %ra %a10 0 #893
	addi %sp %sp -56 #893
	lw %ra %sp 52 #893
beq_cont.45004:
beq_cont.45002:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45007 # nontail if
	jal %zero beq_cont.45008 # then sentence ends
beq_else.45007:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	lw %a1 %sp 16 #41
	lw %f1 %a1 0 #41
	fless %a2 %f0 %f1 #1355
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45009 # nontail if
	jal %zero beq_cont.45010 # then sentence ends
beq_else.45009:
	lw %a2 %sp 44 #1332
	lw %a3 %a2 4 #1332
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45011 # nontail if
	jal %zero beq_cont.45012 # then sentence ends
beq_else.45011:
	slli %a3 %a3 2 #31
	lw %a4 %sp 40 #31
	add %a12 %a4 %a3 #31
	lw %a3 %a12 0 #31
	addi %a5 %zero 0 #1335
	lw %a6 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a6 %zero
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 8 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45013 # nontail if
	jal %zero beq_cont.45014 # then sentence ends
beq_else.45013:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 12 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45015 # nontail if
	jal %zero beq_cont.45016 # then sentence ends
beq_else.45015:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 16 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45017 # nontail if
	jal %zero beq_cont.45018 # then sentence ends
beq_else.45017:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 20 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45019 # nontail if
	jal %zero beq_cont.45020 # then sentence ends
beq_else.45019:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 24 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45021 # nontail if
	jal %zero beq_cont.45022 # then sentence ends
beq_else.45021:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 28 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45023 # nontail if
	jal %zero beq_cont.45024 # then sentence ends
beq_else.45023:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 56 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -56 #1335
	lw %ra %sp 52 #1335
	addi %a0 %zero 8 #1336
	lw %a1 %sp 44 #1336
	lw %a2 %sp 32 #1336
	lw %a11 %sp 28 #1336
	sw %ra %sp 52 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 56 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -56 #1336
	lw %ra %sp 52 #1336
beq_cont.45024:
beq_cont.45022:
beq_cont.45020:
beq_cont.45018:
beq_cont.45016:
beq_cont.45014:
beq_cont.45012:
beq_cont.45010:
beq_cont.45008:
beq_cont.44986:
	lw %a0 %sp 8 #1360
	addi %a0 %a0 1 #1360
	slli %a1 %a0 2 #1342
	lw %a2 %sp 12 #1342
	add %a12 %a2 %a1 #1342
	lw %a1 %a12 0 #1342
	lw %a3 %a1 0 #1343
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45025
	jalr %zero %ra 0 #1345
beq_else.45025:
	sw %a0 %sp 48 #1344
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.45027 # nontail if
	lw %a3 %a1 4 #1332
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45029 # nontail if
	jal %zero beq_cont.45030 # then sentence ends
beq_else.45029:
	slli %a3 %a3 2 #31
	lw %a4 %sp 40 #31
	add %a12 %a4 %a3 #31
	lw %a3 %a12 0 #31
	addi %a5 %zero 0 #1335
	lw %a6 %sp 32 #1335
	lw %a11 %sp 36 #1335
	sw %a1 %sp 52 #1335
	add %a2 %a6 %zero
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 8 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45031 # nontail if
	jal %zero beq_cont.45032 # then sentence ends
beq_else.45031:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 12 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45033 # nontail if
	jal %zero beq_cont.45034 # then sentence ends
beq_else.45033:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 16 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45035 # nontail if
	jal %zero beq_cont.45036 # then sentence ends
beq_else.45035:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 20 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45037 # nontail if
	jal %zero beq_cont.45038 # then sentence ends
beq_else.45037:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 24 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45039 # nontail if
	jal %zero beq_cont.45040 # then sentence ends
beq_else.45039:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1335
	lw %a3 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	addi %a0 %zero 7 #1336
	lw %a1 %sp 52 #1336
	lw %a2 %sp 32 #1336
	lw %a11 %sp 28 #1336
	sw %ra %sp 60 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 64 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -64 #1336
	lw %ra %sp 60 #1336
beq_cont.45040:
beq_cont.45038:
beq_cont.45036:
beq_cont.45034:
beq_cont.45032:
beq_cont.45030:
	jal %zero beq_cont.45028 # then sentence ends
beq_else.45027:
	lw %a4 %sp 32 #1352
	lw %a5 %sp 24 #1352
	lw %a11 %sp 0 #1352
	sw %a1 %sp 52 #1352
	add %a2 %a5 %zero
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1352 call cls
	lw %a10 %a11 0 #1352
	addi %sp %sp 64 #1352	
	jalr %ra %a10 0 #1352
	addi %sp %sp -64 #1352
	lw %ra %sp 60 #1352
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45041 # nontail if
	jal %zero beq_cont.45042 # then sentence ends
beq_else.45041:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 16 #41
	lw %f1 %a0 0 #41
	fless %a0 %f0 %f1 #1355
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45043 # nontail if
	jal %zero beq_cont.45044 # then sentence ends
beq_else.45043:
	lw %a0 %sp 52 #1332
	lw %a1 %a0 4 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45045 # nontail if
	jal %zero beq_cont.45046 # then sentence ends
beq_else.45045:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 8 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45047 # nontail if
	jal %zero beq_cont.45048 # then sentence ends
beq_else.45047:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 12 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45049 # nontail if
	jal %zero beq_cont.45050 # then sentence ends
beq_else.45049:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 16 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45051 # nontail if
	jal %zero beq_cont.45052 # then sentence ends
beq_else.45051:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 20 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45053 # nontail if
	jal %zero beq_cont.45054 # then sentence ends
beq_else.45053:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	lw %a0 %sp 52 #1332
	lw %a1 %a0 24 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45055 # nontail if
	jal %zero beq_cont.45056 # then sentence ends
beq_else.45055:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1335
	lw %a3 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 60 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 64 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -64 #1335
	lw %ra %sp 60 #1335
	addi %a0 %zero 7 #1336
	lw %a1 %sp 52 #1336
	lw %a2 %sp 32 #1336
	lw %a11 %sp 28 #1336
	sw %ra %sp 60 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 64 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -64 #1336
	lw %ra %sp 60 #1336
beq_cont.45056:
beq_cont.45054:
beq_cont.45052:
beq_cont.45050:
beq_cont.45048:
beq_cont.45046:
beq_cont.45044:
beq_cont.45042:
beq_cont.45028:
	lw %a0 %sp 48 #1360
	addi %a0 %a0 1 #1360
	lw %a1 %sp 12 #1360
	lw %a2 %sp 32 #1360
	lw %a11 %sp 4 #1360
	lw %a10 %a11 0 #1360
	jalr %zero %a10 0 #1360
solve_each_element_fast.2764:
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
	sw %a10 %sp 4 #507
	lw %a10 %a2 0 #507
	sw %a9 %sp 8 #1383
	slli %a9 %a0 2 #1383
	add %a12 %a1 %a9 #1383
	lw %a9 %a12 0 #1383
	addi %a12 %zero -1
	bne %a9 %a12 beq_else.45057
	jalr %zero %ra 0 #1384
beq_else.45057:
	sw %a8 %sp 12 #20
	slli %a8 %a9 2 #20
	add %a12 %a7 %a8 #20
	lw %a8 %a12 0 #20
	sw %a4 %sp 16 #427
	lw %a4 %a8 40 #427
	lw %f0 %a4 0 #19
	lw %f1 %a4 4 #19
	lw %f2 %a4 8 #19
	sw %a10 %sp 20 #513
	lw %a10 %a2 4 #513
	sw %a3 %sp 24 #968
	slli %a3 %a9 2 #968
	add %a12 %a10 %a3 #968
	lw %a3 %a12 0 #968
	lw %a10 %a8 4 #238
	sw %a6 %sp 28 #868
	sw %a2 %sp 32 #868
	sw %a1 %sp 36 #868
	sw %a11 %sp 40 #868
	sw %a0 %sp 44 #868
	sw %a7 %sp 48 #868
	sw %a9 %sp 52 #868
	addi %a12 %zero 1
	bne %a10 %a12 beq_else.45059 # nontail if
	lw %a4 %a2 0 #507
	add %a2 %a3 %zero
	add %a1 %a4 %zero
	add %a0 %a8 %zero
	add %a11 %a5 %zero
	sw %ra %sp 60 #1019 call cls
	lw %a10 %a11 0 #1019
	addi %sp %sp 64 #1019	
	jalr %ra %a10 0 #1019
	addi %sp %sp -64 #1019
	lw %ra %sp 60 #1019
	jal %zero beq_cont.45060 # then sentence ends
beq_else.45059:
	addi %a12 %zero 2
	bne %a10 %a12 beq_else.45061 # nontail if
	lw %f0 %a3 0 #983
	fisneg %a5 %f0 #983
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.45063 # nontail if
	addi %a0 %zero 0 #986
	jal %zero beq_cont.45064 # then sentence ends
beq_else.45063:
	lw %f0 %a3 0 #983
	lw %f1 %a4 12 #984
	fmul %f0 %f0 %f1 #984
	sw %f0 %a6 0 #984
	addi %a0 %zero 1 #985
beq_cont.45064:
	jal %zero beq_cont.45062 # then sentence ends
beq_else.45061:
	lw %f3 %a3 0 #992
	fiszero %a5 %f3 #993
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.45065 # nontail if
	lw %f4 %a3 4 #992
	fmul %f0 %f4 %f0 #996
	lw %f4 %a3 8 #992
	fmul %f1 %f4 %f1 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a3 12 #992
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a4 12 #997
	fmul %f2 %f0 %f0 #998
	fmul %f1 %f3 %f1 #998
	fsub %f1 %f2 %f1 #998
	fispos %a4 %f1 #999
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45067 # nontail if
	addi %a0 %zero 0 #1005
	jal %zero beq_cont.45068 # then sentence ends
beq_else.45067:
	lw %a4 %a8 24 #258
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45069 # nontail if
	sqrt %f1 %f1 #1003
	fsub %f0 %f0 %f1 #1003
	lw %f1 %a3 16 #992
	fmul %f0 %f0 %f1 #1003
	sw %f0 %a6 0 #1003
	jal %zero beq_cont.45070 # then sentence ends
beq_else.45069:
	sqrt %f1 %f1 #1001
	fadd %f0 %f0 %f1 #1001
	lw %f1 %a3 16 #992
	fmul %f0 %f0 %f1 #1001
	sw %f0 %a6 0 #1001
beq_cont.45070:
	addi %a0 %zero 1 #1004
beq_cont.45068:
	jal %zero beq_cont.45066 # then sentence ends
beq_else.45065:
	addi %a0 %zero 0 #994
beq_cont.45066:
beq_cont.45062:
beq_cont.45060:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45071
	lw %a0 %sp 52 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 48 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45072
	jalr %zero %ra 0 #1417
beq_else.45072:
	lw %a0 %sp 44 #1416
	addi %a0 %a0 1 #1416
	lw %a1 %sp 36 #1416
	lw %a2 %sp 32 #1416
	lw %a11 %sp 40 #1416
	lw %a10 %a11 0 #1416
	jalr %zero %a10 0 #1416
beq_else.45071:
	lw %a1 %sp 28 #37
	lw %f0 %a1 0 #37
	li %f1 l.37367 #1393
	fless %a1 %f1 %f0 #1393
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45074 # nontail if
	jal %zero beq_cont.45075 # then sentence ends
beq_else.45074:
	lw %a1 %sp 24 #41
	lw %f1 %a1 0 #41
	fless %a2 %f0 %f1 #1394
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45076 # nontail if
	jal %zero beq_cont.45077 # then sentence ends
beq_else.45076:
	li %f1 l.37930 #1396
	fadd %f0 %f0 %f1 #1396
	lw %a2 %sp 20 #903
	lw %f1 %a2 0 #903
	fmul %f1 %f1 %f0 #1397
	lw %a3 %sp 16 #66
	lw %f2 %a3 0 #66
	fadd %f1 %f1 %f2 #1397
	lw %f2 %a2 4 #903
	fmul %f2 %f2 %f0 #1398
	lw %f3 %a3 4 #66
	fadd %f2 %f2 %f3 #1398
	lw %f3 %a2 8 #903
	fmul %f3 %f3 %f0 #1399
	lw %f4 %a3 8 #66
	fadd %f3 %f3 %f4 #1399
	lw %a2 %sp 36 #1194
	lw %a3 %a2 0 #1194
	sw %a0 %sp 56 #1195
	sw %f3 %sp 64 #1195
	sw %f2 %sp 72 #1195
	sw %f1 %sp 80 #1195
	sw %f0 %sp 88 #1195
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45079 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.45080 # then sentence ends
beq_else.45079:
	slli %a3 %a3 2 #20
	lw %a4 %sp 48 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	add %a0 %a3 %zero
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 100 #1198 call dir
	addi %sp %sp 104 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -104 #1198
	lw %ra %sp 100 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45081 # nontail if
	lw %a1 %sp 36 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.45083 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.45084 # then sentence ends
beq_else.45083:
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 80 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a0 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 72 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a0 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 64 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.45085 # nontail if
	fabs %f0 %f0 #1157
	lw %a3 %a0 16 #276
	lw %f6 %a3 0 #281
	fless %a3 %f0 %f6 #1157
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.45087 # nontail if
	addi %a3 %zero 0 #1161
	jal %zero beq_cont.45088 # then sentence ends
beq_else.45087:
	fabs %f0 %f2 #1158
	lw %a3 %a0 16 #286
	lw %f2 %a3 4 #291
	fless %a3 %f0 %f2 #1158
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.45089 # nontail if
	addi %a3 %zero 0 #1160
	jal %zero beq_cont.45090 # then sentence ends
beq_else.45089:
	fabs %f0 %f4 #1159
	lw %a3 %a0 16 #296
	lw %f2 %a3 8 #301
	fless %a3 %f0 %f2 #1159
beq_cont.45090:
beq_cont.45088:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.45091 # nontail if
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45093 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.45094 # then sentence ends
beq_else.45093:
	addi %a0 %zero 0 #1162
beq_cont.45094:
	jal %zero beq_cont.45092 # then sentence ends
beq_else.45091:
	lw %a0 %a0 24 #258
beq_cont.45092:
	jal %zero beq_cont.45086 # then sentence ends
beq_else.45085:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.45095 # nontail if
	lw %a3 %a0 16 #306
	lw %f6 %a3 0 #186
	fmul %f0 %f6 %f0 #186
	lw %f6 %a3 4 #186
	fmul %f2 %f6 %f2 #186
	fadd %f0 %f0 %f2 #186
	lw %f2 %a3 8 #186
	fmul %f2 %f2 %f4 #186
	fadd %f0 %f0 %f2 #186
	lw %a0 %a0 24 #258
	fisneg %a3 %f0 #1168
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45097 # nontail if
	addi %a0 %a3 0 #105
	jal %zero beq_cont.45098 # then sentence ends
beq_else.45097:
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.45099 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.45100 # then sentence ends
beq_else.45099:
	addi %a0 %zero 0 #105
beq_cont.45100:
beq_cont.45098:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45101 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.45102 # then sentence ends
beq_else.45101:
	addi %a0 %zero 0 #1168
beq_cont.45102:
	jal %zero beq_cont.45096 # then sentence ends
beq_else.45095:
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 100 #1189 call dir
	addi %sp %sp 104 #1189	
	jal %ra is_second_outside.2725 #1189
	addi %sp %sp -104 #1189
	lw %ra %sp 100 #1189
beq_cont.45096:
beq_cont.45086:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45103 # nontail if
	lw %a1 %sp 36 #1194
	lw %a0 %a1 8 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.45105 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.45106 # then sentence ends
beq_else.45105:
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 80 #1198
	lw %f1 %sp 72 #1198
	lw %f2 %sp 64 #1198
	sw %ra %sp 100 #1198 call dir
	addi %sp %sp 104 #1198	
	jal %ra is_outside.2730 #1198
	addi %sp %sp -104 #1198
	lw %ra %sp 100 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45107 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 80 #1201
	lw %f1 %sp 72 #1201
	lw %f2 %sp 64 #1201
	lw %a1 %sp 36 #1201
	lw %a11 %sp 12 #1201
	sw %ra %sp 100 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 104 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -104 #1201
	lw %ra %sp 100 #1201
	jal %zero beq_cont.45108 # then sentence ends
beq_else.45107:
	addi %a0 %zero 0 #1199
beq_cont.45108:
beq_cont.45106:
	jal %zero beq_cont.45104 # then sentence ends
beq_else.45103:
	addi %a0 %zero 0 #1199
beq_cont.45104:
beq_cont.45084:
	jal %zero beq_cont.45082 # then sentence ends
beq_else.45081:
	addi %a0 %zero 0 #1199
beq_cont.45082:
beq_cont.45080:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45109 # nontail if
	jal %zero beq_cont.45110 # then sentence ends
beq_else.45109:
	lw %a0 %sp 24 #1402
	lw %f0 %sp 88 #1402
	sw %f0 %a0 0 #1402
	lw %a0 %sp 8 #133
	lw %f0 %sp 80 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 72 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 64 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1404
	lw %a1 %sp 52 #1404
	sw %a1 %a0 0 #1404
	lw %a0 %sp 0 #1405
	lw %a1 %sp 56 #1405
	sw %a1 %a0 0 #1405
beq_cont.45110:
beq_cont.45077:
beq_cont.45075:
	lw %a0 %sp 44 #1411
	addi %a0 %a0 1 #1411
	lw %a1 %sp 36 #1411
	lw %a2 %sp 32 #1411
	lw %a11 %sp 40 #1411
	lw %a10 %a11 0 #1411
	jalr %zero %a10 0 #1411
solve_one_or_network_fast.2768:
	lw %a3 %a11 8 #1422
	lw %a4 %a11 4 #1422
	slli %a5 %a0 2 #1423
	add %a12 %a1 %a5 #1423
	lw %a5 %a12 0 #1423
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.45111
	jalr %zero %ra 0 #1428
beq_else.45111:
	slli %a5 %a5 2 #31
	add %a12 %a4 %a5 #31
	lw %a5 %a12 0 #31
	addi %a6 %zero 0 #1426
	sw %a11 %sp 0 #1426
	sw %a2 %sp 4 #1426
	sw %a3 %sp 8 #1426
	sw %a4 %sp 12 #1426
	sw %a1 %sp 16 #1426
	sw %a0 %sp 20 #1426
	add %a1 %a5 %zero
	add %a0 %a6 %zero
	add %a11 %a3 %zero
	sw %ra %sp 28 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 32 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -32 #1426
	lw %ra %sp 28 #1426
	lw %a0 %sp 20 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 16 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45113
	jalr %zero %ra 0 #1428
beq_else.45113:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 4 #1426
	lw %a11 %sp 8 #1426
	sw %a0 %sp 24 #1426
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 28 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 32 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -32 #1426
	lw %ra %sp 28 #1426
	lw %a0 %sp 24 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 16 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45115
	jalr %zero %ra 0 #1428
beq_else.45115:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 4 #1426
	lw %a11 %sp 8 #1426
	sw %a0 %sp 28 #1426
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 36 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 40 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -40 #1426
	lw %ra %sp 36 #1426
	lw %a0 %sp 28 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 16 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45117
	jalr %zero %ra 0 #1428
beq_else.45117:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 4 #1426
	lw %a11 %sp 8 #1426
	sw %a0 %sp 32 #1426
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 36 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 40 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -40 #1426
	lw %ra %sp 36 #1426
	lw %a0 %sp 32 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 16 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45119
	jalr %zero %ra 0 #1428
beq_else.45119:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 4 #1426
	lw %a11 %sp 8 #1426
	sw %a0 %sp 36 #1426
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 36 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 16 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45121
	jalr %zero %ra 0 #1428
beq_else.45121:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 4 #1426
	lw %a11 %sp 8 #1426
	sw %a0 %sp 40 #1426
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 16 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45123
	jalr %zero %ra 0 #1428
beq_else.45123:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 4 #1426
	lw %a11 %sp 8 #1426
	sw %a0 %sp 44 #1426
	add %a2 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 44 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 16 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45125
	jalr %zero %ra 0 #1428
beq_else.45125:
	slli %a1 %a1 2 #31
	lw %a3 %sp 12 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 4 #1426
	lw %a11 %sp 8 #1426
	sw %a0 %sp 48 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1427
	addi %a0 %a0 1 #1427
	lw %a1 %sp 16 #1427
	lw %a2 %sp 4 #1427
	lw %a11 %sp 0 #1427
	lw %a10 %a11 0 #1427
	jalr %zero %a10 0 #1427
trace_or_matrix_fast.2772:
	lw %a3 %a11 32 #1432
	lw %a4 %a11 28 #1432
	lw %a5 %a11 24 #1432
	lw %a6 %a11 20 #1432
	lw %a7 %a11 16 #1432
	lw %a8 %a11 12 #1432
	lw %a9 %a11 8 #1432
	lw %a10 %a11 4 #1432
	sw %a11 %sp 0 #1433
	slli %a11 %a0 2 #1433
	add %a12 %a1 %a11 #1433
	lw %a11 %a12 0 #1433
	sw %a5 %sp 4 #1434
	lw %a5 %a11 0 #1434
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.45127
	jalr %zero %ra 0 #1436
beq_else.45127:
	sw %a3 %sp 8 #1435
	sw %a6 %sp 12 #1435
	sw %a7 %sp 16 #1435
	sw %a2 %sp 20 #1435
	sw %a8 %sp 24 #1435
	sw %a10 %sp 28 #1435
	sw %a1 %sp 32 #1435
	sw %a0 %sp 36 #1435
	addi %a12 %zero 99
	bne %a5 %a12 beq_else.45129 # nontail if
	lw %a4 %a11 4 #1423
	addi %a12 %zero -1
	bne %a4 %a12 beq_else.45131 # nontail if
	jal %zero beq_cont.45132 # then sentence ends
beq_else.45131:
	slli %a4 %a4 2 #31
	add %a12 %a10 %a4 #31
	lw %a4 %a12 0 #31
	addi %a5 %zero 0 #1426
	sw %a11 %sp 40 #1426
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	add %a11 %a8 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45133 # nontail if
	jal %zero beq_cont.45134 # then sentence ends
beq_else.45133:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45135 # nontail if
	jal %zero beq_cont.45136 # then sentence ends
beq_else.45135:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45137 # nontail if
	jal %zero beq_cont.45138 # then sentence ends
beq_else.45137:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 20 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45139 # nontail if
	jal %zero beq_cont.45140 # then sentence ends
beq_else.45139:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 24 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45141 # nontail if
	jal %zero beq_cont.45142 # then sentence ends
beq_else.45141:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 28 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45143 # nontail if
	jal %zero beq_cont.45144 # then sentence ends
beq_else.45143:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	addi %a0 %zero 8 #1427
	lw %a1 %sp 40 #1427
	lw %a2 %sp 20 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 44 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 48 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -48 #1427
	lw %ra %sp 44 #1427
beq_cont.45144:
beq_cont.45142:
beq_cont.45140:
beq_cont.45138:
beq_cont.45136:
beq_cont.45134:
beq_cont.45132:
	jal %zero beq_cont.45130 # then sentence ends
beq_else.45129:
	slli %a1 %a5 2 #20
	add %a12 %a9 %a1 #20
	lw %a1 %a12 0 #20
	lw %a9 %a1 40 #427
	lw %f0 %a9 0 #19
	lw %f1 %a9 4 #19
	lw %f2 %a9 8 #19
	lw %a0 %a2 4 #513
	slli %a5 %a5 2 #968
	add %a12 %a0 %a5 #968
	lw %a0 %a12 0 #968
	lw %a5 %a1 4 #238
	sw %a11 %sp 40 #868
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.45145 # nontail if
	lw %a5 %a2 0 #507
	add %a2 %a0 %zero
	add %a11 %a4 %zero
	add %a0 %a1 %zero
	add %a1 %a5 %zero
	sw %ra %sp 44 #1019 call cls
	lw %a10 %a11 0 #1019
	addi %sp %sp 48 #1019	
	jalr %ra %a10 0 #1019
	addi %sp %sp -48 #1019
	lw %ra %sp 44 #1019
	jal %zero beq_cont.45146 # then sentence ends
beq_else.45145:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.45147 # nontail if
	lw %f0 %a0 0 #983
	fisneg %a1 %f0 #983
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45149 # nontail if
	addi %a0 %zero 0 #986
	jal %zero beq_cont.45150 # then sentence ends
beq_else.45149:
	lw %f0 %a0 0 #983
	lw %f1 %a9 12 #984
	fmul %f0 %f0 %f1 #984
	sw %f0 %a6 0 #984
	addi %a0 %zero 1 #985
beq_cont.45150:
	jal %zero beq_cont.45148 # then sentence ends
beq_else.45147:
	lw %f3 %a0 0 #992
	fiszero %a4 %f3 #993
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45151 # nontail if
	lw %f4 %a0 4 #992
	fmul %f0 %f4 %f0 #996
	lw %f4 %a0 8 #992
	fmul %f1 %f4 %f1 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a0 12 #992
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a9 12 #997
	fmul %f2 %f0 %f0 #998
	fmul %f1 %f3 %f1 #998
	fsub %f1 %f2 %f1 #998
	fispos %a4 %f1 #999
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45153 # nontail if
	addi %a0 %zero 0 #1005
	jal %zero beq_cont.45154 # then sentence ends
beq_else.45153:
	lw %a1 %a1 24 #258
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45155 # nontail if
	sqrt %f1 %f1 #1003
	fsub %f0 %f0 %f1 #1003
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1003
	sw %f0 %a6 0 #1003
	jal %zero beq_cont.45156 # then sentence ends
beq_else.45155:
	sqrt %f1 %f1 #1001
	fadd %f0 %f0 %f1 #1001
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1001
	sw %f0 %a6 0 #1001
beq_cont.45156:
	addi %a0 %zero 1 #1004
beq_cont.45154:
	jal %zero beq_cont.45152 # then sentence ends
beq_else.45151:
	addi %a0 %zero 0 #994
beq_cont.45152:
beq_cont.45148:
beq_cont.45146:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45157 # nontail if
	jal %zero beq_cont.45158 # then sentence ends
beq_else.45157:
	lw %a0 %sp 12 #37
	lw %f0 %a0 0 #37
	lw %a1 %sp 8 #41
	lw %f1 %a1 0 #41
	fless %a2 %f0 %f1 #1446
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45159 # nontail if
	jal %zero beq_cont.45160 # then sentence ends
beq_else.45159:
	lw %a2 %sp 40 #1423
	lw %a3 %a2 4 #1423
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45161 # nontail if
	jal %zero beq_cont.45162 # then sentence ends
beq_else.45161:
	slli %a3 %a3 2 #31
	lw %a4 %sp 28 #31
	add %a12 %a4 %a3 #31
	lw %a3 %a12 0 #31
	addi %a5 %zero 0 #1426
	lw %a6 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a6 %zero
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45163 # nontail if
	jal %zero beq_cont.45164 # then sentence ends
beq_else.45163:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45165 # nontail if
	jal %zero beq_cont.45166 # then sentence ends
beq_else.45165:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45167 # nontail if
	jal %zero beq_cont.45168 # then sentence ends
beq_else.45167:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 20 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45169 # nontail if
	jal %zero beq_cont.45170 # then sentence ends
beq_else.45169:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 24 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45171 # nontail if
	jal %zero beq_cont.45172 # then sentence ends
beq_else.45171:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 28 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45173 # nontail if
	jal %zero beq_cont.45174 # then sentence ends
beq_else.45173:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 48 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -48 #1426
	lw %ra %sp 44 #1426
	addi %a0 %zero 8 #1427
	lw %a1 %sp 40 #1427
	lw %a2 %sp 20 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 44 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 48 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -48 #1427
	lw %ra %sp 44 #1427
beq_cont.45174:
beq_cont.45172:
beq_cont.45170:
beq_cont.45168:
beq_cont.45166:
beq_cont.45164:
beq_cont.45162:
beq_cont.45160:
beq_cont.45158:
beq_cont.45130:
	lw %a0 %sp 36 #1451
	addi %a0 %a0 1 #1451
	slli %a1 %a0 2 #1433
	lw %a2 %sp 32 #1433
	add %a12 %a2 %a1 #1433
	lw %a1 %a12 0 #1433
	lw %a3 %a1 0 #1434
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45175
	jalr %zero %ra 0 #1436
beq_else.45175:
	sw %a0 %sp 44 #1435
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.45177 # nontail if
	lw %a3 %a1 4 #1423
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45179 # nontail if
	jal %zero beq_cont.45180 # then sentence ends
beq_else.45179:
	slli %a3 %a3 2 #31
	lw %a4 %sp 28 #31
	add %a12 %a4 %a3 #31
	lw %a3 %a12 0 #31
	addi %a5 %zero 0 #1426
	lw %a6 %sp 20 #1426
	lw %a11 %sp 24 #1426
	sw %a1 %sp 48 #1426
	add %a2 %a6 %zero
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45181 # nontail if
	jal %zero beq_cont.45182 # then sentence ends
beq_else.45181:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45183 # nontail if
	jal %zero beq_cont.45184 # then sentence ends
beq_else.45183:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45185 # nontail if
	jal %zero beq_cont.45186 # then sentence ends
beq_else.45185:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 20 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45187 # nontail if
	jal %zero beq_cont.45188 # then sentence ends
beq_else.45187:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 24 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45189 # nontail if
	jal %zero beq_cont.45190 # then sentence ends
beq_else.45189:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	addi %a0 %zero 7 #1427
	lw %a1 %sp 48 #1427
	lw %a2 %sp 20 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 52 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 56 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -56 #1427
	lw %ra %sp 52 #1427
beq_cont.45190:
beq_cont.45188:
beq_cont.45186:
beq_cont.45184:
beq_cont.45182:
beq_cont.45180:
	jal %zero beq_cont.45178 # then sentence ends
beq_else.45177:
	lw %a4 %sp 20 #1443
	lw %a11 %sp 4 #1443
	sw %a1 %sp 48 #1443
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 56 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -56 #1443
	lw %ra %sp 52 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45191 # nontail if
	jal %zero beq_cont.45192 # then sentence ends
beq_else.45191:
	lw %a0 %sp 12 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 8 #41
	lw %f1 %a0 0 #41
	fless %a0 %f0 %f1 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45193 # nontail if
	jal %zero beq_cont.45194 # then sentence ends
beq_else.45193:
	lw %a0 %sp 48 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45195 # nontail if
	jal %zero beq_cont.45196 # then sentence ends
beq_else.45195:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45197 # nontail if
	jal %zero beq_cont.45198 # then sentence ends
beq_else.45197:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45199 # nontail if
	jal %zero beq_cont.45200 # then sentence ends
beq_else.45199:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45201 # nontail if
	jal %zero beq_cont.45202 # then sentence ends
beq_else.45201:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 20 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45203 # nontail if
	jal %zero beq_cont.45204 # then sentence ends
beq_else.45203:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	lw %a0 %sp 48 #1423
	lw %a1 %a0 24 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45205 # nontail if
	jal %zero beq_cont.45206 # then sentence ends
beq_else.45205:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 52 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 56 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -56 #1426
	lw %ra %sp 52 #1426
	addi %a0 %zero 7 #1427
	lw %a1 %sp 48 #1427
	lw %a2 %sp 20 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 52 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 56 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -56 #1427
	lw %ra %sp 52 #1427
beq_cont.45206:
beq_cont.45204:
beq_cont.45202:
beq_cont.45200:
beq_cont.45198:
beq_cont.45196:
beq_cont.45194:
beq_cont.45192:
beq_cont.45178:
	lw %a0 %sp 44 #1451
	addi %a0 %a0 1 #1451
	lw %a1 %sp 32 #1451
	lw %a2 %sp 20 #1451
	lw %a11 %sp 0 #1451
	lw %a10 %a11 0 #1451
	jalr %zero %a10 0 #1451
get_nvector_second.2782:
	lw %a1 %a11 8 #1491
	lw %a2 %a11 4 #1491
	lw %f0 %a2 0 #43
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1492
	lw %f1 %a2 4 #43
	lw %a3 %a0 20 #326
	lw %f2 %a3 4 #331
	fsub %f1 %f1 %f2 #1493
	lw %f2 %a2 8 #43
	lw %a2 %a0 20 #336
	lw %f3 %a2 8 #341
	fsub %f2 %f2 %f3 #1494
	lw %a2 %a0 16 #276
	lw %f3 %a2 0 #281
	fmul %f3 %f0 %f3 #1496
	lw %a2 %a0 16 #286
	lw %f4 %a2 4 #291
	fmul %f4 %f1 %f4 #1497
	lw %a2 %a0 16 #296
	lw %f5 %a2 8 #301
	fmul %f5 %f2 %f5 #1498
	lw %a2 %a0 12 #267
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45207 # nontail if
	sw %f3 %a1 0 #1501
	sw %f4 %a1 4 #1502
	sw %f5 %a1 8 #1503
	jal %zero beq_cont.45208 # then sentence ends
beq_else.45207:
	lw %a2 %a0 36 #416
	lw %f6 %a2 8 #421
	fmul %f6 %f1 %f6 #1505
	lw %a2 %a0 36 #406
	lw %f7 %a2 4 #411
	fmul %f7 %f2 %f7 #1505
	fadd %f6 %f6 %f7 #1505
	fhalf %f6 %f6 #1505
	fadd %f3 %f3 %f6 #1505
	sw %f3 %a1 0 #1505
	lw %a2 %a0 36 #416
	lw %f3 %a2 8 #421
	fmul %f3 %f0 %f3 #1506
	lw %a2 %a0 36 #396
	lw %f6 %a2 0 #401
	fmul %f2 %f2 %f6 #1506
	fadd %f2 %f3 %f2 #1506
	fhalf %f2 %f2 #1506
	fadd %f2 %f4 %f2 #1506
	sw %f2 %a1 4 #1506
	lw %a2 %a0 36 #406
	lw %f2 %a2 4 #411
	fmul %f0 %f0 %f2 #1507
	lw %a2 %a0 36 #396
	lw %f2 %a2 0 #401
	fmul %f1 %f1 %f2 #1507
	fadd %f0 %f0 %f1 #1507
	fhalf %f0 %f0 #1507
	fadd %f0 %f5 %f0 #1507
	sw %f0 %a1 8 #1507
beq_cont.45208:
	lw %a0 %a0 24 #258
	lw %f0 %a1 0 #172
	fmul %f0 %f0 %f0 #172
	lw %f1 %a1 4 #172
	fmul %f1 %f1 %f1 #172
	fadd %f0 %f0 %f1 #172
	lw %f1 %a1 8 #172
	fmul %f1 %f1 %f1 #172
	fadd %f0 %f0 %f1 #172
	sqrt %f0 %f0 #172
	fiszero %a2 %f0 #173
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45209 # nontail if
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45211 # nontail if
	li %f1 l.37441 #173
	fdiv %f0 %f1 %f0 #173
	jal %zero beq_cont.45212 # then sentence ends
beq_else.45211:
	li %f1 l.37443 #173
	fdiv %f0 %f1 %f0 #173
beq_cont.45212:
	jal %zero beq_cont.45210 # then sentence ends
beq_else.45209:
	li %f0 l.37441 #173
beq_cont.45210:
	lw %f1 %a1 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a1 0 #174
	lw %f1 %a1 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a1 4 #175
	lw %f1 %a1 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a1 8 #176
	jalr %zero %ra 0 #176
utexture.2787:
	lw %a2 %a11 4 #1527
	lw %a3 %a0 0 #228
	lw %a4 %a0 32 #366
	lw %f0 %a4 0 #371
	sw %f0 %a2 0 #1530
	lw %a4 %a0 32 #376
	lw %f0 %a4 4 #381
	sw %f0 %a2 4 #1531
	lw %a4 %a0 32 #386
	lw %f0 %a4 8 #391
	sw %f0 %a2 8 #1532
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.45214
	lw %f0 %a1 0 #1536
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1536
	li %f1 l.38479 #1538
	fmul %f1 %f0 %f1 #1538
	floor %f1 %f1 #1538
	li %f2 l.38481 #1538
	fmul %f1 %f1 %f2 #1538
	fsub %f0 %f0 %f1 #1539
	li %f1 l.38461 #1539
	fless %a3 %f0 %f1 #1539
	lw %f0 %a1 8 #1536
	lw %a0 %a0 20 #336
	lw %f1 %a0 8 #341
	fsub %f0 %f0 %f1 #1541
	li %f1 l.38479 #1543
	fmul %f1 %f0 %f1 #1543
	floor %f1 %f1 #1543
	li %f2 l.38481 #1543
	fmul %f1 %f1 %f2 #1543
	fsub %f0 %f0 %f1 #1544
	li %f1 l.38461 #1544
	fless %a0 %f0 %f1 #1544
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.45215 # nontail if
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45217 # nontail if
	li %f0 l.38452 #1549
	jal %zero beq_cont.45218 # then sentence ends
beq_else.45217:
	li %f0 l.37367 #1549
beq_cont.45218:
	jal %zero beq_cont.45216 # then sentence ends
beq_else.45215:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45219 # nontail if
	li %f0 l.37367 #1548
	jal %zero beq_cont.45220 # then sentence ends
beq_else.45219:
	li %f0 l.38452 #1548
beq_cont.45220:
beq_cont.45216:
	sw %f0 %a2 4 #1546
	jalr %zero %ra 0 #1546
beq_else.45214:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.45222
	lw %f0 %a1 4 #1536
	li %f1 l.38470 #1554
	fmul %f0 %f0 %f1 #1554
	sw %a2 %sp 0 #1554
	sw %ra %sp 4 #1554 call dir
	addi %sp %sp 8 #1554	
	jal %ra min_caml_sin #1554
	addi %sp %sp -8 #1554
	lw %ra %sp 4 #1554
	fmul %f0 %f0 %f0 #1554
	li %f1 l.38452 #1555
	fmul %f1 %f1 %f0 #1555
	lw %a0 %sp 0 #1555
	sw %f1 %a0 0 #1555
	li %f1 l.38452 #1556
	li %f2 l.37441 #1556
	fsub %f0 %f2 %f0 #1556
	fmul %f0 %f1 %f0 #1556
	sw %f0 %a0 4 #1556
	jalr %zero %ra 0 #1556
beq_else.45222:
	addi %a12 %zero 3
	bne %a3 %a12 beq_else.45224
	lw %f0 %a1 0 #1536
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1561
	lw %f1 %a1 8 #1536
	lw %a0 %a0 20 #336
	lw %f2 %a0 8 #341
	fsub %f1 %f1 %f2 #1562
	fmul %f0 %f0 %f0 #1563
	fmul %f1 %f1 %f1 #1563
	fadd %f0 %f0 %f1 #1563
	sqrt %f0 %f0 #1563
	li %f1 l.38461 #1563
	fdiv %f0 %f0 %f1 #1563
	floor %f1 %f0 #1564
	fsub %f0 %f0 %f1 #1564
	li %f1 l.38437 #1564
	fmul %f0 %f0 %f1 #1564
	sw %a2 %sp 0 #1565
	sw %ra %sp 4 #1565 call dir
	addi %sp %sp 8 #1565	
	jal %ra min_caml_cos #1565
	addi %sp %sp -8 #1565
	lw %ra %sp 4 #1565
	fmul %f0 %f0 %f0 #1565
	li %f1 l.38452 #1566
	fmul %f1 %f0 %f1 #1566
	lw %a0 %sp 0 #1566
	sw %f1 %a0 4 #1566
	li %f1 l.37441 #1567
	fsub %f0 %f1 %f0 #1567
	li %f1 l.38452 #1567
	fmul %f0 %f0 %f1 #1567
	sw %f0 %a0 8 #1567
	jalr %zero %ra 0 #1567
beq_else.45224:
	addi %a12 %zero 4
	bne %a3 %a12 beq_else.45226
	lw %f0 %a1 0 #1536
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1571
	lw %a3 %a0 16 #276
	lw %f1 %a3 0 #281
	sqrt %f1 %f1 #1571
	fmul %f0 %f0 %f1 #1571
	lw %f1 %a1 8 #1536
	lw %a3 %a0 20 #336
	lw %f2 %a3 8 #341
	fsub %f1 %f1 %f2 #1572
	lw %a3 %a0 16 #296
	lw %f2 %a3 8 #301
	sqrt %f2 %f2 #1572
	fmul %f1 %f1 %f2 #1572
	fmul %f2 %f0 %f0 #1573
	fmul %f3 %f1 %f1 #1573
	fadd %f2 %f2 %f3 #1573
	fabs %f3 %f0 #1575
	li %f4 l.38431 #1575
	fless %a3 %f3 %f4 #1575
	sw %a2 %sp 0 #1575
	sw %f2 %sp 8 #1575
	sw %a0 %sp 16 #1575
	sw %a1 %sp 20 #1575
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.45228 # nontail if
	fdiv %f0 %f1 %f0 #1578
	fabs %f0 %f0 #1578
	sw %ra %sp 28 #1580 call dir
	addi %sp %sp 32 #1580	
	jal %ra min_caml_atan #1580
	addi %sp %sp -32 #1580
	lw %ra %sp 28 #1580
	li %f1 l.38435 #1580
	fmul %f0 %f0 %f1 #1580
	li %f1 l.38437 #1580
	fdiv %f0 %f0 %f1 #1580
	jal %zero beq_cont.45229 # then sentence ends
beq_else.45228:
	li %f0 l.38433 #1576
beq_cont.45229:
	floor %f1 %f0 #1582
	fsub %f0 %f0 %f1 #1582
	lw %a0 %sp 20 #1536
	lw %f1 %a0 4 #1536
	lw %a0 %sp 16 #326
	lw %a1 %a0 20 #326
	lw %f2 %a1 4 #331
	fsub %f1 %f1 %f2 #1584
	lw %a0 %a0 16 #286
	lw %f2 %a0 4 #291
	sqrt %f2 %f2 #1584
	fmul %f1 %f1 %f2 #1584
	lw %f2 %sp 8 #1586
	fabs %f3 %f2 #1586
	li %f4 l.38431 #1586
	fless %a0 %f3 %f4 #1586
	sw %f0 %sp 24 #1586
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45230 # nontail if
	fdiv %f1 %f1 %f2 #1589
	fabs %f1 %f1 #1589
	fadd %f0 %f1 %fzero
	sw %ra %sp 36 #1590 call dir
	addi %sp %sp 40 #1590	
	jal %ra min_caml_atan #1590
	addi %sp %sp -40 #1590
	lw %ra %sp 36 #1590
	li %f1 l.38435 #1590
	fmul %f0 %f0 %f1 #1590
	li %f1 l.38437 #1590
	fdiv %f0 %f0 %f1 #1590
	jal %zero beq_cont.45231 # then sentence ends
beq_else.45230:
	li %f0 l.38433 #1587
beq_cont.45231:
	floor %f1 %f0 #1592
	fsub %f0 %f0 %f1 #1592
	li %f1 l.38446 #1593
	li %f2 l.38448 #1593
	lw %f3 %sp 24 #1593
	fsub %f2 %f2 %f3 #1593
	fmul %f2 %f2 %f2 #1593
	fsub %f1 %f1 %f2 #1593
	li %f2 l.38448 #1593
	fsub %f0 %f2 %f0 #1593
	fmul %f0 %f0 %f0 #1593
	fsub %f0 %f1 %f0 #1593
	fisneg %a0 %f0 #1594
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45232 # nontail if
	jal %zero beq_cont.45233 # then sentence ends
beq_else.45232:
	li %f0 l.37367 #1594
beq_cont.45233:
	li %f1 l.38452 #1595
	fmul %f0 %f1 %f0 #1595
	li %f1 l.38454 #1595
	fdiv %f0 %f0 %f1 #1595
	lw %a0 %sp 0 #1595
	sw %f0 %a0 8 #1595
	jalr %zero %ra 0 #1595
beq_else.45226:
	jalr %zero %ra 0 #1597
add_light.2790:
	lw %a0 %a11 8 #1603
	lw %a1 %a11 4 #1603
	fispos %a2 %f0 #1606
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45236 # nontail if
	jal %zero beq_cont.45237 # then sentence ends
beq_else.45236:
	lw %f3 %a1 0 #191
	lw %f4 %a0 0 #191
	fmul %f4 %f0 %f4 #191
	fadd %f3 %f3 %f4 #191
	sw %f3 %a1 0 #191
	lw %f3 %a1 4 #191
	lw %f4 %a0 4 #191
	fmul %f4 %f0 %f4 #192
	fadd %f3 %f3 %f4 #192
	sw %f3 %a1 4 #192
	lw %f3 %a1 8 #191
	lw %f4 %a0 8 #191
	fmul %f0 %f0 %f4 #193
	fadd %f0 %f3 %f0 #193
	sw %f0 %a1 8 #193
beq_cont.45237:
	fispos %a0 %f1 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45238
	jalr %zero %ra 0 #1616
beq_else.45238:
	fmul %f0 %f1 %f1 #1612
	fmul %f0 %f0 %f0 #1612
	fmul %f0 %f0 %f2 #1612
	lw %f1 %a1 0 #54
	fadd %f1 %f1 %f0 #1613
	sw %f1 %a1 0 #1613
	lw %f1 %a1 4 #54
	fadd %f1 %f1 %f0 #1614
	sw %f1 %a1 4 #1614
	lw %f1 %a1 8 #54
	fadd %f0 %f1 %f0 #1615
	sw %f0 %a1 8 #1615
	jalr %zero %ra 0 #1615
trace_reflections.2794:
	lw %a2 %a11 96 #1620
	lw %a3 %a11 92 #1620
	lw %a4 %a11 88 #1620
	lw %a5 %a11 84 #1620
	lw %a6 %a11 80 #1620
	lw %a7 %a11 76 #1620
	lw %a8 %a11 72 #1620
	lw %a9 %a11 68 #1620
	lw %a10 %a11 64 #1620
	sw %a8 %sp 0 #1620
	lw %a8 %a11 60 #1620
	sw %a10 %sp 4 #1620
	lw %a10 %a11 56 #1620
	sw %a8 %sp 8 #1620
	lw %a8 %a11 52 #1620
	sw %a5 %sp 12 #1620
	lw %a5 %a11 48 #1620
	sw %a1 %sp 16 #1620
	lw %a1 %a11 44 #1620
	sw %a1 %sp 20 #1620
	lw %a1 %a11 40 #1620
	sw %a10 %sp 24 #1620
	lw %a10 %a11 36 #1620
	sw %a8 %sp 28 #1620
	lw %a8 %a11 32 #1620
	sw %a5 %sp 32 #1620
	lw %a5 %a11 28 #1620
	sw %a5 %sp 36 #1620
	lw %a5 %a11 24 #1620
	sw %a6 %sp 40 #1620
	lw %a6 %a11 20 #1620
	sw %a9 %sp 44 #1620
	lw %a9 %a11 16 #1620
	sw %a2 %sp 48 #1620
	lw %a2 %a11 12 #1620
	sw %a7 %sp 52 #1620
	lw %a7 %a11 8 #1620
	sw %a11 %sp 56 #1620
	lw %a11 %a11 4 #1620
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45241
	sw %a11 %sp 60 #95
	slli %a11 %a0 2 #95
	add %a12 %a1 %a11 #95
	lw %a11 %a12 0 #95
	sw %a1 %sp 64 #527
	lw %a1 %a11 4 #527
	li %f2 l.38510 #1458
	sw %f2 %a4 0 #1458
	sw %a0 %sp 68 #1459
	addi %a0 %zero 0 #1459
	sw %a7 %sp 72 #33
	lw %a7 %a10 0 #33
	sw %a3 %sp 76 #1459
	sw %f1 %sp 80 #1459
	sw %f0 %sp 88 #1459
	sw %a1 %sp 96 #1459
	sw %a2 %sp 100 #1459
	sw %a6 %sp 104 #1459
	sw %a8 %sp 108 #1459
	sw %a10 %sp 112 #1459
	sw %a11 %sp 116 #1459
	sw %a5 %sp 120 #1459
	sw %a9 %sp 124 #1459
	sw %a4 %sp 128 #1459
	add %a2 %a1 %zero
	add %a11 %a3 %zero
	add %a1 %a7 %zero
	sw %ra %sp 132 #1459 call cls
	lw %a10 %a11 0 #1459
	addi %sp %sp 136 #1459	
	jalr %ra %a10 0 #1459
	addi %sp %sp -136 #1459
	lw %ra %sp 132 #1459
	lw %a0 %sp 128 #41
	lw %f0 %a0 0 #41
	li %f1 l.37986 #1462
	fless %a1 %f1 %f0 #1462
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45242 # nontail if
	addi %a1 %zero 0 #1464
	jal %zero beq_cont.45243 # then sentence ends
beq_else.45242:
	li %f1 l.38516 #1463
	fless %a1 %f0 %f1 #1463
beq_cont.45243:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45244 # nontail if
	jal %zero beq_cont.45245 # then sentence ends
beq_else.45244:
	lw %a1 %sp 124 #45
	lw %a2 %a1 0 #45
	addi %a3 %zero 4 #1628
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	sw %ra %sp 132 #1628 call dir
	addi %sp %sp 136 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -136 #1628
	lw %ra %sp 132 #1628
	lw %a1 %sp 120 #39
	lw %a2 %a1 0 #39
	add %a0 %a0 %a2 #1628
	lw %a2 %sp 116 #521
	lw %a3 %a2 0 #521
	bne %a0 %a3 beq_else.45246 # nontail if
	lw %a0 %sp 112 #33
	lw %a3 %a0 0 #33
	lw %a4 %a3 0 #1257
	lw %a5 %a4 0 #1258
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.45248 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.45249 # then sentence ends
beq_else.45248:
	sw %a4 %sp 132 #1259
	sw %a3 %sp 136 #1259
	addi %a12 %zero 99
	bne %a5 %a12 beq_else.45250 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.45251 # then sentence ends
beq_else.45250:
	slli %a6 %a5 2 #20
	lw %a7 %sp 108 #20
	add %a12 %a7 %a6 #20
	lw %a6 %a12 0 #20
	lw %a7 %sp 104 #964
	lw %f0 %a7 0 #964
	lw %a8 %a6 20 #316
	lw %f1 %a8 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a7 4 #964
	lw %a8 %a6 20 #326
	lw %f2 %a8 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a7 8 #964
	lw %a7 %a6 20 #336
	lw %f3 %a7 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a5 %a5 2 #968
	lw %a7 %sp 100 #968
	add %a12 %a7 %a5 #968
	lw %a5 %a12 0 #968
	lw %a7 %a6 4 #238
	addi %a12 %zero 1
	bne %a7 %a12 beq_else.45252 # nontail if
	lw %a7 %sp 48 #971
	lw %a11 %sp 52 #971
	add %a2 %a5 %zero
	add %a1 %a7 %zero
	add %a0 %a6 %zero
	sw %ra %sp 140 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 144 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -144 #971
	lw %ra %sp 140 #971
	jal %zero beq_cont.45253 # then sentence ends
beq_else.45252:
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.45254 # nontail if
	lw %f3 %a5 0 #934
	fisneg %a6 %f3 #934
	addi %a12 %zero 0
	bne %a6 %a12 beq_else.45256 # nontail if
	addi %a0 %zero 0 #938
	jal %zero beq_cont.45257 # then sentence ends
beq_else.45256:
	lw %f3 %a5 4 #934
	fmul %f0 %f3 %f0 #936
	lw %f3 %a5 8 #934
	fmul %f1 %f3 %f1 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a5 12 #934
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a5 %sp 44 #935
	sw %f0 %a5 0 #935
	addi %a0 %zero 1 #937
beq_cont.45257:
	jal %zero beq_cont.45255 # then sentence ends
beq_else.45254:
	lw %a11 %sp 40 #975
	add %a1 %a5 %zero
	add %a0 %a6 %zero
	sw %ra %sp 140 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 144 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -144 #975
	lw %ra %sp 140 #975
beq_cont.45255:
beq_cont.45253:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45258 # nontail if
	addi %a0 %zero 0 #1275
	jal %zero beq_cont.45259 # then sentence ends
beq_else.45258:
	lw %a0 %sp 44 #37
	lw %f0 %a0 0 #37
	li %f1 l.37986 #1270
	fless %a1 %f0 %f1 #1270
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45260 # nontail if
	addi %a0 %zero 0 #1274
	jal %zero beq_cont.45261 # then sentence ends
beq_else.45260:
	lw %a1 %sp 132 #1242
	lw %a2 %a1 4 #1242
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.45262 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45263 # then sentence ends
beq_else.45262:
	slli %a2 %a2 2 #31
	lw %a3 %sp 72 #31
	add %a12 %a3 %a2 #31
	lw %a2 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45264 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45266 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45267 # then sentence ends
beq_else.45266:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45268 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45270 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45271 # then sentence ends
beq_else.45270:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45272 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45274 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45275 # then sentence ends
beq_else.45274:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45276 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45278 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45279 # then sentence ends
beq_else.45278:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45280 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45282 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45283 # then sentence ends
beq_else.45282:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45284 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 132 #1251
	lw %a11 %sp 28 #1251
	sw %ra %sp 140 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 144 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -144 #1251
	lw %ra %sp 140 #1251
	jal %zero beq_cont.45285 # then sentence ends
beq_else.45284:
	addi %a0 %zero 1 #1249
beq_cont.45285:
beq_cont.45283:
	jal %zero beq_cont.45281 # then sentence ends
beq_else.45280:
	addi %a0 %zero 1 #1249
beq_cont.45281:
beq_cont.45279:
	jal %zero beq_cont.45277 # then sentence ends
beq_else.45276:
	addi %a0 %zero 1 #1249
beq_cont.45277:
beq_cont.45275:
	jal %zero beq_cont.45273 # then sentence ends
beq_else.45272:
	addi %a0 %zero 1 #1249
beq_cont.45273:
beq_cont.45271:
	jal %zero beq_cont.45269 # then sentence ends
beq_else.45268:
	addi %a0 %zero 1 #1249
beq_cont.45269:
beq_cont.45267:
	jal %zero beq_cont.45265 # then sentence ends
beq_else.45264:
	addi %a0 %zero 1 #1249
beq_cont.45265:
beq_cont.45263:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45286 # nontail if
	addi %a0 %zero 0 #1273
	jal %zero beq_cont.45287 # then sentence ends
beq_else.45286:
	addi %a0 %zero 1 #1272
beq_cont.45287:
beq_cont.45261:
beq_cont.45259:
beq_cont.45251:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45288 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 136 #1282
	lw %a11 %sp 24 #1282
	sw %ra %sp 140 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 144 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -144 #1282
	lw %ra %sp 140 #1282
	jal %zero beq_cont.45289 # then sentence ends
beq_else.45288:
	lw %a0 %sp 132 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45290 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45291 # then sentence ends
beq_else.45290:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45292 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45294 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45295 # then sentence ends
beq_else.45294:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45296 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45298 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45299 # then sentence ends
beq_else.45298:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45300 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45302 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45303 # then sentence ends
beq_else.45302:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45304 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45306 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45307 # then sentence ends
beq_else.45306:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45308 # nontail if
	lw %a0 %sp 132 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45310 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45311 # then sentence ends
beq_else.45310:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45312 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 132 #1251
	lw %a11 %sp 28 #1251
	sw %ra %sp 140 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 144 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -144 #1251
	lw %ra %sp 140 #1251
	jal %zero beq_cont.45313 # then sentence ends
beq_else.45312:
	addi %a0 %zero 1 #1249
beq_cont.45313:
beq_cont.45311:
	jal %zero beq_cont.45309 # then sentence ends
beq_else.45308:
	addi %a0 %zero 1 #1249
beq_cont.45309:
beq_cont.45307:
	jal %zero beq_cont.45305 # then sentence ends
beq_else.45304:
	addi %a0 %zero 1 #1249
beq_cont.45305:
beq_cont.45303:
	jal %zero beq_cont.45301 # then sentence ends
beq_else.45300:
	addi %a0 %zero 1 #1249
beq_cont.45301:
beq_cont.45299:
	jal %zero beq_cont.45297 # then sentence ends
beq_else.45296:
	addi %a0 %zero 1 #1249
beq_cont.45297:
beq_cont.45295:
	jal %zero beq_cont.45293 # then sentence ends
beq_else.45292:
	addi %a0 %zero 1 #1249
beq_cont.45293:
beq_cont.45291:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45314 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 136 #1280
	lw %a11 %sp 24 #1280
	sw %ra %sp 140 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 144 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -144 #1280
	lw %ra %sp 140 #1280
	jal %zero beq_cont.45315 # then sentence ends
beq_else.45314:
	addi %a0 %zero 1 #1278
beq_cont.45315:
beq_cont.45289:
beq_cont.45249:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45316 # nontail if
	lw %a0 %sp 96 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 36 #181
	lw %f0 %a2 0 #181
	lw %f1 %a1 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a2 4 #181
	lw %f2 %a1 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a2 8 #181
	lw %f2 %a1 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %a1 %sp 116 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 88 #1635
	fmul %f3 %f1 %f2 #1635
	fmul %f0 %f3 %f0 #1635
	lw %a0 %a0 0 #507
	lw %a1 %sp 16 #181
	lw %f3 %a1 0 #181
	lw %f4 %a0 0 #181
	fmul %f3 %f3 %f4 #181
	lw %f4 %a1 4 #181
	lw %f5 %a0 4 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	lw %f4 %a1 8 #181
	lw %f5 %a0 8 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	fmul %f1 %f1 %f3 #1636
	fispos %a0 %f0 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45318 # nontail if
	jal %zero beq_cont.45319 # then sentence ends
beq_else.45318:
	lw %a0 %sp 20 #191
	lw %f3 %a0 0 #191
	lw %a3 %sp 12 #191
	lw %f4 %a3 0 #191
	fmul %f4 %f0 %f4 #191
	fadd %f3 %f3 %f4 #191
	sw %f3 %a0 0 #191
	lw %f3 %a0 4 #191
	lw %f4 %a3 4 #191
	fmul %f4 %f0 %f4 #192
	fadd %f3 %f3 %f4 #192
	sw %f3 %a0 4 #192
	lw %f3 %a0 8 #191
	lw %f4 %a3 8 #191
	fmul %f0 %f0 %f4 #193
	fadd %f0 %f3 %f0 #193
	sw %f0 %a0 8 #193
beq_cont.45319:
	fispos %a0 %f1 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45320 # nontail if
	jal %zero beq_cont.45321 # then sentence ends
beq_else.45320:
	fmul %f0 %f1 %f1 #1612
	fmul %f0 %f0 %f0 #1612
	lw %f1 %sp 80 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 20 #54
	lw %f3 %a0 0 #54
	fadd %f3 %f3 %f0 #1613
	sw %f3 %a0 0 #1613
	lw %f3 %a0 4 #54
	fadd %f3 %f3 %f0 #1614
	sw %f3 %a0 4 #1614
	lw %f3 %a0 8 #54
	fadd %f0 %f3 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.45321:
	jal %zero beq_cont.45317 # then sentence ends
beq_else.45316:
beq_cont.45317:
	jal %zero beq_cont.45247 # then sentence ends
beq_else.45246:
beq_cont.45247:
beq_cont.45245:
	lw %a0 %sp 68 #1641
	addi %a0 %a0 -1 #1641
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45322
	slli %a1 %a0 2 #95
	lw %a2 %sp 64 #95
	add %a12 %a2 %a1 #95
	lw %a1 %a12 0 #95
	lw %a2 %a1 4 #527
	li %f0 l.38510 #1458
	lw %a3 %sp 128 #1458
	sw %f0 %a3 0 #1458
	lw %a4 %sp 112 #33
	lw %a5 %a4 0 #33
	lw %a6 %a5 0 #1433
	lw %a7 %a6 0 #1434
	sw %a0 %sp 140 #1435
	sw %a2 %sp 144 #1435
	sw %a1 %sp 148 #1435
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.45323 # nontail if
	jal %zero beq_cont.45324 # then sentence ends
beq_else.45323:
	sw %a5 %sp 152 #1435
	addi %a12 %zero 99
	bne %a7 %a12 beq_else.45325 # nontail if
	lw %a7 %a6 4 #1423
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.45327 # nontail if
	jal %zero beq_cont.45328 # then sentence ends
beq_else.45327:
	slli %a7 %a7 2 #31
	lw %a8 %sp 72 #31
	add %a12 %a8 %a7 #31
	lw %a7 %a12 0 #31
	addi %a9 %zero 0 #1426
	lw %a11 %sp 8 #1426
	sw %a6 %sp 156 #1426
	add %a1 %a7 %zero
	add %a0 %a9 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	lw %a0 %sp 156 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45329 # nontail if
	jal %zero beq_cont.45330 # then sentence ends
beq_else.45329:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 144 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	lw %a0 %sp 156 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45331 # nontail if
	jal %zero beq_cont.45332 # then sentence ends
beq_else.45331:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 144 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	lw %a0 %sp 156 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45333 # nontail if
	jal %zero beq_cont.45334 # then sentence ends
beq_else.45333:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 144 #1426
	lw %a11 %sp 8 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 156 #1427
	lw %a2 %sp 144 #1427
	lw %a11 %sp 4 #1427
	sw %ra %sp 164 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 168 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -168 #1427
	lw %ra %sp 164 #1427
beq_cont.45334:
beq_cont.45332:
beq_cont.45330:
beq_cont.45328:
	jal %zero beq_cont.45326 # then sentence ends
beq_else.45325:
	lw %a11 %sp 0 #1443
	sw %a6 %sp 156 #1443
	add %a1 %a2 %zero
	add %a0 %a7 %zero
	sw %ra %sp 164 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 168 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -168 #1443
	lw %ra %sp 164 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45335 # nontail if
	jal %zero beq_cont.45336 # then sentence ends
beq_else.45335:
	lw %a0 %sp 44 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 128 #41
	lw %f1 %a0 0 #41
	fless %a1 %f0 %f1 #1446
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45337 # nontail if
	jal %zero beq_cont.45338 # then sentence ends
beq_else.45337:
	lw %a1 %sp 156 #1423
	lw %a2 %a1 4 #1423
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.45339 # nontail if
	jal %zero beq_cont.45340 # then sentence ends
beq_else.45339:
	slli %a2 %a2 2 #31
	lw %a3 %sp 72 #31
	add %a12 %a3 %a2 #31
	lw %a2 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 144 #1426
	lw %a11 %sp 8 #1426
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	add %a2 %a5 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	lw %a0 %sp 156 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45341 # nontail if
	jal %zero beq_cont.45342 # then sentence ends
beq_else.45341:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 144 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	lw %a0 %sp 156 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45343 # nontail if
	jal %zero beq_cont.45344 # then sentence ends
beq_else.45343:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 144 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	lw %a0 %sp 156 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45345 # nontail if
	jal %zero beq_cont.45346 # then sentence ends
beq_else.45345:
	slli %a1 %a1 2 #31
	lw %a2 %sp 72 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 144 #1426
	lw %a11 %sp 8 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 164 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 168 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -168 #1426
	lw %ra %sp 164 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 156 #1427
	lw %a2 %sp 144 #1427
	lw %a11 %sp 4 #1427
	sw %ra %sp 164 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 168 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -168 #1427
	lw %ra %sp 164 #1427
beq_cont.45346:
beq_cont.45344:
beq_cont.45342:
beq_cont.45340:
beq_cont.45338:
beq_cont.45336:
beq_cont.45326:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 152 #1451
	lw %a2 %sp 144 #1451
	lw %a11 %sp 76 #1451
	sw %ra %sp 164 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 168 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -168 #1451
	lw %ra %sp 164 #1451
beq_cont.45324:
	lw %a0 %sp 128 #41
	lw %f0 %a0 0 #41
	li %f1 l.37986 #1462
	fless %a0 %f1 %f0 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45347 # nontail if
	addi %a0 %zero 0 #1464
	jal %zero beq_cont.45348 # then sentence ends
beq_else.45347:
	li %f1 l.38516 #1463
	fless %a0 %f0 %f1 #1463
beq_cont.45348:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45349 # nontail if
	jal %zero beq_cont.45350 # then sentence ends
beq_else.45349:
	lw %a0 %sp 124 #45
	lw %a0 %a0 0 #45
	addi %a1 %zero 4 #1628
	sw %ra %sp 164 #1628 call dir
	addi %sp %sp 168 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -168 #1628
	lw %ra %sp 164 #1628
	lw %a1 %sp 120 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1628
	lw %a1 %sp 148 #521
	lw %a2 %a1 0 #521
	bne %a0 %a2 beq_else.45351 # nontail if
	addi %a0 %zero 0 #1631
	lw %a2 %sp 112 #33
	lw %a2 %a2 0 #33
	lw %a11 %sp 24 #1631
	add %a1 %a2 %zero
	sw %ra %sp 164 #1631 call cls
	lw %a10 %a11 0 #1631
	addi %sp %sp 168 #1631	
	jalr %ra %a10 0 #1631
	addi %sp %sp -168 #1631
	lw %ra %sp 164 #1631
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45353 # nontail if
	lw %a0 %sp 144 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 36 #181
	lw %f0 %a2 0 #181
	lw %f1 %a1 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a2 4 #181
	lw %f2 %a1 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a2 8 #181
	lw %f2 %a1 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %a1 %sp 148 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 88 #1635
	fmul %f3 %f1 %f2 #1635
	fmul %f0 %f3 %f0 #1635
	lw %a0 %a0 0 #507
	lw %a1 %sp 16 #181
	lw %f3 %a1 0 #181
	lw %f4 %a0 0 #181
	fmul %f3 %f3 %f4 #181
	lw %f4 %a1 4 #181
	lw %f5 %a0 4 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	lw %f4 %a1 8 #181
	lw %f5 %a0 8 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	fmul %f1 %f1 %f3 #1636
	lw %f3 %sp 80 #1637
	lw %a11 %sp 60 #1637
	fadd %f2 %f3 %fzero
	sw %ra %sp 164 #1637 call cls
	lw %a10 %a11 0 #1637
	addi %sp %sp 168 #1637	
	jalr %ra %a10 0 #1637
	addi %sp %sp -168 #1637
	lw %ra %sp 164 #1637
	jal %zero beq_cont.45354 # then sentence ends
beq_else.45353:
beq_cont.45354:
	jal %zero beq_cont.45352 # then sentence ends
beq_else.45351:
beq_cont.45352:
beq_cont.45350:
	lw %a0 %sp 140 #1641
	addi %a0 %a0 -1 #1641
	lw %f0 %sp 88 #1641
	lw %f1 %sp 80 #1641
	lw %a1 %sp 16 #1641
	lw %a11 %sp 56 #1641
	lw %a10 %a11 0 #1641
	jalr %zero %a10 0 #1641
bge_else.45322:
	jalr %zero %ra 0 #1642
bge_else.45241:
	jalr %zero %ra 0 #1642
trace_ray.2799:
	lw %a3 %a11 140 #1647
	lw %a4 %a11 136 #1647
	lw %a5 %a11 132 #1647
	lw %a6 %a11 128 #1647
	lw %a7 %a11 124 #1647
	lw %a8 %a11 120 #1647
	lw %a9 %a11 116 #1647
	lw %a10 %a11 112 #1647
	sw %a5 %sp 0 #1647
	lw %a5 %a11 108 #1647
	sw %a6 %sp 4 #1647
	lw %a6 %a11 104 #1647
	sw %a10 %sp 8 #1647
	lw %a10 %a11 100 #1647
	sw %a6 %sp 12 #1647
	lw %a6 %a11 96 #1647
	sw %a6 %sp 16 #1647
	lw %a6 %a11 92 #1647
	sw %a6 %sp 20 #1647
	lw %a6 %a11 88 #1647
	sw %a6 %sp 24 #1647
	lw %a6 %a11 84 #1647
	sw %a6 %sp 28 #1647
	lw %a6 %a11 80 #1647
	sw %a6 %sp 32 #1647
	lw %a6 %a11 76 #1647
	sw %a6 %sp 36 #1647
	lw %a6 %a11 72 #1647
	sw %a6 %sp 40 #1647
	lw %a6 %a11 68 #1647
	sw %a6 %sp 44 #1647
	lw %a6 %a11 64 #1647
	sw %a3 %sp 48 #1647
	lw %a3 %a11 60 #1647
	sw %a3 %sp 52 #1647
	lw %a3 %a11 56 #1647
	sw %a10 %sp 56 #1647
	lw %a10 %a11 52 #1647
	sw %a9 %sp 60 #1647
	lw %a9 %a11 48 #1647
	sw %a4 %sp 64 #1647
	lw %a4 %a11 44 #1647
	sw %a4 %sp 68 #1647
	lw %a4 %a11 40 #1647
	sw %a4 %sp 72 #1647
	lw %a4 %a11 36 #1647
	sw %a5 %sp 76 #1647
	lw %a5 %a11 32 #1647
	sw %a9 %sp 80 #1647
	lw %a9 %a11 28 #1647
	sw %a9 %sp 84 #1647
	lw %a9 %a11 24 #1647
	sw %a5 %sp 88 #1647
	lw %a5 %a11 20 #1647
	sw %a5 %sp 92 #1647
	lw %a5 %a11 16 #1647
	sw %a5 %sp 96 #1647
	lw %a5 %a11 12 #1647
	sw %a10 %sp 100 #1647
	lw %a10 %a11 8 #1647
	sw %a11 %sp 104 #1647
	lw %a11 %a11 4 #1647
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.45357
	sw %a11 %sp 108 #454
	lw %a11 %a2 8 #454
	li %f2 l.38510 #1369
	sw %f2 %a8 0 #1369
	sw %a10 %sp 112 #1370
	addi %a10 %zero 0 #1370
	sw %a3 %sp 116 #33
	lw %a3 %a3 0 #33
	sw %f1 %sp 120 #1370
	sw %a2 %sp 128 #1370
	sw %a9 %sp 132 #1370
	sw %a6 %sp 136 #1370
	sw %a5 %sp 140 #1370
	sw %f0 %sp 144 #1370
	sw %a4 %sp 152 #1370
	sw %a1 %sp 156 #1370
	sw %a11 %sp 160 #1370
	sw %a0 %sp 164 #1370
	sw %a8 %sp 168 #1370
	add %a2 %a1 %zero
	add %a0 %a10 %zero
	add %a11 %a7 %zero
	add %a1 %a3 %zero
	sw %ra %sp 172 #1370 call cls
	lw %a10 %a11 0 #1370
	addi %sp %sp 176 #1370	
	jalr %ra %a10 0 #1370
	addi %sp %sp -176 #1370
	lw %ra %sp 172 #1370
	lw %a0 %sp 168 #41
	lw %f0 %a0 0 #41
	li %f1 l.37986 #1373
	fless %a1 %f1 %f0 #1373
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45358 # nontail if
	addi %a1 %zero 0 #1375
	jal %zero beq_cont.45359 # then sentence ends
beq_else.45358:
	li %f1 l.38516 #1374
	fless %a1 %f0 %f1 #1374
beq_cont.45359:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45360
	addi %a0 %zero -1 #1713
	lw %a1 %sp 164 #1713
	slli %a2 %a1 2 #1713
	lw %a3 %sp 160 #1713
	add %a12 %a3 %a2 #1713
	sw %a0 %a12 0 #1713
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45361
	jalr %zero %ra 0 #1727
beq_else.45361:
	lw %a0 %sp 156 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 152 #181
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
	fneg %f0 %f0 #1716
	fispos %a0 %f0 #1718
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45363
	jalr %zero %ra 0 #1726
beq_else.45363:
	fmul %f1 %f0 %f0 #1721
	fmul %f0 %f1 %f0 #1721
	lw %f1 %sp 144 #1721
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 140 #29
	lw %f1 %a0 0 #29
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 136 #54
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
beq_else.45360:
	lw %a1 %sp 132 #45
	lw %a2 %a1 0 #45
	slli %a3 %a2 2 #20
	lw %a4 %sp 100 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	lw %a5 %a3 8 #248
	lw %a6 %a3 28 #346
	lw %f0 %a6 0 #351
	lw %f1 %sp 144 #1655
	fmul %f0 %f0 %f1 #1655
	lw %a6 %a3 4 #238
	sw %a5 %sp 172 #868
	sw %f0 %sp 176 #868
	sw %a2 %sp 184 #868
	sw %a3 %sp 188 #868
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.45366 # nontail if
	lw %a6 %sp 88 #39
	lw %a7 %a6 0 #39
	li %f2 l.37367 #147
	lw %a8 %sp 80 #140
	sw %f2 %a8 0 #140
	sw %f2 %a8 4 #141
	sw %f2 %a8 8 #142
	addi %a9 %a7 -1 #1479
	addi %a7 %a7 -1 #1479
	slli %a7 %a7 2 #1479
	lw %a10 %sp 156 #1479
	add %a12 %a10 %a7 #1479
	lw %f2 %a12 0 #1479
	fiszero %a7 %f2 #111
	addi %a12 %zero 0
	bne %a7 %a12 beq_else.45368 # nontail if
	fispos %a7 %f2 #112
	addi %a12 %zero 0
	bne %a7 %a12 beq_else.45370 # nontail if
	li %f2 l.37443 #113
	jal %zero beq_cont.45371 # then sentence ends
beq_else.45370:
	li %f2 l.37441 #112
beq_cont.45371:
	jal %zero beq_cont.45369 # then sentence ends
beq_else.45368:
	li %f2 l.37367 #111
beq_cont.45369:
	fneg %f2 %f2 #1479
	slli %a7 %a9 2 #1479
	add %a12 %a8 %a7 #1479
	sw %f2 %a12 0 #1479
	jal %zero beq_cont.45367 # then sentence ends
beq_else.45366:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.45372 # nontail if
	lw %a6 %a3 16 #276
	lw %f2 %a6 0 #281
	fneg %f2 %f2 #1485
	lw %a6 %sp 80 #1485
	sw %f2 %a6 0 #1485
	lw %a7 %a3 16 #286
	lw %f2 %a7 4 #291
	fneg %f2 %f2 #1486
	sw %f2 %a6 4 #1486
	lw %a7 %a3 16 #296
	lw %f2 %a7 8 #301
	fneg %f2 %f2 #1487
	sw %f2 %a6 8 #1487
	jal %zero beq_cont.45373 # then sentence ends
beq_else.45372:
	lw %a11 %sp 92 #1520
	add %a0 %a3 %zero
	sw %ra %sp 196 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 200 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -200 #1520
	lw %ra %sp 196 #1520
beq_cont.45373:
beq_cont.45367:
	lw %a1 %sp 84 #152
	lw %f0 %a1 0 #152
	lw %a0 %sp 76 #152
	sw %f0 %a0 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a0 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a0 8 #154
	lw %a0 %sp 188 #1659
	lw %a11 %sp 64 #1659
	sw %ra %sp 196 #1659 call cls
	lw %a10 %a11 0 #1659
	addi %sp %sp 200 #1659	
	jalr %ra %a10 0 #1659
	addi %sp %sp -200 #1659
	lw %ra %sp 196 #1659
	addi %a1 %zero 4 #1662
	lw %a0 %sp 184 #1662
	sw %ra %sp 196 #1662 call dir
	addi %sp %sp 200 #1662	
	jal %ra min_caml_sll #1662
	addi %sp %sp -200 #1662
	lw %ra %sp 196 #1662
	lw %a1 %sp 88 #39
	lw %a2 %a1 0 #39
	add %a0 %a0 %a2 #1662
	lw %a2 %sp 164 #1662
	slli %a3 %a2 2 #1662
	lw %a4 %sp 160 #1662
	add %a12 %a4 %a3 #1662
	sw %a0 %a12 0 #1662
	lw %a0 %sp 128 #446
	lw %a3 %a0 4 #446
	slli %a5 %a2 2 #1664
	add %a12 %a3 %a5 #1664
	lw %a3 %a12 0 #1664
	lw %a5 %sp 84 #152
	lw %f0 %a5 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a5 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a5 8 #152
	sw %f0 %a3 8 #154
	lw %a3 %a0 12 #461
	lw %a6 %sp 188 #346
	lw %a7 %a6 28 #346
	lw %f0 %a7 0 #351
	li %f1 l.38448 #1668
	fless %a7 %f0 %f1 #1668
	addi %a12 %zero 0
	bne %a7 %a12 beq_else.45374 # nontail if
	addi %a7 %zero 1 #1671
	slli %a8 %a2 2 #1671
	add %a12 %a3 %a8 #1671
	sw %a7 %a12 0 #1671
	lw %a3 %a0 16 #468
	slli %a7 %a2 2 #1673
	add %a12 %a3 %a7 #1673
	lw %a7 %a12 0 #1673
	lw %a8 %sp 60 #152
	lw %f0 %a8 0 #152
	sw %f0 %a7 0 #152
	lw %f0 %a8 4 #152
	sw %f0 %a7 4 #153
	lw %f0 %a8 8 #152
	sw %f0 %a7 8 #154
	slli %a7 %a2 2 #1673
	add %a12 %a3 %a7 #1673
	lw %a3 %a12 0 #1673
	li %f0 l.38683 #1674
	lw %f1 %sp 176 #1674
	fmul %f0 %f0 %f1 #1674
	lw %f2 %a3 0 #212
	fmul %f2 %f2 %f0 #212
	sw %f2 %a3 0 #212
	lw %f2 %a3 4 #212
	fmul %f2 %f2 %f0 #213
	sw %f2 %a3 4 #213
	lw %f2 %a3 8 #212
	fmul %f0 %f2 %f0 #214
	sw %f0 %a3 8 #214
	lw %a3 %a0 28 #498
	slli %a7 %a2 2 #1676
	add %a12 %a3 %a7 #1676
	lw %a3 %a12 0 #1676
	lw %a7 %sp 80 #152
	lw %f0 %a7 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a7 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a7 8 #152
	sw %f0 %a3 8 #154
	jal %zero beq_cont.45375 # then sentence ends
beq_else.45374:
	addi %a7 %zero 0 #1669
	slli %a8 %a2 2 #1669
	add %a12 %a3 %a8 #1669
	sw %a7 %a12 0 #1669
beq_cont.45375:
	li %f0 l.38698 #1679
	lw %a3 %sp 156 #181
	lw %f1 %a3 0 #181
	lw %a7 %sp 80 #181
	lw %f2 %a7 0 #181
	fmul %f1 %f1 %f2 #181
	lw %f2 %a3 4 #181
	lw %f3 %a7 4 #181
	fmul %f2 %f2 %f3 #181
	fadd %f1 %f1 %f2 #181
	lw %f2 %a3 8 #181
	lw %f3 %a7 8 #181
	fmul %f2 %f2 %f3 #181
	fadd %f1 %f1 %f2 #181
	fmul %f0 %f0 %f1 #1679
	lw %f1 %a3 0 #191
	lw %f2 %a7 0 #191
	fmul %f2 %f0 %f2 #191
	fadd %f1 %f1 %f2 #191
	sw %f1 %a3 0 #191
	lw %f1 %a3 4 #191
	lw %f2 %a7 4 #191
	fmul %f2 %f0 %f2 #192
	fadd %f1 %f1 %f2 #192
	sw %f1 %a3 4 #192
	lw %f1 %a3 8 #191
	lw %f2 %a7 8 #191
	fmul %f0 %f0 %f2 #193
	fadd %f0 %f1 %f0 #193
	sw %f0 %a3 8 #193
	lw %a8 %a6 28 #356
	lw %f0 %a8 4 #361
	lw %f1 %sp 144 #1683
	fmul %f0 %f1 %f0 #1683
	lw %a8 %sp 116 #33
	lw %a9 %a8 0 #33
	lw %a10 %a9 0 #1257
	lw %a11 %a10 0 #1258
	sw %f0 %sp 192 #1259
	addi %a12 %zero -1
	bne %a11 %a12 beq_else.45376 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.45377 # then sentence ends
beq_else.45376:
	sw %a10 %sp 200 #1259
	sw %a9 %sp 204 #1259
	addi %a12 %zero 99
	bne %a11 %a12 beq_else.45378 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.45379 # then sentence ends
beq_else.45378:
	slli %a0 %a11 2 #20
	lw %a6 %sp 100 #20
	add %a12 %a6 %a0 #20
	lw %a0 %a12 0 #20
	lw %f2 %a5 0 #964
	lw %a6 %a0 20 #316
	lw %f3 %a6 0 #321
	fsub %f2 %f2 %f3 #964
	lw %f3 %a5 4 #964
	lw %a6 %a0 20 #326
	lw %f4 %a6 4 #331
	fsub %f3 %f3 %f4 #965
	lw %f4 %a5 8 #964
	lw %a6 %a0 20 #336
	lw %f5 %a6 8 #341
	fsub %f4 %f4 %f5 #966
	slli %a6 %a11 2 #968
	lw %a11 %sp 96 #968
	add %a12 %a11 %a6 #968
	lw %a6 %a12 0 #968
	lw %a11 %a0 4 #238
	addi %a12 %zero 1
	bne %a11 %a12 beq_else.45380 # nontail if
	lw %a11 %sp 48 #971
	lw %a4 %sp 56 #971
	add %a2 %a6 %zero
	add %a1 %a11 %zero
	add %a11 %a4 %zero
	fadd %f1 %f3 %fzero
	fadd %f0 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 212 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 216 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -216 #971
	lw %ra %sp 212 #971
	jal %zero beq_cont.45381 # then sentence ends
beq_else.45380:
	addi %a12 %zero 2
	bne %a11 %a12 beq_else.45382 # nontail if
	lw %f5 %a6 0 #934
	fisneg %a0 %f5 #934
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45384 # nontail if
	addi %a0 %zero 0 #938
	jal %zero beq_cont.45385 # then sentence ends
beq_else.45384:
	lw %f5 %a6 4 #934
	fmul %f2 %f5 %f2 #936
	lw %f5 %a6 8 #934
	fmul %f3 %f5 %f3 #936
	fadd %f2 %f2 %f3 #936
	lw %f3 %a6 12 #934
	fmul %f3 %f3 %f4 #936
	fadd %f2 %f2 %f3 #936
	lw %a0 %sp 20 #935
	sw %f2 %a0 0 #935
	addi %a0 %zero 1 #937
beq_cont.45385:
	jal %zero beq_cont.45383 # then sentence ends
beq_else.45382:
	lw %a11 %sp 12 #975
	add %a1 %a6 %zero
	fadd %f1 %f3 %fzero
	fadd %f0 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 212 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 216 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -216 #975
	lw %ra %sp 212 #975
beq_cont.45383:
beq_cont.45381:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45386 # nontail if
	addi %a0 %zero 0 #1275
	jal %zero beq_cont.45387 # then sentence ends
beq_else.45386:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	li %f1 l.37986 #1270
	fless %a1 %f0 %f1 #1270
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45388 # nontail if
	addi %a0 %zero 0 #1274
	jal %zero beq_cont.45389 # then sentence ends
beq_else.45388:
	lw %a1 %sp 200 #1242
	lw %a2 %a1 4 #1242
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.45390 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45391 # then sentence ends
beq_else.45390:
	slli %a2 %a2 2 #31
	lw %a3 %sp 112 #31
	add %a12 %a3 %a2 #31
	lw %a2 %a12 0 #31
	addi %a4 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45392 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45394 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45395 # then sentence ends
beq_else.45394:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45396 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45398 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45399 # then sentence ends
beq_else.45398:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45400 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45402 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45403 # then sentence ends
beq_else.45402:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45404 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45406 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45407 # then sentence ends
beq_else.45406:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45408 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45410 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45411 # then sentence ends
beq_else.45410:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45412 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 200 #1251
	lw %a11 %sp 36 #1251
	sw %ra %sp 212 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 216 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -216 #1251
	lw %ra %sp 212 #1251
	jal %zero beq_cont.45413 # then sentence ends
beq_else.45412:
	addi %a0 %zero 1 #1249
beq_cont.45413:
beq_cont.45411:
	jal %zero beq_cont.45409 # then sentence ends
beq_else.45408:
	addi %a0 %zero 1 #1249
beq_cont.45409:
beq_cont.45407:
	jal %zero beq_cont.45405 # then sentence ends
beq_else.45404:
	addi %a0 %zero 1 #1249
beq_cont.45405:
beq_cont.45403:
	jal %zero beq_cont.45401 # then sentence ends
beq_else.45400:
	addi %a0 %zero 1 #1249
beq_cont.45401:
beq_cont.45399:
	jal %zero beq_cont.45397 # then sentence ends
beq_else.45396:
	addi %a0 %zero 1 #1249
beq_cont.45397:
beq_cont.45395:
	jal %zero beq_cont.45393 # then sentence ends
beq_else.45392:
	addi %a0 %zero 1 #1249
beq_cont.45393:
beq_cont.45391:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45414 # nontail if
	addi %a0 %zero 0 #1273
	jal %zero beq_cont.45415 # then sentence ends
beq_else.45414:
	addi %a0 %zero 1 #1272
beq_cont.45415:
beq_cont.45389:
beq_cont.45387:
beq_cont.45379:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45416 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 204 #1282
	lw %a11 %sp 32 #1282
	sw %ra %sp 212 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 216 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -216 #1282
	lw %ra %sp 212 #1282
	jal %zero beq_cont.45417 # then sentence ends
beq_else.45416:
	lw %a0 %sp 200 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45418 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45419 # then sentence ends
beq_else.45418:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45420 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45422 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45423 # then sentence ends
beq_else.45422:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45424 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45426 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45427 # then sentence ends
beq_else.45426:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45428 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45430 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45431 # then sentence ends
beq_else.45430:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45432 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45434 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45435 # then sentence ends
beq_else.45434:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45436 # nontail if
	lw %a0 %sp 200 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45438 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45439 # then sentence ends
beq_else.45438:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 40 #1247
	add %a0 %a3 %zero
	sw %ra %sp 212 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 216 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -216 #1247
	lw %ra %sp 212 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45440 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 200 #1251
	lw %a11 %sp 36 #1251
	sw %ra %sp 212 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 216 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -216 #1251
	lw %ra %sp 212 #1251
	jal %zero beq_cont.45441 # then sentence ends
beq_else.45440:
	addi %a0 %zero 1 #1249
beq_cont.45441:
beq_cont.45439:
	jal %zero beq_cont.45437 # then sentence ends
beq_else.45436:
	addi %a0 %zero 1 #1249
beq_cont.45437:
beq_cont.45435:
	jal %zero beq_cont.45433 # then sentence ends
beq_else.45432:
	addi %a0 %zero 1 #1249
beq_cont.45433:
beq_cont.45431:
	jal %zero beq_cont.45429 # then sentence ends
beq_else.45428:
	addi %a0 %zero 1 #1249
beq_cont.45429:
beq_cont.45427:
	jal %zero beq_cont.45425 # then sentence ends
beq_else.45424:
	addi %a0 %zero 1 #1249
beq_cont.45425:
beq_cont.45423:
	jal %zero beq_cont.45421 # then sentence ends
beq_else.45420:
	addi %a0 %zero 1 #1249
beq_cont.45421:
beq_cont.45419:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45442 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 204 #1280
	lw %a11 %sp 32 #1280
	sw %ra %sp 212 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 216 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -216 #1280
	lw %ra %sp 212 #1280
	jal %zero beq_cont.45443 # then sentence ends
beq_else.45442:
	addi %a0 %zero 1 #1278
beq_cont.45443:
beq_cont.45417:
beq_cont.45377:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45444 # nontail if
	lw %a0 %sp 80 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 152 #181
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
	fneg %f0 %f0 #1687
	lw %f1 %sp 176 #1687
	fmul %f0 %f0 %f1 #1687
	lw %a2 %sp 156 #181
	lw %f2 %a2 0 #181
	lw %f3 %a1 0 #181
	fmul %f2 %f2 %f3 #181
	lw %f3 %a2 4 #181
	lw %f4 %a1 4 #181
	fmul %f3 %f3 %f4 #181
	fadd %f2 %f2 %f3 #181
	lw %f3 %a2 8 #181
	lw %f4 %a1 8 #181
	fmul %f3 %f3 %f4 #181
	fadd %f2 %f2 %f3 #181
	fneg %f2 %f2 #1688
	fispos %a1 %f0 #1606
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45446 # nontail if
	jal %zero beq_cont.45447 # then sentence ends
beq_else.45446:
	lw %a1 %sp 136 #191
	lw %f3 %a1 0 #191
	lw %a3 %sp 60 #191
	lw %f4 %a3 0 #191
	fmul %f4 %f0 %f4 #191
	fadd %f3 %f3 %f4 #191
	sw %f3 %a1 0 #191
	lw %f3 %a1 4 #191
	lw %f4 %a3 4 #191
	fmul %f4 %f0 %f4 #192
	fadd %f3 %f3 %f4 #192
	sw %f3 %a1 4 #192
	lw %f3 %a1 8 #191
	lw %f4 %a3 8 #191
	fmul %f0 %f0 %f4 #193
	fadd %f0 %f3 %f0 #193
	sw %f0 %a1 8 #193
beq_cont.45447:
	fispos %a1 %f2 #1611
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45448 # nontail if
	jal %zero beq_cont.45449 # then sentence ends
beq_else.45448:
	fmul %f0 %f2 %f2 #1612
	fmul %f0 %f0 %f0 #1612
	lw %f2 %sp 192 #1612
	fmul %f0 %f0 %f2 #1612
	lw %a1 %sp 136 #54
	lw %f3 %a1 0 #54
	fadd %f3 %f3 %f0 #1613
	sw %f3 %a1 0 #1613
	lw %f3 %a1 4 #54
	fadd %f3 %f3 %f0 #1614
	sw %f3 %a1 4 #1614
	lw %f3 %a1 8 #54
	fadd %f0 %f3 %f0 #1615
	sw %f0 %a1 8 #1615
beq_cont.45449:
	jal %zero beq_cont.45445 # then sentence ends
beq_else.45444:
beq_cont.45445:
	lw %a0 %sp 84 #152
	lw %f0 %a0 0 #152
	lw %a1 %sp 8 #152
	sw %f0 %a1 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a1 8 #154
	lw %a1 %sp 72 #15
	lw %a1 %a1 0 #15
	addi %a1 %a1 -1 #1147
	lw %a11 %sp 44 #1147
	sw %ra %sp 212 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 216 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -216 #1147
	lw %ra %sp 212 #1147
	lw %a0 %sp 68 #99
	lw %a0 %a0 0 #99
	addi %a0 %a0 -1 #1694
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45450 # nontail if
	slli %a1 %a0 2 #95
	lw %a2 %sp 52 #95
	add %a12 %a2 %a1 #95
	lw %a1 %a12 0 #95
	lw %a2 %a1 4 #527
	li %f0 l.38510 #1458
	lw %a3 %sp 168 #1458
	sw %f0 %a3 0 #1458
	lw %a4 %sp 116 #33
	lw %a5 %a4 0 #33
	lw %a6 %a5 0 #1433
	lw %a7 %a6 0 #1434
	sw %a0 %sp 208 #1435
	sw %a2 %sp 212 #1435
	sw %a1 %sp 216 #1435
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.45452 # nontail if
	jal %zero beq_cont.45453 # then sentence ends
beq_else.45452:
	sw %a5 %sp 220 #1435
	addi %a12 %zero 99
	bne %a7 %a12 beq_else.45454 # nontail if
	lw %a7 %a6 4 #1423
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.45456 # nontail if
	jal %zero beq_cont.45457 # then sentence ends
beq_else.45456:
	slli %a7 %a7 2 #31
	lw %a8 %sp 112 #31
	add %a12 %a8 %a7 #31
	lw %a7 %a12 0 #31
	addi %a9 %zero 0 #1426
	lw %a11 %sp 28 #1426
	sw %a6 %sp 224 #1426
	add %a1 %a7 %zero
	add %a0 %a9 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	lw %a0 %sp 224 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45458 # nontail if
	jal %zero beq_cont.45459 # then sentence ends
beq_else.45458:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 212 #1426
	lw %a11 %sp 28 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	lw %a0 %sp 224 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45460 # nontail if
	jal %zero beq_cont.45461 # then sentence ends
beq_else.45460:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 212 #1426
	lw %a11 %sp 28 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	lw %a0 %sp 224 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45462 # nontail if
	jal %zero beq_cont.45463 # then sentence ends
beq_else.45462:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 212 #1426
	lw %a11 %sp 28 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 224 #1427
	lw %a2 %sp 212 #1427
	lw %a11 %sp 24 #1427
	sw %ra %sp 228 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 232 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -232 #1427
	lw %ra %sp 228 #1427
beq_cont.45463:
beq_cont.45461:
beq_cont.45459:
beq_cont.45457:
	jal %zero beq_cont.45455 # then sentence ends
beq_else.45454:
	lw %a11 %sp 16 #1443
	sw %a6 %sp 224 #1443
	add %a1 %a2 %zero
	add %a0 %a7 %zero
	sw %ra %sp 228 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 232 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -232 #1443
	lw %ra %sp 228 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45464 # nontail if
	jal %zero beq_cont.45465 # then sentence ends
beq_else.45464:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 168 #41
	lw %f1 %a0 0 #41
	fless %a1 %f0 %f1 #1446
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45466 # nontail if
	jal %zero beq_cont.45467 # then sentence ends
beq_else.45466:
	lw %a1 %sp 224 #1423
	lw %a2 %a1 4 #1423
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.45468 # nontail if
	jal %zero beq_cont.45469 # then sentence ends
beq_else.45468:
	slli %a2 %a2 2 #31
	lw %a3 %sp 112 #31
	add %a12 %a3 %a2 #31
	lw %a2 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 212 #1426
	lw %a11 %sp 28 #1426
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	add %a2 %a5 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	lw %a0 %sp 224 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45470 # nontail if
	jal %zero beq_cont.45471 # then sentence ends
beq_else.45470:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 212 #1426
	lw %a11 %sp 28 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	lw %a0 %sp 224 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45472 # nontail if
	jal %zero beq_cont.45473 # then sentence ends
beq_else.45472:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 212 #1426
	lw %a11 %sp 28 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	lw %a0 %sp 224 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45474 # nontail if
	jal %zero beq_cont.45475 # then sentence ends
beq_else.45474:
	slli %a1 %a1 2 #31
	lw %a2 %sp 112 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 212 #1426
	lw %a11 %sp 28 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 228 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 232 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -232 #1426
	lw %ra %sp 228 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 224 #1427
	lw %a2 %sp 212 #1427
	lw %a11 %sp 24 #1427
	sw %ra %sp 228 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 232 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -232 #1427
	lw %ra %sp 228 #1427
beq_cont.45475:
beq_cont.45473:
beq_cont.45471:
beq_cont.45469:
beq_cont.45467:
beq_cont.45465:
beq_cont.45455:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 220 #1451
	lw %a2 %sp 212 #1451
	lw %a11 %sp 4 #1451
	sw %ra %sp 228 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 232 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -232 #1451
	lw %ra %sp 228 #1451
beq_cont.45453:
	lw %a0 %sp 168 #41
	lw %f0 %a0 0 #41
	li %f1 l.37986 #1462
	fless %a1 %f1 %f0 #1462
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45476 # nontail if
	addi %a1 %zero 0 #1464
	jal %zero beq_cont.45477 # then sentence ends
beq_else.45476:
	li %f1 l.38516 #1463
	fless %a1 %f0 %f1 #1463
beq_cont.45477:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45478 # nontail if
	jal %zero beq_cont.45479 # then sentence ends
beq_else.45478:
	lw %a1 %sp 132 #45
	lw %a1 %a1 0 #45
	addi %a2 %zero 4 #1628
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 228 #1628 call dir
	addi %sp %sp 232 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -232 #1628
	lw %ra %sp 228 #1628
	lw %a1 %sp 88 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1628
	lw %a1 %sp 216 #521
	lw %a2 %a1 0 #521
	bne %a0 %a2 beq_else.45480 # nontail if
	addi %a0 %zero 0 #1631
	lw %a2 %sp 116 #33
	lw %a2 %a2 0 #33
	lw %a11 %sp 32 #1631
	add %a1 %a2 %zero
	sw %ra %sp 228 #1631 call cls
	lw %a10 %a11 0 #1631
	addi %sp %sp 232 #1631	
	jalr %ra %a10 0 #1631
	addi %sp %sp -232 #1631
	lw %ra %sp 228 #1631
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45482 # nontail if
	lw %a0 %sp 212 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 80 #181
	lw %f0 %a2 0 #181
	lw %f1 %a1 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a2 4 #181
	lw %f2 %a1 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a2 8 #181
	lw %f2 %a1 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %a1 %sp 216 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 176 #1635
	fmul %f3 %f1 %f2 #1635
	fmul %f0 %f3 %f0 #1635
	lw %a0 %a0 0 #507
	lw %a1 %sp 156 #181
	lw %f3 %a1 0 #181
	lw %f4 %a0 0 #181
	fmul %f3 %f3 %f4 #181
	lw %f4 %a1 4 #181
	lw %f5 %a0 4 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	lw %f4 %a1 8 #181
	lw %f5 %a0 8 #181
	fmul %f4 %f4 %f5 #181
	fadd %f3 %f3 %f4 #181
	fmul %f1 %f1 %f3 #1636
	lw %f3 %sp 192 #1637
	lw %a11 %sp 108 #1637
	fadd %f2 %f3 %fzero
	sw %ra %sp 228 #1637 call cls
	lw %a10 %a11 0 #1637
	addi %sp %sp 232 #1637	
	jalr %ra %a10 0 #1637
	addi %sp %sp -232 #1637
	lw %ra %sp 228 #1637
	jal %zero beq_cont.45483 # then sentence ends
beq_else.45482:
beq_cont.45483:
	jal %zero beq_cont.45481 # then sentence ends
beq_else.45480:
beq_cont.45481:
beq_cont.45479:
	lw %a0 %sp 208 #1641
	addi %a0 %a0 -1 #1641
	lw %f0 %sp 176 #1641
	lw %f1 %sp 192 #1641
	lw %a1 %sp 156 #1641
	lw %a11 %sp 0 #1641
	sw %ra %sp 228 #1641 call cls
	lw %a10 %a11 0 #1641
	addi %sp %sp 232 #1641	
	jalr %ra %a10 0 #1641
	addi %sp %sp -232 #1641
	lw %ra %sp 228 #1641
	jal %zero bge_cont.45451 # then sentence ends
bge_else.45450:
bge_cont.45451:
	li %f0 l.38835 #1697
	lw %f1 %sp 144 #1697
	fless %a0 %f0 %f1 #1697
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45484
	jalr %zero %ra 0 #1708
beq_else.45484:
	lw %a0 %sp 164 #1699
	addi %a12 %zero 4
	blt %a0 %a12 bge_else.45486 # nontail if
	jal %zero bge_cont.45487 # then sentence ends
bge_else.45486:
	addi %a1 %a0 1 #1700
	addi %a2 %zero -1 #1700
	slli %a1 %a1 2 #1700
	lw %a3 %sp 160 #1700
	add %a12 %a3 %a1 #1700
	sw %a2 %a12 0 #1700
bge_cont.45487:
	lw %a1 %sp 172 #20
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.45488
	li %f0 l.37441 #1704
	lw %a1 %sp 188 #346
	lw %a1 %a1 28 #346
	lw %f2 %a1 0 #351
	fsub %f0 %f0 %f2 #1704
	fmul %f0 %f1 %f0 #1704
	addi %a0 %a0 1 #1705
	lw %a1 %sp 168 #41
	lw %f1 %a1 0 #41
	lw %f2 %sp 120 #1705
	fadd %f1 %f2 %f1 #1705
	lw %a1 %sp 156 #1705
	lw %a2 %sp 128 #1705
	lw %a11 %sp 104 #1705
	lw %a10 %a11 0 #1705
	jalr %zero %a10 0 #1705
beq_else.45488:
	jalr %zero %ra 0 #1706
bge_else.45357:
	jalr %zero %ra 0 #1729
trace_diffuse_ray.2805:
	lw %a1 %a11 88 #1737
	lw %a2 %a11 84 #1737
	lw %a3 %a11 80 #1737
	lw %a4 %a11 76 #1737
	lw %a5 %a11 72 #1737
	lw %a6 %a11 68 #1737
	lw %a7 %a11 64 #1737
	lw %a8 %a11 60 #1737
	lw %a9 %a11 56 #1737
	lw %a10 %a11 52 #1737
	sw %a5 %sp 0 #1737
	lw %a5 %a11 48 #1737
	sw %a9 %sp 4 #1737
	lw %a9 %a11 44 #1737
	sw %a10 %sp 8 #1737
	lw %a10 %a11 40 #1737
	sw %a5 %sp 12 #1737
	lw %a5 %a11 36 #1737
	sw %a6 %sp 16 #1737
	lw %a6 %a11 32 #1737
	sw %a6 %sp 20 #1737
	lw %a6 %a11 28 #1737
	sw %a8 %sp 24 #1737
	lw %a8 %a11 24 #1737
	sw %a1 %sp 28 #1737
	lw %a1 %a11 20 #1737
	sw %a7 %sp 32 #1737
	lw %a7 %a11 16 #1737
	sw %a8 %sp 36 #1737
	lw %a8 %a11 12 #1737
	sw %a8 %sp 40 #1737
	lw %a8 %a11 8 #1737
	lw %a11 %a11 4 #1737
	li %f1 l.38510 #1458
	sw %f1 %a4 0 #1458
	sw %a11 %sp 44 #1459
	addi %a11 %zero 0 #1459
	sw %a8 %sp 48 #33
	lw %a8 %a9 0 #33
	sw %f0 %sp 56 #1459
	sw %a9 %sp 64 #1459
	sw %a2 %sp 68 #1459
	sw %a7 %sp 72 #1459
	sw %a5 %sp 76 #1459
	sw %a6 %sp 80 #1459
	sw %a0 %sp 84 #1459
	sw %a10 %sp 88 #1459
	sw %a1 %sp 92 #1459
	sw %a4 %sp 96 #1459
	add %a2 %a0 %zero
	add %a1 %a8 %zero
	add %a0 %a11 %zero
	add %a11 %a3 %zero
	sw %ra %sp 100 #1459 call cls
	lw %a10 %a11 0 #1459
	addi %sp %sp 104 #1459	
	jalr %ra %a10 0 #1459
	addi %sp %sp -104 #1459
	lw %ra %sp 100 #1459
	lw %a0 %sp 96 #41
	lw %f0 %a0 0 #41
	li %f1 l.37986 #1462
	fless %a0 %f1 %f0 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45492 # nontail if
	addi %a0 %zero 0 #1464
	jal %zero beq_cont.45493 # then sentence ends
beq_else.45492:
	li %f1 l.38516 #1463
	fless %a0 %f0 %f1 #1463
beq_cont.45493:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45494
	jalr %zero %ra 0 #1751
beq_else.45494:
	lw %a0 %sp 92 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a1 %sp 88 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a2 %sp 84 #507
	lw %a2 %a2 0 #507
	lw %a3 %a0 4 #238
	sw %a0 %sp 100 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.45496 # nontail if
	lw %a3 %sp 80 #39
	lw %a3 %a3 0 #39
	li %f0 l.37367 #147
	lw %a4 %sp 76 #140
	sw %f0 %a4 0 #140
	sw %f0 %a4 4 #141
	sw %f0 %a4 8 #142
	addi %a5 %a3 -1 #1479
	addi %a3 %a3 -1 #1479
	slli %a3 %a3 2 #1479
	add %a12 %a2 %a3 #1479
	lw %f0 %a12 0 #1479
	fiszero %a2 %f0 #111
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45498 # nontail if
	fispos %a2 %f0 #112
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45500 # nontail if
	li %f0 l.37443 #113
	jal %zero beq_cont.45501 # then sentence ends
beq_else.45500:
	li %f0 l.37441 #112
beq_cont.45501:
	jal %zero beq_cont.45499 # then sentence ends
beq_else.45498:
	li %f0 l.37367 #111
beq_cont.45499:
	fneg %f0 %f0 #1479
	slli %a2 %a5 2 #1479
	add %a12 %a4 %a2 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.45497 # then sentence ends
beq_else.45496:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.45502 # nontail if
	lw %a2 %a0 16 #276
	lw %f0 %a2 0 #281
	fneg %f0 %f0 #1485
	lw %a2 %sp 76 #1485
	sw %f0 %a2 0 #1485
	lw %a3 %a0 16 #286
	lw %f0 %a3 4 #291
	fneg %f0 %f0 #1486
	sw %f0 %a2 4 #1486
	lw %a3 %a0 16 #296
	lw %f0 %a3 8 #301
	fneg %f0 %f0 #1487
	sw %f0 %a2 8 #1487
	jal %zero beq_cont.45503 # then sentence ends
beq_else.45502:
	lw %a11 %sp 72 #1520
	sw %ra %sp 108 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 112 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -112 #1520
	lw %ra %sp 108 #1520
beq_cont.45503:
beq_cont.45497:
	lw %a0 %sp 100 #1743
	lw %a1 %sp 36 #1743
	lw %a11 %sp 68 #1743
	sw %ra %sp 108 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 112 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -112 #1743
	lw %ra %sp 108 #1743
	lw %a0 %sp 64 #33
	lw %a1 %a0 0 #33
	lw %a0 %a1 0 #1257
	lw %a2 %a0 0 #1258
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.45504 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.45505 # then sentence ends
beq_else.45504:
	sw %a0 %sp 104 #1259
	sw %a1 %sp 108 #1259
	addi %a12 %zero 99
	bne %a2 %a12 beq_else.45506 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.45507 # then sentence ends
beq_else.45506:
	slli %a3 %a2 2 #20
	lw %a4 %sp 88 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %sp 36 #964
	lw %f0 %a4 0 #964
	lw %a5 %a3 20 #316
	lw %f1 %a5 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a4 4 #964
	lw %a5 %a3 20 #326
	lw %f2 %a5 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a4 8 #964
	lw %a4 %a3 20 #336
	lw %f3 %a4 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a2 %a2 2 #968
	lw %a4 %sp 48 #968
	add %a12 %a4 %a2 #968
	lw %a2 %a12 0 #968
	lw %a4 %a3 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.45508 # nontail if
	lw %a4 %sp 28 #971
	lw %a11 %sp 32 #971
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 120 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -120 #971
	lw %ra %sp 116 #971
	jal %zero beq_cont.45509 # then sentence ends
beq_else.45508:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.45510 # nontail if
	lw %f3 %a2 0 #934
	fisneg %a3 %f3 #934
	addi %a12 %zero 0
	bne %a3 %a12 beq_else.45512 # nontail if
	addi %a0 %zero 0 #938
	jal %zero beq_cont.45513 # then sentence ends
beq_else.45512:
	lw %f3 %a2 4 #934
	fmul %f0 %f3 %f0 #936
	lw %f3 %a2 8 #934
	fmul %f1 %f3 %f1 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a2 12 #934
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a2 %sp 24 #935
	sw %f0 %a2 0 #935
	addi %a0 %zero 1 #937
beq_cont.45513:
	jal %zero beq_cont.45511 # then sentence ends
beq_else.45510:
	lw %a11 %sp 16 #975
	add %a1 %a2 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 120 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -120 #975
	lw %ra %sp 116 #975
beq_cont.45511:
beq_cont.45509:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45514 # nontail if
	addi %a0 %zero 0 #1275
	jal %zero beq_cont.45515 # then sentence ends
beq_else.45514:
	lw %a0 %sp 24 #37
	lw %f0 %a0 0 #37
	li %f1 l.37986 #1270
	fless %a0 %f0 %f1 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45516 # nontail if
	addi %a0 %zero 0 #1274
	jal %zero beq_cont.45517 # then sentence ends
beq_else.45516:
	lw %a0 %sp 104 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45518 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45519 # then sentence ends
beq_else.45518:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45520 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45522 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45523 # then sentence ends
beq_else.45522:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45524 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45526 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45527 # then sentence ends
beq_else.45526:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45528 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45530 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45531 # then sentence ends
beq_else.45530:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45532 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45534 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45535 # then sentence ends
beq_else.45534:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45536 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45538 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45539 # then sentence ends
beq_else.45538:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45540 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 104 #1251
	lw %a11 %sp 8 #1251
	sw %ra %sp 116 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 120 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -120 #1251
	lw %ra %sp 116 #1251
	jal %zero beq_cont.45541 # then sentence ends
beq_else.45540:
	addi %a0 %zero 1 #1249
beq_cont.45541:
beq_cont.45539:
	jal %zero beq_cont.45537 # then sentence ends
beq_else.45536:
	addi %a0 %zero 1 #1249
beq_cont.45537:
beq_cont.45535:
	jal %zero beq_cont.45533 # then sentence ends
beq_else.45532:
	addi %a0 %zero 1 #1249
beq_cont.45533:
beq_cont.45531:
	jal %zero beq_cont.45529 # then sentence ends
beq_else.45528:
	addi %a0 %zero 1 #1249
beq_cont.45529:
beq_cont.45527:
	jal %zero beq_cont.45525 # then sentence ends
beq_else.45524:
	addi %a0 %zero 1 #1249
beq_cont.45525:
beq_cont.45523:
	jal %zero beq_cont.45521 # then sentence ends
beq_else.45520:
	addi %a0 %zero 1 #1249
beq_cont.45521:
beq_cont.45519:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45542 # nontail if
	addi %a0 %zero 0 #1273
	jal %zero beq_cont.45543 # then sentence ends
beq_else.45542:
	addi %a0 %zero 1 #1272
beq_cont.45543:
beq_cont.45517:
beq_cont.45515:
beq_cont.45507:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45544 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 108 #1282
	lw %a11 %sp 4 #1282
	sw %ra %sp 116 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 120 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -120 #1282
	lw %ra %sp 116 #1282
	jal %zero beq_cont.45545 # then sentence ends
beq_else.45544:
	lw %a0 %sp 104 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45546 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45547 # then sentence ends
beq_else.45546:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45548 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45550 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45551 # then sentence ends
beq_else.45550:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45552 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45554 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45555 # then sentence ends
beq_else.45554:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45556 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 16 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45558 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45559 # then sentence ends
beq_else.45558:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45560 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 20 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45562 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45563 # then sentence ends
beq_else.45562:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45564 # nontail if
	lw %a0 %sp 104 #1242
	lw %a1 %a0 24 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45566 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.45567 # then sentence ends
beq_else.45566:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a2 %zero
	sw %ra %sp 116 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 120 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -120 #1247
	lw %ra %sp 116 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45568 # nontail if
	addi %a0 %zero 7 #1251
	lw %a1 %sp 104 #1251
	lw %a11 %sp 8 #1251
	sw %ra %sp 116 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 120 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -120 #1251
	lw %ra %sp 116 #1251
	jal %zero beq_cont.45569 # then sentence ends
beq_else.45568:
	addi %a0 %zero 1 #1249
beq_cont.45569:
beq_cont.45567:
	jal %zero beq_cont.45565 # then sentence ends
beq_else.45564:
	addi %a0 %zero 1 #1249
beq_cont.45565:
beq_cont.45563:
	jal %zero beq_cont.45561 # then sentence ends
beq_else.45560:
	addi %a0 %zero 1 #1249
beq_cont.45561:
beq_cont.45559:
	jal %zero beq_cont.45557 # then sentence ends
beq_else.45556:
	addi %a0 %zero 1 #1249
beq_cont.45557:
beq_cont.45555:
	jal %zero beq_cont.45553 # then sentence ends
beq_else.45552:
	addi %a0 %zero 1 #1249
beq_cont.45553:
beq_cont.45551:
	jal %zero beq_cont.45549 # then sentence ends
beq_else.45548:
	addi %a0 %zero 1 #1249
beq_cont.45549:
beq_cont.45547:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45570 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 108 #1280
	lw %a11 %sp 4 #1280
	sw %ra %sp 116 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 120 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -120 #1280
	lw %ra %sp 116 #1280
	jal %zero beq_cont.45571 # then sentence ends
beq_else.45570:
	addi %a0 %zero 1 #1278
beq_cont.45571:
beq_cont.45545:
beq_cont.45505:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45572
	lw %a0 %sp 76 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 20 #181
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
	fneg %f0 %f0 #1747
	fispos %a0 %f0 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45573 # nontail if
	li %f0 l.37367 #1748
	jal %zero beq_cont.45574 # then sentence ends
beq_else.45573:
beq_cont.45574:
	lw %f1 %sp 56 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 100 #346
	lw %a0 %a0 28 #346
	lw %f1 %a0 0 #351
	fmul %f0 %f0 %f1 #1749
	lw %a0 %sp 40 #191
	lw %f1 %a0 0 #191
	lw %a1 %sp 0 #191
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
beq_else.45572:
	jalr %zero %ra 0 #1750
iter_trace_diffuse_rays.2808:
	lw %a4 %a11 80 #1755
	lw %a5 %a11 76 #1755
	lw %a6 %a11 72 #1755
	lw %a7 %a11 68 #1755
	lw %a8 %a11 64 #1755
	lw %a9 %a11 60 #1755
	lw %a10 %a11 56 #1755
	sw %a2 %sp 0 #1755
	lw %a2 %a11 52 #1755
	sw %a6 %sp 4 #1755
	lw %a6 %a11 48 #1755
	sw %a8 %sp 8 #1755
	lw %a8 %a11 44 #1755
	sw %a8 %sp 12 #1755
	lw %a8 %a11 40 #1755
	sw %a4 %sp 16 #1755
	lw %a4 %a11 36 #1755
	sw %a4 %sp 20 #1755
	lw %a4 %a11 32 #1755
	sw %a4 %sp 24 #1755
	lw %a4 %a11 28 #1755
	sw %a4 %sp 28 #1755
	lw %a4 %a11 24 #1755
	sw %a4 %sp 32 #1755
	lw %a4 %a11 20 #1755
	sw %a4 %sp 36 #1755
	lw %a4 %a11 16 #1755
	sw %a4 %sp 40 #1755
	lw %a4 %a11 12 #1755
	sw %a4 %sp 44 #1755
	lw %a4 %a11 8 #1755
	sw %a11 %sp 48 #1755
	lw %a11 %a11 4 #1755
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.45577
	sw %a4 %sp 52 #1757
	slli %a4 %a3 2 #1757
	add %a12 %a0 %a4 #1757
	lw %a4 %a12 0 #1757
	lw %a4 %a4 0 #507
	lw %f0 %a4 0 #181
	lw %f1 %a1 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a4 4 #181
	lw %f2 %a1 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a4 8 #181
	lw %f2 %a1 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a4 %f0 #1760
	sw %a1 %sp 56 #1760
	sw %a0 %sp 60 #1760
	sw %a3 %sp 64 #1760
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45578 # nontail if
	slli %a4 %a3 2 #1757
	add %a12 %a0 %a4 #1757
	lw %a4 %a12 0 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	li %f1 l.38510 #1458
	sw %f1 %a7 0 #1458
	lw %a1 %a8 0 #33
	lw %a0 %a1 0 #1433
	lw %a3 %a0 0 #1434
	sw %f0 %sp 72 #1435
	sw %a8 %sp 80 #1435
	sw %a4 %sp 84 #1435
	sw %a7 %sp 88 #1435
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45581 # nontail if
	jal %zero beq_cont.45582 # then sentence ends
beq_else.45581:
	sw %a1 %sp 92 #1435
	sw %a5 %sp 96 #1435
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.45583 # nontail if
	lw %a3 %a0 4 #1423
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45585 # nontail if
	jal %zero beq_cont.45586 # then sentence ends
beq_else.45585:
	slli %a3 %a3 2 #31
	add %a12 %a11 %a3 #31
	lw %a3 %a12 0 #31
	addi %a9 %zero 0 #1426
	sw %a2 %sp 100 #1426
	sw %a6 %sp 104 #1426
	sw %a11 %sp 108 #1426
	sw %a0 %sp 112 #1426
	add %a2 %a4 %zero
	add %a1 %a3 %zero
	add %a0 %a9 %zero
	add %a11 %a6 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 112 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45587 # nontail if
	jal %zero beq_cont.45588 # then sentence ends
beq_else.45587:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 84 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 112 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45589 # nontail if
	jal %zero beq_cont.45590 # then sentence ends
beq_else.45589:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 84 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 112 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45591 # nontail if
	jal %zero beq_cont.45592 # then sentence ends
beq_else.45591:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 84 #1426
	lw %a11 %sp 104 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 112 #1427
	lw %a2 %sp 84 #1427
	lw %a11 %sp 100 #1427
	sw %ra %sp 116 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 120 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -120 #1427
	lw %ra %sp 116 #1427
beq_cont.45592:
beq_cont.45590:
beq_cont.45588:
beq_cont.45586:
	jal %zero beq_cont.45584 # then sentence ends
beq_else.45583:
	sw %a2 %sp 100 #1443
	sw %a6 %sp 104 #1443
	sw %a11 %sp 108 #1443
	sw %a0 %sp 112 #1443
	sw %a10 %sp 116 #1443
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	add %a11 %a9 %zero
	sw %ra %sp 124 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 128 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -128 #1443
	lw %ra %sp 124 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45593 # nontail if
	jal %zero beq_cont.45594 # then sentence ends
beq_else.45593:
	lw %a0 %sp 116 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 88 #41
	lw %f1 %a0 0 #41
	fless %a1 %f0 %f1 #1446
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45595 # nontail if
	jal %zero beq_cont.45596 # then sentence ends
beq_else.45595:
	lw %a1 %sp 112 #1423
	lw %a2 %a1 4 #1423
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.45597 # nontail if
	jal %zero beq_cont.45598 # then sentence ends
beq_else.45597:
	slli %a2 %a2 2 #31
	lw %a3 %sp 108 #31
	add %a12 %a3 %a2 #31
	lw %a2 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 84 #1426
	lw %a11 %sp 104 #1426
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	add %a2 %a5 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 112 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45599 # nontail if
	jal %zero beq_cont.45600 # then sentence ends
beq_else.45599:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 84 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 112 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45601 # nontail if
	jal %zero beq_cont.45602 # then sentence ends
beq_else.45601:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 84 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 112 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45603 # nontail if
	jal %zero beq_cont.45604 # then sentence ends
beq_else.45603:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 84 #1426
	lw %a11 %sp 104 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 112 #1427
	lw %a2 %sp 84 #1427
	lw %a11 %sp 100 #1427
	sw %ra %sp 124 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 128 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -128 #1427
	lw %ra %sp 124 #1427
beq_cont.45604:
beq_cont.45602:
beq_cont.45600:
beq_cont.45598:
beq_cont.45596:
beq_cont.45594:
beq_cont.45584:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 92 #1451
	lw %a2 %sp 84 #1451
	lw %a11 %sp 96 #1451
	sw %ra %sp 124 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 128 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -128 #1451
	lw %ra %sp 124 #1451
beq_cont.45582:
	lw %a0 %sp 88 #41
	lw %f0 %a0 0 #41
	li %f1 l.37986 #1462
	fless %a0 %f1 %f0 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45605 # nontail if
	addi %a0 %zero 0 #1464
	jal %zero beq_cont.45606 # then sentence ends
beq_else.45605:
	li %f1 l.38516 #1463
	fless %a0 %f0 %f1 #1463
beq_cont.45606:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45607 # nontail if
	jal %zero beq_cont.45608 # then sentence ends
beq_else.45607:
	lw %a0 %sp 40 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a1 %sp 20 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a1 %sp 84 #507
	lw %a1 %a1 0 #507
	lw %a2 %a0 4 #238
	sw %a0 %sp 120 #868
	addi %a12 %zero 1
	bne %a2 %a12 beq_else.45609 # nontail if
	lw %a2 %sp 32 #39
	lw %a2 %a2 0 #39
	li %f0 l.37367 #147
	lw %a3 %sp 24 #140
	sw %f0 %a3 0 #140
	sw %f0 %a3 4 #141
	sw %f0 %a3 8 #142
	addi %a4 %a2 -1 #1479
	addi %a2 %a2 -1 #1479
	slli %a2 %a2 2 #1479
	add %a12 %a1 %a2 #1479
	lw %f0 %a12 0 #1479
	fiszero %a1 %f0 #111
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45611 # nontail if
	fispos %a1 %f0 #112
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45613 # nontail if
	li %f0 l.37443 #113
	jal %zero beq_cont.45614 # then sentence ends
beq_else.45613:
	li %f0 l.37441 #112
beq_cont.45614:
	jal %zero beq_cont.45612 # then sentence ends
beq_else.45611:
	li %f0 l.37367 #111
beq_cont.45612:
	fneg %f0 %f0 #1479
	slli %a1 %a4 2 #1479
	add %a12 %a3 %a1 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.45610 # then sentence ends
beq_else.45609:
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.45615 # nontail if
	lw %a1 %a0 16 #276
	lw %f0 %a1 0 #281
	fneg %f0 %f0 #1485
	lw %a1 %sp 24 #1485
	sw %f0 %a1 0 #1485
	lw %a2 %a0 16 #286
	lw %f0 %a2 4 #291
	fneg %f0 %f0 #1486
	sw %f0 %a1 4 #1486
	lw %a2 %a0 16 #296
	lw %f0 %a2 8 #301
	fneg %f0 %f0 #1487
	sw %f0 %a1 8 #1487
	jal %zero beq_cont.45616 # then sentence ends
beq_else.45615:
	lw %a11 %sp 44 #1520
	sw %ra %sp 124 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 128 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -128 #1520
	lw %ra %sp 124 #1520
beq_cont.45616:
beq_cont.45610:
	lw %a0 %sp 120 #1743
	lw %a1 %sp 36 #1743
	lw %a11 %sp 16 #1743
	sw %ra %sp 124 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 128 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -128 #1743
	lw %ra %sp 124 #1743
	addi %a0 %zero 0 #1746
	lw %a1 %sp 80 #33
	lw %a1 %a1 0 #33
	lw %a11 %sp 12 #1746
	sw %ra %sp 124 #1746 call cls
	lw %a10 %a11 0 #1746
	addi %sp %sp 128 #1746	
	jalr %ra %a10 0 #1746
	addi %sp %sp -128 #1746
	lw %ra %sp 124 #1746
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45617 # nontail if
	lw %a0 %sp 24 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 28 #181
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
	fneg %f0 %f0 #1747
	fispos %a0 %f0 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45619 # nontail if
	li %f0 l.37367 #1748
	jal %zero beq_cont.45620 # then sentence ends
beq_else.45619:
beq_cont.45620:
	lw %f1 %sp 72 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 120 #346
	lw %a0 %a0 28 #346
	lw %f1 %a0 0 #351
	fmul %f0 %f0 %f1 #1749
	lw %a0 %sp 52 #191
	lw %f1 %a0 0 #191
	lw %a1 %sp 8 #191
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
	jal %zero beq_cont.45618 # then sentence ends
beq_else.45617:
beq_cont.45618:
beq_cont.45608:
	jal %zero beq_cont.45579 # then sentence ends
beq_else.45578:
	addi %a4 %a3 1 #1761
	slli %a4 %a4 2 #1757
	add %a12 %a0 %a4 #1757
	lw %a4 %a12 0 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	li %f1 l.38510 #1458
	sw %f1 %a7 0 #1458
	lw %a1 %a8 0 #33
	lw %a0 %a1 0 #1433
	lw %a3 %a0 0 #1434
	sw %f0 %sp 128 #1435
	sw %a8 %sp 80 #1435
	sw %a4 %sp 136 #1435
	sw %a7 %sp 88 #1435
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45622 # nontail if
	jal %zero beq_cont.45623 # then sentence ends
beq_else.45622:
	sw %a1 %sp 140 #1435
	sw %a5 %sp 96 #1435
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.45624 # nontail if
	lw %a3 %a0 4 #1423
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.45626 # nontail if
	jal %zero beq_cont.45627 # then sentence ends
beq_else.45626:
	slli %a3 %a3 2 #31
	add %a12 %a11 %a3 #31
	lw %a3 %a12 0 #31
	addi %a9 %zero 0 #1426
	sw %a2 %sp 100 #1426
	sw %a6 %sp 104 #1426
	sw %a11 %sp 108 #1426
	sw %a0 %sp 144 #1426
	add %a2 %a4 %zero
	add %a1 %a3 %zero
	add %a0 %a9 %zero
	add %a11 %a6 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	lw %a0 %sp 144 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45628 # nontail if
	jal %zero beq_cont.45629 # then sentence ends
beq_else.45628:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 136 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	lw %a0 %sp 144 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45630 # nontail if
	jal %zero beq_cont.45631 # then sentence ends
beq_else.45630:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 136 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	lw %a0 %sp 144 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45632 # nontail if
	jal %zero beq_cont.45633 # then sentence ends
beq_else.45632:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 136 #1426
	lw %a11 %sp 104 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 144 #1427
	lw %a2 %sp 136 #1427
	lw %a11 %sp 100 #1427
	sw %ra %sp 148 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 152 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -152 #1427
	lw %ra %sp 148 #1427
beq_cont.45633:
beq_cont.45631:
beq_cont.45629:
beq_cont.45627:
	jal %zero beq_cont.45625 # then sentence ends
beq_else.45624:
	sw %a2 %sp 100 #1443
	sw %a6 %sp 104 #1443
	sw %a11 %sp 108 #1443
	sw %a0 %sp 144 #1443
	sw %a10 %sp 116 #1443
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	add %a11 %a9 %zero
	sw %ra %sp 148 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 152 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -152 #1443
	lw %ra %sp 148 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45634 # nontail if
	jal %zero beq_cont.45635 # then sentence ends
beq_else.45634:
	lw %a0 %sp 116 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 88 #41
	lw %f1 %a0 0 #41
	fless %a1 %f0 %f1 #1446
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45636 # nontail if
	jal %zero beq_cont.45637 # then sentence ends
beq_else.45636:
	lw %a1 %sp 144 #1423
	lw %a2 %a1 4 #1423
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.45638 # nontail if
	jal %zero beq_cont.45639 # then sentence ends
beq_else.45638:
	slli %a2 %a2 2 #31
	lw %a3 %sp 108 #31
	add %a12 %a3 %a2 #31
	lw %a2 %a12 0 #31
	addi %a4 %zero 0 #1426
	lw %a5 %sp 136 #1426
	lw %a11 %sp 104 #1426
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	add %a2 %a5 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	lw %a0 %sp 144 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45640 # nontail if
	jal %zero beq_cont.45641 # then sentence ends
beq_else.45640:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 136 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	lw %a0 %sp 144 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45642 # nontail if
	jal %zero beq_cont.45643 # then sentence ends
beq_else.45642:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 136 #1426
	lw %a11 %sp 104 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	lw %a0 %sp 144 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.45644 # nontail if
	jal %zero beq_cont.45645 # then sentence ends
beq_else.45644:
	slli %a1 %a1 2 #31
	lw %a2 %sp 108 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 136 #1426
	lw %a11 %sp 104 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 148 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 152 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -152 #1426
	lw %ra %sp 148 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 144 #1427
	lw %a2 %sp 136 #1427
	lw %a11 %sp 100 #1427
	sw %ra %sp 148 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 152 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -152 #1427
	lw %ra %sp 148 #1427
beq_cont.45645:
beq_cont.45643:
beq_cont.45641:
beq_cont.45639:
beq_cont.45637:
beq_cont.45635:
beq_cont.45625:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 140 #1451
	lw %a2 %sp 136 #1451
	lw %a11 %sp 96 #1451
	sw %ra %sp 148 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 152 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -152 #1451
	lw %ra %sp 148 #1451
beq_cont.45623:
	lw %a0 %sp 88 #41
	lw %f0 %a0 0 #41
	li %f1 l.37986 #1462
	fless %a0 %f1 %f0 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45646 # nontail if
	addi %a0 %zero 0 #1464
	jal %zero beq_cont.45647 # then sentence ends
beq_else.45646:
	li %f1 l.38516 #1463
	fless %a0 %f0 %f1 #1463
beq_cont.45647:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45648 # nontail if
	jal %zero beq_cont.45649 # then sentence ends
beq_else.45648:
	lw %a0 %sp 40 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a1 %sp 20 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a1 %sp 136 #507
	lw %a1 %a1 0 #507
	lw %a2 %a0 4 #238
	sw %a0 %sp 148 #868
	addi %a12 %zero 1
	bne %a2 %a12 beq_else.45650 # nontail if
	lw %a2 %sp 32 #39
	lw %a2 %a2 0 #39
	li %f0 l.37367 #147
	lw %a3 %sp 24 #140
	sw %f0 %a3 0 #140
	sw %f0 %a3 4 #141
	sw %f0 %a3 8 #142
	addi %a4 %a2 -1 #1479
	addi %a2 %a2 -1 #1479
	slli %a2 %a2 2 #1479
	add %a12 %a1 %a2 #1479
	lw %f0 %a12 0 #1479
	fiszero %a1 %f0 #111
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45652 # nontail if
	fispos %a1 %f0 #112
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45654 # nontail if
	li %f0 l.37443 #113
	jal %zero beq_cont.45655 # then sentence ends
beq_else.45654:
	li %f0 l.37441 #112
beq_cont.45655:
	jal %zero beq_cont.45653 # then sentence ends
beq_else.45652:
	li %f0 l.37367 #111
beq_cont.45653:
	fneg %f0 %f0 #1479
	slli %a1 %a4 2 #1479
	add %a12 %a3 %a1 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.45651 # then sentence ends
beq_else.45650:
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.45656 # nontail if
	lw %a1 %a0 16 #276
	lw %f0 %a1 0 #281
	fneg %f0 %f0 #1485
	lw %a1 %sp 24 #1485
	sw %f0 %a1 0 #1485
	lw %a2 %a0 16 #286
	lw %f0 %a2 4 #291
	fneg %f0 %f0 #1486
	sw %f0 %a1 4 #1486
	lw %a2 %a0 16 #296
	lw %f0 %a2 8 #301
	fneg %f0 %f0 #1487
	sw %f0 %a1 8 #1487
	jal %zero beq_cont.45657 # then sentence ends
beq_else.45656:
	lw %a11 %sp 44 #1520
	sw %ra %sp 156 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 160 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -160 #1520
	lw %ra %sp 156 #1520
beq_cont.45657:
beq_cont.45651:
	lw %a0 %sp 148 #1743
	lw %a1 %sp 36 #1743
	lw %a11 %sp 16 #1743
	sw %ra %sp 156 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 160 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -160 #1743
	lw %ra %sp 156 #1743
	addi %a0 %zero 0 #1746
	lw %a1 %sp 80 #33
	lw %a1 %a1 0 #33
	lw %a11 %sp 12 #1746
	sw %ra %sp 156 #1746 call cls
	lw %a10 %a11 0 #1746
	addi %sp %sp 160 #1746	
	jalr %ra %a10 0 #1746
	addi %sp %sp -160 #1746
	lw %ra %sp 156 #1746
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45658 # nontail if
	lw %a0 %sp 24 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 28 #181
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
	fneg %f0 %f0 #1747
	fispos %a0 %f0 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45660 # nontail if
	li %f0 l.37367 #1748
	jal %zero beq_cont.45661 # then sentence ends
beq_else.45660:
beq_cont.45661:
	lw %f1 %sp 128 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 148 #346
	lw %a0 %a0 28 #346
	lw %f1 %a0 0 #351
	fmul %f0 %f0 %f1 #1749
	lw %a0 %sp 52 #191
	lw %f1 %a0 0 #191
	lw %a1 %sp 8 #191
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
	jal %zero beq_cont.45659 # then sentence ends
beq_else.45658:
beq_cont.45659:
beq_cont.45649:
beq_cont.45579:
	lw %a0 %sp 64 #1765
	addi %a0 %a0 -2 #1765
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45662
	slli %a1 %a0 2 #1757
	lw %a2 %sp 60 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a3 %sp 56 #181
	lw %f1 %a3 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a3 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a3 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	sw %a0 %sp 152 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45663 # nontail if
	slli %a1 %a0 2 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 4 #1763
	add %a0 %a1 %zero
	sw %ra %sp 156 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 160 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -160 #1763
	lw %ra %sp 156 #1763
	jal %zero beq_cont.45664 # then sentence ends
beq_else.45663:
	addi %a1 %a0 1 #1761
	slli %a1 %a1 2 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 4 #1761
	add %a0 %a1 %zero
	sw %ra %sp 156 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 160 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -160 #1761
	lw %ra %sp 156 #1761
beq_cont.45664:
	lw %a0 %sp 152 #1765
	addi %a3 %a0 -2 #1765
	lw %a0 %sp 60 #1765
	lw %a1 %sp 56 #1765
	lw %a2 %sp 0 #1765
	lw %a11 %sp 48 #1765
	lw %a10 %a11 0 #1765
	jalr %zero %a10 0 #1765
bge_else.45662:
	jalr %zero %ra 0 #1766
bge_else.45577:
	jalr %zero %ra 0 #1766
trace_diffuse_ray_80percent.2817:
	lw %a3 %a11 20 #1778
	lw %a4 %a11 16 #1778
	lw %a5 %a11 12 #1778
	lw %a6 %a11 8 #1778
	lw %a7 %a11 4 #1778
	sw %a1 %sp 0 #1780
	sw %a6 %sp 4 #1780
	sw %a4 %sp 8 #1780
	sw %a5 %sp 12 #1780
	sw %a3 %sp 16 #1780
	sw %a2 %sp 20 #1780
	sw %a7 %sp 24 #1780
	sw %a0 %sp 28 #1780
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45667 # nontail if
	jal %zero beq_cont.45668 # then sentence ends
beq_else.45667:
	lw %a8 %a7 0 #81
	lw %f0 %a2 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a3 8 #154
	lw %a9 %a5 0 #15
	addi %a9 %a9 -1 #1147
	sw %a8 %sp 32 #1147
	add %a1 %a9 %zero
	add %a0 %a2 %zero
	add %a11 %a4 %zero
	sw %ra %sp 36 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 40 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -40 #1147
	lw %ra %sp 36 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 32 #1774
	lw %a1 %sp 0 #1774
	lw %a2 %sp 20 #1774
	lw %a11 %sp 4 #1774
	sw %ra %sp 36 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 40 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -40 #1774
	lw %ra %sp 36 #1774
beq_cont.45668:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.45669 # nontail if
	jal %zero beq_cont.45670 # then sentence ends
beq_else.45669:
	lw %a1 %sp 24 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 20 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 16 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 12 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 8 #1147
	sw %a2 %sp 36 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 48 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -48 #1147
	lw %ra %sp 44 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 36 #1774
	lw %a1 %sp 0 #1774
	lw %a2 %sp 20 #1774
	lw %a11 %sp 4 #1774
	sw %ra %sp 44 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 48 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -48 #1774
	lw %ra %sp 44 #1774
beq_cont.45670:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.45671 # nontail if
	jal %zero beq_cont.45672 # then sentence ends
beq_else.45671:
	lw %a1 %sp 24 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 20 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 16 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 12 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 8 #1147
	sw %a2 %sp 40 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 44 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 48 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -48 #1147
	lw %ra %sp 44 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 40 #1774
	lw %a1 %sp 0 #1774
	lw %a2 %sp 20 #1774
	lw %a11 %sp 4 #1774
	sw %ra %sp 44 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 48 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -48 #1774
	lw %ra %sp 44 #1774
beq_cont.45672:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.45673 # nontail if
	jal %zero beq_cont.45674 # then sentence ends
beq_else.45673:
	lw %a1 %sp 24 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 20 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 16 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 12 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 8 #1147
	sw %a2 %sp 44 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 56 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -56 #1147
	lw %ra %sp 52 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 44 #1774
	lw %a1 %sp 0 #1774
	lw %a2 %sp 20 #1774
	lw %a11 %sp 4 #1774
	sw %ra %sp 52 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 56 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -56 #1774
	lw %ra %sp 52 #1774
beq_cont.45674:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.45675
	jalr %zero %ra 0 #1798
beq_else.45675:
	lw %a0 %sp 24 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 20 #152
	lw %f0 %a1 0 #152
	lw %a2 %sp 16 #152
	sw %f0 %a2 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a2 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a2 8 #154
	lw %a2 %sp 12 #15
	lw %a2 %a2 0 #15
	addi %a2 %a2 -1 #1147
	lw %a11 %sp 8 #1147
	sw %a0 %sp 48 #1147
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 52 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 56 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -56 #1147
	lw %ra %sp 52 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 48 #1774
	lw %a1 %sp 0 #1774
	lw %a2 %sp 20 #1774
	lw %a11 %sp 4 #1774
	lw %a10 %a11 0 #1774
	jalr %zero %a10 0 #1774
calc_diffuse_using_1point.2821:
	lw %a2 %a11 32 #1803
	lw %a3 %a11 28 #1803
	lw %a4 %a11 24 #1803
	lw %a5 %a11 20 #1803
	lw %a6 %a11 16 #1803
	lw %a7 %a11 12 #1803
	lw %a8 %a11 8 #1803
	lw %a9 %a11 4 #1803
	lw %a10 %a0 20 #475
	lw %a11 %a0 28 #498
	sw %a5 %sp 0 #446
	lw %a5 %a0 4 #446
	sw %a7 %sp 4 #468
	lw %a7 %a0 16 #468
	sw %a7 %sp 8 #1810
	slli %a7 %a1 2 #1810
	add %a12 %a10 %a7 #1810
	lw %a7 %a12 0 #1810
	lw %f0 %a7 0 #152
	sw %f0 %a9 0 #152
	lw %f0 %a7 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a7 8 #152
	sw %f0 %a9 8 #154
	lw %a0 %a0 24 #484
	lw %a0 %a0 0 #486
	slli %a7 %a1 2 #1676
	add %a12 %a11 %a7 #1676
	lw %a7 %a12 0 #1676
	slli %a10 %a1 2 #1664
	add %a12 %a5 %a10 #1664
	lw %a5 %a12 0 #1664
	sw %a9 %sp 12 #1780
	sw %a1 %sp 16 #1780
	sw %a2 %sp 20 #1780
	sw %a7 %sp 24 #1780
	sw %a4 %sp 28 #1780
	sw %a6 %sp 32 #1780
	sw %a3 %sp 36 #1780
	sw %a5 %sp 40 #1780
	sw %a8 %sp 44 #1780
	sw %a0 %sp 48 #1780
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.45677 # nontail if
	jal %zero beq_cont.45678 # then sentence ends
beq_else.45677:
	lw %a10 %a8 0 #81
	lw %f0 %a5 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a5 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a5 8 #152
	sw %f0 %a3 8 #154
	lw %a11 %a6 0 #15
	addi %a11 %a11 -1 #1147
	sw %a10 %sp 52 #1147
	add %a1 %a11 %zero
	add %a0 %a5 %zero
	add %a11 %a4 %zero
	sw %ra %sp 60 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 64 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -64 #1147
	lw %ra %sp 60 #1147
	lw %a0 %sp 52 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 24 #181
	lw %f1 %a2 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a2 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a2 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45679 # nontail if
	lw %a1 %a0 472 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 60 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 64 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -64 #1763
	lw %ra %sp 60 #1763
	jal %zero beq_cont.45680 # then sentence ends
beq_else.45679:
	lw %a1 %a0 476 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 60 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 64 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -64 #1761
	lw %ra %sp 60 #1761
beq_cont.45680:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 52 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 60 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 64 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -64 #1765
	lw %ra %sp 60 #1765
beq_cont.45678:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.45681 # nontail if
	jal %zero beq_cont.45682 # then sentence ends
beq_else.45681:
	lw %a1 %sp 44 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 40 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 36 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 32 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 28 #1147
	sw %a2 %sp 56 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 60 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 64 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -64 #1147
	lw %ra %sp 60 #1147
	lw %a0 %sp 56 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 24 #181
	lw %f1 %a2 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a2 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a2 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45683 # nontail if
	lw %a1 %a0 472 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 60 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 64 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -64 #1763
	lw %ra %sp 60 #1763
	jal %zero beq_cont.45684 # then sentence ends
beq_else.45683:
	lw %a1 %a0 476 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 60 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 64 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -64 #1761
	lw %ra %sp 60 #1761
beq_cont.45684:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 56 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 60 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 64 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -64 #1765
	lw %ra %sp 60 #1765
beq_cont.45682:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.45685 # nontail if
	jal %zero beq_cont.45686 # then sentence ends
beq_else.45685:
	lw %a1 %sp 44 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 40 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 36 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 32 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 28 #1147
	sw %a2 %sp 60 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 68 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 72 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -72 #1147
	lw %ra %sp 68 #1147
	lw %a0 %sp 60 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 24 #181
	lw %f1 %a2 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a2 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a2 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45687 # nontail if
	lw %a1 %a0 472 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 68 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 72 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -72 #1763
	lw %ra %sp 68 #1763
	jal %zero beq_cont.45688 # then sentence ends
beq_else.45687:
	lw %a1 %a0 476 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 68 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 72 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -72 #1761
	lw %ra %sp 68 #1761
beq_cont.45688:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 60 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 68 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 72 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -72 #1765
	lw %ra %sp 68 #1765
beq_cont.45686:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.45689 # nontail if
	jal %zero beq_cont.45690 # then sentence ends
beq_else.45689:
	lw %a1 %sp 44 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 40 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 36 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 32 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 28 #1147
	sw %a2 %sp 64 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 68 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 72 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -72 #1147
	lw %ra %sp 68 #1147
	lw %a0 %sp 64 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 24 #181
	lw %f1 %a2 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a2 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a2 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45691 # nontail if
	lw %a1 %a0 472 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 68 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 72 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -72 #1763
	lw %ra %sp 68 #1763
	jal %zero beq_cont.45692 # then sentence ends
beq_else.45691:
	lw %a1 %a0 476 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 68 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 72 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -72 #1761
	lw %ra %sp 68 #1761
beq_cont.45692:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 64 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 68 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 72 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -72 #1765
	lw %ra %sp 68 #1765
beq_cont.45690:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.45693 # nontail if
	jal %zero beq_cont.45694 # then sentence ends
beq_else.45693:
	lw %a0 %sp 44 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 40 #152
	lw %f0 %a1 0 #152
	lw %a2 %sp 36 #152
	sw %f0 %a2 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a2 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a2 8 #154
	lw %a2 %sp 32 #15
	lw %a2 %a2 0 #15
	addi %a2 %a2 -1 #1147
	lw %a11 %sp 28 #1147
	sw %a0 %sp 68 #1147
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 76 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 80 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -80 #1147
	lw %ra %sp 76 #1147
	lw %a0 %sp 68 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 24 #181
	lw %f1 %a2 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a2 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a2 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45695 # nontail if
	lw %a1 %a0 472 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 76 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 80 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -80 #1763
	lw %ra %sp 76 #1763
	jal %zero beq_cont.45696 # then sentence ends
beq_else.45695:
	lw %a1 %a0 476 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 76 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 80 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -80 #1761
	lw %ra %sp 76 #1761
beq_cont.45696:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 68 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 76 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 80 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -80 #1765
	lw %ra %sp 76 #1765
beq_cont.45694:
	lw %a0 %sp 16 #1673
	slli %a0 %a0 2 #1673
	lw %a1 %sp 8 #1673
	add %a12 %a1 %a0 #1673
	lw %a0 %a12 0 #1673
	lw %a1 %sp 0 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 12 #219
	lw %f2 %a2 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a1 0 #219
	lw %f0 %a1 4 #219
	lw %f1 %a0 4 #219
	lw %f2 %a2 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a1 4 #220
	lw %f0 %a1 8 #219
	lw %f1 %a0 8 #219
	lw %f2 %a2 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a1 8 #221
	jalr %zero %ra 0 #221
calc_diffuse_using_5points.2824:
	lw %a5 %a11 8 #1821
	lw %a6 %a11 4 #1821
	slli %a7 %a0 2 #1823
	add %a12 %a1 %a7 #1823
	lw %a1 %a12 0 #1823
	lw %a1 %a1 20 #475
	addi %a7 %a0 -1 #1824
	slli %a7 %a7 2 #1824
	add %a12 %a2 %a7 #1824
	lw %a7 %a12 0 #1824
	lw %a7 %a7 20 #475
	slli %a8 %a0 2 #1824
	add %a12 %a2 %a8 #1824
	lw %a8 %a12 0 #1824
	lw %a8 %a8 20 #475
	addi %a9 %a0 1 #1826
	slli %a9 %a9 2 #1824
	add %a12 %a2 %a9 #1824
	lw %a9 %a12 0 #1824
	lw %a9 %a9 20 #475
	slli %a10 %a0 2 #1827
	add %a12 %a3 %a10 #1827
	lw %a3 %a12 0 #1827
	lw %a3 %a3 20 #475
	slli %a10 %a4 2 #1810
	add %a12 %a1 %a10 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a1 0 #152
	sw %f0 %a6 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a6 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a6 8 #154
	slli %a1 %a4 2 #1810
	add %a12 %a7 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a6 0 #198
	lw %f1 %a1 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a6 0 #198
	lw %f0 %a6 4 #198
	lw %f1 %a1 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a6 4 #199
	lw %f0 %a6 8 #198
	lw %f1 %a1 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a6 8 #200
	slli %a1 %a4 2 #1810
	add %a12 %a8 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a6 0 #198
	lw %f1 %a1 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a6 0 #198
	lw %f0 %a6 4 #198
	lw %f1 %a1 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a6 4 #199
	lw %f0 %a6 8 #198
	lw %f1 %a1 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a6 8 #200
	slli %a1 %a4 2 #1810
	add %a12 %a9 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a6 0 #198
	lw %f1 %a1 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a6 0 #198
	lw %f0 %a6 4 #198
	lw %f1 %a1 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a6 4 #199
	lw %f0 %a6 8 #198
	lw %f1 %a1 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a6 8 #200
	slli %a1 %a4 2 #1810
	add %a12 %a3 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a6 0 #198
	lw %f1 %a1 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a6 0 #198
	lw %f0 %a6 4 #198
	lw %f1 %a1 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a6 4 #199
	lw %f0 %a6 8 #198
	lw %f1 %a1 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a6 8 #200
	slli %a0 %a0 2 #1824
	add %a12 %a2 %a0 #1824
	lw %a0 %a12 0 #1824
	lw %a0 %a0 16 #468
	slli %a1 %a4 2 #1673
	add %a12 %a0 %a1 #1673
	lw %a0 %a12 0 #1673
	lw %f0 %a5 0 #219
	lw %f1 %a0 0 #219
	lw %f2 %a6 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a5 0 #219
	lw %f0 %a5 4 #219
	lw %f1 %a0 4 #219
	lw %f2 %a6 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a5 4 #220
	lw %f0 %a5 8 #219
	lw %f1 %a0 8 #219
	lw %f2 %a6 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a5 8 #221
	jalr %zero %ra 0 #221
do_without_neighbors.2830:
	lw %a2 %a11 36 #1841
	lw %a3 %a11 32 #1841
	lw %a4 %a11 28 #1841
	lw %a5 %a11 24 #1841
	lw %a6 %a11 20 #1841
	lw %a7 %a11 16 #1841
	lw %a8 %a11 12 #1841
	lw %a9 %a11 8 #1841
	lw %a10 %a11 4 #1841
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.45699
	sw %a11 %sp 0 #454
	lw %a11 %a0 8 #454
	sw %a2 %sp 4 #1662
	slli %a2 %a1 2 #1662
	add %a12 %a11 %a2 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45700
	lw %a2 %a0 12 #461
	slli %a11 %a1 2 #1669
	add %a12 %a2 %a11 #1669
	lw %a2 %a12 0 #1669
	sw %a5 %sp 8 #1669
	sw %a9 %sp 12 #1669
	sw %a10 %sp 16 #1669
	sw %a0 %sp 20 #1669
	sw %a1 %sp 24 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45701 # nontail if
	jal %zero beq_cont.45702 # then sentence ends
beq_else.45701:
	lw %a2 %a0 20 #475
	lw %a11 %a0 28 #498
	lw %a10 %a0 4 #446
	lw %a5 %a0 16 #468
	sw %a5 %sp 28 #1810
	slli %a5 %a1 2 #1810
	add %a12 %a2 %a5 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	sw %f0 %a9 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a9 8 #154
	lw %a2 %a0 24 #484
	lw %a2 %a2 0 #486
	slli %a5 %a1 2 #1676
	add %a12 %a11 %a5 #1676
	lw %a5 %a12 0 #1676
	slli %a11 %a1 2 #1664
	add %a12 %a10 %a11 #1664
	lw %a10 %a12 0 #1664
	sw %a5 %sp 32 #1780
	sw %a7 %sp 36 #1780
	sw %a4 %sp 40 #1780
	sw %a6 %sp 44 #1780
	sw %a3 %sp 48 #1780
	sw %a10 %sp 52 #1780
	sw %a8 %sp 56 #1780
	sw %a2 %sp 60 #1780
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45703 # nontail if
	jal %zero beq_cont.45704 # then sentence ends
beq_else.45703:
	lw %a11 %a8 0 #81
	lw %f0 %a10 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a10 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a10 8 #152
	sw %f0 %a3 8 #154
	lw %a0 %a6 0 #15
	addi %a0 %a0 -1 #1147
	sw %a11 %sp 64 #1147
	add %a1 %a0 %zero
	add %a11 %a4 %zero
	add %a0 %a10 %zero
	sw %ra %sp 68 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 72 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -72 #1147
	lw %ra %sp 68 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 64 #1774
	lw %a1 %sp 32 #1774
	lw %a2 %sp 52 #1774
	lw %a11 %sp 36 #1774
	sw %ra %sp 68 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 72 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -72 #1774
	lw %ra %sp 68 #1774
beq_cont.45704:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.45705 # nontail if
	jal %zero beq_cont.45706 # then sentence ends
beq_else.45705:
	lw %a1 %sp 56 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 52 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 48 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 44 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 40 #1147
	sw %a2 %sp 68 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 76 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 80 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -80 #1147
	lw %ra %sp 76 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 68 #1774
	lw %a1 %sp 32 #1774
	lw %a2 %sp 52 #1774
	lw %a11 %sp 36 #1774
	sw %ra %sp 76 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 80 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -80 #1774
	lw %ra %sp 76 #1774
beq_cont.45706:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.45707 # nontail if
	jal %zero beq_cont.45708 # then sentence ends
beq_else.45707:
	lw %a1 %sp 56 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 52 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 48 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 44 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 40 #1147
	sw %a2 %sp 72 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 76 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 80 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -80 #1147
	lw %ra %sp 76 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 72 #1774
	lw %a1 %sp 32 #1774
	lw %a2 %sp 52 #1774
	lw %a11 %sp 36 #1774
	sw %ra %sp 76 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 80 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -80 #1774
	lw %ra %sp 76 #1774
beq_cont.45708:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.45709 # nontail if
	jal %zero beq_cont.45710 # then sentence ends
beq_else.45709:
	lw %a1 %sp 56 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 52 #152
	lw %f0 %a3 0 #152
	lw %a4 %sp 48 #152
	sw %f0 %a4 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a4 8 #154
	lw %a5 %sp 44 #15
	lw %a6 %a5 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 40 #1147
	sw %a2 %sp 76 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 88 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -88 #1147
	lw %ra %sp 84 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 76 #1774
	lw %a1 %sp 32 #1774
	lw %a2 %sp 52 #1774
	lw %a11 %sp 36 #1774
	sw %ra %sp 84 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 88 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -88 #1774
	lw %ra %sp 84 #1774
beq_cont.45710:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.45711 # nontail if
	jal %zero beq_cont.45712 # then sentence ends
beq_else.45711:
	lw %a0 %sp 56 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 52 #152
	lw %f0 %a1 0 #152
	lw %a2 %sp 48 #152
	sw %f0 %a2 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a2 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a2 8 #154
	lw %a2 %sp 44 #15
	lw %a2 %a2 0 #15
	addi %a2 %a2 -1 #1147
	lw %a11 %sp 40 #1147
	sw %a0 %sp 80 #1147
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 84 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 88 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -88 #1147
	lw %ra %sp 84 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 80 #1774
	lw %a1 %sp 32 #1774
	lw %a2 %sp 52 #1774
	lw %a11 %sp 36 #1774
	sw %ra %sp 84 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 88 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -88 #1774
	lw %ra %sp 84 #1774
beq_cont.45712:
	lw %a0 %sp 24 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 28 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 8 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 12 #219
	lw %f2 %a3 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a2 0 #219
	lw %f0 %a2 4 #219
	lw %f1 %a1 4 #219
	lw %f2 %a3 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a2 4 #220
	lw %f0 %a2 8 #219
	lw %f1 %a1 8 #219
	lw %f2 %a3 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a2 8 #221
beq_cont.45702:
	lw %a0 %sp 24 #1850
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.45713
	lw %a0 %sp 20 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45714
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 84 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45715 # nontail if
	jal %zero beq_cont.45716 # then sentence ends
beq_else.45715:
	lw %a11 %sp 16 #1848
	sw %ra %sp 92 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 96 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -96 #1848
	lw %ra %sp 92 #1848
beq_cont.45716:
	lw %a0 %sp 84 #1850
	addi %a0 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.45717
	lw %a1 %sp 20 #454
	lw %a2 %a1 8 #454
	slli %a3 %a0 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45718
	lw %a2 %a1 12 #461
	slli %a3 %a0 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45719 # nontail if
	jal %zero beq_cont.45720 # then sentence ends
beq_else.45719:
	lw %a2 %a1 20 #475
	lw %a3 %a1 28 #498
	lw %a4 %a1 4 #446
	lw %a5 %a1 16 #468
	slli %a6 %a0 2 #1810
	add %a12 %a2 %a6 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	lw %a6 %sp 12 #152
	sw %f0 %a6 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a6 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a6 8 #154
	lw %a2 %a1 24 #484
	lw %a2 %a2 0 #486
	slli %a7 %a0 2 #1676
	add %a12 %a3 %a7 #1676
	lw %a3 %a12 0 #1676
	slli %a7 %a0 2 #1664
	add %a12 %a4 %a7 #1664
	lw %a4 %a12 0 #1664
	lw %a11 %sp 4 #1811
	sw %a5 %sp 88 #1811
	sw %a0 %sp 92 #1811
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 100 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 104 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -104 #1811
	lw %ra %sp 100 #1811
	lw %a0 %sp 92 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 88 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 8 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 12 #219
	lw %f2 %a3 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a2 0 #219
	lw %f0 %a2 4 #219
	lw %f1 %a1 4 #219
	lw %f2 %a3 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a2 4 #220
	lw %f0 %a2 8 #219
	lw %f1 %a1 8 #219
	lw %f2 %a3 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a2 8 #221
beq_cont.45720:
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.45721
	lw %a0 %sp 20 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45722
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 96 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45723 # nontail if
	jal %zero beq_cont.45724 # then sentence ends
beq_else.45723:
	lw %a11 %sp 16 #1848
	sw %ra %sp 100 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 104 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -104 #1848
	lw %ra %sp 100 #1848
beq_cont.45724:
	lw %a0 %sp 96 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 20 #1850
	lw %a11 %sp 0 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.45722:
	jalr %zero %ra 0 #1851
bge_else.45721:
	jalr %zero %ra 0 #1852
bge_else.45718:
	jalr %zero %ra 0 #1851
bge_else.45717:
	jalr %zero %ra 0 #1852
bge_else.45714:
	jalr %zero %ra 0 #1851
bge_else.45713:
	jalr %zero %ra 0 #1852
bge_else.45700:
	jalr %zero %ra 0 #1851
bge_else.45699:
	jalr %zero %ra 0 #1852
try_exploit_neighbors.2846:
	lw %a6 %a11 24 #1890
	lw %a7 %a11 20 #1890
	lw %a8 %a11 16 #1890
	lw %a9 %a11 12 #1890
	lw %a10 %a11 8 #1890
	sw %a1 %sp 0 #1890
	lw %a1 %a11 4 #1890
	sw %a11 %sp 4 #1891
	slli %a11 %a0 2 #1891
	add %a12 %a3 %a11 #1891
	lw %a11 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a5 bge_else.45733
	sw %a10 %sp 8 #454
	lw %a10 %a11 8 #454
	sw %a11 %sp 12 #1662
	slli %a11 %a5 2 #1662
	add %a12 %a10 %a11 #1662
	lw %a10 %a12 0 #1662
	addi %a12 %zero 0
	blt %a10 %a12 bge_else.45734
	slli %a10 %a0 2 #1875
	add %a12 %a3 %a10 #1875
	lw %a10 %a12 0 #1875
	lw %a10 %a10 8 #454
	slli %a11 %a5 2 #1662
	add %a12 %a10 %a11 #1662
	lw %a10 %a12 0 #1662
	slli %a11 %a0 2 #1877
	add %a12 %a2 %a11 #1877
	lw %a11 %a12 0 #1877
	lw %a11 %a11 8 #454
	sw %a2 %sp 16 #1662
	slli %a2 %a5 2 #1662
	add %a12 %a11 %a2 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a10 beq_else.45735 # nontail if
	slli %a2 %a0 2 #1878
	add %a12 %a4 %a2 #1878
	lw %a2 %a12 0 #1878
	lw %a2 %a2 8 #454
	slli %a11 %a5 2 #1662
	add %a12 %a2 %a11 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a10 beq_else.45737 # nontail if
	addi %a2 %a0 -1 #1879
	slli %a2 %a2 2 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a2 %a2 8 #454
	slli %a11 %a5 2 #1662
	add %a12 %a2 %a11 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a10 beq_else.45739 # nontail if
	addi %a2 %a0 1 #1880
	slli %a2 %a2 2 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a2 %a2 8 #454
	slli %a11 %a5 2 #1662
	add %a12 %a2 %a11 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a10 beq_else.45741 # nontail if
	addi %a2 %zero 1 #1881
	jal %zero beq_cont.45742 # then sentence ends
beq_else.45741:
	addi %a2 %zero 0 #1882
beq_cont.45742:
	jal %zero beq_cont.45740 # then sentence ends
beq_else.45739:
	addi %a2 %zero 0 #1883
beq_cont.45740:
	jal %zero beq_cont.45738 # then sentence ends
beq_else.45737:
	addi %a2 %zero 0 #1884
beq_cont.45738:
	jal %zero beq_cont.45736 # then sentence ends
beq_else.45735:
	addi %a2 %zero 0 #1885
beq_cont.45736:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45743
	slli %a0 %a0 2 #1891
	add %a12 %a3 %a0 #1891
	lw %a0 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a5 bge_else.45744
	lw %a2 %a0 8 #454
	slli %a3 %a5 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45745
	lw %a2 %a0 12 #461
	slli %a3 %a5 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a8 %sp 20 #1669
	sw %a1 %sp 24 #1669
	sw %a7 %sp 28 #1669
	sw %a6 %sp 32 #1669
	sw %a9 %sp 36 #1669
	sw %a0 %sp 40 #1669
	sw %a5 %sp 44 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45746 # nontail if
	jal %zero beq_cont.45747 # then sentence ends
beq_else.45746:
	add %a11 %a1 %zero
	add %a1 %a5 %zero
	sw %ra %sp 52 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 56 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -56 #1848
	lw %ra %sp 52 #1848
beq_cont.45747:
	lw %a0 %sp 44 #1850
	addi %a0 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.45748
	lw %a1 %sp 40 #454
	lw %a2 %a1 8 #454
	slli %a3 %a0 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45749
	lw %a2 %a1 12 #461
	slli %a3 %a0 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45750 # nontail if
	jal %zero beq_cont.45751 # then sentence ends
beq_else.45750:
	lw %a2 %a1 20 #475
	lw %a3 %a1 28 #498
	lw %a4 %a1 4 #446
	lw %a5 %a1 16 #468
	slli %a6 %a0 2 #1810
	add %a12 %a2 %a6 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	lw %a6 %sp 36 #152
	sw %f0 %a6 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a6 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a6 8 #154
	lw %a2 %a1 24 #484
	lw %a2 %a2 0 #486
	slli %a7 %a0 2 #1676
	add %a12 %a3 %a7 #1676
	lw %a3 %a12 0 #1676
	slli %a7 %a0 2 #1664
	add %a12 %a4 %a7 #1664
	lw %a4 %a12 0 #1664
	lw %a11 %sp 32 #1811
	sw %a5 %sp 48 #1811
	sw %a0 %sp 52 #1811
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 60 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 64 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -64 #1811
	lw %ra %sp 60 #1811
	lw %a0 %sp 52 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 48 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 28 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 36 #219
	lw %f2 %a3 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a2 0 #219
	lw %f0 %a2 4 #219
	lw %f1 %a1 4 #219
	lw %f2 %a3 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a2 4 #220
	lw %f0 %a2 8 #219
	lw %f1 %a1 8 #219
	lw %f2 %a3 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a2 8 #221
beq_cont.45751:
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.45752
	lw %a0 %sp 40 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45753
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 56 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45754 # nontail if
	jal %zero beq_cont.45755 # then sentence ends
beq_else.45754:
	lw %a11 %sp 24 #1848
	sw %ra %sp 60 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 64 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -64 #1848
	lw %ra %sp 60 #1848
beq_cont.45755:
	lw %a0 %sp 56 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 40 #1850
	lw %a11 %sp 20 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.45753:
	jalr %zero %ra 0 #1851
bge_else.45752:
	jalr %zero %ra 0 #1852
bge_else.45749:
	jalr %zero %ra 0 #1851
bge_else.45748:
	jalr %zero %ra 0 #1852
bge_else.45745:
	jalr %zero %ra 0 #1851
bge_else.45744:
	jalr %zero %ra 0 #1852
beq_else.45743:
	lw %a2 %sp 12 #461
	lw %a2 %a2 12 #461
	slli %a10 %a5 2 #1669
	add %a12 %a2 %a10 #1669
	lw %a2 %a12 0 #1669
	sw %a8 %sp 20 #1669
	sw %a1 %sp 24 #1669
	sw %a6 %sp 32 #1669
	sw %a4 %sp 60 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45762 # nontail if
	jal %zero beq_cont.45763 # then sentence ends
beq_else.45762:
	slli %a2 %a0 2 #1823
	lw %a10 %sp 16 #1823
	add %a12 %a10 %a2 #1823
	lw %a2 %a12 0 #1823
	lw %a2 %a2 20 #475
	addi %a11 %a0 -1 #1824
	slli %a11 %a11 2 #1824
	add %a12 %a3 %a11 #1824
	lw %a11 %a12 0 #1824
	lw %a11 %a11 20 #475
	slli %a8 %a0 2 #1824
	add %a12 %a3 %a8 #1824
	lw %a8 %a12 0 #1824
	lw %a8 %a8 20 #475
	addi %a1 %a0 1 #1826
	slli %a1 %a1 2 #1824
	add %a12 %a3 %a1 #1824
	lw %a1 %a12 0 #1824
	lw %a1 %a1 20 #475
	slli %a6 %a0 2 #1827
	add %a12 %a4 %a6 #1827
	lw %a6 %a12 0 #1827
	lw %a6 %a6 20 #475
	slli %a4 %a5 2 #1810
	add %a12 %a2 %a4 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	sw %f0 %a9 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a9 8 #154
	slli %a2 %a5 2 #1810
	add %a12 %a11 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a9 0 #198
	lw %f1 %a2 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a9 0 #198
	lw %f0 %a9 4 #198
	lw %f1 %a2 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a9 4 #199
	lw %f0 %a9 8 #198
	lw %f1 %a2 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a9 8 #200
	slli %a2 %a5 2 #1810
	add %a12 %a8 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a9 0 #198
	lw %f1 %a2 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a9 0 #198
	lw %f0 %a9 4 #198
	lw %f1 %a2 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a9 4 #199
	lw %f0 %a9 8 #198
	lw %f1 %a2 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a9 8 #200
	slli %a2 %a5 2 #1810
	add %a12 %a1 %a2 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a9 0 #198
	lw %f1 %a1 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a9 0 #198
	lw %f0 %a9 4 #198
	lw %f1 %a1 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a9 4 #199
	lw %f0 %a9 8 #198
	lw %f1 %a1 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a9 8 #200
	slli %a1 %a5 2 #1810
	add %a12 %a6 %a1 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a9 0 #198
	lw %f1 %a1 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a9 0 #198
	lw %f0 %a9 4 #198
	lw %f1 %a1 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a9 4 #199
	lw %f0 %a9 8 #198
	lw %f1 %a1 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a9 8 #200
	slli %a1 %a0 2 #1824
	add %a12 %a3 %a1 #1824
	lw %a1 %a12 0 #1824
	lw %a1 %a1 16 #468
	slli %a2 %a5 2 #1673
	add %a12 %a1 %a2 #1673
	lw %a1 %a12 0 #1673
	lw %f0 %a7 0 #219
	lw %f1 %a1 0 #219
	lw %f2 %a9 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a7 0 #219
	lw %f0 %a7 4 #219
	lw %f1 %a1 4 #219
	lw %f2 %a9 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a7 4 #220
	lw %f0 %a7 8 #219
	lw %f1 %a1 8 #219
	lw %f2 %a9 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a7 8 #221
beq_cont.45763:
	addi %a4 %a5 1 #1906
	slli %a1 %a0 2 #1891
	add %a12 %a3 %a1 #1891
	lw %a1 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a4 bge_else.45764
	lw %a2 %a1 8 #454
	slli %a5 %a4 2 #1662
	add %a12 %a2 %a5 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45765
	slli %a2 %a0 2 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a2 %a2 8 #454
	slli %a5 %a4 2 #1662
	add %a12 %a2 %a5 #1662
	lw %a2 %a12 0 #1662
	slli %a5 %a0 2 #1877
	lw %a6 %sp 16 #1877
	add %a12 %a6 %a5 #1877
	lw %a5 %a12 0 #1877
	lw %a5 %a5 8 #454
	slli %a8 %a4 2 #1662
	add %a12 %a5 %a8 #1662
	lw %a5 %a12 0 #1662
	bne %a5 %a2 beq_else.45766 # nontail if
	slli %a5 %a0 2 #1878
	lw %a8 %sp 60 #1878
	add %a12 %a8 %a5 #1878
	lw %a5 %a12 0 #1878
	lw %a5 %a5 8 #454
	slli %a10 %a4 2 #1662
	add %a12 %a5 %a10 #1662
	lw %a5 %a12 0 #1662
	bne %a5 %a2 beq_else.45768 # nontail if
	addi %a5 %a0 -1 #1879
	slli %a5 %a5 2 #1875
	add %a12 %a3 %a5 #1875
	lw %a5 %a12 0 #1875
	lw %a5 %a5 8 #454
	slli %a10 %a4 2 #1662
	add %a12 %a5 %a10 #1662
	lw %a5 %a12 0 #1662
	bne %a5 %a2 beq_else.45770 # nontail if
	addi %a5 %a0 1 #1880
	slli %a5 %a5 2 #1875
	add %a12 %a3 %a5 #1875
	lw %a5 %a12 0 #1875
	lw %a5 %a5 8 #454
	slli %a10 %a4 2 #1662
	add %a12 %a5 %a10 #1662
	lw %a5 %a12 0 #1662
	bne %a5 %a2 beq_else.45772 # nontail if
	addi %a2 %zero 1 #1881
	jal %zero beq_cont.45773 # then sentence ends
beq_else.45772:
	addi %a2 %zero 0 #1882
beq_cont.45773:
	jal %zero beq_cont.45771 # then sentence ends
beq_else.45770:
	addi %a2 %zero 0 #1883
beq_cont.45771:
	jal %zero beq_cont.45769 # then sentence ends
beq_else.45768:
	addi %a2 %zero 0 #1884
beq_cont.45769:
	jal %zero beq_cont.45767 # then sentence ends
beq_else.45766:
	addi %a2 %zero 0 #1885
beq_cont.45767:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45774
	slli %a0 %a0 2 #1891
	add %a12 %a3 %a0 #1891
	lw %a0 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a4 bge_else.45775
	lw %a1 %a0 8 #454
	slli %a2 %a4 2 #1662
	add %a12 %a1 %a2 #1662
	lw %a1 %a12 0 #1662
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45776
	lw %a1 %a0 12 #461
	slli %a2 %a4 2 #1669
	add %a12 %a1 %a2 #1669
	lw %a1 %a12 0 #1669
	sw %a0 %sp 64 #1669
	sw %a4 %sp 68 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45777 # nontail if
	jal %zero beq_cont.45778 # then sentence ends
beq_else.45777:
	lw %a1 %a0 20 #475
	lw %a2 %a0 28 #498
	lw %a3 %a0 4 #446
	lw %a5 %a0 16 #468
	slli %a6 %a4 2 #1810
	add %a12 %a1 %a6 #1810
	lw %a1 %a12 0 #1810
	lw %f0 %a1 0 #152
	sw %f0 %a9 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a9 8 #154
	lw %a1 %a0 24 #484
	lw %a1 %a1 0 #486
	slli %a6 %a4 2 #1676
	add %a12 %a2 %a6 #1676
	lw %a2 %a12 0 #1676
	slli %a6 %a4 2 #1664
	add %a12 %a3 %a6 #1664
	lw %a3 %a12 0 #1664
	lw %a11 %sp 32 #1811
	sw %a9 %sp 36 #1811
	sw %a7 %sp 28 #1811
	sw %a5 %sp 72 #1811
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 76 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 80 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -80 #1811
	lw %ra %sp 76 #1811
	lw %a0 %sp 68 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 72 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 28 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 36 #219
	lw %f2 %a3 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a2 0 #219
	lw %f0 %a2 4 #219
	lw %f1 %a1 4 #219
	lw %f2 %a3 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a2 4 #220
	lw %f0 %a2 8 #219
	lw %f1 %a1 8 #219
	lw %f2 %a3 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a2 8 #221
beq_cont.45778:
	lw %a0 %sp 68 #1850
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.45779
	lw %a0 %sp 64 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45780
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 76 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45781 # nontail if
	jal %zero beq_cont.45782 # then sentence ends
beq_else.45781:
	lw %a11 %sp 24 #1848
	sw %ra %sp 84 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 88 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -88 #1848
	lw %ra %sp 84 #1848
beq_cont.45782:
	lw %a0 %sp 76 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 64 #1850
	lw %a11 %sp 20 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.45780:
	jalr %zero %ra 0 #1851
bge_else.45779:
	jalr %zero %ra 0 #1852
bge_else.45776:
	jalr %zero %ra 0 #1851
bge_else.45775:
	jalr %zero %ra 0 #1852
beq_else.45774:
	lw %a1 %a1 12 #461
	slli %a2 %a4 2 #1669
	add %a12 %a1 %a2 #1669
	lw %a1 %a12 0 #1669
	sw %a3 %sp 80 #1669
	sw %a0 %sp 84 #1669
	sw %a4 %sp 68 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45787 # nontail if
	jal %zero beq_cont.45788 # then sentence ends
beq_else.45787:
	lw %a1 %sp 60 #1902
	lw %a11 %sp 8 #1902
	add %a2 %a3 %zero
	add %a3 %a1 %zero
	add %a1 %a6 %zero
	sw %ra %sp 92 #1902 call cls
	lw %a10 %a11 0 #1902
	addi %sp %sp 96 #1902	
	jalr %ra %a10 0 #1902
	addi %sp %sp -96 #1902
	lw %ra %sp 92 #1902
beq_cont.45788:
	lw %a0 %sp 68 #1906
	addi %a5 %a0 1 #1906
	lw %a0 %sp 84 #1906
	lw %a1 %sp 0 #1906
	lw %a2 %sp 16 #1906
	lw %a3 %sp 80 #1906
	lw %a4 %sp 60 #1906
	lw %a11 %sp 4 #1906
	lw %a10 %a11 0 #1906
	jalr %zero %a10 0 #1906
bge_else.45765:
	jalr %zero %ra 0 #1910
bge_else.45764:
	jalr %zero %ra 0 #1911
bge_else.45734:
	jalr %zero %ra 0 #1910
bge_else.45733:
	jalr %zero %ra 0 #1911
pretrace_diffuse_rays.2859:
	lw %a2 %a11 28 #1949
	lw %a3 %a11 24 #1949
	lw %a4 %a11 20 #1949
	lw %a5 %a11 16 #1949
	lw %a6 %a11 12 #1949
	lw %a7 %a11 8 #1949
	lw %a8 %a11 4 #1949
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.45793
	lw %a9 %a0 8 #454
	slli %a10 %a1 2 #1662
	add %a12 %a9 %a10 #1662
	lw %a9 %a12 0 #1662
	addi %a12 %zero 0
	blt %a9 %a12 bge_else.45794
	lw %a9 %a0 12 #461
	slli %a10 %a1 2 #1669
	add %a12 %a9 %a10 #1669
	lw %a9 %a12 0 #1669
	sw %a11 %sp 0 #1669
	sw %a6 %sp 4 #1669
	sw %a2 %sp 8 #1669
	sw %a4 %sp 12 #1669
	sw %a5 %sp 16 #1669
	sw %a3 %sp 20 #1669
	sw %a7 %sp 24 #1669
	sw %a8 %sp 28 #1669
	sw %a1 %sp 32 #1669
	addi %a12 %zero 0
	bne %a9 %a12 beq_else.45795 # nontail if
	jal %zero beq_cont.45796 # then sentence ends
beq_else.45795:
	lw %a9 %a0 24 #484
	lw %a9 %a9 0 #486
	li %f0 l.37367 #147
	sw %f0 %a8 0 #140
	sw %f0 %a8 4 #141
	sw %f0 %a8 8 #142
	lw %a10 %a0 28 #498
	lw %a11 %a0 4 #446
	slli %a9 %a9 2 #81
	add %a12 %a7 %a9 #81
	lw %a9 %a12 0 #81
	slli %a2 %a1 2 #1676
	add %a12 %a10 %a2 #1676
	lw %a2 %a12 0 #1676
	slli %a10 %a1 2 #1664
	add %a12 %a11 %a10 #1664
	lw %a10 %a12 0 #1664
	lw %f0 %a10 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a10 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a10 8 #152
	sw %f0 %a3 8 #154
	lw %a11 %a5 0 #15
	addi %a11 %a11 -1 #1147
	sw %a0 %sp 36 #1147
	sw %a10 %sp 40 #1147
	sw %a2 %sp 44 #1147
	sw %a9 %sp 48 #1147
	add %a1 %a11 %zero
	add %a0 %a10 %zero
	add %a11 %a4 %zero
	sw %ra %sp 52 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 56 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -56 #1147
	lw %ra %sp 52 #1147
	addi %a3 %zero 118 #1774
	lw %a0 %sp 48 #1774
	lw %a1 %sp 44 #1774
	lw %a2 %sp 40 #1774
	lw %a11 %sp 4 #1774
	sw %ra %sp 52 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 56 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -56 #1774
	lw %ra %sp 52 #1774
	lw %a0 %sp 36 #475
	lw %a1 %a0 20 #475
	lw %a2 %sp 32 #1810
	slli %a3 %a2 2 #1810
	add %a12 %a1 %a3 #1810
	lw %a1 %a12 0 #1810
	lw %a3 %sp 28 #152
	lw %f0 %a3 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a1 8 #154
beq_cont.45796:
	lw %a1 %sp 32 #1971
	addi %a1 %a1 1 #1971
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.45797
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45798
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 52 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45799 # nontail if
	jal %zero beq_cont.45800 # then sentence ends
beq_else.45799:
	lw %a2 %a0 24 #484
	lw %a2 %a2 0 #486
	li %f0 l.37367 #147
	lw %a3 %sp 28 #140
	sw %f0 %a3 0 #140
	sw %f0 %a3 4 #141
	sw %f0 %a3 8 #142
	lw %a4 %a0 28 #498
	lw %a5 %a0 4 #446
	slli %a2 %a2 2 #81
	lw %a6 %sp 24 #81
	add %a12 %a6 %a2 #81
	lw %a2 %a12 0 #81
	slli %a6 %a1 2 #1676
	add %a12 %a4 %a6 #1676
	lw %a4 %a12 0 #1676
	slli %a6 %a1 2 #1664
	add %a12 %a5 %a6 #1664
	lw %a5 %a12 0 #1664
	lw %f0 %a5 0 #152
	lw %a6 %sp 20 #152
	sw %f0 %a6 0 #152
	lw %f0 %a5 4 #152
	sw %f0 %a6 4 #153
	lw %f0 %a5 8 #152
	sw %f0 %a6 8 #154
	lw %a6 %sp 16 #15
	lw %a6 %a6 0 #15
	addi %a6 %a6 -1 #1147
	lw %a11 %sp 12 #1147
	sw %a0 %sp 36 #1147
	sw %a5 %sp 56 #1147
	sw %a4 %sp 60 #1147
	sw %a2 %sp 64 #1147
	add %a1 %a6 %zero
	add %a0 %a5 %zero
	sw %ra %sp 68 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 72 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -72 #1147
	lw %ra %sp 68 #1147
	lw %a0 %sp 64 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 60 #181
	lw %f1 %a2 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a2 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a2 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45801 # nontail if
	lw %a1 %a0 472 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 8 #1763
	add %a0 %a1 %zero
	sw %ra %sp 68 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 72 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -72 #1763
	lw %ra %sp 68 #1763
	jal %zero beq_cont.45802 # then sentence ends
beq_else.45801:
	lw %a1 %a0 476 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 8 #1761
	add %a0 %a1 %zero
	sw %ra %sp 68 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 72 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -72 #1761
	lw %ra %sp 68 #1761
beq_cont.45802:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 64 #1765
	lw %a1 %sp 60 #1765
	lw %a2 %sp 56 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 68 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 72 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -72 #1765
	lw %ra %sp 68 #1765
	lw %a0 %sp 36 #475
	lw %a1 %a0 20 #475
	lw %a2 %sp 52 #1810
	slli %a3 %a2 2 #1810
	add %a12 %a1 %a3 #1810
	lw %a1 %a12 0 #1810
	lw %a3 %sp 28 #152
	lw %f0 %a3 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a1 8 #154
beq_cont.45800:
	lw %a1 %sp 52 #1971
	addi %a1 %a1 1 #1971
	lw %a11 %sp 0 #1971
	lw %a10 %a11 0 #1971
	jalr %zero %a10 0 #1971
bge_else.45798:
	jalr %zero %ra 0 #1972
bge_else.45797:
	jalr %zero %ra 0 #1973
bge_else.45794:
	jalr %zero %ra 0 #1972
bge_else.45793:
	jalr %zero %ra 0 #1973
pretrace_pixels.2862:
	lw %a3 %a11 64 #1978
	lw %a4 %a11 60 #1978
	lw %a5 %a11 56 #1978
	lw %a6 %a11 52 #1978
	lw %a7 %a11 48 #1978
	lw %a8 %a11 44 #1978
	lw %a9 %a11 40 #1978
	lw %a10 %a11 36 #1978
	sw %a5 %sp 0 #1978
	lw %a5 %a11 32 #1978
	sw %a8 %sp 4 #1978
	lw %a8 %a11 28 #1978
	sw %a6 %sp 8 #1978
	lw %a6 %a11 24 #1978
	sw %a6 %sp 12 #1978
	lw %a6 %a11 20 #1978
	sw %a6 %sp 16 #1978
	lw %a6 %a11 16 #1978
	sw %a6 %sp 20 #1978
	lw %a6 %a11 12 #1978
	sw %a2 %sp 24 #1978
	lw %a2 %a11 8 #1978
	sw %a11 %sp 28 #1978
	lw %a11 %a11 4 #1978
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45807
	lw %f3 %a10 0 #61
	lw %a6 %a6 0 #59
	sub %a6 %a1 %a6 #1981
	itof %f4 %a6 #1981
	fmul %f3 %f3 %f4 #1981
	lw %f4 %a9 0 #69
	fmul %f4 %f3 %f4 #1982
	fadd %f4 %f4 %f0 #1982
	sw %f4 %a8 0 #1982
	lw %f4 %a9 4 #69
	fmul %f4 %f3 %f4 #1983
	fadd %f4 %f4 %f1 #1983
	sw %f4 %a8 4 #1983
	lw %f4 %a9 8 #69
	fmul %f3 %f3 %f4 #1984
	fadd %f3 %f3 %f2 #1984
	sw %f3 %a8 8 #1984
	lw %f3 %a8 0 #172
	fmul %f3 %f3 %f3 #172
	lw %f4 %a8 4 #172
	fmul %f4 %f4 %f4 #172
	fadd %f3 %f3 %f4 #172
	lw %f4 %a8 8 #172
	fmul %f4 %f4 %f4 #172
	fadd %f3 %f3 %f4 #172
	sqrt %f3 %f3 #172
	fiszero %a6 %f3 #173
	addi %a12 %zero 0
	bne %a6 %a12 beq_else.45808 # nontail if
	li %f4 l.37441 #173
	fdiv %f3 %f4 %f3 #173
	jal %zero beq_cont.45809 # then sentence ends
beq_else.45808:
	li %f3 l.37441 #173
beq_cont.45809:
	lw %f4 %a8 0 #172
	fmul %f4 %f4 %f3 #174
	sw %f4 %a8 0 #174
	lw %f4 %a8 4 #172
	fmul %f4 %f4 %f3 #175
	sw %f4 %a8 4 #175
	lw %f4 %a8 8 #172
	fmul %f3 %f4 %f3 #176
	sw %f3 %a8 8 #176
	li %f3 l.37367 #147
	sw %f3 %a5 0 #140
	sw %f3 %a5 4 #141
	sw %f3 %a5 8 #142
	lw %f3 %a3 0 #152
	sw %f3 %a7 0 #152
	lw %f3 %a3 4 #152
	sw %f3 %a7 4 #153
	lw %f3 %a3 8 #152
	sw %f3 %a7 8 #154
	addi %a3 %zero 0 #1990
	li %f3 l.37441 #1990
	slli %a6 %a1 2 #1990
	add %a12 %a0 %a6 #1990
	lw %a6 %a12 0 #1990
	li %f4 l.37367 #1990
	sw %f2 %sp 32 #1990
	sw %f1 %sp 40 #1990
	sw %f0 %sp 48 #1990
	sw %a2 %sp 56 #1990
	sw %a11 %sp 60 #1990
	sw %a5 %sp 64 #1990
	sw %a0 %sp 68 #1990
	sw %a1 %sp 72 #1990
	add %a2 %a6 %zero
	add %a1 %a8 %zero
	add %a0 %a3 %zero
	add %a11 %a4 %zero
	fadd %f1 %f4 %fzero
	fadd %f0 %f3 %fzero
	sw %ra %sp 76 #1990 call cls
	lw %a10 %a11 0 #1990
	addi %sp %sp 80 #1990	
	jalr %ra %a10 0 #1990
	addi %sp %sp -80 #1990
	lw %ra %sp 76 #1990
	lw %a0 %sp 72 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 68 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a1 %a1 0 #439
	lw %a3 %sp 64 #152
	lw %f0 %a3 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a1 8 #154
	slli %a1 %a0 2 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a1 %a1 24 #491
	lw %a3 %sp 24 #493
	sw %a3 %a1 0 #493
	slli %a1 %a0 2 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a4 %a1 8 #454
	lw %a4 %a4 0 #1662
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.45810 # nontail if
	lw %a4 %a1 12 #461
	lw %a4 %a4 0 #1669
	sw %a1 %sp 76 #1669
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45812 # nontail if
	jal %zero beq_cont.45813 # then sentence ends
beq_else.45812:
	lw %a4 %a1 24 #484
	lw %a4 %a4 0 #486
	li %f0 l.37367 #147
	lw %a5 %sp 60 #140
	sw %f0 %a5 0 #140
	sw %f0 %a5 4 #141
	sw %f0 %a5 8 #142
	lw %a6 %a1 28 #498
	lw %a7 %a1 4 #446
	slli %a4 %a4 2 #81
	lw %a8 %sp 56 #81
	add %a12 %a8 %a4 #81
	lw %a4 %a12 0 #81
	lw %a6 %a6 0 #1676
	lw %a7 %a7 0 #1664
	lw %f0 %a7 0 #152
	lw %a8 %sp 8 #152
	sw %f0 %a8 0 #152
	lw %f0 %a7 4 #152
	sw %f0 %a8 4 #153
	lw %f0 %a7 8 #152
	sw %f0 %a8 8 #154
	lw %a8 %sp 16 #15
	lw %a8 %a8 0 #15
	addi %a8 %a8 -1 #1147
	lw %a11 %sp 4 #1147
	sw %a7 %sp 80 #1147
	sw %a6 %sp 84 #1147
	sw %a4 %sp 88 #1147
	add %a1 %a8 %zero
	add %a0 %a7 %zero
	sw %ra %sp 92 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 96 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -96 #1147
	lw %ra %sp 92 #1147
	lw %a0 %sp 88 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 84 #181
	lw %f1 %a2 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a1 4 #181
	lw %f2 %a2 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a1 8 #181
	lw %f2 %a2 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	fisneg %a1 %f0 #1760
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45814 # nontail if
	lw %a1 %a0 472 #1757
	li %f1 l.39011 #1763
	fdiv %f0 %f0 %f1 #1763
	lw %a11 %sp 0 #1763
	add %a0 %a1 %zero
	sw %ra %sp 92 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 96 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -96 #1763
	lw %ra %sp 92 #1763
	jal %zero beq_cont.45815 # then sentence ends
beq_else.45814:
	lw %a1 %a0 476 #1757
	li %f1 l.38946 #1761
	fdiv %f0 %f0 %f1 #1761
	lw %a11 %sp 0 #1761
	add %a0 %a1 %zero
	sw %ra %sp 92 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 96 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -96 #1761
	lw %ra %sp 92 #1761
beq_cont.45815:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 88 #1765
	lw %a1 %sp 84 #1765
	lw %a2 %sp 80 #1765
	lw %a11 %sp 20 #1765
	sw %ra %sp 92 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 96 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -96 #1765
	lw %ra %sp 92 #1765
	lw %a0 %sp 76 #475
	lw %a1 %a0 20 #475
	lw %a1 %a1 0 #1810
	lw %a2 %sp 60 #152
	lw %f0 %a2 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a1 8 #154
beq_cont.45813:
	addi %a1 %zero 1 #1971
	lw %a0 %sp 76 #1971
	lw %a11 %sp 12 #1971
	sw %ra %sp 92 #1971 call cls
	lw %a10 %a11 0 #1971
	addi %sp %sp 96 #1971	
	jalr %ra %a10 0 #1971
	addi %sp %sp -96 #1971
	lw %ra %sp 92 #1971
	jal %zero bge_cont.45811 # then sentence ends
bge_else.45810:
bge_cont.45811:
	lw %a0 %sp 72 #1997
	addi %a1 %a0 -1 #1997
	lw %a0 %sp 24 #123
	addi %a0 %a0 1 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.45816 # nontail if
	addi %a2 %a0 -5 #124
	jal %zero bge_cont.45817 # then sentence ends
bge_else.45816:
	addi %a2 %a0 0 #124
bge_cont.45817:
	lw %f0 %sp 48 #1997
	lw %f1 %sp 40 #1997
	lw %f2 %sp 32 #1997
	lw %a0 %sp 68 #1997
	lw %a11 %sp 28 #1997
	lw %a10 %a11 0 #1997
	jalr %zero %a10 0 #1997
bge_else.45807:
	jalr %zero %ra 0 #1999
scan_pixel.2873:
	lw %a5 %a11 32 #2017
	lw %a6 %a11 28 #2017
	lw %a7 %a11 24 #2017
	lw %a8 %a11 20 #2017
	lw %a9 %a11 16 #2017
	lw %a10 %a11 12 #2017
	sw %a5 %sp 0 #2017
	lw %a5 %a11 8 #2017
	sw %a11 %sp 4 #2017
	lw %a11 %a11 4 #2017
	sw %a5 %sp 8 #57
	lw %a5 %a8 0 #57
	blt %a0 %a5 bge_else.45819
	jalr %zero %ra 0 #2033
bge_else.45819:
	slli %a5 %a0 2 #2021
	add %a12 %a3 %a5 #2021
	lw %a5 %a12 0 #2021
	lw %a5 %a5 0 #439
	lw %f0 %a5 0 #152
	sw %f0 %a7 0 #152
	lw %f0 %a5 4 #152
	sw %f0 %a7 4 #153
	lw %f0 %a5 8 #152
	sw %f0 %a7 8 #154
	lw %a5 %a8 4 #57
	sw %a4 %sp 12 #1857
	addi %a4 %a1 1 #1857
	blt %a4 %a5 bge_else.45821 # nontail if
	addi %a4 %zero 0 #1865
	jal %zero bge_cont.45822 # then sentence ends
bge_else.45821:
	addi %a12 %zero 0
	blt %a12 %a1 bge_else.45823 # nontail if
	addi %a4 %zero 0 #1864
	jal %zero bge_cont.45824 # then sentence ends
bge_else.45823:
	lw %a4 %a8 0 #57
	addi %a5 %a0 1 #1859
	blt %a5 %a4 bge_else.45825 # nontail if
	addi %a4 %zero 0 #1863
	jal %zero bge_cont.45826 # then sentence ends
bge_else.45825:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.45827 # nontail if
	addi %a4 %zero 0 #1862
	jal %zero bge_cont.45828 # then sentence ends
bge_else.45827:
	addi %a4 %zero 1 #1861
bge_cont.45828:
bge_cont.45826:
bge_cont.45824:
bge_cont.45822:
	sw %a2 %sp 16 #1861
	sw %a9 %sp 20 #1861
	sw %a11 %sp 24 #1861
	sw %a6 %sp 28 #1861
	sw %a10 %sp 32 #1861
	sw %a1 %sp 36 #1861
	sw %a3 %sp 40 #1861
	sw %a8 %sp 44 #1861
	sw %a0 %sp 48 #1861
	sw %a7 %sp 52 #1861
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45829 # nontail if
	slli %a4 %a0 2 #2021
	add %a12 %a3 %a4 #2021
	lw %a4 %a12 0 #2021
	addi %a5 %zero 0 #2027
	lw %a2 %a4 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45831 # nontail if
	lw %a2 %a4 12 #461
	lw %a2 %a2 0 #1669
	sw %a4 %sp 56 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45833 # nontail if
	jal %zero beq_cont.45834 # then sentence ends
beq_else.45833:
	add %a1 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 60 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 64 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -64 #1848
	lw %ra %sp 60 #1848
beq_cont.45834:
	lw %a0 %sp 56 #454
	lw %a1 %a0 8 #454
	lw %a1 %a1 4 #1662
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45835 # nontail if
	lw %a1 %a0 12 #461
	lw %a1 %a1 4 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45837 # nontail if
	jal %zero beq_cont.45838 # then sentence ends
beq_else.45837:
	lw %a1 %a0 20 #475
	lw %a2 %a0 28 #498
	lw %a3 %a0 4 #446
	lw %a4 %a0 16 #468
	lw %a1 %a1 4 #1810
	lw %f0 %a1 0 #152
	lw %a5 %sp 32 #152
	sw %f0 %a5 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a5 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a5 8 #154
	lw %a1 %a0 24 #484
	lw %a1 %a1 0 #486
	lw %a2 %a2 4 #1676
	lw %a3 %a3 4 #1664
	lw %a11 %sp 28 #1811
	sw %a4 %sp 60 #1811
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 68 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 72 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -72 #1811
	lw %ra %sp 68 #1811
	lw %a0 %sp 60 #1673
	lw %a0 %a0 4 #1673
	lw %a1 %sp 52 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 32 #219
	lw %f2 %a2 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a1 0 #219
	lw %f0 %a1 4 #219
	lw %f1 %a0 4 #219
	lw %f2 %a2 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a1 4 #220
	lw %f0 %a1 8 #219
	lw %f1 %a0 8 #219
	lw %f2 %a2 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a1 8 #221
beq_cont.45838:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 56 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 8 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45839 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 8 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45841 # nontail if
	jal %zero beq_cont.45842 # then sentence ends
beq_else.45841:
	lw %a11 %sp 24 #1848
	sw %ra %sp 68 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 72 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -72 #1848
	lw %ra %sp 68 #1848
beq_cont.45842:
	addi %a1 %zero 3 #1850
	lw %a0 %sp 56 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 68 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 72 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -72 #1850
	lw %ra %sp 68 #1850
	jal %zero bge_cont.45840 # then sentence ends
bge_else.45839:
bge_cont.45840:
	jal %zero bge_cont.45836 # then sentence ends
bge_else.45835:
bge_cont.45836:
	jal %zero bge_cont.45832 # then sentence ends
bge_else.45831:
bge_cont.45832:
	jal %zero beq_cont.45830 # then sentence ends
beq_else.45829:
	addi %a4 %zero 0 #2025
	slli %a5 %a0 2 #1891
	add %a12 %a3 %a5 #1891
	lw %a5 %a12 0 #1891
	lw %a8 %a5 8 #454
	lw %a8 %a8 0 #1662
	addi %a12 %zero 0
	blt %a8 %a12 bge_else.45843 # nontail if
	slli %a8 %a0 2 #1875
	add %a12 %a3 %a8 #1875
	lw %a8 %a12 0 #1875
	lw %a8 %a8 8 #454
	lw %a8 %a8 0 #1662
	slli %a1 %a0 2 #1877
	add %a12 %a2 %a1 #1877
	lw %a1 %a12 0 #1877
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	sw %a4 %sp 64 #1662
	bne %a1 %a8 beq_else.45845 # nontail if
	slli %a1 %a0 2 #1878
	lw %a4 %sp 12 #1878
	add %a12 %a4 %a1 #1878
	lw %a1 %a12 0 #1878
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a8 beq_else.45847 # nontail if
	addi %a1 %a0 -1 #1879
	slli %a1 %a1 2 #1875
	add %a12 %a3 %a1 #1875
	lw %a1 %a12 0 #1875
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a8 beq_else.45849 # nontail if
	addi %a1 %a0 1 #1880
	slli %a1 %a1 2 #1875
	add %a12 %a3 %a1 #1875
	lw %a1 %a12 0 #1875
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a8 beq_else.45851 # nontail if
	addi %a1 %zero 1 #1881
	jal %zero beq_cont.45852 # then sentence ends
beq_else.45851:
	addi %a1 %zero 0 #1882
beq_cont.45852:
	jal %zero beq_cont.45850 # then sentence ends
beq_else.45849:
	addi %a1 %zero 0 #1883
beq_cont.45850:
	jal %zero beq_cont.45848 # then sentence ends
beq_else.45847:
	addi %a1 %zero 0 #1884
beq_cont.45848:
	jal %zero beq_cont.45846 # then sentence ends
beq_else.45845:
	addi %a1 %zero 0 #1885
beq_cont.45846:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45853 # nontail if
	slli %a1 %a0 2 #1891
	add %a12 %a3 %a1 #1891
	lw %a1 %a12 0 #1891
	lw %a4 %a1 8 #454
	lw %a4 %a4 0 #1662
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.45855 # nontail if
	lw %a4 %a1 12 #461
	lw %a4 %a4 0 #1669
	sw %a1 %sp 68 #1669
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.45857 # nontail if
	jal %zero beq_cont.45858 # then sentence ends
beq_else.45857:
	lw %a4 %a1 20 #475
	lw %a5 %a1 28 #498
	lw %a8 %a1 4 #446
	lw %a2 %a1 16 #468
	lw %a4 %a4 0 #1810
	lw %f0 %a4 0 #152
	sw %f0 %a10 0 #152
	lw %f0 %a4 4 #152
	sw %f0 %a10 4 #153
	lw %f0 %a4 8 #152
	sw %f0 %a10 8 #154
	lw %a4 %a1 24 #484
	lw %a4 %a4 0 #486
	lw %a5 %a5 0 #1676
	lw %a8 %a8 0 #1664
	sw %a2 %sp 72 #1811
	add %a2 %a8 %zero
	add %a1 %a5 %zero
	add %a0 %a4 %zero
	add %a11 %a6 %zero
	sw %ra %sp 76 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 80 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -80 #1811
	lw %ra %sp 76 #1811
	lw %a0 %sp 72 #1673
	lw %a0 %a0 0 #1673
	lw %a1 %sp 52 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 32 #219
	lw %f2 %a2 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a1 0 #219
	lw %f0 %a1 4 #219
	lw %f1 %a0 4 #219
	lw %f2 %a2 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a1 4 #220
	lw %f0 %a1 8 #219
	lw %f1 %a0 8 #219
	lw %f2 %a2 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a1 8 #221
beq_cont.45858:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 68 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45859 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45861 # nontail if
	jal %zero beq_cont.45862 # then sentence ends
beq_else.45861:
	lw %a11 %sp 24 #1848
	sw %ra %sp 76 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 80 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -80 #1848
	lw %ra %sp 76 #1848
beq_cont.45862:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 68 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 76 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 80 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -80 #1850
	lw %ra %sp 76 #1850
	jal %zero bge_cont.45860 # then sentence ends
bge_else.45859:
bge_cont.45860:
	jal %zero bge_cont.45856 # then sentence ends
bge_else.45855:
bge_cont.45856:
	jal %zero beq_cont.45854 # then sentence ends
beq_else.45853:
	lw %a1 %a5 12 #461
	lw %a1 %a1 0 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45863 # nontail if
	jal %zero beq_cont.45864 # then sentence ends
beq_else.45863:
	lw %a1 %sp 12 #1902
	lw %a4 %sp 64 #1902
	lw %a5 %sp 8 #1902
	add %a11 %a5 %zero
	add %a10 %a3 %zero
	add %a3 %a1 %zero
	add %a1 %a2 %zero
	add %a2 %a10 %zero
	sw %ra %sp 76 #1902 call cls
	lw %a10 %a11 0 #1902
	addi %sp %sp 80 #1902	
	jalr %ra %a10 0 #1902
	addi %sp %sp -80 #1902
	lw %ra %sp 76 #1902
beq_cont.45864:
	addi %a5 %zero 1 #1906
	lw %a0 %sp 48 #1906
	lw %a1 %sp 36 #1906
	lw %a2 %sp 16 #1906
	lw %a3 %sp 40 #1906
	lw %a4 %sp 12 #1906
	lw %a11 %sp 0 #1906
	sw %ra %sp 76 #1906 call cls
	lw %a10 %a11 0 #1906
	addi %sp %sp 80 #1906	
	jalr %ra %a10 0 #1906
	addi %sp %sp -80 #1906
	lw %ra %sp 76 #1906
beq_cont.45854:
	jal %zero bge_cont.45844 # then sentence ends
bge_else.45843:
bge_cont.45844:
beq_cont.45830:
	lw %a0 %sp 52 #54
	lw %f0 %a0 0 #54
	ftoi %a1 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a1 bge_else.45865 # nontail if
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45867 # nontail if
	jal %zero bge_cont.45868 # then sentence ends
bge_else.45867:
	addi %a1 %zero 0 #1931
bge_cont.45868:
	jal %zero bge_cont.45866 # then sentence ends
bge_else.45865:
	addi %a1 %zero 255 #1931
bge_cont.45866:
	add %a0 %a1 %zero
	sw %ra %sp 76 #1932 call dir
	addi %sp %sp 80 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -80 #1932
	lw %ra %sp 76 #1932
	addi %a0 %zero 32 #1937
	sw %ra %sp 76 #1937 call dir
	addi %sp %sp 80 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -80 #1937
	lw %ra %sp 76 #1937
	lw %a0 %sp 52 #54
	lw %f0 %a0 4 #54
	ftoi %a1 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a1 bge_else.45869 # nontail if
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45871 # nontail if
	jal %zero bge_cont.45872 # then sentence ends
bge_else.45871:
	addi %a1 %zero 0 #1931
bge_cont.45872:
	jal %zero bge_cont.45870 # then sentence ends
bge_else.45869:
	addi %a1 %zero 255 #1931
bge_cont.45870:
	add %a0 %a1 %zero
	sw %ra %sp 76 #1932 call dir
	addi %sp %sp 80 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -80 #1932
	lw %ra %sp 76 #1932
	addi %a0 %zero 32 #1939
	sw %ra %sp 76 #1939 call dir
	addi %sp %sp 80 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -80 #1939
	lw %ra %sp 76 #1939
	lw %a0 %sp 52 #54
	lw %f0 %a0 8 #54
	ftoi %a1 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a1 bge_else.45873 # nontail if
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45875 # nontail if
	jal %zero bge_cont.45876 # then sentence ends
bge_else.45875:
	addi %a1 %zero 0 #1931
bge_cont.45876:
	jal %zero bge_cont.45874 # then sentence ends
bge_else.45873:
	addi %a1 %zero 255 #1931
bge_cont.45874:
	add %a0 %a1 %zero
	sw %ra %sp 76 #1932 call dir
	addi %sp %sp 80 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -80 #1932
	lw %ra %sp 76 #1932
	addi %a0 %zero 10 #1941
	sw %ra %sp 76 #1941 call dir
	addi %sp %sp 80 #1941	
	jal %ra min_caml_print_char #1941
	addi %sp %sp -80 #1941
	lw %ra %sp 76 #1941
	lw %a0 %sp 48 #2032
	addi %a0 %a0 1 #2032
	lw %a1 %sp 44 #57
	lw %a2 %a1 0 #57
	blt %a0 %a2 bge_else.45877
	jalr %zero %ra 0 #2033
bge_else.45877:
	slli %a2 %a0 2 #2021
	lw %a3 %sp 40 #2021
	add %a12 %a3 %a2 #2021
	lw %a2 %a12 0 #2021
	lw %a2 %a2 0 #439
	lw %f0 %a2 0 #152
	lw %a4 %sp 52 #152
	sw %f0 %a4 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a4 8 #154
	lw %a2 %a1 4 #57
	lw %a5 %sp 36 #1857
	addi %a6 %a5 1 #1857
	blt %a6 %a2 bge_else.45879 # nontail if
	addi %a1 %zero 0 #1865
	jal %zero bge_cont.45880 # then sentence ends
bge_else.45879:
	addi %a12 %zero 0
	blt %a12 %a5 bge_else.45881 # nontail if
	addi %a1 %zero 0 #1864
	jal %zero bge_cont.45882 # then sentence ends
bge_else.45881:
	lw %a1 %a1 0 #57
	addi %a2 %a0 1 #1859
	blt %a2 %a1 bge_else.45883 # nontail if
	addi %a1 %zero 0 #1863
	jal %zero bge_cont.45884 # then sentence ends
bge_else.45883:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.45885 # nontail if
	addi %a1 %zero 0 #1862
	jal %zero bge_cont.45886 # then sentence ends
bge_else.45885:
	addi %a1 %zero 1 #1861
bge_cont.45886:
bge_cont.45884:
bge_cont.45882:
bge_cont.45880:
	sw %a0 %sp 76 #1861
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.45887 # nontail if
	slli %a1 %a0 2 #2021
	add %a12 %a3 %a1 #2021
	lw %a1 %a12 0 #2021
	lw %a2 %a1 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45889 # nontail if
	lw %a2 %a1 12 #461
	lw %a2 %a2 0 #1669
	sw %a1 %sp 80 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45891 # nontail if
	jal %zero beq_cont.45892 # then sentence ends
beq_else.45891:
	lw %a2 %a1 20 #475
	lw %a6 %a1 28 #498
	lw %a7 %a1 4 #446
	lw %a8 %a1 16 #468
	lw %a2 %a2 0 #1810
	lw %f0 %a2 0 #152
	lw %a9 %sp 32 #152
	sw %f0 %a9 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a9 8 #154
	lw %a2 %a1 24 #484
	lw %a2 %a2 0 #486
	lw %a6 %a6 0 #1676
	lw %a7 %a7 0 #1664
	lw %a11 %sp 28 #1811
	sw %a8 %sp 84 #1811
	add %a1 %a6 %zero
	add %a0 %a2 %zero
	add %a2 %a7 %zero
	sw %ra %sp 92 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 96 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -96 #1811
	lw %ra %sp 92 #1811
	lw %a0 %sp 84 #1673
	lw %a0 %a0 0 #1673
	lw %a1 %sp 52 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 32 #219
	lw %f2 %a2 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a1 0 #219
	lw %f0 %a1 4 #219
	lw %f1 %a0 4 #219
	lw %f2 %a2 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a1 4 #220
	lw %f0 %a1 8 #219
	lw %f1 %a0 8 #219
	lw %f2 %a2 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a1 8 #221
beq_cont.45892:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 80 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45893 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45895 # nontail if
	jal %zero beq_cont.45896 # then sentence ends
beq_else.45895:
	lw %a11 %sp 24 #1848
	sw %ra %sp 92 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 96 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -96 #1848
	lw %ra %sp 92 #1848
beq_cont.45896:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 80 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 92 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 96 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -96 #1850
	lw %ra %sp 92 #1850
	jal %zero bge_cont.45894 # then sentence ends
bge_else.45893:
bge_cont.45894:
	jal %zero bge_cont.45890 # then sentence ends
bge_else.45889:
bge_cont.45890:
	jal %zero beq_cont.45888 # then sentence ends
beq_else.45887:
	addi %a1 %zero 0 #2025
	lw %a2 %sp 16 #2025
	lw %a6 %sp 12 #2025
	lw %a11 %sp 0 #2025
	add %a4 %a6 %zero
	add %a10 %a5 %zero
	add %a5 %a1 %zero
	add %a1 %a10 %zero
	sw %ra %sp 92 #2025 call cls
	lw %a10 %a11 0 #2025
	addi %sp %sp 96 #2025	
	jalr %ra %a10 0 #2025
	addi %sp %sp -96 #2025
	lw %ra %sp 92 #2025
beq_cont.45888:
	lw %a0 %sp 52 #54
	lw %f0 %a0 0 #54
	ftoi %a1 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a1 bge_else.45897 # nontail if
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45899 # nontail if
	jal %zero bge_cont.45900 # then sentence ends
bge_else.45899:
	addi %a1 %zero 0 #1931
bge_cont.45900:
	jal %zero bge_cont.45898 # then sentence ends
bge_else.45897:
	addi %a1 %zero 255 #1931
bge_cont.45898:
	add %a0 %a1 %zero
	sw %ra %sp 92 #1932 call dir
	addi %sp %sp 96 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -96 #1932
	lw %ra %sp 92 #1932
	addi %a0 %zero 32 #1937
	sw %ra %sp 92 #1937 call dir
	addi %sp %sp 96 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -96 #1937
	lw %ra %sp 92 #1937
	lw %a0 %sp 52 #54
	lw %f0 %a0 4 #54
	ftoi %a1 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a1 bge_else.45901 # nontail if
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45903 # nontail if
	jal %zero bge_cont.45904 # then sentence ends
bge_else.45903:
	addi %a1 %zero 0 #1931
bge_cont.45904:
	jal %zero bge_cont.45902 # then sentence ends
bge_else.45901:
	addi %a1 %zero 255 #1931
bge_cont.45902:
	add %a0 %a1 %zero
	sw %ra %sp 92 #1932 call dir
	addi %sp %sp 96 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -96 #1932
	lw %ra %sp 92 #1932
	addi %a0 %zero 32 #1939
	sw %ra %sp 92 #1939 call dir
	addi %sp %sp 96 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -96 #1939
	lw %ra %sp 92 #1939
	lw %a0 %sp 52 #54
	lw %f0 %a0 8 #54
	ftoi %a0 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.45905 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45907 # nontail if
	jal %zero bge_cont.45908 # then sentence ends
bge_else.45907:
	addi %a0 %zero 0 #1931
bge_cont.45908:
	jal %zero bge_cont.45906 # then sentence ends
bge_else.45905:
	addi %a0 %zero 255 #1931
bge_cont.45906:
	sw %ra %sp 92 #1932 call dir
	addi %sp %sp 96 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -96 #1932
	lw %ra %sp 92 #1932
	addi %a0 %zero 10 #1941
	sw %ra %sp 92 #1941 call dir
	addi %sp %sp 96 #1941	
	jal %ra min_caml_print_char #1941
	addi %sp %sp -96 #1941
	lw %ra %sp 92 #1941
	lw %a0 %sp 76 #2032
	addi %a0 %a0 1 #2032
	lw %a1 %sp 36 #2032
	lw %a2 %sp 16 #2032
	lw %a3 %sp 40 #2032
	lw %a4 %sp 12 #2032
	lw %a11 %sp 4 #2032
	lw %a10 %a11 0 #2032
	jalr %zero %a10 0 #2032
scan_line.2879:
	lw %a5 %a11 52 #2037
	lw %a6 %a11 48 #2037
	lw %a7 %a11 44 #2037
	lw %a8 %a11 40 #2037
	lw %a9 %a11 36 #2037
	lw %a10 %a11 32 #2037
	sw %a9 %sp 0 #2037
	lw %a9 %a11 28 #2037
	sw %a1 %sp 4 #2037
	lw %a1 %a11 24 #2037
	sw %a5 %sp 8 #2037
	lw %a5 %a11 20 #2037
	sw %a6 %sp 12 #2037
	lw %a6 %a11 16 #2037
	sw %a9 %sp 16 #2037
	lw %a9 %a11 12 #2037
	sw %a9 %sp 20 #2037
	lw %a9 %a11 8 #2037
	sw %a11 %sp 24 #2037
	lw %a11 %a11 4 #2037
	sw %a11 %sp 28 #57
	lw %a11 %a5 4 #57
	blt %a0 %a11 bge_else.45909
	jalr %zero %ra 0 #2046
bge_else.45909:
	lw %a11 %a5 4 #57
	addi %a11 %a11 -1 #2041
	sw %a1 %sp 32 #2041
	sw %a7 %sp 36 #2041
	sw %a8 %sp 40 #2041
	sw %a6 %sp 44 #2041
	sw %a10 %sp 48 #2041
	sw %a4 %sp 52 #2041
	sw %a3 %sp 56 #2041
	sw %a9 %sp 60 #2041
	sw %a0 %sp 64 #2041
	sw %a2 %sp 68 #2041
	sw %a5 %sp 72 #2041
	blt %a0 %a11 bge_else.45911 # nontail if
	jal %zero bge_cont.45912 # then sentence ends
bge_else.45911:
	addi %a11 %a0 1 #2042
	lw %f0 %a10 0 #61
	lw %a6 %a6 4 #59
	sub %a6 %a11 %a6 #2004
	itof %f1 %a6 #2004
	fmul %f0 %f0 %f1 #2004
	lw %f1 %a8 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %f2 %a7 0 #71
	fadd %f1 %f1 %f2 #2007
	lw %f2 %a8 4 #70
	fmul %f2 %f0 %f2 #2008
	lw %f3 %a7 4 #71
	fadd %f2 %f2 %f3 #2008
	lw %f3 %a8 8 #70
	fmul %f0 %f0 %f3 #2009
	lw %f3 %a7 8 #71
	fadd %f0 %f0 %f3 #2009
	lw %a6 %a5 0 #57
	addi %a6 %a6 -1 #2010
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	add %a11 %a1 %zero
	add %a1 %a6 %zero
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 76 #2010 call cls
	lw %a10 %a11 0 #2010
	addi %sp %sp 80 #2010	
	jalr %ra %a10 0 #2010
	addi %sp %sp -80 #2010
	lw %ra %sp 76 #2010
bge_cont.45912:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 72 #57
	lw %a2 %a1 0 #57
	addi %a12 %zero 0
	blt %a12 %a2 bge_else.45913 # nontail if
	jal %zero bge_cont.45914 # then sentence ends
bge_else.45913:
	lw %a3 %sp 68 #2021
	lw %a2 %a3 0 #2021
	lw %a2 %a2 0 #439
	lw %f0 %a2 0 #152
	lw %a4 %sp 16 #152
	sw %f0 %a4 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a4 8 #154
	lw %a2 %a1 4 #57
	lw %a5 %sp 64 #1857
	addi %a6 %a5 1 #1857
	blt %a6 %a2 bge_else.45915 # nontail if
	addi %a2 %zero 0 #1865
	jal %zero bge_cont.45916 # then sentence ends
bge_else.45915:
	addi %a12 %zero 0
	blt %a12 %a5 bge_else.45917 # nontail if
	addi %a2 %zero 0 #1864
	jal %zero bge_cont.45918 # then sentence ends
bge_else.45917:
	lw %a2 %a1 0 #57
	addi %a12 %zero 1
	blt %a12 %a2 bge_else.45919 # nontail if
	addi %a2 %zero 0 #1863
	jal %zero bge_cont.45920 # then sentence ends
bge_else.45919:
	addi %a2 %zero 0 #1862
bge_cont.45920:
bge_cont.45918:
bge_cont.45916:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45921 # nontail if
	lw %a0 %a3 0 #2021
	lw %a2 %a0 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45923 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 0 #1669
	sw %a0 %sp 76 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45925 # nontail if
	jal %zero beq_cont.45926 # then sentence ends
beq_else.45925:
	lw %a2 %a0 20 #475
	lw %a6 %a0 28 #498
	lw %a7 %a0 4 #446
	lw %a8 %a0 16 #468
	lw %a2 %a2 0 #1810
	lw %f0 %a2 0 #152
	lw %a9 %sp 60 #152
	sw %f0 %a9 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a9 8 #154
	lw %a2 %a0 24 #484
	lw %a2 %a2 0 #486
	lw %a6 %a6 0 #1676
	lw %a7 %a7 0 #1664
	lw %a11 %sp 12 #1811
	sw %a8 %sp 80 #1811
	add %a1 %a6 %zero
	add %a0 %a2 %zero
	add %a2 %a7 %zero
	sw %ra %sp 84 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 88 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -88 #1811
	lw %ra %sp 84 #1811
	lw %a0 %sp 80 #1673
	lw %a0 %a0 0 #1673
	lw %a1 %sp 16 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 60 #219
	lw %f2 %a2 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a1 0 #219
	lw %f0 %a1 4 #219
	lw %f1 %a0 4 #219
	lw %f2 %a2 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a1 4 #220
	lw %f0 %a1 8 #219
	lw %f1 %a0 8 #219
	lw %f2 %a2 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a1 8 #221
beq_cont.45926:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 76 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.45927 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.45929 # nontail if
	jal %zero beq_cont.45930 # then sentence ends
beq_else.45929:
	lw %a11 %sp 28 #1848
	sw %ra %sp 84 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 88 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -88 #1848
	lw %ra %sp 84 #1848
beq_cont.45930:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 76 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 84 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 88 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -88 #1850
	lw %ra %sp 84 #1850
	jal %zero bge_cont.45928 # then sentence ends
bge_else.45927:
bge_cont.45928:
	jal %zero bge_cont.45924 # then sentence ends
bge_else.45923:
bge_cont.45924:
	jal %zero beq_cont.45922 # then sentence ends
beq_else.45921:
	addi %a2 %zero 0 #2025
	lw %a6 %sp 4 #2025
	lw %a7 %sp 56 #2025
	lw %a11 %sp 8 #2025
	add %a4 %a7 %zero
	add %a1 %a5 %zero
	add %a5 %a2 %zero
	add %a2 %a6 %zero
	sw %ra %sp 84 #2025 call cls
	lw %a10 %a11 0 #2025
	addi %sp %sp 88 #2025	
	jalr %ra %a10 0 #2025
	addi %sp %sp -88 #2025
	lw %ra %sp 84 #2025
beq_cont.45922:
	lw %a0 %sp 16 #54
	lw %f0 %a0 0 #54
	ftoi %a1 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a1 bge_else.45931 # nontail if
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45933 # nontail if
	jal %zero bge_cont.45934 # then sentence ends
bge_else.45933:
	addi %a1 %zero 0 #1931
bge_cont.45934:
	jal %zero bge_cont.45932 # then sentence ends
bge_else.45931:
	addi %a1 %zero 255 #1931
bge_cont.45932:
	add %a0 %a1 %zero
	sw %ra %sp 84 #1932 call dir
	addi %sp %sp 88 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -88 #1932
	lw %ra %sp 84 #1932
	addi %a0 %zero 32 #1937
	sw %ra %sp 84 #1937 call dir
	addi %sp %sp 88 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -88 #1937
	lw %ra %sp 84 #1937
	lw %a0 %sp 16 #54
	lw %f0 %a0 4 #54
	ftoi %a1 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a1 bge_else.45935 # nontail if
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45937 # nontail if
	jal %zero bge_cont.45938 # then sentence ends
bge_else.45937:
	addi %a1 %zero 0 #1931
bge_cont.45938:
	jal %zero bge_cont.45936 # then sentence ends
bge_else.45935:
	addi %a1 %zero 255 #1931
bge_cont.45936:
	add %a0 %a1 %zero
	sw %ra %sp 84 #1932 call dir
	addi %sp %sp 88 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -88 #1932
	lw %ra %sp 84 #1932
	addi %a0 %zero 32 #1939
	sw %ra %sp 84 #1939 call dir
	addi %sp %sp 88 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -88 #1939
	lw %ra %sp 84 #1939
	lw %a0 %sp 16 #54
	lw %f0 %a0 8 #54
	ftoi %a0 %f0 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.45939 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45941 # nontail if
	jal %zero bge_cont.45942 # then sentence ends
bge_else.45941:
	addi %a0 %zero 0 #1931
bge_cont.45942:
	jal %zero bge_cont.45940 # then sentence ends
bge_else.45939:
	addi %a0 %zero 255 #1931
bge_cont.45940:
	sw %ra %sp 84 #1932 call dir
	addi %sp %sp 88 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -88 #1932
	lw %ra %sp 84 #1932
	addi %a0 %zero 10 #1941
	sw %ra %sp 84 #1941 call dir
	addi %sp %sp 88 #1941	
	jal %ra min_caml_print_char #1941
	addi %sp %sp -88 #1941
	lw %ra %sp 84 #1941
	addi %a0 %zero 1 #2032
	lw %a1 %sp 64 #2032
	lw %a2 %sp 4 #2032
	lw %a3 %sp 68 #2032
	lw %a4 %sp 56 #2032
	lw %a11 %sp 0 #2032
	sw %ra %sp 84 #2032 call cls
	lw %a10 %a11 0 #2032
	addi %sp %sp 88 #2032	
	jalr %ra %a10 0 #2032
	addi %sp %sp -88 #2032
	lw %ra %sp 84 #2032
bge_cont.45914:
	lw %a0 %sp 64 #2045
	addi %a1 %a0 1 #2045
	lw %a0 %sp 52 #123
	addi %a0 %a0 2 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.45943 # nontail if
	addi %a2 %a0 -5 #124
	jal %zero bge_cont.45944 # then sentence ends
bge_else.45943:
	addi %a2 %a0 0 #124
bge_cont.45944:
	lw %a0 %sp 72 #57
	lw %a3 %a0 4 #57
	blt %a1 %a3 bge_else.45945
	jalr %zero %ra 0 #2046
bge_else.45945:
	lw %a3 %a0 4 #57
	addi %a3 %a3 -1 #2041
	sw %a2 %sp 84 #2041
	sw %a1 %sp 88 #2041
	blt %a1 %a3 bge_else.45947 # nontail if
	jal %zero bge_cont.45948 # then sentence ends
bge_else.45947:
	addi %a3 %a1 1 #2042
	lw %a4 %sp 48 #61
	lw %f0 %a4 0 #61
	lw %a4 %sp 44 #59
	lw %a4 %a4 4 #59
	sub %a3 %a3 %a4 #2004
	itof %f1 %a3 #2004
	fmul %f0 %f0 %f1 #2004
	lw %a3 %sp 40 #70
	lw %f1 %a3 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a4 %sp 36 #71
	lw %f2 %a4 0 #71
	fadd %f1 %f1 %f2 #2007
	lw %f2 %a3 4 #70
	fmul %f2 %f0 %f2 #2008
	lw %f3 %a4 4 #71
	fadd %f2 %f2 %f3 #2008
	lw %f3 %a3 8 #70
	fmul %f0 %f0 %f3 #2009
	lw %f3 %a4 8 #71
	fadd %f0 %f0 %f3 #2009
	lw %a0 %a0 0 #57
	addi %a0 %a0 -1 #2010
	lw %a3 %sp 4 #2010
	lw %a11 %sp 32 #2010
	add %a1 %a0 %zero
	add %a0 %a3 %zero
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 92 #2010 call cls
	lw %a10 %a11 0 #2010
	addi %sp %sp 96 #2010	
	jalr %ra %a10 0 #2010
	addi %sp %sp -96 #2010
	lw %ra %sp 92 #2010
bge_cont.45948:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 88 #2044
	lw %a2 %sp 68 #2044
	lw %a3 %sp 56 #2044
	lw %a4 %sp 4 #2044
	lw %a11 %sp 0 #2044
	sw %ra %sp 92 #2044 call cls
	lw %a10 %a11 0 #2044
	addi %sp %sp 96 #2044	
	jalr %ra %a10 0 #2044
	addi %sp %sp -96 #2044
	lw %ra %sp 92 #2044
	lw %a0 %sp 88 #2045
	addi %a0 %a0 1 #2045
	lw %a1 %sp 84 #123
	addi %a1 %a1 2 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.45949 # nontail if
	addi %a4 %a1 -5 #124
	jal %zero bge_cont.45950 # then sentence ends
bge_else.45949:
	addi %a4 %a1 0 #124
bge_cont.45950:
	lw %a1 %sp 56 #2045
	lw %a2 %sp 4 #2045
	lw %a3 %sp 68 #2045
	lw %a11 %sp 24 #2045
	lw %a10 %a11 0 #2045
	jalr %zero %a10 0 #2045
create_pixel.2887:
	addi %a0 %zero 3 #2066
	li %f0 l.37367 #2066
	sw %ra %sp 4 #2066 call dir
	addi %sp %sp 8 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -8 #2066
	lw %ra %sp 4 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 0 #2054
	add %a0 %a1 %zero
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
	li %f0 l.37367 #2056
	sw %a0 %sp 4 #2056
	add %a0 %a1 %zero
	sw %ra %sp 12 #2056 call dir
	addi %sp %sp 16 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -16 #2056
	lw %ra %sp 12 #2056
	lw %a1 %sp 4 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 12 #2057 call dir
	addi %sp %sp 16 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -16 #2057
	lw %ra %sp 12 #2057
	lw %a1 %sp 4 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 12 #2058 call dir
	addi %sp %sp 16 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -16 #2058
	lw %ra %sp 12 #2058
	lw %a1 %sp 4 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 12 #2059 call dir
	addi %sp %sp 16 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -16 #2059
	lw %ra %sp 12 #2059
	lw %a1 %sp 4 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
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
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 12 #2054
	add %a0 %a1 %zero
	sw %ra %sp 20 #2054 call dir
	addi %sp %sp 24 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -24 #2054
	lw %ra %sp 20 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 20 #2055 call dir
	addi %sp %sp 24 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -24 #2055
	lw %ra %sp 20 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 16 #2056
	add %a0 %a1 %zero
	sw %ra %sp 20 #2056 call dir
	addi %sp %sp 24 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -24 #2056
	lw %ra %sp 20 #2056
	lw %a1 %sp 16 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 20 #2057 call dir
	addi %sp %sp 24 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -24 #2057
	lw %ra %sp 20 #2057
	lw %a1 %sp 16 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 20 #2058 call dir
	addi %sp %sp 24 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -24 #2058
	lw %ra %sp 20 #2058
	lw %a1 %sp 16 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 20 #2059 call dir
	addi %sp %sp 24 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -24 #2059
	lw %ra %sp 20 #2059
	lw %a1 %sp 16 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %ra %sp 20 #2054 call dir
	addi %sp %sp 24 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -24 #2054
	lw %ra %sp 20 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 20 #2055 call dir
	addi %sp %sp 24 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -24 #2055
	lw %ra %sp 20 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 20 #2056
	add %a0 %a1 %zero
	sw %ra %sp 28 #2056 call dir
	addi %sp %sp 32 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -32 #2056
	lw %ra %sp 28 #2056
	lw %a1 %sp 20 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 28 #2057 call dir
	addi %sp %sp 32 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -32 #2057
	lw %ra %sp 28 #2057
	lw %a1 %sp 20 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 28 #2058 call dir
	addi %sp %sp 32 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -32 #2058
	lw %ra %sp 28 #2058
	lw %a1 %sp 20 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 28 #2059 call dir
	addi %sp %sp 32 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -32 #2059
	lw %ra %sp 28 #2059
	lw %a1 %sp 20 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 28 #2072 call dir
	addi %sp %sp 32 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -32 #2072
	lw %ra %sp 28 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 24 #2054
	add %a0 %a1 %zero
	sw %ra %sp 28 #2054 call dir
	addi %sp %sp 32 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -32 #2054
	lw %ra %sp 28 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 28 #2055 call dir
	addi %sp %sp 32 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -32 #2055
	lw %ra %sp 28 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 28 #2056
	add %a0 %a1 %zero
	sw %ra %sp 36 #2056 call dir
	addi %sp %sp 40 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -40 #2056
	lw %ra %sp 36 #2056
	lw %a1 %sp 28 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 36 #2057 call dir
	addi %sp %sp 40 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -40 #2057
	lw %ra %sp 36 #2057
	lw %a1 %sp 28 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 36 #2058 call dir
	addi %sp %sp 40 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -40 #2058
	lw %ra %sp 36 #2058
	lw %a1 %sp 28 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 36 #2059 call dir
	addi %sp %sp 40 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -40 #2059
	lw %ra %sp 36 #2059
	lw %a1 %sp 28 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 24 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 20 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 16 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 12 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 8 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 4 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 0 #2074
	sw %a1 %a0 0 #2074
	jalr %zero %ra 0 #2074
init_line_elements.2889:
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45951
	addi %a2 %zero 3 #2066
	li %f0 l.37367 #2066
	sw %a0 %sp 0 #2066
	sw %a1 %sp 4 #2066
	add %a0 %a2 %zero
	sw %ra %sp 12 #2066 call dir
	addi %sp %sp 16 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -16 #2066
	lw %ra %sp 12 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 8 #2054
	add %a0 %a1 %zero
	sw %ra %sp 12 #2054 call dir
	addi %sp %sp 16 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -16 #2054
	lw %ra %sp 12 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 12 #2055 call dir
	addi %sp %sp 16 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -16 #2055
	lw %ra %sp 12 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 12 #2056
	add %a0 %a1 %zero
	sw %ra %sp 20 #2056 call dir
	addi %sp %sp 24 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -24 #2056
	lw %ra %sp 20 #2056
	lw %a1 %sp 12 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 20 #2057 call dir
	addi %sp %sp 24 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -24 #2057
	lw %ra %sp 20 #2057
	lw %a1 %sp 12 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 20 #2058 call dir
	addi %sp %sp 24 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -24 #2058
	lw %ra %sp 20 #2058
	lw %a1 %sp 12 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 20 #2059 call dir
	addi %sp %sp 24 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -24 #2059
	lw %ra %sp 20 #2059
	lw %a1 %sp 12 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 20 #2068 call dir
	addi %sp %sp 24 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -24 #2068
	lw %ra %sp 20 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 16 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 20 #2069 call dir
	addi %sp %sp 24 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -24 #2069
	lw %ra %sp 20 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 20 #2054
	add %a0 %a1 %zero
	sw %ra %sp 28 #2054 call dir
	addi %sp %sp 32 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -32 #2054
	lw %ra %sp 28 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 28 #2055 call dir
	addi %sp %sp 32 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -32 #2055
	lw %ra %sp 28 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 24 #2056
	add %a0 %a1 %zero
	sw %ra %sp 28 #2056 call dir
	addi %sp %sp 32 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -32 #2056
	lw %ra %sp 28 #2056
	lw %a1 %sp 24 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 28 #2057 call dir
	addi %sp %sp 32 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -32 #2057
	lw %ra %sp 28 #2057
	lw %a1 %sp 24 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 28 #2058 call dir
	addi %sp %sp 32 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -32 #2058
	lw %ra %sp 28 #2058
	lw %a1 %sp 24 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 28 #2059 call dir
	addi %sp %sp 32 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -32 #2059
	lw %ra %sp 28 #2059
	lw %a1 %sp 24 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %ra %sp 28 #2054 call dir
	addi %sp %sp 32 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -32 #2054
	lw %ra %sp 28 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 28 #2055 call dir
	addi %sp %sp 32 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -32 #2055
	lw %ra %sp 28 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 28 #2056
	add %a0 %a1 %zero
	sw %ra %sp 36 #2056 call dir
	addi %sp %sp 40 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -40 #2056
	lw %ra %sp 36 #2056
	lw %a1 %sp 28 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 36 #2057 call dir
	addi %sp %sp 40 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -40 #2057
	lw %ra %sp 36 #2057
	lw %a1 %sp 28 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 36 #2058 call dir
	addi %sp %sp 40 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -40 #2058
	lw %ra %sp 36 #2058
	lw %a1 %sp 28 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 36 #2059 call dir
	addi %sp %sp 40 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -40 #2059
	lw %ra %sp 36 #2059
	lw %a1 %sp 28 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 36 #2072 call dir
	addi %sp %sp 40 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -40 #2072
	lw %ra %sp 36 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 32 #2054
	add %a0 %a1 %zero
	sw %ra %sp 36 #2054 call dir
	addi %sp %sp 40 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -40 #2054
	lw %ra %sp 36 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 36 #2055 call dir
	addi %sp %sp 40 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -40 #2055
	lw %ra %sp 36 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 36 #2056
	add %a0 %a1 %zero
	sw %ra %sp 44 #2056 call dir
	addi %sp %sp 48 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -48 #2056
	lw %ra %sp 44 #2056
	lw %a1 %sp 36 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 44 #2057 call dir
	addi %sp %sp 48 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -48 #2057
	lw %ra %sp 44 #2057
	lw %a1 %sp 36 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 44 #2058 call dir
	addi %sp %sp 48 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -48 #2058
	lw %ra %sp 44 #2058
	lw %a1 %sp 36 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 44 #2059 call dir
	addi %sp %sp 48 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -48 #2059
	lw %ra %sp 44 #2059
	lw %a1 %sp 36 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 32 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 28 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 24 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 20 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 16 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 12 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 8 #2074
	sw %a1 %a0 0 #2074
	lw %a1 %sp 4 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 0 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a0 %a1 -1 #2081
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45952
	sw %a0 %sp 40 #2080
	sw %ra %sp 44 #2080 call dir
	addi %sp %sp 48 #2080	
	jal %ra create_pixel.2887 #2080
	addi %sp %sp -48 #2080
	lw %ra %sp 44 #2080
	lw %a1 %sp 40 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 0 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a0 %a1 -1 #2081
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45953
	addi %a1 %zero 3 #2066
	li %f0 l.37367 #2066
	sw %a0 %sp 44 #2066
	add %a0 %a1 %zero
	sw %ra %sp 52 #2066 call dir
	addi %sp %sp 56 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -56 #2066
	lw %ra %sp 52 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 48 #2054
	add %a0 %a1 %zero
	sw %ra %sp 52 #2054 call dir
	addi %sp %sp 56 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -56 #2054
	lw %ra %sp 52 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 52 #2055 call dir
	addi %sp %sp 56 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -56 #2055
	lw %ra %sp 52 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 52 #2056
	add %a0 %a1 %zero
	sw %ra %sp 60 #2056 call dir
	addi %sp %sp 64 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -64 #2056
	lw %ra %sp 60 #2056
	lw %a1 %sp 52 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 60 #2057 call dir
	addi %sp %sp 64 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -64 #2057
	lw %ra %sp 60 #2057
	lw %a1 %sp 52 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 60 #2058 call dir
	addi %sp %sp 64 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -64 #2058
	lw %ra %sp 60 #2058
	lw %a1 %sp 52 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 60 #2059 call dir
	addi %sp %sp 64 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -64 #2059
	lw %ra %sp 60 #2059
	lw %a1 %sp 52 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 60 #2068 call dir
	addi %sp %sp 64 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -64 #2068
	lw %ra %sp 60 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 56 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 60 #2069 call dir
	addi %sp %sp 64 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -64 #2069
	lw %ra %sp 60 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 60 #2054
	add %a0 %a1 %zero
	sw %ra %sp 68 #2054 call dir
	addi %sp %sp 72 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -72 #2054
	lw %ra %sp 68 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 68 #2055 call dir
	addi %sp %sp 72 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -72 #2055
	lw %ra %sp 68 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 64 #2056
	add %a0 %a1 %zero
	sw %ra %sp 68 #2056 call dir
	addi %sp %sp 72 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -72 #2056
	lw %ra %sp 68 #2056
	lw %a1 %sp 64 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 68 #2057 call dir
	addi %sp %sp 72 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -72 #2057
	lw %ra %sp 68 #2057
	lw %a1 %sp 64 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 68 #2058 call dir
	addi %sp %sp 72 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -72 #2058
	lw %ra %sp 68 #2058
	lw %a1 %sp 64 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 68 #2059 call dir
	addi %sp %sp 72 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -72 #2059
	lw %ra %sp 68 #2059
	lw %a1 %sp 64 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %ra %sp 68 #2054 call dir
	addi %sp %sp 72 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -72 #2054
	lw %ra %sp 68 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 68 #2055 call dir
	addi %sp %sp 72 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -72 #2055
	lw %ra %sp 68 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 68 #2056
	add %a0 %a1 %zero
	sw %ra %sp 76 #2056 call dir
	addi %sp %sp 80 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -80 #2056
	lw %ra %sp 76 #2056
	lw %a1 %sp 68 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 76 #2057 call dir
	addi %sp %sp 80 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -80 #2057
	lw %ra %sp 76 #2057
	lw %a1 %sp 68 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 76 #2058 call dir
	addi %sp %sp 80 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -80 #2058
	lw %ra %sp 76 #2058
	lw %a1 %sp 68 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 76 #2059 call dir
	addi %sp %sp 80 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -80 #2059
	lw %ra %sp 76 #2059
	lw %a1 %sp 68 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 76 #2072 call dir
	addi %sp %sp 80 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -80 #2072
	lw %ra %sp 76 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 72 #2054
	add %a0 %a1 %zero
	sw %ra %sp 76 #2054 call dir
	addi %sp %sp 80 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -80 #2054
	lw %ra %sp 76 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 76 #2055 call dir
	addi %sp %sp 80 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -80 #2055
	lw %ra %sp 76 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 76 #2056
	add %a0 %a1 %zero
	sw %ra %sp 84 #2056 call dir
	addi %sp %sp 88 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -88 #2056
	lw %ra %sp 84 #2056
	lw %a1 %sp 76 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 84 #2057 call dir
	addi %sp %sp 88 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -88 #2057
	lw %ra %sp 84 #2057
	lw %a1 %sp 76 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 84 #2058 call dir
	addi %sp %sp 88 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -88 #2058
	lw %ra %sp 84 #2058
	lw %a1 %sp 76 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 84 #2059 call dir
	addi %sp %sp 88 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -88 #2059
	lw %ra %sp 84 #2059
	lw %a1 %sp 76 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 72 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 68 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 64 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 60 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 56 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 52 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 48 #2074
	sw %a1 %a0 0 #2074
	lw %a1 %sp 44 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 0 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a0 %a1 -1 #2081
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45954
	sw %a0 %sp 80 #2080
	sw %ra %sp 84 #2080 call dir
	addi %sp %sp 88 #2080	
	jal %ra create_pixel.2887 #2080
	addi %sp %sp -88 #2080
	lw %ra %sp 84 #2080
	lw %a1 %sp 80 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 0 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	jal	%zero init_line_elements.2889
bge_else.45954:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.45953:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.45952:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.45951:
	jalr %zero %ra 0 #2083
calc_dirvec.2899:
	lw %a3 %a11 4 #2110
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.45955
	fmul %f2 %f0 %f0 #2112
	fmul %f3 %f1 %f1 #2112
	fadd %f2 %f2 %f3 #2112
	li %f3 l.37441 #2112
	fadd %f2 %f2 %f3 #2112
	sqrt %f2 %f2 #2112
	fdiv %f0 %f0 %f2 #2113
	fdiv %f1 %f1 %f2 #2114
	li %f3 l.37441 #2115
	fdiv %f2 %f3 %f2 #2115
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	slli %a1 %a2 2 #80
	add %a12 %a0 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	sw %f0 %a1 0 #133
	sw %f1 %a1 4 #134
	sw %f2 %a1 8 #135
	addi %a1 %a2 40 #2120
	slli %a1 %a1 2 #80
	add %a12 %a0 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	fneg %f3 %f1 #2120
	sw %f0 %a1 0 #133
	sw %f2 %a1 4 #134
	sw %f3 %a1 8 #135
	addi %a1 %a2 80 #2121
	slli %a1 %a1 2 #80
	add %a12 %a0 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	fneg %f3 %f0 #2121
	fneg %f4 %f1 #2121
	sw %f2 %a1 0 #133
	sw %f3 %a1 4 #134
	sw %f4 %a1 8 #135
	addi %a1 %a2 1 #2122
	slli %a1 %a1 2 #80
	add %a12 %a0 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	fneg %f3 %f0 #2122
	fneg %f4 %f1 #2122
	fneg %f5 %f2 #2122
	sw %f3 %a1 0 #133
	sw %f4 %a1 4 #134
	sw %f5 %a1 8 #135
	addi %a1 %a2 41 #2123
	slli %a1 %a1 2 #80
	add %a12 %a0 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	fneg %f3 %f0 #2123
	fneg %f4 %f2 #2123
	sw %f3 %a1 0 #133
	sw %f4 %a1 4 #134
	sw %f1 %a1 8 #135
	addi %a1 %a2 81 #2124
	slli %a1 %a1 2 #80
	add %a12 %a0 %a1 #80
	lw %a0 %a12 0 #80
	lw %a0 %a0 0 #507
	fneg %f2 %f2 #2124
	sw %f2 %a0 0 #133
	sw %f0 %a0 4 #134
	sw %f1 %a0 8 #135
	jalr %zero %ra 0 #135
bge_else.45955:
	fmul %f0 %f1 %f1 #2102
	li %f1 l.38835 #2102
	fadd %f0 %f0 %f1 #2102
	sqrt %f0 %f0 #2102
	li %f1 l.37441 #2103
	fdiv %f1 %f1 %f0 #2103
	sw %a2 %sp 0 #2104
	sw %a1 %sp 4 #2104
	sw %a11 %sp 8 #2104
	sw %f3 %sp 16 #2104
	sw %a0 %sp 24 #2104
	sw %f0 %sp 32 #2104
	sw %f2 %sp 40 #2104
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #2104 call dir
	addi %sp %sp 56 #2104	
	jal %ra min_caml_atan #2104
	addi %sp %sp -56 #2104
	lw %ra %sp 52 #2104
	lw %f1 %sp 40 #2105
	fmul %f0 %f0 %f1 #2105
	sw %f0 %sp 48 #2097
	sw %ra %sp 60 #2097 call dir
	addi %sp %sp 64 #2097	
	jal %ra min_caml_sin #2097
	addi %sp %sp -64 #2097
	lw %ra %sp 60 #2097
	lw %f1 %sp 48 #2097
	sw %f0 %sp 56 #2097
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #2097 call dir
	addi %sp %sp 72 #2097	
	jal %ra min_caml_cos #2097
	addi %sp %sp -72 #2097
	lw %ra %sp 68 #2097
	lw %f1 %sp 56 #2097
	fdiv %f0 %f1 %f0 #2097
	lw %f1 %sp 32 #2106
	fmul %f0 %f0 %f1 #2106
	lw %a0 %sp 24 #2127
	addi %a0 %a0 1 #2127
	fmul %f1 %f0 %f0 #2102
	li %f2 l.38835 #2102
	fadd %f1 %f1 %f2 #2102
	sqrt %f1 %f1 #2102
	li %f2 l.37441 #2103
	fdiv %f2 %f2 %f1 #2103
	sw %f0 %sp 64 #2104
	sw %a0 %sp 72 #2104
	sw %f1 %sp 80 #2104
	fadd %f0 %f2 %fzero
	sw %ra %sp 92 #2104 call dir
	addi %sp %sp 96 #2104	
	jal %ra min_caml_atan #2104
	addi %sp %sp -96 #2104
	lw %ra %sp 92 #2104
	lw %f1 %sp 16 #2105
	fmul %f0 %f0 %f1 #2105
	sw %f0 %sp 88 #2097
	sw %ra %sp 100 #2097 call dir
	addi %sp %sp 104 #2097	
	jal %ra min_caml_sin #2097
	addi %sp %sp -104 #2097
	lw %ra %sp 100 #2097
	lw %f1 %sp 88 #2097
	sw %f0 %sp 96 #2097
	fadd %f0 %f1 %fzero
	sw %ra %sp 108 #2097 call dir
	addi %sp %sp 112 #2097	
	jal %ra min_caml_cos #2097
	addi %sp %sp -112 #2097
	lw %ra %sp 108 #2097
	lw %f1 %sp 96 #2097
	fdiv %f0 %f1 %f0 #2097
	lw %f1 %sp 80 #2106
	fmul %f1 %f0 %f1 #2106
	lw %f0 %sp 64 #2127
	lw %f2 %sp 40 #2127
	lw %f3 %sp 16 #2127
	lw %a0 %sp 72 #2127
	lw %a1 %sp 4 #2127
	lw %a2 %sp 0 #2127
	lw %a11 %sp 8 #2127
	lw %a10 %a11 0 #2127
	jalr %zero %a10 0 #2127
calc_dirvecs.2907:
	lw %a3 %a11 4 #2131
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45960
	itof %f1 %a0 #2134
	li %f2 l.40051 #2134
	fmul %f1 %f1 %f2 #2134
	li %f2 l.40053 #2134
	fsub %f2 %f1 %f2 #2134
	addi %a4 %zero 0 #2135
	li %f1 l.37367 #2135
	li %f3 l.37367 #2135
	sw %a11 %sp 0 #2135
	sw %f0 %sp 8 #2135
	sw %a1 %sp 16 #2135
	sw %a3 %sp 20 #2135
	sw %a2 %sp 24 #2135
	sw %a0 %sp 28 #2135
	add %a0 %a4 %zero
	add %a11 %a3 %zero
	fadd %f11 %f3 %fzero
	fadd %f3 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 36 #2135 call cls
	lw %a10 %a11 0 #2135
	addi %sp %sp 40 #2135	
	jalr %ra %a10 0 #2135
	addi %sp %sp -40 #2135
	lw %ra %sp 36 #2135
	lw %a0 %sp 28 #2137
	itof %f0 %a0 #2137
	li %f1 l.40051 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.38835 #2137
	fadd %f2 %f0 %f1 #2137
	addi %a1 %zero 0 #2138
	li %f0 l.37367 #2138
	li %f1 l.37367 #2138
	lw %a2 %sp 24 #2138
	addi %a3 %a2 2 #2138
	lw %f3 %sp 8 #2138
	lw %a4 %sp 16 #2138
	lw %a11 %sp 20 #2138
	add %a2 %a3 %zero
	add %a0 %a1 %zero
	add %a1 %a4 %zero
	sw %ra %sp 36 #2138 call cls
	lw %a10 %a11 0 #2138
	addi %sp %sp 40 #2138	
	jalr %ra %a10 0 #2138
	addi %sp %sp -40 #2138
	lw %ra %sp 36 #2138
	lw %a0 %sp 28 #2140
	addi %a0 %a0 -1 #2140
	lw %a1 %sp 16 #123
	addi %a1 %a1 1 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.45962 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.45963 # then sentence ends
bge_else.45962:
bge_cont.45963:
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45964
	itof %f0 %a0 #2134
	li %f1 l.40051 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.40053 #2134
	fsub %f2 %f0 %f1 #2134
	addi %a2 %zero 0 #2135
	li %f0 l.37367 #2135
	li %f1 l.37367 #2135
	lw %f3 %sp 8 #2135
	lw %a3 %sp 24 #2135
	lw %a11 %sp 20 #2135
	sw %a1 %sp 32 #2135
	sw %a0 %sp 36 #2135
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 44 #2135 call cls
	lw %a10 %a11 0 #2135
	addi %sp %sp 48 #2135	
	jalr %ra %a10 0 #2135
	addi %sp %sp -48 #2135
	lw %ra %sp 44 #2135
	lw %a0 %sp 36 #2137
	itof %f0 %a0 #2137
	li %f1 l.40051 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.38835 #2137
	fadd %f2 %f0 %f1 #2137
	addi %a1 %zero 0 #2138
	li %f0 l.37367 #2138
	li %f1 l.37367 #2138
	lw %a2 %sp 24 #2138
	addi %a3 %a2 2 #2138
	lw %f3 %sp 8 #2138
	lw %a4 %sp 32 #2138
	lw %a11 %sp 20 #2138
	add %a2 %a3 %zero
	add %a0 %a1 %zero
	add %a1 %a4 %zero
	sw %ra %sp 44 #2138 call cls
	lw %a10 %a11 0 #2138
	addi %sp %sp 48 #2138	
	jalr %ra %a10 0 #2138
	addi %sp %sp -48 #2138
	lw %ra %sp 44 #2138
	lw %a0 %sp 36 #2140
	addi %a0 %a0 -1 #2140
	lw %a1 %sp 32 #123
	addi %a1 %a1 1 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.45965 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.45966 # then sentence ends
bge_else.45965:
bge_cont.45966:
	lw %f0 %sp 8 #2140
	lw %a2 %sp 24 #2140
	lw %a11 %sp 0 #2140
	lw %a10 %a11 0 #2140
	jalr %zero %a10 0 #2140
bge_else.45964:
	jalr %zero %ra 0 #2141
bge_else.45960:
	jalr %zero %ra 0 #2141
calc_dirvec_rows.2912:
	lw %a3 %a11 8 #2145
	lw %a4 %a11 4 #2145
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45969
	itof %f0 %a0 #2147
	li %f1 l.40051 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.40053 #2147
	fsub %f3 %f0 %f1 #2147
	addi %a5 %zero 4 #2148
	itof %f0 %a5 #2134
	li %f1 l.40051 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.40053 #2134
	fsub %f2 %f0 %f1 #2134
	addi %a6 %zero 0 #2135
	li %f0 l.37367 #2135
	li %f1 l.37367 #2135
	sw %a11 %sp 0 #2135
	sw %a0 %sp 4 #2135
	sw %a3 %sp 8 #2135
	sw %f3 %sp 16 #2135
	sw %a1 %sp 24 #2135
	sw %a4 %sp 28 #2135
	sw %a2 %sp 32 #2135
	sw %a5 %sp 36 #2135
	add %a0 %a6 %zero
	add %a11 %a4 %zero
	sw %ra %sp 44 #2135 call cls
	lw %a10 %a11 0 #2135
	addi %sp %sp 48 #2135	
	jalr %ra %a10 0 #2135
	addi %sp %sp -48 #2135
	lw %ra %sp 44 #2135
	lw %a0 %sp 36 #2137
	itof %f0 %a0 #2137
	li %f1 l.40051 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.38835 #2137
	fadd %f2 %f0 %f1 #2137
	addi %a0 %zero 0 #2138
	li %f0 l.37367 #2138
	li %f1 l.37367 #2138
	lw %a1 %sp 32 #2138
	addi %a2 %a1 2 #2138
	lw %f3 %sp 16 #2138
	lw %a3 %sp 24 #2138
	lw %a11 %sp 28 #2138
	add %a1 %a3 %zero
	sw %ra %sp 44 #2138 call cls
	lw %a10 %a11 0 #2138
	addi %sp %sp 48 #2138	
	jalr %ra %a10 0 #2138
	addi %sp %sp -48 #2138
	lw %ra %sp 44 #2138
	addi %a0 %zero 3 #2140
	lw %a1 %sp 24 #123
	addi %a2 %a1 1 #123
	addi %a12 %zero 5
	blt %a2 %a12 bge_else.45971 # nontail if
	addi %a2 %a2 -5 #124
	jal %zero bge_cont.45972 # then sentence ends
bge_else.45971:
bge_cont.45972:
	lw %f0 %sp 16 #2140
	lw %a3 %sp 32 #2140
	lw %a11 %sp 8 #2140
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 44 #2140 call cls
	lw %a10 %a11 0 #2140
	addi %sp %sp 48 #2140	
	jalr %ra %a10 0 #2140
	addi %sp %sp -48 #2140
	lw %ra %sp 44 #2140
	lw %a0 %sp 4 #2149
	addi %a0 %a0 -1 #2149
	lw %a1 %sp 24 #123
	addi %a1 %a1 2 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.45973 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.45974 # then sentence ends
bge_else.45973:
bge_cont.45974:
	lw %a2 %sp 32 #2149
	addi %a2 %a2 4 #2149
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45975
	itof %f0 %a0 #2147
	li %f1 l.40051 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.40053 #2147
	fsub %f0 %f0 %f1 #2147
	addi %a3 %zero 4 #2148
	lw %a11 %sp 8 #2148
	sw %a2 %sp 40 #2148
	sw %a1 %sp 44 #2148
	sw %a0 %sp 48 #2148
	add %a0 %a3 %zero
	sw %ra %sp 52 #2148 call cls
	lw %a10 %a11 0 #2148
	addi %sp %sp 56 #2148	
	jalr %ra %a10 0 #2148
	addi %sp %sp -56 #2148
	lw %ra %sp 52 #2148
	lw %a0 %sp 48 #2149
	addi %a0 %a0 -1 #2149
	lw %a1 %sp 44 #123
	addi %a1 %a1 2 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.45976 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.45977 # then sentence ends
bge_else.45976:
bge_cont.45977:
	lw %a2 %sp 40 #2149
	addi %a2 %a2 4 #2149
	lw %a11 %sp 0 #2149
	lw %a10 %a11 0 #2149
	jalr %zero %a10 0 #2149
bge_else.45975:
	jalr %zero %ra 0 #2150
bge_else.45969:
	jalr %zero %ra 0 #2150
create_dirvec_elements.2918:
	lw %a2 %a11 4 #2162
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45980
	addi %a3 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a11 %sp 0 #2157
	sw %a0 %sp 4 #2157
	sw %a1 %sp 8 #2157
	sw %a2 %sp 12 #2157
	add %a0 %a3 %zero
	sw %ra %sp 20 #2157 call dir
	addi %sp %sp 24 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -24 #2157
	lw %ra %sp 20 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 16 #2158
	add %a0 %a2 %zero
	sw %ra %sp 20 #2158 call dir
	addi %sp %sp 24 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -24 #2158
	lw %ra %sp 20 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 16 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 8 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a0 %a1 -1 #2165
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45981
	addi %a1 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 20 #2157
	add %a0 %a1 %zero
	sw %ra %sp 28 #2157 call dir
	addi %sp %sp 32 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -32 #2157
	lw %ra %sp 28 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 24 #2158
	add %a0 %a2 %zero
	sw %ra %sp 28 #2158 call dir
	addi %sp %sp 32 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -32 #2158
	lw %ra %sp 28 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 24 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 20 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a0 %a1 -1 #2165
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45982
	addi %a1 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 28 #2157
	add %a0 %a1 %zero
	sw %ra %sp 36 #2157 call dir
	addi %sp %sp 40 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -40 #2157
	lw %ra %sp 36 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 32 #2158
	add %a0 %a2 %zero
	sw %ra %sp 36 #2158 call dir
	addi %sp %sp 40 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -40 #2158
	lw %ra %sp 36 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 32 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a0 %a1 -1 #2165
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45983
	addi %a1 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 36 #2157
	add %a0 %a1 %zero
	sw %ra %sp 44 #2157 call dir
	addi %sp %sp 48 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -48 #2157
	lw %ra %sp 44 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a0 %a0 0 #15
	sw %a1 %sp 40 #2158
	sw %ra %sp 44 #2158 call dir
	addi %sp %sp 48 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -48 #2158
	lw %ra %sp 44 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 40 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 36 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a1 %a1 -1 #2165
	lw %a11 %sp 0 #2165
	add %a0 %a3 %zero
	lw %a10 %a11 0 #2165
	jalr %zero %a10 0 #2165
bge_else.45983:
	jalr %zero %ra 0 #2166
bge_else.45982:
	jalr %zero %ra 0 #2166
bge_else.45981:
	jalr %zero %ra 0 #2166
bge_else.45980:
	jalr %zero %ra 0 #2166
create_dirvecs.2921:
	lw %a1 %a11 12 #2169
	lw %a2 %a11 8 #2169
	lw %a3 %a11 4 #2169
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45988
	addi %a4 %zero 120 #2171
	addi %a5 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a11 %sp 0 #2157
	sw %a3 %sp 4 #2157
	sw %a2 %sp 8 #2157
	sw %a0 %sp 12 #2157
	sw %a4 %sp 16 #2157
	sw %a1 %sp 20 #2157
	add %a0 %a5 %zero
	sw %ra %sp 28 #2157 call dir
	addi %sp %sp 32 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -32 #2157
	lw %ra %sp 28 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 24 #2158
	add %a0 %a2 %zero
	sw %ra %sp 28 #2158 call dir
	addi %sp %sp 32 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -32 #2158
	lw %ra %sp 28 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 24 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 16 #2171
	sw %ra %sp 28 #2171 call dir
	addi %sp %sp 32 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -32 #2171
	lw %ra %sp 28 #2171
	lw %a1 %sp 12 #2171
	slli %a2 %a1 2 #2171
	lw %a3 %sp 8 #2171
	add %a12 %a3 %a2 #2171
	sw %a0 %a12 0 #2171
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	addi %a2 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 28 #2157
	add %a0 %a2 %zero
	sw %ra %sp 36 #2157 call dir
	addi %sp %sp 40 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -40 #2157
	lw %ra %sp 36 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 32 #2158
	add %a0 %a2 %zero
	sw %ra %sp 36 #2158 call dir
	addi %sp %sp 40 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -40 #2158
	lw %ra %sp 36 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 32 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %ra %sp 36 #2157 call dir
	addi %sp %sp 40 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -40 #2157
	lw %ra %sp 36 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 36 #2158
	add %a0 %a2 %zero
	sw %ra %sp 44 #2158 call dir
	addi %sp %sp 48 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -48 #2158
	lw %ra %sp 44 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 36 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	sw %a0 %a1 468 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %ra %sp 44 #2157 call dir
	addi %sp %sp 48 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -48 #2157
	lw %ra %sp 44 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 40 #2158
	add %a0 %a2 %zero
	sw %ra %sp 44 #2158 call dir
	addi %sp %sp 48 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -48 #2158
	lw %ra %sp 44 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 40 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	sw %a0 %a1 464 #2164
	addi %a0 %zero 115 #2165
	lw %a11 %sp 4 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 44 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 48 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -48 #2165
	lw %ra %sp 44 #2165
	lw %a0 %sp 12 #2173
	addi %a0 %a0 -1 #2173
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45989
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 44 #2157
	sw %a1 %sp 48 #2157
	add %a0 %a2 %zero
	sw %ra %sp 52 #2157 call dir
	addi %sp %sp 56 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -56 #2157
	lw %ra %sp 52 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 52 #2158
	add %a0 %a2 %zero
	sw %ra %sp 60 #2158 call dir
	addi %sp %sp 64 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -64 #2158
	lw %ra %sp 60 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 52 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 48 #2171
	sw %ra %sp 60 #2171 call dir
	addi %sp %sp 64 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -64 #2171
	lw %ra %sp 60 #2171
	lw %a1 %sp 44 #2171
	slli %a2 %a1 2 #2171
	lw %a3 %sp 8 #2171
	add %a12 %a3 %a2 #2171
	sw %a0 %a12 0 #2171
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	addi %a2 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 56 #2157
	add %a0 %a2 %zero
	sw %ra %sp 60 #2157 call dir
	addi %sp %sp 64 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -64 #2157
	lw %ra %sp 60 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 60 #2158
	add %a0 %a2 %zero
	sw %ra %sp 68 #2158 call dir
	addi %sp %sp 72 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -72 #2158
	lw %ra %sp 68 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 60 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 56 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %ra %sp 68 #2157 call dir
	addi %sp %sp 72 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -72 #2157
	lw %ra %sp 68 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 64 #2158
	add %a0 %a2 %zero
	sw %ra %sp 68 #2158 call dir
	addi %sp %sp 72 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -72 #2158
	lw %ra %sp 68 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 64 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 56 #2164
	sw %a0 %a1 468 #2164
	addi %a0 %zero 116 #2165
	lw %a11 %sp 4 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 68 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 72 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -72 #2165
	lw %ra %sp 68 #2165
	lw %a0 %sp 44 #2173
	addi %a0 %a0 -1 #2173
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45990
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 68 #2157
	sw %a1 %sp 72 #2157
	add %a0 %a2 %zero
	sw %ra %sp 76 #2157 call dir
	addi %sp %sp 80 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -80 #2157
	lw %ra %sp 76 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 76 #2158
	add %a0 %a2 %zero
	sw %ra %sp 84 #2158 call dir
	addi %sp %sp 88 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -88 #2158
	lw %ra %sp 84 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 76 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 72 #2171
	sw %ra %sp 84 #2171 call dir
	addi %sp %sp 88 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -88 #2171
	lw %ra %sp 84 #2171
	lw %a1 %sp 68 #2171
	slli %a2 %a1 2 #2171
	lw %a3 %sp 8 #2171
	add %a12 %a3 %a2 #2171
	sw %a0 %a12 0 #2171
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	addi %a2 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 80 #2157
	add %a0 %a2 %zero
	sw %ra %sp 84 #2157 call dir
	addi %sp %sp 88 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -88 #2157
	lw %ra %sp 84 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 84 #2158
	add %a0 %a2 %zero
	sw %ra %sp 92 #2158 call dir
	addi %sp %sp 96 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -96 #2158
	lw %ra %sp 92 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 84 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 80 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 117 #2165
	lw %a11 %sp 4 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 92 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 96 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -96 #2165
	lw %ra %sp 92 #2165
	lw %a0 %sp 68 #2173
	addi %a0 %a0 -1 #2173
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45991
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 88 #2157
	sw %a1 %sp 92 #2157
	add %a0 %a2 %zero
	sw %ra %sp 100 #2157 call dir
	addi %sp %sp 104 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -104 #2157
	lw %ra %sp 100 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a0 %a0 0 #15
	sw %a1 %sp 96 #2158
	sw %ra %sp 100 #2158 call dir
	addi %sp %sp 104 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -104 #2158
	lw %ra %sp 100 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 96 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 92 #2171
	sw %ra %sp 100 #2171 call dir
	addi %sp %sp 104 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -104 #2171
	lw %ra %sp 100 #2171
	lw %a1 %sp 88 #2171
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
	sw %ra %sp 100 #2172 call cls
	lw %a10 %a11 0 #2172
	addi %sp %sp 104 #2172	
	jalr %ra %a10 0 #2172
	addi %sp %sp -104 #2172
	lw %ra %sp 100 #2172
	lw %a0 %sp 88 #2173
	addi %a0 %a0 -1 #2173
	lw %a11 %sp 0 #2173
	lw %a10 %a11 0 #2173
	jalr %zero %a10 0 #2173
bge_else.45991:
	jalr %zero %ra 0 #2174
bge_else.45990:
	jalr %zero %ra 0 #2174
bge_else.45989:
	jalr %zero %ra 0 #2174
bge_else.45988:
	jalr %zero %ra 0 #2174
init_dirvec_constants.2923:
	lw %a2 %a11 12 #2179
	lw %a3 %a11 8 #2179
	lw %a4 %a11 4 #2179
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.45996
	slli %a5 %a1 2 #2181
	add %a12 %a0 %a5 #2181
	lw %a5 %a12 0 #2181
	lw %a6 %a3 0 #15
	addi %a6 %a6 -1 #1121
	sw %a11 %sp 0 #1121
	sw %a4 %sp 4 #1121
	sw %a2 %sp 8 #1121
	sw %a3 %sp 12 #1121
	sw %a0 %sp 16 #1121
	sw %a1 %sp 20 #1121
	add %a1 %a6 %zero
	add %a0 %a5 %zero
	add %a11 %a4 %zero
	sw %ra %sp 28 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 32 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -32 #1121
	lw %ra %sp 28 #1121
	lw %a0 %sp 20 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.45997
	slli %a1 %a0 2 #2181
	lw %a2 %sp 16 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a3 %sp 12 #15
	lw %a4 %a3 0 #15
	addi %a4 %a4 -1 #1121
	sw %a0 %sp 24 #1104
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.45998 # nontail if
	slli %a5 %a4 2 #20
	lw %a6 %sp 8 #20
	add %a12 %a6 %a5 #20
	lw %a5 %a12 0 #20
	lw %a7 %a1 4 #513
	lw %a8 %a1 0 #507
	lw %a9 %a5 4 #238
	sw %a1 %sp 28 #868
	addi %a12 %zero 1
	bne %a9 %a12 beq_else.46000 # nontail if
	sw %a7 %sp 32 #1110
	sw %a4 %sp 36 #1110
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	sw %ra %sp 44 #1110 call dir
	addi %sp %sp 48 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -48 #1110
	lw %ra %sp 44 #1110
	lw %a1 %sp 36 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 32 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.46001 # then sentence ends
beq_else.46000:
	addi %a12 %zero 2
	bne %a9 %a12 beq_else.46002 # nontail if
	sw %a7 %sp 32 #1112
	sw %a4 %sp 36 #1112
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	sw %ra %sp 44 #1112 call dir
	addi %sp %sp 48 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -48 #1112
	lw %ra %sp 44 #1112
	lw %a1 %sp 36 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 32 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.46003 # then sentence ends
beq_else.46002:
	sw %a7 %sp 32 #1114
	sw %a4 %sp 36 #1114
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	sw %ra %sp 44 #1114 call dir
	addi %sp %sp 48 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -48 #1114
	lw %ra %sp 44 #1114
	lw %a1 %sp 36 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 32 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.46003:
beq_cont.46001:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 28 #1116
	lw %a11 %sp 4 #1116
	sw %ra %sp 44 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 48 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -48 #1116
	lw %ra %sp 44 #1116
	jal %zero bge_cont.45999 # then sentence ends
bge_else.45998:
bge_cont.45999:
	lw %a0 %sp 24 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.46004
	slli %a1 %a0 2 #2181
	lw %a2 %sp 16 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a3 %sp 12 #15
	lw %a4 %a3 0 #15
	addi %a4 %a4 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a0 %sp 40 #1121
	add %a0 %a1 %zero
	add %a1 %a4 %zero
	sw %ra %sp 44 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 48 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -48 #1121
	lw %ra %sp 44 #1121
	lw %a0 %sp 40 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.46005
	slli %a1 %a0 2 #2181
	lw %a2 %sp 16 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a3 %sp 12 #15
	lw %a3 %a3 0 #15
	addi %a3 %a3 -1 #1121
	sw %a0 %sp 44 #1104
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.46006 # nontail if
	slli %a4 %a3 2 #20
	lw %a5 %sp 8 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	lw %a5 %a1 4 #513
	lw %a6 %a1 0 #507
	lw %a7 %a4 4 #238
	sw %a1 %sp 48 #868
	addi %a12 %zero 1
	bne %a7 %a12 beq_else.46008 # nontail if
	sw %a5 %sp 52 #1110
	sw %a3 %sp 56 #1110
	add %a1 %a4 %zero
	add %a0 %a6 %zero
	sw %ra %sp 60 #1110 call dir
	addi %sp %sp 64 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -64 #1110
	lw %ra %sp 60 #1110
	lw %a1 %sp 56 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 52 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.46009 # then sentence ends
beq_else.46008:
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.46010 # nontail if
	sw %a5 %sp 52 #1112
	sw %a3 %sp 56 #1112
	add %a1 %a4 %zero
	add %a0 %a6 %zero
	sw %ra %sp 60 #1112 call dir
	addi %sp %sp 64 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -64 #1112
	lw %ra %sp 60 #1112
	lw %a1 %sp 56 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 52 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.46011 # then sentence ends
beq_else.46010:
	sw %a5 %sp 52 #1114
	sw %a3 %sp 56 #1114
	add %a1 %a4 %zero
	add %a0 %a6 %zero
	sw %ra %sp 60 #1114 call dir
	addi %sp %sp 64 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -64 #1114
	lw %ra %sp 60 #1114
	lw %a1 %sp 56 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 52 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.46011:
beq_cont.46009:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 48 #1116
	lw %a11 %sp 4 #1116
	sw %ra %sp 60 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 64 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -64 #1116
	lw %ra %sp 60 #1116
	jal %zero bge_cont.46007 # then sentence ends
bge_else.46006:
bge_cont.46007:
	lw %a0 %sp 44 #2182
	addi %a1 %a0 -1 #2182
	lw %a0 %sp 16 #2182
	lw %a11 %sp 0 #2182
	lw %a10 %a11 0 #2182
	jalr %zero %a10 0 #2182
bge_else.46005:
	jalr %zero %ra 0 #2183
bge_else.46004:
	jalr %zero %ra 0 #2183
bge_else.45997:
	jalr %zero %ra 0 #2183
bge_else.45996:
	jalr %zero %ra 0 #2183
init_vecset_constants.2926:
	lw %a1 %a11 20 #2186
	lw %a2 %a11 16 #2186
	lw %a3 %a11 12 #2186
	lw %a4 %a11 8 #2186
	lw %a5 %a11 4 #2186
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.46016
	slli %a6 %a0 2 #81
	add %a12 %a5 %a6 #81
	lw %a6 %a12 0 #81
	lw %a7 %a6 476 #2181
	lw %a8 %a2 0 #15
	addi %a8 %a8 -1 #1121
	sw %a11 %sp 0 #1104
	sw %a5 %sp 4 #1104
	sw %a0 %sp 8 #1104
	sw %a4 %sp 12 #1104
	sw %a1 %sp 16 #1104
	sw %a3 %sp 20 #1104
	sw %a2 %sp 24 #1104
	sw %a6 %sp 28 #1104
	addi %a12 %zero 0
	blt %a8 %a12 bge_else.46017 # nontail if
	slli %a9 %a8 2 #20
	add %a12 %a1 %a9 #20
	lw %a9 %a12 0 #20
	lw %a10 %a7 4 #513
	lw %a11 %a7 0 #507
	lw %a5 %a9 4 #238
	sw %a7 %sp 32 #868
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.46019 # nontail if
	sw %a10 %sp 36 #1110
	sw %a8 %sp 40 #1110
	add %a1 %a9 %zero
	add %a0 %a11 %zero
	sw %ra %sp 44 #1110 call dir
	addi %sp %sp 48 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -48 #1110
	lw %ra %sp 44 #1110
	lw %a1 %sp 40 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 36 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.46020 # then sentence ends
beq_else.46019:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.46021 # nontail if
	sw %a10 %sp 36 #1112
	sw %a8 %sp 40 #1112
	add %a1 %a9 %zero
	add %a0 %a11 %zero
	sw %ra %sp 44 #1112 call dir
	addi %sp %sp 48 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -48 #1112
	lw %ra %sp 44 #1112
	lw %a1 %sp 40 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 36 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.46022 # then sentence ends
beq_else.46021:
	sw %a10 %sp 36 #1114
	sw %a8 %sp 40 #1114
	add %a1 %a9 %zero
	add %a0 %a11 %zero
	sw %ra %sp 44 #1114 call dir
	addi %sp %sp 48 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -48 #1114
	lw %ra %sp 44 #1114
	lw %a1 %sp 40 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 36 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.46022:
beq_cont.46020:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 32 #1116
	lw %a11 %sp 20 #1116
	sw %ra %sp 44 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 48 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -48 #1116
	lw %ra %sp 44 #1116
	jal %zero bge_cont.46018 # then sentence ends
bge_else.46017:
bge_cont.46018:
	lw %a0 %sp 28 #2181
	lw %a1 %a0 472 #2181
	lw %a2 %sp 24 #15
	lw %a3 %a2 0 #15
	addi %a3 %a3 -1 #1121
	lw %a11 %sp 20 #1121
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 44 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 48 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -48 #1121
	lw %ra %sp 44 #1121
	lw %a0 %sp 28 #2181
	lw %a1 %a0 468 #2181
	lw %a2 %sp 24 #15
	lw %a3 %a2 0 #15
	addi %a3 %a3 -1 #1121
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.46023 # nontail if
	slli %a4 %a3 2 #20
	lw %a5 %sp 16 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	lw %a6 %a1 4 #513
	lw %a7 %a1 0 #507
	lw %a8 %a4 4 #238
	sw %a1 %sp 44 #868
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.46025 # nontail if
	sw %a6 %sp 48 #1110
	sw %a3 %sp 52 #1110
	add %a1 %a4 %zero
	add %a0 %a7 %zero
	sw %ra %sp 60 #1110 call dir
	addi %sp %sp 64 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -64 #1110
	lw %ra %sp 60 #1110
	lw %a1 %sp 52 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 48 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.46026 # then sentence ends
beq_else.46025:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.46027 # nontail if
	sw %a6 %sp 48 #1112
	sw %a3 %sp 52 #1112
	add %a1 %a4 %zero
	add %a0 %a7 %zero
	sw %ra %sp 60 #1112 call dir
	addi %sp %sp 64 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -64 #1112
	lw %ra %sp 60 #1112
	lw %a1 %sp 52 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 48 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.46028 # then sentence ends
beq_else.46027:
	sw %a6 %sp 48 #1114
	sw %a3 %sp 52 #1114
	add %a1 %a4 %zero
	add %a0 %a7 %zero
	sw %ra %sp 60 #1114 call dir
	addi %sp %sp 64 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -64 #1114
	lw %ra %sp 60 #1114
	lw %a1 %sp 52 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 48 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.46028:
beq_cont.46026:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 44 #1116
	lw %a11 %sp 20 #1116
	sw %ra %sp 60 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 64 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -64 #1116
	lw %ra %sp 60 #1116
	jal %zero bge_cont.46024 # then sentence ends
bge_else.46023:
bge_cont.46024:
	addi %a1 %zero 116 #2182
	lw %a0 %sp 28 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 60 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 64 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -64 #2182
	lw %ra %sp 60 #2182
	lw %a0 %sp 8 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.46029
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	lw %a3 %a1 476 #2181
	lw %a4 %sp 24 #15
	lw %a5 %a4 0 #15
	addi %a5 %a5 -1 #1121
	lw %a11 %sp 20 #1121
	sw %a0 %sp 56 #1121
	sw %a1 %sp 60 #1121
	add %a1 %a5 %zero
	add %a0 %a3 %zero
	sw %ra %sp 68 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 72 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -72 #1121
	lw %ra %sp 68 #1121
	lw %a0 %sp 60 #2181
	lw %a1 %a0 472 #2181
	lw %a2 %sp 24 #15
	lw %a3 %a2 0 #15
	addi %a3 %a3 -1 #1121
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.46030 # nontail if
	slli %a4 %a3 2 #20
	lw %a5 %sp 16 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	lw %a6 %a1 4 #513
	lw %a7 %a1 0 #507
	lw %a8 %a4 4 #238
	sw %a1 %sp 64 #868
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.46032 # nontail if
	sw %a6 %sp 68 #1110
	sw %a3 %sp 72 #1110
	add %a1 %a4 %zero
	add %a0 %a7 %zero
	sw %ra %sp 76 #1110 call dir
	addi %sp %sp 80 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -80 #1110
	lw %ra %sp 76 #1110
	lw %a1 %sp 72 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 68 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.46033 # then sentence ends
beq_else.46032:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.46034 # nontail if
	sw %a6 %sp 68 #1112
	sw %a3 %sp 72 #1112
	add %a1 %a4 %zero
	add %a0 %a7 %zero
	sw %ra %sp 76 #1112 call dir
	addi %sp %sp 80 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -80 #1112
	lw %ra %sp 76 #1112
	lw %a1 %sp 72 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 68 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.46035 # then sentence ends
beq_else.46034:
	sw %a6 %sp 68 #1114
	sw %a3 %sp 72 #1114
	add %a1 %a4 %zero
	add %a0 %a7 %zero
	sw %ra %sp 76 #1114 call dir
	addi %sp %sp 80 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -80 #1114
	lw %ra %sp 76 #1114
	lw %a1 %sp 72 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 68 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.46035:
beq_cont.46033:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 64 #1116
	lw %a11 %sp 20 #1116
	sw %ra %sp 76 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 80 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -80 #1116
	lw %ra %sp 76 #1116
	jal %zero bge_cont.46031 # then sentence ends
bge_else.46030:
bge_cont.46031:
	addi %a1 %zero 117 #2182
	lw %a0 %sp 60 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 76 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 80 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -80 #2182
	lw %ra %sp 76 #2182
	lw %a0 %sp 56 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.46036
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	lw %a3 %a1 476 #2181
	lw %a4 %sp 24 #15
	lw %a4 %a4 0 #15
	addi %a4 %a4 -1 #1121
	sw %a0 %sp 76 #1104
	sw %a1 %sp 80 #1104
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.46037 # nontail if
	slli %a5 %a4 2 #20
	lw %a6 %sp 16 #20
	add %a12 %a6 %a5 #20
	lw %a5 %a12 0 #20
	lw %a6 %a3 4 #513
	lw %a7 %a3 0 #507
	lw %a8 %a5 4 #238
	sw %a3 %sp 84 #868
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.46039 # nontail if
	sw %a6 %sp 88 #1110
	sw %a4 %sp 92 #1110
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 100 #1110 call dir
	addi %sp %sp 104 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -104 #1110
	lw %ra %sp 100 #1110
	lw %a1 %sp 92 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 88 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.46040 # then sentence ends
beq_else.46039:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.46041 # nontail if
	sw %a6 %sp 88 #1112
	sw %a4 %sp 92 #1112
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 100 #1112 call dir
	addi %sp %sp 104 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -104 #1112
	lw %ra %sp 100 #1112
	lw %a1 %sp 92 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 88 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.46042 # then sentence ends
beq_else.46041:
	sw %a6 %sp 88 #1114
	sw %a4 %sp 92 #1114
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 100 #1114 call dir
	addi %sp %sp 104 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -104 #1114
	lw %ra %sp 100 #1114
	lw %a1 %sp 92 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 88 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.46042:
beq_cont.46040:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 84 #1116
	lw %a11 %sp 20 #1116
	sw %ra %sp 100 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 104 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -104 #1116
	lw %ra %sp 100 #1116
	jal %zero bge_cont.46038 # then sentence ends
bge_else.46037:
bge_cont.46038:
	addi %a1 %zero 118 #2182
	lw %a0 %sp 80 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 100 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 104 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -104 #2182
	lw %ra %sp 100 #2182
	lw %a0 %sp 76 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.46043
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	addi %a2 %zero 119 #2188
	lw %a11 %sp 12 #2188
	sw %a0 %sp 96 #2188
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 100 #2188 call cls
	lw %a10 %a11 0 #2188
	addi %sp %sp 104 #2188	
	jalr %ra %a10 0 #2188
	addi %sp %sp -104 #2188
	lw %ra %sp 100 #2188
	lw %a0 %sp 96 #2189
	addi %a0 %a0 -1 #2189
	lw %a11 %sp 0 #2189
	lw %a10 %a11 0 #2189
	jalr %zero %a10 0 #2189
bge_else.46043:
	jalr %zero %ra 0 #2190
bge_else.46036:
	jalr %zero %ra 0 #2190
bge_else.46029:
	jalr %zero %ra 0 #2190
bge_else.46016:
	jalr %zero %ra 0 #2190
setup_reflections.2943:
	lw %a1 %a11 24 #2240
	lw %a2 %a11 20 #2240
	lw %a3 %a11 16 #2240
	lw %a4 %a11 12 #2240
	lw %a5 %a11 8 #2240
	lw %a6 %a11 4 #2240
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.46048
	slli %a7 %a0 2 #20
	add %a12 %a2 %a7 #20
	lw %a2 %a12 0 #20
	lw %a7 %a2 8 #248
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.46049
	lw %a7 %a2 28 #346
	lw %f0 %a7 0 #351
	li %f1 l.37441 #2244
	fless %a7 %f0 %f1 #2244
	addi %a12 %zero 0
	bne %a7 %a12 beq_else.46050
	jalr %zero %ra 0 #2252
beq_else.46050:
	lw %a7 %a2 4 #238
	addi %a12 %zero 1
	bne %a7 %a12 beq_else.46052
	addi %a7 %zero 4 #2212
	sw %a1 %sp 0 #2212
	sw %a6 %sp 4 #2212
	sw %a4 %sp 8 #2212
	sw %a5 %sp 12 #2212
	sw %a2 %sp 16 #2212
	sw %a3 %sp 20 #2212
	add %a1 %a7 %zero
	sw %ra %sp 28 #2212 call dir
	addi %sp %sp 32 #2212	
	jal %ra min_caml_sll #2212
	addi %sp %sp -32 #2212
	lw %ra %sp 28 #2212
	lw %a1 %sp 20 #99
	lw %a2 %a1 0 #99
	li %f0 l.37441 #2214
	lw %a3 %sp 16 #346
	lw %a3 %a3 28 #346
	lw %f1 %a3 0 #351
	fsub %f0 %f0 %f1 #2214
	lw %a3 %sp 12 #27
	lw %f1 %a3 0 #27
	fneg %f1 %f1 #2215
	lw %f2 %a3 4 #27
	fneg %f2 %f2 #2216
	lw %f3 %a3 8 #27
	fneg %f3 %f3 #2217
	addi %a4 %a0 1 #2218
	lw %f4 %a3 0 #27
	addi %a5 %zero 3 #2157
	li %f5 l.37367 #2157
	sw %f1 %sp 24 #2157
	sw %a0 %sp 32 #2157
	sw %a2 %sp 36 #2157
	sw %a4 %sp 40 #2157
	sw %f0 %sp 48 #2157
	sw %f3 %sp 56 #2157
	sw %f2 %sp 64 #2157
	sw %f4 %sp 72 #2157
	add %a0 %a5 %zero
	fadd %f0 %f5 %fzero
	sw %ra %sp 84 #2157 call dir
	addi %sp %sp 88 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -88 #2157
	lw %ra %sp 84 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 80 #2158
	add %a0 %a2 %zero
	sw %ra %sp 84 #2158 call dir
	addi %sp %sp 88 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -88 #2158
	lw %ra %sp 84 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 80 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 72 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 64 #134
	sw %f0 %a0 4 #134
	lw %f1 %sp 56 #135
	sw %f1 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	addi %a2 %a2 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 84 #1121
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 92 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 96 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -96 #1121
	lw %ra %sp 92 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 48 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 84 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 40 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 36 #2207
	slli %a2 %a1 2 #2207
	lw %a3 %sp 0 #2207
	add %a12 %a3 %a2 #2207
	sw %a0 %a12 0 #2207
	addi %a0 %a1 1 #2219
	lw %a2 %sp 32 #2219
	addi %a4 %a2 2 #2219
	lw %a5 %sp 12 #27
	lw %f1 %a5 4 #27
	addi %a6 %zero 3 #2157
	li %f2 l.37367 #2157
	sw %a0 %sp 88 #2157
	sw %a4 %sp 92 #2157
	sw %f1 %sp 96 #2157
	add %a0 %a6 %zero
	fadd %f0 %f2 %fzero
	sw %ra %sp 108 #2157 call dir
	addi %sp %sp 112 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -112 #2157
	lw %ra %sp 108 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 104 #2158
	add %a0 %a2 %zero
	sw %ra %sp 108 #2158 call dir
	addi %sp %sp 112 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -112 #2158
	lw %ra %sp 108 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 104 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 24 #133
	sw %f0 %a0 0 #133
	lw %f1 %sp 96 #134
	sw %f1 %a0 4 #134
	lw %f1 %sp 56 #135
	sw %f1 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	addi %a2 %a2 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 108 #1121
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 116 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 120 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -120 #1121
	lw %ra %sp 116 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 48 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 108 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 92 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 88 #2207
	slli %a1 %a1 2 #2207
	lw %a2 %sp 0 #2207
	add %a12 %a2 %a1 #2207
	sw %a0 %a12 0 #2207
	lw %a0 %sp 36 #2220
	addi %a1 %a0 2 #2220
	lw %a3 %sp 32 #2220
	addi %a3 %a3 3 #2220
	lw %a4 %sp 12 #27
	lw %f1 %a4 8 #27
	addi %a4 %zero 3 #2157
	li %f2 l.37367 #2157
	sw %a1 %sp 112 #2157
	sw %a3 %sp 116 #2157
	sw %f1 %sp 120 #2157
	add %a0 %a4 %zero
	fadd %f0 %f2 %fzero
	sw %ra %sp 132 #2157 call dir
	addi %sp %sp 136 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -136 #2157
	lw %ra %sp 132 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 128 #2158
	add %a0 %a2 %zero
	sw %ra %sp 132 #2158 call dir
	addi %sp %sp 136 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -136 #2158
	lw %ra %sp 132 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 128 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 24 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 64 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 120 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 132 #1121
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 140 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 144 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -144 #1121
	lw %ra %sp 140 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 48 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 132 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 116 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 112 #2207
	slli %a1 %a1 2 #2207
	lw %a2 %sp 0 #2207
	add %a12 %a2 %a1 #2207
	sw %a0 %a12 0 #2207
	lw %a0 %sp 36 #2221
	addi %a0 %a0 3 #2221
	lw %a1 %sp 20 #2221
	sw %a0 %a1 0 #2221
	jalr %zero %ra 0 #2221
beq_else.46052:
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.46055
	addi %a7 %zero 4 #2226
	sw %a1 %sp 0 #2226
	sw %a6 %sp 4 #2226
	sw %a4 %sp 8 #2226
	sw %a5 %sp 12 #2226
	sw %a2 %sp 16 #2226
	sw %a3 %sp 20 #2226
	add %a1 %a7 %zero
	sw %ra %sp 140 #2226 call dir
	addi %sp %sp 144 #2226	
	jal %ra min_caml_sll #2226
	addi %sp %sp -144 #2226
	lw %ra %sp 140 #2226
	addi %a0 %a0 1 #2226
	lw %a1 %sp 20 #99
	lw %a2 %a1 0 #99
	li %f0 l.37441 #2228
	lw %a3 %sp 16 #346
	lw %a4 %a3 28 #346
	lw %f1 %a4 0 #351
	fsub %f0 %f0 %f1 #2228
	lw %a4 %a3 16 #306
	lw %a5 %sp 12 #181
	lw %f1 %a5 0 #181
	lw %f2 %a4 0 #181
	fmul %f1 %f1 %f2 #181
	lw %f2 %a5 4 #181
	lw %f3 %a4 4 #181
	fmul %f2 %f2 %f3 #181
	fadd %f1 %f1 %f2 #181
	lw %f2 %a5 8 #181
	lw %f3 %a4 8 #181
	fmul %f2 %f2 %f3 #181
	fadd %f1 %f1 %f2 #181
	li %f2 l.37395 #2232
	lw %a4 %a3 16 #276
	lw %f3 %a4 0 #281
	fmul %f2 %f2 %f3 #2232
	fmul %f2 %f2 %f1 #2232
	lw %f3 %a5 0 #27
	fsub %f2 %f2 %f3 #2232
	li %f3 l.37395 #2233
	lw %a4 %a3 16 #286
	lw %f4 %a4 4 #291
	fmul %f3 %f3 %f4 #2233
	fmul %f3 %f3 %f1 #2233
	lw %f4 %a5 4 #27
	fsub %f3 %f3 %f4 #2233
	li %f4 l.37395 #2234
	lw %a3 %a3 16 #296
	lw %f5 %a3 8 #301
	fmul %f4 %f4 %f5 #2234
	fmul %f1 %f4 %f1 #2234
	lw %f4 %a5 8 #27
	fsub %f1 %f1 %f4 #2234
	addi %a3 %zero 3 #2157
	li %f4 l.37367 #2157
	sw %a2 %sp 136 #2157
	sw %a0 %sp 140 #2157
	sw %f0 %sp 144 #2157
	sw %f1 %sp 152 #2157
	sw %f3 %sp 160 #2157
	sw %f2 %sp 168 #2157
	add %a0 %a3 %zero
	fadd %f0 %f4 %fzero
	sw %ra %sp 180 #2157 call dir
	addi %sp %sp 184 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -184 #2157
	lw %ra %sp 180 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 176 #2158
	add %a0 %a2 %zero
	sw %ra %sp 180 #2158 call dir
	addi %sp %sp 184 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -184 #2158
	lw %ra %sp 180 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 176 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 168 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 160 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 152 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 180 #1121
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 188 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 192 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -192 #1121
	lw %ra %sp 188 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 144 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 180 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 140 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 136 #2207
	slli %a2 %a1 2 #2207
	lw %a3 %sp 0 #2207
	add %a12 %a3 %a2 #2207
	sw %a0 %a12 0 #2207
	addi %a0 %a1 1 #2235
	lw %a1 %sp 20 #2235
	sw %a0 %a1 0 #2235
	jalr %zero %ra 0 #2235
beq_else.46055:
	jalr %zero %ra 0 #2251
beq_else.46049:
	jalr %zero %ra 0 #2253
bge_else.46048:
	jalr %zero %ra 0 #2254
min_caml_start:
	li %sp 100000
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
	li %f0 l.37367 #19
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
	li %f0 l.37367 #23
	sw %a0 %sp 4 #23
	add %a0 %a1 %zero
	sw %ra %sp 12 #23 call dir
	addi %sp %sp 16 #23	
	jal %ra min_caml_create_float_array #23
	addi %sp %sp -16 #23
	lw %ra %sp 12 #23
	addi %a1 %zero 3 #25
	li %f0 l.37367 #25
	sw %a0 %sp 8 #25
	add %a0 %a1 %zero
	sw %ra %sp 12 #25 call dir
	addi %sp %sp 16 #25	
	jal %ra min_caml_create_float_array #25
	addi %sp %sp -16 #25
	lw %ra %sp 12 #25
	addi %a1 %zero 3 #27
	li %f0 l.37367 #27
	sw %a0 %sp 12 #27
	add %a0 %a1 %zero
	sw %ra %sp 20 #27 call dir
	addi %sp %sp 24 #27	
	jal %ra min_caml_create_float_array #27
	addi %sp %sp -24 #27
	lw %ra %sp 20 #27
	addi %a1 %zero 1 #29
	li %f0 l.38452 #29
	sw %a0 %sp 16 #29
	add %a0 %a1 %zero
	sw %ra %sp 20 #29 call dir
	addi %sp %sp 24 #29	
	jal %ra min_caml_create_float_array #29
	addi %sp %sp -24 #29
	lw %ra %sp 20 #29
	addi %a1 %zero 50 #31
	addi %a2 %zero 1 #31
	addi %a3 %zero -1 #31
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
	addi %a2 %zero 1 #33
	lw %a3 %a0 0 #31
	sw %a0 %sp 28 #33
	sw %a1 %sp 32 #33
	add %a1 %a3 %zero
	add %a0 %a2 %zero
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
	li %f0 l.37367 #37
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
	li %f0 l.38510 #41
	sw %a0 %sp 44 #41
	add %a0 %a1 %zero
	sw %ra %sp 52 #41 call dir
	addi %sp %sp 56 #41	
	jal %ra min_caml_create_float_array #41
	addi %sp %sp -56 #41
	lw %ra %sp 52 #41
	addi %a1 %zero 3 #43
	li %f0 l.37367 #43
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
	li %f0 l.37367 #47
	sw %a0 %sp 56 #47
	add %a0 %a1 %zero
	sw %ra %sp 60 #47 call dir
	addi %sp %sp 64 #47	
	jal %ra min_caml_create_float_array #47
	addi %sp %sp -64 #47
	lw %ra %sp 60 #47
	addi %a1 %zero 3 #49
	li %f0 l.37367 #49
	sw %a0 %sp 60 #49
	add %a0 %a1 %zero
	sw %ra %sp 68 #49 call dir
	addi %sp %sp 72 #49	
	jal %ra min_caml_create_float_array #49
	addi %sp %sp -72 #49
	lw %ra %sp 68 #49
	addi %a1 %zero 3 #52
	li %f0 l.37367 #52
	sw %a0 %sp 64 #52
	add %a0 %a1 %zero
	sw %ra %sp 68 #52 call dir
	addi %sp %sp 72 #52	
	jal %ra min_caml_create_float_array #52
	addi %sp %sp -72 #52
	lw %ra %sp 68 #52
	addi %a1 %zero 3 #54
	li %f0 l.37367 #54
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
	li %f0 l.37367 #61
	sw %a0 %sp 80 #61
	add %a0 %a1 %zero
	sw %ra %sp 84 #61 call dir
	addi %sp %sp 88 #61	
	jal %ra min_caml_create_float_array #61
	addi %sp %sp -88 #61
	lw %ra %sp 84 #61
	addi %a1 %zero 3 #64
	li %f0 l.37367 #64
	sw %a0 %sp 84 #64
	add %a0 %a1 %zero
	sw %ra %sp 92 #64 call dir
	addi %sp %sp 96 #64	
	jal %ra min_caml_create_float_array #64
	addi %sp %sp -96 #64
	lw %ra %sp 92 #64
	addi %a1 %zero 3 #66
	li %f0 l.37367 #66
	sw %a0 %sp 88 #66
	add %a0 %a1 %zero
	sw %ra %sp 92 #66 call dir
	addi %sp %sp 96 #66	
	jal %ra min_caml_create_float_array #66
	addi %sp %sp -96 #66
	lw %ra %sp 92 #66
	addi %a1 %zero 3 #69
	li %f0 l.37367 #69
	sw %a0 %sp 92 #69
	add %a0 %a1 %zero
	sw %ra %sp 100 #69 call dir
	addi %sp %sp 104 #69	
	jal %ra min_caml_create_float_array #69
	addi %sp %sp -104 #69
	lw %ra %sp 100 #69
	addi %a1 %zero 3 #70
	li %f0 l.37367 #70
	sw %a0 %sp 96 #70
	add %a0 %a1 %zero
	sw %ra %sp 100 #70 call dir
	addi %sp %sp 104 #70	
	jal %ra min_caml_create_float_array #70
	addi %sp %sp -104 #70
	lw %ra %sp 100 #70
	addi %a1 %zero 3 #71
	li %f0 l.37367 #71
	sw %a0 %sp 100 #71
	add %a0 %a1 %zero
	sw %ra %sp 108 #71 call dir
	addi %sp %sp 112 #71	
	jal %ra min_caml_create_float_array #71
	addi %sp %sp -112 #71
	lw %ra %sp 108 #71
	addi %a1 %zero 3 #74
	li %f0 l.37367 #74
	sw %a0 %sp 104 #74
	add %a0 %a1 %zero
	sw %ra %sp 108 #74 call dir
	addi %sp %sp 112 #74	
	jal %ra min_caml_create_float_array #74
	addi %sp %sp -112 #74
	lw %ra %sp 108 #74
	addi %a1 %zero 0 #78
	li %f0 l.37367 #78
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
	li %f0 l.37367 #85
	sw %a0 %sp 116 #85
	add %a0 %a1 %zero
	sw %ra %sp 124 #85 call dir
	addi %sp %sp 128 #85	
	jal %ra min_caml_create_float_array #85
	addi %sp %sp -128 #85
	lw %ra %sp 124 #85
	addi %a1 %zero 3 #86
	li %f0 l.37367 #86
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
	lw %a2 %sp 124 #88
	sw %a2 %a1 0 #88
	addi %a3 %zero 0 #92
	li %f0 l.37367 #92
	sw %a1 %sp 128 #92
	sw %a0 %sp 132 #92
	add %a0 %a3 %zero
	sw %ra %sp 140 #92 call dir
	addi %sp %sp 144 #92	
	jal %ra min_caml_create_float_array #92
	addi %sp %sp -144 #92
	lw %ra %sp 140 #92
	add %a1 %a0 %zero #92
	addi %a0 %zero 0 #93
	sw %a1 %sp 136 #93
	sw %ra %sp 140 #93 call dir
	addi %sp %sp 144 #93	
	jal %ra min_caml_create_array #93
	addi %sp %sp -144 #93
	lw %ra %sp 140 #93
	addi %a1 %min_caml_hp 0 #94
	addi %min_caml_hp %min_caml_hp 8 #94
	sw %a0 %a1 4 #94
	lw %a0 %sp 136 #94
	sw %a0 %a1 0 #94
	addi %a0 %a1 0 #94
	addi %a1 %zero 180 #95
	addi %a2 %zero 0 #95
	li %f0 l.37367 #95
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
	sw %a0 %sp 140 #99
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 148 #99 call dir
	addi %sp %sp 152 #99	
	jal %ra min_caml_create_array #99
	addi %sp %sp -152 #99
	lw %ra %sp 148 #99
	addi %a1 %min_caml_hp 0 #545
	addi %min_caml_hp %min_caml_hp 24 #545
	li %a2 read_screen_settings.2591 #545
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
	addi %a6 %min_caml_hp 0 #641
	addi %min_caml_hp %min_caml_hp 8 #641
	li %a7 read_nth_object.2598 #641
	sw %a7 %a6 0 #641
	lw %a7 %sp 4 #641
	sw %a7 %a6 4 #641
	addi %a8 %min_caml_hp 0 #724
	addi %min_caml_hp %min_caml_hp 16 #724
	li %a9 read_object.2600 #724
	sw %a9 %a8 0 #724
	sw %a6 %a8 8 #724
	lw %a9 %sp 0 #724
	sw %a9 %a8 4 #724
	addi %a10 %min_caml_hp 0 #757
	addi %min_caml_hp %min_caml_hp 8 #757
	li %a11 read_and_network.2608 #757
	sw %a11 %a10 0 #757
	lw %a11 %sp 28 #757
	sw %a11 %a10 4 #757
	addi %a4 %min_caml_hp 0 #766
	addi %min_caml_hp %min_caml_hp 40 #766
	li %a3 read_parameter.2610 #766
	sw %a3 %a4 0 #766
	sw %a1 %a4 36 #766
	sw %a8 %a4 32 #766
	sw %a6 %a4 28 #766
	sw %a10 %a4 24 #766
	lw %a1 %sp 36 #766
	sw %a1 %a4 20 #766
	sw %a9 %a4 16 #766
	lw %a3 %sp 16 #766
	sw %a3 %a4 12 #766
	lw %a6 %sp 20 #766
	sw %a6 %a4 8 #766
	sw %a11 %a4 4 #766
	addi %a8 %min_caml_hp 0 #797
	addi %min_caml_hp %min_caml_hp 8 #797
	li %a10 solver_rect.2621 #797
	sw %a10 %a8 0 #797
	lw %a10 %sp 40 #797
	sw %a10 %a8 4 #797
	sw %a4 %sp 144 #854
	addi %a4 %min_caml_hp 0 #854
	addi %min_caml_hp %min_caml_hp 8 #854
	li %a5 solver_second.2646 #854
	sw %a5 %a4 0 #854
	sw %a10 %a4 4 #854
	addi %a5 %min_caml_hp 0 #883
	addi %min_caml_hp %min_caml_hp 16 #883
	li %a2 solver.2652 #883
	sw %a2 %a5 0 #883
	sw %a10 %a5 8 #883
	sw %a7 %a5 4 #883
	addi %a2 %min_caml_hp 0 #900
	addi %min_caml_hp %min_caml_hp 8 #900
	li %a6 solver_rect_fast.2656 #900
	sw %a6 %a2 0 #900
	sw %a10 %a2 4 #900
	addi %a6 %min_caml_hp 0 #942
	addi %min_caml_hp %min_caml_hp 8 #942
	li %a9 solver_second_fast.2669 #942
	sw %a9 %a6 0 #942
	sw %a10 %a6 4 #942
	addi %a9 %min_caml_hp 0 #1009
	addi %min_caml_hp %min_caml_hp 16 #1009
	sw %a0 %sp 148 #1009
	li %a0 solver_fast2.2693 #1009
	sw %a0 %a9 0 #1009
	sw %a2 %a9 12 #1009
	sw %a10 %a9 8 #1009
	sw %a7 %a9 4 #1009
	addi %a0 %min_caml_hp 0 #1103
	addi %min_caml_hp %min_caml_hp 8 #1103
	li %a1 iter_setup_dirvec_constants.2705 #1103
	sw %a1 %a0 0 #1103
	sw %a7 %a0 4 #1103
	addi %a1 %min_caml_hp 0 #1126
	addi %min_caml_hp %min_caml_hp 8 #1126
	sw %a0 %sp 152 #1126
	li %a0 setup_startp_constants.2710 #1126
	sw %a0 %a1 0 #1126
	sw %a7 %a1 4 #1126
	addi %a0 %min_caml_hp 0 #1193
	addi %min_caml_hp %min_caml_hp 8 #1193
	sw %a1 %sp 156 #1193
	li %a1 check_all_inside.2735 #1193
	sw %a1 %a0 0 #1193
	sw %a7 %a0 4 #1193
	addi %a1 %min_caml_hp 0 #1211
	addi %min_caml_hp %min_caml_hp 40 #1211
	sw %a9 %sp 160 #1211
	li %a9 shadow_check_and_group.2741 #1211
	sw %a9 %a1 0 #1211
	lw %a9 %sp 124 #1211
	sw %a9 %a1 36 #1211
	sw %a6 %a1 32 #1211
	sw %a2 %a1 28 #1211
	sw %a10 %a1 24 #1211
	sw %a7 %a1 20 #1211
	sw %a3 %a1 16 #1211
	lw %a3 %sp 52 #1211
	sw %a3 %a1 12 #1211
	sw %a5 %sp 164 #1211
	lw %a5 %sp 132 #1211
	sw %a5 %a1 8 #1211
	sw %a0 %a1 4 #1211
	sw %a0 %sp 168 #1241
	addi %a0 %min_caml_hp 0 #1241
	addi %min_caml_hp %min_caml_hp 16 #1241
	sw %a8 %sp 172 #1241
	li %a8 shadow_check_one_or_group.2744 #1241
	sw %a8 %a0 0 #1241
	sw %a1 %a0 8 #1241
	sw %a11 %a0 4 #1241
	addi %a8 %min_caml_hp 0 #1256
	addi %min_caml_hp %min_caml_hp 48 #1256
	sw %a4 %sp 176 #1256
	li %a4 shadow_check_one_or_matrix.2747 #1256
	sw %a4 %a8 0 #1256
	sw %a9 %a8 40 #1256
	sw %a6 %a8 36 #1256
	sw %a2 %a8 32 #1256
	sw %a10 %a8 28 #1256
	sw %a0 %a8 24 #1256
	sw %a1 %a8 20 #1256
	sw %a7 %a8 16 #1256
	sw %a3 %a8 12 #1256
	sw %a5 %a8 8 #1256
	sw %a11 %a8 4 #1256
	addi %a4 %min_caml_hp 0 #1290
	addi %min_caml_hp %min_caml_hp 48 #1290
	li %a5 solve_each_element.2750 #1290
	sw %a5 %a4 0 #1290
	lw %a5 %sp 48 #1290
	sw %a5 %a4 40 #1290
	sw %a1 %sp 180 #1290
	lw %a1 %sp 88 #1290
	sw %a1 %a4 36 #1290
	sw %a0 %sp 184 #1290
	lw %a0 %sp 176 #1290
	sw %a0 %a4 32 #1290
	sw %a8 %sp 188 #1290
	lw %a8 %sp 172 #1290
	sw %a8 %a4 28 #1290
	sw %a10 %a4 24 #1290
	sw %a7 %a4 20 #1290
	sw %a6 %sp 192 #1290
	lw %a6 %sp 44 #1290
	sw %a6 %a4 16 #1290
	sw %a3 %a4 12 #1290
	lw %a9 %sp 56 #1290
	sw %a9 %a4 8 #1290
	lw %a9 %sp 168 #1290
	sw %a9 %a4 4 #1290
	addi %a9 %min_caml_hp 0 #1331
	addi %min_caml_hp %min_caml_hp 16 #1331
	li %a3 solve_one_or_network.2754 #1331
	sw %a3 %a9 0 #1331
	sw %a4 %a9 8 #1331
	sw %a11 %a9 4 #1331
	addi %a3 %min_caml_hp 0 #1341
	addi %min_caml_hp %min_caml_hp 48 #1341
	li %a6 trace_or_matrix.2758 #1341
	sw %a6 %a3 0 #1341
	sw %a5 %a3 40 #1341
	sw %a1 %a3 36 #1341
	sw %a0 %a3 32 #1341
	sw %a8 %a3 28 #1341
	sw %a10 %a3 24 #1341
	lw %a0 %sp 164 #1341
	sw %a0 %a3 20 #1341
	sw %a9 %a3 16 #1341
	sw %a4 %a3 12 #1341
	sw %a7 %a3 8 #1341
	sw %a11 %a3 4 #1341
	addi %a0 %min_caml_hp 0 #1381
	addi %min_caml_hp %min_caml_hp 40 #1381
	li %a4 solve_each_element_fast.2764 #1381
	sw %a4 %a0 0 #1381
	sw %a5 %a0 36 #1381
	lw %a4 %sp 92 #1381
	sw %a4 %a0 32 #1381
	sw %a2 %a0 28 #1381
	sw %a10 %a0 24 #1381
	sw %a7 %a0 20 #1381
	lw %a6 %sp 44 #1381
	sw %a6 %a0 16 #1381
	lw %a8 %sp 52 #1381
	sw %a8 %a0 12 #1381
	lw %a9 %sp 56 #1381
	sw %a9 %a0 8 #1381
	lw %a1 %sp 168 #1381
	sw %a1 %a0 4 #1381
	addi %a1 %min_caml_hp 0 #1422
	addi %min_caml_hp %min_caml_hp 16 #1422
	li %a4 solve_one_or_network_fast.2768 #1422
	sw %a4 %a1 0 #1422
	sw %a0 %a1 8 #1422
	sw %a11 %a1 4 #1422
	addi %a4 %min_caml_hp 0 #1432
	addi %min_caml_hp %min_caml_hp 40 #1432
	sw %a3 %sp 196 #1432
	li %a3 trace_or_matrix_fast.2772 #1432
	sw %a3 %a4 0 #1432
	sw %a5 %a4 32 #1432
	sw %a2 %a4 28 #1432
	lw %a3 %sp 160 #1432
	sw %a3 %a4 24 #1432
	sw %a10 %a4 20 #1432
	sw %a1 %a4 16 #1432
	sw %a0 %a4 12 #1432
	sw %a7 %a4 8 #1432
	sw %a11 %a4 4 #1432
	addi %a11 %min_caml_hp 0 #1491
	addi %min_caml_hp %min_caml_hp 16 #1491
	li %a9 get_nvector_second.2782 #1491
	sw %a9 %a11 0 #1491
	lw %a9 %sp 60 #1491
	sw %a9 %a11 8 #1491
	sw %a8 %a11 4 #1491
	sw %a11 %sp 200 #1527
	addi %a11 %min_caml_hp 0 #1527
	addi %min_caml_hp %min_caml_hp 8 #1527
	li %a8 utexture.2787 #1527
	sw %a8 %a11 0 #1527
	lw %a8 %sp 64 #1527
	sw %a8 %a11 4 #1527
	sw %a11 %sp 204 #1603
	addi %a11 %min_caml_hp 0 #1603
	addi %min_caml_hp %min_caml_hp 16 #1603
	li %a6 add_light.2790 #1603
	sw %a6 %a11 0 #1603
	sw %a8 %a11 8 #1603
	lw %a6 %sp 72 #1603
	sw %a6 %a11 4 #1603
	sw %a11 %sp 208 #1620
	addi %a11 %min_caml_hp 0 #1620
	addi %min_caml_hp %min_caml_hp 104 #1620
	li %a9 trace_reflections.2794 #1620
	sw %a9 %a11 0 #1620
	lw %a9 %sp 124 #1620
	sw %a9 %a11 96 #1620
	sw %a4 %a11 92 #1620
	sw %a5 %a11 88 #1620
	sw %a8 %a11 84 #1620
	lw %a8 %sp 192 #1620
	sw %a8 %a11 80 #1620
	sw %a2 %a11 76 #1620
	sw %a3 %a11 72 #1620
	sw %a10 %a11 68 #1620
	sw %a1 %a11 64 #1620
	sw %a0 %a11 60 #1620
	sw %a0 %sp 212 #1620
	lw %a0 %sp 188 #1620
	sw %a0 %a11 56 #1620
	lw %a0 %sp 184 #1620
	sw %a0 %a11 52 #1620
	lw %a0 %sp 180 #1620
	sw %a0 %a11 48 #1620
	sw %a6 %a11 44 #1620
	lw %a6 %sp 140 #1620
	sw %a6 %a11 40 #1620
	lw %a6 %sp 36 #1620
	sw %a6 %a11 36 #1620
	sw %a7 %a11 32 #1620
	lw %a7 %sp 60 #1620
	sw %a7 %a11 28 #1620
	lw %a7 %sp 44 #1620
	sw %a7 %a11 24 #1620
	lw %a7 %sp 52 #1620
	sw %a7 %a11 20 #1620
	lw %a7 %sp 56 #1620
	sw %a7 %a11 16 #1620
	lw %a7 %sp 132 #1620
	sw %a7 %a11 12 #1620
	lw %a7 %sp 28 #1620
	sw %a7 %a11 8 #1620
	lw %a7 %sp 208 #1620
	sw %a7 %a11 4 #1620
	addi %a7 %min_caml_hp 0 #1647
	addi %min_caml_hp %min_caml_hp 144 #1647
	li %a6 trace_ray.2799 #1647
	sw %a6 %a7 0 #1647
	sw %a9 %a7 140 #1647
	lw %a6 %sp 204 #1647
	sw %a6 %a7 136 #1647
	sw %a11 %a7 132 #1647
	sw %a4 %a7 128 #1647
	lw %a11 %sp 196 #1647
	sw %a11 %a7 124 #1647
	sw %a5 %a7 120 #1647
	lw %a11 %sp 64 #1647
	sw %a11 %a7 116 #1647
	lw %a11 %sp 92 #1647
	sw %a11 %a7 112 #1647
	lw %a11 %sp 88 #1647
	sw %a11 %a7 108 #1647
	sw %a8 %a7 104 #1647
	sw %a2 %a7 100 #1647
	sw %a3 %a7 96 #1647
	sw %a10 %a7 92 #1647
	sw %a1 %a7 88 #1647
	lw %a11 %sp 212 #1647
	sw %a11 %a7 84 #1647
	lw %a11 %sp 188 #1647
	sw %a11 %a7 80 #1647
	sw %a1 %sp 216 #1647
	lw %a1 %sp 184 #1647
	sw %a1 %a7 76 #1647
	sw %a0 %a7 72 #1647
	lw %a3 %sp 156 #1647
	sw %a3 %a7 68 #1647
	lw %a3 %sp 72 #1647
	sw %a3 %a7 64 #1647
	lw %a3 %sp 140 #1647
	sw %a3 %a7 60 #1647
	lw %a3 %sp 36 #1647
	sw %a3 %a7 56 #1647
	lw %a3 %sp 4 #1647
	sw %a3 %a7 52 #1647
	lw %a3 %sp 60 #1647
	sw %a3 %a7 48 #1647
	lw %a3 %sp 148 #1647
	sw %a3 %a7 44 #1647
	lw %a3 %sp 0 #1647
	sw %a3 %a7 40 #1647
	lw %a3 %sp 16 #1647
	sw %a3 %a7 36 #1647
	lw %a3 %sp 44 #1647
	sw %a3 %a7 32 #1647
	lw %a3 %sp 52 #1647
	sw %a3 %a7 28 #1647
	lw %a3 %sp 56 #1647
	sw %a3 %a7 24 #1647
	lw %a3 %sp 200 #1647
	sw %a3 %a7 20 #1647
	lw %a3 %sp 132 #1647
	sw %a3 %a7 16 #1647
	lw %a3 %sp 20 #1647
	sw %a3 %a7 12 #1647
	lw %a3 %sp 28 #1647
	sw %a3 %a7 8 #1647
	lw %a3 %sp 208 #1647
	sw %a3 %a7 4 #1647
	addi %a3 %min_caml_hp 0 #1737
	addi %min_caml_hp %min_caml_hp 96 #1737
	sw %a7 %sp 220 #1737
	li %a7 trace_diffuse_ray.2805 #1737
	sw %a7 %a3 0 #1737
	sw %a9 %a3 88 #1737
	sw %a6 %a3 84 #1737
	sw %a4 %a3 80 #1737
	sw %a5 %a3 76 #1737
	lw %a7 %sp 64 #1737
	sw %a7 %a3 72 #1737
	sw %a8 %a3 68 #1737
	sw %a2 %a3 64 #1737
	sw %a10 %a3 60 #1737
	sw %a11 %a3 56 #1737
	sw %a1 %a3 52 #1737
	sw %a0 %a3 48 #1737
	lw %a0 %sp 36 #1737
	sw %a0 %a3 44 #1737
	lw %a1 %sp 4 #1737
	sw %a1 %a3 40 #1737
	lw %a2 %sp 60 #1737
	sw %a2 %a3 36 #1737
	lw %a8 %sp 16 #1737
	sw %a8 %a3 32 #1737
	lw %a9 %sp 44 #1737
	sw %a9 %a3 28 #1737
	lw %a9 %sp 52 #1737
	sw %a9 %a3 24 #1737
	lw %a9 %sp 56 #1737
	sw %a9 %a3 20 #1737
	lw %a9 %sp 200 #1737
	sw %a9 %a3 16 #1737
	lw %a9 %sp 68 #1737
	sw %a9 %a3 12 #1737
	lw %a9 %sp 132 #1737
	sw %a9 %a3 8 #1737
	lw %a9 %sp 28 #1737
	sw %a9 %a3 4 #1737
	addi %a9 %min_caml_hp 0 #1755
	addi %min_caml_hp %min_caml_hp 88 #1755
	li %a8 iter_trace_diffuse_rays.2808 #1755
	sw %a8 %a9 0 #1755
	sw %a6 %a9 80 #1755
	sw %a4 %a9 76 #1755
	sw %a3 %a9 72 #1755
	sw %a5 %a9 68 #1755
	sw %a7 %a9 64 #1755
	lw %a4 %sp 160 #1755
	sw %a4 %a9 60 #1755
	sw %a10 %a9 56 #1755
	lw %a4 %sp 216 #1755
	sw %a4 %a9 52 #1755
	lw %a4 %sp 212 #1755
	sw %a4 %a9 48 #1755
	sw %a11 %a9 44 #1755
	sw %a0 %a9 40 #1755
	sw %a1 %a9 36 #1755
	sw %a2 %a9 32 #1755
	lw %a0 %sp 16 #1755
	sw %a0 %a9 28 #1755
	lw %a2 %sp 44 #1755
	sw %a2 %a9 24 #1755
	lw %a2 %sp 52 #1755
	sw %a2 %a9 20 #1755
	lw %a2 %sp 56 #1755
	sw %a2 %a9 16 #1755
	lw %a2 %sp 200 #1755
	sw %a2 %a9 12 #1755
	lw %a2 %sp 68 #1755
	sw %a2 %a9 8 #1755
	lw %a4 %sp 28 #1755
	sw %a4 %a9 4 #1755
	addi %a4 %min_caml_hp 0 #1778
	addi %min_caml_hp %min_caml_hp 24 #1778
	li %a5 trace_diffuse_ray_80percent.2817 #1778
	sw %a5 %a4 0 #1778
	lw %a5 %sp 92 #1778
	sw %a5 %a4 20 #1778
	lw %a6 %sp 156 #1778
	sw %a6 %a4 16 #1778
	lw %a7 %sp 0 #1778
	sw %a7 %a4 12 #1778
	sw %a9 %a4 8 #1778
	lw %a8 %sp 116 #1778
	sw %a8 %a4 4 #1778
	addi %a10 %min_caml_hp 0 #1803
	addi %min_caml_hp %min_caml_hp 40 #1803
	li %a11 calc_diffuse_using_1point.2821 #1803
	sw %a11 %a10 0 #1803
	sw %a3 %a10 32 #1803
	sw %a5 %a10 28 #1803
	sw %a6 %a10 24 #1803
	lw %a11 %sp 72 #1803
	sw %a11 %a10 20 #1803
	sw %a7 %a10 16 #1803
	sw %a9 %a10 12 #1803
	sw %a8 %a10 8 #1803
	sw %a2 %a10 4 #1803
	addi %a0 %min_caml_hp 0 #1821
	addi %min_caml_hp %min_caml_hp 16 #1821
	li %a1 calc_diffuse_using_5points.2824 #1821
	sw %a1 %a0 0 #1821
	sw %a11 %a0 8 #1821
	sw %a2 %a0 4 #1821
	addi %a1 %min_caml_hp 0 #1841
	addi %min_caml_hp %min_caml_hp 40 #1841
	sw %a3 %sp 224 #1841
	li %a3 do_without_neighbors.2830 #1841
	sw %a3 %a1 0 #1841
	sw %a4 %a1 36 #1841
	sw %a5 %a1 32 #1841
	sw %a6 %a1 28 #1841
	sw %a11 %a1 24 #1841
	sw %a7 %a1 20 #1841
	sw %a9 %a1 16 #1841
	sw %a8 %a1 12 #1841
	sw %a2 %a1 8 #1841
	sw %a10 %a1 4 #1841
	addi %a3 %min_caml_hp 0 #1890
	addi %min_caml_hp %min_caml_hp 32 #1890
	li %a8 try_exploit_neighbors.2846 #1890
	sw %a8 %a3 0 #1890
	sw %a4 %a3 24 #1890
	sw %a11 %a3 20 #1890
	sw %a1 %a3 16 #1890
	sw %a2 %a3 12 #1890
	sw %a0 %a3 8 #1890
	sw %a10 %a3 4 #1890
	addi %a8 %min_caml_hp 0 #1949
	addi %min_caml_hp %min_caml_hp 32 #1949
	sw %a10 %sp 228 #1949
	li %a10 pretrace_diffuse_rays.2859 #1949
	sw %a10 %a8 0 #1949
	lw %a10 %sp 224 #1949
	sw %a10 %a8 28 #1949
	sw %a5 %a8 24 #1949
	sw %a6 %a8 20 #1949
	sw %a7 %a8 16 #1949
	sw %a9 %a8 12 #1949
	sw %a0 %sp 232 #1949
	lw %a0 %sp 116 #1949
	sw %a0 %a8 8 #1949
	sw %a2 %a8 4 #1949
	sw %a1 %sp 236 #1978
	addi %a1 %min_caml_hp 0 #1978
	addi %min_caml_hp %min_caml_hp 72 #1978
	sw %a4 %sp 240 #1978
	li %a4 pretrace_pixels.2862 #1978
	sw %a4 %a1 0 #1978
	lw %a4 %sp 12 #1978
	sw %a4 %a1 64 #1978
	lw %a4 %sp 220 #1978
	sw %a4 %a1 60 #1978
	sw %a10 %a1 56 #1978
	sw %a5 %a1 52 #1978
	lw %a4 %sp 88 #1978
	sw %a4 %a1 48 #1978
	sw %a6 %a1 44 #1978
	lw %a4 %sp 96 #1978
	sw %a4 %a1 40 #1978
	lw %a4 %sp 84 #1978
	sw %a4 %a1 36 #1978
	sw %a11 %a1 32 #1978
	lw %a5 %sp 108 #1978
	sw %a5 %a1 28 #1978
	sw %a8 %a1 24 #1978
	sw %a7 %a1 20 #1978
	sw %a9 %a1 16 #1978
	lw %a5 %sp 80 #1978
	sw %a5 %a1 12 #1978
	sw %a0 %a1 8 #1978
	sw %a2 %a1 4 #1978
	addi %a6 %min_caml_hp 0 #2017
	addi %min_caml_hp %min_caml_hp 40 #2017
	li %a8 scan_pixel.2873 #2017
	sw %a8 %a6 0 #2017
	sw %a3 %a6 32 #2017
	lw %a8 %sp 240 #2017
	sw %a8 %a6 28 #2017
	sw %a11 %a6 24 #2017
	lw %a9 %sp 76 #2017
	sw %a9 %a6 20 #2017
	lw %a10 %sp 236 #2017
	sw %a10 %a6 16 #2017
	sw %a2 %a6 12 #2017
	lw %a7 %sp 232 #2017
	sw %a7 %a6 8 #2017
	lw %a7 %sp 228 #2017
	sw %a7 %a6 4 #2017
	addi %a0 %min_caml_hp 0 #2037
	addi %min_caml_hp %min_caml_hp 56 #2037
	li %a7 scan_line.2879 #2037
	sw %a7 %a0 0 #2037
	sw %a3 %a0 52 #2037
	sw %a8 %a0 48 #2037
	lw %a3 %sp 104 #2037
	sw %a3 %a0 44 #2037
	lw %a7 %sp 100 #2037
	sw %a7 %a0 40 #2037
	sw %a6 %a0 36 #2037
	sw %a4 %a0 32 #2037
	sw %a11 %a0 28 #2037
	sw %a1 %a0 24 #2037
	sw %a9 %a0 20 #2037
	sw %a5 %a0 16 #2037
	sw %a10 %a0 12 #2037
	sw %a2 %a0 8 #2037
	lw %a2 %sp 228 #2037
	sw %a2 %a0 4 #2037
	addi %a2 %min_caml_hp 0 #2110
	addi %min_caml_hp %min_caml_hp 8 #2110
	li %a6 calc_dirvec.2899 #2110
	sw %a6 %a2 0 #2110
	lw %a6 %sp 116 #2110
	sw %a6 %a2 4 #2110
	addi %a8 %min_caml_hp 0 #2131
	addi %min_caml_hp %min_caml_hp 8 #2131
	li %a10 calc_dirvecs.2907 #2131
	sw %a10 %a8 0 #2131
	sw %a2 %a8 4 #2131
	addi %a10 %min_caml_hp 0 #2145
	addi %min_caml_hp %min_caml_hp 16 #2145
	li %a11 calc_dirvec_rows.2912 #2145
	sw %a11 %a10 0 #2145
	sw %a8 %a10 8 #2145
	sw %a2 %a10 4 #2145
	addi %a2 %min_caml_hp 0 #2162
	addi %min_caml_hp %min_caml_hp 8 #2162
	li %a11 create_dirvec_elements.2918 #2162
	sw %a11 %a2 0 #2162
	lw %a11 %sp 0 #2162
	sw %a11 %a2 4 #2162
	sw %a0 %sp 244 #2169
	addi %a0 %min_caml_hp 0 #2169
	addi %min_caml_hp %min_caml_hp 16 #2169
	sw %a1 %sp 248 #2169
	li %a1 create_dirvecs.2921 #2169
	sw %a1 %a0 0 #2169
	sw %a11 %a0 12 #2169
	sw %a6 %a0 8 #2169
	sw %a2 %a0 4 #2169
	addi %a1 %min_caml_hp 0 #2179
	addi %min_caml_hp %min_caml_hp 16 #2179
	li %a3 init_dirvec_constants.2923 #2179
	sw %a3 %a1 0 #2179
	lw %a3 %sp 4 #2179
	sw %a3 %a1 12 #2179
	sw %a11 %a1 8 #2179
	lw %a7 %sp 152 #2179
	sw %a7 %a1 4 #2179
	sw %a10 %sp 252 #2186
	addi %a10 %min_caml_hp 0 #2186
	addi %min_caml_hp %min_caml_hp 24 #2186
	sw %a8 %sp 256 #2186
	li %a8 init_vecset_constants.2926 #2186
	sw %a8 %a10 0 #2186
	sw %a3 %a10 20 #2186
	sw %a11 %a10 16 #2186
	sw %a7 %a10 12 #2186
	sw %a1 %a10 8 #2186
	sw %a6 %a10 4 #2186
	addi %a8 %min_caml_hp 0 #2240
	addi %min_caml_hp %min_caml_hp 32 #2240
	sw %a10 %sp 260 #2240
	li %a10 setup_reflections.2943 #2240
	sw %a10 %a8 0 #2240
	lw %a10 %sp 140 #2240
	sw %a10 %a8 24 #2240
	sw %a3 %a8 20 #2240
	lw %a10 %sp 148 #2240
	sw %a10 %a8 16 #2240
	sw %a11 %a8 12 #2240
	lw %a10 %sp 16 #2240
	sw %a10 %a8 8 #2240
	sw %a7 %a8 4 #2240
	sw %a8 %sp 264 #2281
	addi %a8 %zero 128 #2281
	addi %a7 %zero 128 #2281
	sw %a8 %a9 0 #2262
	sw %a7 %a9 4 #2263
	addi %a3 %zero 2 #2264
	sw %a1 %sp 268 #2264
	sw %a0 %sp 272 #2264
	sw %a2 %sp 276 #2264
	sw %a8 %sp 280 #2264
	sw %a7 %sp 284 #2264
	add %a1 %a3 %zero
	add %a0 %a8 %zero
	sw %ra %sp 292 #2264 call dir
	addi %sp %sp 296 #2264	
	jal %ra min_caml_srl #2264
	addi %sp %sp -296 #2264
	lw %ra %sp 292 #2264
	lw %a1 %sp 80 #2264
	sw %a0 %a1 0 #2264
	addi %a0 %zero 2 #2265
	lw %a2 %sp 284 #2265
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 292 #2265 call dir
	addi %sp %sp 296 #2265	
	jal %ra min_caml_srl #2265
	addi %sp %sp -296 #2265
	lw %ra %sp 292 #2265
	lw %a1 %sp 80 #2265
	sw %a0 %a1 4 #2265
	li %f0 l.40359 #2266
	lw %a0 %sp 280 #2266
	itof %f1 %a0 #2266
	fdiv %f0 %f0 %f1 #2266
	lw %a0 %sp 84 #2266
	sw %f0 %a0 0 #2266
	lw %a2 %sp 76 #57
	lw %a3 %a2 0 #57
	addi %a4 %zero 3 #2066
	li %f0 l.37367 #2066
	sw %a3 %sp 288 #2066
	add %a0 %a4 %zero
	sw %ra %sp 292 #2066 call dir
	addi %sp %sp 296 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -296 #2066
	lw %ra %sp 292 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 292 #2054
	add %a0 %a1 %zero
	sw %ra %sp 300 #2054 call dir
	addi %sp %sp 304 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -304 #2054
	lw %ra %sp 300 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 300 #2055 call dir
	addi %sp %sp 304 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -304 #2055
	lw %ra %sp 300 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 296 #2056
	add %a0 %a1 %zero
	sw %ra %sp 300 #2056 call dir
	addi %sp %sp 304 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -304 #2056
	lw %ra %sp 300 #2056
	lw %a1 %sp 296 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 300 #2057 call dir
	addi %sp %sp 304 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -304 #2057
	lw %ra %sp 300 #2057
	lw %a1 %sp 296 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 300 #2058 call dir
	addi %sp %sp 304 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -304 #2058
	lw %ra %sp 300 #2058
	lw %a1 %sp 296 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 300 #2059 call dir
	addi %sp %sp 304 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -304 #2059
	lw %ra %sp 300 #2059
	lw %a1 %sp 296 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 300 #2068 call dir
	addi %sp %sp 304 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -304 #2068
	lw %ra %sp 300 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 300 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 308 #2069 call dir
	addi %sp %sp 312 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -312 #2069
	lw %ra %sp 308 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 304 #2054
	add %a0 %a1 %zero
	sw %ra %sp 308 #2054 call dir
	addi %sp %sp 312 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -312 #2054
	lw %ra %sp 308 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 308 #2055 call dir
	addi %sp %sp 312 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -312 #2055
	lw %ra %sp 308 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 308 #2056
	add %a0 %a1 %zero
	sw %ra %sp 316 #2056 call dir
	addi %sp %sp 320 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -320 #2056
	lw %ra %sp 316 #2056
	lw %a1 %sp 308 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 316 #2057 call dir
	addi %sp %sp 320 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -320 #2057
	lw %ra %sp 316 #2057
	lw %a1 %sp 308 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 316 #2058 call dir
	addi %sp %sp 320 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -320 #2058
	lw %ra %sp 316 #2058
	lw %a1 %sp 308 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 316 #2059 call dir
	addi %sp %sp 320 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -320 #2059
	lw %ra %sp 316 #2059
	lw %a1 %sp 308 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %ra %sp 316 #2054 call dir
	addi %sp %sp 320 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -320 #2054
	lw %ra %sp 316 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 316 #2055 call dir
	addi %sp %sp 320 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -320 #2055
	lw %ra %sp 316 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 312 #2056
	add %a0 %a1 %zero
	sw %ra %sp 316 #2056 call dir
	addi %sp %sp 320 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -320 #2056
	lw %ra %sp 316 #2056
	lw %a1 %sp 312 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 316 #2057 call dir
	addi %sp %sp 320 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -320 #2057
	lw %ra %sp 316 #2057
	lw %a1 %sp 312 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 316 #2058 call dir
	addi %sp %sp 320 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -320 #2058
	lw %ra %sp 316 #2058
	lw %a1 %sp 312 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 316 #2059 call dir
	addi %sp %sp 320 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -320 #2059
	lw %ra %sp 316 #2059
	lw %a1 %sp 312 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 316 #2072 call dir
	addi %sp %sp 320 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -320 #2072
	lw %ra %sp 316 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 316 #2054
	add %a0 %a1 %zero
	sw %ra %sp 324 #2054 call dir
	addi %sp %sp 328 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -328 #2054
	lw %ra %sp 324 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 324 #2055 call dir
	addi %sp %sp 328 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -328 #2055
	lw %ra %sp 324 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 320 #2056
	add %a0 %a1 %zero
	sw %ra %sp 324 #2056 call dir
	addi %sp %sp 328 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -328 #2056
	lw %ra %sp 324 #2056
	lw %a1 %sp 320 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 324 #2057 call dir
	addi %sp %sp 328 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -328 #2057
	lw %ra %sp 324 #2057
	lw %a1 %sp 320 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 324 #2058 call dir
	addi %sp %sp 328 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -328 #2058
	lw %ra %sp 324 #2058
	lw %a1 %sp 320 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 324 #2059 call dir
	addi %sp %sp 328 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -328 #2059
	lw %ra %sp 324 #2059
	lw %a1 %sp 320 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 316 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 312 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 308 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 304 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 300 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 296 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 292 #2074
	sw %a1 %a0 0 #2074
	addi %a1 %a0 0 #2074
	lw %a0 %sp 288 #2088
	sw %ra %sp 324 #2088 call dir
	addi %sp %sp 328 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -328 #2088
	lw %ra %sp 324 #2088
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.46060 # nontail if
	sw %a0 %sp 324 #2080
	sw %a2 %sp 328 #2080
	sw %ra %sp 332 #2080 call dir
	addi %sp %sp 336 #2080	
	jal %ra create_pixel.2887 #2080
	addi %sp %sp -336 #2080
	lw %ra %sp 332 #2080
	lw %a1 %sp 328 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 324 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 332 #2081 call dir
	addi %sp %sp 336 #2081	
	jal %ra init_line_elements.2889 #2081
	addi %sp %sp -336 #2081
	lw %ra %sp 332 #2081
	jal %zero bge_cont.46061 # then sentence ends
bge_else.46060:
bge_cont.46061:
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a3 %zero 3 #2066
	li %f0 l.37367 #2066
	sw %a0 %sp 332 #2066
	sw %a2 %sp 336 #2066
	add %a0 %a3 %zero
	sw %ra %sp 340 #2066 call dir
	addi %sp %sp 344 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -344 #2066
	lw %ra %sp 340 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 340 #2054
	add %a0 %a1 %zero
	sw %ra %sp 348 #2054 call dir
	addi %sp %sp 352 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -352 #2054
	lw %ra %sp 348 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 348 #2055 call dir
	addi %sp %sp 352 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -352 #2055
	lw %ra %sp 348 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 344 #2056
	add %a0 %a1 %zero
	sw %ra %sp 348 #2056 call dir
	addi %sp %sp 352 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -352 #2056
	lw %ra %sp 348 #2056
	lw %a1 %sp 344 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 348 #2057 call dir
	addi %sp %sp 352 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -352 #2057
	lw %ra %sp 348 #2057
	lw %a1 %sp 344 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 348 #2058 call dir
	addi %sp %sp 352 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -352 #2058
	lw %ra %sp 348 #2058
	lw %a1 %sp 344 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 348 #2059 call dir
	addi %sp %sp 352 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -352 #2059
	lw %ra %sp 348 #2059
	lw %a1 %sp 344 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 348 #2068 call dir
	addi %sp %sp 352 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -352 #2068
	lw %ra %sp 348 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 348 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 356 #2069 call dir
	addi %sp %sp 360 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -360 #2069
	lw %ra %sp 356 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 352 #2054
	add %a0 %a1 %zero
	sw %ra %sp 356 #2054 call dir
	addi %sp %sp 360 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -360 #2054
	lw %ra %sp 356 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 356 #2055 call dir
	addi %sp %sp 360 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -360 #2055
	lw %ra %sp 356 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 356 #2056
	add %a0 %a1 %zero
	sw %ra %sp 364 #2056 call dir
	addi %sp %sp 368 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -368 #2056
	lw %ra %sp 364 #2056
	lw %a1 %sp 356 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 364 #2057 call dir
	addi %sp %sp 368 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -368 #2057
	lw %ra %sp 364 #2057
	lw %a1 %sp 356 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 364 #2058 call dir
	addi %sp %sp 368 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -368 #2058
	lw %ra %sp 364 #2058
	lw %a1 %sp 356 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 364 #2059 call dir
	addi %sp %sp 368 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -368 #2059
	lw %ra %sp 364 #2059
	lw %a1 %sp 356 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %ra %sp 364 #2054 call dir
	addi %sp %sp 368 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -368 #2054
	lw %ra %sp 364 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 364 #2055 call dir
	addi %sp %sp 368 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -368 #2055
	lw %ra %sp 364 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 360 #2056
	add %a0 %a1 %zero
	sw %ra %sp 364 #2056 call dir
	addi %sp %sp 368 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -368 #2056
	lw %ra %sp 364 #2056
	lw %a1 %sp 360 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 364 #2057 call dir
	addi %sp %sp 368 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -368 #2057
	lw %ra %sp 364 #2057
	lw %a1 %sp 360 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 364 #2058 call dir
	addi %sp %sp 368 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -368 #2058
	lw %ra %sp 364 #2058
	lw %a1 %sp 360 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 364 #2059 call dir
	addi %sp %sp 368 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -368 #2059
	lw %ra %sp 364 #2059
	lw %a1 %sp 360 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 364 #2072 call dir
	addi %sp %sp 368 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -368 #2072
	lw %ra %sp 364 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 364 #2054
	add %a0 %a1 %zero
	sw %ra %sp 372 #2054 call dir
	addi %sp %sp 376 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -376 #2054
	lw %ra %sp 372 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 372 #2055 call dir
	addi %sp %sp 376 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -376 #2055
	lw %ra %sp 372 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 368 #2056
	add %a0 %a1 %zero
	sw %ra %sp 372 #2056 call dir
	addi %sp %sp 376 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -376 #2056
	lw %ra %sp 372 #2056
	lw %a1 %sp 368 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 372 #2057 call dir
	addi %sp %sp 376 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -376 #2057
	lw %ra %sp 372 #2057
	lw %a1 %sp 368 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 372 #2058 call dir
	addi %sp %sp 376 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -376 #2058
	lw %ra %sp 372 #2058
	lw %a1 %sp 368 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 372 #2059 call dir
	addi %sp %sp 376 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -376 #2059
	lw %ra %sp 372 #2059
	lw %a1 %sp 368 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 364 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 360 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 356 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 352 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 348 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 344 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 340 #2074
	sw %a1 %a0 0 #2074
	addi %a1 %a0 0 #2074
	lw %a0 %sp 336 #2088
	sw %ra %sp 372 #2088 call dir
	addi %sp %sp 376 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -376 #2088
	lw %ra %sp 372 #2088
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.46062 # nontail if
	sw %a0 %sp 372 #2080
	sw %a2 %sp 376 #2080
	sw %ra %sp 380 #2080 call dir
	addi %sp %sp 384 #2080	
	jal %ra create_pixel.2887 #2080
	addi %sp %sp -384 #2080
	lw %ra %sp 380 #2080
	lw %a1 %sp 376 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 372 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 380 #2081 call dir
	addi %sp %sp 384 #2081	
	jal %ra init_line_elements.2889 #2081
	addi %sp %sp -384 #2081
	lw %ra %sp 380 #2081
	jal %zero bge_cont.46063 # then sentence ends
bge_else.46062:
bge_cont.46063:
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a3 %zero 3 #2066
	li %f0 l.37367 #2066
	sw %a0 %sp 380 #2066
	sw %a2 %sp 384 #2066
	add %a0 %a3 %zero
	sw %ra %sp 388 #2066 call dir
	addi %sp %sp 392 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -392 #2066
	lw %ra %sp 388 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 388 #2054
	add %a0 %a1 %zero
	sw %ra %sp 396 #2054 call dir
	addi %sp %sp 400 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -400 #2054
	lw %ra %sp 396 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 396 #2055 call dir
	addi %sp %sp 400 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -400 #2055
	lw %ra %sp 396 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 392 #2056
	add %a0 %a1 %zero
	sw %ra %sp 396 #2056 call dir
	addi %sp %sp 400 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -400 #2056
	lw %ra %sp 396 #2056
	lw %a1 %sp 392 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 396 #2057 call dir
	addi %sp %sp 400 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -400 #2057
	lw %ra %sp 396 #2057
	lw %a1 %sp 392 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 396 #2058 call dir
	addi %sp %sp 400 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -400 #2058
	lw %ra %sp 396 #2058
	lw %a1 %sp 392 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 396 #2059 call dir
	addi %sp %sp 400 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -400 #2059
	lw %ra %sp 396 #2059
	lw %a1 %sp 392 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 396 #2068 call dir
	addi %sp %sp 400 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -400 #2068
	lw %ra %sp 396 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 396 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 404 #2069 call dir
	addi %sp %sp 408 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -408 #2069
	lw %ra %sp 404 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 400 #2054
	add %a0 %a1 %zero
	sw %ra %sp 404 #2054 call dir
	addi %sp %sp 408 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -408 #2054
	lw %ra %sp 404 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 404 #2055 call dir
	addi %sp %sp 408 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -408 #2055
	lw %ra %sp 404 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 404 #2056
	add %a0 %a1 %zero
	sw %ra %sp 412 #2056 call dir
	addi %sp %sp 416 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -416 #2056
	lw %ra %sp 412 #2056
	lw %a1 %sp 404 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 412 #2057 call dir
	addi %sp %sp 416 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -416 #2057
	lw %ra %sp 412 #2057
	lw %a1 %sp 404 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 412 #2058 call dir
	addi %sp %sp 416 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -416 #2058
	lw %ra %sp 412 #2058
	lw %a1 %sp 404 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 412 #2059 call dir
	addi %sp %sp 416 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -416 #2059
	lw %ra %sp 412 #2059
	lw %a1 %sp 404 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %ra %sp 412 #2054 call dir
	addi %sp %sp 416 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -416 #2054
	lw %ra %sp 412 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 412 #2055 call dir
	addi %sp %sp 416 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -416 #2055
	lw %ra %sp 412 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 408 #2056
	add %a0 %a1 %zero
	sw %ra %sp 412 #2056 call dir
	addi %sp %sp 416 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -416 #2056
	lw %ra %sp 412 #2056
	lw %a1 %sp 408 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 412 #2057 call dir
	addi %sp %sp 416 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -416 #2057
	lw %ra %sp 412 #2057
	lw %a1 %sp 408 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 412 #2058 call dir
	addi %sp %sp 416 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -416 #2058
	lw %ra %sp 412 #2058
	lw %a1 %sp 408 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 412 #2059 call dir
	addi %sp %sp 416 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -416 #2059
	lw %ra %sp 412 #2059
	lw %a1 %sp 408 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 412 #2072 call dir
	addi %sp %sp 416 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -416 #2072
	lw %ra %sp 412 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.37367 #2054
	sw %a0 %sp 412 #2054
	add %a0 %a1 %zero
	sw %ra %sp 420 #2054 call dir
	addi %sp %sp 424 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -424 #2054
	lw %ra %sp 420 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 420 #2055 call dir
	addi %sp %sp 424 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -424 #2055
	lw %ra %sp 420 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.37367 #2056
	sw %a0 %sp 416 #2056
	add %a0 %a1 %zero
	sw %ra %sp 420 #2056 call dir
	addi %sp %sp 424 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -424 #2056
	lw %ra %sp 420 #2056
	lw %a1 %sp 416 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.37367 #2057
	sw %ra %sp 420 #2057 call dir
	addi %sp %sp 424 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -424 #2057
	lw %ra %sp 420 #2057
	lw %a1 %sp 416 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.37367 #2058
	sw %ra %sp 420 #2058 call dir
	addi %sp %sp 424 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -424 #2058
	lw %ra %sp 420 #2058
	lw %a1 %sp 416 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.37367 #2059
	sw %ra %sp 420 #2059 call dir
	addi %sp %sp 424 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -424 #2059
	lw %ra %sp 420 #2059
	lw %a1 %sp 416 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 412 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 408 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 404 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 400 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 396 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 392 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 388 #2074
	sw %a1 %a0 0 #2074
	addi %a1 %a0 0 #2074
	lw %a0 %sp 384 #2088
	sw %ra %sp 420 #2088 call dir
	addi %sp %sp 424 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -424 #2088
	lw %ra %sp 420 #2088
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.46064 # nontail if
	sw %a0 %sp 420 #2080
	sw %a2 %sp 424 #2080
	sw %ra %sp 428 #2080 call dir
	addi %sp %sp 432 #2080	
	jal %ra create_pixel.2887 #2080
	addi %sp %sp -432 #2080
	lw %ra %sp 428 #2080
	lw %a1 %sp 424 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 420 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 428 #2081 call dir
	addi %sp %sp 432 #2081	
	jal %ra init_line_elements.2889 #2081
	addi %sp %sp -432 #2081
	lw %ra %sp 428 #2081
	jal %zero bge_cont.46065 # then sentence ends
bge_else.46064:
bge_cont.46065:
	lw %a11 %sp 144 #2270
	sw %a0 %sp 428 #2270
	sw %ra %sp 436 #2270 call cls
	lw %a10 %a11 0 #2270
	addi %sp %sp 440 #2270	
	jalr %ra %a10 0 #2270
	addi %sp %sp -440 #2270
	lw %ra %sp 436 #2270
	addi %a0 %zero 80 #1917
	sw %ra %sp 436 #1917 call dir
	addi %sp %sp 440 #1917	
	jal %ra min_caml_print_char #1917
	addi %sp %sp -440 #1917
	lw %ra %sp 436 #1917
	addi %a0 %zero 51 #1918
	sw %ra %sp 436 #1918 call dir
	addi %sp %sp 440 #1918	
	jal %ra min_caml_print_char #1918
	addi %sp %sp -440 #1918
	lw %ra %sp 436 #1918
	addi %a0 %zero 10 #1919
	sw %ra %sp 436 #1919 call dir
	addi %sp %sp 440 #1919	
	jal %ra min_caml_print_char #1919
	addi %sp %sp -440 #1919
	lw %ra %sp 436 #1919
	lw %a0 %sp 76 #57
	lw %a1 %a0 0 #57
	add %a0 %a1 %zero
	sw %ra %sp 436 #1920 call dir
	addi %sp %sp 440 #1920	
	jal %ra min_caml_print_int #1920
	addi %sp %sp -440 #1920
	lw %ra %sp 436 #1920
	addi %a0 %zero 32 #1921
	sw %ra %sp 436 #1921 call dir
	addi %sp %sp 440 #1921	
	jal %ra min_caml_print_char #1921
	addi %sp %sp -440 #1921
	lw %ra %sp 436 #1921
	lw %a0 %sp 76 #57
	lw %a1 %a0 4 #57
	add %a0 %a1 %zero
	sw %ra %sp 436 #1922 call dir
	addi %sp %sp 440 #1922	
	jal %ra min_caml_print_int #1922
	addi %sp %sp -440 #1922
	lw %ra %sp 436 #1922
	addi %a0 %zero 32 #1923
	sw %ra %sp 436 #1923 call dir
	addi %sp %sp 440 #1923	
	jal %ra min_caml_print_char #1923
	addi %sp %sp -440 #1923
	lw %ra %sp 436 #1923
	addi %a0 %zero 255 #1924
	sw %ra %sp 436 #1924 call dir
	addi %sp %sp 440 #1924	
	jal %ra min_caml_print_int #1924
	addi %sp %sp -440 #1924
	lw %ra %sp 436 #1924
	addi %a0 %zero 10 #1925
	sw %ra %sp 436 #1925 call dir
	addi %sp %sp 440 #1925	
	jal %ra min_caml_print_char #1925
	addi %sp %sp -440 #1925
	lw %ra %sp 436 #1925
	addi %a0 %zero 120 #2171
	addi %a1 %zero 3 #2157
	li %f0 l.37367 #2157
	sw %a0 %sp 432 #2157
	add %a0 %a1 %zero
	sw %ra %sp 436 #2157 call dir
	addi %sp %sp 440 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -440 #2157
	lw %ra %sp 436 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 0 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 436 #2158
	add %a0 %a2 %zero
	sw %ra %sp 444 #2158 call dir
	addi %sp %sp 448 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -448 #2158
	lw %ra %sp 444 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 436 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 432 #2171
	sw %ra %sp 444 #2171 call dir
	addi %sp %sp 448 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -448 #2171
	lw %ra %sp 444 #2171
	lw %a1 %sp 116 #2171
	sw %a0 %a1 16 #2171
	lw %a0 %a1 16 #81
	addi %a2 %zero 118 #2172
	lw %a11 %sp 276 #2172
	add %a1 %a2 %zero
	sw %ra %sp 444 #2172 call cls
	lw %a10 %a11 0 #2172
	addi %sp %sp 448 #2172	
	jalr %ra %a10 0 #2172
	addi %sp %sp -448 #2172
	lw %ra %sp 444 #2172
	addi %a0 %zero 3 #2173
	lw %a11 %sp 272 #2173
	sw %ra %sp 444 #2173 call cls
	lw %a10 %a11 0 #2173
	addi %sp %sp 448 #2173	
	jalr %ra %a10 0 #2173
	addi %sp %sp -448 #2173
	lw %ra %sp 444 #2173
	addi %a0 %zero 9 #2195
	addi %a1 %zero 0 #2195
	addi %a2 %zero 0 #2195
	itof %f0 %a0 #2147
	li %f1 l.40051 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.40053 #2147
	fsub %f0 %f0 %f1 #2147
	addi %a0 %zero 4 #2148
	lw %a11 %sp 256 #2148
	sw %ra %sp 444 #2148 call cls
	lw %a10 %a11 0 #2148
	addi %sp %sp 448 #2148	
	jalr %ra %a10 0 #2148
	addi %sp %sp -448 #2148
	lw %ra %sp 444 #2148
	addi %a0 %zero 8 #2149
	addi %a1 %zero 2 #124
	addi %a2 %zero 4 #2149
	lw %a11 %sp 252 #2149
	sw %ra %sp 444 #2149 call cls
	lw %a10 %a11 0 #2149
	addi %sp %sp 448 #2149	
	jalr %ra %a10 0 #2149
	addi %sp %sp -448 #2149
	lw %ra %sp 444 #2149
	lw %a0 %sp 116 #81
	lw %a0 %a0 16 #81
	addi %a1 %zero 119 #2188
	lw %a11 %sp 268 #2188
	sw %ra %sp 444 #2188 call cls
	lw %a10 %a11 0 #2188
	addi %sp %sp 448 #2188	
	jalr %ra %a10 0 #2188
	addi %sp %sp -448 #2188
	lw %ra %sp 444 #2188
	addi %a0 %zero 3 #2189
	lw %a11 %sp 260 #2189
	sw %ra %sp 444 #2189 call cls
	lw %a10 %a11 0 #2189
	addi %sp %sp 448 #2189	
	jalr %ra %a10 0 #2189
	addi %sp %sp -448 #2189
	lw %ra %sp 444 #2189
	lw %a0 %sp 16 #152
	lw %f0 %a0 0 #152
	lw %a1 %sp 124 #152
	sw %f0 %a1 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a1 8 #154
	lw %a0 %sp 0 #15
	lw %a2 %a0 0 #15
	addi %a2 %a2 -1 #1121
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.46066 # nontail if
	slli %a3 %a2 2 #20
	lw %a4 %sp 4 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %a3 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.46068 # nontail if
	sw %a2 %sp 440 #1110
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 444 #1110 call dir
	addi %sp %sp 448 #1110	
	jal %ra setup_rect_table.2696 #1110
	addi %sp %sp -448 #1110
	lw %ra %sp 444 #1110
	lw %a1 %sp 440 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 132 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.46069 # then sentence ends
beq_else.46068:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.46070 # nontail if
	sw %a2 %sp 440 #1112
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 444 #1112 call dir
	addi %sp %sp 448 #1112	
	jal %ra setup_surface_table.2699 #1112
	addi %sp %sp -448 #1112
	lw %ra %sp 444 #1112
	lw %a1 %sp 440 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 132 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.46071 # then sentence ends
beq_else.46070:
	sw %a2 %sp 440 #1114
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 444 #1114 call dir
	addi %sp %sp 448 #1114	
	jal %ra setup_second_table.2702 #1114
	addi %sp %sp -448 #1114
	lw %ra %sp 444 #1114
	lw %a1 %sp 440 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 132 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.46071:
beq_cont.46069:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 128 #1116
	lw %a11 %sp 152 #1116
	sw %ra %sp 444 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 448 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -448 #1116
	lw %ra %sp 444 #1116
	jal %zero bge_cont.46067 # then sentence ends
bge_else.46066:
bge_cont.46067:
	lw %a0 %sp 0 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #2275
	lw %a11 %sp 264 #2275
	sw %ra %sp 444 #2275 call cls
	lw %a10 %a11 0 #2275
	addi %sp %sp 448 #2275	
	jalr %ra %a10 0 #2275
	addi %sp %sp -448 #2275
	lw %ra %sp 444 #2275
	addi %a0 %zero 0 #2276
	addi %a2 %zero 0 #2276
	lw %a1 %sp 84 #61
	lw %f0 %a1 0 #61
	lw %a1 %sp 80 #59
	lw %a1 %a1 4 #59
	sub %a0 %a0 %a1 #2004
	itof %f1 %a0 #2004
	fmul %f0 %f0 %f1 #2004
	lw %a0 %sp 100 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 104 #71
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
	lw %a0 %sp 76 #57
	lw %a0 %a0 0 #57
	addi %a1 %a0 -1 #2010
	lw %a0 %sp 380 #2010
	lw %a11 %sp 248 #2010
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 444 #2010 call cls
	lw %a10 %a11 0 #2010
	addi %sp %sp 448 #2010	
	jalr %ra %a10 0 #2010
	addi %sp %sp -448 #2010
	lw %ra %sp 444 #2010
	addi %a0 %zero 0 #2277
	addi %a4 %zero 2 #2277
	lw %a1 %sp 332 #2277
	lw %a2 %sp 380 #2277
	lw %a3 %sp 428 #2277
	lw %a11 %sp 244 #2277
	sw %ra %sp 444 #2277 call cls
	lw %a10 %a11 0 #2277
	addi %sp %sp 448 #2277	
	jalr %ra %a10 0 #2277
	addi %sp %sp -448 #2277
	lw %ra %sp 444 #2277
	addi %a0 %zero 0 #2283
