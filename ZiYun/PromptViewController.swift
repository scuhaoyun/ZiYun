//
//  ViewController.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/1/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import UIKit
import SwiftyJSON

class PromptViewController: UIViewController,NSURLConnectionDataDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var voiceSwitch: UISwitch!
    @IBOutlet weak var shackSwitch: UISwitch!
    @IBOutlet weak var lockScreenSwitch: UISwitch!
    @IBOutlet weak var unDisturbSwitch: UISwitch!
        //检查更新
    @IBAction func checkUpdate() {
        var indicator = WIndicator.showIndicatorAddedTo(self.tabBarController!.view, alpha: 0.35 ,animation: true)
        indicator.text = "  正在检测，请稍后！  "
        var appleID = UIDevice.currentDevice().identifierForVendor.UUIDString
        let uri = "http://itunes.apple.com/lookup?id=\(appleID)"
        let url = NSURL(string: uri)!
        // 声明NSMutableURLRequest对象，便于设置请求属性
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        NSURLConnection(request: request, delegate: self)
      
    }
    
    @IBAction func feedBackClick(sender: AnyObject) {
        self.tabBarController?.tabBar.hidden = true
    }
    //退出登录
    @IBAction func logout(sender: AnyObject) {
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject("NO" , forKey: "autoLogin")
        userDefault.synchronize()
        //http://222.143.31.169:8080/Logout.do?appkey=test&apppwd=123456&name=xxx&uid=xx
        var alertController = UIAlertController(title: "温馨提示", message: "你确定要退出吗？", preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "退出", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            
            let uri = "http://222.143.31.169:8080/Logout.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)"
            let url = NSURL(string: uri)!
            // 声明NSMutableURLRequest对象，便于设置请求属性
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            NSURLConnection(request: request, delegate: self)
           

            exit(0)
        } )
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
       
        
    }
       override func viewDidLoad() {
        super.viewDidLoad()
        headView.layer.cornerRadius = 8
        headView.layer.masksToBounds = true
        headView.layer.borderWidth = 1
        headView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor

        self.navigationItem.rightBarButtonItem = Common.getRightItem()
        self.navigationItem.leftBarButtonItem = Common.getLeftItem()
        var item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    override func viewDidAppear(animated: Bool) {
        loadUserInfo()
        var backItem = UIBarButtonItem()
        backItem.title = "返回"
        self.navigationItem.backBarButtonItem = backItem
        mainScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 630)
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        
    }

    override func viewWillDisappear(animated: Bool) {
        saveUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //启动时加载用户设置信息
    func loadUserInfo(){
        var userDefault = NSUserDefaults.standardUserDefaults()
        //判断用户信息是否存在，如果不存在则初始化一个默认值
//        if !userDefault.objectIsForcedForKey("voiceOn"){
//            self.voiceSwitch.on = true
//            self.shackSwitch.on = true
//            self.lockScreenSwitch.on = true
//            self.unDisturbSwitch.on = false
//        }
//        else{
            self.voiceSwitch.on = userDefault.boolForKey("voiceOn")
            self.shackSwitch.on = userDefault.boolForKey("shackOn")
            self.lockScreenSwitch.on = userDefault.boolForKey("lockScreenOn")
            self.unDisturbSwitch.on = userDefault.boolForKey("unDisturbOn")
        
    }
    func saveUserInfo(){
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(self.voiceSwitch.on, forKey: "voiceOn")
        userDefault.setBool(self.shackSwitch.on, forKey: "shackOn")
        userDefault.setBool(self.lockScreenSwitch.on, forKey: "lockScreenOn")
        userDefault.setBool(self.unDisturbSwitch.on, forKey: "unDisturbOn")
        userDefault.synchronize()
    }
    // MARK:检测更新未完成
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        WIndicator.removeIndicatorFrom(self.tabBarController!.view , animation: true)
        var dicData = GBK2UTF8.retrunNSData(data)
        let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var version:Double = 0
        var trackViewUrl = ""
        var resultCount = json["resultCount"].uInt
        if resultCount > 0 {
            var trackViewUrl = json["result"]["trackViewUrl"].string
            var version = json["result"]["version"].double
        }
        if version == 0 {
            var indicator = WIndicator.showMsgInView(self.tabBarController!.view, text: "没有更新", timeOut: 0.8, alpha:0.9)
        }
        else{
            var infoDict = NSDictionary(dictionary: NSBundle.mainBundle().infoDictionary!)
            var currentVersion = infoDict["CFBundleVersion"] as! Double
            if version > currentVersion {
                var alertController = UIAlertController(title: "检测更新", message: "有新版本，是否升级！", preferredStyle: UIAlertControllerStyle.Alert)
                var cancelAction = UIAlertAction(title: "忽略", style: UIAlertActionStyle.Cancel, handler: nil)
                var okAction = UIAlertAction(title: "去APP Store下载", style: UIAlertActionStyle.Default, handler:{
                    (action: UIAlertAction!) -> Void in
                    var url = NSURL(string: trackViewUrl)
                    UIApplication.sharedApplication().openURL(url!)
                } )
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else{
                var indicator = WIndicator.showMsgInView(self.view, text: "没有更新", timeOut: 0.8, alpha:0.9)
            }
        }
    }


}

