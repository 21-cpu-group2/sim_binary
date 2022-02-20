1. let directy-tree be like below 
'''
.
├── assembler
├── sim_binary
'''

2. let "test.asm", "contest.txt"(from contest.sld) file be in sim_binary/data directory like below
'''
sim_binary
|
...
├── data
│   ├── contest.bin
│   ├── contest.txt  <------
│   └── test.asm     <------
...
'''

3. please press "./ready.sh" in sim_binary directory

4. then 4 files added to sim_binary/data directory
    ・test.bin 
        machine code
    ・test_disassembled.txt
        disassembled code got from test.bin
        any instruction in test.bin has the same line-number in test_disassembled.txt
        # there is no pseudo instructions.
    ・pc_label.txt
        you can check label, with pc
    ・label_pc.txt
        you can check pc, with label
    ・stats.txt
        you can check statistics
        (cache hit rate, elapsed time, predicted time, etc...)

5. the simulator is ready.
    ./simulator (-p file path) (-a) (-r) (-m n) (-R n1 n2 ...)
    <options>
        -p path      : specify file path (relative path)
        -a           : show assembly code
        -r           : show register
        -m n         : showing memory from memory-address n
        -e n         : end simulator at specified pc
        -R n1 n2 ... : showing state of specified registers like vivado simulator
                       (please let -R option be the last.)
                       


