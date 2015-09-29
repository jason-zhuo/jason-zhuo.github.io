---
layout: post
title: "Botnet detection"
description: "Paper reading"
categories: [Infosec]
tags: [Botnet]
music: []

---

![image](/assets/images/2015-05-08botnet.png)
Botnet检测论文阅读笔记,last update (2015.8.11)
<!-- more -->

####僵尸网络检测方法面临的问题
和流量识别所面临的问题类似[1]，僵尸网络的检测同样也缺乏公开可用的测试数据集合通用的测试评估方法。在论文[2]中，作者提出了僵尸网络检测面临的问题：原有僵尸网络检测论文都只是提出了一种新方法，但是都没有做横向对比。其原因主要是因为分享包含僵尸网络流量数据比较困难，缺乏好的数据集，缺乏科学有效的对比方法等。

作者在论文[2]中首次提出了他们的解决办法，并对3种常见的僵尸网络检测手段在自己收集整理的数据集合上做了横向对比。作者还将数据集合公开出来，极大的方便了其他研究人员的继续研究------[数据集传送门](http://mcfp.weebly.com/the-ctu-13-dataset-a-labeled-dataset-with-botnet-normal-and-background-traffic.html)。

原有的论文都是自己提出了一种方法后，自己搜集了一些数据集进行测试。这些数据集往往很难获取，数据集合的真实性也难以保证和真实网络环境类似。同时，自己构造的数据集很难和其他方法进行对比。（不同的方法针对的数据集特征可能会大相径庭）除了数据集的问题之外，很多僵尸检测的论文中的评价指标仅局限于FPR，或者使用的是不同的评价定义方式，这给方法之间的评比造成困难。

####1. CAMNEP
CAMNEP(Cooperative Adaptive Mechanism for NEtwork Protection) 是一个基于异常检测的网络行为的分析系统。系统包括了state of art的异常检测方法。
主要包括3部分：

 1. 异常检测器： 通过多种异常检测模块，对网络行为进行分析
 2. 信任模型：上一个输出的结果会和信任模型进行对比。信任模型会将Netflow根据其异常值和代表的事件类型聚集为不同类别。并持续对异常值进行更新来达到减少误报率。
 3. 异常聚集器：结果汇总，对每个异常检测器的判定结果加权平均等。

CAMNEP利用NetFlow分析网络异常流量也存在一些限制条件，如需要网络设备对NetFlow的支持，需要分析NetFlow数据的工具软件，需要网络管理员准确区分正常流量数据和异常流量数据等。

#####1.1异常检测模块
下面介绍的异常检测模块是经过对原来算法的改进或者修改实现的，可能会和原来论文中的方法有差异。
**MINDS**[3]，一个入侵检测模块，提取的特征包括：1.相同源IP地址发出的Netflow数，2.到达相同Host的Netflow数，3.从相同端口号到达相同Host的Netflow数，4.从相同Host到达相同端口号的Netflow数. 某种情况下（Context）下的异常值，为上述四个特征到正常样本的距离。最后的Global distance是各个Context下异常值的sum of their squares. 

**Xu et al. 2005** 提出的方法是将来自同一个源IP地址的Netflow进行特征提取。特征包括：1. 正则化后的源端口熵值（Normalized entropy of the source ports），2. 正则化后的目的IP地址熵值，3. 正则化后的目的端口熵值。某种情况下（Context）下的异常值，为上述3个特征到正常样本的距离。最后的distance同样是各个Context下异常值的sum of their squares. 

**Lakhina volume** 原文章是来自Sigcomm的文章，针对的是Network-wide的异常检测。在[1]中作者修改了其中一部分，其主要思想是将来自同一个源IP地址的数据流用PCA方法分为正常流和非正常流，因为正常流占了绝大多数成分而异常流只存在少部分。

**Lakhina entropy** 基于上述PCA的思想，但是采用了和xu et al.类似的特征。

**TAPS 2006** 与上述方法都不相同。该方法针对的是横向和纵向端口扫描。该方法的基本思想还是通过提取特征，然后设置特征阈值。超过一定的阈值则判断为扫描行为。

**KGB 2012** 基于的是  Lakhina 的工作，也是利用的PCA来分解每个源IP产生的特征向量。

**Flag** 和KGB方法类似，只不过输入的特征向量不同。Flag是基于来自同一个IP地址的TCP标志柱状图 。该检测器就是寻找一个连续的TCP标志异常组合。

#####1.2可信模型建立
CAMNEP的可信模型类似于Kmeans中的聚类。模型计算每个Netflow到每个可信簇类中心(Centroid)的距离。


####2. BGlus
BGlus是基于行为的僵尸网络检测方法。其基本思想是先对已知的僵尸网络流量进行模型抽象，然后在网络上寻找相似的流量。
其基本步骤如下：

 1. 将Netflows按时间窗口进行分割
 2. 将分割后的Netflows按照相同的源IP进行组合
 3. 对不同的源IP流量进行聚类
 4. 该步只针对训练阶段：对僵尸网络聚类进行ground truth 打标签
 5. 该步只针对训练阶段：利用僵尸网络簇训练一个分类器。
 6. 该步只针对测试阶段：利用分类器来检测聚类结果中的僵尸网络簇
 
关于作者在第二步中为什么这么做。作者假设这样做会产生新的patterns，可以帮助我们识别僵尸网络，这样做偏向于基于主机的行为分析。

作者在BGlus中运用的是EM聚类算法（作者假设不同的流量产生于相同的分布）和JRIP分类算法。

####3. BotHunter
BotHunter是基于状态序列的匹配方法。它有一个关联分析引擎来分析恶意软件当前的状态过程。检测的特征过程包括：inbound scanning, exploit usage, egg download, outbound bot coordination dialog, outbound attack propagation. 

BotHunter是经过修改过的Snort软件。主要增加了两个插件，一个是SCADE(statistical scan anomaly detection engine) ,另外一个是SLADE(statistical payload anomaly detection engine)

下面穿插对比一下几个检测器：
**Bothunter**: Vertical Correlation. Correlation on the behaviors of single host.
**Botsniffer**: Horizontal Correlation. On centralized C&C botnets
**Botminer**: Extension on Botsniffer, no limitations on the C&C types.

####4. 数据集构建
论文中作者构建的数据集具有以下特点：

 1. 是真实的僵尸网络程序，而不是仿真
 2. 数据集中包括未知流量
 3. 数据集中存在类标，方便训练和方法效果评估
 4. 包括多种僵尸网络流量
 5. 包括多个僵尸主机同时被感染的情况
 6. 包括Netflow文件用来保护用户隐私

作者在一台虚拟主机上设置了僵尸网络程序，这台主机唯一产生僵尸网络流量。然后作者将该虚拟主机和校园网络桥接，并分别在虚拟主机上抓包和校园网络某一台路由器上抓包。虚拟主机产生的流量是用于做类标记的。作者相信最好的办法是抓真实攻击的数据包，因此作者并没有在互联网入口处设置过滤。这样做真的好吗？

作者利用Argus软件将Pcap文件转换为Netflow文件。Netflow文件包括了以下一些字段：开始时间，结束时间，持续时间，源IP，目的IP,源端口，目的端口，目的IP，状态，SToS，总包数，总包大小。

####5.对比结果

>**BClus** showed large FPR values on most scenarios but also large TPR. 
>The **CAMNEP** method had a low FPR during most of the scenarios but at the expense of a low TPR.
>The **BotHunter** algorithm presented very low values during the whole scenario despite that there were ten bots being executed.
 
 看来**BotHunter**的检测效果在作者所做的实验中表现一般，因此作者在结论中评价也相对含蓄。
 >BotHunter method showed that in real environments it could still be useful to have blacklists of known malicious IP addresses

---------
> Written with [StackEdit](https://stackedit.io/).

###论文[4]阅读笔记
一个区分现代Botnet和之前的僵尸网络的特征是结构化的覆盖拓扑结构使用的增加。结构化拓扑结构有利于增加botnet系统的稳定性，但同时也对其检测带来了新的突破口。

论文作者提出了BotGrep检测算法，只通过peer节点之间的通信图来检测僵尸网络的节点。

现有检测面临的挑战：随机端口，内容加密。背景流量越来越纷繁复杂，流量大数据导致算法需要重新设计。
 
 BotGrep算法输入：通信图，误用检测结果。输入误用检测结果的目标是为了区分P2P通信和Botnet。论文作者利用了一个“结构图”的特性叫做: ***fast mixintg time：*** i.e,the convergence time of random walks to a stationary distribution。来将僵尸网络的结构图从其余的通信图中分离出来。
 
设原通信图为 \\(G \subset =（V,E）\\), \\(G_p\\)是在\\(G\\)中的P2P网络通信图 \\(G_p \subset G \\), \\(G_n=G-G_p \\)就是non-P2P通信图。作者最主要的idea就是从\\(G \\)中，分离出\\(G_n\\),\\(G_p\\)。基本思想就是因为P2P网络的拓扑结构是存在结构规律的，比背景的网络流量更具有结构性。在随机游走的情况下，P2P网络的mixing rate要比背景网络mixing rate更快。

作者的主要步骤包括：

1. 过滤操作：开始输入的图可能包括百万级别的节点数量，在这一步中先抽取出小部分的P2P候选节点和false positive节点。
2. 运用***SybilInfer***聚类算法来对上一步中的P2P节点中的false positive节点去掉。
3. 最后一步用fast-mixing特征对P2P网络监测结果进行验证。


下面详细讲解一下每一步：

***过滤操作:***

####参考文献
[1]Dainotti A, Pescape A, Claffy K C. Issues and future directions in traffic classification[J]. Network, IEEE, 2012, 26(1): 35-40.

[2]An empirical comparison of botnet detection methods" Sebastian Garcia, Martin Grill, Honza Stiborek and Alejandro Zunino. Computers and Security Journal, 
Elsevier. 2014. Vol 45, pp 100-123. http://dx.doi.org/10.1016/j.cose.2014.05.011

[3]Ertoz L, Eilertson E, Lazarevic A, Tan PN, Kumar V, Srivastava J, et al. 
Minds-minnesota intrusion detection system. In: Next generation data mining. MIT Press; 2004. pp. 199e218.

[4]Nagaraja S, Mittal P, Hong C Y, et al. BotGrep: Finding P2P Bots with Structured Graph Analysis[C]//USENIX Security Symposium. 2010: 95-110.
