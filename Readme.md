# Install & Configuration

## config

### apt

```
root@raspberry:~# cat /etc/apt/sources.list
deb http://ftp.kr.debian.org/debian/ stable main non-free contrib
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