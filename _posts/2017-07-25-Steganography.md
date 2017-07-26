---
layout: post
title: My first impression on the network steganography
description: “”
categories: [Infosec]
tags: [Steganography]
group: archive
music: []

---

![image](/assets/images/steganography.jpg)

网络数字隐写技术初探及我的个人感悟。

<!-- more -->

### 数字隐写技术和网络数字隐写技术

**网络隐写技术的目的**就是为了保证数据传输内容的隐蔽性，同时确保通信过程不能被他人发现。

数字隐写技术是关于信息隐藏的技巧与科学。所谓信息隐藏指的是不让除预期的接收者之外的任何人知晓信息的传递事件或者信息的内容[1]。数字隐写技术来源于自然界，例如动物的伪装术。早在古希腊就有隐写术的发展，之后的战争年代又有了隐形墨水的产生。

数字隐写技术自1970年始，已在数字媒体防伪上运用广泛，技术也比较成熟。然而网络数字隐写技术是近年来发展迅猛，目前还是比较年轻的信息隐藏分支研究。网络数字隐写技术相较于数字隐写技术，有两个优点： 1. 网络数字隐写的数据传输能力更强，传统的数字隐写技术传输内容受限于传输媒介（一首歌、一部视频或者一幅图片），然而网络数字隐写技术传输内容可以按需获取。2. 网络数字隐写技术让信息泄露成为可能，通过长时间的少量数据传输，达到泄露信息的目的，例如APT。

网络数字隐写技术timing based 或者 storage based 两种技术，如下图所示。 Timing based主要是利用网络数据包传输时间和数据包间隔时间来写入隐蔽信息，比较常见的是数据包发送率隐写，数据包间隔时间隐写（按一定规律延迟发送），但是上述方法对时间比较敏感，应用起来比较困难。Storage based技术主要利用修改或者增加某字段或者将隐蔽信息直接存储到媒介中。常见的增加字段包括IP hearder option 字段， HTTP header等。

![image](/assets/images/classification.png)



### 衡量网络数字隐写性能

隐写带宽（steganography bandwidth）: 单位时间内隐写内容传输大小
健壮性（robustness）：隐写技术能承受多大的外界干扰并且不影响隐写内容
隐蔽性（undetectability or invisibility）：隐写技术不能被检测出来

关于隐蔽性，很多文章都声明自己所提出的方法是隐蔽的，但是这些方法大多缺乏理论证明。后续也有工作证明之前提出方法不是隐蔽的[4]，例如Rainbow[5]。

健壮性和隐蔽性两个性能指标是此消彼长的关系，因此这两个指标的衡量最好是一起进行考虑的，而不是像之前的论文中分开进行讨论。


### 网络数字隐写的应用

1. 流量混淆变形技术，traffic morphing or traffic type obfuscation
2. 隐蔽通信技术，covert communication 
3. 溯源技术，traceback techniques i.e. flow watermarking and flow fingerprinting

网络隐写技术可以用于匿名网络追踪溯源。很多方法也被提出用于匿名网络（Tor）溯源，例如DSSS[6]等。这些方法都有个共同假设：假设攻击者可以恰好位于通信的两端，然而事实并非如此。

对于溯源技术来说，storage based的方法一般效果不佳[4]，因为数据包都是加密的，无法修改其内容。因此目前大多数方法是timing based隐写技。尽管论文中给出了较好的溯源效果，但是目前并未具体实践运用。



### 检测方法

目前的网络隐写技术检测方法没有一个general的方法，大多检测方法是针对某一特定协议进行设计。而且Moskowitz和kang等很多学者认为，几乎不存在某种方法可以检测所有的covert channel。

**Flownormalizer**的工作原理如下图所示，主要工作原理就是去除数据包或者数据内容的不一致性，让他们变得都和预设规则设定的一样。不足之处是可能会破坏某些协议功能。

![image](/assets/images/flownormalizer.png)

**网络审计**（Network auditting），适用于事后分析和异常检测。

**异常检测**，通过对比正常的字段内容，检测某些协议header一些比较奇怪的字段内容。

另外，可以利用**形式化检测方法**来检测协议设计之初是否存在隐藏通道，但是这方面研究很少。

最后，比较有前景的通用检测方法就是**机器学习**了。但是目前机器学习方法都只适用于某一特定的covert channel。不足之处还在于，需要正常的和隐蔽通信的流量数据，不仅是很难获取而且还很难标记。





### 结语

网络隐写技术尽管是一个非常有趣的研究方向，但是我感觉这个研究方向研究起来有点新手不友好。因为，我大概搜索了一下现有方法，但是并没有发现这些方法的开源代码。而且现在并没有这些方法的对比和评估实验，很多论文提出的新方法都是没有和别的方法进行对比。所以很难说这些方法到底哪个更好，复现原有方法也比较困难。

--------

### 参考（Refs）

[1] https://zh.wikipedia.org/wiki/隐写术.

[2] Information hiding in communication network. Wojciech Mazurczyk, Steffen Wendzel, Sebastian Zander, Amir Houmansadr et al. ISBN: 978-1-118-86169-1, February 2016, Wiley-IEEE Press

[3] http://www.garykessler.net/library/steganography.html

[4] Iacovazzi, Alfonso, and Yuval Elovici. "Network Flow Watermarking: A Survey." IEEE Communications Surveys & Tutorials 19.1 (2017): 512-530.

[5] Houmansadr, Amir, Negar Kiyavash, and Nikita Borisov. "RAINBOW: A Robust And Invisible Non-Blind Watermark for Network Flows." NDSS. 2009.

[6] Yu, Wei, et al. "DSSS-based flow marking technique for invisible traceback." Security and Privacy, 2007. SP'07. IEEE Symposium on. IEEE, 2007.




