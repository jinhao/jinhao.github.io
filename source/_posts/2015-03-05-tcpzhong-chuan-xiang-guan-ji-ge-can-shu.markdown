---
layout: post
title: "TCP重传相关几个参数"
date: 2015-03-05 16:58:44 +0800
comments: true
categories: tcp
keywords: tcp_retries
description: 
---

看过TCP协议的，我们都知道TCP send一个数据包，如果对端没有给响应(ack), tcp会进行重传，但是重传指定次数后，若一直失败（如网络中断了），最终错误码是什么了？之前一直也没关心过，今天刚好做了测试，记录一下。

<!-- more -->
先简单说下tcp重传相关的几个参数：
> tcp_orphan_retries: 主要是针对孤立的socket(也就是已经从进程上下文中删除了，可是还有一些清理工作没有完成).对于这种socket，我们重试的最大的次数就是它。 
> tcp_retries1: 表示的是最大的重试次数，当超过了这个值，我们就需要检测路由表了。    
> tcp_retries2: 表示重试最大次数，只不过这个值一般要比上面的值大。和上面那个不同的是，当重试次数超过这个值，我们就必须放弃重试了。  
> tcp_syn_retries: 默认值一般为5，表示未收到syn/ack,syn分节的重传次数, 重传时间为1s,2s,4s,8s,16s。 
> tcp_synack_retries: 表示未收到ack，syn/ack重传次数，重传时间间隔也为1s,2s,4s,8s,16s。

测试方法：通过iptables过滤掉客户端的包。

测试结果：

1. connect重试tcp_syn_retries指定次数后，若还无响应，则connect返回-1， errno:110 errstr:Connection timed out
2. send发送数据直接返回成功copy到socket缓冲区的字节数，tcp协议栈在未收到对端ack时，重试发送，重试tcp_retries2指定次数后，不再重试，下一次再对该fd进行write操作，将返回ret=-1，errno:110, errstr:Connection timed out.
