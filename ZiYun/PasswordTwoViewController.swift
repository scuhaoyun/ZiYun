//
//  PasswordTwoViewController.swift
//  Account
//
//  Created by sunsea on 15/4/4.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import SwiftyJSON


class PasswordTwoViewController: UIViewController,NSURLConnectionDataDelegate,UITextFieldDelegate {

    @IBOutlet weak var Pwd2View: UIView!
    @IBOutlet weak var oldPwd2TextField: UITextField!
    @IBOutlet weak var newPwd2TextField: UITextField!
    @IBOutlet weak var againNewPwd2TextField: UITextField!
    @IBOutlet weak var submit2Button: UIButton!
    
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Pwd2View.layer.cornerRadius = 8
        Pwd2View.layer.masksToBounds = true
        Pwd2View.layer.borderWidth = 1
        Pwd2View.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        self.navigationItem.title = "修改交易密码"
        
        oldPwd2TextField.delegate = self
        newPwd2TextField.delegate = self
        againNewPwd2TextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Submit2(sender: AnyObject) {
        ModifyPwd2Info()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        ModifyPwd2Info()
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

    func ModifyPwd2Info() -> Bool {
        var isSucceed = false
        if newPwd2TextField.text != againNewPwd2TextField.text {
            var alertController = UIAlertController(title: "提示", message: "亲，两次输入的密码不一致哦", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if oldPwd2TextField.text == "" || newPwd2TextField.text == "" || againNewPwd2TextField.text == "" {
            var alertController = UIAlertController(title: "提示", message: "亲，带*号的不能为空哦", preferredStyle: UIAlertControllerStyle.Alert)
            var retry = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
        }
        else {
            if checkNetwork() {
                let uri = "http://222.143.31.169:8080/DealPwd.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)&pwd=\(oldPwd2TextField.text)&xpwd=\(newPwd2TextField.text)&type=edit"
                let url = NSURL(string: uri)!
                let request = NSMutableURLRequest(URL: url)
                loginConn = NSURLConnection(request: request, delegate: self)
                var indicator = WIndicator.showIndicatorAddedTo(self.view, alpha: 0.35, animation: true)
                indicator.text = "正在验证密码，请稍等"
                isSucceed = true
            }
        }
        return isSucceed
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("didFailWithError")
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var dicData = GBK2UTF8.retrunNSData(data)
        if connection == loginConn {
            var (status, reason, scode) = Common.findPassParser(dicData)
            var message = "OK"
            WIndicator.removeIndicatorFrom(self.view, animation: true)
            if status == "修改密码成功" {
                message = status
                var alertController = UIAlertController(title: "OK", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var retry = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(retry)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                message = status
                var alertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(retryAction)
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
    


}
