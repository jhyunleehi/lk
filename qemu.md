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



4.5.2.	오류 처리
4.5.2.1.	git proxy 설정 문제
git proxy 설정후 down load 진행
ljh@ljh-VirtualBox:~/git/linux$ git config --global  http.proxy http://70.10.15.10:8080
ljh@ljh-VirtualBox:~/git/linux$ git config --global  https.proxy https://70.10.15.10:8080
ljh@ljh-VirtualBox:~/git/linux$ git clone https://github.com/raspberrypi/linux
Cloning into 'linux'...
remote: Enumerating objects: 1900, done.
remote: Counting objects: 100% (1900/1900), done.
remote: Compressing objects: 100% (750/750), done.
Receiving objects:   0% (20145/7243382), 8.91 MiB | 3.29 MiB/s


4.5.2.2.	qemu.git 다시 받기
jhyunlee@jhyunlee-VirtualBox:~/git/pi2$ git clone https://github.com/qemu/qemu.git
Cloning into 'qemu'...
remote: Counting objects: 390319, done.
remote: Total 390319 (delta 0), reused 0 (delta 0), pack-reused 390319
Receiving objects: 100% (390319/390319), 185.10 MiB | 399.00 KiB/s, done.
Resolving deltas: 100% (313907/313907), done.
Checking connectivity... done.

4.5.2.3.	DTC.git update 오류
jhyunlee@jhyunlee-VirtualBox:~/git/pi2/qemu$ git submodule update --init dtc
Submodule 'dtc' (git://git.qemu-project.org/dtc.git) registered for path 'dtc'
Cloning into 'dtc'...
^C
jhyunlee@jhyunlee-VirtualBox:~/git/pi2/qemu$ git clone http://git.qemu.org/git/dtc.git
Cloning into 'dtc'...
Checking connectivity... done.

4.5.2.4.	Cloining capstone error
jhyunlee@jhyunlee-VirtualBox:~/git/pi2/qemu$ make -j$(nproc)
  GIT     ui/keycodemapdb dtc capstone
Cloning into 'capstone'...
fatal: unable to connect to git.qemu.org:
git.qemu.org[0: 172.99.69.163]: errno=Connection timed out

fatal: clone of 'git://git.qemu.org/capstone.git' into submodule path 'capstone' failed
./scripts/git-submodule.sh: failed to update modules

Unable to automatically checkout GIT submodules ' ui/keycodemapdb dtc capstone'.
If you require use of an alternative GIT binary (for example to
enable use of a transparent proxy), then please specify it by
running configure by with the '--with-git' argument. e.g.

 $ ./configure --with-git='tsocks git'

Alternatively you may disable automatic GIT submodule checkout
with:

 $ ./configure --disable-git-update

and then manually update submodules prior to running make, with:

 $ scripts/git-submodule.sh update  ui/keycodemapdb dtc capstone

Makefile:45: recipe for target 'git-submodule-update' failed
make: *** [git-submodule-update] Error 1


jhyunlee@jhyunlee-VirtualBox:~/git/pi2/qemu$  ./configure --with-git='tsocks git'

git submodule foreach --recursive 'git submodule sync'
git submodule update --recursive

여기에 git url이 정의 되어 있어서 이것을 조정해 봐야 겠다.
./.git/config:  url = git://git.qemu.org/capstone.git
./.git/config:  url = git://git.qemu.org/keycodemapdb.git
./.git/config:  url = git://git.qemu.org/QemuMacDrivers.git
./.git/config:  url = git://git.qemu.org/qemu-palcode.git
./.git/config:  url = git://git.qemu.org/skiboot.git
./.git/config:  url = git://git.qemu.org/u-boot-sam460ex.git

.git/config 파일에서 capstone.git url을 수정한다.
url = https://github.com/qemu/capstone.git

jhyunlee@jhyunlee-VirtualBox:~/git/pi2/qemu$ make -j$(nproc)
  GIT     ui/keycodemapdb dtc capstone
Cloning into 'capstone'...
remote: Counting objects: 23849, done.
remote: Compressing objects: 100% (226/226), done.
remote: Total 23849 (delta 123), reused 146 (delta 71), pack-reused 23545
Receiving objects: 100% (23849/23849), 33.96 MiB | 400.00 KiB/s, done.
Resolving deltas: 100% (17245/17245), done.
Checking connectivity... done.
Cloning into 'ui/keycodemapdb'..




4.5.2.5.	make capstone failed
make[1]: *** No rule to make target '/home/jhyunlee/git/pi2/qemu/capstone/libcapstone.a'.  Stop.
Makefile:506: recipe for target 'subdir-capstone' failed
make: *** [subdir-capstone] Error

4.6.	Kernel 컴파일
https://harryp.tistory.com/839

4.6.1.	사전준비
최신 커널은 여기서 다운로드
http://kernel.org

필요 패키지 설치
$ sudo apt-get update
$ sudo apt-get install build-essential libncurses5 libncurses5-dev bin86 kernel-package libssl-dev bison flex libelf-dev

$ wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.21.tar.xz
$ wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.50.tar.xz
$ sudo mv 커널소스파일명 /usr/src/
$ cd /usr/src
$ sudo xz -d 커널소스파일명.tar.xz
$ sudo tar xf 커널소스파일명.tar
$ cd 커널소스디렉토리

현재 커널 config 파일 복사
# sudo cp /boot/config-현재커널명 ./.config

프로세서 개수 확인
$ grep -c processor /proc/cpuinfo 

$ sudo make-kpkg --J # --initrd --revision=1.0 kernel_image
-J # 코어 개수
--revision=1.0 숫자만 입력 가능


생성된 커널 이미지  설치
$ sudo dpkg -i 커널이미지파일명


