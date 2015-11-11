---
layout: post
title: "Dieharder and STS"
description: "Dieharder and STS"
categories: [infosec]
tags: [encrypted flow]
music: []

---

###Random or not? Dieharder and STS
![image](http://i.stack.imgur.com/12L2d.gif)
Dieharder以及STS 套件使用 coauthored by Zihao Li, Jason Zhuo
<!-- more -->

###1. 介绍
Dieharder是一个功能强大的软件，它是用来测试一序列伪随机数的随机性能的测试套件。


###2.基本操作演示
使用Sts的话，首先安装sts，然后在终端定位到其目录。输入：

>./assess number

可以开始测试，此处number是单个流的大小。接着输入0选择输入文件，然后写入文件的目录加载文件，如（data/000）。在检测算法列表中选择相应算法，此处填1可以全选，0则选择某几个。某些算法会让使用者设置块大小，这个是在检测时会用到的参数，可以选择使用缺省值。然后输入你准备测试的流的数目，其大小在开始时就已设置，选中你所读入文件的储存格式，如AscII和二进制保存。然后在experience/Algorithm Testingz中的相应文件查看测试结果。


>dieharder -l

出现基本功能列表（dieharder所有的检测算法），-d 15便是测试内置发生器。

![dieharder -l](/Users/zhuozhongliu/JasonzhuoGithubIO/assets/images/2015-10-10.png)

接着可以输入dieharder -g -1显示所有的发生器。

![dieharder -g](/Users/zhuozhongliu/JasonzhuoGithubIO/assets/images/2015-10-10-2.png)
假如准备对第41进行测试，则输入dieharder -d 15 -g 41 -t 1000000,其中-t是选择发生器所产生序列的大小。
	


Dieharder操作外部产生器产生的随机数流操作，在此详述：先载入到文件目录，对于文件分为AscII码和二进制存储分别对待。

>使用dieharder -g 201 -f 文件名 -a，然后会输出结果；

对于AscII码文件，需输入

>dieharder -g 202 -f 文件名 -a

同时，这个文件的头部应做适当修改，否则无法读取。（注：对于二进制文件测试命令 dieharder –g 201 –f 文件名 –a,此处的-a指的是将运行所有的算法来检测文件，如果希望指定某一种算法时，可以使用dieharder –g 201 –f 文件名 –d 数字，此方法对于AscII同样适用）

头部修改举例：


>type: d

>count: 100000

>numbit: 32

>3129711816

>85411969

>2545911541

![dieharder -g 201 -f BBS.dat –a](/Users/zhuozhongliu/JasonzhuoGithubIO/assets/images/2015-10-10-3.png)

###两者对比
| Name        |针对目标          |得到结果 |文件大小 | 操作步骤|是否友好| 对数据随机性的严格程度|
| ------------- |:-----------:| :-----:| :-----:| :-----:|  :-----:| :-----:| 
|STS     | 待检测其随机性的序列     |   较为详细，有明确的中间过程量 |  在处理大容量文件时速度一般|步骤多但明确，且有详细注释|操作较为友好|较为严格|
| Dieharder| 待验证其产生序列是否随机的随机数产生器|只有一个P-value结果，且没有中间过程量|面向文件容量较大，速度较为优秀| 输入命令较为令人费解，且需要对各操作目录比较熟悉，虽然简洁但不简单|操作步骤比较不友好，需要对软件有一定程度的理解|比较宽松


###后记



####Useful site :

[Dieharder home page](https://www.phy.duke.edu/~rgb/General/dieharder.php)

[Random.org](https://www.random.org/)