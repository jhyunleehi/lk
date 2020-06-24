# Linux Kernel Debug

## ubuntu config
####
```
$ uname -a
Linux good-VirtualBox 5.3.0-59-generic #53~18.04.1-Ubuntu SMP Thu Jun 4 14:58:26 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
```
## /etc/apt/sources.list
```
$ cat /etc/apt/sources.list | grep  -v "#"
deb http://kr.archive.ubuntu.com/ubuntu/ bionic main restricted
deb http://kr.archive.ubuntu.com/ubuntu/ bionic-updates main restricted
deb http://kr.archive.ubuntu.com/ubuntu/ bionic universe
deb http://kr.archive.ubuntu.com/ubuntu/ bionic-updates universe
deb http://kr.archive.ubuntu.com/ubuntu/ bionic multiverse
deb http://kr.archive.ubuntu.com/ubuntu/ bionic-updates multiverse
deb http://kr.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu bionic-security main restricted
deb http://security.ubuntu.com/ubuntu bionic-security universe
deb http://security.ubuntu.com/ubuntu bionic-security multiverse
```

## Kernel cross-compiling

```
$ uname -a
Linux good-VirtualBox 5.3.0-59-generic #53~18.04.1-Ubuntu SMP Thu Jun 4 14:58:26 UTC 2020 x86_64 

$ sudo apt install git bc bison flex libssl-dev make
$ mkdir ~/code && cd ~/code
$ git clone --depth=1 --branch rpi-4.19.y https://github.com/raspberrypi/linux

# wget https://downloads.raspberrypi.org/raspios_lite_armhf_latest.zip
# unzip raspios_lite_armhf_latest.zip

$ sudo apt install git bc bison flex libssl-dev make libc6-dev libncurses5-dev
$ git clone https://github.com/raspberrypi/tools ~/tools
$ echo PATH=\$PATH:~/tools/arm-bcm2708/arm-linux-gnueabihf/bin >> ~/.bashrc
$ echo export KERNEL=kernel7 >> ~/.bashrc
$ source ~/.bashrc

$ vi env.sh
#!/bin/sh
export PATH=~/tools/arm-bcm2708/arm-linux-gnueabihf/bin:$PATH
export KERNEL=kernel7
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-


$ cd ~/code/linux
$ KERNEL=kernel
# For Pi 1, Pi Zero, Pi Zero W, or Compute Module:
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig 
# For Pi 2, Pi 3, Pi 3+, or Compute Module 3:
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
# For Raspberry Pi 4:
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
# all platform
$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs

$ cat ~/code/linux/build.sh
#!/bin/sh
OUTPUT="~/code/out"
KERNEL=kernel7
make ARCH=arm O=$OUTPUT CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
make ARCH=arm O=$OUTPUT CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs  -j3

$ make menuconfig 
Kernel hacking --> Compile-time checks and compiler option --> 
            Compile the kernel with debug info --> Enable
            Generate dwarf4 debuginfo --> Enable
            Provide GDB scripts for kernel debuffing--> Enable


$ build.sh
# 커널과  device tree  파일 추출
$ ~/code/linux/scripts/mkknlimg arch/arm/boot/zImage ~/rpi3/kernel7.img
$ cp arch/arm/boot/dts/bcm2709-rpi-2-b.dtb ~/rpi3

$ vi ~/rpi3/run_qemu.sh
#!/bin/sh
BOOT_CMDLINE="rw earlyprintk loglevel=8 console=ttyAMA0,115200 console=tty1 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2"
DTB_FILE="bcm2709-rpi-2-b.dtb"
KERNEL_IMG="kernel7.img"
SD_IMG="raspbian-jessie.img"

echo "target remote localhost:1234"
qemu-system-arm -s -S -M raspi2 \
    -kernel ${KERNEL_IMG} \
    -sd ${SD_IMG} \
    -append "${BOOT_CMDLINE}" \
    -dtb ${DTB_FILE} -serial stdio

$ source env.sh
$ cd ~/kernel/linux/
$ ddd --debugger arm-linux-gnueabihf-gdb ./vmlinux

# GDB shell에서 target remote localhost:1234 명령을 친다.
(gdb) target remote localhost:1234

# start_kernel 에 브레이크 포인트 셋팅
(gdb) b start_kernel

# 디버깅 시작.
(gdb) c

```
### 컴파일 결과 
```

$ ls -l ~/code/out/arch/arm/boot/dts/bcm2709-rpi-2-b.dtb
-rw-r--r-- 1 good good 25334  6월 20 00:53 ~/code/out/arch/arm/boot/dts/bcm2709-rpi-2-b.dtb

$ ls -l ~/code/out/arch/arm/boot/zImage 
-rwxr-xr-x 1 good good 5470168  6월 20 01:01 ~/code/out/arch/arm/boot/zImage

$ ls -l ~/code/out/arch/arm/boot/zImage 
-rwxr-xr-x 1 good good 5470168  6월 20 01:01 ~/code/out/arch/arm/boot/zImage
```


