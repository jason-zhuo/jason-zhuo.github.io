---
layout: post
title: "Random forest clustering"
description: ""
categories: [Machine Learning]
tags: [Random forest, clustering]
music: []

---

### 随机森林聚类（Random forest clustering）

---
![image](/assets/images/2015-05-23-randforest.png)
随机森林聚类分析
<!-- more -->

### 1.起因
网络上现存的很多资料都是关于随机森林的分类和回归分析，但很少有材料讲解随机森林的聚类分析过程。
随机森林以及随机森林的分类回归过程我就不做详细介绍了，你可以参考网络上的其他资料 [1]，[2], [3], [8]。

分析随机森林聚类算法还有如下的原因：

>GBDT和随机森林在ESL书里面说是目前最优的两种算法

然后呢，最近也在研究一些新的聚类算法，就顺带研究一些随机森林是如何用了聚类的吧。


### 2.随机森林聚类

随机森林聚类算法的最核心思想：

**1. 将非监督学习转换为监督学习** 

**2. 相似度矩阵的计算**


合成数据集（synthetic dataset）中包括的样本是通过样本合成算法产生新的样本的集合。最常用的就是合成算法就是生成和原始数据集（Orignial dataset）样本数量一致，相同特征的集合。

举个网上的例子[7]来说吧：
假设有两个特征\\(x_1\\),\\(x_2\\).其中，\\(x_1\\)是连续变量服从\\(Normal(0,1)\\),\\(x_2\\)是0，1分布。一种合成数据的方法是根据每个特征的分布进行估计，值得注意的是随机生成的数据是各自独立的。另外一种合成方法是根据样本的概率进行随机选择，例如在样本中\\(P(male)=0.4\\),\\(P(female)=0.6\\)，那么合成的\\(x_1\\)的值就从原始数据集里面随机选择一个，合成的\\(x_2\\)的值就按照上述概率生成0或1。


新的训练样本集合多了一个新的特征，该特征用来区分该样本是合成的还是原始的，用二进制表示即可。
>新的训练样本集合（多一个类标签特征）=合成样本数据集合+原始数据集合

#### 2.1相似度矩阵

随机森林在建模的同时，还提供了样本相似性度量，即相似度矩阵(简记为 Prox 矩阵)。当用一棵树对所有数据进行判别时，这些数据最终都将达到该树的某个叶节点上.可以用两个样本在每棵树的同一个节点上出现的频率大小，来衡量这两个样本之间的相似程度，或两个样本属于同一类的概率大小。
 
Prox矩阵\\(P=p_{ij} \\)生成过程如下：

1. 对于样本数为N的训练集合，首先生成一个\\(N\times N\\)的矩阵，\\(p_{ii}=1\\)，其他元素为0。
2. 对于任意两个样本\\(x_i\\),\\(x_j\\),若他们出现在生成的同一棵树上的同一个叶节点上，则$$p[i][j]= 1+p[i][j]$$
3. 重复上述过程直到m棵树全部生成，得到相应的矩阵
4. 进行归一化处理$$p[i][j]= \frac{p[i][j]}{N}$$

在随机森林进行聚类的过程中，运用到到了两个样本之间的相似度进行计算。我们知道在聚类算法中存在很多衡量两个样本之间距离的方法，欧几里得距离等等。但是在随机森林中的距离是如下计算的[5]:

$$DISSIM[i][j]= \sqrt{1-p[i][j]}$$

#### 2.2随机森林聚类计算过程
随机森林聚类算法：

1. 生成合成样本集合
2. 生成新的带类新标签的训练集合N，样本只包括两类：合成的数据，原始的数据
3. 根据N生成相似度矩阵P
4. 将P中被我们标记为合成数据的行和列删除
5. 运用其他聚类算法进行聚类

为啥我们要生产合成数据集，然后还要将其加入原始训练集合呢？我直观地认为直接在原始数据集上算相似性不就ok啦。后来我反应过来，但是原始数据是不带类标签的（非监督学习）。产生合成数据集的目的就是和原始数据进行类标记，将非监督学习转换为监督学习。

步骤5中居然采用还是其他的聚类算法，只不过替换了距离测量方法，这点感觉有点那个啥<img src="/assets/smilies/30.gif" id="similey">。



#### 2.3随机森林聚类应用

文献[3]和文献[4]主要是用随机森林对医疗疾病属性的聚类，文献[3][4]用的是PAM（Partitioning around medoids）聚类算法。
随机森林的Prox矩阵可以作为多个基于不相似度聚类算法的输入，例如文献[5]中同样利用的是K-Medoids聚类算法PAM。作者将其应用到网络流量的聚类上，还比较创新。


#### 2.4随机森林聚类Case study

利用R语言中的函数`rfClustering(model,noClusters=4)`进行聚类分析，这个例子中没有体现出合成数据集合的生成的，因为iris数据集是带类标签的。

1. `set<-iris` 载入iris数据集，iris数据集是带类标签的
2. `md<-CoreModel(Species ~., set,model="rf",rfNoTrees=30)` 利用随机森林得到模型，模型md中包括了相似度矩阵
3. `mdCluster<-rfClustering(md,3)`聚成3类

`rfClustering`这个函数根据作者介绍，内在是调用的PAM聚类算法的。

聚类结果：

![image](/assets/images/2015-05-23rfresult.png)

### 参考文献


[1][http://www.cnblogs.com/leftnoteasy/archive/2011/03/07/random-forest-and-gbdt.html](http://www.cnblogs.com/leftnoteasy/archive/2011/03/07/random-forest-and-gbdt.html)


[2][http://blog.sciencenet.cn/blog-661364-615921.html](http://blog.sciencenet.cn/blog-661364-615921.html)

[3][http://blog.csdn.net/songzitea/article/details/10035757](http://blog.csdn.net/songzitea/article/details/10035757)

[4]Shi T, Seligson D, Belldegrun A S, et al. Tumor classification by tissue microarray profiling: random forest clustering applied to renal cell carcinoma[J]. Modern Pathology, 2005, 18(4): 547-557.

[5]Shi T, Horvath S. Unsupervised learning with random forest predictors[J]. Journal of Computational and Graphical Statistics, 2006, 15(1).

[6]Wang Y, Xiang Y, Zhang J. Network traffic clustering using Random Forest proximities[C]//Communications (ICC), 2013 IEEE International Conference on. IEEE, 2013: 2058-2062.

[7][http://stats.stackexchange.com/questions/92725/unsupervised-random-forest-using-weka](http://stats.stackexchange.com/questions/92725/unsupervised-random-forest-using-weka)

[8][http://www.zilhua.com/629.html](http://www.zilhua.com/629.html)