#include <stdio.h>

int main(){
    FILE *fp1, *fp2;
    fp1 = fopen("/Users/koyasuizuho/Desktop/cpu-ex/sim_binary/data/test.bin","r");
    fp2 = fopen("prg128.txt", "w");
    char a[33];
    int b[4];
    char c[4];
    for(int j=0;j<21106;j++){
        fread(a,1,33,fp1);
        for(int i=0;i<4;i++){
            b[i] = (a[8*(3-i)]-'0')*128+(a[8*(3-i)+1]-'0')*64+(a[8*(3-i)+2]-'0')*32+(a[8*(3-i)+3]-'0')*16+ (a[8*(3-i)+4]-'0')*8+(a[8*(3-i)+5]-'0')*4+(a[8*(3-i)+6]-'0')*2+(a[8*(3-i)+7]-'0');
            c[i] = (char)b[i];
        }
        fwrite(c,1,4,fp2);
    }
    
    fclose(fp1); fclose(fp2);
    return 0;
}
