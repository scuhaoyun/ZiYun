//
//  SubjectViewController.swift
//  Account
//
//  Created by sunsea on 15/4/20.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit
import Foundation
import SwiftyJSON

class SubjectViewController: UIViewController ,UITextViewDelegate{

    @IBOutlet weak var mainScrollerView: UIScrollView!
    @IBOutlet weak var SubjectView: UIView!
    @IBOutlet weak var RanBtn: UIButton!
    @IBOutlet weak var LimBtn: UIButton!
    @IBOutlet weak var ClaBtn: UIButton!
    @IBOutlet weak var LetBtn: UIButton!
    @IBOutlet weak var RigBtn: UIButton!
    @IBOutlet weak var AddBtn: UIButton!
    @IBOutlet weak var NonBtn: UIButton!
    @IBOutlet weak var OrBtn: UIButton!
    @IBOutlet weak var StarBtn: UIButton!
    @IBOutlet weak var SearchInfo: UITextView!
    @IBOutlet weak var SubBtn: UIButton!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var subName: UITextField!
    var type : AJDropDownPicker!
    var type1: AJDropDownPicker!
    var type2: AJDropDownPicker!
    
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SubjectView.layer.cornerRadius = 8
        SubjectView.layer.masksToBounds = true
        SubjectView.layer.borderWidth = 1
        SubjectView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor

        textView1.backgroundColor = UIColor.clearColor()
        self.navigationItem.title = "添加专题"
        
        SearchInfo.delegate = self
        textView1.delegate = self
        
        
    }
   
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
        if  text.isEqual("\n") {   //检测到“完成”
            textView.resignFirstResponder() //释放键盘
            return false
            
        }
        
        if textView1.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            if text.isEqual("") {
                self.SearchInfo.hidden = false
            }
            else {
                self.SearchInfo.hidden = true
            }
        }
        else {
            if textView1.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 1 {
                if text.isEqual("") {
                    SearchInfo.hidden = false
                }
                else {
                    SearchInfo.hidden = true
                }
            }
            else {
                SearchInfo.hidden = true
            }
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
         mainScrollerView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 580)
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

    

    @IBAction func Range(sender: AnyObject) {
        type = AJDropDownPicker(delegate: self, dataSourceArray: ["请选择","全部(所有网站信息)","行业内(所有您行业相关的信息）","计算机硬件(您行业专属信息)"])
        type.showFromView(sender as! UIView)
    }
    
    
    @IBAction func Limit(sender: AnyObject) {
        type1 = AJDropDownPicker(delegate: self, dataSourceArray: ["最近一天","最近三天","最近一周","最近一月"])
        type1.showFromView(sender as! UIView)
    }
    
    
    @IBAction func Classify(sender: AnyObject) {
        type2 = AJDropDownPicker(delegate: self, dataSourceArray: ["我的专题"])
        type2.showFromView(sender as! UIView)
    }
    
    func dropDownPicker(dropDownPicker: AJDropDownPicker!, didPickObject pickedObject: AnyObject!) {
        if dropDownPicker == type {
             self.RanBtn.setTitle(pickedObject as! NSString as String, forState: UIControlState.Normal)
        }
        
        else if dropDownPicker == type1 {
            self.LimBtn.setTitle(pickedObject as! NSString as String, forState: UIControlState.Normal)
        }
        
        else if dropDownPicker == type2 {
            self.ClaBtn.setTitle(pickedObject as! NSString as String, forState: UIControlState.Normal)
        }
        else {
            
        }
    }
    
    
    @IBAction func LetBracket(sender: AnyObject) {
        var Info = textView1.text
        textView1.text = Info + "("
    }
    
    @IBAction func RigBracket(sender: AnyObject) {
        var Info = textView1.text
        textView1.text = Info + ")"
    }
    
    
    @IBAction func Add(sender: AnyObject) {
        var Info = textView1.text
        textView1.text = Info + "+"
    }
    
    
    @IBAction func Vertical(sender: AnyObject) {
        var Info = textView1.text
       textView1.text = Info + "|"
    }
    
    
    @IBAction func Sub(sender: AnyObject) {
        var Info = textView1.text
        textView1.text = Info + "-"
    }
    
    
    @IBAction func Star(sender: AnyObject) {
        var Info = textView1.text
        textView1.text = Info + "*"
    }
    
    @IBAction func Submit(sender: AnyObject) {
        createSub()
    }
    
    func createSub() -> Bool {
        var isSucceed = false
        if (subName.text == "" || self.RanBtn.titleLabel?.text == "请选择" || textView1.text == "") {
            var alertController = UIAlertController(title: "专题设置", message: "亲，带*项的不能为空", preferredStyle: UIAlertControllerStyle.Alert)
            var retryAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(retryAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            if checkNetwork() {
                var subVirul = ""
                if self.RanBtn.titleLabel?.text == "全部(所有网站信息)" {
                    subVirul = "全部"
                }
                else if self.RanBtn.titleLabel?.text == "行业内(所有您行业相关的信息）" {
                    subVirul = "计算机硬件,计算机软件,计算机网络设备,计算机|网络安全,互联网|电子商务,移动互联网,电子技术|半导体|集成电路,电信与通讯,网络技术与服务,无线通讯"
                }
                else if self.RanBtn.titleLabel?.text == "计算机硬件(您行业专属信息)" {
                    subVirul = "计算机硬件"
                    
                }
                
                let uri = "http://222.143.31.169:8080/AddSubject.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)&subid=2&time=最近一天&pid=2&pn=我的专题&subname=\(subName.text)&hy=计算机硬件&keyword=\(textView1.text)"
                let encodingUri  = uri.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                let url = NSURL(string: encodingUri!)
                // 声明NSMutableURLRequest对象，便于设置请求属性
                let request = NSMutableURLRequest(URL: url!)
                loginConn = NSURLConnection(request: request, delegate: self)
                var indicator = WIndicator.showIndicatorAddedTo(self.view, alpha: 0.35 ,animation: true)
                indicator.text = "  正在提交，请稍后！  "
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
            if status == "添加专题成功" {
                message = status
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

    
}
