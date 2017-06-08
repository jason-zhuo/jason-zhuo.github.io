---
layout: post
title: "Structure Risk Minimization,SRM"
description: ""
categories: [Machine Learning]
tags: [SRM,Machine learning]
music: []

---
![image](/assets/images/2015-04-18-StatML.png)
本周学术交流，张老师给我们介绍了结构风险最小化原理，这篇博客对交流内容进行了精炼和总结。
<!-- more -->
## 结构风险最小化

----------

基于数据的机器学习有2个方法，第1个是经典的统计估计方法，通过训练样本来估计参数值，代表是R.A Fisher 的统计理论（线性回归）。但我们经常做的预测真的**靠谱**吗？答案是，不靠谱，因为我们在做预测的时候，引入了一个很强的假设条件———样本集要满足独立同分布条件（iid-independent identically distribulted）。

第2个方法是V.Vapnik等人提出的统计学习理论。该理论也被称作VC理论，最重要的概念就是VC维。VC维~函数复杂度~是一个正整数（也叫做函数容量）。函数复杂度越大，预测效果越差。


$$R_{exp}=\int L(y,f)p(x,y)dxdy \leq \frac{1}{m} \sum_i^{m} {(y_i-f(x_i))}^2 +\psi(\frac{V(f)}{m})$$


其中\\(V(f)\\)就是函数VC维，m为样本个数。上式表明在样本一定的情况下，VC维越高，期望风险越大。


统计学习理论-结构风险最小化SRM:  
        $$期望风险<=经验风险 + 置信度$$


这里简单介绍一下Vladimir Vapnik。Vladimir Vapnik是俄国人，1936年出生。1964年，他于莫斯科的控制科学学院获得博士学位。毕业后，他一直在该校工作直到1990年，这期间他作为不多（估计在国内可能有点那个），但是1991加入贝尔实验室之后，他在1995年发明了SVM。从此，他就出名了，2006年当上了美国科学院院士。
![image](/assets/smilies/16.gif)


>所谓的结构风险最小化就是在保证分类精度（经验风险）的同时，降低学习机器的 VC 维，可以使学习机器在整个样本集上的期望风险得到控制。

见图：
![image](http://img.my.csdn.net/uploads/201105/29/0_1306659245j5ZS.gif)

张老师随后介绍了SVM中最著名的核方法。将低维度转化到高维度，计算复杂度却和低维度差不多。这太牛了，佩服Mercer。张老师补充到，这个是1911年提出来的（当时清王朝刚被推翻，国内可能无人潜心科研吧），之后Mercer的论文成为了睡美人，直到后来被Vapnik发现。

**核函数**

$$<\psi(x),\psi(y)>=k(x,y)$$

核函数的作用

$$R^{n} \to H^{\infty}$$ 
(H为Hilbert空间)

非线性问题**一定**能够线性化

