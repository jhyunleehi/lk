# System call



* Linux kernel sourcecode
* write() syscall
* copy_from_user()



### syscalls

#### man syscalls

```text
SYSCALLS(2)                                                           Linux Programmer's Manual                                                          SYSCALLS(2)

NAME
       syscalls - Linux system calls

SYNOPSIS
       Linux system calls.

DESCRIPTION
       The system call is the fundamental interface between an application and the Linux kernel.

   System calls and library wrapper functions
       System calls are generally not invoked directly, but rather via wrapper functions in glibc (or perhaps some other library).  For details of direct invocation
       of a system call, see intro(2).  Often, but not always, the name of the wrapper function is the same as the name of the system call that it invokes.  For ex‐
       ample, glibc contains a function chdir() which invokes the underlying "chdir" system call.
```



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



![CS356: A short guide to x86-64 assembly](img/nHMUcng.png)



####  syscall number

* x86_64: arch/x86/entry/syscalls/syscall_64.tbl: read is 0

* x86: arch/x86/entry/syscalls/syscall_32.tbl: read is 3

* arm64: include/uapi/asm-generic/unistd.h: read is 63,
* arm: arch/arm/tools/syscall.tbl, read is 3

##### arch/x86/entry/syscalls/syscall_64.tbl:

```
#
# 64-bit system call numbers and entry vectors
#
# The format is:
# <number> <abi> <name> <entry point>
#
# The __x64_sys_*() stubs are created on-the-fly for sys_*() system calls
#
# The abi is "common", "64" or "x32" for this file.
#
0	common	read			__x64_sys_read
1	common	write			__x64_sys_write
2	common	open			__x64_sys_open
3	common	close			__x64_sys_close
4	common	stat			__x64_sys_newstat
5	common	fstat			__x64_sys_newfstat
6	common	lstat			__x64_sys_newlstat
7	common	poll			__x64_sys_poll
8	common	lseek			__x64_sys_lseek
9	common	mmap			__x64_sys_mmap
10	common	mprotect		__x64_sys_mprotect
11	common	munmap			__x64_sys_munmap
12	common	brk			__x64_sys_brk
13	64	rt_sigaction		__x64_sys_rt_sigaction
14	common	rt_sigprocmask		__x64_sys_rt_sigprocmask
15	64	rt_sigreturn		__x64_sys_rt_sigreturn/ptregs
16	64	ioctl			__x64_sys_ioctl
17	common	pread64			__x64_sys_pread64
18	common	pwrite64		__x64_sys_pwrite64
19	64	readv			__x64_sys_readv
20	64	writev			__x64_sys_writev
21	common	access			__x64_sys_access
22	common	pipe			__x64_sys_pipe
23	common	select			__x64_sys_select
24	common	sched_yield		__x64_sys_sched_yield
25	common	mremap			__x64_sys_mremap
26	common	msync			__x64_sys_msync
27	common	mincore			__x64_sys_mincore
28	common	madvise			__x64_sys_madvise
29	common	shmget			__x64_sys_shmget
30	common	shmat			__x64_sys_shmat
31	common	shmctl			__x64_sys_shmctl
32	common	dup			__x64_sys_dup
33	common	dup2			__x64_sys_dup2
34	common	pause			__x64_sys_pause
35	common	nanosleep		__x64_sys_nanosleep
36	common	getitimer		__x64_sys_getitimer
37	common	alarm			__x64_sys_alarm
38	common	setitimer		__x64_sys_setitimer
39	common	getpid			__x64_sys_getpid
40	common	sendfile		__x64_sys_sendfile64
41	common	socket			__x64_sys_socket
42	common	connect			__x64_sys_connect
43	common	accept			__x64_sys_accept
44	common	sendto			__x64_sys_sendto
45	64	recvfrom		__x64_sys_recvfrom
46	64	sendmsg			__x64_sys_sendmsg
47	64	recvmsg			__x64_sys_recvmsg
48	common	shutdown		__x64_sys_shutdown
49	common	bind			__x64_sys_bind
50	common	listen			__x64_sys_listen
51	common	getsockname		__x64_sys_getsockname
52	common	getpeername		__x64_sys_getpeername
53	common	socketpair		__x64_sys_socketpair
54	64	setsockopt		__x64_sys_setsockopt
55	64	getsockopt		__x64_sys_getsockopt
56	common	clone			__x64_sys_clone/ptregs
57	common	fork			__x64_sys_fork/ptregs
58	common	vfork			__x64_sys_vfork/ptregs
59	64	execve			__x64_sys_execve/ptregs
60	common	exit			__x64_sys_exit
61	common	wait4			__x64_sys_wait4
62	common	kill			__x64_sys_kill
63	common	uname			__x64_sys_newuname
64	common	semget			__x64_sys_semget
65	common	semop			__x64_sys_semop
66	common	semctl			__x64_sys_semctl
67	common	shmdt			__x64_sys_shmdt
68	common	msgget			__x64_sys_msgget
69	common	msgsnd			__x64_sys_msgsnd
70	common	msgrcv			__x64_sys_msgrcv
71	common	msgctl			__x64_sys_msgctl
72	common	fcntl			__x64_sys_fcntl
73	common	flock			__x64_sys_flock
74	common	fsync			__x64_sys_fsync
75	common	fdatasync		__x64_sys_fdatasync
76	common	truncate		__x64_sys_truncate
77	common	ftruncate		__x64_sys_ftruncate
78	common	getdents		__x64_sys_getdents
79	common	getcwd			__x64_sys_getcwd
80	common	chdir			__x64_sys_chdir
81	common	fchdir			__x64_sys_fchdir
82	common	rename			__x64_sys_rename
83	common	mkdir			__x64_sys_mkdir
84	common	rmdir			__x64_sys_rmdir
85	common	creat			__x64_sys_creat
86	common	link			__x64_sys_link
87	common	unlink			__x64_sys_unlink
88	common	symlink			__x64_sys_symlink
89	common	readlink		__x64_sys_readlink
90	common	chmod			__x64_sys_chmod
91	common	fchmod			__x64_sys_fchmod
92	common	chown			__x64_sys_chown
93	common	fchown			__x64_sys_fchown
94	common	lchown			__x64_sys_lchown
95	common	umask			__x64_sys_umask
96	common	gettimeofday		__x64_sys_gettimeofday
97	common	getrlimit		__x64_sys_getrlimit
98	common	getrusage		__x64_sys_getrusage
99	common	sysinfo			__x64_sys_sysinfo
100	common	times			__x64_sys_times
101	64	ptrace			__x64_sys_ptrace
102	common	getuid			__x64_sys_getuid
103	common	syslog			__x64_sys_syslog
104	common	getgid			__x64_sys_getgid
105	common	setuid			__x64_sys_setuid
106	common	setgid			__x64_sys_setgid
107	common	geteuid			__x64_sys_geteuid
108	common	getegid			__x64_sys_getegid
109	common	setpgid			__x64_sys_setpgid
110	common	getppid			__x64_sys_getppid
111	common	getpgrp			__x64_sys_getpgrp
112	common	setsid			__x64_sys_setsid
113	common	setreuid		__x64_sys_setreuid
114	common	setregid		__x64_sys_setregid
115	common	getgroups		__x64_sys_getgroups
116	common	setgroups		__x64_sys_setgroups
117	common	setresuid		__x64_sys_setresuid
118	common	getresuid		__x64_sys_getresuid
119	common	setresgid		__x64_sys_setresgid
120	common	getresgid		__x64_sys_getresgid
121	common	getpgid			__x64_sys_getpgid
122	common	setfsuid		__x64_sys_setfsuid
123	common	setfsgid		__x64_sys_setfsgid
124	common	getsid			__x64_sys_getsid
125	common	capget			__x64_sys_capget
126	common	capset			__x64_sys_capset
127	64	rt_sigpending		__x64_sys_rt_sigpending
128	64	rt_sigtimedwait		__x64_sys_rt_sigtimedwait
129	64	rt_sigqueueinfo		__x64_sys_rt_sigqueueinfo
130	common	rt_sigsuspend		__x64_sys_rt_sigsuspend
131	64	sigaltstack		__x64_sys_sigaltstack
132	common	utime			__x64_sys_utime
133	common	mknod			__x64_sys_mknod
134	64	uselib
135	common	personality		__x64_sys_personality
136	common	ustat			__x64_sys_ustat
137	common	statfs			__x64_sys_statfs
138	common	fstatfs			__x64_sys_fstatfs
139	common	sysfs			__x64_sys_sysfs
140	common	getpriority		__x64_sys_getpriority
141	common	setpriority		__x64_sys_setpriority
142	common	sched_setparam		__x64_sys_sched_setparam
143	common	sched_getparam		__x64_sys_sched_getparam
144	common	sched_setscheduler	__x64_sys_sched_setscheduler
145	common	sched_getscheduler	__x64_sys_sched_getscheduler
146	common	sched_get_priority_max	__x64_sys_sched_get_priority_max
147	common	sched_get_priority_min	__x64_sys_sched_get_priority_min
148	common	sched_rr_get_interval	__x64_sys_sched_rr_get_interval
149	common	mlock			__x64_sys_mlock
150	common	munlock			__x64_sys_munlock
151	common	mlockall		__x64_sys_mlockall
152	common	munlockall		__x64_sys_munlockall
153	common	vhangup			__x64_sys_vhangup
154	common	modify_ldt		__x64_sys_modify_ldt
155	common	pivot_root		__x64_sys_pivot_root
156	64	_sysctl			__x64_sys_sysctl
157	common	prctl			__x64_sys_prctl
158	common	arch_prctl		__x64_sys_arch_prctl
159	common	adjtimex		__x64_sys_adjtimex
160	common	setrlimit		__x64_sys_setrlimit
161	common	chroot			__x64_sys_chroot
162	common	sync			__x64_sys_sync
163	common	acct			__x64_sys_acct
164	common	settimeofday		__x64_sys_settimeofday
165	common	mount			__x64_sys_mount
166	common	umount2			__x64_sys_umount
167	common	swapon			__x64_sys_swapon
168	common	swapoff			__x64_sys_swapoff
169	common	reboot			__x64_sys_reboot
170	common	sethostname		__x64_sys_sethostname
171	common	setdomainname		__x64_sys_setdomainname
172	common	iopl			__x64_sys_iopl/ptregs
173	common	ioperm			__x64_sys_ioperm
174	64	create_module
175	common	init_module		__x64_sys_init_module
176	common	delete_module		__x64_sys_delete_module
177	64	get_kernel_syms
178	64	query_module
179	common	quotactl		__x64_sys_quotactl
180	64	nfsservctl
181	common	getpmsg
182	common	putpmsg
183	common	afs_syscall
184	common	tuxcall
185	common	security
186	common	gettid			__x64_sys_gettid
187	common	readahead		__x64_sys_readahead
188	common	setxattr		__x64_sys_setxattr
189	common	lsetxattr		__x64_sys_lsetxattr
190	common	fsetxattr		__x64_sys_fsetxattr
191	common	getxattr		__x64_sys_getxattr
192	common	lgetxattr		__x64_sys_lgetxattr
193	common	fgetxattr		__x64_sys_fgetxattr
194	common	listxattr		__x64_sys_listxattr
195	common	llistxattr		__x64_sys_llistxattr
196	common	flistxattr		__x64_sys_flistxattr
197	common	removexattr		__x64_sys_removexattr
198	common	lremovexattr		__x64_sys_lremovexattr
199	common	fremovexattr		__x64_sys_fremovexattr
200	common	tkill			__x64_sys_tkill
201	common	time			__x64_sys_time
202	common	futex			__x64_sys_futex
203	common	sched_setaffinity	__x64_sys_sched_setaffinity
204	common	sched_getaffinity	__x64_sys_sched_getaffinity
205	64	set_thread_area
206	64	io_setup		__x64_sys_io_setup
207	common	io_destroy		__x64_sys_io_destroy
208	common	io_getevents		__x64_sys_io_getevents
209	64	io_submit		__x64_sys_io_submit
210	common	io_cancel		__x64_sys_io_cancel
211	64	get_thread_area
212	common	lookup_dcookie		__x64_sys_lookup_dcookie
213	common	epoll_create		__x64_sys_epoll_create
214	64	epoll_ctl_old
215	64	epoll_wait_old
216	common	remap_file_pages	__x64_sys_remap_file_pages
217	common	getdents64		__x64_sys_getdents64
218	common	set_tid_address		__x64_sys_set_tid_address
219	common	restart_syscall		__x64_sys_restart_syscall
220	common	semtimedop		__x64_sys_semtimedop
221	common	fadvise64		__x64_sys_fadvise64
222	64	timer_create		__x64_sys_timer_create
223	common	timer_settime		__x64_sys_timer_settime
224	common	timer_gettime		__x64_sys_timer_gettime
225	common	timer_getoverrun	__x64_sys_timer_getoverrun
226	common	timer_delete		__x64_sys_timer_delete
227	common	clock_settime		__x64_sys_clock_settime
228	common	clock_gettime		__x64_sys_clock_gettime
229	common	clock_getres		__x64_sys_clock_getres
230	common	clock_nanosleep		__x64_sys_clock_nanosleep
231	common	exit_group		__x64_sys_exit_group
232	common	epoll_wait		__x64_sys_epoll_wait
233	common	epoll_ctl		__x64_sys_epoll_ctl
234	common	tgkill			__x64_sys_tgkill
235	common	utimes			__x64_sys_utimes
236	64	vserver
237	common	mbind			__x64_sys_mbind
238	common	set_mempolicy		__x64_sys_set_mempolicy
239	common	get_mempolicy		__x64_sys_get_mempolicy
240	common	mq_open			__x64_sys_mq_open
241	common	mq_unlink		__x64_sys_mq_unlink
242	common	mq_timedsend		__x64_sys_mq_timedsend
243	common	mq_timedreceive		__x64_sys_mq_timedreceive
244	64	mq_notify		__x64_sys_mq_notify
245	common	mq_getsetattr		__x64_sys_mq_getsetattr
246	64	kexec_load		__x64_sys_kexec_load
247	64	waitid			__x64_sys_waitid
248	common	add_key			__x64_sys_add_key
249	common	request_key		__x64_sys_request_key
250	common	keyctl			__x64_sys_keyctl
251	common	ioprio_set		__x64_sys_ioprio_set
252	common	ioprio_get		__x64_sys_ioprio_get
253	common	inotify_init		__x64_sys_inotify_init
254	common	inotify_add_watch	__x64_sys_inotify_add_watch
255	common	inotify_rm_watch	__x64_sys_inotify_rm_watch
256	common	migrate_pages		__x64_sys_migrate_pages
257	common	openat			__x64_sys_openat
258	common	mkdirat			__x64_sys_mkdirat
259	common	mknodat			__x64_sys_mknodat
260	common	fchownat		__x64_sys_fchownat
261	common	futimesat		__x64_sys_futimesat
262	common	newfstatat		__x64_sys_newfstatat
263	common	unlinkat		__x64_sys_unlinkat
264	common	renameat		__x64_sys_renameat
265	common	linkat			__x64_sys_linkat
266	common	symlinkat		__x64_sys_symlinkat
267	common	readlinkat		__x64_sys_readlinkat
268	common	fchmodat		__x64_sys_fchmodat
269	common	faccessat		__x64_sys_faccessat
270	common	pselect6		__x64_sys_pselect6
271	common	ppoll			__x64_sys_ppoll
272	common	unshare			__x64_sys_unshare
273	64	set_robust_list		__x64_sys_set_robust_list
274	64	get_robust_list		__x64_sys_get_robust_list
275	common	splice			__x64_sys_splice
276	common	tee			__x64_sys_tee
277	common	sync_file_range		__x64_sys_sync_file_range
278	64	vmsplice		__x64_sys_vmsplice
279	64	move_pages		__x64_sys_move_pages
280	common	utimensat		__x64_sys_utimensat
281	common	epoll_pwait		__x64_sys_epoll_pwait
282	common	signalfd		__x64_sys_signalfd
283	common	timerfd_create		__x64_sys_timerfd_create
284	common	eventfd			__x64_sys_eventfd
285	common	fallocate		__x64_sys_fallocate
286	common	timerfd_settime		__x64_sys_timerfd_settime
287	common	timerfd_gettime		__x64_sys_timerfd_gettime
288	common	accept4			__x64_sys_accept4
289	common	signalfd4		__x64_sys_signalfd4
290	common	eventfd2		__x64_sys_eventfd2
291	common	epoll_create1		__x64_sys_epoll_create1
292	common	dup3			__x64_sys_dup3
293	common	pipe2			__x64_sys_pipe2
294	common	inotify_init1		__x64_sys_inotify_init1
295	64	preadv			__x64_sys_preadv
296	64	pwritev			__x64_sys_pwritev
297	64	rt_tgsigqueueinfo	__x64_sys_rt_tgsigqueueinfo
298	common	perf_event_open		__x64_sys_perf_event_open
299	64	recvmmsg		__x64_sys_recvmmsg
300	common	fanotify_init		__x64_sys_fanotify_init
301	common	fanotify_mark		__x64_sys_fanotify_mark
302	common	prlimit64		__x64_sys_prlimit64
303	common	name_to_handle_at	__x64_sys_name_to_handle_at
304	common	open_by_handle_at	__x64_sys_open_by_handle_at
305	common	clock_adjtime		__x64_sys_clock_adjtime
306	common	syncfs			__x64_sys_syncfs
307	64	sendmmsg		__x64_sys_sendmmsg
308	common	setns			__x64_sys_setns
309	common	getcpu			__x64_sys_getcpu
310	64	process_vm_readv	__x64_sys_process_vm_readv
311	64	process_vm_writev	__x64_sys_process_vm_writev
312	common	kcmp			__x64_sys_kcmp
313	common	finit_module		__x64_sys_finit_module
314	common	sched_setattr		__x64_sys_sched_setattr
315	common	sched_getattr		__x64_sys_sched_getattr
316	common	renameat2		__x64_sys_renameat2
317	common	seccomp			__x64_sys_seccomp
318	common	getrandom		__x64_sys_getrandom
319	common	memfd_create		__x64_sys_memfd_create
320	common	kexec_file_load		__x64_sys_kexec_file_load
321	common	bpf			__x64_sys_bpf
322	64	execveat		__x64_sys_execveat/ptregs
323	common	userfaultfd		__x64_sys_userfaultfd
324	common	membarrier		__x64_sys_membarrier
325	common	mlock2			__x64_sys_mlock2
326	common	copy_file_range		__x64_sys_copy_file_range
327	64	preadv2			__x64_sys_preadv2
328	64	pwritev2		__x64_sys_pwritev2
329	common	pkey_mprotect		__x64_sys_pkey_mprotect
330	common	pkey_alloc		__x64_sys_pkey_alloc
331	common	pkey_free		__x64_sys_pkey_free
332	common	statx			__x64_sys_statx
333	common	io_pgetevents		__x64_sys_io_pgetevents
334	common	rseq			__x64_sys_rseq
# don't use numbers 387 through 423, add new calls after the last
# 'common' entry
424	common	pidfd_send_signal	__x64_sys_pidfd_send_signal
425	common	io_uring_setup		__x64_sys_io_uring_setup
426	common	io_uring_enter		__x64_sys_io_uring_enter
427	common	io_uring_register	__x64_sys_io_uring_register
428	common	open_tree		__x64_sys_open_tree
429	common	move_mount		__x64_sys_move_mount
430	common	fsopen			__x64_sys_fsopen
431	common	fsconfig		__x64_sys_fsconfig
432	common	fsmount			__x64_sys_fsmount
433	common	fspick			__x64_sys_fspick
434	common	pidfd_open		__x64_sys_pidfd_open
435	common	clone3			__x64_sys_clone3/ptregs

#
# x32-specific system call numbers start at 512 to avoid cache impact
# for native 64-bit operation. The __x32_compat_sys stubs are created
# on-the-fly for compat_sys_*() compatibility system calls if X86_X32
# is defined.
#
512	x32	rt_sigaction		__x32_compat_sys_rt_sigaction
513	x32	rt_sigreturn		sys32_x32_rt_sigreturn
514	x32	ioctl			__x32_compat_sys_ioctl
515	x32	readv			__x32_compat_sys_readv
516	x32	writev			__x32_compat_sys_writev
517	x32	recvfrom		__x32_compat_sys_recvfrom
518	x32	sendmsg			__x32_compat_sys_sendmsg
519	x32	recvmsg			__x32_compat_sys_recvmsg
520	x32	execve			__x32_compat_sys_execve/ptregs
521	x32	ptrace			__x32_compat_sys_ptrace
522	x32	rt_sigpending		__x32_compat_sys_rt_sigpending
523	x32	rt_sigtimedwait		__x32_compat_sys_rt_sigtimedwait_time64
524	x32	rt_sigqueueinfo		__x32_compat_sys_rt_sigqueueinfo
525	x32	sigaltstack		__x32_compat_sys_sigaltstack
526	x32	timer_create		__x32_compat_sys_timer_create
527	x32	mq_notify		__x32_compat_sys_mq_notify
528	x32	kexec_load		__x32_compat_sys_kexec_load
529	x32	waitid			__x32_compat_sys_waitid
530	x32	set_robust_list		__x32_compat_sys_set_robust_list
531	x32	get_robust_list		__x32_compat_sys_get_robust_list
532	x32	vmsplice		__x32_compat_sys_vmsplice
533	x32	move_pages		__x32_compat_sys_move_pages
534	x32	preadv			__x32_compat_sys_preadv64
535	x32	pwritev			__x32_compat_sys_pwritev64
536	x32	rt_tgsigqueueinfo	__x32_compat_sys_rt_tgsigqueueinfo
537	x32	recvmmsg		__x32_compat_sys_recvmmsg_time64
538	x32	sendmmsg		__x32_compat_sys_sendmmsg
539	x32	process_vm_readv	__x32_compat_sys_process_vm_readv
540	x32	process_vm_writev	__x32_compat_sys_process_vm_writev
541	x32	setsockopt		__x32_compat_sys_setsockopt
542	x32	getsockopt		__x32_compat_sys_getsockopt
543	x32	io_setup		__x32_compat_sys_io_setup
544	x32	io_submit		__x32_compat_sys_io_submit
545	x32	execveat		__x32_compat_sys_execveat/ptregs
546	x32	preadv2			__x32_compat_sys_preadv64v2
547	x32	pwritev2		__x32_compat_sys_pwritev64v2

```



