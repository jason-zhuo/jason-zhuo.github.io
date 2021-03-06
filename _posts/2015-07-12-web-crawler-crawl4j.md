---
layout: post
title: "Web Crawler Crawl4j"
description: "New on Crawl4j"
categories: [new stuff]
tags: [Crawler,Java]
music: []

---

### 基于Crawl4j的网页爬虫（Web crawler based on Crawl4j）
---
![image](/assets/images/2015-07-12webcrawler.png)
基于Crawl4j的网页爬虫简单实现以及运用。
<!-- more -->
### 1.起因
最近老师叫我去下载一个“核武器”，但是这个核武器一共有400G大小，包括2万多个目录，10多万个文件。如果一个一个去下载，明显是不靠谱的。网上也有人放出了这些文件的BT文件，可惜BT文件太大(23MB)，我电脑一打开就卡顿得不行。后来打开了，但是下载进度一直卡在0.0%，最快速度也就20KB/s。老师又叮嘱**一定**要下载下来，于是我就停下了手上论文的工作，开始解决这个问题。一开始我没想太多，因为最近事情确实有点多，白天的事情忙不完，晚上还有兼职工作... 后来花了周六一下午时间，问题解决了,或多或少有些收获，又想到这篇blog或许不仅可以帮助他人学习进步，而且看到牛博士下载开源代码逐个目录的下载，很是辛苦。于是就又了这篇Blog.

另外，关于这个“核武器”，我就简单介绍一下，一开始我也是不知道的，后来老师通知我才晓得。
>可以说这次事件和斯诺登事件的影响力是不相上下的，但HT(Hacking Team)被黑不光光是让公众知道有这回事，随之而来还有整整415G的泄漏资料！里面有Flash 0day, Windows字体0day, iOS enterprise backdoor app, Android selinux exploit, WP8 trojan等等核武级的漏洞和工具。

### 2.方案思路
既然迅雷BT下载速度奇慢无比，那就只好用基本HTTP去下载公布在网络上的镜像文件了。如果像牛博士那样一条条链接去另存为的话，肯定不行。之前看过通过Wget做全站镜像的命令
> wget -mk -c http://target.com

这个也是解决方法之一，不过https网站不行，要出错。另外，上述命令在国内环境中下载速度慢，而且无法在远程VPS上进行下载（硬盘大小有限）。容易造成 *wget memory exhausted* 的错误，真是醉了。

