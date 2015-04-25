---
layout: post
title: "Botnet and fast flux"
description: ""
categories: [Infosec]
tags: [Botnet,fast flux]
music: []

---
Botnet and fast flux 特征介绍；Botminer论文初看
<!-- more -->
##Botnet and fast flux

-----
###几个定义
**Round-Robin DNS (RRDNS) *** 
: Round-robin的意思是循环的意思，顾名思义，这种DNS返回的A记录不只一个，返回的记录是一个列表，列表里面记录的先后顺序是循环出现的。

**Content Distribution Networks (CDN)**
: 中文名叫内容分发网络，和RRDNS比较类似，不过返回的记录的TTL值相对RRDNS更低。CDN系统能够实时地根据网络流量和各节点的连接、负载状况以及到用户的距离和响应时间等综合信息将用户的请求重新导向离用户最近的服务节点上。其目的是使用户可就近取得所需内容，解决 Internet网络拥挤的状况，提高用户访问网站的响应速度。

***Fast-Flux Service Networks (FFSN)***
: FFSN更加创新地利用了RRDNS和CDN的上述特性，来降低恶意服务器被发现和关闭的概率。FFSN的特点下面会讨论。

------
###Fast flux特征
1. **不重复的IP地址数量**：通常情况来说合法DNS查询不重复的IP地址为1~3个，而fast flux查询结果中会有5~6个，以确保至少有一个IP可以连接。
2. **NS数量**：NS数量是指在单一次DNS 查询中所得到的NS （Name server）数量。客户端与DNS 主机进行查询时,可能透过快速变动网域技术掩护DNS 主机,因此NS Records 与NS 的A Records 可能有多笔记录,相较之下,合法的FQDN 其NS Records 与NS 的A Records比较少。
3. **ASN数量与注册时间**：指对ASN进行查询时，主机使用的IP所属的ASN是否属于同一个单位。由于CDN主机使用的IP所属的ASN多属于同一个单位，而fast flux主机大多分散在世界各地，与CDN向比较之下，主机使用的IP所属的ASN属于不同单位。注册时间能够缩小选取范围。
4. **Domain age**:指合法网站记录的TTL时间相对于恶意网站更长；恶意网站的FQDN与对应的IP记录不会长时间存留电脑，电脑必须时常进行DNS查询，以更新记录。RFC1912建议TTL最小为1~5天，这么长！而FFSN的TTL值一般小于600秒。但是一般不使用TTL值来判定FFSN，因为这样的误报率比较高，合法使用的CDN也会返回比较低的TTL值。因此TTL值一般用来区分FFSN/CDN和RRDNS.


####常见僵尸网络检测程序
| Name        |TYPE                       |Protocols |
| ------------- |:-----------------------:| :-----:| 
|BotSniffer     | centralized servers     |   IRC,HTTP |  
| BotHunter      | structure independent  |Protocol independent |
| Botminer | structure independent  |    Protocol independent       |


###BotMiner 初看

#####BotMiner的系统架构
![Structure of Botminer](/assets/images/2015-04-19-botminer.png)


####论文中的一些定义
**A平面**
: 主要检测恶意行为模型,文章用Snort检测某主机的行为,主机的扫描行为用的是Bothunter的SCADE，下载地址：[Cyber-TA.BotHunter Free Internet Distribution Page, 2008. ](http://www.bothunter.net/)。文章采用两种异常检测模式，一种是高频率异常扫描次数，另外一种是带加权的失败连接次数。文章作者为了检测恶意邮件，开发了一种

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
 
####参考文献
[[1]BotMiner: Clustering Analysis of Network Traffic for 
Protocol- and Structure-Independent Botnet Detection](https://www.usenix.org/legacy/event/sec08/tech/full_papers/gu/gu_html/)