### qemu
```
$ vi ~/git/pi2/run_qemu.sh
#!/bin/sh

BOOT_CMDLINE="rw earlyprintk loglevel=8 console=ttyAMA0,115200 console=tty1 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2"
DTB_FILE="bcm2709-rpi-2-b.dtb"
KERNEL_IMG="kernel7.img"
SD_IMG="raspbian-jessie.img"

echo "target remote localhost:1234"
qemu-system-arm -s -S -M raspi2 \
    -kernel ${KERNEL_IMG} \
    -sd ${SD_IMG} \
    -append "${BOOT_CMDLINE}" \
    -dtb ${DTB_FILE} -serial stdio
```

### ddd

```
$ source env.sh
$ cd ~/code/linux/
$ ddd --debugger arm-linux-gnueabihf-gdb ./vmlinux

# GDB shell에서 target remote localhost:1234 명령을 친다.
(gdb) target remote localhost:1234

# start_kernel 에 브레이크 포인트 셋팅
(gdb) b start_kernel

# 디버깅 시작.
(gdb) c
```


### locale 설정

```
root@raspberry:~# raspi-config
```

```
[*] en_GB.UTF-8 
[*] en_US.UTF-8 UTF-8 
[*] ko_KR.UTF-8 UTF-8
```

한글 폰트 설치
```
# apt-get update
# apt-get upgrade
# apt-get install ibus
# apt-get install ibus-hangul
# apt-get install korean *
```

##  kernel build


설치가이드: <https://www.raspberrypi.org/documentation/linux/kernel/building.md>

### local building

```
# sudo apt install git bc bison flex libssl-dev make
# git clone --depth=1 https://github.com/raspberrypi/linux
# git branch
* rpi-4.19.y

```

### kernel config

x86환경
```
# cd linux
# KERNEL=kernel7
# make x86_64_defconfig   //x86_64
# make bcm2711_defconfig  //raspberry pi 4

```
### x86_64 컴파일 
```
# lscpu
# sudo apt install git bc bison flex libssl-dev make
# git clone --depth=1 -b v4.19 https://github.com/torvalds/linux.git
# apt install libelf-dev, libelf-devel or elfutils-libelf-devel
# sudo  apt install libelf-dev
# sudo  apt install libelf-devel
# sudo  apt install elfutils-libelf-devel
# make -j4 bzImage  modules 
# sudo make modules_install
```


### Raspberry Pi Emulator for Windows 10
출처: <https://mystarlight.tistory.com/90>

windows용 QEMU :  <https://qemu.weilnetz.de/w64/>



# Debian img에서 kernel과 device Tree 구성
## QEMU compile
```
$ git clone https://github.com/0xabu/qemu.git -b raspi
$ git submodule update --init dtc
$ ./configure
$ make -j$(nproc)
$ sudo make install
```

## debian image wget

