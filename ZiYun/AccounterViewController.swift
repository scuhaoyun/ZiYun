//
//  AccounterViewController.swift
//  Account
//
//  Created by sunsea on 15/4/2.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccounterViewController: UIViewController {

    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainderLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var remainddayLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    var today: NSDate = NSDate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headView.layer.cornerRadius = 6
        headView.layer.masksToBounds = true
        headView.layer.borderWidth = 1
        headView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
       
        
        accountLabel.text = loginUserInfo.username
        nameLabel.text = loginUserInfo.name
        
        AccountInfo()
        
        //将NSDate类型转换成String类型
//        var formatter = NSDateFormatter()
//        formatter.dateFormat = ("yyyy-MM-dd")
//        var today1 = formatter.stringFromDate(today)
//        
//        deadlineLabel.text = today1
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = ("yyyy-MM-dd")
        var lastday1 = formatter.dateFromString(lastday)
        var timediff:Double = lastday1!.timeIntervalSince1970 - today.timeIntervalSince1970
        var oneDaySecs:Double = 24*3600
        var daydiff = Int(timediff/oneDaySecs)
        
        //var today1 = formatter.stringFromDate(today)
        
        deadlineLabel.text = lastday
        if daydiff > 0{
            remainddayLabel.text = "\(daydiff)"
        }
        else{
            remainddayLabel.text = "0"
        }
        

        var item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationItem.title = "我的账号"
         mainScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 680)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewDidAppear(animated: Bool) {
        mainScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 680)
        checkNetwork()
    }
    override func viewWillDisappear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = false
    }
    func checkNetwork() -> Bool {
        if IJReachability.isConnectedToNetwork() {
            
        }
        else {
            var alertController = UIAlertController(title: "温馨提示", message: "亲，您的网络连接未打开哦", preferredStyle: UIAlertControllerStyle.Alert)
            var okAction = UIAlertAction(title: "前往打开", style: UIAlertActionStyle.Default, handler:{
                (action: UIAlertAction!) -> Void in
                //打开设置页面  注：未测试成功
                var url = NSURL(string: "prefs:root=WIFI")
                UIApplication.sharedApplication().openURL(url!)
            } )
            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        return IJReachability.isConnectedToNetwork()
    }

    func AccountInfo() -> Bool {
        var isSucceed = false
        if checkNetwork() {
            let uri = "http://222.143.31.169:8080/GetInfo.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)"
            let url = NSURL(string: uri)!
            let request = NSMutableURLRequest(URL: url)
            loginConn = NSURLConnection(request: request, delegate: self)
            isSucceed = true
        }
        return isSucceed
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("didFailWithError")
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var Info = GBK2UTF8.retrunNSData(data)
        if connection == loginConn {
            var (paypwd,money,status,scode) = Common.myAccount(Info)
            if status == "用户账户信息获取成功" {
                if paypwd == "ok" {
                    remainderLabel.text = money
                }
                else if paypwd == "" {
                    var alertController = UIAlertController(title: "提示", message: "没有设置交易密码，请设置交易密码", preferredStyle: UIAlertControllerStyle.Alert)
                    var retryAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(retryAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else {
                }
                
            }
        }
    }
    
    
    @IBAction func PaySub(sender: AnyObject) {
        AccountInfo()
        
    }
    
    @IBAction func BuySub(sender: AnyObject) {
        AccountInfo()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
