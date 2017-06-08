---
layout: post
title: "Botnet and fast flux"
description: ""
categories: [Infosec]
tags: [Botnet,fast flux]
music: []

---
Botnet and fast flux 特征介绍；Botminer论文初看,僵尸网络论文阅读笔记（last update:2015.8.10）
<!-- more -->
## Botnet and fast flux

last update: 2016.3.5  增加了Fast flux 和 CDN之间的区别


-----
### 1.几个定义

**NS（Name Server）**：记录是权威域名服务器记录，用来指定该域名由哪个DNS服务器来进行解析。
 
**A record** A记录是名称解析的重要记录，它用于将特定的主机名映射到对应主机的IP地址上。你可以在DNS服务器中手动创建或通过DNS客户端动态更新来创建。

**Round-Robin DNS (RRDNS)**
: Round-robin的意思是循环的意思，顾名思义，这种DNS返回的A记录不只一个，返回的记录是一个列表，列表里面记录的先后顺序是循环出现的。

**Content Distribution Networks (CDN)**
: 中文名叫内容分发网络，和RRDNS比较类似，不过返回的记录的TTL值相对RRDNS更低。CDN系统能够实时地根据网络流量和各节点的连接、负载状况以及到用户的距离和响应时间等综合信息将用户的请求重新导向离用户最近的服务节点上。其目的是使用户可就近取得所需内容，解决 Internet网络拥挤的状况，提高用户访问网站的响应速度。

**Fast-Flux Service Networks (FFSN)**
: FFSN更加创新地利用了RRDNS和CDN的上述特性，来降低恶意服务器被发现和关闭的概率。FFSN的特点下面会讨论。


------
### 2.Fast flux特征
1. **不重复的IP地址数量**：通常情况来说合法DNS查询不重复的IP地址为1~3个，而fast flux查询结果中会有5~6个，以确保至少有一个IP可以连接。
2. **NS数量**：NS数量是指在单一次DNS 查询中所得到的NS （Name server）数量。客户端与DNS 主机进行查询时,可能透过快速变动网域技术掩护DNS 主机,因此NS Records 与NS 的A Records 可能有多笔记录,相较之下,合法的FQDN 其NS Records 与NS 的A Records比较少。
3. **ASN数量与注册时间**：指对ASN进行查询时，主机使用的IP所属的ASN是否属于同一个单位。由于CDN主机使用的IP所属的ASN多属于同一个单位，而fast flux主机大多分散在世界各地，与CDN向比较之下，主机使用的IP所属的ASN属于不同单位。注册时间能够缩小选取范围。
4. **Domain age**:指合法网站记录的TTL时间相对于恶意网站更长；恶意网站的FQDN与对应的IP记录不会长时间存留电脑，电脑必须时常进行DNS查询，以更新记录。RFC1912建议TTL最小为1~5天，这么长！而FFSN的TTL值一般小于600秒。但是一般不使用TTL值来判定FFSN，因为这样的误报率比较高，合法使用的CDN也会返回比较低的TTL值。因此TTL值一般用来区分FFSN/CDN和RRDNS.



#### 2.1 关于Fast flux的第一篇论文[3]
Fastflux网络和普通网络对比：

![image](/assets/images/fastflux.png)

Single flux网络和Double flux网络对比（Double flux比Single flux更加复杂）：

***doulbe flux 的A记录和NS记录都在变，而single flux网络的A记录变化而NS记录不变***

![image](/assets/images/singledoubleflux.png)

攻击者采用fast flux的动机主要有:（1）简单：仅仅需要1台mothership主机来serve master content还有DNS信息。（2）front-end 节点是对于攻击者来说是可以部分随时放弃的。（3）延长关键的backend core servers的生命周期。

真实网络中的Fast flux网络搭建过程：

1. 攻击者用伪造或者偷窃的银行卡信息购买一个域名（www.example.com）该域名可以和某银行的域名很相似（原因你懂的）。
2. 攻击者控制一部分主机群作为转发主机（Redirectors）或者临时租用一个僵尸网络。
3. 攻击者将Name server (NS)记录公布，要么指向公开的DNS服务器，要么指向受控的转发主机节点。
4. 搭建完成

在真实网络中的Fast flux技术主要使用在基于HTTP协议的botnet[3]。 

