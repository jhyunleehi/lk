# Drivers

* 드라이버는 OS에서 어떤 Device를 관리하기 위한 코드인데
* 이것을 인터럽트와 함께 설명하는 이유는 , 디바이스에 대해서 인터럽트 핸들러를 제공하기 때문이다.  그리고 디바이스는 인터럽트를 발생시키기 때문이다. 
* 드라이버 코드는 system call 처럼 흐름 상 준비된 상태에서 발생하는 것이 아니라 interrupt 를 기반으로 동작하기 때문에 교활하다고 할 수 있다. 좀 처리하기 곤란하다 정도...
* 그리고 드라이버는 Device 인터페이스 (IO port) 이런 것도 이해해야 한다. 인터페이스는 복잡하다는 것...
* 디스크 드라이버는 좋은 예시가 될 수 있다. 
* 디스크 드라이버는 디스크로 부터 데이터를 복사해오거나 디스크에 저장하는 역할을 한다. 
* 디스크 하드웨어는 512 바이트 블럭의 연속적 번호로 나타낼 수 있다. 뭐 sector로 나타 낼 수 도 있는데  sector 0은 512 바이트, sector 1은 512 바이트 그 다음.... 다음 ...
* 디스크 섹터를 나타내기 위해 운영 체제는 하나의 섹터에 해당하는 구조를 가지고 있습니다.
* 이 구조에 저장된 데이터는 종종 디스크와 동기화되지 않습니다. 디스크에서 아직 읽히지 않았거나(디스크가 작업 중이지만 섹터의 내용을 아직 반환하지 않음), 업데이트되었지만 아직 디스크에 write 되지 않았습니다.
* 드라이버에 대해서 디스크와 데이터 structure 가 동기화 되지 않을 수 있다는 것을 명심해야 한다. 



## Code: Disk driver

#### IDE Device

* IDE 장치는 PC 표준 IDE 컨트롤러에 연결된 디스크에 대한 액세스를 제공합니다.

```
QEMUOPTS = 
-drive file=fs.img,index=1,media=disk,format=raw 
-drive file=xv6.img,index=0,media=disk,format=raw
```

* IDE는 이제 SCSI와 SATA로 바뀌었지만 인터페이스가 단순하여 특정 하드웨어의 세부 사항 대신 드라이버의 전체 구조에 집중할 수 있습니다.

#### struct buf

* 디스크 드라이버는 버퍼, struct buf(3750)라고 하는 데이터 구조를 가진 디스크 섹터를 나타냅니다. 
* 각 버퍼는 특정 디스크 장치에 있는 한 섹터의 내용을 나타냅니다.
* dev 및 섹터 필드는 장치 및 섹터 번호를 제공하고 데이터 필드는 디스크 섹터의 메모리 내 복사본입니다.

```c
struct buf {
  int flags;
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev; // LRU cache list
  struct buf *next;
  struct buf *qnext; // disk queue
  uchar data[BSIZE];
};
#define B_VALID 0x2  // buffer has been read from disk
#define B_DIRTY 0x4  // buffer needs to be written to disk
```

* 플래그는 메모리와 디스크 간의 관계를 추적합니다. 
* B_VALID 플래그는 데이터를 읽었음을 의미하고 B_DIRTY 플래그는 데이터를 기록해야 함을 의미합니다. 
* B_BUSY 플래그는 잠금 비트입니다. 일부 프로세스는 버퍼를 사용하고 다른 프로세스는 사용하지 않아야 함을 나타냅니다. 버퍼에 B_BUSY 플래그가 설정되어 있으면 버퍼가 잠겨 있다고 말합니다.

#### main()->ideinit

* 커널은 부팅 시 메인(1234)에서 ideinit(4151)를 호출하여 디스크 드라이버를 초기화합니다. 
* Ideinit는 picenable 및 ioapicenable을 호출하여 IDE_IRQ 인터럽트를 활성화합니다(4156-4157). 
* picenable에 대한 호출은 단일 프로세서에서 인터럽트를 활성화합니다. 
* ioapi-cenable은 멀티프로세서에서 인터럽트를 활성화하지만 마지막 CPU(ncpu-1)에서만 가능합니다. 2 프로세서 시스템에서 CPU 1은 디스크 인터럽트를 처리합니다.

```c
static struct spinlock idelock;
void ideinit(void)
{
  int i;
  initlock(&idelock, "ide");
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){ if(inb(0x1f7) != 0){havedisk1 = 1; break; } }
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
```

#### idewait

* 다음으로 ideinit는 디스크 하드웨어를 조사합니다. 디스크가 명령을 수락할 수 있을 때까지 기다리기 위해 idewait(4158)를 호출하여 시작합니다. 
* PC 마더보드는 I/O 포트 0x1f7에서 디스크 하드웨어의 상태 비트를 표시합니다.
* Idewait(4133)는 사용 중 비트(IDE_BSY)가 지워지고 준비 비트(IDE_DRDY)가 설정될 때까지 상태 비트를 폴링합니다. 

```c
// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
  int r;
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY);
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0) return -1;
  return 0;
}
```

