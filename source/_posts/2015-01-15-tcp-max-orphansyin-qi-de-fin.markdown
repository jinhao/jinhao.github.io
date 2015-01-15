---
layout: post
title: "tcp_max_orphans引起的FIN,RST"
date: 2015-01-15 19:12:53 +0800
comments: true
categories: tcp
keywords: tcp_max_orphans
description: 
---
先看一个tcpdump的抓包

    19:08:01.196965 IP 172.16.91.101.10001 > 172.16.91.107.6388: Flags [S], seq 475071557, win 1460, options [mss 1460,nop,nop,sackOK,nop,wscale 10], length 0
    19:08:01.197002 IP 172.16.91.107.6388 > 172.16.91.101.10001: Flags [S.], seq 2477638798, ack 475071558, win 1460, options [mss 1460,nop,nop,sackOK,nop,wscale 10], length 0
    19:08:01.197216 IP 172.16.91.101.10001 > 172.16.91.107.6388: Flags [.], ack 1, win 2, length 0
    19:08:03.032342 IP 172.16.91.101.10001 > 172.16.91.107.6388: Flags [F.], seq 1, ack 1, win 2, length 0
    19:08:03.032505 IP 172.16.91.101.10001 > 172.16.91.107.6388: Flags [R.], seq 2, ack 1, win 2, length 0
    19:08:03.032515 IP 172.16.91.107.6388 > 172.16.91.101.10001: Flags [F.], seq 1, ack 2, win 2, length 0
    19:08:03.032845 IP 172.16.91.101.10001 > 172.16.91.107.6388: Flags [R], seq 475071559, win 0, length 0

<!-- more -->
客户端正常建立连接后，就调用close，抓包显示客户端先发送了FIN包，紧接着又发送了一个RST包，现象看起来实在是奇怪，google之，也未发现介绍这种场景的RST；换了台机器测试，发现4次挥手正常，于是查看tcp相关sysctl参数，发现了这个参数设置(想起来之前测试[tcp_max_orphans][tcp_max_orphans_test]参数对TIME_WAIT影响时设置，未取消)：
> net.ipv4.tcp_max_orphans = 0

关于tcp_max_orphans参数介绍
> Maximal number of TCP sockets not attached to any user file handle, held by system. If this number is exceeded orphaned connections are reset immediately and warning is printed. This limit exists only to prevent simple DoS attacks, you must not rely on this or lower the limit artificially, but rather increase it (probably, after increasing installed memory), if network conditions require more than default value, and tune network services to linger and kill such states more aggressively. Let me to remind again: each orphan eats up to ~64 KB of unswappable memory.

另外一个对应参数：tcp_orphan_retries
> How may times to retry before killing TCP connection, closed by our side. Default value 7 corresponds to  50sec-16min depending on RTO. If your machine is a loaded WEB server, you should think about lowering this value, such sockets may consume significant resources. Cf. tcp_max_orphans

[tcp_max_orphans_test]:http://i4box.com/blog/2014/11/08/fin-wait1zhuang-tai-ce-shi/
