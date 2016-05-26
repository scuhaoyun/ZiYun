//
//  myInformationTableViewController.swift
//  Account
//
//  Created by sunsea on 15/4/24.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import SwiftyJSON


class MySubjectViewController: UITableViewController,NSURLConnectionDataDelegate {

    @IBOutlet var newsTableView: UITableView!
    
    var loginConn:NSURLConnection?
    var findPassConn:NSURLConnection?
    
    
    var _dataSource: NSDictionary = Handler.queryAll()
    var _aiv:UIActivityIndicatorView!

    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title =  "我的情报"
        //Handler.insert("昨天朋友从钱江新城送我去萧山机场，经庆春路隧道我随手拍了一张（抱歉因车身抖动，照片较模糊）", searchId: "161550899871890")
         _dataSource = Handler.queryAll()
        self.newsTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        println(_dataSource)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.refreshControl?.tintColor = UIColor.grayColor()
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        
        var tableFooterView:UIView = UIView()
        tableFooterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 30)
        tableFooterView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = tableFooterView
        
        //加载更多地按钮
        let loadMoreBtn = UIButton()
        loadMoreBtn.frame = CGRectMake(0, 0, self.view.bounds.width, 30)
        loadMoreBtn.setTitle("加载更多", forState: .Normal)
        loadMoreBtn.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        loadMoreBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        loadMoreBtn.addTarget(self, action: "loadMore:", forControlEvents: .TouchUpInside)
        tableFooterView.addSubview(loadMoreBtn)
        
        
        // 加载更多 状态 风火轮
        _aiv = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        _aiv.center = loadMoreBtn.center
        tableFooterView.addSubview(_aiv)
        
        refresh()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清空", style: UIBarButtonItemStyle.Plain, target: self, action: "clearAll")
        var item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    func clearAll(){
        var alertController = UIAlertController(title: "温馨提示", message: "你确定要清空吗？", preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "清空", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            Handler.clearAll()
            self._dataSource = Handler.queryAll()
            self.newsTableView.reloadData()
        } )
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    func loadMore(sender:UIButton) {
        sender.hidden = true
        _aiv.startAnimating()
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
             self._dataSource = Handler.queryAll()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                sleep(1)
                self._aiv.stopAnimating()
                sender.titleLabel?.text = "加载完成"
                sender.hidden = false
                self.newsTableView.reloadData()
            })
        })
    }
    
    
    func refresh() {
        if self.refreshControl?.refreshing == true {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Loading...")
        }
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            self._dataSource = Handler.queryAll()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                sleep(1)
                self.refreshControl?.endRefreshing()
                self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
                self.newsTableView.reloadData()
            })
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return _dataSource.allKeys.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       var cell = newsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ContentCell
    
       var status: String = (_dataSource["subject\(indexPath.row + 1)"] as! NSDictionary)["status"] as! String
       var summary: String = (_dataSource["subject\(indexPath.row + 1)"] as! NSDictionary)["summary"] as! String
        if cell == "" {
            cell = ContentCell(style:  .Default, reuseIdentifier: "cell")
        }
        cell.titleLabel.text = summary
        if status == "未读" {
            cell.readImageView.image = UIImage(named: "unread.png")
        }
        else {
            cell.readImageView.image = UIImage(named: "read.png")
        }
        return cell
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var searchId: String = (_dataSource["subject\(indexPath.row + 1)"] as! NSDictionary)["searchId"] as! String
        var subjectId: Int = (_dataSource["subject\(indexPath.row + 1)"] as! NSDictionary)["subjectId"] as! Int
        let uri = "http://222.143.31.169:8080/Article.do?appkey=test&apppwd=123456&name=\(loginUserInfo.username!)&uid=\(loginUserInfo.uid!)&searchid=\(searchId)&msgtype=msg"
        let encodingUri  = uri.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string: encodingUri!)
        // 声明NSMutableURLRequest对象，便于设置请求属性
        let request = NSMutableURLRequest(URL: url!)
        var searchConn = NSURLConnection(request: request, delegate: self)
        var indicator = WIndicator.showIndicatorAddedTo(self.tabBarController!.view, alpha: 0.35 ,animation: true)
        indicator.text = "  正在加载，请稍后！  "
        Handler.updateNoRead(subjectId)
        return indexPath
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        var alertController = UIAlertController(title: "错误", message: "连接网络出错", preferredStyle: UIAlertControllerStyle.Alert)
        var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        WIndicator.removeIndicatorFrom(self.tabBarController!.view, animation: true)
        var dicData = GBK2UTF8.retrunNSData(data)
        WIndicator.removeIndicatorFrom(self.view, animation: true)
        if dicData == nil {
            var alertController = UIAlertController(title: "错误", message: "连接网络出错", preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            var detailContentviewController = DetailContentViewController(nibName: "DetailContentViewController", bundle: nil)
            var dict = Common.subjectInfoParser(dicData)
            if dict == nil {
                var alertController = UIAlertController(title: "错误", message: "获取该文章出错", preferredStyle: UIAlertControllerStyle.Alert)
                var cancelAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else{
                detailContentviewController.dict = dict! as! [String : NSObject]
                    detailContentviewController.isStore = false
                self.navigationController?.pushViewController(detailContentviewController, animated: true)
            }
            
        }
    }

}
