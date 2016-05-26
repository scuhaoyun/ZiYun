//
//  CostModel.swift
//  tallybook
//
//  Created by ZERO. on 15/3/9.
//  Copyright (c) 2015年 ZERO. All rights reserved.
//

import Foundation

class MySubjectModel: BaseModel {
    var subjectId: Int?
    var searchId: String?
    var summary: String?
    var status: String?

}
//{"summary":"我去開會，都是坐到最近的地鐵站，然後才打車啊，也就兩個起步價。對了，那倆河南的……",                      //文章摘要
//    "authorType":"新注册",                    //用户类型
//    "pubdate":"2015-04-08 14:37:00",            //文章发布时间
//    "searchId":"161739878435153",              //全文检索库文章唯一id
//    "revtime":"",
//    "pic":"",                                 //图片链接地址，多个逗号分开
//    "messageType":"微博正文",                 //文章类型
//    "channelCategory":"微博",                   //频道
//    "url":"http://weibo.com/5025812265/CcjTQdkq8",
//    "ti":"我去開會，都是坐到最近的地鐵站...",    //标题缩写
//    "mediaType":"微博",                        //媒体类型
//    "emotion":"无正负",                        //正负面
//    "id":0,
//    "content":"我去開會，都是坐到最近的地鐵站，然後才打車啊，也就兩個起步價。對了，那倆河南的……",                         //文章正文
//    "author":"瘋狂的一瞬@weibo.com",            //作者，显示时只显示@前
//    "subTitle":"",
//    "num":1,
//    "domainSource":"s.weibo.com",
//    "title":"我去開會，都是坐到最近的地鐵站，然後才打車啊，也就", //全标题
//    "domainLevel":"商业全国",                     //网站级别
//    "domain":"s.weibo.com",                       //域名
//    "word":""
//}
