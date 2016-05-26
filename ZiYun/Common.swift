//
//  Common.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/8/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
class Common:UIView {
    class func getRightItem() -> UIBarButtonItem{
        var labelView = UIView(frame: CGRectMake(0, 0, 200, 44))
        var label = UILabel()
        label.frame.size = CGSize(width: 200, height: 22)
        label.text = "\(loginUserInfo.name!)，欢迎您登陆"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Right
        labelView.addSubview(label)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        var label1 = UILabel()
        label1.frame.size = CGSize(width: 200, height: 22)
        //自定义label的颜色显示
//        let labelString = "更多服务请登陆电脑端www.ziyun.info" as NSString
//        let labelText = NSMutableAttributedString(string: labelString as String)
//        let attr1 = [NSFontAttributeName:UIFont.boldSystemFontOfSize(12),NSForegroundColorAttributeName:UIColor.whiteColor()]
//        let attr2 = [NSFontAttributeName:UIFont.boldSystemFontOfSize(12),NSForegroundColorAttributeName:UIColor(red:0.678, green:0.420, blue:0.161, alpha:1.00)]
//        labelText.setAttributes(attr1, range:labelString.rangeOfString("更多服务请登陆电脑端"))
//        labelText.setAttributes(attr2, range: labelString.rangeOfString("www.ziyun.info"))
//        label1.attributedText = NSAttributedString(attributedString: labelText)
        label1.text = "更多服务请登陆电脑端www.ziyun.info"
        //label1.text = "更多服务请登陆电脑端查看"
        label1.font = UIFont.systemFontOfSize(12)
        label1.textColor = UIColor.whiteColor()
        label1.textAlignment = NSTextAlignment.Right
        label1.setTranslatesAutoresizingMaskIntoConstraints(false)
        labelView.addSubview(label1)
        var top = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: label.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5)
        var right = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: label.superview, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        var bottom = NSLayoutConstraint(item: label1, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: label1.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5)
        var right1 = NSLayoutConstraint(item: label1, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: label1.superview, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        labelView.addConstraints([top,right,bottom,right1])
        var rightItem = UIBarButtonItem(customView: labelView)
        return rightItem
    }
    class func getLeftItem() -> UIBarButtonItem{
        var leftItem = UIBarButtonItem()
        //leftItem.title = "MDCL情报"
        leftItem.title = "紫云情报"
        leftItem.tintColor = UIColor.whiteColor()
        return leftItem
    }
       class func userInfoParser(data:NSData ) -> Void {
        let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        //println(json.description)
        loginUserInfo.uid = json["uid"].uInt
        loginUserInfo.port = json["port"].uInt
        loginUserInfo.keywords = json["keywords"].string
        loginUserInfo.name = json["name"].string
        loginUserInfo.scode = json["scode"].string
        loginUserInfo.industry = json["industry"].string
        loginUserInfo.date = json["date"].string
        loginUserInfo.status = json["status"].string
        loginUserInfo.subject = json["sub"].dictionaryObject
       
    }
    class func subjectInfoParser(data:NSData ) -> NSDictionary? {
        let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        if json["status"].string == "信息获取成功" {
            return json["text"].dictionaryObject
        }
        return nil
    }

    //通用返回数据解析函数，适用于失败返回(status, reason, scode)，成功返回（status, scode）的情况
    class func commonInfoParser(data:NSData) -> (status:String, reason:String, scode:String){
        let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var status = json["status"].string
        var scode = json["scode"].string
        //var reason = "亲！密码已经以短信形式发送到您注册账号时填写的手机，请注意查收"
        var reason = " "
        if scode == "0" {
            reason = json["reason"].string!
        }
        return (status!, reason, scode!)
        
    }
    class func myAccount(data:NSData ) -> (paypwd:String, money:String, status:String, scode: String) {
        let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var paypwd = json["account "]["paypwd"].string
        var money = json["account "]["money"].string
        var status = json["status"].string
        var scode = json["scode"].string
        return (paypwd!, money!, status!, scode!)
    }
    
    class func sccTrade(data:NSData) -> (date:String, status:String, reason:String, scode:String) {
        let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var status = json["status"].string
        var scode = json["scode"].string
        var date = ""
        var reason = ""
        if scode == "0" {
            var reason = json["reason"].string!
            return (date, status!, reason, scode!)
        }
        else {
            var date = json["reason"].string!
            return (date, status!, reason, scode!)
        }
    }

    class func findPassParser(data:NSData ) -> (status:String, reason:String, scode:String) {
        return commonInfoParser(data)
    }
    
    class func registerParser(data:NSData ) -> (status:String, reason:String, scode:String){
        return commonInfoParser(data)
    }
    class func authCodeParser(data:NSData ) -> (status:String,scode:String) {
        let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var status = json["status"].string
        var scode = json["scode"].string
        return (status!,scode!)
    }
    //MARK 待验证
    class func checkUpdate( ) -> (version:Double ,trackViewUrl:String){
        var appleID = UIDevice.currentDevice().identifierForVendor.UUIDString
        let uri = "http://itunes.apple.com/lookup?id=\(appleID)"
        let url = NSURL(string: uri)!
        // 声明NSMutableURLRequest对象，便于设置请求属性
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        println(GBK2UTF8.retrunNSData(data))
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var resultCount = json["resultCount"].uInt
        if resultCount > 0 {
           var trackViewUrl = json["result"]["trackViewUrl"].string
           var version = json["result"]["version"].double
           return (version!, trackViewUrl!)
        }
        else {
            return (0, "")
        }
    }
    class func getUsername( ) -> String!{
        return loginUserInfo.username!
    }
    class func getUid( ) -> String!{
        return loginUserInfo.uid!.description
    }


   }