* 이제 디스크 컨트롤러가 준비되었으므로 ideinit는 존재하는 디스크 수를 확인할 수 있습니다. 
* 부트로더와 커널이 모두 디스크 0에서 로드되었기 때문에 디스크 0이 있다고 가정한다.  따라서  디스크 1을 확인해야 합니다. 디스크 1을 선택하기 위해 I/O 포트 0x1f6에 쓰고 잠시 후 상태를 기다립니다. 디스크가 준비되었음을 나타내는 비트(4160-4167). 그렇지 않은 경우 ideinit는 디스크가 없다고 가정합니다.

#### iderw

* ideinit 후에는 버퍼 캐시가 플래그에 표시된 대로 잠긴 버퍼를 업데이트하는 iderw를 호출할 때까지 디스크가 다시 사용되지 않습니다. 
* B_DIRTY가 설정되면 iderw는 버퍼를 디스크에 씁니다. 
* B_VALID가 설정되지 않은 경우 iderw는 디스크에서 버퍼를 읽습니다.

```c
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void iderw(struct buf *b)
{
  uchar *p;

  if(!holdingsleep(&b->lock))  panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)     panic("iderw: nothing to do");
  if(b->dev != 1)    panic("iderw: request not for disk 1");
  if(b->blockno >= disksize)    panic("iderw: block out of range");

  p = memdisk + b->blockno*BSIZE;

  if(b->flags & B_DIRTY){   
      b->flags &= ~B_DIRTY;   
      memmove(p, b->data, BSIZE);
  } else
    memmove(b->data, p, BSIZE);
  b->flags |= B_VALID;
}
```

* 디스크 액세스는 일반적으로 프로세서에 긴 시간인 밀리초가 걸립니다. 
* 부트 로더는 디스크 읽기 명령을 실행하고 데이터가 준비될 때까지 상태 비트를 반복적으로 읽습니다. 
* 이 폴링 또는 바쁜 대기는 부트 로더에서 괜찮습니다. 그러나 운영 체제에서는 다른 프로세스가 CPU에서 실행되도록 하고 디스크 작업이 완료되면 인터럽트를 수신하도록 정렬하는 것이 더 효율적입니다.
* Iderw는 대기 중인 디스크 요청 목록을 대기열에 유지하고 인터럽트를 사용하여 각 요청이 완료된 시점을 찾는 후자의 접근 방식을 취합니다.
* iderw는 요청 대기열을 유지하지만 간단한 IDE 디스크 컨트롤러는 한 번에 하나의 작업만 처리할 수 있습니다. 디스크 드라이버는 큐의 앞쪽에 있는 버퍼를 디스크 하드웨어로 보냈다는 불변성을 유지합니다. 다른 사람들은 단순히 자신의 차례를 기다리고 있습니다.

#### idestart

```c
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
  int sector_per_block =  BSIZE/SECTOR_SIZE;
  int sector = b->blockno * sector_per_block;
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
```

* Iderw는 버퍼 b를 큐의 끝에 추가합니다. 버퍼가 대기열의 맨 앞에 있으면 iderw는 idestart를 호출하여 버퍼를 디스크 하드웨어로 보내야 합니다. 그렇지 않으면 버퍼 앞에 있는 버퍼가 처리되면 버퍼가 시작됩니다. 
* Idestart는 플래그에 따라 버퍼의 장치 및 섹터에 대한 읽기 또는 쓰기를 실행합니다. 작업이 쓰기인 경우 idestart는 지금 데이터를 제공해야 하며(4189) 인터럽트는 데이터가 디스크에 기록되었다는 신호를 보냅니다. 
* 작업이 읽기인 경우 인터럽트는 데이터가 준비되었음을 알리고 핸들러는 데이터를 읽습니다. 
* idestart에는 IDE 장치에 대한 자세한 지식이 있으며 다음을 작성합니다. 
* 올바른 포트에서 올바른 값. 이러한 outb 문 중 하나라도 잘못된 경우 IDE는 우리가 원하는 것과 다른 작업을 수행합니다. 이러한 세부 정보를 올바르게 얻는 것이 장치 드라이버 작성이 어려운 이유 중 하나입니다.
* 요청을 대기열에 추가하고 필요한 경우 시작했으면 iderw는 결과를 기다려야 합니다. 위에서 논의한 바와 같이 폴링은 CPU를 효율적으로 사용하지 않습니다. 대신, iderw는 작업이 완료되었음을 인터럽트 처리기가 버퍼의 플래그에 기록할 때까지 대기합니다. 이 프로세스가 잠자는 동안 xv6은 CPU를 계속 사용하도록 다른 프로세스를 예약합니다.
* 결국 디스크는 작업을 완료하고 인터럽트를 트리거합니다. 

#### ideintr

```c
// Interrupt handler.
void
ideintr(void)
{
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
    return;
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  wakeup(b);

  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
```



* 트랩은 ideintr을 호출하여 처리합니다(3374). 
* Ideintr(4202)은 대기열의 첫 번째 버퍼를 참조하여 어떤 작업이 발생했는지 알아냅니다. 버퍼를 읽고 있고 디스크 컨트롤러에 데이터가 대기 중인 경우 ideintr은 insl을 사용하여 데이터를 버퍼로 읽습니다. 
* 이제 버퍼가 준비되었습니다. 
* ideintr은 B_VALID를 설정하고 B_DIRTY를 지우고 버퍼에서 잠자는 프로세스를 깨웁니다(4219-4222). . 마지막으로 ideintr은 다음 대기 버퍼를 디스크에 전달해야 합니다(4224-4226).