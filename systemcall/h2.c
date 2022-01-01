#include <unistd.h>
#include<sys/syscall.h>

int main (void){
    syscall(SYS_write,1,"hello world\n",14);
    syscall(SYS_exit,0);
}
