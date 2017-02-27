---
layout: post
title: “Go language using“
description: "Paper reading"
categories: [New stuff]
tags: [Go]
group: archive
music: []

---

![image](https://cdn-images-1.medium.com/max/1800/1*3BB0kiPsh2ftMT9dKg9_GA.jpeg)
Go language using and some thoughts, last update (2017.2.23)
<!-- more -->

###本文概要
本文主要介绍Go语言的使用，以及整理我所看到的一些资料。

###开篇


我们经常听到一句话

>其实这个年代你用什么编程语言都可以，只要能够熟练运用。

精通一门语言对于我们学计算机的人来说确实够用了，我们掌握的其实不是语言，而是语言背后的逻辑思想（算法）。但事实上笔者认为在编程语言上还是需要有一定的选择，物尽其用，觉得用什么语言方便实现就用什么语言。本来笔者也是不想学Go编程语言的，但是看到其优越的特性，感觉不学的话会跟不上时代了。


论文The effect of DNS on Tor’s Anonymity 中使用了Go语言进行代码编写。作者搜集Alexa前100万的DNS流量，无论是从数量级还是工程难度来说都是具有一定挑战的。这篇blog就是学习一下大神是如何利用Go的优势的。

###Go语言
网上说了很多关于Go语言的优劣势分析，稍微谷歌一下就行了。这里我只总结一下我觉得Go语言的优势吧(部分参考[1])。

1. **部署简单**。Go 编译生成的是一个静态可执行文件，除了 glibc 外没有其他外部依赖。这让部署变得异常方便：目标机器上只需要一个基础的系统和必要的管理、监控工具，完全不需要操心应用所需的各种包、库的依赖关系，大大减轻了维护的负担。 **笔者点评：人生苦短，何必浪费时间搭建环境呢，配置环境变量呢！这个特性无敌**
2. **服务器，并发编程实现容易，上手简单。**
3. **跨平台支持**。在mac上编译的go运用程序，可以跑在各种类型的操作系统上，而且目标操作系统都不需要Go编译环境。 **笔者点评：我也非常喜欢这个特性，java还得装jvm才能跨平台**

####DNS 数据搜集
在论文The effect of DNS on Tor’s Anonymity 中， 作者对Alexa top 100 million网站的DNS数据抓取采用了Go+docker的模式来进行。 作者实现了一个server来分任务给位于dockers中的workers. server服务端和docker客户端都采用的Go语言进行编写。 sever负责将alexa 网站地址传给worker，然后通过RPC调用将worker搜集到的pcap返回并保存。







####Refs
[1] https://www.zhihu.com/question/21409296

