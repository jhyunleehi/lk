# Linux Kernel Debug

## ubuntu config
####
```
$ uname -a
Linux good-VirtualBox 5.3.0-59-generic #53~18.04.1-Ubuntu SMP Thu Jun 4 14:58:26 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
```
#### /etc/apt/sources.list
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

#### Cross-Compiling

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

#make menuconfig 
Kernel hacking --> Compile-time checks and compiler option --> 
            Compile the kernel with debug info --> Enable
            Generate dwarf4 debuginfo --> Enable
            Provide GDB scripts for kernel debuffing--> Enable

$ cat ~/code/linux/build.sh
#!/bin/sh
OUTPUT="~/code/out"
KERNEL=kernel7
make ARCH=arm O=$OUTPUT CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
make ARCH=arm O=$OUTPUT CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs  -j3

$ build.sh

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
#### 컴파일 결과 
```

$ ls -l ~/code/out/arch/arm/boot/dts/bcm2709-rpi-2-b.dtb
-rw-r--r-- 1 good good 25334  6월 20 00:53 ~/code/out/arch/arm/boot/dts/bcm2709-rpi-2-b.dtb

$ ls -l ~/code/out/arch/arm/boot/zImage 
-rwxr-xr-x 1 good good 5470168  6월 20 01:01 ~/code/out/arch/arm/boot/zImage

$ ls -l ~/code/out/arch/arm/boot/zImage 
-rwxr-xr-x 1 good good 5470168  6월 20 01:01 ~/code/out/arch/arm/boot/zImage
```
#### qemu
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

#### ddd

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
