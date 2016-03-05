---
layout: post
title: "PF_ring and Jnetpcap"
description: ""
categories: [new stuff]
tags: [Network]
music: []

---
###基于Jnetpcap使用Pf\_ring（PF\_ring and Jnetpcap）
---
![image](/assets/images/Pfringjnetpcap.png)
基于Jnetpcap的Pfring使用，以及网络数据包处理流程机制分析。
<!-- more -->
1. last update 2016.3.5  修正l句子不通顺的地方。


##1.PF ring 简介
PF\_RING是Luca Deri发明的提高内核处理数据包效率的网络数据包捕获程序，如Libpcap和TCPDUMP等。PF\_RING是一种新型的网络socket，它可以极大的改进包捕获的速度。

####1.1 本文中的一些术语
**NAPI:**  NAPI是Linux新的网卡数据处理API，NAPI是综合中断方式与轮询方式的技术，NAPI 在高负载的情况下可以产生更好的性能，它避免了为每个传入的帧都产生中断。参考这个链接[NAPI](http://blog.csdn.net/zhangskd/article/details/21627963)

**Zero copy (ZC):** 简单一点来说，零拷贝就是一种避免 CPU 将数据从一块存储拷贝到另外一块存储的技术。

**NPU:**网络处理器

**DMA**:直接内存存取, Direct Memory Access, 它允许不同速度的硬件装置来沟通，而不需要依赖于 CPU 的大量中断负载。

**Linux 网络栈**：如下图所示，它简单地为用户空间的应用程序提供了一种访问内核网络子系统的方法。
![enter image description here](https://www.ibm.com/developerworks/cn/linux/l-linux-networking-stack/figure2.gif)

##2. Libpcap抓包原理
Libpcap的包捕获机制就是在数据链路层加一个旁路处理。当一个数据包到达网络接口时，libpcap首先利用已经创建的Socket从链路层驱动程序中获得该数据包的拷贝，再通过Tap函数将数据包发给BPF过滤器。BPF过滤器根据用户已经定义好的过滤规则对数据包进行逐一匹配，匹配成功则放入内核缓冲区(一次拷贝)，并传递给用户缓冲区（又一次拷贝），匹配失败则直接丢弃。如果没有设置过滤规则，所有数据包都将放入内核缓冲区，并传递给用户层缓冲区。

![image](/assets/images/Libpcap.jpg)

高速复杂网络环境下libpcap丢包的原因主要有以下两个方面：

1. Cpu处于频繁中断状态，造成接收数据包效率低下。
2. 数据包被多次拷贝，浪费了大量时间和资源。从网卡驱动到内核，再从内核到用户空间。

####为啥用Pfring呢
随着信息技术的发展，1 Gbit/s，10 Gbit/s 以及 100 Gbit/s 的网络会越来越普及，那么零拷贝技术也会变得越来越普及，这是因为网络链接的处理能力比 CPU 的处理能力的增长要快得多。高速网络环境下， CPU 就有可能需要花费几乎所有的时间去拷贝要传输的数据，而没有能力再去做别的事情，这就产生了性能瓶颈。


##3.PF_RING驱动家族
这些驱动（在PF_RING/driver/PF_RING-aware中可用）设计用于提高数据包捕获，它把
数据包直接放入到PF_RING中，不经过标准Linux数据包分发机制。


###3.1 DNA

对于那些希望在CPU利用率为0%（拷贝包到主机）情况下需要最大数据包捕获速度的用户来说，可以使用DNA(Direct NIC Access)驱动，它允许数据直接从网络接口上读取，它以零拷贝的方式同时绕过Linux 内核和 PF_RING模块。

左边这个图解释：**Vanilla PF_RING** 从NIC上通过Linux NAPI获取数据包拷贝。拷贝到PFring 环状缓存空间。然后用户空间的应用会从环状缓存空间读取数据包。从图中可以看出**Vanilla PF_RING** 有两次polling操作，一次从NIC到环状缓存空间（Linux 内核里面），另外一次从环状缓存空间到用户程序。

左边这个图，相对于传统的方式来说。首先Application使用的是mmap方式，较标准版本的Libpcap效率更高。Libpcap标准版是目前使用最多的用于从内核拷贝数据包到用户层的库，而libpcap-mmap是libpcap的一个改进版本。传统libpcap使用固定大小的存储缓冲器和保持缓冲器来完成数据包从内核到用户层的传递，而libpcap-mmap设计了一个大小可以配置的循环缓冲器，允许用户程序和内核程序同时对该循环缓冲器的不同数据区域进行直接的读取。其次，PF_ring使用的是NAPI，而不是Libpcap中使用的DMA方式调用系统函数netif\_rx()将数据包从网卡拷贝到内核缓存。

右边这个图解释：**DNA**模式下通过NIC 的NPU(网络处理器)拷贝数据包到网卡上的缓存空间。然后直接通过DMA方式到用户层，同时绕过了PF_RING模块和Linux 内核缓存。官网已经证明了DNA方式能有更快的处理速率[Performance](http://www.ntop.org/products/packet-capture/pf_ring/)。

![DNAandNAPI](http://img.blog.csdn.net/20140622013115968?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvZG9nMjUw/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

让人多少有点遗憾的是，该方式并不是可以随意使用的，根据其License，提供免费下载，但是以二进制形式提供测试版本的库（也就是说使用5分钟或者达到一定包的处理数量之后软件就停了），如果需要长期使用，需要购买解锁的代码。

>ERROR: You do not seem to have a valid DNA license for eth0 [Intel 1 Gbit e1000e family].
We're now working in demo mode with packet capture
and transmission limited to 0 day(s) 00:05:00


下图展示的是传统数据发送的整个过程，图片引用自[ibm.com](http://www.ibm.com/developerworks/cn/linux/l-cn-zerocopy1/)。
![传统使用 read 和 write 系统调用的数据传输](http://www.ibm.com/developerworks/cn/linux/l-cn-zerocopy1/image001.jpg)

###3.2 PF_RING-aware (ZC support)
这个模块在路径 PF_RING/driver/PF_RING-aware下（带有zc后缀）。根据官方手册介绍，An interface in ZC mode provides the same performance as DNA. Zero Copy(ZC)。ZC和DNA实际上都是绕过Linux 内核和 PF_RING模块，这些模式下Linux内核将看不到任何数据包。

![PFring](http://i2.wp.com/www.ntop.org/wp-content/uploads/2011/08/pfring_mod.png?w=80%25)


###3.3 ZC
PF ring 还有一个ZC模块。什么ZC，DNA，pfring-aware是有点乱，不好分清楚。ZC模块可以看做是DNA的后续版本（“It can be considered as the successor of DNA/LibZero that offers a single and consistent API implementing simple building blocks (queue, worker and pool) that can be used from threads, applications and virtual machines.”）。PF_RING ZC comes with a **new generation of PF_RING aware drivers**。感觉这个ZC新模块与DNA差别不大。

##4. Libpfring and Libpcap and Jnetpcap
怎么让我们的其他应用程序使用pfring的高速特性呢？官方文档中说，Legacy statically-linked pcap-based applications need to be recompiled against the new PF_RING-enabled libpcap.a in order to take advantage of PF_RING. Do not expect to use PF_RING without recompiling your existing application. 也就是说需要和 PF_RING-enabled的 libpcap.a 进行重新编译应用程序才能够使用pfring的高速特性。 

项目运用中，我打算使用JAVA程序来写一个高速的网络数据包处理程序。由于JAVA采用的是Jnetpcap，Jnetpcap是Libpcap的封装。而原本Libpcap本来不是支持Pfring的。因此，如果要用Java调用Pfring，就必须采用支持Pfring的Libpcap，而不是原本安装的Libpcap。所以，需要把原来的Libpcap卸载，安装Pfring的Libpcap。

    rmp -qa libpcap //查看Libpcap
    rpm -e libpcap //删除Libpcap
 
Pfring 的安装过程可以参考这篇文章：[Pfring安装](http://www.cnblogs.com/tswcypy/p/3941619.html)

实验所用的服务器是Dell R730，em1,em2是万兆网卡，em3是千兆网卡
先卸载原来的网卡驱动，加载DNA驱动到em2网卡后是这样的：

```
[root@localhost ~]# ethtool -i em2
driver: ixgbe
version: 4.1.5
firmware-version: 0x800004cf, 15.0.28
bus-info: 0000:01:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no
```
```
[root@localhost ~]# ethtool -i em3
driver: igb
version: 5.2.13-k
firmware-version: 1.67, 0x80000b89, 15.0.28
bus-info: 0000:06:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no
```




运行我写的基于Jnetpcap的Java程序后，读取的硬件信息是这样的：

1. flags=6, addresses=[[addr=[10], mask=[10], broadcast=null, dstaddr=null], [addr=[INET4:192.168.1.30], mask=[INET4:255.255.255.0], broadcast=[INET4:192.168.1.255], dstaddr=null], [addr=[17], mask=null, broadcast=[17], dstaddr=null]], name=em3, desc=**PF_RING**
2. flags=6, addresses=[[addr=[17], mask=null, broadcast=[17], dstaddr=null]], name=em2, desc=**PF_RING ZC/DNA**
3. flags=6, addresses=[[addr=[17], mask=null, broadcast=[17], dstaddr=null]], name=em1, desc=**PF_RING ZC/DNA**

可以看到，em1,em2由于加载了Pfring的特殊驱动，其描述已经变成了**PF_RING ZC/DNA**，em3由于还是用的原来的驱动，所以只有Pfring。

使用Java调用**PF_RING ZC/DNA**，如果没有Lisence, 仍然会出现刚才所讲的错误信息。
需要注意的是调用ZC的时候需要将原来：

`Pcap.openlive(device.getName())`

改为

`Pcap.openlive(“ZC:”+device.getName())`

奇怪的是，我用tcpreplay 最高速发送：1479130个包的时候
jnetpcap接收到16655个包之后就没有了，至今不知道原因。
recv=0, drop=0, ifdrop=0
recv=16655, drop=0, ifdrop=0
recv=16655, drop=0, ifdrop=0
recv=16655, drop=0, ifdrop=0

Jnetpcap不使用ZC/DNA特殊驱动的时候，仅用Jnetpcap+ Pfring模块，在高速网络环境下，我们发现丢包仍然很严重。
实验中，我们将em1和em2直接串联，使用Tcpreplay结果：

```
Actual: 1479130 packets (812472290 bytes) sent in 4.06 seconds.Rated: 200116320.0 bps, 1526.77 Mbps, 364317.72 pps

Statistics for network device: em1
Attempted packets:         1479130
Successful packets:        1479130
Failed packets:            0
Retried packets (ENOBUFS): 0
Retried packets (EAGAIN):  0
```
使用Jnetpcap抓包结果：

```
	recv=93179, drop=139931, ifdrop=0
		recv=201895, drop=721505, ifdrop=0
		recv=338379, drop=736488, ifdrop=0
		recv=490772, drop=736488, ifdrop=0
		recv=660812, drop=736488, ifdrop=0
		recv=663681, drop=736488, ifdrop=0
		recv=663681, drop=736488, ifdrop=0
```

	
可以发现，仅用Jnetpcap+ Pfring模块，在高速网络环境下，我们发现丢包仍然很严重。达到了50%。


### 4.1Pf ring 工作模式
PF\_RING有3中工作模式：	 pf\_ring有三种透明模式（transparent\_mode）。为0时走的是Linux标准的NAPI包处理流程；	为1时，包既走Linux标准包处理流程，也copy给pf\_ring一份；	为2时，驱动只将包拷贝给pf\_ring，内核则不会接收到这些包，1和2模式需要pf_ring特殊的网卡驱动的支持。NOTE from other website：

- 默认为transparent=0，数据包通过标准的linux接口接收。任何驱动都可以使用该模式
- transparent=1（使用于vanila和PF_RING-aware驱动程序），数据包分别拷贝到PF_RING和标准linux网络协议栈各一份
- transparent=2（PF_RING-aware驱动程序），数据包近拷贝到PF_RING,而不会拷贝到标准的linux网络协议栈（tcpdump不会看到任何数据包）。
- 不要同时使用模式1和模式2到vanila驱动，否则将会抓到任何数据包。
###4.2 Pf ring 包过滤
pf_ring 普通模式下支持传统的BPF过滤器，由于DNA模式下，不再使用NAPI Poll，所以PF_RING的数据包过滤功能就不支持了，目前可以使用硬件层的数据包过滤，但只有intel的 82599网卡支持。Jnetpcap只能在pf_ring 普通模式下工作，因此只能够用BPF过滤器。



> Written with [StackEdit](https://stackedit.io/).
