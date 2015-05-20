---
layout: post
title: "Encrypted Traffic identification"
description: "paper reading"
categories: [Infosec]
tags: [Machine learning, encrypted flow]
music: []

---


![image](/assets/images/2015-05-11enflow2.png)
2015加密流量检测论文阅读笔记，持续更新（last update 2015.5.20）
<!-- more -->



####目前还有效的加密流量识别方法

 1. 基于端口号的，局限性很大但某些场景仍然有效。
 2. 基于内容签名的。有些加密协议有固定特殊的内容特征。
 3. 基于流特征的。加密协议在进行密钥协商时具有特殊过程。
 4. 基于主机行为的。从主机行为来看加密协议的建立过程，局限性仍然很大。

 
------------
####论文[1]作者的方法
上述方法的局限性较大。论文[1]中作者采用了随机度测试的方法来对加密流量进行识别。首先作者利用了\\(l_{1}-norm\\) regularized 逻辑斯特回归来选择**sparse**特征（特征中有很多0值），然后利用了ELM来对加密流量进行识别，选择ELM的原因是其具有更好的识别效果和更快的识别速度。

作者在论文[1]中利用随机度测试方法获取了188维度的特征，然后利用一范数正则化方法对特征进行降维。最后再利用ELM学习算法，对加密流量进行识别。

识别效果和支持向量数据描述(support vector data description)SVDD以及GMM方法进行了对比。可见作者采用了one-class分类。最后的结果是识别率大概在80%左右。

####随机度测试与加密方法
如何衡量加密算法的强弱好坏呢。有一种方法就是加密密文需要通过一定的随机度测试，输出的密文需要是随机的，或者近似随机的，这样的加密效果才好。衡量随机度的参数P-value越大则随机的可能性越高。参考：[知乎：如何评价一个伪随机数生成算法的优劣](http://www.zhihu.com/question/20222653)

下图比较形象的说明了随机数测试的问题[cited from https://www.random.org/analysis/ ](https://www.random.org/analysis/)
![Cited ](https://www.random.org/analysis/dilbert.jpg)
现在随机度测试的方法很多，如：NIST test set, DiEHARD test set等等，其中以美国国家标准与技术研究所的NIST最为著名：[NIST传送门](http://csrc.nist.gov/groups/ST/toolkit/rng/documentation_software.html)，[NIST安装过程介绍](http://blog.csdn.net/Tom_VS_Jerry/article/details/26086099)

NIST SP800-22 测试标准包含15个测试项，每个测试项都是针对被测序列的某一特性进行检测的，如下图所示。图片引用自[2]

![image](/assets/images/2015-05-11enflow.png)

####特征提取与选择
作者在文中利用NIST测试套件，通过不同的参数调节产生不同的测试小项，总共提取了188维度的特征。然后作者利用稀疏特征提取(Sparse Feature selection)。并在逻辑斯特回归中加入了1范数罚参。

####ELM 简介
传统的SVM和神经网络需要人们进行干预，学习速度较慢，学习泛化能力也比较差。极限学习机具有较快的学习速度以及良好的泛化性能。然而，它的性能还可以得到很大提高，主要基于两个原因[3]：(1)极限学习机网络中的隐层节点可以减少；(2)网络参数不必每次都调节。

我感觉ELM和传统神经网络学习过程中最大的区别就在于如何求解最小化损失函数。传统的神经网络在学习过程中，学习算法需要在迭代过程中调整所有参赛。而在ELM算法中，直接通过求H的广义逆矩阵，输出权重\\(\beta\\)就可以被确定。

为啥不需要调节参数了呢，原来Huang 已经证明了具有随机制定的输入权值、隐层阈值和非零激活函数的单隐层前馈神经网络可以**普遍近似**任何具有紧凑输入集的连续函数。由此可以看出，输入权值和隐层阈值可以不必调节[3]。


另外可以参考[ELM算法简介](http://blog.csdn.net/google19890102/article/details/18222103)

以及[ELM intro](http://www.ntu.edu.sg/home/egbhuang/)

还有[ELM算法基础](http://blog.csdn.net/itplus/article/details/9277721)

####论文[6]阅读笔记
作者在文章中介绍了加密流量识别的基本情况，强调了最近的进展和未来的发展可能会遇到的挑战。文章中指出，加密流量类型主要集中在：SSH，VPN，SSL,加密P2P，加密VoIP，匿名网络流量。

仅仅粗粒度区分加密和非加密流量是远远不够的，现实世界迫切需要的是从加密中获取应用层类型。这显然是相当复杂的工作，许多方法的综合运用才可能达到该目的。另外，协议混淆（traffic obfuscation）和流量变形（traffic morph）可以达到绕过基于机器学习的统计分类的效果，同样是未来的挑战之一。论文没有开放下载，只读了其中能看到的部分，就已经读到的内容来看，感觉文章综述很一般。

###SSL/TLS应用层流量识别
####1.论文[4]阅读笔记
在未加密情况下识别应用层类型是比较成熟的，然而在加密情况下识别就相对困难许多。

作者在文章中提出了使用随机指纹（*stochastic fingerprints*）来识别SSL/TLS会话过程中的应用类型。指纹是基于一阶马尔可夫链的，然后马尔可夫链的参数是通过训练集合学习得到的。由于参数的不同性，该方法能有效的检测出应用层类型，以及异常的SSL会话过程。

该方法和一些其他的SSL指纹识别方法比较类似，也是利用SSL/TLS握手过程中的头部信息。不同之处在于作者利用的是基于马尔可夫链随机指纹，将不同应用层类型的SSL/TLS握手过程的状态转移形成带有不同参数的马尔科夫状态转移链。作者在论文中对12项常用的SSL类型进行了建模：例如PayPal,Twitter,Skype等等。

####2.论文[5]阅读笔记
传统的基于载荷的和机器学习的方法给系统造成的负载较大。作者提出了利用基于指纹和统计分析的混合方法来解决该问题。作者首先使用指纹来检测出SSL/TLS，然后再利用统计分析来找出确定的应用层类型。实验结果表明，该方法能够99%识别SSL/TLS流量，并达到F-score为94.52%的应用层识别效果。

作者识别SSL/TLS流量的方法主要还是基于流量关键字段特征，这点和普通方法没区别。作者将SSL/TLS流量识别出来之后，又用了贝叶斯方法来对加密流的特征进行学习，统计特征包括：平均包长度，最大最小包长度，平均包到达间隔时间，流持续时间，流所包括的包数量。总体感觉创新不是很大。

####参考文献
[1]Meng J, Yang L, Zhou Y, et al. Encrypted Traffic Identification Based on Sparse Logistical Regression and Extreme Learning Machine[M]//Proceedings of ELM-2014 Volume 2. Springer International Publishing, 2015: 61-70.

[2]侯佳音, 萧宝瑾. 随机数测试标准与随机数发生器性能的关系[J]. 2012.

[3]王建功. 基于极限学习机的多网络学习[J]. 2010.

[4]Korczynski M, Duda A. Markov chain fingerprinting to classify encrypted traffic[C]//INFOCOM, 2014 Proceedings IEEE. IEEE, 2014: 781-789.

[5]Sun G L, Xue Y, Dong Y, et al. An novel hybrid method for effectively classifying encrypted traffic[C]//Global Telecommunications Conference (GLOBECOM 2010), 2010 IEEE. IEEE, 2010: 1-5.

[6]Cao Z, Xiong G, Zhao Y, et al. A Survey on Encrypted Traffic Classification[M]//Applications and Techniques in Information Security. Springer Berlin Heidelberg, 2014: 73-81.
> Written with [StackEdit](https://stackedit.io/).