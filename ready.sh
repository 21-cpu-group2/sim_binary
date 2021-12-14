# assemble
###################
# _____assembler
#   |
#   |__emu_binary
###################
make clean
cp data/test.asm ../assembler/test.asm
rm -f data/test.bin data/label_pc.txt data/pc_label.txt
cd ../assembler
make clean
sed -i -e "s/true/false/g" ./main.ml
make
./main test > ../emu_binary/data/test.bin
make clean
sed -i -e "s/false/true/g" ./main.ml
make
./main test > ../emu_binary/data/label_pc.txt
sed -i -e "s/true/false/g" ./main.ml
# finish assembling
cd ../emu_binary
g++ -o make_pc_label make_pc_label.cpp
./make_pc_label data/label_pc.txt > data/pc_label.txt
rm -f make_pc_label
make