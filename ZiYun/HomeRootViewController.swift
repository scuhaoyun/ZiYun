//
//  HomeRootViewController.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/7/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import UIKit

class HomeRootViewController: UIViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var subjectInfoBtn: UIButton!
    @IBOutlet weak var mySubjectBtn: UIButton!
    var addSubject = UIButton()
    var lookSubject = UIButton()
    var dict:NSDictionary!
    var secondStoryboard = UIStoryboard(name: "second", bundle: nil)
    var noReadCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = Common.getRightItem()
        self.navigationItem.leftBarButtonItem = Common.getLeftItem()
       
        self.tabBarController?.tabBar.selectionIndicatorImage = UIImage(named: "topbar_select.png")
        self.tabBarController?.tabBar.alpha = 1.0
        self.tabBarController?.tabBar.backgroundColor = UIColor.clearColor()
        self.tabBarController?.tabBar.backgroundImage = UIImage(named: "tabbar-bg.png")
        self.tabBarController?.tabBar.barTintColor = UIColor.redColor()
        self.tabBarController?.tabBar.barStyle = UIBarStyle.Black
        var item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        

    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        self.noReadCount = Handler.queryNoRead()
        if noReadCount > 0 {
            var badgeView = JSBadgeView(parentView: mySubjectBtn, alignment: JSBadgeViewAlignment.TopRight)
            badgeView.badgeText = "\(noReadCount)"
            self.mySubjectBtn.addSubview(badgeView)
            self.view.sendSubviewToBack(self.mySubjectBtn)
        }

    }
    
    @IBAction func QuestionHelpClick(sender: AnyObject) {
        var helperViewController = HelperViewController(nibName: "HelperViewController", bundle: nil)
       self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(helperViewController, animated: true)
    }
    @IBAction func subjectSearchClick(sender: AnyObject) {
        var searcherViewController = SearcherViewController(nibName: "SearcherViewController", bundle: nil)
        self.navigationController?.pushViewController(searcherViewController, animated: true)
        self.tabBarController?.tabBar.hidden = true;

    }
    @IBAction func subjectCollectClick(sender: AnyObject) {
        var alertView = UIAlertView(title: "请点击查看", message:"", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "我的收藏")
        var indicator = WIndicator.showIndicatorAddedTo(self.tabBarController!.view, alpha: 0.35 ,animation: true)
        indicator.text = "\t\t正在获取分类...\t\t "
        var url = NSURL(string:"http://222.143.31.169:8080/Favorite.do?appkey=test&apppwd=123456&name=13980834302&uid=\(loginUserInfo.uid!)&fid=12")
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        var queue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue:queue , completionHandler:{
            (reponse,data,error) -> Void in
                WIndicator.removeIndicatorFrom(self.tabBarController!.view , animation: true)
                if data != nil {
                    self.dict = GBK2UTF8.retrunNSDictionary(data)
                    alertView.show()
                }
            }
            
        )
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var myStoreViewController = MyStoreViewController(nibName: "MyStoreViewController", bundle: nil)
        myStoreViewController.dict = (self.dict.objectForKey("favoritearticle") as! NSDictionary).objectForKey("我的收藏") as! NSMutableDictionary
         myStoreViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myStoreViewController, animated: true)
        

    }
    @IBAction func subjectInfoClick(sender: AnyObject) {
        var orignalFrame = sender.frame
        addSubject.frame = CGRectMake(orignalFrame.origin.x - 123 , orignalFrame.origin.y + 90, 80 , 35)
        addSubject.backgroundColor = UIColor(red: 0.408, green: 0.408, blue: 0.408, alpha: 0.8)
        addSubject.setTitle("添加专题", forState: UIControlState.Normal)
        addSubject.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addSubject.titleLabel?.font = UIFont.systemFontOfSize(13)
        addSubject.layer.cornerRadius = 12
        addSubject.layer.masksToBounds = true
        addSubject.layer.borderWidth = 3
        addSubject.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        addSubject.addTarget(self, action: "addSubjectCommit", forControlEvents: UIControlEvents.TouchUpInside)
        self.containerView.addSubview(addSubject)
        //查看专题
        lookSubject.frame = CGRectMake(orignalFrame.origin.x - 42 , orignalFrame.origin.y + 90, 80 , 35)
        lookSubject.backgroundColor = UIColor(red: 0.408, green: 0.408, blue: 0.408, alpha: 0.8)
        lookSubject.setTitle("查看专题", forState: UIControlState.Normal)
        lookSubject.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        lookSubject.titleLabel?.font = UIFont.systemFontOfSize(13)
        lookSubject.layer.cornerRadius = 12
        lookSubject.layer.masksToBounds = true
        lookSubject.layer.borderWidth = 3
        lookSubject.layer.borderColor = UIColor(red: 0.871, green: 0.875, blue: 0.878, alpha: 1.00).CGColor
        lookSubject.addTarget(self, action: "lookSubjectCommit", forControlEvents: UIControlEvents.TouchUpInside)
        self.containerView.addSubview(lookSubject)
        (sender as! UIButton).enabled = false

    }
    @IBAction func mySubjectClick(sender: AnyObject) {
        
        var mySubjectViewController = secondStoryboard.instantiateViewControllerWithIdentifier("MySubjectViewController") as! MySubjectViewController
        mySubjectViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mySubjectViewController, animated: true)
        self.tabBarController?.tabBar.hidden = true
           }
    @IBAction func myAcountClick(sender: AnyObject) {
        var myAcountViewController = secondStoryboard.instantiateViewControllerWithIdentifier("AccountViewController") as! AccounterViewController
        self.navigationController?.pushViewController(myAcountViewController, animated: true)
        self.tabBarController?.tabBar.hidden = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        if isLoginTo {
            var indicator = WIndicator.showMsgInView(self.view, text: "登录成功", timeOut: 0.8, alpha:1)
            isLoginTo = false
        }
    }
    override func viewWillDisappear(animated: Bool) {
        enableBack()
    }
    func addSubjectCommit(){
        enableBack()
        var secondStoryboard = UIStoryboard(name: "second", bundle: nil)
        var addSubjectViewController = secondStoryboard.instantiateViewControllerWithIdentifier("SubjectViewController") as! SubjectViewController
        self.navigationController?.pushViewController(addSubjectViewController, animated: true)
        self.tabBarController?.tabBar.hidden = true
    }
    func lookSubjectCommit(){
       enableBack()
       self.tabBarController?.selectedIndex = 0
    }
    func enableBack(){
        addSubject.removeFromSuperview()
        lookSubject.removeFromSuperview()
        subjectInfoBtn.enabled = true
    }
  }
