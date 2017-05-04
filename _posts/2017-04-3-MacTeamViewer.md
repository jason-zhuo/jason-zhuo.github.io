---
layout: post
title: "Mac TeamViewer SSH 远程登录恢复"
description: “how to restart TeamViewer in Mac”
categories: [new stuff]
tags: [Trouble Shooting]
group: archive
path: comment
music: []

---

![image](/assets/images/TeamMac.png)

Mac 上重新启动TeamViewer 以及Trouble Shooting。

<!-- more -->

思路
--

有些时候出于未知原因，我们无法使用TeamViewer登录远程的Mac计算机。但是我们却可以通过SSH连接到Mac上，这样也可以通过SSH来重新启动和登录TeamViewer。

总结起来就以下一些步骤：

1. 远程SSH到Mac电脑
2. 运用Mac自带的Apple script来重新启动 TeamViewer.
3. 将TeamViewer 显示到第一个窗口（为了防止密码被其他窗口遮挡）
4. 截屏
5. 用SCP 回传截屏图像
6. 用新的临时密码进行TeamViewer登录

具体步骤
----

具体命令行代码：

```python
停止TeamViewer 
osascript -e 'tell application "TeamViewer" to quit'
启动TeamViewer 
osascript -e 'tell application "TeamViewer" to run'
将TeamViewer移动到第一个窗口
osascript -e 'tell application "TeamViewer" to activate'
将TeamViewer重新打开到第一个窗口
osascript -e 'tell application "TeamViewer" to reopen'
截屏
screencapture xxx.jpg
回传用scp
scp xx@host:(path to xxx.jpg) (path to save jpg)
```



**Trouble Shooting:**
---------------------

有的时候回出现如下的一些情况，比如新弹出的对话框挡住了密码。笔者尝试使用了各种办法来模拟用户单击对话框的“OK”都失败了。

由于权限原因：System Events got an error: osascript is not allowed assistive access. 

这个时候可能真需要真人去一趟了。

![](/assets/images/050037934C0DDBBA196577D400A84DB7.jpg)