### Libc 이용한 syscall

#### libc

```c
 1   #include<stdio.h>
 2   int main(void){
 3        printf("hello, World!\n");
 4        return 0;
 5   }


$ file ./hello
./hello: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=60609435bfceccbbf3a9f686f9165ff3cd5fe032, for GNU/Linux 3.2.0, with debug_info, not stripped

$ ldd ./hello
	linux-vdso.so.1 (0x00007ffdd6594000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f55e6b45000) <<== C library
	/lib64/ld-linux-x86-64.so.2 (0x00007f55e6d53000                                 
```

#### objdump

```asm
$ objdump -d ./hello
                                 
00000000000011e9 <main>:
    11e9:       f3 0f 1e fa             endbr64 
    11ed:       55                      push   %rbp
    11ee:       48 89 e5                mov    %rsp,%rbp
    11f1:       ff 15 f1 2d 00 00       callq  *0x2df1(%rip)        # 3fe8 <mcount@GLIBC_2.2.5>
    11f7:       48 8d 3d 06 0e 00 00    lea    0xe06(%rip),%rdi        # 2004 <_IO_stdin_used+0x4>
    11fe:       e8 6d fe ff ff          callq  1070 <puts@plt>
    1203:       b8 00 00 00 00          mov    $0x0,%eax
    1208:       5d                      pop    %rbp
    1209:       c3                      retq   
    120a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)


jhyunlee@ubuntu20:~/code/lk/systemcall$ objdump -s -j .rodata hello

hello:     file format elf64-x86-64

Contents of section .rodata:
 2000 01000200 68656c6c 6f2c2057 6f726c64  ....hello, World    <<=== # 2004 address 
 2010 2100
```

