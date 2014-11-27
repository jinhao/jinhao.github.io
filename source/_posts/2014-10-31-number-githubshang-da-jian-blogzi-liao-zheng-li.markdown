---
layout: post
title: "github上搭建blog资料整理"
date: 2014-10-31 13:48:59 +0800
comments: true
categories: Octopress
keywords: Octopress github pages gitcafe
---

    
###资料整理
通过github pages搭建自己博客相关资料整理:

* [octopress博客搭建和个性化配置](http://blog.csdn.net/grunmin/article/details/14127653)
<!-- more -->
* [github pages 介绍](https://pages.github.com/)

* [如何在github上写博客(知乎)](http://www.zhihu.com/question/20962496)

* [Octopress文档](http://octopress.org/docs/)

* [How to Embed Douban-Show in Your Octopress Site](http://icodeit.org/2012/10/how-to-embed-douban-show-in-your-octopress-site/)

* [象写程序一样写博客：搭建基于github的博客](http://blog.devtang.com/blog/2012/02/10/setup-blog-based-on-github/)

* [添加统计和摘要显示](http://blog.csdn.net/lcliliil/article/details/13727927)
	
###问题整理
		
**部署失败 [error: failed to push some refs to git@github.com xxxx']**(http://stackoverflow.com/questions/21356212/failed-to-deploy-to-github-pages-using-octopress)

**解决方法**


> * `cd _deploy`
> * `git config branch.master.remote origin`
> * `git config branch.master.merge refs/heads/master`
> * `git pull`


**访问速度过慢?**

**解决方法**

> * 将博客从github同步到gitcafe上，gitcafe在国内访问速度快很多
> * [google字体下载到本地](http://imxylz.com/blog/2013/09/22/move-google-fonts-to-local-server/)
> * 若还慢可用Firefox查看下具体打开页面时哪一块比较慢
> * 通过360[奇云测](http://ce.cloud.360.cn/)检测下全国各地访问你博客的速度
