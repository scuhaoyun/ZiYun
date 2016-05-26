//
//  RegisterViewController.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/3/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,NSURLConnectionDataDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var authcode: UITextField!
    @IBOutlet weak var authcodeBtn: UIButton!
    @IBOutlet weak var registerNavigationBar: UINavigationBar!
    @IBOutlet weak var registerNavigationItem: UINavigationItem!
    var randomAuthCode = "123456"
    var authConn: NSURLConnection?
    var registerConn: NSURLConnection?
    override func viewDidLoad() {
        super.viewDidLoad()
        borderView.layer.cornerRadius = 8
        borderView.layer.masksToBounds = true
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        self.registerNavigationBar.setBackgroundImage(UIImage(named: "navigationBarBackImage.png.png"), forBarMetrics: UIBarMetrics.Default)
        self.registerNavigationBar.alpha = 1.0
        self.registerNavigationBar.barStyle = UIBarStyle.Default
        self.registerNavigationBar.tintColor = UIColor.redColor()
        
        var titleView = UILabel()
        titleView.frame.size.height = 44
        titleView.text = "注册"
        titleView.textColor = UIColor.whiteColor()
        self.registerNavigationItem.titleView = titleView
        var statusView = UIView(frame:UIApplication.sharedApplication().statusBarFrame)
        statusView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(statusView)
        
        self.username.delegate = self
        self.password.delegate = self
        self.authcode.delegate = self
    }
   
    @IBAction func getAuthCode(sender: AnyObject) {
        if ( self.username.text=="" || self.password.text==""){
            var alertController = UIAlertController(title: "提交", message: "亲，输入不能为空哦", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler:nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            if checkNetwork() {
                let uri = "http://222.143.31.169:8080/Sendcode.do?appkey=test&apppwd=123456&phone=\(self.username.text)&code=\(self.randomAuthCode)"
                let url = NSURL(string: uri)!
                // 声明NSMutableURLRequest对象，便于设置请求属性
                let request = NSMutableURLRequest(URL: url)
                authConn = NSURLConnection(request: request, delegate: self)
                self.authcodeBtn.enabled = false
                dispatch_async(dispatch_get_global_queue(0,0), { () -> Void in
                    for (var i = 100 ; i > 0 ; i--){
                        sleep(1)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if( i != 0 ){
                                self.authcodeBtn.setTitle("重新获取(\(i))", forState: UIControlState.Normal)
                            }
                            else{
                                self.authcodeBtn.enabled = true
                                self.authcodeBtn.setTitle("点击获取", forState: UIControlState.Normal)
                            }
                        })
                    }
                })
            }

        }

    }

    @IBAction func registerSubmit() {
        if ( self.username.text=="" || self.password.text=="" || self.authcode.text==""){
            var alertController = UIAlertController(title: "提交", message: "亲，账号、密码或验证码不能为空哦", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler:nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            if self.authcode.text == self.randomAuthCode {
                if checkNetwork() {
                    //连接网络注册
                    let uri = "http://222.143.31.169:8080/Register.do?appkey=test&apppwd=123456&loginname=\(self.username.text)&pwd=\(self.password.text)"
                    println(uri)
                    let url = NSURL(string: uri)!
                    // 声明NSMutableURLRequest对象，便于设置请求属性
                    let request = NSMutableURLRequest(URL: url)
                    registerConn = NSURLConnection(request: request, delegate: self)
                    var indicator = WIndicator.showIndicatorAddedTo(self.view, alpha: 0.35 ,animation: true)
                    indicator.text = "  正在提交，请稍后！  "
                }
                else{
                    
                }
            }
            else{
                var alertController = UIAlertController(title: "提交", message: "验证码错误", preferredStyle: UIAlertControllerStyle.Alert)
                var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler:nil)
                alertController.addAction(retryAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func viewDidAppear(animated: Bool) {
       

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
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var dicData = GBK2UTF8.retrunNSData(data)
        if dicData == nil {
            var alertController = UIAlertController(title: "错误", message: "连接网络出错", preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }

        else if connection == authConn {
            let (status,scode) = Common.authCodeParser(dicData)
            if status == "发送成功" {
                
            }
            else{
                
            }

        }
        else if connection == registerConn {
            WIndicator.removeIndicatorFrom(self.view, animation: true)
            let (status,reason,scode) = Common.registerParser(dicData)
            var message = "注册成功！"
            if status == "注册成功" {
                
            }
            else{
                message = "注册失败！"+reason
            }
            var alertController = UIAlertController(title: "注册提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
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