* glib: `puts() writes the string s and a trailing newline to stdout`
* 16KB file size 

```sh
-rwxrwxr-x 1 jhyunlee jhyunlee   16696  1월  1 23:50 hello*   
-rw-rw-r-- 1 jhyunlee jhyunlee     488  1월  2 00:15 hello.c
```

* static compile 하면 더 커짐

```
$ gcc -static -o hello hello.c
-rwxrwxr-x 1 jhyunlee jhyunlee  871760  1월  2 00:28 hello*
-rw-rw-r-- 1 jhyunlee jhyunlee      93  1월  2 00:27 hello.c
```



### SYS_write Call 

#### SYS_write

```c
  1 #include<sys/syscall.h>
  2 #include<unistd.h>
  3 int main(void){
  4     syscall(SYS_write, 1,"hello, World!\n",14);
  5     return 0;
  6 }
```

##### objdump -d

```
00000000000011e9 <main>:
    11e9:       f3 0f 1e fa             endbr64 
    11ed:       55                      push   %rbp
    11ee:       48 89 e5                mov    %rsp,%rbp
    11f1:       ff 15 f1 2d 00 00       callq  *0x2df1(%rip)        # 3fe8 <mcount@GLIBC_2.2.5>
    11f7:       b9 0e 00 00 00          mov    $0xe,%ecx            <<----14bytes
    11fc:       48 8d 15 01 0e 00 00    lea    0xe01(%rip),%rdx        # 2004 <_IO_stdin_used+0x4>
    1203:       be 01 00 00 00          mov    $0x1,%esi             <----- fd 번호 1번 
    1208:       bf 01 00 00 00          mov    $0x1,%edi             
    120d:       b8 00 00 00 00          mov    $0x0,%eax
    1212:       e8 69 fe ff ff          callq  1080 <syscall@plt>  
    1217:       b8 00 00 00 00          mov    $0x0,%eax
    121c:       5d                      pop    %rbp
    121d:       c3                      retq   
    121e:       66 90                   xchg   %ax,%ax

```



