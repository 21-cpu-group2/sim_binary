#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

typedef struct {
    string label;
    unsigned long pc;
}label_pc;

int compare(const void* a, const void* b) {
    if (((label_pc*)a)->pc > ((label_pc*)b)->pc) {
        return 1;
    }
    else {
        return -1;
    }
}

int main(int argc, char** argv){
    label_pc data[1000];
    string file_path = argv[1];
    ifstream ifs(file_path);
    if (ifs.fail()){
        return 1;
    }
    cout << "floating-point imm table" << endl;
    string str;
    int ind = 0;
    while (getline(ifs, str)){
        istringstream iss(str);
        string l, p;
        iss >> l >> p;
        if (l.at(0) == 'l'){
            cout << str << endl;
        }
        else {
            data[ind].label = l;
            data[ind].pc = stoul(p, nullptr, 10);
            ind++;
        }
    }
    cout << endl;
    cout << "pc -> label" << endl;
    qsort(data, ind, sizeof(label_pc), compare);
    for (int i=0; i<ind; i++){
        cout << data[i].pc << "  " << data[i].label << endl;
    }
    return 0;
}