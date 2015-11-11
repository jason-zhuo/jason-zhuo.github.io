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
Dieharder主要测试rng（随机数产生器）的性能，它里面整合了一部分随机数产生器。其大致原理还是对随机数序列进行测试，但是其过程是先选中发生器，然后由发生器产生一序列的随机数，最后对发生器进行评估。不过Dieharder允许产生器产生较大的随机数序列。Dieharder在第三版中增添了**全套**的sts对于随机数测试的逻辑，但是并没有使用其源代码。基本操作方面，Dieharder网页上面的介绍只提及了如何测试内置发生器性能的操作，对于其他并没有过多提及。基本操作比较简洁，但是不是特别友好，需要输入的命令必须要特别熟悉才能够在不打开操作列表（dieharder -l）和内置发生器列表(dieharder -g -1)，同时操作时命令行的格式并没有规定，不确定要如何输入，相关操作方面还在摸索。（如-d和-g的位置在某些情况下需要变换，此处并没有介绍）Sts功能较为单一，只是对随机数序列进行测试并评估其随机程度。但其步骤较为清晰且容易操作。简单来说，如果只是为了将加密后的数据包进行分析，无疑Sts是较为干脆的。这里不确定数据包加密算法是否可以在Dieharder上测试，因为不确定加密算法算不算是一个随机数发生器。如果是为了检测数据包是否被加密过，则Sts是一个好的选择。

###2.基本操作演示
使用Sts的话，首先安装sts，然后在终端定位到其目录。输入：

>./assess number

可以开始测试，此处number是单个流的大小。接着输入0选择输入文件，然后写入文件的目录加载文件，如（data/000）。在检测算法列表中选择相应算法，此处填1可以全选，0则选择某几个。某些算法会让使用者设置块大小，这个是在检测时会用到的参数，可以选择使用缺省值。然后输入你准备测试的流的数目，其大小在开始时就已设置，选中你所读入文件的储存格式，如AscII和二进制保存。然后在experience/Algorithm Testingz中的相应文件查看测试结果。
对于Dieharder，可以先输入

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
>generator mt19937_1999 seed = 1274511046

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


###后记操作过程sts要容易一些，该软件更方便新手操作。dieharder更为简洁，将所有操作凝练在一行，使用者要对该软件有一定程度的熟悉。如此一来，利用dieharder进行测试也是较为方便的，不过dieharder没有sts那样可以查找到中间量的数据，而且暂时还没有找到如何控制dieharder进行部分文件读入的操作。（补充：方法已找到，在后面直接接-t 数字即可，比如dieharder –g 201 –f BBS.dat –d 101 –t 10000.此处的意思是使用-g 201来读入BBS.dat文件，同时使用 -d 101来进行测试，其中只读取10000位）
dieharder无疑是更强大的，暂时使用有些生涩，不过其内含算法要比sts多，如果希望向更深处探究无疑dieharder更好一些。
使用两种软件对BBS.dat中等长的部分文件进行测试，就P-value而言，sts得出的值要略小一些。dieharder并没有展示其计算逻辑，但是应该也是对随机数进行测试，不过应该会对结果进行分析得出针对发生器的P-value。其网站上并不认同单独拿出一段数据测试其随机性是很好的手段，其认为应该从发生器的角度去思考，同时它对发生器的态度比较宽容，在P-value比较小的时候（小于0.01只是视为weak，小于0.01%才会被拒绝）它也承认这个发生器是合理的，而且weak级别的发生器也可以产生正常的随机数。所以单独就数据随机性检测而言，个人认为sts要严格一些。

####Useful site :

[Dieharder home page](https://www.phy.duke.edu/~rgb/General/dieharder.php)

[Random.org](https://www.random.org/)