##### $ gcc -g -static   -o hello_sys hello_sys.c

* main 함수 찾기

```
0000000000401ce5 <main>:
  401ce5:       f3 0f 1e fa             endbr64 
  401ce9:       55                      push   %rbp
  401cea:       48 89 e5                mov    %rsp,%rbp
  401ced:       b9 0e 00 00 00          mov    $0xe,%ecx                <---- 0xE 14 byte 
  401cf2:       48 8d 15 0b 33 09 00    lea    0x9330b(%rip),%rdx        # 495004 <_IO_stdin_used+0x4>
  401cf9:       be 01 00 00 00          mov    $0x1,%esi                <------syscall fd 번호 1번
  401cfe:       bf 01 00 00 00          mov    $0x1,%edi                 
  401d03:       b8 00 00 00 00          mov    $0x0,%eax
  401d08:       e8 03 76 04 00          callq  449310 <syscall>
  401d0d:       b8 00 00 00 00          mov    $0x0,%eax
  401d12:       5d                      pop    %rbp
  401d13:       c3                      retq   
  401d14:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
  401d1b:       00 00 00 
  401d1e:       66 90                   xchg   %ax,%ax

```



* syscall 함수
* syscall(SYS_write, 1,"hello, World!\n",14);
* 함수 매개 변수 전달 순서는 Calling Convention에 따라서 뒤에서 부터 전달..
* main 

