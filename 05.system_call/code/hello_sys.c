#include<sys/syscall.h>
#include<unistd.h>
int main(void){
    syscall(SYS_write, 1,"hello, World!\n",14);
    return 0;
}
