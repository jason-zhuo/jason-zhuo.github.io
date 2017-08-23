---
layout: post
title: Hidden service search engine and naming strategy
description: “”
categories: [Infosec]
tags: [Hidden Service]
group: archive
music: []

---

![image](/assets/images/darknet.png)

暗网搜索以及名字服务。Dark net search engine and naming system.

<!-- more -->
### 1. What?
> Tor 和 I2P 都是目前最常用的低延迟匿名通信系统。 
> Deep Web: Internet not indexed by traditional search engines. 
> Dark Net: Private overlay network. 
> Dark Web: WWW hosted on Dark Nets.

#### 1.1 Hidden Service Popularity
 The goal in [this post](https://blog.torproject.org/blog/some-statistics-about-onions) has been published to answer the following questions:

> "Approximately how many hidden services are there?"
> "Approximately how much traffic of the Tor network is going to hidden services?"

![image](/assets/images/uniqueHiddenService.png)

### 2. Who?
Tor: United States Naval Research Laboratory
I2P: Small group of people spread around several continents

### 3. How?
#### 3.1 Tor

![image](/assets/images/HiddenService.png)

1. Hidden Service (Bob) uses the first 10 bytes of the SHA-1 digest of an ASN.1 encoded version of the RSA public key become the identifier of the hidden service. for example, z.onion where z is the base-32 encoded identifier of the hidden service.
2. Bob chooses a small number of Tor relays as introduction points and establishes new introduction circuit to each one of them.
3. Bob uploads identifier of the hidden service, public key as well as its selected introduction points to the HSDir (Hidden service directory).
4. Alice wants to connect to Bob's hidden service. She use the z.onion to compute the responsible HSDir and fetches relevant information advertised by the hidden service. 
5. Alice learns the introduction points of the hidden service. Alice then selects a rendezvous point and tells the introduction point of her choice as well as DH key etc.
6. Introduction point tells Bob about the DH key parameters as well as the rendezvous point.
7. Bob connects to the rendezvous point and communicate with Alice. 

#### 3.2 I2P

![image](/assets/images/I2PHiddenService.jpg)

I2P hidden service(eepsite) is claimed to be faster than Tor Hidden service.
建立过程也更加简单直接。

1. Hidden service (Bob) 在本地路由搭建匿名服务器
2. Bob 将 Hidden service 的密钥和名字(xyz.i2p)添加进主地址簿
3. 发布过程：Bob 将自己的eepsite的名称(xyz.i2p)和密钥加入到其它网站的I2P地址簿（比如stats.i2p 或no.i2p）
4. Bob 为其Hidden service 维护新的 inbound and outbound tunnel 并将该信息（lease set）告诉NetDB.
4. Alice 想要访问Bob, 如果Bob没有发布自己的eepsite地址，那么Alice将不知道Bob的xyz.i2p就是Bob，假设Alice从各个更新源处获取当前最新的地址簿。Alice则知道xyz.i2p就是Bob的路由，因此Alice从NetDB查找Bob的inbound
5. Alice 从 outbound tunnel连接到Bob的inbound tunnel，双方进行通信。

database store message作用:
> A delivery status message is sent back to the client router to inform it that the connection has been successful. The database store message, which contains the client's leaseSet, is used by the server router to determine how to reach the client's inbound tunnel. This is for optimization, eliminating the need for the server router to look up the netDB for the client's leaseSet.



### 4. Tor Directory and I2P NetDB compare 

![image](/assets/images/TorI2pCompare.png)
 
| Tor | I2P |
| :-: | :-: |
| 10 directories servers  | DHT based NetDB |
| Global view | Partial view |
| Directory Server | Floodfill Router |
 

#### 4.1 Tor Directories 
In tor source code **or/config.c** there are a number of default directories:

![image](/assets/images/TorDiR.png)

These Directory Authorities are run by members of the Tor Project and by trusted outside individuals/groups. 

#### 4.2 I2P NetDB
NetDB contains just two types of data: router contact information (RouterInfos) and destination contact information (LeaseSets). Refer to [[6]](https://geti2p.net/en/docs/how/network-database) for more information.


### 5. Tor search engines

On surface web:

[**Ahmia.fi** https://ahmia.fi](https://ahmia.fi) (Ahmia.fi also works for I2P searches.)

[**Deep Search** http://www.torchtorsearch.com](http://www.torchtorsearch.com)

On deep webs:

[**duckduckgo** http://3g2upl4pq6kufc4m.onion](http://3g2upl4pq6kufc4m.onion)

[**grams** http://grams7enufi7jmdl.onion](http://grams7enufi7jmdl.onion)

[**Torch** http://xmh57jrzrnw6insl.onion/](http://xmh57jrzrnw6insl.onion/) 

[**Not Evil** http://hss3uro2hsxfogfq.onion/](http://hss3uro2hsxfogfq.onion/)

#### 5.1 How to index for Hidden service?

Ahmia search engine [7] uses Elasticsearch to index content. Elasticsearch is an Apache Lucene(TM) open sourced search engine。

The .onion addresses are got from those sites in Ahmia crawler for Tor.

```python
class OnionSpider(WebSpider):
    """
    Crawls the tor network.
    """
    name = "ahmia-tor"

    default_start_url = \
    ['http://zqktlwi4fecvo6ri.onion/wiki/index.php/Main_Page',
     'http://tt3j2x4k5ycaa5zt.onion/',
     'http://msydqstlz2kzerdg.onion/address/',
     'http://msydqstlz2kzerdg.onion/add/onionsadded/',
     'https://blockchainbdgpzk.onion/',
     'http://7cbqhjnlkivmigxf.onion/']
```


The .i2p sites list is shown below.

```python
class InvisibleInternetSpider(WebSpider):
    """
    Crawls the i2p network.
    """
    name = "ahmia-i2p"
    default_start_url = ['http://nekhbet.com/i2p_links.shtml',]

    def get_link_extractor(self):
        return LinkExtractor(allow=r'.i2p',)
```
So where does these sites get the .onion addresses from? 

An attacker can operate several hidden service directories and collect hidden service descriptors over a long period of time [2]. But it is very **slow**. The author in [2] used the **shadow relays** to reduce the number of compromised HSDir and the number of collection time. The authors in [8] used 40 servers and ran 160 days. About 80000 unique hidden services were found, in which 45000 are relatively stable.



### 6. Hidden Service address resolving

#### 6.1 Tor Onion address

**Q:** Tor 当中没有DNS，如何进行地址解析呢？Tor and I2P has no DNS like the Internet. How to resolve the .onion address in Tor? 

**A:** You only need to compute & find the HSDir that responsible for storing that address. A DHT spread across HSDir relays, this simple DHT is ordered by their node fingerprint. Currently there are approximately 3500 routers flagged with HSDir.

![image](/assets/images/DHTtor.png)

For example, Bob's service descriptor is calculated as Desc FP then its Desc FP is stored in HSDir_k and so on.  Alice wants to connect to Bob, only needs to find whether the xyz.onion is in that DHT. 

#### 6.2 I2P address
**Q:** I2P 当中没有DNS，如何进行地址解析呢？Tor and I2P has no DNS like the Internet. How to resolve the .i2p address in I2P? 

**A:** DNS in I2P is called "susidns", where a hostname is translated into its actual base32- or base64-encoded address, called ”destination”. 

All destinations in I2P are 516-byte (or longer) keys.

```
8ZAW ̃KzGFMUEj0pdchy6GQOOZbuzbqpWtiApEj8LHy2 ̃O ̃58XKxRrA43cA23a9oDpNZDqWhRWEtehSnX
5NoCwJcXWWdO1ksKEUim6cQLP−VpQyuZTIIqwSADwgoe6ikxZG0NGvy5FijgxF4EW9zg39nhUNKRejYN
HhOBZKIX38qYyXoB8XCVJybKg89aMMPsCT884F0CLBKbHeYhpYGmhE4YW ̃aV21c5pebivvxeJPWuTBAO
mYxAIgJE3fFU−fucQn9YyGUFa8F3t−0Vco−9qVNSEWfgrdXOdKT6orr3sfssiKo3ybRWdTpxycZ6wB4q
HWgTSU5A−gOA3ACTCMZBsASN3W5cz6GRZCspQ0HNu ̃R ̃nJ8V06Mmw ̃iVYOu5lDvipmG6−dJky6XRxCed
czxMM1GWFoieQ8Ysfuxq−j8keEtaYmyUQme6TcviCEvQsxyVirr ̃dTC−F8aZ ̃y2AlG5IJz5KD02nO6TR
kI2fgjHhv9OZ9nskh−I2jxAzFP6Is1kyAAAA
```

If an application (i2ptunnel or the HTTP proxy) wishes to access a destination by name, the router does a very simple local lookup to resolve that name. The check order is private, master and then public.  

**The address book** which contains three parts: public, master and private. 

**public address book:** updated by the I2P software on all clients and therefor offers the possibility to publicly announce a service. Users can share the public address book with others as well.

**master and private address book** contains personal entries and can be used to store addresses that are not supposed to be publicly known

If not found the entry, the error page is returned. However, I2P offers a **jump service** that can be queried to and retrieve the destination. Four of them are included in the I2P and the error page includes links to access them: i2host.i2p, stats.i2p, no.i2p and i2pjump.i2p.



--------

### 参考（Refs）

[1] Protocol-level hidden server discovery Ling Zhen et al. IEEE INFOCOM 2013

[2] Trawling for Tor Hidden Services: Detection, Measurement, Deanonymization Alex Biryukov et al. IEEE Symposium on Security and Privacy 2013

[3] http://idlerpg.i2p.xyz/help/index_zh.html

[4] https://www.virusbulletin.com/virusbulletin/2016/12/vb2015-paper-anonymity-king/

[5] https://ritter.vg/blog-run_your_own_tor_network.html

[6] https://geti2p.net/en/docs/how/network-database

[7] https://ahmia.fi/documentation/indexing/

[8] Owen G, Savage N. Empirical analysis of Tor hidden services[J]. IET Information Security, 2016, 10(3): 113-118. 