```
0000000000449310 <syscall>:
  449310:       f3 0f 1e fa             endbr64 
  449314:       48 89 f8                mov    %rdi,%rax  #SYS_write -> %rax
  449317:       48 89 f7                mov    %rsi,%rdi  #1--> %rdi
  44931a:       48 89 d6                mov    %rdx,%rsi  #"hello world"  --> %rsi
  44931d:       48 89 ca                mov    %rcx,%rdx  # 14 ---> %rdx
  449320:       4d 89 c2                mov    %r8,%r10
  449323:       4d 89 c8                mov    %r9,%r8
  449326:       4c 8b 4c 24 08          mov    0x8(%rsp),%r9
  44932b:       0f 05                   syscall 
  44932d:       48 3d 01 f0 ff ff       cmp    $0xfffffffffffff001,%rax
  449333:       73 01                   jae    449336 <syscall+0x26>
  449335:       c3                      retq   
  449336:       48 c7 c1 c0 ff ff ff    mov    $0xffffffffffffffc0,%rcx
  44933d:       f7 d8                   neg    %eax
  44933f:       64 89 01                mov    %eax,%fs:(%rcx)
  449342:       48 83 c8 ff             or     $0xffffffffffffffff,%rax
  449346:       c3                      retq   
  449347:       66 0f 1f 84 00 00 00    nopw   0x0(%rax,%rax,1)
  44934e:       00 00 


```

