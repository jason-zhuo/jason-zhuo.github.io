---
layout: post
title: "Matlab2014b Install"
description: ""
categories: [new stuff]
tags: [Matlab]
music: []

---

![image](/assets/images/2014-11-18-matlab.png)
本文描述了作者安装matlab2014b的折腾手记，本着折腾自己方便他人的思想，体现了作者乐于助人的中心思想。
<!-- more -->
距离上一次写博客都好久了，于是本文出于为了不忘记如何写博客以及就很多小伙伴的问题进行统一解答的目的，写下了折腾手记。本文不鼓励大家使用盗版软件。支持正版，人人有责，本文作者在XBG童鞋的诱惑下，已经在app store上购买了超过300元的正版软件。

>使用正版就是免去了折腾的麻烦，珍爱生命，请用正版。——本文作者

好多用Mac的童鞋在升级最新的操作系统之后，就无法使用Matlab了，这为我们科研造成了一些小麻烦。最新的Matlab2014b可以在Yosemite上面运行。特别感谢破解人员的辛勤劳动，我这里就补充一些细枝末节的东西，以解答小伙伴们在MAC平台下安装过程中的一些问题。

首先给出[Matlab2014b全部平台的下载链接](http://bbs.feng.com/read-htm-tid-8467093.html)

####问题：
1. 作者好不容易下载完成，然后解压运行，发现matlab mac版本提示powerpc应用程序不再被支持。
2. 载入镜像安装，输入密钥后发现产品列表里面只有几个基本插件，其他功能都不在了

####解决办法：
1. 下载的iso文件千万别用the unarchiever解压，右键iso文件，注意是iso不是解压出来的那个图标，用DiskImageMounter打开。![image](/assets/images/2014-11-18-matlab1.png)
2. 使用UltraISO编辑下载的matlab的ISO文件，[UltraISO下载](http://www.downxia.com/downinfo/659.html)

用UltraISO打开matlab的ISO文件:

![image](/assets/images/2014-11-18-matlab3.png)

进入matlab的ISO文件目录java/jar/，删除install.jar

![image](/assets/images/2014-11-18-matlab4.png)

再添加破解的install.jar

![image](/assets/images/2014-11-18-matlab5.png)

最后点保存
![image](/assets/images/2014-11-18-matlab6.png)
![image](/assets/images/2014-11-18-matlab7.png)

断网后，再次用DiskImageMounter打开matlab安装程序，输入刚才使用的密钥：29797-39064-48306-32452。发现已经有很多功能了，进行正常安装需要（9GB+）。默认情况下我们用不到那么多工具包，为了节约磁盘空间，可以将一些不常用的，非本专业的工具包取消。（视个人情况而定,可以全部安装）

正常安装完成后，激活即可：
activation file = license.lic

![image](/assets/images/2014-11-18-matlab8.png)
![image](/assets/images/2014-11-18-matlab9.png)

然后在应用程序中找到刚刚安装完成的Matlab.app，右键进入包内容，将/Applications/MATLAB_R2014b/bin/maci64/libmwservices.dylib 用破解的该文件进行替换即可

####最后就可以愉快地进行科研活动啦~！