```
$ wget http://downloads.raspberrypi.org/raspbian/images/raspbian-2015-11-24/2015-11-21-raspbian-jessie.zip
$ sudo /sbin/fdisk -lu 2015-11-21-raspbian-jessie.img
Disk 2015-11-21-raspbian-jessie.img: 3.7 GiB, 3934257152 bytes, 7684096 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xea0e7380

Device                          Boot  Start     End Sectors  Size Id Type
2015-11-21-raspbian-jessie.img1        8192  131071  122880   60M  c W95 FAT32 (LBA)
2015-11-21-raspbian-jessie.img2      131072 7684095 7553024  3.6G 83 Linux
```

## kernel7.img, Device tree 파일 추출
- P0의 start 주소는 8192, Sector size 512
- Offset 계산: 8192 * 512 = 4194304

```
$ mkdir tmp
$ sudo mount -o loop,offset=4194304 2015-11-21-raspbian-jessie.img tmp
$ mkdir 2015-11-21-raspbian-boot
$ cp tmp/kernel7.img 2015-11-21-raspbian-boot
$ cp tmp/bcm2709-rpi-2-b.dtb 2015-11-21-raspbian-boot
```
## Boot Rapbian

```
qemu-system-arm -M raspi2 -kernel 2015-11-21-raspbian-boot/kernel7.img \
-sd 2015-11-21-raspbian-jessie.img \
-append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2" \
-dtb 2015-11-21-raspbian-boot/bcm2709-rpi-2-b.dtb -serial stdio
```
- 아이디 : pi 
- 비밀번호 : raspberry