#### 常见僵尸网络检测程序
| Name        |TYPE                       |Protocols |
| ------------- |:-----------------------:| :-----:| 
|BotSniffer     | centralized servers     |   IRC,HTTP |  
| BotHunter      | structure independent  |Protocol independent |
| Botminer | structure independent  |    Protocol independent       |


### 3.BotMiner 初看

#####BotMiner的系统架构
![Structure of Botminer](/assets/images/2015-04-19-botminer.png)


#### 论文中的一些定义
**A平面**
: 主要检测恶意行为模型,文章用Snort检测某主机的行为,主机的扫描行为用的是Bothunter的SCADE，下载地址：[Cyber-TA.BotHunter Free Internet Distribution Page, 2008. ](http://www.bothunter.net/)。文章采用两种异常检测模式，一种是高频率异常扫描次数，另外一种是带加权的失败连接次数。

**C平面**
: 网络通信关系模型和流特征模型

**AC跨平面关联**
: 发现AC平面之间的某种关联关系，僵尸网络评分s(h)


**C平面的聚类**
:   定义 C-flow 为一段时间E内具有相同源IP，目的IP和目的端口的网络流

**C-flow的一些特征**

 1. FPH: the number of flows per hour.  
 2. PPF: the number of packets per flow 
 3. BPP: the average number of bytes per packets 
 4. BPS: the average number of bytes per second
 
### 4.论文[2]阅读笔记
该论文和之前僵尸网络研究的不同之处在于，之前的survey文章主要集中研究不同僵尸网络的技术细节，例如架构，通信协议，检测方法。这些研究只是僵尸网络某一方面的partial understanding，很难从全面的角度来了解问题。

文章根据僵尸网络的生命周期对僵尸网络进行建模。僵尸网络的生命周期（线性）如下图所示：每个状态都可以额外引入隐藏操作（Complementary Hidding Mechanism):例如 

1. Multi-hopping（多跳链路）通常是不同地区的多重代理。
2. Ciphering(加密)：SpamThru,Zeus采用的加密通道进行通信，Phatbot利用的是WASTE P2P私有加密协议。
3. Binary obfuscation(二进制混淆)：防止逆向分析得出僵尸网络程序的行为特征和其他信息
4. polymorphism(变形):通常实现了多种版本的源代码，但是基本功能保持不变。这样就可以绕过基于特征码检测的杀毒软件。（Phabot,Zeus采用了这种方法）
5. IP spoofing(IP 地址伪造)：在DoS攻击中经常使用。
6. Email-spoofing: 用错误的发件人地址发送邮件，在钓鱼攻击中经常使用。
7. Fast-flux: 对于Fast-flux的拥有者，重要的是要有大量的代理，以及代理位置的异质性。


![image](/assets/images/botnetlifecycle.png)


1. Conception阶段主要去设计和实现一个特定目标的僵尸网络。MEECES为僵尸网络常见的构建动机（Money, Entertainment, Ego, Cause, Entrance to social groups, Status）
2. Recruitment阶段主要是将僵尸网络程序运行在一个传统的主机上。
3. Interaction阶段主要包括（1）bots和botmaster之间的通信过程 （2）秘密通信链路框架，来维护和统计bots。
4. Marketing阶段主要用于传播僵尸网络程序
5. 攻击执行：攻击包括DDoS,Spam,click fraud（Search engine spam）, phishing，Data stealing等。
6. 攻击成功
 
##### 常见僵尸网络程序及其时间

![image](/assets/images/botnetyear.png)


### 补充内容

Fast-Flux网络比較多的NS，故其数量会比一般的DNS查詢所得到还多，而查询ASN（自治域）的原因主要是因为这些IP大多是分散在世界各地的受害主机，与CDN相比之下，会有明显的差异，因为CDN使用的IP所屬ASN多属于同一个单位，而Fast flux不是。此外Holz et al.不使用TTL作为特征理由是其不容易將Fast-Flux网络与CDN做区别，因为CDN也使用了很短的TTL。



#### 参考文献
[[1]BotMiner: Clustering Analysis of Network Traffic for 
Protocol- and Structure-Independent Botnet Detection](https://www.usenix.org/legacy/event/sec08/tech/full_papers/gu/gu_html/)

[2]Rodríguez-Gómez R A, Maciá-Fernández G, García-Teodoro P. Survey and taxonomy of botnet research through life-cycle[J]. ACM Computing Surveys (CSUR), 2013, 45(4): 45.

[3]Enemy K Y. Fast-Flux Service Networks[J]. The Honey net Project and Research Alliance, 2007.