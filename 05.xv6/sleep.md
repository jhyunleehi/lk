# System Call 



## Sleep system call 구현

#### Kernel 함수

##### user.h

```c
int sleep(int);
```

* application에서 찾아 올수 있도록 

##### syscall.h

```c
#define SYS_sleep 13
```

##### syscall.c

```c
extern int sys_sleep(void);

static int (*syscalls[])(void) = {
    [SYS_fork] sys_fork,
    [SYS_exit] sys_exit,
    [SYS_wait] sys_wait,
    [SYS_pipe] sys_pipe,
    [SYS_read] sys_read,
    [SYS_kill] sys_kill,
    [SYS_exec] sys_exec,
    [SYS_fstat] sys_fstat,
    [SYS_chdir] sys_chdir,
    [SYS_dup] sys_dup,
    [SYS_getpid] sys_getpid,
    [SYS_sbrk] sys_sbrk,
    [SYS_sleep] sys_sleep,
    [SYS_uptime] sys_uptime,
    [SYS_open] sys_open,
    [SYS_write] sys_write,
    [SYS_mknod] sys_mknod,
    [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,
    [SYS_mkdir] sys_mkdir,
    [SYS_close] sys_close,
    [SYS_cps] sys_cps,
    [SYS_cdate] sys_cdate,
};
void syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  char *syscall_name[] ={"fork","exit","wait","pipe","read","kill","exec","fstat","chdir","dup","getpid","srbrk","sleep","uptime","open","write","mknod","unlink","link","mkdir","close","cps","cdate"};

  num = curproc->tf->eax;
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
  {
    curproc->tf->eax = syscalls[num]();
    cprintf("k: %s -> %d\n",  syscall_name[num-1], curproc->tf->eax);
  }
  else
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
```



##### sysproc.c

* 실제 sleep 커널 함수 구현

```c
int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
```

##### proc.c

* sleep 구현

```c
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        //DOC: sleeplock0
    acquire(&ptable.lock); //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();     <<=== sleep task를 SLEEPING 상태로 만들고 sched를 호출해서 스케쥴링하게 한다. 

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
```







#### Application

##### sleep.c

```c
#include "types.h"
#include "stat.h"
#include "user.h"  //syscall.h

int main (int argc, char *argv[])
{
    int i;
    if (argc < 2) {
        printf(2, "Usage: sleep time \n");
        exit();
    }
    i=atoi(argv[1]);
    int rtn = sleep(i);
    printf(1,"[%d]\n", rtn);
}

```

#### 컴파일 환경

##### Makefile

```makefile
UPROGS=\
	_cat\
	_echo\
...
	_sleep\
	
EXTRA=\
	mkfs.c ulib.c user.h cat.c echo.c forktest.c grep.c kill.c\
	ln.c ls.c mkdir.c rm.c stressfs.c usertests.c wc.c zombie.c sleep.c\
	printf.c umalloc.c\
	README dot-bochsrc *.pl toc.* runoff runoff1 runoff.list\
	.gdbinit.tmpl gdbutil\
	
```



#### make qemu

* 컴파일 오류

````
make: *** 'fs.img'에서 필요한 '_sleep' 타겟을 만들 규칙이 없습니다.  멈춤.
````

* 원인
  * sleep.c 파일의 위치를 user/sleep.c 이렇게 해놨더니 찾지를 못함.
  * sleep.c 파일을 Makefile 같은 위치로 이동 



#### Error

```
$ sleep 1
[0]
pid 11 sleep: trap 14 err 5 on cpu 0 eip 0xffffffff addr 0xffffffff--kill proc
```

* 이것은 어디서 나오는가?

```c
<trap.c>
//PAGEBREAK: 41
void trap(struct trapframe *tf)
{
  if (tf->trapno == T_SYSCALL)
  {
    if (myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
  {
  case T_IRQ0 + IRQ_TIMER:
    if (cpuid() == 0)
    {
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE + 1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
    {
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }
```



* 디버깅을 해보면 

  `sleep->0` 이렇게 나온다 그러면 원인은 curproc-tf-eax에서 넘겨 줄때  systemcall eax에 넘겨 주는 것에서 좀 문제가 있나?

```c
void syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  char *syscall_name[] ={"fork","exit","wait","pipe","read","kill","exec","fstat","chdir","dup","getpid","srbrk","sleep","uptime","open","write","mknod","unlink","link","mkdir","close","cps","cdate"};

  num = curproc->tf->eax;
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
  {
    curproc->tf->eax = syscalls[num]();
    cprintf("k: %s -> %d\n",  syscall_name[num-1], curproc->tf->eax);
  }
  else
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
```



* 조치
  * 일단 make clean 해서  소스 변경이 반영되지 않은 부분이 있는지 제거하고
  * make qemu-nox 해서 다시 full  compile  한다. 
  * 전체  재 컴파일 하니 정상적으로 sleep 이 동작한다. 





* qemu 터이널 종료할때는 Ctl-a + x 이렇게 



