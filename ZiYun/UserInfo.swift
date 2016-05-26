//
//  UserInfo.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/10/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//
import Foundation
class UserInfo{
    var username:String?
    var uid:UInt?                       //用户id
    var port:UInt?                      //长连接端
    var keywords:String?                //用户关键词
    var name:String?                    //用户昵称
    var scode:String?                   //状态码
    var industry:String?                //用户所属行业
    var date:String?                    //到期日期（格式yyyy-MM-dd）空就是永久有效
    var status:String?                  //返回状态
    var subject:NSDictionary?        //返回用户设置的专题
    //返回行业专题
    
}