另外一个解决方法就是利用网络爬虫将所有的文件链接获取，然后逐一发起HTTP请求去下载。有个叫做**plowdown**的命令可以解决，参考[plowshare](https://github.com/mcrapet/plowshare)
安装完之后，利用
```plowdown --fallback -m Links.txt```
就行了。

后期，打算采用迅雷离线空间来下载上述链接，估计会比较快一点，唯一不足的就是没有文件目录结构，后期按照目录来下载估计就行了。

### 3.Crawl4J简介
Crawl4J是一个开源的Java爬虫程序，总共才三十多个类，比较简单，非常适合爬虫入门的学习。

下载地址：[https://github.com/yasserg/crawler4j](https://github.com/yasserg/crawler4j)

下载crawler4j-4.1-jar-with-dependencies.jar，然后将其导入外部依赖库。


### 4. 源代码
Mycrawler主要对每条链接进行处理。Controller里面设置了Java使用代理（链接到远程VPS）。代码是仿照官网给出的实例改编的，具体方法说明参考Crawl4j说明文档。
####4.1.Mycrawler class

``` 
import edu.uci.ics.crawler4j.crawler.Page;
import edu.uci.ics.crawler4j.crawler.WebCrawler;
import edu.uci.ics.crawler4j.parser.HtmlParseData;
import edu.uci.ics.crawler4j.url.WebURL;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Set;

public class Mycrawler extends WebCrawler {
    static double totalFilesCount = 0.0;
    static  File file = new File("Links.txt");
    public  static  void writelinkstoFile(String url){
        try {
            BufferedWriter bf  = new BufferedWriter(new FileWriter(file,true));
            bf.write(url+"\n");
            bf.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * This method receives two parameters. The first parameter is the page
     * in which we have discovered this new url and the second parameter is
     * the new url. You should implement this function to specify whether
     * the given url should be crawled or not (based on your crawling logic).
     * In this example, we are instructing the crawler to ignore urls that
     * have css, js, git, ... extensions and to only accept urls that start
     * with "http://www.ics.uci.edu/". In this case, we didn't need the
     * referringPage parameter to make the decision.
     */
    public boolean checkifIsDIR(String href){
        if (href.endsWith("/")){
            return true;
        }else
        return false;

    }
    @Override
    public boolean shouldVisit(Page referringPage, WebURL url) {
        String orghref =url.getURL();
        String href = url.getURL().toLowerCase();

        boolean iswithinDomain  =href.startsWith(Controller.TargetSite.toLowerCase());
        if (iswithinDomain&&checkifIsDIR(href)){
          //  System.out.println(href);
            return true;
        }else if (iswithinDomain){
            {
                if(href.equalsIgnoreCase("http://hacking.technology/Hacked%20Team/Exploit_Delivery_Network_android.tar.gz")){
                    return false;
                }
                if(href.equalsIgnoreCase("http://hacking.technology/Hacked%20Team/Exploit_Delivery_Network_windows.tar.gz")){
                    return false;
                }
                if(href.equalsIgnoreCase("http://hacking.technology/Hacked%20Team/support.hackingteam.com.tar.gz")){
                    return false;
                }

            }
            writelinkstoFile(orghref);
            totalFilesCount++;
        }
        return false;

    }

    /**
     * This function is called when a page is fetched and ready
     * to be processed by your program.
     */
    @Override
    public void visit(Page page) {
        String url = page.getWebURL().getURL();
        System.out.println("visited URL: " + url);

        if (page.getParseData() instanceof HtmlParseData) {
            HtmlParseData htmlParseData = (HtmlParseData) page.getParseData();
            String text = htmlParseData.getText();
            String html = htmlParseData.getHtml();
            Set<WebURL> links = htmlParseData.getOutgoingUrls();

            System.out.println("Text length: " + text.length());
            System.out.println("Html length: " + html.length());
            System.out.println("Number of outgoing links: " + links.size());
        }
    }
}

```

#### 4.2.Controller class
```
import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import java.util.Properties;

/**
 * Created by jasonzhuo on 2015/7/11.
 */
public class Controller {
    public  static String TargetSite= "http://hacking.technology/Hacked%20Team/";
    private static final Logger logger = LoggerFactory.getLogger(Controller.class);

    static int numberOfCrawlers = 7;

    public static void main(String[] args) {

        CrawlConfig crawlConfig = new CrawlConfig();
        crawlConfig.setCrawlStorageFolder("I:\\HTools");

        //proxy setup
       //crawlConfig.setProxyHost("127.0.0.1");
      //  crawlConfig.setProxyPort(1080);
        Properties prop = System.getProperties();
        prop.setProperty("socksProxyHost", "127.0.0.1");
        prop.setProperty("socksProxyPort", "1080");
        crawlConfig.setMaxDownloadSize(Integer.MAX_VALUE);
        crawlConfig.setMaxOutgoingLinksToFollow(Integer.MAX_VALUE);
        crawlConfig.setMaxDepthOfCrawling(32767);
        crawlConfig.setMaxPagesToFetch(Integer.MAX_VALUE);
        System.out.println(crawlConfig.toString());
        PageFetcher pageFetcher = new PageFetcher(crawlConfig);
        RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
        RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFetcher);
        try {
            CrawlController controller = new CrawlController(crawlConfig, pageFetcher, robotstxtServer);
            //controller.addSeed("http://www.ics.uci.edu/~welling/");
            controller.addSeed(TargetSite);
            // controller.addSeed("https://www.google.com.hk/");
            controller.start(Mycrawler.class, numberOfCrawlers);
            System.out.println("Recorded total number of files :"+Mycrawler.totalFilesCount);
        } catch (Exception e) {
            e.printStackTrace();
        }


    }


}
```