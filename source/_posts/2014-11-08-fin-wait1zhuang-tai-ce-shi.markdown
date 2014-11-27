---
layout: post
title: "fin_wait1状态测试"
date: 2014-11-08 14:47:12 +0800
comments: true
categories: tcp fin-wait1
keywords: tcp fin-wait1
description: 
---

近日由于[tcpcopy](https://github.com/wangbin579/tcpcopy/)群里面在讨论tcp的fin_wait1状态如何消除,以及相关系统阐述修改对fin_wait1状态的影响。
关于fin_wait1状态可先参考[火丁笔记](http://huoding.com/2014/11/06/383 "关于FIN_WAIT1")。

##以下是我的测试
<!-- more -->
* 系统环境
	> ubuntu12.04    
	> 内核版本3.5.0-23-generic
* 测试场景1
	1. 服务端172.16.91.101，端口9981，客户端172.16.91.107(通过nc模拟的）
	2. 服务端设置系统参数如下：
		> `net.ipv4.tcp_max_orphans = 1`  
		> `net.ipv4.tcp_orphan_retries = 8`
	3. 客户端先去连接服务端
	4. 在91.107上通过iptables过滤掉发给101的包`iptables -A OUTPUT -d 172.16.91.101 -j DROP`
	5. ctrl+c关闭服务端，观察与91.107建立的连接状态如下:
		> FIN-WAIT-1 0      1           172.16.91.101:9981         172.16.91.107:55602 
	6.  tcpdump抓包如下：可有看到fin发送在服务端刚好尝试了8次
		![ tcpdump png ](/images/2014/11/08tcpdump-retry8.png)
    **结论：**`tcp_orphan_retries`参数为tcp对于处于orphan状态连接的重试次数

* 测试场景2
	1. 与场景1相同，只修改系统参数如下：
		> `net.ipv4.tcp_max_orphans = 0`  
	2.  通过ss命令看不到fin-wait-1状态
	3.  抓包结果如下:
		![ tcpdump png ](/images/2014/11/08orp-0.png)
	**结论：**由于`tcp_max_prphans`等于0，因此tcp发送完fin包后直接发送了一个rst包给客户端 (另外经过测试，不在客户端通过iptables过滤掉发送给服务端的包，抓包结果相同，可见服务端发送完fin包后，根本没有等待客户端的ack）。

* 测试场景3
	1. 客户端（91.107）连接上服务端（91.101）后，服务端发送大量数据给客户端，直到客户接收缓冲区满了为止，而客户端不接收数据；
	2. 内核参数如下：
		> `net.ipv4.tcp_max_orphans = 1`  
		> `net.ipv4.tcp_orphan_retries = 1`
	3. 等客户端接收缓存区满了之后，ctrl + c关闭服务端
	4. 观察tcp连接状态，处于orphan状态
	5. 观察tcp抓包，由于tcp缓冲区已满，服务端一直给客户端发送**zero window probes**包，没有发送fin包。
	6. 修改` net.ipv4.tcp_max_orphans = 0`,继续观察抓包，发现，一会后服务端发送了rst包，orphan状态连接消失。  
	*tcpdump抓包如下：*
		![ tcpdump png ](/images/2014/11/08tcpdump-fin1.jpg)
	**结论：** 在测试系统和对应内核下，修改系统参数`net.ipv4.tcp_max_orphans = 0`, 可消除orphan状态连接。

另：tcpcopy社区讨论中，有部分人测试修改后无效，可能由于老版本内核不支持，据群里面**lazio大神说**最新内核代码看貌似Max参数起了作用。

关于orphan相关内核源码分析，可以参考[http://blog.tsunanet.net/2011/03/out-of-socket-memory.html](http://blog.tsunanet.net/2011/03/out-of-socket-memory.html)

*最后，以上结果由本人测试得出，若其中错误，还请指出。*
 
		
	