## booting 
```
#!/bin/sh
qemu-system-arm -M raspi2 -kernel kernel7.img \
-sd 2015-11-21-raspbian-jessie.img \
-append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2" \
-dtb bcm2709-rpi-2-b.dtb -serial stdio
good@good-VirtualBox:~/rpi2$ sh run_qemu.sh 
WARNING: Image format was not specified for '2015-11-21-raspbian-jessie.img' and probing guessed raw.
         Automatically detecting the format is dangerous for raw images, write operations on block 0 will be restricted.
         Specify the 'raw' format explicitly to remove the restrictions.
Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0xf00
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.1.13-v7+ (dc4@dc4-XPS13-9333) (gcc version 4.8.3 20140303 (prerelease) (crosstool-NG linaro-1.13.1+bzr2650 - Linaro GCC 2014.03) ) #826 SMP PREEMPT Fri Nov 13 20:19:03 GMT 2015
[    0.000000] CPU: ARMv7 Processor [412fc0f1] revision 1 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine model: Raspberry Pi 2 Model B
[    0.000000] cma: Reserved 8 MiB at 0x3b800000
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] On node 0 totalpages: 245760
[    0.000000] free_area_init_node: node 0, pgdat 8085f000, node_mem_map baf82000
[    0.000000]   Normal zone: 2160 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 245760 pages, LIFO batch:31
[    0.000000] [bcm2709_smp_init_cpus] enter (9420->f3003010)
[    0.000000] [bcm2709_smp_init_cpus] ncores=4
[    0.000000] PERCPU: Embedded 13 pages/cpu @baf41000 s20608 r8192 d24448 u53248
[    0.000000] pcpu-alloc: s20608 r8192 d24448 u53248 alloc=13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243600
[    0.000000] Kernel command line: rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 955712K/983040K available (5967K kernel code, 534K rwdata, 1652K rodata, 420K init, 757K bss, 19136K reserved, 8192K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
[    0.000000]     vmalloc : 0xbc800000 - 0xff000000   (1064 MB)
[    0.000000]     lowmem  : 0x80000000 - 0xbc000000   ( 960 MB)
[    0.000000]     modules : 0x7f000000 - 0x80000000   (  16 MB)
[    0.000000]       .text : 0x80008000 - 0x80778f64   (7620 kB)
[    0.000000]       .init : 0x80779000 - 0x807e2000   ( 420 kB)
[    0.000000]       .data : 0x807e2000 - 0x80867b6c   ( 535 kB)
[    0.000000]        .bss : 0x8086a000 - 0x8092779c   ( 758 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:608
[    0.000000] Architected cp15 timer(s) running at 19.20MHz (virt).
[    0.000000] clocksource arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x46d987e47, max_idle_ns: 440795202767 ns
[    0.000507] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps every 4398046511078ns
[    0.001146] Switching to timer-based delay loop, resolution 52ns
[    0.031555] Console: colour dummy device 80x30
[    0.033540] Calibrating delay loop (skipped), value calculated using timer frequency.. 38.40 BogoMIPS (lpj=192000)
[    0.034092] pid_max: default: 32768 minimum: 301
[    0.043503] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.043790] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.085707] Initializing cgroup subsys blkio
[    0.086099] Initializing cgroup subsys memory
[    0.087063] Initializing cgroup subsys devices
[    0.087692] Initializing cgroup subsys freezer
[    0.088151] Initializing cgroup subsys net_cls
[    0.089674] CPU: Testing write buffer coherency: ok
[    0.096044] ftrace: allocating 20235 entries in 60 pages
[    0.358429] CPU0: update cpu_capacity 1024
[    0.359286] CPU0: thread -1, cpu 0, socket 15, mpidr 80000f00
[    0.359828] [bcm2709_smp_prepare_cpus] enter
[    0.366379] Setting up static identity map for 0x8240 - 0x8274
[    0.455359] [bcm2709_boot_secondary] cpu:1 failed to start (9420)
[    0.457026] [bcm2709_secondary_init] enter cpu:1
[    0.459411] CPU1: update cpu_capacity 1024
[    0.459463] CPU1: thread -1, cpu 1, socket 15, mpidr 80000f01
[    0.487454] [bcm2709_boot_secondary] cpu:2 started (0) 3
[    0.487654] [bcm2709_secondary_init] enter cpu:2
[    0.487991] CPU2: update cpu_capacity 1024
[    0.488027] CPU2: thread -1, cpu 2, socket 15, mpidr 80000f02
[    0.513120] [bcm2709_boot_secondary] cpu:3 failed to start (9420)
[    0.513282] [bcm2709_secondary_init] enter cpu:3
[    0.513564] CPU3: update cpu_capacity 1024
[    0.513600] CPU3: thread -1, cpu 3, socket 15, mpidr 80000f03
[    0.514446] Brought up 4 CPUs
[    0.514779] SMP: Total of 4 processors activated (153.60 BogoMIPS).
[    0.514933] CPU: All CPU(s) started in SVC mode.
[    0.558459] devtmpfs: initialized
[    0.685283] VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
[    0.727324] clocksource jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.798179] pinctrl core: initialized pinctrl subsystem
[    0.827006] NET: Registered protocol family 16
[    0.886093] DMA: preallocated 4096 KiB pool for atomic coherent allocations
[    0.898956] bcm2709.uart_clock = 3000000
[    0.954790] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[    0.955109] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.958341] Serial: AMBA PL011 UART driver
[    0.971999] 3f201000.uart: ttyAMA0 at MMIO 0x3f201000 (irq = 83, base_baud = 0) is a PL011 rev2
[    1.013663] console [ttyAMA0] enabled
[    1.039548] bcm2835-mbox 3f00b880.mailbox: mailbox enabled
[    1.349086] bcm2708-dmaengine 3f007000.dma: DMA legacy API manager at f3007000, dmachans=0xf35
[    1.352293] bcm2708-dmaengine 3f007000.dma: Initialized 7 DMA channels (+ 1 legacy)
[    1.358260] bcm2708-dmaengine 3f007000.dma: Load BCM2835 DMA engine driver
[    1.358872] bcm2708-dmaengine 3f007000.dma: dma_debug:0
[    1.366400] SCSI subsystem initialized
[    1.369336] usbcore: registered new interface driver usbfs
[    1.370773] usbcore: registered new interface driver hub
[    1.373932] usbcore: registered new device driver usb
[    1.390472] raspberrypi-firmware soc:firmware: Attached to firmware from 1970-01-05 00:12
[    1.429966] Switched to clocksource arch_sys_counter
[    1.713823] FS-Cache: Loaded
[    1.719121] CacheFiles: Loaded
[    1.844246] NET: Registered protocol family 2
[    1.877908] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    1.880041] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    1.881283] TCP: Hash tables configured (established 8192 bind 8192)
[    1.884146] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    1.885000] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    1.892511] NET: Registered protocol family 1
[    1.902821] RPC: Registered named UNIX socket transport module.
[    1.905033] RPC: Registered udp transport module.
[    1.905491] RPC: Registered tcp transport module.
[    1.905822] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.961245] hw perfevents: enabled with armv7_cortex_a7 PMU driver, 1 counters available
[    1.979005] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    2.085245] VFS: Disk quotas dquot_6.6.0
[    2.088663] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.103947] FS-Cache: Netfs 'nfs' registered for caching
[    2.114518] NFS: Registering the id_resolver key type
[    2.117958] Key type id_resolver registered
[    2.119183] Key type id_legacy registered
[    2.186812] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.192567] io scheduler noop registered
[    2.193137] io scheduler deadline registered
[    2.195113] io scheduler cfq registered (default)
[    2.222563] BCM2708FB: allocated DMA memory fbc00000
[    2.224179] BCM2708FB: allocated DMA channel 0 @ f3007000
[    2.316436] Console: switching to colour frame buffer device 100x30
[    2.353849] Serial: 8250/16550 driver, 0 ports, IRQ sharing disabled
[    2.407620] vc-cma: Videocore CMA driver
[    2.408560] vc-cma: vc_cma_base      = 0x00000000
[    2.408951] vc-cma: vc_cma_size      = 0x00000000 (0 MiB)
[    2.409345] vc-cma: vc_cma_initial   = 0x00000000 (0 MiB)
[    2.414796] vc-mem: phys_addr:0x00000000 mem_base=0x00000000 mem_size:0x00000000(0 MiB)
[    2.589944] brd: module loaded
[    2.649446] loop: module loaded
[    2.658717] vchiq: vchiq_init_state: slot_zero = 0xbbc80000, is_master = 0
[    2.670206] bcm2835_vchiq 3f00b840.vchiq: failed to set channelbase
[    2.684430] vchiq: could not load vchiq
[    2.693987] bcm2835_vchiq: probe of 3f00b840.vchiq failed with error -1174190848
[    2.695484] Loading iSCSI transport class v2.0-870.
[    2.703583] usbcore: registered new interface driver smsc95xx
[    2.704526] dwc_otg: version 3.00a 10-AUG-2012 (platform bus)
[    2.932750] Core Release: 0.000
[    2.933785] Setting default values for core params
[    2.940734] Finished setting default values for core params
[    2.941891] dwc_otg 3f980000.usb: Bad value for SNPSID: 0x00000000
[    2.942755] dwc_otg: probe of 3f980000.usb failed with error -22
[    2.943920] dwc_otg: FIQ enabled
[    2.944246] dwc_otg: NAK holdoff enabled
[    2.944568] dwc_otg: FIQ split-transaction FSM enabled
[    2.945415] Module dwc_common_port init
[    2.949364] usbcore: registered new interface driver usb-storage
[    2.952708] mousedev: PS/2 mouse device common for all mice
[    2.964135] bcm2835-cpufreq: min=700000 max=700000
[    2.970803] sdhci: Secure Digital Host Controller Interface driver
[    2.971460] sdhci: Copyright(c) Pierre Ossman
[    2.981139] mmc-bcm2835 3f300000.mmc: mmc_debug:0 mmc_debug2:0
[    2.981974] mmc-bcm2835 3f300000.mmc: DMA channels allocated
[    3.026467] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.047427] ledtrig-cpu: registered to indicate activity on CPUs
[    3.053506] hidraw: raw HID events driver (C) Jiri Kosina
[    3.058188] usbcore: registered new interface driver usbhid
[    3.058848] usbhid: USB HID core driver
[    3.063935] Initializing XFRM netlink socket
[    3.065490] NET: Registered protocol family 17
[    3.069141] Key type dns_resolver registered
[    3.070638] Registering SWP/SWPB emulation handler
[    3.077565] registered taskstats version 1
[    3.084318] vc-sm: Videocore shared memory driver
[    3.107163] mmc0: host does not support reading read-only switch, assuming write-enable
[    3.112444] mmc0: new SDHC card at address 4567
[    3.150047] mmcblk0: mmc0:4567 QEMU! 3.66 GiB 
[    3.150344] uart-pl011 3f201000.uart: no DMA platform data
[    3.201174]  mmcblk0: p1 p2
[    3.255269] EXT4-fs (mmcblk0p2): couldn't mount as ext3 due to feature incompatibilities
[    3.295080] EXT4-fs (mmcblk0p2): couldn't mount as ext2 due to feature incompatibilities
[    6.764127] EXT4-fs (mmcblk0p2): 1 orphan inode deleted
[    6.764791] EXT4-fs (mmcblk0p2): recovery complete
[    6.858772] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    6.874081] VFS: Mounted root (ext4 filesystem) on device 179:2.
[    6.916601] devtmpfs: mounted
[    6.997030] Freeing unused kernel memory: 420K (80779000 - 807e2000)
[   10.052061] random: systemd urandom read with 20 bits of entropy available
[   10.188945] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[   10.204843] systemd[1]: Detected architecture 'arm'.

Welcome to Raspbian GNU/Linux 8 (jessie)!

[   11.559857] NET: Registered protocol family 10
[   11.592881] systemd[1]: Inserted module 'ipv6'
[   11.652593] systemd[1]: Set hostname to <raspberrypi>.
[   18.622241] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[   18.634537] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   18.638315] systemd[1]: Expecting device dev-ttyAMA0.device...
         Expecting device dev-ttyAMA0.device...
[   18.675911] systemd[1]: Starting Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems (Pre).
[   18.684421] systemd[1]: Reached target Remote File Systems (Pre).
[   18.686308] systemd[1]: Starting Encrypted Volumes.
[  OK  ] Reached target Encrypted Volumes.
[   18.693014] systemd[1]: Reached target Encrypted Volumes.
[   18.699917] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[  OK  ] Set up automount Arbitrary Executable File Formats F...utomount Point.
[   18.718426] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   18.720146] systemd[1]: Starting Swap.
[  OK  ] Reached target Swap.
[   18.725228] systemd[1]: Reached target Swap.
[   18.727041] systemd[1]: Expecting device dev-mmcblk0p1.device...
         Expecting device dev-mmcblk0p1.device...
[   18.731834] systemd[1]: Starting Root Slice.
[  OK  ] Created slice Root Slice.
[   18.738885] systemd[1]: Created slice Root Slice.
[   18.740320] systemd[1]: Starting User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[   18.749536] systemd[1]: Created slice User and Session Slice.
[   18.750981] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
[   18.772055] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   18.773555] systemd[1]: Starting Delayed Shutdown Socket.
[  OK  ] Listening on Delayed Shutdown Socket.
[   18.784983] systemd[1]: Listening on Delayed Shutdown Socket.
[   18.786173] systemd[1]: Starting Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket (/dev/log).
[   18.808655] systemd[1]: Listening on Journal Socket (/dev/log).
[   18.813963] systemd[1]: Starting udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[   18.852079] systemd[1]: Listening on udev Control Socket.
[   18.857199] systemd[1]: Starting udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[   18.961458] systemd[1]: Listening on udev Kernel Socket.
[   18.964158] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[   19.095626] systemd[1]: Listening on Journal Socket.
[   19.100281] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[   19.111983] systemd[1]: Created slice System Slice.
[   19.116780] systemd[1]: Started File System Check on Root Device.
[   19.120413] systemd[1]: Starting system-systemd\x2dfsck.slice.
[  OK  ] Created slice system-systemd\x2dfsck.slice.
[   19.131136] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[   19.133091] systemd[1]: Starting system-autologin.slice.
[  OK  ] Created slice system-autologin.slice.
[   19.147033] systemd[1]: Created slice system-autologin.slice.
[   19.152054] systemd[1]: Starting system-serial\x2dgetty.slice.
[  OK  ] Created slice system-serial\x2dgetty.slice.
[   19.166882] systemd[1]: Created slice system-serial\x2dgetty.slice.
[   19.178814] systemd[1]: Starting Increase datagram queue length...
         Starting Increase datagram queue length...
[   19.304172] systemd[1]: Starting Restore / save the current clock...
         Starting Restore / save the current clock...
[   19.794203] systemd[1]: Starting Load Kernel Modules...
         Starting Load Kernel Modules...
[   20.002031] hrtimer: interrupt took 144239583 ns
[   20.264190] systemd[1]: Started Set Up Additional Binary Formats.
[   20.303682] systemd[1]: Starting Create list of required static device nodes for the current kernel...
         Starting Create list of required static device nodes...rrent kernel...
[   20.491044] systemd[1]: Mounting Debug File System...
         Mounting Debug File System...
[   20.944142] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[   21.520401] systemd[1]: Mounted Huge Pages File System.
[   21.525394] systemd[1]: Starting udev Coldplug all Devices...
         Starting udev Coldplug all Devices...
[   22.362854] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[   22.386188] systemd[1]: Reached target Slices.
[  OK  ] Started Increase datagram queue length.
[   23.599852] systemd[1]: Started Increase datagram queue length.
[   23.623771] fuse init (API version 7.23)
[   24.079059] i2c /dev entries driver
[  OK  ] Started Load Kernel Modules.
[   25.263518] systemd[1]: Started Load Kernel Modules.
[  OK  ] Started Create list of required static device nodes ...current kernel.
[   25.452000] systemd[1]: Started Create list of required static device nodes for the current kernel.
[  OK  ] Mounted Debug File System.
[   25.508306] systemd[1]: Mounted Debug File System.
[  OK  ] Mounted POSIX Message Queue File System.
[   25.554150] systemd[1]: Mounted POSIX Message Queue File System.
[  OK  ] Started Restore / save the current clock.
[   26.174997] systemd[1]: Started Restore / save the current clock.
[   26.267718] systemd[1]: Time has been changed
[  OK  ] Started udev Coldplug all Devices.
[   26.952277] systemd[1]: Started udev Coldplug all Devices.
[   27.229549] systemd[1]: Starting Create Static Device Nodes in /dev...
         Starting Create Static Device Nodes in /dev...
[   27.279687] systemd[1]: Mounting FUSE Control File System...
         Mounting FUSE Control File System...
[   27.405900] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[   27.602755] systemd[1]: Mounting Configuration File System...
         Mounting Configuration File System...
[   27.791408] systemd[1]: Starting Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[   27.824731] systemd[1]: Listening on Syslog Socket.
[   27.830217] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[   28.210024] systemd[1]: Started Journal Service.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Mounted FUSE Control File System.
[  OK  ] Mounted Configuration File System.
[  OK  ] Started Create Static Device Nodes in /dev.
         Starting udev Kernel Device Manager...
[  OK  ] Started udev Kernel Device Manager.
         Starting Copy rules generated while the root was ro...
         Starting LSB: Tune IDE hard disks...
         Starting LSB: Set preliminary keymap...
[  OK  ] Started Copy rules generated while the root was ro.
[  OK  ] Started LSB: Tune IDE hard disks.
[  OK  ] Found device /dev/ttyAMA0.
[  OK  ] Found device /dev/mmcblk0p1.
[  OK  ] Started LSB: Set preliminary keymap.
[  OK  ] Reached target Paths.
         Starting Remount Root and Kernel File Systems...
         Starting File System Check on /dev/mmcblk0p1...
[  OK  ] Started Remount Root and Kernel File Systems.
         Starting Load/Save Random Seed...
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Started Load/Save Random Seed.
[   53.928417] systemd-fsck[185]: fsck.fat 3.0.27 (2014-11-12)
[   53.987417] systemd-fsck[185]: 0x25: Dirty bit is set. Fs was not properly unmounted and some data may be corrupt.
[   54.072366] systemd-fsck[185]: Automatically removing dirty bit.
[   54.135461] systemd-fsck[185]: Performing changes.
[   54.163265] systemd-fsck[185]: /dev/mmcblk0p1: 73 files, 2537/7673 clusters
[  OK  ] Started File System Check on /dev/mmcblk0p1.
         Mounting /boot...
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
         Starting Create Volatile Files and Directories...
         Starting Tell Plymouth To Write Out Runtime Data...
         Starting LSB: Raise network interfaces....
[  OK  ] Reached target Remote File Systems.
         Starting Trigger Flushing of Journal to Persistent Storage...
         Starting LSB: Switch to ondemand cpu governor (unles... is pressed)...
         Starting LSB: Prepare console...
[  OK  ] Started Tell Plymouth To Write Out Runtime Data.
[  OK  ] Started Trigger Flushing of Journal to Persistent Storage.
[  OK  ] Started Create Volatile Files and Directories.
         Starting Update UTMP about System Boot/Shutdown...
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Started LSB: Switch to ondemand cpu governor (unless...ey is pressed).
[  OK  ] Started LSB: Prepare console.
         Starting LSB: Set console font and keymap...
[  OK  ] Started LSB: Raise network interfaces..
[  OK  ] Started LSB: Set console font and keymap.
[  OK  ] Reached target System Initialization.
[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Timers.
[  OK  ] Reached target Basic System.
         Starting LSB: Regenerate ssh host keys...
         Starting dhcpcd on all interfaces...
         Starting Regular background program processing daemon...
[  OK  ] Started Regular background program processing daemon.
         Starting Login Service...
         Starting LSB: triggerhappy hotkey daemon...
         Starting LSB: Autogenerate and use a swap file...
         Starting Avahi mDNS/DNS-SD Stack...
         Starting D-Bus System Message Bus...
[  OK  ] Started D-Bus System Message Bus.
[  OK  ] Started Avahi mDNS/DNS-SD Stack.
         Starting System Logging Service...
         Starting Permit User Sessions...
[  OK  ] Started LSB: Regenerate ssh host keys.
[  OK  ] Started dhcpcd on all interfaces.
[  OK  ] Started LSB: triggerhappy hotkey daemon.
[  OK  ] Started Permit User Sessions.
[  OK  ] Started Login Service.
         Starting Light Display Manager...
[  OK  ] Reached target Network.
         Starting OpenBSD Secure Shell server...
[  OK  ] Started OpenBSD Secure Shell server.
         Starting /etc/rc.local Compatibility...
[  OK  ] Reached target Network is Online.
         Starting LSB: Start NTP daemon...
[  OK  ] Started /etc/rc.local Compatibility.
         Starting Wait for Plymouth Boot Screen to Quit...
         Starting Terminate Plymouth Boot Screen...
[  OK  ] Started System Logging Service.
[  OK  ] Started Wait for Plymouth Boot Screen to Quit.
         Starting Getty on tty1...
[  OK  ] Started Getty on tty1.
         Starting Serial Getty on ttyAMA0...
[  OK  ] Started Serial Getty on ttyAMA0.
[  OK  ] Reached target Login Prompts.
[  OK  ] Started LSB: Autogenerate and use a swap file.
[  OK  ] Started Terminate Plymouth Boot Screen.

Raspbian GNU/Linux 8 raspberrypi ttyAMA0

raspberrypi login: pi
Password: 
Last login: Sat Nov 21 21:36:52 UTC 2015 on tty1
Linux raspberrypi 4.1.13-v7+ #826 SMP PREEMPT Fri Nov 13 20:19:03 GMT 2015 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
```