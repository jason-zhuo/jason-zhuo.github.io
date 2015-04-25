---
layout: post
title: "Shadowsocks in Lab"
description: "Shadowsocks introduction"
categories: [Infosec]
tags: [Proxy，Shadowsocks]
music: []

---
![image](https://dn-teddysun.qbox.me/wp-content/uploads/2015/shadowsocks_logo.png)
好多童鞋搞不清楚我在实验室搭建的Shadowsocks如何使用，在这里给你们科普一下，知道原理之后使用起来就更加顺心了，保证一口气科研就到天亮哦~
<!-- more -->
####注明：以下高能内容转载自[vc2tea的博客](http://vc2tea.com/whats-shadowsocks/)

在很久很久以前，我们访问各种网站都是简单而直接的，用户的请求通过互联网发送到服务提供方，服务提供方直接将信息反馈给用户.
   
![image](http://vc2tea.com/public/upload/whats-shadowsocks-01.png)

然后有一天，GFW 就出现了，他像一个收过路费的强盗一样夹在了在用户和服务之间，每当用户需要获取信息，都经过了 GFW，GFW将它不喜欢的内容统统过滤掉，于是客户当触发 GFW 的过滤规则的时候，就会收到 Connection Reset 这样的响应内容，而无法接收到正常的内容.

![image](http://vc2tea.com/public/upload/whats-shadowsocks-02.png)

聪明的人们想到了利用境外服务器代理的方法来绕过 GFW 的过滤，其中包含了各种HTTP代理服务、Socks服务、VPN服务, **Tor**, **Freegate** … 其中以 ssh tunnel 的方法比较有代表性

1. 首先用户和境外服务器基于 ssh 建立起一条加密的通道
2. 用户通过建立起的隧道进行代理，通过 ssh server 向真实的服务发起请求
3. 服务通过 ssh server，再通过创建好的隧道返回给用户

![image](http://vc2tea.com/public/upload/whats-shadowsocks-03.png)

由于 ssh 本身就是基于 RSA 加密技术，所以 GFW 无法从数据传输的过程中的加密数据内容进行关键词分析，避免了被重置链接的问题，但由于创建隧道和数据传输的过程中，ssh 本身的特征是明显的，所以 GFW 一度通过分析连接的特征进行干扰，导致 ssh 存在被定向进行干扰的问题。

这时候**shadowsocks**横空出世。简单看来，shadowsocks是将原来 ssh 创建的 Socks5 协议拆开成 server 端和 client 端，所以下面这个原理图基本上和利用 ssh tunnel 大致类似。

####shadowsocks工作原理
1、6) 客户端发出的请求基于 Socks5 协议跟 ss-local 端进行通讯，由于这个 ss-local 一般是本机或路由器或局域网的其他机器，不经过 GFW，所以解决了上面被 GFW 通过特征分析进行干扰的问题

2、5) ss-local 和 ss-server 两端通过多种可选的加密方法进行通讯，经过 GFW 的时候是常规的TCP包，没有明显的特征码而且 GFW 也无法对通讯数据进行解密

3、4) ss-server 将收到的加密数据进行解密，还原原来的请求，再发送到用户需要访问的服务，获取响应原路返回

![image](http://vc2tea.com/public/upload/whats-shadowsocks-04.png)

-----

截止目前，笔者所使用最流畅、最稳定的就是shadowsocks，一口气翻墙不费劲，以后再也不用操心翻墙了。传送门：[shadowsocks下载地址](https://github.com/shadowsocks/shadowsocks)

在我们实验室中，翻墙代理设置可以为网关的IP地址192.168.1.1，也可以为本地127.0.0.1地址。唯一区别就是上图中SS Local代理程序运行的位置不同，（刘博士懂了撒~）。在实验室环境中，童鞋们可以自己设置利用本机的代理，也可以使用阿江搭建在网关上的SS Local代理，效果一致。没有在实验室的童鞋就只能靠自己本地代理啦。最后使用的时候需要设置为Socks5代理类型就可以正常使用了。
<img src="/assets/smilies/37.gif" id="similey">
(css inline 表情，深夜特别鸣谢刘博士)
<img src="/assets/smilies/28.gif" id="similey">
