min_caml_start:
    addi %a1 %zero 1000
    addi %a2 %zero 2000
    addi %a3 %zero 3000
    addi %a4 %zero 4000
    addi %a5 %zero 5000
    addi %a6 %zero 300000
    addi %a7 %zero 300004
    addi %a8 %zero 300008
    addi %a9 %zero 300012
    sw %a1 %a6 0
    sw %a2 %a6 4
    sw %a3 %a6 8
    sw %a4 %a6 12
    nop