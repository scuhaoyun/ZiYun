//
//  AddInfoViewController.swift
//  Account
//
//  Created by sunsea on 15/4/4.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddInfoViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var ComNameTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var PositionTextField: UITextField!
    @IBOutlet weak var FieldTextField: UITextField!
    @IBOutlet weak var DoneButton: UIButton!
    
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    
    //var Message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "完善信息"
               //FieldTextField.text = Message

        // Do any additional setup after loading the view.
        var item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        ComNameTextField.delegate = self
        NameTextField.delegate = self
        PositionTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       
//    @IBAction func selectJob(sender: AnyObject) {
//        var secondStoryboard = UIStoryboard(name: "second", bundle: nil)
//        var selectFieldViewController = secondStoryboard.instantiateViewControllerWithIdentifier("SelectFieldViewController") as! SelectFieldViewController
//        self.navigationController?.pushViewController(selectFieldViewController, animated: true)
//    }
    @IBAction func cancelToAddInfoViewController(segue:UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindSegueToAddInfoController(segue:UIStoryboardSegue) {
        var vc = segue.sourceViewController as! SelectFieldViewController
        FieldTextField.text = vc.data
        
    }
    
    override func viewDidAppear(animated: Bool) {
        checkNetwork()
    }
    
    @IBAction func Submit(sender: AnyObject) {
        AddUserInfo()
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
    
    
    func AddUserInfo() -> Bool {
        var isSucceed = false
        if (ComNameTextField.text == "" || NameTextField.text == "" || PositionTextField.text == "" || FieldTextField.text == "") {
            var alertController = UIAlertController(title: "完善信息", message: "亲！请全部填写", preferredStyle: UIAlertControllerStyle.Alert)
            var retry = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(retry)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            if checkNetwork() {
//                http://222.143.31.169:8080/UserInfo.do?appkey=test&apppwd=123456&name=xxx&uid=xx&job=xxx&hy=xxx&company=xxxx 这里的name是昵称，job为职务，hy为行业，company为单位   张三
                let uri = "http://222.143.31.169:8080/UserInfo.do?appkey=test&apppwd=123456&name=\(NameTextField.text)&uid=\(loginUserInfo.uid!)&job=\(PositionTextField.text!)&hy=\(FieldTextField.text)&company=\(ComNameTextField.text)"
                //当传送的数据带有中文字符时，执行下面的语句
                let encodingUri  = uri.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                let url = NSURL(string: encodingUri!)
               // println(url)
                // 声明NSMutableURLRequest对象，便于设置请求属性
                let request = NSMutableURLRequest(URL: url!)
                loginConn = NSURLConnection(request: request, delegate: self)
                var indicator = WIndicator.showIndicatorAddedTo(self.view, alpha: 0.35 ,animation: true)
                indicator.text = "正在提交，请稍后！  "
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
            if status == "用户信息修改成功" {
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
    



}
