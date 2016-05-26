//
//  PaswordOneViewController.swift
//  Account
//
//  Created by sunsea on 15/4/15.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import SwiftyJSON



class PaswordOneViewController: UIViewController,NSURLConnectionDataDelegate,UITextFieldDelegate {

    @IBOutlet weak var PwdView: UIView!
    @IBOutlet weak var oldPwdTextField: UITextField!
    @IBOutlet weak var newPwdTextField: UITextField!
    @IBOutlet weak var againNewPwdTextField: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    
    //var pwd1 = "" //得到旧密码
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PwdView.layer.cornerRadius = 8
        PwdView.layer.masksToBounds = true
        PwdView.layer.borderWidth = 1
        PwdView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        self.navigationItem.title = "修改密码"
        // Do any additional setup after loading the view.
        oldPwdTextField.delegate = self
        newPwdTextField.delegate = self
        againNewPwdTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Submit(sender: AnyObject) {
        checkPwdInfo()
//            var alertController = UIAlertController(title: "提示", message: "OK", preferredStyle: UIAlertControllerStyle.Alert)
//            var retryAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
//            alertController.addAction(retryAction)
//            self.presentViewController(alertController, animated: true, completion: nil)
//
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //checkPwdInfo()
        //loadPwdInfo()
        
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
    
    func checkPwdInfo() -> Bool {
        var isSucceed = false
        if (self.oldPwdTextField.text=="" || self.newPwdTextField.text=="" || self.againNewPwdTextField.text=="") {
            var alertController = UIAlertController(title: "提示", message: "亲，带*项的不能为空", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
//        else if (self.oldPwdTextField.text != pwd1) {
//            var alertController = UIAlertController(title: "提示", message: "亲，旧密码不正确", preferredStyle: UIAlertControllerStyle.Alert)
//            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
//            alertController.addAction(retryAction)
//            self.presentViewController(alertController, animated: true, completion: nil)
//
//        }
        else if(self.newPwdTextField.text != self.againNewPwdTextField.text) {
            var alertController = UIAlertController(title: "提示", message: "亲，两次输入的密码不一致", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)

        }
        else  {
            if checkNetwork() {
            
            let uri = "http://222.143.31.169:8080/EditPwd.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)&pwd=\(oldPwdTextField.text)&xpwd=\(newPwdTextField.text)"
            let url = NSURL(string: uri)!
            // 声明NSMutableURLRequest对象，便于设置请求属性
            let request = NSMutableURLRequest(URL: url)
            loginConn = NSURLConnection(request: request, delegate: self)
            var indicator = WIndicator.showIndicatorAddedTo(self.view, alpha: 0.35 ,animation: true)
            indicator.text = "  正在提交，请稍后！  "
            isSucceed = true
            }

        }
        return isSucceed
    }
    
//    func loadPwdInfo() {
//        var userDefault = NSUserDefaults.standardUserDefaults()
//        pwd1 = userDefault.stringForKey("password")!
//    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("didFailWithError");
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var dicData = GBK2UTF8.retrunNSData(data)
        if connection == loginConn {
            var (status, reason, scode) = Common.findPassParser(dicData)
            var message = "Ok"
            WIndicator.removeIndicatorFrom(self.view, animation: true)
            if status == "修改密码成功" {
                message = status
                var alertController = UIAlertController(title: "OK", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(confirmAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
            }
            else{
                message = reason
                var alertController = UIAlertController(title: "温馨提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
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
    


    
    
//     	修改用户登录密码
//        http://222.143.31.169:8080/EditPwd.do?appkey=test&apppwd=123456&name=xxx&uid=xx&pwd=xxx&xpwd=XXxx
//        pwd为旧密码，xpwd为新密码
    



}
