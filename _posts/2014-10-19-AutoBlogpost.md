---
layout: post
title: "Auto Blog Post"
description: "Auto blog post shell script"
categories: [BlogBuilding]
tags: [Linux,Bash]
group: archive
music: []

---

![image](/assets/images/2014-10-19-bash_logo.jpg)

每次写完Blog要不是忘记该输什么命令，就是懒得一个一个命令行敲。为了省事，自己根据Bash语言写了一个自动发表已经撰写好的Blog。

<!-- more -->
每次写完Blog要不是忘记该输什么命令，就是懒得一个一个命令行敲。

>Shell脚本语言(Shell Script)，Shell脚本与Windows/Dos下的批处理相似，也就是用各类命令预先放入到一个文件中，方便一次性执行的一个程序文件，主要是方便管理员进行设置或者管理用的。但是它比Windows下的批处理更强大，比用其他编程程序编辑的程序效率更高，毕竟它使用了Linux/Unix下的命令。——百度百科

Shell脚本语言为实现自动化提供了良好帮助，真不愧为胶水语言，确实省事了很多。
下面展示了我如何利用脚本语言来一键发表提交撰写好的博客内容。脚本内容比较简单，基本逻辑是先输入提交本次提交的评注，然后脚本会自动删除你在本地Git仓库中删除的文件，不然无法提交到远程Git库中，最后3个命令基本上都和网上的教程差不多。代码虽然很简单，但是还是有一定作用。
{% highlight bash linenos %}

echo -n "Enter comment:"
read  comment
files=`git status | grep deleted | awk '{print \$2}'`
if [ "${files}" == "" ]; then
	  echo "nothing to remove"
	else
        for var in $files
        do
            #echo $var
            git rm --cached $var
        done
fi
git add .
git commit -m "$comment"
git push origin master
exit 0  	

{% endhighlight %}
给予该脚本可执行权限后，直接执行./Publish.sh即可轻松提交到远程Git仓库啦~ 
{% highlight bash %}
chmod +x Publish.sh
./Publish.sh
{% endhighlight %}
效果图：

![image](/assets/images/2014-10-19-AutoblogRes.png)