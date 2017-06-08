---
layout: post
title: Deep Learning
description: “Start to learn deep learning”
categories: [Machine Learning]
tags: [Deep Learning]
group: archive
music: []

---

![image](https://www.gitbook.com/cover/book/deep-learning-cn/deep-learning-cn.jpg?build=1461768620204)
Deep learning stuff, last update (2017.3.1)
<!-- more -->

### 本文概要
本文主要介绍Deep learning 和整理我所看到的一些资料，持续更新 (Keep updating, once I have time)。


### 深度学习的优势与不足

优点：

1. 在研究中可以发现，如果在原有的特征中加入这些自动学习得到的特征可以大大提高精确度，甚至在分类问题中比目前最好的分类算法效果还要好[3]
2. 非监督学习


缺点：

1. 深度学习的一个主要优势在于可以利用海量训练数据（即大数据），但是依赖于反向传播算法，仍然对计算量有很高的要求。
2. 比起统计方法来说 那当然就是模型难以诠释，找出来的 Feature 对人而言并不直观。


### Tensorflow
使用Tensorflow需要知道：

>The central unit of data in TensorFlow is the **tensor**. Tensorflow基础数据单元，其rank就是训练数据的维度 (训练数据是几维的)

>A **computational graph** is a series of TensorFlow operations arranged into a graph of nodes. 计算图？ 

>To actually evaluate the nodes, we must run the computational graph within a session. **A session** encapsulates the control and state of the TensorFlow runtime. 计算评估模型需要一次会话

>**A placeholder** is a promise to provide a value later. 就是说数据现在没有，以后有了再提供
，先登记一下

>**A Variable** tf.Variable变量， tf.constant常量，变量是没有初始化的，常量是一调用就被初始化了的，然后就不变了。变量如果需要初始化，需要调用

```python
init = tf.global_variables_initializer()
sess.run(init)
```






#### Refs
[1] LeCun Y, Bengio Y, Hinton G. Deep learning[J]. Nature, 2015, 521(7553): 436-444.

[2] 将Keras作为tensorflow的精简接口 https://keras-cn.readthedocs.io/en/latest/blog/keras_and_tensorflow/

[3] http://blog.csdn.net/zouxy09/article/details/8775524

[Cuda install guide ] https://www.tensorflow.org/versions/master/get_started/os_setup#optional-install-cuda-gpus-on-linux

