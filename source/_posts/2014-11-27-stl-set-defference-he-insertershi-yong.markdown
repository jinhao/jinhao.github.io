---
layout: post
title: "stl set_defference 和 inserter使用"
date: 2014-11-27 22:12:10 +0800
comments: true
keywords: set_difference inserter 交集
categories: stl zookeeper
---
今天在弄通过zookeeper动态更新服务列表`new_list`，由于我这边在做的时一个动态连接池管理，获取到得服务列表后是要与服务列表中得地址建立连接的，更新服务列表时自然也不能简单的直接覆盖老服务列表`old_list`。

<!-- more -->
* 方法1    
>将`new_list`中每个member在`old_list`中遍历一遍，在`old_list`已经存在的member做上标记，不存在的member建立连接后加入`old_list`，全部遍历完成后，再遍历一遍`old_list`将未做标记的member移除。    

* 方法2
> 直接使用stl中算法函数:[std::set_difference][set_difference_id], 该算法函数可以将两个[set][set_id](也可以是其他的container)中前一个[set][set_id]中包含，而后一个set中没有的member保存到另外一个[set][set_id]中。这样我就可以很容易将`old_list`中已经不在`new_list`中得member筛选出来移除掉，另外将new_list中存在的而old_list中不存在的建立连接后加入。

使用方法如下：

    #include <stdio.h>
    #include <string>
    #include <set>
    #include <algorithm>

    void print_set(const std::set<std::string>& s)
    {
	    std::set<std::string>::const_iterator itor;
	    for (itor= s.begin(); itor != s.end(); ++itor)
	    {
		    printf("%s\n", (*itor).c_str());
	    }
    }

    int main(int argc, char* argv[])
    {
	    std::set<std::string> set1;
	    std::set<std::string> set2;

	    set1.insert("192.168.60.71:11201");
	    set1.insert("192.168.60.72:11101");
	    set1.insert("192.168.70.111:11222");
	    set1.insert("192.168.70.111:10222");
	    set1.insert("192.168.73.111:10222");
	    //printf("set1:\n");
	    //print_set(set1);

	    set2.insert("192.168.70.111:10222");
	    set2.insert("192.168.70.111:11222");
	    set2.insert("192.168.60.71:11201");
	    set2.insert("192.168.60.72:11101");
	    //printf("set2:\n");
	    //print_set(set2);

	    std::set<std::string> rlt;
	    std::set_difference(set1.begin(), set1.end(), set2.begin(), set2.end(),
		std::inserter(rlt, rlt.end()));

	    //printf("diff:\n");
	    print_set(rlt);

	    return 0;
    }

结果如下：   
> 192.168.73.111:10222

代码中std::[inserter][inserter_id]是一个模板函数，生成一个插入迭代器[insert_iterator][insert_iterator_id],详细介绍参考[www.cplusplus.com](http://www.cplusplus.com).


[set_difference_id]:http://www.cplusplus.com/reference/algorithm/set_difference/
[set_id]:http://www.cplusplus.com/reference/set/set/
[inserter_id]:http://www.cplusplus.com/reference/iterator/inserter/
[insert_iterator_id]:http://www.cplusplus.com/reference/iterator/inserter/
