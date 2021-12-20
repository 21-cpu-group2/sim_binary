CC := g++
CFLAGS = -std=c++14 -O3
PROGRAM = simulator

all: simulator.o instruction.o main.o simulator

simulator.o: simulator.cpp simulator.hpp
	$(CC) $(CFLAGS) -c simulator.cpp simulator.hpp

instruction.o: instruction.cpp instruction.hpp simulator.hpp
	$(CC) $(CFLAGS) -c instruction.cpp instruction.hpp

main.o: main.cpp instruction.hpp simulator.hpp
	$(CC) $(CFLAGS) -c main.cpp

simulator: simulator.o instruction.o main.o
	$(CC) $(CFLAGS) -o simulator simulator.o instruction.o main.o

clean:
	rm -f *.o *.gch simulator h2f 
