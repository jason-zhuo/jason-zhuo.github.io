---
layout: post
title: "Big data Short notes"
description: ""
categories: [big data]
tags: [Big data]
music: []

---
Bigdata培训课程，听了一天，感觉听不大懂，工程细节上的东西太多了，而且自己这方面也刚刚起步，因此本文就稍微记一下我比较感兴趣的内容。
<!-- more -->
### Spark Streaming 

>目前的大数据处理可以分为如下3个类型：

 1. 复杂的批量数据处理：10min~数小时
 2. 基于历史数据的交互式查询： 10sec~ 数分钟
 3. 基于实时数据流的数据处理（Streaming data processing): 数百毫秒到数秒

除了Spark，流式计算计算系统比较有名的包括Twitter Storm和Yahoo S4。现在所提及的Storm主要是指Apache Storm ，Apache Storm的前身是 Twitter Storm 平台，目前已经归于 Apache 基金会管辖。Storm已经出现好多年了，而且自从2011年开始就在Twitter内部生产环境中使用，还有其他一些公司。而Spark Streaming是一个新的项目, 2013年开始。

Spark的流式计算还是要弱于Storm的，作者在[这篇文章中](http://www.csdn.net/article/2014-08-04/2821018)认为互联网公司对于Storm的部署还是多于Spark。这篇文章对[流式计算](http://blog.csdn.net/anzhsoft/article/details/38168025)系统的设计考虑的一些要素进行了比较详细的讨论。这篇文章介绍了Storm和Streaming框架的[对比](http://www.open-open.com/lib/view/open1426129553435.html). 如此说来，Storm在以后的项目中估计要用到![image](/assets/smilies/8.gif).

相对与**Mapreduce**来说，Mapreduce的输入数据集合是静态的，不能动态变化。因此适合于离线处理。Mapreduce的使用场景包括，简单的网站pv,uv统计，搜索引擎建立索引，海量数据查找，复杂数据的分析和算法实现（聚类，分类，推荐，图算法等）

__Yarn__ 的提出，解决了多计算框架直接的数据无法共享问题，同时负责集群资源的统一管理和调度。

运行在YARN上的计算框架：
1. 离线计算框架Mapreduce
2. DAG计算框架Tez
3. 流式计算框架Strom
4. 内存计算框架Spark


> Written with [StackEdit](https://stackedit.io/).
