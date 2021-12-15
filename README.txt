how to debug

1. let directy-tree be like below 
'''
.
├── assembler
├── emu_binary
'''

2. let "test.asm", "contest.txt" file be in emu_binary/data directory like below
'''
emu_binary
|
...
├── data
│   ├── contest.txt
│   ├── label_pc.txt
│   ├── output.txt
│   ├── pc_label.txt
│   ├── test.asm    <------
│   ├── test.bin
│   └── test_disassembled.txt
...
'''

3. please press "./ready.sh" in emu_binary directory

4. then 4 files added to emu_binary/data directory
    ・test.bin 
        first line       -> initial pc
        from second line -> machine code
    ・test_disassembled.txt
        disassembled code got from test.bin
        any instruction in test.bin has the same line-number in test_disassembled.txt
    ・pc_label.txt
        you can check label, with pc
    ・label_pc.txt
        you can check pc, with label

5. the simulator is ready.
    ./simulator (-p file path) (-a) (-r) (-m n)
    <options>
        -p path : specify file path (relative path)
        -a      : show assembly code
        -r      : show register
        -m n    : showing memory from memory-address n


