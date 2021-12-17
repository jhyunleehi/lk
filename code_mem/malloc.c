#include<stdio.h>
#include<malloc.h>
int main (){
    char *temp;
    for (int i=0; i<1024*1024*10; i++){
        temp=(char*)malloc(sizeof(char)*1024);
        printf("%d K\n",i);
    }
}
