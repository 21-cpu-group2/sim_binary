min_caml_start:
    addi %a1 %zero 1000
    addi %a2 %zero 2000
    addi %a3 %zero 1500
    addi %a4 %zero -1200
    addi %a5 %zero -300
    li %a6 300000
    li %a7 300004
    li %a8 300008
    li %a9 300012
    sw %a1 %a6 0
    sw %a2 %a6 4
    sw %a3 %a6 8
    sw %a4 %a6 12