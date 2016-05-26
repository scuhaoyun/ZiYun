//
//  BuyViewController.swift
//  Account
//
//  Created by sunsea on 15/4/7.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation
import SwiftyJSON

var lastday = loginUserInfo.date!  //新增

class BuyViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var Selbtn: UIButton!
    @IBOutlet weak var PayPwd: UITextField!
    @IBOutlet weak var headView: UIView!
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headView.layer.cornerRadius = 8
        headView.layer.masksToBounds = true
        headView.layer.borderWidth = 1
        headView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        PayPwd.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        checkNetwork()
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
    
    
    @IBAction func BuyBtn(sender: AnyObject) {
        Buy()
    }
    
    
    func Buy() -> Bool {
        var isSucceed = false
        if (self.Selbtn.titleLabel?.text == "请选择" || PayPwd.text == "") {
            var alertController = UIAlertController(title: "提示", message: "请填写交易密码或者选择一个交易分类", preferredStyle: UIAlertControllerStyle.Alert)
            var secAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(secAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            if checkNetwork() {
                var moneyVirul = 0.00
                var days = 0
                if self.Selbtn.titleLabel?.text == "一年（1.00元）" {
                    moneyVirul = 1.00
                    days = 360
                }
                else if self.Selbtn.titleLabel?.text == "半年（0.60元）" {
                    moneyVirul = 0.60
                    days = 180
                    //self.Selbtn.titleLabel?.text = "0.60"
                }
                else if self.Selbtn.titleLabel?.text == "一季度（0.30元）" {
                    moneyVirul = 0.30
                    days = 90
                    // self.Selbtn.titleLabel?.text = "0.30"
                }
                else if self.Selbtn.titleLabel?.text == "一个月（0.20元）" {
                    moneyVirul = 0.20
                    days = 30
                    //self.Selbtn.titleLabel?.text = "0.20"
                }
                let uri = "http://222.143.31.169:8080/Deal.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)&pwd=\(PayPwd.text)&money=\(moneyVirul)&days=\(days)&date=\(loginUserInfo.date!)"
                println(uri)
                let url = NSURL(string: uri)!
                println(url)
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
    
    
    
    
    @IBAction func Select(sender: AnyObject) {
        var type = AJDropDownPicker(delegate: self, dataSourceArray: ["一年（1.00元）","半年（0.60元）","一季度（0.30元）","一个月（0.20元）"])
        type.showFromView(sender as! UIView)
    }
    
    func dropDownPicker(dropDownPicker: AJDropDownPicker!, didPickObject pickedObject: AnyObject!) {
        self.Selbtn.setTitle(pickedObject as! NSString as String, forState: UIControlState.Normal)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("didFailWithError");
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        var dicData = GBK2UTF8.retrunNSData(data)
        if connection == loginConn {
            var (date, status, reason, scode) = Common.sccTrade(dicData)
            var message = "Ok"
            WIndicator.removeIndicatorFrom(self.view, animation: true)
            if status == "交易成功" {
                message = status //新增
                lastday = date
                var alertController = UIAlertController(title: "OK", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(confirmAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
            }
            else{
                message = reason
                var alertController = UIAlertController(title: "温馨提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
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
    

    
}
