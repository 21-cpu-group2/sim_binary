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

l.93674:	# 128.000000
	1124073472
l.93234:	# 0.900000
	1063675494
l.93232:	# 0.200000
	1045220557
l.92174:	# 150.000000
	1125515264
l.92125:	# -150.000000
	-1021968384
l.92051:	# 0.100000
	1036831949
l.91952:	# -2.000000
	-1073741824
l.91937:	# 0.003906
	998244352
l.91808:	# 100000000.000000
	1287568416
l.91802:	# 1000000000.000000
	1315859240
l.91788:	# 20.000000
	1101004800
l.91786:	# 0.050000
	1028443341
l.91777:	# 0.250000
	1048576000
l.91768:	# 10.000000
	1092616192
l.91761:	# 0.300000
	1050253722
l.91759:	# 255.000000
	1132396544
l.91755:	# 0.500000
	1056964608
l.91753:	# 0.150000
	1041865114
l.91744:	# 3.141593
	1078530011
l.91742:	# 30.000000
	1106247680
l.91740:	# 15.000000
	1097859072
l.91738:	# 0.000100
	953267991
l.91269:	# -0.100000
	-1110651699
l.91125:	# 0.010000
	1008981770
l.91123:	# -0.200000
	-1102263091
l.90466:	# -1.000000
	-1082130432
l.90464:	# 1.000000
	1065353216
l.90418:	# 2.000000
	1073741824
l.90390:	# 0.000000
	0
l.90384:	# -200.000000
	-1018691584
l.90381:	# 200.000000
	1128792064
l.90378:	# 0.017453
	1016003125
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
	li %f1 l.90378 #541
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
	li %f1 l.90378 #541
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
	li %f3 l.90381 #559
	fmul %f2 %f2 %f3 #559
	lw %a0 %sp 12 #559
	sw %f2 %a0 0 #559
	li %f2 l.90384 #560
	lw %f3 %sp 40 #560
	fmul %f2 %f3 %f2 #560
	sw %f2 %a0 4 #560
	lw %f2 %sp 56 #561
	fmul %f4 %f1 %f2 #561
	li %f5 l.90381 #561
	fmul %f4 %f4 %f5 #561
	sw %f4 %a0 8 #561
	lw %a1 %sp 8 #563
	sw %f2 %a1 0 #563
	li %f4 l.90390 #564
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
	li %f0 l.90418 #634
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
	li %f0 l.90418 #635
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
	li %f0 l.90418 #636
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
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99025
	addi %a0 %zero 0 #720
	jalr %zero %ra 0 #720
beq_else.99025:
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
	li %f0 l.90390 #650
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
	li %f0 l.90390 #655
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
	li %f0 l.90390 #662
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
	li %f0 l.90390 #666
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
	li %f0 l.90390 #671
	add %a0 %a1 %zero
	sw %ra %sp 44 #671 call dir
	addi %sp %sp 48 #671	
	jal %ra min_caml_create_float_array #671
	addi %sp %sp -48 #671
	lw %ra %sp 44 #671
	lw %a1 %sp 20 #644
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99026 # nontail if
	jal %zero beq_cont.99027 # then sentence ends
beq_else.99026:
	sw %a0 %sp 44 #674
	sw %ra %sp 52 #674 call dir
	addi %sp %sp 56 #674	
	jal %ra min_caml_read_float #674
	addi %sp %sp -56 #674
	lw %ra %sp 52 #674
	li %f1 l.90378 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #674
	sw %f0 %a0 0 #674
	sw %ra %sp 52 #675 call dir
	addi %sp %sp 56 #675	
	jal %ra min_caml_read_float #675
	addi %sp %sp -56 #675
	lw %ra %sp 52 #675
	li %f1 l.90378 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #675
	sw %f0 %a0 4 #675
	sw %ra %sp 52 #676 call dir
	addi %sp %sp 56 #676	
	jal %ra min_caml_read_float #676
	addi %sp %sp -56 #676
	lw %ra %sp 52 #676
	li %f1 l.90378 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #676
	sw %f0 %a0 8 #676
beq_cont.99027:
	lw %a1 %sp 12 #644
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.99028 # nontail if
	addi %a2 %zero 1 #683
	jal %zero beq_cont.99029 # then sentence ends
beq_else.99028:
	lw %a2 %sp 32 #683
beq_cont.99029:
	addi %a3 %zero 4 #684
	li %f0 l.90390 #684
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
	bne %a4 %a12 beq_else.99030 # nontail if
	lw %f0 %a2 0 #650
	sw %f0 %sp 56 #701
	sw %ra %sp 68 #701 call dir
	addi %sp %sp 72 #701	
	jal %ra min_caml_fiszero #701
	addi %sp %sp -72 #701
	lw %ra %sp 68 #701
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99033 # nontail if
	lw %f0 %sp 56 #111
	sw %ra %sp 68 #111 call dir
	addi %sp %sp 72 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -72 #111
	lw %ra %sp 68 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99035 # nontail if
	lw %f0 %sp 56 #112
	sw %ra %sp 68 #112 call dir
	addi %sp %sp 72 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -72 #112
	lw %ra %sp 68 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99037 # nontail if
	li %f0 l.90466 #113
	jal %zero beq_cont.99038 # then sentence ends
beq_else.99037:
	li %f0 l.90464 #112
beq_cont.99038:
	jal %zero beq_cont.99036 # then sentence ends
beq_else.99035:
	li %f0 l.90390 #111
beq_cont.99036:
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
	jal %zero beq_cont.99034 # then sentence ends
beq_else.99033:
	li %f0 l.90390 #701
beq_cont.99034:
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
	bne %a0 %a12 beq_else.99039 # nontail if
	lw %f0 %sp 72 #111
	sw %ra %sp 84 #111 call dir
	addi %sp %sp 88 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -88 #111
	lw %ra %sp 84 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99041 # nontail if
	lw %f0 %sp 72 #112
	sw %ra %sp 84 #112 call dir
	addi %sp %sp 88 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -88 #112
	lw %ra %sp 84 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99043 # nontail if
	li %f0 l.90466 #113
	jal %zero beq_cont.99044 # then sentence ends
beq_else.99043:
	li %f0 l.90464 #112
beq_cont.99044:
	jal %zero beq_cont.99042 # then sentence ends
beq_else.99041:
	li %f0 l.90390 #111
beq_cont.99042:
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
	jal %zero beq_cont.99040 # then sentence ends
beq_else.99039:
	li %f0 l.90390 #703
beq_cont.99040:
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
	bne %a0 %a12 beq_else.99045 # nontail if
	lw %f0 %sp 88 #111
	sw %ra %sp 100 #111 call dir
	addi %sp %sp 104 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -104 #111
	lw %ra %sp 100 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99047 # nontail if
	lw %f0 %sp 88 #112
	sw %ra %sp 100 #112 call dir
	addi %sp %sp 104 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -104 #112
	lw %ra %sp 100 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99049 # nontail if
	li %f0 l.90466 #113
	jal %zero beq_cont.99050 # then sentence ends
beq_else.99049:
	li %f0 l.90464 #112
beq_cont.99050:
	jal %zero beq_cont.99048 # then sentence ends
beq_else.99047:
	li %f0 l.90390 #111
beq_cont.99048:
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
	jal %zero beq_cont.99046 # then sentence ends
beq_else.99045:
	li %f0 l.90390 #705
beq_cont.99046:
	lw %a0 %sp 24 #705
	sw %f0 %a0 8 #705
	jal %zero beq_cont.99031 # then sentence ends
beq_else.99030:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.99051 # nontail if
	lw %a1 %sp 32 #683
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99053 # nontail if
	addi %a1 %zero 1 #709
	jal %zero beq_cont.99054 # then sentence ends
beq_else.99053:
	addi %a1 %zero 0 #709
beq_cont.99054:
	lw %f0 %a2 0 #172
	sw %a1 %sp 104 #172
	sw %ra %sp 108 #172 call dir
	addi %sp %sp 112 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -112 #172
	lw %ra %sp 108 #172
	lw %a0 %sp 24 #172
	lw %f1 %a0 4 #172
	sw %f0 %sp 112 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 124 #172 call dir
	addi %sp %sp 128 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -128 #172
	lw %ra %sp 124 #172
	lw %f1 %sp 112 #172
	fadd %f0 %f1 %f0 #172
	lw %a0 %sp 24 #172
	lw %f1 %a0 8 #172
	sw %f0 %sp 120 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #172 call dir
	addi %sp %sp 136 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -136 #172
	lw %ra %sp 132 #172
	lw %f1 %sp 120 #172
	fadd %f0 %f1 %f0 #172
	sw %ra %sp 132 #172 call dir
	addi %sp %sp 136 #172	
	jal %ra min_caml_sqrt #172
	addi %sp %sp -136 #172
	lw %ra %sp 132 #172
	sw %f0 %sp 128 #173
	sw %ra %sp 140 #173 call dir
	addi %sp %sp 144 #173	
	jal %ra min_caml_fiszero #173
	addi %sp %sp -144 #173
	lw %ra %sp 140 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99056 # nontail if
	lw %a0 %sp 104 #709
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99058 # nontail if
	li %f0 l.90464 #173
	lw %f1 %sp 128 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.99059 # then sentence ends
beq_else.99058:
	li %f0 l.90466 #173
	lw %f1 %sp 128 #173
	fdiv %f0 %f0 %f1 #173
beq_cont.99059:
	jal %zero beq_cont.99057 # then sentence ends
beq_else.99056:
	li %f0 l.90464 #173
beq_cont.99057:
	lw %a0 %sp 24 #172
	lw %f1 %a0 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a0 0 #174
	lw %f1 %a0 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a0 4 #175
	lw %f1 %a0 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a0 8 #176
	jal %zero beq_cont.99052 # then sentence ends
beq_else.99051:
beq_cont.99052:
beq_cont.99031:
	lw %a0 %sp 20 #644
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99060 # nontail if
	jal %zero beq_cont.99061 # then sentence ends
beq_else.99060:
	lw %a0 %sp 24 #714
	lw %a1 %sp 44 #714
	sw %ra %sp 140 #714 call dir
	addi %sp %sp 144 #714	
	jal %ra rotate_quadratic_matrix.2366 #714
	addi %sp %sp -144 #714
	lw %ra %sp 140 #714
beq_cont.99061:
	addi %a0 %zero 1 #717
	jalr %zero %ra 0 #717
read_object.2371:
	lw %a1 %a11 8 #724
	lw %a2 %a11 4 #724
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99062
	jalr %zero %ra 0 #730
bge_else.99062:
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
	bne %a0 %a12 beq_else.99064
	lw %a0 %sp 8 #729
	lw %a1 %sp 12 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99064:
	lw %a0 %sp 12 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99066
	jalr %zero %ra 0 #730
bge_else.99066:
	lw %a11 %sp 4 #726
	sw %a0 %sp 16 #726
	sw %ra %sp 20 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 24 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -24 #726
	lw %ra %sp 20 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99068
	lw %a0 %sp 8 #729
	lw %a1 %sp 16 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99068:
	lw %a0 %sp 16 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99070
	jalr %zero %ra 0 #730
bge_else.99070:
	lw %a11 %sp 4 #726
	sw %a0 %sp 20 #726
	sw %ra %sp 28 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 32 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -32 #726
	lw %ra %sp 28 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99072
	lw %a0 %sp 8 #729
	lw %a1 %sp 20 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99072:
	lw %a0 %sp 20 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99074
	jalr %zero %ra 0 #730
bge_else.99074:
	lw %a11 %sp 4 #726
	sw %a0 %sp 24 #726
	sw %ra %sp 28 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 32 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -32 #726
	lw %ra %sp 28 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99076
	lw %a0 %sp 8 #729
	lw %a1 %sp 24 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99076:
	lw %a0 %sp 24 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99078
	jalr %zero %ra 0 #730
bge_else.99078:
	lw %a11 %sp 4 #726
	sw %a0 %sp 28 #726
	sw %ra %sp 36 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 40 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -40 #726
	lw %ra %sp 36 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99080
	lw %a0 %sp 8 #729
	lw %a1 %sp 28 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99080:
	lw %a0 %sp 28 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99082
	jalr %zero %ra 0 #730
bge_else.99082:
	lw %a11 %sp 4 #726
	sw %a0 %sp 32 #726
	sw %ra %sp 36 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 40 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -40 #726
	lw %ra %sp 36 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99084
	lw %a0 %sp 8 #729
	lw %a1 %sp 32 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99084:
	lw %a0 %sp 32 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99086
	jalr %zero %ra 0 #730
bge_else.99086:
	lw %a11 %sp 4 #726
	sw %a0 %sp 36 #726
	sw %ra %sp 44 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 48 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -48 #726
	lw %ra %sp 44 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99088
	lw %a0 %sp 8 #729
	lw %a1 %sp 36 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99088:
	lw %a0 %sp 36 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.99090
	jalr %zero %ra 0 #730
bge_else.99090:
	lw %a11 %sp 4 #726
	sw %a0 %sp 40 #726
	sw %ra %sp 44 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 48 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -48 #726
	lw %ra %sp 44 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99092
	lw %a0 %sp 8 #729
	lw %a1 %sp 40 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.99092:
	lw %a0 %sp 40 #727
	addi %a0 %a0 1 #727
	lw %a11 %sp 0 #727
	lw %a10 %a11 0 #727
	jalr %zero %a10 0 #727
read_net_item.2375:
	sw %a0 %sp 0 #741
	sw %ra %sp 4 #741 call dir
	addi %sp %sp 8 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -8 #741
	lw %ra %sp 4 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99094
	lw %a0 %sp 0 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	jal	%zero min_caml_create_array
beq_else.99094:
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
	bne %a0 %a12 beq_else.99095 # nontail if
	lw %a0 %sp 8 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.99096 # then sentence ends
beq_else.99095:
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
	bne %a0 %a12 beq_else.99097 # nontail if
	lw %a0 %sp 16 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.99098 # then sentence ends
beq_else.99097:
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
	bne %a0 %a12 beq_else.99099 # nontail if
	lw %a0 %sp 24 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.99100 # then sentence ends
beq_else.99099:
	lw %a1 %sp 24 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 28 #741
	sw %a2 %sp 32 #741
	sw %ra %sp 36 #741 call dir
	addi %sp %sp 40 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -40 #741
	lw %ra %sp 36 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99101 # nontail if
	lw %a0 %sp 32 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 36 #742 call dir
	addi %sp %sp 40 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -40 #742
	lw %ra %sp 36 #742
	jal %zero beq_cont.99102 # then sentence ends
beq_else.99101:
	lw %a1 %sp 32 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 36 #741
	sw %a2 %sp 40 #741
	sw %ra %sp 44 #741 call dir
	addi %sp %sp 48 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -48 #741
	lw %ra %sp 44 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99103 # nontail if
	lw %a0 %sp 40 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	jal %zero beq_cont.99104 # then sentence ends
beq_else.99103:
	lw %a1 %sp 40 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 44 #741
	sw %a2 %sp 48 #741
	sw %ra %sp 52 #741 call dir
	addi %sp %sp 56 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -56 #741
	lw %ra %sp 52 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99105 # nontail if
	lw %a0 %sp 48 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 52 #742 call dir
	addi %sp %sp 56 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -56 #742
	lw %ra %sp 52 #742
	jal %zero beq_cont.99106 # then sentence ends
beq_else.99105:
	lw %a1 %sp 48 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 52 #741
	sw %a2 %sp 56 #741
	sw %ra %sp 60 #741 call dir
	addi %sp %sp 64 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -64 #741
	lw %ra %sp 60 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99107 # nontail if
	lw %a0 %sp 56 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 60 #742 call dir
	addi %sp %sp 64 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -64 #742
	lw %ra %sp 60 #742
	jal %zero beq_cont.99108 # then sentence ends
beq_else.99107:
	lw %a1 %sp 56 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 60 #744
	add %a0 %a2 %zero
	sw %ra %sp 68 #744 call dir
	addi %sp %sp 72 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -72 #744
	lw %ra %sp 68 #744
	lw %a1 %sp 56 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 60 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.99108:
	lw %a1 %sp 48 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 52 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.99106:
	lw %a1 %sp 40 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 44 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.99104:
	lw %a1 %sp 32 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 36 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.99102:
	lw %a1 %sp 24 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 28 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.99100:
	lw %a1 %sp 16 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 20 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.99098:
	lw %a1 %sp 8 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 12 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.99096:
	lw %a1 %sp 0 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 4 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
	jalr %zero %ra 0 #745
read_or_network.2377:
	sw %a0 %sp 0 #741
	sw %ra %sp 4 #741 call dir
	addi %sp %sp 8 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -8 #741
	lw %ra %sp 4 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99109 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 4 #742 call dir
	addi %sp %sp 8 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -8 #742
	lw %ra %sp 4 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.99110 # then sentence ends
beq_else.99109:
	sw %a0 %sp 4 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99111 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.99112 # then sentence ends
beq_else.99111:
	sw %a0 %sp 8 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99113 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.99114 # then sentence ends
beq_else.99113:
	sw %a0 %sp 12 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99115 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.99116 # then sentence ends
beq_else.99115:
	sw %a0 %sp 16 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99117 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.99118 # then sentence ends
beq_else.99117:
	sw %a0 %sp 20 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99119 # nontail if
	addi %a0 %zero 6 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.99120 # then sentence ends
beq_else.99119:
	sw %a0 %sp 24 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99121 # nontail if
	addi %a0 %zero 7 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.99122 # then sentence ends
beq_else.99121:
	addi %a1 %zero 7 #744
	sw %a0 %sp 28 #744
	add %a0 %a1 %zero
	sw %ra %sp 36 #744 call dir
	addi %sp %sp 40 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -40 #744
	lw %ra %sp 36 #744
	lw %a1 %sp 28 #745
	sw %a1 %a0 24 #745
beq_cont.99122:
	lw %a1 %sp 24 #745
	sw %a1 %a0 20 #745
beq_cont.99120:
	lw %a1 %sp 20 #745
	sw %a1 %a0 16 #745
beq_cont.99118:
	lw %a1 %sp 16 #745
	sw %a1 %a0 12 #745
beq_cont.99116:
	lw %a1 %sp 12 #745
	sw %a1 %a0 8 #745
beq_cont.99114:
	lw %a1 %sp 8 #745
	sw %a1 %a0 4 #745
beq_cont.99112:
	lw %a1 %sp 4 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.99110:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99123
	lw %a0 %sp 0 #751
	addi %a0 %a0 1 #751
	jal	%zero min_caml_create_array
beq_else.99123:
	lw %a0 %sp 0 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 32 #741
	sw %a2 %sp 36 #741
	sw %ra %sp 44 #741 call dir
	addi %sp %sp 48 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -48 #741
	lw %ra %sp 44 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99124 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.99125 # then sentence ends
beq_else.99124:
	sw %a0 %sp 40 #741
	sw %ra %sp 44 #741 call dir
	addi %sp %sp 48 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -48 #741
	lw %ra %sp 44 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99126 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	jal %zero beq_cont.99127 # then sentence ends
beq_else.99126:
	sw %a0 %sp 44 #741
	sw %ra %sp 52 #741 call dir
	addi %sp %sp 56 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -56 #741
	lw %ra %sp 52 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99128 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 52 #742 call dir
	addi %sp %sp 56 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -56 #742
	lw %ra %sp 52 #742
	jal %zero beq_cont.99129 # then sentence ends
beq_else.99128:
	sw %a0 %sp 48 #741
	sw %ra %sp 52 #741 call dir
	addi %sp %sp 56 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -56 #741
	lw %ra %sp 52 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99130 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 52 #742 call dir
	addi %sp %sp 56 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -56 #742
	lw %ra %sp 52 #742
	jal %zero beq_cont.99131 # then sentence ends
beq_else.99130:
	sw %a0 %sp 52 #741
	sw %ra %sp 60 #741 call dir
	addi %sp %sp 64 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -64 #741
	lw %ra %sp 60 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99132 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 60 #742 call dir
	addi %sp %sp 64 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -64 #742
	lw %ra %sp 60 #742
	jal %zero beq_cont.99133 # then sentence ends
beq_else.99132:
	sw %a0 %sp 56 #741
	sw %ra %sp 60 #741 call dir
	addi %sp %sp 64 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -64 #741
	lw %ra %sp 60 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99134 # nontail if
	addi %a0 %zero 6 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 60 #742 call dir
	addi %sp %sp 64 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -64 #742
	lw %ra %sp 60 #742
	jal %zero beq_cont.99135 # then sentence ends
beq_else.99134:
	addi %a1 %zero 6 #744
	sw %a0 %sp 60 #744
	add %a0 %a1 %zero
	sw %ra %sp 68 #744 call dir
	addi %sp %sp 72 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -72 #744
	lw %ra %sp 68 #744
	lw %a1 %sp 60 #745
	sw %a1 %a0 20 #745
beq_cont.99135:
	lw %a1 %sp 56 #745
	sw %a1 %a0 16 #745
beq_cont.99133:
	lw %a1 %sp 52 #745
	sw %a1 %a0 12 #745
beq_cont.99131:
	lw %a1 %sp 48 #745
	sw %a1 %a0 8 #745
beq_cont.99129:
	lw %a1 %sp 44 #745
	sw %a1 %a0 4 #745
beq_cont.99127:
	lw %a1 %sp 40 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.99125:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99136 # nontail if
	lw %a0 %sp 36 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 68 #751 call dir
	addi %sp %sp 72 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -72 #751
	lw %ra %sp 68 #751
	jal %zero beq_cont.99137 # then sentence ends
beq_else.99136:
	lw %a0 %sp 36 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 64 #741
	sw %a2 %sp 68 #741
	sw %ra %sp 76 #741 call dir
	addi %sp %sp 80 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -80 #741
	lw %ra %sp 76 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99138 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 76 #742 call dir
	addi %sp %sp 80 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -80 #742
	lw %ra %sp 76 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.99139 # then sentence ends
beq_else.99138:
	sw %a0 %sp 72 #741
	sw %ra %sp 76 #741 call dir
	addi %sp %sp 80 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -80 #741
	lw %ra %sp 76 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99140 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 76 #742 call dir
	addi %sp %sp 80 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -80 #742
	lw %ra %sp 76 #742
	jal %zero beq_cont.99141 # then sentence ends
beq_else.99140:
	sw %a0 %sp 76 #741
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99142 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.99143 # then sentence ends
beq_else.99142:
	sw %a0 %sp 80 #741
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99144 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.99145 # then sentence ends
beq_else.99144:
	sw %a0 %sp 84 #741
	sw %ra %sp 92 #741 call dir
	addi %sp %sp 96 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -96 #741
	lw %ra %sp 92 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99146 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 92 #742 call dir
	addi %sp %sp 96 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -96 #742
	lw %ra %sp 92 #742
	jal %zero beq_cont.99147 # then sentence ends
beq_else.99146:
	addi %a1 %zero 5 #744
	sw %a0 %sp 88 #744
	add %a0 %a1 %zero
	sw %ra %sp 92 #744 call dir
	addi %sp %sp 96 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -96 #744
	lw %ra %sp 92 #744
	lw %a1 %sp 88 #745
	sw %a1 %a0 16 #745
beq_cont.99147:
	lw %a1 %sp 84 #745
	sw %a1 %a0 12 #745
beq_cont.99145:
	lw %a1 %sp 80 #745
	sw %a1 %a0 8 #745
beq_cont.99143:
	lw %a1 %sp 76 #745
	sw %a1 %a0 4 #745
beq_cont.99141:
	lw %a1 %sp 72 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.99139:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99148 # nontail if
	lw %a0 %sp 68 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 92 #751 call dir
	addi %sp %sp 96 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -96 #751
	lw %ra %sp 92 #751
	jal %zero beq_cont.99149 # then sentence ends
beq_else.99148:
	lw %a0 %sp 68 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 92 #741
	sw %a2 %sp 96 #741
	sw %ra %sp 100 #741 call dir
	addi %sp %sp 104 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -104 #741
	lw %ra %sp 100 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99150 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 100 #742 call dir
	addi %sp %sp 104 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -104 #742
	lw %ra %sp 100 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.99151 # then sentence ends
beq_else.99150:
	sw %a0 %sp 100 #741
	sw %ra %sp 108 #741 call dir
	addi %sp %sp 112 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -112 #741
	lw %ra %sp 108 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99152 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 108 #742 call dir
	addi %sp %sp 112 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -112 #742
	lw %ra %sp 108 #742
	jal %zero beq_cont.99153 # then sentence ends
beq_else.99152:
	sw %a0 %sp 104 #741
	sw %ra %sp 108 #741 call dir
	addi %sp %sp 112 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -112 #741
	lw %ra %sp 108 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99154 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 108 #742 call dir
	addi %sp %sp 112 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -112 #742
	lw %ra %sp 108 #742
	jal %zero beq_cont.99155 # then sentence ends
beq_else.99154:
	sw %a0 %sp 108 #741
	sw %ra %sp 116 #741 call dir
	addi %sp %sp 120 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -120 #741
	lw %ra %sp 116 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99156 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 116 #742 call dir
	addi %sp %sp 120 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -120 #742
	lw %ra %sp 116 #742
	jal %zero beq_cont.99157 # then sentence ends
beq_else.99156:
	addi %a1 %zero 4 #744
	sw %a0 %sp 112 #744
	add %a0 %a1 %zero
	sw %ra %sp 116 #744 call dir
	addi %sp %sp 120 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -120 #744
	lw %ra %sp 116 #744
	lw %a1 %sp 112 #745
	sw %a1 %a0 12 #745
beq_cont.99157:
	lw %a1 %sp 108 #745
	sw %a1 %a0 8 #745
beq_cont.99155:
	lw %a1 %sp 104 #745
	sw %a1 %a0 4 #745
beq_cont.99153:
	lw %a1 %sp 100 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.99151:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99158 # nontail if
	lw %a0 %sp 96 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 116 #751 call dir
	addi %sp %sp 120 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -120 #751
	lw %ra %sp 116 #751
	jal %zero beq_cont.99159 # then sentence ends
beq_else.99158:
	lw %a0 %sp 96 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 116 #753
	add %a0 %a2 %zero
	sw %ra %sp 124 #753 call dir
	addi %sp %sp 128 #753	
	jal %ra read_or_network.2377 #753
	addi %sp %sp -128 #753
	lw %ra %sp 124 #753
	lw %a1 %sp 96 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 116 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.99159:
	lw %a1 %sp 68 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 92 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.99149:
	lw %a1 %sp 36 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 64 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.99137:
	lw %a1 %sp 0 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 32 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
	jalr %zero %ra 0 #754
read_and_network.2379:
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
	bne %a0 %a12 beq_else.99160 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.99161 # then sentence ends
beq_else.99160:
	sw %a0 %sp 12 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99162 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.99163 # then sentence ends
beq_else.99162:
	sw %a0 %sp 16 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99164 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.99165 # then sentence ends
beq_else.99164:
	sw %a0 %sp 20 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99166 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.99167 # then sentence ends
beq_else.99166:
	sw %a0 %sp 24 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99168 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.99169 # then sentence ends
beq_else.99168:
	sw %a0 %sp 28 #741
	sw %ra %sp 36 #741 call dir
	addi %sp %sp 40 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -40 #741
	lw %ra %sp 36 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99170 # nontail if
	addi %a0 %zero 6 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 36 #742 call dir
	addi %sp %sp 40 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -40 #742
	lw %ra %sp 36 #742
	jal %zero beq_cont.99171 # then sentence ends
beq_else.99170:
	sw %a0 %sp 32 #741
	sw %ra %sp 36 #741 call dir
	addi %sp %sp 40 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -40 #741
	lw %ra %sp 36 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99172 # nontail if
	addi %a0 %zero 7 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 36 #742 call dir
	addi %sp %sp 40 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -40 #742
	lw %ra %sp 36 #742
	jal %zero beq_cont.99173 # then sentence ends
beq_else.99172:
	addi %a1 %zero 7 #744
	sw %a0 %sp 36 #744
	add %a0 %a1 %zero
	sw %ra %sp 44 #744 call dir
	addi %sp %sp 48 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -48 #744
	lw %ra %sp 44 #744
	lw %a1 %sp 36 #745
	sw %a1 %a0 24 #745
beq_cont.99173:
	lw %a1 %sp 32 #745
	sw %a1 %a0 20 #745
beq_cont.99171:
	lw %a1 %sp 28 #745
	sw %a1 %a0 16 #745
beq_cont.99169:
	lw %a1 %sp 24 #745
	sw %a1 %a0 12 #745
beq_cont.99167:
	lw %a1 %sp 20 #745
	sw %a1 %a0 8 #745
beq_cont.99165:
	lw %a1 %sp 16 #745
	sw %a1 %a0 4 #745
beq_cont.99163:
	lw %a1 %sp 12 #745
	sw %a1 %a0 0 #745
beq_cont.99161:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99174
	jalr %zero %ra 0 #759
beq_else.99174:
	lw %a1 %sp 8 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	sw %a0 %sp 40 #741
	sw %ra %sp 44 #741 call dir
	addi %sp %sp 48 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -48 #741
	lw %ra %sp 44 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99176 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	jal %zero beq_cont.99177 # then sentence ends
beq_else.99176:
	sw %a0 %sp 44 #741
	sw %ra %sp 52 #741 call dir
	addi %sp %sp 56 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -56 #741
	lw %ra %sp 52 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99178 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 52 #742 call dir
	addi %sp %sp 56 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -56 #742
	lw %ra %sp 52 #742
	jal %zero beq_cont.99179 # then sentence ends
beq_else.99178:
	sw %a0 %sp 48 #741
	sw %ra %sp 52 #741 call dir
	addi %sp %sp 56 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -56 #741
	lw %ra %sp 52 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99180 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 52 #742 call dir
	addi %sp %sp 56 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -56 #742
	lw %ra %sp 52 #742
	jal %zero beq_cont.99181 # then sentence ends
beq_else.99180:
	sw %a0 %sp 52 #741
	sw %ra %sp 60 #741 call dir
	addi %sp %sp 64 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -64 #741
	lw %ra %sp 60 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99182 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 60 #742 call dir
	addi %sp %sp 64 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -64 #742
	lw %ra %sp 60 #742
	jal %zero beq_cont.99183 # then sentence ends
beq_else.99182:
	sw %a0 %sp 56 #741
	sw %ra %sp 60 #741 call dir
	addi %sp %sp 64 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -64 #741
	lw %ra %sp 60 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99184 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 60 #742 call dir
	addi %sp %sp 64 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -64 #742
	lw %ra %sp 60 #742
	jal %zero beq_cont.99185 # then sentence ends
beq_else.99184:
	sw %a0 %sp 60 #741
	sw %ra %sp 68 #741 call dir
	addi %sp %sp 72 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -72 #741
	lw %ra %sp 68 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99186 # nontail if
	addi %a0 %zero 6 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 68 #742 call dir
	addi %sp %sp 72 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -72 #742
	lw %ra %sp 68 #742
	jal %zero beq_cont.99187 # then sentence ends
beq_else.99186:
	addi %a1 %zero 6 #744
	sw %a0 %sp 64 #744
	add %a0 %a1 %zero
	sw %ra %sp 68 #744 call dir
	addi %sp %sp 72 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -72 #744
	lw %ra %sp 68 #744
	lw %a1 %sp 64 #745
	sw %a1 %a0 20 #745
beq_cont.99187:
	lw %a1 %sp 60 #745
	sw %a1 %a0 16 #745
beq_cont.99185:
	lw %a1 %sp 56 #745
	sw %a1 %a0 12 #745
beq_cont.99183:
	lw %a1 %sp 52 #745
	sw %a1 %a0 8 #745
beq_cont.99181:
	lw %a1 %sp 48 #745
	sw %a1 %a0 4 #745
beq_cont.99179:
	lw %a1 %sp 44 #745
	sw %a1 %a0 0 #745
beq_cont.99177:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99188
	jalr %zero %ra 0 #759
beq_else.99188:
	lw %a1 %sp 40 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	sw %a0 %sp 68 #741
	sw %ra %sp 76 #741 call dir
	addi %sp %sp 80 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -80 #741
	lw %ra %sp 76 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99190 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 76 #742 call dir
	addi %sp %sp 80 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -80 #742
	lw %ra %sp 76 #742
	jal %zero beq_cont.99191 # then sentence ends
beq_else.99190:
	sw %a0 %sp 72 #741
	sw %ra %sp 76 #741 call dir
	addi %sp %sp 80 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -80 #741
	lw %ra %sp 76 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99192 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 76 #742 call dir
	addi %sp %sp 80 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -80 #742
	lw %ra %sp 76 #742
	jal %zero beq_cont.99193 # then sentence ends
beq_else.99192:
	sw %a0 %sp 76 #741
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99194 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.99195 # then sentence ends
beq_else.99194:
	sw %a0 %sp 80 #741
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99196 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.99197 # then sentence ends
beq_else.99196:
	sw %a0 %sp 84 #741
	sw %ra %sp 92 #741 call dir
	addi %sp %sp 96 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -96 #741
	lw %ra %sp 92 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99198 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 92 #742 call dir
	addi %sp %sp 96 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -96 #742
	lw %ra %sp 92 #742
	jal %zero beq_cont.99199 # then sentence ends
beq_else.99198:
	addi %a1 %zero 5 #744
	sw %a0 %sp 88 #744
	add %a0 %a1 %zero
	sw %ra %sp 92 #744 call dir
	addi %sp %sp 96 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -96 #744
	lw %ra %sp 92 #744
	lw %a1 %sp 88 #745
	sw %a1 %a0 16 #745
beq_cont.99199:
	lw %a1 %sp 84 #745
	sw %a1 %a0 12 #745
beq_cont.99197:
	lw %a1 %sp 80 #745
	sw %a1 %a0 8 #745
beq_cont.99195:
	lw %a1 %sp 76 #745
	sw %a1 %a0 4 #745
beq_cont.99193:
	lw %a1 %sp 72 #745
	sw %a1 %a0 0 #745
beq_cont.99191:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99200
	jalr %zero %ra 0 #759
beq_else.99200:
	lw %a1 %sp 68 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	sw %a0 %sp 92 #741
	sw %ra %sp 100 #741 call dir
	addi %sp %sp 104 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -104 #741
	lw %ra %sp 100 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99202 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 100 #742 call dir
	addi %sp %sp 104 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -104 #742
	lw %ra %sp 100 #742
	jal %zero beq_cont.99203 # then sentence ends
beq_else.99202:
	sw %a0 %sp 96 #741
	sw %ra %sp 100 #741 call dir
	addi %sp %sp 104 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -104 #741
	lw %ra %sp 100 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99204 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 100 #742 call dir
	addi %sp %sp 104 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -104 #742
	lw %ra %sp 100 #742
	jal %zero beq_cont.99205 # then sentence ends
beq_else.99204:
	sw %a0 %sp 100 #741
	sw %ra %sp 108 #741 call dir
	addi %sp %sp 112 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -112 #741
	lw %ra %sp 108 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99206 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 108 #742 call dir
	addi %sp %sp 112 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -112 #742
	lw %ra %sp 108 #742
	jal %zero beq_cont.99207 # then sentence ends
beq_else.99206:
	sw %a0 %sp 104 #741
	sw %ra %sp 108 #741 call dir
	addi %sp %sp 112 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -112 #741
	lw %ra %sp 108 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99208 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 108 #742 call dir
	addi %sp %sp 112 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -112 #742
	lw %ra %sp 108 #742
	jal %zero beq_cont.99209 # then sentence ends
beq_else.99208:
	addi %a1 %zero 4 #744
	sw %a0 %sp 108 #744
	add %a0 %a1 %zero
	sw %ra %sp 116 #744 call dir
	addi %sp %sp 120 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -120 #744
	lw %ra %sp 116 #744
	lw %a1 %sp 108 #745
	sw %a1 %a0 12 #745
beq_cont.99209:
	lw %a1 %sp 104 #745
	sw %a1 %a0 8 #745
beq_cont.99207:
	lw %a1 %sp 100 #745
	sw %a1 %a0 4 #745
beq_cont.99205:
	lw %a1 %sp 96 #745
	sw %a1 %a0 0 #745
beq_cont.99203:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99210
	jalr %zero %ra 0 #759
beq_else.99210:
	lw %a1 %sp 92 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	lw %a11 %sp 0 #762
	lw %a10 %a11 0 #762
	jalr %zero %a10 0 #762
read_parameter.2381:
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
	li %f1 l.90378 #541
	fmul %f0 %f0 %f1 #541
	sw %f0 %sp 32 #584
	sw %ra %sp 44 #584 call dir
	addi %sp %sp 48 #584	
	jal %ra min_caml_sin #584
	addi %sp %sp -48 #584
	lw %ra %sp 44 #584
	sw %ra %sp 44 #585 call dir
	addi %sp %sp 48 #585	
	jal %ra min_caml_fneg #585
	addi %sp %sp -48 #585
	lw %ra %sp 44 #585
	lw %a0 %sp 28 #585
	sw %f0 %a0 4 #585
	sw %ra %sp 44 #586 call dir
	addi %sp %sp 48 #586	
	jal %ra min_caml_read_float #586
	addi %sp %sp -48 #586
	lw %ra %sp 44 #586
	li %f1 l.90378 #541
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
	bne %a0 %a12 beq_else.99212 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 56 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.99213 # then sentence ends
beq_else.99212:
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
	bne %a0 %a12 beq_else.99214 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 60 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.99215 # then sentence ends
beq_else.99214:
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
	bne %a0 %a12 beq_else.99216 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 64 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.99217 # then sentence ends
beq_else.99216:
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
	bne %a0 %a12 beq_else.99218 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 68 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.99219 # then sentence ends
beq_else.99218:
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
	bne %a0 %a12 beq_else.99220 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 72 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.99221 # then sentence ends
beq_else.99220:
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
	bne %a0 %a12 beq_else.99222 # nontail if
	lw %a0 %sp 16 #729
	lw %a1 %sp 76 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.99223 # then sentence ends
beq_else.99222:
	addi %a0 %zero 6 #727
	lw %a11 %sp 12 #727
	sw %ra %sp 84 #727 call cls
	lw %a10 %a11 0 #727
	addi %sp %sp 88 #727	
	jalr %ra %a10 0 #727
	addi %sp %sp -88 #727
	lw %ra %sp 84 #727
beq_cont.99223:
beq_cont.99221:
beq_cont.99219:
beq_cont.99217:
beq_cont.99215:
beq_cont.99213:
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99224 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.99225 # then sentence ends
beq_else.99224:
	sw %a0 %sp 80 #741
	sw %ra %sp 84 #741 call dir
	addi %sp %sp 88 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -88 #741
	lw %ra %sp 84 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99226 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 84 #742 call dir
	addi %sp %sp 88 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -88 #742
	lw %ra %sp 84 #742
	jal %zero beq_cont.99227 # then sentence ends
beq_else.99226:
	sw %a0 %sp 84 #741
	sw %ra %sp 92 #741 call dir
	addi %sp %sp 96 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -96 #741
	lw %ra %sp 92 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99228 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 92 #742 call dir
	addi %sp %sp 96 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -96 #742
	lw %ra %sp 92 #742
	jal %zero beq_cont.99229 # then sentence ends
beq_else.99228:
	sw %a0 %sp 88 #741
	sw %ra %sp 92 #741 call dir
	addi %sp %sp 96 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -96 #741
	lw %ra %sp 92 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99230 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 92 #742 call dir
	addi %sp %sp 96 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -96 #742
	lw %ra %sp 92 #742
	jal %zero beq_cont.99231 # then sentence ends
beq_else.99230:
	sw %a0 %sp 92 #741
	sw %ra %sp 100 #741 call dir
	addi %sp %sp 104 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -104 #741
	lw %ra %sp 100 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99232 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 100 #742 call dir
	addi %sp %sp 104 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -104 #742
	lw %ra %sp 100 #742
	jal %zero beq_cont.99233 # then sentence ends
beq_else.99232:
	sw %a0 %sp 96 #741
	sw %ra %sp 100 #741 call dir
	addi %sp %sp 104 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -104 #741
	lw %ra %sp 100 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99234 # nontail if
	addi %a0 %zero 6 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 100 #742 call dir
	addi %sp %sp 104 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -104 #742
	lw %ra %sp 100 #742
	jal %zero beq_cont.99235 # then sentence ends
beq_else.99234:
	addi %a1 %zero 6 #744
	sw %a0 %sp 100 #744
	add %a0 %a1 %zero
	sw %ra %sp 108 #744 call dir
	addi %sp %sp 112 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -112 #744
	lw %ra %sp 108 #744
	lw %a1 %sp 100 #745
	sw %a1 %a0 20 #745
beq_cont.99235:
	lw %a1 %sp 96 #745
	sw %a1 %a0 16 #745
beq_cont.99233:
	lw %a1 %sp 92 #745
	sw %a1 %a0 12 #745
beq_cont.99231:
	lw %a1 %sp 88 #745
	sw %a1 %a0 8 #745
beq_cont.99229:
	lw %a1 %sp 84 #745
	sw %a1 %a0 4 #745
beq_cont.99227:
	lw %a1 %sp 80 #745
	sw %a1 %a0 0 #745
beq_cont.99225:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99236 # nontail if
	jal %zero beq_cont.99237 # then sentence ends
beq_else.99236:
	lw %a1 %sp 8 #761
	sw %a0 %a1 0 #761
	sw %ra %sp 108 #741 call dir
	addi %sp %sp 112 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -112 #741
	lw %ra %sp 108 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99238 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 108 #742 call dir
	addi %sp %sp 112 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -112 #742
	lw %ra %sp 108 #742
	jal %zero beq_cont.99239 # then sentence ends
beq_else.99238:
	sw %a0 %sp 104 #741
	sw %ra %sp 108 #741 call dir
	addi %sp %sp 112 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -112 #741
	lw %ra %sp 108 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99240 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 108 #742 call dir
	addi %sp %sp 112 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -112 #742
	lw %ra %sp 108 #742
	jal %zero beq_cont.99241 # then sentence ends
beq_else.99240:
	sw %a0 %sp 108 #741
	sw %ra %sp 116 #741 call dir
	addi %sp %sp 120 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -120 #741
	lw %ra %sp 116 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99242 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 116 #742 call dir
	addi %sp %sp 120 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -120 #742
	lw %ra %sp 116 #742
	jal %zero beq_cont.99243 # then sentence ends
beq_else.99242:
	sw %a0 %sp 112 #741
	sw %ra %sp 116 #741 call dir
	addi %sp %sp 120 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -120 #741
	lw %ra %sp 116 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99244 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 116 #742 call dir
	addi %sp %sp 120 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -120 #742
	lw %ra %sp 116 #742
	jal %zero beq_cont.99245 # then sentence ends
beq_else.99244:
	sw %a0 %sp 116 #741
	sw %ra %sp 124 #741 call dir
	addi %sp %sp 128 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -128 #741
	lw %ra %sp 124 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99246 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 124 #742 call dir
	addi %sp %sp 128 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -128 #742
	lw %ra %sp 124 #742
	jal %zero beq_cont.99247 # then sentence ends
beq_else.99246:
	addi %a1 %zero 5 #744
	sw %a0 %sp 120 #744
	add %a0 %a1 %zero
	sw %ra %sp 124 #744 call dir
	addi %sp %sp 128 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -128 #744
	lw %ra %sp 124 #744
	lw %a1 %sp 120 #745
	sw %a1 %a0 16 #745
beq_cont.99247:
	lw %a1 %sp 116 #745
	sw %a1 %a0 12 #745
beq_cont.99245:
	lw %a1 %sp 112 #745
	sw %a1 %a0 8 #745
beq_cont.99243:
	lw %a1 %sp 108 #745
	sw %a1 %a0 4 #745
beq_cont.99241:
	lw %a1 %sp 104 #745
	sw %a1 %a0 0 #745
beq_cont.99239:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99248 # nontail if
	jal %zero beq_cont.99249 # then sentence ends
beq_else.99248:
	lw %a1 %sp 8 #761
	sw %a0 %a1 4 #761
	sw %ra %sp 124 #741 call dir
	addi %sp %sp 128 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -128 #741
	lw %ra %sp 124 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99250 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 124 #742 call dir
	addi %sp %sp 128 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -128 #742
	lw %ra %sp 124 #742
	jal %zero beq_cont.99251 # then sentence ends
beq_else.99250:
	sw %a0 %sp 124 #741
	sw %ra %sp 132 #741 call dir
	addi %sp %sp 136 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -136 #741
	lw %ra %sp 132 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99252 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 132 #742 call dir
	addi %sp %sp 136 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -136 #742
	lw %ra %sp 132 #742
	jal %zero beq_cont.99253 # then sentence ends
beq_else.99252:
	sw %a0 %sp 128 #741
	sw %ra %sp 132 #741 call dir
	addi %sp %sp 136 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -136 #741
	lw %ra %sp 132 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99254 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 132 #742 call dir
	addi %sp %sp 136 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -136 #742
	lw %ra %sp 132 #742
	jal %zero beq_cont.99255 # then sentence ends
beq_else.99254:
	sw %a0 %sp 132 #741
	sw %ra %sp 140 #741 call dir
	addi %sp %sp 144 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -144 #741
	lw %ra %sp 140 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99256 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 140 #742 call dir
	addi %sp %sp 144 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -144 #742
	lw %ra %sp 140 #742
	jal %zero beq_cont.99257 # then sentence ends
beq_else.99256:
	addi %a1 %zero 4 #744
	sw %a0 %sp 136 #744
	add %a0 %a1 %zero
	sw %ra %sp 140 #744 call dir
	addi %sp %sp 144 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -144 #744
	lw %ra %sp 140 #744
	lw %a1 %sp 136 #745
	sw %a1 %a0 12 #745
beq_cont.99257:
	lw %a1 %sp 132 #745
	sw %a1 %a0 8 #745
beq_cont.99255:
	lw %a1 %sp 128 #745
	sw %a1 %a0 4 #745
beq_cont.99253:
	lw %a1 %sp 124 #745
	sw %a1 %a0 0 #745
beq_cont.99251:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99258 # nontail if
	jal %zero beq_cont.99259 # then sentence ends
beq_else.99258:
	lw %a1 %sp 8 #761
	sw %a0 %a1 8 #761
	addi %a0 %zero 3 #762
	lw %a11 %sp 4 #762
	sw %ra %sp 140 #762 call cls
	lw %a10 %a11 0 #762
	addi %sp %sp 144 #762	
	jalr %ra %a10 0 #762
	addi %sp %sp -144 #762
	lw %ra %sp 140 #762
beq_cont.99259:
beq_cont.99249:
beq_cont.99237:
	sw %ra %sp 140 #741 call dir
	addi %sp %sp 144 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -144 #741
	lw %ra %sp 140 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99260 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 140 #742 call dir
	addi %sp %sp 144 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -144 #742
	lw %ra %sp 140 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.99261 # then sentence ends
beq_else.99260:
	sw %a0 %sp 140 #741
	sw %ra %sp 148 #741 call dir
	addi %sp %sp 152 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -152 #741
	lw %ra %sp 148 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99262 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 148 #742 call dir
	addi %sp %sp 152 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -152 #742
	lw %ra %sp 148 #742
	jal %zero beq_cont.99263 # then sentence ends
beq_else.99262:
	sw %a0 %sp 144 #741
	sw %ra %sp 148 #741 call dir
	addi %sp %sp 152 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -152 #741
	lw %ra %sp 148 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99264 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 148 #742 call dir
	addi %sp %sp 152 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -152 #742
	lw %ra %sp 148 #742
	jal %zero beq_cont.99265 # then sentence ends
beq_else.99264:
	sw %a0 %sp 148 #741
	sw %ra %sp 156 #741 call dir
	addi %sp %sp 160 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -160 #741
	lw %ra %sp 156 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99266 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 156 #742 call dir
	addi %sp %sp 160 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -160 #742
	lw %ra %sp 156 #742
	jal %zero beq_cont.99267 # then sentence ends
beq_else.99266:
	sw %a0 %sp 152 #741
	sw %ra %sp 156 #741 call dir
	addi %sp %sp 160 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -160 #741
	lw %ra %sp 156 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99268 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 156 #742 call dir
	addi %sp %sp 160 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -160 #742
	lw %ra %sp 156 #742
	jal %zero beq_cont.99269 # then sentence ends
beq_else.99268:
	sw %a0 %sp 156 #741
	sw %ra %sp 164 #741 call dir
	addi %sp %sp 168 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -168 #741
	lw %ra %sp 164 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99270 # nontail if
	addi %a0 %zero 6 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 164 #742 call dir
	addi %sp %sp 168 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -168 #742
	lw %ra %sp 164 #742
	jal %zero beq_cont.99271 # then sentence ends
beq_else.99270:
	addi %a1 %zero 6 #744
	sw %a0 %sp 160 #744
	add %a0 %a1 %zero
	sw %ra %sp 164 #744 call dir
	addi %sp %sp 168 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -168 #744
	lw %ra %sp 164 #744
	lw %a1 %sp 160 #745
	sw %a1 %a0 20 #745
beq_cont.99271:
	lw %a1 %sp 156 #745
	sw %a1 %a0 16 #745
beq_cont.99269:
	lw %a1 %sp 152 #745
	sw %a1 %a0 12 #745
beq_cont.99267:
	lw %a1 %sp 148 #745
	sw %a1 %a0 8 #745
beq_cont.99265:
	lw %a1 %sp 144 #745
	sw %a1 %a0 4 #745
beq_cont.99263:
	lw %a1 %sp 140 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.99261:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99272 # nontail if
	addi %a0 %zero 1 #751
	sw %ra %sp 164 #751 call dir
	addi %sp %sp 168 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -168 #751
	lw %ra %sp 164 #751
	jal %zero beq_cont.99273 # then sentence ends
beq_else.99272:
	sw %a1 %sp 164 #741
	sw %ra %sp 172 #741 call dir
	addi %sp %sp 176 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -176 #741
	lw %ra %sp 172 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99274 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 172 #742 call dir
	addi %sp %sp 176 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -176 #742
	lw %ra %sp 172 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.99275 # then sentence ends
beq_else.99274:
	sw %a0 %sp 168 #741
	sw %ra %sp 172 #741 call dir
	addi %sp %sp 176 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -176 #741
	lw %ra %sp 172 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99276 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 172 #742 call dir
	addi %sp %sp 176 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -176 #742
	lw %ra %sp 172 #742
	jal %zero beq_cont.99277 # then sentence ends
beq_else.99276:
	sw %a0 %sp 172 #741
	sw %ra %sp 180 #741 call dir
	addi %sp %sp 184 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -184 #741
	lw %ra %sp 180 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99278 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 180 #742 call dir
	addi %sp %sp 184 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -184 #742
	lw %ra %sp 180 #742
	jal %zero beq_cont.99279 # then sentence ends
beq_else.99278:
	sw %a0 %sp 176 #741
	sw %ra %sp 180 #741 call dir
	addi %sp %sp 184 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -184 #741
	lw %ra %sp 180 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99280 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 180 #742 call dir
	addi %sp %sp 184 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -184 #742
	lw %ra %sp 180 #742
	jal %zero beq_cont.99281 # then sentence ends
beq_else.99280:
	sw %a0 %sp 180 #741
	sw %ra %sp 188 #741 call dir
	addi %sp %sp 192 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -192 #741
	lw %ra %sp 188 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99282 # nontail if
	addi %a0 %zero 5 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 188 #742 call dir
	addi %sp %sp 192 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -192 #742
	lw %ra %sp 188 #742
	jal %zero beq_cont.99283 # then sentence ends
beq_else.99282:
	addi %a1 %zero 5 #744
	sw %a0 %sp 184 #744
	add %a0 %a1 %zero
	sw %ra %sp 188 #744 call dir
	addi %sp %sp 192 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -192 #744
	lw %ra %sp 188 #744
	lw %a1 %sp 184 #745
	sw %a1 %a0 16 #745
beq_cont.99283:
	lw %a1 %sp 180 #745
	sw %a1 %a0 12 #745
beq_cont.99281:
	lw %a1 %sp 176 #745
	sw %a1 %a0 8 #745
beq_cont.99279:
	lw %a1 %sp 172 #745
	sw %a1 %a0 4 #745
beq_cont.99277:
	lw %a1 %sp 168 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.99275:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99284 # nontail if
	addi %a0 %zero 2 #751
	sw %ra %sp 188 #751 call dir
	addi %sp %sp 192 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -192 #751
	lw %ra %sp 188 #751
	jal %zero beq_cont.99285 # then sentence ends
beq_else.99284:
	sw %a1 %sp 188 #741
	sw %ra %sp 196 #741 call dir
	addi %sp %sp 200 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -200 #741
	lw %ra %sp 196 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99286 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 196 #742 call dir
	addi %sp %sp 200 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -200 #742
	lw %ra %sp 196 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.99287 # then sentence ends
beq_else.99286:
	sw %a0 %sp 192 #741
	sw %ra %sp 196 #741 call dir
	addi %sp %sp 200 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -200 #741
	lw %ra %sp 196 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99288 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 196 #742 call dir
	addi %sp %sp 200 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -200 #742
	lw %ra %sp 196 #742
	jal %zero beq_cont.99289 # then sentence ends
beq_else.99288:
	sw %a0 %sp 196 #741
	sw %ra %sp 204 #741 call dir
	addi %sp %sp 208 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -208 #741
	lw %ra %sp 204 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99290 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 204 #742 call dir
	addi %sp %sp 208 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -208 #742
	lw %ra %sp 204 #742
	jal %zero beq_cont.99291 # then sentence ends
beq_else.99290:
	sw %a0 %sp 200 #741
	sw %ra %sp 204 #741 call dir
	addi %sp %sp 208 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -208 #741
	lw %ra %sp 204 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99292 # nontail if
	addi %a0 %zero 4 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 204 #742 call dir
	addi %sp %sp 208 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -208 #742
	lw %ra %sp 204 #742
	jal %zero beq_cont.99293 # then sentence ends
beq_else.99292:
	addi %a1 %zero 4 #744
	sw %a0 %sp 204 #744
	add %a0 %a1 %zero
	sw %ra %sp 212 #744 call dir
	addi %sp %sp 216 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -216 #744
	lw %ra %sp 212 #744
	lw %a1 %sp 204 #745
	sw %a1 %a0 12 #745
beq_cont.99293:
	lw %a1 %sp 200 #745
	sw %a1 %a0 8 #745
beq_cont.99291:
	lw %a1 %sp 196 #745
	sw %a1 %a0 4 #745
beq_cont.99289:
	lw %a1 %sp 192 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.99287:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99294 # nontail if
	addi %a0 %zero 3 #751
	sw %ra %sp 212 #751 call dir
	addi %sp %sp 216 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -216 #751
	lw %ra %sp 212 #751
	jal %zero beq_cont.99295 # then sentence ends
beq_else.99294:
	addi %a0 %zero 3 #753
	sw %a1 %sp 208 #753
	sw %ra %sp 212 #753 call dir
	addi %sp %sp 216 #753	
	jal %ra read_or_network.2377 #753
	addi %sp %sp -216 #753
	lw %ra %sp 212 #753
	lw %a1 %sp 208 #754
	sw %a1 %a0 8 #754
beq_cont.99295:
	lw %a1 %sp 188 #754
	sw %a1 %a0 4 #754
beq_cont.99285:
	lw %a1 %sp 164 #754
	sw %a1 %a0 0 #754
beq_cont.99273:
	lw %a1 %sp 0 #772
	sw %a0 %a1 0 #772
	jalr %zero %ra 0 #772
solver_rect.2392:
	lw %a2 %a11 4 #797
	lw %f3 %a1 0 #783
	sw %a2 %sp 0 #783
	sw %f2 %sp 8 #783
	sw %f1 %sp 16 #783
	sw %f0 %sp 24 #783
	sw %a1 %sp 32 #783
	sw %a0 %sp 36 #783
	fadd %f0 %f3 %fzero
	sw %ra %sp 44 #783 call dir
	addi %sp %sp 48 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -48 #783
	lw %ra %sp 44 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99298 # nontail if
	lw %a0 %sp 36 #306
	lw %a1 %a0 16 #306
	lw %a2 %a0 24 #258
	lw %a3 %sp 32 #783
	lw %f0 %a3 0 #783
	sw %a1 %sp 40 #785
	sw %a2 %sp 44 #785
	sw %ra %sp 52 #785 call dir
	addi %sp %sp 56 #785	
	jal %ra min_caml_fisneg #785
	addi %sp %sp -56 #785
	lw %ra %sp 52 #785
	lw %a1 %sp 44 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99300 # nontail if
	jal %zero beq_cont.99301 # then sentence ends
beq_else.99300:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99302 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99303 # then sentence ends
beq_else.99302:
	addi %a0 %zero 0 #105
beq_cont.99303:
beq_cont.99301:
	lw %a1 %sp 40 #785
	lw %f0 %a1 0 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99304 # nontail if
	sw %ra %sp 52 #118 call dir
	addi %sp %sp 56 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -56 #118
	lw %ra %sp 52 #118
	jal %zero beq_cont.99305 # then sentence ends
beq_else.99304:
beq_cont.99305:
	lw %f1 %sp 24 #787
	fsub %f0 %f0 %f1 #787
	lw %a0 %sp 32 #783
	lw %f2 %a0 0 #783
	fdiv %f0 %f0 %f2 #787
	lw %f2 %a0 4 #783
	fmul %f2 %f0 %f2 #788
	lw %f3 %sp 16 #788
	fadd %f2 %f2 %f3 #788
	sw %f0 %sp 48 #788
	fadd %f0 %f2 %fzero
	sw %ra %sp 60 #788 call dir
	addi %sp %sp 64 #788	
	jal %ra min_caml_fabs #788
	addi %sp %sp -64 #788
	lw %ra %sp 60 #788
	lw %a0 %sp 40 #785
	lw %f1 %a0 4 #785
	sw %ra %sp 60 #788 call dir
	addi %sp %sp 64 #788	
	jal %ra min_caml_fless #788
	addi %sp %sp -64 #788
	lw %ra %sp 60 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99306 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99307 # then sentence ends
beq_else.99306:
	lw %a0 %sp 32 #783
	lw %f0 %a0 8 #783
	lw %f1 %sp 48 #789
	fmul %f0 %f1 %f0 #789
	lw %f2 %sp 8 #789
	fadd %f0 %f0 %f2 #789
	sw %ra %sp 60 #789 call dir
	addi %sp %sp 64 #789	
	jal %ra min_caml_fabs #789
	addi %sp %sp -64 #789
	lw %ra %sp 60 #789
	lw %a0 %sp 40 #785
	lw %f1 %a0 8 #785
	sw %ra %sp 60 #789 call dir
	addi %sp %sp 64 #789	
	jal %ra min_caml_fless #789
	addi %sp %sp -64 #789
	lw %ra %sp 60 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99308 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99309 # then sentence ends
beq_else.99308:
	lw %a0 %sp 0 #790
	lw %f0 %sp 48 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.99309:
beq_cont.99307:
	jal %zero beq_cont.99299 # then sentence ends
beq_else.99298:
	addi %a0 %zero 0 #783
beq_cont.99299:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99310
	lw %a0 %sp 32 #783
	lw %f0 %a0 4 #783
	sw %ra %sp 60 #783 call dir
	addi %sp %sp 64 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -64 #783
	lw %ra %sp 60 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99311 # nontail if
	lw %a0 %sp 36 #306
	lw %a1 %a0 16 #306
	lw %a2 %a0 24 #258
	lw %a3 %sp 32 #783
	lw %f0 %a3 4 #783
	sw %a1 %sp 56 #785
	sw %a2 %sp 60 #785
	sw %ra %sp 68 #785 call dir
	addi %sp %sp 72 #785	
	jal %ra min_caml_fisneg #785
	addi %sp %sp -72 #785
	lw %ra %sp 68 #785
	lw %a1 %sp 60 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99313 # nontail if
	jal %zero beq_cont.99314 # then sentence ends
beq_else.99313:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99315 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99316 # then sentence ends
beq_else.99315:
	addi %a0 %zero 0 #105
beq_cont.99316:
beq_cont.99314:
	lw %a1 %sp 56 #785
	lw %f0 %a1 4 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99317 # nontail if
	sw %ra %sp 68 #118 call dir
	addi %sp %sp 72 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -72 #118
	lw %ra %sp 68 #118
	jal %zero beq_cont.99318 # then sentence ends
beq_else.99317:
beq_cont.99318:
	lw %f1 %sp 16 #787
	fsub %f0 %f0 %f1 #787
	lw %a0 %sp 32 #783
	lw %f2 %a0 4 #783
	fdiv %f0 %f0 %f2 #787
	lw %f2 %a0 8 #783
	fmul %f2 %f0 %f2 #788
	lw %f3 %sp 8 #788
	fadd %f2 %f2 %f3 #788
	sw %f0 %sp 64 #788
	fadd %f0 %f2 %fzero
	sw %ra %sp 76 #788 call dir
	addi %sp %sp 80 #788	
	jal %ra min_caml_fabs #788
	addi %sp %sp -80 #788
	lw %ra %sp 76 #788
	lw %a0 %sp 56 #785
	lw %f1 %a0 8 #785
	sw %ra %sp 76 #788 call dir
	addi %sp %sp 80 #788	
	jal %ra min_caml_fless #788
	addi %sp %sp -80 #788
	lw %ra %sp 76 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99319 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99320 # then sentence ends
beq_else.99319:
	lw %a0 %sp 32 #783
	lw %f0 %a0 0 #783
	lw %f1 %sp 64 #789
	fmul %f0 %f1 %f0 #789
	lw %f2 %sp 24 #789
	fadd %f0 %f0 %f2 #789
	sw %ra %sp 76 #789 call dir
	addi %sp %sp 80 #789	
	jal %ra min_caml_fabs #789
	addi %sp %sp -80 #789
	lw %ra %sp 76 #789
	lw %a0 %sp 56 #785
	lw %f1 %a0 0 #785
	sw %ra %sp 76 #789 call dir
	addi %sp %sp 80 #789	
	jal %ra min_caml_fless #789
	addi %sp %sp -80 #789
	lw %ra %sp 76 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99321 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99322 # then sentence ends
beq_else.99321:
	lw %a0 %sp 0 #790
	lw %f0 %sp 64 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.99322:
beq_cont.99320:
	jal %zero beq_cont.99312 # then sentence ends
beq_else.99311:
	addi %a0 %zero 0 #783
beq_cont.99312:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99323
	lw %a0 %sp 32 #783
	lw %f0 %a0 8 #783
	sw %ra %sp 76 #783 call dir
	addi %sp %sp 80 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -80 #783
	lw %ra %sp 76 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99324 # nontail if
	lw %a0 %sp 36 #306
	lw %a1 %a0 16 #306
	lw %a0 %a0 24 #258
	lw %a2 %sp 32 #783
	lw %f0 %a2 8 #783
	sw %a1 %sp 72 #785
	sw %a0 %sp 76 #785
	sw %ra %sp 84 #785 call dir
	addi %sp %sp 88 #785	
	jal %ra min_caml_fisneg #785
	addi %sp %sp -88 #785
	lw %ra %sp 84 #785
	lw %a1 %sp 76 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99326 # nontail if
	jal %zero beq_cont.99327 # then sentence ends
beq_else.99326:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99328 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99329 # then sentence ends
beq_else.99328:
	addi %a0 %zero 0 #105
beq_cont.99329:
beq_cont.99327:
	lw %a1 %sp 72 #785
	lw %f0 %a1 8 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99330 # nontail if
	sw %ra %sp 84 #118 call dir
	addi %sp %sp 88 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -88 #118
	lw %ra %sp 84 #118
	jal %zero beq_cont.99331 # then sentence ends
beq_else.99330:
beq_cont.99331:
	lw %f1 %sp 8 #787
	fsub %f0 %f0 %f1 #787
	lw %a0 %sp 32 #783
	lw %f1 %a0 8 #783
	fdiv %f0 %f0 %f1 #787
	lw %f1 %a0 0 #783
	fmul %f1 %f0 %f1 #788
	lw %f2 %sp 24 #788
	fadd %f1 %f1 %f2 #788
	sw %f0 %sp 80 #788
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #788 call dir
	addi %sp %sp 96 #788	
	jal %ra min_caml_fabs #788
	addi %sp %sp -96 #788
	lw %ra %sp 92 #788
	lw %a0 %sp 72 #785
	lw %f1 %a0 0 #785
	sw %ra %sp 92 #788 call dir
	addi %sp %sp 96 #788	
	jal %ra min_caml_fless #788
	addi %sp %sp -96 #788
	lw %ra %sp 92 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99332 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99333 # then sentence ends
beq_else.99332:
	lw %a0 %sp 32 #783
	lw %f0 %a0 4 #783
	lw %f1 %sp 80 #789
	fmul %f0 %f1 %f0 #789
	lw %f2 %sp 16 #789
	fadd %f0 %f0 %f2 #789
	sw %ra %sp 92 #789 call dir
	addi %sp %sp 96 #789	
	jal %ra min_caml_fabs #789
	addi %sp %sp -96 #789
	lw %ra %sp 92 #789
	lw %a0 %sp 72 #785
	lw %f1 %a0 4 #785
	sw %ra %sp 92 #789 call dir
	addi %sp %sp 96 #789	
	jal %ra min_caml_fless #789
	addi %sp %sp -96 #789
	lw %ra %sp 92 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99334 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99335 # then sentence ends
beq_else.99334:
	lw %a0 %sp 0 #790
	lw %f0 %sp 80 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.99335:
beq_cont.99333:
	jal %zero beq_cont.99325 # then sentence ends
beq_else.99324:
	addi %a0 %zero 0 #783
beq_cont.99325:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99336
	addi %a0 %zero 0 #798
	jalr %zero %ra 0 #798
beq_else.99336:
	addi %a0 %zero 3 #800
	jalr %zero %ra 0 #800
beq_else.99323:
	addi %a0 %zero 2 #799
	jalr %zero %ra 0 #799
beq_else.99310:
	addi %a0 %zero 1 #798
	jalr %zero %ra 0 #798
solver_second.2417:
	lw %a2 %a11 4 #854
	lw %f3 %a1 0 #858
	lw %f4 %a1 4 #858
	lw %f5 %a1 8 #858
	sw %a2 %sp 0 #822
	sw %f2 %sp 8 #822
	sw %f1 %sp 16 #822
	sw %f0 %sp 24 #822
	sw %a1 %sp 32 #822
	sw %f3 %sp 40 #822
	sw %f5 %sp 48 #822
	sw %f4 %sp 56 #822
	sw %a0 %sp 64 #822
	fadd %f0 %f3 %fzero
	sw %ra %sp 68 #822 call dir
	addi %sp %sp 72 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -72 #822
	lw %ra %sp 68 #822
	lw %a0 %sp 64 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 56 #822
	sw %f0 %sp 72 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #822 call dir
	addi %sp %sp 88 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -88 #822
	lw %ra %sp 84 #822
	lw %a0 %sp 64 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 72 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 48 #822
	sw %f0 %sp 80 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #822 call dir
	addi %sp %sp 96 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -96 #822
	lw %ra %sp 92 #822
	lw %a0 %sp 64 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 80 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99340 # nontail if
	jal %zero beq_cont.99341 # then sentence ends
beq_else.99340:
	lw %f1 %sp 48 #828
	lw %f2 %sp 56 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 40 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99341:
	sw %f0 %sp 88 #860
	sw %ra %sp 100 #860 call dir
	addi %sp %sp 104 #860	
	jal %ra min_caml_fiszero #860
	addi %sp %sp -104 #860
	lw %ra %sp 100 #860
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99342
	lw %a0 %sp 32 #858
	lw %f0 %a0 0 #858
	lw %f1 %a0 4 #858
	lw %f2 %a0 8 #858
	lw %f3 %sp 24 #837
	fmul %f4 %f0 %f3 #837
	lw %a0 %sp 64 #276
	lw %a1 %a0 16 #276
	lw %f5 %a1 0 #281
	fmul %f4 %f4 %f5 #837
	lw %f5 %sp 16 #838
	fmul %f6 %f1 %f5 #838
	lw %a1 %a0 16 #286
	lw %f7 %a1 4 #291
	fmul %f6 %f6 %f7 #838
	fadd %f4 %f4 %f6 #837
	lw %f6 %sp 8 #839
	fmul %f7 %f2 %f6 #839
	lw %a1 %a0 16 #296
	lw %f8 %a1 8 #301
	fmul %f7 %f7 %f8 #839
	fadd %f4 %f4 %f7 #837
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99343 # nontail if
	fadd %f0 %f4 %fzero #837
	jal %zero beq_cont.99344 # then sentence ends
beq_else.99343:
	fmul %f7 %f2 %f5 #845
	fmul %f8 %f1 %f6 #845
	fadd %f7 %f7 %f8 #845
	lw %a1 %a0 36 #396
	lw %f8 %a1 0 #401
	fmul %f7 %f7 %f8 #845
	fmul %f8 %f0 %f6 #846
	fmul %f2 %f2 %f3 #846
	fadd %f2 %f8 %f2 #846
	lw %a1 %a0 36 #406
	lw %f8 %a1 4 #411
	fmul %f2 %f2 %f8 #846
	fadd %f2 %f7 %f2 #845
	fmul %f0 %f0 %f5 #847
	fmul %f1 %f1 %f3 #847
	fadd %f0 %f0 %f1 #847
	lw %a1 %a0 36 #416
	lw %f1 %a1 8 #421
	fmul %f0 %f0 %f1 #847
	fadd %f0 %f2 %f0 #845
	sw %f4 %sp 96 #844
	sw %ra %sp 108 #844 call dir
	addi %sp %sp 112 #844	
	jal %ra min_caml_fhalf #844
	addi %sp %sp -112 #844
	lw %ra %sp 108 #844
	lw %f1 %sp 96 #844
	fadd %f0 %f1 %f0 #844
beq_cont.99344:
	lw %f1 %sp 24 #822
	sw %f0 %sp 104 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 116 #822 call dir
	addi %sp %sp 120 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -120 #822
	lw %ra %sp 116 #822
	lw %a0 %sp 64 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 16 #822
	sw %f0 %sp 112 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 124 #822 call dir
	addi %sp %sp 128 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -128 #822
	lw %ra %sp 124 #822
	lw %a0 %sp 64 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 112 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 8 #822
	sw %f0 %sp 120 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #822 call dir
	addi %sp %sp 136 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -136 #822
	lw %ra %sp 132 #822
	lw %a0 %sp 64 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 120 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99345 # nontail if
	jal %zero beq_cont.99346 # then sentence ends
beq_else.99345:
	lw %f1 %sp 8 #828
	lw %f2 %sp 16 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 24 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99346:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99347 # nontail if
	li %f1 l.90464 #868
	fsub %f0 %f0 %f1 #868
	jal %zero beq_cont.99348 # then sentence ends
beq_else.99347:
beq_cont.99348:
	lw %f1 %sp 104 #870
	sw %f0 %sp 128 #870
	fadd %f0 %f1 %fzero
	sw %ra %sp 140 #870 call dir
	addi %sp %sp 144 #870	
	jal %ra min_caml_fsqr #870
	addi %sp %sp -144 #870
	lw %ra %sp 140 #870
	lw %f1 %sp 128 #870
	lw %f2 %sp 88 #870
	fmul %f1 %f2 %f1 #870
	fsub %f0 %f0 %f1 #870
	sw %f0 %sp 136 #872
	sw %ra %sp 148 #872 call dir
	addi %sp %sp 152 #872	
	jal %ra min_caml_fispos #872
	addi %sp %sp -152 #872
	lw %ra %sp 148 #872
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99349
	addi %a0 %zero 0 #860
	jalr %zero %ra 0 #860
beq_else.99349:
	lw %f0 %sp 136 #873
	sw %ra %sp 148 #873 call dir
	addi %sp %sp 152 #873	
	jal %ra min_caml_sqrt #873
	addi %sp %sp -152 #873
	lw %ra %sp 148 #873
	lw %a0 %sp 64 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99350 # nontail if
	sw %ra %sp 148 #874 call dir
	addi %sp %sp 152 #874	
	jal %ra min_caml_fneg #874
	addi %sp %sp -152 #874
	lw %ra %sp 148 #874
	jal %zero beq_cont.99351 # then sentence ends
beq_else.99350:
beq_cont.99351:
	lw %f1 %sp 104 #875
	fsub %f0 %f0 %f1 #875
	lw %f1 %sp 88 #875
	fdiv %f0 %f0 %f1 #875
	lw %a0 %sp 0 #875
	sw %f0 %a0 0 #875
	addi %a0 %zero 1 #875
	jalr %zero %ra 0 #875
beq_else.99342:
	addi %a0 %zero 0 #860
	jalr %zero %ra 0 #860
solver.2423:
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
	bne %a2 %a12 beq_else.99352
	lw %f3 %a1 0 #783
	sw %a3 %sp 0 #783
	sw %f2 %sp 8 #783
	sw %f1 %sp 16 #783
	sw %f0 %sp 24 #783
	sw %a1 %sp 32 #783
	sw %a0 %sp 36 #783
	fadd %f0 %f3 %fzero
	sw %ra %sp 44 #783 call dir
	addi %sp %sp 48 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -48 #783
	lw %ra %sp 44 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99354 # nontail if
	lw %a0 %sp 36 #306
	lw %a1 %a0 16 #306
	lw %a2 %a0 24 #258
	lw %a3 %sp 32 #783
	lw %f0 %a3 0 #783
	sw %a1 %sp 40 #785
	sw %a2 %sp 44 #785
	sw %ra %sp 52 #785 call dir
	addi %sp %sp 56 #785	
	jal %ra min_caml_fisneg #785
	addi %sp %sp -56 #785
	lw %ra %sp 52 #785
	lw %a1 %sp 44 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99356 # nontail if
	jal %zero beq_cont.99357 # then sentence ends
beq_else.99356:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99358 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99359 # then sentence ends
beq_else.99358:
	addi %a0 %zero 0 #105
beq_cont.99359:
beq_cont.99357:
	lw %a1 %sp 40 #785
	lw %f0 %a1 0 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99360 # nontail if
	sw %ra %sp 52 #118 call dir
	addi %sp %sp 56 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -56 #118
	lw %ra %sp 52 #118
	jal %zero beq_cont.99361 # then sentence ends
beq_else.99360:
beq_cont.99361:
	lw %f1 %sp 24 #787
	fsub %f0 %f0 %f1 #787
	lw %a0 %sp 32 #783
	lw %f2 %a0 0 #783
	fdiv %f0 %f0 %f2 #787
	lw %f2 %a0 4 #783
	fmul %f2 %f0 %f2 #788
	lw %f3 %sp 16 #788
	fadd %f2 %f2 %f3 #788
	sw %f0 %sp 48 #788
	fadd %f0 %f2 %fzero
	sw %ra %sp 60 #788 call dir
	addi %sp %sp 64 #788	
	jal %ra min_caml_fabs #788
	addi %sp %sp -64 #788
	lw %ra %sp 60 #788
	lw %a0 %sp 40 #785
	lw %f1 %a0 4 #785
	sw %ra %sp 60 #788 call dir
	addi %sp %sp 64 #788	
	jal %ra min_caml_fless #788
	addi %sp %sp -64 #788
	lw %ra %sp 60 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99362 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99363 # then sentence ends
beq_else.99362:
	lw %a0 %sp 32 #783
	lw %f0 %a0 8 #783
	lw %f1 %sp 48 #789
	fmul %f0 %f1 %f0 #789
	lw %f2 %sp 8 #789
	fadd %f0 %f0 %f2 #789
	sw %ra %sp 60 #789 call dir
	addi %sp %sp 64 #789	
	jal %ra min_caml_fabs #789
	addi %sp %sp -64 #789
	lw %ra %sp 60 #789
	lw %a0 %sp 40 #785
	lw %f1 %a0 8 #785
	sw %ra %sp 60 #789 call dir
	addi %sp %sp 64 #789	
	jal %ra min_caml_fless #789
	addi %sp %sp -64 #789
	lw %ra %sp 60 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99364 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99365 # then sentence ends
beq_else.99364:
	lw %a0 %sp 0 #790
	lw %f0 %sp 48 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.99365:
beq_cont.99363:
	jal %zero beq_cont.99355 # then sentence ends
beq_else.99354:
	addi %a0 %zero 0 #783
beq_cont.99355:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99366
	lw %a0 %sp 32 #783
	lw %f0 %a0 4 #783
	sw %ra %sp 60 #783 call dir
	addi %sp %sp 64 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -64 #783
	lw %ra %sp 60 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99367 # nontail if
	lw %a0 %sp 36 #306
	lw %a1 %a0 16 #306
	lw %a2 %a0 24 #258
	lw %a3 %sp 32 #783
	lw %f0 %a3 4 #783
	sw %a1 %sp 56 #785
	sw %a2 %sp 60 #785
	sw %ra %sp 68 #785 call dir
	addi %sp %sp 72 #785	
	jal %ra min_caml_fisneg #785
	addi %sp %sp -72 #785
	lw %ra %sp 68 #785
	lw %a1 %sp 60 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99369 # nontail if
	jal %zero beq_cont.99370 # then sentence ends
beq_else.99369:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99371 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99372 # then sentence ends
beq_else.99371:
	addi %a0 %zero 0 #105
beq_cont.99372:
beq_cont.99370:
	lw %a1 %sp 56 #785
	lw %f0 %a1 4 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99373 # nontail if
	sw %ra %sp 68 #118 call dir
	addi %sp %sp 72 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -72 #118
	lw %ra %sp 68 #118
	jal %zero beq_cont.99374 # then sentence ends
beq_else.99373:
beq_cont.99374:
	lw %f1 %sp 16 #787
	fsub %f0 %f0 %f1 #787
	lw %a0 %sp 32 #783
	lw %f2 %a0 4 #783
	fdiv %f0 %f0 %f2 #787
	lw %f2 %a0 8 #783
	fmul %f2 %f0 %f2 #788
	lw %f3 %sp 8 #788
	fadd %f2 %f2 %f3 #788
	sw %f0 %sp 64 #788
	fadd %f0 %f2 %fzero
	sw %ra %sp 76 #788 call dir
	addi %sp %sp 80 #788	
	jal %ra min_caml_fabs #788
	addi %sp %sp -80 #788
	lw %ra %sp 76 #788
	lw %a0 %sp 56 #785
	lw %f1 %a0 8 #785
	sw %ra %sp 76 #788 call dir
	addi %sp %sp 80 #788	
	jal %ra min_caml_fless #788
	addi %sp %sp -80 #788
	lw %ra %sp 76 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99375 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99376 # then sentence ends
beq_else.99375:
	lw %a0 %sp 32 #783
	lw %f0 %a0 0 #783
	lw %f1 %sp 64 #789
	fmul %f0 %f1 %f0 #789
	lw %f2 %sp 24 #789
	fadd %f0 %f0 %f2 #789
	sw %ra %sp 76 #789 call dir
	addi %sp %sp 80 #789	
	jal %ra min_caml_fabs #789
	addi %sp %sp -80 #789
	lw %ra %sp 76 #789
	lw %a0 %sp 56 #785
	lw %f1 %a0 0 #785
	sw %ra %sp 76 #789 call dir
	addi %sp %sp 80 #789	
	jal %ra min_caml_fless #789
	addi %sp %sp -80 #789
	lw %ra %sp 76 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99377 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99378 # then sentence ends
beq_else.99377:
	lw %a0 %sp 0 #790
	lw %f0 %sp 64 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.99378:
beq_cont.99376:
	jal %zero beq_cont.99368 # then sentence ends
beq_else.99367:
	addi %a0 %zero 0 #783
beq_cont.99368:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99379
	lw %a0 %sp 32 #783
	lw %f0 %a0 8 #783
	sw %ra %sp 76 #783 call dir
	addi %sp %sp 80 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -80 #783
	lw %ra %sp 76 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99380 # nontail if
	lw %a0 %sp 36 #306
	lw %a1 %a0 16 #306
	lw %a0 %a0 24 #258
	lw %a2 %sp 32 #783
	lw %f0 %a2 8 #783
	sw %a1 %sp 72 #785
	sw %a0 %sp 76 #785
	sw %ra %sp 84 #785 call dir
	addi %sp %sp 88 #785	
	jal %ra min_caml_fisneg #785
	addi %sp %sp -88 #785
	lw %ra %sp 84 #785
	lw %a1 %sp 76 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99382 # nontail if
	jal %zero beq_cont.99383 # then sentence ends
beq_else.99382:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99384 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99385 # then sentence ends
beq_else.99384:
	addi %a0 %zero 0 #105
beq_cont.99385:
beq_cont.99383:
	lw %a1 %sp 72 #785
	lw %f0 %a1 8 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99386 # nontail if
	sw %ra %sp 84 #118 call dir
	addi %sp %sp 88 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -88 #118
	lw %ra %sp 84 #118
	jal %zero beq_cont.99387 # then sentence ends
beq_else.99386:
beq_cont.99387:
	lw %f1 %sp 8 #787
	fsub %f0 %f0 %f1 #787
	lw %a0 %sp 32 #783
	lw %f1 %a0 8 #783
	fdiv %f0 %f0 %f1 #787
	lw %f1 %a0 0 #783
	fmul %f1 %f0 %f1 #788
	lw %f2 %sp 24 #788
	fadd %f1 %f1 %f2 #788
	sw %f0 %sp 80 #788
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #788 call dir
	addi %sp %sp 96 #788	
	jal %ra min_caml_fabs #788
	addi %sp %sp -96 #788
	lw %ra %sp 92 #788
	lw %a0 %sp 72 #785
	lw %f1 %a0 0 #785
	sw %ra %sp 92 #788 call dir
	addi %sp %sp 96 #788	
	jal %ra min_caml_fless #788
	addi %sp %sp -96 #788
	lw %ra %sp 92 #788
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99388 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99389 # then sentence ends
beq_else.99388:
	lw %a0 %sp 32 #783
	lw %f0 %a0 4 #783
	lw %f1 %sp 80 #789
	fmul %f0 %f1 %f0 #789
	lw %f2 %sp 16 #789
	fadd %f0 %f0 %f2 #789
	sw %ra %sp 92 #789 call dir
	addi %sp %sp 96 #789	
	jal %ra min_caml_fabs #789
	addi %sp %sp -96 #789
	lw %ra %sp 92 #789
	lw %a0 %sp 72 #785
	lw %f1 %a0 4 #785
	sw %ra %sp 92 #789 call dir
	addi %sp %sp 96 #789	
	jal %ra min_caml_fless #789
	addi %sp %sp -96 #789
	lw %ra %sp 92 #789
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99390 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.99391 # then sentence ends
beq_else.99390:
	lw %a0 %sp 0 #790
	lw %f0 %sp 80 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.99391:
beq_cont.99389:
	jal %zero beq_cont.99381 # then sentence ends
beq_else.99380:
	addi %a0 %zero 0 #783
beq_cont.99381:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99392
	addi %a0 %zero 0 #798
	jalr %zero %ra 0 #798
beq_else.99392:
	addi %a0 %zero 3 #800
	jalr %zero %ra 0 #800
beq_else.99379:
	addi %a0 %zero 2 #799
	jalr %zero %ra 0 #799
beq_else.99366:
	addi %a0 %zero 1 #798
	jalr %zero %ra 0 #798
beq_else.99352:
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.99393
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
	sw %a3 %sp 0 #811
	sw %f3 %sp 88 #811
	sw %f2 %sp 8 #811
	sw %f1 %sp 16 #811
	sw %f0 %sp 24 #811
	sw %a0 %sp 96 #811
	fadd %f0 %f3 %fzero
	sw %ra %sp 100 #811 call dir
	addi %sp %sp 104 #811	
	jal %ra min_caml_fispos #811
	addi %sp %sp -104 #811
	lw %ra %sp 100 #811
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99394
	addi %a0 %zero 0 #811
	jalr %zero %ra 0 #811
beq_else.99394:
	lw %a0 %sp 96 #186
	lw %f0 %a0 0 #186
	lw %f1 %sp 24 #186
	fmul %f0 %f0 %f1 #186
	lw %f1 %a0 4 #186
	lw %f2 %sp 16 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a0 8 #186
	lw %f2 %sp 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	sw %ra %sp 100 #812 call dir
	addi %sp %sp 104 #812	
	jal %ra min_caml_fneg #812
	addi %sp %sp -104 #812
	lw %ra %sp 100 #812
	lw %f1 %sp 88 #812
	fdiv %f0 %f0 %f1 #812
	lw %a0 %sp 0 #812
	sw %f0 %a0 0 #812
	addi %a0 %zero 1 #813
	jalr %zero %ra 0 #813
beq_else.99393:
	lw %f3 %a1 0 #858
	lw %f4 %a1 4 #858
	lw %f5 %a1 8 #858
	sw %a3 %sp 0 #822
	sw %f2 %sp 8 #822
	sw %f1 %sp 16 #822
	sw %f0 %sp 24 #822
	sw %a1 %sp 32 #822
	sw %f3 %sp 104 #822
	sw %f5 %sp 112 #822
	sw %f4 %sp 120 #822
	sw %a0 %sp 36 #822
	fadd %f0 %f3 %fzero
	sw %ra %sp 132 #822 call dir
	addi %sp %sp 136 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -136 #822
	lw %ra %sp 132 #822
	lw %a0 %sp 36 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 120 #822
	sw %f0 %sp 128 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 140 #822 call dir
	addi %sp %sp 144 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -144 #822
	lw %ra %sp 140 #822
	lw %a0 %sp 36 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 128 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 112 #822
	sw %f0 %sp 136 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 148 #822 call dir
	addi %sp %sp 152 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -152 #822
	lw %ra %sp 148 #822
	lw %a0 %sp 36 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 136 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99396 # nontail if
	jal %zero beq_cont.99397 # then sentence ends
beq_else.99396:
	lw %f1 %sp 112 #828
	lw %f2 %sp 120 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 104 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99397:
	sw %f0 %sp 144 #860
	sw %ra %sp 156 #860 call dir
	addi %sp %sp 160 #860	
	jal %ra min_caml_fiszero #860
	addi %sp %sp -160 #860
	lw %ra %sp 156 #860
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99398
	lw %a0 %sp 32 #858
	lw %f0 %a0 0 #858
	lw %f1 %a0 4 #858
	lw %f2 %a0 8 #858
	lw %f3 %sp 24 #837
	fmul %f4 %f0 %f3 #837
	lw %a0 %sp 36 #276
	lw %a1 %a0 16 #276
	lw %f5 %a1 0 #281
	fmul %f4 %f4 %f5 #837
	lw %f5 %sp 16 #838
	fmul %f6 %f1 %f5 #838
	lw %a1 %a0 16 #286
	lw %f7 %a1 4 #291
	fmul %f6 %f6 %f7 #838
	fadd %f4 %f4 %f6 #837
	lw %f6 %sp 8 #839
	fmul %f7 %f2 %f6 #839
	lw %a1 %a0 16 #296
	lw %f8 %a1 8 #301
	fmul %f7 %f7 %f8 #839
	fadd %f4 %f4 %f7 #837
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99399 # nontail if
	fadd %f0 %f4 %fzero #837
	jal %zero beq_cont.99400 # then sentence ends
beq_else.99399:
	fmul %f7 %f2 %f5 #845
	fmul %f8 %f1 %f6 #845
	fadd %f7 %f7 %f8 #845
	lw %a1 %a0 36 #396
	lw %f8 %a1 0 #401
	fmul %f7 %f7 %f8 #845
	fmul %f8 %f0 %f6 #846
	fmul %f2 %f2 %f3 #846
	fadd %f2 %f8 %f2 #846
	lw %a1 %a0 36 #406
	lw %f8 %a1 4 #411
	fmul %f2 %f2 %f8 #846
	fadd %f2 %f7 %f2 #845
	fmul %f0 %f0 %f5 #847
	fmul %f1 %f1 %f3 #847
	fadd %f0 %f0 %f1 #847
	lw %a1 %a0 36 #416
	lw %f1 %a1 8 #421
	fmul %f0 %f0 %f1 #847
	fadd %f0 %f2 %f0 #845
	sw %f4 %sp 152 #844
	sw %ra %sp 164 #844 call dir
	addi %sp %sp 168 #844	
	jal %ra min_caml_fhalf #844
	addi %sp %sp -168 #844
	lw %ra %sp 164 #844
	lw %f1 %sp 152 #844
	fadd %f0 %f1 %f0 #844
beq_cont.99400:
	lw %f1 %sp 24 #822
	sw %f0 %sp 160 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 172 #822 call dir
	addi %sp %sp 176 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -176 #822
	lw %ra %sp 172 #822
	lw %a0 %sp 36 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 16 #822
	sw %f0 %sp 168 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 180 #822 call dir
	addi %sp %sp 184 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -184 #822
	lw %ra %sp 180 #822
	lw %a0 %sp 36 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 168 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 8 #822
	sw %f0 %sp 176 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 188 #822 call dir
	addi %sp %sp 192 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -192 #822
	lw %ra %sp 188 #822
	lw %a0 %sp 36 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 176 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99401 # nontail if
	jal %zero beq_cont.99402 # then sentence ends
beq_else.99401:
	lw %f1 %sp 8 #828
	lw %f2 %sp 16 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 24 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99402:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99403 # nontail if
	li %f1 l.90464 #868
	fsub %f0 %f0 %f1 #868
	jal %zero beq_cont.99404 # then sentence ends
beq_else.99403:
beq_cont.99404:
	lw %f1 %sp 160 #870
	sw %f0 %sp 184 #870
	fadd %f0 %f1 %fzero
	sw %ra %sp 196 #870 call dir
	addi %sp %sp 200 #870	
	jal %ra min_caml_fsqr #870
	addi %sp %sp -200 #870
	lw %ra %sp 196 #870
	lw %f1 %sp 184 #870
	lw %f2 %sp 144 #870
	fmul %f1 %f2 %f1 #870
	fsub %f0 %f0 %f1 #870
	sw %f0 %sp 192 #872
	sw %ra %sp 204 #872 call dir
	addi %sp %sp 208 #872	
	jal %ra min_caml_fispos #872
	addi %sp %sp -208 #872
	lw %ra %sp 204 #872
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99405
	addi %a0 %zero 0 #860
	jalr %zero %ra 0 #860
beq_else.99405:
	lw %f0 %sp 192 #873
	sw %ra %sp 204 #873 call dir
	addi %sp %sp 208 #873	
	jal %ra min_caml_sqrt #873
	addi %sp %sp -208 #873
	lw %ra %sp 204 #873
	lw %a0 %sp 36 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99406 # nontail if
	sw %ra %sp 204 #874 call dir
	addi %sp %sp 208 #874	
	jal %ra min_caml_fneg #874
	addi %sp %sp -208 #874
	lw %ra %sp 204 #874
	jal %zero beq_cont.99407 # then sentence ends
beq_else.99406:
beq_cont.99407:
	lw %f1 %sp 160 #875
	fsub %f0 %f0 %f1 #875
	lw %f1 %sp 144 #875
	fdiv %f0 %f0 %f1 #875
	lw %a0 %sp 0 #875
	sw %f0 %a0 0 #875
	addi %a0 %zero 1 #875
	jalr %zero %ra 0 #875
beq_else.99398:
	addi %a0 %zero 0 #860
	jalr %zero %ra 0 #860
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
	lw %a0 %sp 52 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 60 #903 call dir
	addi %sp %sp 64 #903	
	jal %ra min_caml_fless #903
	addi %sp %sp -64 #903
	lw %ra %sp 60 #903
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99410 # nontail if
	addi %a0 %zero 0 #903
	jal %zero beq_cont.99411 # then sentence ends
beq_else.99410:
	lw %a0 %sp 48 #903
	lw %f0 %a0 8 #903
	lw %f1 %sp 40 #904
	fmul %f0 %f1 %f0 #904
	lw %f2 %sp 32 #904
	fadd %f0 %f0 %f2 #904
	sw %ra %sp 60 #904 call dir
	addi %sp %sp 64 #904	
	jal %ra min_caml_fabs #904
	addi %sp %sp -64 #904
	lw %ra %sp 60 #904
	lw %a0 %sp 52 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 60 #904 call dir
	addi %sp %sp 64 #904	
	jal %ra min_caml_fless #904
	addi %sp %sp -64 #904
	lw %ra %sp 60 #904
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99412 # nontail if
	addi %a0 %zero 0 #903
	jal %zero beq_cont.99413 # then sentence ends
beq_else.99412:
	lw %a0 %sp 24 #901
	lw %f0 %a0 4 #901
	sw %ra %sp 60 #905 call dir
	addi %sp %sp 64 #905	
	jal %ra min_caml_fiszero #905
	addi %sp %sp -64 #905
	lw %ra %sp 60 #905
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99414 # nontail if
	addi %a0 %zero 1 #905
	jal %zero beq_cont.99415 # then sentence ends
beq_else.99414:
	addi %a0 %zero 0 #903
beq_cont.99415:
beq_cont.99413:
beq_cont.99411:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99416
	lw %a0 %sp 24 #901
	lw %f0 %a0 8 #901
	lw %f1 %sp 16 #910
	fsub %f0 %f0 %f1 #910
	lw %f2 %a0 12 #901
	fmul %f0 %f0 %f2 #910
	lw %a1 %sp 48 #903
	lw %f2 %a1 0 #903
	fmul %f2 %f0 %f2 #912
	lw %f3 %sp 8 #912
	fadd %f2 %f2 %f3 #912
	sw %f0 %sp 56 #912
	fadd %f0 %f2 %fzero
	sw %ra %sp 68 #912 call dir
	addi %sp %sp 72 #912	
	jal %ra min_caml_fabs #912
	addi %sp %sp -72 #912
	lw %ra %sp 68 #912
	lw %a0 %sp 52 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 68 #912 call dir
	addi %sp %sp 72 #912	
	jal %ra min_caml_fless #912
	addi %sp %sp -72 #912
	lw %ra %sp 68 #912
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99417 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.99418 # then sentence ends
beq_else.99417:
	lw %a0 %sp 48 #903
	lw %f0 %a0 8 #903
	lw %f1 %sp 56 #913
	fmul %f0 %f1 %f0 #913
	lw %f2 %sp 32 #913
	fadd %f0 %f0 %f2 #913
	sw %ra %sp 68 #913 call dir
	addi %sp %sp 72 #913	
	jal %ra min_caml_fabs #913
	addi %sp %sp -72 #913
	lw %ra %sp 68 #913
	lw %a0 %sp 52 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 68 #913 call dir
	addi %sp %sp 72 #913	
	jal %ra min_caml_fless #913
	addi %sp %sp -72 #913
	lw %ra %sp 68 #913
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99419 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.99420 # then sentence ends
beq_else.99419:
	lw %a0 %sp 24 #901
	lw %f0 %a0 12 #901
	sw %ra %sp 68 #914 call dir
	addi %sp %sp 72 #914	
	jal %ra min_caml_fiszero #914
	addi %sp %sp -72 #914
	lw %ra %sp 68 #914
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99421 # nontail if
	addi %a0 %zero 1 #914
	jal %zero beq_cont.99422 # then sentence ends
beq_else.99421:
	addi %a0 %zero 0 #902
beq_cont.99422:
beq_cont.99420:
beq_cont.99418:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99423
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
	sw %f0 %sp 64 #921
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #921 call dir
	addi %sp %sp 80 #921	
	jal %ra min_caml_fabs #921
	addi %sp %sp -80 #921
	lw %ra %sp 76 #921
	lw %a0 %sp 52 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 76 #921 call dir
	addi %sp %sp 80 #921	
	jal %ra min_caml_fless #921
	addi %sp %sp -80 #921
	lw %ra %sp 76 #921
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99424 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.99425 # then sentence ends
beq_else.99424:
	lw %a0 %sp 48 #903
	lw %f0 %a0 4 #903
	lw %f1 %sp 64 #922
	fmul %f0 %f1 %f0 #922
	lw %f2 %sp 16 #922
	fadd %f0 %f0 %f2 #922
	sw %ra %sp 76 #922 call dir
	addi %sp %sp 80 #922	
	jal %ra min_caml_fabs #922
	addi %sp %sp -80 #922
	lw %ra %sp 76 #922
	lw %a0 %sp 52 #286
	lw %a0 %a0 16 #286
	lw %f1 %a0 4 #291
	sw %ra %sp 76 #922 call dir
	addi %sp %sp 80 #922	
	jal %ra min_caml_fless #922
	addi %sp %sp -80 #922
	lw %ra %sp 76 #922
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99426 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.99427 # then sentence ends
beq_else.99426:
	lw %a0 %sp 24 #901
	lw %f0 %a0 20 #901
	sw %ra %sp 76 #923 call dir
	addi %sp %sp 80 #923	
	jal %ra min_caml_fiszero #923
	addi %sp %sp -80 #923
	lw %ra %sp 76 #923
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99428 # nontail if
	addi %a0 %zero 1 #923
	jal %zero beq_cont.99429 # then sentence ends
beq_else.99428:
	addi %a0 %zero 0 #902
beq_cont.99429:
beq_cont.99427:
beq_cont.99425:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99430
	addi %a0 %zero 0 #902
	jalr %zero %ra 0 #902
beq_else.99430:
	lw %a0 %sp 0 #927
	lw %f0 %sp 64 #927
	sw %f0 %a0 0 #927
	addi %a0 %zero 3 #927
	jalr %zero %ra 0 #927
beq_else.99423:
	lw %a0 %sp 0 #918
	lw %f0 %sp 56 #918
	sw %f0 %a0 0 #918
	addi %a0 %zero 2 #918
	jalr %zero %ra 0 #918
beq_else.99416:
	lw %a0 %sp 0 #909
	lw %f0 %sp 40 #909
	sw %f0 %a0 0 #909
	addi %a0 %zero 1 #909
	jalr %zero %ra 0 #909
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
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99433
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
	sw %f0 %sp 56 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #822 call dir
	addi %sp %sp 72 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -72 #822
	lw %ra %sp 68 #822
	lw %a0 %sp 16 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 32 #822
	sw %f0 %sp 64 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #822 call dir
	addi %sp %sp 80 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -80 #822
	lw %ra %sp 76 #822
	lw %a0 %sp 16 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 64 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 24 #822
	sw %f0 %sp 72 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #822 call dir
	addi %sp %sp 88 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -88 #822
	lw %ra %sp 84 #822
	lw %a0 %sp 16 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 72 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99435 # nontail if
	jal %zero beq_cont.99436 # then sentence ends
beq_else.99435:
	lw %f1 %sp 24 #828
	lw %f2 %sp 32 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 40 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99436:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99437 # nontail if
	li %f1 l.90464 #950
	fsub %f0 %f0 %f1 #950
	jal %zero beq_cont.99438 # then sentence ends
beq_else.99437:
beq_cont.99438:
	lw %f1 %sp 56 #951
	sw %f0 %sp 80 #951
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #951 call dir
	addi %sp %sp 96 #951	
	jal %ra min_caml_fsqr #951
	addi %sp %sp -96 #951
	lw %ra %sp 92 #951
	lw %f1 %sp 80 #951
	lw %f2 %sp 8 #951
	fmul %f1 %f2 %f1 #951
	fsub %f0 %f0 %f1 #951
	sw %f0 %sp 88 #952
	sw %ra %sp 100 #952 call dir
	addi %sp %sp 104 #952	
	jal %ra min_caml_fispos #952
	addi %sp %sp -104 #952
	lw %ra %sp 100 #952
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99439
	addi %a0 %zero 0 #945
	jalr %zero %ra 0 #945
beq_else.99439:
	lw %a0 %sp 16 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99440 # nontail if
	lw %f0 %sp 88 #956
	sw %ra %sp 100 #956 call dir
	addi %sp %sp 104 #956	
	jal %ra min_caml_sqrt #956
	addi %sp %sp -104 #956
	lw %ra %sp 100 #956
	lw %f1 %sp 56 #956
	fsub %f0 %f1 %f0 #956
	lw %a0 %sp 48 #944
	lw %f1 %a0 16 #944
	fmul %f0 %f0 %f1 #956
	lw %a0 %sp 0 #956
	sw %f0 %a0 0 #956
	jal %zero beq_cont.99441 # then sentence ends
beq_else.99440:
	lw %f0 %sp 88 #954
	sw %ra %sp 100 #954 call dir
	addi %sp %sp 104 #954	
	jal %ra min_caml_sqrt #954
	addi %sp %sp -104 #954
	lw %ra %sp 100 #954
	lw %f1 %sp 56 #954
	fadd %f0 %f1 %f0 #954
	lw %a0 %sp 48 #944
	lw %f1 %a0 16 #944
	fmul %f0 %f0 %f1 #954
	lw %a0 %sp 0 #954
	sw %f0 %a0 0 #954
beq_cont.99441:
	addi %a0 %zero 1 #957
	jalr %zero %ra 0 #957
beq_else.99433:
	addi %a0 %zero 0 #945
	jalr %zero %ra 0 #945
solver_fast.2446:
	lw %a3 %a11 12 #962
	lw %a4 %a11 8 #962
	lw %a5 %a11 4 #962
	slli %a6 %a0 2 #20
	add %a12 %a5 %a6 #20
	lw %a5 %a12 0 #20
	lw %f0 %a2 0 #964
	lw %a6 %a5 20 #316
	lw %f1 %a6 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a2 4 #964
	lw %a6 %a5 20 #326
	lw %f2 %a6 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a2 8 #964
	lw %a2 %a5 20 #336
	lw %f3 %a2 8 #341
	fsub %f2 %f2 %f3 #966
	lw %a2 %a1 4 #513
	slli %a0 %a0 2 #968
	add %a12 %a2 %a0 #968
	lw %a2 %a12 0 #968
	lw %a0 %a5 4 #238
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.99442
	lw %a1 %a1 0 #507
	add %a0 %a5 %zero
	add %a11 %a3 %zero
	lw %a10 %a11 0 #971
	jalr %zero %a10 0 #971
beq_else.99442:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.99443
	lw %f3 %a2 0 #934
	sw %a4 %sp 0 #934
	sw %f2 %sp 8 #934
	sw %f1 %sp 16 #934
	sw %f0 %sp 24 #934
	sw %a2 %sp 32 #934
	fadd %f0 %f3 %fzero
	sw %ra %sp 36 #934 call dir
	addi %sp %sp 40 #934	
	jal %ra min_caml_fisneg #934
	addi %sp %sp -40 #934
	lw %ra %sp 36 #934
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99445
	addi %a0 %zero 0 #934
	jalr %zero %ra 0 #934
beq_else.99445:
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
beq_else.99443:
	lw %f3 %a2 0 #944
	sw %a4 %sp 0 #945
	sw %f3 %sp 40 #945
	sw %a5 %sp 48 #945
	sw %f2 %sp 8 #945
	sw %f1 %sp 16 #945
	sw %f0 %sp 24 #945
	sw %a2 %sp 32 #945
	fadd %f0 %f3 %fzero
	sw %ra %sp 52 #945 call dir
	addi %sp %sp 56 #945	
	jal %ra min_caml_fiszero #945
	addi %sp %sp -56 #945
	lw %ra %sp 52 #945
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99447
	lw %a0 %sp 32 #944
	lw %f0 %a0 4 #944
	lw %f1 %sp 24 #948
	fmul %f0 %f0 %f1 #948
	lw %f2 %a0 8 #944
	lw %f3 %sp 16 #948
	fmul %f2 %f2 %f3 #948
	fadd %f0 %f0 %f2 #948
	lw %f2 %a0 12 #944
	lw %f4 %sp 8 #948
	fmul %f2 %f2 %f4 #948
	fadd %f0 %f0 %f2 #948
	sw %f0 %sp 56 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #822 call dir
	addi %sp %sp 72 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -72 #822
	lw %ra %sp 68 #822
	lw %a0 %sp 48 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 16 #822
	sw %f0 %sp 64 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #822 call dir
	addi %sp %sp 80 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -80 #822
	lw %ra %sp 76 #822
	lw %a0 %sp 48 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 64 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 8 #822
	sw %f0 %sp 72 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #822 call dir
	addi %sp %sp 88 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -88 #822
	lw %ra %sp 84 #822
	lw %a0 %sp 48 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 72 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99449 # nontail if
	jal %zero beq_cont.99450 # then sentence ends
beq_else.99449:
	lw %f1 %sp 8 #828
	lw %f2 %sp 16 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 24 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99450:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99451 # nontail if
	li %f1 l.90464 #950
	fsub %f0 %f0 %f1 #950
	jal %zero beq_cont.99452 # then sentence ends
beq_else.99451:
beq_cont.99452:
	lw %f1 %sp 56 #951
	sw %f0 %sp 80 #951
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #951 call dir
	addi %sp %sp 96 #951	
	jal %ra min_caml_fsqr #951
	addi %sp %sp -96 #951
	lw %ra %sp 92 #951
	lw %f1 %sp 80 #951
	lw %f2 %sp 40 #951
	fmul %f1 %f2 %f1 #951
	fsub %f0 %f0 %f1 #951
	sw %f0 %sp 88 #952
	sw %ra %sp 100 #952 call dir
	addi %sp %sp 104 #952	
	jal %ra min_caml_fispos #952
	addi %sp %sp -104 #952
	lw %ra %sp 100 #952
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99453
	addi %a0 %zero 0 #945
	jalr %zero %ra 0 #945
beq_else.99453:
	lw %a0 %sp 48 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99454 # nontail if
	lw %f0 %sp 88 #956
	sw %ra %sp 100 #956 call dir
	addi %sp %sp 104 #956	
	jal %ra min_caml_sqrt #956
	addi %sp %sp -104 #956
	lw %ra %sp 100 #956
	lw %f1 %sp 56 #956
	fsub %f0 %f1 %f0 #956
	lw %a0 %sp 32 #944
	lw %f1 %a0 16 #944
	fmul %f0 %f0 %f1 #956
	lw %a0 %sp 0 #956
	sw %f0 %a0 0 #956
	jal %zero beq_cont.99455 # then sentence ends
beq_else.99454:
	lw %f0 %sp 88 #954
	sw %ra %sp 100 #954 call dir
	addi %sp %sp 104 #954	
	jal %ra min_caml_sqrt #954
	addi %sp %sp -104 #954
	lw %ra %sp 100 #954
	lw %f1 %sp 56 #954
	fadd %f0 %f1 %f0 #954
	lw %a0 %sp 32 #944
	lw %f1 %a0 16 #944
	fmul %f0 %f0 %f1 #954
	lw %a0 %sp 0 #954
	sw %f0 %a0 0 #954
beq_cont.99455:
	addi %a0 %zero 1 #957
	jalr %zero %ra 0 #957
beq_else.99447:
	addi %a0 %zero 0 #945
	jalr %zero %ra 0 #945
solver_fast2.2464:
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
	bne %a6 %a12 beq_else.99456
	lw %a1 %a1 0 #507
	add %a11 %a2 %zero
	add %a2 %a0 %zero
	add %a0 %a4 %zero
	lw %a10 %a11 0 #1019
	jalr %zero %a10 0 #1019
beq_else.99456:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.99457
	lw %f0 %a0 0 #983
	sw %a3 %sp 0 #983
	sw %a5 %sp 4 #983
	sw %a0 %sp 8 #983
	sw %ra %sp 12 #983 call dir
	addi %sp %sp 16 #983	
	jal %ra min_caml_fisneg #983
	addi %sp %sp -16 #983
	lw %ra %sp 12 #983
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99458
	addi %a0 %zero 0 #983
	jalr %zero %ra 0 #983
beq_else.99458:
	lw %a0 %sp 8 #983
	lw %f0 %a0 0 #983
	lw %a0 %sp 4 #984
	lw %f1 %a0 12 #984
	fmul %f0 %f0 %f1 #984
	lw %a0 %sp 0 #984
	sw %f0 %a0 0 #984
	addi %a0 %zero 1 #985
	jalr %zero %ra 0 #985
beq_else.99457:
	lw %f3 %a0 0 #992
	sw %a3 %sp 0 #993
	sw %a4 %sp 12 #993
	sw %f3 %sp 16 #993
	sw %a5 %sp 4 #993
	sw %f2 %sp 24 #993
	sw %f1 %sp 32 #993
	sw %f0 %sp 40 #993
	sw %a0 %sp 8 #993
	fadd %f0 %f3 %fzero
	sw %ra %sp 52 #993 call dir
	addi %sp %sp 56 #993	
	jal %ra min_caml_fiszero #993
	addi %sp %sp -56 #993
	lw %ra %sp 52 #993
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99459
	lw %a0 %sp 8 #992
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
	lw %a1 %sp 4 #997
	lw %f1 %a1 12 #997
	sw %f0 %sp 48 #998
	sw %f1 %sp 56 #998
	sw %ra %sp 68 #998 call dir
	addi %sp %sp 72 #998	
	jal %ra min_caml_fsqr #998
	addi %sp %sp -72 #998
	lw %ra %sp 68 #998
	lw %f1 %sp 56 #998
	lw %f2 %sp 16 #998
	fmul %f1 %f2 %f1 #998
	fsub %f0 %f0 %f1 #998
	sw %f0 %sp 64 #999
	sw %ra %sp 76 #999 call dir
	addi %sp %sp 80 #999	
	jal %ra min_caml_fispos #999
	addi %sp %sp -80 #999
	lw %ra %sp 76 #999
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99460
	addi %a0 %zero 0 #993
	jalr %zero %ra 0 #993
beq_else.99460:
	lw %a0 %sp 12 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99461 # nontail if
	lw %f0 %sp 64 #1003
	sw %ra %sp 76 #1003 call dir
	addi %sp %sp 80 #1003	
	jal %ra min_caml_sqrt #1003
	addi %sp %sp -80 #1003
	lw %ra %sp 76 #1003
	lw %f1 %sp 48 #1003
	fsub %f0 %f1 %f0 #1003
	lw %a0 %sp 8 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1003
	lw %a0 %sp 0 #1003
	sw %f0 %a0 0 #1003
	jal %zero beq_cont.99462 # then sentence ends
beq_else.99461:
	lw %f0 %sp 64 #1001
	sw %ra %sp 76 #1001 call dir
	addi %sp %sp 80 #1001	
	jal %ra min_caml_sqrt #1001
	addi %sp %sp -80 #1001
	lw %ra %sp 76 #1001
	lw %f1 %sp 48 #1001
	fadd %f0 %f1 %f0 #1001
	lw %a0 %sp 8 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1001
	lw %a0 %sp 0 #1001
	sw %f0 %a0 0 #1001
beq_cont.99462:
	addi %a0 %zero 1 #1004
	jalr %zero %ra 0 #1004
beq_else.99459:
	addi %a0 %zero 0 #993
	jalr %zero %ra 0 #993
setup_rect_table.2467:
	addi %a2 %zero 6 #1030
	li %f0 l.90390 #1030
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
	bne %a0 %a12 beq_else.99463 # nontail if
	lw %a0 %sp 0 #258
	lw %a1 %a0 24 #258
	lw %a2 %sp 4 #1032
	lw %f0 %a2 0 #1032
	sw %a1 %sp 12 #1036
	sw %ra %sp 20 #1036 call dir
	addi %sp %sp 24 #1036	
	jal %ra min_caml_fisneg #1036
	addi %sp %sp -24 #1036
	lw %ra %sp 20 #1036
	lw %a1 %sp 12 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99465 # nontail if
	jal %zero beq_cont.99466 # then sentence ends
beq_else.99465:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99467 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99468 # then sentence ends
beq_else.99467:
	addi %a0 %zero 0 #105
beq_cont.99468:
beq_cont.99466:
	lw %a1 %sp 0 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99469 # nontail if
	sw %ra %sp 20 #118 call dir
	addi %sp %sp 24 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -24 #118
	lw %ra %sp 20 #118
	jal %zero beq_cont.99470 # then sentence ends
beq_else.99469:
beq_cont.99470:
	lw %a0 %sp 8 #1036
	sw %f0 %a0 0 #1036
	li %f0 l.90464 #1038
	lw %a1 %sp 4 #1032
	lw %f1 %a1 0 #1032
	fdiv %f0 %f0 %f1 #1038
	sw %f0 %a0 4 #1038
	jal %zero beq_cont.99464 # then sentence ends
beq_else.99463:
	li %f0 l.90390 #1033
	lw %a0 %sp 8 #1033
	sw %f0 %a0 4 #1033
beq_cont.99464:
	lw %a1 %sp 4 #1032
	lw %f0 %a1 4 #1032
	sw %ra %sp 20 #1040 call dir
	addi %sp %sp 24 #1040	
	jal %ra min_caml_fiszero #1040
	addi %sp %sp -24 #1040
	lw %ra %sp 20 #1040
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99471 # nontail if
	lw %a0 %sp 0 #258
	lw %a1 %a0 24 #258
	lw %a2 %sp 4 #1032
	lw %f0 %a2 4 #1032
	sw %a1 %sp 16 #1043
	sw %ra %sp 20 #1043 call dir
	addi %sp %sp 24 #1043	
	jal %ra min_caml_fisneg #1043
	addi %sp %sp -24 #1043
	lw %ra %sp 20 #1043
	lw %a1 %sp 16 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99473 # nontail if
	jal %zero beq_cont.99474 # then sentence ends
beq_else.99473:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99475 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99476 # then sentence ends
beq_else.99475:
	addi %a0 %zero 0 #105
beq_cont.99476:
beq_cont.99474:
	lw %a1 %sp 0 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99477 # nontail if
	sw %ra %sp 20 #118 call dir
	addi %sp %sp 24 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -24 #118
	lw %ra %sp 20 #118
	jal %zero beq_cont.99478 # then sentence ends
beq_else.99477:
beq_cont.99478:
	lw %a0 %sp 8 #1043
	sw %f0 %a0 8 #1043
	li %f0 l.90464 #1044
	lw %a1 %sp 4 #1032
	lw %f1 %a1 4 #1032
	fdiv %f0 %f0 %f1 #1044
	sw %f0 %a0 12 #1044
	jal %zero beq_cont.99472 # then sentence ends
beq_else.99471:
	li %f0 l.90390 #1041
	lw %a0 %sp 8 #1041
	sw %f0 %a0 12 #1041
beq_cont.99472:
	lw %a1 %sp 4 #1032
	lw %f0 %a1 8 #1032
	sw %ra %sp 20 #1046 call dir
	addi %sp %sp 24 #1046	
	jal %ra min_caml_fiszero #1046
	addi %sp %sp -24 #1046
	lw %ra %sp 20 #1046
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99479 # nontail if
	lw %a0 %sp 0 #258
	lw %a1 %a0 24 #258
	lw %a2 %sp 4 #1032
	lw %f0 %a2 8 #1032
	sw %a1 %sp 20 #1049
	sw %ra %sp 28 #1049 call dir
	addi %sp %sp 32 #1049	
	jal %ra min_caml_fisneg #1049
	addi %sp %sp -32 #1049
	lw %ra %sp 28 #1049
	lw %a1 %sp 20 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99481 # nontail if
	jal %zero beq_cont.99482 # then sentence ends
beq_else.99481:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99483 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99484 # then sentence ends
beq_else.99483:
	addi %a0 %zero 0 #105
beq_cont.99484:
beq_cont.99482:
	lw %a1 %sp 0 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99485 # nontail if
	sw %ra %sp 28 #118 call dir
	addi %sp %sp 32 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -32 #118
	lw %ra %sp 28 #118
	jal %zero beq_cont.99486 # then sentence ends
beq_else.99485:
beq_cont.99486:
	lw %a0 %sp 8 #1049
	sw %f0 %a0 16 #1049
	li %f0 l.90464 #1050
	lw %a1 %sp 4 #1032
	lw %f1 %a1 8 #1032
	fdiv %f0 %f0 %f1 #1050
	sw %f0 %a0 20 #1050
	jal %zero beq_cont.99480 # then sentence ends
beq_else.99479:
	li %f0 l.90390 #1047
	lw %a0 %sp 8 #1047
	sw %f0 %a0 20 #1047
beq_cont.99480:
	jalr %zero %ra 0 #1052
setup_second_table.2473:
	addi %a2 %zero 5 #1076
	li %f0 l.90390 #1076
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
	sw %a0 %sp 8 #822
	sw %f0 %sp 16 #822
	sw %f2 %sp 24 #822
	sw %f1 %sp 32 #822
	sw %ra %sp 44 #822 call dir
	addi %sp %sp 48 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -48 #822
	lw %ra %sp 44 #822
	lw %a0 %sp 0 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 32 #822
	sw %f0 %sp 40 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #822 call dir
	addi %sp %sp 56 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -56 #822
	lw %ra %sp 52 #822
	lw %a0 %sp 0 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 40 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 24 #822
	sw %f0 %sp 48 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #822 call dir
	addi %sp %sp 64 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -64 #822
	lw %ra %sp 60 #822
	lw %a0 %sp 0 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 48 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99488 # nontail if
	jal %zero beq_cont.99489 # then sentence ends
beq_else.99488:
	lw %f1 %sp 24 #828
	lw %f2 %sp 32 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 16 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99489:
	lw %a1 %sp 4 #1078
	lw %f1 %a1 0 #1078
	lw %a2 %a0 16 #276
	lw %f2 %a2 0 #281
	fmul %f1 %f1 %f2 #1079
	sw %f0 %sp 56 #1079
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #1079 call dir
	addi %sp %sp 72 #1079	
	jal %ra min_caml_fneg #1079
	addi %sp %sp -72 #1079
	lw %ra %sp 68 #1079
	lw %a0 %sp 4 #1078
	lw %f1 %a0 4 #1078
	lw %a1 %sp 0 #286
	lw %a2 %a1 16 #286
	lw %f2 %a2 4 #291
	fmul %f1 %f1 %f2 #1080
	sw %f0 %sp 64 #1080
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #1080 call dir
	addi %sp %sp 80 #1080	
	jal %ra min_caml_fneg #1080
	addi %sp %sp -80 #1080
	lw %ra %sp 76 #1080
	lw %a0 %sp 4 #1078
	lw %f1 %a0 8 #1078
	lw %a1 %sp 0 #296
	lw %a2 %a1 16 #296
	lw %f2 %a2 8 #301
	fmul %f1 %f1 %f2 #1081
	sw %f0 %sp 72 #1081
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #1081 call dir
	addi %sp %sp 88 #1081	
	jal %ra min_caml_fneg #1081
	addi %sp %sp -88 #1081
	lw %ra %sp 84 #1081
	lw %a0 %sp 8 #1083
	lw %f1 %sp 56 #1083
	sw %f1 %a0 0 #1083
	lw %a1 %sp 0 #267
	lw %a2 %a1 12 #267
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.99490 # nontail if
	lw %f2 %sp 64 #1091
	sw %f2 %a0 4 #1091
	lw %f2 %sp 72 #1092
	sw %f2 %a0 8 #1092
	sw %f0 %a0 12 #1093
	jal %zero beq_cont.99491 # then sentence ends
beq_else.99490:
	lw %a2 %sp 4 #1078
	lw %f2 %a2 8 #1078
	lw %a3 %a1 36 #406
	lw %f3 %a3 4 #411
	fmul %f2 %f2 %f3 #1087
	lw %f3 %a2 4 #1078
	lw %a3 %a1 36 #416
	lw %f4 %a3 8 #421
	fmul %f3 %f3 %f4 #1087
	fadd %f2 %f2 %f3 #1087
	sw %f0 %sp 80 #1087
	fadd %f0 %f2 %fzero
	sw %ra %sp 92 #1087 call dir
	addi %sp %sp 96 #1087	
	jal %ra min_caml_fhalf #1087
	addi %sp %sp -96 #1087
	lw %ra %sp 92 #1087
	lw %f1 %sp 64 #1087
	fsub %f0 %f1 %f0 #1087
	lw %a0 %sp 8 #1087
	sw %f0 %a0 4 #1087
	lw %a1 %sp 4 #1078
	lw %f0 %a1 8 #1078
	lw %a2 %sp 0 #396
	lw %a3 %a2 36 #396
	lw %f1 %a3 0 #401
	fmul %f0 %f0 %f1 #1088
	lw %f1 %a1 0 #1078
	lw %a3 %a2 36 #416
	lw %f2 %a3 8 #421
	fmul %f1 %f1 %f2 #1088
	fadd %f0 %f0 %f1 #1088
	sw %ra %sp 92 #1088 call dir
	addi %sp %sp 96 #1088	
	jal %ra min_caml_fhalf #1088
	addi %sp %sp -96 #1088
	lw %ra %sp 92 #1088
	lw %f1 %sp 72 #1088
	fsub %f0 %f1 %f0 #1088
	lw %a0 %sp 8 #1088
	sw %f0 %a0 8 #1088
	lw %a1 %sp 4 #1078
	lw %f0 %a1 4 #1078
	lw %a2 %sp 0 #396
	lw %a3 %a2 36 #396
	lw %f1 %a3 0 #401
	fmul %f0 %f0 %f1 #1089
	lw %f1 %a1 0 #1078
	lw %a1 %a2 36 #406
	lw %f2 %a1 4 #411
	fmul %f1 %f1 %f2 #1089
	fadd %f0 %f0 %f1 #1089
	sw %ra %sp 92 #1089 call dir
	addi %sp %sp 96 #1089	
	jal %ra min_caml_fhalf #1089
	addi %sp %sp -96 #1089
	lw %ra %sp 92 #1089
	lw %f1 %sp 80 #1089
	fsub %f0 %f1 %f0 #1089
	lw %a0 %sp 8 #1089
	sw %f0 %a0 12 #1089
beq_cont.99491:
	lw %f0 %sp 56 #1095
	sw %ra %sp 92 #1095 call dir
	addi %sp %sp 96 #1095	
	jal %ra min_caml_fiszero #1095
	addi %sp %sp -96 #1095
	lw %ra %sp 92 #1095
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99492 # nontail if
	li %f0 l.90464 #1096
	lw %f1 %sp 56 #1096
	fdiv %f0 %f0 %f1 #1096
	lw %a0 %sp 8 #1096
	sw %f0 %a0 16 #1096
	jal %zero beq_cont.99493 # then sentence ends
beq_else.99492:
beq_cont.99493:
	lw %a0 %sp 8 #1098
	jalr %zero %ra 0 #1098
iter_setup_dirvec_constants.2476:
	lw %a2 %a11 4 #1103
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.99494
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
	bne %a6 %a12 beq_else.99495 # nontail if
	sw %a4 %sp 12 #1110
	sw %a1 %sp 16 #1110
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 20 #1110 call dir
	addi %sp %sp 24 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -24 #1110
	lw %ra %sp 20 #1110
	lw %a1 %sp 16 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 12 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.99496 # then sentence ends
beq_else.99495:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.99497 # nontail if
	addi %a6 %zero 4 #1057
	li %f0 l.90390 #1057
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
	sw %f0 %sp 32 #1061
	sw %a0 %sp 40 #1061
	sw %ra %sp 44 #1061 call dir
	addi %sp %sp 48 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -48 #1061
	lw %ra %sp 44 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99500 # nontail if
	li %f0 l.90390 #1069
	lw %a0 %sp 40 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.99501 # then sentence ends
beq_else.99500:
	li %f0 l.90466 #1063
	lw %f1 %sp 32 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 40 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 20 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 44 #1065 call dir
	addi %sp %sp 48 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -48 #1065
	lw %ra %sp 44 #1065
	lw %a0 %sp 40 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 20 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	lw %f1 %sp 32 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 44 #1066 call dir
	addi %sp %sp 48 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -48 #1066
	lw %ra %sp 44 #1066
	lw %a0 %sp 40 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 20 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	lw %f1 %sp 32 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 44 #1067 call dir
	addi %sp %sp 48 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -48 #1067
	lw %ra %sp 44 #1067
	lw %a0 %sp 40 #1067
	sw %f0 %a0 12 #1067
beq_cont.99501:
	lw %a1 %sp 16 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 12 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.99498 # then sentence ends
beq_else.99497:
	sw %a4 %sp 12 #1114
	sw %a1 %sp 16 #1114
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 44 #1114 call dir
	addi %sp %sp 48 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -48 #1114
	lw %ra %sp 44 #1114
	lw %a1 %sp 16 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 12 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.99498:
beq_cont.99496:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.99502
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a2 %sp 4 #513
	lw %a3 %a2 4 #513
	lw %a4 %a2 0 #507
	lw %a5 %a1 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.99503 # nontail if
	sw %a3 %sp 44 #1110
	sw %a0 %sp 48 #1110
	add %a0 %a4 %zero
	sw %ra %sp 52 #1110 call dir
	addi %sp %sp 56 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -56 #1110
	lw %ra %sp 52 #1110
	lw %a1 %sp 48 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 44 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.99504 # then sentence ends
beq_else.99503:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.99505 # nontail if
	addi %a5 %zero 4 #1057
	li %f0 l.90390 #1057
	sw %a3 %sp 44 #1057
	sw %a0 %sp 48 #1057
	sw %a1 %sp 52 #1057
	sw %a4 %sp 56 #1057
	add %a0 %a5 %zero
	sw %ra %sp 60 #1057 call dir
	addi %sp %sp 64 #1057	
	jal %ra min_caml_create_float_array #1057
	addi %sp %sp -64 #1057
	lw %ra %sp 60 #1057
	lw %a1 %sp 56 #1059
	lw %f0 %a1 0 #1059
	lw %a2 %sp 52 #276
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
	sw %f0 %sp 64 #1061
	sw %a0 %sp 72 #1061
	sw %ra %sp 76 #1061 call dir
	addi %sp %sp 80 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -80 #1061
	lw %ra %sp 76 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99508 # nontail if
	li %f0 l.90390 #1069
	lw %a0 %sp 72 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.99509 # then sentence ends
beq_else.99508:
	li %f0 l.90466 #1063
	lw %f1 %sp 64 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 72 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 52 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 76 #1065 call dir
	addi %sp %sp 80 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -80 #1065
	lw %ra %sp 76 #1065
	lw %a0 %sp 72 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 52 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	lw %f1 %sp 64 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 76 #1066 call dir
	addi %sp %sp 80 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -80 #1066
	lw %ra %sp 76 #1066
	lw %a0 %sp 72 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 52 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	lw %f1 %sp 64 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 76 #1067 call dir
	addi %sp %sp 80 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -80 #1067
	lw %ra %sp 76 #1067
	lw %a0 %sp 72 #1067
	sw %f0 %a0 12 #1067
beq_cont.99509:
	lw %a1 %sp 48 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 44 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.99506 # then sentence ends
beq_else.99505:
	sw %a3 %sp 44 #1114
	sw %a0 %sp 48 #1114
	add %a0 %a4 %zero
	sw %ra %sp 76 #1114 call dir
	addi %sp %sp 80 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -80 #1114
	lw %ra %sp 76 #1114
	lw %a1 %sp 48 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 44 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.99506:
beq_cont.99504:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 4 #1116
	lw %a11 %sp 0 #1116
	lw %a10 %a11 0 #1116
	jalr %zero %a10 0 #1116
bge_else.99502:
	jalr %zero %ra 0 #1117
bge_else.99494:
	jalr %zero %ra 0 #1117
setup_dirvec_constants.2479:
	lw %a1 %a11 12 #1120
	lw %a2 %a11 8 #1120
	lw %a3 %a11 4 #1120
	lw %a2 %a2 0 #15
	addi %a2 %a2 -1 #1121
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.99512
	slli %a4 %a2 2 #20
	add %a12 %a1 %a4 #20
	lw %a1 %a12 0 #20
	lw %a4 %a0 4 #513
	lw %a5 %a0 0 #507
	lw %a6 %a1 4 #238
	sw %a0 %sp 0 #868
	sw %a3 %sp 4 #868
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.99513 # nontail if
	sw %a4 %sp 8 #1110
	sw %a2 %sp 12 #1110
	add %a0 %a5 %zero
	sw %ra %sp 20 #1110 call dir
	addi %sp %sp 24 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -24 #1110
	lw %ra %sp 20 #1110
	lw %a1 %sp 12 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 8 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.99514 # then sentence ends
beq_else.99513:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.99515 # nontail if
	addi %a6 %zero 4 #1057
	li %f0 l.90390 #1057
	sw %a4 %sp 8 #1057
	sw %a2 %sp 12 #1057
	sw %a1 %sp 16 #1057
	sw %a5 %sp 20 #1057
	add %a0 %a6 %zero
	sw %ra %sp 28 #1057 call dir
	addi %sp %sp 32 #1057	
	jal %ra min_caml_create_float_array #1057
	addi %sp %sp -32 #1057
	lw %ra %sp 28 #1057
	lw %a1 %sp 20 #1059
	lw %f0 %a1 0 #1059
	lw %a2 %sp 16 #276
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
	sw %f0 %sp 24 #1061
	sw %a0 %sp 32 #1061
	sw %ra %sp 36 #1061 call dir
	addi %sp %sp 40 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -40 #1061
	lw %ra %sp 36 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99517 # nontail if
	li %f0 l.90390 #1069
	lw %a0 %sp 32 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.99518 # then sentence ends
beq_else.99517:
	li %f0 l.90466 #1063
	lw %f1 %sp 24 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 32 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 16 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 36 #1065 call dir
	addi %sp %sp 40 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -40 #1065
	lw %ra %sp 36 #1065
	lw %a0 %sp 32 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 16 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	lw %f1 %sp 24 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 36 #1066 call dir
	addi %sp %sp 40 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -40 #1066
	lw %ra %sp 36 #1066
	lw %a0 %sp 32 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 16 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	lw %f1 %sp 24 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 36 #1067 call dir
	addi %sp %sp 40 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -40 #1067
	lw %ra %sp 36 #1067
	lw %a0 %sp 32 #1067
	sw %f0 %a0 12 #1067
beq_cont.99518:
	lw %a1 %sp 12 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 8 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.99516 # then sentence ends
beq_else.99515:
	sw %a4 %sp 8 #1114
	sw %a2 %sp 12 #1114
	add %a0 %a5 %zero
	sw %ra %sp 36 #1114 call dir
	addi %sp %sp 40 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -40 #1114
	lw %ra %sp 36 #1114
	lw %a1 %sp 12 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 8 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.99516:
beq_cont.99514:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 0 #1116
	lw %a11 %sp 4 #1116
	lw %a10 %a11 0 #1116
	jalr %zero %a10 0 #1116
bge_else.99512:
	jalr %zero %ra 0 #1117
setup_startp_constants.2481:
	lw %a2 %a11 4 #1126
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.99520
	slli %a3 %a1 2 #20
	add %a12 %a2 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %a3 40 #427
	lw %a5 %a3 4 #238
	lw %f0 %a0 0 #1131
	lw %a6 %a3 20 #316
	lw %f1 %a6 0 #321
	fsub %f0 %f0 %f1 #1131
	sw %f0 %a4 0 #1131
	lw %f0 %a0 4 #1131
	lw %a6 %a3 20 #326
	lw %f1 %a6 4 #331
	fsub %f0 %f0 %f1 #1132
	sw %f0 %a4 4 #1132
	lw %f0 %a0 8 #1131
	lw %a6 %a3 20 #336
	lw %f1 %a6 8 #341
	fsub %f0 %f0 %f1 #1133
	sw %f0 %a4 8 #1133
	sw %a11 %sp 0 #868
	sw %a0 %sp 4 #868
	sw %a2 %sp 8 #868
	sw %a1 %sp 12 #868
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.99521 # nontail if
	lw %a3 %a3 16 #306
	lw %f0 %a4 0 #19
	lw %f1 %a4 4 #19
	lw %f2 %a4 8 #19
	lw %f3 %a3 0 #186
	fmul %f0 %f3 %f0 #186
	lw %f3 %a3 4 #186
	fmul %f1 %f3 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a3 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	sw %f0 %a4 12 #1135
	jal %zero beq_cont.99522 # then sentence ends
beq_else.99521:
	addi %a12 %zero 2
	blt %a12 %a5 bge_else.99523 # nontail if
	jal %zero bge_cont.99524 # then sentence ends
bge_else.99523:
	lw %f0 %a4 0 #19
	lw %f1 %a4 4 #19
	lw %f2 %a4 8 #19
	sw %a4 %sp 16 #822
	sw %a5 %sp 20 #822
	sw %f0 %sp 24 #822
	sw %f2 %sp 32 #822
	sw %f1 %sp 40 #822
	sw %a3 %sp 48 #822
	sw %ra %sp 52 #822 call dir
	addi %sp %sp 56 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -56 #822
	lw %ra %sp 52 #822
	lw %a0 %sp 48 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 40 #822
	sw %f0 %sp 56 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #822 call dir
	addi %sp %sp 72 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -72 #822
	lw %ra %sp 68 #822
	lw %a0 %sp 48 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 56 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 32 #822
	sw %f0 %sp 64 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #822 call dir
	addi %sp %sp 80 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -80 #822
	lw %ra %sp 76 #822
	lw %a0 %sp 48 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 64 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99526 # nontail if
	jal %zero beq_cont.99527 # then sentence ends
beq_else.99526:
	lw %f1 %sp 32 #828
	lw %f2 %sp 40 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 24 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a0 %a0 36 #416
	lw %f2 %a0 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99527:
	lw %a0 %sp 20 #868
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.99528 # nontail if
	li %f1 l.90464 #1139
	fsub %f0 %f0 %f1 #1139
	jal %zero beq_cont.99529 # then sentence ends
beq_else.99528:
beq_cont.99529:
	lw %a0 %sp 16 #1139
	sw %f0 %a0 12 #1139
bge_cont.99524:
beq_cont.99522:
	lw %a0 %sp 12 #1141
	addi %a0 %a0 -1 #1141
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.99530
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a2 %a1 40 #427
	lw %a3 %a1 4 #238
	lw %a4 %sp 4 #1131
	lw %f0 %a4 0 #1131
	lw %a5 %a1 20 #316
	lw %f1 %a5 0 #321
	fsub %f0 %f0 %f1 #1131
	sw %f0 %a2 0 #1131
	lw %f0 %a4 4 #1131
	lw %a5 %a1 20 #326
	lw %f1 %a5 4 #331
	fsub %f0 %f0 %f1 #1132
	sw %f0 %a2 4 #1132
	lw %f0 %a4 8 #1131
	lw %a5 %a1 20 #336
	lw %f1 %a5 8 #341
	fsub %f0 %f0 %f1 #1133
	sw %f0 %a2 8 #1133
	sw %a0 %sp 72 #868
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.99531 # nontail if
	lw %a1 %a1 16 #306
	lw %f0 %a2 0 #19
	lw %f1 %a2 4 #19
	lw %f2 %a2 8 #19
	lw %f3 %a1 0 #186
	fmul %f0 %f3 %f0 #186
	lw %f3 %a1 4 #186
	fmul %f1 %f3 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a1 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	sw %f0 %a2 12 #1135
	jal %zero beq_cont.99532 # then sentence ends
beq_else.99531:
	addi %a12 %zero 2
	blt %a12 %a3 bge_else.99533 # nontail if
	jal %zero bge_cont.99534 # then sentence ends
bge_else.99533:
	lw %f0 %a2 0 #19
	lw %f1 %a2 4 #19
	lw %f2 %a2 8 #19
	sw %a2 %sp 76 #822
	sw %a3 %sp 80 #822
	sw %f0 %sp 88 #822
	sw %f2 %sp 96 #822
	sw %f1 %sp 104 #822
	sw %a1 %sp 112 #822
	sw %ra %sp 116 #822 call dir
	addi %sp %sp 120 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -120 #822
	lw %ra %sp 116 #822
	lw %a0 %sp 112 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 104 #822
	sw %f0 %sp 120 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #822 call dir
	addi %sp %sp 136 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -136 #822
	lw %ra %sp 132 #822
	lw %a0 %sp 112 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 120 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 96 #822
	sw %f0 %sp 128 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 140 #822 call dir
	addi %sp %sp 144 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -144 #822
	lw %ra %sp 140 #822
	lw %a0 %sp 112 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 128 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99537 # nontail if
	jal %zero beq_cont.99538 # then sentence ends
beq_else.99537:
	lw %f1 %sp 96 #828
	lw %f2 %sp 104 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 88 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a0 %a0 36 #416
	lw %f2 %a0 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99538:
	lw %a0 %sp 80 #868
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.99539 # nontail if
	li %f1 l.90464 #1139
	fsub %f0 %f0 %f1 #1139
	jal %zero beq_cont.99540 # then sentence ends
beq_else.99539:
beq_cont.99540:
	lw %a0 %sp 76 #1139
	sw %f0 %a0 12 #1139
bge_cont.99534:
beq_cont.99532:
	lw %a0 %sp 72 #1141
	addi %a1 %a0 -1 #1141
	lw %a0 %sp 4 #1141
	lw %a11 %sp 0 #1141
	lw %a10 %a11 0 #1141
	jalr %zero %a10 0 #1141
bge_else.99530:
	jalr %zero %ra 0 #1142
bge_else.99520:
	jalr %zero %ra 0 #1142
setup_startp.2484:
	lw %a1 %a11 16 #1145
	lw %a2 %a11 12 #1145
	lw %a3 %a11 8 #1145
	lw %a4 %a11 4 #1145
	lw %f0 %a0 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a1 8 #154
	lw %a1 %a4 0 #15
	addi %a1 %a1 -1 #1147
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.99543
	slli %a4 %a1 2 #20
	add %a12 %a3 %a4 #20
	lw %a3 %a12 0 #20
	lw %a4 %a3 40 #427
	lw %a5 %a3 4 #238
	lw %f0 %a0 0 #1131
	lw %a6 %a3 20 #316
	lw %f1 %a6 0 #321
	fsub %f0 %f0 %f1 #1131
	sw %f0 %a4 0 #1131
	lw %f0 %a0 4 #1131
	lw %a6 %a3 20 #326
	lw %f1 %a6 4 #331
	fsub %f0 %f0 %f1 #1132
	sw %f0 %a4 4 #1132
	lw %f0 %a0 8 #1131
	lw %a6 %a3 20 #336
	lw %f1 %a6 8 #341
	fsub %f0 %f0 %f1 #1133
	sw %f0 %a4 8 #1133
	sw %a0 %sp 0 #868
	sw %a2 %sp 4 #868
	sw %a1 %sp 8 #868
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.99544 # nontail if
	lw %a3 %a3 16 #306
	lw %f0 %a4 0 #19
	lw %f1 %a4 4 #19
	lw %f2 %a4 8 #19
	lw %f3 %a3 0 #186
	fmul %f0 %f3 %f0 #186
	lw %f3 %a3 4 #186
	fmul %f1 %f3 %f1 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a3 8 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	sw %f0 %a4 12 #1135
	jal %zero beq_cont.99545 # then sentence ends
beq_else.99544:
	addi %a12 %zero 2
	blt %a12 %a5 bge_else.99546 # nontail if
	jal %zero bge_cont.99547 # then sentence ends
bge_else.99546:
	lw %f0 %a4 0 #19
	lw %f1 %a4 4 #19
	lw %f2 %a4 8 #19
	sw %a4 %sp 12 #822
	sw %a5 %sp 16 #822
	sw %f0 %sp 24 #822
	sw %f2 %sp 32 #822
	sw %f1 %sp 40 #822
	sw %a3 %sp 48 #822
	sw %ra %sp 52 #822 call dir
	addi %sp %sp 56 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -56 #822
	lw %ra %sp 52 #822
	lw %a0 %sp 48 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 40 #822
	sw %f0 %sp 56 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #822 call dir
	addi %sp %sp 72 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -72 #822
	lw %ra %sp 68 #822
	lw %a0 %sp 48 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 56 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 32 #822
	sw %f0 %sp 64 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #822 call dir
	addi %sp %sp 80 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -80 #822
	lw %ra %sp 76 #822
	lw %a0 %sp 48 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 64 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99550 # nontail if
	jal %zero beq_cont.99551 # then sentence ends
beq_else.99550:
	lw %f1 %sp 32 #828
	lw %f2 %sp 40 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 24 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a0 %a0 36 #416
	lw %f2 %a0 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99551:
	lw %a0 %sp 16 #868
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.99552 # nontail if
	li %f1 l.90464 #1139
	fsub %f0 %f0 %f1 #1139
	jal %zero beq_cont.99553 # then sentence ends
beq_else.99552:
beq_cont.99553:
	lw %a0 %sp 12 #1139
	sw %f0 %a0 12 #1139
bge_cont.99547:
beq_cont.99545:
	lw %a0 %sp 8 #1141
	addi %a1 %a0 -1 #1141
	lw %a0 %sp 0 #1141
	lw %a11 %sp 4 #1141
	lw %a10 %a11 0 #1141
	jalr %zero %a10 0 #1141
bge_else.99543:
	jalr %zero %ra 0 #1142
is_outside.2501:
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
	bne %a1 %a12 beq_else.99555
	sw %f2 %sp 0 #1157
	sw %f1 %sp 8 #1157
	sw %a0 %sp 16 #1157
	sw %ra %sp 20 #1157 call dir
	addi %sp %sp 24 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -24 #1157
	lw %ra %sp 20 #1157
	lw %a0 %sp 16 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 20 #1157 call dir
	addi %sp %sp 24 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -24 #1157
	lw %ra %sp 20 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99556 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99557 # then sentence ends
beq_else.99556:
	lw %f0 %sp 8 #1158
	sw %ra %sp 20 #1158 call dir
	addi %sp %sp 24 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -24 #1158
	lw %ra %sp 20 #1158
	lw %a0 %sp 16 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 20 #1158 call dir
	addi %sp %sp 24 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -24 #1158
	lw %ra %sp 20 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99558 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99559 # then sentence ends
beq_else.99558:
	lw %f0 %sp 0 #1159
	sw %ra %sp 20 #1159 call dir
	addi %sp %sp 24 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -24 #1159
	lw %ra %sp 20 #1159
	lw %a0 %sp 16 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 20 #1159 call dir
	addi %sp %sp 24 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -24 #1159
	lw %ra %sp 20 #1159
beq_cont.99559:
beq_cont.99557:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99560
	lw %a0 %sp 16 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99561
	addi %a0 %zero 1 #1162
	jalr %zero %ra 0 #1162
beq_else.99561:
	addi %a0 %zero 0 #1156
	jalr %zero %ra 0 #1156
beq_else.99560:
	lw %a0 %sp 16 #258
	lw %a0 %a0 24 #258
	jalr %zero %ra 0 #262
beq_else.99555:
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.99562
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
	sw %a0 %sp 20 #1168
	sw %ra %sp 28 #1168 call dir
	addi %sp %sp 32 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -32 #1168
	lw %ra %sp 28 #1168
	lw %a1 %sp 20 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99563 # nontail if
	jal %zero beq_cont.99564 # then sentence ends
beq_else.99563:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99565 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99566 # then sentence ends
beq_else.99565:
	addi %a0 %zero 0 #105
beq_cont.99566:
beq_cont.99564:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99567
	addi %a0 %zero 1 #1168
	jalr %zero %ra 0 #1168
beq_else.99567:
	addi %a0 %zero 0 #1168
	jalr %zero %ra 0 #1168
beq_else.99562:
	sw %f0 %sp 24 #822
	sw %f2 %sp 0 #822
	sw %f1 %sp 8 #822
	sw %a0 %sp 16 #822
	sw %ra %sp 36 #822 call dir
	addi %sp %sp 40 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -40 #822
	lw %ra %sp 36 #822
	lw %a0 %sp 16 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 8 #822
	sw %f0 %sp 32 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #822 call dir
	addi %sp %sp 48 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -48 #822
	lw %ra %sp 44 #822
	lw %a0 %sp 16 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 32 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 0 #822
	sw %f0 %sp 40 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #822 call dir
	addi %sp %sp 56 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -56 #822
	lw %ra %sp 52 #822
	lw %a0 %sp 16 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 40 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99568 # nontail if
	jal %zero beq_cont.99569 # then sentence ends
beq_else.99568:
	lw %f1 %sp 0 #828
	lw %f2 %sp 8 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 24 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99569:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99570 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99571 # then sentence ends
beq_else.99570:
beq_cont.99571:
	lw %a0 %a0 24 #258
	sw %a0 %sp 48 #1175
	sw %ra %sp 52 #1175 call dir
	addi %sp %sp 56 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -56 #1175
	lw %ra %sp 52 #1175
	lw %a1 %sp 48 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99572 # nontail if
	jal %zero beq_cont.99573 # then sentence ends
beq_else.99572:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99574 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99575 # then sentence ends
beq_else.99574:
	addi %a0 %zero 0 #105
beq_cont.99575:
beq_cont.99573:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99576
	addi %a0 %zero 1 #1175
	jalr %zero %ra 0 #1175
beq_else.99576:
	addi %a0 %zero 0 #1175
	jalr %zero %ra 0 #1175
check_all_inside.2506:
	lw %a2 %a11 4 #1193
	slli %a3 %a0 2 #1194
	add %a12 %a1 %a3 #1194
	lw %a3 %a12 0 #1194
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.99577
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.99577:
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
	sw %a11 %sp 0 #868
	sw %f2 %sp 8 #868
	sw %f1 %sp 16 #868
	sw %f0 %sp 24 #868
	sw %a2 %sp 32 #868
	sw %a1 %sp 36 #868
	sw %a0 %sp 40 #868
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.99579 # nontail if
	sw %f5 %sp 48 #1157
	sw %f4 %sp 56 #1157
	sw %a3 %sp 64 #1157
	fadd %f0 %f3 %fzero
	sw %ra %sp 68 #1157 call dir
	addi %sp %sp 72 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -72 #1157
	lw %ra %sp 68 #1157
	lw %a0 %sp 64 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 68 #1157 call dir
	addi %sp %sp 72 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -72 #1157
	lw %ra %sp 68 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99582 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99583 # then sentence ends
beq_else.99582:
	lw %f0 %sp 56 #1158
	sw %ra %sp 68 #1158 call dir
	addi %sp %sp 72 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -72 #1158
	lw %ra %sp 68 #1158
	lw %a0 %sp 64 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 68 #1158 call dir
	addi %sp %sp 72 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -72 #1158
	lw %ra %sp 68 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99584 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99585 # then sentence ends
beq_else.99584:
	lw %f0 %sp 48 #1159
	sw %ra %sp 68 #1159 call dir
	addi %sp %sp 72 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -72 #1159
	lw %ra %sp 68 #1159
	lw %a0 %sp 64 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 68 #1159 call dir
	addi %sp %sp 72 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -72 #1159
	lw %ra %sp 68 #1159
beq_cont.99585:
beq_cont.99583:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99586 # nontail if
	lw %a0 %sp 64 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99588 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99589 # then sentence ends
beq_else.99588:
	addi %a0 %zero 0 #1156
beq_cont.99589:
	jal %zero beq_cont.99587 # then sentence ends
beq_else.99586:
	lw %a0 %sp 64 #258
	lw %a0 %a0 24 #258
beq_cont.99587:
	jal %zero beq_cont.99580 # then sentence ends
beq_else.99579:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.99590 # nontail if
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
	sw %a3 %sp 68 #1168
	fadd %f0 %f3 %fzero
	sw %ra %sp 76 #1168 call dir
	addi %sp %sp 80 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -80 #1168
	lw %ra %sp 76 #1168
	lw %a1 %sp 68 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99592 # nontail if
	jal %zero beq_cont.99593 # then sentence ends
beq_else.99592:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99594 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99595 # then sentence ends
beq_else.99594:
	addi %a0 %zero 0 #105
beq_cont.99595:
beq_cont.99593:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99596 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99597 # then sentence ends
beq_else.99596:
	addi %a0 %zero 0 #1168
beq_cont.99597:
	jal %zero beq_cont.99591 # then sentence ends
beq_else.99590:
	sw %f3 %sp 72 #822
	sw %f5 %sp 48 #822
	sw %f4 %sp 56 #822
	sw %a3 %sp 64 #822
	fadd %f0 %f3 %fzero
	sw %ra %sp 84 #822 call dir
	addi %sp %sp 88 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -88 #822
	lw %ra %sp 84 #822
	lw %a0 %sp 64 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 56 #822
	sw %f0 %sp 80 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 92 #822 call dir
	addi %sp %sp 96 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -96 #822
	lw %ra %sp 92 #822
	lw %a0 %sp 64 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 80 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 48 #822
	sw %f0 %sp 88 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 100 #822 call dir
	addi %sp %sp 104 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -104 #822
	lw %ra %sp 100 #822
	lw %a0 %sp 64 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 88 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99598 # nontail if
	jal %zero beq_cont.99599 # then sentence ends
beq_else.99598:
	lw %f1 %sp 48 #828
	lw %f2 %sp 56 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 72 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99599:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99600 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99601 # then sentence ends
beq_else.99600:
beq_cont.99601:
	lw %a0 %a0 24 #258
	sw %a0 %sp 96 #1175
	sw %ra %sp 100 #1175 call dir
	addi %sp %sp 104 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -104 #1175
	lw %ra %sp 100 #1175
	lw %a1 %sp 96 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99602 # nontail if
	jal %zero beq_cont.99603 # then sentence ends
beq_else.99602:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99604 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99605 # then sentence ends
beq_else.99604:
	addi %a0 %zero 0 #105
beq_cont.99605:
beq_cont.99603:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99606 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99607 # then sentence ends
beq_else.99606:
	addi %a0 %zero 0 #1175
beq_cont.99607:
beq_cont.99591:
beq_cont.99580:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99608
	lw %a0 %sp 40 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99609
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.99609:
	slli %a1 %a1 2 #20
	lw %a3 %sp 32 #20
	add %a12 %a3 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 24 #1198
	lw %f1 %sp 16 #1198
	lw %f2 %sp 8 #1198
	sw %a0 %sp 100 #1198
	add %a0 %a1 %zero
	sw %ra %sp 108 #1198 call dir
	addi %sp %sp 112 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -112 #1198
	lw %ra %sp 108 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99610
	lw %a0 %sp 100 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99611
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.99611:
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
	sw %a0 %sp 104 #868
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.99612 # nontail if
	sw %f4 %sp 112 #1157
	sw %f2 %sp 120 #1157
	sw %a1 %sp 128 #1157
	sw %ra %sp 132 #1157 call dir
	addi %sp %sp 136 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -136 #1157
	lw %ra %sp 132 #1157
	lw %a0 %sp 128 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 132 #1157 call dir
	addi %sp %sp 136 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -136 #1157
	lw %ra %sp 132 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99615 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99616 # then sentence ends
beq_else.99615:
	lw %f0 %sp 120 #1158
	sw %ra %sp 132 #1158 call dir
	addi %sp %sp 136 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -136 #1158
	lw %ra %sp 132 #1158
	lw %a0 %sp 128 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 132 #1158 call dir
	addi %sp %sp 136 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -136 #1158
	lw %ra %sp 132 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99617 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99618 # then sentence ends
beq_else.99617:
	lw %f0 %sp 112 #1159
	sw %ra %sp 132 #1159 call dir
	addi %sp %sp 136 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -136 #1159
	lw %ra %sp 132 #1159
	lw %a0 %sp 128 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 132 #1159 call dir
	addi %sp %sp 136 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -136 #1159
	lw %ra %sp 132 #1159
beq_cont.99618:
beq_cont.99616:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99619 # nontail if
	lw %a0 %sp 128 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99621 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99622 # then sentence ends
beq_else.99621:
	addi %a0 %zero 0 #1156
beq_cont.99622:
	jal %zero beq_cont.99620 # then sentence ends
beq_else.99619:
	lw %a0 %sp 128 #258
	lw %a0 %a0 24 #258
beq_cont.99620:
	jal %zero beq_cont.99613 # then sentence ends
beq_else.99612:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.99623 # nontail if
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
	sw %a1 %sp 132 #1168
	sw %ra %sp 140 #1168 call dir
	addi %sp %sp 144 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -144 #1168
	lw %ra %sp 140 #1168
	lw %a1 %sp 132 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99625 # nontail if
	jal %zero beq_cont.99626 # then sentence ends
beq_else.99625:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99627 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99628 # then sentence ends
beq_else.99627:
	addi %a0 %zero 0 #105
beq_cont.99628:
beq_cont.99626:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99629 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99630 # then sentence ends
beq_else.99629:
	addi %a0 %zero 0 #1168
beq_cont.99630:
	jal %zero beq_cont.99624 # then sentence ends
beq_else.99623:
	sw %f0 %sp 136 #822
	sw %f4 %sp 112 #822
	sw %f2 %sp 120 #822
	sw %a1 %sp 128 #822
	sw %ra %sp 148 #822 call dir
	addi %sp %sp 152 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -152 #822
	lw %ra %sp 148 #822
	lw %a0 %sp 128 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 120 #822
	sw %f0 %sp 144 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 156 #822 call dir
	addi %sp %sp 160 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -160 #822
	lw %ra %sp 156 #822
	lw %a0 %sp 128 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 144 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 112 #822
	sw %f0 %sp 152 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 164 #822 call dir
	addi %sp %sp 168 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -168 #822
	lw %ra %sp 164 #822
	lw %a0 %sp 128 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 152 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99631 # nontail if
	jal %zero beq_cont.99632 # then sentence ends
beq_else.99631:
	lw %f1 %sp 112 #828
	lw %f2 %sp 120 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 136 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99632:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99633 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99634 # then sentence ends
beq_else.99633:
beq_cont.99634:
	lw %a0 %a0 24 #258
	sw %a0 %sp 160 #1175
	sw %ra %sp 164 #1175 call dir
	addi %sp %sp 168 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -168 #1175
	lw %ra %sp 164 #1175
	lw %a1 %sp 160 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99635 # nontail if
	jal %zero beq_cont.99636 # then sentence ends
beq_else.99635:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99637 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99638 # then sentence ends
beq_else.99637:
	addi %a0 %zero 0 #105
beq_cont.99638:
beq_cont.99636:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99639 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99640 # then sentence ends
beq_else.99639:
	addi %a0 %zero 0 #1175
beq_cont.99640:
beq_cont.99624:
beq_cont.99613:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99641
	lw %a0 %sp 104 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99642
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.99642:
	slli %a1 %a1 2 #20
	lw %a3 %sp 32 #20
	add %a12 %a3 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 24 #1198
	lw %f1 %sp 16 #1198
	lw %f2 %sp 8 #1198
	sw %a0 %sp 164 #1198
	add %a0 %a1 %zero
	sw %ra %sp 172 #1198 call dir
	addi %sp %sp 176 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -176 #1198
	lw %ra %sp 172 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99643
	lw %a0 %sp 164 #1201
	addi %a0 %a0 1 #1201
	lw %f0 %sp 24 #1201
	lw %f1 %sp 16 #1201
	lw %f2 %sp 8 #1201
	lw %a1 %sp 36 #1201
	lw %a11 %sp 0 #1201
	lw %a10 %a11 0 #1201
	jalr %zero %a10 0 #1201
beq_else.99643:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
beq_else.99641:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
beq_else.99610:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
beq_else.99608:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
shadow_check_and_group.2512:
	lw %a2 %a11 44 #1211
	lw %a3 %a11 40 #1211
	lw %a4 %a11 36 #1211
	lw %a5 %a11 32 #1211
	lw %a6 %a11 28 #1211
	lw %a7 %a11 24 #1211
	lw %a8 %a11 20 #1211
	lw %a9 %a11 16 #1211
	lw %a10 %a11 12 #1211
	sw %a9 %sp 0 #1211
	lw %a9 %a11 8 #1211
	sw %a11 %sp 4 #1211
	lw %a11 %a11 4 #1211
	sw %a11 %sp 8 #1212
	slli %a11 %a0 2 #1212
	add %a12 %a1 %a11 #1212
	lw %a11 %a12 0 #1212
	addi %a12 %zero -1
	bne %a11 %a12 beq_else.99644
	addi %a0 %zero 0 #1213
	jalr %zero %ra 0 #1213
beq_else.99644:
	sw %a8 %sp 12 #20
	slli %a8 %a11 2 #20
	add %a12 %a7 %a8 #20
	lw %a8 %a12 0 #20
	lw %f0 %a10 0 #964
	sw %a5 %sp 16 #316
	lw %a5 %a8 20 #316
	lw %f1 %a5 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a10 4 #964
	lw %a5 %a8 20 #326
	lw %f2 %a5 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a10 8 #964
	lw %a5 %a8 20 #336
	lw %f3 %a5 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a5 %a11 2 #968
	add %a12 %a9 %a5 #968
	lw %a5 %a12 0 #968
	lw %a9 %a8 4 #238
	sw %a10 %sp 20 #868
	sw %a1 %sp 24 #868
	sw %a0 %sp 28 #868
	sw %a7 %sp 32 #868
	sw %a11 %sp 36 #868
	sw %a6 %sp 40 #868
	addi %a12 %zero 1
	bne %a9 %a12 beq_else.99645 # nontail if
	add %a1 %a2 %zero
	add %a0 %a8 %zero
	add %a11 %a4 %zero
	add %a2 %a5 %zero
	sw %ra %sp 44 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 48 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -48 #971
	lw %ra %sp 44 #971
	jal %zero beq_cont.99646 # then sentence ends
beq_else.99645:
	addi %a12 %zero 2
	bne %a9 %a12 beq_else.99647 # nontail if
	lw %f3 %a5 0 #934
	sw %f2 %sp 48 #934
	sw %f1 %sp 56 #934
	sw %f0 %sp 64 #934
	sw %a5 %sp 72 #934
	fadd %f0 %f3 %fzero
	sw %ra %sp 76 #934 call dir
	addi %sp %sp 80 #934	
	jal %ra min_caml_fisneg #934
	addi %sp %sp -80 #934
	lw %ra %sp 76 #934
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99650 # nontail if
	addi %a0 %zero 0 #934
	jal %zero beq_cont.99651 # then sentence ends
beq_else.99650:
	lw %a0 %sp 72 #934
	lw %f0 %a0 4 #934
	lw %f1 %sp 64 #936
	fmul %f0 %f0 %f1 #936
	lw %f1 %a0 8 #934
	lw %f2 %sp 56 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a0 12 #934
	lw %f2 %sp 48 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a0 %sp 40 #935
	sw %f0 %a0 0 #935
	addi %a0 %zero 1 #937
beq_cont.99651:
	jal %zero beq_cont.99648 # then sentence ends
beq_else.99647:
	add %a1 %a5 %zero
	add %a0 %a8 %zero
	add %a11 %a3 %zero
	sw %ra %sp 76 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 80 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -80 #975
	lw %ra %sp 76 #975
beq_cont.99648:
beq_cont.99646:
	lw %a1 %sp 40 #37
	lw %f0 %a1 0 #37
	sw %f0 %sp 80 #909
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99653 # nontail if
	addi %a0 %zero 0 #1218
	jal %zero beq_cont.99654 # then sentence ends
beq_else.99653:
	li %f1 l.91123 #1218
	sw %ra %sp 92 #1218 call dir
	addi %sp %sp 96 #1218	
	jal %ra min_caml_fless #1218
	addi %sp %sp -96 #1218
	lw %ra %sp 92 #1218
beq_cont.99654:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99655
	lw %a0 %sp 36 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 32 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99656
	addi %a0 %zero 0 #1218
	jalr %zero %ra 0 #1218
beq_else.99656:
	lw %a0 %sp 28 #1235
	addi %a0 %a0 1 #1235
	slli %a2 %a0 2 #1212
	lw %a3 %sp 24 #1212
	add %a12 %a3 %a2 #1212
	lw %a2 %a12 0 #1212
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.99657
	addi %a0 %zero 0 #1213
	jalr %zero %ra 0 #1213
beq_else.99657:
	lw %a4 %sp 12 #1216
	lw %a5 %sp 20 #1216
	lw %a11 %sp 16 #1216
	sw %a0 %sp 88 #1216
	sw %a2 %sp 92 #1216
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	add %a2 %a5 %zero
	sw %ra %sp 100 #1216 call cls
	lw %a10 %a11 0 #1216
	addi %sp %sp 104 #1216	
	jalr %ra %a10 0 #1216
	addi %sp %sp -104 #1216
	lw %ra %sp 100 #1216
	lw %a1 %sp 40 #37
	lw %f0 %a1 0 #37
	sw %f0 %sp 96 #909
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99658 # nontail if
	addi %a0 %zero 0 #1218
	jal %zero beq_cont.99659 # then sentence ends
beq_else.99658:
	li %f1 l.91123 #1218
	sw %ra %sp 108 #1218 call dir
	addi %sp %sp 112 #1218	
	jal %ra min_caml_fless #1218
	addi %sp %sp -112 #1218
	lw %ra %sp 108 #1218
beq_cont.99659:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99660
	lw %a0 %sp 92 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 32 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99661
	addi %a0 %zero 0 #1218
	jalr %zero %ra 0 #1218
beq_else.99661:
	lw %a0 %sp 88 #1235
	addi %a0 %a0 1 #1235
	lw %a1 %sp 24 #1235
	lw %a11 %sp 4 #1235
	lw %a10 %a11 0 #1235
	jalr %zero %a10 0 #1235
beq_else.99660:
	li %f0 l.91125 #1221
	lw %f1 %sp 96 #1221
	fadd %f0 %f1 %f0 #1221
	lw %a0 %sp 0 #27
	lw %f1 %a0 0 #27
	fmul %f1 %f1 %f0 #1222
	lw %a1 %sp 20 #43
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
	lw %a1 %sp 24 #1194
	lw %a0 %a1 0 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99662 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99663 # then sentence ends
beq_else.99662:
	slli %a0 %a0 2 #20
	lw %a2 %sp 32 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f3 %a3 0 #321
	fsub %f3 %f1 %f3 #1180
	lw %a3 %a0 20 #326
	lw %f4 %a3 4 #331
	fsub %f4 %f2 %f4 #1181
	lw %a3 %a0 20 #336
	lw %f5 %a3 8 #341
	fsub %f5 %f0 %f5 #1182
	lw %a3 %a0 4 #238
	sw %f0 %sp 104 #868
	sw %f2 %sp 112 #868
	sw %f1 %sp 120 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.99664 # nontail if
	sw %f5 %sp 128 #1157
	sw %f4 %sp 136 #1157
	sw %a0 %sp 144 #1157
	fadd %f0 %f3 %fzero
	sw %ra %sp 148 #1157 call dir
	addi %sp %sp 152 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -152 #1157
	lw %ra %sp 148 #1157
	lw %a0 %sp 144 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 148 #1157 call dir
	addi %sp %sp 152 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -152 #1157
	lw %ra %sp 148 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99666 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99667 # then sentence ends
beq_else.99666:
	lw %f0 %sp 136 #1158
	sw %ra %sp 148 #1158 call dir
	addi %sp %sp 152 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -152 #1158
	lw %ra %sp 148 #1158
	lw %a0 %sp 144 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 148 #1158 call dir
	addi %sp %sp 152 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -152 #1158
	lw %ra %sp 148 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99668 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99669 # then sentence ends
beq_else.99668:
	lw %f0 %sp 128 #1159
	sw %ra %sp 148 #1159 call dir
	addi %sp %sp 152 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -152 #1159
	lw %ra %sp 148 #1159
	lw %a0 %sp 144 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 148 #1159 call dir
	addi %sp %sp 152 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -152 #1159
	lw %ra %sp 148 #1159
beq_cont.99669:
beq_cont.99667:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99670 # nontail if
	lw %a0 %sp 144 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99672 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99673 # then sentence ends
beq_else.99672:
	addi %a0 %zero 0 #1156
beq_cont.99673:
	jal %zero beq_cont.99671 # then sentence ends
beq_else.99670:
	lw %a0 %sp 144 #258
	lw %a0 %a0 24 #258
beq_cont.99671:
	jal %zero beq_cont.99665 # then sentence ends
beq_else.99664:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.99674 # nontail if
	lw %a3 %a0 16 #306
	lw %f6 %a3 0 #186
	fmul %f3 %f6 %f3 #186
	lw %f6 %a3 4 #186
	fmul %f4 %f6 %f4 #186
	fadd %f3 %f3 %f4 #186
	lw %f4 %a3 8 #186
	fmul %f4 %f4 %f5 #186
	fadd %f3 %f3 %f4 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 148 #1168
	fadd %f0 %f3 %fzero
	sw %ra %sp 156 #1168 call dir
	addi %sp %sp 160 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -160 #1168
	lw %ra %sp 156 #1168
	lw %a1 %sp 148 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99676 # nontail if
	jal %zero beq_cont.99677 # then sentence ends
beq_else.99676:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99678 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99679 # then sentence ends
beq_else.99678:
	addi %a0 %zero 0 #105
beq_cont.99679:
beq_cont.99677:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99680 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99681 # then sentence ends
beq_else.99680:
	addi %a0 %zero 0 #1168
beq_cont.99681:
	jal %zero beq_cont.99675 # then sentence ends
beq_else.99674:
	sw %f3 %sp 152 #822
	sw %f5 %sp 128 #822
	sw %f4 %sp 136 #822
	sw %a0 %sp 144 #822
	fadd %f0 %f3 %fzero
	sw %ra %sp 164 #822 call dir
	addi %sp %sp 168 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -168 #822
	lw %ra %sp 164 #822
	lw %a0 %sp 144 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 136 #822
	sw %f0 %sp 160 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 172 #822 call dir
	addi %sp %sp 176 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -176 #822
	lw %ra %sp 172 #822
	lw %a0 %sp 144 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 160 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 128 #822
	sw %f0 %sp 168 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 180 #822 call dir
	addi %sp %sp 184 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -184 #822
	lw %ra %sp 180 #822
	lw %a0 %sp 144 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 168 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99682 # nontail if
	jal %zero beq_cont.99683 # then sentence ends
beq_else.99682:
	lw %f1 %sp 128 #828
	lw %f2 %sp 136 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 152 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99683:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99684 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99685 # then sentence ends
beq_else.99684:
beq_cont.99685:
	lw %a0 %a0 24 #258
	sw %a0 %sp 176 #1175
	sw %ra %sp 180 #1175 call dir
	addi %sp %sp 184 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -184 #1175
	lw %ra %sp 180 #1175
	lw %a1 %sp 176 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99686 # nontail if
	jal %zero beq_cont.99687 # then sentence ends
beq_else.99686:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99688 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99689 # then sentence ends
beq_else.99688:
	addi %a0 %zero 0 #105
beq_cont.99689:
beq_cont.99687:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99690 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99691 # then sentence ends
beq_else.99690:
	addi %a0 %zero 0 #1175
beq_cont.99691:
beq_cont.99675:
beq_cont.99665:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99692 # nontail if
	lw %a1 %sp 24 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99694 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99695 # then sentence ends
beq_else.99694:
	slli %a0 %a0 2 #20
	lw %a2 %sp 32 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 120 #1198
	lw %f1 %sp 112 #1198
	lw %f2 %sp 104 #1198
	sw %ra %sp 180 #1198 call dir
	addi %sp %sp 184 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -184 #1198
	lw %ra %sp 180 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99696 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 120 #1201
	lw %f1 %sp 112 #1201
	lw %f2 %sp 104 #1201
	lw %a1 %sp 24 #1201
	lw %a11 %sp 8 #1201
	sw %ra %sp 180 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 184 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -184 #1201
	lw %ra %sp 180 #1201
	jal %zero beq_cont.99697 # then sentence ends
beq_else.99696:
	addi %a0 %zero 0 #1198
beq_cont.99697:
beq_cont.99695:
	jal %zero beq_cont.99693 # then sentence ends
beq_else.99692:
	addi %a0 %zero 0 #1198
beq_cont.99693:
beq_cont.99663:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99698
	lw %a0 %sp 88 #1228
	addi %a0 %a0 1 #1228
	lw %a1 %sp 24 #1228
	lw %a11 %sp 4 #1228
	lw %a10 %a11 0 #1228
	jalr %zero %a10 0 #1228
beq_else.99698:
	addi %a0 %zero 1 #1226
	jalr %zero %ra 0 #1226
beq_else.99655:
	li %f0 l.91125 #1221
	lw %f1 %sp 80 #1221
	fadd %f0 %f1 %f0 #1221
	lw %a0 %sp 0 #27
	lw %f1 %a0 0 #27
	fmul %f1 %f1 %f0 #1222
	lw %a2 %sp 20 #43
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
	lw %a1 %sp 24 #1194
	lw %a3 %a1 0 #1194
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.99699 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99700 # then sentence ends
beq_else.99699:
	slli %a3 %a3 2 #20
	lw %a4 %sp 32 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	sw %f0 %sp 184 #1198
	sw %f2 %sp 192 #1198
	sw %f1 %sp 200 #1198
	add %a0 %a3 %zero
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 212 #1198 call dir
	addi %sp %sp 216 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -216 #1198
	lw %ra %sp 212 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99702 # nontail if
	lw %a0 %sp 24 #1194
	lw %a1 %a0 4 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99704 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99705 # then sentence ends
beq_else.99704:
	slli %a1 %a1 2 #20
	lw %a2 %sp 32 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a3 %a1 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 200 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a1 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 192 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a1 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 184 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a1 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.99706 # nontail if
	sw %f4 %sp 208 #1157
	sw %f2 %sp 216 #1157
	sw %a1 %sp 224 #1157
	sw %ra %sp 228 #1157 call dir
	addi %sp %sp 232 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -232 #1157
	lw %ra %sp 228 #1157
	lw %a0 %sp 224 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 228 #1157 call dir
	addi %sp %sp 232 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -232 #1157
	lw %ra %sp 228 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99708 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99709 # then sentence ends
beq_else.99708:
	lw %f0 %sp 216 #1158
	sw %ra %sp 228 #1158 call dir
	addi %sp %sp 232 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -232 #1158
	lw %ra %sp 228 #1158
	lw %a0 %sp 224 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 228 #1158 call dir
	addi %sp %sp 232 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -232 #1158
	lw %ra %sp 228 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99710 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99711 # then sentence ends
beq_else.99710:
	lw %f0 %sp 208 #1159
	sw %ra %sp 228 #1159 call dir
	addi %sp %sp 232 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -232 #1159
	lw %ra %sp 228 #1159
	lw %a0 %sp 224 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 228 #1159 call dir
	addi %sp %sp 232 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -232 #1159
	lw %ra %sp 228 #1159
beq_cont.99711:
beq_cont.99709:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99712 # nontail if
	lw %a0 %sp 224 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99714 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99715 # then sentence ends
beq_else.99714:
	addi %a0 %zero 0 #1156
beq_cont.99715:
	jal %zero beq_cont.99713 # then sentence ends
beq_else.99712:
	lw %a0 %sp 224 #258
	lw %a0 %a0 24 #258
beq_cont.99713:
	jal %zero beq_cont.99707 # then sentence ends
beq_else.99706:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.99716 # nontail if
	lw %a3 %a1 16 #306
	lw %f6 %a3 0 #186
	fmul %f0 %f6 %f0 #186
	lw %f6 %a3 4 #186
	fmul %f2 %f6 %f2 #186
	fadd %f0 %f0 %f2 #186
	lw %f2 %a3 8 #186
	fmul %f2 %f2 %f4 #186
	fadd %f0 %f0 %f2 #186
	lw %a1 %a1 24 #258
	sw %a1 %sp 228 #1168
	sw %ra %sp 236 #1168 call dir
	addi %sp %sp 240 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -240 #1168
	lw %ra %sp 236 #1168
	lw %a1 %sp 228 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99718 # nontail if
	jal %zero beq_cont.99719 # then sentence ends
beq_else.99718:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99720 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99721 # then sentence ends
beq_else.99720:
	addi %a0 %zero 0 #105
beq_cont.99721:
beq_cont.99719:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99722 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99723 # then sentence ends
beq_else.99722:
	addi %a0 %zero 0 #1168
beq_cont.99723:
	jal %zero beq_cont.99717 # then sentence ends
beq_else.99716:
	sw %f0 %sp 232 #822
	sw %f4 %sp 208 #822
	sw %f2 %sp 216 #822
	sw %a1 %sp 224 #822
	sw %ra %sp 244 #822 call dir
	addi %sp %sp 248 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -248 #822
	lw %ra %sp 244 #822
	lw %a0 %sp 224 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 216 #822
	sw %f0 %sp 240 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 252 #822 call dir
	addi %sp %sp 256 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -256 #822
	lw %ra %sp 252 #822
	lw %a0 %sp 224 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 240 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 208 #822
	sw %f0 %sp 248 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 260 #822 call dir
	addi %sp %sp 264 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -264 #822
	lw %ra %sp 260 #822
	lw %a0 %sp 224 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 248 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99724 # nontail if
	jal %zero beq_cont.99725 # then sentence ends
beq_else.99724:
	lw %f1 %sp 208 #828
	lw %f2 %sp 216 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 232 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99725:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99726 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99727 # then sentence ends
beq_else.99726:
beq_cont.99727:
	lw %a0 %a0 24 #258
	sw %a0 %sp 256 #1175
	sw %ra %sp 260 #1175 call dir
	addi %sp %sp 264 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -264 #1175
	lw %ra %sp 260 #1175
	lw %a1 %sp 256 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99728 # nontail if
	jal %zero beq_cont.99729 # then sentence ends
beq_else.99728:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99730 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99731 # then sentence ends
beq_else.99730:
	addi %a0 %zero 0 #105
beq_cont.99731:
beq_cont.99729:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99732 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99733 # then sentence ends
beq_else.99732:
	addi %a0 %zero 0 #1175
beq_cont.99733:
beq_cont.99717:
beq_cont.99707:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99734 # nontail if
	lw %a0 %sp 24 #1194
	lw %a1 %a0 8 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99736 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99737 # then sentence ends
beq_else.99736:
	slli %a1 %a1 2 #20
	lw %a2 %sp 32 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 200 #1198
	lw %f1 %sp 192 #1198
	lw %f2 %sp 184 #1198
	add %a0 %a1 %zero
	sw %ra %sp 260 #1198 call dir
	addi %sp %sp 264 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -264 #1198
	lw %ra %sp 260 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99738 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 200 #1201
	lw %f1 %sp 192 #1201
	lw %f2 %sp 184 #1201
	lw %a1 %sp 24 #1201
	lw %a11 %sp 8 #1201
	sw %ra %sp 260 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 264 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -264 #1201
	lw %ra %sp 260 #1201
	jal %zero beq_cont.99739 # then sentence ends
beq_else.99738:
	addi %a0 %zero 0 #1198
beq_cont.99739:
beq_cont.99737:
	jal %zero beq_cont.99735 # then sentence ends
beq_else.99734:
	addi %a0 %zero 0 #1198
beq_cont.99735:
beq_cont.99705:
	jal %zero beq_cont.99703 # then sentence ends
beq_else.99702:
	addi %a0 %zero 0 #1198
beq_cont.99703:
beq_cont.99700:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99740
	lw %a0 %sp 28 #1228
	addi %a0 %a0 1 #1228
	slli %a1 %a0 2 #1212
	lw %a2 %sp 24 #1212
	add %a12 %a2 %a1 #1212
	lw %a1 %a12 0 #1212
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99741
	addi %a0 %zero 0 #1213
	jalr %zero %ra 0 #1213
beq_else.99741:
	lw %a3 %sp 12 #1216
	lw %a4 %sp 20 #1216
	lw %a11 %sp 16 #1216
	sw %a0 %sp 260 #1216
	sw %a1 %sp 264 #1216
	add %a2 %a4 %zero
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 268 #1216 call cls
	lw %a10 %a11 0 #1216
	addi %sp %sp 272 #1216	
	jalr %ra %a10 0 #1216
	addi %sp %sp -272 #1216
	lw %ra %sp 268 #1216
	lw %a1 %sp 40 #37
	lw %f0 %a1 0 #37
	sw %f0 %sp 272 #909
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99743 # nontail if
	addi %a0 %zero 0 #1218
	jal %zero beq_cont.99744 # then sentence ends
beq_else.99743:
	li %f1 l.91123 #1218
	sw %ra %sp 284 #1218 call dir
	addi %sp %sp 288 #1218	
	jal %ra min_caml_fless #1218
	addi %sp %sp -288 #1218
	lw %ra %sp 284 #1218
beq_cont.99744:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99745
	lw %a0 %sp 264 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 32 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99746
	addi %a0 %zero 0 #1218
	jalr %zero %ra 0 #1218
beq_else.99746:
	lw %a0 %sp 260 #1235
	addi %a0 %a0 1 #1235
	lw %a1 %sp 24 #1235
	lw %a11 %sp 4 #1235
	lw %a10 %a11 0 #1235
	jalr %zero %a10 0 #1235
beq_else.99745:
	li %f0 l.91125 #1221
	lw %f1 %sp 272 #1221
	fadd %f0 %f1 %f0 #1221
	lw %a0 %sp 0 #27
	lw %f1 %a0 0 #27
	fmul %f1 %f1 %f0 #1222
	lw %a1 %sp 20 #43
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
	lw %a1 %sp 24 #1194
	lw %a0 %a1 0 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99747 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99748 # then sentence ends
beq_else.99747:
	slli %a0 %a0 2 #20
	lw %a2 %sp 32 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f3 %a3 0 #321
	fsub %f3 %f1 %f3 #1180
	lw %a3 %a0 20 #326
	lw %f4 %a3 4 #331
	fsub %f4 %f2 %f4 #1181
	lw %a3 %a0 20 #336
	lw %f5 %a3 8 #341
	fsub %f5 %f0 %f5 #1182
	lw %a3 %a0 4 #238
	sw %f0 %sp 280 #868
	sw %f2 %sp 288 #868
	sw %f1 %sp 296 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.99749 # nontail if
	sw %f5 %sp 304 #1157
	sw %f4 %sp 312 #1157
	sw %a0 %sp 320 #1157
	fadd %f0 %f3 %fzero
	sw %ra %sp 324 #1157 call dir
	addi %sp %sp 328 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -328 #1157
	lw %ra %sp 324 #1157
	lw %a0 %sp 320 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 324 #1157 call dir
	addi %sp %sp 328 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -328 #1157
	lw %ra %sp 324 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99751 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99752 # then sentence ends
beq_else.99751:
	lw %f0 %sp 312 #1158
	sw %ra %sp 324 #1158 call dir
	addi %sp %sp 328 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -328 #1158
	lw %ra %sp 324 #1158
	lw %a0 %sp 320 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 324 #1158 call dir
	addi %sp %sp 328 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -328 #1158
	lw %ra %sp 324 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99753 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99754 # then sentence ends
beq_else.99753:
	lw %f0 %sp 304 #1159
	sw %ra %sp 324 #1159 call dir
	addi %sp %sp 328 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -328 #1159
	lw %ra %sp 324 #1159
	lw %a0 %sp 320 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 324 #1159 call dir
	addi %sp %sp 328 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -328 #1159
	lw %ra %sp 324 #1159
beq_cont.99754:
beq_cont.99752:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99755 # nontail if
	lw %a0 %sp 320 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99757 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99758 # then sentence ends
beq_else.99757:
	addi %a0 %zero 0 #1156
beq_cont.99758:
	jal %zero beq_cont.99756 # then sentence ends
beq_else.99755:
	lw %a0 %sp 320 #258
	lw %a0 %a0 24 #258
beq_cont.99756:
	jal %zero beq_cont.99750 # then sentence ends
beq_else.99749:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.99759 # nontail if
	lw %a3 %a0 16 #306
	lw %f6 %a3 0 #186
	fmul %f3 %f6 %f3 #186
	lw %f6 %a3 4 #186
	fmul %f4 %f6 %f4 #186
	fadd %f3 %f3 %f4 #186
	lw %f4 %a3 8 #186
	fmul %f4 %f4 %f5 #186
	fadd %f3 %f3 %f4 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 324 #1168
	fadd %f0 %f3 %fzero
	sw %ra %sp 332 #1168 call dir
	addi %sp %sp 336 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -336 #1168
	lw %ra %sp 332 #1168
	lw %a1 %sp 324 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99761 # nontail if
	jal %zero beq_cont.99762 # then sentence ends
beq_else.99761:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99763 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99764 # then sentence ends
beq_else.99763:
	addi %a0 %zero 0 #105
beq_cont.99764:
beq_cont.99762:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99765 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99766 # then sentence ends
beq_else.99765:
	addi %a0 %zero 0 #1168
beq_cont.99766:
	jal %zero beq_cont.99760 # then sentence ends
beq_else.99759:
	sw %f3 %sp 328 #822
	sw %f5 %sp 304 #822
	sw %f4 %sp 312 #822
	sw %a0 %sp 320 #822
	fadd %f0 %f3 %fzero
	sw %ra %sp 340 #822 call dir
	addi %sp %sp 344 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -344 #822
	lw %ra %sp 340 #822
	lw %a0 %sp 320 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 312 #822
	sw %f0 %sp 336 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 348 #822 call dir
	addi %sp %sp 352 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -352 #822
	lw %ra %sp 348 #822
	lw %a0 %sp 320 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 336 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 304 #822
	sw %f0 %sp 344 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 356 #822 call dir
	addi %sp %sp 360 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -360 #822
	lw %ra %sp 356 #822
	lw %a0 %sp 320 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 344 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99767 # nontail if
	jal %zero beq_cont.99768 # then sentence ends
beq_else.99767:
	lw %f1 %sp 304 #828
	lw %f2 %sp 312 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 328 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99768:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99769 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99770 # then sentence ends
beq_else.99769:
beq_cont.99770:
	lw %a0 %a0 24 #258
	sw %a0 %sp 352 #1175
	sw %ra %sp 356 #1175 call dir
	addi %sp %sp 360 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -360 #1175
	lw %ra %sp 356 #1175
	lw %a1 %sp 352 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99771 # nontail if
	jal %zero beq_cont.99772 # then sentence ends
beq_else.99771:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99773 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99774 # then sentence ends
beq_else.99773:
	addi %a0 %zero 0 #105
beq_cont.99774:
beq_cont.99772:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99775 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99776 # then sentence ends
beq_else.99775:
	addi %a0 %zero 0 #1175
beq_cont.99776:
beq_cont.99760:
beq_cont.99750:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99777 # nontail if
	lw %a1 %sp 24 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99779 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99780 # then sentence ends
beq_else.99779:
	slli %a0 %a0 2 #20
	lw %a2 %sp 32 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 296 #1198
	lw %f1 %sp 288 #1198
	lw %f2 %sp 280 #1198
	sw %ra %sp 356 #1198 call dir
	addi %sp %sp 360 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -360 #1198
	lw %ra %sp 356 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99781 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 296 #1201
	lw %f1 %sp 288 #1201
	lw %f2 %sp 280 #1201
	lw %a1 %sp 24 #1201
	lw %a11 %sp 8 #1201
	sw %ra %sp 356 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 360 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -360 #1201
	lw %ra %sp 356 #1201
	jal %zero beq_cont.99782 # then sentence ends
beq_else.99781:
	addi %a0 %zero 0 #1198
beq_cont.99782:
beq_cont.99780:
	jal %zero beq_cont.99778 # then sentence ends
beq_else.99777:
	addi %a0 %zero 0 #1198
beq_cont.99778:
beq_cont.99748:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99783
	lw %a0 %sp 260 #1228
	addi %a0 %a0 1 #1228
	lw %a1 %sp 24 #1228
	lw %a11 %sp 4 #1228
	lw %a10 %a11 0 #1228
	jalr %zero %a10 0 #1228
beq_else.99783:
	addi %a0 %zero 1 #1226
	jalr %zero %ra 0 #1226
beq_else.99740:
	addi %a0 %zero 1 #1226
	jalr %zero %ra 0 #1226
shadow_check_one_or_group.2515:
	lw %a2 %a11 36 #1241
	lw %a3 %a11 32 #1241
	lw %a4 %a11 28 #1241
	lw %a5 %a11 24 #1241
	lw %a6 %a11 20 #1241
	lw %a7 %a11 16 #1241
	lw %a8 %a11 12 #1241
	lw %a9 %a11 8 #1241
	lw %a10 %a11 4 #1241
	sw %a11 %sp 0 #1242
	slli %a11 %a0 2 #1242
	add %a12 %a1 %a11 #1242
	lw %a11 %a12 0 #1242
	addi %a12 %zero -1
	bne %a11 %a12 beq_else.99784
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.99784:
	slli %a11 %a11 2 #31
	add %a12 %a10 %a11 #31
	lw %a11 %a12 0 #31
	sw %a10 %sp 4 #1212
	lw %a10 %a11 0 #1212
	sw %a4 %sp 8 #1212
	sw %a1 %sp 12 #1212
	sw %a0 %sp 16 #1212
	addi %a12 %zero -1
	bne %a10 %a12 beq_else.99785 # nontail if
	addi %a0 %zero 0 #1213
	jal %zero beq_cont.99786 # then sentence ends
beq_else.99785:
	sw %a9 %sp 20 #1216
	sw %a8 %sp 24 #1216
	sw %a7 %sp 28 #1216
	sw %a11 %sp 32 #1216
	sw %a5 %sp 36 #1216
	sw %a10 %sp 40 #1216
	sw %a3 %sp 44 #1216
	add %a1 %a6 %zero
	add %a0 %a10 %zero
	add %a11 %a2 %zero
	add %a2 %a8 %zero
	sw %ra %sp 52 #1216 call cls
	lw %a10 %a11 0 #1216
	addi %sp %sp 56 #1216	
	jalr %ra %a10 0 #1216
	addi %sp %sp -56 #1216
	lw %ra %sp 52 #1216
	lw %a1 %sp 44 #37
	lw %f0 %a1 0 #37
	sw %f0 %sp 48 #909
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99787 # nontail if
	addi %a0 %zero 0 #1218
	jal %zero beq_cont.99788 # then sentence ends
beq_else.99787:
	li %f1 l.91123 #1218
	sw %ra %sp 60 #1218 call dir
	addi %sp %sp 64 #1218	
	jal %ra min_caml_fless #1218
	addi %sp %sp -64 #1218
	lw %ra %sp 60 #1218
beq_cont.99788:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99789 # nontail if
	lw %a0 %sp 40 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 36 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99791 # nontail if
	addi %a0 %zero 0 #1218
	jal %zero beq_cont.99792 # then sentence ends
beq_else.99791:
	addi %a0 %zero 1 #1235
	lw %a1 %sp 32 #1235
	lw %a11 %sp 8 #1235
	sw %ra %sp 60 #1235 call cls
	lw %a10 %a11 0 #1235
	addi %sp %sp 64 #1235	
	jalr %ra %a10 0 #1235
	addi %sp %sp -64 #1235
	lw %ra %sp 60 #1235
beq_cont.99792:
	jal %zero beq_cont.99790 # then sentence ends
beq_else.99789:
	li %f0 l.91125 #1221
	lw %f1 %sp 48 #1221
	fadd %f0 %f1 %f0 #1221
	lw %a0 %sp 28 #27
	lw %f1 %a0 0 #27
	fmul %f1 %f1 %f0 #1222
	lw %a1 %sp 24 #43
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
	lw %a1 %sp 32 #1194
	lw %a0 %a1 0 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99793 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99794 # then sentence ends
beq_else.99793:
	slli %a0 %a0 2 #20
	lw %a2 %sp 36 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f3 %a3 0 #321
	fsub %f3 %f1 %f3 #1180
	lw %a3 %a0 20 #326
	lw %f4 %a3 4 #331
	fsub %f4 %f2 %f4 #1181
	lw %a3 %a0 20 #336
	lw %f5 %a3 8 #341
	fsub %f5 %f0 %f5 #1182
	lw %a3 %a0 4 #238
	sw %f0 %sp 56 #868
	sw %f2 %sp 64 #868
	sw %f1 %sp 72 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.99795 # nontail if
	sw %f5 %sp 80 #1157
	sw %f4 %sp 88 #1157
	sw %a0 %sp 96 #1157
	fadd %f0 %f3 %fzero
	sw %ra %sp 100 #1157 call dir
	addi %sp %sp 104 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -104 #1157
	lw %ra %sp 100 #1157
	lw %a0 %sp 96 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 100 #1157 call dir
	addi %sp %sp 104 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -104 #1157
	lw %ra %sp 100 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99797 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99798 # then sentence ends
beq_else.99797:
	lw %f0 %sp 88 #1158
	sw %ra %sp 100 #1158 call dir
	addi %sp %sp 104 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -104 #1158
	lw %ra %sp 100 #1158
	lw %a0 %sp 96 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 100 #1158 call dir
	addi %sp %sp 104 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -104 #1158
	lw %ra %sp 100 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99799 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99800 # then sentence ends
beq_else.99799:
	lw %f0 %sp 80 #1159
	sw %ra %sp 100 #1159 call dir
	addi %sp %sp 104 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -104 #1159
	lw %ra %sp 100 #1159
	lw %a0 %sp 96 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 100 #1159 call dir
	addi %sp %sp 104 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -104 #1159
	lw %ra %sp 100 #1159
beq_cont.99800:
beq_cont.99798:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99801 # nontail if
	lw %a0 %sp 96 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99803 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99804 # then sentence ends
beq_else.99803:
	addi %a0 %zero 0 #1156
beq_cont.99804:
	jal %zero beq_cont.99802 # then sentence ends
beq_else.99801:
	lw %a0 %sp 96 #258
	lw %a0 %a0 24 #258
beq_cont.99802:
	jal %zero beq_cont.99796 # then sentence ends
beq_else.99795:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.99805 # nontail if
	lw %a3 %a0 16 #306
	lw %f6 %a3 0 #186
	fmul %f3 %f6 %f3 #186
	lw %f6 %a3 4 #186
	fmul %f4 %f6 %f4 #186
	fadd %f3 %f3 %f4 #186
	lw %f4 %a3 8 #186
	fmul %f4 %f4 %f5 #186
	fadd %f3 %f3 %f4 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 100 #1168
	fadd %f0 %f3 %fzero
	sw %ra %sp 108 #1168 call dir
	addi %sp %sp 112 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -112 #1168
	lw %ra %sp 108 #1168
	lw %a1 %sp 100 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99807 # nontail if
	jal %zero beq_cont.99808 # then sentence ends
beq_else.99807:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99809 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99810 # then sentence ends
beq_else.99809:
	addi %a0 %zero 0 #105
beq_cont.99810:
beq_cont.99808:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99811 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99812 # then sentence ends
beq_else.99811:
	addi %a0 %zero 0 #1168
beq_cont.99812:
	jal %zero beq_cont.99806 # then sentence ends
beq_else.99805:
	sw %f3 %sp 104 #822
	sw %f5 %sp 80 #822
	sw %f4 %sp 88 #822
	sw %a0 %sp 96 #822
	fadd %f0 %f3 %fzero
	sw %ra %sp 116 #822 call dir
	addi %sp %sp 120 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -120 #822
	lw %ra %sp 116 #822
	lw %a0 %sp 96 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 88 #822
	sw %f0 %sp 112 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 124 #822 call dir
	addi %sp %sp 128 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -128 #822
	lw %ra %sp 124 #822
	lw %a0 %sp 96 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 112 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 80 #822
	sw %f0 %sp 120 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #822 call dir
	addi %sp %sp 136 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -136 #822
	lw %ra %sp 132 #822
	lw %a0 %sp 96 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 120 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99813 # nontail if
	jal %zero beq_cont.99814 # then sentence ends
beq_else.99813:
	lw %f1 %sp 80 #828
	lw %f2 %sp 88 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 104 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99814:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99815 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99816 # then sentence ends
beq_else.99815:
beq_cont.99816:
	lw %a0 %a0 24 #258
	sw %a0 %sp 128 #1175
	sw %ra %sp 132 #1175 call dir
	addi %sp %sp 136 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -136 #1175
	lw %ra %sp 132 #1175
	lw %a1 %sp 128 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99817 # nontail if
	jal %zero beq_cont.99818 # then sentence ends
beq_else.99817:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99819 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99820 # then sentence ends
beq_else.99819:
	addi %a0 %zero 0 #105
beq_cont.99820:
beq_cont.99818:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99821 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99822 # then sentence ends
beq_else.99821:
	addi %a0 %zero 0 #1175
beq_cont.99822:
beq_cont.99806:
beq_cont.99796:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99823 # nontail if
	lw %a1 %sp 32 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99825 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99826 # then sentence ends
beq_else.99825:
	slli %a0 %a0 2 #20
	lw %a2 %sp 36 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 72 #1198
	lw %f1 %sp 64 #1198
	lw %f2 %sp 56 #1198
	sw %ra %sp 132 #1198 call dir
	addi %sp %sp 136 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -136 #1198
	lw %ra %sp 132 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99827 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 72 #1201
	lw %f1 %sp 64 #1201
	lw %f2 %sp 56 #1201
	lw %a1 %sp 32 #1201
	lw %a11 %sp 20 #1201
	sw %ra %sp 132 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 136 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -136 #1201
	lw %ra %sp 132 #1201
	jal %zero beq_cont.99828 # then sentence ends
beq_else.99827:
	addi %a0 %zero 0 #1198
beq_cont.99828:
beq_cont.99826:
	jal %zero beq_cont.99824 # then sentence ends
beq_else.99823:
	addi %a0 %zero 0 #1198
beq_cont.99824:
beq_cont.99794:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99829 # nontail if
	addi %a0 %zero 1 #1228
	lw %a1 %sp 32 #1228
	lw %a11 %sp 8 #1228
	sw %ra %sp 132 #1228 call cls
	lw %a10 %a11 0 #1228
	addi %sp %sp 136 #1228	
	jalr %ra %a10 0 #1228
	addi %sp %sp -136 #1228
	lw %ra %sp 132 #1228
	jal %zero beq_cont.99830 # then sentence ends
beq_else.99829:
	addi %a0 %zero 1 #1226
beq_cont.99830:
beq_cont.99790:
beq_cont.99786:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99831
	lw %a0 %sp 16 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99832
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.99832:
	slli %a1 %a1 2 #31
	lw %a3 %sp 4 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 8 #1247
	sw %a0 %sp 132 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99833
	lw %a0 %sp 132 #1251
	addi %a0 %a0 1 #1251
	lw %a1 %sp 12 #1251
	lw %a11 %sp 0 #1251
	lw %a10 %a11 0 #1251
	jalr %zero %a10 0 #1251
beq_else.99833:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.99831:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
shadow_check_one_or_matrix.2518:
	lw %a2 %a11 48 #1256
	lw %a3 %a11 44 #1256
	lw %a4 %a11 40 #1256
	lw %a5 %a11 36 #1256
	lw %a6 %a11 32 #1256
	lw %a7 %a11 28 #1256
	lw %a8 %a11 24 #1256
	lw %a9 %a11 20 #1256
	lw %a10 %a11 16 #1256
	sw %a10 %sp 0 #1256
	lw %a10 %a11 12 #1256
	sw %a5 %sp 4 #1256
	lw %a5 %a11 8 #1256
	sw %a11 %sp 8 #1256
	lw %a11 %a11 4 #1256
	sw %a0 %sp 12 #1257
	slli %a0 %a0 2 #1257
	add %a12 %a1 %a0 #1257
	lw %a0 %a12 0 #1257
	sw %a1 %sp 16 #1258
	lw %a1 %a0 0 #1258
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99834
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.99834:
	sw %a8 %sp 20 #1259
	sw %a11 %sp 24 #1259
	sw %a0 %sp 28 #1259
	sw %a7 %sp 32 #1259
	sw %a6 %sp 36 #1259
	sw %a10 %sp 40 #1259
	addi %a12 %zero 99
	bne %a1 %a12 beq_else.99835 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.99836 # then sentence ends
beq_else.99835:
	slli %a7 %a1 2 #20
	add %a12 %a9 %a7 #20
	lw %a7 %a12 0 #20
	lw %f0 %a10 0 #964
	lw %a9 %a7 20 #316
	lw %f1 %a9 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a10 4 #964
	lw %a9 %a7 20 #326
	lw %f2 %a9 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a10 8 #964
	lw %a9 %a7 20 #336
	lw %f3 %a9 8 #341
	fsub %f2 %f2 %f3 #966
	slli %a1 %a1 2 #968
	add %a12 %a5 %a1 #968
	lw %a1 %a12 0 #968
	lw %a5 %a7 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.99837 # nontail if
	add %a0 %a7 %zero
	add %a11 %a4 %zero
	add %a10 %a2 %zero
	add %a2 %a1 %zero
	add %a1 %a10 %zero
	sw %ra %sp 44 #971 call cls
	lw %a10 %a11 0 #971
	addi %sp %sp 48 #971	
	jalr %ra %a10 0 #971
	addi %sp %sp -48 #971
	lw %ra %sp 44 #971
	jal %zero beq_cont.99838 # then sentence ends
beq_else.99837:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.99839 # nontail if
	lw %f3 %a1 0 #934
	sw %f2 %sp 48 #934
	sw %f1 %sp 56 #934
	sw %f0 %sp 64 #934
	sw %a1 %sp 72 #934
	fadd %f0 %f3 %fzero
	sw %ra %sp 76 #934 call dir
	addi %sp %sp 80 #934	
	jal %ra min_caml_fisneg #934
	addi %sp %sp -80 #934
	lw %ra %sp 76 #934
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99842 # nontail if
	addi %a0 %zero 0 #934
	jal %zero beq_cont.99843 # then sentence ends
beq_else.99842:
	lw %a0 %sp 72 #934
	lw %f0 %a0 4 #934
	lw %f1 %sp 64 #936
	fmul %f0 %f0 %f1 #936
	lw %f1 %a0 8 #934
	lw %f2 %sp 56 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a0 12 #934
	lw %f2 %sp 48 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a0 %sp 36 #935
	sw %f0 %a0 0 #935
	addi %a0 %zero 1 #937
beq_cont.99843:
	jal %zero beq_cont.99840 # then sentence ends
beq_else.99839:
	add %a0 %a7 %zero
	add %a11 %a3 %zero
	sw %ra %sp 76 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 80 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -80 #975
	lw %ra %sp 76 #975
beq_cont.99840:
beq_cont.99838:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99844 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99845 # then sentence ends
beq_else.99844:
	lw %a0 %sp 36 #37
	lw %f0 %a0 0 #37
	li %f1 l.91269 #1270
	sw %ra %sp 76 #1270 call dir
	addi %sp %sp 80 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -80 #1270
	lw %ra %sp 76 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99846 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99847 # then sentence ends
beq_else.99846:
	lw %a0 %sp 28 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99848 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.99849 # then sentence ends
beq_else.99848:
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
	bne %a0 %a12 beq_else.99850 # nontail if
	addi %a0 %zero 2 #1251
	lw %a1 %sp 28 #1251
	lw %a11 %sp 32 #1251
	sw %ra %sp 76 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 80 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -80 #1251
	lw %ra %sp 76 #1251
	jal %zero beq_cont.99851 # then sentence ends
beq_else.99850:
	addi %a0 %zero 1 #1249
beq_cont.99851:
beq_cont.99849:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99852 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99853 # then sentence ends
beq_else.99852:
	addi %a0 %zero 1 #1272
beq_cont.99853:
beq_cont.99847:
beq_cont.99845:
beq_cont.99836:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99854
	lw %a0 %sp 12 #1282
	addi %a0 %a0 1 #1282
	slli %a1 %a0 2 #1257
	lw %a2 %sp 16 #1257
	add %a12 %a2 %a1 #1257
	lw %a1 %a12 0 #1257
	lw %a3 %a1 0 #1258
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.99855
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.99855:
	sw %a1 %sp 76 #1259
	sw %a0 %sp 80 #1259
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.99856 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.99857 # then sentence ends
beq_else.99856:
	lw %a4 %sp 0 #1266
	lw %a5 %sp 40 #1266
	lw %a11 %sp 4 #1266
	add %a2 %a5 %zero
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 88 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -88 #1266
	lw %ra %sp 84 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99858 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99859 # then sentence ends
beq_else.99858:
	lw %a0 %sp 36 #37
	lw %f0 %a0 0 #37
	li %f1 l.91269 #1270
	sw %ra %sp 84 #1270 call dir
	addi %sp %sp 88 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -88 #1270
	lw %ra %sp 84 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99860 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99861 # then sentence ends
beq_else.99860:
	addi %a0 %zero 1 #1271
	lw %a1 %sp 76 #1271
	lw %a11 %sp 32 #1271
	sw %ra %sp 84 #1271 call cls
	lw %a10 %a11 0 #1271
	addi %sp %sp 88 #1271	
	jalr %ra %a10 0 #1271
	addi %sp %sp -88 #1271
	lw %ra %sp 84 #1271
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99862 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99863 # then sentence ends
beq_else.99862:
	addi %a0 %zero 1 #1272
beq_cont.99863:
beq_cont.99861:
beq_cont.99859:
beq_cont.99857:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99864
	lw %a0 %sp 80 #1282
	addi %a0 %a0 1 #1282
	lw %a1 %sp 16 #1282
	lw %a11 %sp 8 #1282
	lw %a10 %a11 0 #1282
	jalr %zero %a10 0 #1282
beq_else.99864:
	addi %a0 %zero 1 #1277
	lw %a1 %sp 76 #1277
	lw %a11 %sp 32 #1277
	sw %ra %sp 84 #1277 call cls
	lw %a10 %a11 0 #1277
	addi %sp %sp 88 #1277	
	jalr %ra %a10 0 #1277
	addi %sp %sp -88 #1277
	lw %ra %sp 84 #1277
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99865
	lw %a0 %sp 80 #1280
	addi %a0 %a0 1 #1280
	lw %a1 %sp 16 #1280
	lw %a11 %sp 8 #1280
	lw %a10 %a11 0 #1280
	jalr %zero %a10 0 #1280
beq_else.99865:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
beq_else.99854:
	lw %a0 %sp 28 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99866 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.99867 # then sentence ends
beq_else.99866:
	slli %a1 %a1 2 #31
	lw %a2 %sp 24 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1247
	lw %a11 %sp 20 #1247
	add %a0 %a2 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99868 # nontail if
	addi %a0 %zero 2 #1251
	lw %a1 %sp 28 #1251
	lw %a11 %sp 32 #1251
	sw %ra %sp 84 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 88 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -88 #1251
	lw %ra %sp 84 #1251
	jal %zero beq_cont.99869 # then sentence ends
beq_else.99868:
	addi %a0 %zero 1 #1249
beq_cont.99869:
beq_cont.99867:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99870
	lw %a0 %sp 12 #1280
	addi %a0 %a0 1 #1280
	slli %a1 %a0 2 #1257
	lw %a2 %sp 16 #1257
	add %a12 %a2 %a1 #1257
	lw %a1 %a12 0 #1257
	lw %a3 %a1 0 #1258
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.99871
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.99871:
	sw %a1 %sp 84 #1259
	sw %a0 %sp 88 #1259
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.99872 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.99873 # then sentence ends
beq_else.99872:
	lw %a4 %sp 0 #1266
	lw %a5 %sp 40 #1266
	lw %a11 %sp 4 #1266
	add %a2 %a5 %zero
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 96 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -96 #1266
	lw %ra %sp 92 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99874 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99875 # then sentence ends
beq_else.99874:
	lw %a0 %sp 36 #37
	lw %f0 %a0 0 #37
	li %f1 l.91269 #1270
	sw %ra %sp 92 #1270 call dir
	addi %sp %sp 96 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -96 #1270
	lw %ra %sp 92 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99876 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99877 # then sentence ends
beq_else.99876:
	addi %a0 %zero 1 #1271
	lw %a1 %sp 84 #1271
	lw %a11 %sp 32 #1271
	sw %ra %sp 92 #1271 call cls
	lw %a10 %a11 0 #1271
	addi %sp %sp 96 #1271	
	jalr %ra %a10 0 #1271
	addi %sp %sp -96 #1271
	lw %ra %sp 92 #1271
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99878 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.99879 # then sentence ends
beq_else.99878:
	addi %a0 %zero 1 #1272
beq_cont.99879:
beq_cont.99877:
beq_cont.99875:
beq_cont.99873:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99880
	lw %a0 %sp 88 #1282
	addi %a0 %a0 1 #1282
	lw %a1 %sp 16 #1282
	lw %a11 %sp 8 #1282
	lw %a10 %a11 0 #1282
	jalr %zero %a10 0 #1282
beq_else.99880:
	addi %a0 %zero 1 #1277
	lw %a1 %sp 84 #1277
	lw %a11 %sp 32 #1277
	sw %ra %sp 92 #1277 call cls
	lw %a10 %a11 0 #1277
	addi %sp %sp 96 #1277	
	jalr %ra %a10 0 #1277
	addi %sp %sp -96 #1277
	lw %ra %sp 92 #1277
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99881
	lw %a0 %sp 88 #1280
	addi %a0 %a0 1 #1280
	lw %a1 %sp 16 #1280
	lw %a11 %sp 8 #1280
	lw %a10 %a11 0 #1280
	jalr %zero %a10 0 #1280
beq_else.99881:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
beq_else.99870:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
solve_each_element.2521:
	lw %a3 %a11 44 #1290
	lw %a4 %a11 40 #1290
	lw %a5 %a11 36 #1290
	lw %a6 %a11 32 #1290
	lw %a7 %a11 28 #1290
	lw %a8 %a11 24 #1290
	lw %a9 %a11 20 #1290
	lw %a10 %a11 16 #1290
	sw %a10 %sp 0 #1290
	lw %a10 %a11 12 #1290
	sw %a10 %sp 4 #1290
	lw %a10 %a11 8 #1290
	sw %a10 %sp 8 #1290
	lw %a10 %a11 4 #1290
	sw %a10 %sp 12 #1291
	slli %a10 %a0 2 #1291
	add %a12 %a1 %a10 #1291
	lw %a10 %a12 0 #1291
	addi %a12 %zero -1
	bne %a10 %a12 beq_else.99882
	jalr %zero %ra 0 #1292
beq_else.99882:
	sw %a3 %sp 16 #20
	slli %a3 %a10 2 #20
	add %a12 %a9 %a3 #20
	lw %a3 %a12 0 #20
	lw %f0 %a4 0 #886
	sw %a11 %sp 20 #316
	lw %a11 %a3 20 #316
	lw %f1 %a11 0 #321
	fsub %f0 %f0 %f1 #886
	lw %f1 %a4 4 #886
	lw %a11 %a3 20 #326
	lw %f2 %a11 4 #331
	fsub %f1 %f1 %f2 #887
	lw %f2 %a4 8 #886
	lw %a11 %a3 20 #336
	lw %f3 %a11 8 #341
	fsub %f2 %f2 %f3 #888
	lw %a11 %a3 4 #238
	sw %a7 %sp 24 #868
	sw %a4 %sp 28 #868
	sw %a2 %sp 32 #868
	sw %a8 %sp 36 #868
	sw %a1 %sp 40 #868
	sw %a0 %sp 44 #868
	sw %a9 %sp 48 #868
	sw %a10 %sp 52 #868
	addi %a12 %zero 1
	bne %a11 %a12 beq_else.99884 # nontail if
	add %a1 %a2 %zero
	add %a0 %a3 %zero
	add %a11 %a6 %zero
	sw %ra %sp 60 #891 call cls
	lw %a10 %a11 0 #891
	addi %sp %sp 64 #891	
	jalr %ra %a10 0 #891
	addi %sp %sp -64 #891
	lw %ra %sp 60 #891
	jal %zero beq_cont.99885 # then sentence ends
beq_else.99884:
	addi %a12 %zero 2
	bne %a11 %a12 beq_else.99886 # nontail if
	lw %a3 %a3 16 #306
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
	sw %f3 %sp 56 #811
	sw %f2 %sp 64 #811
	sw %f1 %sp 72 #811
	sw %f0 %sp 80 #811
	sw %a3 %sp 88 #811
	fadd %f0 %f3 %fzero
	sw %ra %sp 92 #811 call dir
	addi %sp %sp 96 #811	
	jal %ra min_caml_fispos #811
	addi %sp %sp -96 #811
	lw %ra %sp 92 #811
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99888 # nontail if
	addi %a0 %zero 0 #811
	jal %zero beq_cont.99889 # then sentence ends
beq_else.99888:
	lw %a0 %sp 88 #186
	lw %f0 %a0 0 #186
	lw %f1 %sp 80 #186
	fmul %f0 %f0 %f1 #186
	lw %f1 %a0 4 #186
	lw %f2 %sp 72 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a0 8 #186
	lw %f2 %sp 64 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	sw %ra %sp 92 #812 call dir
	addi %sp %sp 96 #812	
	jal %ra min_caml_fneg #812
	addi %sp %sp -96 #812
	lw %ra %sp 92 #812
	lw %f1 %sp 56 #812
	fdiv %f0 %f0 %f1 #812
	lw %a0 %sp 24 #812
	sw %f0 %a0 0 #812
	addi %a0 %zero 1 #813
beq_cont.99889:
	jal %zero beq_cont.99887 # then sentence ends
beq_else.99886:
	add %a1 %a2 %zero
	add %a0 %a3 %zero
	add %a11 %a5 %zero
	sw %ra %sp 92 #893 call cls
	lw %a10 %a11 0 #893
	addi %sp %sp 96 #893	
	jalr %ra %a10 0 #893
	addi %sp %sp -96 #893
	lw %ra %sp 92 #893
beq_cont.99887:
beq_cont.99885:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99890
	lw %a0 %sp 52 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 48 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99891
	jalr %zero %ra 0 #1325
beq_else.99891:
	lw %a0 %sp 44 #1324
	addi %a0 %a0 1 #1324
	slli %a2 %a0 2 #1291
	lw %a3 %sp 40 #1291
	add %a12 %a3 %a2 #1291
	lw %a2 %a12 0 #1291
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.99893
	jalr %zero %ra 0 #1292
beq_else.99893:
	lw %a4 %sp 32 #1294
	lw %a5 %sp 28 #1294
	lw %a11 %sp 36 #1294
	sw %a0 %sp 92 #1294
	sw %a2 %sp 96 #1294
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	add %a2 %a5 %zero
	sw %ra %sp 100 #1294 call cls
	lw %a10 %a11 0 #1294
	addi %sp %sp 104 #1294	
	jalr %ra %a10 0 #1294
	addi %sp %sp -104 #1294
	lw %ra %sp 100 #1294
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99895
	lw %a0 %sp 96 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 48 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99896
	jalr %zero %ra 0 #1325
beq_else.99896:
	lw %a0 %sp 92 #1324
	addi %a0 %a0 1 #1324
	lw %a1 %sp 40 #1324
	lw %a2 %sp 32 #1324
	lw %a11 %sp 20 #1324
	lw %a10 %a11 0 #1324
	jalr %zero %a10 0 #1324
beq_else.99895:
	lw %a1 %sp 24 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1301
	sw %a0 %sp 100 #1301
	sw %f1 %sp 104 #1301
	sw %ra %sp 116 #1301 call dir
	addi %sp %sp 120 #1301	
	jal %ra min_caml_fless #1301
	addi %sp %sp -120 #1301
	lw %ra %sp 116 #1301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99898 # nontail if
	jal %zero beq_cont.99899 # then sentence ends
beq_else.99898:
	lw %a0 %sp 16 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 104 #1302
	sw %ra %sp 116 #1302 call dir
	addi %sp %sp 120 #1302	
	jal %ra min_caml_fless #1302
	addi %sp %sp -120 #1302
	lw %ra %sp 116 #1302
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99900 # nontail if
	jal %zero beq_cont.99901 # then sentence ends
beq_else.99900:
	li %f0 l.91125 #1304
	lw %f1 %sp 104 #1304
	fadd %f0 %f1 %f0 #1304
	lw %a2 %sp 32 #783
	lw %f1 %a2 0 #783
	fmul %f1 %f1 %f0 #1305
	lw %a0 %sp 28 #64
	lw %f2 %a0 0 #64
	fadd %f1 %f1 %f2 #1305
	lw %f2 %a2 4 #783
	fmul %f2 %f2 %f0 #1306
	lw %f3 %a0 4 #64
	fadd %f2 %f2 %f3 #1306
	lw %f3 %a2 8 #783
	fmul %f3 %f3 %f0 #1307
	lw %f4 %a0 8 #64
	fadd %f3 %f3 %f4 #1307
	lw %a1 %sp 40 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 112 #1195
	sw %f2 %sp 120 #1195
	sw %f1 %sp 128 #1195
	sw %f0 %sp 136 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99902 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99903 # then sentence ends
beq_else.99902:
	slli %a0 %a0 2 #20
	lw %a3 %sp 48 #20
	add %a12 %a3 %a0 #20
	lw %a0 %a12 0 #20
	lw %a4 %a0 20 #316
	lw %f4 %a4 0 #321
	fsub %f4 %f1 %f4 #1180
	lw %a4 %a0 20 #326
	lw %f5 %a4 4 #331
	fsub %f5 %f2 %f5 #1181
	lw %a4 %a0 20 #336
	lw %f6 %a4 8 #341
	fsub %f6 %f3 %f6 #1182
	lw %a4 %a0 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.99904 # nontail if
	sw %f6 %sp 144 #1157
	sw %f5 %sp 152 #1157
	sw %a0 %sp 160 #1157
	fadd %f0 %f4 %fzero
	sw %ra %sp 164 #1157 call dir
	addi %sp %sp 168 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -168 #1157
	lw %ra %sp 164 #1157
	lw %a0 %sp 160 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 164 #1157 call dir
	addi %sp %sp 168 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -168 #1157
	lw %ra %sp 164 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99906 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99907 # then sentence ends
beq_else.99906:
	lw %f0 %sp 152 #1158
	sw %ra %sp 164 #1158 call dir
	addi %sp %sp 168 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -168 #1158
	lw %ra %sp 164 #1158
	lw %a0 %sp 160 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 164 #1158 call dir
	addi %sp %sp 168 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -168 #1158
	lw %ra %sp 164 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99908 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99909 # then sentence ends
beq_else.99908:
	lw %f0 %sp 144 #1159
	sw %ra %sp 164 #1159 call dir
	addi %sp %sp 168 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -168 #1159
	lw %ra %sp 164 #1159
	lw %a0 %sp 160 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 164 #1159 call dir
	addi %sp %sp 168 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -168 #1159
	lw %ra %sp 164 #1159
beq_cont.99909:
beq_cont.99907:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99910 # nontail if
	lw %a0 %sp 160 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99912 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99913 # then sentence ends
beq_else.99912:
	addi %a0 %zero 0 #1156
beq_cont.99913:
	jal %zero beq_cont.99911 # then sentence ends
beq_else.99910:
	lw %a0 %sp 160 #258
	lw %a0 %a0 24 #258
beq_cont.99911:
	jal %zero beq_cont.99905 # then sentence ends
beq_else.99904:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.99914 # nontail if
	lw %a4 %a0 16 #306
	lw %f7 %a4 0 #186
	fmul %f4 %f7 %f4 #186
	lw %f7 %a4 4 #186
	fmul %f5 %f7 %f5 #186
	fadd %f4 %f4 %f5 #186
	lw %f5 %a4 8 #186
	fmul %f5 %f5 %f6 #186
	fadd %f4 %f4 %f5 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 164 #1168
	fadd %f0 %f4 %fzero
	sw %ra %sp 172 #1168 call dir
	addi %sp %sp 176 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -176 #1168
	lw %ra %sp 172 #1168
	lw %a1 %sp 164 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99916 # nontail if
	jal %zero beq_cont.99917 # then sentence ends
beq_else.99916:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99918 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99919 # then sentence ends
beq_else.99918:
	addi %a0 %zero 0 #105
beq_cont.99919:
beq_cont.99917:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99920 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99921 # then sentence ends
beq_else.99920:
	addi %a0 %zero 0 #1168
beq_cont.99921:
	jal %zero beq_cont.99915 # then sentence ends
beq_else.99914:
	sw %f4 %sp 168 #822
	sw %f6 %sp 144 #822
	sw %f5 %sp 152 #822
	sw %a0 %sp 160 #822
	fadd %f0 %f4 %fzero
	sw %ra %sp 180 #822 call dir
	addi %sp %sp 184 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -184 #822
	lw %ra %sp 180 #822
	lw %a0 %sp 160 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 152 #822
	sw %f0 %sp 176 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 188 #822 call dir
	addi %sp %sp 192 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -192 #822
	lw %ra %sp 188 #822
	lw %a0 %sp 160 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 176 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 144 #822
	sw %f0 %sp 184 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 196 #822 call dir
	addi %sp %sp 200 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -200 #822
	lw %ra %sp 196 #822
	lw %a0 %sp 160 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 184 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99922 # nontail if
	jal %zero beq_cont.99923 # then sentence ends
beq_else.99922:
	lw %f1 %sp 144 #828
	lw %f2 %sp 152 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 168 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99923:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99924 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99925 # then sentence ends
beq_else.99924:
beq_cont.99925:
	lw %a0 %a0 24 #258
	sw %a0 %sp 192 #1175
	sw %ra %sp 196 #1175 call dir
	addi %sp %sp 200 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -200 #1175
	lw %ra %sp 196 #1175
	lw %a1 %sp 192 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99926 # nontail if
	jal %zero beq_cont.99927 # then sentence ends
beq_else.99926:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99928 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99929 # then sentence ends
beq_else.99928:
	addi %a0 %zero 0 #105
beq_cont.99929:
beq_cont.99927:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99930 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99931 # then sentence ends
beq_else.99930:
	addi %a0 %zero 0 #1175
beq_cont.99931:
beq_cont.99915:
beq_cont.99905:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99932 # nontail if
	lw %a1 %sp 40 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99934 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99935 # then sentence ends
beq_else.99934:
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 128 #1198
	lw %f1 %sp 120 #1198
	lw %f2 %sp 112 #1198
	sw %ra %sp 196 #1198 call dir
	addi %sp %sp 200 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -200 #1198
	lw %ra %sp 196 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99936 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 128 #1201
	lw %f1 %sp 120 #1201
	lw %f2 %sp 112 #1201
	lw %a1 %sp 40 #1201
	lw %a11 %sp 12 #1201
	sw %ra %sp 196 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 200 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -200 #1201
	lw %ra %sp 196 #1201
	jal %zero beq_cont.99937 # then sentence ends
beq_else.99936:
	addi %a0 %zero 0 #1198
beq_cont.99937:
beq_cont.99935:
	jal %zero beq_cont.99933 # then sentence ends
beq_else.99932:
	addi %a0 %zero 0 #1198
beq_cont.99933:
beq_cont.99903:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99938 # nontail if
	jal %zero beq_cont.99939 # then sentence ends
beq_else.99938:
	lw %a0 %sp 16 #1310
	lw %f0 %sp 136 #1310
	sw %f0 %a0 0 #1310
	lw %a0 %sp 4 #133
	lw %f0 %sp 128 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 120 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 112 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 8 #1312
	lw %a1 %sp 96 #1312
	sw %a1 %a0 0 #1312
	lw %a0 %sp 0 #1313
	lw %a1 %sp 100 #1313
	sw %a1 %a0 0 #1313
beq_cont.99939:
beq_cont.99901:
beq_cont.99899:
	lw %a0 %sp 92 #1319
	addi %a0 %a0 1 #1319
	lw %a1 %sp 40 #1319
	lw %a2 %sp 32 #1319
	lw %a11 %sp 20 #1319
	lw %a10 %a11 0 #1319
	jalr %zero %a10 0 #1319
beq_else.99890:
	lw %a1 %sp 24 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1301
	sw %a0 %sp 196 #1301
	sw %f1 %sp 200 #1301
	sw %ra %sp 212 #1301 call dir
	addi %sp %sp 216 #1301	
	jal %ra min_caml_fless #1301
	addi %sp %sp -216 #1301
	lw %ra %sp 212 #1301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99940 # nontail if
	jal %zero beq_cont.99941 # then sentence ends
beq_else.99940:
	lw %a0 %sp 16 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 200 #1302
	sw %ra %sp 212 #1302 call dir
	addi %sp %sp 216 #1302	
	jal %ra min_caml_fless #1302
	addi %sp %sp -216 #1302
	lw %ra %sp 212 #1302
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99942 # nontail if
	jal %zero beq_cont.99943 # then sentence ends
beq_else.99942:
	li %f0 l.91125 #1304
	lw %f1 %sp 200 #1304
	fadd %f0 %f1 %f0 #1304
	lw %a1 %sp 32 #783
	lw %f1 %a1 0 #783
	fmul %f1 %f1 %f0 #1305
	lw %a2 %sp 28 #64
	lw %f2 %a2 0 #64
	fadd %f1 %f1 %f2 #1305
	lw %f2 %a1 4 #783
	fmul %f2 %f2 %f0 #1306
	lw %f3 %a2 4 #64
	fadd %f2 %f2 %f3 #1306
	lw %f3 %a1 8 #783
	fmul %f3 %f3 %f0 #1307
	lw %f4 %a2 8 #64
	fadd %f3 %f3 %f4 #1307
	lw %a0 %sp 40 #1194
	lw %a3 %a0 0 #1194
	sw %f3 %sp 208 #1195
	sw %f2 %sp 216 #1195
	sw %f1 %sp 224 #1195
	sw %f0 %sp 232 #1195
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.99944 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99945 # then sentence ends
beq_else.99944:
	slli %a3 %a3 2 #20
	lw %a4 %sp 48 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	add %a0 %a3 %zero
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 244 #1198 call dir
	addi %sp %sp 248 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -248 #1198
	lw %ra %sp 244 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99946 # nontail if
	lw %a0 %sp 40 #1194
	lw %a1 %a0 4 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99948 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99949 # then sentence ends
beq_else.99948:
	slli %a1 %a1 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a3 %a1 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 224 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a1 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 216 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a1 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 208 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a1 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.99950 # nontail if
	sw %f4 %sp 240 #1157
	sw %f2 %sp 248 #1157
	sw %a1 %sp 256 #1157
	sw %ra %sp 260 #1157 call dir
	addi %sp %sp 264 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -264 #1157
	lw %ra %sp 260 #1157
	lw %a0 %sp 256 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 260 #1157 call dir
	addi %sp %sp 264 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -264 #1157
	lw %ra %sp 260 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99952 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99953 # then sentence ends
beq_else.99952:
	lw %f0 %sp 248 #1158
	sw %ra %sp 260 #1158 call dir
	addi %sp %sp 264 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -264 #1158
	lw %ra %sp 260 #1158
	lw %a0 %sp 256 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 260 #1158 call dir
	addi %sp %sp 264 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -264 #1158
	lw %ra %sp 260 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99954 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.99955 # then sentence ends
beq_else.99954:
	lw %f0 %sp 240 #1159
	sw %ra %sp 260 #1159 call dir
	addi %sp %sp 264 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -264 #1159
	lw %ra %sp 260 #1159
	lw %a0 %sp 256 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 260 #1159 call dir
	addi %sp %sp 264 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -264 #1159
	lw %ra %sp 260 #1159
beq_cont.99955:
beq_cont.99953:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99956 # nontail if
	lw %a0 %sp 256 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99958 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.99959 # then sentence ends
beq_else.99958:
	addi %a0 %zero 0 #1156
beq_cont.99959:
	jal %zero beq_cont.99957 # then sentence ends
beq_else.99956:
	lw %a0 %sp 256 #258
	lw %a0 %a0 24 #258
beq_cont.99957:
	jal %zero beq_cont.99951 # then sentence ends
beq_else.99950:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.99960 # nontail if
	lw %a3 %a1 16 #306
	lw %f6 %a3 0 #186
	fmul %f0 %f6 %f0 #186
	lw %f6 %a3 4 #186
	fmul %f2 %f6 %f2 #186
	fadd %f0 %f0 %f2 #186
	lw %f2 %a3 8 #186
	fmul %f2 %f2 %f4 #186
	fadd %f0 %f0 %f2 #186
	lw %a1 %a1 24 #258
	sw %a1 %sp 260 #1168
	sw %ra %sp 268 #1168 call dir
	addi %sp %sp 272 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -272 #1168
	lw %ra %sp 268 #1168
	lw %a1 %sp 260 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99962 # nontail if
	jal %zero beq_cont.99963 # then sentence ends
beq_else.99962:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99964 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99965 # then sentence ends
beq_else.99964:
	addi %a0 %zero 0 #105
beq_cont.99965:
beq_cont.99963:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99966 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.99967 # then sentence ends
beq_else.99966:
	addi %a0 %zero 0 #1168
beq_cont.99967:
	jal %zero beq_cont.99961 # then sentence ends
beq_else.99960:
	sw %f0 %sp 264 #822
	sw %f4 %sp 240 #822
	sw %f2 %sp 248 #822
	sw %a1 %sp 256 #822
	sw %ra %sp 276 #822 call dir
	addi %sp %sp 280 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -280 #822
	lw %ra %sp 276 #822
	lw %a0 %sp 256 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 248 #822
	sw %f0 %sp 272 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 284 #822 call dir
	addi %sp %sp 288 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -288 #822
	lw %ra %sp 284 #822
	lw %a0 %sp 256 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 272 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 240 #822
	sw %f0 %sp 280 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 292 #822 call dir
	addi %sp %sp 296 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -296 #822
	lw %ra %sp 292 #822
	lw %a0 %sp 256 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 280 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99968 # nontail if
	jal %zero beq_cont.99969 # then sentence ends
beq_else.99968:
	lw %f1 %sp 240 #828
	lw %f2 %sp 248 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 264 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.99969:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.99970 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.99971 # then sentence ends
beq_else.99970:
beq_cont.99971:
	lw %a0 %a0 24 #258
	sw %a0 %sp 288 #1175
	sw %ra %sp 292 #1175 call dir
	addi %sp %sp 296 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -296 #1175
	lw %ra %sp 292 #1175
	lw %a1 %sp 288 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.99972 # nontail if
	jal %zero beq_cont.99973 # then sentence ends
beq_else.99972:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99974 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.99975 # then sentence ends
beq_else.99974:
	addi %a0 %zero 0 #105
beq_cont.99975:
beq_cont.99973:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99976 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.99977 # then sentence ends
beq_else.99976:
	addi %a0 %zero 0 #1175
beq_cont.99977:
beq_cont.99961:
beq_cont.99951:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99978 # nontail if
	lw %a0 %sp 40 #1194
	lw %a1 %a0 8 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99980 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99981 # then sentence ends
beq_else.99980:
	slli %a1 %a1 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 224 #1198
	lw %f1 %sp 216 #1198
	lw %f2 %sp 208 #1198
	add %a0 %a1 %zero
	sw %ra %sp 292 #1198 call dir
	addi %sp %sp 296 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -296 #1198
	lw %ra %sp 292 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99982 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 224 #1201
	lw %f1 %sp 216 #1201
	lw %f2 %sp 208 #1201
	lw %a1 %sp 40 #1201
	lw %a11 %sp 12 #1201
	sw %ra %sp 292 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 296 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -296 #1201
	lw %ra %sp 292 #1201
	jal %zero beq_cont.99983 # then sentence ends
beq_else.99982:
	addi %a0 %zero 0 #1198
beq_cont.99983:
beq_cont.99981:
	jal %zero beq_cont.99979 # then sentence ends
beq_else.99978:
	addi %a0 %zero 0 #1198
beq_cont.99979:
beq_cont.99949:
	jal %zero beq_cont.99947 # then sentence ends
beq_else.99946:
	addi %a0 %zero 0 #1198
beq_cont.99947:
beq_cont.99945:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99984 # nontail if
	jal %zero beq_cont.99985 # then sentence ends
beq_else.99984:
	lw %a0 %sp 16 #1310
	lw %f0 %sp 232 #1310
	sw %f0 %a0 0 #1310
	lw %a1 %sp 4 #133
	lw %f0 %sp 224 #133
	sw %f0 %a1 0 #133
	lw %f0 %sp 216 #134
	sw %f0 %a1 4 #134
	lw %f0 %sp 208 #135
	sw %f0 %a1 8 #135
	lw %a2 %sp 8 #1312
	lw %a3 %sp 52 #1312
	sw %a3 %a2 0 #1312
	lw %a3 %sp 0 #1313
	lw %a4 %sp 196 #1313
	sw %a4 %a3 0 #1313
beq_cont.99985:
beq_cont.99943:
beq_cont.99941:
	lw %a0 %sp 44 #1319
	addi %a0 %a0 1 #1319
	slli %a1 %a0 2 #1291
	lw %a2 %sp 40 #1291
	add %a12 %a2 %a1 #1291
	lw %a1 %a12 0 #1291
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.99986
	jalr %zero %ra 0 #1292
beq_else.99986:
	lw %a3 %sp 32 #1294
	lw %a4 %sp 28 #1294
	lw %a11 %sp 36 #1294
	sw %a0 %sp 292 #1294
	sw %a1 %sp 296 #1294
	add %a2 %a4 %zero
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 300 #1294 call cls
	lw %a10 %a11 0 #1294
	addi %sp %sp 304 #1294	
	jalr %ra %a10 0 #1294
	addi %sp %sp -304 #1294
	lw %ra %sp 300 #1294
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99988
	lw %a0 %sp 296 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 48 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99989
	jalr %zero %ra 0 #1325
beq_else.99989:
	lw %a0 %sp 292 #1324
	addi %a0 %a0 1 #1324
	lw %a1 %sp 40 #1324
	lw %a2 %sp 32 #1324
	lw %a11 %sp 20 #1324
	lw %a10 %a11 0 #1324
	jalr %zero %a10 0 #1324
beq_else.99988:
	lw %a1 %sp 24 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1301
	sw %a0 %sp 300 #1301
	sw %f1 %sp 304 #1301
	sw %ra %sp 316 #1301 call dir
	addi %sp %sp 320 #1301	
	jal %ra min_caml_fless #1301
	addi %sp %sp -320 #1301
	lw %ra %sp 316 #1301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99991 # nontail if
	jal %zero beq_cont.99992 # then sentence ends
beq_else.99991:
	lw %a0 %sp 16 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 304 #1302
	sw %ra %sp 316 #1302 call dir
	addi %sp %sp 320 #1302	
	jal %ra min_caml_fless #1302
	addi %sp %sp -320 #1302
	lw %ra %sp 316 #1302
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99993 # nontail if
	jal %zero beq_cont.99994 # then sentence ends
beq_else.99993:
	li %f0 l.91125 #1304
	lw %f1 %sp 304 #1304
	fadd %f0 %f1 %f0 #1304
	lw %a2 %sp 32 #783
	lw %f1 %a2 0 #783
	fmul %f1 %f1 %f0 #1305
	lw %a0 %sp 28 #64
	lw %f2 %a0 0 #64
	fadd %f1 %f1 %f2 #1305
	lw %f2 %a2 4 #783
	fmul %f2 %f2 %f0 #1306
	lw %f3 %a0 4 #64
	fadd %f2 %f2 %f3 #1306
	lw %f3 %a2 8 #783
	fmul %f3 %f3 %f0 #1307
	lw %f4 %a0 8 #64
	fadd %f3 %f3 %f4 #1307
	lw %a1 %sp 40 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 312 #1195
	sw %f2 %sp 320 #1195
	sw %f1 %sp 328 #1195
	sw %f0 %sp 336 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.99995 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.99996 # then sentence ends
beq_else.99995:
	slli %a0 %a0 2 #20
	lw %a3 %sp 48 #20
	add %a12 %a3 %a0 #20
	lw %a0 %a12 0 #20
	lw %a4 %a0 20 #316
	lw %f4 %a4 0 #321
	fsub %f4 %f1 %f4 #1180
	lw %a4 %a0 20 #326
	lw %f5 %a4 4 #331
	fsub %f5 %f2 %f5 #1181
	lw %a4 %a0 20 #336
	lw %f6 %a4 8 #341
	fsub %f6 %f3 %f6 #1182
	lw %a4 %a0 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.99997 # nontail if
	sw %f6 %sp 344 #1157
	sw %f5 %sp 352 #1157
	sw %a0 %sp 360 #1157
	fadd %f0 %f4 %fzero
	sw %ra %sp 364 #1157 call dir
	addi %sp %sp 368 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -368 #1157
	lw %ra %sp 364 #1157
	lw %a0 %sp 360 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 364 #1157 call dir
	addi %sp %sp 368 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -368 #1157
	lw %ra %sp 364 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.99999 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100000 # then sentence ends
beq_else.99999:
	lw %f0 %sp 352 #1158
	sw %ra %sp 364 #1158 call dir
	addi %sp %sp 368 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -368 #1158
	lw %ra %sp 364 #1158
	lw %a0 %sp 360 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 364 #1158 call dir
	addi %sp %sp 368 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -368 #1158
	lw %ra %sp 364 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100001 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100002 # then sentence ends
beq_else.100001:
	lw %f0 %sp 344 #1159
	sw %ra %sp 364 #1159 call dir
	addi %sp %sp 368 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -368 #1159
	lw %ra %sp 364 #1159
	lw %a0 %sp 360 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 364 #1159 call dir
	addi %sp %sp 368 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -368 #1159
	lw %ra %sp 364 #1159
beq_cont.100002:
beq_cont.100000:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100003 # nontail if
	lw %a0 %sp 360 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100005 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.100006 # then sentence ends
beq_else.100005:
	addi %a0 %zero 0 #1156
beq_cont.100006:
	jal %zero beq_cont.100004 # then sentence ends
beq_else.100003:
	lw %a0 %sp 360 #258
	lw %a0 %a0 24 #258
beq_cont.100004:
	jal %zero beq_cont.99998 # then sentence ends
beq_else.99997:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.100007 # nontail if
	lw %a4 %a0 16 #306
	lw %f7 %a4 0 #186
	fmul %f4 %f7 %f4 #186
	lw %f7 %a4 4 #186
	fmul %f5 %f7 %f5 #186
	fadd %f4 %f4 %f5 #186
	lw %f5 %a4 8 #186
	fmul %f5 %f5 %f6 #186
	fadd %f4 %f4 %f5 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 364 #1168
	fadd %f0 %f4 %fzero
	sw %ra %sp 372 #1168 call dir
	addi %sp %sp 376 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -376 #1168
	lw %ra %sp 372 #1168
	lw %a1 %sp 364 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100009 # nontail if
	jal %zero beq_cont.100010 # then sentence ends
beq_else.100009:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100011 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100012 # then sentence ends
beq_else.100011:
	addi %a0 %zero 0 #105
beq_cont.100012:
beq_cont.100010:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100013 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.100014 # then sentence ends
beq_else.100013:
	addi %a0 %zero 0 #1168
beq_cont.100014:
	jal %zero beq_cont.100008 # then sentence ends
beq_else.100007:
	sw %f4 %sp 368 #822
	sw %f6 %sp 344 #822
	sw %f5 %sp 352 #822
	sw %a0 %sp 360 #822
	fadd %f0 %f4 %fzero
	sw %ra %sp 380 #822 call dir
	addi %sp %sp 384 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -384 #822
	lw %ra %sp 380 #822
	lw %a0 %sp 360 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 352 #822
	sw %f0 %sp 376 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 388 #822 call dir
	addi %sp %sp 392 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -392 #822
	lw %ra %sp 388 #822
	lw %a0 %sp 360 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 376 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 344 #822
	sw %f0 %sp 384 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 396 #822 call dir
	addi %sp %sp 400 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -400 #822
	lw %ra %sp 396 #822
	lw %a0 %sp 360 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 384 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100015 # nontail if
	jal %zero beq_cont.100016 # then sentence ends
beq_else.100015:
	lw %f1 %sp 344 #828
	lw %f2 %sp 352 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 368 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.100016:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.100017 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.100018 # then sentence ends
beq_else.100017:
beq_cont.100018:
	lw %a0 %a0 24 #258
	sw %a0 %sp 392 #1175
	sw %ra %sp 396 #1175 call dir
	addi %sp %sp 400 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -400 #1175
	lw %ra %sp 396 #1175
	lw %a1 %sp 392 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100019 # nontail if
	jal %zero beq_cont.100020 # then sentence ends
beq_else.100019:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100021 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100022 # then sentence ends
beq_else.100021:
	addi %a0 %zero 0 #105
beq_cont.100022:
beq_cont.100020:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100023 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.100024 # then sentence ends
beq_else.100023:
	addi %a0 %zero 0 #1175
beq_cont.100024:
beq_cont.100008:
beq_cont.99998:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100025 # nontail if
	lw %a1 %sp 40 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100027 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100028 # then sentence ends
beq_else.100027:
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 328 #1198
	lw %f1 %sp 320 #1198
	lw %f2 %sp 312 #1198
	sw %ra %sp 396 #1198 call dir
	addi %sp %sp 400 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -400 #1198
	lw %ra %sp 396 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100029 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 328 #1201
	lw %f1 %sp 320 #1201
	lw %f2 %sp 312 #1201
	lw %a1 %sp 40 #1201
	lw %a11 %sp 12 #1201
	sw %ra %sp 396 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 400 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -400 #1201
	lw %ra %sp 396 #1201
	jal %zero beq_cont.100030 # then sentence ends
beq_else.100029:
	addi %a0 %zero 0 #1198
beq_cont.100030:
beq_cont.100028:
	jal %zero beq_cont.100026 # then sentence ends
beq_else.100025:
	addi %a0 %zero 0 #1198
beq_cont.100026:
beq_cont.99996:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100031 # nontail if
	jal %zero beq_cont.100032 # then sentence ends
beq_else.100031:
	lw %a0 %sp 16 #1310
	lw %f0 %sp 336 #1310
	sw %f0 %a0 0 #1310
	lw %a0 %sp 4 #133
	lw %f0 %sp 328 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 320 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 312 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 8 #1312
	lw %a1 %sp 296 #1312
	sw %a1 %a0 0 #1312
	lw %a0 %sp 0 #1313
	lw %a1 %sp 300 #1313
	sw %a1 %a0 0 #1313
beq_cont.100032:
beq_cont.99994:
beq_cont.99992:
	lw %a0 %sp 292 #1319
	addi %a0 %a0 1 #1319
	lw %a1 %sp 40 #1319
	lw %a2 %sp 32 #1319
	lw %a11 %sp 20 #1319
	lw %a10 %a11 0 #1319
	jalr %zero %a10 0 #1319
solve_one_or_network.2525:
	lw %a3 %a11 44 #1331
	lw %a4 %a11 40 #1331
	lw %a5 %a11 36 #1331
	lw %a6 %a11 32 #1331
	lw %a7 %a11 28 #1331
	lw %a8 %a11 24 #1331
	lw %a9 %a11 20 #1331
	lw %a10 %a11 16 #1331
	sw %a9 %sp 0 #1331
	lw %a9 %a11 12 #1331
	sw %a9 %sp 4 #1331
	lw %a9 %a11 8 #1331
	sw %a11 %sp 8 #1331
	lw %a11 %a11 4 #1331
	sw %a0 %sp 12 #1332
	slli %a0 %a0 2 #1332
	add %a12 %a1 %a0 #1332
	lw %a0 %a12 0 #1332
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100033
	jalr %zero %ra 0 #1337
beq_else.100033:
	slli %a0 %a0 2 #31
	add %a12 %a11 %a0 #31
	lw %a0 %a12 0 #31
	sw %a11 %sp 16 #1291
	lw %a11 %a0 0 #1291
	sw %a2 %sp 20 #1292
	sw %a7 %sp 24 #1292
	sw %a1 %sp 28 #1292
	addi %a12 %zero -1
	bne %a11 %a12 beq_else.100035 # nontail if
	jal %zero beq_cont.100036 # then sentence ends
beq_else.100035:
	sw %a10 %sp 32 #1294
	sw %a9 %sp 36 #1294
	sw %a4 %sp 40 #1294
	sw %a3 %sp 44 #1294
	sw %a5 %sp 48 #1294
	sw %a0 %sp 52 #1294
	sw %a8 %sp 56 #1294
	sw %a11 %sp 60 #1294
	add %a1 %a2 %zero
	add %a0 %a11 %zero
	add %a2 %a4 %zero
	add %a11 %a6 %zero
	sw %ra %sp 68 #1294 call cls
	lw %a10 %a11 0 #1294
	addi %sp %sp 72 #1294	
	jalr %ra %a10 0 #1294
	addi %sp %sp -72 #1294
	lw %ra %sp 68 #1294
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100037 # nontail if
	lw %a0 %sp 60 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 56 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100039 # nontail if
	jal %zero beq_cont.100040 # then sentence ends
beq_else.100039:
	addi %a0 %zero 1 #1324
	lw %a1 %sp 52 #1324
	lw %a2 %sp 20 #1324
	lw %a11 %sp 24 #1324
	sw %ra %sp 68 #1324 call cls
	lw %a10 %a11 0 #1324
	addi %sp %sp 72 #1324	
	jalr %ra %a10 0 #1324
	addi %sp %sp -72 #1324
	lw %ra %sp 68 #1324
beq_cont.100040:
	jal %zero beq_cont.100038 # then sentence ends
beq_else.100037:
	lw %a1 %sp 48 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1301
	sw %a0 %sp 64 #1301
	sw %f1 %sp 72 #1301
	sw %ra %sp 84 #1301 call dir
	addi %sp %sp 88 #1301	
	jal %ra min_caml_fless #1301
	addi %sp %sp -88 #1301
	lw %ra %sp 84 #1301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100042 # nontail if
	jal %zero beq_cont.100043 # then sentence ends
beq_else.100042:
	lw %a0 %sp 44 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 72 #1302
	sw %ra %sp 84 #1302 call dir
	addi %sp %sp 88 #1302	
	jal %ra min_caml_fless #1302
	addi %sp %sp -88 #1302
	lw %ra %sp 84 #1302
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100044 # nontail if
	jal %zero beq_cont.100045 # then sentence ends
beq_else.100044:
	li %f0 l.91125 #1304
	lw %f1 %sp 72 #1304
	fadd %f0 %f1 %f0 #1304
	lw %a2 %sp 20 #783
	lw %f1 %a2 0 #783
	fmul %f1 %f1 %f0 #1305
	lw %a0 %sp 40 #64
	lw %f2 %a0 0 #64
	fadd %f1 %f1 %f2 #1305
	lw %f2 %a2 4 #783
	fmul %f2 %f2 %f0 #1306
	lw %f3 %a0 4 #64
	fadd %f2 %f2 %f3 #1306
	lw %f3 %a2 8 #783
	fmul %f3 %f3 %f0 #1307
	lw %f4 %a0 8 #64
	fadd %f3 %f3 %f4 #1307
	lw %a1 %sp 52 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 80 #1195
	sw %f2 %sp 88 #1195
	sw %f1 %sp 96 #1195
	sw %f0 %sp 104 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100046 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100047 # then sentence ends
beq_else.100046:
	slli %a0 %a0 2 #20
	lw %a3 %sp 56 #20
	add %a12 %a3 %a0 #20
	lw %a0 %a12 0 #20
	lw %a4 %a0 20 #316
	lw %f4 %a4 0 #321
	fsub %f4 %f1 %f4 #1180
	lw %a4 %a0 20 #326
	lw %f5 %a4 4 #331
	fsub %f5 %f2 %f5 #1181
	lw %a4 %a0 20 #336
	lw %f6 %a4 8 #341
	fsub %f6 %f3 %f6 #1182
	lw %a4 %a0 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.100048 # nontail if
	sw %f6 %sp 112 #1157
	sw %f5 %sp 120 #1157
	sw %a0 %sp 128 #1157
	fadd %f0 %f4 %fzero
	sw %ra %sp 132 #1157 call dir
	addi %sp %sp 136 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -136 #1157
	lw %ra %sp 132 #1157
	lw %a0 %sp 128 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 132 #1157 call dir
	addi %sp %sp 136 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -136 #1157
	lw %ra %sp 132 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100050 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100051 # then sentence ends
beq_else.100050:
	lw %f0 %sp 120 #1158
	sw %ra %sp 132 #1158 call dir
	addi %sp %sp 136 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -136 #1158
	lw %ra %sp 132 #1158
	lw %a0 %sp 128 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 132 #1158 call dir
	addi %sp %sp 136 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -136 #1158
	lw %ra %sp 132 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100052 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100053 # then sentence ends
beq_else.100052:
	lw %f0 %sp 112 #1159
	sw %ra %sp 132 #1159 call dir
	addi %sp %sp 136 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -136 #1159
	lw %ra %sp 132 #1159
	lw %a0 %sp 128 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 132 #1159 call dir
	addi %sp %sp 136 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -136 #1159
	lw %ra %sp 132 #1159
beq_cont.100053:
beq_cont.100051:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100054 # nontail if
	lw %a0 %sp 128 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100056 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.100057 # then sentence ends
beq_else.100056:
	addi %a0 %zero 0 #1156
beq_cont.100057:
	jal %zero beq_cont.100055 # then sentence ends
beq_else.100054:
	lw %a0 %sp 128 #258
	lw %a0 %a0 24 #258
beq_cont.100055:
	jal %zero beq_cont.100049 # then sentence ends
beq_else.100048:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.100058 # nontail if
	lw %a4 %a0 16 #306
	lw %f7 %a4 0 #186
	fmul %f4 %f7 %f4 #186
	lw %f7 %a4 4 #186
	fmul %f5 %f7 %f5 #186
	fadd %f4 %f4 %f5 #186
	lw %f5 %a4 8 #186
	fmul %f5 %f5 %f6 #186
	fadd %f4 %f4 %f5 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 132 #1168
	fadd %f0 %f4 %fzero
	sw %ra %sp 140 #1168 call dir
	addi %sp %sp 144 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -144 #1168
	lw %ra %sp 140 #1168
	lw %a1 %sp 132 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100060 # nontail if
	jal %zero beq_cont.100061 # then sentence ends
beq_else.100060:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100062 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100063 # then sentence ends
beq_else.100062:
	addi %a0 %zero 0 #105
beq_cont.100063:
beq_cont.100061:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100064 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.100065 # then sentence ends
beq_else.100064:
	addi %a0 %zero 0 #1168
beq_cont.100065:
	jal %zero beq_cont.100059 # then sentence ends
beq_else.100058:
	sw %f4 %sp 136 #822
	sw %f6 %sp 112 #822
	sw %f5 %sp 120 #822
	sw %a0 %sp 128 #822
	fadd %f0 %f4 %fzero
	sw %ra %sp 148 #822 call dir
	addi %sp %sp 152 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -152 #822
	lw %ra %sp 148 #822
	lw %a0 %sp 128 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 120 #822
	sw %f0 %sp 144 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 156 #822 call dir
	addi %sp %sp 160 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -160 #822
	lw %ra %sp 156 #822
	lw %a0 %sp 128 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 144 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 112 #822
	sw %f0 %sp 152 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 164 #822 call dir
	addi %sp %sp 168 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -168 #822
	lw %ra %sp 164 #822
	lw %a0 %sp 128 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 152 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100066 # nontail if
	jal %zero beq_cont.100067 # then sentence ends
beq_else.100066:
	lw %f1 %sp 112 #828
	lw %f2 %sp 120 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 136 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.100067:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.100068 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.100069 # then sentence ends
beq_else.100068:
beq_cont.100069:
	lw %a0 %a0 24 #258
	sw %a0 %sp 160 #1175
	sw %ra %sp 164 #1175 call dir
	addi %sp %sp 168 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -168 #1175
	lw %ra %sp 164 #1175
	lw %a1 %sp 160 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100070 # nontail if
	jal %zero beq_cont.100071 # then sentence ends
beq_else.100070:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100072 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100073 # then sentence ends
beq_else.100072:
	addi %a0 %zero 0 #105
beq_cont.100073:
beq_cont.100071:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100074 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.100075 # then sentence ends
beq_else.100074:
	addi %a0 %zero 0 #1175
beq_cont.100075:
beq_cont.100059:
beq_cont.100049:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100076 # nontail if
	lw %a1 %sp 52 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100078 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100079 # then sentence ends
beq_else.100078:
	slli %a0 %a0 2 #20
	lw %a2 %sp 56 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 96 #1198
	lw %f1 %sp 88 #1198
	lw %f2 %sp 80 #1198
	sw %ra %sp 164 #1198 call dir
	addi %sp %sp 168 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -168 #1198
	lw %ra %sp 164 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100080 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 96 #1201
	lw %f1 %sp 88 #1201
	lw %f2 %sp 80 #1201
	lw %a1 %sp 52 #1201
	lw %a11 %sp 36 #1201
	sw %ra %sp 164 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 168 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -168 #1201
	lw %ra %sp 164 #1201
	jal %zero beq_cont.100081 # then sentence ends
beq_else.100080:
	addi %a0 %zero 0 #1198
beq_cont.100081:
beq_cont.100079:
	jal %zero beq_cont.100077 # then sentence ends
beq_else.100076:
	addi %a0 %zero 0 #1198
beq_cont.100077:
beq_cont.100047:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100082 # nontail if
	jal %zero beq_cont.100083 # then sentence ends
beq_else.100082:
	lw %a0 %sp 44 #1310
	lw %f0 %sp 104 #1310
	sw %f0 %a0 0 #1310
	lw %a0 %sp 32 #133
	lw %f0 %sp 96 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 88 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 80 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1312
	lw %a1 %sp 60 #1312
	sw %a1 %a0 0 #1312
	lw %a0 %sp 0 #1313
	lw %a1 %sp 64 #1313
	sw %a1 %a0 0 #1313
beq_cont.100083:
beq_cont.100045:
beq_cont.100043:
	addi %a0 %zero 1 #1319
	lw %a1 %sp 52 #1319
	lw %a2 %sp 20 #1319
	lw %a11 %sp 24 #1319
	sw %ra %sp 164 #1319 call cls
	lw %a10 %a11 0 #1319
	addi %sp %sp 168 #1319	
	jalr %ra %a10 0 #1319
	addi %sp %sp -168 #1319
	lw %ra %sp 164 #1319
beq_cont.100038:
beq_cont.100036:
	lw %a0 %sp 12 #1336
	addi %a0 %a0 1 #1336
	slli %a1 %a0 2 #1332
	lw %a2 %sp 28 #1332
	add %a12 %a2 %a1 #1332
	lw %a1 %a12 0 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100084
	jalr %zero %ra 0 #1337
beq_else.100084:
	slli %a1 %a1 2 #31
	lw %a3 %sp 16 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 20 #1335
	lw %a11 %sp 24 #1335
	sw %a0 %sp 164 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 172 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 176 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -176 #1335
	lw %ra %sp 172 #1335
	lw %a0 %sp 164 #1336
	addi %a0 %a0 1 #1336
	lw %a1 %sp 28 #1336
	lw %a2 %sp 20 #1336
	lw %a11 %sp 8 #1336
	lw %a10 %a11 0 #1336
	jalr %zero %a10 0 #1336
trace_or_matrix.2529:
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
	bne %a1 %a12 beq_else.100086
	jalr %zero %ra 0 #1345
beq_else.100086:
	sw %a3 %sp 16 #1344
	sw %a7 %sp 20 #1344
	sw %a4 %sp 24 #1344
	sw %a2 %sp 28 #1344
	sw %a9 %sp 32 #1344
	addi %a12 %zero 99
	bne %a1 %a12 beq_else.100088 # nontail if
	lw %a1 %a0 4 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100090 # nontail if
	jal %zero beq_cont.100091 # then sentence ends
beq_else.100090:
	slli %a1 %a1 2 #31
	add %a12 %a11 %a1 #31
	lw %a1 %a12 0 #31
	addi %a5 %zero 0 #1335
	sw %a0 %sp 36 #1335
	add %a0 %a5 %zero
	add %a11 %a10 %zero
	sw %ra %sp 44 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 48 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -48 #1335
	lw %ra %sp 44 #1335
	addi %a0 %zero 2 #1336
	lw %a1 %sp 36 #1336
	lw %a2 %sp 28 #1336
	lw %a11 %sp 32 #1336
	sw %ra %sp 44 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 48 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -48 #1336
	lw %ra %sp 44 #1336
beq_cont.100091:
	jal %zero beq_cont.100089 # then sentence ends
beq_else.100088:
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
	sw %a10 %sp 40 #868
	sw %a11 %sp 44 #868
	sw %a0 %sp 36 #868
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.100092 # nontail if
	add %a0 %a1 %zero
	add %a11 %a6 %zero
	add %a1 %a2 %zero
	sw %ra %sp 52 #891 call cls
	lw %a10 %a11 0 #891
	addi %sp %sp 56 #891	
	jalr %ra %a10 0 #891
	addi %sp %sp -56 #891
	lw %ra %sp 52 #891
	jal %zero beq_cont.100093 # then sentence ends
beq_else.100092:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.100094 # nontail if
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
	sw %f3 %sp 48 #811
	sw %f2 %sp 56 #811
	sw %f1 %sp 64 #811
	sw %f0 %sp 72 #811
	sw %a1 %sp 80 #811
	fadd %f0 %f3 %fzero
	sw %ra %sp 84 #811 call dir
	addi %sp %sp 88 #811	
	jal %ra min_caml_fispos #811
	addi %sp %sp -88 #811
	lw %ra %sp 84 #811
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100096 # nontail if
	addi %a0 %zero 0 #811
	jal %zero beq_cont.100097 # then sentence ends
beq_else.100096:
	lw %a0 %sp 80 #186
	lw %f0 %a0 0 #186
	lw %f1 %sp 72 #186
	fmul %f0 %f0 %f1 #186
	lw %f1 %a0 4 #186
	lw %f2 %sp 64 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	lw %f1 %a0 8 #186
	lw %f2 %sp 56 #186
	fmul %f1 %f1 %f2 #186
	fadd %f0 %f0 %f1 #186
	sw %ra %sp 84 #812 call dir
	addi %sp %sp 88 #812	
	jal %ra min_caml_fneg #812
	addi %sp %sp -88 #812
	lw %ra %sp 84 #812
	lw %f1 %sp 48 #812
	fdiv %f0 %f0 %f1 #812
	lw %a0 %sp 20 #812
	sw %f0 %a0 0 #812
	addi %a0 %zero 1 #813
beq_cont.100097:
	jal %zero beq_cont.100095 # then sentence ends
beq_else.100094:
	add %a0 %a1 %zero
	add %a11 %a5 %zero
	add %a1 %a2 %zero
	sw %ra %sp 84 #893 call cls
	lw %a10 %a11 0 #893
	addi %sp %sp 88 #893	
	jalr %ra %a10 0 #893
	addi %sp %sp -88 #893
	lw %ra %sp 84 #893
beq_cont.100095:
beq_cont.100093:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100098 # nontail if
	jal %zero beq_cont.100099 # then sentence ends
beq_else.100098:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	lw %a1 %sp 16 #41
	lw %f1 %a1 0 #41
	sw %ra %sp 84 #1355 call dir
	addi %sp %sp 88 #1355	
	jal %ra min_caml_fless #1355
	addi %sp %sp -88 #1355
	lw %ra %sp 84 #1355
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100100 # nontail if
	jal %zero beq_cont.100101 # then sentence ends
beq_else.100100:
	lw %a0 %sp 36 #1332
	lw %a1 %a0 4 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100102 # nontail if
	jal %zero beq_cont.100103 # then sentence ends
beq_else.100102:
	slli %a1 %a1 2 #31
	lw %a2 %sp 44 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1335
	lw %a3 %sp 28 #1335
	lw %a11 %sp 40 #1335
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	addi %a0 %zero 2 #1336
	lw %a1 %sp 36 #1336
	lw %a2 %sp 28 #1336
	lw %a11 %sp 32 #1336
	sw %ra %sp 84 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 88 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -88 #1336
	lw %ra %sp 84 #1336
beq_cont.100103:
beq_cont.100101:
beq_cont.100099:
beq_cont.100089:
	lw %a0 %sp 8 #1360
	addi %a0 %a0 1 #1360
	slli %a1 %a0 2 #1342
	lw %a2 %sp 12 #1342
	add %a12 %a2 %a1 #1342
	lw %a1 %a12 0 #1342
	lw %a3 %a1 0 #1343
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.100104
	jalr %zero %ra 0 #1345
beq_else.100104:
	sw %a0 %sp 84 #1344
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.100106 # nontail if
	addi %a3 %zero 1 #1348
	lw %a4 %sp 28 #1348
	lw %a11 %sp 32 #1348
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1348 call cls
	lw %a10 %a11 0 #1348
	addi %sp %sp 96 #1348	
	jalr %ra %a10 0 #1348
	addi %sp %sp -96 #1348
	lw %ra %sp 92 #1348
	jal %zero beq_cont.100107 # then sentence ends
beq_else.100106:
	lw %a4 %sp 28 #1352
	lw %a5 %sp 24 #1352
	lw %a11 %sp 0 #1352
	sw %a1 %sp 88 #1352
	add %a2 %a5 %zero
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1352 call cls
	lw %a10 %a11 0 #1352
	addi %sp %sp 96 #1352	
	jalr %ra %a10 0 #1352
	addi %sp %sp -96 #1352
	lw %ra %sp 92 #1352
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100108 # nontail if
	jal %zero beq_cont.100109 # then sentence ends
beq_else.100108:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 16 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 92 #1355 call dir
	addi %sp %sp 96 #1355	
	jal %ra min_caml_fless #1355
	addi %sp %sp -96 #1355
	lw %ra %sp 92 #1355
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100110 # nontail if
	jal %zero beq_cont.100111 # then sentence ends
beq_else.100110:
	addi %a0 %zero 1 #1356
	lw %a1 %sp 88 #1356
	lw %a2 %sp 28 #1356
	lw %a11 %sp 32 #1356
	sw %ra %sp 92 #1356 call cls
	lw %a10 %a11 0 #1356
	addi %sp %sp 96 #1356	
	jalr %ra %a10 0 #1356
	addi %sp %sp -96 #1356
	lw %ra %sp 92 #1356
beq_cont.100111:
beq_cont.100109:
beq_cont.100107:
	lw %a0 %sp 84 #1360
	addi %a0 %a0 1 #1360
	lw %a1 %sp 12 #1360
	lw %a2 %sp 28 #1360
	lw %a11 %sp 4 #1360
	lw %a10 %a11 0 #1360
	jalr %zero %a10 0 #1360
solve_each_element_fast.2535:
	lw %a3 %a11 40 #1381
	lw %a4 %a11 36 #1381
	lw %a5 %a11 32 #1381
	lw %a6 %a11 28 #1381
	lw %a7 %a11 24 #1381
	lw %a8 %a11 20 #1381
	lw %a9 %a11 16 #1381
	lw %a10 %a11 12 #1381
	sw %a9 %sp 0 #1381
	lw %a9 %a11 8 #1381
	sw %a9 %sp 4 #1381
	lw %a9 %a11 4 #1381
	sw %a10 %sp 8 #507
	lw %a10 %a2 0 #507
	sw %a10 %sp 12 #1383
	slli %a10 %a0 2 #1383
	add %a12 %a1 %a10 #1383
	lw %a10 %a12 0 #1383
	addi %a12 %zero -1
	bne %a10 %a12 beq_else.100112
	jalr %zero %ra 0 #1384
beq_else.100112:
	sw %a9 %sp 16 #20
	slli %a9 %a10 2 #20
	add %a12 %a8 %a9 #20
	lw %a9 %a12 0 #20
	sw %a4 %sp 20 #427
	lw %a4 %a9 40 #427
	lw %f0 %a4 0 #19
	lw %f1 %a4 4 #19
	lw %f2 %a4 8 #19
	sw %a3 %sp 24 #513
	lw %a3 %a2 4 #513
	sw %a11 %sp 28 #968
	slli %a11 %a10 2 #968
	add %a12 %a3 %a11 #968
	lw %a3 %a12 0 #968
	lw %a11 %a9 4 #238
	sw %a7 %sp 32 #868
	sw %a6 %sp 36 #868
	sw %a1 %sp 40 #868
	sw %a2 %sp 44 #868
	sw %a0 %sp 48 #868
	sw %a8 %sp 52 #868
	sw %a10 %sp 56 #868
	addi %a12 %zero 1
	bne %a11 %a12 beq_else.100114 # nontail if
	lw %a4 %a2 0 #507
	add %a2 %a3 %zero
	add %a1 %a4 %zero
	add %a0 %a9 %zero
	add %a11 %a5 %zero
	sw %ra %sp 60 #1019 call cls
	lw %a10 %a11 0 #1019
	addi %sp %sp 64 #1019	
	jalr %ra %a10 0 #1019
	addi %sp %sp -64 #1019
	lw %ra %sp 60 #1019
	jal %zero beq_cont.100115 # then sentence ends
beq_else.100114:
	addi %a12 %zero 2
	bne %a11 %a12 beq_else.100116 # nontail if
	lw %f0 %a3 0 #983
	sw %a4 %sp 60 #983
	sw %a3 %sp 64 #983
	sw %ra %sp 68 #983 call dir
	addi %sp %sp 72 #983	
	jal %ra min_caml_fisneg #983
	addi %sp %sp -72 #983
	lw %ra %sp 68 #983
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100118 # nontail if
	addi %a0 %zero 0 #983
	jal %zero beq_cont.100119 # then sentence ends
beq_else.100118:
	lw %a0 %sp 64 #983
	lw %f0 %a0 0 #983
	lw %a0 %sp 60 #984
	lw %f1 %a0 12 #984
	fmul %f0 %f0 %f1 #984
	lw %a0 %sp 32 #984
	sw %f0 %a0 0 #984
	addi %a0 %zero 1 #985
beq_cont.100119:
	jal %zero beq_cont.100117 # then sentence ends
beq_else.100116:
	lw %f3 %a3 0 #992
	sw %a9 %sp 68 #993
	sw %f3 %sp 72 #993
	sw %a4 %sp 60 #993
	sw %f2 %sp 80 #993
	sw %f1 %sp 88 #993
	sw %f0 %sp 96 #993
	sw %a3 %sp 64 #993
	fadd %f0 %f3 %fzero
	sw %ra %sp 108 #993 call dir
	addi %sp %sp 112 #993	
	jal %ra min_caml_fiszero #993
	addi %sp %sp -112 #993
	lw %ra %sp 108 #993
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100120 # nontail if
	lw %a0 %sp 64 #992
	lw %f0 %a0 4 #992
	lw %f1 %sp 96 #996
	fmul %f0 %f0 %f1 #996
	lw %f1 %a0 8 #992
	lw %f2 %sp 88 #996
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a0 12 #992
	lw %f2 %sp 80 #996
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %a1 %sp 60 #997
	lw %f1 %a1 12 #997
	sw %f0 %sp 104 #998
	sw %f1 %sp 112 #998
	sw %ra %sp 124 #998 call dir
	addi %sp %sp 128 #998	
	jal %ra min_caml_fsqr #998
	addi %sp %sp -128 #998
	lw %ra %sp 124 #998
	lw %f1 %sp 112 #998
	lw %f2 %sp 72 #998
	fmul %f1 %f2 %f1 #998
	fsub %f0 %f0 %f1 #998
	sw %f0 %sp 120 #999
	sw %ra %sp 132 #999 call dir
	addi %sp %sp 136 #999	
	jal %ra min_caml_fispos #999
	addi %sp %sp -136 #999
	lw %ra %sp 132 #999
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100122 # nontail if
	addi %a0 %zero 0 #993
	jal %zero beq_cont.100123 # then sentence ends
beq_else.100122:
	lw %a0 %sp 68 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100124 # nontail if
	lw %f0 %sp 120 #1003
	sw %ra %sp 132 #1003 call dir
	addi %sp %sp 136 #1003	
	jal %ra min_caml_sqrt #1003
	addi %sp %sp -136 #1003
	lw %ra %sp 132 #1003
	lw %f1 %sp 104 #1003
	fsub %f0 %f1 %f0 #1003
	lw %a0 %sp 64 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1003
	lw %a0 %sp 32 #1003
	sw %f0 %a0 0 #1003
	jal %zero beq_cont.100125 # then sentence ends
beq_else.100124:
	lw %f0 %sp 120 #1001
	sw %ra %sp 132 #1001 call dir
	addi %sp %sp 136 #1001	
	jal %ra min_caml_sqrt #1001
	addi %sp %sp -136 #1001
	lw %ra %sp 132 #1001
	lw %f1 %sp 104 #1001
	fadd %f0 %f1 %f0 #1001
	lw %a0 %sp 64 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1001
	lw %a0 %sp 32 #1001
	sw %f0 %a0 0 #1001
beq_cont.100125:
	addi %a0 %zero 1 #1004
beq_cont.100123:
	jal %zero beq_cont.100121 # then sentence ends
beq_else.100120:
	addi %a0 %zero 0 #993
beq_cont.100121:
beq_cont.100117:
beq_cont.100115:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100126
	lw %a0 %sp 56 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 52 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100127
	jalr %zero %ra 0 #1417
beq_else.100127:
	lw %a0 %sp 48 #1416
	addi %a0 %a0 1 #1416
	lw %a2 %sp 44 #507
	lw %a3 %a2 0 #507
	slli %a4 %a0 2 #1383
	lw %a5 %sp 40 #1383
	add %a12 %a5 %a4 #1383
	lw %a4 %a12 0 #1383
	addi %a12 %zero -1
	bne %a4 %a12 beq_else.100129
	jalr %zero %ra 0 #1384
beq_else.100129:
	lw %a11 %sp 36 #1386
	sw %a3 %sp 128 #1386
	sw %a0 %sp 132 #1386
	sw %a4 %sp 136 #1386
	add %a1 %a2 %zero
	add %a0 %a4 %zero
	sw %ra %sp 140 #1386 call cls
	lw %a10 %a11 0 #1386
	addi %sp %sp 144 #1386	
	jalr %ra %a10 0 #1386
	addi %sp %sp -144 #1386
	lw %ra %sp 140 #1386
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100131
	lw %a0 %sp 136 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 52 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100132
	jalr %zero %ra 0 #1417
beq_else.100132:
	lw %a0 %sp 132 #1416
	addi %a0 %a0 1 #1416
	lw %a1 %sp 40 #1416
	lw %a2 %sp 44 #1416
	lw %a11 %sp 28 #1416
	lw %a10 %a11 0 #1416
	jalr %zero %a10 0 #1416
beq_else.100131:
	lw %a1 %sp 32 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1393
	sw %a0 %sp 140 #1393
	sw %f1 %sp 144 #1393
	sw %ra %sp 156 #1393 call dir
	addi %sp %sp 160 #1393	
	jal %ra min_caml_fless #1393
	addi %sp %sp -160 #1393
	lw %ra %sp 156 #1393
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100134 # nontail if
	jal %zero beq_cont.100135 # then sentence ends
beq_else.100134:
	lw %a0 %sp 24 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 144 #1394
	sw %ra %sp 156 #1394 call dir
	addi %sp %sp 160 #1394	
	jal %ra min_caml_fless #1394
	addi %sp %sp -160 #1394
	lw %ra %sp 156 #1394
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100136 # nontail if
	jal %zero beq_cont.100137 # then sentence ends
beq_else.100136:
	li %f0 l.91125 #1396
	lw %f1 %sp 144 #1396
	fadd %f0 %f1 %f0 #1396
	lw %a0 %sp 128 #903
	lw %f1 %a0 0 #903
	fmul %f1 %f1 %f0 #1397
	lw %a1 %sp 20 #66
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
	lw %a1 %sp 40 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 152 #1195
	sw %f2 %sp 160 #1195
	sw %f1 %sp 168 #1195
	sw %f0 %sp 176 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100138 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100139 # then sentence ends
beq_else.100138:
	slli %a0 %a0 2 #20
	lw %a2 %sp 52 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f4 %a3 0 #321
	fsub %f4 %f1 %f4 #1180
	lw %a3 %a0 20 #326
	lw %f5 %a3 4 #331
	fsub %f5 %f2 %f5 #1181
	lw %a3 %a0 20 #336
	lw %f6 %a3 8 #341
	fsub %f6 %f3 %f6 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.100140 # nontail if
	sw %f6 %sp 184 #1157
	sw %f5 %sp 192 #1157
	sw %a0 %sp 200 #1157
	fadd %f0 %f4 %fzero
	sw %ra %sp 204 #1157 call dir
	addi %sp %sp 208 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -208 #1157
	lw %ra %sp 204 #1157
	lw %a0 %sp 200 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 204 #1157 call dir
	addi %sp %sp 208 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -208 #1157
	lw %ra %sp 204 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100142 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100143 # then sentence ends
beq_else.100142:
	lw %f0 %sp 192 #1158
	sw %ra %sp 204 #1158 call dir
	addi %sp %sp 208 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -208 #1158
	lw %ra %sp 204 #1158
	lw %a0 %sp 200 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 204 #1158 call dir
	addi %sp %sp 208 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -208 #1158
	lw %ra %sp 204 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100144 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100145 # then sentence ends
beq_else.100144:
	lw %f0 %sp 184 #1159
	sw %ra %sp 204 #1159 call dir
	addi %sp %sp 208 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -208 #1159
	lw %ra %sp 204 #1159
	lw %a0 %sp 200 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 204 #1159 call dir
	addi %sp %sp 208 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -208 #1159
	lw %ra %sp 204 #1159
beq_cont.100145:
beq_cont.100143:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100146 # nontail if
	lw %a0 %sp 200 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100148 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.100149 # then sentence ends
beq_else.100148:
	addi %a0 %zero 0 #1156
beq_cont.100149:
	jal %zero beq_cont.100147 # then sentence ends
beq_else.100146:
	lw %a0 %sp 200 #258
	lw %a0 %a0 24 #258
beq_cont.100147:
	jal %zero beq_cont.100141 # then sentence ends
beq_else.100140:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.100150 # nontail if
	lw %a3 %a0 16 #306
	lw %f7 %a3 0 #186
	fmul %f4 %f7 %f4 #186
	lw %f7 %a3 4 #186
	fmul %f5 %f7 %f5 #186
	fadd %f4 %f4 %f5 #186
	lw %f5 %a3 8 #186
	fmul %f5 %f5 %f6 #186
	fadd %f4 %f4 %f5 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 204 #1168
	fadd %f0 %f4 %fzero
	sw %ra %sp 212 #1168 call dir
	addi %sp %sp 216 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -216 #1168
	lw %ra %sp 212 #1168
	lw %a1 %sp 204 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100152 # nontail if
	jal %zero beq_cont.100153 # then sentence ends
beq_else.100152:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100154 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100155 # then sentence ends
beq_else.100154:
	addi %a0 %zero 0 #105
beq_cont.100155:
beq_cont.100153:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100156 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.100157 # then sentence ends
beq_else.100156:
	addi %a0 %zero 0 #1168
beq_cont.100157:
	jal %zero beq_cont.100151 # then sentence ends
beq_else.100150:
	sw %f4 %sp 208 #822
	sw %f6 %sp 184 #822
	sw %f5 %sp 192 #822
	sw %a0 %sp 200 #822
	fadd %f0 %f4 %fzero
	sw %ra %sp 220 #822 call dir
	addi %sp %sp 224 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -224 #822
	lw %ra %sp 220 #822
	lw %a0 %sp 200 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 192 #822
	sw %f0 %sp 216 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 228 #822 call dir
	addi %sp %sp 232 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -232 #822
	lw %ra %sp 228 #822
	lw %a0 %sp 200 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 216 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 184 #822
	sw %f0 %sp 224 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 236 #822 call dir
	addi %sp %sp 240 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -240 #822
	lw %ra %sp 236 #822
	lw %a0 %sp 200 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 224 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100158 # nontail if
	jal %zero beq_cont.100159 # then sentence ends
beq_else.100158:
	lw %f1 %sp 184 #828
	lw %f2 %sp 192 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 208 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.100159:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.100160 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.100161 # then sentence ends
beq_else.100160:
beq_cont.100161:
	lw %a0 %a0 24 #258
	sw %a0 %sp 232 #1175
	sw %ra %sp 236 #1175 call dir
	addi %sp %sp 240 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -240 #1175
	lw %ra %sp 236 #1175
	lw %a1 %sp 232 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100162 # nontail if
	jal %zero beq_cont.100163 # then sentence ends
beq_else.100162:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100164 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100165 # then sentence ends
beq_else.100164:
	addi %a0 %zero 0 #105
beq_cont.100165:
beq_cont.100163:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100166 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.100167 # then sentence ends
beq_else.100166:
	addi %a0 %zero 0 #1175
beq_cont.100167:
beq_cont.100151:
beq_cont.100141:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100168 # nontail if
	lw %a1 %sp 40 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100170 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100171 # then sentence ends
beq_else.100170:
	slli %a0 %a0 2 #20
	lw %a2 %sp 52 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 168 #1198
	lw %f1 %sp 160 #1198
	lw %f2 %sp 152 #1198
	sw %ra %sp 236 #1198 call dir
	addi %sp %sp 240 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -240 #1198
	lw %ra %sp 236 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100172 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 168 #1201
	lw %f1 %sp 160 #1201
	lw %f2 %sp 152 #1201
	lw %a1 %sp 40 #1201
	lw %a11 %sp 16 #1201
	sw %ra %sp 236 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 240 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -240 #1201
	lw %ra %sp 236 #1201
	jal %zero beq_cont.100173 # then sentence ends
beq_else.100172:
	addi %a0 %zero 0 #1198
beq_cont.100173:
beq_cont.100171:
	jal %zero beq_cont.100169 # then sentence ends
beq_else.100168:
	addi %a0 %zero 0 #1198
beq_cont.100169:
beq_cont.100139:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100174 # nontail if
	jal %zero beq_cont.100175 # then sentence ends
beq_else.100174:
	lw %a0 %sp 24 #1402
	lw %f0 %sp 176 #1402
	sw %f0 %a0 0 #1402
	lw %a0 %sp 8 #133
	lw %f0 %sp 168 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 160 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 152 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1404
	lw %a1 %sp 136 #1404
	sw %a1 %a0 0 #1404
	lw %a0 %sp 0 #1405
	lw %a1 %sp 140 #1405
	sw %a1 %a0 0 #1405
beq_cont.100175:
beq_cont.100137:
beq_cont.100135:
	lw %a0 %sp 132 #1411
	addi %a0 %a0 1 #1411
	lw %a1 %sp 40 #1411
	lw %a2 %sp 44 #1411
	lw %a11 %sp 28 #1411
	lw %a10 %a11 0 #1411
	jalr %zero %a10 0 #1411
beq_else.100126:
	lw %a1 %sp 32 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1393
	sw %a0 %sp 236 #1393
	sw %f1 %sp 240 #1393
	sw %ra %sp 252 #1393 call dir
	addi %sp %sp 256 #1393	
	jal %ra min_caml_fless #1393
	addi %sp %sp -256 #1393
	lw %ra %sp 252 #1393
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100176 # nontail if
	jal %zero beq_cont.100177 # then sentence ends
beq_else.100176:
	lw %a0 %sp 24 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 240 #1394
	sw %ra %sp 252 #1394 call dir
	addi %sp %sp 256 #1394	
	jal %ra min_caml_fless #1394
	addi %sp %sp -256 #1394
	lw %ra %sp 252 #1394
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100178 # nontail if
	jal %zero beq_cont.100179 # then sentence ends
beq_else.100178:
	li %f0 l.91125 #1396
	lw %f1 %sp 240 #1396
	fadd %f0 %f1 %f0 #1396
	lw %a0 %sp 12 #903
	lw %f1 %a0 0 #903
	fmul %f1 %f1 %f0 #1397
	lw %a1 %sp 20 #66
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
	lw %a0 %sp 40 #1194
	lw %a2 %a0 0 #1194
	sw %f3 %sp 248 #1195
	sw %f2 %sp 256 #1195
	sw %f1 %sp 264 #1195
	sw %f0 %sp 272 #1195
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.100180 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100181 # then sentence ends
beq_else.100180:
	slli %a2 %a2 2 #20
	lw %a3 %sp 52 #20
	add %a12 %a3 %a2 #20
	lw %a2 %a12 0 #20
	add %a0 %a2 %zero
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 284 #1198 call dir
	addi %sp %sp 288 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -288 #1198
	lw %ra %sp 284 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100182 # nontail if
	lw %a0 %sp 40 #1194
	lw %a1 %a0 4 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100184 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100185 # then sentence ends
beq_else.100184:
	slli %a1 %a1 2 #20
	lw %a2 %sp 52 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a3 %a1 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 264 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a1 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 256 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a1 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 248 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a1 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.100186 # nontail if
	sw %f4 %sp 280 #1157
	sw %f2 %sp 288 #1157
	sw %a1 %sp 296 #1157
	sw %ra %sp 300 #1157 call dir
	addi %sp %sp 304 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -304 #1157
	lw %ra %sp 300 #1157
	lw %a0 %sp 296 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 300 #1157 call dir
	addi %sp %sp 304 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -304 #1157
	lw %ra %sp 300 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100188 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100189 # then sentence ends
beq_else.100188:
	lw %f0 %sp 288 #1158
	sw %ra %sp 300 #1158 call dir
	addi %sp %sp 304 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -304 #1158
	lw %ra %sp 300 #1158
	lw %a0 %sp 296 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 300 #1158 call dir
	addi %sp %sp 304 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -304 #1158
	lw %ra %sp 300 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100190 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100191 # then sentence ends
beq_else.100190:
	lw %f0 %sp 280 #1159
	sw %ra %sp 300 #1159 call dir
	addi %sp %sp 304 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -304 #1159
	lw %ra %sp 300 #1159
	lw %a0 %sp 296 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 300 #1159 call dir
	addi %sp %sp 304 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -304 #1159
	lw %ra %sp 300 #1159
beq_cont.100191:
beq_cont.100189:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100192 # nontail if
	lw %a0 %sp 296 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100194 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.100195 # then sentence ends
beq_else.100194:
	addi %a0 %zero 0 #1156
beq_cont.100195:
	jal %zero beq_cont.100193 # then sentence ends
beq_else.100192:
	lw %a0 %sp 296 #258
	lw %a0 %a0 24 #258
beq_cont.100193:
	jal %zero beq_cont.100187 # then sentence ends
beq_else.100186:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.100196 # nontail if
	lw %a3 %a1 16 #306
	lw %f6 %a3 0 #186
	fmul %f0 %f6 %f0 #186
	lw %f6 %a3 4 #186
	fmul %f2 %f6 %f2 #186
	fadd %f0 %f0 %f2 #186
	lw %f2 %a3 8 #186
	fmul %f2 %f2 %f4 #186
	fadd %f0 %f0 %f2 #186
	lw %a1 %a1 24 #258
	sw %a1 %sp 300 #1168
	sw %ra %sp 308 #1168 call dir
	addi %sp %sp 312 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -312 #1168
	lw %ra %sp 308 #1168
	lw %a1 %sp 300 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100198 # nontail if
	jal %zero beq_cont.100199 # then sentence ends
beq_else.100198:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100200 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100201 # then sentence ends
beq_else.100200:
	addi %a0 %zero 0 #105
beq_cont.100201:
beq_cont.100199:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100202 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.100203 # then sentence ends
beq_else.100202:
	addi %a0 %zero 0 #1168
beq_cont.100203:
	jal %zero beq_cont.100197 # then sentence ends
beq_else.100196:
	sw %f0 %sp 304 #822
	sw %f4 %sp 280 #822
	sw %f2 %sp 288 #822
	sw %a1 %sp 296 #822
	sw %ra %sp 316 #822 call dir
	addi %sp %sp 320 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -320 #822
	lw %ra %sp 316 #822
	lw %a0 %sp 296 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 288 #822
	sw %f0 %sp 312 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 324 #822 call dir
	addi %sp %sp 328 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -328 #822
	lw %ra %sp 324 #822
	lw %a0 %sp 296 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 312 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 280 #822
	sw %f0 %sp 320 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 332 #822 call dir
	addi %sp %sp 336 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -336 #822
	lw %ra %sp 332 #822
	lw %a0 %sp 296 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 320 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100204 # nontail if
	jal %zero beq_cont.100205 # then sentence ends
beq_else.100204:
	lw %f1 %sp 280 #828
	lw %f2 %sp 288 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 304 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.100205:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.100206 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.100207 # then sentence ends
beq_else.100206:
beq_cont.100207:
	lw %a0 %a0 24 #258
	sw %a0 %sp 328 #1175
	sw %ra %sp 332 #1175 call dir
	addi %sp %sp 336 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -336 #1175
	lw %ra %sp 332 #1175
	lw %a1 %sp 328 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100208 # nontail if
	jal %zero beq_cont.100209 # then sentence ends
beq_else.100208:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100210 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100211 # then sentence ends
beq_else.100210:
	addi %a0 %zero 0 #105
beq_cont.100211:
beq_cont.100209:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100212 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.100213 # then sentence ends
beq_else.100212:
	addi %a0 %zero 0 #1175
beq_cont.100213:
beq_cont.100197:
beq_cont.100187:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100214 # nontail if
	lw %a0 %sp 40 #1194
	lw %a1 %a0 8 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100216 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100217 # then sentence ends
beq_else.100216:
	slli %a1 %a1 2 #20
	lw %a2 %sp 52 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 264 #1198
	lw %f1 %sp 256 #1198
	lw %f2 %sp 248 #1198
	add %a0 %a1 %zero
	sw %ra %sp 332 #1198 call dir
	addi %sp %sp 336 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -336 #1198
	lw %ra %sp 332 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100218 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 264 #1201
	lw %f1 %sp 256 #1201
	lw %f2 %sp 248 #1201
	lw %a1 %sp 40 #1201
	lw %a11 %sp 16 #1201
	sw %ra %sp 332 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 336 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -336 #1201
	lw %ra %sp 332 #1201
	jal %zero beq_cont.100219 # then sentence ends
beq_else.100218:
	addi %a0 %zero 0 #1198
beq_cont.100219:
beq_cont.100217:
	jal %zero beq_cont.100215 # then sentence ends
beq_else.100214:
	addi %a0 %zero 0 #1198
beq_cont.100215:
beq_cont.100185:
	jal %zero beq_cont.100183 # then sentence ends
beq_else.100182:
	addi %a0 %zero 0 #1198
beq_cont.100183:
beq_cont.100181:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100220 # nontail if
	jal %zero beq_cont.100221 # then sentence ends
beq_else.100220:
	lw %a0 %sp 24 #1402
	lw %f0 %sp 272 #1402
	sw %f0 %a0 0 #1402
	lw %a1 %sp 8 #133
	lw %f0 %sp 264 #133
	sw %f0 %a1 0 #133
	lw %f0 %sp 256 #134
	sw %f0 %a1 4 #134
	lw %f0 %sp 248 #135
	sw %f0 %a1 8 #135
	lw %a2 %sp 4 #1404
	lw %a3 %sp 56 #1404
	sw %a3 %a2 0 #1404
	lw %a3 %sp 0 #1405
	lw %a4 %sp 236 #1405
	sw %a4 %a3 0 #1405
beq_cont.100221:
beq_cont.100179:
beq_cont.100177:
	lw %a0 %sp 48 #1411
	addi %a0 %a0 1 #1411
	lw %a1 %sp 44 #507
	lw %a2 %a1 0 #507
	slli %a3 %a0 2 #1383
	lw %a4 %sp 40 #1383
	add %a12 %a4 %a3 #1383
	lw %a3 %a12 0 #1383
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.100222
	jalr %zero %ra 0 #1384
beq_else.100222:
	lw %a11 %sp 36 #1386
	sw %a2 %sp 332 #1386
	sw %a0 %sp 336 #1386
	sw %a3 %sp 340 #1386
	add %a0 %a3 %zero
	sw %ra %sp 348 #1386 call cls
	lw %a10 %a11 0 #1386
	addi %sp %sp 352 #1386	
	jalr %ra %a10 0 #1386
	addi %sp %sp -352 #1386
	lw %ra %sp 348 #1386
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100224
	lw %a0 %sp 340 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 52 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100225
	jalr %zero %ra 0 #1417
beq_else.100225:
	lw %a0 %sp 336 #1416
	addi %a0 %a0 1 #1416
	lw %a1 %sp 40 #1416
	lw %a2 %sp 44 #1416
	lw %a11 %sp 28 #1416
	lw %a10 %a11 0 #1416
	jalr %zero %a10 0 #1416
beq_else.100224:
	lw %a1 %sp 32 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1393
	sw %a0 %sp 344 #1393
	sw %f1 %sp 352 #1393
	sw %ra %sp 364 #1393 call dir
	addi %sp %sp 368 #1393	
	jal %ra min_caml_fless #1393
	addi %sp %sp -368 #1393
	lw %ra %sp 364 #1393
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100228 # nontail if
	jal %zero beq_cont.100229 # then sentence ends
beq_else.100228:
	lw %a0 %sp 24 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 352 #1394
	sw %ra %sp 364 #1394 call dir
	addi %sp %sp 368 #1394	
	jal %ra min_caml_fless #1394
	addi %sp %sp -368 #1394
	lw %ra %sp 364 #1394
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100230 # nontail if
	jal %zero beq_cont.100231 # then sentence ends
beq_else.100230:
	li %f0 l.91125 #1396
	lw %f1 %sp 352 #1396
	fadd %f0 %f1 %f0 #1396
	lw %a0 %sp 332 #903
	lw %f1 %a0 0 #903
	fmul %f1 %f1 %f0 #1397
	lw %a1 %sp 20 #66
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
	lw %a1 %sp 40 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 360 #1195
	sw %f2 %sp 368 #1195
	sw %f1 %sp 376 #1195
	sw %f0 %sp 384 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100232 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100233 # then sentence ends
beq_else.100232:
	slli %a0 %a0 2 #20
	lw %a2 %sp 52 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f4 %a3 0 #321
	fsub %f4 %f1 %f4 #1180
	lw %a3 %a0 20 #326
	lw %f5 %a3 4 #331
	fsub %f5 %f2 %f5 #1181
	lw %a3 %a0 20 #336
	lw %f6 %a3 8 #341
	fsub %f6 %f3 %f6 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.100234 # nontail if
	sw %f6 %sp 392 #1157
	sw %f5 %sp 400 #1157
	sw %a0 %sp 408 #1157
	fadd %f0 %f4 %fzero
	sw %ra %sp 412 #1157 call dir
	addi %sp %sp 416 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -416 #1157
	lw %ra %sp 412 #1157
	lw %a0 %sp 408 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 412 #1157 call dir
	addi %sp %sp 416 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -416 #1157
	lw %ra %sp 412 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100236 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100237 # then sentence ends
beq_else.100236:
	lw %f0 %sp 400 #1158
	sw %ra %sp 412 #1158 call dir
	addi %sp %sp 416 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -416 #1158
	lw %ra %sp 412 #1158
	lw %a0 %sp 408 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 412 #1158 call dir
	addi %sp %sp 416 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -416 #1158
	lw %ra %sp 412 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100238 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100239 # then sentence ends
beq_else.100238:
	lw %f0 %sp 392 #1159
	sw %ra %sp 412 #1159 call dir
	addi %sp %sp 416 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -416 #1159
	lw %ra %sp 412 #1159
	lw %a0 %sp 408 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 412 #1159 call dir
	addi %sp %sp 416 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -416 #1159
	lw %ra %sp 412 #1159
beq_cont.100239:
beq_cont.100237:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100240 # nontail if
	lw %a0 %sp 408 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100242 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.100243 # then sentence ends
beq_else.100242:
	addi %a0 %zero 0 #1156
beq_cont.100243:
	jal %zero beq_cont.100241 # then sentence ends
beq_else.100240:
	lw %a0 %sp 408 #258
	lw %a0 %a0 24 #258
beq_cont.100241:
	jal %zero beq_cont.100235 # then sentence ends
beq_else.100234:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.100244 # nontail if
	lw %a3 %a0 16 #306
	lw %f7 %a3 0 #186
	fmul %f4 %f7 %f4 #186
	lw %f7 %a3 4 #186
	fmul %f5 %f7 %f5 #186
	fadd %f4 %f4 %f5 #186
	lw %f5 %a3 8 #186
	fmul %f5 %f5 %f6 #186
	fadd %f4 %f4 %f5 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 412 #1168
	fadd %f0 %f4 %fzero
	sw %ra %sp 420 #1168 call dir
	addi %sp %sp 424 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -424 #1168
	lw %ra %sp 420 #1168
	lw %a1 %sp 412 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100246 # nontail if
	jal %zero beq_cont.100247 # then sentence ends
beq_else.100246:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100248 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100249 # then sentence ends
beq_else.100248:
	addi %a0 %zero 0 #105
beq_cont.100249:
beq_cont.100247:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100250 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.100251 # then sentence ends
beq_else.100250:
	addi %a0 %zero 0 #1168
beq_cont.100251:
	jal %zero beq_cont.100245 # then sentence ends
beq_else.100244:
	sw %f4 %sp 416 #822
	sw %f6 %sp 392 #822
	sw %f5 %sp 400 #822
	sw %a0 %sp 408 #822
	fadd %f0 %f4 %fzero
	sw %ra %sp 428 #822 call dir
	addi %sp %sp 432 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -432 #822
	lw %ra %sp 428 #822
	lw %a0 %sp 408 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 400 #822
	sw %f0 %sp 424 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 436 #822 call dir
	addi %sp %sp 440 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -440 #822
	lw %ra %sp 436 #822
	lw %a0 %sp 408 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 424 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 392 #822
	sw %f0 %sp 432 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 444 #822 call dir
	addi %sp %sp 448 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -448 #822
	lw %ra %sp 444 #822
	lw %a0 %sp 408 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 432 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100252 # nontail if
	jal %zero beq_cont.100253 # then sentence ends
beq_else.100252:
	lw %f1 %sp 392 #828
	lw %f2 %sp 400 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 416 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.100253:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.100254 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.100255 # then sentence ends
beq_else.100254:
beq_cont.100255:
	lw %a0 %a0 24 #258
	sw %a0 %sp 440 #1175
	sw %ra %sp 444 #1175 call dir
	addi %sp %sp 448 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -448 #1175
	lw %ra %sp 444 #1175
	lw %a1 %sp 440 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100256 # nontail if
	jal %zero beq_cont.100257 # then sentence ends
beq_else.100256:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100258 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100259 # then sentence ends
beq_else.100258:
	addi %a0 %zero 0 #105
beq_cont.100259:
beq_cont.100257:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100260 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.100261 # then sentence ends
beq_else.100260:
	addi %a0 %zero 0 #1175
beq_cont.100261:
beq_cont.100245:
beq_cont.100235:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100262 # nontail if
	lw %a1 %sp 40 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100264 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100265 # then sentence ends
beq_else.100264:
	slli %a0 %a0 2 #20
	lw %a2 %sp 52 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 376 #1198
	lw %f1 %sp 368 #1198
	lw %f2 %sp 360 #1198
	sw %ra %sp 444 #1198 call dir
	addi %sp %sp 448 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -448 #1198
	lw %ra %sp 444 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100266 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 376 #1201
	lw %f1 %sp 368 #1201
	lw %f2 %sp 360 #1201
	lw %a1 %sp 40 #1201
	lw %a11 %sp 16 #1201
	sw %ra %sp 444 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 448 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -448 #1201
	lw %ra %sp 444 #1201
	jal %zero beq_cont.100267 # then sentence ends
beq_else.100266:
	addi %a0 %zero 0 #1198
beq_cont.100267:
beq_cont.100265:
	jal %zero beq_cont.100263 # then sentence ends
beq_else.100262:
	addi %a0 %zero 0 #1198
beq_cont.100263:
beq_cont.100233:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100268 # nontail if
	jal %zero beq_cont.100269 # then sentence ends
beq_else.100268:
	lw %a0 %sp 24 #1402
	lw %f0 %sp 384 #1402
	sw %f0 %a0 0 #1402
	lw %a0 %sp 8 #133
	lw %f0 %sp 376 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 368 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 360 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1404
	lw %a1 %sp 340 #1404
	sw %a1 %a0 0 #1404
	lw %a0 %sp 0 #1405
	lw %a1 %sp 344 #1405
	sw %a1 %a0 0 #1405
beq_cont.100269:
beq_cont.100231:
beq_cont.100229:
	lw %a0 %sp 336 #1411
	addi %a0 %a0 1 #1411
	lw %a1 %sp 40 #1411
	lw %a2 %sp 44 #1411
	lw %a11 %sp 28 #1411
	lw %a10 %a11 0 #1411
	jalr %zero %a10 0 #1411
solve_one_or_network_fast.2539:
	lw %a3 %a11 44 #1422
	lw %a4 %a11 40 #1422
	lw %a5 %a11 36 #1422
	lw %a6 %a11 32 #1422
	lw %a7 %a11 28 #1422
	lw %a8 %a11 24 #1422
	lw %a9 %a11 20 #1422
	lw %a10 %a11 16 #1422
	sw %a9 %sp 0 #1422
	lw %a9 %a11 12 #1422
	sw %a9 %sp 4 #1422
	lw %a9 %a11 8 #1422
	sw %a11 %sp 8 #1422
	lw %a11 %a11 4 #1422
	sw %a0 %sp 12 #1423
	slli %a0 %a0 2 #1423
	add %a12 %a1 %a0 #1423
	lw %a0 %a12 0 #1423
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100270
	jalr %zero %ra 0 #1428
beq_else.100270:
	slli %a0 %a0 2 #31
	add %a12 %a11 %a0 #31
	lw %a0 %a12 0 #31
	sw %a11 %sp 16 #507
	lw %a11 %a2 0 #507
	sw %a1 %sp 20 #1383
	lw %a1 %a0 0 #1383
	sw %a2 %sp 24 #1384
	sw %a7 %sp 28 #1384
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100272 # nontail if
	jal %zero beq_cont.100273 # then sentence ends
beq_else.100272:
	sw %a10 %sp 32 #1386
	sw %a9 %sp 36 #1386
	sw %a4 %sp 40 #1386
	sw %a11 %sp 44 #1386
	sw %a3 %sp 48 #1386
	sw %a6 %sp 52 #1386
	sw %a0 %sp 56 #1386
	sw %a8 %sp 60 #1386
	sw %a1 %sp 64 #1386
	add %a0 %a1 %zero
	add %a11 %a5 %zero
	add %a1 %a2 %zero
	sw %ra %sp 68 #1386 call cls
	lw %a10 %a11 0 #1386
	addi %sp %sp 72 #1386	
	jalr %ra %a10 0 #1386
	addi %sp %sp -72 #1386
	lw %ra %sp 68 #1386
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100274 # nontail if
	lw %a0 %sp 64 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 60 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100276 # nontail if
	jal %zero beq_cont.100277 # then sentence ends
beq_else.100276:
	addi %a0 %zero 1 #1416
	lw %a1 %sp 56 #1416
	lw %a2 %sp 24 #1416
	lw %a11 %sp 28 #1416
	sw %ra %sp 68 #1416 call cls
	lw %a10 %a11 0 #1416
	addi %sp %sp 72 #1416	
	jalr %ra %a10 0 #1416
	addi %sp %sp -72 #1416
	lw %ra %sp 68 #1416
beq_cont.100277:
	jal %zero beq_cont.100275 # then sentence ends
beq_else.100274:
	lw %a1 %sp 52 #37
	lw %f1 %a1 0 #37
	li %f0 l.90390 #1393
	sw %a0 %sp 68 #1393
	sw %f1 %sp 72 #1393
	sw %ra %sp 84 #1393 call dir
	addi %sp %sp 88 #1393	
	jal %ra min_caml_fless #1393
	addi %sp %sp -88 #1393
	lw %ra %sp 84 #1393
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100278 # nontail if
	jal %zero beq_cont.100279 # then sentence ends
beq_else.100278:
	lw %a0 %sp 48 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 72 #1394
	sw %ra %sp 84 #1394 call dir
	addi %sp %sp 88 #1394	
	jal %ra min_caml_fless #1394
	addi %sp %sp -88 #1394
	lw %ra %sp 84 #1394
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100280 # nontail if
	jal %zero beq_cont.100281 # then sentence ends
beq_else.100280:
	li %f0 l.91125 #1396
	lw %f1 %sp 72 #1396
	fadd %f0 %f1 %f0 #1396
	lw %a0 %sp 44 #903
	lw %f1 %a0 0 #903
	fmul %f1 %f1 %f0 #1397
	lw %a1 %sp 40 #66
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
	lw %a1 %sp 56 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 80 #1195
	sw %f2 %sp 88 #1195
	sw %f1 %sp 96 #1195
	sw %f0 %sp 104 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100282 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100283 # then sentence ends
beq_else.100282:
	slli %a0 %a0 2 #20
	lw %a2 %sp 60 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f4 %a3 0 #321
	fsub %f4 %f1 %f4 #1180
	lw %a3 %a0 20 #326
	lw %f5 %a3 4 #331
	fsub %f5 %f2 %f5 #1181
	lw %a3 %a0 20 #336
	lw %f6 %a3 8 #341
	fsub %f6 %f3 %f6 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.100284 # nontail if
	sw %f6 %sp 112 #1157
	sw %f5 %sp 120 #1157
	sw %a0 %sp 128 #1157
	fadd %f0 %f4 %fzero
	sw %ra %sp 132 #1157 call dir
	addi %sp %sp 136 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -136 #1157
	lw %ra %sp 132 #1157
	lw %a0 %sp 128 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 132 #1157 call dir
	addi %sp %sp 136 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -136 #1157
	lw %ra %sp 132 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100286 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100287 # then sentence ends
beq_else.100286:
	lw %f0 %sp 120 #1158
	sw %ra %sp 132 #1158 call dir
	addi %sp %sp 136 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -136 #1158
	lw %ra %sp 132 #1158
	lw %a0 %sp 128 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 132 #1158 call dir
	addi %sp %sp 136 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -136 #1158
	lw %ra %sp 132 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100288 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.100289 # then sentence ends
beq_else.100288:
	lw %f0 %sp 112 #1159
	sw %ra %sp 132 #1159 call dir
	addi %sp %sp 136 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -136 #1159
	lw %ra %sp 132 #1159
	lw %a0 %sp 128 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 132 #1159 call dir
	addi %sp %sp 136 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -136 #1159
	lw %ra %sp 132 #1159
beq_cont.100289:
beq_cont.100287:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100290 # nontail if
	lw %a0 %sp 128 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100292 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.100293 # then sentence ends
beq_else.100292:
	addi %a0 %zero 0 #1156
beq_cont.100293:
	jal %zero beq_cont.100291 # then sentence ends
beq_else.100290:
	lw %a0 %sp 128 #258
	lw %a0 %a0 24 #258
beq_cont.100291:
	jal %zero beq_cont.100285 # then sentence ends
beq_else.100284:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.100294 # nontail if
	lw %a3 %a0 16 #306
	lw %f7 %a3 0 #186
	fmul %f4 %f7 %f4 #186
	lw %f7 %a3 4 #186
	fmul %f5 %f7 %f5 #186
	fadd %f4 %f4 %f5 #186
	lw %f5 %a3 8 #186
	fmul %f5 %f5 %f6 #186
	fadd %f4 %f4 %f5 #186
	lw %a0 %a0 24 #258
	sw %a0 %sp 132 #1168
	fadd %f0 %f4 %fzero
	sw %ra %sp 140 #1168 call dir
	addi %sp %sp 144 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -144 #1168
	lw %ra %sp 140 #1168
	lw %a1 %sp 132 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100296 # nontail if
	jal %zero beq_cont.100297 # then sentence ends
beq_else.100296:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100298 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100299 # then sentence ends
beq_else.100298:
	addi %a0 %zero 0 #105
beq_cont.100299:
beq_cont.100297:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100300 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.100301 # then sentence ends
beq_else.100300:
	addi %a0 %zero 0 #1168
beq_cont.100301:
	jal %zero beq_cont.100295 # then sentence ends
beq_else.100294:
	sw %f4 %sp 136 #822
	sw %f6 %sp 112 #822
	sw %f5 %sp 120 #822
	sw %a0 %sp 128 #822
	fadd %f0 %f4 %fzero
	sw %ra %sp 148 #822 call dir
	addi %sp %sp 152 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -152 #822
	lw %ra %sp 148 #822
	lw %a0 %sp 128 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 120 #822
	sw %f0 %sp 144 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 156 #822 call dir
	addi %sp %sp 160 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -160 #822
	lw %ra %sp 156 #822
	lw %a0 %sp 128 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 144 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 112 #822
	sw %f0 %sp 152 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 164 #822 call dir
	addi %sp %sp 168 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -168 #822
	lw %ra %sp 164 #822
	lw %a0 %sp 128 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 152 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100302 # nontail if
	jal %zero beq_cont.100303 # then sentence ends
beq_else.100302:
	lw %f1 %sp 112 #828
	lw %f2 %sp 120 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 136 #829
	fmul %f1 %f1 %f3 #829
	lw %a1 %a0 36 #406
	lw %f4 %a1 4 #411
	fmul %f1 %f1 %f4 #829
	fadd %f0 %f0 %f1 #827
	fmul %f1 %f3 %f2 #830
	lw %a1 %a0 36 #416
	lw %f2 %a1 8 #421
	fmul %f1 %f1 %f2 #830
	fadd %f0 %f0 %f1 #827
beq_cont.100303:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.100304 # nontail if
	li %f1 l.90464 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.100305 # then sentence ends
beq_else.100304:
beq_cont.100305:
	lw %a0 %a0 24 #258
	sw %a0 %sp 160 #1175
	sw %ra %sp 164 #1175 call dir
	addi %sp %sp 168 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -168 #1175
	lw %ra %sp 164 #1175
	lw %a1 %sp 160 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100306 # nontail if
	jal %zero beq_cont.100307 # then sentence ends
beq_else.100306:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100308 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.100309 # then sentence ends
beq_else.100308:
	addi %a0 %zero 0 #105
beq_cont.100309:
beq_cont.100307:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100310 # nontail if
	addi %a0 %zero 1 #1175
	jal %zero beq_cont.100311 # then sentence ends
beq_else.100310:
	addi %a0 %zero 0 #1175
beq_cont.100311:
beq_cont.100295:
beq_cont.100285:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100312 # nontail if
	lw %a1 %sp 56 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.100314 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.100315 # then sentence ends
beq_else.100314:
	slli %a0 %a0 2 #20
	lw %a2 %sp 60 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 96 #1198
	lw %f1 %sp 88 #1198
	lw %f2 %sp 80 #1198
	sw %ra %sp 164 #1198 call dir
	addi %sp %sp 168 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -168 #1198
	lw %ra %sp 164 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100316 # nontail if
	addi %a0 %zero 2 #1201
	lw %f0 %sp 96 #1201
	lw %f1 %sp 88 #1201
	lw %f2 %sp 80 #1201
	lw %a1 %sp 56 #1201
	lw %a11 %sp 36 #1201
	sw %ra %sp 164 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 168 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -168 #1201
	lw %ra %sp 164 #1201
	jal %zero beq_cont.100317 # then sentence ends
beq_else.100316:
	addi %a0 %zero 0 #1198
beq_cont.100317:
beq_cont.100315:
	jal %zero beq_cont.100313 # then sentence ends
beq_else.100312:
	addi %a0 %zero 0 #1198
beq_cont.100313:
beq_cont.100283:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100318 # nontail if
	jal %zero beq_cont.100319 # then sentence ends
beq_else.100318:
	lw %a0 %sp 48 #1402
	lw %f0 %sp 104 #1402
	sw %f0 %a0 0 #1402
	lw %a0 %sp 32 #133
	lw %f0 %sp 96 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 88 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 80 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1404
	lw %a1 %sp 64 #1404
	sw %a1 %a0 0 #1404
	lw %a0 %sp 0 #1405
	lw %a1 %sp 68 #1405
	sw %a1 %a0 0 #1405
beq_cont.100319:
beq_cont.100281:
beq_cont.100279:
	addi %a0 %zero 1 #1411
	lw %a1 %sp 56 #1411
	lw %a2 %sp 24 #1411
	lw %a11 %sp 28 #1411
	sw %ra %sp 164 #1411 call cls
	lw %a10 %a11 0 #1411
	addi %sp %sp 168 #1411	
	jalr %ra %a10 0 #1411
	addi %sp %sp -168 #1411
	lw %ra %sp 164 #1411
beq_cont.100275:
beq_cont.100273:
	lw %a0 %sp 12 #1427
	addi %a0 %a0 1 #1427
	slli %a1 %a0 2 #1423
	lw %a2 %sp 20 #1423
	add %a12 %a2 %a1 #1423
	lw %a1 %a12 0 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100320
	jalr %zero %ra 0 #1428
beq_else.100320:
	slli %a1 %a1 2 #31
	lw %a3 %sp 16 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 24 #1426
	lw %a11 %sp 28 #1426
	sw %a0 %sp 164 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 172 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 176 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -176 #1426
	lw %ra %sp 172 #1426
	lw %a0 %sp 164 #1427
	addi %a0 %a0 1 #1427
	lw %a1 %sp 20 #1427
	lw %a2 %sp 24 #1427
	lw %a11 %sp 8 #1427
	lw %a10 %a11 0 #1427
	jalr %zero %a10 0 #1427
trace_or_matrix_fast.2543:
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
	bne %a5 %a12 beq_else.100322
	jalr %zero %ra 0 #1436
beq_else.100322:
	sw %a3 %sp 8 #1435
	sw %a6 %sp 12 #1435
	sw %a2 %sp 16 #1435
	sw %a7 %sp 20 #1435
	sw %a1 %sp 24 #1435
	sw %a0 %sp 28 #1435
	addi %a12 %zero 99
	bne %a5 %a12 beq_else.100324 # nontail if
	lw %a4 %a11 4 #1423
	addi %a12 %zero -1
	bne %a4 %a12 beq_else.100326 # nontail if
	jal %zero beq_cont.100327 # then sentence ends
beq_else.100326:
	slli %a4 %a4 2 #31
	add %a12 %a10 %a4 #31
	lw %a4 %a12 0 #31
	addi %a5 %zero 0 #1426
	sw %a11 %sp 32 #1426
	add %a1 %a4 %zero
	add %a0 %a5 %zero
	add %a11 %a8 %zero
	sw %ra %sp 36 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 40 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -40 #1426
	lw %ra %sp 36 #1426
	addi %a0 %zero 2 #1427
	lw %a1 %sp 32 #1427
	lw %a2 %sp 16 #1427
	lw %a11 %sp 20 #1427
	sw %ra %sp 36 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 40 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -40 #1427
	lw %ra %sp 36 #1427
beq_cont.100327:
	jal %zero beq_cont.100325 # then sentence ends
beq_else.100324:
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
	sw %a8 %sp 36 #868
	sw %a10 %sp 40 #868
	sw %a11 %sp 32 #868
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.100328 # nontail if
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
	jal %zero beq_cont.100329 # then sentence ends
beq_else.100328:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.100330 # nontail if
	lw %f0 %a0 0 #983
	sw %a9 %sp 44 #983
	sw %a0 %sp 48 #983
	sw %ra %sp 52 #983 call dir
	addi %sp %sp 56 #983	
	jal %ra min_caml_fisneg #983
	addi %sp %sp -56 #983
	lw %ra %sp 52 #983
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100332 # nontail if
	addi %a0 %zero 0 #983
	jal %zero beq_cont.100333 # then sentence ends
beq_else.100332:
	lw %a0 %sp 48 #983
	lw %f0 %a0 0 #983
	lw %a0 %sp 44 #984
	lw %f1 %a0 12 #984
	fmul %f0 %f0 %f1 #984
	lw %a0 %sp 12 #984
	sw %f0 %a0 0 #984
	addi %a0 %zero 1 #985
beq_cont.100333:
	jal %zero beq_cont.100331 # then sentence ends
beq_else.100330:
	lw %f3 %a0 0 #992
	sw %a1 %sp 52 #993
	sw %f3 %sp 56 #993
	sw %a9 %sp 44 #993
	sw %f2 %sp 64 #993
	sw %f1 %sp 72 #993
	sw %f0 %sp 80 #993
	sw %a0 %sp 48 #993
	fadd %f0 %f3 %fzero
	sw %ra %sp 92 #993 call dir
	addi %sp %sp 96 #993	
	jal %ra min_caml_fiszero #993
	addi %sp %sp -96 #993
	lw %ra %sp 92 #993
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100334 # nontail if
	lw %a0 %sp 48 #992
	lw %f0 %a0 4 #992
	lw %f1 %sp 80 #996
	fmul %f0 %f0 %f1 #996
	lw %f1 %a0 8 #992
	lw %f2 %sp 72 #996
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %f1 %a0 12 #992
	lw %f2 %sp 64 #996
	fmul %f1 %f1 %f2 #996
	fadd %f0 %f0 %f1 #996
	lw %a1 %sp 44 #997
	lw %f1 %a1 12 #997
	sw %f0 %sp 88 #998
	sw %f1 %sp 96 #998
	sw %ra %sp 108 #998 call dir
	addi %sp %sp 112 #998	
	jal %ra min_caml_fsqr #998
	addi %sp %sp -112 #998
	lw %ra %sp 108 #998
	lw %f1 %sp 96 #998
	lw %f2 %sp 56 #998
	fmul %f1 %f2 %f1 #998
	fsub %f0 %f0 %f1 #998
	sw %f0 %sp 104 #999
	sw %ra %sp 116 #999 call dir
	addi %sp %sp 120 #999	
	jal %ra min_caml_fispos #999
	addi %sp %sp -120 #999
	lw %ra %sp 116 #999
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100336 # nontail if
	addi %a0 %zero 0 #993
	jal %zero beq_cont.100337 # then sentence ends
beq_else.100336:
	lw %a0 %sp 52 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100338 # nontail if
	lw %f0 %sp 104 #1003
	sw %ra %sp 116 #1003 call dir
	addi %sp %sp 120 #1003	
	jal %ra min_caml_sqrt #1003
	addi %sp %sp -120 #1003
	lw %ra %sp 116 #1003
	lw %f1 %sp 88 #1003
	fsub %f0 %f1 %f0 #1003
	lw %a0 %sp 48 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1003
	lw %a0 %sp 12 #1003
	sw %f0 %a0 0 #1003
	jal %zero beq_cont.100339 # then sentence ends
beq_else.100338:
	lw %f0 %sp 104 #1001
	sw %ra %sp 116 #1001 call dir
	addi %sp %sp 120 #1001	
	jal %ra min_caml_sqrt #1001
	addi %sp %sp -120 #1001
	lw %ra %sp 116 #1001
	lw %f1 %sp 88 #1001
	fadd %f0 %f1 %f0 #1001
	lw %a0 %sp 48 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1001
	lw %a0 %sp 12 #1001
	sw %f0 %a0 0 #1001
beq_cont.100339:
	addi %a0 %zero 1 #1004
beq_cont.100337:
	jal %zero beq_cont.100335 # then sentence ends
beq_else.100334:
	addi %a0 %zero 0 #993
beq_cont.100335:
beq_cont.100331:
beq_cont.100329:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100340 # nontail if
	jal %zero beq_cont.100341 # then sentence ends
beq_else.100340:
	lw %a0 %sp 12 #37
	lw %f0 %a0 0 #37
	lw %a1 %sp 8 #41
	lw %f1 %a1 0 #41
	sw %ra %sp 116 #1446 call dir
	addi %sp %sp 120 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -120 #1446
	lw %ra %sp 116 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100342 # nontail if
	jal %zero beq_cont.100343 # then sentence ends
beq_else.100342:
	lw %a0 %sp 32 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.100344 # nontail if
	jal %zero beq_cont.100345 # then sentence ends
beq_else.100344:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 16 #1426
	lw %a11 %sp 36 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	addi %a0 %zero 2 #1427
	lw %a1 %sp 32 #1427
	lw %a2 %sp 16 #1427
	lw %a11 %sp 20 #1427
	sw %ra %sp 116 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 120 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -120 #1427
	lw %ra %sp 116 #1427
beq_cont.100345:
beq_cont.100343:
beq_cont.100341:
beq_cont.100325:
	lw %a0 %sp 28 #1451
	addi %a0 %a0 1 #1451
	slli %a1 %a0 2 #1433
	lw %a2 %sp 24 #1433
	add %a12 %a2 %a1 #1433
	lw %a1 %a12 0 #1433
	lw %a3 %a1 0 #1434
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.100346
	jalr %zero %ra 0 #1436
beq_else.100346:
	sw %a0 %sp 112 #1435
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.100348 # nontail if
	addi %a3 %zero 1 #1439
	lw %a4 %sp 16 #1439
	lw %a11 %sp 20 #1439
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1439 call cls
	lw %a10 %a11 0 #1439
	addi %sp %sp 120 #1439	
	jalr %ra %a10 0 #1439
	addi %sp %sp -120 #1439
	lw %ra %sp 116 #1439
	jal %zero beq_cont.100349 # then sentence ends
beq_else.100348:
	lw %a4 %sp 16 #1443
	lw %a11 %sp 4 #1443
	sw %a1 %sp 116 #1443
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 128 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -128 #1443
	lw %ra %sp 124 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100350 # nontail if
	jal %zero beq_cont.100351 # then sentence ends
beq_else.100350:
	lw %a0 %sp 12 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 8 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 124 #1446 call dir
	addi %sp %sp 128 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -128 #1446
	lw %ra %sp 124 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100352 # nontail if
	jal %zero beq_cont.100353 # then sentence ends
beq_else.100352:
	addi %a0 %zero 1 #1447
	lw %a1 %sp 116 #1447
	lw %a2 %sp 16 #1447
	lw %a11 %sp 20 #1447
	sw %ra %sp 124 #1447 call cls
	lw %a10 %a11 0 #1447
	addi %sp %sp 128 #1447	
	jalr %ra %a10 0 #1447
	addi %sp %sp -128 #1447
	lw %ra %sp 124 #1447
beq_cont.100353:
beq_cont.100351:
beq_cont.100349:
	lw %a0 %sp 112 #1451
	addi %a0 %a0 1 #1451
	lw %a1 %sp 24 #1451
	lw %a2 %sp 16 #1451
	lw %a11 %sp 0 #1451
	lw %a10 %a11 0 #1451
	jalr %zero %a10 0 #1451
get_nvector_second.2553:
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
	sw %a1 %sp 0 #824
	sw %a0 %sp 4 #824
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100354 # nontail if
	sw %f3 %a1 0 #1501
	sw %f4 %a1 4 #1502
	sw %f5 %a1 8 #1503
	jal %zero beq_cont.100355 # then sentence ends
beq_else.100354:
	lw %a2 %a0 36 #416
	lw %f6 %a2 8 #421
	fmul %f6 %f1 %f6 #1505
	lw %a2 %a0 36 #406
	lw %f7 %a2 4 #411
	fmul %f7 %f2 %f7 #1505
	fadd %f6 %f6 %f7 #1505
	sw %f5 %sp 8 #1505
	sw %f1 %sp 16 #1505
	sw %f4 %sp 24 #1505
	sw %f2 %sp 32 #1505
	sw %f0 %sp 40 #1505
	sw %f3 %sp 48 #1505
	fadd %f0 %f6 %fzero
	sw %ra %sp 60 #1505 call dir
	addi %sp %sp 64 #1505	
	jal %ra min_caml_fhalf #1505
	addi %sp %sp -64 #1505
	lw %ra %sp 60 #1505
	lw %f1 %sp 48 #1505
	fadd %f0 %f1 %f0 #1505
	lw %a0 %sp 0 #1505
	sw %f0 %a0 0 #1505
	lw %a1 %sp 4 #416
	lw %a2 %a1 36 #416
	lw %f0 %a2 8 #421
	lw %f1 %sp 40 #1506
	fmul %f0 %f1 %f0 #1506
	lw %a2 %a1 36 #396
	lw %f2 %a2 0 #401
	lw %f3 %sp 32 #1506
	fmul %f2 %f3 %f2 #1506
	fadd %f0 %f0 %f2 #1506
	sw %ra %sp 60 #1506 call dir
	addi %sp %sp 64 #1506	
	jal %ra min_caml_fhalf #1506
	addi %sp %sp -64 #1506
	lw %ra %sp 60 #1506
	lw %f1 %sp 24 #1506
	fadd %f0 %f1 %f0 #1506
	lw %a0 %sp 0 #1506
	sw %f0 %a0 4 #1506
	lw %a1 %sp 4 #406
	lw %a2 %a1 36 #406
	lw %f0 %a2 4 #411
	lw %f1 %sp 40 #1507
	fmul %f0 %f1 %f0 #1507
	lw %a2 %a1 36 #396
	lw %f1 %a2 0 #401
	lw %f2 %sp 16 #1507
	fmul %f1 %f2 %f1 #1507
	fadd %f0 %f0 %f1 #1507
	sw %ra %sp 60 #1507 call dir
	addi %sp %sp 64 #1507	
	jal %ra min_caml_fhalf #1507
	addi %sp %sp -64 #1507
	lw %ra %sp 60 #1507
	lw %f1 %sp 8 #1507
	fadd %f0 %f1 %f0 #1507
	lw %a0 %sp 0 #1507
	sw %f0 %a0 8 #1507
beq_cont.100355:
	lw %a0 %sp 4 #258
	lw %a0 %a0 24 #258
	lw %a1 %sp 0 #172
	lw %f0 %a1 0 #172
	sw %a0 %sp 56 #172
	sw %ra %sp 60 #172 call dir
	addi %sp %sp 64 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -64 #172
	lw %ra %sp 60 #172
	lw %a0 %sp 0 #172
	lw %f1 %a0 4 #172
	sw %f0 %sp 64 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #172 call dir
	addi %sp %sp 80 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -80 #172
	lw %ra %sp 76 #172
	lw %f1 %sp 64 #172
	fadd %f0 %f1 %f0 #172
	lw %a0 %sp 0 #172
	lw %f1 %a0 8 #172
	sw %f0 %sp 72 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #172 call dir
	addi %sp %sp 88 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -88 #172
	lw %ra %sp 84 #172
	lw %f1 %sp 72 #172
	fadd %f0 %f1 %f0 #172
	sw %ra %sp 84 #172 call dir
	addi %sp %sp 88 #172	
	jal %ra min_caml_sqrt #172
	addi %sp %sp -88 #172
	lw %ra %sp 84 #172
	sw %f0 %sp 80 #173
	sw %ra %sp 92 #173 call dir
	addi %sp %sp 96 #173	
	jal %ra min_caml_fiszero #173
	addi %sp %sp -96 #173
	lw %ra %sp 92 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100357 # nontail if
	lw %a0 %sp 56 #105
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100359 # nontail if
	li %f0 l.90464 #173
	lw %f1 %sp 80 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.100360 # then sentence ends
beq_else.100359:
	li %f0 l.90466 #173
	lw %f1 %sp 80 #173
	fdiv %f0 %f0 %f1 #173
beq_cont.100360:
	jal %zero beq_cont.100358 # then sentence ends
beq_else.100357:
	li %f0 l.90464 #173
beq_cont.100358:
	lw %a0 %sp 0 #172
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
utexture.2558:
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
	bne %a3 %a12 beq_else.100362
	lw %f0 %a1 0 #1536
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1536
	li %f1 l.91786 #1538
	fmul %f1 %f0 %f1 #1538
	sw %a2 %sp 0 #1538
	sw %a0 %sp 4 #1538
	sw %a1 %sp 8 #1538
	sw %f0 %sp 16 #1538
	fadd %f0 %f1 %fzero
	sw %ra %sp 28 #1538 call dir
	addi %sp %sp 32 #1538	
	jal %ra min_caml_floor #1538
	addi %sp %sp -32 #1538
	lw %ra %sp 28 #1538
	li %f1 l.91788 #1538
	fmul %f0 %f0 %f1 #1538
	lw %f1 %sp 16 #1539
	fsub %f0 %f1 %f0 #1539
	li %f1 l.91768 #1539
	sw %ra %sp 28 #1539 call dir
	addi %sp %sp 32 #1539	
	jal %ra min_caml_fless #1539
	addi %sp %sp -32 #1539
	lw %ra %sp 28 #1539
	lw %a1 %sp 8 #1536
	lw %f0 %a1 8 #1536
	lw %a1 %sp 4 #336
	lw %a1 %a1 20 #336
	lw %f1 %a1 8 #341
	fsub %f0 %f0 %f1 #1541
	li %f1 l.91786 #1543
	fmul %f1 %f0 %f1 #1543
	sw %a0 %sp 24 #1543
	sw %f0 %sp 32 #1543
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #1543 call dir
	addi %sp %sp 48 #1543	
	jal %ra min_caml_floor #1543
	addi %sp %sp -48 #1543
	lw %ra %sp 44 #1543
	li %f1 l.91788 #1543
	fmul %f0 %f0 %f1 #1543
	lw %f1 %sp 32 #1544
	fsub %f0 %f1 %f0 #1544
	li %f1 l.91768 #1544
	sw %ra %sp 44 #1544 call dir
	addi %sp %sp 48 #1544	
	jal %ra min_caml_fless #1544
	addi %sp %sp -48 #1544
	lw %ra %sp 44 #1544
	lw %a1 %sp 24 #788
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100365 # nontail if
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100367 # nontail if
	li %f0 l.91759 #1549
	jal %zero beq_cont.100368 # then sentence ends
beq_else.100367:
	li %f0 l.90390 #1549
beq_cont.100368:
	jal %zero beq_cont.100366 # then sentence ends
beq_else.100365:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100369 # nontail if
	li %f0 l.90390 #1548
	jal %zero beq_cont.100370 # then sentence ends
beq_else.100369:
	li %f0 l.91759 #1548
beq_cont.100370:
beq_cont.100366:
	lw %a0 %sp 0 #1546
	sw %f0 %a0 4 #1546
	jalr %zero %ra 0 #1546
beq_else.100362:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.100372
	lw %f0 %a1 4 #1536
	li %f1 l.91777 #1554
	fmul %f0 %f0 %f1 #1554
	sw %a2 %sp 0 #1554
	sw %ra %sp 44 #1554 call dir
	addi %sp %sp 48 #1554	
	jal %ra min_caml_sin #1554
	addi %sp %sp -48 #1554
	lw %ra %sp 44 #1554
	sw %ra %sp 44 #1554 call dir
	addi %sp %sp 48 #1554	
	jal %ra min_caml_fsqr #1554
	addi %sp %sp -48 #1554
	lw %ra %sp 44 #1554
	li %f1 l.91759 #1555
	fmul %f1 %f1 %f0 #1555
	lw %a0 %sp 0 #1555
	sw %f1 %a0 0 #1555
	li %f1 l.91759 #1556
	li %f2 l.90464 #1556
	fsub %f0 %f2 %f0 #1556
	fmul %f0 %f1 %f0 #1556
	sw %f0 %a0 4 #1556
	jalr %zero %ra 0 #1556
beq_else.100372:
	addi %a12 %zero 3
	bne %a3 %a12 beq_else.100374
	lw %f0 %a1 0 #1536
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1561
	lw %f1 %a1 8 #1536
	lw %a0 %a0 20 #336
	lw %f2 %a0 8 #341
	fsub %f1 %f1 %f2 #1562
	sw %a2 %sp 0 #1563
	sw %f1 %sp 40 #1563
	sw %ra %sp 52 #1563 call dir
	addi %sp %sp 56 #1563	
	jal %ra min_caml_fsqr #1563
	addi %sp %sp -56 #1563
	lw %ra %sp 52 #1563
	lw %f1 %sp 40 #1563
	sw %f0 %sp 48 #1563
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #1563 call dir
	addi %sp %sp 64 #1563	
	jal %ra min_caml_fsqr #1563
	addi %sp %sp -64 #1563
	lw %ra %sp 60 #1563
	lw %f1 %sp 48 #1563
	fadd %f0 %f1 %f0 #1563
	sw %ra %sp 60 #1563 call dir
	addi %sp %sp 64 #1563	
	jal %ra min_caml_sqrt #1563
	addi %sp %sp -64 #1563
	lw %ra %sp 60 #1563
	li %f1 l.91768 #1563
	fdiv %f0 %f0 %f1 #1563
	sw %f0 %sp 56 #1564
	sw %ra %sp 68 #1564 call dir
	addi %sp %sp 72 #1564	
	jal %ra min_caml_floor #1564
	addi %sp %sp -72 #1564
	lw %ra %sp 68 #1564
	lw %f1 %sp 56 #1564
	fsub %f0 %f1 %f0 #1564
	li %f1 l.91744 #1564
	fmul %f0 %f0 %f1 #1564
	sw %ra %sp 68 #1565 call dir
	addi %sp %sp 72 #1565	
	jal %ra min_caml_cos #1565
	addi %sp %sp -72 #1565
	lw %ra %sp 68 #1565
	sw %ra %sp 68 #1565 call dir
	addi %sp %sp 72 #1565	
	jal %ra min_caml_fsqr #1565
	addi %sp %sp -72 #1565
	lw %ra %sp 68 #1565
	li %f1 l.91759 #1566
	fmul %f1 %f0 %f1 #1566
	lw %a0 %sp 0 #1566
	sw %f1 %a0 4 #1566
	li %f1 l.90464 #1567
	fsub %f0 %f1 %f0 #1567
	li %f1 l.91759 #1567
	fmul %f0 %f0 %f1 #1567
	sw %f0 %a0 8 #1567
	jalr %zero %ra 0 #1567
beq_else.100374:
	addi %a12 %zero 4
	bne %a3 %a12 beq_else.100376
	lw %f0 %a1 0 #1536
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1571
	lw %a3 %a0 16 #276
	lw %f1 %a3 0 #281
	sw %a2 %sp 0 #1571
	sw %a0 %sp 4 #1571
	sw %a1 %sp 8 #1571
	sw %f0 %sp 64 #1571
	fadd %f0 %f1 %fzero
	sw %ra %sp 76 #1571 call dir
	addi %sp %sp 80 #1571	
	jal %ra min_caml_sqrt #1571
	addi %sp %sp -80 #1571
	lw %ra %sp 76 #1571
	lw %f1 %sp 64 #1571
	fmul %f0 %f1 %f0 #1571
	lw %a0 %sp 8 #1536
	lw %f1 %a0 8 #1536
	lw %a1 %sp 4 #336
	lw %a2 %a1 20 #336
	lw %f2 %a2 8 #341
	fsub %f1 %f1 %f2 #1572
	lw %a2 %a1 16 #296
	lw %f2 %a2 8 #301
	sw %f0 %sp 72 #1572
	sw %f1 %sp 80 #1572
	fadd %f0 %f2 %fzero
	sw %ra %sp 92 #1572 call dir
	addi %sp %sp 96 #1572	
	jal %ra min_caml_sqrt #1572
	addi %sp %sp -96 #1572
	lw %ra %sp 92 #1572
	lw %f1 %sp 80 #1572
	fmul %f0 %f1 %f0 #1572
	lw %f1 %sp 72 #1573
	sw %f0 %sp 88 #1573
	fadd %f0 %f1 %fzero
	sw %ra %sp 100 #1573 call dir
	addi %sp %sp 104 #1573	
	jal %ra min_caml_fsqr #1573
	addi %sp %sp -104 #1573
	lw %ra %sp 100 #1573
	lw %f1 %sp 88 #1573
	sw %f0 %sp 96 #1573
	fadd %f0 %f1 %fzero
	sw %ra %sp 108 #1573 call dir
	addi %sp %sp 112 #1573	
	jal %ra min_caml_fsqr #1573
	addi %sp %sp -112 #1573
	lw %ra %sp 108 #1573
	lw %f1 %sp 96 #1573
	fadd %f0 %f1 %f0 #1573
	lw %f1 %sp 72 #1575
	sw %f0 %sp 104 #1575
	fadd %f0 %f1 %fzero
	sw %ra %sp 116 #1575 call dir
	addi %sp %sp 120 #1575	
	jal %ra min_caml_fabs #1575
	addi %sp %sp -120 #1575
	lw %ra %sp 116 #1575
	li %f1 l.91738 #1575
	sw %ra %sp 116 #1575 call dir
	addi %sp %sp 120 #1575	
	jal %ra min_caml_fless #1575
	addi %sp %sp -120 #1575
	lw %ra %sp 116 #1575
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100377 # nontail if
	lw %f0 %sp 72 #1578
	lw %f1 %sp 88 #1578
	fdiv %f0 %f1 %f0 #1578
	sw %ra %sp 116 #1578 call dir
	addi %sp %sp 120 #1578	
	jal %ra min_caml_fabs #1578
	addi %sp %sp -120 #1578
	lw %ra %sp 116 #1578
	sw %ra %sp 116 #1580 call dir
	addi %sp %sp 120 #1580	
	jal %ra min_caml_atan #1580
	addi %sp %sp -120 #1580
	lw %ra %sp 116 #1580
	li %f1 l.91742 #1580
	fmul %f0 %f0 %f1 #1580
	li %f1 l.91744 #1580
	fdiv %f0 %f0 %f1 #1580
	jal %zero beq_cont.100378 # then sentence ends
beq_else.100377:
	li %f0 l.91740 #1576
beq_cont.100378:
	sw %f0 %sp 112 #1582
	sw %ra %sp 124 #1582 call dir
	addi %sp %sp 128 #1582	
	jal %ra min_caml_floor #1582
	addi %sp %sp -128 #1582
	lw %ra %sp 124 #1582
	lw %f1 %sp 112 #1582
	fsub %f0 %f1 %f0 #1582
	lw %a0 %sp 8 #1536
	lw %f1 %a0 4 #1536
	lw %a0 %sp 4 #326
	lw %a1 %a0 20 #326
	lw %f2 %a1 4 #331
	fsub %f1 %f1 %f2 #1584
	lw %a0 %a0 16 #286
	lw %f2 %a0 4 #291
	sw %f0 %sp 120 #1584
	sw %f1 %sp 128 #1584
	fadd %f0 %f2 %fzero
	sw %ra %sp 140 #1584 call dir
	addi %sp %sp 144 #1584	
	jal %ra min_caml_sqrt #1584
	addi %sp %sp -144 #1584
	lw %ra %sp 140 #1584
	lw %f1 %sp 128 #1584
	fmul %f0 %f1 %f0 #1584
	lw %f1 %sp 104 #1586
	sw %f0 %sp 136 #1586
	fadd %f0 %f1 %fzero
	sw %ra %sp 148 #1586 call dir
	addi %sp %sp 152 #1586	
	jal %ra min_caml_fabs #1586
	addi %sp %sp -152 #1586
	lw %ra %sp 148 #1586
	li %f1 l.91738 #1586
	sw %ra %sp 148 #1586 call dir
	addi %sp %sp 152 #1586	
	jal %ra min_caml_fless #1586
	addi %sp %sp -152 #1586
	lw %ra %sp 148 #1586
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100379 # nontail if
	lw %f0 %sp 104 #1589
	lw %f1 %sp 136 #1589
	fdiv %f0 %f1 %f0 #1589
	sw %ra %sp 148 #1589 call dir
	addi %sp %sp 152 #1589	
	jal %ra min_caml_fabs #1589
	addi %sp %sp -152 #1589
	lw %ra %sp 148 #1589
	sw %ra %sp 148 #1590 call dir
	addi %sp %sp 152 #1590	
	jal %ra min_caml_atan #1590
	addi %sp %sp -152 #1590
	lw %ra %sp 148 #1590
	li %f1 l.91742 #1590
	fmul %f0 %f0 %f1 #1590
	li %f1 l.91744 #1590
	fdiv %f0 %f0 %f1 #1590
	jal %zero beq_cont.100380 # then sentence ends
beq_else.100379:
	li %f0 l.91740 #1587
beq_cont.100380:
	sw %f0 %sp 144 #1592
	sw %ra %sp 156 #1592 call dir
	addi %sp %sp 160 #1592	
	jal %ra min_caml_floor #1592
	addi %sp %sp -160 #1592
	lw %ra %sp 156 #1592
	lw %f1 %sp 144 #1592
	fsub %f0 %f1 %f0 #1592
	li %f1 l.91753 #1593
	li %f2 l.91755 #1593
	lw %f3 %sp 120 #1593
	fsub %f2 %f2 %f3 #1593
	sw %f0 %sp 152 #1593
	sw %f1 %sp 160 #1593
	fadd %f0 %f2 %fzero
	sw %ra %sp 172 #1593 call dir
	addi %sp %sp 176 #1593	
	jal %ra min_caml_fsqr #1593
	addi %sp %sp -176 #1593
	lw %ra %sp 172 #1593
	lw %f1 %sp 160 #1593
	fsub %f0 %f1 %f0 #1593
	li %f1 l.91755 #1593
	lw %f2 %sp 152 #1593
	fsub %f1 %f1 %f2 #1593
	sw %f0 %sp 168 #1593
	fadd %f0 %f1 %fzero
	sw %ra %sp 180 #1593 call dir
	addi %sp %sp 184 #1593	
	jal %ra min_caml_fsqr #1593
	addi %sp %sp -184 #1593
	lw %ra %sp 180 #1593
	lw %f1 %sp 168 #1593
	fsub %f0 %f1 %f0 #1593
	sw %f0 %sp 176 #1594
	sw %ra %sp 188 #1594 call dir
	addi %sp %sp 192 #1594	
	jal %ra min_caml_fisneg #1594
	addi %sp %sp -192 #1594
	lw %ra %sp 188 #1594
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100381 # nontail if
	lw %f0 %sp 176 #1593
	jal %zero beq_cont.100382 # then sentence ends
beq_else.100381:
	li %f0 l.90390 #1594
beq_cont.100382:
	li %f1 l.91759 #1595
	fmul %f0 %f1 %f0 #1595
	li %f1 l.91761 #1595
	fdiv %f0 %f0 %f1 #1595
	lw %a0 %sp 0 #1595
	sw %f0 %a0 8 #1595
	jalr %zero %ra 0 #1595
beq_else.100376:
	jalr %zero %ra 0 #1597
trace_reflections.2565:
	lw %a2 %a11 68 #1620
	lw %a3 %a11 64 #1620
	lw %a4 %a11 60 #1620
	lw %a5 %a11 56 #1620
	lw %a6 %a11 52 #1620
	lw %a7 %a11 48 #1620
	lw %a8 %a11 44 #1620
	lw %a9 %a11 40 #1620
	lw %a10 %a11 36 #1620
	sw %a5 %sp 0 #1620
	lw %a5 %a11 32 #1620
	sw %a8 %sp 4 #1620
	lw %a8 %a11 28 #1620
	sw %a4 %sp 8 #1620
	lw %a4 %a11 24 #1620
	sw %a5 %sp 12 #1620
	lw %a5 %a11 20 #1620
	sw %a1 %sp 16 #1620
	lw %a1 %a11 16 #1620
	sw %a5 %sp 20 #1620
	lw %a5 %a11 12 #1620
	sw %a9 %sp 24 #1620
	lw %a9 %a11 8 #1620
	sw %a11 %sp 28 #1620
	lw %a11 %a11 4 #1620
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100385
	sw %a0 %sp 32 #95
	slli %a0 %a0 2 #95
	add %a12 %a8 %a0 #95
	lw %a0 %a12 0 #95
	sw %a8 %sp 36 #527
	lw %a8 %a0 4 #527
	li %f2 l.91802 #1458
	sw %f2 %a3 0 #1458
	sw %a10 %sp 40 #1459
	addi %a10 %zero 0 #1459
	sw %a7 %sp 44 #33
	lw %a7 %a4 0 #33
	sw %a2 %sp 48 #1459
	sw %f1 %sp 56 #1459
	sw %f0 %sp 64 #1459
	sw %a8 %sp 72 #1459
	sw %a9 %sp 76 #1459
	sw %a1 %sp 80 #1459
	sw %a6 %sp 84 #1459
	sw %a4 %sp 88 #1459
	sw %a0 %sp 92 #1459
	sw %a5 %sp 96 #1459
	sw %a11 %sp 100 #1459
	sw %a3 %sp 104 #1459
	add %a1 %a7 %zero
	add %a0 %a10 %zero
	add %a11 %a2 %zero
	add %a2 %a8 %zero
	sw %ra %sp 108 #1459 call cls
	lw %a10 %a11 0 #1459
	addi %sp %sp 112 #1459	
	jalr %ra %a10 0 #1459
	addi %sp %sp -112 #1459
	lw %ra %sp 108 #1459
	lw %a0 %sp 104 #41
	lw %f1 %a0 0 #41
	li %f0 l.91269 #1462
	sw %f1 %sp 112 #1462
	sw %ra %sp 124 #1462 call dir
	addi %sp %sp 128 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -128 #1462
	lw %ra %sp 124 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100388 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.100389 # then sentence ends
beq_else.100388:
	li %f1 l.91808 #1463
	lw %f0 %sp 112 #1463
	sw %ra %sp 124 #1463 call dir
	addi %sp %sp 128 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -128 #1463
	lw %ra %sp 124 #1463
beq_cont.100389:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100390 # nontail if
	jal %zero beq_cont.100391 # then sentence ends
beq_else.100390:
	lw %a0 %sp 100 #45
	lw %a1 %a0 0 #45
	addi %a2 %zero 4 #1628
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 124 #1628 call dir
	addi %sp %sp 128 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -128 #1628
	lw %ra %sp 124 #1628
	lw %a1 %sp 96 #39
	lw %a2 %a1 0 #39
	add %a0 %a0 %a2 #1628
	lw %a2 %sp 92 #521
	lw %a3 %a2 0 #521
	bne %a0 %a3 beq_else.100392 # nontail if
	lw %a0 %sp 88 #33
	lw %a3 %a0 0 #33
	lw %a4 %a3 0 #1257
	lw %a5 %a4 0 #1258
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.100394 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.100395 # then sentence ends
beq_else.100394:
	sw %a4 %sp 120 #1259
	sw %a3 %sp 124 #1259
	addi %a12 %zero 99
	bne %a5 %a12 beq_else.100396 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.100397 # then sentence ends
beq_else.100396:
	lw %a6 %sp 80 #1266
	lw %a7 %sp 76 #1266
	lw %a11 %sp 84 #1266
	add %a2 %a7 %zero
	add %a1 %a6 %zero
	add %a0 %a5 %zero
	sw %ra %sp 132 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 136 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -136 #1266
	lw %ra %sp 132 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100398 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100399 # then sentence ends
beq_else.100398:
	lw %a0 %sp 44 #37
	lw %f0 %a0 0 #37
	li %f1 l.91269 #1270
	sw %ra %sp 132 #1270 call dir
	addi %sp %sp 136 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -136 #1270
	lw %ra %sp 132 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100400 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100401 # then sentence ends
beq_else.100400:
	addi %a0 %zero 1 #1271
	lw %a1 %sp 120 #1271
	lw %a11 %sp 40 #1271
	sw %ra %sp 132 #1271 call cls
	lw %a10 %a11 0 #1271
	addi %sp %sp 136 #1271	
	jalr %ra %a10 0 #1271
	addi %sp %sp -136 #1271
	lw %ra %sp 132 #1271
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100402 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100403 # then sentence ends
beq_else.100402:
	addi %a0 %zero 1 #1272
beq_cont.100403:
beq_cont.100401:
beq_cont.100399:
beq_cont.100397:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100404 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 124 #1282
	lw %a11 %sp 24 #1282
	sw %ra %sp 132 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 136 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -136 #1282
	lw %ra %sp 132 #1282
	jal %zero beq_cont.100405 # then sentence ends
beq_else.100404:
	addi %a0 %zero 1 #1277
	lw %a1 %sp 120 #1277
	lw %a11 %sp 40 #1277
	sw %ra %sp 132 #1277 call cls
	lw %a10 %a11 0 #1277
	addi %sp %sp 136 #1277	
	jalr %ra %a10 0 #1277
	addi %sp %sp -136 #1277
	lw %ra %sp 132 #1277
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100406 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 124 #1280
	lw %a11 %sp 24 #1280
	sw %ra %sp 132 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 136 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -136 #1280
	lw %ra %sp 132 #1280
	jal %zero beq_cont.100407 # then sentence ends
beq_else.100406:
	addi %a0 %zero 1 #1278
beq_cont.100407:
beq_cont.100405:
beq_cont.100395:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100408 # nontail if
	lw %a0 %sp 72 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 20 #181
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
	lw %a1 %sp 92 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 64 #1635
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
	sw %f1 %sp 128 #1606
	sw %f0 %sp 136 #1606
	sw %ra %sp 148 #1606 call dir
	addi %sp %sp 152 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -152 #1606
	lw %ra %sp 148 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100410 # nontail if
	jal %zero beq_cont.100411 # then sentence ends
beq_else.100410:
	lw %a0 %sp 12 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 8 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 136 #191
	fmul %f1 %f2 %f1 #191
	fadd %f0 %f0 %f1 #191
	sw %f0 %a0 0 #191
	lw %f0 %a0 4 #191
	lw %f1 %a1 4 #191
	fmul %f1 %f2 %f1 #192
	fadd %f0 %f0 %f1 #192
	sw %f0 %a0 4 #192
	lw %f0 %a0 8 #191
	lw %f1 %a1 8 #191
	fmul %f1 %f2 %f1 #193
	fadd %f0 %f0 %f1 #193
	sw %f0 %a0 8 #193
beq_cont.100411:
	lw %f0 %sp 128 #1611
	sw %ra %sp 148 #1611 call dir
	addi %sp %sp 152 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -152 #1611
	lw %ra %sp 148 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100412 # nontail if
	jal %zero beq_cont.100413 # then sentence ends
beq_else.100412:
	lw %f0 %sp 128 #1612
	sw %ra %sp 148 #1612 call dir
	addi %sp %sp 152 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -152 #1612
	lw %ra %sp 148 #1612
	sw %ra %sp 148 #1612 call dir
	addi %sp %sp 152 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -152 #1612
	lw %ra %sp 148 #1612
	lw %f1 %sp 56 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 12 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.100413:
	jal %zero beq_cont.100409 # then sentence ends
beq_else.100408:
beq_cont.100409:
	jal %zero beq_cont.100393 # then sentence ends
beq_else.100392:
beq_cont.100393:
beq_cont.100391:
	lw %a0 %sp 32 #1641
	addi %a0 %a0 -1 #1641
	addi %a1 %zero 0 #1622
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100414
	slli %a2 %a0 2 #95
	lw %a3 %sp 36 #95
	add %a12 %a3 %a2 #95
	lw %a2 %a12 0 #95
	lw %a3 %a2 4 #527
	li %f0 l.91802 #1458
	lw %a4 %sp 104 #1458
	sw %f0 %a4 0 #1458
	lw %a5 %sp 88 #33
	lw %a6 %a5 0 #33
	lw %a7 %a6 0 #1433
	lw %a8 %a7 0 #1434
	sw %a0 %sp 144 #1435
	sw %a3 %sp 148 #1435
	sw %a1 %sp 152 #1435
	sw %a2 %sp 156 #1435
	addi %a12 %zero -1
	bne %a8 %a12 beq_else.100415 # nontail if
	jal %zero beq_cont.100416 # then sentence ends
beq_else.100415:
	sw %a6 %sp 160 #1435
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.100417 # nontail if
	addi %a8 %zero 1 #1439
	lw %a11 %sp 4 #1439
	add %a2 %a3 %zero
	add %a1 %a7 %zero
	add %a0 %a8 %zero
	sw %ra %sp 164 #1439 call cls
	lw %a10 %a11 0 #1439
	addi %sp %sp 168 #1439	
	jalr %ra %a10 0 #1439
	addi %sp %sp -168 #1439
	lw %ra %sp 164 #1439
	jal %zero beq_cont.100418 # then sentence ends
beq_else.100417:
	lw %a11 %sp 0 #1443
	sw %a7 %sp 164 #1443
	add %a1 %a3 %zero
	add %a0 %a8 %zero
	sw %ra %sp 172 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 176 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -176 #1443
	lw %ra %sp 172 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100419 # nontail if
	jal %zero beq_cont.100420 # then sentence ends
beq_else.100419:
	lw %a0 %sp 44 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 104 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 172 #1446 call dir
	addi %sp %sp 176 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -176 #1446
	lw %ra %sp 172 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100421 # nontail if
	jal %zero beq_cont.100422 # then sentence ends
beq_else.100421:
	addi %a0 %zero 1 #1447
	lw %a1 %sp 164 #1447
	lw %a2 %sp 148 #1447
	lw %a11 %sp 4 #1447
	sw %ra %sp 172 #1447 call cls
	lw %a10 %a11 0 #1447
	addi %sp %sp 176 #1447	
	jalr %ra %a10 0 #1447
	addi %sp %sp -176 #1447
	lw %ra %sp 172 #1447
beq_cont.100422:
beq_cont.100420:
beq_cont.100418:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 160 #1451
	lw %a2 %sp 148 #1451
	lw %a11 %sp 48 #1451
	sw %ra %sp 172 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 176 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -176 #1451
	lw %ra %sp 172 #1451
beq_cont.100416:
	lw %a0 %sp 104 #41
	lw %f1 %a0 0 #41
	li %f0 l.91269 #1462
	sw %f1 %sp 168 #1462
	sw %ra %sp 180 #1462 call dir
	addi %sp %sp 184 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -184 #1462
	lw %ra %sp 180 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100423 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.100424 # then sentence ends
beq_else.100423:
	li %f1 l.91808 #1463
	lw %f0 %sp 168 #1463
	sw %ra %sp 180 #1463 call dir
	addi %sp %sp 184 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -184 #1463
	lw %ra %sp 180 #1463
beq_cont.100424:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100425 # nontail if
	jal %zero beq_cont.100426 # then sentence ends
beq_else.100425:
	lw %a0 %sp 100 #45
	lw %a0 %a0 0 #45
	addi %a1 %zero 4 #1628
	sw %ra %sp 180 #1628 call dir
	addi %sp %sp 184 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -184 #1628
	lw %ra %sp 180 #1628
	lw %a1 %sp 96 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1628
	lw %a1 %sp 156 #521
	lw %a2 %a1 0 #521
	bne %a0 %a2 beq_else.100427 # nontail if
	lw %a0 %sp 88 #33
	lw %a0 %a0 0 #33
	lw %a2 %sp 152 #1631
	lw %a11 %sp 24 #1631
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 180 #1631 call cls
	lw %a10 %a11 0 #1631
	addi %sp %sp 184 #1631	
	jalr %ra %a10 0 #1631
	addi %sp %sp -184 #1631
	lw %ra %sp 180 #1631
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100429 # nontail if
	lw %a0 %sp 148 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 20 #181
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
	lw %a1 %sp 156 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 64 #1635
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
	sw %f1 %sp 176 #1606
	sw %f0 %sp 184 #1606
	sw %ra %sp 196 #1606 call dir
	addi %sp %sp 200 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -200 #1606
	lw %ra %sp 196 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100431 # nontail if
	jal %zero beq_cont.100432 # then sentence ends
beq_else.100431:
	lw %a0 %sp 12 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 8 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 184 #191
	fmul %f1 %f2 %f1 #191
	fadd %f0 %f0 %f1 #191
	sw %f0 %a0 0 #191
	lw %f0 %a0 4 #191
	lw %f1 %a1 4 #191
	fmul %f1 %f2 %f1 #192
	fadd %f0 %f0 %f1 #192
	sw %f0 %a0 4 #192
	lw %f0 %a0 8 #191
	lw %f1 %a1 8 #191
	fmul %f1 %f2 %f1 #193
	fadd %f0 %f0 %f1 #193
	sw %f0 %a0 8 #193
beq_cont.100432:
	lw %f0 %sp 176 #1611
	sw %ra %sp 196 #1611 call dir
	addi %sp %sp 200 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -200 #1611
	lw %ra %sp 196 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100433 # nontail if
	jal %zero beq_cont.100434 # then sentence ends
beq_else.100433:
	lw %f0 %sp 176 #1612
	sw %ra %sp 196 #1612 call dir
	addi %sp %sp 200 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -200 #1612
	lw %ra %sp 196 #1612
	sw %ra %sp 196 #1612 call dir
	addi %sp %sp 200 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -200 #1612
	lw %ra %sp 196 #1612
	lw %f1 %sp 56 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 12 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.100434:
	jal %zero beq_cont.100430 # then sentence ends
beq_else.100429:
beq_cont.100430:
	jal %zero beq_cont.100428 # then sentence ends
beq_else.100427:
beq_cont.100428:
beq_cont.100426:
	lw %a0 %sp 144 #1641
	addi %a0 %a0 -1 #1641
	lw %f0 %sp 64 #1641
	lw %f1 %sp 56 #1641
	lw %a1 %sp 16 #1641
	lw %a11 %sp 28 #1641
	lw %a10 %a11 0 #1641
	jalr %zero %a10 0 #1641
bge_else.100414:
	jalr %zero %ra 0 #1642
bge_else.100385:
	jalr %zero %ra 0 #1642
trace_ray.2570:
	lw %a3 %a11 116 #1647
	lw %a4 %a11 112 #1647
	lw %a5 %a11 108 #1647
	lw %a6 %a11 104 #1647
	lw %a7 %a11 100 #1647
	lw %a8 %a11 96 #1647
	lw %a9 %a11 92 #1647
	lw %a10 %a11 88 #1647
	sw %a4 %sp 0 #1647
	lw %a4 %a11 84 #1647
	sw %a5 %sp 4 #1647
	lw %a5 %a11 80 #1647
	sw %a4 %sp 8 #1647
	lw %a4 %a11 76 #1647
	sw %a9 %sp 12 #1647
	lw %a9 %a11 72 #1647
	sw %a9 %sp 16 #1647
	lw %a9 %a11 68 #1647
	sw %a9 %sp 20 #1647
	lw %a9 %a11 64 #1647
	sw %a9 %sp 24 #1647
	lw %a9 %a11 60 #1647
	sw %a9 %sp 28 #1647
	lw %a9 %a11 56 #1647
	sw %a4 %sp 32 #1647
	lw %a4 %a11 52 #1647
	sw %a4 %sp 36 #1647
	lw %a4 %a11 48 #1647
	sw %a5 %sp 40 #1647
	lw %a5 %a11 44 #1647
	sw %a8 %sp 44 #1647
	lw %a8 %a11 40 #1647
	sw %a3 %sp 48 #1647
	lw %a3 %a11 36 #1647
	sw %a3 %sp 52 #1647
	lw %a3 %a11 32 #1647
	sw %a3 %sp 56 #1647
	lw %a3 %a11 28 #1647
	sw %a3 %sp 60 #1647
	lw %a3 %a11 24 #1647
	sw %a10 %sp 64 #1647
	lw %a10 %a11 20 #1647
	sw %a8 %sp 68 #1647
	lw %a8 %a11 16 #1647
	sw %a8 %sp 72 #1647
	lw %a8 %a11 12 #1647
	sw %a10 %sp 76 #1647
	lw %a10 %a11 8 #1647
	sw %a11 %sp 80 #1647
	lw %a11 %a11 4 #1647
	sw %a10 %sp 84 #1648
	addi %a10 %zero 4 #1648
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.100437
	sw %a2 %sp 88 #454
	lw %a2 %a2 8 #454
	li %f2 l.91802 #1369
	sw %f2 %a7 0 #1369
	sw %a10 %sp 92 #1370
	addi %a10 %zero 0 #1370
	sw %a4 %sp 96 #33
	lw %a4 %a4 0 #33
	sw %f1 %sp 104 #1370
	sw %a5 %sp 112 #1370
	sw %a8 %sp 116 #1370
	sw %a9 %sp 120 #1370
	sw %a11 %sp 124 #1370
	sw %f0 %sp 128 #1370
	sw %a3 %sp 136 #1370
	sw %a1 %sp 140 #1370
	sw %a2 %sp 144 #1370
	sw %a0 %sp 148 #1370
	sw %a7 %sp 152 #1370
	add %a2 %a1 %zero
	add %a0 %a10 %zero
	add %a11 %a6 %zero
	add %a1 %a4 %zero
	sw %ra %sp 156 #1370 call cls
	lw %a10 %a11 0 #1370
	addi %sp %sp 160 #1370	
	jalr %ra %a10 0 #1370
	addi %sp %sp -160 #1370
	lw %ra %sp 156 #1370
	lw %a0 %sp 152 #41
	lw %f1 %a0 0 #41
	li %f0 l.91269 #1373
	sw %f1 %sp 160 #1373
	sw %ra %sp 172 #1373 call dir
	addi %sp %sp 176 #1373	
	jal %ra min_caml_fless #1373
	addi %sp %sp -176 #1373
	lw %ra %sp 172 #1373
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100440 # nontail if
	addi %a0 %zero 0 #1373
	jal %zero beq_cont.100441 # then sentence ends
beq_else.100440:
	li %f1 l.91808 #1374
	lw %f0 %sp 160 #1374
	sw %ra %sp 172 #1374 call dir
	addi %sp %sp 176 #1374	
	jal %ra min_caml_fless #1374
	addi %sp %sp -176 #1374
	lw %ra %sp 172 #1374
beq_cont.100441:
	addi %a1 %zero 0 #1650
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100442
	addi %a0 %zero -1 #1713
	lw %a1 %sp 148 #1713
	slli %a2 %a1 2 #1713
	lw %a3 %sp 144 #1713
	add %a12 %a3 %a2 #1713
	sw %a0 %a12 0 #1713
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100443
	jalr %zero %ra 0 #1727
beq_else.100443:
	lw %a0 %sp 140 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 136 #181
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
	sw %ra %sp 172 #1716 call dir
	addi %sp %sp 176 #1716	
	jal %ra min_caml_fneg #1716
	addi %sp %sp -176 #1716
	lw %ra %sp 172 #1716
	sw %f0 %sp 168 #1718
	sw %ra %sp 180 #1718 call dir
	addi %sp %sp 184 #1718	
	jal %ra min_caml_fispos #1718
	addi %sp %sp -184 #1718
	lw %ra %sp 180 #1718
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100445
	jalr %zero %ra 0 #1726
beq_else.100445:
	lw %f0 %sp 168 #1721
	sw %ra %sp 180 #1721 call dir
	addi %sp %sp 184 #1721	
	jal %ra min_caml_fsqr #1721
	addi %sp %sp -184 #1721
	lw %ra %sp 180 #1721
	lw %f1 %sp 168 #1721
	fmul %f0 %f0 %f1 #1721
	lw %f1 %sp 128 #1721
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 124 #29
	lw %f1 %a0 0 #29
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 120 #54
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
beq_else.100442:
	lw %a0 %sp 116 #45
	lw %a2 %a0 0 #45
	slli %a3 %a2 2 #20
	lw %a4 %sp 112 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %a3 8 #248
	lw %a5 %a3 28 #346
	lw %f0 %a5 0 #351
	lw %f1 %sp 128 #1655
	fmul %f0 %f0 %f1 #1655
	lw %a5 %a3 4 #238
	sw %a4 %sp 176 #868
	sw %a1 %sp 180 #868
	sw %f0 %sp 184 #868
	sw %a2 %sp 192 #868
	sw %a3 %sp 196 #868
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.100448 # nontail if
	lw %a5 %sp 76 #39
	lw %a6 %a5 0 #39
	li %f2 l.90390 #147
	lw %a7 %sp 68 #140
	sw %f2 %a7 0 #140
	sw %f2 %a7 4 #141
	sw %f2 %a7 8 #142
	addi %a8 %a6 -1 #1479
	addi %a6 %a6 -1 #1479
	slli %a6 %a6 2 #1479
	lw %a9 %sp 140 #1479
	add %a12 %a9 %a6 #1479
	lw %f2 %a12 0 #1479
	sw %a8 %sp 200 #111
	sw %f2 %sp 208 #111
	fadd %f0 %f2 %fzero
	sw %ra %sp 220 #111 call dir
	addi %sp %sp 224 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -224 #111
	lw %ra %sp 220 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100451 # nontail if
	lw %f0 %sp 208 #112
	sw %ra %sp 220 #112 call dir
	addi %sp %sp 224 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -224 #112
	lw %ra %sp 220 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100453 # nontail if
	li %f0 l.90466 #113
	jal %zero beq_cont.100454 # then sentence ends
beq_else.100453:
	li %f0 l.90464 #112
beq_cont.100454:
	jal %zero beq_cont.100452 # then sentence ends
beq_else.100451:
	li %f0 l.90390 #111
beq_cont.100452:
	sw %ra %sp 220 #1479 call dir
	addi %sp %sp 224 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -224 #1479
	lw %ra %sp 220 #1479
	lw %a0 %sp 200 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 68 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.100449 # then sentence ends
beq_else.100448:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.100455 # nontail if
	lw %a5 %a3 16 #276
	lw %f2 %a5 0 #281
	fadd %f0 %f2 %fzero
	sw %ra %sp 220 #1485 call dir
	addi %sp %sp 224 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -224 #1485
	lw %ra %sp 220 #1485
	lw %a0 %sp 68 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 196 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 220 #1486 call dir
	addi %sp %sp 224 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -224 #1486
	lw %ra %sp 220 #1486
	lw %a0 %sp 68 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 196 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 220 #1487 call dir
	addi %sp %sp 224 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -224 #1487
	lw %ra %sp 220 #1487
	lw %a0 %sp 68 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.100456 # then sentence ends
beq_else.100455:
	lw %a11 %sp 84 #1520
	add %a0 %a3 %zero
	sw %ra %sp 220 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 224 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -224 #1520
	lw %ra %sp 220 #1520
beq_cont.100456:
beq_cont.100449:
	lw %a1 %sp 72 #152
	lw %f0 %a1 0 #152
	lw %a0 %sp 64 #152
	sw %f0 %a0 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a0 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a0 8 #154
	lw %a0 %sp 196 #1659
	lw %a11 %sp 48 #1659
	sw %ra %sp 220 #1659 call cls
	lw %a10 %a11 0 #1659
	addi %sp %sp 224 #1659	
	jalr %ra %a10 0 #1659
	addi %sp %sp -224 #1659
	lw %ra %sp 220 #1659
	lw %a0 %sp 192 #1662
	lw %a1 %sp 92 #1662
	sw %ra %sp 220 #1662 call dir
	addi %sp %sp 224 #1662	
	jal %ra min_caml_sll #1662
	addi %sp %sp -224 #1662
	lw %ra %sp 220 #1662
	lw %a1 %sp 76 #39
	lw %a2 %a1 0 #39
	add %a0 %a0 %a2 #1662
	lw %a2 %sp 148 #1662
	slli %a3 %a2 2 #1662
	lw %a4 %sp 144 #1662
	add %a12 %a4 %a3 #1662
	sw %a0 %a12 0 #1662
	lw %a0 %sp 88 #446
	lw %a3 %a0 4 #446
	slli %a5 %a2 2 #1664
	add %a12 %a3 %a5 #1664
	lw %a3 %a12 0 #1664
	lw %a5 %sp 72 #152
	lw %f0 %a5 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a5 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a5 8 #152
	sw %f0 %a3 8 #154
	lw %a3 %a0 12 #461
	lw %a6 %sp 196 #346
	lw %a7 %a6 28 #346
	lw %f0 %a7 0 #351
	li %f1 l.91755 #1668
	sw %a3 %sp 216 #1668
	sw %ra %sp 220 #1668 call dir
	addi %sp %sp 224 #1668	
	jal %ra min_caml_fless #1668
	addi %sp %sp -224 #1668
	lw %ra %sp 220 #1668
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100457 # nontail if
	addi %a0 %zero 1 #1671
	lw %a1 %sp 148 #1671
	slli %a2 %a1 2 #1671
	lw %a3 %sp 216 #1671
	add %a12 %a3 %a2 #1671
	sw %a0 %a12 0 #1671
	lw %a0 %sp 88 #468
	lw %a2 %a0 16 #468
	slli %a3 %a1 2 #1673
	add %a12 %a2 %a3 #1673
	lw %a3 %a12 0 #1673
	lw %a4 %sp 44 #152
	lw %f0 %a4 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a4 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a4 8 #152
	sw %f0 %a3 8 #154
	slli %a3 %a1 2 #1673
	add %a12 %a2 %a3 #1673
	lw %a2 %a12 0 #1673
	li %f0 l.91937 #1674
	lw %f1 %sp 184 #1674
	fmul %f0 %f0 %f1 #1674
	lw %f2 %a2 0 #212
	fmul %f2 %f2 %f0 #212
	sw %f2 %a2 0 #212
	lw %f2 %a2 4 #212
	fmul %f2 %f2 %f0 #213
	sw %f2 %a2 4 #213
	lw %f2 %a2 8 #212
	fmul %f0 %f2 %f0 #214
	sw %f0 %a2 8 #214
	lw %a2 %a0 28 #498
	slli %a3 %a1 2 #1676
	add %a12 %a2 %a3 #1676
	lw %a2 %a12 0 #1676
	lw %a3 %sp 68 #152
	lw %f0 %a3 0 #152
	sw %f0 %a2 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a2 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a2 8 #154
	jal %zero beq_cont.100458 # then sentence ends
beq_else.100457:
	lw %a0 %sp 148 #1669
	slli %a1 %a0 2 #1669
	lw %a2 %sp 216 #1669
	lw %a3 %sp 180 #1669
	add %a12 %a2 %a1 #1669
	sw %a3 %a12 0 #1669
beq_cont.100458:
	li %f0 l.91952 #1679
	lw %a0 %sp 140 #181
	lw %f1 %a0 0 #181
	lw %a1 %sp 68 #181
	lw %f2 %a1 0 #181
	fmul %f1 %f1 %f2 #181
	lw %f2 %a0 4 #181
	lw %f3 %a1 4 #181
	fmul %f2 %f2 %f3 #181
	fadd %f1 %f1 %f2 #181
	lw %f2 %a0 8 #181
	lw %f3 %a1 8 #181
	fmul %f2 %f2 %f3 #181
	fadd %f1 %f1 %f2 #181
	fmul %f0 %f0 %f1 #1679
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
	lw %a2 %sp 196 #356
	lw %a3 %a2 28 #356
	lw %f0 %a3 4 #361
	lw %f1 %sp 128 #1683
	fmul %f0 %f1 %f0 #1683
	lw %a3 %sp 96 #33
	lw %a4 %a3 0 #33
	lw %a5 %a4 0 #1257
	lw %a6 %a5 0 #1258
	sw %f0 %sp 224 #1259
	addi %a12 %zero -1
	bne %a6 %a12 beq_else.100460 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.100461 # then sentence ends
beq_else.100460:
	sw %a5 %sp 232 #1259
	sw %a4 %sp 236 #1259
	addi %a12 %zero 99
	bne %a6 %a12 beq_else.100462 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.100463 # then sentence ends
beq_else.100462:
	lw %a7 %sp 60 #1266
	lw %a8 %sp 72 #1266
	lw %a11 %sp 40 #1266
	add %a2 %a8 %zero
	add %a1 %a7 %zero
	add %a0 %a6 %zero
	sw %ra %sp 244 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 248 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -248 #1266
	lw %ra %sp 244 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100464 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100465 # then sentence ends
beq_else.100464:
	lw %a0 %sp 32 #37
	lw %f0 %a0 0 #37
	li %f1 l.91269 #1270
	sw %ra %sp 244 #1270 call dir
	addi %sp %sp 248 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -248 #1270
	lw %ra %sp 244 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100466 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100467 # then sentence ends
beq_else.100466:
	addi %a0 %zero 1 #1271
	lw %a1 %sp 232 #1271
	lw %a11 %sp 24 #1271
	sw %ra %sp 244 #1271 call cls
	lw %a10 %a11 0 #1271
	addi %sp %sp 248 #1271	
	jalr %ra %a10 0 #1271
	addi %sp %sp -248 #1271
	lw %ra %sp 244 #1271
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100468 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100469 # then sentence ends
beq_else.100468:
	addi %a0 %zero 1 #1272
beq_cont.100469:
beq_cont.100467:
beq_cont.100465:
beq_cont.100463:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100470 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 236 #1282
	lw %a11 %sp 20 #1282
	sw %ra %sp 244 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 248 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -248 #1282
	lw %ra %sp 244 #1282
	jal %zero beq_cont.100471 # then sentence ends
beq_else.100470:
	addi %a0 %zero 1 #1277
	lw %a1 %sp 232 #1277
	lw %a11 %sp 24 #1277
	sw %ra %sp 244 #1277 call cls
	lw %a10 %a11 0 #1277
	addi %sp %sp 248 #1277	
	jalr %ra %a10 0 #1277
	addi %sp %sp -248 #1277
	lw %ra %sp 244 #1277
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100472 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 236 #1280
	lw %a11 %sp 20 #1280
	sw %ra %sp 244 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 248 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -248 #1280
	lw %ra %sp 244 #1280
	jal %zero beq_cont.100473 # then sentence ends
beq_else.100472:
	addi %a0 %zero 1 #1278
beq_cont.100473:
beq_cont.100471:
beq_cont.100461:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100474 # nontail if
	lw %a0 %sp 68 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 136 #181
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
	sw %ra %sp 244 #1687 call dir
	addi %sp %sp 248 #1687	
	jal %ra min_caml_fneg #1687
	addi %sp %sp -248 #1687
	lw %ra %sp 244 #1687
	lw %f1 %sp 184 #1687
	fmul %f0 %f0 %f1 #1687
	lw %a0 %sp 140 #181
	lw %f2 %a0 0 #181
	lw %a1 %sp 136 #181
	lw %f3 %a1 0 #181
	fmul %f2 %f2 %f3 #181
	lw %f3 %a0 4 #181
	lw %f4 %a1 4 #181
	fmul %f3 %f3 %f4 #181
	fadd %f2 %f2 %f3 #181
	lw %f3 %a0 8 #181
	lw %f4 %a1 8 #181
	fmul %f3 %f3 %f4 #181
	fadd %f2 %f2 %f3 #181
	sw %f0 %sp 240 #1688
	fadd %f0 %f2 %fzero
	sw %ra %sp 252 #1688 call dir
	addi %sp %sp 256 #1688	
	jal %ra min_caml_fneg #1688
	addi %sp %sp -256 #1688
	lw %ra %sp 252 #1688
	lw %f1 %sp 240 #1606
	sw %f0 %sp 248 #1606
	fadd %f0 %f1 %fzero
	sw %ra %sp 260 #1606 call dir
	addi %sp %sp 264 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -264 #1606
	lw %ra %sp 260 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100476 # nontail if
	jal %zero beq_cont.100477 # then sentence ends
beq_else.100476:
	lw %a0 %sp 120 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 44 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 240 #191
	fmul %f1 %f2 %f1 #191
	fadd %f0 %f0 %f1 #191
	sw %f0 %a0 0 #191
	lw %f0 %a0 4 #191
	lw %f1 %a1 4 #191
	fmul %f1 %f2 %f1 #192
	fadd %f0 %f0 %f1 #192
	sw %f0 %a0 4 #192
	lw %f0 %a0 8 #191
	lw %f1 %a1 8 #191
	fmul %f1 %f2 %f1 #193
	fadd %f0 %f0 %f1 #193
	sw %f0 %a0 8 #193
beq_cont.100477:
	lw %f0 %sp 248 #1611
	sw %ra %sp 260 #1611 call dir
	addi %sp %sp 264 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -264 #1611
	lw %ra %sp 260 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100478 # nontail if
	jal %zero beq_cont.100479 # then sentence ends
beq_else.100478:
	lw %f0 %sp 248 #1612
	sw %ra %sp 260 #1612 call dir
	addi %sp %sp 264 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -264 #1612
	lw %ra %sp 260 #1612
	sw %ra %sp 260 #1612 call dir
	addi %sp %sp 264 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -264 #1612
	lw %ra %sp 260 #1612
	lw %f1 %sp 224 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 120 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.100479:
	jal %zero beq_cont.100475 # then sentence ends
beq_else.100474:
beq_cont.100475:
	lw %a0 %sp 72 #152
	lw %f0 %a0 0 #152
	lw %a1 %sp 12 #152
	sw %f0 %a1 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a1 8 #154
	lw %a1 %sp 56 #15
	lw %a1 %a1 0 #15
	addi %a1 %a1 -1 #1147
	lw %a11 %sp 28 #1147
	sw %ra %sp 260 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 264 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -264 #1147
	lw %ra %sp 260 #1147
	lw %a0 %sp 52 #99
	lw %a0 %a0 0 #99
	addi %a0 %a0 -1 #1694
	addi %a1 %zero 0 #1622
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100480 # nontail if
	slli %a2 %a0 2 #95
	lw %a3 %sp 36 #95
	add %a12 %a3 %a2 #95
	lw %a2 %a12 0 #95
	lw %a3 %a2 4 #527
	li %f0 l.91802 #1458
	lw %a4 %sp 152 #1458
	sw %f0 %a4 0 #1458
	lw %a5 %sp 96 #33
	lw %a6 %a5 0 #33
	lw %a7 %a6 0 #1433
	lw %a8 %a7 0 #1434
	sw %a0 %sp 256 #1435
	sw %a3 %sp 260 #1435
	sw %a1 %sp 264 #1435
	sw %a2 %sp 268 #1435
	addi %a12 %zero -1
	bne %a8 %a12 beq_else.100482 # nontail if
	jal %zero beq_cont.100483 # then sentence ends
beq_else.100482:
	sw %a6 %sp 272 #1435
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.100484 # nontail if
	addi %a8 %zero 1 #1439
	lw %a11 %sp 16 #1439
	add %a2 %a3 %zero
	add %a1 %a7 %zero
	add %a0 %a8 %zero
	sw %ra %sp 276 #1439 call cls
	lw %a10 %a11 0 #1439
	addi %sp %sp 280 #1439	
	jalr %ra %a10 0 #1439
	addi %sp %sp -280 #1439
	lw %ra %sp 276 #1439
	jal %zero beq_cont.100485 # then sentence ends
beq_else.100484:
	lw %a11 %sp 8 #1443
	sw %a7 %sp 276 #1443
	add %a1 %a3 %zero
	add %a0 %a8 %zero
	sw %ra %sp 284 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 288 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -288 #1443
	lw %ra %sp 284 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100486 # nontail if
	jal %zero beq_cont.100487 # then sentence ends
beq_else.100486:
	lw %a0 %sp 32 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 152 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 284 #1446 call dir
	addi %sp %sp 288 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -288 #1446
	lw %ra %sp 284 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100488 # nontail if
	jal %zero beq_cont.100489 # then sentence ends
beq_else.100488:
	addi %a0 %zero 1 #1447
	lw %a1 %sp 276 #1447
	lw %a2 %sp 260 #1447
	lw %a11 %sp 16 #1447
	sw %ra %sp 284 #1447 call cls
	lw %a10 %a11 0 #1447
	addi %sp %sp 288 #1447	
	jalr %ra %a10 0 #1447
	addi %sp %sp -288 #1447
	lw %ra %sp 284 #1447
beq_cont.100489:
beq_cont.100487:
beq_cont.100485:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 272 #1451
	lw %a2 %sp 260 #1451
	lw %a11 %sp 4 #1451
	sw %ra %sp 284 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 288 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -288 #1451
	lw %ra %sp 284 #1451
beq_cont.100483:
	lw %a0 %sp 152 #41
	lw %f1 %a0 0 #41
	li %f0 l.91269 #1462
	sw %f1 %sp 280 #1462
	sw %ra %sp 292 #1462 call dir
	addi %sp %sp 296 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -296 #1462
	lw %ra %sp 292 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100490 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.100491 # then sentence ends
beq_else.100490:
	li %f1 l.91808 #1463
	lw %f0 %sp 280 #1463
	sw %ra %sp 292 #1463 call dir
	addi %sp %sp 296 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -296 #1463
	lw %ra %sp 292 #1463
beq_cont.100491:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100492 # nontail if
	jal %zero beq_cont.100493 # then sentence ends
beq_else.100492:
	lw %a0 %sp 116 #45
	lw %a0 %a0 0 #45
	addi %a1 %zero 4 #1628
	sw %ra %sp 292 #1628 call dir
	addi %sp %sp 296 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -296 #1628
	lw %ra %sp 292 #1628
	lw %a1 %sp 76 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1628
	lw %a1 %sp 268 #521
	lw %a2 %a1 0 #521
	bne %a0 %a2 beq_else.100494 # nontail if
	lw %a0 %sp 96 #33
	lw %a0 %a0 0 #33
	lw %a2 %sp 264 #1631
	lw %a11 %sp 20 #1631
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 292 #1631 call cls
	lw %a10 %a11 0 #1631
	addi %sp %sp 296 #1631	
	jalr %ra %a10 0 #1631
	addi %sp %sp -296 #1631
	lw %ra %sp 292 #1631
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100496 # nontail if
	lw %a0 %sp 260 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 68 #181
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
	lw %a1 %sp 268 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 184 #1635
	fmul %f3 %f1 %f2 #1635
	fmul %f0 %f3 %f0 #1635
	lw %a0 %a0 0 #507
	lw %a1 %sp 140 #181
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
	sw %f1 %sp 288 #1606
	sw %f0 %sp 296 #1606
	sw %ra %sp 308 #1606 call dir
	addi %sp %sp 312 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -312 #1606
	lw %ra %sp 308 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100498 # nontail if
	jal %zero beq_cont.100499 # then sentence ends
beq_else.100498:
	lw %a0 %sp 120 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 44 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 296 #191
	fmul %f1 %f2 %f1 #191
	fadd %f0 %f0 %f1 #191
	sw %f0 %a0 0 #191
	lw %f0 %a0 4 #191
	lw %f1 %a1 4 #191
	fmul %f1 %f2 %f1 #192
	fadd %f0 %f0 %f1 #192
	sw %f0 %a0 4 #192
	lw %f0 %a0 8 #191
	lw %f1 %a1 8 #191
	fmul %f1 %f2 %f1 #193
	fadd %f0 %f0 %f1 #193
	sw %f0 %a0 8 #193
beq_cont.100499:
	lw %f0 %sp 288 #1611
	sw %ra %sp 308 #1611 call dir
	addi %sp %sp 312 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -312 #1611
	lw %ra %sp 308 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100500 # nontail if
	jal %zero beq_cont.100501 # then sentence ends
beq_else.100500:
	lw %f0 %sp 288 #1612
	sw %ra %sp 308 #1612 call dir
	addi %sp %sp 312 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -312 #1612
	lw %ra %sp 308 #1612
	sw %ra %sp 308 #1612 call dir
	addi %sp %sp 312 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -312 #1612
	lw %ra %sp 308 #1612
	lw %f1 %sp 224 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 120 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.100501:
	jal %zero beq_cont.100497 # then sentence ends
beq_else.100496:
beq_cont.100497:
	jal %zero beq_cont.100495 # then sentence ends
beq_else.100494:
beq_cont.100495:
beq_cont.100493:
	lw %a0 %sp 256 #1641
	addi %a0 %a0 -1 #1641
	lw %f0 %sp 184 #1641
	lw %f1 %sp 224 #1641
	lw %a1 %sp 140 #1641
	lw %a11 %sp 0 #1641
	sw %ra %sp 308 #1641 call cls
	lw %a10 %a11 0 #1641
	addi %sp %sp 312 #1641	
	jalr %ra %a10 0 #1641
	addi %sp %sp -312 #1641
	lw %ra %sp 308 #1641
	jal %zero bge_cont.100481 # then sentence ends
bge_else.100480:
bge_cont.100481:
	li %f0 l.92051 #1697
	lw %f1 %sp 128 #1697
	sw %ra %sp 308 #1697 call dir
	addi %sp %sp 312 #1697	
	jal %ra min_caml_fless #1697
	addi %sp %sp -312 #1697
	lw %ra %sp 308 #1697
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100502
	jalr %zero %ra 0 #1708
beq_else.100502:
	lw %a0 %sp 148 #1648
	addi %a12 %zero 4
	blt %a0 %a12 bge_else.100504 # nontail if
	jal %zero bge_cont.100505 # then sentence ends
bge_else.100504:
	addi %a1 %a0 1 #1700
	addi %a2 %zero -1 #1700
	slli %a1 %a1 2 #1700
	lw %a3 %sp 144 #1700
	add %a12 %a3 %a1 #1700
	sw %a2 %a12 0 #1700
bge_cont.100505:
	lw %a1 %sp 176 #20
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.100506
	li %f0 l.90464 #1704
	lw %a1 %sp 196 #346
	lw %a1 %a1 28 #346
	lw %f1 %a1 0 #351
	fsub %f0 %f0 %f1 #1704
	lw %f1 %sp 128 #1704
	fmul %f0 %f1 %f0 #1704
	addi %a0 %a0 1 #1705
	lw %a1 %sp 152 #41
	lw %f1 %a1 0 #41
	lw %f2 %sp 104 #1705
	fadd %f1 %f2 %f1 #1705
	lw %a1 %sp 140 #1705
	lw %a2 %sp 88 #1705
	lw %a11 %sp 80 #1705
	lw %a10 %a11 0 #1705
	jalr %zero %a10 0 #1705
beq_else.100506:
	jalr %zero %ra 0 #1706
bge_else.100437:
	jalr %zero %ra 0 #1729
trace_diffuse_ray.2576:
	lw %a1 %a11 72 #1737
	lw %a2 %a11 68 #1737
	lw %a3 %a11 64 #1737
	lw %a4 %a11 60 #1737
	lw %a5 %a11 56 #1737
	lw %a6 %a11 52 #1737
	lw %a7 %a11 48 #1737
	lw %a8 %a11 44 #1737
	lw %a9 %a11 40 #1737
	lw %a10 %a11 36 #1737
	sw %a4 %sp 0 #1737
	lw %a4 %a11 32 #1737
	sw %a7 %sp 4 #1737
	lw %a7 %a11 28 #1737
	sw %a8 %sp 8 #1737
	lw %a8 %a11 24 #1737
	sw %a8 %sp 12 #1737
	lw %a8 %a11 20 #1737
	sw %a6 %sp 16 #1737
	lw %a6 %a11 16 #1737
	sw %a7 %sp 20 #1737
	lw %a7 %a11 12 #1737
	sw %a5 %sp 24 #1737
	lw %a5 %a11 8 #1737
	lw %a11 %a11 4 #1737
	li %f1 l.91802 #1458
	sw %f1 %a3 0 #1458
	sw %a11 %sp 28 #1459
	addi %a11 %zero 0 #1459
	sw %a9 %sp 32 #33
	lw %a9 %a9 0 #33
	sw %f0 %sp 40 #1459
	sw %a6 %sp 48 #1459
	sw %a1 %sp 52 #1459
	sw %a5 %sp 56 #1459
	sw %a4 %sp 60 #1459
	sw %a8 %sp 64 #1459
	sw %a0 %sp 68 #1459
	sw %a10 %sp 72 #1459
	sw %a7 %sp 76 #1459
	sw %a3 %sp 80 #1459
	add %a1 %a9 %zero
	add %a10 %a2 %zero
	add %a2 %a0 %zero
	add %a0 %a11 %zero
	add %a11 %a10 %zero
	sw %ra %sp 84 #1459 call cls
	lw %a10 %a11 0 #1459
	addi %sp %sp 88 #1459	
	jalr %ra %a10 0 #1459
	addi %sp %sp -88 #1459
	lw %ra %sp 84 #1459
	lw %a0 %sp 80 #41
	lw %f1 %a0 0 #41
	li %f0 l.91269 #1462
	sw %f1 %sp 88 #1462
	sw %ra %sp 100 #1462 call dir
	addi %sp %sp 104 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -104 #1462
	lw %ra %sp 100 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100511 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.100512 # then sentence ends
beq_else.100511:
	li %f1 l.91808 #1463
	lw %f0 %sp 88 #1463
	sw %ra %sp 100 #1463 call dir
	addi %sp %sp 104 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -104 #1463
	lw %ra %sp 100 #1463
beq_cont.100512:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100513
	jalr %zero %ra 0 #1751
beq_else.100513:
	lw %a0 %sp 76 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a1 %sp 72 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a1 %sp 68 #507
	lw %a1 %a1 0 #507
	lw %a2 %a0 4 #238
	sw %a0 %sp 96 #868
	addi %a12 %zero 1
	bne %a2 %a12 beq_else.100515 # nontail if
	lw %a2 %sp 64 #39
	lw %a2 %a2 0 #39
	li %f0 l.90390 #147
	lw %a3 %sp 60 #140
	sw %f0 %a3 0 #140
	sw %f0 %a3 4 #141
	sw %f0 %a3 8 #142
	addi %a4 %a2 -1 #1479
	addi %a2 %a2 -1 #1479
	slli %a2 %a2 2 #1479
	add %a12 %a1 %a2 #1479
	lw %f0 %a12 0 #1479
	sw %a4 %sp 100 #111
	sw %f0 %sp 104 #111
	sw %ra %sp 116 #111 call dir
	addi %sp %sp 120 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -120 #111
	lw %ra %sp 116 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100517 # nontail if
	lw %f0 %sp 104 #112
	sw %ra %sp 116 #112 call dir
	addi %sp %sp 120 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -120 #112
	lw %ra %sp 116 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100519 # nontail if
	li %f0 l.90466 #113
	jal %zero beq_cont.100520 # then sentence ends
beq_else.100519:
	li %f0 l.90464 #112
beq_cont.100520:
	jal %zero beq_cont.100518 # then sentence ends
beq_else.100517:
	li %f0 l.90390 #111
beq_cont.100518:
	sw %ra %sp 116 #1479 call dir
	addi %sp %sp 120 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -120 #1479
	lw %ra %sp 116 #1479
	lw %a0 %sp 100 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 60 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.100516 # then sentence ends
beq_else.100515:
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.100521 # nontail if
	lw %a1 %a0 16 #276
	lw %f0 %a1 0 #281
	sw %ra %sp 116 #1485 call dir
	addi %sp %sp 120 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -120 #1485
	lw %ra %sp 116 #1485
	lw %a0 %sp 60 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 96 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 116 #1486 call dir
	addi %sp %sp 120 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -120 #1486
	lw %ra %sp 116 #1486
	lw %a0 %sp 60 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 96 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 116 #1487 call dir
	addi %sp %sp 120 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -120 #1487
	lw %ra %sp 116 #1487
	lw %a0 %sp 60 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.100522 # then sentence ends
beq_else.100521:
	lw %a11 %sp 56 #1520
	sw %ra %sp 116 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 120 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -120 #1520
	lw %ra %sp 116 #1520
beq_cont.100522:
beq_cont.100516:
	lw %a0 %sp 96 #1743
	lw %a1 %sp 48 #1743
	lw %a11 %sp 52 #1743
	sw %ra %sp 116 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 120 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -120 #1743
	lw %ra %sp 116 #1743
	lw %a0 %sp 32 #33
	lw %a1 %a0 0 #33
	lw %a0 %a1 0 #1257
	lw %a2 %a0 0 #1258
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.100523 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.100524 # then sentence ends
beq_else.100523:
	sw %a0 %sp 112 #1259
	sw %a1 %sp 116 #1259
	addi %a12 %zero 99
	bne %a2 %a12 beq_else.100525 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.100526 # then sentence ends
beq_else.100525:
	lw %a3 %sp 20 #1266
	lw %a4 %sp 48 #1266
	lw %a11 %sp 24 #1266
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 124 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 128 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -128 #1266
	lw %ra %sp 124 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100527 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100528 # then sentence ends
beq_else.100527:
	lw %a0 %sp 16 #37
	lw %f0 %a0 0 #37
	li %f1 l.91269 #1270
	sw %ra %sp 124 #1270 call dir
	addi %sp %sp 128 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -128 #1270
	lw %ra %sp 124 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100529 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100530 # then sentence ends
beq_else.100529:
	addi %a0 %zero 1 #1271
	lw %a1 %sp 112 #1271
	lw %a11 %sp 8 #1271
	sw %ra %sp 124 #1271 call cls
	lw %a10 %a11 0 #1271
	addi %sp %sp 128 #1271	
	jalr %ra %a10 0 #1271
	addi %sp %sp -128 #1271
	lw %ra %sp 124 #1271
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100531 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.100532 # then sentence ends
beq_else.100531:
	addi %a0 %zero 1 #1272
beq_cont.100532:
beq_cont.100530:
beq_cont.100528:
beq_cont.100526:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100533 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 116 #1282
	lw %a11 %sp 4 #1282
	sw %ra %sp 124 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 128 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -128 #1282
	lw %ra %sp 124 #1282
	jal %zero beq_cont.100534 # then sentence ends
beq_else.100533:
	addi %a0 %zero 1 #1277
	lw %a1 %sp 112 #1277
	lw %a11 %sp 8 #1277
	sw %ra %sp 124 #1277 call cls
	lw %a10 %a11 0 #1277
	addi %sp %sp 128 #1277	
	jalr %ra %a10 0 #1277
	addi %sp %sp -128 #1277
	lw %ra %sp 124 #1277
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100535 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 116 #1280
	lw %a11 %sp 4 #1280
	sw %ra %sp 124 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 128 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -128 #1280
	lw %ra %sp 124 #1280
	jal %zero beq_cont.100536 # then sentence ends
beq_else.100535:
	addi %a0 %zero 1 #1278
beq_cont.100536:
beq_cont.100534:
beq_cont.100524:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100537
	lw %a0 %sp 60 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 12 #181
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
	sw %ra %sp 124 #1747 call dir
	addi %sp %sp 128 #1747	
	jal %ra min_caml_fneg #1747
	addi %sp %sp -128 #1747
	lw %ra %sp 124 #1747
	sw %f0 %sp 120 #1748
	sw %ra %sp 132 #1748 call dir
	addi %sp %sp 136 #1748	
	jal %ra min_caml_fispos #1748
	addi %sp %sp -136 #1748
	lw %ra %sp 132 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100538 # nontail if
	li %f0 l.90390 #1748
	jal %zero beq_cont.100539 # then sentence ends
beq_else.100538:
	lw %f0 %sp 120 #559
beq_cont.100539:
	lw %f1 %sp 40 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 96 #346
	lw %a0 %a0 28 #346
	lw %f1 %a0 0 #351
	fmul %f0 %f0 %f1 #1749
	lw %a0 %sp 28 #191
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
beq_else.100537:
	jalr %zero %ra 0 #1750
iter_trace_diffuse_rays.2579:
	lw %a4 %a11 72 #1755
	lw %a5 %a11 68 #1755
	lw %a6 %a11 64 #1755
	lw %a7 %a11 60 #1755
	lw %a8 %a11 56 #1755
	lw %a9 %a11 52 #1755
	lw %a10 %a11 48 #1755
	sw %a2 %sp 0 #1755
	lw %a2 %a11 44 #1755
	sw %a6 %sp 4 #1755
	lw %a6 %a11 40 #1755
	sw %a8 %sp 8 #1755
	lw %a8 %a11 36 #1755
	sw %a6 %sp 12 #1755
	lw %a6 %a11 32 #1755
	sw %a4 %sp 16 #1755
	lw %a4 %a11 28 #1755
	sw %a4 %sp 20 #1755
	lw %a4 %a11 24 #1755
	sw %a4 %sp 24 #1755
	lw %a4 %a11 20 #1755
	sw %a4 %sp 28 #1755
	lw %a4 %a11 16 #1755
	sw %a4 %sp 32 #1755
	lw %a4 %a11 12 #1755
	sw %a6 %sp 36 #1755
	lw %a6 %a11 8 #1755
	sw %a11 %sp 40 #1755
	lw %a11 %a11 4 #1755
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.100542
	sw %a11 %sp 44 #1757
	slli %a11 %a3 2 #1757
	add %a12 %a0 %a11 #1757
	lw %a11 %a12 0 #1757
	lw %a11 %a11 0 #507
	lw %f0 %a11 0 #181
	lw %f1 %a1 0 #181
	fmul %f0 %f0 %f1 #181
	lw %f1 %a11 4 #181
	lw %f2 %a1 4 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	lw %f1 %a11 8 #181
	lw %f2 %a1 8 #181
	fmul %f1 %f1 %f2 #181
	fadd %f0 %f0 %f1 #181
	sw %a1 %sp 48 #1760
	sw %a6 %sp 52 #1760
	sw %a4 %sp 56 #1760
	sw %a5 %sp 60 #1760
	sw %a10 %sp 64 #1760
	sw %a9 %sp 68 #1760
	sw %a2 %sp 72 #1760
	sw %a8 %sp 76 #1760
	sw %a7 %sp 80 #1760
	sw %f0 %sp 88 #1760
	sw %a0 %sp 96 #1760
	sw %a3 %sp 100 #1760
	sw %ra %sp 108 #1760 call dir
	addi %sp %sp 112 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -112 #1760
	lw %ra %sp 108 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100544 # nontail if
	lw %a0 %sp 100 #1757
	slli %a1 %a0 2 #1757
	lw %a2 %sp 96 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 88 #1763
	fdiv %f0 %f1 %f0 #1763
	li %f1 l.91802 #1458
	lw %a3 %sp 80 #1458
	sw %f1 %a3 0 #1458
	lw %a4 %sp 76 #33
	lw %a5 %a4 0 #33
	lw %a6 %a5 0 #1433
	lw %a7 %a6 0 #1434
	sw %f0 %sp 104 #1435
	sw %a1 %sp 112 #1435
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.100546 # nontail if
	jal %zero beq_cont.100547 # then sentence ends
beq_else.100546:
	sw %a5 %sp 116 #1435
	addi %a12 %zero 99
	bne %a7 %a12 beq_else.100548 # nontail if
	addi %a7 %zero 1 #1439
	lw %a11 %sp 72 #1439
	add %a2 %a1 %zero
	add %a0 %a7 %zero
	add %a1 %a6 %zero
	sw %ra %sp 124 #1439 call cls
	lw %a10 %a11 0 #1439
	addi %sp %sp 128 #1439	
	jalr %ra %a10 0 #1439
	addi %sp %sp -128 #1439
	lw %ra %sp 124 #1439
	jal %zero beq_cont.100549 # then sentence ends
beq_else.100548:
	lw %a11 %sp 68 #1443
	sw %a6 %sp 120 #1443
	add %a0 %a7 %zero
	sw %ra %sp 124 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 128 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -128 #1443
	lw %ra %sp 124 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100550 # nontail if
	jal %zero beq_cont.100551 # then sentence ends
beq_else.100550:
	lw %a0 %sp 64 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 80 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 124 #1446 call dir
	addi %sp %sp 128 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -128 #1446
	lw %ra %sp 124 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100552 # nontail if
	jal %zero beq_cont.100553 # then sentence ends
beq_else.100552:
	addi %a0 %zero 1 #1447
	lw %a1 %sp 120 #1447
	lw %a2 %sp 112 #1447
	lw %a11 %sp 72 #1447
	sw %ra %sp 124 #1447 call cls
	lw %a10 %a11 0 #1447
	addi %sp %sp 128 #1447	
	jalr %ra %a10 0 #1447
	addi %sp %sp -128 #1447
	lw %ra %sp 124 #1447
beq_cont.100553:
beq_cont.100551:
beq_cont.100549:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 116 #1451
	lw %a2 %sp 112 #1451
	lw %a11 %sp 60 #1451
	sw %ra %sp 124 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 128 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -128 #1451
	lw %ra %sp 124 #1451
beq_cont.100547:
	lw %a0 %sp 80 #41
	lw %f1 %a0 0 #41
	li %f0 l.91269 #1462
	sw %f1 %sp 128 #1462
	sw %ra %sp 140 #1462 call dir
	addi %sp %sp 144 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -144 #1462
	lw %ra %sp 140 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100555 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.100556 # then sentence ends
beq_else.100555:
	li %f1 l.91808 #1463
	lw %f0 %sp 128 #1463
	sw %ra %sp 140 #1463 call dir
	addi %sp %sp 144 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -144 #1463
	lw %ra %sp 140 #1463
beq_cont.100556:
	addi %a1 %zero 0 #1740
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100557 # nontail if
	jal %zero beq_cont.100558 # then sentence ends
beq_else.100557:
	lw %a0 %sp 56 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a2 %sp 36 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a2 %sp 112 #507
	lw %a2 %a2 0 #507
	lw %a3 %a0 4 #238
	sw %a1 %sp 136 #868
	sw %a0 %sp 140 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.100559 # nontail if
	lw %a3 %sp 28 #39
	lw %a3 %a3 0 #39
	li %f0 l.90390 #147
	lw %a4 %sp 20 #140
	sw %f0 %a4 0 #140
	sw %f0 %a4 4 #141
	sw %f0 %a4 8 #142
	addi %a5 %a3 -1 #1479
	addi %a3 %a3 -1 #1479
	slli %a3 %a3 2 #1479
	add %a12 %a2 %a3 #1479
	lw %f0 %a12 0 #1479
	sw %a5 %sp 144 #111
	sw %f0 %sp 152 #111
	sw %ra %sp 164 #111 call dir
	addi %sp %sp 168 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -168 #111
	lw %ra %sp 164 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100562 # nontail if
	lw %f0 %sp 152 #112
	sw %ra %sp 164 #112 call dir
	addi %sp %sp 168 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -168 #112
	lw %ra %sp 164 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100564 # nontail if
	li %f0 l.90466 #113
	jal %zero beq_cont.100565 # then sentence ends
beq_else.100564:
	li %f0 l.90464 #112
beq_cont.100565:
	jal %zero beq_cont.100563 # then sentence ends
beq_else.100562:
	li %f0 l.90390 #111
beq_cont.100563:
	sw %ra %sp 164 #1479 call dir
	addi %sp %sp 168 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -168 #1479
	lw %ra %sp 164 #1479
	lw %a0 %sp 144 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 20 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.100560 # then sentence ends
beq_else.100559:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.100566 # nontail if
	lw %a2 %a0 16 #276
	lw %f0 %a2 0 #281
	sw %ra %sp 164 #1485 call dir
	addi %sp %sp 168 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -168 #1485
	lw %ra %sp 164 #1485
	lw %a0 %sp 20 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 140 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 164 #1486 call dir
	addi %sp %sp 168 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -168 #1486
	lw %ra %sp 164 #1486
	lw %a0 %sp 20 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 140 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 164 #1487 call dir
	addi %sp %sp 168 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -168 #1487
	lw %ra %sp 164 #1487
	lw %a0 %sp 20 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.100567 # then sentence ends
beq_else.100566:
	lw %a11 %sp 52 #1520
	sw %ra %sp 164 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 168 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -168 #1520
	lw %ra %sp 164 #1520
beq_cont.100567:
beq_cont.100560:
	lw %a0 %sp 140 #1743
	lw %a1 %sp 32 #1743
	lw %a11 %sp 16 #1743
	sw %ra %sp 164 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 168 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -168 #1743
	lw %ra %sp 164 #1743
	lw %a0 %sp 76 #33
	lw %a1 %a0 0 #33
	lw %a0 %sp 136 #1746
	lw %a11 %sp 12 #1746
	sw %ra %sp 164 #1746 call cls
	lw %a10 %a11 0 #1746
	addi %sp %sp 168 #1746	
	jalr %ra %a10 0 #1746
	addi %sp %sp -168 #1746
	lw %ra %sp 164 #1746
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100568 # nontail if
	lw %a0 %sp 20 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 24 #181
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
	sw %ra %sp 164 #1747 call dir
	addi %sp %sp 168 #1747	
	jal %ra min_caml_fneg #1747
	addi %sp %sp -168 #1747
	lw %ra %sp 164 #1747
	sw %f0 %sp 160 #1748
	sw %ra %sp 172 #1748 call dir
	addi %sp %sp 176 #1748	
	jal %ra min_caml_fispos #1748
	addi %sp %sp -176 #1748
	lw %ra %sp 172 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100570 # nontail if
	li %f0 l.90390 #1748
	jal %zero beq_cont.100571 # then sentence ends
beq_else.100570:
	lw %f0 %sp 160 #559
beq_cont.100571:
	lw %f1 %sp 104 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 140 #346
	lw %a0 %a0 28 #346
	lw %f1 %a0 0 #351
	fmul %f0 %f0 %f1 #1749
	lw %a0 %sp 44 #191
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
	jal %zero beq_cont.100569 # then sentence ends
beq_else.100568:
beq_cont.100569:
beq_cont.100558:
	jal %zero beq_cont.100545 # then sentence ends
beq_else.100544:
	lw %a0 %sp 100 #1761
	addi %a1 %a0 1 #1761
	slli %a1 %a1 2 #1757
	lw %a2 %sp 96 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 88 #1761
	fdiv %f0 %f1 %f0 #1761
	li %f1 l.91802 #1458
	lw %a3 %sp 80 #1458
	sw %f1 %a3 0 #1458
	lw %a4 %sp 76 #33
	lw %a5 %a4 0 #33
	lw %a6 %a5 0 #1433
	lw %a7 %a6 0 #1434
	sw %f0 %sp 168 #1435
	sw %a1 %sp 176 #1435
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.100572 # nontail if
	jal %zero beq_cont.100573 # then sentence ends
beq_else.100572:
	sw %a5 %sp 180 #1435
	addi %a12 %zero 99
	bne %a7 %a12 beq_else.100574 # nontail if
	addi %a7 %zero 1 #1439
	lw %a11 %sp 72 #1439
	add %a2 %a1 %zero
	add %a0 %a7 %zero
	add %a1 %a6 %zero
	sw %ra %sp 188 #1439 call cls
	lw %a10 %a11 0 #1439
	addi %sp %sp 192 #1439	
	jalr %ra %a10 0 #1439
	addi %sp %sp -192 #1439
	lw %ra %sp 188 #1439
	jal %zero beq_cont.100575 # then sentence ends
beq_else.100574:
	lw %a11 %sp 68 #1443
	sw %a6 %sp 184 #1443
	add %a0 %a7 %zero
	sw %ra %sp 188 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 192 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -192 #1443
	lw %ra %sp 188 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100576 # nontail if
	jal %zero beq_cont.100577 # then sentence ends
beq_else.100576:
	lw %a0 %sp 64 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 80 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 188 #1446 call dir
	addi %sp %sp 192 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -192 #1446
	lw %ra %sp 188 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100578 # nontail if
	jal %zero beq_cont.100579 # then sentence ends
beq_else.100578:
	addi %a0 %zero 1 #1447
	lw %a1 %sp 184 #1447
	lw %a2 %sp 176 #1447
	lw %a11 %sp 72 #1447
	sw %ra %sp 188 #1447 call cls
	lw %a10 %a11 0 #1447
	addi %sp %sp 192 #1447	
	jalr %ra %a10 0 #1447
	addi %sp %sp -192 #1447
	lw %ra %sp 188 #1447
beq_cont.100579:
beq_cont.100577:
beq_cont.100575:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 180 #1451
	lw %a2 %sp 176 #1451
	lw %a11 %sp 60 #1451
	sw %ra %sp 188 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 192 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -192 #1451
	lw %ra %sp 188 #1451
beq_cont.100573:
	lw %a0 %sp 80 #41
	lw %f1 %a0 0 #41
	li %f0 l.91269 #1462
	sw %f1 %sp 192 #1462
	sw %ra %sp 204 #1462 call dir
	addi %sp %sp 208 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -208 #1462
	lw %ra %sp 204 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100581 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.100582 # then sentence ends
beq_else.100581:
	li %f1 l.91808 #1463
	lw %f0 %sp 192 #1463
	sw %ra %sp 204 #1463 call dir
	addi %sp %sp 208 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -208 #1463
	lw %ra %sp 204 #1463
beq_cont.100582:
	addi %a1 %zero 0 #1740
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100583 # nontail if
	jal %zero beq_cont.100584 # then sentence ends
beq_else.100583:
	lw %a0 %sp 56 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a2 %sp 36 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a2 %sp 176 #507
	lw %a2 %a2 0 #507
	lw %a3 %a0 4 #238
	sw %a1 %sp 200 #868
	sw %a0 %sp 204 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.100585 # nontail if
	lw %a3 %sp 28 #39
	lw %a3 %a3 0 #39
	li %f0 l.90390 #147
	lw %a4 %sp 20 #140
	sw %f0 %a4 0 #140
	sw %f0 %a4 4 #141
	sw %f0 %a4 8 #142
	addi %a5 %a3 -1 #1479
	addi %a3 %a3 -1 #1479
	slli %a3 %a3 2 #1479
	add %a12 %a2 %a3 #1479
	lw %f0 %a12 0 #1479
	sw %a5 %sp 208 #111
	sw %f0 %sp 216 #111
	sw %ra %sp 228 #111 call dir
	addi %sp %sp 232 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -232 #111
	lw %ra %sp 228 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100588 # nontail if
	lw %f0 %sp 216 #112
	sw %ra %sp 228 #112 call dir
	addi %sp %sp 232 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -232 #112
	lw %ra %sp 228 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100590 # nontail if
	li %f0 l.90466 #113
	jal %zero beq_cont.100591 # then sentence ends
beq_else.100590:
	li %f0 l.90464 #112
beq_cont.100591:
	jal %zero beq_cont.100589 # then sentence ends
beq_else.100588:
	li %f0 l.90390 #111
beq_cont.100589:
	sw %ra %sp 228 #1479 call dir
	addi %sp %sp 232 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -232 #1479
	lw %ra %sp 228 #1479
	lw %a0 %sp 208 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 20 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.100586 # then sentence ends
beq_else.100585:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.100592 # nontail if
	lw %a2 %a0 16 #276
	lw %f0 %a2 0 #281
	sw %ra %sp 228 #1485 call dir
	addi %sp %sp 232 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -232 #1485
	lw %ra %sp 228 #1485
	lw %a0 %sp 20 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 204 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 228 #1486 call dir
	addi %sp %sp 232 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -232 #1486
	lw %ra %sp 228 #1486
	lw %a0 %sp 20 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 204 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 228 #1487 call dir
	addi %sp %sp 232 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -232 #1487
	lw %ra %sp 228 #1487
	lw %a0 %sp 20 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.100593 # then sentence ends
beq_else.100592:
	lw %a11 %sp 52 #1520
	sw %ra %sp 228 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 232 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -232 #1520
	lw %ra %sp 228 #1520
beq_cont.100593:
beq_cont.100586:
	lw %a0 %sp 204 #1743
	lw %a1 %sp 32 #1743
	lw %a11 %sp 16 #1743
	sw %ra %sp 228 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 232 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -232 #1743
	lw %ra %sp 228 #1743
	lw %a0 %sp 76 #33
	lw %a1 %a0 0 #33
	lw %a0 %sp 200 #1746
	lw %a11 %sp 12 #1746
	sw %ra %sp 228 #1746 call cls
	lw %a10 %a11 0 #1746
	addi %sp %sp 232 #1746	
	jalr %ra %a10 0 #1746
	addi %sp %sp -232 #1746
	lw %ra %sp 228 #1746
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100594 # nontail if
	lw %a0 %sp 20 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 24 #181
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
	sw %ra %sp 228 #1747 call dir
	addi %sp %sp 232 #1747	
	jal %ra min_caml_fneg #1747
	addi %sp %sp -232 #1747
	lw %ra %sp 228 #1747
	sw %f0 %sp 224 #1748
	sw %ra %sp 236 #1748 call dir
	addi %sp %sp 240 #1748	
	jal %ra min_caml_fispos #1748
	addi %sp %sp -240 #1748
	lw %ra %sp 236 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100596 # nontail if
	li %f0 l.90390 #1748
	jal %zero beq_cont.100597 # then sentence ends
beq_else.100596:
	lw %f0 %sp 224 #559
beq_cont.100597:
	lw %f1 %sp 168 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 204 #346
	lw %a0 %a0 28 #346
	lw %f1 %a0 0 #351
	fmul %f0 %f0 %f1 #1749
	lw %a0 %sp 44 #191
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
	jal %zero beq_cont.100595 # then sentence ends
beq_else.100594:
beq_cont.100595:
beq_cont.100584:
beq_cont.100545:
	lw %a0 %sp 100 #1765
	addi %a0 %a0 -2 #1765
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100598
	slli %a1 %a0 2 #1757
	lw %a2 %sp 96 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a3 %sp 48 #181
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
	sw %f0 %sp 232 #1760
	sw %a0 %sp 240 #1760
	sw %ra %sp 244 #1760 call dir
	addi %sp %sp 248 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -248 #1760
	lw %ra %sp 244 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100599 # nontail if
	lw %a0 %sp 240 #1757
	slli %a1 %a0 2 #1757
	lw %a2 %sp 96 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 232 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 4 #1763
	add %a0 %a1 %zero
	sw %ra %sp 244 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 248 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -248 #1763
	lw %ra %sp 244 #1763
	jal %zero beq_cont.100600 # then sentence ends
beq_else.100599:
	lw %a0 %sp 240 #1761
	addi %a1 %a0 1 #1761
	slli %a1 %a1 2 #1757
	lw %a2 %sp 96 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 232 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 4 #1761
	add %a0 %a1 %zero
	sw %ra %sp 244 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 248 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -248 #1761
	lw %ra %sp 244 #1761
beq_cont.100600:
	lw %a0 %sp 240 #1765
	addi %a3 %a0 -2 #1765
	lw %a0 %sp 96 #1765
	lw %a1 %sp 48 #1765
	lw %a2 %sp 0 #1765
	lw %a11 %sp 40 #1765
	lw %a10 %a11 0 #1765
	jalr %zero %a10 0 #1765
bge_else.100598:
	jalr %zero %ra 0 #1766
bge_else.100542:
	jalr %zero %ra 0 #1766
calc_diffuse_using_1point.2592:
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
	bne %a0 %a12 beq_else.100603 # nontail if
	jal %zero beq_cont.100604 # then sentence ends
beq_else.100603:
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
	sw %f0 %sp 56 #1760
	sw %ra %sp 68 #1760 call dir
	addi %sp %sp 72 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -72 #1760
	lw %ra %sp 68 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100605 # nontail if
	lw %a0 %sp 52 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 56 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 68 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 72 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -72 #1763
	lw %ra %sp 68 #1763
	jal %zero beq_cont.100606 # then sentence ends
beq_else.100605:
	lw %a0 %sp 52 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 56 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 68 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 72 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -72 #1761
	lw %ra %sp 68 #1761
beq_cont.100606:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 52 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 68 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 72 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -72 #1765
	lw %ra %sp 68 #1765
beq_cont.100604:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100607 # nontail if
	jal %zero beq_cont.100608 # then sentence ends
beq_else.100607:
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
	sw %f0 %sp 72 #1760
	sw %ra %sp 84 #1760 call dir
	addi %sp %sp 88 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -88 #1760
	lw %ra %sp 84 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100610 # nontail if
	lw %a0 %sp 64 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 72 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 84 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 88 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -88 #1763
	lw %ra %sp 84 #1763
	jal %zero beq_cont.100611 # then sentence ends
beq_else.100610:
	lw %a0 %sp 64 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 72 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 84 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 88 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -88 #1761
	lw %ra %sp 84 #1761
beq_cont.100611:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 64 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 84 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 88 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -88 #1765
	lw %ra %sp 84 #1765
beq_cont.100608:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100612 # nontail if
	jal %zero beq_cont.100613 # then sentence ends
beq_else.100612:
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
	sw %a2 %sp 80 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 88 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -88 #1147
	lw %ra %sp 84 #1147
	lw %a0 %sp 80 #1757
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
	sw %f0 %sp 88 #1760
	sw %ra %sp 100 #1760 call dir
	addi %sp %sp 104 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -104 #1760
	lw %ra %sp 100 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100615 # nontail if
	lw %a0 %sp 80 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 88 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 100 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 104 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -104 #1763
	lw %ra %sp 100 #1763
	jal %zero beq_cont.100616 # then sentence ends
beq_else.100615:
	lw %a0 %sp 80 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 88 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 100 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 104 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -104 #1761
	lw %ra %sp 100 #1761
beq_cont.100616:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 80 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 100 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 104 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -104 #1765
	lw %ra %sp 100 #1765
beq_cont.100613:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100617 # nontail if
	jal %zero beq_cont.100618 # then sentence ends
beq_else.100617:
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
	sw %a2 %sp 96 #1147
	add %a1 %a6 %zero
	add %a0 %a3 %zero
	sw %ra %sp 100 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 104 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -104 #1147
	lw %ra %sp 100 #1147
	lw %a0 %sp 96 #1757
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
	sw %f0 %sp 104 #1760
	sw %ra %sp 116 #1760 call dir
	addi %sp %sp 120 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -120 #1760
	lw %ra %sp 116 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100620 # nontail if
	lw %a0 %sp 96 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 104 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 116 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 120 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -120 #1763
	lw %ra %sp 116 #1763
	jal %zero beq_cont.100621 # then sentence ends
beq_else.100620:
	lw %a0 %sp 96 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 104 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 116 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 120 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -120 #1761
	lw %ra %sp 116 #1761
beq_cont.100621:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 96 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 116 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 120 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -120 #1765
	lw %ra %sp 116 #1765
beq_cont.100618:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100622 # nontail if
	jal %zero beq_cont.100623 # then sentence ends
beq_else.100622:
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
	sw %a0 %sp 112 #1147
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 116 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 120 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -120 #1147
	lw %ra %sp 116 #1147
	lw %a0 %sp 112 #1757
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
	sw %f0 %sp 120 #1760
	sw %ra %sp 132 #1760 call dir
	addi %sp %sp 136 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -136 #1760
	lw %ra %sp 132 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100625 # nontail if
	lw %a0 %sp 112 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 120 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 20 #1763
	add %a0 %a1 %zero
	sw %ra %sp 132 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 136 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -136 #1763
	lw %ra %sp 132 #1763
	jal %zero beq_cont.100626 # then sentence ends
beq_else.100625:
	lw %a0 %sp 112 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 120 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 20 #1761
	add %a0 %a1 %zero
	sw %ra %sp 132 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 136 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -136 #1761
	lw %ra %sp 132 #1761
beq_cont.100626:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 112 #1765
	lw %a1 %sp 24 #1765
	lw %a2 %sp 40 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 132 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 136 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -136 #1765
	lw %ra %sp 132 #1765
beq_cont.100623:
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
calc_diffuse_using_5points.2595:
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
do_without_neighbors.2601:
	lw %a2 %a11 24 #1841
	lw %a3 %a11 20 #1841
	lw %a4 %a11 16 #1841
	lw %a5 %a11 12 #1841
	lw %a6 %a11 8 #1841
	lw %a7 %a11 4 #1841
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.100629
	lw %a8 %a0 8 #454
	slli %a9 %a1 2 #1662
	add %a12 %a8 %a9 #1662
	lw %a8 %a12 0 #1662
	addi %a12 %zero 0
	blt %a8 %a12 bge_else.100630
	lw %a8 %a0 12 #461
	slli %a9 %a1 2 #1669
	add %a12 %a8 %a9 #1669
	lw %a8 %a12 0 #1669
	sw %a11 %sp 0 #1669
	sw %a3 %sp 4 #1669
	sw %a4 %sp 8 #1669
	sw %a2 %sp 12 #1669
	sw %a5 %sp 16 #1669
	sw %a6 %sp 20 #1669
	sw %a7 %sp 24 #1669
	sw %a0 %sp 28 #1669
	sw %a1 %sp 32 #1669
	addi %a12 %zero 0
	bne %a8 %a12 beq_else.100631 # nontail if
	jal %zero beq_cont.100632 # then sentence ends
beq_else.100631:
	lw %a8 %a0 20 #475
	lw %a9 %a0 28 #498
	lw %a10 %a0 4 #446
	lw %a11 %a0 16 #468
	slli %a7 %a1 2 #1810
	add %a12 %a8 %a7 #1810
	lw %a7 %a12 0 #1810
	lw %f0 %a7 0 #152
	sw %f0 %a6 0 #152
	lw %f0 %a7 4 #152
	sw %f0 %a6 4 #153
	lw %f0 %a7 8 #152
	sw %f0 %a6 8 #154
	lw %a7 %a0 24 #484
	lw %a7 %a7 0 #486
	slli %a8 %a1 2 #1676
	add %a12 %a9 %a8 #1676
	lw %a8 %a12 0 #1676
	slli %a9 %a1 2 #1664
	add %a12 %a10 %a9 #1664
	lw %a9 %a12 0 #1664
	sw %a11 %sp 36 #1780
	sw %a8 %sp 40 #1780
	sw %a9 %sp 44 #1780
	sw %a7 %sp 48 #1780
	addi %a12 %zero 0
	bne %a7 %a12 beq_else.100633 # nontail if
	jal %zero beq_cont.100634 # then sentence ends
beq_else.100633:
	lw %a10 %a5 0 #81
	sw %a10 %sp 52 #1771
	add %a0 %a9 %zero
	add %a11 %a2 %zero
	sw %ra %sp 60 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 64 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -64 #1771
	lw %ra %sp 60 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 52 #1774
	lw %a1 %sp 40 #1774
	lw %a2 %sp 44 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 60 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 64 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -64 #1774
	lw %ra %sp 60 #1774
beq_cont.100634:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100635 # nontail if
	jal %zero beq_cont.100636 # then sentence ends
beq_else.100635:
	lw %a1 %sp 16 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 44 #1771
	lw %a11 %sp 12 #1771
	sw %a2 %sp 56 #1771
	add %a0 %a3 %zero
	sw %ra %sp 60 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 64 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -64 #1771
	lw %ra %sp 60 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 56 #1774
	lw %a1 %sp 40 #1774
	lw %a2 %sp 44 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 60 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 64 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -64 #1774
	lw %ra %sp 60 #1774
beq_cont.100636:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100637 # nontail if
	jal %zero beq_cont.100638 # then sentence ends
beq_else.100637:
	lw %a1 %sp 16 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 44 #1771
	lw %a11 %sp 12 #1771
	sw %a2 %sp 60 #1771
	add %a0 %a3 %zero
	sw %ra %sp 68 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 72 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -72 #1771
	lw %ra %sp 68 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 60 #1774
	lw %a1 %sp 40 #1774
	lw %a2 %sp 44 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 68 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 72 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -72 #1774
	lw %ra %sp 68 #1774
beq_cont.100638:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100639 # nontail if
	jal %zero beq_cont.100640 # then sentence ends
beq_else.100639:
	lw %a1 %sp 16 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 44 #1771
	lw %a11 %sp 12 #1771
	sw %a2 %sp 64 #1771
	add %a0 %a3 %zero
	sw %ra %sp 68 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 72 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -72 #1771
	lw %ra %sp 68 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 64 #1774
	lw %a1 %sp 40 #1774
	lw %a2 %sp 44 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 68 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 72 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -72 #1774
	lw %ra %sp 68 #1774
beq_cont.100640:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100641 # nontail if
	jal %zero beq_cont.100642 # then sentence ends
beq_else.100641:
	lw %a0 %sp 16 #81
	lw %a1 %a0 16 #81
	lw %a2 %sp 44 #1771
	lw %a11 %sp 12 #1771
	sw %a1 %sp 68 #1771
	add %a0 %a2 %zero
	sw %ra %sp 76 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 80 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -80 #1771
	lw %ra %sp 76 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 68 #1774
	lw %a1 %sp 40 #1774
	lw %a2 %sp 44 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 76 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 80 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -80 #1774
	lw %ra %sp 76 #1774
beq_cont.100642:
	lw %a0 %sp 32 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 36 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 4 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 20 #219
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
beq_cont.100632:
	lw %a0 %sp 32 #1850
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.100643
	lw %a0 %sp 28 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100644
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 72 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100645 # nontail if
	jal %zero beq_cont.100646 # then sentence ends
beq_else.100645:
	lw %a11 %sp 24 #1848
	sw %ra %sp 76 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 80 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -80 #1848
	lw %ra %sp 76 #1848
beq_cont.100646:
	lw %a0 %sp 72 #1850
	addi %a0 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.100647
	lw %a1 %sp 28 #454
	lw %a2 %a1 8 #454
	slli %a3 %a0 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100648
	lw %a2 %a1 12 #461
	slli %a3 %a0 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100649 # nontail if
	jal %zero beq_cont.100650 # then sentence ends
beq_else.100649:
	lw %a2 %a1 20 #475
	lw %a3 %a1 28 #498
	lw %a4 %a1 4 #446
	lw %a5 %a1 16 #468
	slli %a6 %a0 2 #1810
	add %a12 %a2 %a6 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	lw %a6 %sp 20 #152
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
	sw %a5 %sp 76 #1780
	sw %a0 %sp 80 #1780
	sw %a3 %sp 84 #1780
	sw %a4 %sp 88 #1780
	sw %a2 %sp 92 #1780
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100651 # nontail if
	jal %zero beq_cont.100652 # then sentence ends
beq_else.100651:
	lw %a7 %sp 16 #81
	lw %a8 %a7 0 #81
	lw %a11 %sp 12 #1771
	sw %a8 %sp 96 #1771
	add %a0 %a4 %zero
	sw %ra %sp 100 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 104 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -104 #1771
	lw %ra %sp 100 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 96 #1774
	lw %a1 %sp 84 #1774
	lw %a2 %sp 88 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 100 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 104 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -104 #1774
	lw %ra %sp 100 #1774
beq_cont.100652:
	lw %a0 %sp 92 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100653 # nontail if
	jal %zero beq_cont.100654 # then sentence ends
beq_else.100653:
	lw %a1 %sp 16 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 88 #1771
	lw %a11 %sp 12 #1771
	sw %a2 %sp 100 #1771
	add %a0 %a3 %zero
	sw %ra %sp 108 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 112 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -112 #1771
	lw %ra %sp 108 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 100 #1774
	lw %a1 %sp 84 #1774
	lw %a2 %sp 88 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 108 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 112 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -112 #1774
	lw %ra %sp 108 #1774
beq_cont.100654:
	lw %a0 %sp 92 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100655 # nontail if
	jal %zero beq_cont.100656 # then sentence ends
beq_else.100655:
	lw %a1 %sp 16 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 88 #1771
	lw %a11 %sp 12 #1771
	sw %a2 %sp 104 #1771
	add %a0 %a3 %zero
	sw %ra %sp 108 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 112 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -112 #1771
	lw %ra %sp 108 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 104 #1774
	lw %a1 %sp 84 #1774
	lw %a2 %sp 88 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 108 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 112 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -112 #1774
	lw %ra %sp 108 #1774
beq_cont.100656:
	lw %a0 %sp 92 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100657 # nontail if
	jal %zero beq_cont.100658 # then sentence ends
beq_else.100657:
	lw %a1 %sp 16 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 88 #1771
	lw %a11 %sp 12 #1771
	sw %a2 %sp 108 #1771
	add %a0 %a3 %zero
	sw %ra %sp 116 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 120 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -120 #1771
	lw %ra %sp 116 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 108 #1774
	lw %a1 %sp 84 #1774
	lw %a2 %sp 88 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 116 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 120 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -120 #1774
	lw %ra %sp 116 #1774
beq_cont.100658:
	lw %a0 %sp 92 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100659 # nontail if
	jal %zero beq_cont.100660 # then sentence ends
beq_else.100659:
	lw %a0 %sp 16 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 88 #1771
	lw %a11 %sp 12 #1771
	sw %a0 %sp 112 #1771
	add %a0 %a1 %zero
	sw %ra %sp 116 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 120 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -120 #1771
	lw %ra %sp 116 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 112 #1774
	lw %a1 %sp 84 #1774
	lw %a2 %sp 88 #1774
	lw %a11 %sp 8 #1774
	sw %ra %sp 116 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 120 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -120 #1774
	lw %ra %sp 116 #1774
beq_cont.100660:
	lw %a0 %sp 80 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 76 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 4 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 20 #219
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
beq_cont.100650:
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.100661
	lw %a0 %sp 28 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100662
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 116 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100663 # nontail if
	jal %zero beq_cont.100664 # then sentence ends
beq_else.100663:
	lw %a11 %sp 24 #1848
	sw %ra %sp 124 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 128 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -128 #1848
	lw %ra %sp 124 #1848
beq_cont.100664:
	lw %a0 %sp 116 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 28 #1850
	lw %a11 %sp 0 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.100662:
	jalr %zero %ra 0 #1851
bge_else.100661:
	jalr %zero %ra 0 #1852
bge_else.100648:
	jalr %zero %ra 0 #1851
bge_else.100647:
	jalr %zero %ra 0 #1852
bge_else.100644:
	jalr %zero %ra 0 #1851
bge_else.100643:
	jalr %zero %ra 0 #1852
bge_else.100630:
	jalr %zero %ra 0 #1851
bge_else.100629:
	jalr %zero %ra 0 #1852
try_exploit_neighbors.2617:
	lw %a6 %a11 32 #1890
	lw %a7 %a11 28 #1890
	lw %a8 %a11 24 #1890
	lw %a9 %a11 20 #1890
	lw %a10 %a11 16 #1890
	sw %a1 %sp 0 #1890
	lw %a1 %a11 12 #1890
	sw %a9 %sp 4 #1890
	lw %a9 %a11 8 #1890
	sw %a11 %sp 8 #1890
	lw %a11 %a11 4 #1890
	sw %a9 %sp 12 #1891
	slli %a9 %a0 2 #1891
	add %a12 %a3 %a9 #1891
	lw %a9 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a5 bge_else.100673
	sw %a7 %sp 16 #454
	lw %a7 %a9 8 #454
	sw %a8 %sp 20 #1662
	slli %a8 %a5 2 #1662
	add %a12 %a7 %a8 #1662
	lw %a7 %a12 0 #1662
	addi %a12 %zero 0
	blt %a7 %a12 bge_else.100674
	slli %a7 %a0 2 #1875
	add %a12 %a3 %a7 #1875
	lw %a7 %a12 0 #1875
	lw %a7 %a7 8 #454
	slli %a8 %a5 2 #1662
	add %a12 %a7 %a8 #1662
	lw %a7 %a12 0 #1662
	slli %a8 %a0 2 #1877
	add %a12 %a2 %a8 #1877
	lw %a8 %a12 0 #1877
	lw %a8 %a8 8 #454
	sw %a2 %sp 24 #1662
	slli %a2 %a5 2 #1662
	add %a12 %a8 %a2 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a7 beq_else.100675 # nontail if
	slli %a2 %a0 2 #1878
	add %a12 %a4 %a2 #1878
	lw %a2 %a12 0 #1878
	lw %a2 %a2 8 #454
	slli %a8 %a5 2 #1662
	add %a12 %a2 %a8 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a7 beq_else.100677 # nontail if
	addi %a2 %a0 -1 #1879
	slli %a2 %a2 2 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a2 %a2 8 #454
	slli %a8 %a5 2 #1662
	add %a12 %a2 %a8 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a7 beq_else.100679 # nontail if
	addi %a2 %a0 1 #1880
	slli %a2 %a2 2 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a2 %a2 8 #454
	slli %a8 %a5 2 #1662
	add %a12 %a2 %a8 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a7 beq_else.100681 # nontail if
	addi %a2 %zero 1 #1881
	jal %zero beq_cont.100682 # then sentence ends
beq_else.100681:
	addi %a2 %zero 0 #1882
beq_cont.100682:
	jal %zero beq_cont.100680 # then sentence ends
beq_else.100679:
	addi %a2 %zero 0 #1883
beq_cont.100680:
	jal %zero beq_cont.100678 # then sentence ends
beq_else.100677:
	addi %a2 %zero 0 #1884
beq_cont.100678:
	jal %zero beq_cont.100676 # then sentence ends
beq_else.100675:
	addi %a2 %zero 0 #1885
beq_cont.100676:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100683
	addi %a12 %zero 4
	blt %a12 %a5 bge_else.100684
	lw %a0 %a9 8 #454
	slli %a2 %a5 2 #1662
	add %a12 %a0 %a2 #1662
	lw %a0 %a12 0 #1662
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100685
	lw %a0 %a9 12 #461
	slli %a2 %a5 2 #1669
	add %a12 %a0 %a2 #1669
	lw %a0 %a12 0 #1669
	sw %a11 %sp 28 #1669
	sw %a6 %sp 32 #1669
	sw %a10 %sp 36 #1669
	sw %a1 %sp 40 #1669
	sw %a9 %sp 44 #1669
	sw %a5 %sp 48 #1669
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100686 # nontail if
	jal %zero beq_cont.100687 # then sentence ends
beq_else.100686:
	add %a1 %a5 %zero
	add %a0 %a9 %zero
	sw %ra %sp 52 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 56 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -56 #1848
	lw %ra %sp 52 #1848
beq_cont.100687:
	lw %a0 %sp 48 #1850
	addi %a0 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.100688
	lw %a1 %sp 44 #454
	lw %a2 %a1 8 #454
	slli %a3 %a0 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100689
	lw %a2 %a1 12 #461
	slli %a3 %a0 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100690 # nontail if
	jal %zero beq_cont.100691 # then sentence ends
beq_else.100690:
	lw %a2 %a1 20 #475
	lw %a3 %a1 28 #498
	lw %a4 %a1 4 #446
	lw %a5 %a1 16 #468
	slli %a6 %a0 2 #1810
	add %a12 %a2 %a6 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	lw %a6 %sp 40 #152
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
	sw %a5 %sp 52 #1780
	sw %a0 %sp 56 #1780
	sw %a3 %sp 60 #1780
	sw %a4 %sp 64 #1780
	sw %a2 %sp 68 #1780
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100692 # nontail if
	jal %zero beq_cont.100693 # then sentence ends
beq_else.100692:
	lw %a7 %sp 36 #81
	lw %a8 %a7 0 #81
	lw %a11 %sp 32 #1771
	sw %a8 %sp 72 #1771
	add %a0 %a4 %zero
	sw %ra %sp 76 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 80 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -80 #1771
	lw %ra %sp 76 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 72 #1774
	lw %a1 %sp 60 #1774
	lw %a2 %sp 64 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 76 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 80 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -80 #1774
	lw %ra %sp 76 #1774
beq_cont.100693:
	lw %a0 %sp 68 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100694 # nontail if
	jal %zero beq_cont.100695 # then sentence ends
beq_else.100694:
	lw %a1 %sp 36 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 64 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 76 #1771
	add %a0 %a3 %zero
	sw %ra %sp 84 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 88 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -88 #1771
	lw %ra %sp 84 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 76 #1774
	lw %a1 %sp 60 #1774
	lw %a2 %sp 64 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 84 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 88 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -88 #1774
	lw %ra %sp 84 #1774
beq_cont.100695:
	lw %a0 %sp 68 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100696 # nontail if
	jal %zero beq_cont.100697 # then sentence ends
beq_else.100696:
	lw %a1 %sp 36 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 64 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 80 #1771
	add %a0 %a3 %zero
	sw %ra %sp 84 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 88 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -88 #1771
	lw %ra %sp 84 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 80 #1774
	lw %a1 %sp 60 #1774
	lw %a2 %sp 64 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 84 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 88 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -88 #1774
	lw %ra %sp 84 #1774
beq_cont.100697:
	lw %a0 %sp 68 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100698 # nontail if
	jal %zero beq_cont.100699 # then sentence ends
beq_else.100698:
	lw %a1 %sp 36 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 64 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 84 #1771
	add %a0 %a3 %zero
	sw %ra %sp 92 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 96 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -96 #1771
	lw %ra %sp 92 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 84 #1774
	lw %a1 %sp 60 #1774
	lw %a2 %sp 64 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 92 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 96 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -96 #1774
	lw %ra %sp 92 #1774
beq_cont.100699:
	lw %a0 %sp 68 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100700 # nontail if
	jal %zero beq_cont.100701 # then sentence ends
beq_else.100700:
	lw %a0 %sp 36 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 64 #1771
	lw %a11 %sp 32 #1771
	sw %a0 %sp 88 #1771
	add %a0 %a1 %zero
	sw %ra %sp 92 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 96 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -96 #1771
	lw %ra %sp 92 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 88 #1774
	lw %a1 %sp 60 #1774
	lw %a2 %sp 64 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 92 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 96 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -96 #1774
	lw %ra %sp 92 #1774
beq_cont.100701:
	lw %a0 %sp 56 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 52 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 16 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 40 #219
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
beq_cont.100691:
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.100702
	lw %a0 %sp 44 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100703
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 92 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100704 # nontail if
	jal %zero beq_cont.100705 # then sentence ends
beq_else.100704:
	lw %a11 %sp 28 #1848
	sw %ra %sp 100 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 104 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -104 #1848
	lw %ra %sp 100 #1848
beq_cont.100705:
	lw %a0 %sp 92 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 44 #1850
	lw %a11 %sp 4 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.100703:
	jalr %zero %ra 0 #1851
bge_else.100702:
	jalr %zero %ra 0 #1852
bge_else.100689:
	jalr %zero %ra 0 #1851
bge_else.100688:
	jalr %zero %ra 0 #1852
bge_else.100685:
	jalr %zero %ra 0 #1851
bge_else.100684:
	jalr %zero %ra 0 #1852
beq_else.100683:
	lw %a2 %a9 12 #461
	slli %a7 %a5 2 #1669
	add %a12 %a2 %a7 #1669
	lw %a2 %a12 0 #1669
	sw %a11 %sp 28 #1669
	sw %a6 %sp 32 #1669
	sw %a10 %sp 36 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100712 # nontail if
	jal %zero beq_cont.100713 # then sentence ends
beq_else.100712:
	slli %a2 %a0 2 #1823
	lw %a7 %sp 24 #1823
	add %a12 %a7 %a2 #1823
	lw %a2 %a12 0 #1823
	lw %a2 %a2 20 #475
	addi %a8 %a0 -1 #1824
	slli %a8 %a8 2 #1824
	add %a12 %a3 %a8 #1824
	lw %a8 %a12 0 #1824
	lw %a8 %a8 20 #475
	slli %a9 %a0 2 #1824
	add %a12 %a3 %a9 #1824
	lw %a9 %a12 0 #1824
	lw %a9 %a9 20 #475
	addi %a11 %a0 1 #1826
	slli %a11 %a11 2 #1824
	add %a12 %a3 %a11 #1824
	lw %a11 %a12 0 #1824
	lw %a11 %a11 20 #475
	slli %a6 %a0 2 #1827
	add %a12 %a4 %a6 #1827
	lw %a6 %a12 0 #1827
	lw %a6 %a6 20 #475
	slli %a10 %a5 2 #1810
	add %a12 %a2 %a10 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a1 8 #154
	slli %a2 %a5 2 #1810
	add %a12 %a8 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a1 0 #198
	lw %f1 %a2 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a1 0 #198
	lw %f0 %a1 4 #198
	lw %f1 %a2 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a1 4 #199
	lw %f0 %a1 8 #198
	lw %f1 %a2 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a1 8 #200
	slli %a2 %a5 2 #1810
	add %a12 %a9 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a1 0 #198
	lw %f1 %a2 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a1 0 #198
	lw %f0 %a1 4 #198
	lw %f1 %a2 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a1 4 #199
	lw %f0 %a1 8 #198
	lw %f1 %a2 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a1 8 #200
	slli %a2 %a5 2 #1810
	add %a12 %a11 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a1 0 #198
	lw %f1 %a2 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a1 0 #198
	lw %f0 %a1 4 #198
	lw %f1 %a2 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a1 4 #199
	lw %f0 %a1 8 #198
	lw %f1 %a2 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a1 8 #200
	slli %a2 %a5 2 #1810
	add %a12 %a6 %a2 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a1 0 #198
	lw %f1 %a2 0 #198
	fadd %f0 %f0 %f1 #198
	sw %f0 %a1 0 #198
	lw %f0 %a1 4 #198
	lw %f1 %a2 4 #198
	fadd %f0 %f0 %f1 #199
	sw %f0 %a1 4 #199
	lw %f0 %a1 8 #198
	lw %f1 %a2 8 #198
	fadd %f0 %f0 %f1 #200
	sw %f0 %a1 8 #200
	slli %a2 %a0 2 #1824
	add %a12 %a3 %a2 #1824
	lw %a2 %a12 0 #1824
	lw %a2 %a2 16 #468
	slli %a6 %a5 2 #1673
	add %a12 %a2 %a6 #1673
	lw %a2 %a12 0 #1673
	lw %a6 %sp 16 #219
	lw %f0 %a6 0 #219
	lw %f1 %a2 0 #219
	lw %f2 %a1 0 #219
	fmul %f1 %f1 %f2 #219
	fadd %f0 %f0 %f1 #219
	sw %f0 %a6 0 #219
	lw %f0 %a6 4 #219
	lw %f1 %a2 4 #219
	lw %f2 %a1 4 #219
	fmul %f1 %f1 %f2 #220
	fadd %f0 %f0 %f1 #220
	sw %f0 %a6 4 #220
	lw %f0 %a6 8 #219
	lw %f1 %a2 8 #219
	lw %f2 %a1 8 #219
	fmul %f1 %f1 %f2 #221
	fadd %f0 %f0 %f1 #221
	sw %f0 %a6 8 #221
beq_cont.100713:
	addi %a2 %a5 1 #1906
	slli %a5 %a0 2 #1891
	add %a12 %a3 %a5 #1891
	lw %a5 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a2 bge_else.100714
	lw %a6 %a5 8 #454
	slli %a7 %a2 2 #1662
	add %a12 %a6 %a7 #1662
	lw %a6 %a12 0 #1662
	addi %a12 %zero 0
	blt %a6 %a12 bge_else.100715
	slli %a6 %a0 2 #1875
	add %a12 %a3 %a6 #1875
	lw %a6 %a12 0 #1875
	lw %a6 %a6 8 #454
	slli %a7 %a2 2 #1662
	add %a12 %a6 %a7 #1662
	lw %a6 %a12 0 #1662
	slli %a7 %a0 2 #1877
	lw %a8 %sp 24 #1877
	add %a12 %a8 %a7 #1877
	lw %a7 %a12 0 #1877
	lw %a7 %a7 8 #454
	slli %a9 %a2 2 #1662
	add %a12 %a7 %a9 #1662
	lw %a7 %a12 0 #1662
	bne %a7 %a6 beq_else.100716 # nontail if
	slli %a7 %a0 2 #1878
	add %a12 %a4 %a7 #1878
	lw %a7 %a12 0 #1878
	lw %a7 %a7 8 #454
	slli %a9 %a2 2 #1662
	add %a12 %a7 %a9 #1662
	lw %a7 %a12 0 #1662
	bne %a7 %a6 beq_else.100718 # nontail if
	addi %a7 %a0 -1 #1879
	slli %a7 %a7 2 #1875
	add %a12 %a3 %a7 #1875
	lw %a7 %a12 0 #1875
	lw %a7 %a7 8 #454
	slli %a9 %a2 2 #1662
	add %a12 %a7 %a9 #1662
	lw %a7 %a12 0 #1662
	bne %a7 %a6 beq_else.100720 # nontail if
	addi %a7 %a0 1 #1880
	slli %a7 %a7 2 #1875
	add %a12 %a3 %a7 #1875
	lw %a7 %a12 0 #1875
	lw %a7 %a7 8 #454
	slli %a9 %a2 2 #1662
	add %a12 %a7 %a9 #1662
	lw %a7 %a12 0 #1662
	bne %a7 %a6 beq_else.100722 # nontail if
	addi %a6 %zero 1 #1881
	jal %zero beq_cont.100723 # then sentence ends
beq_else.100722:
	addi %a6 %zero 0 #1882
beq_cont.100723:
	jal %zero beq_cont.100721 # then sentence ends
beq_else.100720:
	addi %a6 %zero 0 #1883
beq_cont.100721:
	jal %zero beq_cont.100719 # then sentence ends
beq_else.100718:
	addi %a6 %zero 0 #1884
beq_cont.100719:
	jal %zero beq_cont.100717 # then sentence ends
beq_else.100716:
	addi %a6 %zero 0 #1885
beq_cont.100717:
	addi %a12 %zero 0
	bne %a6 %a12 beq_else.100724
	addi %a12 %zero 4
	blt %a12 %a2 bge_else.100725
	lw %a0 %a5 8 #454
	slli %a3 %a2 2 #1662
	add %a12 %a0 %a3 #1662
	lw %a0 %a12 0 #1662
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100726
	lw %a0 %a5 12 #461
	slli %a3 %a2 2 #1669
	add %a12 %a0 %a3 #1669
	lw %a0 %a12 0 #1669
	sw %a5 %sp 96 #1669
	sw %a2 %sp 100 #1669
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100727 # nontail if
	jal %zero beq_cont.100728 # then sentence ends
beq_else.100727:
	lw %a0 %a5 20 #475
	lw %a3 %a5 28 #498
	lw %a4 %a5 4 #446
	lw %a6 %a5 16 #468
	slli %a7 %a2 2 #1810
	add %a12 %a0 %a7 #1810
	lw %a0 %a12 0 #1810
	lw %f0 %a0 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a1 8 #154
	lw %a0 %a5 24 #484
	lw %a0 %a0 0 #486
	slli %a7 %a2 2 #1676
	add %a12 %a3 %a7 #1676
	lw %a3 %a12 0 #1676
	slli %a7 %a2 2 #1664
	add %a12 %a4 %a7 #1664
	lw %a4 %a12 0 #1664
	sw %a1 %sp 40 #1780
	sw %a6 %sp 104 #1780
	sw %a3 %sp 108 #1780
	sw %a4 %sp 112 #1780
	sw %a0 %sp 116 #1780
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100729 # nontail if
	jal %zero beq_cont.100730 # then sentence ends
beq_else.100729:
	lw %a7 %sp 36 #81
	lw %a8 %a7 0 #81
	lw %a11 %sp 32 #1771
	sw %a8 %sp 120 #1771
	add %a0 %a4 %zero
	sw %ra %sp 124 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 128 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -128 #1771
	lw %ra %sp 124 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 120 #1774
	lw %a1 %sp 108 #1774
	lw %a2 %sp 112 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 124 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 128 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -128 #1774
	lw %ra %sp 124 #1774
beq_cont.100730:
	lw %a0 %sp 116 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100731 # nontail if
	jal %zero beq_cont.100732 # then sentence ends
beq_else.100731:
	lw %a1 %sp 36 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 112 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 124 #1771
	add %a0 %a3 %zero
	sw %ra %sp 132 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 136 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -136 #1771
	lw %ra %sp 132 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 124 #1774
	lw %a1 %sp 108 #1774
	lw %a2 %sp 112 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 132 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 136 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -136 #1774
	lw %ra %sp 132 #1774
beq_cont.100732:
	lw %a0 %sp 116 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100733 # nontail if
	jal %zero beq_cont.100734 # then sentence ends
beq_else.100733:
	lw %a1 %sp 36 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 112 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 128 #1771
	add %a0 %a3 %zero
	sw %ra %sp 132 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 136 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -136 #1771
	lw %ra %sp 132 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 128 #1774
	lw %a1 %sp 108 #1774
	lw %a2 %sp 112 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 132 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 136 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -136 #1774
	lw %ra %sp 132 #1774
beq_cont.100734:
	lw %a0 %sp 116 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100735 # nontail if
	jal %zero beq_cont.100736 # then sentence ends
beq_else.100735:
	lw %a1 %sp 36 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 112 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 132 #1771
	add %a0 %a3 %zero
	sw %ra %sp 140 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 144 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -144 #1771
	lw %ra %sp 140 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 132 #1774
	lw %a1 %sp 108 #1774
	lw %a2 %sp 112 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 140 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 144 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -144 #1774
	lw %ra %sp 140 #1774
beq_cont.100736:
	lw %a0 %sp 116 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100737 # nontail if
	jal %zero beq_cont.100738 # then sentence ends
beq_else.100737:
	lw %a0 %sp 36 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 112 #1771
	lw %a11 %sp 32 #1771
	sw %a0 %sp 136 #1771
	add %a0 %a1 %zero
	sw %ra %sp 140 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 144 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -144 #1771
	lw %ra %sp 140 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 136 #1774
	lw %a1 %sp 108 #1774
	lw %a2 %sp 112 #1774
	lw %a11 %sp 20 #1774
	sw %ra %sp 140 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 144 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -144 #1774
	lw %ra %sp 140 #1774
beq_cont.100738:
	lw %a0 %sp 100 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 104 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 16 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 40 #219
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
beq_cont.100728:
	lw %a0 %sp 100 #1850
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.100739
	lw %a0 %sp 96 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100740
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 140 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100741 # nontail if
	jal %zero beq_cont.100742 # then sentence ends
beq_else.100741:
	lw %a11 %sp 28 #1848
	sw %ra %sp 148 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 152 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -152 #1848
	lw %ra %sp 148 #1848
beq_cont.100742:
	lw %a0 %sp 140 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 96 #1850
	lw %a11 %sp 4 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.100740:
	jalr %zero %ra 0 #1851
bge_else.100739:
	jalr %zero %ra 0 #1852
bge_else.100726:
	jalr %zero %ra 0 #1851
bge_else.100725:
	jalr %zero %ra 0 #1852
beq_else.100724:
	lw %a1 %a5 12 #461
	slli %a5 %a2 2 #1669
	add %a12 %a1 %a5 #1669
	lw %a1 %a12 0 #1669
	sw %a4 %sp 144 #1669
	sw %a3 %sp 148 #1669
	sw %a0 %sp 152 #1669
	sw %a2 %sp 100 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100747 # nontail if
	jal %zero beq_cont.100748 # then sentence ends
beq_else.100747:
	lw %a11 %sp 12 #1902
	add %a1 %a8 %zero
	add %a10 %a4 %zero
	add %a4 %a2 %zero
	add %a2 %a3 %zero
	add %a3 %a10 %zero
	sw %ra %sp 156 #1902 call cls
	lw %a10 %a11 0 #1902
	addi %sp %sp 160 #1902	
	jalr %ra %a10 0 #1902
	addi %sp %sp -160 #1902
	lw %ra %sp 156 #1902
beq_cont.100748:
	lw %a0 %sp 100 #1906
	addi %a5 %a0 1 #1906
	lw %a0 %sp 152 #1906
	lw %a1 %sp 0 #1906
	lw %a2 %sp 24 #1906
	lw %a3 %sp 148 #1906
	lw %a4 %sp 144 #1906
	lw %a11 %sp 8 #1906
	lw %a10 %a11 0 #1906
	jalr %zero %a10 0 #1906
bge_else.100715:
	jalr %zero %ra 0 #1910
bge_else.100714:
	jalr %zero %ra 0 #1911
bge_else.100674:
	jalr %zero %ra 0 #1910
bge_else.100673:
	jalr %zero %ra 0 #1911
pretrace_diffuse_rays.2630:
	lw %a2 %a11 32 #1949
	lw %a3 %a11 28 #1949
	lw %a4 %a11 24 #1949
	lw %a5 %a11 20 #1949
	lw %a6 %a11 16 #1949
	lw %a7 %a11 12 #1949
	lw %a8 %a11 8 #1949
	lw %a9 %a11 4 #1949
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.100753
	lw %a10 %a0 8 #454
	sw %a11 %sp 0 #1662
	slli %a11 %a1 2 #1662
	add %a12 %a10 %a11 #1662
	lw %a10 %a12 0 #1662
	addi %a12 %zero 0
	blt %a10 %a12 bge_else.100754
	lw %a10 %a0 12 #461
	slli %a11 %a1 2 #1669
	add %a12 %a10 %a11 #1669
	lw %a10 %a12 0 #1669
	sw %a7 %sp 4 #1669
	sw %a2 %sp 8 #1669
	sw %a4 %sp 12 #1669
	sw %a6 %sp 16 #1669
	sw %a3 %sp 20 #1669
	sw %a8 %sp 24 #1669
	sw %a9 %sp 28 #1669
	sw %a1 %sp 32 #1669
	addi %a12 %zero 0
	bne %a10 %a12 beq_else.100755 # nontail if
	jal %zero beq_cont.100756 # then sentence ends
beq_else.100755:
	lw %a10 %a0 24 #484
	lw %a10 %a10 0 #486
	li %f0 l.90390 #147
	sw %f0 %a9 0 #140
	sw %f0 %a9 4 #141
	sw %f0 %a9 8 #142
	lw %a11 %a0 28 #498
	lw %a2 %a0 4 #446
	slli %a10 %a10 2 #81
	add %a12 %a8 %a10 #81
	lw %a10 %a12 0 #81
	slli %a4 %a1 2 #1676
	add %a12 %a11 %a4 #1676
	lw %a4 %a12 0 #1676
	slli %a11 %a1 2 #1664
	add %a12 %a2 %a11 #1664
	lw %a2 %a12 0 #1664
	sw %a0 %sp 36 #1771
	sw %a2 %sp 40 #1771
	sw %a4 %sp 44 #1771
	sw %a10 %sp 48 #1771
	add %a0 %a2 %zero
	add %a11 %a5 %zero
	sw %ra %sp 52 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 56 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -56 #1771
	lw %ra %sp 52 #1771
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
beq_cont.100756:
	lw %a1 %sp 32 #1971
	addi %a1 %a1 1 #1971
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.100757
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100758
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 52 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100759 # nontail if
	jal %zero beq_cont.100760 # then sentence ends
beq_else.100759:
	lw %a2 %a0 24 #484
	lw %a2 %a2 0 #486
	li %f0 l.90390 #147
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
	sw %f0 %sp 72 #1760
	sw %ra %sp 84 #1760 call dir
	addi %sp %sp 88 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -88 #1760
	lw %ra %sp 84 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100762 # nontail if
	lw %a0 %sp 64 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 72 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 8 #1763
	add %a0 %a1 %zero
	sw %ra %sp 84 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 88 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -88 #1763
	lw %ra %sp 84 #1763
	jal %zero beq_cont.100763 # then sentence ends
beq_else.100762:
	lw %a0 %sp 64 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 72 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 8 #1761
	add %a0 %a1 %zero
	sw %ra %sp 84 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 88 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -88 #1761
	lw %ra %sp 84 #1761
beq_cont.100763:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 64 #1765
	lw %a1 %sp 60 #1765
	lw %a2 %sp 56 #1765
	lw %a11 %sp 4 #1765
	sw %ra %sp 84 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 88 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -88 #1765
	lw %ra %sp 84 #1765
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
beq_cont.100760:
	lw %a1 %sp 52 #1971
	addi %a1 %a1 1 #1971
	lw %a11 %sp 0 #1971
	lw %a10 %a11 0 #1971
	jalr %zero %a10 0 #1971
bge_else.100758:
	jalr %zero %ra 0 #1972
bge_else.100757:
	jalr %zero %ra 0 #1973
bge_else.100754:
	jalr %zero %ra 0 #1972
bge_else.100753:
	jalr %zero %ra 0 #1973
pretrace_pixels.2633:
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
	sw %a2 %sp 32 #1979
	addi %a2 %zero 0 #1979
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.100768
	lw %f3 %a10 0 #61
	sw %a6 %sp 36 #59
	lw %a6 %a6 0 #59
	sub %a6 %a1 %a6 #1981
	sw %a10 %sp 40 #1981
	sw %a11 %sp 44 #1981
	sw %a2 %sp 48 #1981
	sw %a4 %sp 52 #1981
	sw %a0 %sp 56 #1981
	sw %a1 %sp 60 #1981
	sw %a7 %sp 64 #1981
	sw %a3 %sp 68 #1981
	sw %a5 %sp 72 #1981
	sw %f2 %sp 80 #1981
	sw %f1 %sp 88 #1981
	sw %a8 %sp 96 #1981
	sw %f0 %sp 104 #1981
	sw %a9 %sp 112 #1981
	sw %f3 %sp 120 #1981
	add %a0 %a6 %zero
	sw %ra %sp 132 #1981 call dir
	addi %sp %sp 136 #1981	
	jal %ra min_caml_float_of_int #1981
	addi %sp %sp -136 #1981
	lw %ra %sp 132 #1981
	lw %f1 %sp 120 #1981
	fmul %f0 %f1 %f0 #1981
	lw %a0 %sp 112 #69
	lw %f1 %a0 0 #69
	fmul %f1 %f0 %f1 #1982
	lw %f2 %sp 104 #1982
	fadd %f1 %f1 %f2 #1982
	lw %a1 %sp 96 #1982
	sw %f1 %a1 0 #1982
	lw %f1 %a0 4 #69
	fmul %f1 %f0 %f1 #1983
	lw %f3 %sp 88 #1983
	fadd %f1 %f1 %f3 #1983
	sw %f1 %a1 4 #1983
	lw %f1 %a0 8 #69
	fmul %f0 %f0 %f1 #1984
	lw %f1 %sp 80 #1984
	fadd %f0 %f0 %f1 #1984
	sw %f0 %a1 8 #1984
	lw %f0 %a1 0 #172
	sw %ra %sp 132 #172 call dir
	addi %sp %sp 136 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -136 #172
	lw %ra %sp 132 #172
	lw %a0 %sp 96 #172
	lw %f1 %a0 4 #172
	sw %f0 %sp 128 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 140 #172 call dir
	addi %sp %sp 144 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -144 #172
	lw %ra %sp 140 #172
	lw %f1 %sp 128 #172
	fadd %f0 %f1 %f0 #172
	lw %a0 %sp 96 #172
	lw %f1 %a0 8 #172
	sw %f0 %sp 136 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 148 #172 call dir
	addi %sp %sp 152 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -152 #172
	lw %ra %sp 148 #172
	lw %f1 %sp 136 #172
	fadd %f0 %f1 %f0 #172
	sw %ra %sp 148 #172 call dir
	addi %sp %sp 152 #172	
	jal %ra min_caml_sqrt #172
	addi %sp %sp -152 #172
	lw %ra %sp 148 #172
	sw %f0 %sp 144 #173
	sw %ra %sp 156 #173 call dir
	addi %sp %sp 160 #173	
	jal %ra min_caml_fiszero #173
	addi %sp %sp -160 #173
	lw %ra %sp 156 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100772 # nontail if
	li %f0 l.90464 #173
	lw %f1 %sp 144 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.100773 # then sentence ends
beq_else.100772:
	li %f0 l.90464 #173
beq_cont.100773:
	lw %a1 %sp 96 #172
	lw %f1 %a1 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a1 0 #174
	lw %f1 %a1 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a1 4 #175
	lw %f1 %a1 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a1 8 #176
	li %f0 l.90390 #147
	lw %a0 %sp 72 #140
	sw %f0 %a0 0 #140
	sw %f0 %a0 4 #141
	sw %f0 %a0 8 #142
	lw %a2 %sp 68 #152
	lw %f0 %a2 0 #152
	lw %a3 %sp 64 #152
	sw %f0 %a3 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a3 8 #154
	li %f0 l.90464 #1990
	lw %a4 %sp 60 #1990
	slli %a5 %a4 2 #1990
	lw %a6 %sp 56 #1990
	add %a12 %a6 %a5 #1990
	lw %a5 %a12 0 #1990
	li %f1 l.90390 #1990
	lw %a7 %sp 48 #1990
	lw %a11 %sp 52 #1990
	add %a2 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 156 #1990 call cls
	lw %a10 %a11 0 #1990
	addi %sp %sp 160 #1990	
	jalr %ra %a10 0 #1990
	addi %sp %sp -160 #1990
	lw %ra %sp 156 #1990
	lw %a0 %sp 60 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 56 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a1 %a1 0 #439
	lw %a3 %sp 72 #152
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
	lw %a4 %sp 24 #493
	sw %a4 %a1 0 #493
	slli %a1 %a0 2 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a5 %a1 8 #454
	lw %a5 %a5 0 #1662
	addi %a12 %zero 0
	blt %a5 %a12 bge_else.100774 # nontail if
	lw %a5 %a1 12 #461
	lw %a5 %a5 0 #1669
	sw %a1 %sp 152 #1669
	addi %a12 %zero 0
	bne %a5 %a12 beq_else.100776 # nontail if
	jal %zero beq_cont.100777 # then sentence ends
beq_else.100776:
	lw %a5 %a1 24 #484
	lw %a5 %a5 0 #486
	li %f0 l.90390 #147
	lw %a6 %sp 44 #140
	sw %f0 %a6 0 #140
	sw %f0 %a6 4 #141
	sw %f0 %a6 8 #142
	lw %a7 %a1 28 #498
	lw %a8 %a1 4 #446
	slli %a5 %a5 2 #81
	lw %a9 %sp 32 #81
	add %a12 %a9 %a5 #81
	lw %a5 %a12 0 #81
	lw %a7 %a7 0 #1676
	lw %a8 %a8 0 #1664
	lw %f0 %a8 0 #152
	lw %a9 %sp 8 #152
	sw %f0 %a9 0 #152
	lw %f0 %a8 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a8 8 #152
	sw %f0 %a9 8 #154
	lw %a9 %sp 16 #15
	lw %a9 %a9 0 #15
	addi %a9 %a9 -1 #1147
	lw %a11 %sp 4 #1147
	sw %a8 %sp 156 #1147
	sw %a7 %sp 160 #1147
	sw %a5 %sp 164 #1147
	add %a1 %a9 %zero
	add %a0 %a8 %zero
	sw %ra %sp 172 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 176 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -176 #1147
	lw %ra %sp 172 #1147
	lw %a0 %sp 164 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 160 #181
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
	sw %f0 %sp 168 #1760
	sw %ra %sp 180 #1760 call dir
	addi %sp %sp 184 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -184 #1760
	lw %ra %sp 180 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100778 # nontail if
	lw %a0 %sp 164 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.92174 #1763
	lw %f1 %sp 168 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 0 #1763
	add %a0 %a1 %zero
	sw %ra %sp 180 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 184 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -184 #1763
	lw %ra %sp 180 #1763
	jal %zero beq_cont.100779 # then sentence ends
beq_else.100778:
	lw %a0 %sp 164 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.92125 #1761
	lw %f1 %sp 168 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 0 #1761
	add %a0 %a1 %zero
	sw %ra %sp 180 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 184 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -184 #1761
	lw %ra %sp 180 #1761
beq_cont.100779:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 164 #1765
	lw %a1 %sp 160 #1765
	lw %a2 %sp 156 #1765
	lw %a11 %sp 20 #1765
	sw %ra %sp 180 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 184 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -184 #1765
	lw %ra %sp 180 #1765
	lw %a0 %sp 152 #475
	lw %a1 %a0 20 #475
	lw %a1 %a1 0 #1810
	lw %a2 %sp 44 #152
	lw %f0 %a2 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a1 8 #154
beq_cont.100777:
	addi %a1 %zero 1 #1971
	lw %a0 %sp 152 #1971
	lw %a11 %sp 12 #1971
	sw %ra %sp 180 #1971 call cls
	lw %a10 %a11 0 #1971
	addi %sp %sp 184 #1971	
	jalr %ra %a10 0 #1971
	addi %sp %sp -184 #1971
	lw %ra %sp 180 #1971
	jal %zero bge_cont.100775 # then sentence ends
bge_else.100774:
bge_cont.100775:
	lw %a0 %sp 60 #1997
	addi %a0 %a0 -1 #1997
	lw %a1 %sp 24 #123
	addi %a1 %a1 1 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.100780 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.100781 # then sentence ends
bge_else.100780:
bge_cont.100781:
	addi %a2 %zero 0 #1979
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100782
	lw %a3 %sp 40 #61
	lw %f0 %a3 0 #61
	lw %a3 %sp 36 #59
	lw %a3 %a3 0 #59
	sub %a3 %a0 %a3 #1981
	sw %a1 %sp 176 #1981
	sw %a2 %sp 180 #1981
	sw %a0 %sp 184 #1981
	sw %f0 %sp 192 #1981
	add %a0 %a3 %zero
	sw %ra %sp 204 #1981 call dir
	addi %sp %sp 208 #1981	
	jal %ra min_caml_float_of_int #1981
	addi %sp %sp -208 #1981
	lw %ra %sp 204 #1981
	lw %f1 %sp 192 #1981
	fmul %f0 %f1 %f0 #1981
	lw %a0 %sp 112 #69
	lw %f1 %a0 0 #69
	fmul %f1 %f0 %f1 #1982
	lw %f2 %sp 104 #1982
	fadd %f1 %f1 %f2 #1982
	lw %a1 %sp 96 #1982
	sw %f1 %a1 0 #1982
	lw %f1 %a0 4 #69
	fmul %f1 %f0 %f1 #1983
	lw %f3 %sp 88 #1983
	fadd %f1 %f1 %f3 #1983
	sw %f1 %a1 4 #1983
	lw %f1 %a0 8 #69
	fmul %f0 %f0 %f1 #1984
	lw %f1 %sp 80 #1984
	fadd %f0 %f0 %f1 #1984
	sw %f0 %a1 8 #1984
	lw %f0 %a1 0 #172
	sw %ra %sp 204 #172 call dir
	addi %sp %sp 208 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -208 #172
	lw %ra %sp 204 #172
	lw %a0 %sp 96 #172
	lw %f1 %a0 4 #172
	sw %f0 %sp 200 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 212 #172 call dir
	addi %sp %sp 216 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -216 #172
	lw %ra %sp 212 #172
	lw %f1 %sp 200 #172
	fadd %f0 %f1 %f0 #172
	lw %a0 %sp 96 #172
	lw %f1 %a0 8 #172
	sw %f0 %sp 208 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 220 #172 call dir
	addi %sp %sp 224 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -224 #172
	lw %ra %sp 220 #172
	lw %f1 %sp 208 #172
	fadd %f0 %f1 %f0 #172
	sw %ra %sp 220 #172 call dir
	addi %sp %sp 224 #172	
	jal %ra min_caml_sqrt #172
	addi %sp %sp -224 #172
	lw %ra %sp 220 #172
	sw %f0 %sp 216 #173
	sw %ra %sp 228 #173 call dir
	addi %sp %sp 232 #173	
	jal %ra min_caml_fiszero #173
	addi %sp %sp -232 #173
	lw %ra %sp 228 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100784 # nontail if
	li %f0 l.90464 #173
	lw %f1 %sp 216 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.100785 # then sentence ends
beq_else.100784:
	li %f0 l.90464 #173
beq_cont.100785:
	lw %a1 %sp 96 #172
	lw %f1 %a1 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a1 0 #174
	lw %f1 %a1 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a1 4 #175
	lw %f1 %a1 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a1 8 #176
	li %f0 l.90390 #147
	lw %a0 %sp 72 #140
	sw %f0 %a0 0 #140
	sw %f0 %a0 4 #141
	sw %f0 %a0 8 #142
	lw %a2 %sp 68 #152
	lw %f0 %a2 0 #152
	lw %a3 %sp 64 #152
	sw %f0 %a3 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a3 8 #154
	li %f0 l.90464 #1990
	lw %a2 %sp 184 #1990
	slli %a3 %a2 2 #1990
	lw %a4 %sp 56 #1990
	add %a12 %a4 %a3 #1990
	lw %a3 %a12 0 #1990
	li %f1 l.90390 #1990
	lw %a5 %sp 180 #1990
	lw %a11 %sp 52 #1990
	add %a2 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 228 #1990 call cls
	lw %a10 %a11 0 #1990
	addi %sp %sp 232 #1990	
	jalr %ra %a10 0 #1990
	addi %sp %sp -232 #1990
	lw %ra %sp 228 #1990
	lw %a0 %sp 184 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 56 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a1 %a1 0 #439
	lw %a3 %sp 72 #152
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
	lw %a3 %sp 176 #493
	sw %a3 %a1 0 #493
	slli %a1 %a0 2 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a4 %sp 180 #1995
	lw %a11 %sp 12 #1995
	add %a0 %a1 %zero
	add %a1 %a4 %zero
	sw %ra %sp 228 #1995 call cls
	lw %a10 %a11 0 #1995
	addi %sp %sp 232 #1995	
	jalr %ra %a10 0 #1995
	addi %sp %sp -232 #1995
	lw %ra %sp 228 #1995
	lw %a0 %sp 184 #1997
	addi %a1 %a0 -1 #1997
	lw %a0 %sp 176 #123
	addi %a0 %a0 1 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.100786 # nontail if
	addi %a2 %a0 -5 #124
	jal %zero bge_cont.100787 # then sentence ends
bge_else.100786:
	addi %a2 %a0 0 #124
bge_cont.100787:
	lw %f0 %sp 104 #1997
	lw %f1 %sp 88 #1997
	lw %f2 %sp 80 #1997
	lw %a0 %sp 56 #1997
	lw %a11 %sp 28 #1997
	lw %a10 %a11 0 #1997
	jalr %zero %a10 0 #1997
bge_else.100782:
	jalr %zero %ra 0 #1999
bge_else.100768:
	jalr %zero %ra 0 #1999
pretrace_line.2640:
	lw %a3 %a11 52 #2003
	lw %a4 %a11 48 #2003
	lw %a5 %a11 44 #2003
	lw %a6 %a11 40 #2003
	lw %a7 %a11 36 #2003
	lw %a8 %a11 32 #2003
	lw %a9 %a11 28 #2003
	lw %a10 %a11 24 #2003
	sw %a2 %sp 0 #2003
	lw %a2 %a11 20 #2003
	sw %a4 %sp 4 #2003
	lw %a4 %a11 16 #2003
	sw %a4 %sp 8 #2003
	lw %a4 %a11 12 #2003
	sw %a4 %sp 12 #2003
	lw %a4 %a11 8 #2003
	lw %a11 %a11 4 #2003
	lw %f0 %a9 0 #61
	sw %a0 %sp 16 #59
	lw %a0 %a11 4 #59
	sub %a0 %a1 %a0 #2004
	sw %a5 %sp 20 #2004
	sw %a3 %sp 24 #2004
	sw %a10 %sp 28 #2004
	sw %a2 %sp 32 #2004
	sw %a8 %sp 36 #2004
	sw %a11 %sp 40 #2004
	sw %a9 %sp 44 #2004
	sw %a4 %sp 48 #2004
	sw %a6 %sp 52 #2004
	sw %a7 %sp 56 #2004
	sw %f0 %sp 64 #2004
	sw %ra %sp 76 #2004 call dir
	addi %sp %sp 80 #2004	
	jal %ra min_caml_float_of_int #2004
	addi %sp %sp -80 #2004
	lw %ra %sp 76 #2004
	lw %f1 %sp 64 #2004
	fmul %f0 %f1 %f0 #2004
	lw %a0 %sp 56 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 52 #71
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
	lw %a0 %sp 48 #57
	lw %a0 %a0 0 #57
	addi %a0 %a0 -1 #2010
	addi %a1 %zero 0 #1979
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100791
	lw %a2 %sp 44 #61
	lw %f3 %a2 0 #61
	lw %a2 %sp 40 #59
	lw %a2 %a2 0 #59
	sub %a2 %a0 %a2 #1981
	sw %a1 %sp 72 #1981
	sw %a0 %sp 76 #1981
	sw %f0 %sp 80 #1981
	sw %f2 %sp 88 #1981
	sw %f1 %sp 96 #1981
	sw %f3 %sp 104 #1981
	add %a0 %a2 %zero
	sw %ra %sp 116 #1981 call dir
	addi %sp %sp 120 #1981	
	jal %ra min_caml_float_of_int #1981
	addi %sp %sp -120 #1981
	lw %ra %sp 116 #1981
	lw %f1 %sp 104 #1981
	fmul %f0 %f1 %f0 #1981
	lw %a0 %sp 36 #69
	lw %f1 %a0 0 #69
	fmul %f1 %f0 %f1 #1982
	lw %f2 %sp 96 #1982
	fadd %f1 %f1 %f2 #1982
	lw %a1 %sp 32 #1982
	sw %f1 %a1 0 #1982
	lw %f1 %a0 4 #69
	fmul %f1 %f0 %f1 #1983
	lw %f3 %sp 88 #1983
	fadd %f1 %f1 %f3 #1983
	sw %f1 %a1 4 #1983
	lw %f1 %a0 8 #69
	fmul %f0 %f0 %f1 #1984
	lw %f1 %sp 80 #1984
	fadd %f0 %f0 %f1 #1984
	sw %f0 %a1 8 #1984
	lw %f0 %a1 0 #172
	sw %ra %sp 116 #172 call dir
	addi %sp %sp 120 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -120 #172
	lw %ra %sp 116 #172
	lw %a0 %sp 32 #172
	lw %f1 %a0 4 #172
	sw %f0 %sp 112 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 124 #172 call dir
	addi %sp %sp 128 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -128 #172
	lw %ra %sp 124 #172
	lw %f1 %sp 112 #172
	fadd %f0 %f1 %f0 #172
	lw %a0 %sp 32 #172
	lw %f1 %a0 8 #172
	sw %f0 %sp 120 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #172 call dir
	addi %sp %sp 136 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -136 #172
	lw %ra %sp 132 #172
	lw %f1 %sp 120 #172
	fadd %f0 %f1 %f0 #172
	sw %ra %sp 132 #172 call dir
	addi %sp %sp 136 #172	
	jal %ra min_caml_sqrt #172
	addi %sp %sp -136 #172
	lw %ra %sp 132 #172
	sw %f0 %sp 128 #173
	sw %ra %sp 140 #173 call dir
	addi %sp %sp 144 #173	
	jal %ra min_caml_fiszero #173
	addi %sp %sp -144 #173
	lw %ra %sp 140 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.100792 # nontail if
	li %f0 l.90464 #173
	lw %f1 %sp 128 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.100793 # then sentence ends
beq_else.100792:
	li %f0 l.90464 #173
beq_cont.100793:
	lw %a1 %sp 32 #172
	lw %f1 %a1 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a1 0 #174
	lw %f1 %a1 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a1 4 #175
	lw %f1 %a1 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a1 8 #176
	li %f0 l.90390 #147
	lw %a0 %sp 28 #140
	sw %f0 %a0 0 #140
	sw %f0 %a0 4 #141
	sw %f0 %a0 8 #142
	lw %a2 %sp 24 #152
	lw %f0 %a2 0 #152
	lw %a3 %sp 20 #152
	sw %f0 %a3 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a3 8 #154
	li %f0 l.90464 #1990
	lw %a2 %sp 76 #1990
	slli %a3 %a2 2 #1990
	lw %a4 %sp 16 #1990
	add %a12 %a4 %a3 #1990
	lw %a3 %a12 0 #1990
	li %f1 l.90390 #1990
	lw %a5 %sp 72 #1990
	lw %a11 %sp 4 #1990
	add %a2 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 140 #1990 call cls
	lw %a10 %a11 0 #1990
	addi %sp %sp 144 #1990	
	jalr %ra %a10 0 #1990
	addi %sp %sp -144 #1990
	lw %ra %sp 140 #1990
	lw %a0 %sp 76 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 16 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a1 %a1 0 #439
	lw %a3 %sp 28 #152
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
	lw %a3 %sp 0 #493
	sw %a3 %a1 0 #493
	slli %a1 %a0 2 #1990
	add %a12 %a2 %a1 #1990
	lw %a1 %a12 0 #1990
	lw %a4 %sp 72 #1995
	lw %a11 %sp 12 #1995
	add %a0 %a1 %zero
	add %a1 %a4 %zero
	sw %ra %sp 140 #1995 call cls
	lw %a10 %a11 0 #1995
	addi %sp %sp 144 #1995	
	jalr %ra %a10 0 #1995
	addi %sp %sp -144 #1995
	lw %ra %sp 140 #1995
	lw %a0 %sp 76 #1997
	addi %a1 %a0 -1 #1997
	lw %a0 %sp 0 #123
	addi %a0 %a0 1 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.100794 # nontail if
	addi %a2 %a0 -5 #124
	jal %zero bge_cont.100795 # then sentence ends
bge_else.100794:
	addi %a2 %a0 0 #124
bge_cont.100795:
	lw %f0 %sp 96 #1997
	lw %f1 %sp 88 #1997
	lw %f2 %sp 80 #1997
	lw %a0 %sp 16 #1997
	lw %a11 %sp 8 #1997
	lw %a10 %a11 0 #1997
	jalr %zero %a10 0 #1997
bge_else.100791:
	jalr %zero %ra 0 #1999
scan_pixel.2644:
	lw %a5 %a11 40 #2017
	lw %a6 %a11 36 #2017
	lw %a7 %a11 32 #2017
	lw %a8 %a11 28 #2017
	lw %a9 %a11 24 #2017
	lw %a10 %a11 20 #2017
	sw %a5 %sp 0 #2017
	lw %a5 %a11 16 #2017
	sw %a4 %sp 4 #2017
	lw %a4 %a11 12 #2017
	sw %a2 %sp 8 #2017
	lw %a2 %a11 8 #2017
	sw %a11 %sp 12 #2017
	lw %a11 %a11 4 #2017
	sw %a2 %sp 16 #57
	lw %a2 %a9 0 #57
	blt %a0 %a2 bge_else.100797
	jalr %zero %ra 0 #2033
bge_else.100797:
	slli %a2 %a0 2 #2021
	add %a12 %a3 %a2 #2021
	lw %a2 %a12 0 #2021
	lw %a2 %a2 0 #439
	lw %f0 %a2 0 #152
	sw %f0 %a7 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a7 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a7 8 #154
	lw %a2 %a9 4 #57
	sw %a10 %sp 20 #1857
	addi %a10 %a1 1 #1857
	blt %a10 %a2 bge_else.100799 # nontail if
	addi %a2 %zero 0 #1865
	jal %zero bge_cont.100800 # then sentence ends
bge_else.100799:
	addi %a12 %zero 0
	blt %a12 %a1 bge_else.100801 # nontail if
	addi %a2 %zero 0 #1858
	jal %zero bge_cont.100802 # then sentence ends
bge_else.100801:
	lw %a2 %a9 0 #57
	addi %a10 %a0 1 #1859
	blt %a10 %a2 bge_else.100803 # nontail if
	addi %a2 %zero 0 #1858
	jal %zero bge_cont.100804 # then sentence ends
bge_else.100803:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.100805 # nontail if
	addi %a2 %zero 0 #1858
	jal %zero bge_cont.100806 # then sentence ends
bge_else.100805:
	addi %a2 %zero 1 #1861
bge_cont.100806:
bge_cont.100804:
bge_cont.100802:
bge_cont.100800:
	addi %a10 %zero 0 #2024
	sw %a11 %sp 24 #1861
	sw %a8 %sp 28 #1861
	sw %a6 %sp 32 #1861
	sw %a5 %sp 36 #1861
	sw %a4 %sp 40 #1861
	sw %a1 %sp 44 #1861
	sw %a3 %sp 48 #1861
	sw %a9 %sp 52 #1861
	sw %a0 %sp 56 #1861
	sw %a7 %sp 60 #1861
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100807 # nontail if
	slli %a2 %a0 2 #2021
	add %a12 %a3 %a2 #2021
	lw %a2 %a12 0 #2021
	lw %a1 %a2 8 #454
	lw %a1 %a1 0 #1662
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.100809 # nontail if
	lw %a1 %a2 12 #461
	lw %a1 %a1 0 #1669
	sw %a2 %sp 64 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100811 # nontail if
	jal %zero beq_cont.100812 # then sentence ends
beq_else.100811:
	add %a1 %a10 %zero
	add %a0 %a2 %zero
	sw %ra %sp 68 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 72 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -72 #1848
	lw %ra %sp 68 #1848
beq_cont.100812:
	lw %a0 %sp 64 #454
	lw %a1 %a0 8 #454
	lw %a1 %a1 4 #1662
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.100813 # nontail if
	lw %a1 %a0 12 #461
	lw %a1 %a1 4 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100815 # nontail if
	jal %zero beq_cont.100816 # then sentence ends
beq_else.100815:
	lw %a1 %a0 20 #475
	lw %a2 %a0 28 #498
	lw %a3 %a0 4 #446
	lw %a4 %a0 16 #468
	lw %a1 %a1 4 #1810
	lw %f0 %a1 0 #152
	lw %a5 %sp 40 #152
	sw %f0 %a5 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a5 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a5 8 #154
	lw %a1 %a0 24 #484
	lw %a1 %a1 0 #486
	lw %a2 %a2 4 #1676
	lw %a3 %a3 4 #1664
	sw %a4 %sp 68 #1780
	sw %a2 %sp 72 #1780
	sw %a3 %sp 76 #1780
	sw %a1 %sp 80 #1780
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100817 # nontail if
	jal %zero beq_cont.100818 # then sentence ends
beq_else.100817:
	lw %a6 %sp 36 #81
	lw %a7 %a6 0 #81
	lw %a11 %sp 32 #1771
	sw %a7 %sp 84 #1771
	add %a0 %a3 %zero
	sw %ra %sp 92 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 96 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -96 #1771
	lw %ra %sp 92 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 84 #1774
	lw %a1 %sp 72 #1774
	lw %a2 %sp 76 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 92 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 96 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -96 #1774
	lw %ra %sp 92 #1774
beq_cont.100818:
	lw %a0 %sp 80 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100819 # nontail if
	jal %zero beq_cont.100820 # then sentence ends
beq_else.100819:
	lw %a1 %sp 36 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 76 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 88 #1771
	add %a0 %a3 %zero
	sw %ra %sp 92 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 96 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -96 #1771
	lw %ra %sp 92 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 88 #1774
	lw %a1 %sp 72 #1774
	lw %a2 %sp 76 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 92 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 96 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -96 #1774
	lw %ra %sp 92 #1774
beq_cont.100820:
	lw %a0 %sp 80 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100821 # nontail if
	jal %zero beq_cont.100822 # then sentence ends
beq_else.100821:
	lw %a1 %sp 36 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 76 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 92 #1771
	add %a0 %a3 %zero
	sw %ra %sp 100 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 104 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -104 #1771
	lw %ra %sp 100 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 92 #1774
	lw %a1 %sp 72 #1774
	lw %a2 %sp 76 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 100 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 104 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -104 #1774
	lw %ra %sp 100 #1774
beq_cont.100822:
	lw %a0 %sp 80 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100823 # nontail if
	jal %zero beq_cont.100824 # then sentence ends
beq_else.100823:
	lw %a1 %sp 36 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 76 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 96 #1771
	add %a0 %a3 %zero
	sw %ra %sp 100 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 104 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -104 #1771
	lw %ra %sp 100 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 96 #1774
	lw %a1 %sp 72 #1774
	lw %a2 %sp 76 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 100 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 104 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -104 #1774
	lw %ra %sp 100 #1774
beq_cont.100824:
	lw %a0 %sp 80 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100825 # nontail if
	jal %zero beq_cont.100826 # then sentence ends
beq_else.100825:
	lw %a0 %sp 36 #81
	lw %a1 %a0 16 #81
	lw %a2 %sp 76 #1771
	lw %a11 %sp 32 #1771
	sw %a1 %sp 100 #1771
	add %a0 %a2 %zero
	sw %ra %sp 108 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 112 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -112 #1771
	lw %ra %sp 108 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 100 #1774
	lw %a1 %sp 72 #1774
	lw %a2 %sp 76 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 108 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 112 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -112 #1774
	lw %ra %sp 108 #1774
beq_cont.100826:
	lw %a0 %sp 68 #1673
	lw %a0 %a0 4 #1673
	lw %a1 %sp 60 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 40 #219
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
beq_cont.100816:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 64 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 8 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100827 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 8 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100829 # nontail if
	jal %zero beq_cont.100830 # then sentence ends
beq_else.100829:
	lw %a11 %sp 24 #1848
	sw %ra %sp 108 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 112 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -112 #1848
	lw %ra %sp 108 #1848
beq_cont.100830:
	addi %a1 %zero 3 #1850
	lw %a0 %sp 64 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 108 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 112 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -112 #1850
	lw %ra %sp 108 #1850
	jal %zero bge_cont.100828 # then sentence ends
bge_else.100827:
bge_cont.100828:
	jal %zero bge_cont.100814 # then sentence ends
bge_else.100813:
bge_cont.100814:
	jal %zero bge_cont.100810 # then sentence ends
bge_else.100809:
bge_cont.100810:
	jal %zero beq_cont.100808 # then sentence ends
beq_else.100807:
	slli %a2 %a0 2 #1891
	add %a12 %a3 %a2 #1891
	lw %a2 %a12 0 #1891
	lw %a9 %a2 8 #454
	lw %a9 %a9 0 #1662
	addi %a12 %zero 0
	blt %a9 %a12 bge_else.100831 # nontail if
	slli %a9 %a0 2 #1875
	add %a12 %a3 %a9 #1875
	lw %a9 %a12 0 #1875
	lw %a9 %a9 8 #454
	lw %a9 %a9 0 #1662
	slli %a1 %a0 2 #1877
	sw %a10 %sp 104 #1877
	lw %a10 %sp 8 #1877
	add %a12 %a10 %a1 #1877
	lw %a1 %a12 0 #1877
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a9 beq_else.100833 # nontail if
	slli %a1 %a0 2 #1878
	lw %a10 %sp 4 #1878
	add %a12 %a10 %a1 #1878
	lw %a1 %a12 0 #1878
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a9 beq_else.100835 # nontail if
	addi %a1 %a0 -1 #1879
	slli %a1 %a1 2 #1875
	add %a12 %a3 %a1 #1875
	lw %a1 %a12 0 #1875
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a9 beq_else.100837 # nontail if
	addi %a1 %a0 1 #1880
	slli %a1 %a1 2 #1875
	add %a12 %a3 %a1 #1875
	lw %a1 %a12 0 #1875
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a9 beq_else.100839 # nontail if
	addi %a1 %zero 1 #1881
	jal %zero beq_cont.100840 # then sentence ends
beq_else.100839:
	addi %a1 %zero 0 #1882
beq_cont.100840:
	jal %zero beq_cont.100838 # then sentence ends
beq_else.100837:
	addi %a1 %zero 0 #1883
beq_cont.100838:
	jal %zero beq_cont.100836 # then sentence ends
beq_else.100835:
	addi %a1 %zero 0 #1884
beq_cont.100836:
	jal %zero beq_cont.100834 # then sentence ends
beq_else.100833:
	addi %a1 %zero 0 #1885
beq_cont.100834:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100841 # nontail if
	lw %a1 %a2 8 #454
	lw %a1 %a1 0 #1662
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.100843 # nontail if
	lw %a1 %a2 12 #461
	lw %a1 %a1 0 #1669
	sw %a2 %sp 108 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100845 # nontail if
	jal %zero beq_cont.100846 # then sentence ends
beq_else.100845:
	lw %a1 %a2 20 #475
	lw %a9 %a2 28 #498
	lw %a10 %a2 4 #446
	lw %a3 %a2 16 #468
	lw %a1 %a1 0 #1810
	lw %f0 %a1 0 #152
	sw %f0 %a4 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a4 8 #154
	lw %a1 %a2 24 #484
	lw %a1 %a1 0 #486
	lw %a9 %a9 0 #1676
	lw %a10 %a10 0 #1664
	sw %a3 %sp 112 #1780
	sw %a9 %sp 116 #1780
	sw %a10 %sp 120 #1780
	sw %a1 %sp 124 #1780
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100847 # nontail if
	jal %zero beq_cont.100848 # then sentence ends
beq_else.100847:
	lw %a0 %a5 0 #81
	sw %a0 %sp 128 #1771
	add %a0 %a10 %zero
	add %a11 %a6 %zero
	sw %ra %sp 132 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 136 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -136 #1771
	lw %ra %sp 132 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 128 #1774
	lw %a1 %sp 116 #1774
	lw %a2 %sp 120 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 132 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 136 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -136 #1774
	lw %ra %sp 132 #1774
beq_cont.100848:
	lw %a0 %sp 124 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100849 # nontail if
	jal %zero beq_cont.100850 # then sentence ends
beq_else.100849:
	lw %a1 %sp 36 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 120 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 132 #1771
	add %a0 %a3 %zero
	sw %ra %sp 140 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 144 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -144 #1771
	lw %ra %sp 140 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 132 #1774
	lw %a1 %sp 116 #1774
	lw %a2 %sp 120 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 140 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 144 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -144 #1774
	lw %ra %sp 140 #1774
beq_cont.100850:
	lw %a0 %sp 124 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100851 # nontail if
	jal %zero beq_cont.100852 # then sentence ends
beq_else.100851:
	lw %a1 %sp 36 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 120 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 136 #1771
	add %a0 %a3 %zero
	sw %ra %sp 140 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 144 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -144 #1771
	lw %ra %sp 140 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 136 #1774
	lw %a1 %sp 116 #1774
	lw %a2 %sp 120 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 140 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 144 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -144 #1774
	lw %ra %sp 140 #1774
beq_cont.100852:
	lw %a0 %sp 124 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100853 # nontail if
	jal %zero beq_cont.100854 # then sentence ends
beq_else.100853:
	lw %a1 %sp 36 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 120 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 140 #1771
	add %a0 %a3 %zero
	sw %ra %sp 148 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 152 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -152 #1771
	lw %ra %sp 148 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 140 #1774
	lw %a1 %sp 116 #1774
	lw %a2 %sp 120 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 148 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 152 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -152 #1774
	lw %ra %sp 148 #1774
beq_cont.100854:
	lw %a0 %sp 124 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100855 # nontail if
	jal %zero beq_cont.100856 # then sentence ends
beq_else.100855:
	lw %a0 %sp 36 #81
	lw %a1 %a0 16 #81
	lw %a2 %sp 120 #1771
	lw %a11 %sp 32 #1771
	sw %a1 %sp 144 #1771
	add %a0 %a2 %zero
	sw %ra %sp 148 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 152 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -152 #1771
	lw %ra %sp 148 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 144 #1774
	lw %a1 %sp 116 #1774
	lw %a2 %sp 120 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 148 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 152 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -152 #1774
	lw %ra %sp 148 #1774
beq_cont.100856:
	lw %a0 %sp 112 #1673
	lw %a0 %a0 0 #1673
	lw %a1 %sp 60 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 40 #219
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
beq_cont.100846:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 108 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100857 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100859 # nontail if
	jal %zero beq_cont.100860 # then sentence ends
beq_else.100859:
	lw %a11 %sp 24 #1848
	sw %ra %sp 148 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 152 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -152 #1848
	lw %ra %sp 148 #1848
beq_cont.100860:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 108 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 148 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 152 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -152 #1850
	lw %ra %sp 148 #1850
	jal %zero bge_cont.100858 # then sentence ends
bge_else.100857:
bge_cont.100858:
	jal %zero bge_cont.100844 # then sentence ends
bge_else.100843:
bge_cont.100844:
	jal %zero beq_cont.100842 # then sentence ends
beq_else.100841:
	lw %a1 %a2 12 #461
	lw %a1 %a1 0 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100861 # nontail if
	jal %zero beq_cont.100862 # then sentence ends
beq_else.100861:
	lw %a1 %sp 8 #1902
	lw %a2 %sp 4 #1902
	lw %a9 %sp 104 #1902
	lw %a10 %sp 16 #1902
	add %a4 %a9 %zero
	add %a11 %a10 %zero
	add %a10 %a3 %zero
	add %a3 %a2 %zero
	add %a2 %a10 %zero
	sw %ra %sp 148 #1902 call cls
	lw %a10 %a11 0 #1902
	addi %sp %sp 152 #1902	
	jalr %ra %a10 0 #1902
	addi %sp %sp -152 #1902
	lw %ra %sp 148 #1902
beq_cont.100862:
	addi %a5 %zero 1 #1906
	lw %a0 %sp 56 #1906
	lw %a1 %sp 44 #1906
	lw %a2 %sp 8 #1906
	lw %a3 %sp 48 #1906
	lw %a4 %sp 4 #1906
	lw %a11 %sp 0 #1906
	sw %ra %sp 148 #1906 call cls
	lw %a10 %a11 0 #1906
	addi %sp %sp 152 #1906	
	jalr %ra %a10 0 #1906
	addi %sp %sp -152 #1906
	lw %ra %sp 148 #1906
beq_cont.100842:
	jal %zero bge_cont.100832 # then sentence ends
bge_else.100831:
bge_cont.100832:
beq_cont.100808:
	lw %a0 %sp 60 #54
	lw %f0 %a0 0 #54
	sw %ra %sp 148 #1930 call dir
	addi %sp %sp 152 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -152 #1930
	lw %ra %sp 148 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100863 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100865 # nontail if
	jal %zero bge_cont.100866 # then sentence ends
bge_else.100865:
	addi %a0 %zero 0 #1931
bge_cont.100866:
	jal %zero bge_cont.100864 # then sentence ends
bge_else.100863:
	addi %a0 %zero 255 #1931
bge_cont.100864:
	sw %ra %sp 148 #1932 call dir
	addi %sp %sp 152 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -152 #1932
	lw %ra %sp 148 #1932
	addi %a0 %zero 32 #1937
	sw %ra %sp 148 #1937 call dir
	addi %sp %sp 152 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -152 #1937
	lw %ra %sp 148 #1937
	lw %a0 %sp 60 #54
	lw %f0 %a0 4 #54
	sw %ra %sp 148 #1930 call dir
	addi %sp %sp 152 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -152 #1930
	lw %ra %sp 148 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100867 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100869 # nontail if
	jal %zero bge_cont.100870 # then sentence ends
bge_else.100869:
	addi %a0 %zero 0 #1931
bge_cont.100870:
	jal %zero bge_cont.100868 # then sentence ends
bge_else.100867:
	addi %a0 %zero 255 #1931
bge_cont.100868:
	sw %ra %sp 148 #1932 call dir
	addi %sp %sp 152 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -152 #1932
	lw %ra %sp 148 #1932
	addi %a0 %zero 32 #1939
	sw %ra %sp 148 #1939 call dir
	addi %sp %sp 152 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -152 #1939
	lw %ra %sp 148 #1939
	lw %a0 %sp 60 #54
	lw %f0 %a0 8 #54
	sw %ra %sp 148 #1930 call dir
	addi %sp %sp 152 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -152 #1930
	lw %ra %sp 148 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100871 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100873 # nontail if
	jal %zero bge_cont.100874 # then sentence ends
bge_else.100873:
	addi %a0 %zero 0 #1931
bge_cont.100874:
	jal %zero bge_cont.100872 # then sentence ends
bge_else.100871:
	addi %a0 %zero 255 #1931
bge_cont.100872:
	sw %ra %sp 148 #1932 call dir
	addi %sp %sp 152 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -152 #1932
	lw %ra %sp 148 #1932
	addi %a0 %zero 10 #1941
	sw %ra %sp 148 #1941 call dir
	addi %sp %sp 152 #1941	
	jal %ra min_caml_print_char #1941
	addi %sp %sp -152 #1941
	lw %ra %sp 148 #1941
	lw %a0 %sp 56 #2032
	addi %a0 %a0 1 #2032
	lw %a1 %sp 52 #57
	lw %a2 %a1 0 #57
	blt %a0 %a2 bge_else.100875
	jalr %zero %ra 0 #2033
bge_else.100875:
	slli %a2 %a0 2 #2021
	lw %a3 %sp 48 #2021
	add %a12 %a3 %a2 #2021
	lw %a2 %a12 0 #2021
	lw %a2 %a2 0 #439
	lw %f0 %a2 0 #152
	lw %a4 %sp 60 #152
	sw %f0 %a4 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a4 8 #154
	lw %a2 %a1 4 #57
	lw %a5 %sp 44 #1857
	addi %a6 %a5 1 #1857
	blt %a6 %a2 bge_else.100877 # nontail if
	addi %a1 %zero 0 #1865
	jal %zero bge_cont.100878 # then sentence ends
bge_else.100877:
	addi %a12 %zero 0
	blt %a12 %a5 bge_else.100879 # nontail if
	addi %a1 %zero 0 #1858
	jal %zero bge_cont.100880 # then sentence ends
bge_else.100879:
	lw %a1 %a1 0 #57
	addi %a2 %a0 1 #1859
	blt %a2 %a1 bge_else.100881 # nontail if
	addi %a1 %zero 0 #1858
	jal %zero bge_cont.100882 # then sentence ends
bge_else.100881:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.100883 # nontail if
	addi %a1 %zero 0 #1858
	jal %zero bge_cont.100884 # then sentence ends
bge_else.100883:
	addi %a1 %zero 1 #1861
bge_cont.100884:
bge_cont.100882:
bge_cont.100880:
bge_cont.100878:
	addi %a2 %zero 0 #2024
	sw %a0 %sp 148 #1861
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.100885 # nontail if
	slli %a1 %a0 2 #2021
	add %a12 %a3 %a1 #2021
	lw %a1 %a12 0 #2021
	lw %a2 %a1 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100887 # nontail if
	lw %a2 %a1 12 #461
	lw %a2 %a2 0 #1669
	sw %a1 %sp 152 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100889 # nontail if
	jal %zero beq_cont.100890 # then sentence ends
beq_else.100889:
	lw %a2 %a1 20 #475
	lw %a6 %a1 28 #498
	lw %a7 %a1 4 #446
	lw %a8 %a1 16 #468
	lw %a2 %a2 0 #1810
	lw %f0 %a2 0 #152
	lw %a9 %sp 40 #152
	sw %f0 %a9 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a9 8 #154
	lw %a2 %a1 24 #484
	lw %a2 %a2 0 #486
	lw %a6 %a6 0 #1676
	lw %a7 %a7 0 #1664
	sw %a8 %sp 156 #1780
	sw %a6 %sp 160 #1780
	sw %a7 %sp 164 #1780
	sw %a2 %sp 168 #1780
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100891 # nontail if
	jal %zero beq_cont.100892 # then sentence ends
beq_else.100891:
	lw %a10 %sp 36 #81
	lw %a11 %a10 0 #81
	lw %a3 %sp 32 #1771
	sw %a11 %sp 172 #1771
	add %a0 %a7 %zero
	add %a11 %a3 %zero
	sw %ra %sp 180 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 184 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -184 #1771
	lw %ra %sp 180 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 172 #1774
	lw %a1 %sp 160 #1774
	lw %a2 %sp 164 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 180 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 184 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -184 #1774
	lw %ra %sp 180 #1774
beq_cont.100892:
	lw %a0 %sp 168 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100893 # nontail if
	jal %zero beq_cont.100894 # then sentence ends
beq_else.100893:
	lw %a1 %sp 36 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 164 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 176 #1771
	add %a0 %a3 %zero
	sw %ra %sp 180 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 184 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -184 #1771
	lw %ra %sp 180 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 176 #1774
	lw %a1 %sp 160 #1774
	lw %a2 %sp 164 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 180 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 184 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -184 #1774
	lw %ra %sp 180 #1774
beq_cont.100894:
	lw %a0 %sp 168 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100895 # nontail if
	jal %zero beq_cont.100896 # then sentence ends
beq_else.100895:
	lw %a1 %sp 36 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 164 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 180 #1771
	add %a0 %a3 %zero
	sw %ra %sp 188 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 192 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -192 #1771
	lw %ra %sp 188 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 180 #1774
	lw %a1 %sp 160 #1774
	lw %a2 %sp 164 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 188 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 192 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -192 #1774
	lw %ra %sp 188 #1774
beq_cont.100896:
	lw %a0 %sp 168 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100897 # nontail if
	jal %zero beq_cont.100898 # then sentence ends
beq_else.100897:
	lw %a1 %sp 36 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 164 #1771
	lw %a11 %sp 32 #1771
	sw %a2 %sp 184 #1771
	add %a0 %a3 %zero
	sw %ra %sp 188 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 192 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -192 #1771
	lw %ra %sp 188 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 184 #1774
	lw %a1 %sp 160 #1774
	lw %a2 %sp 164 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 188 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 192 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -192 #1774
	lw %ra %sp 188 #1774
beq_cont.100898:
	lw %a0 %sp 168 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100899 # nontail if
	jal %zero beq_cont.100900 # then sentence ends
beq_else.100899:
	lw %a0 %sp 36 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 164 #1771
	lw %a11 %sp 32 #1771
	sw %a0 %sp 188 #1771
	add %a0 %a1 %zero
	sw %ra %sp 196 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 200 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -200 #1771
	lw %ra %sp 196 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 188 #1774
	lw %a1 %sp 160 #1774
	lw %a2 %sp 164 #1774
	lw %a11 %sp 28 #1774
	sw %ra %sp 196 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 200 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -200 #1774
	lw %ra %sp 196 #1774
beq_cont.100900:
	lw %a0 %sp 156 #1673
	lw %a0 %a0 0 #1673
	lw %a1 %sp 60 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 40 #219
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
beq_cont.100890:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 152 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100901 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100903 # nontail if
	jal %zero beq_cont.100904 # then sentence ends
beq_else.100903:
	lw %a11 %sp 24 #1848
	sw %ra %sp 196 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 200 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -200 #1848
	lw %ra %sp 196 #1848
beq_cont.100904:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 152 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 196 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 200 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -200 #1850
	lw %ra %sp 196 #1850
	jal %zero bge_cont.100902 # then sentence ends
bge_else.100901:
bge_cont.100902:
	jal %zero bge_cont.100888 # then sentence ends
bge_else.100887:
bge_cont.100888:
	jal %zero beq_cont.100886 # then sentence ends
beq_else.100885:
	lw %a1 %sp 8 #2025
	lw %a6 %sp 4 #2025
	lw %a11 %sp 0 #2025
	add %a4 %a6 %zero
	add %a10 %a5 %zero
	add %a5 %a2 %zero
	add %a2 %a1 %zero
	add %a1 %a10 %zero
	sw %ra %sp 196 #2025 call cls
	lw %a10 %a11 0 #2025
	addi %sp %sp 200 #2025	
	jalr %ra %a10 0 #2025
	addi %sp %sp -200 #2025
	lw %ra %sp 196 #2025
beq_cont.100886:
	lw %a0 %sp 60 #54
	lw %f0 %a0 0 #54
	sw %ra %sp 196 #1930 call dir
	addi %sp %sp 200 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -200 #1930
	lw %ra %sp 196 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100905 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100907 # nontail if
	jal %zero bge_cont.100908 # then sentence ends
bge_else.100907:
	addi %a0 %zero 0 #1931
bge_cont.100908:
	jal %zero bge_cont.100906 # then sentence ends
bge_else.100905:
	addi %a0 %zero 255 #1931
bge_cont.100906:
	sw %ra %sp 196 #1932 call dir
	addi %sp %sp 200 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -200 #1932
	lw %ra %sp 196 #1932
	addi %a0 %zero 32 #1937
	sw %ra %sp 196 #1937 call dir
	addi %sp %sp 200 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -200 #1937
	lw %ra %sp 196 #1937
	lw %a0 %sp 60 #54
	lw %f0 %a0 4 #54
	sw %ra %sp 196 #1930 call dir
	addi %sp %sp 200 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -200 #1930
	lw %ra %sp 196 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100909 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100911 # nontail if
	jal %zero bge_cont.100912 # then sentence ends
bge_else.100911:
	addi %a0 %zero 0 #1931
bge_cont.100912:
	jal %zero bge_cont.100910 # then sentence ends
bge_else.100909:
	addi %a0 %zero 255 #1931
bge_cont.100910:
	sw %ra %sp 196 #1932 call dir
	addi %sp %sp 200 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -200 #1932
	lw %ra %sp 196 #1932
	addi %a0 %zero 32 #1939
	sw %ra %sp 196 #1939 call dir
	addi %sp %sp 200 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -200 #1939
	lw %ra %sp 196 #1939
	lw %a0 %sp 60 #54
	lw %f0 %a0 8 #54
	sw %ra %sp 196 #1930 call dir
	addi %sp %sp 200 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -200 #1930
	lw %ra %sp 196 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100913 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100915 # nontail if
	jal %zero bge_cont.100916 # then sentence ends
bge_else.100915:
	addi %a0 %zero 0 #1931
bge_cont.100916:
	jal %zero bge_cont.100914 # then sentence ends
bge_else.100913:
	addi %a0 %zero 255 #1931
bge_cont.100914:
	sw %ra %sp 196 #1932 call dir
	addi %sp %sp 200 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -200 #1932
	lw %ra %sp 196 #1932
	addi %a0 %zero 10 #1941
	sw %ra %sp 196 #1941 call dir
	addi %sp %sp 200 #1941	
	jal %ra min_caml_print_char #1941
	addi %sp %sp -200 #1941
	lw %ra %sp 196 #1941
	lw %a0 %sp 148 #2032
	addi %a0 %a0 1 #2032
	lw %a1 %sp 44 #2032
	lw %a2 %sp 8 #2032
	lw %a3 %sp 48 #2032
	lw %a4 %sp 4 #2032
	lw %a11 %sp 12 #2032
	lw %a10 %a11 0 #2032
	jalr %zero %a10 0 #2032
scan_line.2650:
	lw %a5 %a11 64 #2037
	lw %a6 %a11 60 #2037
	lw %a7 %a11 56 #2037
	lw %a8 %a11 52 #2037
	lw %a9 %a11 48 #2037
	lw %a10 %a11 44 #2037
	sw %a9 %sp 0 #2037
	lw %a9 %a11 40 #2037
	sw %a1 %sp 4 #2037
	lw %a1 %a11 36 #2037
	sw %a5 %sp 8 #2037
	lw %a5 %a11 32 #2037
	sw %a5 %sp 12 #2037
	lw %a5 %a11 28 #2037
	sw %a5 %sp 16 #2037
	lw %a5 %a11 24 #2037
	sw %a6 %sp 20 #2037
	lw %a6 %a11 20 #2037
	sw %a9 %sp 24 #2037
	lw %a9 %a11 16 #2037
	sw %a9 %sp 28 #2037
	lw %a9 %a11 12 #2037
	sw %a9 %sp 32 #2037
	lw %a9 %a11 8 #2037
	sw %a11 %sp 36 #2037
	lw %a11 %a11 4 #2037
	sw %a11 %sp 40 #57
	lw %a11 %a5 4 #57
	blt %a0 %a11 bge_else.100917
	jalr %zero %ra 0 #2046
bge_else.100917:
	lw %a11 %a5 4 #57
	addi %a11 %a11 -1 #2041
	sw %a4 %sp 44 #2041
	sw %a3 %sp 48 #2041
	sw %a9 %sp 52 #2041
	sw %a0 %sp 56 #2041
	sw %a2 %sp 60 #2041
	sw %a5 %sp 64 #2041
	blt %a0 %a11 bge_else.100919 # nontail if
	jal %zero bge_cont.100920 # then sentence ends
bge_else.100919:
	addi %a11 %a0 1 #2042
	lw %f0 %a10 0 #61
	lw %a6 %a6 4 #59
	sub %a6 %a11 %a6 #2004
	sw %a1 %sp 68 #2004
	sw %a7 %sp 72 #2004
	sw %a8 %sp 76 #2004
	sw %f0 %sp 80 #2004
	add %a0 %a6 %zero
	sw %ra %sp 92 #2004 call dir
	addi %sp %sp 96 #2004	
	jal %ra min_caml_float_of_int #2004
	addi %sp %sp -96 #2004
	lw %ra %sp 92 #2004
	lw %f1 %sp 80 #2004
	fmul %f0 %f1 %f0 #2004
	lw %a0 %sp 76 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 72 #71
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
	lw %a0 %sp 64 #57
	lw %a1 %a0 0 #57
	addi %a1 %a1 -1 #2010
	lw %a2 %sp 48 #2010
	lw %a3 %sp 44 #2010
	lw %a11 %sp 68 #2010
	add %a0 %a2 %zero
	add %a2 %a3 %zero
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
bge_cont.100920:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 64 #57
	lw %a2 %a1 0 #57
	addi %a12 %zero 0
	blt %a12 %a2 bge_else.100921 # nontail if
	jal %zero bge_cont.100922 # then sentence ends
bge_else.100921:
	lw %a3 %sp 60 #2021
	lw %a2 %a3 0 #2021
	lw %a2 %a2 0 #439
	lw %f0 %a2 0 #152
	lw %a4 %sp 24 #152
	sw %f0 %a4 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a4 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a4 8 #154
	lw %a2 %a1 4 #57
	lw %a5 %sp 56 #1857
	addi %a6 %a5 1 #1857
	blt %a6 %a2 bge_else.100923 # nontail if
	addi %a2 %zero 0 #1865
	jal %zero bge_cont.100924 # then sentence ends
bge_else.100923:
	addi %a12 %zero 0
	blt %a12 %a5 bge_else.100925 # nontail if
	addi %a2 %zero 0 #1858
	jal %zero bge_cont.100926 # then sentence ends
bge_else.100925:
	lw %a2 %a1 0 #57
	addi %a12 %zero 1
	blt %a12 %a2 bge_else.100927 # nontail if
	addi %a2 %zero 0 #1858
	jal %zero bge_cont.100928 # then sentence ends
bge_else.100927:
	addi %a2 %zero 0 #1858
bge_cont.100928:
bge_cont.100926:
bge_cont.100924:
	addi %a6 %zero 0 #2024
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100929 # nontail if
	lw %a0 %a3 0 #2021
	lw %a2 %a0 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100931 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 0 #1669
	sw %a0 %sp 88 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100933 # nontail if
	jal %zero beq_cont.100934 # then sentence ends
beq_else.100933:
	lw %a2 %a0 20 #475
	lw %a6 %a0 28 #498
	lw %a7 %a0 4 #446
	lw %a8 %a0 16 #468
	lw %a2 %a2 0 #1810
	lw %f0 %a2 0 #152
	lw %a9 %sp 52 #152
	sw %f0 %a9 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a9 8 #154
	lw %a2 %a0 24 #484
	lw %a2 %a2 0 #486
	lw %a6 %a6 0 #1676
	lw %a7 %a7 0 #1664
	sw %a8 %sp 92 #1780
	sw %a6 %sp 96 #1780
	sw %a7 %sp 100 #1780
	sw %a2 %sp 104 #1780
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100935 # nontail if
	jal %zero beq_cont.100936 # then sentence ends
beq_else.100935:
	lw %a10 %sp 32 #81
	lw %a11 %a10 0 #81
	lw %a1 %sp 20 #1771
	sw %a11 %sp 108 #1771
	add %a0 %a7 %zero
	add %a11 %a1 %zero
	sw %ra %sp 116 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 120 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -120 #1771
	lw %ra %sp 116 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 108 #1774
	lw %a1 %sp 96 #1774
	lw %a2 %sp 100 #1774
	lw %a11 %sp 16 #1774
	sw %ra %sp 116 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 120 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -120 #1774
	lw %ra %sp 116 #1774
beq_cont.100936:
	lw %a0 %sp 104 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.100937 # nontail if
	jal %zero beq_cont.100938 # then sentence ends
beq_else.100937:
	lw %a1 %sp 32 #81
	lw %a2 %a1 4 #81
	lw %a3 %sp 100 #1771
	lw %a11 %sp 20 #1771
	sw %a2 %sp 112 #1771
	add %a0 %a3 %zero
	sw %ra %sp 116 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 120 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -120 #1771
	lw %ra %sp 116 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 112 #1774
	lw %a1 %sp 96 #1774
	lw %a2 %sp 100 #1774
	lw %a11 %sp 16 #1774
	sw %ra %sp 116 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 120 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -120 #1774
	lw %ra %sp 116 #1774
beq_cont.100938:
	lw %a0 %sp 104 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.100939 # nontail if
	jal %zero beq_cont.100940 # then sentence ends
beq_else.100939:
	lw %a1 %sp 32 #81
	lw %a2 %a1 8 #81
	lw %a3 %sp 100 #1771
	lw %a11 %sp 20 #1771
	sw %a2 %sp 116 #1771
	add %a0 %a3 %zero
	sw %ra %sp 124 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 128 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -128 #1771
	lw %ra %sp 124 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 116 #1774
	lw %a1 %sp 96 #1774
	lw %a2 %sp 100 #1774
	lw %a11 %sp 16 #1774
	sw %ra %sp 124 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 128 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -128 #1774
	lw %ra %sp 124 #1774
beq_cont.100940:
	lw %a0 %sp 104 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.100941 # nontail if
	jal %zero beq_cont.100942 # then sentence ends
beq_else.100941:
	lw %a1 %sp 32 #81
	lw %a2 %a1 12 #81
	lw %a3 %sp 100 #1771
	lw %a11 %sp 20 #1771
	sw %a2 %sp 120 #1771
	add %a0 %a3 %zero
	sw %ra %sp 124 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 128 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -128 #1771
	lw %ra %sp 124 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 120 #1774
	lw %a1 %sp 96 #1774
	lw %a2 %sp 100 #1774
	lw %a11 %sp 16 #1774
	sw %ra %sp 124 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 128 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -128 #1774
	lw %ra %sp 124 #1774
beq_cont.100942:
	lw %a0 %sp 104 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.100943 # nontail if
	jal %zero beq_cont.100944 # then sentence ends
beq_else.100943:
	lw %a0 %sp 32 #81
	lw %a0 %a0 16 #81
	lw %a1 %sp 100 #1771
	lw %a11 %sp 20 #1771
	sw %a0 %sp 124 #1771
	add %a0 %a1 %zero
	sw %ra %sp 132 #1771 call cls
	lw %a10 %a11 0 #1771
	addi %sp %sp 136 #1771	
	jalr %ra %a10 0 #1771
	addi %sp %sp -136 #1771
	lw %ra %sp 132 #1771
	addi %a3 %zero 118 #1774
	lw %a0 %sp 124 #1774
	lw %a1 %sp 96 #1774
	lw %a2 %sp 100 #1774
	lw %a11 %sp 16 #1774
	sw %ra %sp 132 #1774 call cls
	lw %a10 %a11 0 #1774
	addi %sp %sp 136 #1774	
	jalr %ra %a10 0 #1774
	addi %sp %sp -136 #1774
	lw %ra %sp 132 #1774
beq_cont.100944:
	lw %a0 %sp 92 #1673
	lw %a0 %a0 0 #1673
	lw %a1 %sp 24 #219
	lw %f0 %a1 0 #219
	lw %f1 %a0 0 #219
	lw %a2 %sp 52 #219
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
beq_cont.100934:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 88 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.100945 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.100947 # nontail if
	jal %zero beq_cont.100948 # then sentence ends
beq_else.100947:
	lw %a11 %sp 40 #1848
	sw %ra %sp 132 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 136 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -136 #1848
	lw %ra %sp 132 #1848
beq_cont.100948:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 88 #1850
	lw %a11 %sp 28 #1850
	sw %ra %sp 132 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 136 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -136 #1850
	lw %ra %sp 132 #1850
	jal %zero bge_cont.100946 # then sentence ends
bge_else.100945:
bge_cont.100946:
	jal %zero bge_cont.100932 # then sentence ends
bge_else.100931:
bge_cont.100932:
	jal %zero beq_cont.100930 # then sentence ends
beq_else.100929:
	lw %a2 %sp 4 #2025
	lw %a7 %sp 48 #2025
	lw %a11 %sp 8 #2025
	add %a4 %a7 %zero
	add %a1 %a5 %zero
	add %a5 %a6 %zero
	sw %ra %sp 132 #2025 call cls
	lw %a10 %a11 0 #2025
	addi %sp %sp 136 #2025	
	jalr %ra %a10 0 #2025
	addi %sp %sp -136 #2025
	lw %ra %sp 132 #2025
beq_cont.100930:
	lw %a0 %sp 24 #54
	lw %f0 %a0 0 #54
	sw %ra %sp 132 #1930 call dir
	addi %sp %sp 136 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -136 #1930
	lw %ra %sp 132 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100949 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100951 # nontail if
	jal %zero bge_cont.100952 # then sentence ends
bge_else.100951:
	addi %a0 %zero 0 #1931
bge_cont.100952:
	jal %zero bge_cont.100950 # then sentence ends
bge_else.100949:
	addi %a0 %zero 255 #1931
bge_cont.100950:
	sw %ra %sp 132 #1932 call dir
	addi %sp %sp 136 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -136 #1932
	lw %ra %sp 132 #1932
	addi %a0 %zero 32 #1937
	sw %ra %sp 132 #1937 call dir
	addi %sp %sp 136 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -136 #1937
	lw %ra %sp 132 #1937
	lw %a0 %sp 24 #54
	lw %f0 %a0 4 #54
	sw %ra %sp 132 #1930 call dir
	addi %sp %sp 136 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -136 #1930
	lw %ra %sp 132 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100953 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100955 # nontail if
	jal %zero bge_cont.100956 # then sentence ends
bge_else.100955:
	addi %a0 %zero 0 #1931
bge_cont.100956:
	jal %zero bge_cont.100954 # then sentence ends
bge_else.100953:
	addi %a0 %zero 255 #1931
bge_cont.100954:
	sw %ra %sp 132 #1932 call dir
	addi %sp %sp 136 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -136 #1932
	lw %ra %sp 132 #1932
	addi %a0 %zero 32 #1939
	sw %ra %sp 132 #1939 call dir
	addi %sp %sp 136 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -136 #1939
	lw %ra %sp 132 #1939
	lw %a0 %sp 24 #54
	lw %f0 %a0 8 #54
	sw %ra %sp 132 #1930 call dir
	addi %sp %sp 136 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -136 #1930
	lw %ra %sp 132 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.100957 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100959 # nontail if
	jal %zero bge_cont.100960 # then sentence ends
bge_else.100959:
	addi %a0 %zero 0 #1931
bge_cont.100960:
	jal %zero bge_cont.100958 # then sentence ends
bge_else.100957:
	addi %a0 %zero 255 #1931
bge_cont.100958:
	sw %ra %sp 132 #1932 call dir
	addi %sp %sp 136 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -136 #1932
	lw %ra %sp 132 #1932
	addi %a0 %zero 10 #1941
	sw %ra %sp 132 #1941 call dir
	addi %sp %sp 136 #1941	
	jal %ra min_caml_print_char #1941
	addi %sp %sp -136 #1941
	lw %ra %sp 132 #1941
	addi %a0 %zero 1 #2032
	lw %a1 %sp 56 #2032
	lw %a2 %sp 4 #2032
	lw %a3 %sp 60 #2032
	lw %a4 %sp 48 #2032
	lw %a11 %sp 0 #2032
	sw %ra %sp 132 #2032 call cls
	lw %a10 %a11 0 #2032
	addi %sp %sp 136 #2032	
	jalr %ra %a10 0 #2032
	addi %sp %sp -136 #2032
	lw %ra %sp 132 #2032
bge_cont.100922:
	lw %a0 %sp 56 #2045
	addi %a1 %a0 1 #2045
	lw %a0 %sp 44 #123
	addi %a0 %a0 2 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.100961 # nontail if
	addi %a2 %a0 -5 #124
	jal %zero bge_cont.100962 # then sentence ends
bge_else.100961:
	addi %a2 %a0 0 #124
bge_cont.100962:
	lw %a0 %sp 64 #57
	lw %a3 %a0 4 #57
	blt %a1 %a3 bge_else.100963
	jalr %zero %ra 0 #2046
bge_else.100963:
	lw %a0 %a0 4 #57
	addi %a0 %a0 -1 #2041
	sw %a2 %sp 128 #2041
	sw %a1 %sp 132 #2041
	blt %a1 %a0 bge_else.100965 # nontail if
	jal %zero bge_cont.100966 # then sentence ends
bge_else.100965:
	addi %a0 %a1 1 #2042
	lw %a3 %sp 4 #2042
	lw %a11 %sp 12 #2042
	add %a1 %a0 %zero
	add %a0 %a3 %zero
	sw %ra %sp 140 #2042 call cls
	lw %a10 %a11 0 #2042
	addi %sp %sp 144 #2042	
	jalr %ra %a10 0 #2042
	addi %sp %sp -144 #2042
	lw %ra %sp 140 #2042
bge_cont.100966:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 132 #2044
	lw %a2 %sp 60 #2044
	lw %a3 %sp 48 #2044
	lw %a4 %sp 4 #2044
	lw %a11 %sp 0 #2044
	sw %ra %sp 140 #2044 call cls
	lw %a10 %a11 0 #2044
	addi %sp %sp 144 #2044	
	jalr %ra %a10 0 #2044
	addi %sp %sp -144 #2044
	lw %ra %sp 140 #2044
	lw %a0 %sp 132 #2045
	addi %a0 %a0 1 #2045
	lw %a1 %sp 128 #123
	addi %a1 %a1 2 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.100967 # nontail if
	addi %a4 %a1 -5 #124
	jal %zero bge_cont.100968 # then sentence ends
bge_else.100967:
	addi %a4 %a1 0 #124
bge_cont.100968:
	lw %a1 %sp 48 #2045
	lw %a2 %sp 4 #2045
	lw %a3 %sp 60 #2045
	lw %a11 %sp 36 #2045
	lw %a10 %a11 0 #2045
	jalr %zero %a10 0 #2045
create_pixel.2658:
	addi %a0 %zero 3 #2066
	li %f0 l.90390 #2066
	sw %ra %sp 4 #2066 call dir
	addi %sp %sp 8 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -8 #2066
	lw %ra %sp 4 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 12 #2057 call dir
	addi %sp %sp 16 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -16 #2057
	lw %ra %sp 12 #2057
	lw %a1 %sp 4 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 12 #2058 call dir
	addi %sp %sp 16 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -16 #2058
	lw %ra %sp 12 #2058
	lw %a1 %sp 4 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 20 #2057 call dir
	addi %sp %sp 24 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -24 #2057
	lw %ra %sp 20 #2057
	lw %a1 %sp 16 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 20 #2058 call dir
	addi %sp %sp 24 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -24 #2058
	lw %ra %sp 20 #2058
	lw %a1 %sp 16 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 20 #2059 call dir
	addi %sp %sp 24 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -24 #2059
	lw %ra %sp 20 #2059
	lw %a1 %sp 16 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 28 #2057 call dir
	addi %sp %sp 32 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -32 #2057
	lw %ra %sp 28 #2057
	lw %a1 %sp 20 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 28 #2058 call dir
	addi %sp %sp 32 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -32 #2058
	lw %ra %sp 28 #2058
	lw %a1 %sp 20 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 36 #2057 call dir
	addi %sp %sp 40 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -40 #2057
	lw %ra %sp 36 #2057
	lw %a1 %sp 28 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 36 #2058 call dir
	addi %sp %sp 40 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -40 #2058
	lw %ra %sp 36 #2058
	lw %a1 %sp 28 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
init_line_elements.2660:
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.100969
	addi %a2 %zero 3 #2066
	li %f0 l.90390 #2066
	sw %a0 %sp 0 #2066
	sw %a1 %sp 4 #2066
	add %a0 %a2 %zero
	sw %ra %sp 12 #2066 call dir
	addi %sp %sp 16 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -16 #2066
	lw %ra %sp 12 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 20 #2057 call dir
	addi %sp %sp 24 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -24 #2057
	lw %ra %sp 20 #2057
	lw %a1 %sp 12 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 20 #2058 call dir
	addi %sp %sp 24 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -24 #2058
	lw %ra %sp 20 #2058
	lw %a1 %sp 12 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 28 #2057 call dir
	addi %sp %sp 32 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -32 #2057
	lw %ra %sp 28 #2057
	lw %a1 %sp 24 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 28 #2058 call dir
	addi %sp %sp 32 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -32 #2058
	lw %ra %sp 28 #2058
	lw %a1 %sp 24 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 28 #2059 call dir
	addi %sp %sp 32 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -32 #2059
	lw %ra %sp 28 #2059
	lw %a1 %sp 24 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 36 #2057 call dir
	addi %sp %sp 40 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -40 #2057
	lw %ra %sp 36 #2057
	lw %a1 %sp 28 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 36 #2058 call dir
	addi %sp %sp 40 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -40 #2058
	lw %ra %sp 36 #2058
	lw %a1 %sp 28 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 44 #2057 call dir
	addi %sp %sp 48 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -48 #2057
	lw %ra %sp 44 #2057
	lw %a1 %sp 36 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 44 #2058 call dir
	addi %sp %sp 48 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -48 #2058
	lw %ra %sp 44 #2058
	lw %a1 %sp 36 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	blt %a0 %a12 bge_else.100970
	sw %a0 %sp 40 #2080
	sw %ra %sp 44 #2080 call dir
	addi %sp %sp 48 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -48 #2080
	lw %ra %sp 44 #2080
	lw %a1 %sp 40 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 0 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a0 %a1 -1 #2081
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100971
	addi %a1 %zero 3 #2066
	li %f0 l.90390 #2066
	sw %a0 %sp 44 #2066
	add %a0 %a1 %zero
	sw %ra %sp 52 #2066 call dir
	addi %sp %sp 56 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -56 #2066
	lw %ra %sp 52 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 60 #2057 call dir
	addi %sp %sp 64 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -64 #2057
	lw %ra %sp 60 #2057
	lw %a1 %sp 52 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 60 #2058 call dir
	addi %sp %sp 64 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -64 #2058
	lw %ra %sp 60 #2058
	lw %a1 %sp 52 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 68 #2057 call dir
	addi %sp %sp 72 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -72 #2057
	lw %ra %sp 68 #2057
	lw %a1 %sp 64 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 68 #2058 call dir
	addi %sp %sp 72 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -72 #2058
	lw %ra %sp 68 #2058
	lw %a1 %sp 64 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 68 #2059 call dir
	addi %sp %sp 72 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -72 #2059
	lw %ra %sp 68 #2059
	lw %a1 %sp 64 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 76 #2057 call dir
	addi %sp %sp 80 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -80 #2057
	lw %ra %sp 76 #2057
	lw %a1 %sp 68 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 76 #2058 call dir
	addi %sp %sp 80 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -80 #2058
	lw %ra %sp 76 #2058
	lw %a1 %sp 68 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 84 #2057 call dir
	addi %sp %sp 88 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -88 #2057
	lw %ra %sp 84 #2057
	lw %a1 %sp 76 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 84 #2058 call dir
	addi %sp %sp 88 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -88 #2058
	lw %ra %sp 84 #2058
	lw %a1 %sp 76 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
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
	blt %a0 %a12 bge_else.100972
	sw %a0 %sp 80 #2080
	sw %ra %sp 84 #2080 call dir
	addi %sp %sp 88 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -88 #2080
	lw %ra %sp 84 #2080
	lw %a1 %sp 80 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 0 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	jal	%zero init_line_elements.2660
bge_else.100972:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.100971:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.100970:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.100969:
	jalr %zero %ra 0 #2083
calc_dirvec.2670:
	lw %a3 %a11 4 #2110
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.100973
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
	li %f1 l.90464 #2112
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
	li %f3 l.90464 #2115
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
	lw %a2 %a2 0 #507
	sw %f1 %a2 0 #133
	sw %f2 %a2 4 #134
	sw %f0 %a2 8 #135
	addi %a2 %a1 40 #2120
	slli %a2 %a2 2 #80
	add %a12 %a0 %a2 #80
	lw %a2 %a12 0 #80
	lw %a2 %a2 0 #507
	sw %f2 %sp 40 #2120
	sw %a0 %sp 48 #2120
	sw %f0 %sp 56 #2120
	sw %a2 %sp 64 #2120
	sw %f1 %sp 72 #2120
	fadd %f0 %f2 %fzero
	sw %ra %sp 84 #2120 call dir
	addi %sp %sp 88 #2120	
	jal %ra min_caml_fneg #2120
	addi %sp %sp -88 #2120
	lw %ra %sp 84 #2120
	lw %a0 %sp 64 #133
	lw %f1 %sp 72 #133
	sw %f1 %a0 0 #133
	lw %f2 %sp 56 #134
	sw %f2 %a0 4 #134
	sw %f0 %a0 8 #135
	lw %a0 %sp 0 #2121
	addi %a1 %a0 80 #2121
	slli %a1 %a1 2 #80
	lw %a2 %sp 48 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	sw %a1 %sp 80 #2121
	fadd %f0 %f1 %fzero
	sw %ra %sp 84 #2121 call dir
	addi %sp %sp 88 #2121	
	jal %ra min_caml_fneg #2121
	addi %sp %sp -88 #2121
	lw %ra %sp 84 #2121
	lw %f1 %sp 40 #2121
	sw %f0 %sp 88 #2121
	fadd %f0 %f1 %fzero
	sw %ra %sp 100 #2121 call dir
	addi %sp %sp 104 #2121	
	jal %ra min_caml_fneg #2121
	addi %sp %sp -104 #2121
	lw %ra %sp 100 #2121
	lw %a0 %sp 80 #133
	lw %f1 %sp 56 #133
	sw %f1 %a0 0 #133
	lw %f2 %sp 88 #134
	sw %f2 %a0 4 #134
	sw %f0 %a0 8 #135
	lw %a0 %sp 0 #2122
	addi %a1 %a0 1 #2122
	slli %a1 %a1 2 #80
	lw %a2 %sp 48 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	lw %f0 %sp 72 #2122
	sw %a1 %sp 96 #2122
	sw %ra %sp 100 #2122 call dir
	addi %sp %sp 104 #2122	
	jal %ra min_caml_fneg #2122
	addi %sp %sp -104 #2122
	lw %ra %sp 100 #2122
	lw %f1 %sp 40 #2122
	sw %f0 %sp 104 #2122
	fadd %f0 %f1 %fzero
	sw %ra %sp 116 #2122 call dir
	addi %sp %sp 120 #2122	
	jal %ra min_caml_fneg #2122
	addi %sp %sp -120 #2122
	lw %ra %sp 116 #2122
	lw %f1 %sp 56 #2122
	sw %f0 %sp 112 #2122
	fadd %f0 %f1 %fzero
	sw %ra %sp 124 #2122 call dir
	addi %sp %sp 128 #2122	
	jal %ra min_caml_fneg #2122
	addi %sp %sp -128 #2122
	lw %ra %sp 124 #2122
	lw %a0 %sp 96 #133
	lw %f1 %sp 104 #133
	sw %f1 %a0 0 #133
	lw %f1 %sp 112 #134
	sw %f1 %a0 4 #134
	sw %f0 %a0 8 #135
	lw %a0 %sp 0 #2123
	addi %a1 %a0 41 #2123
	slli %a1 %a1 2 #80
	lw %a2 %sp 48 #80
	add %a12 %a2 %a1 #80
	lw %a1 %a12 0 #80
	lw %a1 %a1 0 #507
	lw %f0 %sp 72 #2123
	sw %a1 %sp 120 #2123
	sw %ra %sp 124 #2123 call dir
	addi %sp %sp 128 #2123	
	jal %ra min_caml_fneg #2123
	addi %sp %sp -128 #2123
	lw %ra %sp 124 #2123
	lw %f1 %sp 56 #2123
	sw %f0 %sp 128 #2123
	fadd %f0 %f1 %fzero
	sw %ra %sp 140 #2123 call dir
	addi %sp %sp 144 #2123	
	jal %ra min_caml_fneg #2123
	addi %sp %sp -144 #2123
	lw %ra %sp 140 #2123
	lw %a0 %sp 120 #133
	lw %f1 %sp 128 #133
	sw %f1 %a0 0 #133
	sw %f0 %a0 4 #134
	lw %f0 %sp 40 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 0 #2124
	addi %a0 %a0 81 #2124
	slli %a0 %a0 2 #80
	lw %a1 %sp 48 #80
	add %a12 %a1 %a0 #80
	lw %a0 %a12 0 #80
	lw %a0 %a0 0 #507
	lw %f1 %sp 56 #2124
	sw %a0 %sp 136 #2124
	fadd %f0 %f1 %fzero
	sw %ra %sp 140 #2124 call dir
	addi %sp %sp 144 #2124	
	jal %ra min_caml_fneg #2124
	addi %sp %sp -144 #2124
	lw %ra %sp 140 #2124
	lw %a0 %sp 136 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 72 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 40 #135
	sw %f0 %a0 8 #135
	jalr %zero %ra 0 #135
bge_else.100973:
	fmul %f0 %f1 %f1 #2102
	li %f1 l.92051 #2102
	fadd %f0 %f0 %f1 #2102
	sw %a2 %sp 0 #2102
	sw %a1 %sp 8 #2102
	sw %a11 %sp 140 #2102
	sw %f3 %sp 144 #2102
	sw %a0 %sp 152 #2102
	sw %f2 %sp 160 #2102
	sw %ra %sp 172 #2102 call dir
	addi %sp %sp 176 #2102	
	jal %ra min_caml_sqrt #2102
	addi %sp %sp -176 #2102
	lw %ra %sp 172 #2102
	li %f1 l.90464 #2103
	fdiv %f1 %f1 %f0 #2103
	sw %f0 %sp 168 #2104
	fadd %f0 %f1 %fzero
	sw %ra %sp 180 #2104 call dir
	addi %sp %sp 184 #2104	
	jal %ra min_caml_atan #2104
	addi %sp %sp -184 #2104
	lw %ra %sp 180 #2104
	lw %f1 %sp 160 #2105
	fmul %f0 %f0 %f1 #2105
	sw %f0 %sp 176 #2097
	sw %ra %sp 188 #2097 call dir
	addi %sp %sp 192 #2097	
	jal %ra min_caml_sin #2097
	addi %sp %sp -192 #2097
	lw %ra %sp 188 #2097
	lw %f1 %sp 176 #2097
	sw %f0 %sp 184 #2097
	fadd %f0 %f1 %fzero
	sw %ra %sp 196 #2097 call dir
	addi %sp %sp 200 #2097	
	jal %ra min_caml_cos #2097
	addi %sp %sp -200 #2097
	lw %ra %sp 196 #2097
	lw %f1 %sp 184 #2097
	fdiv %f0 %f1 %f0 #2097
	lw %f1 %sp 168 #2106
	fmul %f0 %f0 %f1 #2106
	lw %a0 %sp 152 #2127
	addi %a0 %a0 1 #2127
	fmul %f1 %f0 %f0 #2102
	li %f2 l.92051 #2102
	fadd %f1 %f1 %f2 #2102
	sw %f0 %sp 192 #2102
	sw %a0 %sp 200 #2102
	fadd %f0 %f1 %fzero
	sw %ra %sp 204 #2102 call dir
	addi %sp %sp 208 #2102	
	jal %ra min_caml_sqrt #2102
	addi %sp %sp -208 #2102
	lw %ra %sp 204 #2102
	li %f1 l.90464 #2103
	fdiv %f1 %f1 %f0 #2103
	sw %f0 %sp 208 #2104
	fadd %f0 %f1 %fzero
	sw %ra %sp 220 #2104 call dir
	addi %sp %sp 224 #2104	
	jal %ra min_caml_atan #2104
	addi %sp %sp -224 #2104
	lw %ra %sp 220 #2104
	lw %f1 %sp 144 #2105
	fmul %f0 %f0 %f1 #2105
	sw %f0 %sp 216 #2097
	sw %ra %sp 228 #2097 call dir
	addi %sp %sp 232 #2097	
	jal %ra min_caml_sin #2097
	addi %sp %sp -232 #2097
	lw %ra %sp 228 #2097
	lw %f1 %sp 216 #2097
	sw %f0 %sp 224 #2097
	fadd %f0 %f1 %fzero
	sw %ra %sp 236 #2097 call dir
	addi %sp %sp 240 #2097	
	jal %ra min_caml_cos #2097
	addi %sp %sp -240 #2097
	lw %ra %sp 236 #2097
	lw %f1 %sp 224 #2097
	fdiv %f0 %f1 %f0 #2097
	lw %f1 %sp 208 #2106
	fmul %f1 %f0 %f1 #2106
	lw %f0 %sp 192 #2127
	lw %f2 %sp 160 #2127
	lw %f3 %sp 144 #2127
	lw %a0 %sp 200 #2127
	lw %a1 %sp 8 #2127
	lw %a2 %sp 0 #2127
	lw %a11 %sp 140 #2127
	lw %a10 %a11 0 #2127
	jalr %zero %a10 0 #2127
calc_dirvecs.2678:
	lw %a3 %a11 4 #2131
	addi %a4 %zero 0 #2132
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100983
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
	li %f1 l.93232 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.93234 #2134
	fsub %f2 %f0 %f1 #2134
	li %f0 l.90390 #2135
	li %f1 l.90390 #2135
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
	li %f1 l.93232 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.92051 #2137
	fadd %f2 %f0 %f1 #2137
	li %f0 l.90390 #2138
	li %f1 l.90390 #2138
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
	lw %a1 %sp 20 #123
	addi %a1 %a1 1 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.100984 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.100985 # then sentence ends
bge_else.100984:
bge_cont.100985:
	addi %a2 %zero 0 #2132
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100986
	sw %a0 %sp 32 #2134
	sw %a1 %sp 36 #2134
	sw %a2 %sp 40 #2134
	sw %ra %sp 44 #2134 call dir
	addi %sp %sp 48 #2134	
	jal %ra min_caml_float_of_int #2134
	addi %sp %sp -48 #2134
	lw %ra %sp 44 #2134
	li %f1 l.93232 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.93234 #2134
	fsub %f2 %f0 %f1 #2134
	li %f0 l.90390 #2135
	li %f1 l.90390 #2135
	lw %f3 %sp 8 #2135
	lw %a0 %sp 40 #2135
	lw %a1 %sp 36 #2135
	lw %a2 %sp 16 #2135
	lw %a11 %sp 28 #2135
	sw %ra %sp 44 #2135 call cls
	lw %a10 %a11 0 #2135
	addi %sp %sp 48 #2135	
	jalr %ra %a10 0 #2135
	addi %sp %sp -48 #2135
	lw %ra %sp 44 #2135
	lw %a0 %sp 32 #2137
	sw %ra %sp 44 #2137 call dir
	addi %sp %sp 48 #2137	
	jal %ra min_caml_float_of_int #2137
	addi %sp %sp -48 #2137
	lw %ra %sp 44 #2137
	li %f1 l.93232 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.92051 #2137
	fadd %f2 %f0 %f1 #2137
	li %f0 l.90390 #2138
	li %f1 l.90390 #2138
	lw %a0 %sp 16 #2138
	addi %a2 %a0 2 #2138
	lw %f3 %sp 8 #2138
	lw %a1 %sp 40 #2138
	lw %a3 %sp 36 #2138
	lw %a11 %sp 28 #2138
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 44 #2138 call cls
	lw %a10 %a11 0 #2138
	addi %sp %sp 48 #2138	
	jalr %ra %a10 0 #2138
	addi %sp %sp -48 #2138
	lw %ra %sp 44 #2138
	lw %a0 %sp 32 #2140
	addi %a0 %a0 -1 #2140
	lw %a1 %sp 36 #123
	addi %a1 %a1 1 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.100987 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.100988 # then sentence ends
bge_else.100987:
bge_cont.100988:
	lw %f0 %sp 8 #2140
	lw %a2 %sp 16 #2140
	lw %a11 %sp 0 #2140
	lw %a10 %a11 0 #2140
	jalr %zero %a10 0 #2140
bge_else.100986:
	jalr %zero %ra 0 #2141
bge_else.100983:
	jalr %zero %ra 0 #2141
calc_dirvec_rows.2683:
	lw %a3 %a11 8 #2145
	lw %a4 %a11 4 #2145
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100991
	sw %a11 %sp 0 #2147
	sw %a0 %sp 4 #2147
	sw %a3 %sp 8 #2147
	sw %a2 %sp 12 #2147
	sw %a1 %sp 16 #2147
	sw %a4 %sp 20 #2147
	sw %ra %sp 28 #2147 call dir
	addi %sp %sp 32 #2147	
	jal %ra min_caml_float_of_int #2147
	addi %sp %sp -32 #2147
	lw %ra %sp 28 #2147
	li %f1 l.93232 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.93234 #2147
	fsub %f0 %f0 %f1 #2147
	addi %a0 %zero 4 #2148
	addi %a1 %zero 0 #2132
	sw %a0 %sp 24 #2134
	sw %f0 %sp 32 #2134
	sw %a1 %sp 40 #2134
	sw %ra %sp 44 #2134 call dir
	addi %sp %sp 48 #2134	
	jal %ra min_caml_float_of_int #2134
	addi %sp %sp -48 #2134
	lw %ra %sp 44 #2134
	li %f1 l.93232 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.93234 #2134
	fsub %f2 %f0 %f1 #2134
	li %f0 l.90390 #2135
	li %f1 l.90390 #2135
	lw %f3 %sp 32 #2135
	lw %a0 %sp 40 #2135
	lw %a1 %sp 16 #2135
	lw %a2 %sp 12 #2135
	lw %a11 %sp 20 #2135
	sw %ra %sp 44 #2135 call cls
	lw %a10 %a11 0 #2135
	addi %sp %sp 48 #2135	
	jalr %ra %a10 0 #2135
	addi %sp %sp -48 #2135
	lw %ra %sp 44 #2135
	lw %a0 %sp 24 #2137
	sw %ra %sp 44 #2137 call dir
	addi %sp %sp 48 #2137	
	jal %ra min_caml_float_of_int #2137
	addi %sp %sp -48 #2137
	lw %ra %sp 44 #2137
	li %f1 l.93232 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.92051 #2137
	fadd %f2 %f0 %f1 #2137
	li %f0 l.90390 #2138
	li %f1 l.90390 #2138
	lw %a0 %sp 12 #2138
	addi %a2 %a0 2 #2138
	lw %f3 %sp 32 #2138
	lw %a1 %sp 40 #2138
	lw %a3 %sp 16 #2138
	lw %a11 %sp 20 #2138
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 44 #2138 call cls
	lw %a10 %a11 0 #2138
	addi %sp %sp 48 #2138	
	jalr %ra %a10 0 #2138
	addi %sp %sp -48 #2138
	lw %ra %sp 44 #2138
	addi %a0 %zero 3 #2140
	lw %a1 %sp 16 #123
	addi %a2 %a1 1 #123
	addi %a12 %zero 5
	blt %a2 %a12 bge_else.100993 # nontail if
	addi %a2 %a2 -5 #124
	jal %zero bge_cont.100994 # then sentence ends
bge_else.100993:
bge_cont.100994:
	lw %f0 %sp 32 #2140
	lw %a3 %sp 12 #2140
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
	lw %a1 %sp 16 #123
	addi %a1 %a1 2 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.100995 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.100996 # then sentence ends
bge_else.100995:
bge_cont.100996:
	lw %a2 %sp 12 #2149
	addi %a2 %a2 4 #2149
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.100997
	sw %a0 %sp 44 #2147
	sw %a2 %sp 48 #2147
	sw %a1 %sp 52 #2147
	sw %ra %sp 60 #2147 call dir
	addi %sp %sp 64 #2147	
	jal %ra min_caml_float_of_int #2147
	addi %sp %sp -64 #2147
	lw %ra %sp 60 #2147
	li %f1 l.93232 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.93234 #2147
	fsub %f0 %f0 %f1 #2147
	addi %a0 %zero 4 #2148
	lw %a1 %sp 52 #2148
	lw %a2 %sp 48 #2148
	lw %a11 %sp 8 #2148
	sw %ra %sp 60 #2148 call cls
	lw %a10 %a11 0 #2148
	addi %sp %sp 64 #2148	
	jalr %ra %a10 0 #2148
	addi %sp %sp -64 #2148
	lw %ra %sp 60 #2148
	lw %a0 %sp 44 #2149
	addi %a0 %a0 -1 #2149
	lw %a1 %sp 52 #123
	addi %a1 %a1 2 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.100998 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.100999 # then sentence ends
bge_else.100998:
bge_cont.100999:
	lw %a2 %sp 48 #2149
	addi %a2 %a2 4 #2149
	lw %a11 %sp 0 #2149
	lw %a10 %a11 0 #2149
	jalr %zero %a10 0 #2149
bge_else.100997:
	jalr %zero %ra 0 #2150
bge_else.100991:
	jalr %zero %ra 0 #2150
create_dirvec_elements.2689:
	lw %a2 %a11 4 #2162
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.101002
	addi %a3 %zero 3 #2157
	li %f0 l.90390 #2157
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
	blt %a0 %a12 bge_else.101003
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
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
	blt %a0 %a12 bge_else.101004
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
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
	blt %a0 %a12 bge_else.101005
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 36 #2157
	add %a0 %a1 %zero
	sw %ra %sp 44 #2157 call dir
	addi %sp %sp 48 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -48 #2157
	lw %ra %sp 44 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
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
	lw %a1 %sp 36 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a0 %a1 -1 #2165
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101006
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 44 #2157
	add %a0 %a1 %zero
	sw %ra %sp 52 #2157 call dir
	addi %sp %sp 56 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -56 #2157
	lw %ra %sp 52 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 48 #2158
	add %a0 %a2 %zero
	sw %ra %sp 52 #2158 call dir
	addi %sp %sp 56 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -56 #2158
	lw %ra %sp 52 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 48 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 44 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a0 %a1 -1 #2165
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101007
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 52 #2157
	add %a0 %a1 %zero
	sw %ra %sp 60 #2157 call dir
	addi %sp %sp 64 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -64 #2157
	lw %ra %sp 60 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 56 #2158
	add %a0 %a2 %zero
	sw %ra %sp 60 #2158 call dir
	addi %sp %sp 64 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -64 #2158
	lw %ra %sp 60 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 56 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 52 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a0 %a1 -1 #2165
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101008
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 60 #2157
	add %a0 %a1 %zero
	sw %ra %sp 68 #2157 call dir
	addi %sp %sp 72 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -72 #2157
	lw %ra %sp 68 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
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
	lw %a1 %sp 60 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a0 %a1 -1 #2165
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101009
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 68 #2157
	add %a0 %a1 %zero
	sw %ra %sp 76 #2157 call dir
	addi %sp %sp 80 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -80 #2157
	lw %ra %sp 76 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a0 %a0 0 #15
	sw %a1 %sp 72 #2158
	sw %ra %sp 76 #2158 call dir
	addi %sp %sp 80 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -80 #2158
	lw %ra %sp 76 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 72 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 68 #2164
	slli %a2 %a1 2 #2164
	lw %a3 %sp 4 #2164
	add %a12 %a3 %a2 #2164
	sw %a0 %a12 0 #2164
	addi %a1 %a1 -1 #2165
	lw %a11 %sp 0 #2165
	add %a0 %a3 %zero
	lw %a10 %a11 0 #2165
	jalr %zero %a10 0 #2165
bge_else.101009:
	jalr %zero %ra 0 #2166
bge_else.101008:
	jalr %zero %ra 0 #2166
bge_else.101007:
	jalr %zero %ra 0 #2166
bge_else.101006:
	jalr %zero %ra 0 #2166
bge_else.101005:
	jalr %zero %ra 0 #2166
bge_else.101004:
	jalr %zero %ra 0 #2166
bge_else.101003:
	jalr %zero %ra 0 #2166
bge_else.101002:
	jalr %zero %ra 0 #2166
create_dirvecs.2692:
	lw %a1 %a11 12 #2169
	lw %a2 %a11 8 #2169
	lw %a3 %a11 4 #2169
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101018
	addi %a4 %zero 120 #2171
	addi %a5 %zero 3 #2157
	li %f0 l.90390 #2157
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
	li %f0 l.90390 #2157
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
	li %f0 l.90390 #2157
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
	li %f0 l.90390 #2157
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
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 44 #2157 call dir
	addi %sp %sp 48 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -48 #2157
	lw %ra %sp 44 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 44 #2158
	add %a0 %a2 %zero
	sw %ra %sp 52 #2158 call dir
	addi %sp %sp 56 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -56 #2158
	lw %ra %sp 52 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 44 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	sw %a0 %a1 460 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 52 #2157 call dir
	addi %sp %sp 56 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -56 #2157
	lw %ra %sp 52 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 48 #2158
	add %a0 %a2 %zero
	sw %ra %sp 52 #2158 call dir
	addi %sp %sp 56 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -56 #2158
	lw %ra %sp 52 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 48 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	sw %a0 %a1 456 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
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
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	sw %a0 %a1 452 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 60 #2157 call dir
	addi %sp %sp 64 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -64 #2157
	lw %ra %sp 60 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 56 #2158
	add %a0 %a2 %zero
	sw %ra %sp 60 #2158 call dir
	addi %sp %sp 64 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -64 #2158
	lw %ra %sp 60 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 56 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 28 #2164
	sw %a0 %a1 448 #2164
	addi %a0 %zero 111 #2165
	lw %a11 %sp 4 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 60 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 64 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -64 #2165
	lw %ra %sp 60 #2165
	lw %a0 %sp 12 #2173
	addi %a0 %a0 -1 #2173
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101019
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 60 #2157
	sw %a1 %sp 64 #2157
	add %a0 %a2 %zero
	sw %ra %sp 68 #2157 call dir
	addi %sp %sp 72 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -72 #2157
	lw %ra %sp 68 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 68 #2158
	add %a0 %a2 %zero
	sw %ra %sp 76 #2158 call dir
	addi %sp %sp 80 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -80 #2158
	lw %ra %sp 76 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 68 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 64 #2171
	sw %ra %sp 76 #2171 call dir
	addi %sp %sp 80 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -80 #2171
	lw %ra %sp 76 #2171
	lw %a1 %sp 60 #2171
	slli %a2 %a1 2 #2171
	lw %a3 %sp 8 #2171
	add %a12 %a3 %a2 #2171
	sw %a0 %a12 0 #2171
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	addi %a2 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 72 #2157
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
	addi %a0 %a1 0 #2159
	lw %a1 %sp 72 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 84 #2157 call dir
	addi %sp %sp 88 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -88 #2157
	lw %ra %sp 84 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
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
	addi %a0 %a1 0 #2159
	lw %a1 %sp 72 #2164
	sw %a0 %a1 468 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
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
	lw %a1 %sp 72 #2164
	sw %a0 %a1 464 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 92 #2157 call dir
	addi %sp %sp 96 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -96 #2157
	lw %ra %sp 92 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 88 #2158
	add %a0 %a2 %zero
	sw %ra %sp 92 #2158 call dir
	addi %sp %sp 96 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -96 #2158
	lw %ra %sp 92 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 88 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 72 #2164
	sw %a0 %a1 460 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 92 #2157 call dir
	addi %sp %sp 96 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -96 #2157
	lw %ra %sp 92 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 92 #2158
	add %a0 %a2 %zero
	sw %ra %sp 100 #2158 call dir
	addi %sp %sp 104 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -104 #2158
	lw %ra %sp 100 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 92 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 72 #2164
	sw %a0 %a1 456 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 100 #2157 call dir
	addi %sp %sp 104 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -104 #2157
	lw %ra %sp 100 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 96 #2158
	add %a0 %a2 %zero
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
	addi %a0 %a1 0 #2159
	lw %a1 %sp 72 #2164
	sw %a0 %a1 452 #2164
	addi %a0 %zero 112 #2165
	lw %a11 %sp 4 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 100 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 104 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -104 #2165
	lw %ra %sp 100 #2165
	lw %a0 %sp 60 #2173
	addi %a0 %a0 -1 #2173
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101020
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 100 #2157
	sw %a1 %sp 104 #2157
	add %a0 %a2 %zero
	sw %ra %sp 108 #2157 call dir
	addi %sp %sp 112 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -112 #2157
	lw %ra %sp 108 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 108 #2158
	add %a0 %a2 %zero
	sw %ra %sp 116 #2158 call dir
	addi %sp %sp 120 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -120 #2158
	lw %ra %sp 116 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 108 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 104 #2171
	sw %ra %sp 116 #2171 call dir
	addi %sp %sp 120 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -120 #2171
	lw %ra %sp 116 #2171
	lw %a1 %sp 100 #2171
	slli %a2 %a1 2 #2171
	lw %a3 %sp 8 #2171
	add %a12 %a3 %a2 #2171
	sw %a0 %a12 0 #2171
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	addi %a2 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 112 #2157
	add %a0 %a2 %zero
	sw %ra %sp 116 #2157 call dir
	addi %sp %sp 120 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -120 #2157
	lw %ra %sp 116 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 116 #2158
	add %a0 %a2 %zero
	sw %ra %sp 124 #2158 call dir
	addi %sp %sp 128 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -128 #2158
	lw %ra %sp 124 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 116 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 112 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 124 #2157 call dir
	addi %sp %sp 128 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -128 #2157
	lw %ra %sp 124 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 120 #2158
	add %a0 %a2 %zero
	sw %ra %sp 124 #2158 call dir
	addi %sp %sp 128 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -128 #2158
	lw %ra %sp 124 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 120 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 112 #2164
	sw %a0 %a1 468 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 124 #2157 call dir
	addi %sp %sp 128 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -128 #2157
	lw %ra %sp 124 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 124 #2158
	add %a0 %a2 %zero
	sw %ra %sp 132 #2158 call dir
	addi %sp %sp 136 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -136 #2158
	lw %ra %sp 132 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 124 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 112 #2164
	sw %a0 %a1 464 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 132 #2157 call dir
	addi %sp %sp 136 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -136 #2157
	lw %ra %sp 132 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
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
	addi %a0 %a1 0 #2159
	lw %a1 %sp 112 #2164
	sw %a0 %a1 460 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 132 #2157 call dir
	addi %sp %sp 136 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -136 #2157
	lw %ra %sp 132 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 132 #2158
	add %a0 %a2 %zero
	sw %ra %sp 140 #2158 call dir
	addi %sp %sp 144 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -144 #2158
	lw %ra %sp 140 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 132 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 112 #2164
	sw %a0 %a1 456 #2164
	addi %a0 %zero 113 #2165
	lw %a11 %sp 4 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 140 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 144 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -144 #2165
	lw %ra %sp 140 #2165
	lw %a0 %sp 100 #2173
	addi %a0 %a0 -1 #2173
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101021
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 136 #2157
	sw %a1 %sp 140 #2157
	add %a0 %a2 %zero
	sw %ra %sp 148 #2157 call dir
	addi %sp %sp 152 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -152 #2157
	lw %ra %sp 148 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 144 #2158
	add %a0 %a2 %zero
	sw %ra %sp 148 #2158 call dir
	addi %sp %sp 152 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -152 #2158
	lw %ra %sp 148 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 144 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 140 #2171
	sw %ra %sp 148 #2171 call dir
	addi %sp %sp 152 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -152 #2171
	lw %ra %sp 148 #2171
	lw %a1 %sp 136 #2171
	slli %a2 %a1 2 #2171
	lw %a3 %sp 8 #2171
	add %a12 %a3 %a2 #2171
	sw %a0 %a12 0 #2171
	slli %a0 %a1 2 #81
	add %a12 %a3 %a0 #81
	lw %a0 %a12 0 #81
	addi %a2 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 148 #2157
	add %a0 %a2 %zero
	sw %ra %sp 156 #2157 call dir
	addi %sp %sp 160 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -160 #2157
	lw %ra %sp 156 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 152 #2158
	add %a0 %a2 %zero
	sw %ra %sp 156 #2158 call dir
	addi %sp %sp 160 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -160 #2158
	lw %ra %sp 156 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 152 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 148 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 156 #2157 call dir
	addi %sp %sp 160 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -160 #2157
	lw %ra %sp 156 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 156 #2158
	add %a0 %a2 %zero
	sw %ra %sp 164 #2158 call dir
	addi %sp %sp 168 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -168 #2158
	lw %ra %sp 164 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 156 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 148 #2164
	sw %a0 %a1 468 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 164 #2157 call dir
	addi %sp %sp 168 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -168 #2157
	lw %ra %sp 164 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 160 #2158
	add %a0 %a2 %zero
	sw %ra %sp 164 #2158 call dir
	addi %sp %sp 168 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -168 #2158
	lw %ra %sp 164 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 160 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 148 #2164
	sw %a0 %a1 464 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 164 #2157 call dir
	addi %sp %sp 168 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -168 #2157
	lw %ra %sp 164 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 20 #15
	lw %a0 %a0 0 #15
	sw %a1 %sp 164 #2158
	sw %ra %sp 172 #2158 call dir
	addi %sp %sp 176 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -176 #2158
	lw %ra %sp 172 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 164 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 148 #2164
	sw %a0 %a1 460 #2164
	addi %a0 %zero 114 #2165
	lw %a11 %sp 4 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 172 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 176 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -176 #2165
	lw %ra %sp 172 #2165
	lw %a0 %sp 136 #2173
	addi %a0 %a0 -1 #2173
	lw %a11 %sp 0 #2173
	lw %a10 %a11 0 #2173
	jalr %zero %a10 0 #2173
bge_else.101021:
	jalr %zero %ra 0 #2174
bge_else.101020:
	jalr %zero %ra 0 #2174
bge_else.101019:
	jalr %zero %ra 0 #2174
bge_else.101018:
	jalr %zero %ra 0 #2174
init_dirvec_constants.2694:
	lw %a2 %a11 16 #2179
	lw %a3 %a11 12 #2179
	lw %a4 %a11 8 #2179
	lw %a5 %a11 4 #2179
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.101026
	slli %a6 %a1 2 #2181
	add %a12 %a0 %a6 #2181
	lw %a6 %a12 0 #2181
	lw %a7 %a4 0 #15
	addi %a7 %a7 -1 #1121
	sw %a11 %sp 0 #1121
	sw %a2 %sp 4 #1121
	sw %a5 %sp 8 #1121
	sw %a3 %sp 12 #1121
	sw %a4 %sp 16 #1121
	sw %a0 %sp 20 #1121
	sw %a1 %sp 24 #1121
	add %a1 %a7 %zero
	add %a0 %a6 %zero
	add %a11 %a5 %zero
	sw %ra %sp 28 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 32 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -32 #1121
	lw %ra %sp 28 #1121
	lw %a0 %sp 24 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101027
	slli %a1 %a0 2 #2181
	lw %a2 %sp 20 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a3 %sp 16 #15
	lw %a4 %a3 0 #15
	addi %a4 %a4 -1 #1121
	sw %a0 %sp 28 #1104
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.101028 # nontail if
	slli %a5 %a4 2 #20
	lw %a6 %sp 12 #20
	add %a12 %a6 %a5 #20
	lw %a5 %a12 0 #20
	lw %a6 %a1 4 #513
	lw %a7 %a1 0 #507
	lw %a8 %a5 4 #238
	sw %a1 %sp 32 #868
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.101030 # nontail if
	sw %a6 %sp 36 #1110
	sw %a4 %sp 40 #1110
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 44 #1110 call dir
	addi %sp %sp 48 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -48 #1110
	lw %ra %sp 44 #1110
	lw %a1 %sp 40 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 36 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.101031 # then sentence ends
beq_else.101030:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.101032 # nontail if
	addi %a8 %zero 4 #1057
	li %f0 l.90390 #1057
	sw %a6 %sp 36 #1057
	sw %a4 %sp 40 #1057
	sw %a5 %sp 44 #1057
	sw %a7 %sp 48 #1057
	add %a0 %a8 %zero
	sw %ra %sp 52 #1057 call dir
	addi %sp %sp 56 #1057	
	jal %ra min_caml_create_float_array #1057
	addi %sp %sp -56 #1057
	lw %ra %sp 52 #1057
	lw %a1 %sp 48 #1059
	lw %f0 %a1 0 #1059
	lw %a2 %sp 44 #276
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
	sw %f0 %sp 56 #1061
	sw %a0 %sp 64 #1061
	sw %ra %sp 68 #1061 call dir
	addi %sp %sp 72 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -72 #1061
	lw %ra %sp 68 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.101035 # nontail if
	li %f0 l.90390 #1069
	lw %a0 %sp 64 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.101036 # then sentence ends
beq_else.101035:
	li %f0 l.90466 #1063
	lw %f1 %sp 56 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 64 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 44 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 68 #1065 call dir
	addi %sp %sp 72 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -72 #1065
	lw %ra %sp 68 #1065
	lw %a0 %sp 64 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 44 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	lw %f1 %sp 56 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 68 #1066 call dir
	addi %sp %sp 72 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -72 #1066
	lw %ra %sp 68 #1066
	lw %a0 %sp 64 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 44 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	lw %f1 %sp 56 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 68 #1067 call dir
	addi %sp %sp 72 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -72 #1067
	lw %ra %sp 68 #1067
	lw %a0 %sp 64 #1067
	sw %f0 %a0 12 #1067
beq_cont.101036:
	lw %a1 %sp 40 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 36 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.101033 # then sentence ends
beq_else.101032:
	sw %a6 %sp 36 #1114
	sw %a4 %sp 40 #1114
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 68 #1114 call dir
	addi %sp %sp 72 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -72 #1114
	lw %ra %sp 68 #1114
	lw %a1 %sp 40 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 36 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.101033:
beq_cont.101031:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 32 #1116
	lw %a11 %sp 8 #1116
	sw %ra %sp 68 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 72 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -72 #1116
	lw %ra %sp 68 #1116
	jal %zero bge_cont.101029 # then sentence ends
bge_else.101028:
bge_cont.101029:
	lw %a0 %sp 28 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101037
	slli %a1 %a0 2 #2181
	lw %a2 %sp 20 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a3 %sp 16 #15
	lw %a3 %a3 0 #15
	addi %a3 %a3 -1 #1121
	lw %a11 %sp 8 #1121
	sw %a0 %sp 68 #1121
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 76 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 80 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -80 #1121
	lw %ra %sp 76 #1121
	lw %a0 %sp 68 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101038
	slli %a1 %a0 2 #2181
	lw %a2 %sp 20 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a11 %sp 4 #2181
	sw %a0 %sp 72 #2181
	add %a0 %a1 %zero
	sw %ra %sp 76 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 80 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -80 #2181
	lw %ra %sp 76 #2181
	lw %a0 %sp 72 #2182
	addi %a1 %a0 -1 #2182
	lw %a0 %sp 20 #2182
	lw %a11 %sp 0 #2182
	lw %a10 %a11 0 #2182
	jalr %zero %a10 0 #2182
bge_else.101038:
	jalr %zero %ra 0 #2183
bge_else.101037:
	jalr %zero %ra 0 #2183
bge_else.101027:
	jalr %zero %ra 0 #2183
bge_else.101026:
	jalr %zero %ra 0 #2183
init_vecset_constants.2697:
	lw %a1 %a11 24 #2186
	lw %a2 %a11 20 #2186
	lw %a3 %a11 16 #2186
	lw %a4 %a11 12 #2186
	lw %a5 %a11 8 #2186
	lw %a6 %a11 4 #2186
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101043
	slli %a7 %a0 2 #81
	add %a12 %a6 %a7 #81
	lw %a7 %a12 0 #81
	lw %a8 %a7 476 #2181
	lw %a9 %a3 0 #15
	addi %a9 %a9 -1 #1121
	sw %a11 %sp 0 #1104
	sw %a6 %sp 4 #1104
	sw %a0 %sp 8 #1104
	sw %a5 %sp 12 #1104
	sw %a1 %sp 16 #1104
	sw %a4 %sp 20 #1104
	sw %a3 %sp 24 #1104
	sw %a7 %sp 28 #1104
	addi %a12 %zero 0
	blt %a9 %a12 bge_else.101044 # nontail if
	slli %a10 %a9 2 #20
	add %a12 %a2 %a10 #20
	lw %a2 %a12 0 #20
	lw %a10 %a8 4 #513
	lw %a11 %a8 0 #507
	lw %a6 %a2 4 #238
	sw %a8 %sp 32 #868
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.101046 # nontail if
	sw %a10 %sp 36 #1110
	sw %a9 %sp 40 #1110
	add %a1 %a2 %zero
	add %a0 %a11 %zero
	sw %ra %sp 44 #1110 call dir
	addi %sp %sp 48 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -48 #1110
	lw %ra %sp 44 #1110
	lw %a1 %sp 40 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 36 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.101047 # then sentence ends
beq_else.101046:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.101048 # nontail if
	addi %a6 %zero 4 #1057
	li %f0 l.90390 #1057
	sw %a10 %sp 36 #1057
	sw %a9 %sp 40 #1057
	sw %a2 %sp 44 #1057
	sw %a11 %sp 48 #1057
	add %a0 %a6 %zero
	sw %ra %sp 52 #1057 call dir
	addi %sp %sp 56 #1057	
	jal %ra min_caml_create_float_array #1057
	addi %sp %sp -56 #1057
	lw %ra %sp 52 #1057
	lw %a1 %sp 48 #1059
	lw %f0 %a1 0 #1059
	lw %a2 %sp 44 #276
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
	sw %f0 %sp 56 #1061
	sw %a0 %sp 64 #1061
	sw %ra %sp 68 #1061 call dir
	addi %sp %sp 72 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -72 #1061
	lw %ra %sp 68 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.101051 # nontail if
	li %f0 l.90390 #1069
	lw %a0 %sp 64 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.101052 # then sentence ends
beq_else.101051:
	li %f0 l.90466 #1063
	lw %f1 %sp 56 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 64 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 44 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 68 #1065 call dir
	addi %sp %sp 72 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -72 #1065
	lw %ra %sp 68 #1065
	lw %a0 %sp 64 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 44 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	lw %f1 %sp 56 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 68 #1066 call dir
	addi %sp %sp 72 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -72 #1066
	lw %ra %sp 68 #1066
	lw %a0 %sp 64 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 44 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	lw %f1 %sp 56 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 68 #1067 call dir
	addi %sp %sp 72 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -72 #1067
	lw %ra %sp 68 #1067
	lw %a0 %sp 64 #1067
	sw %f0 %a0 12 #1067
beq_cont.101052:
	lw %a1 %sp 40 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 36 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.101049 # then sentence ends
beq_else.101048:
	sw %a10 %sp 36 #1114
	sw %a9 %sp 40 #1114
	add %a1 %a2 %zero
	add %a0 %a11 %zero
	sw %ra %sp 68 #1114 call dir
	addi %sp %sp 72 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -72 #1114
	lw %ra %sp 68 #1114
	lw %a1 %sp 40 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 36 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.101049:
beq_cont.101047:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 32 #1116
	lw %a11 %sp 20 #1116
	sw %ra %sp 68 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 72 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -72 #1116
	lw %ra %sp 68 #1116
	jal %zero bge_cont.101045 # then sentence ends
bge_else.101044:
bge_cont.101045:
	lw %a0 %sp 28 #2181
	lw %a1 %a0 472 #2181
	lw %a2 %sp 24 #15
	lw %a3 %a2 0 #15
	addi %a3 %a3 -1 #1121
	lw %a11 %sp 20 #1121
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 68 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 72 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -72 #1121
	lw %ra %sp 68 #1121
	lw %a0 %sp 28 #2181
	lw %a1 %a0 468 #2181
	lw %a11 %sp 16 #2181
	add %a0 %a1 %zero
	sw %ra %sp 68 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 72 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -72 #2181
	lw %ra %sp 68 #2181
	addi %a1 %zero 116 #2182
	lw %a0 %sp 28 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 68 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 72 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -72 #2182
	lw %ra %sp 68 #2182
	lw %a0 %sp 8 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101053
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	lw %a3 %a1 476 #2181
	lw %a4 %sp 24 #15
	lw %a4 %a4 0 #15
	addi %a4 %a4 -1 #1121
	lw %a11 %sp 20 #1121
	sw %a0 %sp 68 #1121
	sw %a1 %sp 72 #1121
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 76 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 80 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -80 #1121
	lw %ra %sp 76 #1121
	lw %a0 %sp 72 #2181
	lw %a1 %a0 472 #2181
	lw %a11 %sp 16 #2181
	add %a0 %a1 %zero
	sw %ra %sp 76 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 80 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -80 #2181
	lw %ra %sp 76 #2181
	addi %a1 %zero 117 #2182
	lw %a0 %sp 72 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 76 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 80 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -80 #2182
	lw %ra %sp 76 #2182
	lw %a0 %sp 68 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101054
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	lw %a3 %a1 476 #2181
	lw %a11 %sp 16 #2181
	sw %a0 %sp 76 #2181
	sw %a1 %sp 80 #2181
	add %a0 %a3 %zero
	sw %ra %sp 84 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 88 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -88 #2181
	lw %ra %sp 84 #2181
	addi %a1 %zero 118 #2182
	lw %a0 %sp 80 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 84 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 88 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -88 #2182
	lw %ra %sp 84 #2182
	lw %a0 %sp 76 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101055
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	addi %a2 %zero 119 #2188
	lw %a11 %sp 12 #2188
	sw %a0 %sp 84 #2188
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 92 #2188 call cls
	lw %a10 %a11 0 #2188
	addi %sp %sp 96 #2188	
	jalr %ra %a10 0 #2188
	addi %sp %sp -96 #2188
	lw %ra %sp 92 #2188
	lw %a0 %sp 84 #2189
	addi %a0 %a0 -1 #2189
	lw %a11 %sp 0 #2189
	lw %a10 %a11 0 #2189
	jalr %zero %a10 0 #2189
bge_else.101055:
	jalr %zero %ra 0 #2190
bge_else.101054:
	jalr %zero %ra 0 #2190
bge_else.101053:
	jalr %zero %ra 0 #2190
bge_else.101043:
	jalr %zero %ra 0 #2190
setup_reflections.2714:
	lw %a1 %a11 24 #2240
	lw %a2 %a11 20 #2240
	lw %a3 %a11 16 #2240
	lw %a4 %a11 12 #2240
	lw %a5 %a11 8 #2240
	lw %a6 %a11 4 #2240
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.101060
	slli %a7 %a0 2 #20
	add %a12 %a2 %a7 #20
	lw %a2 %a12 0 #20
	lw %a7 %a2 8 #248
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.101061
	lw %a7 %a2 28 #346
	lw %f0 %a7 0 #351
	li %f1 l.90464 #2244
	sw %a1 %sp 0 #2244
	sw %a6 %sp 4 #2244
	sw %a4 %sp 8 #2244
	sw %a5 %sp 12 #2244
	sw %a3 %sp 16 #2244
	sw %a0 %sp 20 #2244
	sw %a2 %sp 24 #2244
	sw %ra %sp 28 #2244 call dir
	addi %sp %sp 32 #2244	
	jal %ra min_caml_fless #2244
	addi %sp %sp -32 #2244
	lw %ra %sp 28 #2244
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.101062
	jalr %zero %ra 0 #2252
beq_else.101062:
	lw %a0 %sp 24 #238
	lw %a1 %a0 4 #238
	addi %a12 %zero 1
	bne %a1 %a12 beq_else.101064
	addi %a1 %zero 4 #2212
	lw %a2 %sp 20 #2212
	add %a0 %a2 %zero
	sw %ra %sp 28 #2212 call dir
	addi %sp %sp 32 #2212	
	jal %ra min_caml_sll #2212
	addi %sp %sp -32 #2212
	lw %ra %sp 28 #2212
	lw %a1 %sp 16 #99
	lw %a2 %a1 0 #99
	li %f0 l.90464 #2214
	lw %a3 %sp 24 #346
	lw %a3 %a3 28 #346
	lw %f1 %a3 0 #351
	fsub %f0 %f0 %f1 #2214
	lw %a3 %sp 12 #27
	lw %f1 %a3 0 #27
	sw %a2 %sp 28 #2215
	sw %f0 %sp 32 #2215
	sw %a0 %sp 40 #2215
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #2215 call dir
	addi %sp %sp 48 #2215	
	jal %ra min_caml_fneg #2215
	addi %sp %sp -48 #2215
	lw %ra %sp 44 #2215
	lw %a0 %sp 12 #27
	lw %f1 %a0 4 #27
	sw %f0 %sp 48 #2216
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #2216 call dir
	addi %sp %sp 64 #2216	
	jal %ra min_caml_fneg #2216
	addi %sp %sp -64 #2216
	lw %ra %sp 60 #2216
	lw %a0 %sp 12 #27
	lw %f1 %a0 8 #27
	sw %f0 %sp 56 #2217
	fadd %f0 %f1 %fzero
	sw %ra %sp 68 #2217 call dir
	addi %sp %sp 72 #2217	
	jal %ra min_caml_fneg #2217
	addi %sp %sp -72 #2217
	lw %ra %sp 68 #2217
	lw %a0 %sp 40 #2218
	addi %a1 %a0 1 #2218
	lw %a2 %sp 12 #27
	lw %f1 %a2 0 #27
	addi %a3 %zero 3 #2157
	li %f2 l.90390 #2157
	sw %a1 %sp 64 #2157
	sw %f0 %sp 72 #2157
	sw %f1 %sp 80 #2157
	add %a0 %a3 %zero
	fadd %f0 %f2 %fzero
	sw %ra %sp 92 #2157 call dir
	addi %sp %sp 96 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -96 #2157
	lw %ra %sp 92 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 88 #2158
	add %a0 %a2 %zero
	sw %ra %sp 92 #2158 call dir
	addi %sp %sp 96 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -96 #2158
	lw %ra %sp 92 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 88 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 80 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 56 #134
	sw %f0 %a0 4 #134
	lw %f1 %sp 72 #135
	sw %f1 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	addi %a2 %a2 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 92 #1121
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 100 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 104 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -104 #1121
	lw %ra %sp 100 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 32 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 92 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 64 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 28 #2207
	slli %a2 %a1 2 #2207
	lw %a3 %sp 0 #2207
	add %a12 %a3 %a2 #2207
	sw %a0 %a12 0 #2207
	addi %a0 %a1 1 #2219
	lw %a2 %sp 40 #2219
	addi %a4 %a2 2 #2219
	lw %a5 %sp 12 #27
	lw %f1 %a5 4 #27
	addi %a6 %zero 3 #2157
	li %f2 l.90390 #2157
	sw %a0 %sp 96 #2157
	sw %a4 %sp 100 #2157
	sw %f1 %sp 104 #2157
	add %a0 %a6 %zero
	fadd %f0 %f2 %fzero
	sw %ra %sp 116 #2157 call dir
	addi %sp %sp 120 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -120 #2157
	lw %ra %sp 116 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 112 #2158
	add %a0 %a2 %zero
	sw %ra %sp 116 #2158 call dir
	addi %sp %sp 120 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -120 #2158
	lw %ra %sp 116 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 112 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 48 #133
	sw %f0 %a0 0 #133
	lw %f1 %sp 104 #134
	sw %f1 %a0 4 #134
	lw %f1 %sp 72 #135
	sw %f1 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	addi %a2 %a2 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 116 #1121
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 124 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 128 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -128 #1121
	lw %ra %sp 124 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 32 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 116 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 100 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 96 #2207
	slli %a1 %a1 2 #2207
	lw %a2 %sp 0 #2207
	add %a12 %a2 %a1 #2207
	sw %a0 %a12 0 #2207
	lw %a0 %sp 28 #2220
	addi %a1 %a0 2 #2220
	lw %a3 %sp 40 #2220
	addi %a3 %a3 3 #2220
	lw %a4 %sp 12 #27
	lw %f1 %a4 8 #27
	addi %a4 %zero 3 #2157
	li %f2 l.90390 #2157
	sw %a1 %sp 120 #2157
	sw %a3 %sp 124 #2157
	sw %f1 %sp 128 #2157
	add %a0 %a4 %zero
	fadd %f0 %f2 %fzero
	sw %ra %sp 140 #2157 call dir
	addi %sp %sp 144 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -144 #2157
	lw %ra %sp 140 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 136 #2158
	add %a0 %a2 %zero
	sw %ra %sp 140 #2158 call dir
	addi %sp %sp 144 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -144 #2158
	lw %ra %sp 140 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 136 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 48 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 56 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 128 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 140 #1121
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 148 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 152 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -152 #1121
	lw %ra %sp 148 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 32 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 140 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 124 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 120 #2207
	slli %a1 %a1 2 #2207
	lw %a2 %sp 0 #2207
	add %a12 %a2 %a1 #2207
	sw %a0 %a12 0 #2207
	lw %a0 %sp 28 #2221
	addi %a0 %a0 3 #2221
	lw %a1 %sp 16 #2221
	sw %a0 %a1 0 #2221
	jalr %zero %ra 0 #2221
beq_else.101064:
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.101068
	addi %a1 %zero 4 #2226
	lw %a2 %sp 20 #2226
	add %a0 %a2 %zero
	sw %ra %sp 148 #2226 call dir
	addi %sp %sp 152 #2226	
	jal %ra min_caml_sll #2226
	addi %sp %sp -152 #2226
	lw %ra %sp 148 #2226
	addi %a0 %a0 1 #2226
	lw %a1 %sp 16 #99
	lw %a2 %a1 0 #99
	li %f0 l.90464 #2228
	lw %a3 %sp 24 #346
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
	li %f2 l.90418 #2232
	lw %a4 %a3 16 #276
	lw %f3 %a4 0 #281
	fmul %f2 %f2 %f3 #2232
	fmul %f2 %f2 %f1 #2232
	lw %f3 %a5 0 #27
	fsub %f2 %f2 %f3 #2232
	li %f3 l.90418 #2233
	lw %a4 %a3 16 #286
	lw %f4 %a4 4 #291
	fmul %f3 %f3 %f4 #2233
	fmul %f3 %f3 %f1 #2233
	lw %f4 %a5 4 #27
	fsub %f3 %f3 %f4 #2233
	li %f4 l.90418 #2234
	lw %a3 %a3 16 #296
	lw %f5 %a3 8 #301
	fmul %f4 %f4 %f5 #2234
	fmul %f1 %f4 %f1 #2234
	lw %f4 %a5 8 #27
	fsub %f1 %f1 %f4 #2234
	addi %a3 %zero 3 #2157
	li %f4 l.90390 #2157
	sw %a2 %sp 144 #2157
	sw %a0 %sp 148 #2157
	sw %f0 %sp 152 #2157
	sw %f1 %sp 160 #2157
	sw %f3 %sp 168 #2157
	sw %f2 %sp 176 #2157
	add %a0 %a3 %zero
	fadd %f0 %f4 %fzero
	sw %ra %sp 188 #2157 call dir
	addi %sp %sp 192 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -192 #2157
	lw %ra %sp 188 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 8 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 184 #2158
	add %a0 %a2 %zero
	sw %ra %sp 188 #2158 call dir
	addi %sp %sp 192 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -192 #2158
	lw %ra %sp 188 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 184 #2159
	sw %a0 %a1 0 #2159
	lw %f0 %sp 176 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 168 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 160 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 8 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #1121
	lw %a11 %sp 4 #1121
	sw %a1 %sp 188 #1121
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 196 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 200 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -200 #1121
	lw %ra %sp 196 #1121
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 152 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 188 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 148 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 144 #2207
	slli %a2 %a1 2 #2207
	lw %a3 %sp 0 #2207
	add %a12 %a3 %a2 #2207
	sw %a0 %a12 0 #2207
	addi %a0 %a1 1 #2235
	lw %a1 %sp 16 #2235
	sw %a0 %a1 0 #2235
	jalr %zero %ra 0 #2235
beq_else.101068:
	jalr %zero %ra 0 #2251
beq_else.101061:
	jalr %zero %ra 0 #2253
bge_else.101060:
	jalr %zero %ra 0 #2254
min_caml_start:
	li %sp 150000
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
	li %f0 l.90390 #19
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
	li %f0 l.90390 #23
	sw %a0 %sp 4 #23
	add %a0 %a1 %zero
	sw %ra %sp 12 #23 call dir
	addi %sp %sp 16 #23	
	jal %ra min_caml_create_float_array #23
	addi %sp %sp -16 #23
	lw %ra %sp 12 #23
	addi %a1 %zero 3 #25
	li %f0 l.90390 #25
	sw %a0 %sp 8 #25
	add %a0 %a1 %zero
	sw %ra %sp 12 #25 call dir
	addi %sp %sp 16 #25	
	jal %ra min_caml_create_float_array #25
	addi %sp %sp -16 #25
	lw %ra %sp 12 #25
	addi %a1 %zero 3 #27
	li %f0 l.90390 #27
	sw %a0 %sp 12 #27
	add %a0 %a1 %zero
	sw %ra %sp 20 #27 call dir
	addi %sp %sp 24 #27	
	jal %ra min_caml_create_float_array #27
	addi %sp %sp -24 #27
	lw %ra %sp 20 #27
	addi %a1 %zero 1 #29
	li %f0 l.91759 #29
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
	li %f0 l.90390 #37
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
	li %f0 l.91802 #41
	sw %a0 %sp 44 #41
	add %a0 %a1 %zero
	sw %ra %sp 52 #41 call dir
	addi %sp %sp 56 #41	
	jal %ra min_caml_create_float_array #41
	addi %sp %sp -56 #41
	lw %ra %sp 52 #41
	addi %a1 %zero 3 #43
	li %f0 l.90390 #43
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
	li %f0 l.90390 #47
	sw %a0 %sp 56 #47
	add %a0 %a1 %zero
	sw %ra %sp 60 #47 call dir
	addi %sp %sp 64 #47	
	jal %ra min_caml_create_float_array #47
	addi %sp %sp -64 #47
	lw %ra %sp 60 #47
	addi %a1 %zero 3 #49
	li %f0 l.90390 #49
	sw %a0 %sp 60 #49
	add %a0 %a1 %zero
	sw %ra %sp 68 #49 call dir
	addi %sp %sp 72 #49	
	jal %ra min_caml_create_float_array #49
	addi %sp %sp -72 #49
	lw %ra %sp 68 #49
	addi %a1 %zero 3 #52
	li %f0 l.90390 #52
	sw %a0 %sp 64 #52
	add %a0 %a1 %zero
	sw %ra %sp 68 #52 call dir
	addi %sp %sp 72 #52	
	jal %ra min_caml_create_float_array #52
	addi %sp %sp -72 #52
	lw %ra %sp 68 #52
	addi %a1 %zero 3 #54
	li %f0 l.90390 #54
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
	li %f0 l.90390 #61
	sw %a0 %sp 80 #61
	add %a0 %a1 %zero
	sw %ra %sp 84 #61 call dir
	addi %sp %sp 88 #61	
	jal %ra min_caml_create_float_array #61
	addi %sp %sp -88 #61
	lw %ra %sp 84 #61
	addi %a1 %zero 3 #64
	li %f0 l.90390 #64
	sw %a0 %sp 84 #64
	add %a0 %a1 %zero
	sw %ra %sp 92 #64 call dir
	addi %sp %sp 96 #64	
	jal %ra min_caml_create_float_array #64
	addi %sp %sp -96 #64
	lw %ra %sp 92 #64
	addi %a1 %zero 3 #66
	li %f0 l.90390 #66
	sw %a0 %sp 88 #66
	add %a0 %a1 %zero
	sw %ra %sp 92 #66 call dir
	addi %sp %sp 96 #66	
	jal %ra min_caml_create_float_array #66
	addi %sp %sp -96 #66
	lw %ra %sp 92 #66
	addi %a1 %zero 3 #69
	li %f0 l.90390 #69
	sw %a0 %sp 92 #69
	add %a0 %a1 %zero
	sw %ra %sp 100 #69 call dir
	addi %sp %sp 104 #69	
	jal %ra min_caml_create_float_array #69
	addi %sp %sp -104 #69
	lw %ra %sp 100 #69
	addi %a1 %zero 3 #70
	li %f0 l.90390 #70
	sw %a0 %sp 96 #70
	add %a0 %a1 %zero
	sw %ra %sp 100 #70 call dir
	addi %sp %sp 104 #70	
	jal %ra min_caml_create_float_array #70
	addi %sp %sp -104 #70
	lw %ra %sp 100 #70
	addi %a1 %zero 3 #71
	li %f0 l.90390 #71
	sw %a0 %sp 100 #71
	add %a0 %a1 %zero
	sw %ra %sp 108 #71 call dir
	addi %sp %sp 112 #71	
	jal %ra min_caml_create_float_array #71
	addi %sp %sp -112 #71
	lw %ra %sp 108 #71
	addi %a1 %zero 3 #74
	li %f0 l.90390 #74
	sw %a0 %sp 104 #74
	add %a0 %a1 %zero
	sw %ra %sp 108 #74 call dir
	addi %sp %sp 112 #74	
	jal %ra min_caml_create_float_array #74
	addi %sp %sp -112 #74
	lw %ra %sp 108 #74
	addi %a1 %zero 0 #78
	li %f0 l.90390 #78
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
	li %f0 l.90390 #85
	sw %a0 %sp 116 #85
	add %a0 %a1 %zero
	sw %ra %sp 124 #85 call dir
	addi %sp %sp 128 #85	
	jal %ra min_caml_create_float_array #85
	addi %sp %sp -128 #85
	lw %ra %sp 124 #85
	addi %a1 %zero 3 #86
	li %f0 l.90390 #86
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
	li %f0 l.90390 #92
	sw %a0 %sp 128 #92
	sw %a1 %sp 132 #92
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
	li %f0 l.90390 #95
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
	addi %a6 %min_caml_hp 0 #641
	addi %min_caml_hp %min_caml_hp 8 #641
	li %a7 read_nth_object.2369 #641
	sw %a7 %a6 0 #641
	lw %a7 %sp 4 #641
	sw %a7 %a6 4 #641
	addi %a8 %min_caml_hp 0 #724
	addi %min_caml_hp %min_caml_hp 16 #724
	li %a9 read_object.2371 #724
	sw %a9 %a8 0 #724
	sw %a6 %a8 8 #724
	lw %a9 %sp 0 #724
	sw %a9 %a8 4 #724
	addi %a10 %min_caml_hp 0 #757
	addi %min_caml_hp %min_caml_hp 8 #757
	li %a11 read_and_network.2379 #757
	sw %a11 %a10 0 #757
	lw %a11 %sp 28 #757
	sw %a11 %a10 4 #757
	addi %a4 %min_caml_hp 0 #766
	addi %min_caml_hp %min_caml_hp 40 #766
	li %a3 read_parameter.2381 #766
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
	li %a10 solver_rect.2392 #797
	sw %a10 %a8 0 #797
	lw %a10 %sp 40 #797
	sw %a10 %a8 4 #797
	sw %a4 %sp 144 #854
	addi %a4 %min_caml_hp 0 #854
	addi %min_caml_hp %min_caml_hp 8 #854
	li %a5 solver_second.2417 #854
	sw %a5 %a4 0 #854
	sw %a10 %a4 4 #854
	addi %a5 %min_caml_hp 0 #883
	addi %min_caml_hp %min_caml_hp 16 #883
	li %a2 solver.2423 #883
	sw %a2 %a5 0 #883
	sw %a10 %a5 8 #883
	sw %a7 %a5 4 #883
	addi %a2 %min_caml_hp 0 #900
	addi %min_caml_hp %min_caml_hp 8 #900
	li %a6 solver_rect_fast.2427 #900
	sw %a6 %a2 0 #900
	sw %a10 %a2 4 #900
	addi %a6 %min_caml_hp 0 #942
	addi %min_caml_hp %min_caml_hp 8 #942
	sw %a0 %sp 148 #942
	li %a0 solver_second_fast.2440 #942
	sw %a0 %a6 0 #942
	sw %a10 %a6 4 #942
	addi %a0 %min_caml_hp 0 #962
	addi %min_caml_hp %min_caml_hp 16 #962
	li %a1 solver_fast.2446 #962
	sw %a1 %a0 0 #962
	sw %a2 %a0 12 #962
	sw %a10 %a0 8 #962
	sw %a7 %a0 4 #962
	addi %a1 %min_caml_hp 0 #1009
	addi %min_caml_hp %min_caml_hp 16 #1009
	sw %a5 %sp 152 #1009
	li %a5 solver_fast2.2464 #1009
	sw %a5 %a1 0 #1009
	sw %a2 %a1 12 #1009
	sw %a10 %a1 8 #1009
	sw %a7 %a1 4 #1009
	addi %a5 %min_caml_hp 0 #1103
	addi %min_caml_hp %min_caml_hp 8 #1103
	sw %a1 %sp 156 #1103
	li %a1 iter_setup_dirvec_constants.2476 #1103
	sw %a1 %a5 0 #1103
	sw %a7 %a5 4 #1103
	addi %a1 %min_caml_hp 0 #1120
	addi %min_caml_hp %min_caml_hp 16 #1120
	sw %a8 %sp 160 #1120
	li %a8 setup_dirvec_constants.2479 #1120
	sw %a8 %a1 0 #1120
	sw %a7 %a1 12 #1120
	sw %a9 %a1 8 #1120
	sw %a5 %a1 4 #1120
	addi %a8 %min_caml_hp 0 #1126
	addi %min_caml_hp %min_caml_hp 8 #1126
	sw %a5 %sp 164 #1126
	li %a5 setup_startp_constants.2481 #1126
	sw %a5 %a8 0 #1126
	sw %a7 %a8 4 #1126
	addi %a5 %min_caml_hp 0 #1145
	addi %min_caml_hp %min_caml_hp 24 #1145
	sw %a1 %sp 168 #1145
	li %a1 setup_startp.2484 #1145
	sw %a1 %a5 0 #1145
	lw %a1 %sp 92 #1145
	sw %a1 %a5 16 #1145
	sw %a8 %a5 12 #1145
	sw %a7 %a5 8 #1145
	sw %a9 %a5 4 #1145
	sw %a5 %sp 172 #1193
	addi %a5 %min_caml_hp 0 #1193
	addi %min_caml_hp %min_caml_hp 8 #1193
	li %a9 check_all_inside.2506 #1193
	sw %a9 %a5 0 #1193
	sw %a7 %a5 4 #1193
	addi %a9 %min_caml_hp 0 #1211
	addi %min_caml_hp %min_caml_hp 48 #1211
	sw %a8 %sp 176 #1211
	li %a8 shadow_check_and_group.2512 #1211
	sw %a8 %a9 0 #1211
	lw %a8 %sp 124 #1211
	sw %a8 %a9 44 #1211
	sw %a6 %a9 40 #1211
	sw %a2 %a9 36 #1211
	sw %a0 %a9 32 #1211
	sw %a10 %a9 28 #1211
	sw %a7 %a9 24 #1211
	lw %a1 %sp 132 #1211
	sw %a1 %a9 20 #1211
	sw %a3 %a9 16 #1211
	sw %a4 %sp 180 #1211
	lw %a4 %sp 52 #1211
	sw %a4 %a9 12 #1211
	sw %a2 %sp 184 #1211
	lw %a2 %sp 128 #1211
	sw %a2 %a9 8 #1211
	sw %a5 %a9 4 #1211
	addi %a2 %min_caml_hp 0 #1241
	addi %min_caml_hp %min_caml_hp 40 #1241
	sw %a6 %sp 188 #1241
	li %a6 shadow_check_one_or_group.2515 #1241
	sw %a6 %a2 0 #1241
	sw %a0 %a2 36 #1241
	sw %a10 %a2 32 #1241
	sw %a9 %a2 28 #1241
	sw %a7 %a2 24 #1241
	sw %a1 %a2 20 #1241
	sw %a3 %a2 16 #1241
	sw %a4 %a2 12 #1241
	sw %a5 %a2 8 #1241
	sw %a11 %a2 4 #1241
	addi %a6 %min_caml_hp 0 #1256
	addi %min_caml_hp %min_caml_hp 56 #1256
	li %a3 shadow_check_one_or_matrix.2518 #1256
	sw %a3 %a6 0 #1256
	sw %a8 %a6 48 #1256
	lw %a3 %sp 188 #1256
	sw %a3 %a6 44 #1256
	lw %a3 %sp 184 #1256
	sw %a3 %a6 40 #1256
	sw %a0 %a6 36 #1256
	sw %a10 %a6 32 #1256
	sw %a2 %a6 28 #1256
	sw %a9 %a6 24 #1256
	sw %a7 %a6 20 #1256
	sw %a1 %a6 16 #1256
	sw %a4 %a6 12 #1256
	lw %a9 %sp 128 #1256
	sw %a9 %a6 8 #1256
	sw %a11 %a6 4 #1256
	addi %a9 %min_caml_hp 0 #1290
	addi %min_caml_hp %min_caml_hp 48 #1290
	li %a8 solve_each_element.2521 #1290
	sw %a8 %a9 0 #1290
	lw %a8 %sp 48 #1290
	sw %a8 %a9 44 #1290
	lw %a1 %sp 88 #1290
	sw %a1 %a9 40 #1290
	sw %a2 %sp 192 #1290
	lw %a2 %sp 180 #1290
	sw %a2 %a9 36 #1290
	sw %a6 %sp 196 #1290
	lw %a6 %sp 160 #1290
	sw %a6 %a9 32 #1290
	sw %a10 %a9 28 #1290
	sw %a0 %sp 200 #1290
	lw %a0 %sp 152 #1290
	sw %a0 %a9 24 #1290
	sw %a7 %a9 20 #1290
	lw %a3 %sp 44 #1290
	sw %a3 %a9 16 #1290
	sw %a4 %a9 12 #1290
	lw %a6 %sp 56 #1290
	sw %a6 %a9 8 #1290
	sw %a5 %a9 4 #1290
	addi %a2 %min_caml_hp 0 #1331
	addi %min_caml_hp %min_caml_hp 48 #1331
	li %a11 solve_one_or_network.2525 #1331
	sw %a11 %a2 0 #1331
	sw %a8 %a2 44 #1331
	sw %a1 %a2 40 #1331
	sw %a10 %a2 36 #1331
	sw %a0 %a2 32 #1331
	sw %a9 %a2 28 #1331
	sw %a7 %a2 24 #1331
	sw %a3 %a2 20 #1331
	sw %a4 %a2 16 #1331
	sw %a6 %a2 12 #1331
	sw %a5 %a2 8 #1331
	lw %a11 %sp 28 #1331
	sw %a11 %a2 4 #1331
	sw %a5 %sp 204 #1341
	addi %a5 %min_caml_hp 0 #1341
	addi %min_caml_hp %min_caml_hp 48 #1341
	li %a6 trace_or_matrix.2529 #1341
	sw %a6 %a5 0 #1341
	sw %a8 %a5 40 #1341
	sw %a1 %a5 36 #1341
	lw %a6 %sp 180 #1341
	sw %a6 %a5 32 #1341
	lw %a6 %sp 160 #1341
	sw %a6 %a5 28 #1341
	sw %a10 %a5 24 #1341
	sw %a0 %a5 20 #1341
	sw %a2 %a5 16 #1341
	sw %a9 %a5 12 #1341
	sw %a7 %a5 8 #1341
	sw %a11 %a5 4 #1341
	addi %a0 %min_caml_hp 0 #1381
	addi %min_caml_hp %min_caml_hp 48 #1381
	li %a2 solve_each_element_fast.2535 #1381
	sw %a2 %a0 0 #1381
	sw %a8 %a0 40 #1381
	lw %a2 %sp 92 #1381
	sw %a2 %a0 36 #1381
	lw %a6 %sp 184 #1381
	sw %a6 %a0 32 #1381
	lw %a9 %sp 156 #1381
	sw %a9 %a0 28 #1381
	sw %a10 %a0 24 #1381
	sw %a7 %a0 20 #1381
	sw %a3 %a0 16 #1381
	sw %a4 %a0 12 #1381
	lw %a1 %sp 56 #1381
	sw %a1 %a0 8 #1381
	sw %a5 %sp 208 #1381
	lw %a5 %sp 204 #1381
	sw %a5 %a0 4 #1381
	addi %a6 %min_caml_hp 0 #1422
	addi %min_caml_hp %min_caml_hp 48 #1422
	li %a11 solve_one_or_network_fast.2539 #1422
	sw %a11 %a6 0 #1422
	sw %a8 %a6 44 #1422
	sw %a2 %a6 40 #1422
	sw %a9 %a6 36 #1422
	sw %a10 %a6 32 #1422
	sw %a0 %a6 28 #1422
	sw %a7 %a6 24 #1422
	sw %a3 %a6 20 #1422
	sw %a4 %a6 16 #1422
	sw %a1 %a6 12 #1422
	sw %a5 %a6 8 #1422
	lw %a5 %sp 28 #1422
	sw %a5 %a6 4 #1422
	addi %a11 %min_caml_hp 0 #1432
	addi %min_caml_hp %min_caml_hp 40 #1432
	li %a2 trace_or_matrix_fast.2543 #1432
	sw %a2 %a11 0 #1432
	sw %a8 %a11 32 #1432
	lw %a2 %sp 184 #1432
	sw %a2 %a11 28 #1432
	sw %a9 %a11 24 #1432
	sw %a10 %a11 20 #1432
	sw %a6 %a11 16 #1432
	sw %a0 %a11 12 #1432
	sw %a7 %a11 8 #1432
	sw %a5 %a11 4 #1432
	addi %a0 %min_caml_hp 0 #1491
	addi %min_caml_hp %min_caml_hp 16 #1491
	li %a2 get_nvector_second.2553 #1491
	sw %a2 %a0 0 #1491
	lw %a2 %sp 60 #1491
	sw %a2 %a0 8 #1491
	sw %a4 %a0 4 #1491
	addi %a5 %min_caml_hp 0 #1527
	addi %min_caml_hp %min_caml_hp 8 #1527
	sw %a0 %sp 212 #1527
	li %a0 utexture.2558 #1527
	sw %a0 %a5 0 #1527
	lw %a0 %sp 64 #1527
	sw %a0 %a5 4 #1527
	addi %a7 %min_caml_hp 0 #1620
	addi %min_caml_hp %min_caml_hp 72 #1620
	sw %a5 %sp 216 #1620
	li %a5 trace_reflections.2565 #1620
	sw %a5 %a7 0 #1620
	sw %a11 %a7 68 #1620
	sw %a8 %a7 64 #1620
	sw %a0 %a7 60 #1620
	sw %a9 %a7 56 #1620
	lw %a5 %sp 200 #1620
	sw %a5 %a7 52 #1620
	sw %a10 %a7 48 #1620
	sw %a6 %a7 44 #1620
	sw %a6 %sp 220 #1620
	lw %a6 %sp 196 #1620
	sw %a6 %a7 40 #1620
	lw %a6 %sp 192 #1620
	sw %a6 %a7 36 #1620
	lw %a6 %sp 72 #1620
	sw %a6 %a7 32 #1620
	lw %a6 %sp 140 #1620
	sw %a6 %a7 28 #1620
	lw %a6 %sp 36 #1620
	sw %a6 %a7 24 #1620
	sw %a2 %a7 20 #1620
	lw %a2 %sp 132 #1620
	sw %a2 %a7 16 #1620
	sw %a3 %a7 12 #1620
	sw %a4 %a7 8 #1620
	sw %a1 %a7 4 #1620
	addi %a1 %min_caml_hp 0 #1647
	addi %min_caml_hp %min_caml_hp 120 #1647
	li %a4 trace_ray.2570 #1647
	sw %a4 %a1 0 #1647
	lw %a4 %sp 216 #1647
	sw %a4 %a1 116 #1647
	sw %a7 %a1 112 #1647
	sw %a11 %a1 108 #1647
	lw %a7 %sp 208 #1647
	sw %a7 %a1 104 #1647
	sw %a8 %a1 100 #1647
	sw %a0 %a1 96 #1647
	lw %a7 %sp 92 #1647
	sw %a7 %a1 92 #1647
	lw %a7 %sp 88 #1647
	sw %a7 %a1 88 #1647
	sw %a9 %a1 84 #1647
	sw %a5 %a1 80 #1647
	sw %a10 %a1 76 #1647
	lw %a7 %sp 220 #1647
	sw %a7 %a1 72 #1647
	lw %a7 %sp 196 #1647
	sw %a7 %a1 68 #1647
	lw %a9 %sp 192 #1647
	sw %a9 %a1 64 #1647
	lw %a9 %sp 176 #1647
	sw %a9 %a1 60 #1647
	lw %a9 %sp 72 #1647
	sw %a9 %a1 56 #1647
	lw %a9 %sp 140 #1647
	sw %a9 %a1 52 #1647
	sw %a6 %a1 48 #1647
	lw %a9 %sp 4 #1647
	sw %a9 %a1 44 #1647
	lw %a9 %sp 60 #1647
	sw %a9 %a1 40 #1647
	lw %a9 %sp 148 #1647
	sw %a9 %a1 36 #1647
	lw %a9 %sp 0 #1647
	sw %a9 %a1 32 #1647
	sw %a2 %a1 28 #1647
	lw %a9 %sp 16 #1647
	sw %a9 %a1 24 #1647
	sw %a3 %a1 20 #1647
	lw %a3 %sp 52 #1647
	sw %a3 %a1 16 #1647
	lw %a3 %sp 56 #1647
	sw %a3 %a1 12 #1647
	lw %a3 %sp 212 #1647
	sw %a3 %a1 8 #1647
	lw %a3 %sp 20 #1647
	sw %a3 %a1 4 #1647
	addi %a3 %min_caml_hp 0 #1737
	addi %min_caml_hp %min_caml_hp 80 #1737
	sw %a1 %sp 224 #1737
	li %a1 trace_diffuse_ray.2576 #1737
	sw %a1 %a3 0 #1737
	sw %a4 %a3 72 #1737
	sw %a11 %a3 68 #1737
	sw %a8 %a3 64 #1737
	sw %a0 %a3 60 #1737
	sw %a5 %a3 56 #1737
	sw %a10 %a3 52 #1737
	sw %a7 %a3 48 #1737
	lw %a1 %sp 192 #1737
	sw %a1 %a3 44 #1737
	sw %a6 %a3 40 #1737
	lw %a1 %sp 4 #1737
	sw %a1 %a3 36 #1737
	lw %a5 %sp 60 #1737
	sw %a5 %a3 32 #1737
	sw %a2 %a3 28 #1737
	sw %a9 %a3 24 #1737
	lw %a2 %sp 44 #1737
	sw %a2 %a3 20 #1737
	lw %a2 %sp 52 #1737
	sw %a2 %a3 16 #1737
	lw %a2 %sp 56 #1737
	sw %a2 %a3 12 #1737
	lw %a2 %sp 212 #1737
	sw %a2 %a3 8 #1737
	lw %a2 %sp 68 #1737
	sw %a2 %a3 4 #1737
	addi %a2 %min_caml_hp 0 #1755
	addi %min_caml_hp %min_caml_hp 80 #1755
	li %a9 iter_trace_diffuse_rays.2579 #1755
	sw %a9 %a2 0 #1755
	sw %a4 %a2 72 #1755
	sw %a11 %a2 68 #1755
	sw %a3 %a2 64 #1755
	sw %a8 %a2 60 #1755
	sw %a0 %a2 56 #1755
	lw %a0 %sp 156 #1755
	sw %a0 %a2 52 #1755
	sw %a10 %a2 48 #1755
	lw %a0 %sp 220 #1755
	sw %a0 %a2 44 #1755
	sw %a7 %a2 40 #1755
	sw %a6 %a2 36 #1755
	sw %a1 %a2 32 #1755
	sw %a5 %a2 28 #1755
	lw %a0 %sp 16 #1755
	sw %a0 %a2 24 #1755
	lw %a4 %sp 44 #1755
	sw %a4 %a2 20 #1755
	lw %a4 %sp 52 #1755
	sw %a4 %a2 16 #1755
	lw %a4 %sp 56 #1755
	sw %a4 %a2 12 #1755
	lw %a4 %sp 212 #1755
	sw %a4 %a2 8 #1755
	lw %a4 %sp 68 #1755
	sw %a4 %a2 4 #1755
	addi %a5 %min_caml_hp 0 #1803
	addi %min_caml_hp %min_caml_hp 40 #1803
	li %a6 calc_diffuse_using_1point.2592 #1803
	sw %a6 %a5 0 #1803
	sw %a3 %a5 32 #1803
	lw %a6 %sp 92 #1803
	sw %a6 %a5 28 #1803
	lw %a7 %sp 176 #1803
	sw %a7 %a5 24 #1803
	lw %a8 %sp 72 #1803
	sw %a8 %a5 20 #1803
	lw %a9 %sp 0 #1803
	sw %a9 %a5 16 #1803
	sw %a2 %a5 12 #1803
	lw %a10 %sp 116 #1803
	sw %a10 %a5 8 #1803
	sw %a4 %a5 4 #1803
	addi %a11 %min_caml_hp 0 #1821
	addi %min_caml_hp %min_caml_hp 16 #1821
	li %a0 calc_diffuse_using_5points.2595 #1821
	sw %a0 %a11 0 #1821
	sw %a8 %a11 8 #1821
	sw %a4 %a11 4 #1821
	addi %a0 %min_caml_hp 0 #1841
	addi %min_caml_hp %min_caml_hp 32 #1841
	li %a1 do_without_neighbors.2601 #1841
	sw %a1 %a0 0 #1841
	lw %a1 %sp 172 #1841
	sw %a1 %a0 24 #1841
	sw %a8 %a0 20 #1841
	sw %a2 %a0 16 #1841
	sw %a10 %a0 12 #1841
	sw %a4 %a0 8 #1841
	sw %a5 %a0 4 #1841
	addi %a9 %min_caml_hp 0 #1890
	addi %min_caml_hp %min_caml_hp 40 #1890
	li %a7 try_exploit_neighbors.2617 #1890
	sw %a7 %a9 0 #1890
	sw %a1 %a9 32 #1890
	sw %a8 %a9 28 #1890
	sw %a2 %a9 24 #1890
	sw %a0 %a9 20 #1890
	sw %a10 %a9 16 #1890
	sw %a4 %a9 12 #1890
	sw %a11 %a9 8 #1890
	sw %a5 %a9 4 #1890
	addi %a7 %min_caml_hp 0 #1949
	addi %min_caml_hp %min_caml_hp 40 #1949
	sw %a5 %sp 228 #1949
	li %a5 pretrace_diffuse_rays.2630 #1949
	sw %a5 %a7 0 #1949
	sw %a3 %a7 32 #1949
	sw %a6 %a7 28 #1949
	lw %a5 %sp 176 #1949
	sw %a5 %a7 24 #1949
	sw %a1 %a7 20 #1949
	sw %a11 %sp 232 #1949
	lw %a11 %sp 0 #1949
	sw %a11 %a7 16 #1949
	sw %a2 %a7 12 #1949
	sw %a10 %a7 8 #1949
	sw %a4 %a7 4 #1949
	sw %a0 %sp 236 #1978
	addi %a0 %min_caml_hp 0 #1978
	addi %min_caml_hp %min_caml_hp 72 #1978
	li %a1 pretrace_pixels.2633 #1978
	sw %a1 %a0 0 #1978
	lw %a1 %sp 12 #1978
	sw %a1 %a0 64 #1978
	sw %a9 %sp 240 #1978
	lw %a9 %sp 224 #1978
	sw %a9 %a0 60 #1978
	sw %a3 %a0 56 #1978
	sw %a6 %a0 52 #1978
	lw %a3 %sp 88 #1978
	sw %a3 %a0 48 #1978
	sw %a5 %a0 44 #1978
	lw %a5 %sp 96 #1978
	sw %a5 %a0 40 #1978
	lw %a6 %sp 84 #1978
	sw %a6 %a0 36 #1978
	sw %a8 %a0 32 #1978
	lw %a8 %sp 108 #1978
	sw %a8 %a0 28 #1978
	sw %a7 %a0 24 #1978
	sw %a11 %a0 20 #1978
	sw %a2 %a0 16 #1978
	lw %a11 %sp 80 #1978
	sw %a11 %a0 12 #1978
	sw %a10 %a0 8 #1978
	sw %a4 %a0 4 #1978
	addi %a4 %min_caml_hp 0 #2003
	addi %min_caml_hp %min_caml_hp 56 #2003
	li %a10 pretrace_line.2640 #2003
	sw %a10 %a4 0 #2003
	sw %a1 %a4 52 #2003
	sw %a9 %a4 48 #2003
	sw %a3 %a4 44 #2003
	lw %a1 %sp 104 #2003
	sw %a1 %a4 40 #2003
	lw %a3 %sp 100 #2003
	sw %a3 %a4 36 #2003
	sw %a5 %a4 32 #2003
	sw %a6 %a4 28 #2003
	lw %a5 %sp 72 #2003
	sw %a5 %a4 24 #2003
	sw %a8 %a4 20 #2003
	sw %a0 %a4 16 #2003
	sw %a7 %a4 12 #2003
	lw %a7 %sp 76 #2003
	sw %a7 %a4 8 #2003
	sw %a11 %a4 4 #2003
	addi %a8 %min_caml_hp 0 #2017
	addi %min_caml_hp %min_caml_hp 48 #2017
	li %a9 scan_pixel.2644 #2017
	sw %a9 %a8 0 #2017
	lw %a9 %sp 240 #2017
	sw %a9 %a8 40 #2017
	lw %a10 %sp 172 #2017
	sw %a10 %a8 36 #2017
	sw %a5 %a8 32 #2017
	sw %a2 %a8 28 #2017
	sw %a7 %a8 24 #2017
	lw %a11 %sp 236 #2017
	sw %a11 %a8 20 #2017
	lw %a11 %sp 116 #2017
	sw %a11 %a8 16 #2017
	lw %a11 %sp 68 #2017
	sw %a11 %a8 12 #2017
	lw %a11 %sp 232 #2017
	sw %a11 %a8 8 #2017
	lw %a11 %sp 228 #2017
	sw %a11 %a8 4 #2017
	addi %a11 %min_caml_hp 0 #2037
	addi %min_caml_hp %min_caml_hp 72 #2037
	li %a7 scan_line.2650 #2037
	sw %a7 %a11 0 #2037
	sw %a9 %a11 64 #2037
	sw %a10 %a11 60 #2037
	sw %a1 %a11 56 #2037
	sw %a3 %a11 52 #2037
	sw %a8 %a11 48 #2037
	sw %a6 %a11 44 #2037
	sw %a5 %a11 40 #2037
	sw %a0 %a11 36 #2037
	sw %a4 %a11 32 #2037
	sw %a2 %a11 28 #2037
	lw %a0 %sp 76 #2037
	sw %a0 %a11 24 #2037
	lw %a1 %sp 80 #2037
	sw %a1 %a11 20 #2037
	lw %a2 %sp 236 #2037
	sw %a2 %a11 16 #2037
	lw %a2 %sp 116 #2037
	sw %a2 %a11 12 #2037
	lw %a3 %sp 68 #2037
	sw %a3 %a11 8 #2037
	lw %a3 %sp 228 #2037
	sw %a3 %a11 4 #2037
	addi %a3 %min_caml_hp 0 #2110
	addi %min_caml_hp %min_caml_hp 8 #2110
	li %a5 calc_dirvec.2670 #2110
	sw %a5 %a3 0 #2110
	sw %a2 %a3 4 #2110
	addi %a5 %min_caml_hp 0 #2131
	addi %min_caml_hp %min_caml_hp 8 #2131
	li %a7 calc_dirvecs.2678 #2131
	sw %a7 %a5 0 #2131
	sw %a3 %a5 4 #2131
	addi %a7 %min_caml_hp 0 #2145
	addi %min_caml_hp %min_caml_hp 16 #2145
	li %a8 calc_dirvec_rows.2683 #2145
	sw %a8 %a7 0 #2145
	sw %a5 %a7 8 #2145
	sw %a3 %a7 4 #2145
	addi %a3 %min_caml_hp 0 #2162
	addi %min_caml_hp %min_caml_hp 8 #2162
	li %a8 create_dirvec_elements.2689 #2162
	sw %a8 %a3 0 #2162
	lw %a8 %sp 0 #2162
	sw %a8 %a3 4 #2162
	addi %a9 %min_caml_hp 0 #2169
	addi %min_caml_hp %min_caml_hp 16 #2169
	li %a10 create_dirvecs.2692 #2169
	sw %a10 %a9 0 #2169
	sw %a8 %a9 12 #2169
	sw %a2 %a9 8 #2169
	sw %a3 %a9 4 #2169
	addi %a10 %min_caml_hp 0 #2179
	addi %min_caml_hp %min_caml_hp 24 #2179
	sw %a11 %sp 244 #2179
	li %a11 init_dirvec_constants.2694 #2179
	sw %a11 %a10 0 #2179
	lw %a11 %sp 168 #2179
	sw %a11 %a10 16 #2179
	sw %a4 %sp 248 #2179
	lw %a4 %sp 4 #2179
	sw %a4 %a10 12 #2179
	sw %a8 %a10 8 #2179
	sw %a7 %sp 252 #2179
	lw %a7 %sp 164 #2179
	sw %a7 %a10 4 #2179
	sw %a5 %sp 256 #2186
	addi %a5 %min_caml_hp 0 #2186
	addi %min_caml_hp %min_caml_hp 32 #2186
	sw %a9 %sp 260 #2186
	li %a9 init_vecset_constants.2697 #2186
	sw %a9 %a5 0 #2186
	sw %a11 %a5 24 #2186
	sw %a4 %a5 20 #2186
	sw %a8 %a5 16 #2186
	sw %a7 %a5 12 #2186
	sw %a10 %a5 8 #2186
	sw %a2 %a5 4 #2186
	addi %a9 %min_caml_hp 0 #2240
	addi %min_caml_hp %min_caml_hp 32 #2240
	li %a11 setup_reflections.2714 #2240
	sw %a11 %a9 0 #2240
	lw %a11 %sp 140 #2240
	sw %a11 %a9 24 #2240
	sw %a4 %a9 20 #2240
	lw %a11 %sp 148 #2240
	sw %a11 %a9 16 #2240
	sw %a8 %a9 12 #2240
	lw %a11 %sp 16 #2240
	sw %a11 %a9 8 #2240
	sw %a7 %a9 4 #2240
	sw %a9 %sp 264 #2281
	addi %a9 %zero 128 #2281
	addi %a7 %zero 128 #2281
	sw %a9 %a0 0 #2262
	sw %a7 %a0 4 #2263
	addi %a4 %zero 2 #2264
	sw %a5 %sp 268 #2264
	sw %a10 %sp 272 #2264
	sw %a3 %sp 276 #2264
	sw %a9 %sp 280 #2264
	sw %a7 %sp 284 #2264
	add %a1 %a4 %zero
	add %a0 %a9 %zero
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
	li %f0 l.93674 #2266
	lw %a0 %sp 280 #2266
	sw %f0 %sp 288 #2266
	sw %ra %sp 300 #2266 call dir
	addi %sp %sp 304 #2266	
	jal %ra min_caml_float_of_int #2266
	addi %sp %sp -304 #2266
	lw %ra %sp 300 #2266
	lw %f1 %sp 288 #2266
	fdiv %f0 %f1 %f0 #2266
	lw %a0 %sp 84 #2266
	sw %f0 %a0 0 #2266
	lw %a0 %sp 76 #57
	lw %a1 %a0 0 #57
	addi %a2 %zero 3 #2066
	li %f0 l.90390 #2066
	sw %a1 %sp 296 #2066
	add %a0 %a2 %zero
	sw %ra %sp 300 #2066 call dir
	addi %sp %sp 304 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -304 #2066
	lw %ra %sp 300 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 300 #2054
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
	li %f0 l.90390 #2056
	sw %a0 %sp 304 #2056
	add %a0 %a1 %zero
	sw %ra %sp 308 #2056 call dir
	addi %sp %sp 312 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -312 #2056
	lw %ra %sp 308 #2056
	lw %a1 %sp 304 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 308 #2057 call dir
	addi %sp %sp 312 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -312 #2057
	lw %ra %sp 308 #2057
	lw %a1 %sp 304 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 308 #2058 call dir
	addi %sp %sp 312 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -312 #2058
	lw %ra %sp 308 #2058
	lw %a1 %sp 304 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 308 #2059 call dir
	addi %sp %sp 312 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -312 #2059
	lw %ra %sp 308 #2059
	lw %a1 %sp 304 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 308 #2068 call dir
	addi %sp %sp 312 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -312 #2068
	lw %ra %sp 308 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 308 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 316 #2069 call dir
	addi %sp %sp 320 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -320 #2069
	lw %ra %sp 316 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 312 #2054
	add %a0 %a1 %zero
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
	li %f0 l.90390 #2056
	sw %a0 %sp 316 #2056
	add %a0 %a1 %zero
	sw %ra %sp 324 #2056 call dir
	addi %sp %sp 328 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -328 #2056
	lw %ra %sp 324 #2056
	lw %a1 %sp 316 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 324 #2057 call dir
	addi %sp %sp 328 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -328 #2057
	lw %ra %sp 324 #2057
	lw %a1 %sp 316 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 324 #2058 call dir
	addi %sp %sp 328 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -328 #2058
	lw %ra %sp 324 #2058
	lw %a1 %sp 316 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 324 #2059 call dir
	addi %sp %sp 328 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -328 #2059
	lw %ra %sp 324 #2059
	lw %a1 %sp 316 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 324 #2057 call dir
	addi %sp %sp 328 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -328 #2057
	lw %ra %sp 324 #2057
	lw %a1 %sp 320 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 324 #2058 call dir
	addi %sp %sp 328 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -328 #2058
	lw %ra %sp 324 #2058
	lw %a1 %sp 320 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 324 #2059 call dir
	addi %sp %sp 328 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -328 #2059
	lw %ra %sp 324 #2059
	lw %a1 %sp 320 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 324 #2072 call dir
	addi %sp %sp 328 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -328 #2072
	lw %ra %sp 324 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 324 #2054
	add %a0 %a1 %zero
	sw %ra %sp 332 #2054 call dir
	addi %sp %sp 336 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -336 #2054
	lw %ra %sp 332 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 332 #2055 call dir
	addi %sp %sp 336 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -336 #2055
	lw %ra %sp 332 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.90390 #2056
	sw %a0 %sp 328 #2056
	add %a0 %a1 %zero
	sw %ra %sp 332 #2056 call dir
	addi %sp %sp 336 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -336 #2056
	lw %ra %sp 332 #2056
	lw %a1 %sp 328 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 332 #2057 call dir
	addi %sp %sp 336 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -336 #2057
	lw %ra %sp 332 #2057
	lw %a1 %sp 328 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 332 #2058 call dir
	addi %sp %sp 336 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -336 #2058
	lw %ra %sp 332 #2058
	lw %a1 %sp 328 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 332 #2059 call dir
	addi %sp %sp 336 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -336 #2059
	lw %ra %sp 332 #2059
	lw %a1 %sp 328 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 324 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 320 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 316 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 312 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 308 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 304 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 300 #2074
	sw %a1 %a0 0 #2074
	addi %a1 %a0 0 #2074
	lw %a0 %sp 296 #2088
	sw %ra %sp 332 #2088 call dir
	addi %sp %sp 336 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -336 #2088
	lw %ra %sp 332 #2088
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.101073 # nontail if
	sw %a0 %sp 332 #2080
	sw %a2 %sp 336 #2080
	sw %ra %sp 340 #2080 call dir
	addi %sp %sp 344 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -344 #2080
	lw %ra %sp 340 #2080
	lw %a1 %sp 336 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 332 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 340 #2081 call dir
	addi %sp %sp 344 #2081	
	jal %ra init_line_elements.2660 #2081
	addi %sp %sp -344 #2081
	lw %ra %sp 340 #2081
	jal %zero bge_cont.101074 # then sentence ends
bge_else.101073:
bge_cont.101074:
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a3 %zero 3 #2066
	li %f0 l.90390 #2066
	sw %a0 %sp 340 #2066
	sw %a2 %sp 344 #2066
	add %a0 %a3 %zero
	sw %ra %sp 348 #2066 call dir
	addi %sp %sp 352 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -352 #2066
	lw %ra %sp 348 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 348 #2054
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
	li %f0 l.90390 #2056
	sw %a0 %sp 352 #2056
	add %a0 %a1 %zero
	sw %ra %sp 356 #2056 call dir
	addi %sp %sp 360 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -360 #2056
	lw %ra %sp 356 #2056
	lw %a1 %sp 352 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 356 #2057 call dir
	addi %sp %sp 360 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -360 #2057
	lw %ra %sp 356 #2057
	lw %a1 %sp 352 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 356 #2058 call dir
	addi %sp %sp 360 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -360 #2058
	lw %ra %sp 356 #2058
	lw %a1 %sp 352 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 356 #2059 call dir
	addi %sp %sp 360 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -360 #2059
	lw %ra %sp 356 #2059
	lw %a1 %sp 352 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 356 #2068 call dir
	addi %sp %sp 360 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -360 #2068
	lw %ra %sp 356 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 356 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 364 #2069 call dir
	addi %sp %sp 368 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -368 #2069
	lw %ra %sp 364 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 360 #2054
	add %a0 %a1 %zero
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
	li %f0 l.90390 #2056
	sw %a0 %sp 364 #2056
	add %a0 %a1 %zero
	sw %ra %sp 372 #2056 call dir
	addi %sp %sp 376 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -376 #2056
	lw %ra %sp 372 #2056
	lw %a1 %sp 364 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 372 #2057 call dir
	addi %sp %sp 376 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -376 #2057
	lw %ra %sp 372 #2057
	lw %a1 %sp 364 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 372 #2058 call dir
	addi %sp %sp 376 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -376 #2058
	lw %ra %sp 372 #2058
	lw %a1 %sp 364 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 372 #2059 call dir
	addi %sp %sp 376 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -376 #2059
	lw %ra %sp 372 #2059
	lw %a1 %sp 364 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 372 #2057 call dir
	addi %sp %sp 376 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -376 #2057
	lw %ra %sp 372 #2057
	lw %a1 %sp 368 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 372 #2058 call dir
	addi %sp %sp 376 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -376 #2058
	lw %ra %sp 372 #2058
	lw %a1 %sp 368 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 372 #2059 call dir
	addi %sp %sp 376 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -376 #2059
	lw %ra %sp 372 #2059
	lw %a1 %sp 368 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 372 #2072 call dir
	addi %sp %sp 376 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -376 #2072
	lw %ra %sp 372 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 372 #2054
	add %a0 %a1 %zero
	sw %ra %sp 380 #2054 call dir
	addi %sp %sp 384 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -384 #2054
	lw %ra %sp 380 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 380 #2055 call dir
	addi %sp %sp 384 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -384 #2055
	lw %ra %sp 380 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.90390 #2056
	sw %a0 %sp 376 #2056
	add %a0 %a1 %zero
	sw %ra %sp 380 #2056 call dir
	addi %sp %sp 384 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -384 #2056
	lw %ra %sp 380 #2056
	lw %a1 %sp 376 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 380 #2057 call dir
	addi %sp %sp 384 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -384 #2057
	lw %ra %sp 380 #2057
	lw %a1 %sp 376 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 380 #2058 call dir
	addi %sp %sp 384 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -384 #2058
	lw %ra %sp 380 #2058
	lw %a1 %sp 376 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 380 #2059 call dir
	addi %sp %sp 384 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -384 #2059
	lw %ra %sp 380 #2059
	lw %a1 %sp 376 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 372 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 368 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 364 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 360 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 356 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 352 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 348 #2074
	sw %a1 %a0 0 #2074
	addi %a1 %a0 0 #2074
	lw %a0 %sp 344 #2088
	sw %ra %sp 380 #2088 call dir
	addi %sp %sp 384 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -384 #2088
	lw %ra %sp 380 #2088
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.101075 # nontail if
	sw %a0 %sp 380 #2080
	sw %a2 %sp 384 #2080
	sw %ra %sp 388 #2080 call dir
	addi %sp %sp 392 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -392 #2080
	lw %ra %sp 388 #2080
	lw %a1 %sp 384 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 380 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 388 #2081 call dir
	addi %sp %sp 392 #2081	
	jal %ra init_line_elements.2660 #2081
	addi %sp %sp -392 #2081
	lw %ra %sp 388 #2081
	jal %zero bge_cont.101076 # then sentence ends
bge_else.101075:
bge_cont.101076:
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a3 %zero 3 #2066
	li %f0 l.90390 #2066
	sw %a0 %sp 388 #2066
	sw %a2 %sp 392 #2066
	add %a0 %a3 %zero
	sw %ra %sp 396 #2066 call dir
	addi %sp %sp 400 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -400 #2066
	lw %ra %sp 396 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 396 #2054
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
	li %f0 l.90390 #2056
	sw %a0 %sp 400 #2056
	add %a0 %a1 %zero
	sw %ra %sp 404 #2056 call dir
	addi %sp %sp 408 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -408 #2056
	lw %ra %sp 404 #2056
	lw %a1 %sp 400 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 404 #2057 call dir
	addi %sp %sp 408 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -408 #2057
	lw %ra %sp 404 #2057
	lw %a1 %sp 400 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 404 #2058 call dir
	addi %sp %sp 408 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -408 #2058
	lw %ra %sp 404 #2058
	lw %a1 %sp 400 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 404 #2059 call dir
	addi %sp %sp 408 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -408 #2059
	lw %ra %sp 404 #2059
	lw %a1 %sp 400 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 404 #2068 call dir
	addi %sp %sp 408 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -408 #2068
	lw %ra %sp 404 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 404 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 412 #2069 call dir
	addi %sp %sp 416 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -416 #2069
	lw %ra %sp 412 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 408 #2054
	add %a0 %a1 %zero
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
	li %f0 l.90390 #2056
	sw %a0 %sp 412 #2056
	add %a0 %a1 %zero
	sw %ra %sp 420 #2056 call dir
	addi %sp %sp 424 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -424 #2056
	lw %ra %sp 420 #2056
	lw %a1 %sp 412 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 420 #2057 call dir
	addi %sp %sp 424 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -424 #2057
	lw %ra %sp 420 #2057
	lw %a1 %sp 412 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 420 #2058 call dir
	addi %sp %sp 424 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -424 #2058
	lw %ra %sp 420 #2058
	lw %a1 %sp 412 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 420 #2059 call dir
	addi %sp %sp 424 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -424 #2059
	lw %ra %sp 420 #2059
	lw %a1 %sp 412 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.90390 #2054
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
	li %f0 l.90390 #2056
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
	li %f0 l.90390 #2057
	sw %ra %sp 420 #2057 call dir
	addi %sp %sp 424 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -424 #2057
	lw %ra %sp 420 #2057
	lw %a1 %sp 416 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 420 #2058 call dir
	addi %sp %sp 424 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -424 #2058
	lw %ra %sp 420 #2058
	lw %a1 %sp 416 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 420 #2059 call dir
	addi %sp %sp 424 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -424 #2059
	lw %ra %sp 420 #2059
	lw %a1 %sp 416 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 420 #2072 call dir
	addi %sp %sp 424 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -424 #2072
	lw %ra %sp 420 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.90390 #2054
	sw %a0 %sp 420 #2054
	add %a0 %a1 %zero
	sw %ra %sp 428 #2054 call dir
	addi %sp %sp 432 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -432 #2054
	lw %ra %sp 428 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 428 #2055 call dir
	addi %sp %sp 432 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -432 #2055
	lw %ra %sp 428 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.90390 #2056
	sw %a0 %sp 424 #2056
	add %a0 %a1 %zero
	sw %ra %sp 428 #2056 call dir
	addi %sp %sp 432 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -432 #2056
	lw %ra %sp 428 #2056
	lw %a1 %sp 424 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.90390 #2057
	sw %ra %sp 428 #2057 call dir
	addi %sp %sp 432 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -432 #2057
	lw %ra %sp 428 #2057
	lw %a1 %sp 424 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.90390 #2058
	sw %ra %sp 428 #2058 call dir
	addi %sp %sp 432 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -432 #2058
	lw %ra %sp 428 #2058
	lw %a1 %sp 424 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.90390 #2059
	sw %ra %sp 428 #2059 call dir
	addi %sp %sp 432 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -432 #2059
	lw %ra %sp 428 #2059
	lw %a1 %sp 424 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 420 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 416 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 412 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 408 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 404 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 400 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 396 #2074
	sw %a1 %a0 0 #2074
	addi %a1 %a0 0 #2074
	lw %a0 %sp 392 #2088
	sw %ra %sp 428 #2088 call dir
	addi %sp %sp 432 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -432 #2088
	lw %ra %sp 428 #2088
	lw %a1 %sp 76 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.101077 # nontail if
	sw %a0 %sp 428 #2080
	sw %a2 %sp 432 #2080
	sw %ra %sp 436 #2080 call dir
	addi %sp %sp 440 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -440 #2080
	lw %ra %sp 436 #2080
	lw %a1 %sp 432 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 428 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 436 #2081 call dir
	addi %sp %sp 440 #2081	
	jal %ra init_line_elements.2660 #2081
	addi %sp %sp -440 #2081
	lw %ra %sp 436 #2081
	jal %zero bge_cont.101078 # then sentence ends
bge_else.101077:
bge_cont.101078:
	lw %a11 %sp 144 #2270
	sw %a0 %sp 436 #2270
	sw %ra %sp 444 #2270 call cls
	lw %a10 %a11 0 #2270
	addi %sp %sp 448 #2270	
	jalr %ra %a10 0 #2270
	addi %sp %sp -448 #2270
	lw %ra %sp 444 #2270
	addi %a0 %zero 80 #1917
	sw %ra %sp 444 #1917 call dir
	addi %sp %sp 448 #1917	
	jal %ra min_caml_print_char #1917
	addi %sp %sp -448 #1917
	lw %ra %sp 444 #1917
	addi %a0 %zero 51 #1918
	sw %ra %sp 444 #1918 call dir
	addi %sp %sp 448 #1918	
	jal %ra min_caml_print_char #1918
	addi %sp %sp -448 #1918
	lw %ra %sp 444 #1918
	addi %a0 %zero 10 #1919
	sw %ra %sp 444 #1919 call dir
	addi %sp %sp 448 #1919	
	jal %ra min_caml_print_char #1919
	addi %sp %sp -448 #1919
	lw %ra %sp 444 #1919
	lw %a0 %sp 76 #57
	lw %a1 %a0 0 #57
	add %a0 %a1 %zero
	sw %ra %sp 444 #1920 call dir
	addi %sp %sp 448 #1920	
	jal %ra min_caml_print_int #1920
	addi %sp %sp -448 #1920
	lw %ra %sp 444 #1920
	addi %a0 %zero 32 #1921
	sw %ra %sp 444 #1921 call dir
	addi %sp %sp 448 #1921	
	jal %ra min_caml_print_char #1921
	addi %sp %sp -448 #1921
	lw %ra %sp 444 #1921
	lw %a0 %sp 76 #57
	lw %a0 %a0 4 #57
	sw %ra %sp 444 #1922 call dir
	addi %sp %sp 448 #1922	
	jal %ra min_caml_print_int #1922
	addi %sp %sp -448 #1922
	lw %ra %sp 444 #1922
	addi %a0 %zero 32 #1923
	sw %ra %sp 444 #1923 call dir
	addi %sp %sp 448 #1923	
	jal %ra min_caml_print_char #1923
	addi %sp %sp -448 #1923
	lw %ra %sp 444 #1923
	addi %a0 %zero 255 #1924
	sw %ra %sp 444 #1924 call dir
	addi %sp %sp 448 #1924	
	jal %ra min_caml_print_int #1924
	addi %sp %sp -448 #1924
	lw %ra %sp 444 #1924
	addi %a0 %zero 10 #1925
	sw %ra %sp 444 #1925 call dir
	addi %sp %sp 448 #1925	
	jal %ra min_caml_print_char #1925
	addi %sp %sp -448 #1925
	lw %ra %sp 444 #1925
	addi %a0 %zero 120 #2171
	addi %a1 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 440 #2157
	add %a0 %a1 %zero
	sw %ra %sp 444 #2157 call dir
	addi %sp %sp 448 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -448 #2157
	lw %ra %sp 444 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 0 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 444 #2158
	add %a0 %a2 %zero
	sw %ra %sp 452 #2158 call dir
	addi %sp %sp 456 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -456 #2158
	lw %ra %sp 452 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 444 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 440 #2171
	sw %ra %sp 452 #2171 call dir
	addi %sp %sp 456 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -456 #2171
	lw %ra %sp 452 #2171
	lw %a1 %sp 116 #2171
	sw %a0 %a1 16 #2171
	lw %a0 %a1 16 #81
	addi %a2 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %a0 %sp 448 #2157
	add %a0 %a2 %zero
	sw %ra %sp 452 #2157 call dir
	addi %sp %sp 456 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -456 #2157
	lw %ra %sp 452 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 0 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 452 #2158
	add %a0 %a2 %zero
	sw %ra %sp 460 #2158 call dir
	addi %sp %sp 464 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -464 #2158
	lw %ra %sp 460 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 452 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 448 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 460 #2157 call dir
	addi %sp %sp 464 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -464 #2157
	lw %ra %sp 460 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 0 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 456 #2158
	add %a0 %a2 %zero
	sw %ra %sp 460 #2158 call dir
	addi %sp %sp 464 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -464 #2158
	lw %ra %sp 460 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 456 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 448 #2164
	sw %a0 %a1 468 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 460 #2157 call dir
	addi %sp %sp 464 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -464 #2157
	lw %ra %sp 460 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 0 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 460 #2158
	add %a0 %a2 %zero
	sw %ra %sp 468 #2158 call dir
	addi %sp %sp 472 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -472 #2158
	lw %ra %sp 468 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 460 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 448 #2164
	sw %a0 %a1 464 #2164
	addi %a0 %zero 3 #2157
	li %f0 l.90390 #2157
	sw %ra %sp 468 #2157 call dir
	addi %sp %sp 472 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -472 #2157
	lw %ra %sp 468 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 0 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 464 #2158
	add %a0 %a2 %zero
	sw %ra %sp 468 #2158 call dir
	addi %sp %sp 472 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -472 #2158
	lw %ra %sp 468 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 464 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 448 #2164
	sw %a0 %a1 460 #2164
	addi %a0 %zero 114 #2165
	lw %a11 %sp 276 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 468 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 472 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -472 #2165
	lw %ra %sp 468 #2165
	addi %a0 %zero 3 #2173
	lw %a11 %sp 260 #2173
	sw %ra %sp 468 #2173 call cls
	lw %a10 %a11 0 #2173
	addi %sp %sp 472 #2173	
	jalr %ra %a10 0 #2173
	addi %sp %sp -472 #2173
	lw %ra %sp 468 #2173
	addi %a0 %zero 9 #2195
	addi %a1 %zero 0 #2195
	addi %a2 %zero 0 #2195
	sw %a2 %sp 468 #2147
	sw %a1 %sp 472 #2147
	sw %ra %sp 476 #2147 call dir
	addi %sp %sp 480 #2147	
	jal %ra min_caml_float_of_int #2147
	addi %sp %sp -480 #2147
	lw %ra %sp 476 #2147
	li %f1 l.93232 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.93234 #2147
	fsub %f0 %f0 %f1 #2147
	addi %a0 %zero 4 #2148
	lw %a1 %sp 472 #2148
	lw %a2 %sp 468 #2148
	lw %a11 %sp 256 #2148
	sw %ra %sp 476 #2148 call cls
	lw %a10 %a11 0 #2148
	addi %sp %sp 480 #2148	
	jalr %ra %a10 0 #2148
	addi %sp %sp -480 #2148
	lw %ra %sp 476 #2148
	addi %a0 %zero 8 #2149
	addi %a1 %zero 2 #124
	addi %a2 %zero 4 #2149
	lw %a11 %sp 252 #2149
	sw %ra %sp 476 #2149 call cls
	lw %a10 %a11 0 #2149
	addi %sp %sp 480 #2149	
	jalr %ra %a10 0 #2149
	addi %sp %sp -480 #2149
	lw %ra %sp 476 #2149
	lw %a0 %sp 116 #81
	lw %a0 %a0 16 #81
	addi %a1 %zero 119 #2188
	lw %a11 %sp 272 #2188
	sw %ra %sp 476 #2188 call cls
	lw %a10 %a11 0 #2188
	addi %sp %sp 480 #2188	
	jalr %ra %a10 0 #2188
	addi %sp %sp -480 #2188
	lw %ra %sp 476 #2188
	addi %a0 %zero 3 #2189
	lw %a11 %sp 268 #2189
	sw %ra %sp 476 #2189 call cls
	lw %a10 %a11 0 #2189
	addi %sp %sp 480 #2189	
	jalr %ra %a10 0 #2189
	addi %sp %sp -480 #2189
	lw %ra %sp 476 #2189
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
	blt %a2 %a12 bge_else.101079 # nontail if
	slli %a3 %a2 2 #20
	lw %a4 %sp 4 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %a3 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.101081 # nontail if
	sw %a2 %sp 476 #1110
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 484 #1110 call dir
	addi %sp %sp 488 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -488 #1110
	lw %ra %sp 484 #1110
	lw %a1 %sp 476 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 128 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.101082 # then sentence ends
beq_else.101081:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.101083 # nontail if
	addi %a4 %zero 4 #1057
	li %f0 l.90390 #1057
	sw %a2 %sp 476 #1057
	sw %a3 %sp 480 #1057
	add %a0 %a4 %zero
	sw %ra %sp 484 #1057 call dir
	addi %sp %sp 488 #1057	
	jal %ra min_caml_create_float_array #1057
	addi %sp %sp -488 #1057
	lw %ra %sp 484 #1057
	lw %a1 %sp 124 #1059
	lw %f0 %a1 0 #1059
	lw %a2 %sp 480 #276
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
	sw %f0 %sp 488 #1061
	sw %a0 %sp 496 #1061
	sw %ra %sp 500 #1061 call dir
	addi %sp %sp 504 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -504 #1061
	lw %ra %sp 500 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.101086 # nontail if
	li %f0 l.90390 #1069
	lw %a0 %sp 496 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.101087 # then sentence ends
beq_else.101086:
	li %f0 l.90466 #1063
	lw %f1 %sp 488 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 496 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 480 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 500 #1065 call dir
	addi %sp %sp 504 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -504 #1065
	lw %ra %sp 500 #1065
	lw %a0 %sp 496 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 480 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	lw %f1 %sp 488 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 500 #1066 call dir
	addi %sp %sp 504 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -504 #1066
	lw %ra %sp 500 #1066
	lw %a0 %sp 496 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 480 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	lw %f1 %sp 488 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 500 #1067 call dir
	addi %sp %sp 504 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -504 #1067
	lw %ra %sp 500 #1067
	lw %a0 %sp 496 #1067
	sw %f0 %a0 12 #1067
beq_cont.101087:
	lw %a1 %sp 476 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 128 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.101084 # then sentence ends
beq_else.101083:
	sw %a2 %sp 476 #1114
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 500 #1114 call dir
	addi %sp %sp 504 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -504 #1114
	lw %ra %sp 500 #1114
	lw %a1 %sp 476 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 128 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.101084:
beq_cont.101082:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 132 #1116
	lw %a11 %sp 164 #1116
	sw %ra %sp 500 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 504 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -504 #1116
	lw %ra %sp 500 #1116
	jal %zero bge_cont.101080 # then sentence ends
bge_else.101079:
bge_cont.101080:
	lw %a0 %sp 0 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #2275
	lw %a11 %sp 264 #2275
	sw %ra %sp 500 #2275 call cls
	lw %a10 %a11 0 #2275
	addi %sp %sp 504 #2275	
	jalr %ra %a10 0 #2275
	addi %sp %sp -504 #2275
	lw %ra %sp 500 #2275
	addi %a1 %zero 0 #2276
	addi %a2 %zero 0 #2276
	lw %a0 %sp 388 #2276
	lw %a11 %sp 248 #2276
	sw %ra %sp 500 #2276 call cls
	lw %a10 %a11 0 #2276
	addi %sp %sp 504 #2276	
	jalr %ra %a10 0 #2276
	addi %sp %sp -504 #2276
	lw %ra %sp 500 #2276
	addi %a0 %zero 0 #2277
	addi %a4 %zero 2 #2277
	lw %a1 %sp 340 #2277
	lw %a2 %sp 388 #2277
	lw %a3 %sp 436 #2277
	lw %a11 %sp 244 #2277
	sw %ra %sp 500 #2277 call cls
	lw %a10 %a11 0 #2277
	addi %sp %sp 504 #2277	
	jalr %ra %a10 0 #2277
	addi %sp %sp -504 #2277
	lw %ra %sp 500 #2277
	addi %a0 %zero 0 #2283