* syscall argemtn passing 

       Arch/ABI      arg1  arg2  arg3  arg4  arg5  arg6  arg7  Notes
       ──────────────────────────────────────────────────────────────
       x86-64        rdi   rsi   rdx   r10   r8    r9    -


### Assembly 

```
$ gcc -S hello_sys.c
$ mv hello_sys.s hello_sys.S
gcc -o hello_sys hello_sys.S -no-pie
$ ./hello_sys
hello, World!
```

#### syscall 

```asm
  	.file	"hello_sys.c"
	.section	.rodata
hello:
	.string	"hello, World!\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp

    ## write
	movl	$14, %ecx
	movl	$hello, %edx
	movl	$1, %esi
	movl	$1, %edi
	movl	$0, %eax
	call	syscall

    ## exit 0
	movl	$0, %eax
	popq	%rbp
	ret
.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
```

##### objdump 

* main 함수

```
0000000000401126 <main>:
  401126:       55                      push   %rbp
  401127:       48 89 e5                mov    %rsp,%rbp
  40112a:       b9 0e 00 00 00          mov    $0xe,%ecx
  40112f:       ba 04 20 40 00          mov    $ㅂ,%edx
  401134:       be 01 00 00 00          mov    $0x1,%esi
  401139:       bf 01 00 00 00          mov    $0x1,%edi
  40113e:       b8 00 00 00 00          mov    $0x0,%eax
  401143:       e8 e8 fe ff ff          callq  401030 <syscall@plt>   <<=== 401030 주소는 아래 "hello..."
  401148:       b8 00 00 00 00          mov    $0x0,%eax
  40114d:       5d                      pop    %rbp
  40114e:       c3                      retq   
  40114f:       90                      nop


$ objdump -s -j .rodata  hello_sys 

hello_sys:     file format elf64-x86-64

Contents of section .rodata:
 402000 01000200 68656c6c 6f2c2057 6f726c64  ....hello, World
 402010 210a00                               !.. 
```



### SYS_call by assembly

#### direct SYS_write call

```asm
#include <asm/unistd.h>
#include <syscall.h>
	.file	"hello_sys.c"
	.section	.rodata
hello:
	.string	"hello, World!\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp

    ## write
	movl	$14, %edx
	movl	$hello, %esi
	movl	$1, %edi
	movl	$SYS_write, %eax
	syscall

    ## exit 0
	movl	$0, %eax
	popq	%rbp
	ret
.size	main, .-main
	.section	.note.GNU-stack,"",@progbits

```

* compile 

```
$ rm hello_sys
jhyunlee@ubuntu20:~/code/lk/systemcall$ gcc -o hello_sys hello_sys.S -no-pie
jhyunlee@ubuntu20:~/code/lk/systemcall$ ./hello_sys 
hello, World!
$ ll -l hello_sys
-rwxrwxr-x 1 jhyunlee jhyunlee 16224  1월  2 00:58 hello_sys*
```

* objdump

```
0000000000401106 <main>:
  401106:       55                      push   %rbp        <---- 모든 함수의 시작은 stack에 bp push
  401107:       48 89 e5                mov    %rsp,%rbp
  40110a:       ba 0e 00 00 00          mov    $0xe,%edx   <------- oxE ==> 14
  40110f:       be 04 20 40 00          mov    $0x402004,%esi    <------- "hello world 주소"
  401114:       bf 01 00 00 00          mov    $0x1,%edi       <<------1 
  401119:       b8 01 00 00 00          mov    $0x1,%eax
  40111e:       0f 05                   syscall 
  401120:       b8 00 00 00 00          mov    $0x0,%eax
  401125:       5d                      pop    %rbp
  401126:       c3                      retq   
  401127:       66 0f 1f 84 00 00 00    nopw   0x0(%rax,%rax,1)
  40112e:       00 00
```



#### SYS_write call

```asm
#include <asm/unistd.h>
#include <syscall.h>
	.file	"hello_sys.c"
	.section	.rodata
hello:
	.string	"hello, World!\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp

    ## write
	movl	$14, %edx
	movl	$hello, %esi
	movl	$1, %edi
	movl	$SYS_write, %eax
	syscall

    ## exit 0
	movl	$0, %edi
	movl    $SYS_exit, %eax
	syscall 

.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
```



* compile & objdump

```
jhyunlee@ubuntu20:~/code/lk/systemcall$ objdump -d hello_sys.o

hello_sys.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	ba 0e 00 00 00       	mov    $0xe,%edx
   9:	be 00 00 00 00       	mov    $0x0,%esi
   e:	bf 01 00 00 00       	mov    $0x1,%edi
  13:	b8 01 00 00 00       	mov    $0x1,%eax
  18:	0f 05                	syscall 
  1a:	bf 00 00 00 00       	mov    $0x0,%edi
  1f:	b8 3c 00 00 00       	mov    $0x3c,%eax
  24:	0f 05                	syscall
```

* ld

```
jhyunlee@ubuntu20:~/code/lk/systemcall$ ld -o hello_sys hello_sys.o
ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000
jhyunlee@ubuntu20:~/code/lk/systemcall$ ls -l
-rwxrwxr-x 1 jhyunlee jhyunlee    8928  1월  2 01:33 hello_sys
jhyunlee@ubuntu20:~/code/lk/systemcall$ ./hello_sys
hello, World!

```



* objdump 결과

```
jhyunlee@ubuntu20:~/code/lk/systemcall$ objdump -d hello_sys

hello_sys:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <main>:
  401000:	55                   	push   %rbp
  401001:	48 89 e5             	mov    %rsp,%rbp
  401004:	ba 0e 00 00 00       	mov    $0xe,%edx
  401009:	be 00 20 40 00       	mov    $0x402000,%esi
  40100e:	bf 01 00 00 00       	mov    $0x1,%edi
  401013:	b8 01 00 00 00       	mov    $0x1,%eax
  401018:	0f 05                	syscall 
  40101a:	bf 00 00 00 00       	mov    $0x0,%edi
  40101f:	b8 3c 00 00 00       	mov    $0x3c,%eax
  401024:	0f 05                	syscall 
```



