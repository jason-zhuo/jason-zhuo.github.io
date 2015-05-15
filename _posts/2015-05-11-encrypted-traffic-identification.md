---
layout: post
title: "Encrypted Traffic identification"
description: "paper reading"
categories: [Infosec]
tags: [Machine learning, encrypted flow]
music: []

---


![image](/assets/images/2015-05-11enflow2.png)
2015加密流量检测论文阅读笔记
<!-- more -->



####目前还有效的加密流量识别方法

 1. 基于端口号的。
 2. 基于内容签名的。有些加密协议有固定特殊的内容特征。
 3. 基于流特征的。加密协议在进行密钥协商时具有特殊过程。
 
------------
####论文作者的方法
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


####参考文献
[1]Meng J, Yang L, Zhou Y, et al. Encrypted Traffic Identification Based on Sparse Logistical Regression and Extreme Learning Machine[M]//Proceedings of ELM-2014 Volume 2. Springer International Publishing, 2015: 61-70.

[2]侯佳音, 萧宝瑾. 随机数测试标准与随机数发生器性能的关系[J]. 2012.

[3]王建功. 基于极限学习机的多网络学习[J]. 2010.

> Written with [StackEdit](https://stackedit.io/).