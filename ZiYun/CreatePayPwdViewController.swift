//
//  CreatePayPwdViewController.swift
//  Account
//
//  Created by sunsea on 15/4/19.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreatePayPwdViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var NewPwd: UITextField!
    @IBOutlet weak var ConfirmPwd: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headView.layer.cornerRadius = 8
        headView.layer.masksToBounds = true
        headView.layer.borderWidth = 1
        headView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor

        // Do any additional setup after loading the view.
        NewPwd.delegate = self
        ConfirmPwd.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        checkNetwork()
    }
    
    @IBAction func Confirm(sender: AnyObject) {
        CreatPayPwd()
        
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

    func CreatPayPwd() -> Bool {
        var isSucceed = false
        if (NewPwd.text != ConfirmPwd.text) {
            var alertController = UIAlertController(title: "提示", message: "亲！两次输入的密码不一致哦", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if (NewPwd.text == "" || ConfirmPwd.text == "") {
            var alertController = UIAlertController(title: "提示", message: "亲，带*项的不能为空", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            if checkNetwork() {
                var uri = "http://222.143.31.169:8080/DealPwd.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)&pwd=\(NewPwd.text)&xpwd=\(ConfirmPwd.text)&type=create"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}
