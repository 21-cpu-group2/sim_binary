# assemble
###################
# _____assembler
#   |
#   |__sim_binary
###################
make clean
SRC_ASM="data/test.asm"
cp $SRC_ASM ../assembler/test.asm
rm -f data/test.bin data/label_pc.txt data/pc_label.txt
cd ../assembler
make clean
sed -i -e 's/true/false/g' main.ml
make
./main test > ../sim_binary/data/test.bin
make clean
sed -i -e 's/false/true/g' main.ml
make
./main test > ../sim_binary/data/label_pc.txt
sed -i -e 's/true/false/g' main.ml
# finish assembling
cd ../sim_binary
g++ -o make_pc_label make_pc_label.cpp
g++ -o disassembler disassembler.cpp
./make_pc_label data/label_pc.txt > data/pc_label.txt
./disassembler data/test.bin > data/test_disassembled.txt
rm -f make_pc_label disassembler
make