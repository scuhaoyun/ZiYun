//
//  FeedBackViewController.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/2/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class FeedBackViewController :  UIViewController,NSURLConnectionDataDelegate, AJDropDownPickerDelegte,UITextViewDelegate
 {
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var feedBackTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        headView.layer.cornerRadius = 8
        headView.layer.masksToBounds = true
        headView.layer.borderWidth = 1
        headView.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        var scrollViewWidth = UIScreen.mainScreen().bounds.width
        var titleView = UILabel()
        titleView.frame.size.height = 44
        titleView.text = "反馈信息"
        titleView.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleView
        feedBackTextView.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func typePicker(sender: AnyObject) {

        var picker = AJDropDownPicker(delegate: self, dataSourceArray: ["添加关注信息网站","意见建议","崩溃描述"])
        picker.showFromView(sender as! UIView)
    }
    @IBAction func Submit() {
        //http://222.143.31.169:8080/Suggestion.do?appkey=test&apppwd=123456&name=xxx&uid=xx&from=ios&type=意见建议&text=这是建
        //   议和意见测试&version=手机型号：苹果_ a1586 ,系统版本ios8.1.1
        //let systemName = UIDevice.currentDevice().systemName
        if checkNetwork() {
            let phoneModel = UIDevice.currentDevice().model
            let systemVersion = UIDevice.currentDevice().systemVersion
            let name = loginUserInfo.name!
            let uid = loginUserInfo.uid!
            //uri内不能包含中文字符
            let uri = "http://222.143.31.169:8080/Suggestion.do?appkey=test&apppwd=123456&name=\(name)&uid=\(uid)&from=ios&type=\(self.pickerBtn.titleLabel?.text)&text=\(self.feedBackTextView.text)&version=手机型号：\(phoneModel) ,系统版本\(systemVersion)"
            let encodingUri  = uri.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = NSURL(string: encodingUri!)!
            // 声明NSMutableURLRequest对象，便于设置请求属性
            var appleID = UIDevice.currentDevice().identifierForVendor.UUIDString
            let request = NSMutableURLRequest(URL: url)
            NSURLConnection(request: request, delegate: self)
            var indicator = WIndicator.showIndicatorAddedTo(self.view, alpha: 0.35 ,animation: true)
            indicator.text = "  正在提交，请稍后！  "
        }
        //messagePrompt.MessagePrompt("这是紫云本地的通知信息，请及时查看！你他妈的说什么，你不管我，那我他妈的找谁去，你这个傻逼我才懒得管你，你有本事就去死，不要再来烦我了，马上给我消失，马上！！！")
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
         WIndicator.removeIndicatorFrom(self.view, animation: true)
        if dicData == nil {
            var alertController = UIAlertController(title: "错误", message: "连接网络出错", preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let (status,reason,scode) = Common.registerParser(dicData)
            var message = "提交成功！"
            var title = "确定"
            if status == "提交成功" {
                println(dicData)
            }
            else{
                message = "提交失败！"+reason
                title = "重试"
            }
            var alertController = UIAlertController(title: "反馈提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: title, style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    func dropDownPicker(dropDownPicker: AJDropDownPicker!, didPickObject pickedObject: AnyObject!) {
        self.pickerBtn.setTitle(pickedObject as! NSString as String, forState: UIControlState.Normal)
    }
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }

}