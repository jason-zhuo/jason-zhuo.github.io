---
layout: post
title: "hello world again"
description: "Test math equation"
categories: [Machine Learning]
tags: [Math equation]
music: []

---
I'm back!
<!-- more -->
时隔了这么久没写过博客，感觉有点对不起起初建立博客的初衷。于是想把我的博客给恢复起来。今天尝试了向我的博客里面添加数学公式的方法：
###添加行内公式
	\\(公式\\)
###添加行间公式
	$$公式$$

例如行间公式：\\(\sum_{i\to 2}^i\\)

$$\sum_{i\to 2}^i$$

具体来说实现比较简单：
如果用Mou渲染Math公式，尝试在**default.html**加上如下js，表示让Mou去加载Mathjax的脚本

`<script type="text/javascript"
 src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>`

在试过上面的方法后，我还尝试了直接在mou编辑过程中加入上述代码：
![image](/assets/images/2015-04-16-mathequa.png)

加入之后倒是可以一边编辑一边看到编辑结果，但是容易造成Mou在渲染过程中的卡顿，不推荐这样使用。

编辑完成之后，在上传之前可以进行检查，把上述图中的代码加入就可以进行检查了。

在此庆祝我的博客复活啦，以后就可以写写高大上的数学公式了~ 就这样了，碎觉碎觉，累死累活！

>... in mathematics you didn't understand things, you just get used to them. --J.von.Newmann 
--