* not dynamic link file 

```
$ file hello_sys
hello_sys: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
jhyunlee@ubuntu20:~/code/lk/systemcall$ ldd hello_sys
	동적 실행 파일이 아닙니다
```



#### _start로 수정

* no main -->  _start 위치로 변경

```asm
#include <asm/unistd.h>
#include <syscall.h>
	.file	"hello_sys.c"
	.section	.rodata
hello:
	.string	"hello, World!\n"
	.text
	.globl	_start
	.type	_start, @function
-start:
    ## write
	movl	$14, %edx
	movl	$hello, %esi
	movl	$1, %edi
	movl	$SYS_write, %eax
	syscall

    ## exit 0
	movl	$0, %edi
	movl    $SYS_exit, %eax
	syscall 

.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
```

* compile 

```
$ gcc -c -o hello_sys.o hello_sys.S
$ ld -o hello_sys hello_sys.o

jhyunlee@ubuntu20:~/code/lk/systemcall$ ll -l
-rwxrwxr-x 1 jhyunlee jhyunlee    8896  1월  2 01:46 hello_sys*
```

* readelf 

```
jhyunlee@ubuntu20:~/code/lk/systemcall$ file   hello_sys
hello_sys: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
jhyunlee@ubuntu20:~/code/lk/systemcall$ ldd hello_sys
	동적 실행 파일이 아닙니다
	
jhyunlee@ubuntu20:~/code/lk/systemcall$ readelf -l ./hello_sys
```

* objdump

```
$ objdump -d hello_sys

hello_sys:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <_start>:
  401000:	ba 0e 00 00 00       	mov    $0xe,%edx
  401005:	be 00 20 40 00       	mov    $0x402000,%esi
  40100a:	bf 01 00 00 00       	mov    $0x1,%edi
  40100f:	b8 01 00 00 00       	mov    $0x1,%eax
  401014:	0f 05                	syscall 
  401016:	bf 00 00 00 00       	mov    $0x0,%edi
  40101b:	b8 3c 00 00 00       	mov    $0x3c,%eax
  401020:	0f 05                	syscall 

```



#### C 코드로 다시...

```c
#include <unistd.h>
#include<sys/syscall.h>

int main (void){
    syscall(SYS_write,1,"hello world\n",14);
    syscall(SYS_exit,0);
}
```















### uftrace code

```c
       #define _GNU_SOURCE
       #include <unistd.h>
       #include <sys/syscall.h>
       #include <sys/types.h>
       #include <signal.h>

       int
       main(int argc, char *argv[])
       {
           pid_t tid;

           tid = syscall(SYS_gettid);
           syscall(SYS_tgkill, getpid(), tid, SIGHUP);
       }
```

$ gcc -g -pg -o scall syscall.c

#### uftrace

```
$ sudo uftrace record  -K 30 ./scall
$ sudo uftrace tui  -t 8us  -N smp_apic_timer_interrupt@kernel
$ uftrace dump --flame-graph | ./flamegraph.pl > out.svg
```

![](out.svg)



#### write

```
NAME
       write - write to a file descriptor
SYNOPSIS
       #include <unistd.h>
       ssize_t write(int fd, const void *buf, size_t count);

```

##### write.c

```c
#include <unistd.h>
void main(){
    write(1, "HELLO\n",6);
}
```



```sh
jhyunlee@ubuntu20:~/code/lk/systemcall$ gcc -g -pg  -o write write.c
jhyunlee@ubuntu20:~/code/lk/systemcall$ ./write
jhyunlee@ubuntu20:~/code/lk/systemcall$ strace ./write
execve("./write", ["./write"], 0x7ffc915e1e70 /* 64 vars */) = 0
brk(NULL)                               = 0x55a1ee34f000
arch_prctl(0x3001 /* ARCH_??? */, 0x7ffcc08fc360) = -1 EINVAL (부적절한 인수)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (그런 파일이나 디렉터리가 없습니다)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=80061, ...}) = 0
mmap(NULL, 80061, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fb8a9c2c000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360q\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
fstat(3, {st_mode=S_IFREG|0755, st_size=2029224, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fb8a9c2a000
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
mmap(NULL, 2036952, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fb8a9a38000
mprotect(0x7fb8a9a5d000, 1847296, PROT_NONE) = 0
mmap(0x7fb8a9a5d000, 1540096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x25000) = 0x7fb8a9a5d000
mmap(0x7fb8a9bd5000, 303104, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19d000) = 0x7fb8a9bd5000
mmap(0x7fb8a9c20000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e7000) = 0x7fb8a9c20000
mmap(0x7fb8a9c26000, 13528, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fb8a9c26000
close(3)                                = 0
arch_prctl(ARCH_SET_FS, 0x7fb8a9c2b540) = 0
mprotect(0x7fb8a9c20000, 12288, PROT_READ) = 0
mprotect(0x55a1ec58a000, 4096, PROT_READ) = 0
mprotect(0x7fb8a9c6d000, 4096, PROT_READ) = 0
munmap(0x7fb8a9c2c000, 80061)           = 0
brk(NULL)                               = 0x55a1ee34f000
brk(0x55a1ee370000)                     = 0x55a1ee370000
rt_sigaction(SIGPROF, {sa_handler=0x7fb8a9b5cd50, sa_mask=~[], sa_flags=SA_RESTORER|SA_RESTART|SA_SIGINFO, sa_restorer=0x7fb8a9a7e210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
setitimer(ITIMER_PROF, {it_interval={tv_sec=0, tv_usec=10000}, it_value={tv_sec=0, tv_usec=10000}}, {it_interval={tv_sec=0, tv_usec=0}, it_value={tv_sec=0, tv_usec=0}}) = 0
write(1, "HELLO\n", 6HELLO
)                  = 6
setitimer(ITIMER_PROF, {it_interval={tv_sec=0, tv_usec=0}, it_value={tv_sec=0, tv_usec=0}}, NULL) = 0
rt_sigaction(SIGPROF, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7fb8a9a7e210}, NULL, 8) = 0
openat(AT_FDCWD, "gmon.out", O_WRONLY|O_CREAT|O_TRUNC|O_NOFOLLOW, 0666) = 3
write(3, "gmon\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 20) = 20
writev(3, [{iov_base="\0", iov_len=1}, {iov_base="\240\20\0\0\0\0\0\0\264\22\0\0\0\0\0\0\210\0\0\0d\0\0\0seconds\0"..., iov_len=40}, {iov_base="\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., iov_len=272}], 3) = 313
close(3)                                = 0
exit_group(6)                           = ?
+++ exited with 6 +++

```



