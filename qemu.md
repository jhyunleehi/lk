4.5.	qemu 설정
4.5.1.	QEMU를 이용한 라즈베리파이2 커널 디버깅

참고 : 송원식 iamroot 항목 참고, QEMU를 이용한 라즈베리파이2 커널 디버깅
http://www.iamroot.org/xe/index.php?mid=Knowledge&search_target=title_content&search_keyword=qemu&document_srl=186059


4.5.1.1.	QEMU 컴파일
참고 URL Emulate Rapberry Pi 2 in QEMU
QEMU 다운로드
$ mkdir -p ~/git/pi2
$ cd ~/git/pi2

$ git clone https://github.com/0xabu/qemu.git -b raspi
$ cd qemu
$ git clone http://git.qemu.org/git/dtc.git
QEMU 커널 BASE 주소 수정
Qemu 소스 hw/arm/boot.c 파일 수정.
#define KERNEL_LOAD_ADDR 0x00010000
이것을 아래처럼 수정.
#define KERNEL_LOAD_ADDR 0x00008000
compile 및 설치
$ cd ~/git/pi2/qemu

$ ./configure --target-list=arm-softmmu
$ make -j$(nproc)
$ sudo make install
config나 컴파일 잘안되면 아래 오류조치 내용을 참고한다.

4.5.1.2.	라즈베리파이2용 커널 컴파일
참고 URL Raspberry Pi Kernel Building
라즈베리파이2 이미지 다운로드 Raspberry PI 2 Image download
압축을 푼뒤 raspbian-jessie.img 파일명으로 변경한다
라즈베리파이2 컴파일러 및 툴체인 설치
$ mkdir ~/git/pi2
$ cd ~/git/pi2
$ git clone https://github.com/raspberrypi/tools
컴파일 환경 설정 파일 만들기
$ vi env.sh
#!/bin/sh
export PATH=~/git/pi2/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin:$PATH
export KERNEL=kernel7

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
환경 설정 적용.
$ source env.sh
커널 컴파일시 추가 셋팅
$ cd ~/git/pi2/
$ git clone https://github.com/raspberrypi/linux
$ cd linux
$ git checkout tag5

$ make bcm2709_defconfig
$ make menuconfig

Kernel hacking --> Compile-time checks and compiler option --> 
            Compile the kernel with debug info --> Enable
            Generate dwarf4 debuginfo --> Enable
            Provide GDB scripts for kernel debuffing--> Enable

$ make -j$(nproc) zImage modules dtbs


4.5.1.3.	커널 디버깅
컴파일 된 커널과 DTB파일 추출
$ scripts/mkknlimg arch/arm/boot/zImage ~/git/pi2/kernel7.img
$ cp arch/arm/boot/dts/bcm2709-rpi-2-b.dtb ~/git/pi2
QEMNU 실행 스크립트 작성.
$ vi ~/git/pi2/run_qemu.sh
#!/bin/sh

BOOT_CMDLINE="rw earlyprintk loglevel=8 console=ttyAMA0,115200 console=tty1 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2"
DTB_FILE="bcm2709-rpi-2-b.dtb"
KERNEL_IMG="kernel7.img"
SD_IMG="raspbian-jessie.img"

echo "target remote localhost:1234"
qemu-system-arm -s -S -M raspi2 -kernel ${KERNEL_IMG} \
    -sd ${SD_IMG} \
    -append "${BOOT_CMDLINE}" \
    -dtb ${DTB_FILE} -serial stdio
QEMU 실행
$ sh ./run_qemu.sh
gdb 실행 새터미널을 띄운후 gdb 실행(디버깅)
$ cd ~/git/pi2
$ source env.sh
$ cd ~/git/pi2/linux
$ ddd --debugger arm-linux-gnueabihf-gdb ./vmlinux
# GDB shell에서 target remote localhost:1234 명령을 친다.
(gdb) target remote localhost:1234

# start_kernel 에 브레이크 포인트 셋팅
(gdb) b start_kernel

# 디버깅 시작.
(gdb) c

언제라도 쉽게 소스코드를 볼수 있는 상황..
그리고 중요한 모듈 핵심 모듈들을 이해하고 붙일 수 있는 것
하지만 더 중요한 것은 리눅스의 기본적인 내부 동작을 완전하게 이해하는 것이다.

*tip
ddd 명령이 정상적으로 동작하지 않을 경우는 ~/.ddd 디렉토리 안에 내용을 삭제하면 정상적으로 ddd를 수행할 수 있다.
