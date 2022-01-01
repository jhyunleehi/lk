# System call



* Linux kernel sourcecode
* write() syscall
* copy_from_user()



`*ABI* ( Application Binary Interface )`



#### Archtecure call Conventions

##### system call  Instruction, system call number

```
       Arch/ABI    Instruction           System  Ret  Ret  Error    Notes
                                         call #  val  val2
       ───────────────────────────────────────────────────────────────────
       alpha       callsys               v0      v0   a4   a3       1, 6
       arc         trap0                 r8      r0   -    -
       arm/OABI    swi NR                -       a1   -    -        2
       arm/EABI    swi 0x0               r7      r0   r1   -
       arm64       svc #0                x8      x0   x1   -
       i386        int $0x80             eax     eax  edx  -
       mips        syscall               v0      v0   v1   a3       1, 6
       powerpc     sc                    r0      r3   -    r0       1
       powerpc64   sc                    r0      r3   -    cr0.SO   1
       riscv       ecall                 a7      a0   a1   -
       s390        svc 0                 r1      r2   r3   -        3
       s390x       svc 0                 r1      r2   r3   -        3
       superh      trap #0x17            r3      r0   r1   -        4, 6
       sparc/32    t 0x10                g1      o0   o1   psr/csr  1, 6
       sparc/64    t 0x6d                g1      o0   o1   psr/csr  1, 6
       tile        swint1                R10     R00  -    R01      1
       x86-64      syscall               rax     rax  rdx  -        5
```



##### to pass the system call arguments

```
       Arch/ABI      arg1  arg2  arg3  arg4  arg5  arg6  arg7  Notes
       ──────────────────────────────────────────────────────────────
       arm/OABI      a1    a2    a3    a4    v1    v2    v3
       arm/EABI      r0    r1    r2    r3    r4    r5    r6
       arm64         x0    x1    x2    x3    x4    x5    -
       i386          ebx   ecx   edx   esi   edi   ebp   -
       mips/o32      a0    a1    a2    a3    -     -     -     1
       mips/n32,64   a0    a1    a2    a3    a4    a5    -
       powerpc       r3    r4    r5    r6    r7    r8    r9
       powerpc64     r3    r4    r5    r6    r7    r8    -
       riscv         a0    a1    a2    a3    a4    a5    -
       s390          r2    r3    r4    r5    r6    r7    -
       s390x         r2    r3    r4    r5    r6    r7    -
       superh        r4    r5    r6    r7    r0    r1    r2
       sparc/32      o0    o1    o2    o3    o4    o5    -
       sparc/64      o0    o1    o2    o3    o4    o5    -
       x86-64        rdi   rsi   rdx   r10   r8    r9    -
```





<img src="img/x86register.jpg"  />

