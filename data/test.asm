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

l.30489:	# 128.000000
	1124073472
l.30232:	# 0.900000
	1063675494
l.30230:	# 0.200000
	1045220557
l.29193:	# 150.000000
	1125515264
l.29128:	# -150.000000
	-1021968384
l.29046:	# 0.100000
	1036831949
l.28923:	# -2.000000
	-1073741824
l.28908:	# 0.003906
	998244352
l.28755:	# 100000000.000000
	1287568416
l.28749:	# 1000000000.000000
	1315859240
l.28735:	# 20.000000
	1101004800
l.28733:	# 0.050000
	1028443341
l.28724:	# 0.250000
	1048576000
l.28715:	# 10.000000
	1092616192
l.28708:	# 0.300000
	1050253722
l.28706:	# 255.000000
	1132396544
l.28702:	# 0.500000
	1056964608
l.28700:	# 0.150000
	1041865114
l.28691:	# 3.141593
	1078530011
l.28689:	# 30.000000
	1106247680
l.28687:	# 15.000000
	1097859072
l.28685:	# 0.000100
	953267991
l.28314:	# -0.100000
	-1110651699
l.28266:	# 0.010000
	1008981770
l.28264:	# -0.200000
	-1102263091
l.27801:	# -1.000000
	-1082130432
l.27799:	# 1.000000
	1065353216
l.27753:	# 2.000000
	1073741824
l.27725:	# 0.000000
	0
l.27719:	# -200.000000
	-1018691584
l.27716:	# 200.000000
	1128792064
l.27713:	# 0.017453
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
	li %f1 l.27713 #541
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
	li %f1 l.27713 #541
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
	li %f3 l.27716 #559
	fmul %f2 %f2 %f3 #559
	lw %a0 %sp 12 #559
	sw %f2 %a0 0 #559
	li %f2 l.27719 #560
	lw %f3 %sp 40 #560
	fmul %f2 %f3 %f2 #560
	sw %f2 %a0 4 #560
	lw %f2 %sp 56 #561
	fmul %f4 %f1 %f2 #561
	li %f5 l.27716 #561
	fmul %f4 %f4 %f5 #561
	sw %f4 %a0 8 #561
	lw %a1 %sp 8 #563
	sw %f2 %a1 0 #563
	li %f4 l.27725 #564
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
	li %f0 l.27753 #634
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
	li %f0 l.27753 #635
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
	li %f0 l.27753 #636
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
	bne %a0 %a12 beq_else.35231
	addi %a0 %zero 0 #720
	jalr %zero %ra 0 #720
beq_else.35231:
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
	li %f0 l.27725 #650
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
	li %f0 l.27725 #655
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
	li %f0 l.27725 #662
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
	li %f0 l.27725 #666
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
	li %f0 l.27725 #671
	add %a0 %a1 %zero
	sw %ra %sp 44 #671 call dir
	addi %sp %sp 48 #671	
	jal %ra min_caml_create_float_array #671
	addi %sp %sp -48 #671
	lw %ra %sp 44 #671
	lw %a1 %sp 20 #644
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35232 # nontail if
	jal %zero beq_cont.35233 # then sentence ends
beq_else.35232:
	sw %a0 %sp 44 #674
	sw %ra %sp 52 #674 call dir
	addi %sp %sp 56 #674	
	jal %ra min_caml_read_float #674
	addi %sp %sp -56 #674
	lw %ra %sp 52 #674
	li %f1 l.27713 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #674
	sw %f0 %a0 0 #674
	sw %ra %sp 52 #675 call dir
	addi %sp %sp 56 #675	
	jal %ra min_caml_read_float #675
	addi %sp %sp -56 #675
	lw %ra %sp 52 #675
	li %f1 l.27713 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #675
	sw %f0 %a0 4 #675
	sw %ra %sp 52 #676 call dir
	addi %sp %sp 56 #676	
	jal %ra min_caml_read_float #676
	addi %sp %sp -56 #676
	lw %ra %sp 52 #676
	li %f1 l.27713 #541
	fmul %f0 %f0 %f1 #541
	lw %a0 %sp 44 #676
	sw %f0 %a0 8 #676
beq_cont.35233:
	lw %a1 %sp 12 #644
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.35234 # nontail if
	addi %a2 %zero 1 #683
	jal %zero beq_cont.35235 # then sentence ends
beq_else.35234:
	lw %a2 %sp 32 #683
beq_cont.35235:
	addi %a3 %zero 4 #684
	li %f0 l.27725 #684
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
	bne %a4 %a12 beq_else.35236 # nontail if
	lw %f0 %a2 0 #650
	sw %f0 %sp 56 #701
	sw %ra %sp 68 #701 call dir
	addi %sp %sp 72 #701	
	jal %ra min_caml_fiszero #701
	addi %sp %sp -72 #701
	lw %ra %sp 68 #701
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35239 # nontail if
	lw %f0 %sp 56 #111
	sw %ra %sp 68 #111 call dir
	addi %sp %sp 72 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -72 #111
	lw %ra %sp 68 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35241 # nontail if
	lw %f0 %sp 56 #112
	sw %ra %sp 68 #112 call dir
	addi %sp %sp 72 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -72 #112
	lw %ra %sp 68 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35243 # nontail if
	li %f0 l.27801 #113
	jal %zero beq_cont.35244 # then sentence ends
beq_else.35243:
	li %f0 l.27799 #112
beq_cont.35244:
	jal %zero beq_cont.35242 # then sentence ends
beq_else.35241:
	li %f0 l.27725 #111
beq_cont.35242:
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
	jal %zero beq_cont.35240 # then sentence ends
beq_else.35239:
	li %f0 l.27725 #701
beq_cont.35240:
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
	bne %a0 %a12 beq_else.35245 # nontail if
	lw %f0 %sp 72 #111
	sw %ra %sp 84 #111 call dir
	addi %sp %sp 88 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -88 #111
	lw %ra %sp 84 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35247 # nontail if
	lw %f0 %sp 72 #112
	sw %ra %sp 84 #112 call dir
	addi %sp %sp 88 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -88 #112
	lw %ra %sp 84 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35249 # nontail if
	li %f0 l.27801 #113
	jal %zero beq_cont.35250 # then sentence ends
beq_else.35249:
	li %f0 l.27799 #112
beq_cont.35250:
	jal %zero beq_cont.35248 # then sentence ends
beq_else.35247:
	li %f0 l.27725 #111
beq_cont.35248:
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
	jal %zero beq_cont.35246 # then sentence ends
beq_else.35245:
	li %f0 l.27725 #703
beq_cont.35246:
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
	bne %a0 %a12 beq_else.35251 # nontail if
	lw %f0 %sp 88 #111
	sw %ra %sp 100 #111 call dir
	addi %sp %sp 104 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -104 #111
	lw %ra %sp 100 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35253 # nontail if
	lw %f0 %sp 88 #112
	sw %ra %sp 100 #112 call dir
	addi %sp %sp 104 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -104 #112
	lw %ra %sp 100 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35255 # nontail if
	li %f0 l.27801 #113
	jal %zero beq_cont.35256 # then sentence ends
beq_else.35255:
	li %f0 l.27799 #112
beq_cont.35256:
	jal %zero beq_cont.35254 # then sentence ends
beq_else.35253:
	li %f0 l.27725 #111
beq_cont.35254:
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
	jal %zero beq_cont.35252 # then sentence ends
beq_else.35251:
	li %f0 l.27725 #705
beq_cont.35252:
	lw %a0 %sp 24 #705
	sw %f0 %a0 8 #705
	jal %zero beq_cont.35237 # then sentence ends
beq_else.35236:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.35257 # nontail if
	lw %a1 %sp 32 #683
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35259 # nontail if
	addi %a1 %zero 1 #709
	jal %zero beq_cont.35260 # then sentence ends
beq_else.35259:
	addi %a1 %zero 0 #709
beq_cont.35260:
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
	bne %a0 %a12 beq_else.35262 # nontail if
	lw %a0 %sp 104 #709
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35264 # nontail if
	li %f0 l.27799 #173
	lw %f1 %sp 128 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.35265 # then sentence ends
beq_else.35264:
	li %f0 l.27801 #173
	lw %f1 %sp 128 #173
	fdiv %f0 %f0 %f1 #173
beq_cont.35265:
	jal %zero beq_cont.35263 # then sentence ends
beq_else.35262:
	li %f0 l.27799 #173
beq_cont.35263:
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
	jal %zero beq_cont.35258 # then sentence ends
beq_else.35257:
beq_cont.35258:
beq_cont.35237:
	lw %a0 %sp 20 #644
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35266 # nontail if
	jal %zero beq_cont.35267 # then sentence ends
beq_else.35266:
	lw %a0 %sp 24 #714
	lw %a1 %sp 44 #714
	sw %ra %sp 140 #714 call dir
	addi %sp %sp 144 #714	
	jal %ra rotate_quadratic_matrix.2366 #714
	addi %sp %sp -144 #714
	lw %ra %sp 140 #714
beq_cont.35267:
	addi %a0 %zero 1 #717
	jalr %zero %ra 0 #717
read_object.2371:
	lw %a1 %a11 8 #724
	lw %a2 %a11 4 #724
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35268
	jalr %zero %ra 0 #730
bge_else.35268:
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
	bne %a0 %a12 beq_else.35270
	lw %a0 %sp 8 #729
	lw %a1 %sp 12 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35270:
	lw %a0 %sp 12 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35272
	jalr %zero %ra 0 #730
bge_else.35272:
	lw %a11 %sp 4 #726
	sw %a0 %sp 16 #726
	sw %ra %sp 20 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 24 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -24 #726
	lw %ra %sp 20 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35274
	lw %a0 %sp 8 #729
	lw %a1 %sp 16 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35274:
	lw %a0 %sp 16 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35276
	jalr %zero %ra 0 #730
bge_else.35276:
	lw %a11 %sp 4 #726
	sw %a0 %sp 20 #726
	sw %ra %sp 28 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 32 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -32 #726
	lw %ra %sp 28 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35278
	lw %a0 %sp 8 #729
	lw %a1 %sp 20 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35278:
	lw %a0 %sp 20 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35280
	jalr %zero %ra 0 #730
bge_else.35280:
	lw %a11 %sp 4 #726
	sw %a0 %sp 24 #726
	sw %ra %sp 28 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 32 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -32 #726
	lw %ra %sp 28 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35282
	lw %a0 %sp 8 #729
	lw %a1 %sp 24 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35282:
	lw %a0 %sp 24 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35284
	jalr %zero %ra 0 #730
bge_else.35284:
	lw %a11 %sp 4 #726
	sw %a0 %sp 28 #726
	sw %ra %sp 36 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 40 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -40 #726
	lw %ra %sp 36 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35286
	lw %a0 %sp 8 #729
	lw %a1 %sp 28 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35286:
	lw %a0 %sp 28 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35288
	jalr %zero %ra 0 #730
bge_else.35288:
	lw %a11 %sp 4 #726
	sw %a0 %sp 32 #726
	sw %ra %sp 36 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 40 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -40 #726
	lw %ra %sp 36 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35290
	lw %a0 %sp 8 #729
	lw %a1 %sp 32 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35290:
	lw %a0 %sp 32 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35292
	jalr %zero %ra 0 #730
bge_else.35292:
	lw %a11 %sp 4 #726
	sw %a0 %sp 36 #726
	sw %ra %sp 44 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 48 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -48 #726
	lw %ra %sp 44 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35294
	lw %a0 %sp 8 #729
	lw %a1 %sp 36 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35294:
	lw %a0 %sp 36 #727
	addi %a0 %a0 1 #727
	addi %a12 %zero 60
	blt %a0 %a12 bge_else.35296
	jalr %zero %ra 0 #730
bge_else.35296:
	lw %a11 %sp 4 #726
	sw %a0 %sp 40 #726
	sw %ra %sp 44 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 48 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -48 #726
	lw %ra %sp 44 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35298
	lw %a0 %sp 8 #729
	lw %a1 %sp 40 #729
	sw %a1 %a0 0 #729
	jalr %zero %ra 0 #729
beq_else.35298:
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
	bne %a0 %a12 beq_else.35300
	lw %a0 %sp 0 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	jal	%zero min_caml_create_array
beq_else.35300:
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
	bne %a0 %a12 beq_else.35301 # nontail if
	lw %a0 %sp 8 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.35302 # then sentence ends
beq_else.35301:
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
	bne %a0 %a12 beq_else.35303 # nontail if
	lw %a0 %sp 16 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.35304 # then sentence ends
beq_else.35303:
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
	bne %a0 %a12 beq_else.35305 # nontail if
	lw %a0 %sp 24 #742
	addi %a0 %a0 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.35306 # then sentence ends
beq_else.35305:
	lw %a1 %sp 24 #744
	addi %a2 %a1 1 #744
	sw %a0 %sp 28 #744
	add %a0 %a2 %zero
	sw %ra %sp 36 #744 call dir
	addi %sp %sp 40 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -40 #744
	lw %ra %sp 36 #744
	lw %a1 %sp 24 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 28 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.35306:
	lw %a1 %sp 16 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 20 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.35304:
	lw %a1 %sp 8 #745
	slli %a1 %a1 2 #745
	lw %a2 %sp 12 #745
	add %a12 %a0 %a1 #745
	sw %a2 %a12 0 #745
beq_cont.35302:
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
	bne %a0 %a12 beq_else.35307 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 4 #742 call dir
	addi %sp %sp 8 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -8 #742
	lw %ra %sp 4 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.35308 # then sentence ends
beq_else.35307:
	sw %a0 %sp 4 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35309 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.35310 # then sentence ends
beq_else.35309:
	sw %a0 %sp 8 #741
	sw %ra %sp 12 #741 call dir
	addi %sp %sp 16 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -16 #741
	lw %ra %sp 12 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35311 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.35312 # then sentence ends
beq_else.35311:
	addi %a1 %zero 3 #744
	sw %a0 %sp 12 #744
	add %a0 %a1 %zero
	sw %ra %sp 20 #744 call dir
	addi %sp %sp 24 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -24 #744
	lw %ra %sp 20 #744
	lw %a1 %sp 12 #745
	sw %a1 %a0 8 #745
beq_cont.35312:
	lw %a1 %sp 8 #745
	sw %a1 %a0 4 #745
beq_cont.35310:
	lw %a1 %sp 4 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.35308:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35313
	lw %a0 %sp 0 #751
	addi %a0 %a0 1 #751
	jal	%zero min_caml_create_array
beq_else.35313:
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
	bne %a0 %a12 beq_else.35314 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.35315 # then sentence ends
beq_else.35314:
	sw %a0 %sp 24 #741
	sw %ra %sp 28 #741 call dir
	addi %sp %sp 32 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -32 #741
	lw %ra %sp 28 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35316 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.35317 # then sentence ends
beq_else.35316:
	addi %a1 %zero 2 #744
	sw %a0 %sp 28 #744
	add %a0 %a1 %zero
	sw %ra %sp 36 #744 call dir
	addi %sp %sp 40 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -40 #744
	lw %ra %sp 36 #744
	lw %a1 %sp 28 #745
	sw %a1 %a0 4 #745
beq_cont.35317:
	lw %a1 %sp 24 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.35315:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35318 # nontail if
	lw %a0 %sp 20 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 36 #751 call dir
	addi %sp %sp 40 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -40 #751
	lw %ra %sp 36 #751
	jal %zero beq_cont.35319 # then sentence ends
beq_else.35318:
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
	bne %a0 %a12 beq_else.35320 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.35321 # then sentence ends
beq_else.35320:
	addi %a1 %zero 1 #744
	sw %a0 %sp 40 #744
	add %a0 %a1 %zero
	sw %ra %sp 44 #744 call dir
	addi %sp %sp 48 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -48 #744
	lw %ra %sp 44 #744
	lw %a1 %sp 40 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.35321:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35322 # nontail if
	lw %a0 %sp 36 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 44 #751 call dir
	addi %sp %sp 48 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -48 #751
	lw %ra %sp 44 #751
	jal %zero beq_cont.35323 # then sentence ends
beq_else.35322:
	lw %a0 %sp 36 #753
	addi %a2 %a0 1 #753
	addi %a3 %zero 0 #749
	sw %a1 %sp 44 #749
	sw %a2 %sp 48 #749
	add %a0 %a3 %zero
	sw %ra %sp 52 #749 call dir
	addi %sp %sp 56 #749	
	jal %ra read_net_item.2375 #749
	addi %sp %sp -56 #749
	lw %ra %sp 52 #749
	add %a1 %a0 %zero #749
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35324 # nontail if
	lw %a0 %sp 48 #751
	addi %a0 %a0 1 #751
	sw %ra %sp 52 #751 call dir
	addi %sp %sp 56 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -56 #751
	lw %ra %sp 52 #751
	jal %zero beq_cont.35325 # then sentence ends
beq_else.35324:
	lw %a0 %sp 48 #753
	addi %a2 %a0 1 #753
	sw %a1 %sp 52 #753
	add %a0 %a2 %zero
	sw %ra %sp 60 #753 call dir
	addi %sp %sp 64 #753	
	jal %ra read_or_network.2377 #753
	addi %sp %sp -64 #753
	lw %ra %sp 60 #753
	lw %a1 %sp 48 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 52 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.35325:
	lw %a1 %sp 36 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 44 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.35323:
	lw %a1 %sp 20 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 32 #754
	add %a12 %a0 %a1 #754
	sw %a2 %a12 0 #754
beq_cont.35319:
	lw %a1 %sp 0 #754
	slli %a1 %a1 2 #754
	lw %a2 %sp 16 #754
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
	bne %a0 %a12 beq_else.35326 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 12 #742 call dir
	addi %sp %sp 16 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -16 #742
	lw %ra %sp 12 #742
	jal %zero beq_cont.35327 # then sentence ends
beq_else.35326:
	sw %a0 %sp 12 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35328 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.35329 # then sentence ends
beq_else.35328:
	sw %a0 %sp 16 #741
	sw %ra %sp 20 #741 call dir
	addi %sp %sp 24 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -24 #741
	lw %ra %sp 20 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35330 # nontail if
	addi %a0 %zero 3 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 20 #742 call dir
	addi %sp %sp 24 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -24 #742
	lw %ra %sp 20 #742
	jal %zero beq_cont.35331 # then sentence ends
beq_else.35330:
	addi %a1 %zero 3 #744
	sw %a0 %sp 20 #744
	add %a0 %a1 %zero
	sw %ra %sp 28 #744 call dir
	addi %sp %sp 32 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -32 #744
	lw %ra %sp 28 #744
	lw %a1 %sp 20 #745
	sw %a1 %a0 8 #745
beq_cont.35331:
	lw %a1 %sp 16 #745
	sw %a1 %a0 4 #745
beq_cont.35329:
	lw %a1 %sp 12 #745
	sw %a1 %a0 0 #745
beq_cont.35327:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35332
	jalr %zero %ra 0 #759
beq_else.35332:
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
	bne %a0 %a12 beq_else.35334 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 28 #742 call dir
	addi %sp %sp 32 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -32 #742
	lw %ra %sp 28 #742
	jal %zero beq_cont.35335 # then sentence ends
beq_else.35334:
	sw %a0 %sp 28 #741
	sw %ra %sp 36 #741 call dir
	addi %sp %sp 40 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -40 #741
	lw %ra %sp 36 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35336 # nontail if
	addi %a0 %zero 2 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 36 #742 call dir
	addi %sp %sp 40 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -40 #742
	lw %ra %sp 36 #742
	jal %zero beq_cont.35337 # then sentence ends
beq_else.35336:
	addi %a1 %zero 2 #744
	sw %a0 %sp 32 #744
	add %a0 %a1 %zero
	sw %ra %sp 36 #744 call dir
	addi %sp %sp 40 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -40 #744
	lw %ra %sp 36 #744
	lw %a1 %sp 32 #745
	sw %a1 %a0 4 #745
beq_cont.35337:
	lw %a1 %sp 28 #745
	sw %a1 %a0 0 #745
beq_cont.35335:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35338
	jalr %zero %ra 0 #759
beq_else.35338:
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
	bne %a0 %a12 beq_else.35340 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 44 #742 call dir
	addi %sp %sp 48 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -48 #742
	lw %ra %sp 44 #742
	jal %zero beq_cont.35341 # then sentence ends
beq_else.35340:
	addi %a1 %zero 1 #744
	sw %a0 %sp 40 #744
	add %a0 %a1 %zero
	sw %ra %sp 44 #744 call dir
	addi %sp %sp 48 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -48 #744
	lw %ra %sp 44 #744
	lw %a1 %sp 40 #745
	sw %a1 %a0 0 #745
beq_cont.35341:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35342
	jalr %zero %ra 0 #759
beq_else.35342:
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
	jal %ra read_net_item.2375 #758
	addi %sp %sp -56 #758
	lw %ra %sp 52 #758
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35344
	jalr %zero %ra 0 #759
beq_else.35344:
	lw %a1 %sp 44 #761
	slli %a2 %a1 2 #761
	lw %a3 %sp 4 #761
	add %a12 %a3 %a2 #761
	sw %a0 %a12 0 #761
	addi %a0 %a1 1 #762
	lw %a11 %sp 0 #762
	lw %a10 %a11 0 #762
	jalr %zero %a10 0 #762
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
	bne %a0 %a12 beq_else.35347 # nontail if
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
	bne %a1 %a12 beq_else.35349 # nontail if
	jal %zero beq_cont.35350 # then sentence ends
beq_else.35349:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35351 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35352 # then sentence ends
beq_else.35351:
	addi %a0 %zero 0 #105
beq_cont.35352:
beq_cont.35350:
	lw %a1 %sp 40 #785
	lw %f0 %a1 0 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35353 # nontail if
	sw %ra %sp 52 #118 call dir
	addi %sp %sp 56 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -56 #118
	lw %ra %sp 52 #118
	jal %zero beq_cont.35354 # then sentence ends
beq_else.35353:
beq_cont.35354:
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
	bne %a0 %a12 beq_else.35355 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35356 # then sentence ends
beq_else.35355:
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
	bne %a0 %a12 beq_else.35357 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35358 # then sentence ends
beq_else.35357:
	lw %a0 %sp 0 #790
	lw %f0 %sp 48 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.35358:
beq_cont.35356:
	jal %zero beq_cont.35348 # then sentence ends
beq_else.35347:
	addi %a0 %zero 0 #783
beq_cont.35348:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35359
	lw %a0 %sp 32 #783
	lw %f0 %a0 4 #783
	sw %ra %sp 60 #783 call dir
	addi %sp %sp 64 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -64 #783
	lw %ra %sp 60 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35360 # nontail if
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
	bne %a1 %a12 beq_else.35362 # nontail if
	jal %zero beq_cont.35363 # then sentence ends
beq_else.35362:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35364 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35365 # then sentence ends
beq_else.35364:
	addi %a0 %zero 0 #105
beq_cont.35365:
beq_cont.35363:
	lw %a1 %sp 56 #785
	lw %f0 %a1 4 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35366 # nontail if
	sw %ra %sp 68 #118 call dir
	addi %sp %sp 72 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -72 #118
	lw %ra %sp 68 #118
	jal %zero beq_cont.35367 # then sentence ends
beq_else.35366:
beq_cont.35367:
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
	bne %a0 %a12 beq_else.35368 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35369 # then sentence ends
beq_else.35368:
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
	bne %a0 %a12 beq_else.35370 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35371 # then sentence ends
beq_else.35370:
	lw %a0 %sp 0 #790
	lw %f0 %sp 64 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.35371:
beq_cont.35369:
	jal %zero beq_cont.35361 # then sentence ends
beq_else.35360:
	addi %a0 %zero 0 #783
beq_cont.35361:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35372
	lw %a0 %sp 32 #783
	lw %f0 %a0 8 #783
	sw %ra %sp 76 #783 call dir
	addi %sp %sp 80 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -80 #783
	lw %ra %sp 76 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35373 # nontail if
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
	bne %a1 %a12 beq_else.35375 # nontail if
	jal %zero beq_cont.35376 # then sentence ends
beq_else.35375:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35377 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35378 # then sentence ends
beq_else.35377:
	addi %a0 %zero 0 #105
beq_cont.35378:
beq_cont.35376:
	lw %a1 %sp 72 #785
	lw %f0 %a1 8 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35379 # nontail if
	sw %ra %sp 84 #118 call dir
	addi %sp %sp 88 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -88 #118
	lw %ra %sp 84 #118
	jal %zero beq_cont.35380 # then sentence ends
beq_else.35379:
beq_cont.35380:
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
	bne %a0 %a12 beq_else.35381 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35382 # then sentence ends
beq_else.35381:
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
	bne %a0 %a12 beq_else.35383 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35384 # then sentence ends
beq_else.35383:
	lw %a0 %sp 0 #790
	lw %f0 %sp 80 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.35384:
beq_cont.35382:
	jal %zero beq_cont.35374 # then sentence ends
beq_else.35373:
	addi %a0 %zero 0 #783
beq_cont.35374:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35385
	addi %a0 %zero 0 #798
	jalr %zero %ra 0 #798
beq_else.35385:
	addi %a0 %zero 3 #800
	jalr %zero %ra 0 #800
beq_else.35372:
	addi %a0 %zero 2 #799
	jalr %zero %ra 0 #799
beq_else.35359:
	addi %a0 %zero 1 #798
	jalr %zero %ra 0 #798
bilinear.2409:
	fmul %f6 %f0 %f3 #837
	lw %a1 %a0 16 #276
	lw %f7 %a1 0 #281
	fmul %f6 %f6 %f7 #837
	fmul %f7 %f1 %f4 #838
	lw %a1 %a0 16 #286
	lw %f8 %a1 4 #291
	fmul %f7 %f7 %f8 #838
	fadd %f6 %f6 %f7 #837
	fmul %f7 %f2 %f5 #839
	lw %a1 %a0 16 #296
	lw %f8 %a1 8 #301
	fmul %f7 %f7 %f8 #839
	fadd %f6 %f6 %f7 #837
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35386
	fadd %f0 %f6 %fzero #837
	jalr %zero %ra 0 #837
beq_else.35386:
	fmul %f7 %f2 %f4 #845
	fmul %f8 %f1 %f5 #845
	fadd %f7 %f7 %f8 #845
	lw %a1 %a0 36 #396
	lw %f8 %a1 0 #401
	fmul %f7 %f7 %f8 #845
	fmul %f5 %f0 %f5 #846
	fmul %f2 %f2 %f3 #846
	fadd %f2 %f5 %f2 #846
	lw %a1 %a0 36 #406
	lw %f5 %a1 4 #411
	fmul %f2 %f2 %f5 #846
	fadd %f2 %f7 %f2 #845
	fmul %f0 %f0 %f4 #847
	fmul %f1 %f1 %f3 #847
	fadd %f0 %f0 %f1 #847
	lw %a0 %a0 36 #416
	lw %f1 %a0 8 #421
	fmul %f0 %f0 %f1 #847
	fadd %f0 %f2 %f0 #845
	sw %f6 %sp 0 #844
	sw %ra %sp 12 #844 call dir
	addi %sp %sp 16 #844	
	jal %ra min_caml_fhalf #844
	addi %sp %sp -16 #844
	lw %ra %sp 12 #844
	lw %f1 %sp 0 #844
	fadd %f0 %f1 %f0 #844
	jalr %zero %ra 0 #844
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
	bne %a1 %a12 beq_else.35390 # nontail if
	jal %zero beq_cont.35391 # then sentence ends
beq_else.35390:
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
beq_cont.35391:
	sw %f0 %sp 88 #860
	sw %ra %sp 100 #860 call dir
	addi %sp %sp 104 #860	
	jal %ra min_caml_fiszero #860
	addi %sp %sp -104 #860
	lw %ra %sp 100 #860
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35392
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
	bne %a1 %a12 beq_else.35393 # nontail if
	fadd %f0 %f4 %fzero #837
	jal %zero beq_cont.35394 # then sentence ends
beq_else.35393:
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
beq_cont.35394:
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
	bne %a1 %a12 beq_else.35395 # nontail if
	jal %zero beq_cont.35396 # then sentence ends
beq_else.35395:
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
beq_cont.35396:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.35397 # nontail if
	li %f1 l.27799 #868
	fsub %f0 %f0 %f1 #868
	jal %zero beq_cont.35398 # then sentence ends
beq_else.35397:
beq_cont.35398:
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
	bne %a0 %a12 beq_else.35399
	addi %a0 %zero 0 #860
	jalr %zero %ra 0 #860
beq_else.35399:
	lw %f0 %sp 136 #873
	sw %ra %sp 148 #873 call dir
	addi %sp %sp 152 #873	
	jal %ra min_caml_sqrt #873
	addi %sp %sp -152 #873
	lw %ra %sp 148 #873
	lw %a0 %sp 64 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35400 # nontail if
	sw %ra %sp 148 #874 call dir
	addi %sp %sp 152 #874	
	jal %ra min_caml_fneg #874
	addi %sp %sp -152 #874
	lw %ra %sp 148 #874
	jal %zero beq_cont.35401 # then sentence ends
beq_else.35400:
beq_cont.35401:
	lw %f1 %sp 104 #875
	fsub %f0 %f0 %f1 #875
	lw %f1 %sp 88 #875
	fdiv %f0 %f0 %f1 #875
	lw %a0 %sp 0 #875
	sw %f0 %a0 0 #875
	addi %a0 %zero 1 #875
	jalr %zero %ra 0 #875
beq_else.35392:
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
	bne %a2 %a12 beq_else.35402
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
	bne %a0 %a12 beq_else.35404 # nontail if
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
	bne %a1 %a12 beq_else.35406 # nontail if
	jal %zero beq_cont.35407 # then sentence ends
beq_else.35406:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35408 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35409 # then sentence ends
beq_else.35408:
	addi %a0 %zero 0 #105
beq_cont.35409:
beq_cont.35407:
	lw %a1 %sp 40 #785
	lw %f0 %a1 0 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35410 # nontail if
	sw %ra %sp 52 #118 call dir
	addi %sp %sp 56 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -56 #118
	lw %ra %sp 52 #118
	jal %zero beq_cont.35411 # then sentence ends
beq_else.35410:
beq_cont.35411:
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
	bne %a0 %a12 beq_else.35412 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35413 # then sentence ends
beq_else.35412:
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
	bne %a0 %a12 beq_else.35414 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35415 # then sentence ends
beq_else.35414:
	lw %a0 %sp 0 #790
	lw %f0 %sp 48 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.35415:
beq_cont.35413:
	jal %zero beq_cont.35405 # then sentence ends
beq_else.35404:
	addi %a0 %zero 0 #783
beq_cont.35405:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35416
	lw %a0 %sp 32 #783
	lw %f0 %a0 4 #783
	sw %ra %sp 60 #783 call dir
	addi %sp %sp 64 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -64 #783
	lw %ra %sp 60 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35417 # nontail if
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
	bne %a1 %a12 beq_else.35419 # nontail if
	jal %zero beq_cont.35420 # then sentence ends
beq_else.35419:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35421 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35422 # then sentence ends
beq_else.35421:
	addi %a0 %zero 0 #105
beq_cont.35422:
beq_cont.35420:
	lw %a1 %sp 56 #785
	lw %f0 %a1 4 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35423 # nontail if
	sw %ra %sp 68 #118 call dir
	addi %sp %sp 72 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -72 #118
	lw %ra %sp 68 #118
	jal %zero beq_cont.35424 # then sentence ends
beq_else.35423:
beq_cont.35424:
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
	bne %a0 %a12 beq_else.35425 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35426 # then sentence ends
beq_else.35425:
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
	bne %a0 %a12 beq_else.35427 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35428 # then sentence ends
beq_else.35427:
	lw %a0 %sp 0 #790
	lw %f0 %sp 64 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.35428:
beq_cont.35426:
	jal %zero beq_cont.35418 # then sentence ends
beq_else.35417:
	addi %a0 %zero 0 #783
beq_cont.35418:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35429
	lw %a0 %sp 32 #783
	lw %f0 %a0 8 #783
	sw %ra %sp 76 #783 call dir
	addi %sp %sp 80 #783	
	jal %ra min_caml_fiszero #783
	addi %sp %sp -80 #783
	lw %ra %sp 76 #783
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35430 # nontail if
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
	bne %a1 %a12 beq_else.35432 # nontail if
	jal %zero beq_cont.35433 # then sentence ends
beq_else.35432:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35434 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35435 # then sentence ends
beq_else.35434:
	addi %a0 %zero 0 #105
beq_cont.35435:
beq_cont.35433:
	lw %a1 %sp 72 #785
	lw %f0 %a1 8 #785
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35436 # nontail if
	sw %ra %sp 84 #118 call dir
	addi %sp %sp 88 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -88 #118
	lw %ra %sp 84 #118
	jal %zero beq_cont.35437 # then sentence ends
beq_else.35436:
beq_cont.35437:
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
	bne %a0 %a12 beq_else.35438 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35439 # then sentence ends
beq_else.35438:
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
	bne %a0 %a12 beq_else.35440 # nontail if
	addi %a0 %zero 0 #783
	jal %zero beq_cont.35441 # then sentence ends
beq_else.35440:
	lw %a0 %sp 0 #790
	lw %f0 %sp 80 #790
	sw %f0 %a0 0 #790
	addi %a0 %zero 1 #790
beq_cont.35441:
beq_cont.35439:
	jal %zero beq_cont.35431 # then sentence ends
beq_else.35430:
	addi %a0 %zero 0 #783
beq_cont.35431:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35442
	addi %a0 %zero 0 #798
	jalr %zero %ra 0 #798
beq_else.35442:
	addi %a0 %zero 3 #800
	jalr %zero %ra 0 #800
beq_else.35429:
	addi %a0 %zero 2 #799
	jalr %zero %ra 0 #799
beq_else.35416:
	addi %a0 %zero 1 #798
	jalr %zero %ra 0 #798
beq_else.35402:
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.35443
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
	bne %a0 %a12 beq_else.35444
	addi %a0 %zero 0 #811
	jalr %zero %ra 0 #811
beq_else.35444:
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
beq_else.35443:
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
	bne %a1 %a12 beq_else.35446 # nontail if
	jal %zero beq_cont.35447 # then sentence ends
beq_else.35446:
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
beq_cont.35447:
	sw %f0 %sp 144 #860
	sw %ra %sp 156 #860 call dir
	addi %sp %sp 160 #860	
	jal %ra min_caml_fiszero #860
	addi %sp %sp -160 #860
	lw %ra %sp 156 #860
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35448
	lw %a0 %sp 32 #858
	lw %f0 %a0 0 #858
	lw %f1 %a0 4 #858
	lw %f2 %a0 8 #858
	lw %f3 %sp 24 #865
	lw %f4 %sp 16 #865
	lw %f5 %sp 8 #865
	lw %a0 %sp 36 #865
	sw %ra %sp 156 #865 call dir
	addi %sp %sp 160 #865	
	jal %ra bilinear.2409 #865
	addi %sp %sp -160 #865
	lw %ra %sp 156 #865
	lw %f1 %sp 24 #822
	sw %f0 %sp 152 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 164 #822 call dir
	addi %sp %sp 168 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -168 #822
	lw %ra %sp 164 #822
	lw %a0 %sp 36 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 16 #822
	sw %f0 %sp 160 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 172 #822 call dir
	addi %sp %sp 176 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -176 #822
	lw %ra %sp 172 #822
	lw %a0 %sp 36 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 160 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 8 #822
	sw %f0 %sp 168 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 180 #822 call dir
	addi %sp %sp 184 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -184 #822
	lw %ra %sp 180 #822
	lw %a0 %sp 36 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 168 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35449 # nontail if
	jal %zero beq_cont.35450 # then sentence ends
beq_else.35449:
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
beq_cont.35450:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.35451 # nontail if
	li %f1 l.27799 #868
	fsub %f0 %f0 %f1 #868
	jal %zero beq_cont.35452 # then sentence ends
beq_else.35451:
beq_cont.35452:
	lw %f1 %sp 152 #870
	sw %f0 %sp 176 #870
	fadd %f0 %f1 %fzero
	sw %ra %sp 188 #870 call dir
	addi %sp %sp 192 #870	
	jal %ra min_caml_fsqr #870
	addi %sp %sp -192 #870
	lw %ra %sp 188 #870
	lw %f1 %sp 176 #870
	lw %f2 %sp 144 #870
	fmul %f1 %f2 %f1 #870
	fsub %f0 %f0 %f1 #870
	sw %f0 %sp 184 #872
	sw %ra %sp 196 #872 call dir
	addi %sp %sp 200 #872	
	jal %ra min_caml_fispos #872
	addi %sp %sp -200 #872
	lw %ra %sp 196 #872
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35453
	addi %a0 %zero 0 #860
	jalr %zero %ra 0 #860
beq_else.35453:
	lw %f0 %sp 184 #873
	sw %ra %sp 196 #873 call dir
	addi %sp %sp 200 #873	
	jal %ra min_caml_sqrt #873
	addi %sp %sp -200 #873
	lw %ra %sp 196 #873
	lw %a0 %sp 36 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35454 # nontail if
	sw %ra %sp 196 #874 call dir
	addi %sp %sp 200 #874	
	jal %ra min_caml_fneg #874
	addi %sp %sp -200 #874
	lw %ra %sp 196 #874
	jal %zero beq_cont.35455 # then sentence ends
beq_else.35454:
beq_cont.35455:
	lw %f1 %sp 152 #875
	fsub %f0 %f0 %f1 #875
	lw %f1 %sp 144 #875
	fdiv %f0 %f0 %f1 #875
	lw %a0 %sp 0 #875
	sw %f0 %a0 0 #875
	addi %a0 %zero 1 #875
	jalr %zero %ra 0 #875
beq_else.35448:
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
	bne %a0 %a12 beq_else.35458 # nontail if
	addi %a0 %zero 0 #903
	jal %zero beq_cont.35459 # then sentence ends
beq_else.35458:
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
	bne %a0 %a12 beq_else.35460 # nontail if
	addi %a0 %zero 0 #903
	jal %zero beq_cont.35461 # then sentence ends
beq_else.35460:
	lw %a0 %sp 24 #901
	lw %f0 %a0 4 #901
	sw %ra %sp 60 #905 call dir
	addi %sp %sp 64 #905	
	jal %ra min_caml_fiszero #905
	addi %sp %sp -64 #905
	lw %ra %sp 60 #905
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35462 # nontail if
	addi %a0 %zero 1 #905
	jal %zero beq_cont.35463 # then sentence ends
beq_else.35462:
	addi %a0 %zero 0 #903
beq_cont.35463:
beq_cont.35461:
beq_cont.35459:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35464
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
	bne %a0 %a12 beq_else.35465 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.35466 # then sentence ends
beq_else.35465:
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
	bne %a0 %a12 beq_else.35467 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.35468 # then sentence ends
beq_else.35467:
	lw %a0 %sp 24 #901
	lw %f0 %a0 12 #901
	sw %ra %sp 68 #914 call dir
	addi %sp %sp 72 #914	
	jal %ra min_caml_fiszero #914
	addi %sp %sp -72 #914
	lw %ra %sp 68 #914
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35469 # nontail if
	addi %a0 %zero 1 #914
	jal %zero beq_cont.35470 # then sentence ends
beq_else.35469:
	addi %a0 %zero 0 #902
beq_cont.35470:
beq_cont.35468:
beq_cont.35466:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35471
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
	bne %a0 %a12 beq_else.35472 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.35473 # then sentence ends
beq_else.35472:
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
	bne %a0 %a12 beq_else.35474 # nontail if
	addi %a0 %zero 0 #902
	jal %zero beq_cont.35475 # then sentence ends
beq_else.35474:
	lw %a0 %sp 24 #901
	lw %f0 %a0 20 #901
	sw %ra %sp 76 #923 call dir
	addi %sp %sp 80 #923	
	jal %ra min_caml_fiszero #923
	addi %sp %sp -80 #923
	lw %ra %sp 76 #923
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35476 # nontail if
	addi %a0 %zero 1 #923
	jal %zero beq_cont.35477 # then sentence ends
beq_else.35476:
	addi %a0 %zero 0 #902
beq_cont.35477:
beq_cont.35475:
beq_cont.35473:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35478
	addi %a0 %zero 0 #902
	jalr %zero %ra 0 #902
beq_else.35478:
	lw %a0 %sp 0 #927
	lw %f0 %sp 64 #927
	sw %f0 %a0 0 #927
	addi %a0 %zero 3 #927
	jalr %zero %ra 0 #927
beq_else.35471:
	lw %a0 %sp 0 #918
	lw %f0 %sp 56 #918
	sw %f0 %a0 0 #918
	addi %a0 %zero 2 #918
	jalr %zero %ra 0 #918
beq_else.35464:
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
	bne %a0 %a12 beq_else.35481
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
	bne %a1 %a12 beq_else.35483 # nontail if
	jal %zero beq_cont.35484 # then sentence ends
beq_else.35483:
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
beq_cont.35484:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.35485 # nontail if
	li %f1 l.27799 #950
	fsub %f0 %f0 %f1 #950
	jal %zero beq_cont.35486 # then sentence ends
beq_else.35485:
beq_cont.35486:
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
	bne %a0 %a12 beq_else.35487
	addi %a0 %zero 0 #945
	jalr %zero %ra 0 #945
beq_else.35487:
	lw %a0 %sp 16 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35488 # nontail if
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
	jal %zero beq_cont.35489 # then sentence ends
beq_else.35488:
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
beq_cont.35489:
	addi %a0 %zero 1 #957
	jalr %zero %ra 0 #957
beq_else.35481:
	addi %a0 %zero 0 #945
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
	lw %a7 %a6 20 #316
	lw %f1 %a7 0 #321
	fsub %f0 %f0 %f1 #964
	lw %f1 %a2 4 #964
	lw %a7 %a6 20 #326
	lw %f2 %a7 4 #331
	fsub %f1 %f1 %f2 #965
	lw %f2 %a2 8 #964
	lw %a2 %a6 20 #336
	lw %f3 %a2 8 #341
	fsub %f2 %f2 %f3 #966
	lw %a2 %a1 4 #513
	slli %a0 %a0 2 #968
	add %a12 %a2 %a0 #968
	lw %a2 %a12 0 #968
	lw %a0 %a6 4 #238
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.35490
	lw %a1 %a1 0 #507
	add %a0 %a6 %zero
	add %a11 %a4 %zero
	lw %a10 %a11 0 #971
	jalr %zero %a10 0 #971
beq_else.35490:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.35491
	lw %f3 %a2 0 #934
	sw %a5 %sp 0 #934
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
	bne %a0 %a12 beq_else.35493
	addi %a0 %zero 0 #934
	jalr %zero %ra 0 #934
beq_else.35493:
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
beq_else.35491:
	add %a1 %a2 %zero
	add %a0 %a6 %zero
	add %a11 %a3 %zero
	lw %a10 %a11 0 #975
	jalr %zero %a10 0 #975
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
	bne %a6 %a12 beq_else.35494
	lw %a1 %a1 0 #507
	add %a11 %a2 %zero
	add %a2 %a0 %zero
	add %a0 %a4 %zero
	lw %a10 %a11 0 #1019
	jalr %zero %a10 0 #1019
beq_else.35494:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.35495
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
	bne %a0 %a12 beq_else.35496
	addi %a0 %zero 0 #983
	jalr %zero %ra 0 #983
beq_else.35496:
	lw %a0 %sp 8 #983
	lw %f0 %a0 0 #983
	lw %a0 %sp 4 #984
	lw %f1 %a0 12 #984
	fmul %f0 %f0 %f1 #984
	lw %a0 %sp 0 #984
	sw %f0 %a0 0 #984
	addi %a0 %zero 1 #985
	jalr %zero %ra 0 #985
beq_else.35495:
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
	bne %a0 %a12 beq_else.35497
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
	bne %a0 %a12 beq_else.35498
	addi %a0 %zero 0 #993
	jalr %zero %ra 0 #993
beq_else.35498:
	lw %a0 %sp 12 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35499 # nontail if
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
	jal %zero beq_cont.35500 # then sentence ends
beq_else.35499:
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
beq_cont.35500:
	addi %a0 %zero 1 #1004
	jalr %zero %ra 0 #1004
beq_else.35497:
	addi %a0 %zero 0 #993
	jalr %zero %ra 0 #993
setup_rect_table.2467:
	addi %a2 %zero 6 #1030
	li %f0 l.27725 #1030
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
	bne %a0 %a12 beq_else.35501 # nontail if
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
	bne %a1 %a12 beq_else.35503 # nontail if
	jal %zero beq_cont.35504 # then sentence ends
beq_else.35503:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35505 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35506 # then sentence ends
beq_else.35505:
	addi %a0 %zero 0 #105
beq_cont.35506:
beq_cont.35504:
	lw %a1 %sp 0 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35507 # nontail if
	sw %ra %sp 20 #118 call dir
	addi %sp %sp 24 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -24 #118
	lw %ra %sp 20 #118
	jal %zero beq_cont.35508 # then sentence ends
beq_else.35507:
beq_cont.35508:
	lw %a0 %sp 8 #1036
	sw %f0 %a0 0 #1036
	li %f0 l.27799 #1038
	lw %a1 %sp 4 #1032
	lw %f1 %a1 0 #1032
	fdiv %f0 %f0 %f1 #1038
	sw %f0 %a0 4 #1038
	jal %zero beq_cont.35502 # then sentence ends
beq_else.35501:
	li %f0 l.27725 #1033
	lw %a0 %sp 8 #1033
	sw %f0 %a0 4 #1033
beq_cont.35502:
	lw %a1 %sp 4 #1032
	lw %f0 %a1 4 #1032
	sw %ra %sp 20 #1040 call dir
	addi %sp %sp 24 #1040	
	jal %ra min_caml_fiszero #1040
	addi %sp %sp -24 #1040
	lw %ra %sp 20 #1040
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35509 # nontail if
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
	bne %a1 %a12 beq_else.35511 # nontail if
	jal %zero beq_cont.35512 # then sentence ends
beq_else.35511:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35513 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35514 # then sentence ends
beq_else.35513:
	addi %a0 %zero 0 #105
beq_cont.35514:
beq_cont.35512:
	lw %a1 %sp 0 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35515 # nontail if
	sw %ra %sp 20 #118 call dir
	addi %sp %sp 24 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -24 #118
	lw %ra %sp 20 #118
	jal %zero beq_cont.35516 # then sentence ends
beq_else.35515:
beq_cont.35516:
	lw %a0 %sp 8 #1043
	sw %f0 %a0 8 #1043
	li %f0 l.27799 #1044
	lw %a1 %sp 4 #1032
	lw %f1 %a1 4 #1032
	fdiv %f0 %f0 %f1 #1044
	sw %f0 %a0 12 #1044
	jal %zero beq_cont.35510 # then sentence ends
beq_else.35509:
	li %f0 l.27725 #1041
	lw %a0 %sp 8 #1041
	sw %f0 %a0 12 #1041
beq_cont.35510:
	lw %a1 %sp 4 #1032
	lw %f0 %a1 8 #1032
	sw %ra %sp 20 #1046 call dir
	addi %sp %sp 24 #1046	
	jal %ra min_caml_fiszero #1046
	addi %sp %sp -24 #1046
	lw %ra %sp 20 #1046
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35517 # nontail if
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
	bne %a1 %a12 beq_else.35519 # nontail if
	jal %zero beq_cont.35520 # then sentence ends
beq_else.35519:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35521 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35522 # then sentence ends
beq_else.35521:
	addi %a0 %zero 0 #105
beq_cont.35522:
beq_cont.35520:
	lw %a1 %sp 0 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35523 # nontail if
	sw %ra %sp 28 #118 call dir
	addi %sp %sp 32 #118	
	jal %ra min_caml_fneg #118
	addi %sp %sp -32 #118
	lw %ra %sp 28 #118
	jal %zero beq_cont.35524 # then sentence ends
beq_else.35523:
beq_cont.35524:
	lw %a0 %sp 8 #1049
	sw %f0 %a0 16 #1049
	li %f0 l.27799 #1050
	lw %a1 %sp 4 #1032
	lw %f1 %a1 8 #1032
	fdiv %f0 %f0 %f1 #1050
	sw %f0 %a0 20 #1050
	jal %zero beq_cont.35518 # then sentence ends
beq_else.35517:
	li %f0 l.27725 #1047
	lw %a0 %sp 8 #1047
	sw %f0 %a0 20 #1047
beq_cont.35518:
	jalr %zero %ra 0 #1052
setup_surface_table.2470:
	addi %a2 %zero 4 #1057
	li %f0 l.27725 #1057
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
	sw %f0 %sp 8 #1061
	sw %a0 %sp 16 #1061
	sw %ra %sp 20 #1061 call dir
	addi %sp %sp 24 #1061	
	jal %ra min_caml_fispos #1061
	addi %sp %sp -24 #1061
	lw %ra %sp 20 #1061
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35525 # nontail if
	li %f0 l.27725 #1069
	lw %a0 %sp 16 #1069
	sw %f0 %a0 0 #1069
	jal %zero beq_cont.35526 # then sentence ends
beq_else.35525:
	li %f0 l.27801 #1063
	lw %f1 %sp 8 #1063
	fdiv %f0 %f0 %f1 #1063
	lw %a0 %sp 16 #1063
	sw %f0 %a0 0 #1063
	lw %a1 %sp 0 #276
	lw %a2 %a1 16 #276
	lw %f0 %a2 0 #281
	fdiv %f0 %f0 %f1 #1065
	sw %ra %sp 20 #1065 call dir
	addi %sp %sp 24 #1065	
	jal %ra min_caml_fneg #1065
	addi %sp %sp -24 #1065
	lw %ra %sp 20 #1065
	lw %a0 %sp 16 #1065
	sw %f0 %a0 4 #1065
	lw %a1 %sp 0 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	lw %f1 %sp 8 #1066
	fdiv %f0 %f0 %f1 #1066
	sw %ra %sp 20 #1066 call dir
	addi %sp %sp 24 #1066	
	jal %ra min_caml_fneg #1066
	addi %sp %sp -24 #1066
	lw %ra %sp 20 #1066
	lw %a0 %sp 16 #1066
	sw %f0 %a0 8 #1066
	lw %a1 %sp 0 #296
	lw %a1 %a1 16 #296
	lw %f0 %a1 8 #301
	lw %f1 %sp 8 #1067
	fdiv %f0 %f0 %f1 #1067
	sw %ra %sp 20 #1067 call dir
	addi %sp %sp 24 #1067	
	jal %ra min_caml_fneg #1067
	addi %sp %sp -24 #1067
	lw %ra %sp 20 #1067
	lw %a0 %sp 16 #1067
	sw %f0 %a0 12 #1067
beq_cont.35526:
	jalr %zero %ra 0 #1070
setup_second_table.2473:
	addi %a2 %zero 5 #1076
	li %f0 l.27725 #1076
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
	bne %a1 %a12 beq_else.35528 # nontail if
	jal %zero beq_cont.35529 # then sentence ends
beq_else.35528:
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
beq_cont.35529:
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
	bne %a2 %a12 beq_else.35530 # nontail if
	lw %f2 %sp 64 #1091
	sw %f2 %a0 4 #1091
	lw %f2 %sp 72 #1092
	sw %f2 %a0 8 #1092
	sw %f0 %a0 12 #1093
	jal %zero beq_cont.35531 # then sentence ends
beq_else.35530:
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
beq_cont.35531:
	lw %f0 %sp 56 #1095
	sw %ra %sp 92 #1095 call dir
	addi %sp %sp 96 #1095	
	jal %ra min_caml_fiszero #1095
	addi %sp %sp -96 #1095
	lw %ra %sp 92 #1095
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35532 # nontail if
	li %f0 l.27799 #1096
	lw %f1 %sp 56 #1096
	fdiv %f0 %f0 %f1 #1096
	lw %a0 %sp 8 #1096
	sw %f0 %a0 16 #1096
	jal %zero beq_cont.35533 # then sentence ends
beq_else.35532:
beq_cont.35533:
	lw %a0 %sp 8 #1098
	jalr %zero %ra 0 #1098
iter_setup_dirvec_constants.2476:
	lw %a2 %a11 4 #1103
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.35534
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
	bne %a6 %a12 beq_else.35535 # nontail if
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
	jal %zero beq_cont.35536 # then sentence ends
beq_else.35535:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.35537 # nontail if
	sw %a4 %sp 12 #1112
	sw %a1 %sp 16 #1112
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 20 #1112 call dir
	addi %sp %sp 24 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -24 #1112
	lw %ra %sp 20 #1112
	lw %a1 %sp 16 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 12 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.35538 # then sentence ends
beq_else.35537:
	sw %a4 %sp 12 #1114
	sw %a1 %sp 16 #1114
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 20 #1114 call dir
	addi %sp %sp 24 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -24 #1114
	lw %ra %sp 20 #1114
	lw %a1 %sp 16 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 12 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.35538:
beq_cont.35536:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.35539
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a3 %sp 4 #513
	lw %a4 %a3 4 #513
	lw %a5 %a3 0 #507
	lw %a6 %a1 4 #238
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.35540 # nontail if
	sw %a4 %sp 20 #1110
	sw %a0 %sp 24 #1110
	add %a0 %a5 %zero
	sw %ra %sp 28 #1110 call dir
	addi %sp %sp 32 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -32 #1110
	lw %ra %sp 28 #1110
	lw %a1 %sp 24 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 20 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.35541 # then sentence ends
beq_else.35540:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.35542 # nontail if
	sw %a4 %sp 20 #1112
	sw %a0 %sp 24 #1112
	add %a0 %a5 %zero
	sw %ra %sp 28 #1112 call dir
	addi %sp %sp 32 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -32 #1112
	lw %ra %sp 28 #1112
	lw %a1 %sp 24 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 20 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.35543 # then sentence ends
beq_else.35542:
	sw %a4 %sp 20 #1114
	sw %a0 %sp 24 #1114
	add %a0 %a5 %zero
	sw %ra %sp 28 #1114 call dir
	addi %sp %sp 32 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -32 #1114
	lw %ra %sp 28 #1114
	lw %a1 %sp 24 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 20 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.35543:
beq_cont.35541:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.35544
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a3 %sp 4 #513
	lw %a4 %a3 4 #513
	lw %a5 %a3 0 #507
	lw %a6 %a1 4 #238
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.35545 # nontail if
	sw %a4 %sp 28 #1110
	sw %a0 %sp 32 #1110
	add %a0 %a5 %zero
	sw %ra %sp 36 #1110 call dir
	addi %sp %sp 40 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -40 #1110
	lw %ra %sp 36 #1110
	lw %a1 %sp 32 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 28 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.35546 # then sentence ends
beq_else.35545:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.35547 # nontail if
	sw %a4 %sp 28 #1112
	sw %a0 %sp 32 #1112
	add %a0 %a5 %zero
	sw %ra %sp 36 #1112 call dir
	addi %sp %sp 40 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -40 #1112
	lw %ra %sp 36 #1112
	lw %a1 %sp 32 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 28 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.35548 # then sentence ends
beq_else.35547:
	sw %a4 %sp 28 #1114
	sw %a0 %sp 32 #1114
	add %a0 %a5 %zero
	sw %ra %sp 36 #1114 call dir
	addi %sp %sp 40 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -40 #1114
	lw %ra %sp 36 #1114
	lw %a1 %sp 32 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 28 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.35548:
beq_cont.35546:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.35549
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a2 %sp 4 #513
	lw %a3 %a2 4 #513
	lw %a4 %a2 0 #507
	lw %a5 %a1 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.35550 # nontail if
	sw %a3 %sp 36 #1110
	sw %a0 %sp 40 #1110
	add %a0 %a4 %zero
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
	jal %zero beq_cont.35551 # then sentence ends
beq_else.35550:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.35552 # nontail if
	sw %a3 %sp 36 #1112
	sw %a0 %sp 40 #1112
	add %a0 %a4 %zero
	sw %ra %sp 44 #1112 call dir
	addi %sp %sp 48 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -48 #1112
	lw %ra %sp 44 #1112
	lw %a1 %sp 40 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 36 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.35553 # then sentence ends
beq_else.35552:
	sw %a3 %sp 36 #1114
	sw %a0 %sp 40 #1114
	add %a0 %a4 %zero
	sw %ra %sp 44 #1114 call dir
	addi %sp %sp 48 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -48 #1114
	lw %ra %sp 44 #1114
	lw %a1 %sp 40 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 36 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.35553:
beq_cont.35551:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 4 #1116
	lw %a11 %sp 0 #1116
	lw %a10 %a11 0 #1116
	jalr %zero %a10 0 #1116
bge_else.35549:
	jalr %zero %ra 0 #1117
bge_else.35544:
	jalr %zero %ra 0 #1117
bge_else.35539:
	jalr %zero %ra 0 #1117
bge_else.35534:
	jalr %zero %ra 0 #1117
setup_dirvec_constants.2479:
	lw %a1 %a11 12 #1120
	lw %a2 %a11 8 #1120
	lw %a3 %a11 4 #1120
	lw %a2 %a2 0 #15
	addi %a2 %a2 -1 #1121
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.35558
	slli %a4 %a2 2 #20
	add %a12 %a1 %a4 #20
	lw %a4 %a12 0 #20
	lw %a5 %a0 4 #513
	lw %a6 %a0 0 #507
	lw %a7 %a4 4 #238
	sw %a3 %sp 0 #868
	sw %a0 %sp 4 #868
	sw %a1 %sp 8 #868
	addi %a12 %zero 1
	bne %a7 %a12 beq_else.35559 # nontail if
	sw %a5 %sp 12 #1110
	sw %a2 %sp 16 #1110
	add %a1 %a4 %zero
	add %a0 %a6 %zero
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
	jal %zero beq_cont.35560 # then sentence ends
beq_else.35559:
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.35561 # nontail if
	sw %a5 %sp 12 #1112
	sw %a2 %sp 16 #1112
	add %a1 %a4 %zero
	add %a0 %a6 %zero
	sw %ra %sp 20 #1112 call dir
	addi %sp %sp 24 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -24 #1112
	lw %ra %sp 20 #1112
	lw %a1 %sp 16 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 12 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.35562 # then sentence ends
beq_else.35561:
	sw %a5 %sp 12 #1114
	sw %a2 %sp 16 #1114
	add %a1 %a4 %zero
	add %a0 %a6 %zero
	sw %ra %sp 20 #1114 call dir
	addi %sp %sp 24 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -24 #1114
	lw %ra %sp 20 #1114
	lw %a1 %sp 16 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 12 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.35562:
beq_cont.35560:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.35563
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a3 %sp 4 #513
	lw %a4 %a3 4 #513
	lw %a5 %a3 0 #507
	lw %a6 %a1 4 #238
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.35564 # nontail if
	sw %a4 %sp 20 #1110
	sw %a0 %sp 24 #1110
	add %a0 %a5 %zero
	sw %ra %sp 28 #1110 call dir
	addi %sp %sp 32 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -32 #1110
	lw %ra %sp 28 #1110
	lw %a1 %sp 24 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 20 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.35565 # then sentence ends
beq_else.35564:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.35566 # nontail if
	sw %a4 %sp 20 #1112
	sw %a0 %sp 24 #1112
	add %a0 %a5 %zero
	sw %ra %sp 28 #1112 call dir
	addi %sp %sp 32 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -32 #1112
	lw %ra %sp 28 #1112
	lw %a1 %sp 24 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 20 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.35567 # then sentence ends
beq_else.35566:
	sw %a4 %sp 20 #1114
	sw %a0 %sp 24 #1114
	add %a0 %a5 %zero
	sw %ra %sp 28 #1114 call dir
	addi %sp %sp 32 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -32 #1114
	lw %ra %sp 28 #1114
	lw %a1 %sp 24 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 20 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.35567:
beq_cont.35565:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.35568
	slli %a1 %a0 2 #20
	lw %a2 %sp 8 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a2 %sp 4 #513
	lw %a3 %a2 4 #513
	lw %a4 %a2 0 #507
	lw %a5 %a1 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.35569 # nontail if
	sw %a3 %sp 28 #1110
	sw %a0 %sp 32 #1110
	add %a0 %a4 %zero
	sw %ra %sp 36 #1110 call dir
	addi %sp %sp 40 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -40 #1110
	lw %ra %sp 36 #1110
	lw %a1 %sp 32 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 28 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.35570 # then sentence ends
beq_else.35569:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.35571 # nontail if
	sw %a3 %sp 28 #1112
	sw %a0 %sp 32 #1112
	add %a0 %a4 %zero
	sw %ra %sp 36 #1112 call dir
	addi %sp %sp 40 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -40 #1112
	lw %ra %sp 36 #1112
	lw %a1 %sp 32 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 28 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.35572 # then sentence ends
beq_else.35571:
	sw %a3 %sp 28 #1114
	sw %a0 %sp 32 #1114
	add %a0 %a4 %zero
	sw %ra %sp 36 #1114 call dir
	addi %sp %sp 40 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -40 #1114
	lw %ra %sp 36 #1114
	lw %a1 %sp 32 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 28 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.35572:
beq_cont.35570:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 4 #1116
	lw %a11 %sp 0 #1116
	lw %a10 %a11 0 #1116
	jalr %zero %a10 0 #1116
bge_else.35568:
	jalr %zero %ra 0 #1117
bge_else.35563:
	jalr %zero %ra 0 #1117
bge_else.35558:
	jalr %zero %ra 0 #1117
setup_startp_constants.2481:
	lw %a2 %a11 4 #1126
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.35576
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
	sw %a0 %sp 0 #868
	sw %a11 %sp 4 #868
	sw %a1 %sp 8 #868
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.35577 # nontail if
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
	jal %zero beq_cont.35578 # then sentence ends
beq_else.35577:
	addi %a12 %zero 2
	blt %a12 %a4 bge_else.35579 # nontail if
	jal %zero bge_cont.35580 # then sentence ends
bge_else.35579:
	lw %f0 %a3 0 #19
	lw %f1 %a3 4 #19
	lw %f2 %a3 8 #19
	sw %a3 %sp 12 #822
	sw %a4 %sp 16 #822
	sw %f0 %sp 24 #822
	sw %f2 %sp 32 #822
	sw %f1 %sp 40 #822
	sw %a2 %sp 48 #822
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
	bne %a1 %a12 beq_else.35583 # nontail if
	jal %zero beq_cont.35584 # then sentence ends
beq_else.35583:
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
beq_cont.35584:
	lw %a0 %sp 16 #868
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.35585 # nontail if
	li %f1 l.27799 #1139
	fsub %f0 %f0 %f1 #1139
	jal %zero beq_cont.35586 # then sentence ends
beq_else.35585:
beq_cont.35586:
	lw %a0 %sp 12 #1139
	sw %f0 %a0 12 #1139
bge_cont.35580:
beq_cont.35578:
	lw %a0 %sp 8 #1141
	addi %a1 %a0 -1 #1141
	lw %a0 %sp 0 #1141
	lw %a11 %sp 4 #1141
	lw %a10 %a11 0 #1141
	jalr %zero %a10 0 #1141
bge_else.35576:
	jalr %zero %ra 0 #1142
is_second_outside.2496:
	sw %f0 %sp 0 #822
	sw %f2 %sp 8 #822
	sw %f1 %sp 16 #822
	sw %a0 %sp 24 #822
	sw %ra %sp 28 #822 call dir
	addi %sp %sp 32 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -32 #822
	lw %ra %sp 28 #822
	lw %a0 %sp 24 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 16 #822
	sw %f0 %sp 32 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #822 call dir
	addi %sp %sp 48 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -48 #822
	lw %ra %sp 44 #822
	lw %a0 %sp 24 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 32 #822
	fadd %f0 %f1 %f0 #822
	lw %f1 %sp 8 #822
	sw %f0 %sp 40 #822
	fadd %f0 %f1 %fzero
	sw %ra %sp 52 #822 call dir
	addi %sp %sp 56 #822	
	jal %ra min_caml_fsqr #822
	addi %sp %sp -56 #822
	lw %ra %sp 52 #822
	lw %a0 %sp 24 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	fmul %f0 %f0 %f1 #822
	lw %f1 %sp 40 #822
	fadd %f0 %f1 %f0 #822
	lw %a1 %a0 12 #267
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35589 # nontail if
	jal %zero beq_cont.35590 # then sentence ends
beq_else.35589:
	lw %f1 %sp 8 #828
	lw %f2 %sp 16 #828
	fmul %f3 %f2 %f1 #828
	lw %a1 %a0 36 #396
	lw %f4 %a1 0 #401
	fmul %f3 %f3 %f4 #828
	fadd %f0 %f0 %f3 #827
	lw %f3 %sp 0 #829
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
beq_cont.35590:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.35591 # nontail if
	li %f1 l.27799 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.35592 # then sentence ends
beq_else.35591:
beq_cont.35592:
	lw %a0 %a0 24 #258
	sw %a0 %sp 48 #1175
	sw %ra %sp 52 #1175 call dir
	addi %sp %sp 56 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -56 #1175
	lw %ra %sp 52 #1175
	lw %a1 %sp 48 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35593 # nontail if
	jal %zero beq_cont.35594 # then sentence ends
beq_else.35593:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35595 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35596 # then sentence ends
beq_else.35595:
	addi %a0 %zero 0 #105
beq_cont.35596:
beq_cont.35594:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35597
	addi %a0 %zero 1 #1175
	jalr %zero %ra 0 #1175
beq_else.35597:
	addi %a0 %zero 0 #1175
	jalr %zero %ra 0 #1175
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
	bne %a1 %a12 beq_else.35598
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
	bne %a0 %a12 beq_else.35599 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35600 # then sentence ends
beq_else.35599:
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
	bne %a0 %a12 beq_else.35601 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35602 # then sentence ends
beq_else.35601:
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
beq_cont.35602:
beq_cont.35600:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35603
	lw %a0 %sp 16 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35604
	addi %a0 %zero 1 #1162
	jalr %zero %ra 0 #1162
beq_else.35604:
	addi %a0 %zero 0 #1156
	jalr %zero %ra 0 #1156
beq_else.35603:
	lw %a0 %sp 16 #258
	lw %a0 %a0 24 #258
	jalr %zero %ra 0 #262
beq_else.35598:
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.35605
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
	bne %a1 %a12 beq_else.35606 # nontail if
	jal %zero beq_cont.35607 # then sentence ends
beq_else.35606:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35608 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35609 # then sentence ends
beq_else.35608:
	addi %a0 %zero 0 #105
beq_cont.35609:
beq_cont.35607:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35610
	addi %a0 %zero 1 #1168
	jalr %zero %ra 0 #1168
beq_else.35610:
	addi %a0 %zero 0 #1168
	jalr %zero %ra 0 #1168
beq_else.35605:
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
	bne %a1 %a12 beq_else.35611 # nontail if
	jal %zero beq_cont.35612 # then sentence ends
beq_else.35611:
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
beq_cont.35612:
	lw %a1 %a0 4 #238
	addi %a12 %zero 3
	bne %a1 %a12 beq_else.35613 # nontail if
	li %f1 l.27799 #1174
	fsub %f0 %f0 %f1 #1174
	jal %zero beq_cont.35614 # then sentence ends
beq_else.35613:
beq_cont.35614:
	lw %a0 %a0 24 #258
	sw %a0 %sp 48 #1175
	sw %ra %sp 52 #1175 call dir
	addi %sp %sp 56 #1175	
	jal %ra min_caml_fisneg #1175
	addi %sp %sp -56 #1175
	lw %ra %sp 52 #1175
	lw %a1 %sp 48 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35615 # nontail if
	jal %zero beq_cont.35616 # then sentence ends
beq_else.35615:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35617 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35618 # then sentence ends
beq_else.35617:
	addi %a0 %zero 0 #105
beq_cont.35618:
beq_cont.35616:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35619
	addi %a0 %zero 1 #1175
	jalr %zero %ra 0 #1175
beq_else.35619:
	addi %a0 %zero 0 #1175
	jalr %zero %ra 0 #1175
check_all_inside.2506:
	lw %a2 %a11 4 #1193
	slli %a3 %a0 2 #1194
	add %a12 %a1 %a3 #1194
	lw %a3 %a12 0 #1194
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.35620
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.35620:
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
	bne %a4 %a12 beq_else.35622 # nontail if
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
	bne %a0 %a12 beq_else.35625 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35626 # then sentence ends
beq_else.35625:
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
	bne %a0 %a12 beq_else.35627 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35628 # then sentence ends
beq_else.35627:
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
beq_cont.35628:
beq_cont.35626:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35629 # nontail if
	lw %a0 %sp 64 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35631 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.35632 # then sentence ends
beq_else.35631:
	addi %a0 %zero 0 #1156
beq_cont.35632:
	jal %zero beq_cont.35630 # then sentence ends
beq_else.35629:
	lw %a0 %sp 64 #258
	lw %a0 %a0 24 #258
beq_cont.35630:
	jal %zero beq_cont.35623 # then sentence ends
beq_else.35622:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.35633 # nontail if
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
	bne %a1 %a12 beq_else.35635 # nontail if
	jal %zero beq_cont.35636 # then sentence ends
beq_else.35635:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35637 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35638 # then sentence ends
beq_else.35637:
	addi %a0 %zero 0 #105
beq_cont.35638:
beq_cont.35636:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35639 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.35640 # then sentence ends
beq_else.35639:
	addi %a0 %zero 0 #1168
beq_cont.35640:
	jal %zero beq_cont.35634 # then sentence ends
beq_else.35633:
	add %a0 %a3 %zero
	fadd %f2 %f5 %fzero
	fadd %f1 %f4 %fzero
	fadd %f0 %f3 %fzero
	sw %ra %sp 76 #1189 call dir
	addi %sp %sp 80 #1189	
	jal %ra is_second_outside.2496 #1189
	addi %sp %sp -80 #1189
	lw %ra %sp 76 #1189
beq_cont.35634:
beq_cont.35623:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35641
	lw %a0 %sp 40 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35642
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.35642:
	slli %a1 %a1 2 #20
	lw %a3 %sp 32 #20
	add %a12 %a3 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 24 #1198
	lw %f1 %sp 16 #1198
	lw %f2 %sp 8 #1198
	sw %a0 %sp 72 #1198
	add %a0 %a1 %zero
	sw %ra %sp 76 #1198 call dir
	addi %sp %sp 80 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -80 #1198
	lw %ra %sp 76 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35643
	lw %a0 %sp 72 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35644
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.35644:
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
	sw %a0 %sp 76 #868
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.35645 # nontail if
	sw %f4 %sp 80 #1157
	sw %f2 %sp 88 #1157
	sw %a1 %sp 96 #1157
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
	bne %a0 %a12 beq_else.35647 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35648 # then sentence ends
beq_else.35647:
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
	bne %a0 %a12 beq_else.35649 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35650 # then sentence ends
beq_else.35649:
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
beq_cont.35650:
beq_cont.35648:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35651 # nontail if
	lw %a0 %sp 96 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35653 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.35654 # then sentence ends
beq_else.35653:
	addi %a0 %zero 0 #1156
beq_cont.35654:
	jal %zero beq_cont.35652 # then sentence ends
beq_else.35651:
	lw %a0 %sp 96 #258
	lw %a0 %a0 24 #258
beq_cont.35652:
	jal %zero beq_cont.35646 # then sentence ends
beq_else.35645:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.35655 # nontail if
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
	sw %a1 %sp 100 #1168
	sw %ra %sp 108 #1168 call dir
	addi %sp %sp 112 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -112 #1168
	lw %ra %sp 108 #1168
	lw %a1 %sp 100 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35657 # nontail if
	jal %zero beq_cont.35658 # then sentence ends
beq_else.35657:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35659 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35660 # then sentence ends
beq_else.35659:
	addi %a0 %zero 0 #105
beq_cont.35660:
beq_cont.35658:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35661 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.35662 # then sentence ends
beq_else.35661:
	addi %a0 %zero 0 #1168
beq_cont.35662:
	jal %zero beq_cont.35656 # then sentence ends
beq_else.35655:
	add %a0 %a1 %zero
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 108 #1189 call dir
	addi %sp %sp 112 #1189	
	jal %ra is_second_outside.2496 #1189
	addi %sp %sp -112 #1189
	lw %ra %sp 108 #1189
beq_cont.35656:
beq_cont.35646:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35663
	lw %a0 %sp 76 #1201
	addi %a0 %a0 1 #1201
	slli %a1 %a0 2 #1194
	lw %a2 %sp 36 #1194
	add %a12 %a2 %a1 #1194
	lw %a1 %a12 0 #1194
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35664
	addi %a0 %zero 1 #1196
	jalr %zero %ra 0 #1196
beq_else.35664:
	slli %a1 %a1 2 #20
	lw %a3 %sp 32 #20
	add %a12 %a3 %a1 #20
	lw %a1 %a12 0 #20
	lw %f0 %sp 24 #1198
	lw %f1 %sp 16 #1198
	lw %f2 %sp 8 #1198
	sw %a0 %sp 104 #1198
	add %a0 %a1 %zero
	sw %ra %sp 108 #1198 call dir
	addi %sp %sp 112 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -112 #1198
	lw %ra %sp 108 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35665
	lw %a0 %sp 104 #1201
	addi %a0 %a0 1 #1201
	lw %f0 %sp 24 #1201
	lw %f1 %sp 16 #1201
	lw %f2 %sp 8 #1201
	lw %a1 %sp 36 #1201
	lw %a11 %sp 0 #1201
	lw %a10 %a11 0 #1201
	jalr %zero %a10 0 #1201
beq_else.35665:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
beq_else.35663:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
beq_else.35643:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
beq_else.35641:
	addi %a0 %zero 0 #1198
	jalr %zero %ra 0 #1198
shadow_check_and_group.2512:
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
	bne %a10 %a12 beq_else.35666
	addi %a0 %zero 0 #1213
	jalr %zero %ra 0 #1213
beq_else.35666:
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
	bne %a9 %a12 beq_else.35667 # nontail if
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
	jal %zero beq_cont.35668 # then sentence ends
beq_else.35667:
	addi %a12 %zero 2
	bne %a9 %a12 beq_else.35669 # nontail if
	lw %f3 %a1 0 #934
	sw %f2 %sp 40 #934
	sw %f1 %sp 48 #934
	sw %f0 %sp 56 #934
	sw %a1 %sp 64 #934
	fadd %f0 %f3 %fzero
	sw %ra %sp 68 #934 call dir
	addi %sp %sp 72 #934	
	jal %ra min_caml_fisneg #934
	addi %sp %sp -72 #934
	lw %ra %sp 68 #934
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35672 # nontail if
	addi %a0 %zero 0 #934
	jal %zero beq_cont.35673 # then sentence ends
beq_else.35672:
	lw %a0 %sp 64 #934
	lw %f0 %a0 4 #934
	lw %f1 %sp 56 #936
	fmul %f0 %f0 %f1 #936
	lw %f1 %a0 8 #934
	lw %f2 %sp 48 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %f1 %a0 12 #934
	lw %f2 %sp 40 #936
	fmul %f1 %f1 %f2 #936
	fadd %f0 %f0 %f1 #936
	lw %a0 %sp 32 #935
	sw %f0 %a0 0 #935
	addi %a0 %zero 1 #937
beq_cont.35673:
	jal %zero beq_cont.35670 # then sentence ends
beq_else.35669:
	add %a0 %a7 %zero
	add %a11 %a3 %zero
	sw %ra %sp 68 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 72 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -72 #975
	lw %ra %sp 68 #975
beq_cont.35670:
beq_cont.35668:
	lw %a1 %sp 32 #37
	lw %f0 %a1 0 #37
	sw %f0 %sp 72 #909
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35675 # nontail if
	addi %a0 %zero 0 #1218
	jal %zero beq_cont.35676 # then sentence ends
beq_else.35675:
	li %f1 l.28264 #1218
	sw %ra %sp 84 #1218 call dir
	addi %sp %sp 88 #1218	
	jal %ra min_caml_fless #1218
	addi %sp %sp -88 #1218
	lw %ra %sp 84 #1218
beq_cont.35676:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35677
	lw %a0 %sp 28 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 24 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35678
	addi %a0 %zero 0 #1218
	jalr %zero %ra 0 #1218
beq_else.35678:
	lw %a0 %sp 20 #1235
	addi %a0 %a0 1 #1235
	lw %a1 %sp 8 #1235
	lw %a11 %sp 16 #1235
	lw %a10 %a11 0 #1235
	jalr %zero %a10 0 #1235
beq_else.35677:
	li %f0 l.28266 #1221
	lw %f1 %sp 72 #1221
	fadd %f0 %f1 %f0 #1221
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
	bne %a0 %a12 beq_else.35679 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35680 # then sentence ends
beq_else.35679:
	slli %a0 %a0 2 #20
	lw %a2 %sp 24 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	sw %f0 %sp 80 #1198
	sw %f2 %sp 88 #1198
	sw %f1 %sp 96 #1198
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 108 #1198 call dir
	addi %sp %sp 112 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -112 #1198
	lw %ra %sp 108 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35681 # nontail if
	lw %a1 %sp 8 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35683 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35684 # then sentence ends
beq_else.35683:
	slli %a0 %a0 2 #20
	lw %a2 %sp 24 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 96 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a0 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 88 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a0 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 80 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.35685 # nontail if
	sw %f4 %sp 104 #1157
	sw %f2 %sp 112 #1157
	sw %a0 %sp 120 #1157
	sw %ra %sp 124 #1157 call dir
	addi %sp %sp 128 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -128 #1157
	lw %ra %sp 124 #1157
	lw %a0 %sp 120 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 124 #1157 call dir
	addi %sp %sp 128 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -128 #1157
	lw %ra %sp 124 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35687 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35688 # then sentence ends
beq_else.35687:
	lw %f0 %sp 112 #1158
	sw %ra %sp 124 #1158 call dir
	addi %sp %sp 128 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -128 #1158
	lw %ra %sp 124 #1158
	lw %a0 %sp 120 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 124 #1158 call dir
	addi %sp %sp 128 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -128 #1158
	lw %ra %sp 124 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35689 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35690 # then sentence ends
beq_else.35689:
	lw %f0 %sp 104 #1159
	sw %ra %sp 124 #1159 call dir
	addi %sp %sp 128 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -128 #1159
	lw %ra %sp 124 #1159
	lw %a0 %sp 120 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 124 #1159 call dir
	addi %sp %sp 128 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -128 #1159
	lw %ra %sp 124 #1159
beq_cont.35690:
beq_cont.35688:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35691 # nontail if
	lw %a0 %sp 120 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35693 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.35694 # then sentence ends
beq_else.35693:
	addi %a0 %zero 0 #1156
beq_cont.35694:
	jal %zero beq_cont.35692 # then sentence ends
beq_else.35691:
	lw %a0 %sp 120 #258
	lw %a0 %a0 24 #258
beq_cont.35692:
	jal %zero beq_cont.35686 # then sentence ends
beq_else.35685:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.35695 # nontail if
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
	sw %a0 %sp 124 #1168
	sw %ra %sp 132 #1168 call dir
	addi %sp %sp 136 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -136 #1168
	lw %ra %sp 132 #1168
	lw %a1 %sp 124 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35697 # nontail if
	jal %zero beq_cont.35698 # then sentence ends
beq_else.35697:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35699 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35700 # then sentence ends
beq_else.35699:
	addi %a0 %zero 0 #105
beq_cont.35700:
beq_cont.35698:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35701 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.35702 # then sentence ends
beq_else.35701:
	addi %a0 %zero 0 #1168
beq_cont.35702:
	jal %zero beq_cont.35696 # then sentence ends
beq_else.35695:
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 132 #1189 call dir
	addi %sp %sp 136 #1189	
	jal %ra is_second_outside.2496 #1189
	addi %sp %sp -136 #1189
	lw %ra %sp 132 #1189
beq_cont.35696:
beq_cont.35686:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35703 # nontail if
	lw %a1 %sp 8 #1194
	lw %a0 %a1 8 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35705 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35706 # then sentence ends
beq_else.35705:
	slli %a0 %a0 2 #20
	lw %a2 %sp 24 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 96 #1198
	lw %f1 %sp 88 #1198
	lw %f2 %sp 80 #1198
	sw %ra %sp 132 #1198 call dir
	addi %sp %sp 136 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -136 #1198
	lw %ra %sp 132 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35707 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 96 #1201
	lw %f1 %sp 88 #1201
	lw %f2 %sp 80 #1201
	lw %a1 %sp 8 #1201
	lw %a11 %sp 0 #1201
	sw %ra %sp 132 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 136 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -136 #1201
	lw %ra %sp 132 #1201
	jal %zero beq_cont.35708 # then sentence ends
beq_else.35707:
	addi %a0 %zero 0 #1198
beq_cont.35708:
beq_cont.35706:
	jal %zero beq_cont.35704 # then sentence ends
beq_else.35703:
	addi %a0 %zero 0 #1198
beq_cont.35704:
beq_cont.35684:
	jal %zero beq_cont.35682 # then sentence ends
beq_else.35681:
	addi %a0 %zero 0 #1198
beq_cont.35682:
beq_cont.35680:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35709
	lw %a0 %sp 20 #1228
	addi %a0 %a0 1 #1228
	lw %a1 %sp 8 #1228
	lw %a11 %sp 16 #1228
	lw %a10 %a11 0 #1228
	jalr %zero %a10 0 #1228
beq_else.35709:
	addi %a0 %zero 1 #1226
	jalr %zero %ra 0 #1226
shadow_check_one_or_group.2515:
	lw %a2 %a11 8 #1241
	lw %a3 %a11 4 #1241
	slli %a4 %a0 2 #1242
	add %a12 %a1 %a4 #1242
	lw %a4 %a12 0 #1242
	addi %a12 %zero -1
	bne %a4 %a12 beq_else.35710
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.35710:
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
	bne %a0 %a12 beq_else.35711
	lw %a0 %sp 16 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35712
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.35712:
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
	bne %a0 %a12 beq_else.35713
	lw %a0 %sp 20 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35714
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.35714:
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
	bne %a0 %a12 beq_else.35715
	lw %a0 %sp 24 #1251
	addi %a0 %a0 1 #1251
	slli %a1 %a0 2 #1242
	lw %a2 %sp 12 #1242
	add %a12 %a2 %a1 #1242
	lw %a1 %a12 0 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35716
	addi %a0 %zero 0 #1244
	jalr %zero %ra 0 #1244
beq_else.35716:
	slli %a1 %a1 2 #31
	lw %a3 %sp 8 #31
	add %a12 %a3 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 4 #1247
	sw %a0 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 36 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 40 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -40 #1247
	lw %ra %sp 36 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35717
	lw %a0 %sp 28 #1251
	addi %a0 %a0 1 #1251
	lw %a1 %sp 12 #1251
	lw %a11 %sp 0 #1251
	lw %a10 %a11 0 #1251
	jalr %zero %a10 0 #1251
beq_else.35717:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.35715:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.35713:
	addi %a0 %zero 1 #1249
	jalr %zero %ra 0 #1249
beq_else.35711:
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
	bne %a1 %a12 beq_else.35718
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.35718:
	sw %a0 %sp 20 #1259
	sw %a7 %sp 24 #1259
	sw %a8 %sp 28 #1259
	sw %a11 %sp 32 #1259
	sw %a6 %sp 36 #1259
	sw %a10 %sp 40 #1259
	addi %a12 %zero 99
	bne %a1 %a12 beq_else.35719 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.35720 # then sentence ends
beq_else.35719:
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
	bne %a5 %a12 beq_else.35721 # nontail if
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
	jal %zero beq_cont.35722 # then sentence ends
beq_else.35721:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.35723 # nontail if
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
	bne %a0 %a12 beq_else.35726 # nontail if
	addi %a0 %zero 0 #934
	jal %zero beq_cont.35727 # then sentence ends
beq_else.35726:
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
beq_cont.35727:
	jal %zero beq_cont.35724 # then sentence ends
beq_else.35723:
	add %a0 %a7 %zero
	add %a11 %a3 %zero
	sw %ra %sp 76 #975 call cls
	lw %a10 %a11 0 #975
	addi %sp %sp 80 #975	
	jalr %ra %a10 0 #975
	addi %sp %sp -80 #975
	lw %ra %sp 76 #975
beq_cont.35724:
beq_cont.35722:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35728 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35729 # then sentence ends
beq_else.35728:
	lw %a0 %sp 36 #37
	lw %f0 %a0 0 #37
	li %f1 l.28314 #1270
	sw %ra %sp 76 #1270 call dir
	addi %sp %sp 80 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -80 #1270
	lw %ra %sp 76 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35730 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35731 # then sentence ends
beq_else.35730:
	lw %a0 %sp 20 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35732 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35733 # then sentence ends
beq_else.35732:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35734 # nontail if
	lw %a0 %sp 20 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35736 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35737 # then sentence ends
beq_else.35736:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35738 # nontail if
	lw %a0 %sp 20 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35740 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35741 # then sentence ends
beq_else.35740:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 76 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 80 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -80 #1247
	lw %ra %sp 76 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35742 # nontail if
	addi %a0 %zero 4 #1251
	lw %a1 %sp 20 #1251
	lw %a11 %sp 24 #1251
	sw %ra %sp 76 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 80 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -80 #1251
	lw %ra %sp 76 #1251
	jal %zero beq_cont.35743 # then sentence ends
beq_else.35742:
	addi %a0 %zero 1 #1249
beq_cont.35743:
beq_cont.35741:
	jal %zero beq_cont.35739 # then sentence ends
beq_else.35738:
	addi %a0 %zero 1 #1249
beq_cont.35739:
beq_cont.35737:
	jal %zero beq_cont.35735 # then sentence ends
beq_else.35734:
	addi %a0 %zero 1 #1249
beq_cont.35735:
beq_cont.35733:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35744 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35745 # then sentence ends
beq_else.35744:
	addi %a0 %zero 1 #1272
beq_cont.35745:
beq_cont.35731:
beq_cont.35729:
beq_cont.35720:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35746
	lw %a0 %sp 12 #1282
	addi %a0 %a0 1 #1282
	slli %a1 %a0 2 #1257
	lw %a2 %sp 16 #1257
	add %a12 %a2 %a1 #1257
	lw %a1 %a12 0 #1257
	lw %a3 %a1 0 #1258
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.35747
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.35747:
	sw %a1 %sp 76 #1259
	sw %a0 %sp 80 #1259
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.35748 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.35749 # then sentence ends
beq_else.35748:
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
	bne %a0 %a12 beq_else.35750 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35751 # then sentence ends
beq_else.35750:
	lw %a0 %sp 36 #37
	lw %f0 %a0 0 #37
	li %f1 l.28314 #1270
	sw %ra %sp 84 #1270 call dir
	addi %sp %sp 88 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -88 #1270
	lw %ra %sp 84 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35752 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35753 # then sentence ends
beq_else.35752:
	lw %a0 %sp 76 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35754 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35755 # then sentence ends
beq_else.35754:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35756 # nontail if
	lw %a0 %sp 76 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35758 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35759 # then sentence ends
beq_else.35758:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35760 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 76 #1251
	lw %a11 %sp 24 #1251
	sw %ra %sp 84 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 88 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -88 #1251
	lw %ra %sp 84 #1251
	jal %zero beq_cont.35761 # then sentence ends
beq_else.35760:
	addi %a0 %zero 1 #1249
beq_cont.35761:
beq_cont.35759:
	jal %zero beq_cont.35757 # then sentence ends
beq_else.35756:
	addi %a0 %zero 1 #1249
beq_cont.35757:
beq_cont.35755:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35762 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35763 # then sentence ends
beq_else.35762:
	addi %a0 %zero 1 #1272
beq_cont.35763:
beq_cont.35753:
beq_cont.35751:
beq_cont.35749:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35764
	lw %a0 %sp 80 #1282
	addi %a0 %a0 1 #1282
	lw %a1 %sp 16 #1282
	lw %a11 %sp 8 #1282
	lw %a10 %a11 0 #1282
	jalr %zero %a10 0 #1282
beq_else.35764:
	lw %a0 %sp 76 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35765 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35766 # then sentence ends
beq_else.35765:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35767 # nontail if
	lw %a0 %sp 76 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35769 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35770 # then sentence ends
beq_else.35769:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a2 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35771 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 76 #1251
	lw %a11 %sp 24 #1251
	sw %ra %sp 84 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 88 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -88 #1251
	lw %ra %sp 84 #1251
	jal %zero beq_cont.35772 # then sentence ends
beq_else.35771:
	addi %a0 %zero 1 #1249
beq_cont.35772:
beq_cont.35770:
	jal %zero beq_cont.35768 # then sentence ends
beq_else.35767:
	addi %a0 %zero 1 #1249
beq_cont.35768:
beq_cont.35766:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35773
	lw %a0 %sp 80 #1280
	addi %a0 %a0 1 #1280
	lw %a1 %sp 16 #1280
	lw %a11 %sp 8 #1280
	lw %a10 %a11 0 #1280
	jalr %zero %a10 0 #1280
beq_else.35773:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
beq_else.35746:
	lw %a0 %sp 20 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35774 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35775 # then sentence ends
beq_else.35774:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35776 # nontail if
	lw %a0 %sp 20 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35778 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35779 # then sentence ends
beq_else.35778:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35780 # nontail if
	lw %a0 %sp 20 #1242
	lw %a1 %a0 12 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35782 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35783 # then sentence ends
beq_else.35782:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 84 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 88 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -88 #1247
	lw %ra %sp 84 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35784 # nontail if
	addi %a0 %zero 4 #1251
	lw %a1 %sp 20 #1251
	lw %a11 %sp 24 #1251
	sw %ra %sp 84 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 88 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -88 #1251
	lw %ra %sp 84 #1251
	jal %zero beq_cont.35785 # then sentence ends
beq_else.35784:
	addi %a0 %zero 1 #1249
beq_cont.35785:
beq_cont.35783:
	jal %zero beq_cont.35781 # then sentence ends
beq_else.35780:
	addi %a0 %zero 1 #1249
beq_cont.35781:
beq_cont.35779:
	jal %zero beq_cont.35777 # then sentence ends
beq_else.35776:
	addi %a0 %zero 1 #1249
beq_cont.35777:
beq_cont.35775:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35786
	lw %a0 %sp 12 #1280
	addi %a0 %a0 1 #1280
	slli %a1 %a0 2 #1257
	lw %a2 %sp 16 #1257
	add %a12 %a2 %a1 #1257
	lw %a1 %a12 0 #1257
	lw %a3 %a1 0 #1258
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.35787
	addi %a0 %zero 0 #1260
	jalr %zero %ra 0 #1260
beq_else.35787:
	sw %a1 %sp 84 #1259
	sw %a0 %sp 88 #1259
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.35788 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.35789 # then sentence ends
beq_else.35788:
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
	bne %a0 %a12 beq_else.35790 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35791 # then sentence ends
beq_else.35790:
	lw %a0 %sp 36 #37
	lw %f0 %a0 0 #37
	li %f1 l.28314 #1270
	sw %ra %sp 92 #1270 call dir
	addi %sp %sp 96 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -96 #1270
	lw %ra %sp 92 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35792 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35793 # then sentence ends
beq_else.35792:
	lw %a0 %sp 84 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35794 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35795 # then sentence ends
beq_else.35794:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 92 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 96 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -96 #1247
	lw %ra %sp 92 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35796 # nontail if
	lw %a0 %sp 84 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35798 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35799 # then sentence ends
beq_else.35798:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 92 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 96 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -96 #1247
	lw %ra %sp 92 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35800 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 84 #1251
	lw %a11 %sp 24 #1251
	sw %ra %sp 92 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 96 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -96 #1251
	lw %ra %sp 92 #1251
	jal %zero beq_cont.35801 # then sentence ends
beq_else.35800:
	addi %a0 %zero 1 #1249
beq_cont.35801:
beq_cont.35799:
	jal %zero beq_cont.35797 # then sentence ends
beq_else.35796:
	addi %a0 %zero 1 #1249
beq_cont.35797:
beq_cont.35795:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35802 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.35803 # then sentence ends
beq_else.35802:
	addi %a0 %zero 1 #1272
beq_cont.35803:
beq_cont.35793:
beq_cont.35791:
beq_cont.35789:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35804
	lw %a0 %sp 88 #1282
	addi %a0 %a0 1 #1282
	lw %a1 %sp 16 #1282
	lw %a11 %sp 8 #1282
	lw %a10 %a11 0 #1282
	jalr %zero %a10 0 #1282
beq_else.35804:
	lw %a0 %sp 84 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35805 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35806 # then sentence ends
beq_else.35805:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a3 %zero
	sw %ra %sp 92 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 96 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -96 #1247
	lw %ra %sp 92 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35807 # nontail if
	lw %a0 %sp 84 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35809 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.35810 # then sentence ends
beq_else.35809:
	slli %a1 %a1 2 #31
	lw %a2 %sp 32 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1247
	lw %a11 %sp 28 #1247
	add %a0 %a2 %zero
	sw %ra %sp 92 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 96 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -96 #1247
	lw %ra %sp 92 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35811 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 84 #1251
	lw %a11 %sp 24 #1251
	sw %ra %sp 92 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 96 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -96 #1251
	lw %ra %sp 92 #1251
	jal %zero beq_cont.35812 # then sentence ends
beq_else.35811:
	addi %a0 %zero 1 #1249
beq_cont.35812:
beq_cont.35810:
	jal %zero beq_cont.35808 # then sentence ends
beq_else.35807:
	addi %a0 %zero 1 #1249
beq_cont.35808:
beq_cont.35806:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35813
	lw %a0 %sp 88 #1280
	addi %a0 %a0 1 #1280
	lw %a1 %sp 16 #1280
	lw %a11 %sp 8 #1280
	lw %a10 %a11 0 #1280
	jalr %zero %a10 0 #1280
beq_else.35813:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
beq_else.35786:
	addi %a0 %zero 1 #1278
	jalr %zero %ra 0 #1278
solve_each_element.2521:
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
	bne %a10 %a12 beq_else.35814
	jalr %zero %ra 0 #1292
beq_else.35814:
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
	bne %a3 %a12 beq_else.35816 # nontail if
	add %a1 %a2 %zero
	add %a0 %a9 %zero
	add %a11 %a6 %zero
	sw %ra %sp 52 #891 call cls
	lw %a10 %a11 0 #891
	addi %sp %sp 56 #891	
	jalr %ra %a10 0 #891
	addi %sp %sp -56 #891
	lw %ra %sp 52 #891
	jal %zero beq_cont.35817 # then sentence ends
beq_else.35816:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.35818 # nontail if
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
	bne %a0 %a12 beq_else.35821 # nontail if
	addi %a0 %zero 0 #811
	jal %zero beq_cont.35822 # then sentence ends
beq_else.35821:
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
beq_cont.35822:
	jal %zero beq_cont.35819 # then sentence ends
beq_else.35818:
	add %a1 %a2 %zero
	add %a0 %a9 %zero
	add %a11 %a5 %zero
	sw %ra %sp 92 #893 call cls
	lw %a10 %a11 0 #893
	addi %sp %sp 96 #893	
	jalr %ra %a10 0 #893
	addi %sp %sp -96 #893
	lw %ra %sp 92 #893
beq_cont.35819:
beq_cont.35817:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35823
	lw %a0 %sp 48 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 44 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35824
	jalr %zero %ra 0 #1325
beq_else.35824:
	lw %a0 %sp 40 #1324
	addi %a0 %a0 1 #1324
	lw %a1 %sp 32 #1324
	lw %a2 %sp 28 #1324
	lw %a11 %sp 36 #1324
	lw %a10 %a11 0 #1324
	jalr %zero %a10 0 #1324
beq_else.35823:
	lw %a1 %sp 24 #37
	lw %f1 %a1 0 #37
	li %f0 l.27725 #1301
	sw %a0 %sp 92 #1301
	sw %f1 %sp 96 #1301
	sw %ra %sp 108 #1301 call dir
	addi %sp %sp 112 #1301	
	jal %ra min_caml_fless #1301
	addi %sp %sp -112 #1301
	lw %ra %sp 108 #1301
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35826 # nontail if
	jal %zero beq_cont.35827 # then sentence ends
beq_else.35826:
	lw %a0 %sp 16 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 96 #1302
	sw %ra %sp 108 #1302 call dir
	addi %sp %sp 112 #1302	
	jal %ra min_caml_fless #1302
	addi %sp %sp -112 #1302
	lw %ra %sp 108 #1302
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35828 # nontail if
	jal %zero beq_cont.35829 # then sentence ends
beq_else.35828:
	li %f0 l.28266 #1304
	lw %f1 %sp 96 #1304
	fadd %f0 %f1 %f0 #1304
	lw %a2 %sp 28 #783
	lw %f1 %a2 0 #783
	fmul %f1 %f1 %f0 #1305
	lw %a0 %sp 20 #64
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
	lw %a1 %sp 32 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 104 #1195
	sw %f2 %sp 112 #1195
	sw %f1 %sp 120 #1195
	sw %f0 %sp 128 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35830 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35831 # then sentence ends
beq_else.35830:
	slli %a0 %a0 2 #20
	lw %a3 %sp 44 #20
	add %a12 %a3 %a0 #20
	lw %a0 %a12 0 #20
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 140 #1198 call dir
	addi %sp %sp 144 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -144 #1198
	lw %ra %sp 140 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35832 # nontail if
	lw %a1 %sp 32 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35834 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35835 # then sentence ends
beq_else.35834:
	slli %a0 %a0 2 #20
	lw %a2 %sp 44 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 120 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a0 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 112 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a0 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 104 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.35836 # nontail if
	sw %f4 %sp 136 #1157
	sw %f2 %sp 144 #1157
	sw %a0 %sp 152 #1157
	sw %ra %sp 156 #1157 call dir
	addi %sp %sp 160 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -160 #1157
	lw %ra %sp 156 #1157
	lw %a0 %sp 152 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 156 #1157 call dir
	addi %sp %sp 160 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -160 #1157
	lw %ra %sp 156 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35838 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35839 # then sentence ends
beq_else.35838:
	lw %f0 %sp 144 #1158
	sw %ra %sp 156 #1158 call dir
	addi %sp %sp 160 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -160 #1158
	lw %ra %sp 156 #1158
	lw %a0 %sp 152 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 156 #1158 call dir
	addi %sp %sp 160 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -160 #1158
	lw %ra %sp 156 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35840 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35841 # then sentence ends
beq_else.35840:
	lw %f0 %sp 136 #1159
	sw %ra %sp 156 #1159 call dir
	addi %sp %sp 160 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -160 #1159
	lw %ra %sp 156 #1159
	lw %a0 %sp 152 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 156 #1159 call dir
	addi %sp %sp 160 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -160 #1159
	lw %ra %sp 156 #1159
beq_cont.35841:
beq_cont.35839:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35842 # nontail if
	lw %a0 %sp 152 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35844 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.35845 # then sentence ends
beq_else.35844:
	addi %a0 %zero 0 #1156
beq_cont.35845:
	jal %zero beq_cont.35843 # then sentence ends
beq_else.35842:
	lw %a0 %sp 152 #258
	lw %a0 %a0 24 #258
beq_cont.35843:
	jal %zero beq_cont.35837 # then sentence ends
beq_else.35836:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.35846 # nontail if
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
	sw %a0 %sp 156 #1168
	sw %ra %sp 164 #1168 call dir
	addi %sp %sp 168 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -168 #1168
	lw %ra %sp 164 #1168
	lw %a1 %sp 156 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35848 # nontail if
	jal %zero beq_cont.35849 # then sentence ends
beq_else.35848:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35850 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35851 # then sentence ends
beq_else.35850:
	addi %a0 %zero 0 #105
beq_cont.35851:
beq_cont.35849:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35852 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.35853 # then sentence ends
beq_else.35852:
	addi %a0 %zero 0 #1168
beq_cont.35853:
	jal %zero beq_cont.35847 # then sentence ends
beq_else.35846:
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 164 #1189 call dir
	addi %sp %sp 168 #1189	
	jal %ra is_second_outside.2496 #1189
	addi %sp %sp -168 #1189
	lw %ra %sp 164 #1189
beq_cont.35847:
beq_cont.35837:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35854 # nontail if
	lw %a1 %sp 32 #1194
	lw %a0 %a1 8 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35856 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35857 # then sentence ends
beq_else.35856:
	slli %a0 %a0 2 #20
	lw %a2 %sp 44 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 120 #1198
	lw %f1 %sp 112 #1198
	lw %f2 %sp 104 #1198
	sw %ra %sp 164 #1198 call dir
	addi %sp %sp 168 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -168 #1198
	lw %ra %sp 164 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35858 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 120 #1201
	lw %f1 %sp 112 #1201
	lw %f2 %sp 104 #1201
	lw %a1 %sp 32 #1201
	lw %a11 %sp 12 #1201
	sw %ra %sp 164 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 168 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -168 #1201
	lw %ra %sp 164 #1201
	jal %zero beq_cont.35859 # then sentence ends
beq_else.35858:
	addi %a0 %zero 0 #1198
beq_cont.35859:
beq_cont.35857:
	jal %zero beq_cont.35855 # then sentence ends
beq_else.35854:
	addi %a0 %zero 0 #1198
beq_cont.35855:
beq_cont.35835:
	jal %zero beq_cont.35833 # then sentence ends
beq_else.35832:
	addi %a0 %zero 0 #1198
beq_cont.35833:
beq_cont.35831:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35860 # nontail if
	jal %zero beq_cont.35861 # then sentence ends
beq_else.35860:
	lw %a0 %sp 16 #1310
	lw %f0 %sp 128 #1310
	sw %f0 %a0 0 #1310
	lw %a0 %sp 8 #133
	lw %f0 %sp 120 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 112 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 104 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1312
	lw %a1 %sp 48 #1312
	sw %a1 %a0 0 #1312
	lw %a0 %sp 0 #1313
	lw %a1 %sp 92 #1313
	sw %a1 %a0 0 #1313
beq_cont.35861:
beq_cont.35829:
beq_cont.35827:
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
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.35862
	jalr %zero %ra 0 #1337
beq_else.35862:
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
	bne %a1 %a12 beq_else.35864
	jalr %zero %ra 0 #1337
beq_else.35864:
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
	bne %a1 %a12 beq_else.35866
	jalr %zero %ra 0 #1337
beq_else.35866:
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
	bne %a1 %a12 beq_else.35868
	jalr %zero %ra 0 #1337
beq_else.35868:
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
	bne %a1 %a12 beq_else.35870
	jalr %zero %ra 0 #1337
beq_else.35870:
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
	bne %a1 %a12 beq_else.35872
	jalr %zero %ra 0 #1337
beq_else.35872:
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
	bne %a1 %a12 beq_else.35874
	jalr %zero %ra 0 #1337
beq_else.35874:
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
	bne %a1 %a12 beq_else.35876
	jalr %zero %ra 0 #1337
beq_else.35876:
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
	bne %a1 %a12 beq_else.35878
	jalr %zero %ra 0 #1345
beq_else.35878:
	sw %a3 %sp 16 #1344
	sw %a7 %sp 20 #1344
	sw %a4 %sp 24 #1344
	sw %a9 %sp 28 #1344
	sw %a2 %sp 32 #1344
	sw %a10 %sp 36 #1344
	sw %a11 %sp 40 #1344
	addi %a12 %zero 99
	bne %a1 %a12 beq_else.35880 # nontail if
	lw %a1 %a0 4 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35882 # nontail if
	jal %zero beq_cont.35883 # then sentence ends
beq_else.35882:
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
	bne %a1 %a12 beq_else.35884 # nontail if
	jal %zero beq_cont.35885 # then sentence ends
beq_else.35884:
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
	bne %a1 %a12 beq_else.35886 # nontail if
	jal %zero beq_cont.35887 # then sentence ends
beq_else.35886:
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
	bne %a1 %a12 beq_else.35888 # nontail if
	jal %zero beq_cont.35889 # then sentence ends
beq_else.35888:
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
	bne %a1 %a12 beq_else.35890 # nontail if
	jal %zero beq_cont.35891 # then sentence ends
beq_else.35890:
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
	bne %a1 %a12 beq_else.35892 # nontail if
	jal %zero beq_cont.35893 # then sentence ends
beq_else.35892:
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
	bne %a1 %a12 beq_else.35894 # nontail if
	jal %zero beq_cont.35895 # then sentence ends
beq_else.35894:
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
beq_cont.35895:
beq_cont.35893:
beq_cont.35891:
beq_cont.35889:
beq_cont.35887:
beq_cont.35885:
beq_cont.35883:
	jal %zero beq_cont.35881 # then sentence ends
beq_else.35880:
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
	bne %a8 %a12 beq_else.35896 # nontail if
	add %a0 %a1 %zero
	add %a11 %a6 %zero
	add %a1 %a2 %zero
	sw %ra %sp 52 #891 call cls
	lw %a10 %a11 0 #891
	addi %sp %sp 56 #891	
	jalr %ra %a10 0 #891
	addi %sp %sp -56 #891
	lw %ra %sp 52 #891
	jal %zero beq_cont.35897 # then sentence ends
beq_else.35896:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.35898 # nontail if
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
	bne %a0 %a12 beq_else.35900 # nontail if
	addi %a0 %zero 0 #811
	jal %zero beq_cont.35901 # then sentence ends
beq_else.35900:
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
beq_cont.35901:
	jal %zero beq_cont.35899 # then sentence ends
beq_else.35898:
	add %a0 %a1 %zero
	add %a11 %a5 %zero
	add %a1 %a2 %zero
	sw %ra %sp 84 #893 call cls
	lw %a10 %a11 0 #893
	addi %sp %sp 88 #893	
	jalr %ra %a10 0 #893
	addi %sp %sp -88 #893
	lw %ra %sp 84 #893
beq_cont.35899:
beq_cont.35897:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35902 # nontail if
	jal %zero beq_cont.35903 # then sentence ends
beq_else.35902:
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
	bne %a0 %a12 beq_else.35904 # nontail if
	jal %zero beq_cont.35905 # then sentence ends
beq_else.35904:
	lw %a0 %sp 44 #1332
	lw %a1 %a0 4 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35906 # nontail if
	jal %zero beq_cont.35907 # then sentence ends
beq_else.35906:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 8 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35908 # nontail if
	jal %zero beq_cont.35909 # then sentence ends
beq_else.35908:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 12 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35910 # nontail if
	jal %zero beq_cont.35911 # then sentence ends
beq_else.35910:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 16 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35912 # nontail if
	jal %zero beq_cont.35913 # then sentence ends
beq_else.35912:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 20 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35914 # nontail if
	jal %zero beq_cont.35915 # then sentence ends
beq_else.35914:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 24 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35916 # nontail if
	jal %zero beq_cont.35917 # then sentence ends
beq_else.35916:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	lw %a0 %sp 44 #1332
	lw %a1 %a0 28 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35918 # nontail if
	jal %zero beq_cont.35919 # then sentence ends
beq_else.35918:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 84 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 88 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -88 #1335
	lw %ra %sp 84 #1335
	addi %a0 %zero 8 #1336
	lw %a1 %sp 44 #1336
	lw %a2 %sp 32 #1336
	lw %a11 %sp 28 #1336
	sw %ra %sp 84 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 88 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -88 #1336
	lw %ra %sp 84 #1336
beq_cont.35919:
beq_cont.35917:
beq_cont.35915:
beq_cont.35913:
beq_cont.35911:
beq_cont.35909:
beq_cont.35907:
beq_cont.35905:
beq_cont.35903:
beq_cont.35881:
	lw %a0 %sp 8 #1360
	addi %a0 %a0 1 #1360
	slli %a1 %a0 2 #1342
	lw %a2 %sp 12 #1342
	add %a12 %a2 %a1 #1342
	lw %a1 %a12 0 #1342
	lw %a3 %a1 0 #1343
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.35920
	jalr %zero %ra 0 #1345
beq_else.35920:
	sw %a0 %sp 84 #1344
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.35922 # nontail if
	lw %a3 %a1 4 #1332
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.35924 # nontail if
	jal %zero beq_cont.35925 # then sentence ends
beq_else.35924:
	slli %a3 %a3 2 #31
	lw %a4 %sp 40 #31
	add %a12 %a4 %a3 #31
	lw %a3 %a12 0 #31
	addi %a5 %zero 0 #1335
	lw %a6 %sp 32 #1335
	lw %a11 %sp 36 #1335
	sw %a1 %sp 88 #1335
	add %a2 %a6 %zero
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 8 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35926 # nontail if
	jal %zero beq_cont.35927 # then sentence ends
beq_else.35926:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 12 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35928 # nontail if
	jal %zero beq_cont.35929 # then sentence ends
beq_else.35928:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 16 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35930 # nontail if
	jal %zero beq_cont.35931 # then sentence ends
beq_else.35930:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 20 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35932 # nontail if
	jal %zero beq_cont.35933 # then sentence ends
beq_else.35932:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 24 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35934 # nontail if
	jal %zero beq_cont.35935 # then sentence ends
beq_else.35934:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1335
	lw %a3 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	addi %a0 %zero 7 #1336
	lw %a1 %sp 88 #1336
	lw %a2 %sp 32 #1336
	lw %a11 %sp 28 #1336
	sw %ra %sp 92 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 96 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -96 #1336
	lw %ra %sp 92 #1336
beq_cont.35935:
beq_cont.35933:
beq_cont.35931:
beq_cont.35929:
beq_cont.35927:
beq_cont.35925:
	jal %zero beq_cont.35923 # then sentence ends
beq_else.35922:
	lw %a4 %sp 32 #1352
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
	bne %a0 %a12 beq_else.35936 # nontail if
	jal %zero beq_cont.35937 # then sentence ends
beq_else.35936:
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
	bne %a0 %a12 beq_else.35938 # nontail if
	jal %zero beq_cont.35939 # then sentence ends
beq_else.35938:
	lw %a0 %sp 88 #1332
	lw %a1 %a0 4 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35940 # nontail if
	jal %zero beq_cont.35941 # then sentence ends
beq_else.35940:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 8 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35942 # nontail if
	jal %zero beq_cont.35943 # then sentence ends
beq_else.35942:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 12 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35944 # nontail if
	jal %zero beq_cont.35945 # then sentence ends
beq_else.35944:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 16 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35946 # nontail if
	jal %zero beq_cont.35947 # then sentence ends
beq_else.35946:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 20 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35948 # nontail if
	jal %zero beq_cont.35949 # then sentence ends
beq_else.35948:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1335
	lw %a4 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	lw %a0 %sp 88 #1332
	lw %a1 %a0 24 #1332
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.35950 # nontail if
	jal %zero beq_cont.35951 # then sentence ends
beq_else.35950:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1335
	lw %a3 %sp 32 #1335
	lw %a11 %sp 36 #1335
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 92 #1335 call cls
	lw %a10 %a11 0 #1335
	addi %sp %sp 96 #1335	
	jalr %ra %a10 0 #1335
	addi %sp %sp -96 #1335
	lw %ra %sp 92 #1335
	addi %a0 %zero 7 #1336
	lw %a1 %sp 88 #1336
	lw %a2 %sp 32 #1336
	lw %a11 %sp 28 #1336
	sw %ra %sp 92 #1336 call cls
	lw %a10 %a11 0 #1336
	addi %sp %sp 96 #1336	
	jalr %ra %a10 0 #1336
	addi %sp %sp -96 #1336
	lw %ra %sp 92 #1336
beq_cont.35951:
beq_cont.35949:
beq_cont.35947:
beq_cont.35945:
beq_cont.35943:
beq_cont.35941:
beq_cont.35939:
beq_cont.35937:
beq_cont.35923:
	lw %a0 %sp 84 #1360
	addi %a0 %a0 1 #1360
	lw %a1 %sp 12 #1360
	lw %a2 %sp 32 #1360
	lw %a11 %sp 4 #1360
	lw %a10 %a11 0 #1360
	jalr %zero %a10 0 #1360
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
	sw %a10 %sp 4 #507
	lw %a10 %a2 0 #507
	sw %a9 %sp 8 #1383
	slli %a9 %a0 2 #1383
	add %a12 %a1 %a9 #1383
	lw %a9 %a12 0 #1383
	addi %a12 %zero -1
	bne %a9 %a12 beq_else.35952
	jalr %zero %ra 0 #1384
beq_else.35952:
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
	bne %a10 %a12 beq_else.35954 # nontail if
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
	jal %zero beq_cont.35955 # then sentence ends
beq_else.35954:
	addi %a12 %zero 2
	bne %a10 %a12 beq_else.35956 # nontail if
	lw %f0 %a3 0 #983
	sw %a4 %sp 56 #983
	sw %a3 %sp 60 #983
	sw %ra %sp 68 #983 call dir
	addi %sp %sp 72 #983	
	jal %ra min_caml_fisneg #983
	addi %sp %sp -72 #983
	lw %ra %sp 68 #983
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35958 # nontail if
	addi %a0 %zero 0 #983
	jal %zero beq_cont.35959 # then sentence ends
beq_else.35958:
	lw %a0 %sp 60 #983
	lw %f0 %a0 0 #983
	lw %a0 %sp 56 #984
	lw %f1 %a0 12 #984
	fmul %f0 %f0 %f1 #984
	lw %a0 %sp 28 #984
	sw %f0 %a0 0 #984
	addi %a0 %zero 1 #985
beq_cont.35959:
	jal %zero beq_cont.35957 # then sentence ends
beq_else.35956:
	lw %f3 %a3 0 #992
	sw %a8 %sp 64 #993
	sw %f3 %sp 72 #993
	sw %a4 %sp 56 #993
	sw %f2 %sp 80 #993
	sw %f1 %sp 88 #993
	sw %f0 %sp 96 #993
	sw %a3 %sp 60 #993
	fadd %f0 %f3 %fzero
	sw %ra %sp 108 #993 call dir
	addi %sp %sp 112 #993	
	jal %ra min_caml_fiszero #993
	addi %sp %sp -112 #993
	lw %ra %sp 108 #993
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35961 # nontail if
	lw %a0 %sp 60 #992
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
	lw %a1 %sp 56 #997
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
	bne %a0 %a12 beq_else.35963 # nontail if
	addi %a0 %zero 0 #993
	jal %zero beq_cont.35964 # then sentence ends
beq_else.35963:
	lw %a0 %sp 64 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35965 # nontail if
	lw %f0 %sp 120 #1003
	sw %ra %sp 132 #1003 call dir
	addi %sp %sp 136 #1003	
	jal %ra min_caml_sqrt #1003
	addi %sp %sp -136 #1003
	lw %ra %sp 132 #1003
	lw %f1 %sp 104 #1003
	fsub %f0 %f1 %f0 #1003
	lw %a0 %sp 60 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1003
	lw %a0 %sp 28 #1003
	sw %f0 %a0 0 #1003
	jal %zero beq_cont.35966 # then sentence ends
beq_else.35965:
	lw %f0 %sp 120 #1001
	sw %ra %sp 132 #1001 call dir
	addi %sp %sp 136 #1001	
	jal %ra min_caml_sqrt #1001
	addi %sp %sp -136 #1001
	lw %ra %sp 132 #1001
	lw %f1 %sp 104 #1001
	fadd %f0 %f1 %f0 #1001
	lw %a0 %sp 60 #992
	lw %f1 %a0 16 #992
	fmul %f0 %f0 %f1 #1001
	lw %a0 %sp 28 #1001
	sw %f0 %a0 0 #1001
beq_cont.35966:
	addi %a0 %zero 1 #1004
beq_cont.35964:
	jal %zero beq_cont.35962 # then sentence ends
beq_else.35961:
	addi %a0 %zero 0 #993
beq_cont.35962:
beq_cont.35957:
beq_cont.35955:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35967
	lw %a0 %sp 52 #20
	slli %a0 %a0 2 #20
	lw %a1 %sp 48 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35968
	jalr %zero %ra 0 #1417
beq_else.35968:
	lw %a0 %sp 44 #1416
	addi %a0 %a0 1 #1416
	lw %a1 %sp 36 #1416
	lw %a2 %sp 32 #1416
	lw %a11 %sp 40 #1416
	lw %a10 %a11 0 #1416
	jalr %zero %a10 0 #1416
beq_else.35967:
	lw %a1 %sp 28 #37
	lw %f1 %a1 0 #37
	li %f0 l.27725 #1393
	sw %a0 %sp 128 #1393
	sw %f1 %sp 136 #1393
	sw %ra %sp 148 #1393 call dir
	addi %sp %sp 152 #1393	
	jal %ra min_caml_fless #1393
	addi %sp %sp -152 #1393
	lw %ra %sp 148 #1393
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35971 # nontail if
	jal %zero beq_cont.35972 # then sentence ends
beq_else.35971:
	lw %a0 %sp 24 #41
	lw %f1 %a0 0 #41
	lw %f0 %sp 136 #1394
	sw %ra %sp 148 #1394 call dir
	addi %sp %sp 152 #1394	
	jal %ra min_caml_fless #1394
	addi %sp %sp -152 #1394
	lw %ra %sp 148 #1394
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35973 # nontail if
	jal %zero beq_cont.35974 # then sentence ends
beq_else.35973:
	li %f0 l.28266 #1396
	lw %f1 %sp 136 #1396
	fadd %f0 %f1 %f0 #1396
	lw %a0 %sp 20 #903
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
	lw %a1 %sp 36 #1194
	lw %a0 %a1 0 #1194
	sw %f3 %sp 144 #1195
	sw %f2 %sp 152 #1195
	sw %f1 %sp 160 #1195
	sw %f0 %sp 168 #1195
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35975 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35976 # then sentence ends
beq_else.35975:
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	fadd %f0 %f1 %fzero
	fadd %f1 %f2 %fzero
	fadd %f2 %f3 %fzero
	sw %ra %sp 180 #1198 call dir
	addi %sp %sp 184 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -184 #1198
	lw %ra %sp 180 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35977 # nontail if
	lw %a1 %sp 36 #1194
	lw %a0 %a1 4 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.35979 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.35980 # then sentence ends
beq_else.35979:
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a3 %a0 20 #316
	lw %f0 %a3 0 #321
	lw %f1 %sp 160 #1180
	fsub %f0 %f1 %f0 #1180
	lw %a3 %a0 20 #326
	lw %f2 %a3 4 #331
	lw %f3 %sp 152 #1181
	fsub %f2 %f3 %f2 #1181
	lw %a3 %a0 20 #336
	lw %f4 %a3 8 #341
	lw %f5 %sp 144 #1182
	fsub %f4 %f5 %f4 #1182
	lw %a3 %a0 4 #238
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.35981 # nontail if
	sw %f4 %sp 176 #1157
	sw %f2 %sp 184 #1157
	sw %a0 %sp 192 #1157
	sw %ra %sp 196 #1157 call dir
	addi %sp %sp 200 #1157	
	jal %ra min_caml_fabs #1157
	addi %sp %sp -200 #1157
	lw %ra %sp 196 #1157
	lw %a0 %sp 192 #276
	lw %a1 %a0 16 #276
	lw %f1 %a1 0 #281
	sw %ra %sp 196 #1157 call dir
	addi %sp %sp 200 #1157	
	jal %ra min_caml_fless #1157
	addi %sp %sp -200 #1157
	lw %ra %sp 196 #1157
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35983 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35984 # then sentence ends
beq_else.35983:
	lw %f0 %sp 184 #1158
	sw %ra %sp 196 #1158 call dir
	addi %sp %sp 200 #1158	
	jal %ra min_caml_fabs #1158
	addi %sp %sp -200 #1158
	lw %ra %sp 196 #1158
	lw %a0 %sp 192 #286
	lw %a1 %a0 16 #286
	lw %f1 %a1 4 #291
	sw %ra %sp 196 #1158 call dir
	addi %sp %sp 200 #1158	
	jal %ra min_caml_fless #1158
	addi %sp %sp -200 #1158
	lw %ra %sp 196 #1158
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35985 # nontail if
	addi %a0 %zero 0 #1157
	jal %zero beq_cont.35986 # then sentence ends
beq_else.35985:
	lw %f0 %sp 176 #1159
	sw %ra %sp 196 #1159 call dir
	addi %sp %sp 200 #1159	
	jal %ra min_caml_fabs #1159
	addi %sp %sp -200 #1159
	lw %ra %sp 196 #1159
	lw %a0 %sp 192 #296
	lw %a1 %a0 16 #296
	lw %f1 %a1 8 #301
	sw %ra %sp 196 #1159 call dir
	addi %sp %sp 200 #1159	
	jal %ra min_caml_fless #1159
	addi %sp %sp -200 #1159
	lw %ra %sp 196 #1159
beq_cont.35986:
beq_cont.35984:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35987 # nontail if
	lw %a0 %sp 192 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35989 # nontail if
	addi %a0 %zero 1 #1162
	jal %zero beq_cont.35990 # then sentence ends
beq_else.35989:
	addi %a0 %zero 0 #1156
beq_cont.35990:
	jal %zero beq_cont.35988 # then sentence ends
beq_else.35987:
	lw %a0 %sp 192 #258
	lw %a0 %a0 24 #258
beq_cont.35988:
	jal %zero beq_cont.35982 # then sentence ends
beq_else.35981:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.35991 # nontail if
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
	sw %a0 %sp 196 #1168
	sw %ra %sp 204 #1168 call dir
	addi %sp %sp 208 #1168	
	jal %ra min_caml_fisneg #1168
	addi %sp %sp -208 #1168
	lw %ra %sp 204 #1168
	lw %a1 %sp 196 #105
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.35993 # nontail if
	jal %zero beq_cont.35994 # then sentence ends
beq_else.35993:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35995 # nontail if
	addi %a0 %zero 1 #105
	jal %zero beq_cont.35996 # then sentence ends
beq_else.35995:
	addi %a0 %zero 0 #105
beq_cont.35996:
beq_cont.35994:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35997 # nontail if
	addi %a0 %zero 1 #1168
	jal %zero beq_cont.35998 # then sentence ends
beq_else.35997:
	addi %a0 %zero 0 #1168
beq_cont.35998:
	jal %zero beq_cont.35992 # then sentence ends
beq_else.35991:
	fadd %f1 %f2 %fzero
	fadd %f2 %f4 %fzero
	sw %ra %sp 204 #1189 call dir
	addi %sp %sp 208 #1189	
	jal %ra is_second_outside.2496 #1189
	addi %sp %sp -208 #1189
	lw %ra %sp 204 #1189
beq_cont.35992:
beq_cont.35982:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.35999 # nontail if
	lw %a1 %sp 36 #1194
	lw %a0 %a1 8 #1194
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.36001 # nontail if
	addi %a0 %zero 1 #1196
	jal %zero beq_cont.36002 # then sentence ends
beq_else.36001:
	slli %a0 %a0 2 #20
	lw %a2 %sp 48 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %f0 %sp 160 #1198
	lw %f1 %sp 152 #1198
	lw %f2 %sp 144 #1198
	sw %ra %sp 204 #1198 call dir
	addi %sp %sp 208 #1198	
	jal %ra is_outside.2501 #1198
	addi %sp %sp -208 #1198
	lw %ra %sp 204 #1198
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36003 # nontail if
	addi %a0 %zero 3 #1201
	lw %f0 %sp 160 #1201
	lw %f1 %sp 152 #1201
	lw %f2 %sp 144 #1201
	lw %a1 %sp 36 #1201
	lw %a11 %sp 12 #1201
	sw %ra %sp 204 #1201 call cls
	lw %a10 %a11 0 #1201
	addi %sp %sp 208 #1201	
	jalr %ra %a10 0 #1201
	addi %sp %sp -208 #1201
	lw %ra %sp 204 #1201
	jal %zero beq_cont.36004 # then sentence ends
beq_else.36003:
	addi %a0 %zero 0 #1198
beq_cont.36004:
beq_cont.36002:
	jal %zero beq_cont.36000 # then sentence ends
beq_else.35999:
	addi %a0 %zero 0 #1198
beq_cont.36000:
beq_cont.35980:
	jal %zero beq_cont.35978 # then sentence ends
beq_else.35977:
	addi %a0 %zero 0 #1198
beq_cont.35978:
beq_cont.35976:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36005 # nontail if
	jal %zero beq_cont.36006 # then sentence ends
beq_else.36005:
	lw %a0 %sp 24 #1402
	lw %f0 %sp 168 #1402
	sw %f0 %a0 0 #1402
	lw %a0 %sp 8 #133
	lw %f0 %sp 160 #133
	sw %f0 %a0 0 #133
	lw %f0 %sp 152 #134
	sw %f0 %a0 4 #134
	lw %f0 %sp 144 #135
	sw %f0 %a0 8 #135
	lw %a0 %sp 4 #1404
	lw %a1 %sp 52 #1404
	sw %a1 %a0 0 #1404
	lw %a0 %sp 0 #1405
	lw %a1 %sp 128 #1405
	sw %a1 %a0 0 #1405
beq_cont.36006:
beq_cont.35974:
beq_cont.35972:
	lw %a0 %sp 44 #1411
	addi %a0 %a0 1 #1411
	lw %a1 %sp 36 #1411
	lw %a2 %sp 32 #1411
	lw %a11 %sp 40 #1411
	lw %a10 %a11 0 #1411
	jalr %zero %a10 0 #1411
solve_one_or_network_fast.2539:
	lw %a3 %a11 8 #1422
	lw %a4 %a11 4 #1422
	slli %a5 %a0 2 #1423
	add %a12 %a1 %a5 #1423
	lw %a5 %a12 0 #1423
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.36007
	jalr %zero %ra 0 #1428
beq_else.36007:
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
	bne %a1 %a12 beq_else.36009
	jalr %zero %ra 0 #1428
beq_else.36009:
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
	bne %a1 %a12 beq_else.36011
	jalr %zero %ra 0 #1428
beq_else.36011:
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
	bne %a1 %a12 beq_else.36013
	jalr %zero %ra 0 #1428
beq_else.36013:
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
	bne %a1 %a12 beq_else.36015
	jalr %zero %ra 0 #1428
beq_else.36015:
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
	bne %a1 %a12 beq_else.36017
	jalr %zero %ra 0 #1428
beq_else.36017:
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
	bne %a1 %a12 beq_else.36019
	jalr %zero %ra 0 #1428
beq_else.36019:
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
	bne %a1 %a12 beq_else.36021
	jalr %zero %ra 0 #1428
beq_else.36021:
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
	bne %a5 %a12 beq_else.36023
	jalr %zero %ra 0 #1436
beq_else.36023:
	sw %a3 %sp 8 #1435
	sw %a6 %sp 12 #1435
	sw %a7 %sp 16 #1435
	sw %a2 %sp 20 #1435
	sw %a8 %sp 24 #1435
	sw %a10 %sp 28 #1435
	sw %a1 %sp 32 #1435
	sw %a0 %sp 36 #1435
	addi %a12 %zero 99
	bne %a5 %a12 beq_else.36025 # nontail if
	lw %a4 %a11 4 #1423
	addi %a12 %zero -1
	bne %a4 %a12 beq_else.36027 # nontail if
	jal %zero beq_cont.36028 # then sentence ends
beq_else.36027:
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
	bne %a1 %a12 beq_else.36029 # nontail if
	jal %zero beq_cont.36030 # then sentence ends
beq_else.36029:
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
	bne %a1 %a12 beq_else.36031 # nontail if
	jal %zero beq_cont.36032 # then sentence ends
beq_else.36031:
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
	bne %a1 %a12 beq_else.36033 # nontail if
	jal %zero beq_cont.36034 # then sentence ends
beq_else.36033:
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
	bne %a1 %a12 beq_else.36035 # nontail if
	jal %zero beq_cont.36036 # then sentence ends
beq_else.36035:
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
	bne %a1 %a12 beq_else.36037 # nontail if
	jal %zero beq_cont.36038 # then sentence ends
beq_else.36037:
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
	bne %a1 %a12 beq_else.36039 # nontail if
	jal %zero beq_cont.36040 # then sentence ends
beq_else.36039:
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
beq_cont.36040:
beq_cont.36038:
beq_cont.36036:
beq_cont.36034:
beq_cont.36032:
beq_cont.36030:
beq_cont.36028:
	jal %zero beq_cont.36026 # then sentence ends
beq_else.36025:
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
	bne %a5 %a12 beq_else.36041 # nontail if
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
	jal %zero beq_cont.36042 # then sentence ends
beq_else.36041:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.36043 # nontail if
	lw %f0 %a0 0 #983
	sw %a9 %sp 44 #983
	sw %a0 %sp 48 #983
	sw %ra %sp 52 #983 call dir
	addi %sp %sp 56 #983	
	jal %ra min_caml_fisneg #983
	addi %sp %sp -56 #983
	lw %ra %sp 52 #983
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36045 # nontail if
	addi %a0 %zero 0 #983
	jal %zero beq_cont.36046 # then sentence ends
beq_else.36045:
	lw %a0 %sp 48 #983
	lw %f0 %a0 0 #983
	lw %a0 %sp 44 #984
	lw %f1 %a0 12 #984
	fmul %f0 %f0 %f1 #984
	lw %a0 %sp 12 #984
	sw %f0 %a0 0 #984
	addi %a0 %zero 1 #985
beq_cont.36046:
	jal %zero beq_cont.36044 # then sentence ends
beq_else.36043:
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
	bne %a0 %a12 beq_else.36047 # nontail if
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
	bne %a0 %a12 beq_else.36049 # nontail if
	addi %a0 %zero 0 #993
	jal %zero beq_cont.36050 # then sentence ends
beq_else.36049:
	lw %a0 %sp 52 #258
	lw %a0 %a0 24 #258
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36051 # nontail if
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
	jal %zero beq_cont.36052 # then sentence ends
beq_else.36051:
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
beq_cont.36052:
	addi %a0 %zero 1 #1004
beq_cont.36050:
	jal %zero beq_cont.36048 # then sentence ends
beq_else.36047:
	addi %a0 %zero 0 #993
beq_cont.36048:
beq_cont.36044:
beq_cont.36042:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36053 # nontail if
	jal %zero beq_cont.36054 # then sentence ends
beq_else.36053:
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
	bne %a0 %a12 beq_else.36055 # nontail if
	jal %zero beq_cont.36056 # then sentence ends
beq_else.36055:
	lw %a0 %sp 40 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36057 # nontail if
	jal %zero beq_cont.36058 # then sentence ends
beq_else.36057:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36059 # nontail if
	jal %zero beq_cont.36060 # then sentence ends
beq_else.36059:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36061 # nontail if
	jal %zero beq_cont.36062 # then sentence ends
beq_else.36061:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36063 # nontail if
	jal %zero beq_cont.36064 # then sentence ends
beq_else.36063:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 20 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36065 # nontail if
	jal %zero beq_cont.36066 # then sentence ends
beq_else.36065:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 24 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36067 # nontail if
	jal %zero beq_cont.36068 # then sentence ends
beq_else.36067:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	lw %a0 %sp 40 #1423
	lw %a1 %a0 28 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36069 # nontail if
	jal %zero beq_cont.36070 # then sentence ends
beq_else.36069:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 116 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 120 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -120 #1426
	lw %ra %sp 116 #1426
	addi %a0 %zero 8 #1427
	lw %a1 %sp 40 #1427
	lw %a2 %sp 20 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 116 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 120 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -120 #1427
	lw %ra %sp 116 #1427
beq_cont.36070:
beq_cont.36068:
beq_cont.36066:
beq_cont.36064:
beq_cont.36062:
beq_cont.36060:
beq_cont.36058:
beq_cont.36056:
beq_cont.36054:
beq_cont.36026:
	lw %a0 %sp 36 #1451
	addi %a0 %a0 1 #1451
	slli %a1 %a0 2 #1433
	lw %a2 %sp 32 #1433
	add %a12 %a2 %a1 #1433
	lw %a1 %a12 0 #1433
	lw %a3 %a1 0 #1434
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.36071
	jalr %zero %ra 0 #1436
beq_else.36071:
	sw %a0 %sp 112 #1435
	addi %a12 %zero 99
	bne %a3 %a12 beq_else.36073 # nontail if
	lw %a3 %a1 4 #1423
	addi %a12 %zero -1
	bne %a3 %a12 beq_else.36075 # nontail if
	jal %zero beq_cont.36076 # then sentence ends
beq_else.36075:
	slli %a3 %a3 2 #31
	lw %a4 %sp 28 #31
	add %a12 %a4 %a3 #31
	lw %a3 %a12 0 #31
	addi %a5 %zero 0 #1426
	lw %a6 %sp 20 #1426
	lw %a11 %sp 24 #1426
	sw %a1 %sp 116 #1426
	add %a2 %a6 %zero
	add %a1 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36077 # nontail if
	jal %zero beq_cont.36078 # then sentence ends
beq_else.36077:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36079 # nontail if
	jal %zero beq_cont.36080 # then sentence ends
beq_else.36079:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36081 # nontail if
	jal %zero beq_cont.36082 # then sentence ends
beq_else.36081:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 20 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36083 # nontail if
	jal %zero beq_cont.36084 # then sentence ends
beq_else.36083:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 24 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36085 # nontail if
	jal %zero beq_cont.36086 # then sentence ends
beq_else.36085:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	addi %a0 %zero 7 #1427
	lw %a1 %sp 116 #1427
	lw %a2 %sp 20 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 124 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 128 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -128 #1427
	lw %ra %sp 124 #1427
beq_cont.36086:
beq_cont.36084:
beq_cont.36082:
beq_cont.36080:
beq_cont.36078:
beq_cont.36076:
	jal %zero beq_cont.36074 # then sentence ends
beq_else.36073:
	lw %a4 %sp 20 #1443
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
	bne %a0 %a12 beq_else.36087 # nontail if
	jal %zero beq_cont.36088 # then sentence ends
beq_else.36087:
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
	bne %a0 %a12 beq_else.36089 # nontail if
	jal %zero beq_cont.36090 # then sentence ends
beq_else.36089:
	lw %a0 %sp 116 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36091 # nontail if
	jal %zero beq_cont.36092 # then sentence ends
beq_else.36091:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36093 # nontail if
	jal %zero beq_cont.36094 # then sentence ends
beq_else.36093:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36095 # nontail if
	jal %zero beq_cont.36096 # then sentence ends
beq_else.36095:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36097 # nontail if
	jal %zero beq_cont.36098 # then sentence ends
beq_else.36097:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 20 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36099 # nontail if
	jal %zero beq_cont.36100 # then sentence ends
beq_else.36099:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	lw %a0 %sp 116 #1423
	lw %a1 %a0 24 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36101 # nontail if
	jal %zero beq_cont.36102 # then sentence ends
beq_else.36101:
	slli %a1 %a1 2 #31
	lw %a2 %sp 28 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 20 #1426
	lw %a11 %sp 24 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 124 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 128 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -128 #1426
	lw %ra %sp 124 #1426
	addi %a0 %zero 7 #1427
	lw %a1 %sp 116 #1427
	lw %a2 %sp 20 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 124 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 128 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -128 #1427
	lw %ra %sp 124 #1427
beq_cont.36102:
beq_cont.36100:
beq_cont.36098:
beq_cont.36096:
beq_cont.36094:
beq_cont.36092:
beq_cont.36090:
beq_cont.36088:
beq_cont.36074:
	lw %a0 %sp 112 #1451
	addi %a0 %a0 1 #1451
	lw %a1 %sp 32 #1451
	lw %a2 %sp 20 #1451
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
	bne %a2 %a12 beq_else.36103 # nontail if
	sw %f3 %a1 0 #1501
	sw %f4 %a1 4 #1502
	sw %f5 %a1 8 #1503
	jal %zero beq_cont.36104 # then sentence ends
beq_else.36103:
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
beq_cont.36104:
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
	bne %a0 %a12 beq_else.36106 # nontail if
	lw %a0 %sp 56 #105
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36108 # nontail if
	li %f0 l.27799 #173
	lw %f1 %sp 80 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.36109 # then sentence ends
beq_else.36108:
	li %f0 l.27801 #173
	lw %f1 %sp 80 #173
	fdiv %f0 %f0 %f1 #173
beq_cont.36109:
	jal %zero beq_cont.36107 # then sentence ends
beq_else.36106:
	li %f0 l.27799 #173
beq_cont.36107:
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
	bne %a3 %a12 beq_else.36111
	lw %f0 %a1 0 #1536
	lw %a3 %a0 20 #316
	lw %f1 %a3 0 #321
	fsub %f0 %f0 %f1 #1536
	li %f1 l.28733 #1538
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
	li %f1 l.28735 #1538
	fmul %f0 %f0 %f1 #1538
	lw %f1 %sp 16 #1539
	fsub %f0 %f1 %f0 #1539
	li %f1 l.28715 #1539
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
	li %f1 l.28733 #1543
	fmul %f1 %f0 %f1 #1543
	sw %a0 %sp 24 #1543
	sw %f0 %sp 32 #1543
	fadd %f0 %f1 %fzero
	sw %ra %sp 44 #1543 call dir
	addi %sp %sp 48 #1543	
	jal %ra min_caml_floor #1543
	addi %sp %sp -48 #1543
	lw %ra %sp 44 #1543
	li %f1 l.28735 #1543
	fmul %f0 %f0 %f1 #1543
	lw %f1 %sp 32 #1544
	fsub %f0 %f1 %f0 #1544
	li %f1 l.28715 #1544
	sw %ra %sp 44 #1544 call dir
	addi %sp %sp 48 #1544	
	jal %ra min_caml_fless #1544
	addi %sp %sp -48 #1544
	lw %ra %sp 44 #1544
	lw %a1 %sp 24 #788
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36114 # nontail if
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36116 # nontail if
	li %f0 l.28706 #1549
	jal %zero beq_cont.36117 # then sentence ends
beq_else.36116:
	li %f0 l.27725 #1549
beq_cont.36117:
	jal %zero beq_cont.36115 # then sentence ends
beq_else.36114:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36118 # nontail if
	li %f0 l.27725 #1548
	jal %zero beq_cont.36119 # then sentence ends
beq_else.36118:
	li %f0 l.28706 #1548
beq_cont.36119:
beq_cont.36115:
	lw %a0 %sp 0 #1546
	sw %f0 %a0 4 #1546
	jalr %zero %ra 0 #1546
beq_else.36111:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.36121
	lw %f0 %a1 4 #1536
	li %f1 l.28724 #1554
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
	li %f1 l.28706 #1555
	fmul %f1 %f1 %f0 #1555
	lw %a0 %sp 0 #1555
	sw %f1 %a0 0 #1555
	li %f1 l.28706 #1556
	li %f2 l.27799 #1556
	fsub %f0 %f2 %f0 #1556
	fmul %f0 %f1 %f0 #1556
	sw %f0 %a0 4 #1556
	jalr %zero %ra 0 #1556
beq_else.36121:
	addi %a12 %zero 3
	bne %a3 %a12 beq_else.36123
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
	li %f1 l.28715 #1563
	fdiv %f0 %f0 %f1 #1563
	sw %f0 %sp 56 #1564
	sw %ra %sp 68 #1564 call dir
	addi %sp %sp 72 #1564	
	jal %ra min_caml_floor #1564
	addi %sp %sp -72 #1564
	lw %ra %sp 68 #1564
	lw %f1 %sp 56 #1564
	fsub %f0 %f1 %f0 #1564
	li %f1 l.28691 #1564
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
	li %f1 l.28706 #1566
	fmul %f1 %f0 %f1 #1566
	lw %a0 %sp 0 #1566
	sw %f1 %a0 4 #1566
	li %f1 l.27799 #1567
	fsub %f0 %f1 %f0 #1567
	li %f1 l.28706 #1567
	fmul %f0 %f0 %f1 #1567
	sw %f0 %a0 8 #1567
	jalr %zero %ra 0 #1567
beq_else.36123:
	addi %a12 %zero 4
	bne %a3 %a12 beq_else.36125
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
	li %f1 l.28685 #1575
	sw %ra %sp 116 #1575 call dir
	addi %sp %sp 120 #1575	
	jal %ra min_caml_fless #1575
	addi %sp %sp -120 #1575
	lw %ra %sp 116 #1575
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36126 # nontail if
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
	li %f1 l.28689 #1580
	fmul %f0 %f0 %f1 #1580
	li %f1 l.28691 #1580
	fdiv %f0 %f0 %f1 #1580
	jal %zero beq_cont.36127 # then sentence ends
beq_else.36126:
	li %f0 l.28687 #1576
beq_cont.36127:
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
	li %f1 l.28685 #1586
	sw %ra %sp 148 #1586 call dir
	addi %sp %sp 152 #1586	
	jal %ra min_caml_fless #1586
	addi %sp %sp -152 #1586
	lw %ra %sp 148 #1586
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36128 # nontail if
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
	li %f1 l.28689 #1590
	fmul %f0 %f0 %f1 #1590
	li %f1 l.28691 #1590
	fdiv %f0 %f0 %f1 #1590
	jal %zero beq_cont.36129 # then sentence ends
beq_else.36128:
	li %f0 l.28687 #1587
beq_cont.36129:
	sw %f0 %sp 144 #1592
	sw %ra %sp 156 #1592 call dir
	addi %sp %sp 160 #1592	
	jal %ra min_caml_floor #1592
	addi %sp %sp -160 #1592
	lw %ra %sp 156 #1592
	lw %f1 %sp 144 #1592
	fsub %f0 %f1 %f0 #1592
	li %f1 l.28700 #1593
	li %f2 l.28702 #1593
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
	li %f1 l.28702 #1593
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
	bne %a0 %a12 beq_else.36130 # nontail if
	lw %f0 %sp 176 #1593
	jal %zero beq_cont.36131 # then sentence ends
beq_else.36130:
	li %f0 l.27725 #1594
beq_cont.36131:
	li %f1 l.28706 #1595
	fmul %f0 %f1 %f0 #1595
	li %f1 l.28708 #1595
	fdiv %f0 %f0 %f1 #1595
	lw %a0 %sp 0 #1595
	sw %f0 %a0 8 #1595
	jalr %zero %ra 0 #1595
beq_else.36125:
	jalr %zero %ra 0 #1597
trace_reflections.2565:
	lw %a2 %a11 80 #1620
	lw %a3 %a11 76 #1620
	lw %a4 %a11 72 #1620
	lw %a5 %a11 68 #1620
	lw %a6 %a11 64 #1620
	lw %a7 %a11 60 #1620
	lw %a8 %a11 56 #1620
	lw %a9 %a11 52 #1620
	lw %a10 %a11 48 #1620
	sw %a5 %sp 0 #1620
	lw %a5 %a11 44 #1620
	sw %a8 %sp 4 #1620
	lw %a8 %a11 40 #1620
	sw %a9 %sp 8 #1620
	lw %a9 %a11 36 #1620
	sw %a4 %sp 12 #1620
	lw %a4 %a11 32 #1620
	sw %a9 %sp 16 #1620
	lw %a9 %a11 28 #1620
	sw %a1 %sp 20 #1620
	lw %a1 %a11 24 #1620
	sw %a1 %sp 24 #1620
	lw %a1 %a11 20 #1620
	sw %a10 %sp 28 #1620
	lw %a10 %a11 16 #1620
	sw %a5 %sp 32 #1620
	lw %a5 %a11 12 #1620
	sw %a8 %sp 36 #1620
	lw %a8 %a11 8 #1620
	sw %a11 %sp 40 #1620
	lw %a11 %a11 4 #1620
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36134
	sw %a0 %sp 44 #95
	slli %a0 %a0 2 #95
	add %a12 %a4 %a0 #95
	lw %a0 %a12 0 #95
	sw %a4 %sp 48 #527
	lw %a4 %a0 4 #527
	li %f2 l.28749 #1458
	sw %f2 %a3 0 #1458
	sw %a11 %sp 52 #1459
	addi %a11 %zero 0 #1459
	sw %a7 %sp 56 #33
	lw %a7 %a9 0 #33
	sw %a2 %sp 60 #1459
	sw %f1 %sp 64 #1459
	sw %f0 %sp 72 #1459
	sw %a4 %sp 80 #1459
	sw %a5 %sp 84 #1459
	sw %a1 %sp 88 #1459
	sw %a6 %sp 92 #1459
	sw %a9 %sp 96 #1459
	sw %a0 %sp 100 #1459
	sw %a10 %sp 104 #1459
	sw %a8 %sp 108 #1459
	sw %a3 %sp 112 #1459
	add %a1 %a7 %zero
	add %a0 %a11 %zero
	add %a11 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 116 #1459 call cls
	lw %a10 %a11 0 #1459
	addi %sp %sp 120 #1459	
	jalr %ra %a10 0 #1459
	addi %sp %sp -120 #1459
	lw %ra %sp 116 #1459
	lw %a0 %sp 112 #41
	lw %f1 %a0 0 #41
	li %f0 l.28314 #1462
	sw %f1 %sp 120 #1462
	sw %ra %sp 132 #1462 call dir
	addi %sp %sp 136 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -136 #1462
	lw %ra %sp 132 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36136 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.36137 # then sentence ends
beq_else.36136:
	li %f1 l.28755 #1463
	lw %f0 %sp 120 #1463
	sw %ra %sp 132 #1463 call dir
	addi %sp %sp 136 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -136 #1463
	lw %ra %sp 132 #1463
beq_cont.36137:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36138 # nontail if
	jal %zero beq_cont.36139 # then sentence ends
beq_else.36138:
	lw %a0 %sp 108 #45
	lw %a1 %a0 0 #45
	addi %a2 %zero 4 #1628
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 132 #1628 call dir
	addi %sp %sp 136 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -136 #1628
	lw %ra %sp 132 #1628
	lw %a1 %sp 104 #39
	lw %a2 %a1 0 #39
	add %a0 %a0 %a2 #1628
	lw %a2 %sp 100 #521
	lw %a3 %a2 0 #521
	bne %a0 %a3 beq_else.36140 # nontail if
	lw %a0 %sp 96 #33
	lw %a3 %a0 0 #33
	lw %a4 %a3 0 #1257
	lw %a5 %a4 0 #1258
	addi %a12 %zero -1
	bne %a5 %a12 beq_else.36142 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.36143 # then sentence ends
beq_else.36142:
	sw %a4 %sp 128 #1259
	sw %a3 %sp 132 #1259
	addi %a12 %zero 99
	bne %a5 %a12 beq_else.36144 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.36145 # then sentence ends
beq_else.36144:
	lw %a6 %sp 88 #1266
	lw %a7 %sp 84 #1266
	lw %a11 %sp 92 #1266
	add %a2 %a7 %zero
	add %a1 %a6 %zero
	add %a0 %a5 %zero
	sw %ra %sp 140 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 144 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -144 #1266
	lw %ra %sp 140 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36146 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36147 # then sentence ends
beq_else.36146:
	lw %a0 %sp 56 #37
	lw %f0 %a0 0 #37
	li %f1 l.28314 #1270
	sw %ra %sp 140 #1270 call dir
	addi %sp %sp 144 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -144 #1270
	lw %ra %sp 140 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36148 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36149 # then sentence ends
beq_else.36148:
	lw %a0 %sp 128 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36150 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36151 # then sentence ends
beq_else.36150:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 36 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36152 # nontail if
	lw %a0 %sp 128 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36154 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36155 # then sentence ends
beq_else.36154:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 36 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36156 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 128 #1251
	lw %a11 %sp 32 #1251
	sw %ra %sp 140 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 144 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -144 #1251
	lw %ra %sp 140 #1251
	jal %zero beq_cont.36157 # then sentence ends
beq_else.36156:
	addi %a0 %zero 1 #1249
beq_cont.36157:
beq_cont.36155:
	jal %zero beq_cont.36153 # then sentence ends
beq_else.36152:
	addi %a0 %zero 1 #1249
beq_cont.36153:
beq_cont.36151:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36158 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36159 # then sentence ends
beq_else.36158:
	addi %a0 %zero 1 #1272
beq_cont.36159:
beq_cont.36149:
beq_cont.36147:
beq_cont.36145:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36160 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 132 #1282
	lw %a11 %sp 28 #1282
	sw %ra %sp 140 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 144 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -144 #1282
	lw %ra %sp 140 #1282
	jal %zero beq_cont.36161 # then sentence ends
beq_else.36160:
	lw %a0 %sp 128 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36162 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36163 # then sentence ends
beq_else.36162:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 36 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36164 # nontail if
	lw %a0 %sp 128 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36166 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36167 # then sentence ends
beq_else.36166:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 36 #1247
	add %a0 %a3 %zero
	sw %ra %sp 140 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 144 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -144 #1247
	lw %ra %sp 140 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36168 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 128 #1251
	lw %a11 %sp 32 #1251
	sw %ra %sp 140 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 144 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -144 #1251
	lw %ra %sp 140 #1251
	jal %zero beq_cont.36169 # then sentence ends
beq_else.36168:
	addi %a0 %zero 1 #1249
beq_cont.36169:
beq_cont.36167:
	jal %zero beq_cont.36165 # then sentence ends
beq_else.36164:
	addi %a0 %zero 1 #1249
beq_cont.36165:
beq_cont.36163:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36170 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 132 #1280
	lw %a11 %sp 28 #1280
	sw %ra %sp 140 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 144 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -144 #1280
	lw %ra %sp 140 #1280
	jal %zero beq_cont.36171 # then sentence ends
beq_else.36170:
	addi %a0 %zero 1 #1278
beq_cont.36171:
beq_cont.36161:
beq_cont.36143:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36172 # nontail if
	lw %a0 %sp 80 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 24 #181
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
	lw %a1 %sp 100 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 72 #1635
	fmul %f3 %f1 %f2 #1635
	fmul %f0 %f3 %f0 #1635
	lw %a0 %a0 0 #507
	lw %a1 %sp 20 #181
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
	sw %f1 %sp 136 #1606
	sw %f0 %sp 144 #1606
	sw %ra %sp 156 #1606 call dir
	addi %sp %sp 160 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -160 #1606
	lw %ra %sp 156 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36174 # nontail if
	jal %zero beq_cont.36175 # then sentence ends
beq_else.36174:
	lw %a0 %sp 16 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 12 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 144 #191
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
beq_cont.36175:
	lw %f0 %sp 136 #1611
	sw %ra %sp 156 #1611 call dir
	addi %sp %sp 160 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -160 #1611
	lw %ra %sp 156 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36176 # nontail if
	jal %zero beq_cont.36177 # then sentence ends
beq_else.36176:
	lw %f0 %sp 136 #1612
	sw %ra %sp 156 #1612 call dir
	addi %sp %sp 160 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -160 #1612
	lw %ra %sp 156 #1612
	sw %ra %sp 156 #1612 call dir
	addi %sp %sp 160 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -160 #1612
	lw %ra %sp 156 #1612
	lw %f1 %sp 64 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 16 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.36177:
	jal %zero beq_cont.36173 # then sentence ends
beq_else.36172:
beq_cont.36173:
	jal %zero beq_cont.36141 # then sentence ends
beq_else.36140:
beq_cont.36141:
beq_cont.36139:
	lw %a0 %sp 44 #1641
	addi %a0 %a0 -1 #1641
	addi %a1 %zero 0 #1622
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36178
	slli %a2 %a0 2 #95
	lw %a3 %sp 48 #95
	add %a12 %a3 %a2 #95
	lw %a2 %a12 0 #95
	lw %a3 %a2 4 #527
	li %f0 l.28749 #1458
	lw %a4 %sp 112 #1458
	sw %f0 %a4 0 #1458
	lw %a5 %sp 96 #33
	lw %a6 %a5 0 #33
	lw %a7 %a6 0 #1433
	lw %a8 %a7 0 #1434
	sw %a0 %sp 152 #1435
	sw %a3 %sp 156 #1435
	sw %a1 %sp 160 #1435
	sw %a2 %sp 164 #1435
	addi %a12 %zero -1
	bne %a8 %a12 beq_else.36179 # nontail if
	jal %zero beq_cont.36180 # then sentence ends
beq_else.36179:
	sw %a6 %sp 168 #1435
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.36181 # nontail if
	lw %a8 %a7 4 #1423
	addi %a12 %zero -1
	bne %a8 %a12 beq_else.36183 # nontail if
	jal %zero beq_cont.36184 # then sentence ends
beq_else.36183:
	slli %a8 %a8 2 #31
	lw %a9 %sp 52 #31
	add %a12 %a9 %a8 #31
	lw %a8 %a12 0 #31
	addi %a10 %zero 0 #1426
	lw %a11 %sp 8 #1426
	sw %a7 %sp 172 #1426
	add %a2 %a3 %zero
	add %a1 %a8 %zero
	add %a0 %a10 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	lw %a0 %sp 172 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36185 # nontail if
	jal %zero beq_cont.36186 # then sentence ends
beq_else.36185:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 156 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	lw %a0 %sp 172 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36187 # nontail if
	jal %zero beq_cont.36188 # then sentence ends
beq_else.36187:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 156 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	lw %a0 %sp 172 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36189 # nontail if
	jal %zero beq_cont.36190 # then sentence ends
beq_else.36189:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 156 #1426
	lw %a11 %sp 8 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 172 #1427
	lw %a2 %sp 156 #1427
	lw %a11 %sp 4 #1427
	sw %ra %sp 180 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 184 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -184 #1427
	lw %ra %sp 180 #1427
beq_cont.36190:
beq_cont.36188:
beq_cont.36186:
beq_cont.36184:
	jal %zero beq_cont.36182 # then sentence ends
beq_else.36181:
	lw %a11 %sp 0 #1443
	sw %a7 %sp 172 #1443
	add %a1 %a3 %zero
	add %a0 %a8 %zero
	sw %ra %sp 180 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 184 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -184 #1443
	lw %ra %sp 180 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36191 # nontail if
	jal %zero beq_cont.36192 # then sentence ends
beq_else.36191:
	lw %a0 %sp 56 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 112 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 180 #1446 call dir
	addi %sp %sp 184 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -184 #1446
	lw %ra %sp 180 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36193 # nontail if
	jal %zero beq_cont.36194 # then sentence ends
beq_else.36193:
	lw %a0 %sp 172 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36195 # nontail if
	jal %zero beq_cont.36196 # then sentence ends
beq_else.36195:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 156 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	lw %a0 %sp 172 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36197 # nontail if
	jal %zero beq_cont.36198 # then sentence ends
beq_else.36197:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 156 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	lw %a0 %sp 172 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36199 # nontail if
	jal %zero beq_cont.36200 # then sentence ends
beq_else.36199:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 156 #1426
	lw %a11 %sp 8 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	lw %a0 %sp 172 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36201 # nontail if
	jal %zero beq_cont.36202 # then sentence ends
beq_else.36201:
	slli %a1 %a1 2 #31
	lw %a2 %sp 52 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 156 #1426
	lw %a11 %sp 8 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 180 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 184 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -184 #1426
	lw %ra %sp 180 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 172 #1427
	lw %a2 %sp 156 #1427
	lw %a11 %sp 4 #1427
	sw %ra %sp 180 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 184 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -184 #1427
	lw %ra %sp 180 #1427
beq_cont.36202:
beq_cont.36200:
beq_cont.36198:
beq_cont.36196:
beq_cont.36194:
beq_cont.36192:
beq_cont.36182:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 168 #1451
	lw %a2 %sp 156 #1451
	lw %a11 %sp 60 #1451
	sw %ra %sp 180 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 184 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -184 #1451
	lw %ra %sp 180 #1451
beq_cont.36180:
	lw %a0 %sp 112 #41
	lw %f1 %a0 0 #41
	li %f0 l.28314 #1462
	sw %f1 %sp 176 #1462
	sw %ra %sp 188 #1462 call dir
	addi %sp %sp 192 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -192 #1462
	lw %ra %sp 188 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36203 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.36204 # then sentence ends
beq_else.36203:
	li %f1 l.28755 #1463
	lw %f0 %sp 176 #1463
	sw %ra %sp 188 #1463 call dir
	addi %sp %sp 192 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -192 #1463
	lw %ra %sp 188 #1463
beq_cont.36204:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36205 # nontail if
	jal %zero beq_cont.36206 # then sentence ends
beq_else.36205:
	lw %a0 %sp 108 #45
	lw %a0 %a0 0 #45
	addi %a1 %zero 4 #1628
	sw %ra %sp 188 #1628 call dir
	addi %sp %sp 192 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -192 #1628
	lw %ra %sp 188 #1628
	lw %a1 %sp 104 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1628
	lw %a1 %sp 164 #521
	lw %a2 %a1 0 #521
	bne %a0 %a2 beq_else.36207 # nontail if
	lw %a0 %sp 96 #33
	lw %a0 %a0 0 #33
	lw %a2 %sp 160 #1631
	lw %a11 %sp 28 #1631
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 188 #1631 call cls
	lw %a10 %a11 0 #1631
	addi %sp %sp 192 #1631	
	jalr %ra %a10 0 #1631
	addi %sp %sp -192 #1631
	lw %ra %sp 188 #1631
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36209 # nontail if
	lw %a0 %sp 156 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 24 #181
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
	lw %a1 %sp 164 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 72 #1635
	fmul %f3 %f1 %f2 #1635
	fmul %f0 %f3 %f0 #1635
	lw %a0 %a0 0 #507
	lw %a1 %sp 20 #181
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
	sw %f1 %sp 184 #1606
	sw %f0 %sp 192 #1606
	sw %ra %sp 204 #1606 call dir
	addi %sp %sp 208 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -208 #1606
	lw %ra %sp 204 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36211 # nontail if
	jal %zero beq_cont.36212 # then sentence ends
beq_else.36211:
	lw %a0 %sp 16 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 12 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 192 #191
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
beq_cont.36212:
	lw %f0 %sp 184 #1611
	sw %ra %sp 204 #1611 call dir
	addi %sp %sp 208 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -208 #1611
	lw %ra %sp 204 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36213 # nontail if
	jal %zero beq_cont.36214 # then sentence ends
beq_else.36213:
	lw %f0 %sp 184 #1612
	sw %ra %sp 204 #1612 call dir
	addi %sp %sp 208 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -208 #1612
	lw %ra %sp 204 #1612
	sw %ra %sp 204 #1612 call dir
	addi %sp %sp 208 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -208 #1612
	lw %ra %sp 204 #1612
	lw %f1 %sp 64 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 16 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.36214:
	jal %zero beq_cont.36210 # then sentence ends
beq_else.36209:
beq_cont.36210:
	jal %zero beq_cont.36208 # then sentence ends
beq_else.36207:
beq_cont.36208:
beq_cont.36206:
	lw %a0 %sp 152 #1641
	addi %a0 %a0 -1 #1641
	lw %f0 %sp 72 #1641
	lw %f1 %sp 64 #1641
	lw %a1 %sp 20 #1641
	lw %a11 %sp 40 #1641
	lw %a10 %a11 0 #1641
	jalr %zero %a10 0 #1641
bge_else.36178:
	jalr %zero %ra 0 #1642
bge_else.36134:
	jalr %zero %ra 0 #1642
trace_ray.2570:
	lw %a3 %a11 128 #1647
	lw %a4 %a11 124 #1647
	lw %a5 %a11 120 #1647
	lw %a6 %a11 116 #1647
	lw %a7 %a11 112 #1647
	lw %a8 %a11 108 #1647
	lw %a9 %a11 104 #1647
	lw %a10 %a11 100 #1647
	sw %a4 %sp 0 #1647
	lw %a4 %a11 96 #1647
	sw %a5 %sp 4 #1647
	lw %a5 %a11 92 #1647
	sw %a4 %sp 8 #1647
	lw %a4 %a11 88 #1647
	sw %a9 %sp 12 #1647
	lw %a9 %a11 84 #1647
	sw %a9 %sp 16 #1647
	lw %a9 %a11 80 #1647
	sw %a9 %sp 20 #1647
	lw %a9 %a11 76 #1647
	sw %a9 %sp 24 #1647
	lw %a9 %a11 72 #1647
	sw %a9 %sp 28 #1647
	lw %a9 %a11 68 #1647
	sw %a9 %sp 32 #1647
	lw %a9 %a11 64 #1647
	sw %a9 %sp 36 #1647
	lw %a9 %a11 60 #1647
	sw %a4 %sp 40 #1647
	lw %a4 %a11 56 #1647
	sw %a4 %sp 44 #1647
	lw %a4 %a11 52 #1647
	sw %a5 %sp 48 #1647
	lw %a5 %a11 48 #1647
	sw %a8 %sp 52 #1647
	lw %a8 %a11 44 #1647
	sw %a3 %sp 56 #1647
	lw %a3 %a11 40 #1647
	sw %a3 %sp 60 #1647
	lw %a3 %a11 36 #1647
	sw %a3 %sp 64 #1647
	lw %a3 %a11 32 #1647
	sw %a3 %sp 68 #1647
	lw %a3 %a11 28 #1647
	sw %a10 %sp 72 #1647
	lw %a10 %a11 24 #1647
	sw %a8 %sp 76 #1647
	lw %a8 %a11 20 #1647
	sw %a8 %sp 80 #1647
	lw %a8 %a11 16 #1647
	sw %a10 %sp 84 #1647
	lw %a10 %a11 12 #1647
	sw %a10 %sp 88 #1647
	lw %a10 %a11 8 #1647
	sw %a11 %sp 92 #1647
	lw %a11 %a11 4 #1647
	sw %a11 %sp 96 #1648
	addi %a11 %zero 4 #1648
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.36217
	sw %a2 %sp 100 #454
	lw %a2 %a2 8 #454
	li %f2 l.28749 #1369
	sw %f2 %a7 0 #1369
	sw %a11 %sp 104 #1370
	addi %a11 %zero 0 #1370
	sw %a4 %sp 108 #33
	lw %a4 %a4 0 #33
	sw %f1 %sp 112 #1370
	sw %a5 %sp 120 #1370
	sw %a8 %sp 124 #1370
	sw %a9 %sp 128 #1370
	sw %a10 %sp 132 #1370
	sw %f0 %sp 136 #1370
	sw %a3 %sp 144 #1370
	sw %a1 %sp 148 #1370
	sw %a2 %sp 152 #1370
	sw %a0 %sp 156 #1370
	sw %a7 %sp 160 #1370
	add %a2 %a1 %zero
	add %a0 %a11 %zero
	add %a1 %a4 %zero
	add %a11 %a6 %zero
	sw %ra %sp 164 #1370 call cls
	lw %a10 %a11 0 #1370
	addi %sp %sp 168 #1370	
	jalr %ra %a10 0 #1370
	addi %sp %sp -168 #1370
	lw %ra %sp 164 #1370
	lw %a0 %sp 160 #41
	lw %f1 %a0 0 #41
	li %f0 l.28314 #1373
	sw %f1 %sp 168 #1373
	sw %ra %sp 180 #1373 call dir
	addi %sp %sp 184 #1373	
	jal %ra min_caml_fless #1373
	addi %sp %sp -184 #1373
	lw %ra %sp 180 #1373
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36219 # nontail if
	addi %a0 %zero 0 #1373
	jal %zero beq_cont.36220 # then sentence ends
beq_else.36219:
	li %f1 l.28755 #1374
	lw %f0 %sp 168 #1374
	sw %ra %sp 180 #1374 call dir
	addi %sp %sp 184 #1374	
	jal %ra min_caml_fless #1374
	addi %sp %sp -184 #1374
	lw %ra %sp 180 #1374
beq_cont.36220:
	addi %a1 %zero 0 #1650
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36221
	addi %a0 %zero -1 #1713
	lw %a1 %sp 156 #1713
	slli %a2 %a1 2 #1713
	lw %a3 %sp 152 #1713
	add %a12 %a3 %a2 #1713
	sw %a0 %a12 0 #1713
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36222
	jalr %zero %ra 0 #1727
beq_else.36222:
	lw %a0 %sp 148 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 144 #181
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
	sw %ra %sp 180 #1716 call dir
	addi %sp %sp 184 #1716	
	jal %ra min_caml_fneg #1716
	addi %sp %sp -184 #1716
	lw %ra %sp 180 #1716
	sw %f0 %sp 176 #1718
	sw %ra %sp 188 #1718 call dir
	addi %sp %sp 192 #1718	
	jal %ra min_caml_fispos #1718
	addi %sp %sp -192 #1718
	lw %ra %sp 188 #1718
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36224
	jalr %zero %ra 0 #1726
beq_else.36224:
	lw %f0 %sp 176 #1721
	sw %ra %sp 188 #1721 call dir
	addi %sp %sp 192 #1721	
	jal %ra min_caml_fsqr #1721
	addi %sp %sp -192 #1721
	lw %ra %sp 188 #1721
	lw %f1 %sp 176 #1721
	fmul %f0 %f0 %f1 #1721
	lw %f1 %sp 136 #1721
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 132 #29
	lw %f1 %a0 0 #29
	fmul %f0 %f0 %f1 #1721
	lw %a0 %sp 128 #54
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
beq_else.36221:
	lw %a0 %sp 124 #45
	lw %a2 %a0 0 #45
	slli %a3 %a2 2 #20
	lw %a4 %sp 120 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	lw %a4 %a3 8 #248
	lw %a5 %a3 28 #346
	lw %f0 %a5 0 #351
	lw %f1 %sp 136 #1655
	fmul %f0 %f0 %f1 #1655
	lw %a5 %a3 4 #238
	sw %a4 %sp 184 #868
	sw %a1 %sp 188 #868
	sw %f0 %sp 192 #868
	sw %a2 %sp 200 #868
	sw %a3 %sp 204 #868
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.36227 # nontail if
	lw %a5 %sp 84 #39
	lw %a6 %a5 0 #39
	li %f2 l.27725 #147
	lw %a7 %sp 76 #140
	sw %f2 %a7 0 #140
	sw %f2 %a7 4 #141
	sw %f2 %a7 8 #142
	addi %a8 %a6 -1 #1479
	addi %a6 %a6 -1 #1479
	slli %a6 %a6 2 #1479
	lw %a9 %sp 148 #1479
	add %a12 %a9 %a6 #1479
	lw %f2 %a12 0 #1479
	sw %a8 %sp 208 #111
	sw %f2 %sp 216 #111
	fadd %f0 %f2 %fzero
	sw %ra %sp 228 #111 call dir
	addi %sp %sp 232 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -232 #111
	lw %ra %sp 228 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36230 # nontail if
	lw %f0 %sp 216 #112
	sw %ra %sp 228 #112 call dir
	addi %sp %sp 232 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -232 #112
	lw %ra %sp 228 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36232 # nontail if
	li %f0 l.27801 #113
	jal %zero beq_cont.36233 # then sentence ends
beq_else.36232:
	li %f0 l.27799 #112
beq_cont.36233:
	jal %zero beq_cont.36231 # then sentence ends
beq_else.36230:
	li %f0 l.27725 #111
beq_cont.36231:
	sw %ra %sp 228 #1479 call dir
	addi %sp %sp 232 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -232 #1479
	lw %ra %sp 228 #1479
	lw %a0 %sp 208 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 76 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.36228 # then sentence ends
beq_else.36227:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.36234 # nontail if
	lw %a5 %a3 16 #276
	lw %f2 %a5 0 #281
	fadd %f0 %f2 %fzero
	sw %ra %sp 228 #1485 call dir
	addi %sp %sp 232 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -232 #1485
	lw %ra %sp 228 #1485
	lw %a0 %sp 76 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 204 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 228 #1486 call dir
	addi %sp %sp 232 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -232 #1486
	lw %ra %sp 228 #1486
	lw %a0 %sp 76 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 204 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 228 #1487 call dir
	addi %sp %sp 232 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -232 #1487
	lw %ra %sp 228 #1487
	lw %a0 %sp 76 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.36235 # then sentence ends
beq_else.36234:
	lw %a11 %sp 88 #1520
	add %a0 %a3 %zero
	sw %ra %sp 228 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 232 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -232 #1520
	lw %ra %sp 228 #1520
beq_cont.36235:
beq_cont.36228:
	lw %a1 %sp 80 #152
	lw %f0 %a1 0 #152
	lw %a0 %sp 72 #152
	sw %f0 %a0 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a0 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a0 8 #154
	lw %a0 %sp 204 #1659
	lw %a11 %sp 56 #1659
	sw %ra %sp 228 #1659 call cls
	lw %a10 %a11 0 #1659
	addi %sp %sp 232 #1659	
	jalr %ra %a10 0 #1659
	addi %sp %sp -232 #1659
	lw %ra %sp 228 #1659
	lw %a0 %sp 200 #1662
	lw %a1 %sp 104 #1662
	sw %ra %sp 228 #1662 call dir
	addi %sp %sp 232 #1662	
	jal %ra min_caml_sll #1662
	addi %sp %sp -232 #1662
	lw %ra %sp 228 #1662
	lw %a1 %sp 84 #39
	lw %a2 %a1 0 #39
	add %a0 %a0 %a2 #1662
	lw %a2 %sp 156 #1662
	slli %a3 %a2 2 #1662
	lw %a4 %sp 152 #1662
	add %a12 %a4 %a3 #1662
	sw %a0 %a12 0 #1662
	lw %a0 %sp 100 #446
	lw %a3 %a0 4 #446
	slli %a5 %a2 2 #1664
	add %a12 %a3 %a5 #1664
	lw %a3 %a12 0 #1664
	lw %a5 %sp 80 #152
	lw %f0 %a5 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a5 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a5 8 #152
	sw %f0 %a3 8 #154
	lw %a3 %a0 12 #461
	lw %a6 %sp 204 #346
	lw %a7 %a6 28 #346
	lw %f0 %a7 0 #351
	li %f1 l.28702 #1668
	sw %a3 %sp 224 #1668
	sw %ra %sp 228 #1668 call dir
	addi %sp %sp 232 #1668	
	jal %ra min_caml_fless #1668
	addi %sp %sp -232 #1668
	lw %ra %sp 228 #1668
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36236 # nontail if
	addi %a0 %zero 1 #1671
	lw %a1 %sp 156 #1671
	slli %a2 %a1 2 #1671
	lw %a3 %sp 224 #1671
	add %a12 %a3 %a2 #1671
	sw %a0 %a12 0 #1671
	lw %a0 %sp 100 #468
	lw %a2 %a0 16 #468
	slli %a3 %a1 2 #1673
	add %a12 %a2 %a3 #1673
	lw %a3 %a12 0 #1673
	lw %a4 %sp 52 #152
	lw %f0 %a4 0 #152
	sw %f0 %a3 0 #152
	lw %f0 %a4 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a4 8 #152
	sw %f0 %a3 8 #154
	slli %a3 %a1 2 #1673
	add %a12 %a2 %a3 #1673
	lw %a2 %a12 0 #1673
	li %f0 l.28908 #1674
	lw %f1 %sp 192 #1674
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
	lw %a3 %sp 76 #152
	lw %f0 %a3 0 #152
	sw %f0 %a2 0 #152
	lw %f0 %a3 4 #152
	sw %f0 %a2 4 #153
	lw %f0 %a3 8 #152
	sw %f0 %a2 8 #154
	jal %zero beq_cont.36237 # then sentence ends
beq_else.36236:
	lw %a0 %sp 156 #1669
	slli %a1 %a0 2 #1669
	lw %a2 %sp 224 #1669
	lw %a3 %sp 188 #1669
	add %a12 %a2 %a1 #1669
	sw %a3 %a12 0 #1669
beq_cont.36237:
	li %f0 l.28923 #1679
	lw %a0 %sp 148 #181
	lw %f1 %a0 0 #181
	lw %a1 %sp 76 #181
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
	lw %a2 %sp 204 #356
	lw %a3 %a2 28 #356
	lw %f0 %a3 4 #361
	lw %f1 %sp 136 #1683
	fmul %f0 %f1 %f0 #1683
	lw %a3 %sp 108 #33
	lw %a4 %a3 0 #33
	lw %a5 %a4 0 #1257
	lw %a6 %a5 0 #1258
	sw %f0 %sp 232 #1259
	addi %a12 %zero -1
	bne %a6 %a12 beq_else.36239 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.36240 # then sentence ends
beq_else.36239:
	sw %a5 %sp 240 #1259
	sw %a4 %sp 244 #1259
	addi %a12 %zero 99
	bne %a6 %a12 beq_else.36241 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.36242 # then sentence ends
beq_else.36241:
	lw %a7 %sp 68 #1266
	lw %a8 %sp 80 #1266
	lw %a11 %sp 48 #1266
	add %a2 %a8 %zero
	add %a1 %a7 %zero
	add %a0 %a6 %zero
	sw %ra %sp 252 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 256 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -256 #1266
	lw %ra %sp 252 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36243 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36244 # then sentence ends
beq_else.36243:
	lw %a0 %sp 40 #37
	lw %f0 %a0 0 #37
	li %f1 l.28314 #1270
	sw %ra %sp 252 #1270 call dir
	addi %sp %sp 256 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -256 #1270
	lw %ra %sp 252 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36245 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36246 # then sentence ends
beq_else.36245:
	lw %a0 %sp 240 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36247 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36248 # then sentence ends
beq_else.36247:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 252 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 256 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -256 #1247
	lw %ra %sp 252 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36249 # nontail if
	lw %a0 %sp 240 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36251 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36252 # then sentence ends
beq_else.36251:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 252 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 256 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -256 #1247
	lw %ra %sp 252 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36253 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 240 #1251
	lw %a11 %sp 28 #1251
	sw %ra %sp 252 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 256 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -256 #1251
	lw %ra %sp 252 #1251
	jal %zero beq_cont.36254 # then sentence ends
beq_else.36253:
	addi %a0 %zero 1 #1249
beq_cont.36254:
beq_cont.36252:
	jal %zero beq_cont.36250 # then sentence ends
beq_else.36249:
	addi %a0 %zero 1 #1249
beq_cont.36250:
beq_cont.36248:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36255 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36256 # then sentence ends
beq_else.36255:
	addi %a0 %zero 1 #1272
beq_cont.36256:
beq_cont.36246:
beq_cont.36244:
beq_cont.36242:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36257 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 244 #1282
	lw %a11 %sp 24 #1282
	sw %ra %sp 252 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 256 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -256 #1282
	lw %ra %sp 252 #1282
	jal %zero beq_cont.36258 # then sentence ends
beq_else.36257:
	lw %a0 %sp 240 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36259 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36260 # then sentence ends
beq_else.36259:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 252 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 256 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -256 #1247
	lw %ra %sp 252 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36261 # nontail if
	lw %a0 %sp 240 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36263 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36264 # then sentence ends
beq_else.36263:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 32 #1247
	add %a0 %a3 %zero
	sw %ra %sp 252 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 256 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -256 #1247
	lw %ra %sp 252 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36265 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 240 #1251
	lw %a11 %sp 28 #1251
	sw %ra %sp 252 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 256 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -256 #1251
	lw %ra %sp 252 #1251
	jal %zero beq_cont.36266 # then sentence ends
beq_else.36265:
	addi %a0 %zero 1 #1249
beq_cont.36266:
beq_cont.36264:
	jal %zero beq_cont.36262 # then sentence ends
beq_else.36261:
	addi %a0 %zero 1 #1249
beq_cont.36262:
beq_cont.36260:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36267 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 244 #1280
	lw %a11 %sp 24 #1280
	sw %ra %sp 252 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 256 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -256 #1280
	lw %ra %sp 252 #1280
	jal %zero beq_cont.36268 # then sentence ends
beq_else.36267:
	addi %a0 %zero 1 #1278
beq_cont.36268:
beq_cont.36258:
beq_cont.36240:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36269 # nontail if
	lw %a0 %sp 76 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 144 #181
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
	sw %ra %sp 252 #1687 call dir
	addi %sp %sp 256 #1687	
	jal %ra min_caml_fneg #1687
	addi %sp %sp -256 #1687
	lw %ra %sp 252 #1687
	lw %f1 %sp 192 #1687
	fmul %f0 %f0 %f1 #1687
	lw %a0 %sp 148 #181
	lw %f2 %a0 0 #181
	lw %a1 %sp 144 #181
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
	sw %f0 %sp 248 #1688
	fadd %f0 %f2 %fzero
	sw %ra %sp 260 #1688 call dir
	addi %sp %sp 264 #1688	
	jal %ra min_caml_fneg #1688
	addi %sp %sp -264 #1688
	lw %ra %sp 260 #1688
	lw %f1 %sp 248 #1606
	sw %f0 %sp 256 #1606
	fadd %f0 %f1 %fzero
	sw %ra %sp 268 #1606 call dir
	addi %sp %sp 272 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -272 #1606
	lw %ra %sp 268 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36271 # nontail if
	jal %zero beq_cont.36272 # then sentence ends
beq_else.36271:
	lw %a0 %sp 128 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 52 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 248 #191
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
beq_cont.36272:
	lw %f0 %sp 256 #1611
	sw %ra %sp 268 #1611 call dir
	addi %sp %sp 272 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -272 #1611
	lw %ra %sp 268 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36273 # nontail if
	jal %zero beq_cont.36274 # then sentence ends
beq_else.36273:
	lw %f0 %sp 256 #1612
	sw %ra %sp 268 #1612 call dir
	addi %sp %sp 272 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -272 #1612
	lw %ra %sp 268 #1612
	sw %ra %sp 268 #1612 call dir
	addi %sp %sp 272 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -272 #1612
	lw %ra %sp 268 #1612
	lw %f1 %sp 232 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 128 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.36274:
	jal %zero beq_cont.36270 # then sentence ends
beq_else.36269:
beq_cont.36270:
	lw %a0 %sp 80 #152
	lw %f0 %a0 0 #152
	lw %a1 %sp 12 #152
	sw %f0 %a1 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a1 8 #154
	lw %a1 %sp 64 #15
	lw %a1 %a1 0 #15
	addi %a1 %a1 -1 #1147
	lw %a11 %sp 36 #1147
	sw %ra %sp 268 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 272 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -272 #1147
	lw %ra %sp 268 #1147
	lw %a0 %sp 60 #99
	lw %a0 %a0 0 #99
	addi %a0 %a0 -1 #1694
	addi %a1 %zero 0 #1622
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36275 # nontail if
	slli %a2 %a0 2 #95
	lw %a3 %sp 44 #95
	add %a12 %a3 %a2 #95
	lw %a2 %a12 0 #95
	lw %a3 %a2 4 #527
	li %f0 l.28749 #1458
	lw %a4 %sp 160 #1458
	sw %f0 %a4 0 #1458
	lw %a5 %sp 108 #33
	lw %a6 %a5 0 #33
	lw %a7 %a6 0 #1433
	lw %a8 %a7 0 #1434
	sw %a0 %sp 264 #1435
	sw %a3 %sp 268 #1435
	sw %a1 %sp 272 #1435
	sw %a2 %sp 276 #1435
	addi %a12 %zero -1
	bne %a8 %a12 beq_else.36277 # nontail if
	jal %zero beq_cont.36278 # then sentence ends
beq_else.36277:
	sw %a6 %sp 280 #1435
	addi %a12 %zero 99
	bne %a8 %a12 beq_else.36279 # nontail if
	lw %a8 %a7 4 #1423
	addi %a12 %zero -1
	bne %a8 %a12 beq_else.36281 # nontail if
	jal %zero beq_cont.36282 # then sentence ends
beq_else.36281:
	slli %a8 %a8 2 #31
	lw %a9 %sp 96 #31
	add %a12 %a9 %a8 #31
	lw %a8 %a12 0 #31
	addi %a10 %zero 0 #1426
	lw %a11 %sp 20 #1426
	sw %a7 %sp 284 #1426
	add %a2 %a3 %zero
	add %a1 %a8 %zero
	add %a0 %a10 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	lw %a0 %sp 284 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36283 # nontail if
	jal %zero beq_cont.36284 # then sentence ends
beq_else.36283:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 268 #1426
	lw %a11 %sp 20 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	lw %a0 %sp 284 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36285 # nontail if
	jal %zero beq_cont.36286 # then sentence ends
beq_else.36285:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 268 #1426
	lw %a11 %sp 20 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	lw %a0 %sp 284 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36287 # nontail if
	jal %zero beq_cont.36288 # then sentence ends
beq_else.36287:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 268 #1426
	lw %a11 %sp 20 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 284 #1427
	lw %a2 %sp 268 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 292 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 296 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -296 #1427
	lw %ra %sp 292 #1427
beq_cont.36288:
beq_cont.36286:
beq_cont.36284:
beq_cont.36282:
	jal %zero beq_cont.36280 # then sentence ends
beq_else.36279:
	lw %a11 %sp 8 #1443
	sw %a7 %sp 284 #1443
	add %a1 %a3 %zero
	add %a0 %a8 %zero
	sw %ra %sp 292 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 296 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -296 #1443
	lw %ra %sp 292 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36289 # nontail if
	jal %zero beq_cont.36290 # then sentence ends
beq_else.36289:
	lw %a0 %sp 40 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 160 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 292 #1446 call dir
	addi %sp %sp 296 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -296 #1446
	lw %ra %sp 292 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36291 # nontail if
	jal %zero beq_cont.36292 # then sentence ends
beq_else.36291:
	lw %a0 %sp 284 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36293 # nontail if
	jal %zero beq_cont.36294 # then sentence ends
beq_else.36293:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 268 #1426
	lw %a11 %sp 20 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	lw %a0 %sp 284 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36295 # nontail if
	jal %zero beq_cont.36296 # then sentence ends
beq_else.36295:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 268 #1426
	lw %a11 %sp 20 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	lw %a0 %sp 284 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36297 # nontail if
	jal %zero beq_cont.36298 # then sentence ends
beq_else.36297:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 268 #1426
	lw %a11 %sp 20 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	lw %a0 %sp 284 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36299 # nontail if
	jal %zero beq_cont.36300 # then sentence ends
beq_else.36299:
	slli %a1 %a1 2 #31
	lw %a2 %sp 96 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 268 #1426
	lw %a11 %sp 20 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 292 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 296 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -296 #1426
	lw %ra %sp 292 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 284 #1427
	lw %a2 %sp 268 #1427
	lw %a11 %sp 16 #1427
	sw %ra %sp 292 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 296 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -296 #1427
	lw %ra %sp 292 #1427
beq_cont.36300:
beq_cont.36298:
beq_cont.36296:
beq_cont.36294:
beq_cont.36292:
beq_cont.36290:
beq_cont.36280:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 280 #1451
	lw %a2 %sp 268 #1451
	lw %a11 %sp 4 #1451
	sw %ra %sp 292 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 296 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -296 #1451
	lw %ra %sp 292 #1451
beq_cont.36278:
	lw %a0 %sp 160 #41
	lw %f1 %a0 0 #41
	li %f0 l.28314 #1462
	sw %f1 %sp 288 #1462
	sw %ra %sp 300 #1462 call dir
	addi %sp %sp 304 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -304 #1462
	lw %ra %sp 300 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36301 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.36302 # then sentence ends
beq_else.36301:
	li %f1 l.28755 #1463
	lw %f0 %sp 288 #1463
	sw %ra %sp 300 #1463 call dir
	addi %sp %sp 304 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -304 #1463
	lw %ra %sp 300 #1463
beq_cont.36302:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36303 # nontail if
	jal %zero beq_cont.36304 # then sentence ends
beq_else.36303:
	lw %a0 %sp 124 #45
	lw %a0 %a0 0 #45
	addi %a1 %zero 4 #1628
	sw %ra %sp 300 #1628 call dir
	addi %sp %sp 304 #1628	
	jal %ra min_caml_sll #1628
	addi %sp %sp -304 #1628
	lw %ra %sp 300 #1628
	lw %a1 %sp 84 #39
	lw %a1 %a1 0 #39
	add %a0 %a0 %a1 #1628
	lw %a1 %sp 276 #521
	lw %a2 %a1 0 #521
	bne %a0 %a2 beq_else.36305 # nontail if
	lw %a0 %sp 108 #33
	lw %a0 %a0 0 #33
	lw %a2 %sp 272 #1631
	lw %a11 %sp 24 #1631
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 300 #1631 call cls
	lw %a10 %a11 0 #1631
	addi %sp %sp 304 #1631	
	jalr %ra %a10 0 #1631
	addi %sp %sp -304 #1631
	lw %ra %sp 300 #1631
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36307 # nontail if
	lw %a0 %sp 268 #507
	lw %a1 %a0 0 #507
	lw %a2 %sp 76 #181
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
	lw %a1 %sp 276 #533
	lw %f1 %a1 8 #533
	lw %f2 %sp 192 #1635
	fmul %f3 %f1 %f2 #1635
	fmul %f0 %f3 %f0 #1635
	lw %a0 %a0 0 #507
	lw %a1 %sp 148 #181
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
	sw %f1 %sp 296 #1606
	sw %f0 %sp 304 #1606
	sw %ra %sp 316 #1606 call dir
	addi %sp %sp 320 #1606	
	jal %ra min_caml_fispos #1606
	addi %sp %sp -320 #1606
	lw %ra %sp 316 #1606
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36309 # nontail if
	jal %zero beq_cont.36310 # then sentence ends
beq_else.36309:
	lw %a0 %sp 128 #191
	lw %f0 %a0 0 #191
	lw %a1 %sp 52 #191
	lw %f1 %a1 0 #191
	lw %f2 %sp 304 #191
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
beq_cont.36310:
	lw %f0 %sp 296 #1611
	sw %ra %sp 316 #1611 call dir
	addi %sp %sp 320 #1611	
	jal %ra min_caml_fispos #1611
	addi %sp %sp -320 #1611
	lw %ra %sp 316 #1611
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36311 # nontail if
	jal %zero beq_cont.36312 # then sentence ends
beq_else.36311:
	lw %f0 %sp 296 #1612
	sw %ra %sp 316 #1612 call dir
	addi %sp %sp 320 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -320 #1612
	lw %ra %sp 316 #1612
	sw %ra %sp 316 #1612 call dir
	addi %sp %sp 320 #1612	
	jal %ra min_caml_fsqr #1612
	addi %sp %sp -320 #1612
	lw %ra %sp 316 #1612
	lw %f1 %sp 232 #1612
	fmul %f0 %f0 %f1 #1612
	lw %a0 %sp 128 #54
	lw %f2 %a0 0 #54
	fadd %f2 %f2 %f0 #1613
	sw %f2 %a0 0 #1613
	lw %f2 %a0 4 #54
	fadd %f2 %f2 %f0 #1614
	sw %f2 %a0 4 #1614
	lw %f2 %a0 8 #54
	fadd %f0 %f2 %f0 #1615
	sw %f0 %a0 8 #1615
beq_cont.36312:
	jal %zero beq_cont.36308 # then sentence ends
beq_else.36307:
beq_cont.36308:
	jal %zero beq_cont.36306 # then sentence ends
beq_else.36305:
beq_cont.36306:
beq_cont.36304:
	lw %a0 %sp 264 #1641
	addi %a0 %a0 -1 #1641
	lw %f0 %sp 192 #1641
	lw %f1 %sp 232 #1641
	lw %a1 %sp 148 #1641
	lw %a11 %sp 0 #1641
	sw %ra %sp 316 #1641 call cls
	lw %a10 %a11 0 #1641
	addi %sp %sp 320 #1641	
	jalr %ra %a10 0 #1641
	addi %sp %sp -320 #1641
	lw %ra %sp 316 #1641
	jal %zero bge_cont.36276 # then sentence ends
bge_else.36275:
bge_cont.36276:
	li %f0 l.29046 #1697
	lw %f1 %sp 136 #1697
	sw %ra %sp 316 #1697 call dir
	addi %sp %sp 320 #1697	
	jal %ra min_caml_fless #1697
	addi %sp %sp -320 #1697
	lw %ra %sp 316 #1697
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36313
	jalr %zero %ra 0 #1708
beq_else.36313:
	lw %a0 %sp 156 #1648
	addi %a12 %zero 4
	blt %a0 %a12 bge_else.36315 # nontail if
	jal %zero bge_cont.36316 # then sentence ends
bge_else.36315:
	addi %a1 %a0 1 #1700
	addi %a2 %zero -1 #1700
	slli %a1 %a1 2 #1700
	lw %a3 %sp 152 #1700
	add %a12 %a3 %a1 #1700
	sw %a2 %a12 0 #1700
bge_cont.36316:
	lw %a1 %sp 184 #20
	addi %a12 %zero 2
	bne %a1 %a12 beq_else.36317
	li %f0 l.27799 #1704
	lw %a1 %sp 204 #346
	lw %a1 %a1 28 #346
	lw %f1 %a1 0 #351
	fsub %f0 %f0 %f1 #1704
	lw %f1 %sp 136 #1704
	fmul %f0 %f1 %f0 #1704
	addi %a0 %a0 1 #1705
	lw %a1 %sp 160 #41
	lw %f1 %a1 0 #41
	lw %f2 %sp 112 #1705
	fadd %f1 %f2 %f1 #1705
	lw %a1 %sp 148 #1705
	lw %a2 %sp 100 #1705
	lw %a11 %sp 92 #1705
	lw %a10 %a11 0 #1705
	jalr %zero %a10 0 #1705
beq_else.36317:
	jalr %zero %ra 0 #1706
bge_else.36217:
	jalr %zero %ra 0 #1729
trace_diffuse_ray.2576:
	lw %a1 %a11 80 #1737
	lw %a2 %a11 76 #1737
	lw %a3 %a11 72 #1737
	lw %a4 %a11 68 #1737
	lw %a5 %a11 64 #1737
	lw %a6 %a11 60 #1737
	lw %a7 %a11 56 #1737
	lw %a8 %a11 52 #1737
	lw %a9 %a11 48 #1737
	lw %a10 %a11 44 #1737
	sw %a4 %sp 0 #1737
	lw %a4 %a11 40 #1737
	sw %a7 %sp 4 #1737
	lw %a7 %a11 36 #1737
	sw %a8 %sp 8 #1737
	lw %a8 %a11 32 #1737
	sw %a9 %sp 12 #1737
	lw %a9 %a11 28 #1737
	sw %a9 %sp 16 #1737
	lw %a9 %a11 24 #1737
	sw %a6 %sp 20 #1737
	lw %a6 %a11 20 #1737
	sw %a8 %sp 24 #1737
	lw %a8 %a11 16 #1737
	sw %a5 %sp 28 #1737
	lw %a5 %a11 12 #1737
	sw %a6 %sp 32 #1737
	lw %a6 %a11 8 #1737
	lw %a11 %a11 4 #1737
	li %f1 l.28749 #1458
	sw %f1 %a3 0 #1458
	sw %a6 %sp 36 #1459
	addi %a6 %zero 0 #1459
	sw %a11 %sp 40 #33
	lw %a11 %a10 0 #33
	sw %f0 %sp 48 #1459
	sw %a10 %sp 56 #1459
	sw %a1 %sp 60 #1459
	sw %a5 %sp 64 #1459
	sw %a7 %sp 68 #1459
	sw %a9 %sp 72 #1459
	sw %a0 %sp 76 #1459
	sw %a4 %sp 80 #1459
	sw %a8 %sp 84 #1459
	sw %a3 %sp 88 #1459
	add %a1 %a11 %zero
	add %a11 %a2 %zero
	add %a2 %a0 %zero
	add %a0 %a6 %zero
	sw %ra %sp 92 #1459 call cls
	lw %a10 %a11 0 #1459
	addi %sp %sp 96 #1459	
	jalr %ra %a10 0 #1459
	addi %sp %sp -96 #1459
	lw %ra %sp 92 #1459
	lw %a0 %sp 88 #41
	lw %f1 %a0 0 #41
	li %f0 l.28314 #1462
	sw %f1 %sp 96 #1462
	sw %ra %sp 108 #1462 call dir
	addi %sp %sp 112 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -112 #1462
	lw %ra %sp 108 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36322 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.36323 # then sentence ends
beq_else.36322:
	li %f1 l.28755 #1463
	lw %f0 %sp 96 #1463
	sw %ra %sp 108 #1463 call dir
	addi %sp %sp 112 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -112 #1463
	lw %ra %sp 108 #1463
beq_cont.36323:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36324
	jalr %zero %ra 0 #1751
beq_else.36324:
	lw %a0 %sp 84 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a1 %sp 80 #20
	add %a12 %a1 %a0 #20
	lw %a0 %a12 0 #20
	lw %a1 %sp 76 #507
	lw %a1 %a1 0 #507
	lw %a2 %a0 4 #238
	sw %a0 %sp 104 #868
	addi %a12 %zero 1
	bne %a2 %a12 beq_else.36326 # nontail if
	lw %a2 %sp 72 #39
	lw %a2 %a2 0 #39
	li %f0 l.27725 #147
	lw %a3 %sp 68 #140
	sw %f0 %a3 0 #140
	sw %f0 %a3 4 #141
	sw %f0 %a3 8 #142
	addi %a4 %a2 -1 #1479
	addi %a2 %a2 -1 #1479
	slli %a2 %a2 2 #1479
	add %a12 %a1 %a2 #1479
	lw %f0 %a12 0 #1479
	sw %a4 %sp 108 #111
	sw %f0 %sp 112 #111
	sw %ra %sp 124 #111 call dir
	addi %sp %sp 128 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -128 #111
	lw %ra %sp 124 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36328 # nontail if
	lw %f0 %sp 112 #112
	sw %ra %sp 124 #112 call dir
	addi %sp %sp 128 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -128 #112
	lw %ra %sp 124 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36330 # nontail if
	li %f0 l.27801 #113
	jal %zero beq_cont.36331 # then sentence ends
beq_else.36330:
	li %f0 l.27799 #112
beq_cont.36331:
	jal %zero beq_cont.36329 # then sentence ends
beq_else.36328:
	li %f0 l.27725 #111
beq_cont.36329:
	sw %ra %sp 124 #1479 call dir
	addi %sp %sp 128 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -128 #1479
	lw %ra %sp 124 #1479
	lw %a0 %sp 108 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 68 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.36327 # then sentence ends
beq_else.36326:
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.36332 # nontail if
	lw %a1 %a0 16 #276
	lw %f0 %a1 0 #281
	sw %ra %sp 124 #1485 call dir
	addi %sp %sp 128 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -128 #1485
	lw %ra %sp 124 #1485
	lw %a0 %sp 68 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 104 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 124 #1486 call dir
	addi %sp %sp 128 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -128 #1486
	lw %ra %sp 124 #1486
	lw %a0 %sp 68 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 104 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 124 #1487 call dir
	addi %sp %sp 128 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -128 #1487
	lw %ra %sp 124 #1487
	lw %a0 %sp 68 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.36333 # then sentence ends
beq_else.36332:
	lw %a11 %sp 64 #1520
	sw %ra %sp 124 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 128 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -128 #1520
	lw %ra %sp 124 #1520
beq_cont.36333:
beq_cont.36327:
	lw %a0 %sp 104 #1743
	lw %a1 %sp 32 #1743
	lw %a11 %sp 60 #1743
	sw %ra %sp 124 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 128 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -128 #1743
	lw %ra %sp 124 #1743
	lw %a0 %sp 56 #33
	lw %a1 %a0 0 #33
	lw %a0 %a1 0 #1257
	lw %a2 %a0 0 #1258
	addi %a12 %zero -1
	bne %a2 %a12 beq_else.36334 # nontail if
	addi %a0 %zero 0 #1260
	jal %zero beq_cont.36335 # then sentence ends
beq_else.36334:
	sw %a0 %sp 120 #1259
	sw %a1 %sp 124 #1259
	addi %a12 %zero 99
	bne %a2 %a12 beq_else.36336 # nontail if
	addi %a0 %zero 1 #1264
	jal %zero beq_cont.36337 # then sentence ends
beq_else.36336:
	lw %a3 %sp 24 #1266
	lw %a4 %sp 32 #1266
	lw %a11 %sp 28 #1266
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 132 #1266 call cls
	lw %a10 %a11 0 #1266
	addi %sp %sp 136 #1266	
	jalr %ra %a10 0 #1266
	addi %sp %sp -136 #1266
	lw %ra %sp 132 #1266
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36338 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36339 # then sentence ends
beq_else.36338:
	lw %a0 %sp 20 #37
	lw %f0 %a0 0 #37
	li %f1 l.28314 #1270
	sw %ra %sp 132 #1270 call dir
	addi %sp %sp 136 #1270	
	jal %ra min_caml_fless #1270
	addi %sp %sp -136 #1270
	lw %ra %sp 132 #1270
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36340 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36341 # then sentence ends
beq_else.36340:
	lw %a0 %sp 120 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36342 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36343 # then sentence ends
beq_else.36342:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 132 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 136 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -136 #1247
	lw %ra %sp 132 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36344 # nontail if
	lw %a0 %sp 120 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36346 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36347 # then sentence ends
beq_else.36346:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 132 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 136 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -136 #1247
	lw %ra %sp 132 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36348 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 120 #1251
	lw %a11 %sp 8 #1251
	sw %ra %sp 132 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 136 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -136 #1251
	lw %ra %sp 132 #1251
	jal %zero beq_cont.36349 # then sentence ends
beq_else.36348:
	addi %a0 %zero 1 #1249
beq_cont.36349:
beq_cont.36347:
	jal %zero beq_cont.36345 # then sentence ends
beq_else.36344:
	addi %a0 %zero 1 #1249
beq_cont.36345:
beq_cont.36343:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36350 # nontail if
	addi %a0 %zero 0 #1269
	jal %zero beq_cont.36351 # then sentence ends
beq_else.36350:
	addi %a0 %zero 1 #1272
beq_cont.36351:
beq_cont.36341:
beq_cont.36339:
beq_cont.36337:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36352 # nontail if
	addi %a0 %zero 1 #1282
	lw %a1 %sp 124 #1282
	lw %a11 %sp 4 #1282
	sw %ra %sp 132 #1282 call cls
	lw %a10 %a11 0 #1282
	addi %sp %sp 136 #1282	
	jalr %ra %a10 0 #1282
	addi %sp %sp -136 #1282
	lw %ra %sp 132 #1282
	jal %zero beq_cont.36353 # then sentence ends
beq_else.36352:
	lw %a0 %sp 120 #1242
	lw %a1 %a0 4 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36354 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36355 # then sentence ends
beq_else.36354:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a3 %zero
	sw %ra %sp 132 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 136 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -136 #1247
	lw %ra %sp 132 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36356 # nontail if
	lw %a0 %sp 120 #1242
	lw %a1 %a0 8 #1242
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36358 # nontail if
	addi %a0 %zero 0 #1244
	jal %zero beq_cont.36359 # then sentence ends
beq_else.36358:
	slli %a1 %a1 2 #31
	lw %a2 %sp 40 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1247
	lw %a11 %sp 12 #1247
	add %a0 %a2 %zero
	sw %ra %sp 132 #1247 call cls
	lw %a10 %a11 0 #1247
	addi %sp %sp 136 #1247	
	jalr %ra %a10 0 #1247
	addi %sp %sp -136 #1247
	lw %ra %sp 132 #1247
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36360 # nontail if
	addi %a0 %zero 3 #1251
	lw %a1 %sp 120 #1251
	lw %a11 %sp 8 #1251
	sw %ra %sp 132 #1251 call cls
	lw %a10 %a11 0 #1251
	addi %sp %sp 136 #1251	
	jalr %ra %a10 0 #1251
	addi %sp %sp -136 #1251
	lw %ra %sp 132 #1251
	jal %zero beq_cont.36361 # then sentence ends
beq_else.36360:
	addi %a0 %zero 1 #1249
beq_cont.36361:
beq_cont.36359:
	jal %zero beq_cont.36357 # then sentence ends
beq_else.36356:
	addi %a0 %zero 1 #1249
beq_cont.36357:
beq_cont.36355:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36362 # nontail if
	addi %a0 %zero 1 #1280
	lw %a1 %sp 124 #1280
	lw %a11 %sp 4 #1280
	sw %ra %sp 132 #1280 call cls
	lw %a10 %a11 0 #1280
	addi %sp %sp 136 #1280	
	jalr %ra %a10 0 #1280
	addi %sp %sp -136 #1280
	lw %ra %sp 132 #1280
	jal %zero beq_cont.36363 # then sentence ends
beq_else.36362:
	addi %a0 %zero 1 #1278
beq_cont.36363:
beq_cont.36353:
beq_cont.36335:
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36364
	lw %a0 %sp 68 #181
	lw %f0 %a0 0 #181
	lw %a1 %sp 16 #181
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
	sw %ra %sp 132 #1747 call dir
	addi %sp %sp 136 #1747	
	jal %ra min_caml_fneg #1747
	addi %sp %sp -136 #1747
	lw %ra %sp 132 #1747
	sw %f0 %sp 128 #1748
	sw %ra %sp 140 #1748 call dir
	addi %sp %sp 144 #1748	
	jal %ra min_caml_fispos #1748
	addi %sp %sp -144 #1748
	lw %ra %sp 140 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36365 # nontail if
	li %f0 l.27725 #1748
	jal %zero beq_cont.36366 # then sentence ends
beq_else.36365:
	lw %f0 %sp 128 #559
beq_cont.36366:
	lw %f1 %sp 48 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 104 #346
	lw %a0 %a0 28 #346
	lw %f1 %a0 0 #351
	fmul %f0 %f0 %f1 #1749
	lw %a0 %sp 36 #191
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
beq_else.36364:
	jalr %zero %ra 0 #1750
iter_trace_diffuse_rays.2579:
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
	blt %a3 %a12 bge_else.36369
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
	sw %a1 %sp 56 #1760
	sw %a5 %sp 60 #1760
	sw %a10 %sp 64 #1760
	sw %a9 %sp 68 #1760
	sw %a2 %sp 72 #1760
	sw %a6 %sp 76 #1760
	sw %a11 %sp 80 #1760
	sw %a8 %sp 84 #1760
	sw %a7 %sp 88 #1760
	sw %f0 %sp 96 #1760
	sw %a0 %sp 104 #1760
	sw %a3 %sp 108 #1760
	sw %ra %sp 116 #1760 call dir
	addi %sp %sp 120 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -120 #1760
	lw %ra %sp 116 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36371 # nontail if
	lw %a0 %sp 108 #1757
	slli %a1 %a0 2 #1757
	lw %a2 %sp 104 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.29193 #1763
	lw %f1 %sp 96 #1763
	fdiv %f0 %f1 %f0 #1763
	li %f1 l.28749 #1458
	lw %a3 %sp 88 #1458
	sw %f1 %a3 0 #1458
	lw %a4 %sp 84 #33
	lw %a5 %a4 0 #33
	lw %a6 %a5 0 #1433
	lw %a7 %a6 0 #1434
	sw %f0 %sp 112 #1435
	sw %a1 %sp 120 #1435
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.36373 # nontail if
	jal %zero beq_cont.36374 # then sentence ends
beq_else.36373:
	sw %a5 %sp 124 #1435
	addi %a12 %zero 99
	bne %a7 %a12 beq_else.36375 # nontail if
	lw %a7 %a6 4 #1423
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.36377 # nontail if
	jal %zero beq_cont.36378 # then sentence ends
beq_else.36377:
	slli %a7 %a7 2 #31
	lw %a8 %sp 80 #31
	add %a12 %a8 %a7 #31
	lw %a7 %a12 0 #31
	addi %a9 %zero 0 #1426
	lw %a11 %sp 76 #1426
	sw %a6 %sp 128 #1426
	add %a2 %a1 %zero
	add %a0 %a9 %zero
	add %a1 %a7 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	lw %a0 %sp 128 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36379 # nontail if
	jal %zero beq_cont.36380 # then sentence ends
beq_else.36379:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 120 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	lw %a0 %sp 128 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36381 # nontail if
	jal %zero beq_cont.36382 # then sentence ends
beq_else.36381:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 120 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	lw %a0 %sp 128 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36383 # nontail if
	jal %zero beq_cont.36384 # then sentence ends
beq_else.36383:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 120 #1426
	lw %a11 %sp 76 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 128 #1427
	lw %a2 %sp 120 #1427
	lw %a11 %sp 72 #1427
	sw %ra %sp 132 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 136 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -136 #1427
	lw %ra %sp 132 #1427
beq_cont.36384:
beq_cont.36382:
beq_cont.36380:
beq_cont.36378:
	jal %zero beq_cont.36376 # then sentence ends
beq_else.36375:
	lw %a11 %sp 68 #1443
	sw %a6 %sp 128 #1443
	add %a0 %a7 %zero
	sw %ra %sp 132 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 136 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -136 #1443
	lw %ra %sp 132 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36385 # nontail if
	jal %zero beq_cont.36386 # then sentence ends
beq_else.36385:
	lw %a0 %sp 64 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 88 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 132 #1446 call dir
	addi %sp %sp 136 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -136 #1446
	lw %ra %sp 132 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36387 # nontail if
	jal %zero beq_cont.36388 # then sentence ends
beq_else.36387:
	lw %a0 %sp 128 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36389 # nontail if
	jal %zero beq_cont.36390 # then sentence ends
beq_else.36389:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 120 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	lw %a0 %sp 128 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36391 # nontail if
	jal %zero beq_cont.36392 # then sentence ends
beq_else.36391:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 120 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	lw %a0 %sp 128 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36393 # nontail if
	jal %zero beq_cont.36394 # then sentence ends
beq_else.36393:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 120 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	lw %a0 %sp 128 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36395 # nontail if
	jal %zero beq_cont.36396 # then sentence ends
beq_else.36395:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 120 #1426
	lw %a11 %sp 76 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 132 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 136 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -136 #1426
	lw %ra %sp 132 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 128 #1427
	lw %a2 %sp 120 #1427
	lw %a11 %sp 72 #1427
	sw %ra %sp 132 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 136 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -136 #1427
	lw %ra %sp 132 #1427
beq_cont.36396:
beq_cont.36394:
beq_cont.36392:
beq_cont.36390:
beq_cont.36388:
beq_cont.36386:
beq_cont.36376:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 124 #1451
	lw %a2 %sp 120 #1451
	lw %a11 %sp 60 #1451
	sw %ra %sp 132 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 136 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -136 #1451
	lw %ra %sp 132 #1451
beq_cont.36374:
	lw %a0 %sp 88 #41
	lw %f1 %a0 0 #41
	li %f0 l.28314 #1462
	sw %f1 %sp 136 #1462
	sw %ra %sp 148 #1462 call dir
	addi %sp %sp 152 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -152 #1462
	lw %ra %sp 148 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36398 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.36399 # then sentence ends
beq_else.36398:
	li %f1 l.28755 #1463
	lw %f0 %sp 136 #1463
	sw %ra %sp 148 #1463 call dir
	addi %sp %sp 152 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -152 #1463
	lw %ra %sp 148 #1463
beq_cont.36399:
	addi %a1 %zero 0 #1740
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36400 # nontail if
	jal %zero beq_cont.36401 # then sentence ends
beq_else.36400:
	lw %a0 %sp 40 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a2 %sp 20 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a2 %sp 120 #507
	lw %a2 %a2 0 #507
	lw %a3 %a0 4 #238
	sw %a1 %sp 144 #868
	sw %a0 %sp 148 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.36402 # nontail if
	lw %a3 %sp 32 #39
	lw %a3 %a3 0 #39
	li %f0 l.27725 #147
	lw %a4 %sp 24 #140
	sw %f0 %a4 0 #140
	sw %f0 %a4 4 #141
	sw %f0 %a4 8 #142
	addi %a5 %a3 -1 #1479
	addi %a3 %a3 -1 #1479
	slli %a3 %a3 2 #1479
	add %a12 %a2 %a3 #1479
	lw %f0 %a12 0 #1479
	sw %a5 %sp 152 #111
	sw %f0 %sp 160 #111
	sw %ra %sp 172 #111 call dir
	addi %sp %sp 176 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -176 #111
	lw %ra %sp 172 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36405 # nontail if
	lw %f0 %sp 160 #112
	sw %ra %sp 172 #112 call dir
	addi %sp %sp 176 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -176 #112
	lw %ra %sp 172 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36407 # nontail if
	li %f0 l.27801 #113
	jal %zero beq_cont.36408 # then sentence ends
beq_else.36407:
	li %f0 l.27799 #112
beq_cont.36408:
	jal %zero beq_cont.36406 # then sentence ends
beq_else.36405:
	li %f0 l.27725 #111
beq_cont.36406:
	sw %ra %sp 172 #1479 call dir
	addi %sp %sp 176 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -176 #1479
	lw %ra %sp 172 #1479
	lw %a0 %sp 152 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 24 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.36403 # then sentence ends
beq_else.36402:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.36409 # nontail if
	lw %a2 %a0 16 #276
	lw %f0 %a2 0 #281
	sw %ra %sp 172 #1485 call dir
	addi %sp %sp 176 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -176 #1485
	lw %ra %sp 172 #1485
	lw %a0 %sp 24 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 148 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 172 #1486 call dir
	addi %sp %sp 176 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -176 #1486
	lw %ra %sp 172 #1486
	lw %a0 %sp 24 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 148 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 172 #1487 call dir
	addi %sp %sp 176 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -176 #1487
	lw %ra %sp 172 #1487
	lw %a0 %sp 24 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.36410 # then sentence ends
beq_else.36409:
	lw %a11 %sp 44 #1520
	sw %ra %sp 172 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 176 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -176 #1520
	lw %ra %sp 172 #1520
beq_cont.36410:
beq_cont.36403:
	lw %a0 %sp 148 #1743
	lw %a1 %sp 36 #1743
	lw %a11 %sp 16 #1743
	sw %ra %sp 172 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 176 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -176 #1743
	lw %ra %sp 172 #1743
	lw %a0 %sp 84 #33
	lw %a1 %a0 0 #33
	lw %a0 %sp 144 #1746
	lw %a11 %sp 12 #1746
	sw %ra %sp 172 #1746 call cls
	lw %a10 %a11 0 #1746
	addi %sp %sp 176 #1746	
	jalr %ra %a10 0 #1746
	addi %sp %sp -176 #1746
	lw %ra %sp 172 #1746
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36411 # nontail if
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
	sw %ra %sp 172 #1747 call dir
	addi %sp %sp 176 #1747	
	jal %ra min_caml_fneg #1747
	addi %sp %sp -176 #1747
	lw %ra %sp 172 #1747
	sw %f0 %sp 168 #1748
	sw %ra %sp 180 #1748 call dir
	addi %sp %sp 184 #1748	
	jal %ra min_caml_fispos #1748
	addi %sp %sp -184 #1748
	lw %ra %sp 180 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36413 # nontail if
	li %f0 l.27725 #1748
	jal %zero beq_cont.36414 # then sentence ends
beq_else.36413:
	lw %f0 %sp 168 #559
beq_cont.36414:
	lw %f1 %sp 112 #1749
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
	jal %zero beq_cont.36412 # then sentence ends
beq_else.36411:
beq_cont.36412:
beq_cont.36401:
	jal %zero beq_cont.36372 # then sentence ends
beq_else.36371:
	lw %a0 %sp 108 #1761
	addi %a1 %a0 1 #1761
	slli %a1 %a1 2 #1757
	lw %a2 %sp 104 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.29128 #1761
	lw %f1 %sp 96 #1761
	fdiv %f0 %f1 %f0 #1761
	li %f1 l.28749 #1458
	lw %a3 %sp 88 #1458
	sw %f1 %a3 0 #1458
	lw %a4 %sp 84 #33
	lw %a5 %a4 0 #33
	lw %a6 %a5 0 #1433
	lw %a7 %a6 0 #1434
	sw %f0 %sp 176 #1435
	sw %a1 %sp 184 #1435
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.36415 # nontail if
	jal %zero beq_cont.36416 # then sentence ends
beq_else.36415:
	sw %a5 %sp 188 #1435
	addi %a12 %zero 99
	bne %a7 %a12 beq_else.36417 # nontail if
	lw %a7 %a6 4 #1423
	addi %a12 %zero -1
	bne %a7 %a12 beq_else.36419 # nontail if
	jal %zero beq_cont.36420 # then sentence ends
beq_else.36419:
	slli %a7 %a7 2 #31
	lw %a8 %sp 80 #31
	add %a12 %a8 %a7 #31
	lw %a7 %a12 0 #31
	addi %a9 %zero 0 #1426
	lw %a11 %sp 76 #1426
	sw %a6 %sp 192 #1426
	add %a2 %a1 %zero
	add %a0 %a9 %zero
	add %a1 %a7 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	lw %a0 %sp 192 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36421 # nontail if
	jal %zero beq_cont.36422 # then sentence ends
beq_else.36421:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 184 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	lw %a0 %sp 192 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36423 # nontail if
	jal %zero beq_cont.36424 # then sentence ends
beq_else.36423:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 184 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	lw %a0 %sp 192 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36425 # nontail if
	jal %zero beq_cont.36426 # then sentence ends
beq_else.36425:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 184 #1426
	lw %a11 %sp 76 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 192 #1427
	lw %a2 %sp 184 #1427
	lw %a11 %sp 72 #1427
	sw %ra %sp 196 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 200 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -200 #1427
	lw %ra %sp 196 #1427
beq_cont.36426:
beq_cont.36424:
beq_cont.36422:
beq_cont.36420:
	jal %zero beq_cont.36418 # then sentence ends
beq_else.36417:
	lw %a11 %sp 68 #1443
	sw %a6 %sp 192 #1443
	add %a0 %a7 %zero
	sw %ra %sp 196 #1443 call cls
	lw %a10 %a11 0 #1443
	addi %sp %sp 200 #1443	
	jalr %ra %a10 0 #1443
	addi %sp %sp -200 #1443
	lw %ra %sp 196 #1443
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36427 # nontail if
	jal %zero beq_cont.36428 # then sentence ends
beq_else.36427:
	lw %a0 %sp 64 #37
	lw %f0 %a0 0 #37
	lw %a0 %sp 88 #41
	lw %f1 %a0 0 #41
	sw %ra %sp 196 #1446 call dir
	addi %sp %sp 200 #1446	
	jal %ra min_caml_fless #1446
	addi %sp %sp -200 #1446
	lw %ra %sp 196 #1446
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36429 # nontail if
	jal %zero beq_cont.36430 # then sentence ends
beq_else.36429:
	lw %a0 %sp 192 #1423
	lw %a1 %a0 4 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36431 # nontail if
	jal %zero beq_cont.36432 # then sentence ends
beq_else.36431:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 184 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	lw %a0 %sp 192 #1423
	lw %a1 %a0 8 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36433 # nontail if
	jal %zero beq_cont.36434 # then sentence ends
beq_else.36433:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 184 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	lw %a0 %sp 192 #1423
	lw %a1 %a0 12 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36435 # nontail if
	jal %zero beq_cont.36436 # then sentence ends
beq_else.36435:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a3 %zero 0 #1426
	lw %a4 %sp 184 #1426
	lw %a11 %sp 76 #1426
	add %a2 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	lw %a0 %sp 192 #1423
	lw %a1 %a0 16 #1423
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36437 # nontail if
	jal %zero beq_cont.36438 # then sentence ends
beq_else.36437:
	slli %a1 %a1 2 #31
	lw %a2 %sp 80 #31
	add %a12 %a2 %a1 #31
	lw %a1 %a12 0 #31
	addi %a2 %zero 0 #1426
	lw %a3 %sp 184 #1426
	lw %a11 %sp 76 #1426
	add %a0 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 196 #1426 call cls
	lw %a10 %a11 0 #1426
	addi %sp %sp 200 #1426	
	jalr %ra %a10 0 #1426
	addi %sp %sp -200 #1426
	lw %ra %sp 196 #1426
	addi %a0 %zero 5 #1427
	lw %a1 %sp 192 #1427
	lw %a2 %sp 184 #1427
	lw %a11 %sp 72 #1427
	sw %ra %sp 196 #1427 call cls
	lw %a10 %a11 0 #1427
	addi %sp %sp 200 #1427	
	jalr %ra %a10 0 #1427
	addi %sp %sp -200 #1427
	lw %ra %sp 196 #1427
beq_cont.36438:
beq_cont.36436:
beq_cont.36434:
beq_cont.36432:
beq_cont.36430:
beq_cont.36428:
beq_cont.36418:
	addi %a0 %zero 1 #1451
	lw %a1 %sp 188 #1451
	lw %a2 %sp 184 #1451
	lw %a11 %sp 60 #1451
	sw %ra %sp 196 #1451 call cls
	lw %a10 %a11 0 #1451
	addi %sp %sp 200 #1451	
	jalr %ra %a10 0 #1451
	addi %sp %sp -200 #1451
	lw %ra %sp 196 #1451
beq_cont.36416:
	lw %a0 %sp 88 #41
	lw %f1 %a0 0 #41
	li %f0 l.28314 #1462
	sw %f1 %sp 200 #1462
	sw %ra %sp 212 #1462 call dir
	addi %sp %sp 216 #1462	
	jal %ra min_caml_fless #1462
	addi %sp %sp -216 #1462
	lw %ra %sp 212 #1462
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36440 # nontail if
	addi %a0 %zero 0 #1462
	jal %zero beq_cont.36441 # then sentence ends
beq_else.36440:
	li %f1 l.28755 #1463
	lw %f0 %sp 200 #1463
	sw %ra %sp 212 #1463 call dir
	addi %sp %sp 216 #1463	
	jal %ra min_caml_fless #1463
	addi %sp %sp -216 #1463
	lw %ra %sp 212 #1463
beq_cont.36441:
	addi %a1 %zero 0 #1740
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36442 # nontail if
	jal %zero beq_cont.36443 # then sentence ends
beq_else.36442:
	lw %a0 %sp 40 #45
	lw %a0 %a0 0 #45
	slli %a0 %a0 2 #20
	lw %a2 %sp 20 #20
	add %a12 %a2 %a0 #20
	lw %a0 %a12 0 #20
	lw %a2 %sp 184 #507
	lw %a2 %a2 0 #507
	lw %a3 %a0 4 #238
	sw %a1 %sp 208 #868
	sw %a0 %sp 212 #868
	addi %a12 %zero 1
	bne %a3 %a12 beq_else.36444 # nontail if
	lw %a3 %sp 32 #39
	lw %a3 %a3 0 #39
	li %f0 l.27725 #147
	lw %a4 %sp 24 #140
	sw %f0 %a4 0 #140
	sw %f0 %a4 4 #141
	sw %f0 %a4 8 #142
	addi %a5 %a3 -1 #1479
	addi %a3 %a3 -1 #1479
	slli %a3 %a3 2 #1479
	add %a12 %a2 %a3 #1479
	lw %f0 %a12 0 #1479
	sw %a5 %sp 216 #111
	sw %f0 %sp 224 #111
	sw %ra %sp 236 #111 call dir
	addi %sp %sp 240 #111	
	jal %ra min_caml_fiszero #111
	addi %sp %sp -240 #111
	lw %ra %sp 236 #111
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36447 # nontail if
	lw %f0 %sp 224 #112
	sw %ra %sp 236 #112 call dir
	addi %sp %sp 240 #112	
	jal %ra min_caml_fispos #112
	addi %sp %sp -240 #112
	lw %ra %sp 236 #112
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36449 # nontail if
	li %f0 l.27801 #113
	jal %zero beq_cont.36450 # then sentence ends
beq_else.36449:
	li %f0 l.27799 #112
beq_cont.36450:
	jal %zero beq_cont.36448 # then sentence ends
beq_else.36447:
	li %f0 l.27725 #111
beq_cont.36448:
	sw %ra %sp 236 #1479 call dir
	addi %sp %sp 240 #1479	
	jal %ra min_caml_fneg #1479
	addi %sp %sp -240 #1479
	lw %ra %sp 236 #1479
	lw %a0 %sp 216 #1479
	slli %a0 %a0 2 #1479
	lw %a1 %sp 24 #1479
	add %a12 %a1 %a0 #1479
	sw %f0 %a12 0 #1479
	jal %zero beq_cont.36445 # then sentence ends
beq_else.36444:
	addi %a12 %zero 2
	bne %a3 %a12 beq_else.36451 # nontail if
	lw %a2 %a0 16 #276
	lw %f0 %a2 0 #281
	sw %ra %sp 236 #1485 call dir
	addi %sp %sp 240 #1485	
	jal %ra min_caml_fneg #1485
	addi %sp %sp -240 #1485
	lw %ra %sp 236 #1485
	lw %a0 %sp 24 #1485
	sw %f0 %a0 0 #1485
	lw %a1 %sp 212 #286
	lw %a2 %a1 16 #286
	lw %f0 %a2 4 #291
	sw %ra %sp 236 #1486 call dir
	addi %sp %sp 240 #1486	
	jal %ra min_caml_fneg #1486
	addi %sp %sp -240 #1486
	lw %ra %sp 236 #1486
	lw %a0 %sp 24 #1486
	sw %f0 %a0 4 #1486
	lw %a1 %sp 212 #296
	lw %a2 %a1 16 #296
	lw %f0 %a2 8 #301
	sw %ra %sp 236 #1487 call dir
	addi %sp %sp 240 #1487	
	jal %ra min_caml_fneg #1487
	addi %sp %sp -240 #1487
	lw %ra %sp 236 #1487
	lw %a0 %sp 24 #1487
	sw %f0 %a0 8 #1487
	jal %zero beq_cont.36452 # then sentence ends
beq_else.36451:
	lw %a11 %sp 44 #1520
	sw %ra %sp 236 #1520 call cls
	lw %a10 %a11 0 #1520
	addi %sp %sp 240 #1520	
	jalr %ra %a10 0 #1520
	addi %sp %sp -240 #1520
	lw %ra %sp 236 #1520
beq_cont.36452:
beq_cont.36445:
	lw %a0 %sp 212 #1743
	lw %a1 %sp 36 #1743
	lw %a11 %sp 16 #1743
	sw %ra %sp 236 #1743 call cls
	lw %a10 %a11 0 #1743
	addi %sp %sp 240 #1743	
	jalr %ra %a10 0 #1743
	addi %sp %sp -240 #1743
	lw %ra %sp 236 #1743
	lw %a0 %sp 84 #33
	lw %a1 %a0 0 #33
	lw %a0 %sp 208 #1746
	lw %a11 %sp 12 #1746
	sw %ra %sp 236 #1746 call cls
	lw %a10 %a11 0 #1746
	addi %sp %sp 240 #1746	
	jalr %ra %a10 0 #1746
	addi %sp %sp -240 #1746
	lw %ra %sp 236 #1746
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36453 # nontail if
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
	sw %ra %sp 236 #1747 call dir
	addi %sp %sp 240 #1747	
	jal %ra min_caml_fneg #1747
	addi %sp %sp -240 #1747
	lw %ra %sp 236 #1747
	sw %f0 %sp 232 #1748
	sw %ra %sp 244 #1748 call dir
	addi %sp %sp 248 #1748	
	jal %ra min_caml_fispos #1748
	addi %sp %sp -248 #1748
	lw %ra %sp 244 #1748
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36455 # nontail if
	li %f0 l.27725 #1748
	jal %zero beq_cont.36456 # then sentence ends
beq_else.36455:
	lw %f0 %sp 232 #559
beq_cont.36456:
	lw %f1 %sp 176 #1749
	fmul %f0 %f1 %f0 #1749
	lw %a0 %sp 212 #346
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
	jal %zero beq_cont.36454 # then sentence ends
beq_else.36453:
beq_cont.36454:
beq_cont.36443:
beq_cont.36372:
	lw %a0 %sp 108 #1765
	addi %a0 %a0 -2 #1765
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36457
	slli %a1 %a0 2 #1757
	lw %a2 %sp 104 #1757
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
	sw %f0 %sp 240 #1760
	sw %a0 %sp 248 #1760
	sw %ra %sp 252 #1760 call dir
	addi %sp %sp 256 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -256 #1760
	lw %ra %sp 252 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36458 # nontail if
	lw %a0 %sp 248 #1757
	slli %a1 %a0 2 #1757
	lw %a2 %sp 104 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.29193 #1763
	lw %f1 %sp 240 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 4 #1763
	add %a0 %a1 %zero
	sw %ra %sp 252 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 256 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -256 #1763
	lw %ra %sp 252 #1763
	jal %zero beq_cont.36459 # then sentence ends
beq_else.36458:
	lw %a0 %sp 248 #1761
	addi %a1 %a0 1 #1761
	slli %a1 %a1 2 #1757
	lw %a2 %sp 104 #1757
	add %a12 %a2 %a1 #1757
	lw %a1 %a12 0 #1757
	li %f0 l.29128 #1761
	lw %f1 %sp 240 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 4 #1761
	add %a0 %a1 %zero
	sw %ra %sp 252 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 256 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -256 #1761
	lw %ra %sp 252 #1761
beq_cont.36459:
	lw %a0 %sp 248 #1765
	addi %a3 %a0 -2 #1765
	lw %a0 %sp 104 #1765
	lw %a1 %sp 56 #1765
	lw %a2 %sp 0 #1765
	lw %a11 %sp 48 #1765
	lw %a10 %a11 0 #1765
	jalr %zero %a10 0 #1765
bge_else.36457:
	jalr %zero %ra 0 #1766
bge_else.36369:
	jalr %zero %ra 0 #1766
trace_diffuse_ray_80percent.2588:
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
	bne %a0 %a12 beq_else.36462 # nontail if
	jal %zero beq_cont.36463 # then sentence ends
beq_else.36462:
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
beq_cont.36463:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.36464 # nontail if
	jal %zero beq_cont.36465 # then sentence ends
beq_else.36464:
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
beq_cont.36465:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.36466 # nontail if
	jal %zero beq_cont.36467 # then sentence ends
beq_else.36466:
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
beq_cont.36467:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.36468 # nontail if
	jal %zero beq_cont.36469 # then sentence ends
beq_else.36468:
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
beq_cont.36469:
	lw %a0 %sp 28 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.36470
	jalr %zero %ra 0 #1798
beq_else.36470:
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
	bne %a0 %a12 beq_else.36472 # nontail if
	jal %zero beq_cont.36473 # then sentence ends
beq_else.36472:
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
	bne %a0 %a12 beq_else.36474 # nontail if
	lw %a0 %sp 52 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.29193 #1763
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
	jal %zero beq_cont.36475 # then sentence ends
beq_else.36474:
	lw %a0 %sp 52 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.29128 #1761
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
beq_cont.36475:
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
beq_cont.36473:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.36476 # nontail if
	jal %zero beq_cont.36477 # then sentence ends
beq_else.36476:
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
	bne %a0 %a12 beq_else.36479 # nontail if
	lw %a0 %sp 64 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.29193 #1763
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
	jal %zero beq_cont.36480 # then sentence ends
beq_else.36479:
	lw %a0 %sp 64 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.29128 #1761
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
beq_cont.36480:
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
beq_cont.36477:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.36481 # nontail if
	jal %zero beq_cont.36482 # then sentence ends
beq_else.36481:
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
	bne %a0 %a12 beq_else.36484 # nontail if
	lw %a0 %sp 80 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.29193 #1763
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
	jal %zero beq_cont.36485 # then sentence ends
beq_else.36484:
	lw %a0 %sp 80 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.29128 #1761
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
beq_cont.36485:
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
beq_cont.36482:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.36486 # nontail if
	jal %zero beq_cont.36487 # then sentence ends
beq_else.36486:
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
	bne %a0 %a12 beq_else.36489 # nontail if
	lw %a0 %sp 96 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.29193 #1763
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
	jal %zero beq_cont.36490 # then sentence ends
beq_else.36489:
	lw %a0 %sp 96 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.29128 #1761
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
beq_cont.36490:
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
beq_cont.36487:
	lw %a0 %sp 48 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.36491 # nontail if
	jal %zero beq_cont.36492 # then sentence ends
beq_else.36491:
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
	bne %a0 %a12 beq_else.36494 # nontail if
	lw %a0 %sp 112 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.29193 #1763
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
	jal %zero beq_cont.36495 # then sentence ends
beq_else.36494:
	lw %a0 %sp 112 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.29128 #1761
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
beq_cont.36495:
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
beq_cont.36492:
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
	blt %a12 %a1 bge_else.36498
	sw %a11 %sp 0 #454
	lw %a11 %a0 8 #454
	sw %a2 %sp 4 #1662
	slli %a2 %a1 2 #1662
	add %a12 %a11 %a2 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36499
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
	bne %a2 %a12 beq_else.36500 # nontail if
	jal %zero beq_cont.36501 # then sentence ends
beq_else.36500:
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
	bne %a2 %a12 beq_else.36502 # nontail if
	jal %zero beq_cont.36503 # then sentence ends
beq_else.36502:
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
beq_cont.36503:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.36504 # nontail if
	jal %zero beq_cont.36505 # then sentence ends
beq_else.36504:
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
beq_cont.36505:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.36506 # nontail if
	jal %zero beq_cont.36507 # then sentence ends
beq_else.36506:
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
beq_cont.36507:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 3
	bne %a0 %a12 beq_else.36508 # nontail if
	jal %zero beq_cont.36509 # then sentence ends
beq_else.36508:
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
beq_cont.36509:
	lw %a0 %sp 60 #1780
	addi %a12 %zero 4
	bne %a0 %a12 beq_else.36510 # nontail if
	jal %zero beq_cont.36511 # then sentence ends
beq_else.36510:
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
beq_cont.36511:
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
beq_cont.36501:
	lw %a0 %sp 24 #1850
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.36512
	lw %a0 %sp 20 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36513
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 84 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36514 # nontail if
	jal %zero beq_cont.36515 # then sentence ends
beq_else.36514:
	lw %a11 %sp 16 #1848
	sw %ra %sp 92 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 96 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -96 #1848
	lw %ra %sp 92 #1848
beq_cont.36515:
	lw %a0 %sp 84 #1850
	addi %a0 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.36516
	lw %a1 %sp 20 #454
	lw %a2 %a1 8 #454
	slli %a3 %a0 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36517
	lw %a2 %a1 12 #461
	slli %a3 %a0 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36518 # nontail if
	jal %zero beq_cont.36519 # then sentence ends
beq_else.36518:
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
beq_cont.36519:
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.36520
	lw %a0 %sp 20 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36521
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 96 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36522 # nontail if
	jal %zero beq_cont.36523 # then sentence ends
beq_else.36522:
	lw %a11 %sp 16 #1848
	sw %ra %sp 100 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 104 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -104 #1848
	lw %ra %sp 100 #1848
beq_cont.36523:
	lw %a0 %sp 96 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 20 #1850
	lw %a11 %sp 0 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.36521:
	jalr %zero %ra 0 #1851
bge_else.36520:
	jalr %zero %ra 0 #1852
bge_else.36517:
	jalr %zero %ra 0 #1851
bge_else.36516:
	jalr %zero %ra 0 #1852
bge_else.36513:
	jalr %zero %ra 0 #1851
bge_else.36512:
	jalr %zero %ra 0 #1852
bge_else.36499:
	jalr %zero %ra 0 #1851
bge_else.36498:
	jalr %zero %ra 0 #1852
try_exploit_neighbors.2617:
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
	blt %a12 %a5 bge_else.36532
	sw %a10 %sp 8 #454
	lw %a10 %a11 8 #454
	sw %a8 %sp 12 #1662
	slli %a8 %a5 2 #1662
	add %a12 %a10 %a8 #1662
	lw %a8 %a12 0 #1662
	addi %a12 %zero 0
	blt %a8 %a12 bge_else.36533
	slli %a8 %a0 2 #1875
	add %a12 %a3 %a8 #1875
	lw %a8 %a12 0 #1875
	lw %a8 %a8 8 #454
	slli %a10 %a5 2 #1662
	add %a12 %a8 %a10 #1662
	lw %a8 %a12 0 #1662
	slli %a10 %a0 2 #1877
	add %a12 %a2 %a10 #1877
	lw %a10 %a12 0 #1877
	lw %a10 %a10 8 #454
	sw %a2 %sp 16 #1662
	slli %a2 %a5 2 #1662
	add %a12 %a10 %a2 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a8 beq_else.36534 # nontail if
	slli %a2 %a0 2 #1878
	add %a12 %a4 %a2 #1878
	lw %a2 %a12 0 #1878
	lw %a2 %a2 8 #454
	slli %a10 %a5 2 #1662
	add %a12 %a2 %a10 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a8 beq_else.36536 # nontail if
	addi %a2 %a0 -1 #1879
	slli %a2 %a2 2 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a2 %a2 8 #454
	slli %a10 %a5 2 #1662
	add %a12 %a2 %a10 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a8 beq_else.36538 # nontail if
	addi %a2 %a0 1 #1880
	slli %a2 %a2 2 #1875
	add %a12 %a3 %a2 #1875
	lw %a2 %a12 0 #1875
	lw %a2 %a2 8 #454
	slli %a10 %a5 2 #1662
	add %a12 %a2 %a10 #1662
	lw %a2 %a12 0 #1662
	bne %a2 %a8 beq_else.36540 # nontail if
	addi %a2 %zero 1 #1881
	jal %zero beq_cont.36541 # then sentence ends
beq_else.36540:
	addi %a2 %zero 0 #1882
beq_cont.36541:
	jal %zero beq_cont.36539 # then sentence ends
beq_else.36538:
	addi %a2 %zero 0 #1883
beq_cont.36539:
	jal %zero beq_cont.36537 # then sentence ends
beq_else.36536:
	addi %a2 %zero 0 #1884
beq_cont.36537:
	jal %zero beq_cont.36535 # then sentence ends
beq_else.36534:
	addi %a2 %zero 0 #1885
beq_cont.36535:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36542
	addi %a12 %zero 4
	blt %a12 %a5 bge_else.36543
	lw %a0 %a11 8 #454
	slli %a2 %a5 2 #1662
	add %a12 %a0 %a2 #1662
	lw %a0 %a12 0 #1662
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36544
	lw %a0 %a11 12 #461
	slli %a2 %a5 2 #1669
	add %a12 %a0 %a2 #1669
	lw %a0 %a12 0 #1669
	sw %a1 %sp 20 #1669
	sw %a7 %sp 24 #1669
	sw %a6 %sp 28 #1669
	sw %a9 %sp 32 #1669
	sw %a11 %sp 36 #1669
	sw %a5 %sp 40 #1669
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36545 # nontail if
	jal %zero beq_cont.36546 # then sentence ends
beq_else.36545:
	add %a0 %a11 %zero
	add %a11 %a1 %zero
	add %a1 %a5 %zero
	sw %ra %sp 44 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 48 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -48 #1848
	lw %ra %sp 44 #1848
beq_cont.36546:
	lw %a0 %sp 40 #1850
	addi %a0 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a0 bge_else.36547
	lw %a1 %sp 36 #454
	lw %a2 %a1 8 #454
	slli %a3 %a0 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36548
	lw %a2 %a1 12 #461
	slli %a3 %a0 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36549 # nontail if
	jal %zero beq_cont.36550 # then sentence ends
beq_else.36549:
	lw %a2 %a1 20 #475
	lw %a3 %a1 28 #498
	lw %a4 %a1 4 #446
	lw %a5 %a1 16 #468
	slli %a6 %a0 2 #1810
	add %a12 %a2 %a6 #1810
	lw %a2 %a12 0 #1810
	lw %f0 %a2 0 #152
	lw %a6 %sp 32 #152
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
	lw %a11 %sp 28 #1811
	sw %a5 %sp 44 #1811
	sw %a0 %sp 48 #1811
	add %a1 %a3 %zero
	add %a0 %a2 %zero
	add %a2 %a4 %zero
	sw %ra %sp 52 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 56 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -56 #1811
	lw %ra %sp 52 #1811
	lw %a0 %sp 48 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 44 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 24 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 32 #219
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
beq_cont.36550:
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.36551
	lw %a0 %sp 36 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36552
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 52 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36553 # nontail if
	jal %zero beq_cont.36554 # then sentence ends
beq_else.36553:
	lw %a11 %sp 20 #1848
	sw %ra %sp 60 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 64 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -64 #1848
	lw %ra %sp 60 #1848
beq_cont.36554:
	lw %a0 %sp 52 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 36 #1850
	lw %a11 %sp 12 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.36552:
	jalr %zero %ra 0 #1851
bge_else.36551:
	jalr %zero %ra 0 #1852
bge_else.36548:
	jalr %zero %ra 0 #1851
bge_else.36547:
	jalr %zero %ra 0 #1852
bge_else.36544:
	jalr %zero %ra 0 #1851
bge_else.36543:
	jalr %zero %ra 0 #1852
beq_else.36542:
	lw %a2 %a11 12 #461
	slli %a8 %a5 2 #1669
	add %a12 %a2 %a8 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 20 #1669
	sw %a6 %sp 28 #1669
	sw %a4 %sp 56 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36561 # nontail if
	jal %zero beq_cont.36562 # then sentence ends
beq_else.36561:
	slli %a2 %a0 2 #1823
	lw %a8 %sp 16 #1823
	add %a12 %a8 %a2 #1823
	lw %a2 %a12 0 #1823
	lw %a2 %a2 20 #475
	addi %a10 %a0 -1 #1824
	slli %a10 %a10 2 #1824
	add %a12 %a3 %a10 #1824
	lw %a10 %a12 0 #1824
	lw %a10 %a10 20 #475
	slli %a11 %a0 2 #1824
	add %a12 %a3 %a11 #1824
	lw %a11 %a12 0 #1824
	lw %a11 %a11 20 #475
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
	add %a12 %a10 %a2 #1810
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
beq_cont.36562:
	addi %a4 %a5 1 #1906
	slli %a1 %a0 2 #1891
	add %a12 %a3 %a1 #1891
	lw %a1 %a12 0 #1891
	addi %a12 %zero 4
	blt %a12 %a4 bge_else.36563
	lw %a2 %a1 8 #454
	slli %a5 %a4 2 #1662
	add %a12 %a2 %a5 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36564
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
	bne %a5 %a2 beq_else.36565 # nontail if
	slli %a5 %a0 2 #1878
	lw %a8 %sp 56 #1878
	add %a12 %a8 %a5 #1878
	lw %a5 %a12 0 #1878
	lw %a5 %a5 8 #454
	slli %a10 %a4 2 #1662
	add %a12 %a5 %a10 #1662
	lw %a5 %a12 0 #1662
	bne %a5 %a2 beq_else.36567 # nontail if
	addi %a5 %a0 -1 #1879
	slli %a5 %a5 2 #1875
	add %a12 %a3 %a5 #1875
	lw %a5 %a12 0 #1875
	lw %a5 %a5 8 #454
	slli %a10 %a4 2 #1662
	add %a12 %a5 %a10 #1662
	lw %a5 %a12 0 #1662
	bne %a5 %a2 beq_else.36569 # nontail if
	addi %a5 %a0 1 #1880
	slli %a5 %a5 2 #1875
	add %a12 %a3 %a5 #1875
	lw %a5 %a12 0 #1875
	lw %a5 %a5 8 #454
	slli %a10 %a4 2 #1662
	add %a12 %a5 %a10 #1662
	lw %a5 %a12 0 #1662
	bne %a5 %a2 beq_else.36571 # nontail if
	addi %a2 %zero 1 #1881
	jal %zero beq_cont.36572 # then sentence ends
beq_else.36571:
	addi %a2 %zero 0 #1882
beq_cont.36572:
	jal %zero beq_cont.36570 # then sentence ends
beq_else.36569:
	addi %a2 %zero 0 #1883
beq_cont.36570:
	jal %zero beq_cont.36568 # then sentence ends
beq_else.36567:
	addi %a2 %zero 0 #1884
beq_cont.36568:
	jal %zero beq_cont.36566 # then sentence ends
beq_else.36565:
	addi %a2 %zero 0 #1885
beq_cont.36566:
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36573
	addi %a12 %zero 4
	blt %a12 %a4 bge_else.36574
	lw %a0 %a1 8 #454
	slli %a2 %a4 2 #1662
	add %a12 %a0 %a2 #1662
	lw %a0 %a12 0 #1662
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36575
	lw %a0 %a1 12 #461
	slli %a2 %a4 2 #1669
	add %a12 %a0 %a2 #1669
	lw %a0 %a12 0 #1669
	sw %a1 %sp 60 #1669
	sw %a4 %sp 64 #1669
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36576 # nontail if
	jal %zero beq_cont.36577 # then sentence ends
beq_else.36576:
	lw %a0 %a1 20 #475
	lw %a2 %a1 28 #498
	lw %a3 %a1 4 #446
	lw %a5 %a1 16 #468
	slli %a6 %a4 2 #1810
	add %a12 %a0 %a6 #1810
	lw %a0 %a12 0 #1810
	lw %f0 %a0 0 #152
	sw %f0 %a9 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a9 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a9 8 #154
	lw %a0 %a1 24 #484
	lw %a0 %a0 0 #486
	slli %a6 %a4 2 #1676
	add %a12 %a2 %a6 #1676
	lw %a2 %a12 0 #1676
	slli %a6 %a4 2 #1664
	add %a12 %a3 %a6 #1664
	lw %a3 %a12 0 #1664
	lw %a11 %sp 28 #1811
	sw %a9 %sp 32 #1811
	sw %a7 %sp 24 #1811
	sw %a5 %sp 68 #1811
	add %a1 %a2 %zero
	add %a2 %a3 %zero
	sw %ra %sp 76 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 80 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -80 #1811
	lw %ra %sp 76 #1811
	lw %a0 %sp 64 #1673
	slli %a1 %a0 2 #1673
	lw %a2 %sp 68 #1673
	add %a12 %a2 %a1 #1673
	lw %a1 %a12 0 #1673
	lw %a2 %sp 24 #219
	lw %f0 %a2 0 #219
	lw %f1 %a1 0 #219
	lw %a3 %sp 32 #219
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
beq_cont.36577:
	lw %a0 %sp 64 #1850
	addi %a1 %a0 1 #1850
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.36578
	lw %a0 %sp 60 #454
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36579
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 72 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36580 # nontail if
	jal %zero beq_cont.36581 # then sentence ends
beq_else.36580:
	lw %a11 %sp 20 #1848
	sw %ra %sp 76 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 80 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -80 #1848
	lw %ra %sp 76 #1848
beq_cont.36581:
	lw %a0 %sp 72 #1850
	addi %a1 %a0 1 #1850
	lw %a0 %sp 60 #1850
	lw %a11 %sp 12 #1850
	lw %a10 %a11 0 #1850
	jalr %zero %a10 0 #1850
bge_else.36579:
	jalr %zero %ra 0 #1851
bge_else.36578:
	jalr %zero %ra 0 #1852
bge_else.36575:
	jalr %zero %ra 0 #1851
bge_else.36574:
	jalr %zero %ra 0 #1852
beq_else.36573:
	lw %a1 %a1 12 #461
	slli %a2 %a4 2 #1669
	add %a12 %a1 %a2 #1669
	lw %a1 %a12 0 #1669
	sw %a3 %sp 76 #1669
	sw %a0 %sp 80 #1669
	sw %a4 %sp 64 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36586 # nontail if
	jal %zero beq_cont.36587 # then sentence ends
beq_else.36586:
	lw %a1 %sp 56 #1902
	lw %a11 %sp 8 #1902
	add %a2 %a3 %zero
	add %a3 %a1 %zero
	add %a1 %a6 %zero
	sw %ra %sp 84 #1902 call cls
	lw %a10 %a11 0 #1902
	addi %sp %sp 88 #1902	
	jalr %ra %a10 0 #1902
	addi %sp %sp -88 #1902
	lw %ra %sp 84 #1902
beq_cont.36587:
	lw %a0 %sp 64 #1906
	addi %a5 %a0 1 #1906
	lw %a0 %sp 80 #1906
	lw %a1 %sp 0 #1906
	lw %a2 %sp 16 #1906
	lw %a3 %sp 76 #1906
	lw %a4 %sp 56 #1906
	lw %a11 %sp 4 #1906
	lw %a10 %a11 0 #1906
	jalr %zero %a10 0 #1906
bge_else.36564:
	jalr %zero %ra 0 #1910
bge_else.36563:
	jalr %zero %ra 0 #1911
bge_else.36533:
	jalr %zero %ra 0 #1910
bge_else.36532:
	jalr %zero %ra 0 #1911
pretrace_diffuse_rays.2630:
	lw %a2 %a11 28 #1949
	lw %a3 %a11 24 #1949
	lw %a4 %a11 20 #1949
	lw %a5 %a11 16 #1949
	lw %a6 %a11 12 #1949
	lw %a7 %a11 8 #1949
	lw %a8 %a11 4 #1949
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.36592
	lw %a9 %a0 8 #454
	slli %a10 %a1 2 #1662
	add %a12 %a9 %a10 #1662
	lw %a9 %a12 0 #1662
	addi %a12 %zero 0
	blt %a9 %a12 bge_else.36593
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
	bne %a9 %a12 beq_else.36594 # nontail if
	jal %zero beq_cont.36595 # then sentence ends
beq_else.36594:
	lw %a9 %a0 24 #484
	lw %a9 %a9 0 #486
	li %f0 l.27725 #147
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
beq_cont.36595:
	lw %a1 %sp 32 #1971
	addi %a1 %a1 1 #1971
	addi %a12 %zero 4
	blt %a12 %a1 bge_else.36596
	lw %a2 %a0 8 #454
	slli %a3 %a1 2 #1662
	add %a12 %a2 %a3 #1662
	lw %a2 %a12 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36597
	lw %a2 %a0 12 #461
	slli %a3 %a1 2 #1669
	add %a12 %a2 %a3 #1669
	lw %a2 %a12 0 #1669
	sw %a1 %sp 52 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36598 # nontail if
	jal %zero beq_cont.36599 # then sentence ends
beq_else.36598:
	lw %a2 %a0 24 #484
	lw %a2 %a2 0 #486
	li %f0 l.27725 #147
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
	bne %a0 %a12 beq_else.36601 # nontail if
	lw %a0 %sp 64 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.29193 #1763
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
	jal %zero beq_cont.36602 # then sentence ends
beq_else.36601:
	lw %a0 %sp 64 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.29128 #1761
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
beq_cont.36602:
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
beq_cont.36599:
	lw %a1 %sp 52 #1971
	addi %a1 %a1 1 #1971
	lw %a11 %sp 0 #1971
	lw %a10 %a11 0 #1971
	jalr %zero %a10 0 #1971
bge_else.36597:
	jalr %zero %ra 0 #1972
bge_else.36596:
	jalr %zero %ra 0 #1973
bge_else.36593:
	jalr %zero %ra 0 #1972
bge_else.36592:
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
	blt %a1 %a12 bge_else.36607
	lw %f3 %a10 0 #61
	lw %a6 %a6 0 #59
	sub %a6 %a1 %a6 #1981
	sw %a11 %sp 36 #1981
	sw %a2 %sp 40 #1981
	sw %a4 %sp 44 #1981
	sw %a0 %sp 48 #1981
	sw %a1 %sp 52 #1981
	sw %a7 %sp 56 #1981
	sw %a3 %sp 60 #1981
	sw %a5 %sp 64 #1981
	sw %f2 %sp 72 #1981
	sw %f1 %sp 80 #1981
	sw %a8 %sp 88 #1981
	sw %f0 %sp 96 #1981
	sw %a9 %sp 104 #1981
	sw %f3 %sp 112 #1981
	add %a0 %a6 %zero
	sw %ra %sp 124 #1981 call dir
	addi %sp %sp 128 #1981	
	jal %ra min_caml_float_of_int #1981
	addi %sp %sp -128 #1981
	lw %ra %sp 124 #1981
	lw %f1 %sp 112 #1981
	fmul %f0 %f1 %f0 #1981
	lw %a0 %sp 104 #69
	lw %f1 %a0 0 #69
	fmul %f1 %f0 %f1 #1982
	lw %f2 %sp 96 #1982
	fadd %f1 %f1 %f2 #1982
	lw %a1 %sp 88 #1982
	sw %f1 %a1 0 #1982
	lw %f1 %a0 4 #69
	fmul %f1 %f0 %f1 #1983
	lw %f3 %sp 80 #1983
	fadd %f1 %f1 %f3 #1983
	sw %f1 %a1 4 #1983
	lw %f1 %a0 8 #69
	fmul %f0 %f0 %f1 #1984
	lw %f1 %sp 72 #1984
	fadd %f0 %f0 %f1 #1984
	sw %f0 %a1 8 #1984
	lw %f0 %a1 0 #172
	sw %ra %sp 124 #172 call dir
	addi %sp %sp 128 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -128 #172
	lw %ra %sp 124 #172
	lw %a0 %sp 88 #172
	lw %f1 %a0 4 #172
	sw %f0 %sp 120 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 132 #172 call dir
	addi %sp %sp 136 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -136 #172
	lw %ra %sp 132 #172
	lw %f1 %sp 120 #172
	fadd %f0 %f1 %f0 #172
	lw %a0 %sp 88 #172
	lw %f1 %a0 8 #172
	sw %f0 %sp 128 #172
	fadd %f0 %f1 %fzero
	sw %ra %sp 140 #172 call dir
	addi %sp %sp 144 #172	
	jal %ra min_caml_fsqr #172
	addi %sp %sp -144 #172
	lw %ra %sp 140 #172
	lw %f1 %sp 128 #172
	fadd %f0 %f1 %f0 #172
	sw %ra %sp 140 #172 call dir
	addi %sp %sp 144 #172	
	jal %ra min_caml_sqrt #172
	addi %sp %sp -144 #172
	lw %ra %sp 140 #172
	sw %f0 %sp 136 #173
	sw %ra %sp 148 #173 call dir
	addi %sp %sp 152 #173	
	jal %ra min_caml_fiszero #173
	addi %sp %sp -152 #173
	lw %ra %sp 148 #173
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36611 # nontail if
	li %f0 l.27799 #173
	lw %f1 %sp 136 #173
	fdiv %f0 %f0 %f1 #173
	jal %zero beq_cont.36612 # then sentence ends
beq_else.36611:
	li %f0 l.27799 #173
beq_cont.36612:
	lw %a1 %sp 88 #172
	lw %f1 %a1 0 #172
	fmul %f1 %f1 %f0 #174
	sw %f1 %a1 0 #174
	lw %f1 %a1 4 #172
	fmul %f1 %f1 %f0 #175
	sw %f1 %a1 4 #175
	lw %f1 %a1 8 #172
	fmul %f0 %f1 %f0 #176
	sw %f0 %a1 8 #176
	li %f0 l.27725 #147
	lw %a0 %sp 64 #140
	sw %f0 %a0 0 #140
	sw %f0 %a0 4 #141
	sw %f0 %a0 8 #142
	lw %a2 %sp 60 #152
	lw %f0 %a2 0 #152
	lw %a3 %sp 56 #152
	sw %f0 %a3 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a3 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a3 8 #154
	li %f0 l.27799 #1990
	lw %a2 %sp 52 #1990
	slli %a3 %a2 2 #1990
	lw %a4 %sp 48 #1990
	add %a12 %a4 %a3 #1990
	lw %a3 %a12 0 #1990
	li %f1 l.27725 #1990
	lw %a5 %sp 40 #1990
	lw %a11 %sp 44 #1990
	add %a2 %a3 %zero
	add %a0 %a5 %zero
	sw %ra %sp 148 #1990 call cls
	lw %a10 %a11 0 #1990
	addi %sp %sp 152 #1990	
	jalr %ra %a10 0 #1990
	addi %sp %sp -152 #1990
	lw %ra %sp 148 #1990
	lw %a0 %sp 52 #1990
	slli %a1 %a0 2 #1990
	lw %a2 %sp 48 #1990
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
	blt %a4 %a12 bge_else.36613 # nontail if
	lw %a4 %a1 12 #461
	lw %a4 %a4 0 #1669
	sw %a1 %sp 144 #1669
	addi %a12 %zero 0
	bne %a4 %a12 beq_else.36615 # nontail if
	jal %zero beq_cont.36616 # then sentence ends
beq_else.36615:
	lw %a4 %a1 24 #484
	lw %a4 %a4 0 #486
	li %f0 l.27725 #147
	lw %a5 %sp 36 #140
	sw %f0 %a5 0 #140
	sw %f0 %a5 4 #141
	sw %f0 %a5 8 #142
	lw %a6 %a1 28 #498
	lw %a7 %a1 4 #446
	slli %a4 %a4 2 #81
	lw %a8 %sp 32 #81
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
	sw %a7 %sp 148 #1147
	sw %a6 %sp 152 #1147
	sw %a4 %sp 156 #1147
	add %a1 %a8 %zero
	add %a0 %a7 %zero
	sw %ra %sp 164 #1147 call cls
	lw %a10 %a11 0 #1147
	addi %sp %sp 168 #1147	
	jalr %ra %a10 0 #1147
	addi %sp %sp -168 #1147
	lw %ra %sp 164 #1147
	lw %a0 %sp 156 #1757
	lw %a1 %a0 472 #1757
	lw %a1 %a1 0 #507
	lw %f0 %a1 0 #181
	lw %a2 %sp 152 #181
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
	sw %f0 %sp 160 #1760
	sw %ra %sp 172 #1760 call dir
	addi %sp %sp 176 #1760	
	jal %ra min_caml_fisneg #1760
	addi %sp %sp -176 #1760
	lw %ra %sp 172 #1760
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36617 # nontail if
	lw %a0 %sp 156 #1757
	lw %a1 %a0 472 #1757
	li %f0 l.29193 #1763
	lw %f1 %sp 160 #1763
	fdiv %f0 %f1 %f0 #1763
	lw %a11 %sp 0 #1763
	add %a0 %a1 %zero
	sw %ra %sp 172 #1763 call cls
	lw %a10 %a11 0 #1763
	addi %sp %sp 176 #1763	
	jalr %ra %a10 0 #1763
	addi %sp %sp -176 #1763
	lw %ra %sp 172 #1763
	jal %zero beq_cont.36618 # then sentence ends
beq_else.36617:
	lw %a0 %sp 156 #1757
	lw %a1 %a0 476 #1757
	li %f0 l.29128 #1761
	lw %f1 %sp 160 #1761
	fdiv %f0 %f1 %f0 #1761
	lw %a11 %sp 0 #1761
	add %a0 %a1 %zero
	sw %ra %sp 172 #1761 call cls
	lw %a10 %a11 0 #1761
	addi %sp %sp 176 #1761	
	jalr %ra %a10 0 #1761
	addi %sp %sp -176 #1761
	lw %ra %sp 172 #1761
beq_cont.36618:
	addi %a3 %zero 116 #1765
	lw %a0 %sp 156 #1765
	lw %a1 %sp 152 #1765
	lw %a2 %sp 148 #1765
	lw %a11 %sp 20 #1765
	sw %ra %sp 172 #1765 call cls
	lw %a10 %a11 0 #1765
	addi %sp %sp 176 #1765	
	jalr %ra %a10 0 #1765
	addi %sp %sp -176 #1765
	lw %ra %sp 172 #1765
	lw %a0 %sp 144 #475
	lw %a1 %a0 20 #475
	lw %a1 %a1 0 #1810
	lw %a2 %sp 36 #152
	lw %f0 %a2 0 #152
	sw %f0 %a1 0 #152
	lw %f0 %a2 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a2 8 #152
	sw %f0 %a1 8 #154
beq_cont.36616:
	addi %a1 %zero 1 #1971
	lw %a0 %sp 144 #1971
	lw %a11 %sp 12 #1971
	sw %ra %sp 172 #1971 call cls
	lw %a10 %a11 0 #1971
	addi %sp %sp 176 #1971	
	jalr %ra %a10 0 #1971
	addi %sp %sp -176 #1971
	lw %ra %sp 172 #1971
	jal %zero bge_cont.36614 # then sentence ends
bge_else.36613:
bge_cont.36614:
	lw %a0 %sp 52 #1997
	addi %a1 %a0 -1 #1997
	lw %a0 %sp 24 #123
	addi %a0 %a0 1 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.36619 # nontail if
	addi %a2 %a0 -5 #124
	jal %zero bge_cont.36620 # then sentence ends
bge_else.36619:
	addi %a2 %a0 0 #124
bge_cont.36620:
	lw %f0 %sp 96 #1997
	lw %f1 %sp 80 #1997
	lw %f2 %sp 72 #1997
	lw %a0 %sp 48 #1997
	lw %a11 %sp 28 #1997
	lw %a10 %a11 0 #1997
	jalr %zero %a10 0 #1997
bge_else.36607:
	jalr %zero %ra 0 #1999
scan_pixel.2644:
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
	blt %a0 %a5 bge_else.36622
	jalr %zero %ra 0 #2033
bge_else.36622:
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
	blt %a4 %a5 bge_else.36624 # nontail if
	addi %a4 %zero 0 #1865
	jal %zero bge_cont.36625 # then sentence ends
bge_else.36624:
	addi %a12 %zero 0
	blt %a12 %a1 bge_else.36626 # nontail if
	addi %a4 %zero 0 #1858
	jal %zero bge_cont.36627 # then sentence ends
bge_else.36626:
	lw %a4 %a8 0 #57
	addi %a5 %a0 1 #1859
	blt %a5 %a4 bge_else.36628 # nontail if
	addi %a4 %zero 0 #1858
	jal %zero bge_cont.36629 # then sentence ends
bge_else.36628:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.36630 # nontail if
	addi %a4 %zero 0 #1858
	jal %zero bge_cont.36631 # then sentence ends
bge_else.36630:
	addi %a4 %zero 1 #1861
bge_cont.36631:
bge_cont.36629:
bge_cont.36627:
bge_cont.36625:
	addi %a5 %zero 0 #2024
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
	bne %a4 %a12 beq_else.36632 # nontail if
	slli %a4 %a0 2 #2021
	add %a12 %a3 %a4 #2021
	lw %a4 %a12 0 #2021
	lw %a2 %a4 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36634 # nontail if
	lw %a2 %a4 12 #461
	lw %a2 %a2 0 #1669
	sw %a4 %sp 56 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36636 # nontail if
	jal %zero beq_cont.36637 # then sentence ends
beq_else.36636:
	add %a1 %a5 %zero
	add %a0 %a4 %zero
	sw %ra %sp 60 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 64 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -64 #1848
	lw %ra %sp 60 #1848
beq_cont.36637:
	lw %a0 %sp 56 #454
	lw %a1 %a0 8 #454
	lw %a1 %a1 4 #1662
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.36638 # nontail if
	lw %a1 %a0 12 #461
	lw %a1 %a1 4 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36640 # nontail if
	jal %zero beq_cont.36641 # then sentence ends
beq_else.36640:
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
beq_cont.36641:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 56 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 8 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36642 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 8 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36644 # nontail if
	jal %zero beq_cont.36645 # then sentence ends
beq_else.36644:
	lw %a11 %sp 24 #1848
	sw %ra %sp 68 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 72 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -72 #1848
	lw %ra %sp 68 #1848
beq_cont.36645:
	addi %a1 %zero 3 #1850
	lw %a0 %sp 56 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 68 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 72 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -72 #1850
	lw %ra %sp 68 #1850
	jal %zero bge_cont.36643 # then sentence ends
bge_else.36642:
bge_cont.36643:
	jal %zero bge_cont.36639 # then sentence ends
bge_else.36638:
bge_cont.36639:
	jal %zero bge_cont.36635 # then sentence ends
bge_else.36634:
bge_cont.36635:
	jal %zero beq_cont.36633 # then sentence ends
beq_else.36632:
	slli %a4 %a0 2 #1891
	add %a12 %a3 %a4 #1891
	lw %a4 %a12 0 #1891
	lw %a8 %a4 8 #454
	lw %a8 %a8 0 #1662
	addi %a12 %zero 0
	blt %a8 %a12 bge_else.36646 # nontail if
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
	sw %a5 %sp 64 #1662
	bne %a1 %a8 beq_else.36648 # nontail if
	slli %a1 %a0 2 #1878
	lw %a5 %sp 12 #1878
	add %a12 %a5 %a1 #1878
	lw %a1 %a12 0 #1878
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a8 beq_else.36650 # nontail if
	addi %a1 %a0 -1 #1879
	slli %a1 %a1 2 #1875
	add %a12 %a3 %a1 #1875
	lw %a1 %a12 0 #1875
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a8 beq_else.36652 # nontail if
	addi %a1 %a0 1 #1880
	slli %a1 %a1 2 #1875
	add %a12 %a3 %a1 #1875
	lw %a1 %a12 0 #1875
	lw %a1 %a1 8 #454
	lw %a1 %a1 0 #1662
	bne %a1 %a8 beq_else.36654 # nontail if
	addi %a1 %zero 1 #1881
	jal %zero beq_cont.36655 # then sentence ends
beq_else.36654:
	addi %a1 %zero 0 #1882
beq_cont.36655:
	jal %zero beq_cont.36653 # then sentence ends
beq_else.36652:
	addi %a1 %zero 0 #1883
beq_cont.36653:
	jal %zero beq_cont.36651 # then sentence ends
beq_else.36650:
	addi %a1 %zero 0 #1884
beq_cont.36651:
	jal %zero beq_cont.36649 # then sentence ends
beq_else.36648:
	addi %a1 %zero 0 #1885
beq_cont.36649:
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36656 # nontail if
	lw %a1 %a4 8 #454
	lw %a1 %a1 0 #1662
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.36658 # nontail if
	lw %a1 %a4 12 #461
	lw %a1 %a1 0 #1669
	sw %a4 %sp 68 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36660 # nontail if
	jal %zero beq_cont.36661 # then sentence ends
beq_else.36660:
	lw %a1 %a4 20 #475
	lw %a5 %a4 28 #498
	lw %a8 %a4 4 #446
	lw %a2 %a4 16 #468
	lw %a1 %a1 0 #1810
	lw %f0 %a1 0 #152
	sw %f0 %a10 0 #152
	lw %f0 %a1 4 #152
	sw %f0 %a10 4 #153
	lw %f0 %a1 8 #152
	sw %f0 %a10 8 #154
	lw %a1 %a4 24 #484
	lw %a1 %a1 0 #486
	lw %a5 %a5 0 #1676
	lw %a8 %a8 0 #1664
	sw %a2 %sp 72 #1811
	add %a2 %a8 %zero
	add %a0 %a1 %zero
	add %a11 %a6 %zero
	add %a1 %a5 %zero
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
beq_cont.36661:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 68 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36662 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36664 # nontail if
	jal %zero beq_cont.36665 # then sentence ends
beq_else.36664:
	lw %a11 %sp 24 #1848
	sw %ra %sp 76 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 80 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -80 #1848
	lw %ra %sp 76 #1848
beq_cont.36665:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 68 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 76 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 80 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -80 #1850
	lw %ra %sp 76 #1850
	jal %zero bge_cont.36663 # then sentence ends
bge_else.36662:
bge_cont.36663:
	jal %zero bge_cont.36659 # then sentence ends
bge_else.36658:
bge_cont.36659:
	jal %zero beq_cont.36657 # then sentence ends
beq_else.36656:
	lw %a1 %a4 12 #461
	lw %a1 %a1 0 #1669
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36666 # nontail if
	jal %zero beq_cont.36667 # then sentence ends
beq_else.36666:
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
beq_cont.36667:
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
beq_cont.36657:
	jal %zero bge_cont.36647 # then sentence ends
bge_else.36646:
bge_cont.36647:
beq_cont.36633:
	lw %a0 %sp 52 #54
	lw %f0 %a0 0 #54
	sw %ra %sp 76 #1930 call dir
	addi %sp %sp 80 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -80 #1930
	lw %ra %sp 76 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36668 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36670 # nontail if
	jal %zero bge_cont.36671 # then sentence ends
bge_else.36670:
	addi %a0 %zero 0 #1931
bge_cont.36671:
	jal %zero bge_cont.36669 # then sentence ends
bge_else.36668:
	addi %a0 %zero 255 #1931
bge_cont.36669:
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
	sw %ra %sp 76 #1930 call dir
	addi %sp %sp 80 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -80 #1930
	lw %ra %sp 76 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36672 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36674 # nontail if
	jal %zero bge_cont.36675 # then sentence ends
bge_else.36674:
	addi %a0 %zero 0 #1931
bge_cont.36675:
	jal %zero bge_cont.36673 # then sentence ends
bge_else.36672:
	addi %a0 %zero 255 #1931
bge_cont.36673:
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
	sw %ra %sp 76 #1930 call dir
	addi %sp %sp 80 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -80 #1930
	lw %ra %sp 76 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36676 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36678 # nontail if
	jal %zero bge_cont.36679 # then sentence ends
bge_else.36678:
	addi %a0 %zero 0 #1931
bge_cont.36679:
	jal %zero bge_cont.36677 # then sentence ends
bge_else.36676:
	addi %a0 %zero 255 #1931
bge_cont.36677:
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
	blt %a0 %a2 bge_else.36680
	jalr %zero %ra 0 #2033
bge_else.36680:
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
	blt %a6 %a2 bge_else.36682 # nontail if
	addi %a1 %zero 0 #1865
	jal %zero bge_cont.36683 # then sentence ends
bge_else.36682:
	addi %a12 %zero 0
	blt %a12 %a5 bge_else.36684 # nontail if
	addi %a1 %zero 0 #1858
	jal %zero bge_cont.36685 # then sentence ends
bge_else.36684:
	lw %a1 %a1 0 #57
	addi %a2 %a0 1 #1859
	blt %a2 %a1 bge_else.36686 # nontail if
	addi %a1 %zero 0 #1858
	jal %zero bge_cont.36687 # then sentence ends
bge_else.36686:
	addi %a12 %zero 0
	blt %a12 %a0 bge_else.36688 # nontail if
	addi %a1 %zero 0 #1858
	jal %zero bge_cont.36689 # then sentence ends
bge_else.36688:
	addi %a1 %zero 1 #1861
bge_cont.36689:
bge_cont.36687:
bge_cont.36685:
bge_cont.36683:
	addi %a2 %zero 0 #2024
	sw %a0 %sp 76 #1861
	addi %a12 %zero 0
	bne %a1 %a12 beq_else.36690 # nontail if
	slli %a1 %a0 2 #2021
	add %a12 %a3 %a1 #2021
	lw %a1 %a12 0 #2021
	lw %a2 %a1 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36692 # nontail if
	lw %a2 %a1 12 #461
	lw %a2 %a2 0 #1669
	sw %a1 %sp 80 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36694 # nontail if
	jal %zero beq_cont.36695 # then sentence ends
beq_else.36694:
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
beq_cont.36695:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 80 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36696 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36698 # nontail if
	jal %zero beq_cont.36699 # then sentence ends
beq_else.36698:
	lw %a11 %sp 24 #1848
	sw %ra %sp 92 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 96 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -96 #1848
	lw %ra %sp 92 #1848
beq_cont.36699:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 80 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 92 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 96 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -96 #1850
	lw %ra %sp 92 #1850
	jal %zero bge_cont.36697 # then sentence ends
bge_else.36696:
bge_cont.36697:
	jal %zero bge_cont.36693 # then sentence ends
bge_else.36692:
bge_cont.36693:
	jal %zero beq_cont.36691 # then sentence ends
beq_else.36690:
	lw %a1 %sp 16 #2025
	lw %a6 %sp 12 #2025
	lw %a11 %sp 0 #2025
	add %a4 %a6 %zero
	add %a10 %a5 %zero
	add %a5 %a2 %zero
	add %a2 %a1 %zero
	add %a1 %a10 %zero
	sw %ra %sp 92 #2025 call cls
	lw %a10 %a11 0 #2025
	addi %sp %sp 96 #2025	
	jalr %ra %a10 0 #2025
	addi %sp %sp -96 #2025
	lw %ra %sp 92 #2025
beq_cont.36691:
	lw %a0 %sp 52 #54
	lw %f0 %a0 0 #54
	sw %ra %sp 92 #1930 call dir
	addi %sp %sp 96 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -96 #1930
	lw %ra %sp 92 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36700 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36702 # nontail if
	jal %zero bge_cont.36703 # then sentence ends
bge_else.36702:
	addi %a0 %zero 0 #1931
bge_cont.36703:
	jal %zero bge_cont.36701 # then sentence ends
bge_else.36700:
	addi %a0 %zero 255 #1931
bge_cont.36701:
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
	sw %ra %sp 92 #1930 call dir
	addi %sp %sp 96 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -96 #1930
	lw %ra %sp 92 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36704 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36706 # nontail if
	jal %zero bge_cont.36707 # then sentence ends
bge_else.36706:
	addi %a0 %zero 0 #1931
bge_cont.36707:
	jal %zero bge_cont.36705 # then sentence ends
bge_else.36704:
	addi %a0 %zero 255 #1931
bge_cont.36705:
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
	sw %ra %sp 92 #1930 call dir
	addi %sp %sp 96 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -96 #1930
	lw %ra %sp 92 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36708 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36710 # nontail if
	jal %zero bge_cont.36711 # then sentence ends
bge_else.36710:
	addi %a0 %zero 0 #1931
bge_cont.36711:
	jal %zero bge_cont.36709 # then sentence ends
bge_else.36708:
	addi %a0 %zero 255 #1931
bge_cont.36709:
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
scan_line.2650:
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
	blt %a0 %a11 bge_else.36712
	jalr %zero %ra 0 #2046
bge_else.36712:
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
	blt %a0 %a11 bge_else.36714 # nontail if
	jal %zero bge_cont.36715 # then sentence ends
bge_else.36714:
	addi %a11 %a0 1 #2042
	lw %f0 %a10 0 #61
	lw %a6 %a6 4 #59
	sub %a6 %a11 %a6 #2004
	sw %f0 %sp 80 #2004
	add %a0 %a6 %zero
	sw %ra %sp 92 #2004 call dir
	addi %sp %sp 96 #2004	
	jal %ra min_caml_float_of_int #2004
	addi %sp %sp -96 #2004
	lw %ra %sp 92 #2004
	lw %f1 %sp 80 #2004
	fmul %f0 %f1 %f0 #2004
	lw %a0 %sp 40 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 36 #71
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
	lw %a2 %sp 72 #57
	lw %a3 %a2 0 #57
	addi %a3 %a3 -1 #2010
	lw %a4 %sp 56 #2010
	lw %a5 %sp 52 #2010
	lw %a11 %sp 32 #2010
	add %a2 %a5 %zero
	add %a1 %a3 %zero
	add %a0 %a4 %zero
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
bge_cont.36715:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 72 #57
	lw %a2 %a1 0 #57
	addi %a12 %zero 0
	blt %a12 %a2 bge_else.36717 # nontail if
	jal %zero bge_cont.36718 # then sentence ends
bge_else.36717:
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
	blt %a6 %a2 bge_else.36719 # nontail if
	addi %a2 %zero 0 #1865
	jal %zero bge_cont.36720 # then sentence ends
bge_else.36719:
	addi %a12 %zero 0
	blt %a12 %a5 bge_else.36721 # nontail if
	addi %a2 %zero 0 #1858
	jal %zero bge_cont.36722 # then sentence ends
bge_else.36721:
	lw %a2 %a1 0 #57
	addi %a12 %zero 1
	blt %a12 %a2 bge_else.36723 # nontail if
	addi %a2 %zero 0 #1858
	jal %zero bge_cont.36724 # then sentence ends
bge_else.36723:
	addi %a2 %zero 0 #1858
bge_cont.36724:
bge_cont.36722:
bge_cont.36720:
	addi %a6 %zero 0 #2024
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36725 # nontail if
	lw %a0 %a3 0 #2021
	lw %a2 %a0 8 #454
	lw %a2 %a2 0 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36727 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 0 #1669
	sw %a0 %sp 88 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36729 # nontail if
	jal %zero beq_cont.36730 # then sentence ends
beq_else.36729:
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
	sw %a8 %sp 92 #1811
	add %a1 %a6 %zero
	add %a0 %a2 %zero
	add %a2 %a7 %zero
	sw %ra %sp 100 #1811 call cls
	lw %a10 %a11 0 #1811
	addi %sp %sp 104 #1811	
	jalr %ra %a10 0 #1811
	addi %sp %sp -104 #1811
	lw %ra %sp 100 #1811
	lw %a0 %sp 92 #1673
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
beq_cont.36730:
	addi %a1 %zero 1 #1850
	lw %a0 %sp 88 #454
	lw %a2 %a0 8 #454
	lw %a2 %a2 4 #1662
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36731 # nontail if
	lw %a2 %a0 12 #461
	lw %a2 %a2 4 #1669
	addi %a12 %zero 0
	bne %a2 %a12 beq_else.36733 # nontail if
	jal %zero beq_cont.36734 # then sentence ends
beq_else.36733:
	lw %a11 %sp 28 #1848
	sw %ra %sp 100 #1848 call cls
	lw %a10 %a11 0 #1848
	addi %sp %sp 104 #1848	
	jalr %ra %a10 0 #1848
	addi %sp %sp -104 #1848
	lw %ra %sp 100 #1848
beq_cont.36734:
	addi %a1 %zero 2 #1850
	lw %a0 %sp 88 #1850
	lw %a11 %sp 20 #1850
	sw %ra %sp 100 #1850 call cls
	lw %a10 %a11 0 #1850
	addi %sp %sp 104 #1850	
	jalr %ra %a10 0 #1850
	addi %sp %sp -104 #1850
	lw %ra %sp 100 #1850
	jal %zero bge_cont.36732 # then sentence ends
bge_else.36731:
bge_cont.36732:
	jal %zero bge_cont.36728 # then sentence ends
bge_else.36727:
bge_cont.36728:
	jal %zero beq_cont.36726 # then sentence ends
beq_else.36725:
	lw %a2 %sp 4 #2025
	lw %a7 %sp 56 #2025
	lw %a11 %sp 8 #2025
	add %a4 %a7 %zero
	add %a1 %a5 %zero
	add %a5 %a6 %zero
	sw %ra %sp 100 #2025 call cls
	lw %a10 %a11 0 #2025
	addi %sp %sp 104 #2025	
	jalr %ra %a10 0 #2025
	addi %sp %sp -104 #2025
	lw %ra %sp 100 #2025
beq_cont.36726:
	lw %a0 %sp 16 #54
	lw %f0 %a0 0 #54
	sw %ra %sp 100 #1930 call dir
	addi %sp %sp 104 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -104 #1930
	lw %ra %sp 100 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36735 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36737 # nontail if
	jal %zero bge_cont.36738 # then sentence ends
bge_else.36737:
	addi %a0 %zero 0 #1931
bge_cont.36738:
	jal %zero bge_cont.36736 # then sentence ends
bge_else.36735:
	addi %a0 %zero 255 #1931
bge_cont.36736:
	sw %ra %sp 100 #1932 call dir
	addi %sp %sp 104 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -104 #1932
	lw %ra %sp 100 #1932
	addi %a0 %zero 32 #1937
	sw %ra %sp 100 #1937 call dir
	addi %sp %sp 104 #1937	
	jal %ra min_caml_print_char #1937
	addi %sp %sp -104 #1937
	lw %ra %sp 100 #1937
	lw %a0 %sp 16 #54
	lw %f0 %a0 4 #54
	sw %ra %sp 100 #1930 call dir
	addi %sp %sp 104 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -104 #1930
	lw %ra %sp 100 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36739 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36741 # nontail if
	jal %zero bge_cont.36742 # then sentence ends
bge_else.36741:
	addi %a0 %zero 0 #1931
bge_cont.36742:
	jal %zero bge_cont.36740 # then sentence ends
bge_else.36739:
	addi %a0 %zero 255 #1931
bge_cont.36740:
	sw %ra %sp 100 #1932 call dir
	addi %sp %sp 104 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -104 #1932
	lw %ra %sp 100 #1932
	addi %a0 %zero 32 #1939
	sw %ra %sp 100 #1939 call dir
	addi %sp %sp 104 #1939	
	jal %ra min_caml_print_char #1939
	addi %sp %sp -104 #1939
	lw %ra %sp 100 #1939
	lw %a0 %sp 16 #54
	lw %f0 %a0 8 #54
	sw %ra %sp 100 #1930 call dir
	addi %sp %sp 104 #1930	
	jal %ra min_caml_int_of_float #1930
	addi %sp %sp -104 #1930
	lw %ra %sp 100 #1930
	addi %a12 %zero 255
	blt %a12 %a0 bge_else.36743 # nontail if
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36745 # nontail if
	jal %zero bge_cont.36746 # then sentence ends
bge_else.36745:
	addi %a0 %zero 0 #1931
bge_cont.36746:
	jal %zero bge_cont.36744 # then sentence ends
bge_else.36743:
	addi %a0 %zero 255 #1931
bge_cont.36744:
	sw %ra %sp 100 #1932 call dir
	addi %sp %sp 104 #1932	
	jal %ra min_caml_print_int #1932
	addi %sp %sp -104 #1932
	lw %ra %sp 100 #1932
	addi %a0 %zero 10 #1941
	sw %ra %sp 100 #1941 call dir
	addi %sp %sp 104 #1941	
	jal %ra min_caml_print_char #1941
	addi %sp %sp -104 #1941
	lw %ra %sp 100 #1941
	addi %a0 %zero 1 #2032
	lw %a1 %sp 64 #2032
	lw %a2 %sp 4 #2032
	lw %a3 %sp 68 #2032
	lw %a4 %sp 56 #2032
	lw %a11 %sp 0 #2032
	sw %ra %sp 100 #2032 call cls
	lw %a10 %a11 0 #2032
	addi %sp %sp 104 #2032	
	jalr %ra %a10 0 #2032
	addi %sp %sp -104 #2032
	lw %ra %sp 100 #2032
bge_cont.36718:
	lw %a0 %sp 64 #2045
	addi %a1 %a0 1 #2045
	lw %a0 %sp 52 #123
	addi %a0 %a0 2 #123
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.36747 # nontail if
	addi %a0 %a0 -5 #124
	jal %zero bge_cont.36748 # then sentence ends
bge_else.36747:
bge_cont.36748:
	lw %a2 %sp 72 #57
	lw %a3 %a2 4 #57
	blt %a1 %a3 bge_else.36749
	jalr %zero %ra 0 #2046
bge_else.36749:
	lw %a3 %a2 4 #57
	addi %a3 %a3 -1 #2041
	sw %a0 %sp 96 #2041
	sw %a1 %sp 100 #2041
	blt %a1 %a3 bge_else.36751 # nontail if
	jal %zero bge_cont.36752 # then sentence ends
bge_else.36751:
	addi %a3 %a1 1 #2042
	lw %a4 %sp 48 #61
	lw %f0 %a4 0 #61
	lw %a4 %sp 44 #59
	lw %a4 %a4 4 #59
	sub %a3 %a3 %a4 #2004
	sw %f0 %sp 104 #2004
	add %a0 %a3 %zero
	sw %ra %sp 116 #2004 call dir
	addi %sp %sp 120 #2004	
	jal %ra min_caml_float_of_int #2004
	addi %sp %sp -120 #2004
	lw %ra %sp 116 #2004
	lw %f1 %sp 104 #2004
	fmul %f0 %f1 %f0 #2004
	lw %a0 %sp 40 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 36 #71
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
	lw %a0 %sp 72 #57
	lw %a0 %a0 0 #57
	addi %a1 %a0 -1 #2010
	lw %a0 %sp 4 #2010
	lw %a2 %sp 96 #2010
	lw %a11 %sp 32 #2010
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 116 #2010 call cls
	lw %a10 %a11 0 #2010
	addi %sp %sp 120 #2010	
	jalr %ra %a10 0 #2010
	addi %sp %sp -120 #2010
	lw %ra %sp 116 #2010
bge_cont.36752:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 100 #2044
	lw %a2 %sp 68 #2044
	lw %a3 %sp 56 #2044
	lw %a4 %sp 4 #2044
	lw %a11 %sp 0 #2044
	sw %ra %sp 116 #2044 call cls
	lw %a10 %a11 0 #2044
	addi %sp %sp 120 #2044	
	jalr %ra %a10 0 #2044
	addi %sp %sp -120 #2044
	lw %ra %sp 116 #2044
	lw %a0 %sp 100 #2045
	addi %a0 %a0 1 #2045
	lw %a1 %sp 96 #123
	addi %a1 %a1 2 #123
	addi %a12 %zero 5
	blt %a1 %a12 bge_else.36753 # nontail if
	addi %a4 %a1 -5 #124
	jal %zero bge_cont.36754 # then sentence ends
bge_else.36753:
	addi %a4 %a1 0 #124
bge_cont.36754:
	lw %a1 %sp 56 #2045
	lw %a2 %sp 4 #2045
	lw %a3 %sp 68 #2045
	lw %a11 %sp 24 #2045
	lw %a10 %a11 0 #2045
	jalr %zero %a10 0 #2045
create_pixel.2658:
	addi %a0 %zero 3 #2066
	li %f0 l.27725 #2066
	sw %ra %sp 4 #2066 call dir
	addi %sp %sp 8 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -8 #2066
	lw %ra %sp 4 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 12 #2057 call dir
	addi %sp %sp 16 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -16 #2057
	lw %ra %sp 12 #2057
	lw %a1 %sp 4 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 12 #2058 call dir
	addi %sp %sp 16 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -16 #2058
	lw %ra %sp 12 #2058
	lw %a1 %sp 4 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 20 #2057 call dir
	addi %sp %sp 24 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -24 #2057
	lw %ra %sp 20 #2057
	lw %a1 %sp 16 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 20 #2058 call dir
	addi %sp %sp 24 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -24 #2058
	lw %ra %sp 20 #2058
	lw %a1 %sp 16 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 20 #2059 call dir
	addi %sp %sp 24 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -24 #2059
	lw %ra %sp 20 #2059
	lw %a1 %sp 16 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 28 #2057 call dir
	addi %sp %sp 32 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -32 #2057
	lw %ra %sp 28 #2057
	lw %a1 %sp 20 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 28 #2058 call dir
	addi %sp %sp 32 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -32 #2058
	lw %ra %sp 28 #2058
	lw %a1 %sp 20 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 36 #2057 call dir
	addi %sp %sp 40 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -40 #2057
	lw %ra %sp 36 #2057
	lw %a1 %sp 28 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 36 #2058 call dir
	addi %sp %sp 40 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -40 #2058
	lw %ra %sp 36 #2058
	lw %a1 %sp 28 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	blt %a1 %a12 bge_else.36755
	addi %a2 %zero 3 #2066
	li %f0 l.27725 #2066
	sw %a0 %sp 0 #2066
	sw %a1 %sp 4 #2066
	add %a0 %a2 %zero
	sw %ra %sp 12 #2066 call dir
	addi %sp %sp 16 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -16 #2066
	lw %ra %sp 12 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 20 #2057 call dir
	addi %sp %sp 24 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -24 #2057
	lw %ra %sp 20 #2057
	lw %a1 %sp 12 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 20 #2058 call dir
	addi %sp %sp 24 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -24 #2058
	lw %ra %sp 20 #2058
	lw %a1 %sp 12 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 28 #2057 call dir
	addi %sp %sp 32 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -32 #2057
	lw %ra %sp 28 #2057
	lw %a1 %sp 24 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 28 #2058 call dir
	addi %sp %sp 32 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -32 #2058
	lw %ra %sp 28 #2058
	lw %a1 %sp 24 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 28 #2059 call dir
	addi %sp %sp 32 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -32 #2059
	lw %ra %sp 28 #2059
	lw %a1 %sp 24 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 36 #2057 call dir
	addi %sp %sp 40 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -40 #2057
	lw %ra %sp 36 #2057
	lw %a1 %sp 28 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 36 #2058 call dir
	addi %sp %sp 40 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -40 #2058
	lw %ra %sp 36 #2058
	lw %a1 %sp 28 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 44 #2057 call dir
	addi %sp %sp 48 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -48 #2057
	lw %ra %sp 44 #2057
	lw %a1 %sp 36 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 44 #2058 call dir
	addi %sp %sp 48 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -48 #2058
	lw %ra %sp 44 #2058
	lw %a1 %sp 36 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	blt %a0 %a12 bge_else.36756
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
	blt %a0 %a12 bge_else.36757
	addi %a1 %zero 3 #2066
	li %f0 l.27725 #2066
	sw %a0 %sp 44 #2066
	add %a0 %a1 %zero
	sw %ra %sp 52 #2066 call dir
	addi %sp %sp 56 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -56 #2066
	lw %ra %sp 52 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 60 #2057 call dir
	addi %sp %sp 64 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -64 #2057
	lw %ra %sp 60 #2057
	lw %a1 %sp 52 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 60 #2058 call dir
	addi %sp %sp 64 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -64 #2058
	lw %ra %sp 60 #2058
	lw %a1 %sp 52 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 68 #2057 call dir
	addi %sp %sp 72 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -72 #2057
	lw %ra %sp 68 #2057
	lw %a1 %sp 64 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 68 #2058 call dir
	addi %sp %sp 72 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -72 #2058
	lw %ra %sp 68 #2058
	lw %a1 %sp 64 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 68 #2059 call dir
	addi %sp %sp 72 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -72 #2059
	lw %ra %sp 68 #2059
	lw %a1 %sp 64 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 76 #2057 call dir
	addi %sp %sp 80 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -80 #2057
	lw %ra %sp 76 #2057
	lw %a1 %sp 68 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 76 #2058 call dir
	addi %sp %sp 80 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -80 #2058
	lw %ra %sp 76 #2058
	lw %a1 %sp 68 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	li %f0 l.27725 #2054
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
	li %f0 l.27725 #2056
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
	li %f0 l.27725 #2057
	sw %ra %sp 84 #2057 call dir
	addi %sp %sp 88 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -88 #2057
	lw %ra %sp 84 #2057
	lw %a1 %sp 76 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 84 #2058 call dir
	addi %sp %sp 88 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -88 #2058
	lw %ra %sp 84 #2058
	lw %a1 %sp 76 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
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
	blt %a0 %a12 bge_else.36758
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
bge_else.36758:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.36757:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.36756:
	addi %a0 %a3 0 #2083
	jalr %zero %ra 0 #2083
bge_else.36755:
	jalr %zero %ra 0 #2083
calc_dirvec.2670:
	lw %a3 %a11 4 #2110
	addi %a12 %zero 5
	blt %a0 %a12 bge_else.36759
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
	li %f1 l.27799 #2112
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
	li %f3 l.27799 #2115
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
bge_else.36759:
	fmul %f0 %f1 %f1 #2102
	li %f1 l.29046 #2102
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
	li %f1 l.27799 #2103
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
	li %f2 l.29046 #2102
	fadd %f1 %f1 %f2 #2102
	sw %f0 %sp 192 #2102
	sw %a0 %sp 200 #2102
	fadd %f0 %f1 %fzero
	sw %ra %sp 204 #2102 call dir
	addi %sp %sp 208 #2102	
	jal %ra min_caml_sqrt #2102
	addi %sp %sp -208 #2102
	lw %ra %sp 204 #2102
	li %f1 l.27799 #2103
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
	blt %a0 %a12 bge_else.36769
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
	li %f1 l.30230 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.30232 #2134
	fsub %f2 %f0 %f1 #2134
	li %f0 l.27725 #2135
	li %f1 l.27725 #2135
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
	li %f1 l.30230 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.29046 #2137
	fadd %f2 %f0 %f1 #2137
	li %f0 l.27725 #2138
	li %f1 l.27725 #2138
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
	blt %a1 %a12 bge_else.36770 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.36771 # then sentence ends
bge_else.36770:
bge_cont.36771:
	addi %a2 %zero 0 #2132
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36772
	sw %a0 %sp 32 #2134
	sw %a1 %sp 36 #2134
	sw %a2 %sp 40 #2134
	sw %ra %sp 44 #2134 call dir
	addi %sp %sp 48 #2134	
	jal %ra min_caml_float_of_int #2134
	addi %sp %sp -48 #2134
	lw %ra %sp 44 #2134
	li %f1 l.30230 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.30232 #2134
	fsub %f2 %f0 %f1 #2134
	li %f0 l.27725 #2135
	li %f1 l.27725 #2135
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
	li %f1 l.30230 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.29046 #2137
	fadd %f2 %f0 %f1 #2137
	li %f0 l.27725 #2138
	li %f1 l.27725 #2138
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
	blt %a1 %a12 bge_else.36773 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.36774 # then sentence ends
bge_else.36773:
bge_cont.36774:
	lw %f0 %sp 8 #2140
	lw %a2 %sp 16 #2140
	lw %a11 %sp 0 #2140
	lw %a10 %a11 0 #2140
	jalr %zero %a10 0 #2140
bge_else.36772:
	jalr %zero %ra 0 #2141
bge_else.36769:
	jalr %zero %ra 0 #2141
calc_dirvec_rows.2683:
	lw %a3 %a11 8 #2145
	lw %a4 %a11 4 #2145
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36777
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
	li %f1 l.30230 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.30232 #2147
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
	li %f1 l.30230 #2134
	fmul %f0 %f0 %f1 #2134
	li %f1 l.30232 #2134
	fsub %f2 %f0 %f1 #2134
	li %f0 l.27725 #2135
	li %f1 l.27725 #2135
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
	li %f1 l.30230 #2137
	fmul %f0 %f0 %f1 #2137
	li %f1 l.29046 #2137
	fadd %f2 %f0 %f1 #2137
	li %f0 l.27725 #2138
	li %f1 l.27725 #2138
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
	blt %a2 %a12 bge_else.36779 # nontail if
	addi %a2 %a2 -5 #124
	jal %zero bge_cont.36780 # then sentence ends
bge_else.36779:
bge_cont.36780:
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
	blt %a1 %a12 bge_else.36781 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.36782 # then sentence ends
bge_else.36781:
bge_cont.36782:
	lw %a2 %sp 12 #2149
	addi %a2 %a2 4 #2149
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36783
	sw %a0 %sp 44 #2147
	sw %a2 %sp 48 #2147
	sw %a1 %sp 52 #2147
	sw %ra %sp 60 #2147 call dir
	addi %sp %sp 64 #2147	
	jal %ra min_caml_float_of_int #2147
	addi %sp %sp -64 #2147
	lw %ra %sp 60 #2147
	li %f1 l.30230 #2147
	fmul %f0 %f0 %f1 #2147
	li %f1 l.30232 #2147
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
	blt %a1 %a12 bge_else.36784 # nontail if
	addi %a1 %a1 -5 #124
	jal %zero bge_cont.36785 # then sentence ends
bge_else.36784:
bge_cont.36785:
	lw %a2 %sp 48 #2149
	addi %a2 %a2 4 #2149
	lw %a11 %sp 0 #2149
	lw %a10 %a11 0 #2149
	jalr %zero %a10 0 #2149
bge_else.36783:
	jalr %zero %ra 0 #2150
bge_else.36777:
	jalr %zero %ra 0 #2150
create_dirvec_elements.2689:
	lw %a2 %a11 4 #2162
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.36788
	addi %a3 %zero 3 #2157
	li %f0 l.27725 #2157
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
	blt %a0 %a12 bge_else.36789
	addi %a1 %zero 3 #2157
	li %f0 l.27725 #2157
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
	blt %a0 %a12 bge_else.36790
	addi %a1 %zero 3 #2157
	li %f0 l.27725 #2157
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
	blt %a0 %a12 bge_else.36791
	addi %a1 %zero 3 #2157
	li %f0 l.27725 #2157
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
bge_else.36791:
	jalr %zero %ra 0 #2166
bge_else.36790:
	jalr %zero %ra 0 #2166
bge_else.36789:
	jalr %zero %ra 0 #2166
bge_else.36788:
	jalr %zero %ra 0 #2166
create_dirvecs.2692:
	lw %a1 %a11 12 #2169
	lw %a2 %a11 8 #2169
	lw %a3 %a11 4 #2169
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36796
	addi %a4 %zero 120 #2171
	addi %a5 %zero 3 #2157
	li %f0 l.27725 #2157
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
	li %f0 l.27725 #2157
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
	li %f0 l.27725 #2157
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
	li %f0 l.27725 #2157
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
	blt %a0 %a12 bge_else.36797
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.27725 #2157
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
	li %f0 l.27725 #2157
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
	li %f0 l.27725 #2157
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
	blt %a0 %a12 bge_else.36798
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.27725 #2157
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
	li %f0 l.27725 #2157
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
	blt %a0 %a12 bge_else.36799
	addi %a1 %zero 120 #2171
	addi %a2 %zero 3 #2157
	li %f0 l.27725 #2157
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
bge_else.36799:
	jalr %zero %ra 0 #2174
bge_else.36798:
	jalr %zero %ra 0 #2174
bge_else.36797:
	jalr %zero %ra 0 #2174
bge_else.36796:
	jalr %zero %ra 0 #2174
init_dirvec_constants.2694:
	lw %a2 %a11 16 #2179
	lw %a3 %a11 12 #2179
	lw %a4 %a11 8 #2179
	lw %a5 %a11 4 #2179
	addi %a12 %zero 0
	blt %a1 %a12 bge_else.36804
	slli %a6 %a1 2 #2181
	add %a12 %a0 %a6 #2181
	lw %a6 %a12 0 #2181
	lw %a7 %a4 0 #15
	addi %a7 %a7 -1 #1121
	sw %a11 %sp 0 #1104
	sw %a2 %sp 4 #1104
	sw %a5 %sp 8 #1104
	sw %a3 %sp 12 #1104
	sw %a4 %sp 16 #1104
	sw %a0 %sp 20 #1104
	sw %a1 %sp 24 #1104
	addi %a12 %zero 0
	blt %a7 %a12 bge_else.36805 # nontail if
	slli %a8 %a7 2 #20
	add %a12 %a3 %a8 #20
	lw %a8 %a12 0 #20
	lw %a9 %a6 4 #513
	lw %a10 %a6 0 #507
	lw %a11 %a8 4 #238
	sw %a6 %sp 28 #868
	addi %a12 %zero 1
	bne %a11 %a12 beq_else.36807 # nontail if
	sw %a9 %sp 32 #1110
	sw %a7 %sp 36 #1110
	add %a1 %a8 %zero
	add %a0 %a10 %zero
	sw %ra %sp 44 #1110 call dir
	addi %sp %sp 48 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -48 #1110
	lw %ra %sp 44 #1110
	lw %a1 %sp 36 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 32 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36808 # then sentence ends
beq_else.36807:
	addi %a12 %zero 2
	bne %a11 %a12 beq_else.36809 # nontail if
	sw %a9 %sp 32 #1112
	sw %a7 %sp 36 #1112
	add %a1 %a8 %zero
	add %a0 %a10 %zero
	sw %ra %sp 44 #1112 call dir
	addi %sp %sp 48 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -48 #1112
	lw %ra %sp 44 #1112
	lw %a1 %sp 36 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 32 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36810 # then sentence ends
beq_else.36809:
	sw %a9 %sp 32 #1114
	sw %a7 %sp 36 #1114
	add %a1 %a8 %zero
	add %a0 %a10 %zero
	sw %ra %sp 44 #1114 call dir
	addi %sp %sp 48 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -48 #1114
	lw %ra %sp 44 #1114
	lw %a1 %sp 36 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 32 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36810:
beq_cont.36808:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36811 # nontail if
	slli %a1 %a0 2 #20
	lw %a2 %sp 12 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a3 %sp 28 #513
	lw %a4 %a3 4 #513
	lw %a5 %a3 0 #507
	lw %a6 %a1 4 #238
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.36813 # nontail if
	sw %a4 %sp 40 #1110
	sw %a0 %sp 44 #1110
	add %a0 %a5 %zero
	sw %ra %sp 52 #1110 call dir
	addi %sp %sp 56 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -56 #1110
	lw %ra %sp 52 #1110
	lw %a1 %sp 44 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 40 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36814 # then sentence ends
beq_else.36813:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.36815 # nontail if
	sw %a4 %sp 40 #1112
	sw %a0 %sp 44 #1112
	add %a0 %a5 %zero
	sw %ra %sp 52 #1112 call dir
	addi %sp %sp 56 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -56 #1112
	lw %ra %sp 52 #1112
	lw %a1 %sp 44 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 40 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36816 # then sentence ends
beq_else.36815:
	sw %a4 %sp 40 #1114
	sw %a0 %sp 44 #1114
	add %a0 %a5 %zero
	sw %ra %sp 52 #1114 call dir
	addi %sp %sp 56 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -56 #1114
	lw %ra %sp 52 #1114
	lw %a1 %sp 44 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 40 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36816:
beq_cont.36814:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 28 #1116
	lw %a11 %sp 8 #1116
	sw %ra %sp 52 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 56 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -56 #1116
	lw %ra %sp 52 #1116
	jal %zero bge_cont.36812 # then sentence ends
bge_else.36811:
bge_cont.36812:
	jal %zero bge_cont.36806 # then sentence ends
bge_else.36805:
bge_cont.36806:
	lw %a0 %sp 24 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36817
	slli %a1 %a0 2 #2181
	lw %a2 %sp 20 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a3 %sp 16 #15
	lw %a4 %a3 0 #15
	addi %a4 %a4 -1 #1121
	sw %a0 %sp 48 #1104
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.36818 # nontail if
	slli %a5 %a4 2 #20
	lw %a6 %sp 12 #20
	add %a12 %a6 %a5 #20
	lw %a5 %a12 0 #20
	lw %a6 %a1 4 #513
	lw %a7 %a1 0 #507
	lw %a8 %a5 4 #238
	sw %a1 %sp 52 #868
	addi %a12 %zero 1
	bne %a8 %a12 beq_else.36820 # nontail if
	sw %a6 %sp 56 #1110
	sw %a4 %sp 60 #1110
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 68 #1110 call dir
	addi %sp %sp 72 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -72 #1110
	lw %ra %sp 68 #1110
	lw %a1 %sp 60 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 56 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36821 # then sentence ends
beq_else.36820:
	addi %a12 %zero 2
	bne %a8 %a12 beq_else.36822 # nontail if
	sw %a6 %sp 56 #1112
	sw %a4 %sp 60 #1112
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 68 #1112 call dir
	addi %sp %sp 72 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -72 #1112
	lw %ra %sp 68 #1112
	lw %a1 %sp 60 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 56 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36823 # then sentence ends
beq_else.36822:
	sw %a6 %sp 56 #1114
	sw %a4 %sp 60 #1114
	add %a1 %a5 %zero
	add %a0 %a7 %zero
	sw %ra %sp 68 #1114 call dir
	addi %sp %sp 72 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -72 #1114
	lw %ra %sp 68 #1114
	lw %a1 %sp 60 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 56 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36823:
beq_cont.36821:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 52 #1116
	lw %a11 %sp 8 #1116
	sw %ra %sp 68 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 72 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -72 #1116
	lw %ra %sp 68 #1116
	jal %zero bge_cont.36819 # then sentence ends
bge_else.36818:
bge_cont.36819:
	lw %a0 %sp 48 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36824
	slli %a1 %a0 2 #2181
	lw %a2 %sp 20 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a3 %sp 16 #15
	lw %a3 %a3 0 #15
	addi %a3 %a3 -1 #1121
	lw %a11 %sp 8 #1121
	sw %a0 %sp 64 #1121
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 68 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 72 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -72 #1121
	lw %ra %sp 68 #1121
	lw %a0 %sp 64 #2182
	addi %a0 %a0 -1 #2182
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36825
	slli %a1 %a0 2 #2181
	lw %a2 %sp 20 #2181
	add %a12 %a2 %a1 #2181
	lw %a1 %a12 0 #2181
	lw %a11 %sp 4 #2181
	sw %a0 %sp 68 #2181
	add %a0 %a1 %zero
	sw %ra %sp 76 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 80 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -80 #2181
	lw %ra %sp 76 #2181
	lw %a0 %sp 68 #2182
	addi %a1 %a0 -1 #2182
	lw %a0 %sp 20 #2182
	lw %a11 %sp 0 #2182
	lw %a10 %a11 0 #2182
	jalr %zero %a10 0 #2182
bge_else.36825:
	jalr %zero %ra 0 #2183
bge_else.36824:
	jalr %zero %ra 0 #2183
bge_else.36817:
	jalr %zero %ra 0 #2183
bge_else.36804:
	jalr %zero %ra 0 #2183
init_vecset_constants.2697:
	lw %a1 %a11 24 #2186
	lw %a2 %a11 20 #2186
	lw %a3 %a11 16 #2186
	lw %a4 %a11 12 #2186
	lw %a5 %a11 8 #2186
	lw %a6 %a11 4 #2186
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36830
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
	blt %a9 %a12 bge_else.36831 # nontail if
	slli %a10 %a9 2 #20
	add %a12 %a2 %a10 #20
	lw %a2 %a12 0 #20
	lw %a10 %a8 4 #513
	lw %a11 %a8 0 #507
	lw %a6 %a2 4 #238
	sw %a8 %sp 32 #868
	addi %a12 %zero 1
	bne %a6 %a12 beq_else.36833 # nontail if
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
	jal %zero beq_cont.36834 # then sentence ends
beq_else.36833:
	addi %a12 %zero 2
	bne %a6 %a12 beq_else.36835 # nontail if
	sw %a10 %sp 36 #1112
	sw %a9 %sp 40 #1112
	add %a1 %a2 %zero
	add %a0 %a11 %zero
	sw %ra %sp 44 #1112 call dir
	addi %sp %sp 48 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -48 #1112
	lw %ra %sp 44 #1112
	lw %a1 %sp 40 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 36 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36836 # then sentence ends
beq_else.36835:
	sw %a10 %sp 36 #1114
	sw %a9 %sp 40 #1114
	add %a1 %a2 %zero
	add %a0 %a11 %zero
	sw %ra %sp 44 #1114 call dir
	addi %sp %sp 48 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -48 #1114
	lw %ra %sp 44 #1114
	lw %a1 %sp 40 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 36 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36836:
beq_cont.36834:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 32 #1116
	lw %a11 %sp 20 #1116
	sw %ra %sp 44 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 48 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -48 #1116
	lw %ra %sp 44 #1116
	jal %zero bge_cont.36832 # then sentence ends
bge_else.36831:
bge_cont.36832:
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
	lw %a11 %sp 16 #2181
	add %a0 %a1 %zero
	sw %ra %sp 44 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 48 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -48 #2181
	lw %ra %sp 44 #2181
	addi %a1 %zero 116 #2182
	lw %a0 %sp 28 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 44 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 48 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -48 #2182
	lw %ra %sp 44 #2182
	lw %a0 %sp 8 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36837
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	lw %a3 %a1 476 #2181
	lw %a4 %sp 24 #15
	lw %a4 %a4 0 #15
	addi %a4 %a4 -1 #1121
	lw %a11 %sp 20 #1121
	sw %a0 %sp 44 #1121
	sw %a1 %sp 48 #1121
	add %a1 %a4 %zero
	add %a0 %a3 %zero
	sw %ra %sp 52 #1121 call cls
	lw %a10 %a11 0 #1121
	addi %sp %sp 56 #1121	
	jalr %ra %a10 0 #1121
	addi %sp %sp -56 #1121
	lw %ra %sp 52 #1121
	lw %a0 %sp 48 #2181
	lw %a1 %a0 472 #2181
	lw %a11 %sp 16 #2181
	add %a0 %a1 %zero
	sw %ra %sp 52 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 56 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -56 #2181
	lw %ra %sp 52 #2181
	addi %a1 %zero 117 #2182
	lw %a0 %sp 48 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 52 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 56 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -56 #2182
	lw %ra %sp 52 #2182
	lw %a0 %sp 44 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36838
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	lw %a3 %a1 476 #2181
	lw %a11 %sp 16 #2181
	sw %a0 %sp 52 #2181
	sw %a1 %sp 56 #2181
	add %a0 %a3 %zero
	sw %ra %sp 60 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 64 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -64 #2181
	lw %ra %sp 60 #2181
	addi %a1 %zero 118 #2182
	lw %a0 %sp 56 #2182
	lw %a11 %sp 12 #2182
	sw %ra %sp 60 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 64 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -64 #2182
	lw %ra %sp 60 #2182
	lw %a0 %sp 52 #2189
	addi %a0 %a0 -1 #2189
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36839
	slli %a1 %a0 2 #81
	lw %a2 %sp 4 #81
	add %a12 %a2 %a1 #81
	lw %a1 %a12 0 #81
	addi %a2 %zero 119 #2188
	lw %a11 %sp 12 #2188
	sw %a0 %sp 60 #2188
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 68 #2188 call cls
	lw %a10 %a11 0 #2188
	addi %sp %sp 72 #2188	
	jalr %ra %a10 0 #2188
	addi %sp %sp -72 #2188
	lw %ra %sp 68 #2188
	lw %a0 %sp 60 #2189
	addi %a0 %a0 -1 #2189
	lw %a11 %sp 0 #2189
	lw %a10 %a11 0 #2189
	jalr %zero %a10 0 #2189
bge_else.36839:
	jalr %zero %ra 0 #2190
bge_else.36838:
	jalr %zero %ra 0 #2190
bge_else.36837:
	jalr %zero %ra 0 #2190
bge_else.36830:
	jalr %zero %ra 0 #2190
setup_rect_reflection.2708:
	lw %a2 %a11 24 #2211
	lw %a3 %a11 20 #2211
	lw %a4 %a11 16 #2211
	lw %a5 %a11 12 #2211
	lw %a6 %a11 8 #2211
	lw %a7 %a11 4 #2211
	addi %a8 %zero 4 #2212
	sw %a2 %sp 0 #2212
	sw %a7 %sp 4 #2212
	sw %a3 %sp 8 #2212
	sw %a5 %sp 12 #2212
	sw %a6 %sp 16 #2212
	sw %a1 %sp 20 #2212
	sw %a4 %sp 24 #2212
	add %a1 %a8 %zero
	sw %ra %sp 28 #2212 call dir
	addi %sp %sp 32 #2212	
	jal %ra min_caml_sll #2212
	addi %sp %sp -32 #2212
	lw %ra %sp 28 #2212
	lw %a1 %sp 24 #99
	lw %a2 %a1 0 #99
	li %f0 l.27799 #2214
	lw %a3 %sp 20 #346
	lw %a3 %a3 28 #346
	lw %f1 %a3 0 #351
	fsub %f0 %f0 %f1 #2214
	lw %a3 %sp 16 #27
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
	lw %a0 %sp 16 #27
	lw %f1 %a0 4 #27
	sw %f0 %sp 48 #2216
	fadd %f0 %f1 %fzero
	sw %ra %sp 60 #2216 call dir
	addi %sp %sp 64 #2216	
	jal %ra min_caml_fneg #2216
	addi %sp %sp -64 #2216
	lw %ra %sp 60 #2216
	lw %a0 %sp 16 #27
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
	lw %a2 %sp 16 #27
	lw %f1 %a2 0 #27
	addi %a3 %zero 3 #2157
	li %f2 l.27725 #2157
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
	lw %a0 %sp 12 #15
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
	lw %a2 %sp 88 #2159
	sw %a2 %a1 0 #2159
	lw %f0 %sp 80 #133
	sw %f0 %a2 0 #133
	lw %f0 %sp 56 #134
	sw %f0 %a2 4 #134
	lw %f1 %sp 72 #135
	sw %f1 %a2 8 #135
	lw %a3 %sp 12 #15
	lw %a4 %a3 0 #15
	addi %a4 %a4 -1 #1121
	sw %a1 %sp 92 #1104
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.36846 # nontail if
	slli %a5 %a4 2 #20
	lw %a6 %sp 8 #20
	add %a12 %a6 %a5 #20
	lw %a5 %a12 0 #20
	lw %a7 %a5 4 #238
	addi %a12 %zero 1
	bne %a7 %a12 beq_else.36848 # nontail if
	sw %a0 %sp 96 #1110
	sw %a4 %sp 100 #1110
	add %a1 %a5 %zero
	add %a0 %a2 %zero
	sw %ra %sp 108 #1110 call dir
	addi %sp %sp 112 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -112 #1110
	lw %ra %sp 108 #1110
	lw %a1 %sp 100 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 96 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36849 # then sentence ends
beq_else.36848:
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.36850 # nontail if
	sw %a0 %sp 96 #1112
	sw %a4 %sp 100 #1112
	add %a1 %a5 %zero
	add %a0 %a2 %zero
	sw %ra %sp 108 #1112 call dir
	addi %sp %sp 112 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -112 #1112
	lw %ra %sp 108 #1112
	lw %a1 %sp 100 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 96 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36851 # then sentence ends
beq_else.36850:
	sw %a0 %sp 96 #1114
	sw %a4 %sp 100 #1114
	add %a1 %a5 %zero
	add %a0 %a2 %zero
	sw %ra %sp 108 #1114 call dir
	addi %sp %sp 112 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -112 #1114
	lw %ra %sp 108 #1114
	lw %a1 %sp 100 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 96 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36851:
beq_cont.36849:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 92 #1116
	lw %a11 %sp 4 #1116
	sw %ra %sp 108 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 112 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -112 #1116
	lw %ra %sp 108 #1116
	jal %zero bge_cont.36847 # then sentence ends
bge_else.36846:
bge_cont.36847:
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
	lw %a5 %sp 16 #27
	lw %f1 %a5 4 #27
	addi %a6 %zero 3 #2157
	li %f2 l.27725 #2157
	sw %a0 %sp 104 #2157
	sw %a4 %sp 108 #2157
	sw %f1 %sp 112 #2157
	add %a0 %a6 %zero
	fadd %f0 %f2 %fzero
	sw %ra %sp 124 #2157 call dir
	addi %sp %sp 128 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -128 #2157
	lw %ra %sp 124 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
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
	lw %a2 %sp 120 #2159
	sw %a2 %a1 0 #2159
	lw %f0 %sp 48 #133
	sw %f0 %a2 0 #133
	lw %f1 %sp 112 #134
	sw %f1 %a2 4 #134
	lw %f1 %sp 72 #135
	sw %f1 %a2 8 #135
	lw %a3 %sp 12 #15
	lw %a4 %a3 0 #15
	addi %a4 %a4 -1 #1121
	sw %a1 %sp 124 #1104
	addi %a12 %zero 0
	blt %a4 %a12 bge_else.36852 # nontail if
	slli %a5 %a4 2 #20
	lw %a6 %sp 8 #20
	add %a12 %a6 %a5 #20
	lw %a5 %a12 0 #20
	lw %a7 %a5 4 #238
	addi %a12 %zero 1
	bne %a7 %a12 beq_else.36854 # nontail if
	sw %a0 %sp 128 #1110
	sw %a4 %sp 132 #1110
	add %a1 %a5 %zero
	add %a0 %a2 %zero
	sw %ra %sp 140 #1110 call dir
	addi %sp %sp 144 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -144 #1110
	lw %ra %sp 140 #1110
	lw %a1 %sp 132 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 128 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36855 # then sentence ends
beq_else.36854:
	addi %a12 %zero 2
	bne %a7 %a12 beq_else.36856 # nontail if
	sw %a0 %sp 128 #1112
	sw %a4 %sp 132 #1112
	add %a1 %a5 %zero
	add %a0 %a2 %zero
	sw %ra %sp 140 #1112 call dir
	addi %sp %sp 144 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -144 #1112
	lw %ra %sp 140 #1112
	lw %a1 %sp 132 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 128 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36857 # then sentence ends
beq_else.36856:
	sw %a0 %sp 128 #1114
	sw %a4 %sp 132 #1114
	add %a1 %a5 %zero
	add %a0 %a2 %zero
	sw %ra %sp 140 #1114 call dir
	addi %sp %sp 144 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -144 #1114
	lw %ra %sp 140 #1114
	lw %a1 %sp 132 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 128 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36857:
beq_cont.36855:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 124 #1116
	lw %a11 %sp 4 #1116
	sw %ra %sp 140 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 144 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -144 #1116
	lw %ra %sp 140 #1116
	jal %zero bge_cont.36853 # then sentence ends
bge_else.36852:
bge_cont.36853:
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 32 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 124 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 108 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 104 #2207
	slli %a1 %a1 2 #2207
	lw %a2 %sp 0 #2207
	add %a12 %a2 %a1 #2207
	sw %a0 %a12 0 #2207
	lw %a0 %sp 28 #2220
	addi %a1 %a0 2 #2220
	lw %a3 %sp 40 #2220
	addi %a3 %a3 3 #2220
	lw %a4 %sp 16 #27
	lw %f1 %a4 8 #27
	addi %a4 %zero 3 #2157
	li %f2 l.27725 #2157
	sw %a1 %sp 136 #2157
	sw %a3 %sp 140 #2157
	sw %f1 %sp 144 #2157
	add %a0 %a4 %zero
	fadd %f0 %f2 %fzero
	sw %ra %sp 156 #2157 call dir
	addi %sp %sp 160 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -160 #2157
	lw %ra %sp 156 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
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
	lw %a2 %sp 152 #2159
	sw %a2 %a1 0 #2159
	lw %f0 %sp 48 #133
	sw %f0 %a2 0 #133
	lw %f0 %sp 56 #134
	sw %f0 %a2 4 #134
	lw %f0 %sp 144 #135
	sw %f0 %a2 8 #135
	lw %a3 %sp 12 #15
	lw %a3 %a3 0 #15
	addi %a3 %a3 -1 #1121
	sw %a1 %sp 156 #1104
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.36858 # nontail if
	slli %a4 %a3 2 #20
	lw %a5 %sp 8 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	lw %a5 %a4 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.36860 # nontail if
	sw %a0 %sp 160 #1110
	sw %a3 %sp 164 #1110
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 172 #1110 call dir
	addi %sp %sp 176 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -176 #1110
	lw %ra %sp 172 #1110
	lw %a1 %sp 164 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 160 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36861 # then sentence ends
beq_else.36860:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.36862 # nontail if
	sw %a0 %sp 160 #1112
	sw %a3 %sp 164 #1112
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 172 #1112 call dir
	addi %sp %sp 176 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -176 #1112
	lw %ra %sp 172 #1112
	lw %a1 %sp 164 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 160 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36863 # then sentence ends
beq_else.36862:
	sw %a0 %sp 160 #1114
	sw %a3 %sp 164 #1114
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 172 #1114 call dir
	addi %sp %sp 176 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -176 #1114
	lw %ra %sp 172 #1114
	lw %a1 %sp 164 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 160 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36863:
beq_cont.36861:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 156 #1116
	lw %a11 %sp 4 #1116
	sw %ra %sp 172 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 176 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -176 #1116
	lw %ra %sp 172 #1116
	jal %zero bge_cont.36859 # then sentence ends
bge_else.36858:
bge_cont.36859:
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 32 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 156 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 140 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 136 #2207
	slli %a1 %a1 2 #2207
	lw %a2 %sp 0 #2207
	add %a12 %a2 %a1 #2207
	sw %a0 %a12 0 #2207
	lw %a0 %sp 28 #2221
	addi %a0 %a0 3 #2221
	lw %a1 %sp 24 #2221
	sw %a0 %a1 0 #2221
	jalr %zero %ra 0 #2221
setup_surface_reflection.2711:
	lw %a2 %a11 24 #2225
	lw %a3 %a11 20 #2225
	lw %a4 %a11 16 #2225
	lw %a5 %a11 12 #2225
	lw %a6 %a11 8 #2225
	lw %a7 %a11 4 #2225
	addi %a8 %zero 4 #2226
	sw %a2 %sp 0 #2226
	sw %a7 %sp 4 #2226
	sw %a3 %sp 8 #2226
	sw %a5 %sp 12 #2226
	sw %a6 %sp 16 #2226
	sw %a1 %sp 20 #2226
	sw %a4 %sp 24 #2226
	add %a1 %a8 %zero
	sw %ra %sp 28 #2226 call dir
	addi %sp %sp 32 #2226	
	jal %ra min_caml_sll #2226
	addi %sp %sp -32 #2226
	lw %ra %sp 28 #2226
	addi %a0 %a0 1 #2226
	lw %a1 %sp 24 #99
	lw %a2 %a1 0 #99
	li %f0 l.27799 #2228
	lw %a3 %sp 20 #346
	lw %a4 %a3 28 #346
	lw %f1 %a4 0 #351
	fsub %f0 %f0 %f1 #2228
	lw %a4 %a3 16 #306
	lw %a5 %sp 16 #181
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
	li %f2 l.27753 #2232
	lw %a4 %a3 16 #276
	lw %f3 %a4 0 #281
	fmul %f2 %f2 %f3 #2232
	fmul %f2 %f2 %f1 #2232
	lw %f3 %a5 0 #27
	fsub %f2 %f2 %f3 #2232
	li %f3 l.27753 #2233
	lw %a4 %a3 16 #286
	lw %f4 %a4 4 #291
	fmul %f3 %f3 %f4 #2233
	fmul %f3 %f3 %f1 #2233
	lw %f4 %a5 4 #27
	fsub %f3 %f3 %f4 #2233
	li %f4 l.27753 #2234
	lw %a3 %a3 16 #296
	lw %f5 %a3 8 #301
	fmul %f4 %f4 %f5 #2234
	fmul %f1 %f4 %f1 #2234
	lw %f4 %a5 8 #27
	fsub %f1 %f1 %f4 #2234
	addi %a3 %zero 3 #2157
	li %f4 l.27725 #2157
	sw %a2 %sp 28 #2157
	sw %a0 %sp 32 #2157
	sw %f0 %sp 40 #2157
	sw %f1 %sp 48 #2157
	sw %f3 %sp 56 #2157
	sw %f2 %sp 64 #2157
	add %a0 %a3 %zero
	fadd %f0 %f4 %fzero
	sw %ra %sp 76 #2157 call dir
	addi %sp %sp 80 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -80 #2157
	lw %ra %sp 76 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 12 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 72 #2158
	add %a0 %a2 %zero
	sw %ra %sp 76 #2158 call dir
	addi %sp %sp 80 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -80 #2158
	lw %ra %sp 76 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a2 %sp 72 #2159
	sw %a2 %a1 0 #2159
	lw %f0 %sp 64 #133
	sw %f0 %a2 0 #133
	lw %f0 %sp 56 #134
	sw %f0 %a2 4 #134
	lw %f0 %sp 48 #135
	sw %f0 %a2 8 #135
	lw %a3 %sp 12 #15
	lw %a3 %a3 0 #15
	addi %a3 %a3 -1 #1121
	sw %a1 %sp 76 #1104
	addi %a12 %zero 0
	blt %a3 %a12 bge_else.36866 # nontail if
	slli %a4 %a3 2 #20
	lw %a5 %sp 8 #20
	add %a12 %a5 %a4 #20
	lw %a4 %a12 0 #20
	lw %a5 %a4 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.36868 # nontail if
	sw %a0 %sp 80 #1110
	sw %a3 %sp 84 #1110
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 92 #1110 call dir
	addi %sp %sp 96 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -96 #1110
	lw %ra %sp 92 #1110
	lw %a1 %sp 84 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 80 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36869 # then sentence ends
beq_else.36868:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.36870 # nontail if
	sw %a0 %sp 80 #1112
	sw %a3 %sp 84 #1112
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 92 #1112 call dir
	addi %sp %sp 96 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -96 #1112
	lw %ra %sp 92 #1112
	lw %a1 %sp 84 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 80 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36871 # then sentence ends
beq_else.36870:
	sw %a0 %sp 80 #1114
	sw %a3 %sp 84 #1114
	add %a1 %a4 %zero
	add %a0 %a2 %zero
	sw %ra %sp 92 #1114 call dir
	addi %sp %sp 96 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -96 #1114
	lw %ra %sp 92 #1114
	lw %a1 %sp 84 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 80 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36871:
beq_cont.36869:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 76 #1116
	lw %a11 %sp 4 #1116
	sw %ra %sp 92 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 96 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -96 #1116
	lw %ra %sp 92 #1116
	jal %zero bge_cont.36867 # then sentence ends
bge_else.36866:
bge_cont.36867:
	addi %a0 %min_caml_hp 0 #2207
	addi %min_caml_hp %min_caml_hp 16 #2207
	lw %f0 %sp 40 #2207
	sw %f0 %a0 8 #2207
	lw %a1 %sp 76 #2207
	sw %a1 %a0 4 #2207
	lw %a1 %sp 32 #2207
	sw %a1 %a0 0 #2207
	lw %a1 %sp 28 #2207
	slli %a2 %a1 2 #2207
	lw %a3 %sp 0 #2207
	add %a12 %a3 %a2 #2207
	sw %a0 %a12 0 #2207
	addi %a0 %a1 1 #2235
	lw %a1 %sp 24 #2235
	sw %a0 %a1 0 #2235
	jalr %zero %ra 0 #2235
rt.2716:
	lw %a2 %a11 124 #2260
	lw %a3 %a11 120 #2260
	lw %a4 %a11 116 #2260
	lw %a5 %a11 112 #2260
	lw %a6 %a11 108 #2260
	lw %a7 %a11 104 #2260
	lw %a8 %a11 100 #2260
	lw %a9 %a11 96 #2260
	lw %a10 %a11 92 #2260
	sw %a10 %sp 0 #2260
	lw %a10 %a11 88 #2260
	sw %a8 %sp 4 #2260
	lw %a8 %a11 84 #2260
	sw %a6 %sp 8 #2260
	lw %a6 %a11 80 #2260
	sw %a7 %sp 12 #2260
	lw %a7 %a11 76 #2260
	sw %a3 %sp 16 #2260
	lw %a3 %a11 72 #2260
	sw %a3 %sp 20 #2260
	lw %a3 %a11 68 #2260
	sw %a4 %sp 24 #2260
	lw %a4 %a11 64 #2260
	sw %a4 %sp 28 #2260
	lw %a4 %a11 60 #2260
	sw %a2 %sp 32 #2260
	lw %a2 %a11 56 #2260
	sw %a2 %sp 36 #2260
	lw %a2 %a11 52 #2260
	sw %a5 %sp 40 #2260
	lw %a5 %a11 48 #2260
	sw %a5 %sp 44 #2260
	lw %a5 %a11 44 #2260
	sw %a5 %sp 48 #2260
	lw %a5 %a11 40 #2260
	sw %a5 %sp 52 #2260
	lw %a5 %a11 36 #2260
	sw %a3 %sp 56 #2260
	lw %a3 %a11 32 #2260
	sw %a7 %sp 60 #2260
	lw %a7 %a11 28 #2260
	sw %a7 %sp 64 #2260
	lw %a7 %a11 24 #2260
	sw %a7 %sp 68 #2260
	lw %a7 %a11 20 #2260
	sw %a7 %sp 72 #2260
	lw %a7 %a11 16 #2260
	sw %a7 %sp 76 #2260
	lw %a7 %a11 12 #2260
	sw %a7 %sp 80 #2260
	lw %a7 %a11 8 #2260
	lw %a11 %a11 4 #2260
	sw %a0 %a5 0 #2262
	sw %a1 %a5 4 #2263
	sw %a11 %sp 84 #2264
	addi %a11 %zero 2 #2264
	sw %a8 %sp 88 #2264
	sw %a4 %sp 92 #2264
	sw %a6 %sp 96 #2264
	sw %a7 %sp 100 #2264
	sw %a2 %sp 104 #2264
	sw %a10 %sp 108 #2264
	sw %a5 %sp 112 #2264
	sw %a9 %sp 116 #2264
	sw %a0 %sp 120 #2264
	sw %a1 %sp 124 #2264
	sw %a3 %sp 128 #2264
	add %a1 %a11 %zero
	sw %ra %sp 132 #2264 call dir
	addi %sp %sp 136 #2264	
	jal %ra min_caml_srl #2264
	addi %sp %sp -136 #2264
	lw %ra %sp 132 #2264
	lw %a1 %sp 128 #2264
	sw %a0 %a1 0 #2264
	addi %a0 %zero 2 #2265
	lw %a2 %sp 124 #2265
	add %a1 %a0 %zero
	add %a0 %a2 %zero
	sw %ra %sp 132 #2265 call dir
	addi %sp %sp 136 #2265	
	jal %ra min_caml_srl #2265
	addi %sp %sp -136 #2265
	lw %ra %sp 132 #2265
	lw %a1 %sp 128 #2265
	sw %a0 %a1 4 #2265
	li %f0 l.30489 #2266
	lw %a0 %sp 120 #2266
	sw %f0 %sp 136 #2266
	sw %ra %sp 148 #2266 call dir
	addi %sp %sp 152 #2266	
	jal %ra min_caml_float_of_int #2266
	addi %sp %sp -152 #2266
	lw %ra %sp 148 #2266
	lw %f1 %sp 136 #2266
	fdiv %f0 %f1 %f0 #2266
	lw %a0 %sp 116 #2266
	sw %f0 %a0 0 #2266
	lw %a1 %sp 112 #57
	lw %a2 %a1 0 #57
	sw %a2 %sp 144 #2088
	sw %ra %sp 148 #2088 call dir
	addi %sp %sp 152 #2088	
	jal %ra create_pixel.2658 #2088
	addi %sp %sp -152 #2088
	lw %ra %sp 148 #2088
	add %a1 %a0 %zero #2088
	lw %a0 %sp 144 #2088
	sw %ra %sp 148 #2088 call dir
	addi %sp %sp 152 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -152 #2088
	lw %ra %sp 148 #2088
	lw %a1 %sp 112 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36874 # nontail if
	addi %a3 %zero 3 #2066
	li %f0 l.27725 #2066
	sw %a0 %sp 148 #2066
	sw %a2 %sp 152 #2066
	add %a0 %a3 %zero
	sw %ra %sp 156 #2066 call dir
	addi %sp %sp 160 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -160 #2066
	lw %ra %sp 156 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 156 #2054
	add %a0 %a1 %zero
	sw %ra %sp 164 #2054 call dir
	addi %sp %sp 168 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -168 #2054
	lw %ra %sp 164 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 164 #2055 call dir
	addi %sp %sp 168 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -168 #2055
	lw %ra %sp 164 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 160 #2056
	add %a0 %a1 %zero
	sw %ra %sp 164 #2056 call dir
	addi %sp %sp 168 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -168 #2056
	lw %ra %sp 164 #2056
	lw %a1 %sp 160 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 164 #2057 call dir
	addi %sp %sp 168 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -168 #2057
	lw %ra %sp 164 #2057
	lw %a1 %sp 160 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 164 #2058 call dir
	addi %sp %sp 168 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -168 #2058
	lw %ra %sp 164 #2058
	lw %a1 %sp 160 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 164 #2059 call dir
	addi %sp %sp 168 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -168 #2059
	lw %ra %sp 164 #2059
	lw %a1 %sp 160 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 164 #2068 call dir
	addi %sp %sp 168 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -168 #2068
	lw %ra %sp 164 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 164 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 172 #2069 call dir
	addi %sp %sp 176 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -176 #2069
	lw %ra %sp 172 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 168 #2054
	add %a0 %a1 %zero
	sw %ra %sp 172 #2054 call dir
	addi %sp %sp 176 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -176 #2054
	lw %ra %sp 172 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 172 #2055 call dir
	addi %sp %sp 176 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -176 #2055
	lw %ra %sp 172 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 172 #2056
	add %a0 %a1 %zero
	sw %ra %sp 180 #2056 call dir
	addi %sp %sp 184 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -184 #2056
	lw %ra %sp 180 #2056
	lw %a1 %sp 172 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 180 #2057 call dir
	addi %sp %sp 184 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -184 #2057
	lw %ra %sp 180 #2057
	lw %a1 %sp 172 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 180 #2058 call dir
	addi %sp %sp 184 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -184 #2058
	lw %ra %sp 180 #2058
	lw %a1 %sp 172 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 180 #2059 call dir
	addi %sp %sp 184 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -184 #2059
	lw %ra %sp 180 #2059
	lw %a1 %sp 172 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %ra %sp 180 #2054 call dir
	addi %sp %sp 184 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -184 #2054
	lw %ra %sp 180 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 180 #2055 call dir
	addi %sp %sp 184 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -184 #2055
	lw %ra %sp 180 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 176 #2056
	add %a0 %a1 %zero
	sw %ra %sp 180 #2056 call dir
	addi %sp %sp 184 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -184 #2056
	lw %ra %sp 180 #2056
	lw %a1 %sp 176 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 180 #2057 call dir
	addi %sp %sp 184 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -184 #2057
	lw %ra %sp 180 #2057
	lw %a1 %sp 176 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 180 #2058 call dir
	addi %sp %sp 184 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -184 #2058
	lw %ra %sp 180 #2058
	lw %a1 %sp 176 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 180 #2059 call dir
	addi %sp %sp 184 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -184 #2059
	lw %ra %sp 180 #2059
	lw %a1 %sp 176 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 180 #2072 call dir
	addi %sp %sp 184 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -184 #2072
	lw %ra %sp 180 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 180 #2054
	add %a0 %a1 %zero
	sw %ra %sp 188 #2054 call dir
	addi %sp %sp 192 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -192 #2054
	lw %ra %sp 188 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 188 #2055 call dir
	addi %sp %sp 192 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -192 #2055
	lw %ra %sp 188 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 184 #2056
	add %a0 %a1 %zero
	sw %ra %sp 188 #2056 call dir
	addi %sp %sp 192 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -192 #2056
	lw %ra %sp 188 #2056
	lw %a1 %sp 184 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 188 #2057 call dir
	addi %sp %sp 192 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -192 #2057
	lw %ra %sp 188 #2057
	lw %a1 %sp 184 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 188 #2058 call dir
	addi %sp %sp 192 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -192 #2058
	lw %ra %sp 188 #2058
	lw %a1 %sp 184 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 188 #2059 call dir
	addi %sp %sp 192 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -192 #2059
	lw %ra %sp 188 #2059
	lw %a1 %sp 184 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 180 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 176 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 172 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 168 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 164 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 160 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 156 #2074
	sw %a1 %a0 0 #2074
	lw %a1 %sp 152 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 148 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a0 %a1 -1 #2081
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36876 # nontail if
	sw %a0 %sp 188 #2080
	sw %ra %sp 196 #2080 call dir
	addi %sp %sp 200 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -200 #2080
	lw %ra %sp 196 #2080
	lw %a1 %sp 188 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 148 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 196 #2081 call dir
	addi %sp %sp 200 #2081	
	jal %ra init_line_elements.2660 #2081
	addi %sp %sp -200 #2081
	lw %ra %sp 196 #2081
	jal %zero bge_cont.36877 # then sentence ends
bge_else.36876:
	addi %a0 %a3 0 #2083
bge_cont.36877:
	jal %zero bge_cont.36875 # then sentence ends
bge_else.36874:
bge_cont.36875:
	lw %a1 %sp 112 #57
	lw %a2 %a1 0 #57
	sw %a0 %sp 192 #2088
	sw %a2 %sp 196 #2088
	sw %ra %sp 204 #2088 call dir
	addi %sp %sp 208 #2088	
	jal %ra create_pixel.2658 #2088
	addi %sp %sp -208 #2088
	lw %ra %sp 204 #2088
	add %a1 %a0 %zero #2088
	lw %a0 %sp 196 #2088
	sw %ra %sp 204 #2088 call dir
	addi %sp %sp 208 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -208 #2088
	lw %ra %sp 204 #2088
	lw %a1 %sp 112 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36878 # nontail if
	addi %a3 %zero 3 #2066
	li %f0 l.27725 #2066
	sw %a0 %sp 200 #2066
	sw %a2 %sp 204 #2066
	add %a0 %a3 %zero
	sw %ra %sp 212 #2066 call dir
	addi %sp %sp 216 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -216 #2066
	lw %ra %sp 212 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 208 #2054
	add %a0 %a1 %zero
	sw %ra %sp 212 #2054 call dir
	addi %sp %sp 216 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -216 #2054
	lw %ra %sp 212 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 212 #2055 call dir
	addi %sp %sp 216 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -216 #2055
	lw %ra %sp 212 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 212 #2056
	add %a0 %a1 %zero
	sw %ra %sp 220 #2056 call dir
	addi %sp %sp 224 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -224 #2056
	lw %ra %sp 220 #2056
	lw %a1 %sp 212 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 220 #2057 call dir
	addi %sp %sp 224 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -224 #2057
	lw %ra %sp 220 #2057
	lw %a1 %sp 212 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 220 #2058 call dir
	addi %sp %sp 224 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -224 #2058
	lw %ra %sp 220 #2058
	lw %a1 %sp 212 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 220 #2059 call dir
	addi %sp %sp 224 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -224 #2059
	lw %ra %sp 220 #2059
	lw %a1 %sp 212 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 220 #2068 call dir
	addi %sp %sp 224 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -224 #2068
	lw %ra %sp 220 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 216 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 220 #2069 call dir
	addi %sp %sp 224 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -224 #2069
	lw %ra %sp 220 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 220 #2054
	add %a0 %a1 %zero
	sw %ra %sp 228 #2054 call dir
	addi %sp %sp 232 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -232 #2054
	lw %ra %sp 228 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 228 #2055 call dir
	addi %sp %sp 232 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -232 #2055
	lw %ra %sp 228 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 224 #2056
	add %a0 %a1 %zero
	sw %ra %sp 228 #2056 call dir
	addi %sp %sp 232 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -232 #2056
	lw %ra %sp 228 #2056
	lw %a1 %sp 224 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 228 #2057 call dir
	addi %sp %sp 232 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -232 #2057
	lw %ra %sp 228 #2057
	lw %a1 %sp 224 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 228 #2058 call dir
	addi %sp %sp 232 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -232 #2058
	lw %ra %sp 228 #2058
	lw %a1 %sp 224 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 228 #2059 call dir
	addi %sp %sp 232 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -232 #2059
	lw %ra %sp 228 #2059
	lw %a1 %sp 224 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %ra %sp 228 #2054 call dir
	addi %sp %sp 232 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -232 #2054
	lw %ra %sp 228 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 228 #2055 call dir
	addi %sp %sp 232 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -232 #2055
	lw %ra %sp 228 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 228 #2056
	add %a0 %a1 %zero
	sw %ra %sp 236 #2056 call dir
	addi %sp %sp 240 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -240 #2056
	lw %ra %sp 236 #2056
	lw %a1 %sp 228 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 236 #2057 call dir
	addi %sp %sp 240 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -240 #2057
	lw %ra %sp 236 #2057
	lw %a1 %sp 228 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 236 #2058 call dir
	addi %sp %sp 240 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -240 #2058
	lw %ra %sp 236 #2058
	lw %a1 %sp 228 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 236 #2059 call dir
	addi %sp %sp 240 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -240 #2059
	lw %ra %sp 236 #2059
	lw %a1 %sp 228 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 236 #2072 call dir
	addi %sp %sp 240 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -240 #2072
	lw %ra %sp 236 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 232 #2054
	add %a0 %a1 %zero
	sw %ra %sp 236 #2054 call dir
	addi %sp %sp 240 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -240 #2054
	lw %ra %sp 236 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 236 #2055 call dir
	addi %sp %sp 240 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -240 #2055
	lw %ra %sp 236 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 236 #2056
	add %a0 %a1 %zero
	sw %ra %sp 244 #2056 call dir
	addi %sp %sp 248 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -248 #2056
	lw %ra %sp 244 #2056
	lw %a1 %sp 236 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 244 #2057 call dir
	addi %sp %sp 248 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -248 #2057
	lw %ra %sp 244 #2057
	lw %a1 %sp 236 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 244 #2058 call dir
	addi %sp %sp 248 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -248 #2058
	lw %ra %sp 244 #2058
	lw %a1 %sp 236 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 244 #2059 call dir
	addi %sp %sp 248 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -248 #2059
	lw %ra %sp 244 #2059
	lw %a1 %sp 236 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 232 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 228 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 224 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 220 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 216 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 212 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 208 #2074
	sw %a1 %a0 0 #2074
	lw %a1 %sp 204 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 200 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a0 %a1 -1 #2081
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36880 # nontail if
	sw %a0 %sp 240 #2080
	sw %ra %sp 244 #2080 call dir
	addi %sp %sp 248 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -248 #2080
	lw %ra %sp 244 #2080
	lw %a1 %sp 240 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 200 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 244 #2081 call dir
	addi %sp %sp 248 #2081	
	jal %ra init_line_elements.2660 #2081
	addi %sp %sp -248 #2081
	lw %ra %sp 244 #2081
	jal %zero bge_cont.36881 # then sentence ends
bge_else.36880:
	addi %a0 %a3 0 #2083
bge_cont.36881:
	jal %zero bge_cont.36879 # then sentence ends
bge_else.36878:
bge_cont.36879:
	lw %a1 %sp 112 #57
	lw %a2 %a1 0 #57
	sw %a0 %sp 244 #2088
	sw %a2 %sp 248 #2088
	sw %ra %sp 252 #2088 call dir
	addi %sp %sp 256 #2088	
	jal %ra create_pixel.2658 #2088
	addi %sp %sp -256 #2088
	lw %ra %sp 252 #2088
	add %a1 %a0 %zero #2088
	lw %a0 %sp 248 #2088
	sw %ra %sp 252 #2088 call dir
	addi %sp %sp 256 #2088	
	jal %ra min_caml_create_array #2088
	addi %sp %sp -256 #2088
	lw %ra %sp 252 #2088
	lw %a1 %sp 112 #57
	lw %a2 %a1 0 #57
	addi %a2 %a2 -2 #2089
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36882 # nontail if
	addi %a3 %zero 3 #2066
	li %f0 l.27725 #2066
	sw %a0 %sp 252 #2066
	sw %a2 %sp 256 #2066
	add %a0 %a3 %zero
	sw %ra %sp 260 #2066 call dir
	addi %sp %sp 264 #2066	
	jal %ra min_caml_create_float_array #2066
	addi %sp %sp -264 #2066
	lw %ra %sp 260 #2066
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 260 #2054
	add %a0 %a1 %zero
	sw %ra %sp 268 #2054 call dir
	addi %sp %sp 272 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -272 #2054
	lw %ra %sp 268 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 268 #2055 call dir
	addi %sp %sp 272 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -272 #2055
	lw %ra %sp 268 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 264 #2056
	add %a0 %a1 %zero
	sw %ra %sp 268 #2056 call dir
	addi %sp %sp 272 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -272 #2056
	lw %ra %sp 268 #2056
	lw %a1 %sp 264 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 268 #2057 call dir
	addi %sp %sp 272 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -272 #2057
	lw %ra %sp 268 #2057
	lw %a1 %sp 264 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 268 #2058 call dir
	addi %sp %sp 272 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -272 #2058
	lw %ra %sp 268 #2058
	lw %a1 %sp 264 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 268 #2059 call dir
	addi %sp %sp 272 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -272 #2059
	lw %ra %sp 268 #2059
	lw %a1 %sp 264 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 5 #2068
	addi %a2 %zero 0 #2068
	add %a1 %a2 %zero
	sw %ra %sp 268 #2068 call dir
	addi %sp %sp 272 #2068	
	jal %ra min_caml_create_array #2068
	addi %sp %sp -272 #2068
	lw %ra %sp 268 #2068
	addi %a1 %zero 5 #2069
	addi %a2 %zero 0 #2069
	sw %a0 %sp 268 #2069
	add %a0 %a1 %zero
	add %a1 %a2 %zero
	sw %ra %sp 276 #2069 call dir
	addi %sp %sp 280 #2069	
	jal %ra min_caml_create_array #2069
	addi %sp %sp -280 #2069
	lw %ra %sp 276 #2069
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 272 #2054
	add %a0 %a1 %zero
	sw %ra %sp 276 #2054 call dir
	addi %sp %sp 280 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -280 #2054
	lw %ra %sp 276 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 276 #2055 call dir
	addi %sp %sp 280 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -280 #2055
	lw %ra %sp 276 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 276 #2056
	add %a0 %a1 %zero
	sw %ra %sp 284 #2056 call dir
	addi %sp %sp 288 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -288 #2056
	lw %ra %sp 284 #2056
	lw %a1 %sp 276 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 284 #2057 call dir
	addi %sp %sp 288 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -288 #2057
	lw %ra %sp 284 #2057
	lw %a1 %sp 276 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 284 #2058 call dir
	addi %sp %sp 288 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -288 #2058
	lw %ra %sp 284 #2058
	lw %a1 %sp 276 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 284 #2059 call dir
	addi %sp %sp 288 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -288 #2059
	lw %ra %sp 284 #2059
	lw %a1 %sp 276 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %ra %sp 284 #2054 call dir
	addi %sp %sp 288 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -288 #2054
	lw %ra %sp 284 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 284 #2055 call dir
	addi %sp %sp 288 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -288 #2055
	lw %ra %sp 284 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 280 #2056
	add %a0 %a1 %zero
	sw %ra %sp 284 #2056 call dir
	addi %sp %sp 288 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -288 #2056
	lw %ra %sp 284 #2056
	lw %a1 %sp 280 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 284 #2057 call dir
	addi %sp %sp 288 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -288 #2057
	lw %ra %sp 284 #2057
	lw %a1 %sp 280 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 284 #2058 call dir
	addi %sp %sp 288 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -288 #2058
	lw %ra %sp 284 #2058
	lw %a1 %sp 280 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 284 #2059 call dir
	addi %sp %sp 288 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -288 #2059
	lw %ra %sp 284 #2059
	lw %a1 %sp 280 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %zero 1 #2072
	addi %a2 %zero 0 #2072
	add %a1 %a2 %zero
	sw %ra %sp 284 #2072 call dir
	addi %sp %sp 288 #2072	
	jal %ra min_caml_create_array #2072
	addi %sp %sp -288 #2072
	lw %ra %sp 284 #2072
	addi %a1 %zero 3 #2054
	li %f0 l.27725 #2054
	sw %a0 %sp 284 #2054
	add %a0 %a1 %zero
	sw %ra %sp 292 #2054 call dir
	addi %sp %sp 296 #2054	
	jal %ra min_caml_create_float_array #2054
	addi %sp %sp -296 #2054
	lw %ra %sp 292 #2054
	add %a1 %a0 %zero #2054
	addi %a0 %zero 5 #2055
	sw %ra %sp 292 #2055 call dir
	addi %sp %sp 296 #2055	
	jal %ra min_caml_create_array #2055
	addi %sp %sp -296 #2055
	lw %ra %sp 292 #2055
	addi %a1 %zero 3 #2056
	li %f0 l.27725 #2056
	sw %a0 %sp 288 #2056
	add %a0 %a1 %zero
	sw %ra %sp 292 #2056 call dir
	addi %sp %sp 296 #2056	
	jal %ra min_caml_create_float_array #2056
	addi %sp %sp -296 #2056
	lw %ra %sp 292 #2056
	lw %a1 %sp 288 #2056
	sw %a0 %a1 4 #2056
	addi %a0 %zero 3 #2057
	li %f0 l.27725 #2057
	sw %ra %sp 292 #2057 call dir
	addi %sp %sp 296 #2057	
	jal %ra min_caml_create_float_array #2057
	addi %sp %sp -296 #2057
	lw %ra %sp 292 #2057
	lw %a1 %sp 288 #2057
	sw %a0 %a1 8 #2057
	addi %a0 %zero 3 #2058
	li %f0 l.27725 #2058
	sw %ra %sp 292 #2058 call dir
	addi %sp %sp 296 #2058	
	jal %ra min_caml_create_float_array #2058
	addi %sp %sp -296 #2058
	lw %ra %sp 292 #2058
	lw %a1 %sp 288 #2058
	sw %a0 %a1 12 #2058
	addi %a0 %zero 3 #2059
	li %f0 l.27725 #2059
	sw %ra %sp 292 #2059 call dir
	addi %sp %sp 296 #2059	
	jal %ra min_caml_create_float_array #2059
	addi %sp %sp -296 #2059
	lw %ra %sp 292 #2059
	lw %a1 %sp 288 #2059
	sw %a0 %a1 16 #2059
	addi %a0 %min_caml_hp 0 #2074
	addi %min_caml_hp %min_caml_hp 32 #2074
	sw %a1 %a0 28 #2074
	lw %a1 %sp 284 #2074
	sw %a1 %a0 24 #2074
	lw %a1 %sp 280 #2074
	sw %a1 %a0 20 #2074
	lw %a1 %sp 276 #2074
	sw %a1 %a0 16 #2074
	lw %a1 %sp 272 #2074
	sw %a1 %a0 12 #2074
	lw %a1 %sp 268 #2074
	sw %a1 %a0 8 #2074
	lw %a1 %sp 264 #2074
	sw %a1 %a0 4 #2074
	lw %a1 %sp 260 #2074
	sw %a1 %a0 0 #2074
	lw %a1 %sp 256 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 252 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a0 %a1 -1 #2081
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36884 # nontail if
	sw %a0 %sp 292 #2080
	sw %ra %sp 300 #2080 call dir
	addi %sp %sp 304 #2080	
	jal %ra create_pixel.2658 #2080
	addi %sp %sp -304 #2080
	lw %ra %sp 300 #2080
	lw %a1 %sp 292 #2080
	slli %a2 %a1 2 #2080
	lw %a3 %sp 252 #2080
	add %a12 %a3 %a2 #2080
	sw %a0 %a12 0 #2080
	addi %a1 %a1 -1 #2081
	add %a0 %a3 %zero
	sw %ra %sp 300 #2081 call dir
	addi %sp %sp 304 #2081	
	jal %ra init_line_elements.2660 #2081
	addi %sp %sp -304 #2081
	lw %ra %sp 300 #2081
	jal %zero bge_cont.36885 # then sentence ends
bge_else.36884:
	addi %a0 %a3 0 #2083
bge_cont.36885:
	jal %zero bge_cont.36883 # then sentence ends
bge_else.36882:
bge_cont.36883:
	lw %a11 %sp 108 #768
	sw %a0 %sp 296 #768
	sw %ra %sp 300 #768 call cls
	lw %a10 %a11 0 #768
	addi %sp %sp 304 #768	
	jalr %ra %a10 0 #768
	addi %sp %sp -304 #768
	lw %ra %sp 300 #768
	sw %ra %sp 300 #580 call dir
	addi %sp %sp 304 #580	
	jal %ra min_caml_read_int #580
	addi %sp %sp -304 #580
	lw %ra %sp 300 #580
	sw %ra %sp 300 #583 call dir
	addi %sp %sp 304 #583	
	jal %ra min_caml_read_float #583
	addi %sp %sp -304 #583
	lw %ra %sp 300 #583
	li %f1 l.27713 #541
	fmul %f0 %f0 %f1 #541
	sw %f0 %sp 304 #584
	sw %ra %sp 316 #584 call dir
	addi %sp %sp 320 #584	
	jal %ra min_caml_sin #584
	addi %sp %sp -320 #584
	lw %ra %sp 316 #584
	sw %ra %sp 316 #585 call dir
	addi %sp %sp 320 #585	
	jal %ra min_caml_fneg #585
	addi %sp %sp -320 #585
	lw %ra %sp 316 #585
	lw %a0 %sp 104 #585
	sw %f0 %a0 4 #585
	sw %ra %sp 316 #586 call dir
	addi %sp %sp 320 #586	
	jal %ra min_caml_read_float #586
	addi %sp %sp -320 #586
	lw %ra %sp 316 #586
	li %f1 l.27713 #541
	fmul %f0 %f0 %f1 #541
	lw %f1 %sp 304 #587
	sw %f0 %sp 312 #587
	fadd %f0 %f1 %fzero
	sw %ra %sp 324 #587 call dir
	addi %sp %sp 328 #587	
	jal %ra min_caml_cos #587
	addi %sp %sp -328 #587
	lw %ra %sp 324 #587
	lw %f1 %sp 312 #588
	sw %f0 %sp 320 #588
	fadd %f0 %f1 %fzero
	sw %ra %sp 332 #588 call dir
	addi %sp %sp 336 #588	
	jal %ra min_caml_sin #588
	addi %sp %sp -336 #588
	lw %ra %sp 332 #588
	lw %f1 %sp 320 #589
	fmul %f0 %f1 %f0 #589
	lw %a0 %sp 104 #589
	sw %f0 %a0 0 #589
	lw %f0 %sp 312 #590
	sw %ra %sp 332 #590 call dir
	addi %sp %sp 336 #590	
	jal %ra min_caml_cos #590
	addi %sp %sp -336 #590
	lw %ra %sp 332 #590
	lw %f1 %sp 320 #591
	fmul %f0 %f1 %f0 #591
	lw %a0 %sp 104 #591
	sw %f0 %a0 8 #591
	sw %ra %sp 332 #592 call dir
	addi %sp %sp 336 #592	
	jal %ra min_caml_read_float #592
	addi %sp %sp -336 #592
	lw %ra %sp 332 #592
	lw %a0 %sp 100 #592
	sw %f0 %a0 0 #592
	addi %a0 %zero 0 #734
	lw %a11 %sp 96 #726
	sw %a0 %sp 328 #726
	sw %ra %sp 332 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 336 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -336 #726
	lw %ra %sp 332 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36887 # nontail if
	lw %a0 %sp 92 #729
	lw %a1 %sp 328 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.36888 # then sentence ends
beq_else.36887:
	addi %a0 %zero 1 #727
	lw %a11 %sp 96 #726
	sw %a0 %sp 332 #726
	sw %ra %sp 340 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 344 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -344 #726
	lw %ra %sp 340 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36889 # nontail if
	lw %a0 %sp 92 #729
	lw %a1 %sp 332 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.36890 # then sentence ends
beq_else.36889:
	addi %a0 %zero 2 #727
	lw %a11 %sp 96 #726
	sw %a0 %sp 336 #726
	sw %ra %sp 340 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 344 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -344 #726
	lw %ra %sp 340 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36891 # nontail if
	lw %a0 %sp 92 #729
	lw %a1 %sp 336 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.36892 # then sentence ends
beq_else.36891:
	addi %a0 %zero 3 #727
	lw %a11 %sp 96 #726
	sw %a0 %sp 340 #726
	sw %ra %sp 348 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 352 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -352 #726
	lw %ra %sp 348 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36893 # nontail if
	lw %a0 %sp 92 #729
	lw %a1 %sp 340 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.36894 # then sentence ends
beq_else.36893:
	addi %a0 %zero 4 #727
	lw %a11 %sp 96 #726
	sw %a0 %sp 344 #726
	sw %ra %sp 348 #726 call cls
	lw %a10 %a11 0 #726
	addi %sp %sp 352 #726	
	jalr %ra %a10 0 #726
	addi %sp %sp -352 #726
	lw %ra %sp 348 #726
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36895 # nontail if
	lw %a0 %sp 92 #729
	lw %a1 %sp 344 #729
	sw %a1 %a0 0 #729
	jal %zero beq_cont.36896 # then sentence ends
beq_else.36895:
	addi %a0 %zero 5 #727
	lw %a11 %sp 88 #727
	sw %ra %sp 348 #727 call cls
	lw %a10 %a11 0 #727
	addi %sp %sp 352 #727	
	jalr %ra %a10 0 #727
	addi %sp %sp -352 #727
	lw %ra %sp 348 #727
beq_cont.36896:
beq_cont.36894:
beq_cont.36892:
beq_cont.36890:
beq_cont.36888:
	sw %ra %sp 348 #741 call dir
	addi %sp %sp 352 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -352 #741
	lw %ra %sp 348 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.36897 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 348 #742 call dir
	addi %sp %sp 352 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -352 #742
	lw %ra %sp 348 #742
	jal %zero beq_cont.36898 # then sentence ends
beq_else.36897:
	addi %a1 %zero 1 #744
	sw %a0 %sp 348 #744
	add %a0 %a1 %zero
	sw %ra %sp 356 #744 call dir
	addi %sp %sp 360 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -360 #744
	lw %ra %sp 356 #744
	lw %a1 %sp 348 #745
	sw %a1 %a0 0 #745
beq_cont.36898:
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36899 # nontail if
	jal %zero beq_cont.36900 # then sentence ends
beq_else.36899:
	lw %a1 %sp 84 #761
	sw %a0 %a1 0 #761
	addi %a0 %zero 0 #758
	sw %ra %sp 356 #758 call dir
	addi %sp %sp 360 #758	
	jal %ra read_net_item.2375 #758
	addi %sp %sp -360 #758
	lw %ra %sp 356 #758
	lw %a1 %a0 0 #745
	addi %a12 %zero -1
	bne %a1 %a12 beq_else.36901 # nontail if
	jal %zero beq_cont.36902 # then sentence ends
beq_else.36901:
	lw %a1 %sp 84 #761
	sw %a0 %a1 4 #761
	addi %a0 %zero 2 #762
	lw %a11 %sp 60 #762
	sw %ra %sp 356 #762 call cls
	lw %a10 %a11 0 #762
	addi %sp %sp 360 #762	
	jalr %ra %a10 0 #762
	addi %sp %sp -360 #762
	lw %ra %sp 356 #762
beq_cont.36902:
beq_cont.36900:
	sw %ra %sp 356 #741 call dir
	addi %sp %sp 360 #741	
	jal %ra min_caml_read_int #741
	addi %sp %sp -360 #741
	lw %ra %sp 356 #741
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.36903 # nontail if
	addi %a0 %zero 1 #742
	addi %a1 %zero -1 #742
	sw %ra %sp 356 #742 call dir
	addi %sp %sp 360 #742	
	jal %ra min_caml_create_array #742
	addi %sp %sp -360 #742
	lw %ra %sp 356 #742
	add %a1 %a0 %zero #742
	jal %zero beq_cont.36904 # then sentence ends
beq_else.36903:
	addi %a1 %zero 1 #744
	sw %a0 %sp 352 #744
	add %a0 %a1 %zero
	sw %ra %sp 356 #744 call dir
	addi %sp %sp 360 #744	
	jal %ra read_net_item.2375 #744
	addi %sp %sp -360 #744
	lw %ra %sp 356 #744
	lw %a1 %sp 352 #745
	sw %a1 %a0 0 #745
	addi %a1 %a0 0 #745
beq_cont.36904:
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.36905 # nontail if
	addi %a0 %zero 1 #751
	sw %ra %sp 356 #751 call dir
	addi %sp %sp 360 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -360 #751
	lw %ra %sp 356 #751
	jal %zero beq_cont.36906 # then sentence ends
beq_else.36905:
	addi %a0 %zero 0 #749
	sw %a1 %sp 356 #749
	sw %ra %sp 364 #749 call dir
	addi %sp %sp 368 #749	
	jal %ra read_net_item.2375 #749
	addi %sp %sp -368 #749
	lw %ra %sp 364 #749
	add %a1 %a0 %zero #749
	lw %a0 %a1 0 #745
	addi %a12 %zero -1
	bne %a0 %a12 beq_else.36907 # nontail if
	addi %a0 %zero 2 #751
	sw %ra %sp 364 #751 call dir
	addi %sp %sp 368 #751	
	jal %ra min_caml_create_array #751
	addi %sp %sp -368 #751
	lw %ra %sp 364 #751
	jal %zero beq_cont.36908 # then sentence ends
beq_else.36907:
	addi %a0 %zero 2 #753
	sw %a1 %sp 360 #753
	sw %ra %sp 364 #753 call dir
	addi %sp %sp 368 #753	
	jal %ra read_or_network.2377 #753
	addi %sp %sp -368 #753
	lw %ra %sp 364 #753
	lw %a1 %sp 360 #754
	sw %a1 %a0 4 #754
beq_cont.36908:
	lw %a1 %sp 356 #754
	sw %a1 %a0 0 #754
beq_cont.36906:
	lw %a1 %sp 56 #772
	sw %a0 %a1 0 #772
	addi %a0 %zero 80 #1917
	sw %ra %sp 364 #1917 call dir
	addi %sp %sp 368 #1917	
	jal %ra min_caml_print_char #1917
	addi %sp %sp -368 #1917
	lw %ra %sp 364 #1917
	addi %a0 %zero 51 #1918
	sw %ra %sp 364 #1918 call dir
	addi %sp %sp 368 #1918	
	jal %ra min_caml_print_char #1918
	addi %sp %sp -368 #1918
	lw %ra %sp 364 #1918
	addi %a0 %zero 10 #1919
	sw %ra %sp 364 #1919 call dir
	addi %sp %sp 368 #1919	
	jal %ra min_caml_print_char #1919
	addi %sp %sp -368 #1919
	lw %ra %sp 364 #1919
	lw %a0 %sp 112 #57
	lw %a1 %a0 0 #57
	add %a0 %a1 %zero
	sw %ra %sp 364 #1920 call dir
	addi %sp %sp 368 #1920	
	jal %ra min_caml_print_int #1920
	addi %sp %sp -368 #1920
	lw %ra %sp 364 #1920
	addi %a0 %zero 32 #1921
	sw %ra %sp 364 #1921 call dir
	addi %sp %sp 368 #1921	
	jal %ra min_caml_print_char #1921
	addi %sp %sp -368 #1921
	lw %ra %sp 364 #1921
	lw %a0 %sp 112 #57
	lw %a1 %a0 4 #57
	add %a0 %a1 %zero
	sw %ra %sp 364 #1922 call dir
	addi %sp %sp 368 #1922	
	jal %ra min_caml_print_int #1922
	addi %sp %sp -368 #1922
	lw %ra %sp 364 #1922
	addi %a0 %zero 32 #1923
	sw %ra %sp 364 #1923 call dir
	addi %sp %sp 368 #1923	
	jal %ra min_caml_print_char #1923
	addi %sp %sp -368 #1923
	lw %ra %sp 364 #1923
	addi %a0 %zero 255 #1924
	sw %ra %sp 364 #1924 call dir
	addi %sp %sp 368 #1924	
	jal %ra min_caml_print_int #1924
	addi %sp %sp -368 #1924
	lw %ra %sp 364 #1924
	addi %a0 %zero 10 #1925
	sw %ra %sp 364 #1925 call dir
	addi %sp %sp 368 #1925	
	jal %ra min_caml_print_char #1925
	addi %sp %sp -368 #1925
	lw %ra %sp 364 #1925
	addi %a0 %zero 120 #2171
	addi %a1 %zero 3 #2157
	li %f0 l.27725 #2157
	sw %a0 %sp 364 #2157
	add %a0 %a1 %zero
	sw %ra %sp 372 #2157 call dir
	addi %sp %sp 376 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -376 #2157
	lw %ra %sp 372 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 92 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 368 #2158
	add %a0 %a2 %zero
	sw %ra %sp 372 #2158 call dir
	addi %sp %sp 376 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -376 #2158
	lw %ra %sp 372 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 368 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 364 #2171
	sw %ra %sp 372 #2171 call dir
	addi %sp %sp 376 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -376 #2171
	lw %ra %sp 372 #2171
	lw %a1 %sp 64 #2171
	sw %a0 %a1 16 #2171
	lw %a0 %a1 16 #81
	addi %a2 %zero 3 #2157
	li %f0 l.27725 #2157
	sw %a0 %sp 372 #2157
	add %a0 %a2 %zero
	sw %ra %sp 380 #2157 call dir
	addi %sp %sp 384 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -384 #2157
	lw %ra %sp 380 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 92 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 376 #2158
	add %a0 %a2 %zero
	sw %ra %sp 380 #2158 call dir
	addi %sp %sp 384 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -384 #2158
	lw %ra %sp 380 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 376 #2159
	sw %a0 %a1 0 #2159
	addi %a0 %a1 0 #2159
	lw %a1 %sp 372 #2164
	sw %a0 %a1 472 #2164
	addi %a0 %zero 117 #2165
	lw %a11 %sp 72 #2165
	add %a10 %a1 %zero
	add %a1 %a0 %zero
	add %a0 %a10 %zero
	sw %ra %sp 380 #2165 call cls
	lw %a10 %a11 0 #2165
	addi %sp %sp 384 #2165	
	jalr %ra %a10 0 #2165
	addi %sp %sp -384 #2165
	lw %ra %sp 380 #2165
	addi %a0 %zero 120 #2171
	addi %a1 %zero 3 #2157
	li %f0 l.27725 #2157
	sw %a0 %sp 380 #2157
	add %a0 %a1 %zero
	sw %ra %sp 388 #2157 call dir
	addi %sp %sp 392 #2157	
	jal %ra min_caml_create_float_array #2157
	addi %sp %sp -392 #2157
	lw %ra %sp 388 #2157
	add %a1 %a0 %zero #2157
	lw %a0 %sp 92 #15
	lw %a2 %a0 0 #15
	sw %a1 %sp 384 #2158
	add %a0 %a2 %zero
	sw %ra %sp 388 #2158 call dir
	addi %sp %sp 392 #2158	
	jal %ra min_caml_create_array #2158
	addi %sp %sp -392 #2158
	lw %ra %sp 388 #2158
	addi %a1 %min_caml_hp 0 #2159
	addi %min_caml_hp %min_caml_hp 8 #2159
	sw %a0 %a1 4 #2159
	lw %a0 %sp 384 #2159
	sw %a0 %a1 0 #2159
	lw %a0 %sp 380 #2171
	sw %ra %sp 388 #2171 call dir
	addi %sp %sp 392 #2171	
	jal %ra min_caml_create_array #2171
	addi %sp %sp -392 #2171
	lw %ra %sp 388 #2171
	lw %a1 %sp 64 #2171
	sw %a0 %a1 12 #2171
	lw %a0 %a1 12 #81
	addi %a2 %zero 118 #2172
	lw %a11 %sp 72 #2172
	add %a1 %a2 %zero
	sw %ra %sp 388 #2172 call cls
	lw %a10 %a11 0 #2172
	addi %sp %sp 392 #2172	
	jalr %ra %a10 0 #2172
	addi %sp %sp -392 #2172
	lw %ra %sp 388 #2172
	addi %a0 %zero 2 #2173
	lw %a11 %sp 68 #2173
	sw %ra %sp 388 #2173 call cls
	lw %a10 %a11 0 #2173
	addi %sp %sp 392 #2173	
	jalr %ra %a10 0 #2173
	addi %sp %sp -392 #2173
	lw %ra %sp 388 #2173
	addi %a0 %zero 9 #2195
	addi %a1 %zero 0 #2195
	addi %a2 %zero 0 #2195
	lw %a11 %sp 80 #2195
	sw %ra %sp 388 #2195 call cls
	lw %a10 %a11 0 #2195
	addi %sp %sp 392 #2195	
	jalr %ra %a10 0 #2195
	addi %sp %sp -392 #2195
	lw %ra %sp 388 #2195
	lw %a0 %sp 64 #81
	lw %a1 %a0 16 #81
	lw %a2 %a1 476 #2181
	lw %a11 %sp 40 #2181
	sw %a1 %sp 388 #2181
	add %a0 %a2 %zero
	sw %ra %sp 396 #2181 call cls
	lw %a10 %a11 0 #2181
	addi %sp %sp 400 #2181	
	jalr %ra %a10 0 #2181
	addi %sp %sp -400 #2181
	lw %ra %sp 396 #2181
	addi %a1 %zero 118 #2182
	lw %a0 %sp 388 #2182
	lw %a11 %sp 52 #2182
	sw %ra %sp 396 #2182 call cls
	lw %a10 %a11 0 #2182
	addi %sp %sp 400 #2182	
	jalr %ra %a10 0 #2182
	addi %sp %sp -400 #2182
	lw %ra %sp 396 #2182
	lw %a0 %sp 64 #81
	lw %a0 %a0 12 #81
	addi %a1 %zero 119 #2188
	lw %a11 %sp 52 #2188
	sw %ra %sp 396 #2188 call cls
	lw %a10 %a11 0 #2188
	addi %sp %sp 400 #2188	
	jalr %ra %a10 0 #2188
	addi %sp %sp -400 #2188
	lw %ra %sp 396 #2188
	addi %a0 %zero 2 #2189
	lw %a11 %sp 48 #2189
	sw %ra %sp 396 #2189 call cls
	lw %a10 %a11 0 #2189
	addi %sp %sp 400 #2189	
	jalr %ra %a10 0 #2189
	addi %sp %sp -400 #2189
	lw %ra %sp 396 #2189
	lw %a0 %sp 104 #152
	lw %f0 %a0 0 #152
	lw %a1 %sp 32 #152
	sw %f0 %a1 0 #152
	lw %f0 %a0 4 #152
	sw %f0 %a1 4 #153
	lw %f0 %a0 8 #152
	sw %f0 %a1 8 #154
	lw %a0 %sp 92 #15
	lw %a2 %a0 0 #15
	addi %a2 %a2 -1 #1121
	addi %a12 %zero 0
	blt %a2 %a12 bge_else.36909 # nontail if
	slli %a3 %a2 2 #20
	lw %a4 %sp 28 #20
	add %a12 %a4 %a3 #20
	lw %a3 %a12 0 #20
	lw %a5 %a3 4 #238
	addi %a12 %zero 1
	bne %a5 %a12 beq_else.36911 # nontail if
	sw %a2 %sp 392 #1110
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 396 #1110 call dir
	addi %sp %sp 400 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -400 #1110
	lw %ra %sp 396 #1110
	lw %a1 %sp 392 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 76 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36912 # then sentence ends
beq_else.36911:
	addi %a12 %zero 2
	bne %a5 %a12 beq_else.36913 # nontail if
	sw %a2 %sp 392 #1112
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 396 #1112 call dir
	addi %sp %sp 400 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -400 #1112
	lw %ra %sp 396 #1112
	lw %a1 %sp 392 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 76 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36914 # then sentence ends
beq_else.36913:
	sw %a2 %sp 392 #1114
	add %a0 %a1 %zero
	add %a1 %a3 %zero
	sw %ra %sp 396 #1114 call dir
	addi %sp %sp 400 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -400 #1114
	lw %ra %sp 396 #1114
	lw %a1 %sp 392 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 76 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36914:
beq_cont.36912:
	addi %a0 %a1 -1 #1116
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36915 # nontail if
	slli %a1 %a0 2 #20
	lw %a2 %sp 28 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a4 %a1 4 #238
	addi %a12 %zero 1
	bne %a4 %a12 beq_else.36917 # nontail if
	lw %a4 %sp 32 #1110
	sw %a0 %sp 396 #1110
	add %a0 %a4 %zero
	sw %ra %sp 404 #1110 call dir
	addi %sp %sp 408 #1110	
	jal %ra setup_rect_table.2467 #1110
	addi %sp %sp -408 #1110
	lw %ra %sp 404 #1110
	lw %a1 %sp 396 #1110
	slli %a2 %a1 2 #1110
	lw %a3 %sp 76 #1110
	add %a12 %a3 %a2 #1110
	sw %a0 %a12 0 #1110
	jal %zero beq_cont.36918 # then sentence ends
beq_else.36917:
	addi %a12 %zero 2
	bne %a4 %a12 beq_else.36919 # nontail if
	lw %a4 %sp 32 #1112
	sw %a0 %sp 396 #1112
	add %a0 %a4 %zero
	sw %ra %sp 404 #1112 call dir
	addi %sp %sp 408 #1112	
	jal %ra setup_surface_table.2470 #1112
	addi %sp %sp -408 #1112
	lw %ra %sp 404 #1112
	lw %a1 %sp 396 #1112
	slli %a2 %a1 2 #1112
	lw %a3 %sp 76 #1112
	add %a12 %a3 %a2 #1112
	sw %a0 %a12 0 #1112
	jal %zero beq_cont.36920 # then sentence ends
beq_else.36919:
	lw %a4 %sp 32 #1114
	sw %a0 %sp 396 #1114
	add %a0 %a4 %zero
	sw %ra %sp 404 #1114 call dir
	addi %sp %sp 408 #1114	
	jal %ra setup_second_table.2473 #1114
	addi %sp %sp -408 #1114
	lw %ra %sp 404 #1114
	lw %a1 %sp 396 #1114
	slli %a2 %a1 2 #1114
	lw %a3 %sp 76 #1114
	add %a12 %a3 %a2 #1114
	sw %a0 %a12 0 #1114
beq_cont.36920:
beq_cont.36918:
	addi %a1 %a1 -1 #1116
	lw %a0 %sp 36 #1116
	lw %a11 %sp 44 #1116
	sw %ra %sp 404 #1116 call cls
	lw %a10 %a11 0 #1116
	addi %sp %sp 408 #1116	
	jalr %ra %a10 0 #1116
	addi %sp %sp -408 #1116
	lw %ra %sp 404 #1116
	jal %zero bge_cont.36916 # then sentence ends
bge_else.36915:
bge_cont.36916:
	jal %zero bge_cont.36910 # then sentence ends
bge_else.36909:
bge_cont.36910:
	lw %a0 %sp 92 #15
	lw %a0 %a0 0 #15
	addi %a0 %a0 -1 #2275
	addi %a12 %zero 0
	blt %a0 %a12 bge_else.36921 # nontail if
	slli %a1 %a0 2 #20
	lw %a2 %sp 28 #20
	add %a12 %a2 %a1 #20
	lw %a1 %a12 0 #20
	lw %a2 %a1 8 #248
	addi %a12 %zero 2
	bne %a2 %a12 beq_else.36923 # nontail if
	lw %a2 %a1 28 #346
	lw %f0 %a2 0 #351
	li %f1 l.27799 #2244
	sw %a0 %sp 400 #2244
	sw %a1 %sp 404 #2244
	sw %ra %sp 412 #2244 call dir
	addi %sp %sp 416 #2244	
	jal %ra min_caml_fless #2244
	addi %sp %sp -416 #2244
	lw %ra %sp 412 #2244
	addi %a12 %zero 0
	bne %a0 %a12 beq_else.36925 # nontail if
	jal %zero beq_cont.36926 # then sentence ends
beq_else.36925:
	lw %a1 %sp 404 #238
	lw %a0 %a1 4 #238
	addi %a12 %zero 1
	bne %a0 %a12 beq_else.36927 # nontail if
	lw %a0 %sp 400 #2248
	lw %a11 %sp 24 #2248
	sw %ra %sp 412 #2248 call cls
	lw %a10 %a11 0 #2248
	addi %sp %sp 416 #2248	
	jalr %ra %a10 0 #2248
	addi %sp %sp -416 #2248
	lw %ra %sp 412 #2248
	jal %zero beq_cont.36928 # then sentence ends
beq_else.36927:
	addi %a12 %zero 2
	bne %a0 %a12 beq_else.36929 # nontail if
	lw %a0 %sp 400 #2250
	lw %a11 %sp 16 #2250
	sw %ra %sp 412 #2250 call cls
	lw %a10 %a11 0 #2250
	addi %sp %sp 416 #2250	
	jalr %ra %a10 0 #2250
	addi %sp %sp -416 #2250
	lw %ra %sp 412 #2250
	jal %zero beq_cont.36930 # then sentence ends
beq_else.36929:
beq_cont.36930:
beq_cont.36928:
beq_cont.36926:
	jal %zero beq_cont.36924 # then sentence ends
beq_else.36923:
beq_cont.36924:
	jal %zero bge_cont.36922 # then sentence ends
bge_else.36921:
bge_cont.36922:
	addi %a0 %zero 0 #2276
	addi %a1 %zero 0 #2276
	lw %a2 %sp 116 #61
	lw %f0 %a2 0 #61
	lw %a3 %sp 128 #59
	lw %a4 %a3 4 #59
	sub %a0 %a0 %a4 #2004
	sw %a1 %sp 408 #2004
	sw %f0 %sp 416 #2004
	sw %ra %sp 428 #2004 call dir
	addi %sp %sp 432 #2004	
	jal %ra min_caml_float_of_int #2004
	addi %sp %sp -432 #2004
	lw %ra %sp 428 #2004
	lw %f1 %sp 416 #2004
	fmul %f0 %f1 %f0 #2004
	lw %a0 %sp 12 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 8 #71
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
	lw %a2 %sp 112 #57
	lw %a3 %a2 0 #57
	addi %a3 %a3 -1 #2010
	lw %a4 %sp 244 #2010
	lw %a5 %sp 408 #2010
	lw %a11 %sp 20 #2010
	add %a2 %a5 %zero
	add %a1 %a3 %zero
	add %a0 %a4 %zero
	fadd %f11 %f2 %fzero
	fadd %f2 %f0 %fzero
	fadd %f0 %f1 %fzero
	fadd %f1 %f11 %fzero
	sw %ra %sp 428 #2010 call cls
	lw %a10 %a11 0 #2010
	addi %sp %sp 432 #2010	
	jalr %ra %a10 0 #2010
	addi %sp %sp -432 #2010
	lw %ra %sp 428 #2010
	addi %a1 %zero 0 #2277
	addi %a0 %zero 2 #2277
	lw %a2 %sp 112 #57
	lw %a3 %a2 4 #57
	addi %a12 %zero 0
	blt %a12 %a3 bge_else.36932
	jalr %zero %ra 0 #2046
bge_else.36932:
	lw %a3 %a2 4 #57
	addi %a3 %a3 -1 #2041
	sw %a1 %sp 424 #2041
	addi %a12 %zero 0
	blt %a12 %a3 bge_else.36934 # nontail if
	jal %zero bge_cont.36935 # then sentence ends
bge_else.36934:
	addi %a3 %zero 1 #2042
	lw %a4 %sp 116 #61
	lw %f0 %a4 0 #61
	lw %a4 %sp 128 #59
	lw %a4 %a4 4 #59
	sub %a3 %a3 %a4 #2004
	sw %a0 %sp 428 #2004
	sw %f0 %sp 432 #2004
	add %a0 %a3 %zero
	sw %ra %sp 444 #2004 call dir
	addi %sp %sp 448 #2004	
	jal %ra min_caml_float_of_int #2004
	addi %sp %sp -448 #2004
	lw %ra %sp 444 #2004
	lw %f1 %sp 432 #2004
	fmul %f0 %f1 %f0 #2004
	lw %a0 %sp 12 #70
	lw %f1 %a0 0 #70
	fmul %f1 %f0 %f1 #2007
	lw %a1 %sp 8 #71
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
	lw %a0 %sp 112 #57
	lw %a0 %a0 0 #57
	addi %a1 %a0 -1 #2010
	lw %a0 %sp 296 #2010
	lw %a2 %sp 428 #2010
	lw %a11 %sp 20 #2010
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
bge_cont.36935:
	addi %a0 %zero 0 #2044
	lw %a1 %sp 424 #2044
	lw %a2 %sp 192 #2044
	lw %a3 %sp 244 #2044
	lw %a4 %sp 296 #2044
	lw %a11 %sp 4 #2044
	sw %ra %sp 444 #2044 call cls
	lw %a10 %a11 0 #2044
	addi %sp %sp 448 #2044	
	jalr %ra %a10 0 #2044
	addi %sp %sp -448 #2044
	lw %ra %sp 444 #2044
	addi %a0 %zero 1 #2045
	addi %a4 %zero 4 #124
	lw %a1 %sp 244 #2045
	lw %a2 %sp 296 #2045
	lw %a3 %sp 192 #2045
	lw %a11 %sp 0 #2045
	lw %a10 %a11 0 #2045
	jalr %zero %a10 0 #2045
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
	li %f0 l.27725 #19
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
	li %f0 l.27725 #23
	sw %a0 %sp 4 #23
	add %a0 %a1 %zero
	sw %ra %sp 12 #23 call dir
	addi %sp %sp 16 #23	
	jal %ra min_caml_create_float_array #23
	addi %sp %sp -16 #23
	lw %ra %sp 12 #23
	addi %a1 %zero 3 #25
	li %f0 l.27725 #25
	sw %a0 %sp 8 #25
	add %a0 %a1 %zero
	sw %ra %sp 12 #25 call dir
	addi %sp %sp 16 #25	
	jal %ra min_caml_create_float_array #25
	addi %sp %sp -16 #25
	lw %ra %sp 12 #25
	addi %a1 %zero 3 #27
	li %f0 l.27725 #27
	sw %a0 %sp 12 #27
	add %a0 %a1 %zero
	sw %ra %sp 20 #27 call dir
	addi %sp %sp 24 #27	
	jal %ra min_caml_create_float_array #27
	addi %sp %sp -24 #27
	lw %ra %sp 20 #27
	addi %a1 %zero 1 #29
	li %f0 l.28706 #29
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
	li %f0 l.27725 #37
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
	li %f0 l.28749 #41
	sw %a0 %sp 44 #41
	add %a0 %a1 %zero
	sw %ra %sp 52 #41 call dir
	addi %sp %sp 56 #41	
	jal %ra min_caml_create_float_array #41
	addi %sp %sp -56 #41
	lw %ra %sp 52 #41
	addi %a1 %zero 3 #43
	li %f0 l.27725 #43
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
	li %f0 l.27725 #47
	sw %a0 %sp 56 #47
	add %a0 %a1 %zero
	sw %ra %sp 60 #47 call dir
	addi %sp %sp 64 #47	
	jal %ra min_caml_create_float_array #47
	addi %sp %sp -64 #47
	lw %ra %sp 60 #47
	addi %a1 %zero 3 #49
	li %f0 l.27725 #49
	sw %a0 %sp 60 #49
	add %a0 %a1 %zero
	sw %ra %sp 68 #49 call dir
	addi %sp %sp 72 #49	
	jal %ra min_caml_create_float_array #49
	addi %sp %sp -72 #49
	lw %ra %sp 68 #49
	addi %a1 %zero 3 #52
	li %f0 l.27725 #52
	sw %a0 %sp 64 #52
	add %a0 %a1 %zero
	sw %ra %sp 68 #52 call dir
	addi %sp %sp 72 #52	
	jal %ra min_caml_create_float_array #52
	addi %sp %sp -72 #52
	lw %ra %sp 68 #52
	addi %a1 %zero 3 #54
	li %f0 l.27725 #54
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
	li %f0 l.27725 #61
	sw %a0 %sp 80 #61
	add %a0 %a1 %zero
	sw %ra %sp 84 #61 call dir
	addi %sp %sp 88 #61	
	jal %ra min_caml_create_float_array #61
	addi %sp %sp -88 #61
	lw %ra %sp 84 #61
	addi %a1 %zero 3 #64
	li %f0 l.27725 #64
	sw %a0 %sp 84 #64
	add %a0 %a1 %zero
	sw %ra %sp 92 #64 call dir
	addi %sp %sp 96 #64	
	jal %ra min_caml_create_float_array #64
	addi %sp %sp -96 #64
	lw %ra %sp 92 #64
	addi %a1 %zero 3 #66
	li %f0 l.27725 #66
	sw %a0 %sp 88 #66
	add %a0 %a1 %zero
	sw %ra %sp 92 #66 call dir
	addi %sp %sp 96 #66	
	jal %ra min_caml_create_float_array #66
	addi %sp %sp -96 #66
	lw %ra %sp 92 #66
	addi %a1 %zero 3 #69
	li %f0 l.27725 #69
	sw %a0 %sp 92 #69
	add %a0 %a1 %zero
	sw %ra %sp 100 #69 call dir
	addi %sp %sp 104 #69	
	jal %ra min_caml_create_float_array #69
	addi %sp %sp -104 #69
	lw %ra %sp 100 #69
	addi %a1 %zero 3 #70
	li %f0 l.27725 #70
	sw %a0 %sp 96 #70
	add %a0 %a1 %zero
	sw %ra %sp 100 #70 call dir
	addi %sp %sp 104 #70	
	jal %ra min_caml_create_float_array #70
	addi %sp %sp -104 #70
	lw %ra %sp 100 #70
	addi %a1 %zero 3 #71
	li %f0 l.27725 #71
	sw %a0 %sp 100 #71
	add %a0 %a1 %zero
	sw %ra %sp 108 #71 call dir
	addi %sp %sp 112 #71	
	jal %ra min_caml_create_float_array #71
	addi %sp %sp -112 #71
	lw %ra %sp 108 #71
	addi %a1 %zero 3 #74
	li %f0 l.27725 #74
	sw %a0 %sp 104 #74
	add %a0 %a1 %zero
	sw %ra %sp 108 #74 call dir
	addi %sp %sp 112 #74	
	jal %ra min_caml_create_float_array #74
	addi %sp %sp -112 #74
	lw %ra %sp 108 #74
	addi %a1 %zero 0 #78
	li %f0 l.27725 #78
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
	li %f0 l.27725 #85
	sw %a0 %sp 116 #85
	add %a0 %a1 %zero
	sw %ra %sp 124 #85 call dir
	addi %sp %sp 128 #85	
	jal %ra min_caml_create_float_array #85
	addi %sp %sp -128 #85
	lw %ra %sp 124 #85
	addi %a1 %zero 3 #86
	li %f0 l.27725 #86
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
	li %f0 l.27725 #92
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
	li %f0 l.27725 #95
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
	sw %a10 %sp 144 #797
	addi %a10 %min_caml_hp 0 #797
	addi %min_caml_hp %min_caml_hp 8 #797
	sw %a6 %sp 148 #797
	li %a6 solver_rect.2392 #797
	sw %a6 %a10 0 #797
	lw %a6 %sp 40 #797
	sw %a6 %a10 4 #797
	sw %a8 %sp 152 #854
	addi %a8 %min_caml_hp 0 #854
	addi %min_caml_hp %min_caml_hp 8 #854
	sw %a1 %sp 156 #854
	li %a1 solver_second.2417 #854
	sw %a1 %a8 0 #854
	sw %a6 %a8 4 #854
	addi %a1 %min_caml_hp 0 #883
	addi %min_caml_hp %min_caml_hp 16 #883
	li %a4 solver.2423 #883
	sw %a4 %a1 0 #883
	sw %a6 %a1 8 #883
	sw %a7 %a1 4 #883
	addi %a4 %min_caml_hp 0 #900
	addi %min_caml_hp %min_caml_hp 8 #900
	li %a3 solver_rect_fast.2427 #900
	sw %a3 %a4 0 #900
	sw %a6 %a4 4 #900
	addi %a3 %min_caml_hp 0 #942
	addi %min_caml_hp %min_caml_hp 8 #942
	li %a5 solver_second_fast.2440 #942
	sw %a5 %a3 0 #942
	sw %a6 %a3 4 #942
	addi %a5 %min_caml_hp 0 #962
	addi %min_caml_hp %min_caml_hp 24 #962
	li %a2 solver_fast.2446 #962
	sw %a2 %a5 0 #962
	sw %a3 %a5 16 #962
	sw %a4 %a5 12 #962
	sw %a6 %a5 8 #962
	sw %a7 %a5 4 #962
	addi %a2 %min_caml_hp 0 #1009
	addi %min_caml_hp %min_caml_hp 16 #1009
	sw %a0 %sp 160 #1009
	li %a0 solver_fast2.2464 #1009
	sw %a0 %a2 0 #1009
	sw %a4 %a2 12 #1009
	sw %a6 %a2 8 #1009
	sw %a7 %a2 4 #1009
	addi %a0 %min_caml_hp 0 #1103
	addi %min_caml_hp %min_caml_hp 8 #1103
	sw %a2 %sp 164 #1103
	li %a2 iter_setup_dirvec_constants.2476 #1103
	sw %a2 %a0 0 #1103
	sw %a7 %a0 4 #1103
	addi %a2 %min_caml_hp 0 #1120
	addi %min_caml_hp %min_caml_hp 16 #1120
	sw %a1 %sp 168 #1120
	li %a1 setup_dirvec_constants.2479 #1120
	sw %a1 %a2 0 #1120
	sw %a7 %a2 12 #1120
	sw %a9 %a2 8 #1120
	sw %a0 %a2 4 #1120
	addi %a1 %min_caml_hp 0 #1126
	addi %min_caml_hp %min_caml_hp 8 #1126
	sw %a0 %sp 172 #1126
	li %a0 setup_startp_constants.2481 #1126
	sw %a0 %a1 0 #1126
	sw %a7 %a1 4 #1126
	addi %a0 %min_caml_hp 0 #1193
	addi %min_caml_hp %min_caml_hp 8 #1193
	sw %a2 %sp 176 #1193
	li %a2 check_all_inside.2506 #1193
	sw %a2 %a0 0 #1193
	sw %a7 %a0 4 #1193
	addi %a2 %min_caml_hp 0 #1211
	addi %min_caml_hp %min_caml_hp 40 #1211
	li %a9 shadow_check_and_group.2512 #1211
	sw %a9 %a2 0 #1211
	lw %a9 %sp 124 #1211
	sw %a9 %a2 36 #1211
	sw %a3 %a2 32 #1211
	sw %a4 %a2 28 #1211
	sw %a6 %a2 24 #1211
	sw %a7 %a2 20 #1211
	sw %a1 %sp 180 #1211
	lw %a1 %sp 16 #1211
	sw %a1 %a2 16 #1211
	lw %a1 %sp 52 #1211
	sw %a1 %a2 12 #1211
	sw %a10 %sp 184 #1211
	lw %a10 %sp 132 #1211
	sw %a10 %a2 8 #1211
	sw %a0 %a2 4 #1211
	sw %a0 %sp 188 #1241
	addi %a0 %min_caml_hp 0 #1241
	addi %min_caml_hp %min_caml_hp 16 #1241
	sw %a8 %sp 192 #1241
	li %a8 shadow_check_one_or_group.2515 #1241
	sw %a8 %a0 0 #1241
	sw %a2 %a0 8 #1241
	sw %a11 %a0 4 #1241
	addi %a8 %min_caml_hp 0 #1256
	addi %min_caml_hp %min_caml_hp 56 #1256
	li %a11 shadow_check_one_or_matrix.2518 #1256
	sw %a11 %a8 0 #1256
	sw %a9 %a8 48 #1256
	sw %a3 %a8 44 #1256
	sw %a4 %a8 40 #1256
	sw %a5 %a8 36 #1256
	sw %a6 %a8 32 #1256
	sw %a0 %a8 28 #1256
	sw %a2 %a8 24 #1256
	sw %a7 %a8 20 #1256
	lw %a3 %sp 128 #1256
	sw %a3 %a8 16 #1256
	sw %a1 %a8 12 #1256
	sw %a10 %a8 8 #1256
	lw %a11 %sp 28 #1256
	sw %a11 %a8 4 #1256
	addi %a10 %min_caml_hp 0 #1290
	addi %min_caml_hp %min_caml_hp 48 #1290
	li %a9 solve_each_element.2521 #1290
	sw %a9 %a10 0 #1290
	lw %a9 %sp 48 #1290
	sw %a9 %a10 40 #1290
	lw %a3 %sp 88 #1290
	sw %a3 %a10 36 #1290
	sw %a2 %sp 196 #1290
	lw %a2 %sp 192 #1290
	sw %a2 %a10 32 #1290
	sw %a0 %sp 200 #1290
	lw %a0 %sp 184 #1290
	sw %a0 %a10 28 #1290
	sw %a6 %a10 24 #1290
	sw %a7 %a10 20 #1290
	sw %a8 %sp 204 #1290
	lw %a8 %sp 44 #1290
	sw %a8 %a10 16 #1290
	sw %a1 %a10 12 #1290
	sw %a5 %sp 208 #1290
	lw %a5 %sp 56 #1290
	sw %a5 %a10 8 #1290
	lw %a5 %sp 188 #1290
	sw %a5 %a10 4 #1290
	addi %a5 %min_caml_hp 0 #1331
	addi %min_caml_hp %min_caml_hp 16 #1331
	li %a1 solve_one_or_network.2525 #1331
	sw %a1 %a5 0 #1331
	sw %a10 %a5 8 #1331
	sw %a11 %a5 4 #1331
	addi %a1 %min_caml_hp 0 #1341
	addi %min_caml_hp %min_caml_hp 48 #1341
	li %a8 trace_or_matrix.2529 #1341
	sw %a8 %a1 0 #1341
	sw %a9 %a1 40 #1341
	sw %a3 %a1 36 #1341
	sw %a2 %a1 32 #1341
	sw %a0 %a1 28 #1341
	sw %a6 %a1 24 #1341
	lw %a0 %sp 168 #1341
	sw %a0 %a1 20 #1341
	sw %a5 %a1 16 #1341
	sw %a10 %a1 12 #1341
	sw %a7 %a1 8 #1341
	sw %a11 %a1 4 #1341
	addi %a0 %min_caml_hp 0 #1381
	addi %min_caml_hp %min_caml_hp 40 #1381
	li %a2 solve_each_element_fast.2535 #1381
	sw %a2 %a0 0 #1381
	sw %a9 %a0 36 #1381
	lw %a2 %sp 92 #1381
	sw %a2 %a0 32 #1381
	sw %a4 %a0 28 #1381
	sw %a6 %a0 24 #1381
	sw %a7 %a0 20 #1381
	lw %a5 %sp 44 #1381
	sw %a5 %a0 16 #1381
	lw %a8 %sp 52 #1381
	sw %a8 %a0 12 #1381
	lw %a10 %sp 56 #1381
	sw %a10 %a0 8 #1381
	lw %a3 %sp 188 #1381
	sw %a3 %a0 4 #1381
	addi %a3 %min_caml_hp 0 #1422
	addi %min_caml_hp %min_caml_hp 16 #1422
	li %a2 solve_one_or_network_fast.2539 #1422
	sw %a2 %a3 0 #1422
	sw %a0 %a3 8 #1422
	sw %a11 %a3 4 #1422
	addi %a2 %min_caml_hp 0 #1432
	addi %min_caml_hp %min_caml_hp 40 #1432
	sw %a1 %sp 212 #1432
	li %a1 trace_or_matrix_fast.2543 #1432
	sw %a1 %a2 0 #1432
	sw %a9 %a2 32 #1432
	sw %a4 %a2 28 #1432
	lw %a1 %sp 164 #1432
	sw %a1 %a2 24 #1432
	sw %a6 %a2 20 #1432
	sw %a3 %a2 16 #1432
	sw %a0 %a2 12 #1432
	sw %a7 %a2 8 #1432
	sw %a11 %a2 4 #1432
	addi %a4 %min_caml_hp 0 #1491
	addi %min_caml_hp %min_caml_hp 16 #1491
	li %a7 get_nvector_second.2553 #1491
	sw %a7 %a4 0 #1491
	lw %a7 %sp 60 #1491
	sw %a7 %a4 8 #1491
	sw %a8 %a4 4 #1491
	sw %a4 %sp 216 #1527
	addi %a4 %min_caml_hp 0 #1527
	addi %min_caml_hp %min_caml_hp 8 #1527
	li %a11 utexture.2558 #1527
	sw %a11 %a4 0 #1527
	lw %a11 %sp 64 #1527
	sw %a11 %a4 4 #1527
	sw %a4 %sp 220 #1620
	addi %a4 %min_caml_hp 0 #1620
	addi %min_caml_hp %min_caml_hp 88 #1620
	li %a10 trace_reflections.2565 #1620
	sw %a10 %a4 0 #1620
	sw %a2 %a4 80 #1620
	sw %a9 %a4 76 #1620
	sw %a11 %a4 72 #1620
	sw %a1 %a4 68 #1620
	lw %a10 %sp 208 #1620
	sw %a10 %a4 64 #1620
	sw %a6 %a4 60 #1620
	sw %a3 %a4 56 #1620
	sw %a0 %a4 52 #1620
	sw %a0 %sp 224 #1620
	lw %a0 %sp 204 #1620
	sw %a0 %a4 48 #1620
	lw %a0 %sp 200 #1620
	sw %a0 %a4 44 #1620
	lw %a0 %sp 196 #1620
	sw %a0 %a4 40 #1620
	lw %a0 %sp 72 #1620
	sw %a0 %a4 36 #1620
	lw %a0 %sp 140 #1620
	sw %a0 %a4 32 #1620
	lw %a0 %sp 36 #1620
	sw %a0 %a4 28 #1620
	sw %a7 %a4 24 #1620
	lw %a7 %sp 128 #1620
	sw %a7 %a4 20 #1620
	sw %a5 %a4 16 #1620
	sw %a8 %a4 12 #1620
	lw %a8 %sp 56 #1620
	sw %a8 %a4 8 #1620
	lw %a8 %sp 28 #1620
	sw %a8 %a4 4 #1620
	addi %a8 %min_caml_hp 0 #1647
	addi %min_caml_hp %min_caml_hp 136 #1647
	li %a5 trace_ray.2570 #1647
	sw %a5 %a8 0 #1647
	lw %a5 %sp 220 #1647
	sw %a5 %a8 128 #1647
	sw %a4 %a8 124 #1647
	sw %a2 %a8 120 #1647
	lw %a4 %sp 212 #1647
	sw %a4 %a8 116 #1647
	sw %a9 %a8 112 #1647
	sw %a11 %a8 108 #1647
	lw %a4 %sp 92 #1647
	sw %a4 %a8 104 #1647
	lw %a4 %sp 88 #1647
	sw %a4 %a8 100 #1647
	sw %a1 %a8 96 #1647
	sw %a10 %a8 92 #1647
	sw %a6 %a8 88 #1647
	sw %a3 %a8 84 #1647
	lw %a4 %sp 224 #1647
	sw %a4 %a8 80 #1647
	lw %a4 %sp 204 #1647
	sw %a4 %a8 76 #1647
	sw %a3 %sp 228 #1647
	lw %a3 %sp 200 #1647
	sw %a3 %a8 72 #1647
	lw %a1 %sp 196 #1647
	sw %a1 %a8 68 #1647
	lw %a1 %sp 180 #1647
	sw %a1 %a8 64 #1647
	lw %a1 %sp 72 #1647
	sw %a1 %a8 60 #1647
	lw %a1 %sp 140 #1647
	sw %a1 %a8 56 #1647
	sw %a0 %a8 52 #1647
	lw %a1 %sp 4 #1647
	sw %a1 %a8 48 #1647
	lw %a1 %sp 60 #1647
	sw %a1 %a8 44 #1647
	lw %a1 %sp 160 #1647
	sw %a1 %a8 40 #1647
	lw %a1 %sp 0 #1647
	sw %a1 %a8 36 #1647
	sw %a7 %a8 32 #1647
	lw %a1 %sp 16 #1647
	sw %a1 %a8 28 #1647
	lw %a1 %sp 44 #1647
	sw %a1 %a8 24 #1647
	lw %a1 %sp 52 #1647
	sw %a1 %a8 20 #1647
	lw %a1 %sp 56 #1647
	sw %a1 %a8 16 #1647
	lw %a1 %sp 216 #1647
	sw %a1 %a8 12 #1647
	lw %a1 %sp 20 #1647
	sw %a1 %a8 8 #1647
	lw %a1 %sp 28 #1647
	sw %a1 %a8 4 #1647
	sw %a8 %sp 232 #1737
	addi %a8 %min_caml_hp 0 #1737
	addi %min_caml_hp %min_caml_hp 88 #1737
	li %a1 trace_diffuse_ray.2576 #1737
	sw %a1 %a8 0 #1737
	sw %a5 %a8 80 #1737
	sw %a2 %a8 76 #1737
	sw %a9 %a8 72 #1737
	sw %a11 %a8 68 #1737
	sw %a10 %a8 64 #1737
	sw %a6 %a8 60 #1737
	sw %a4 %a8 56 #1737
	sw %a3 %a8 52 #1737
	lw %a1 %sp 196 #1737
	sw %a1 %a8 48 #1737
	sw %a0 %a8 44 #1737
	lw %a1 %sp 4 #1737
	sw %a1 %a8 40 #1737
	lw %a3 %sp 60 #1737
	sw %a3 %a8 36 #1737
	sw %a7 %a8 32 #1737
	lw %a10 %sp 16 #1737
	sw %a10 %a8 28 #1737
	lw %a7 %sp 44 #1737
	sw %a7 %a8 24 #1737
	lw %a7 %sp 52 #1737
	sw %a7 %a8 20 #1737
	lw %a7 %sp 56 #1737
	sw %a7 %a8 16 #1737
	lw %a7 %sp 216 #1737
	sw %a7 %a8 12 #1737
	lw %a7 %sp 68 #1737
	sw %a7 %a8 8 #1737
	lw %a7 %sp 28 #1737
	sw %a7 %a8 4 #1737
	addi %a7 %min_caml_hp 0 #1755
	addi %min_caml_hp %min_caml_hp 88 #1755
	li %a10 iter_trace_diffuse_rays.2579 #1755
	sw %a10 %a7 0 #1755
	sw %a5 %a7 80 #1755
	sw %a2 %a7 76 #1755
	sw %a8 %a7 72 #1755
	sw %a9 %a7 68 #1755
	sw %a11 %a7 64 #1755
	lw %a2 %sp 164 #1755
	sw %a2 %a7 60 #1755
	sw %a6 %a7 56 #1755
	lw %a2 %sp 228 #1755
	sw %a2 %a7 52 #1755
	lw %a2 %sp 224 #1755
	sw %a2 %a7 48 #1755
	sw %a4 %a7 44 #1755
	sw %a0 %a7 40 #1755
	sw %a1 %a7 36 #1755
	sw %a3 %a7 32 #1755
	lw %a2 %sp 16 #1755
	sw %a2 %a7 28 #1755
	lw %a3 %sp 44 #1755
	sw %a3 %a7 24 #1755
	lw %a3 %sp 52 #1755
	sw %a3 %a7 20 #1755
	lw %a3 %sp 56 #1755
	sw %a3 %a7 16 #1755
	lw %a3 %sp 216 #1755
	sw %a3 %a7 12 #1755
	lw %a3 %sp 68 #1755
	sw %a3 %a7 8 #1755
	lw %a4 %sp 28 #1755
	sw %a4 %a7 4 #1755
	addi %a5 %min_caml_hp 0 #1778
	addi %min_caml_hp %min_caml_hp 24 #1778
	li %a6 trace_diffuse_ray_80percent.2588 #1778
	sw %a6 %a5 0 #1778
	lw %a6 %sp 92 #1778
	sw %a6 %a5 20 #1778
	lw %a9 %sp 180 #1778
	sw %a9 %a5 16 #1778
	lw %a10 %sp 0 #1778
	sw %a10 %a5 12 #1778
	sw %a7 %a5 8 #1778
	lw %a11 %sp 116 #1778
	sw %a11 %a5 4 #1778
	addi %a4 %min_caml_hp 0 #1803
	addi %min_caml_hp %min_caml_hp 40 #1803
	li %a0 calc_diffuse_using_1point.2592 #1803
	sw %a0 %a4 0 #1803
	sw %a8 %a4 32 #1803
	sw %a6 %a4 28 #1803
	sw %a9 %a4 24 #1803
	lw %a0 %sp 72 #1803
	sw %a0 %a4 20 #1803
	sw %a10 %a4 16 #1803
	sw %a7 %a4 12 #1803
	sw %a11 %a4 8 #1803
	sw %a3 %a4 4 #1803
	addi %a2 %min_caml_hp 0 #1821
	addi %min_caml_hp %min_caml_hp 16 #1821
	li %a1 calc_diffuse_using_5points.2595 #1821
	sw %a1 %a2 0 #1821
	sw %a0 %a2 8 #1821
	sw %a3 %a2 4 #1821
	addi %a1 %min_caml_hp 0 #1841
	addi %min_caml_hp %min_caml_hp 40 #1841
	sw %a8 %sp 236 #1841
	li %a8 do_without_neighbors.2601 #1841
	sw %a8 %a1 0 #1841
	sw %a5 %a1 36 #1841
	sw %a6 %a1 32 #1841
	sw %a9 %a1 28 #1841
	sw %a0 %a1 24 #1841
	sw %a10 %a1 20 #1841
	sw %a7 %a1 16 #1841
	sw %a11 %a1 12 #1841
	sw %a3 %a1 8 #1841
	sw %a4 %a1 4 #1841
	addi %a8 %min_caml_hp 0 #1890
	addi %min_caml_hp %min_caml_hp 32 #1890
	li %a11 try_exploit_neighbors.2617 #1890
	sw %a11 %a8 0 #1890
	sw %a5 %a8 24 #1890
	sw %a0 %a8 20 #1890
	sw %a1 %a8 16 #1890
	sw %a3 %a8 12 #1890
	sw %a2 %a8 8 #1890
	sw %a4 %a8 4 #1890
	addi %a11 %min_caml_hp 0 #1949
	addi %min_caml_hp %min_caml_hp 32 #1949
	sw %a4 %sp 240 #1949
	li %a4 pretrace_diffuse_rays.2630 #1949
	sw %a4 %a11 0 #1949
	lw %a4 %sp 236 #1949
	sw %a4 %a11 28 #1949
	sw %a6 %a11 24 #1949
	sw %a9 %a11 20 #1949
	sw %a10 %a11 16 #1949
	sw %a7 %a11 12 #1949
	sw %a2 %sp 244 #1949
	lw %a2 %sp 116 #1949
	sw %a2 %a11 8 #1949
	sw %a3 %a11 4 #1949
	sw %a1 %sp 248 #1978
	addi %a1 %min_caml_hp 0 #1978
	addi %min_caml_hp %min_caml_hp 72 #1978
	sw %a5 %sp 252 #1978
	li %a5 pretrace_pixels.2633 #1978
	sw %a5 %a1 0 #1978
	lw %a5 %sp 12 #1978
	sw %a5 %a1 64 #1978
	lw %a5 %sp 232 #1978
	sw %a5 %a1 60 #1978
	sw %a4 %a1 56 #1978
	sw %a6 %a1 52 #1978
	lw %a4 %sp 88 #1978
	sw %a4 %a1 48 #1978
	sw %a9 %a1 44 #1978
	lw %a4 %sp 96 #1978
	sw %a4 %a1 40 #1978
	lw %a4 %sp 84 #1978
	sw %a4 %a1 36 #1978
	sw %a0 %a1 32 #1978
	lw %a5 %sp 108 #1978
	sw %a5 %a1 28 #1978
	sw %a11 %a1 24 #1978
	sw %a10 %a1 20 #1978
	sw %a7 %a1 16 #1978
	lw %a5 %sp 80 #1978
	sw %a5 %a1 12 #1978
	sw %a2 %a1 8 #1978
	sw %a3 %a1 4 #1978
	addi %a6 %min_caml_hp 0 #2017
	addi %min_caml_hp %min_caml_hp 40 #2017
	li %a7 scan_pixel.2644 #2017
	sw %a7 %a6 0 #2017
	sw %a8 %a6 32 #2017
	lw %a7 %sp 252 #2017
	sw %a7 %a6 28 #2017
	sw %a0 %a6 24 #2017
	lw %a9 %sp 76 #2017
	sw %a9 %a6 20 #2017
	lw %a11 %sp 248 #2017
	sw %a11 %a6 16 #2017
	sw %a3 %a6 12 #2017
	lw %a10 %sp 244 #2017
	sw %a10 %a6 8 #2017
	lw %a10 %sp 240 #2017
	sw %a10 %a6 4 #2017
	addi %a2 %min_caml_hp 0 #2037
	addi %min_caml_hp %min_caml_hp 56 #2037
	li %a10 scan_line.2650 #2037
	sw %a10 %a2 0 #2037
	sw %a8 %a2 52 #2037
	sw %a7 %a2 48 #2037
	lw %a7 %sp 104 #2037
	sw %a7 %a2 44 #2037
	lw %a8 %sp 100 #2037
	sw %a8 %a2 40 #2037
	sw %a6 %a2 36 #2037
	sw %a4 %a2 32 #2037
	sw %a0 %a2 28 #2037
	sw %a1 %a2 24 #2037
	sw %a9 %a2 20 #2037
	sw %a5 %a2 16 #2037
	sw %a11 %a2 12 #2037
	sw %a3 %a2 8 #2037
	lw %a0 %sp 240 #2037
	sw %a0 %a2 4 #2037
	addi %a0 %min_caml_hp 0 #2110
	addi %min_caml_hp %min_caml_hp 8 #2110
	li %a3 calc_dirvec.2670 #2110
	sw %a3 %a0 0 #2110
	lw %a3 %sp 116 #2110
	sw %a3 %a0 4 #2110
	addi %a10 %min_caml_hp 0 #2131
	addi %min_caml_hp %min_caml_hp 8 #2131
	li %a11 calc_dirvecs.2678 #2131
	sw %a11 %a10 0 #2131
	sw %a0 %a10 4 #2131
	addi %a11 %min_caml_hp 0 #2145
	addi %min_caml_hp %min_caml_hp 16 #2145
	li %a5 calc_dirvec_rows.2683 #2145
	sw %a5 %a11 0 #2145
	sw %a10 %a11 8 #2145
	sw %a0 %a11 4 #2145
	addi %a0 %min_caml_hp 0 #2162
	addi %min_caml_hp %min_caml_hp 8 #2162
	li %a5 create_dirvec_elements.2689 #2162
	sw %a5 %a0 0 #2162
	lw %a5 %sp 0 #2162
	sw %a5 %a0 4 #2162
	addi %a10 %min_caml_hp 0 #2169
	addi %min_caml_hp %min_caml_hp 16 #2169
	sw %a11 %sp 256 #2169
	li %a11 create_dirvecs.2692 #2169
	sw %a11 %a10 0 #2169
	sw %a5 %a10 12 #2169
	sw %a3 %a10 8 #2169
	sw %a0 %a10 4 #2169
	addi %a11 %min_caml_hp 0 #2179
	addi %min_caml_hp %min_caml_hp 24 #2179
	sw %a0 %sp 260 #2179
	li %a0 init_dirvec_constants.2694 #2179
	sw %a0 %a11 0 #2179
	lw %a0 %sp 176 #2179
	sw %a0 %a11 16 #2179
	sw %a10 %sp 264 #2179
	lw %a10 %sp 4 #2179
	sw %a10 %a11 12 #2179
	sw %a5 %a11 8 #2179
	lw %a9 %sp 172 #2179
	sw %a9 %a11 4 #2179
	sw %a1 %sp 268 #2186
	addi %a1 %min_caml_hp 0 #2186
	addi %min_caml_hp %min_caml_hp 32 #2186
	sw %a2 %sp 272 #2186
	li %a2 init_vecset_constants.2697 #2186
	sw %a2 %a1 0 #2186
	sw %a0 %a1 24 #2186
	sw %a10 %a1 20 #2186
	sw %a5 %a1 16 #2186
	sw %a9 %a1 12 #2186
	sw %a11 %a1 8 #2186
	sw %a3 %a1 4 #2186
	addi %a2 %min_caml_hp 0 #2211
	addi %min_caml_hp %min_caml_hp 32 #2211
	li %a3 setup_rect_reflection.2708 #2211
	sw %a3 %a2 0 #2211
	lw %a3 %sp 140 #2211
	sw %a3 %a2 24 #2211
	sw %a10 %a2 20 #2211
	sw %a11 %sp 276 #2211
	lw %a11 %sp 160 #2211
	sw %a11 %a2 16 #2211
	sw %a5 %a2 12 #2211
	sw %a1 %sp 280 #2211
	lw %a1 %sp 16 #2211
	sw %a1 %a2 8 #2211
	sw %a9 %a2 4 #2211
	addi %a4 %min_caml_hp 0 #2225
	addi %min_caml_hp %min_caml_hp 32 #2225
	sw %a6 %sp 284 #2225
	li %a6 setup_surface_reflection.2711 #2225
	sw %a6 %a4 0 #2225
	sw %a3 %a4 24 #2225
	sw %a10 %a4 20 #2225
	sw %a11 %a4 16 #2225
	sw %a5 %a4 12 #2225
	sw %a1 %a4 8 #2225
	sw %a9 %a4 4 #2225
	addi %a11 %min_caml_hp 0 #2260
	addi %min_caml_hp %min_caml_hp 128 #2260
	li %a3 rt.2716 #2260
	sw %a3 %a11 0 #2260
	lw %a3 %sp 124 #2260
	sw %a3 %a11 124 #2260
	sw %a4 %a11 120 #2260
	sw %a2 %a11 116 #2260
	sw %a0 %a11 112 #2260
	sw %a7 %a11 108 #2260
	sw %a8 %a11 104 #2260
	lw %a0 %sp 284 #2260
	sw %a0 %a11 100 #2260
	lw %a0 %sp 84 #2260
	sw %a0 %a11 96 #2260
	lw %a0 %sp 272 #2260
	sw %a0 %a11 92 #2260
	lw %a0 %sp 156 #2260
	sw %a0 %a11 88 #2260
	lw %a0 %sp 152 #2260
	sw %a0 %a11 84 #2260
	lw %a0 %sp 148 #2260
	sw %a0 %a11 80 #2260
	lw %a0 %sp 144 #2260
	sw %a0 %a11 76 #2260
	lw %a0 %sp 268 #2260
	sw %a0 %a11 72 #2260
	lw %a0 %sp 36 #2260
	sw %a0 %a11 68 #2260
	sw %a10 %a11 64 #2260
	sw %a5 %a11 60 #2260
	lw %a0 %sp 128 #2260
	sw %a0 %a11 56 #2260
	sw %a1 %a11 52 #2260
	sw %a9 %a11 48 #2260
	lw %a0 %sp 280 #2260
	sw %a0 %a11 44 #2260
	lw %a0 %sp 276 #2260
	sw %a0 %a11 40 #2260
	lw %a0 %sp 76 #2260
	sw %a0 %a11 36 #2260
	lw %a0 %sp 80 #2260
	sw %a0 %a11 32 #2260
	lw %a0 %sp 116 #2260
	sw %a0 %a11 28 #2260
	lw %a0 %sp 264 #2260
	sw %a0 %a11 24 #2260
	lw %a0 %sp 260 #2260
	sw %a0 %a11 20 #2260
	lw %a0 %sp 132 #2260
	sw %a0 %a11 16 #2260
	lw %a0 %sp 256 #2260
	sw %a0 %a11 12 #2260
	lw %a0 %sp 20 #2260
	sw %a0 %a11 8 #2260
	lw %a0 %sp 28 #2260
	sw %a0 %a11 4 #2260
	addi %a0 %zero 128 #2281
	addi %a1 %zero 128 #2281
	sw %ra %sp 292 #2281 call cls
	lw %a10 %a11 0 #2281
	addi %sp %sp 296 #2281	
	jalr %ra %a10 0 #2281
	addi %sp %sp -296 #2281
	lw %ra %sp 292 #2281
	addi %a0 %zero 0 #2283
