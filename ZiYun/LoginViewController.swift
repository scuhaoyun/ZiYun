//
//  LoginViewController.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/2/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import UIKit
import SwiftyJSON
var loginUserInfo = UserInfo()
var isLoginTo = false
var identifier:String!
class LoginViewController: UIViewController,NSURLConnectionDataDelegate,UITextFieldDelegate
{
    class func getSubject() -> (NSDictionary) {
        return loginUserInfo.subject!
    }
    

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var isRememberPasswordSwitch: UISwitch!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    var dataCount = 1
    var tmpData:NSMutableData?
    override func viewDidLoad() {
        super.viewDidLoad()
        borderView.layer.cornerRadius = 4
        borderView.layer.masksToBounds = true
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        username.delegate = self
        password.delegate = self
       
           }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        var statusView = UIView(frame:UIApplication.sharedApplication().statusBarFrame)
        statusView.frame.size.height = 20
        statusView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(statusView)
        self.view.sendSubviewToBack(statusView)

        checkNetwork()
        loadUserInfo()
        autoLogin()

    }
    //离开该页面时保存用户信息
    override func viewWillDisappear(animated: Bool) {
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(self.username.text, forKey: "username")
        userDefault.setObject(self.password.text, forKey: "password")
        userDefault.setObject(self.isRememberPasswordSwitch.on , forKey: "isRememberPass")
       
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    //点击登录按钮，记录用户信息并登录
    @IBAction func Login() {
        checkUserInfo()
    }
    
    @IBAction func forgotPassword() {
        //http://222.143.31.169:8080/GetPwd.do?appkey=test&apppwd=123456&loginname=xxx
        if checkNetwork() {
            let uri = "http://222.143.31.169:8080/GetPwd.do?appkey=test&apppwd=123456&loginname=\(self.username.text)"
            let url = NSURL(string: uri)!
            // 声明NSMutableURLRequest对象，便于设置请求属性
            let request = NSMutableURLRequest(URL: url)
            findPassConn = NSURLConnection(request: request, delegate: self)
        }
    }
    @IBAction func unwindToLoginViewController(segue:UIStoryboardSegue) {
      
    }
    //检查网络是否连接
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
    
    //检查是否记住密码，如果记住密码，则自动填充用户名和密码且自动登录，否则只读取信息，用户自己输入用户名和密码
    func loadUserInfo(){
        var userDefault = NSUserDefaults.standardUserDefaults()
        //如果存在用户信息，就将其读出并初始化界面
            self.username.text = userDefault.stringForKey("username")
            self.isRememberPasswordSwitch.on = userDefault.boolForKey("isRememberPass")
        if self.isRememberPasswordSwitch.on {
            self.password.text  = userDefault.stringForKey("password")
        }
        
    }
    func checkUserInfo() -> Bool {
        var isSucceed = false
        //判断用户名和密码框中是否为空
        if ( self.username.text=="" || self.password.text==""){
            var alertController = UIAlertController(title: "登录", message: "亲，账号或密码不能为空哦", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler:nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            if checkNetwork() {
            //连接网络判断用户名和密码是否正确
                if identifier == nil {
                    //identifier = "6b70b28f3c6936ae0fa50ce116aadcc22cfabe5e7000bae3569cbf8cf2bf5181"
                    identifier = UIDevice().identifierForVendor.UUIDString
                }
                let uri = "http://222.143.31.169:8080/Login.do?appkey=test&apppwd=123456&loginname=\(self.username.text)&pwd=\(self.password.text)&sid=\(identifier)"
                let url = NSURL(string: uri)!
                println(uri)
                // 声明NSMutableURLRequest对象，便于设置请求属性
                let request = NSMutableURLRequest(URL: url)
                loginConn = NSURLConnection(request: request, delegate: self)
                var indicator = WIndicator.showIndicatorAddedTo(self.view, alpha: 0.35 ,animation: true)
                indicator.text = "  正在验证密码，请稍后！  "
                isSucceed = true
            }
            else{
                
            }

        }
        return isSucceed

    }
    func autoLogin(){
        var userDefault = NSUserDefaults.standardUserDefaults()
        self.isRememberPasswordSwitch.on = userDefault.boolForKey("isRememberPass")
        if self.isRememberPasswordSwitch.on && userDefault.stringForKey("autoLogin") == "YES"{
            checkUserInfo()
         }

    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        var alertController = UIAlertController(title: "错误", message: "连接网络出错", preferredStyle: UIAlertControllerStyle.Alert)
        var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var dicData = GBK2UTF8.retrunNSData(data)
        if tmpData == nil{
            tmpData = NSMutableData(data: dicData)
        }
        else{
            tmpData?.appendData(dicData)
        }
        WIndicator.removeIndicatorFrom(self.view, animation: true)
        //MARK 此处登录成功返回数据可能分两次返回，因此会出现解析错误
        if dicData == nil {
            var alertController = UIAlertController(title: "错误", message: "连接网络出错", preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if connection == loginConn {
          Common.userInfoParser(dicData)
            if loginUserInfo.status == nil {
                if dataCount == 2 {
                    Common.userInfoParser(tmpData!)
                    if loginUserInfo.status == "登录成功" {
                        var userDefault = NSUserDefaults.standardUserDefaults()
                        userDefault.setObject("YES" , forKey: "autoLogin")
                        userDefault.synchronize()
                        loginUserInfo.username = self.username.text
                        isLoginTo = true
                        performSegueWithIdentifier("LoginToHome", sender: self)
                        
                    }
                    else{
                        dataCount = 1
                        tmpData = nil
                        var alertController = UIAlertController(title: "登陆提示", message: "用户名或密码错误", preferredStyle: UIAlertControllerStyle.Alert)
                        var cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }

                }
                else{
                    dataCount += 1
                }
            }

          else if loginUserInfo.status == "登录成功" {
                dataCount = 1
                tmpData = nil
                loginUserInfo.username = self.username.text
                isLoginTo = true
                performSegueWithIdentifier("LoginToHome", sender: self)
                
            }
//            else if loginUserInfo.status == nil {
//                var alertController = UIAlertController(title: "登陆提示", message: "亲，服务器压力有点重，请重试", preferredStyle: UIAlertControllerStyle.Alert)
//                var cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
//                alertController.addAction(cancelAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
            else{
                dataCount = 1
                tmpData = nil
                var alertController = UIAlertController(title: "登陆提示", message: "用户名或密码错误", preferredStyle: UIAlertControllerStyle.Alert)
                var cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else if connection == findPassConn {
            let (status, reason, scode) = Common.findPassParser(dicData)
            var message = "亲！密码已经以短信形式发送到您注册账号时填写的手机，请注意查收"
            if status == "密码发送成功" {
               
            }
            else{
                message = reason
            }
            var alertController = UIAlertController(title: "密码找回", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
         }
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

