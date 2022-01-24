# Interrupt

## Event 기반 OS

#### OS&Events

* 커널은 Event 기반 아키텍처 이다.
* 오직 interrupt에 의해서만 동작된다. 

![image-20220117153944597](img/image-20220117153944597.png)



### Events 종류

1. 하드웨어 인터럽트
2. 트랩 : software interrupts 
3. Exceptions

![image-20220117154035206](img/image-20220117154035206.png)



![image-20220117154121813](img/image-20220117154121813.png)



## Hardware Interrupts 

#### 1. Multiple devices 

![image-20220117154202167](img/image-20220117154202167.png)

#### 2. interrupt handler routine 

![image-20220117232316716](img/image-20220117232316716.png)



#### 3. Programmable Interrupt Controller 

![image-20220117154219739](img/image-20220117154219739.png)



![image-20220117155143435](img/image-20220117155143435.png)

#### 4. APIC

* advanced Programmable Interrupt

![image-20220117155204274](img/image-20220117155204274.png)

* External interrupts are routed from peripherals to CPUs in multi processor systems through APIC 
* APIC distributes and priotitizes interrupts to processors
* Comprises of two components
  * local APIC (LAPIC)
  * I/O  APIC
* APIC communicate through a special 3-wire APICS bus 



##### 1. LAPIC

* Receives interrups from I/O APIC and routes it to the local CPU
* Can also receive local interrupts (such as from themal sensor, internal timer, etc)
* Send and receive IPIs (inter processor interrupts)
  * IPIs used to distribute interrupts between processors or execute system wide functions like booting, load distribution, etc

##### 2. I/O APIC

* present in chipset (north bridge)
* used to route external interrupt to local APIC 



### 

#### 5. IDTR : interrupt descriptor table



![image-20220117232424561](img/image-20220117232424561.png)



#### 6. interrupt trap gate

![image-20220117232521063](img/image-20220117232521063.png)



#### 7. interrupt descriptor 

![image-20220117232707223](img/image-20220117232707223.png)



#### 8. Exception and interrupt vectors in x86

![image-20220117232837337](img/image-20220117232837337.png)





## Interrupt handling 





![image-20220117233047144](img/image-20220117233047144.png)

![image-20220117233231054](img/image-20220117233231054.png)





![image-20220117233347374](img/image-20220117233347374.png)



![image-20220117233405386](img/image-20220117233405386.png)

![image-20220117233719122](img/image-20220117233719122.png)



![image-20220117233813856](img/image-20220117233813856.png)





![image-20220117233837764](img/image-20220117233837764.png)



![image-20220117234002953](img/image-20220117234002953.png)





![image-20220117234052235](img/image-20220117234052235.png)





![image-20220117234223290](img/image-20220117234223290.png)



![image-20220117234818982](img/image-20220117234818982.png)



![image-20220118000459978](img/image-20220118000459978.png)



![image-20220118000615234](img/image-20220118000615234.png)



![image-20220118000714385](img/image-20220118000714385.png)



## Software Interrupt

### hardware vs Software interrupt

![image-20220118001008642](img/image-20220118001008642.png)

#### Software interrupt 

* software interrupt used fot implementing system calls
  * in linux Int 128
  * in xv6  int 64 

![image-20220118001110917](img/image-20220118001110917.png)



### system call : example

#### 1. write system call 

![image-20220118001131495](img/image-20220118001131495.png)



#### 2. System  call in xv6



![image-20220118000813916](img/image-20220118000813916.png)



#### 3. system call number

![image-20220118000833925](img/image-20220118000833925.png)



#### 4. prototype of a typical system call 

![image-20220118001218857](img/image-20220118001218857.png)



#### 5. passing parameters in system call

![image-20220118001321393](img/image-20220118001321393.png)

#### 6. pass by register (linux)



![image-20220118001337755](img/image-20220118001337755.png)



* 내가 System call 할때 상태를 저장하는 것과 파라미터를 전달하는 것을 혼동 했구나.

#### 7. pass via user stack (xv6)

![image-20220118001517265](img/image-20220118001517265.png)



#### 8. return from system call



![image-20220118001559437](img/image-20220118001559437.png)