![](write.svg)





#### radare2 

``` asm
jhyunlee@ubuntu20:~/code/lk/systemcall$ radare2 -d  ./write
Process with PID 399453 started...
= attach 399453 399453
bin.baddr 0x562e9e2b7000
Using 0x562e9e2b7000
asm.bits 64
[0x7fb2dfe84100]> s sym.main
[0x562e9e2b81e9]> pd
            ;-- main:
            0x562e9e2b81e9      f3             invalid
            0x562e9e2b81ea      0f             invalid
            0x562e9e2b81eb      1e             invalid
            0x562e9e2b81ec      fa             cli
            0x562e9e2b81ed      55             push rbp
            0x562e9e2b81ee      4889e5         mov rbp, rsp
            0x562e9e2b81f1      ff15f12d0000   call qword [reloc.mcount] ; [0x562e9e2bafe8:8]=0
            0x562e9e2b81f7      ba06000000     mov edx, 6
            0x562e9e2b81fc      488d35010e00.  lea rsi, qword str.HELLO ; 0x562e9e2b9004 ; "HELLO\n"
            0x562e9e2b8203      bf01000000     mov edi, 1
            0x562e9e2b8208      e863feffff     call sym.imp.write
            0x562e9e2b820d      90             nop
            0x562e9e2b820e      5d             pop rbp
            0x562e9e2b820f      c3             ret
            ;-- __libc_csu_init:
            0x562e9e2b8210      f3             invalid
            0x562e9e2b8211      0f             invalid
            0x562e9e2b8212      1e             invalid
            0x562e9e2b8213      fa             cli
            0x562e9e2b8214      4157           push r15
            0x562e9e2b8216      4c8d3d832b00.  lea r15, qword obj.__frame_dummy_init_array_entry ; loc.__init_array_start
                                                                       ; 0x562e9e2bada0
            0x562e9e2b821d      4156           push r14
            0x562e9e2b821f      4989d6         mov r14, rdx
            0x562e9e2b8222      4155           push r13
            0x562e9e2b8224      4989f5         mov r13, rsi
            0x562e9e2b8227      4154           push r12
            0x562e9e2b8229      4189fc         mov r12d, edi
            0x562e9e2b822c      55             push rbp
            0x562e9e2b822d      488d2d742b00.  lea rbp, qword obj.__do_global_dtors_aux_fini_array_entry ; loc.__init_array_end
                                                                       ; 0x562e9e2bada8
            0x562e9e2b8234      53             push rbx
            0x562e9e2b8235      4c29fd         sub rbp, r15
            0x562e9e2b8238      4883ec08       sub rsp, 8
            0x562e9e2b823c      e8bffdffff     call map.home_jhyunlee_code_lk_systemcall_write.r_x
            0x562e9e2b8241      48c1fd03       sar rbp, 3
        ┌─< 0x562e9e2b8245      741f           je 0x562e9e2b8266
        │   0x562e9e2b8247      31db           xor ebx, ebx
        │   0x562e9e2b8249      0f1f80000000.  nop dword [rax]
       ┌──> 0x562e9e2b8250      4c89f2         mov rdx, r14
       ╎│   0x562e9e2b8253      4c89ee         mov rsi, r13
       ╎│   0x562e9e2b8256      4489e7         mov edi, r12d
       ╎│   0x562e9e2b8259      41ff14df       call qword [r15 + rbx*8]
       ╎│   0x562e9e2b825d      4883c301       add rbx, 1
       ╎│   0x562e9e2b8261      4839dd         cmp rbp, rbx
       └──< 0x562e9e2b8264      75ea           jne 0x562e9e2b8250
        └─> 0x562e9e2b8266      4883c408       add rsp, 8
            0x562e9e2b826a      5b             pop rbx
            0x562e9e2b826b      5d             pop rbp
            0x562e9e2b826c      415c           pop r12
            0x562e9e2b826e      415d           pop r13
            0x562e9e2b8270      415e           pop r14
            0x562e9e2b8272      415f           pop r15
            0x562e9e2b8274      c3             ret
            0x562e9e2b8275      66662e0f1f84.  nop word cs:[rax + rax]
            ;-- __libc_csu_fini:
            0x562e9e2b8280      f3             invalid
            0x562e9e2b8281      0f             invalid
            0x562e9e2b8282      1e             invalid
            0x562e9e2b8283      fa             cli
            0x562e9e2b8284      c3             ret
            0x562e9e2b8285      662e0f1f8400.  nop word cs:[rax + rax]
            0x562e9e2b828f      90             nop
            ;-- atexit:
            0x562e9e2b8290      f3             invalid
            0x562e9e2b8291      0f             invalid
            0x562e9e2b8292      1e             invalid
            0x562e9e2b8293      fa             cli
            0x562e9e2b8294      488b156d2d00.  mov rdx, qword [obj.__dso_handle] ; [0x562e9e2bb008:8]=0x4008

```



```
[0x7fb2dfe84100]> s sym.main
[0x562e9e2b81e9]> pd
[0x55ff7d2c01e9]> db 0x55ff7d2c0208
[0x55ff7d2c01e9]> v!
```

