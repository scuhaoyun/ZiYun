//
//  SelectFieldViewController.swift
//  Account
//
//  Created by sunsea on 15/4/8.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectFieldViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var FieldTextField: UITextField!
    @IBOutlet weak var tableView2: UITableView!
    var row = 0
    var data = ""
    var groups:[String] = ["计算机|网络|通信","金融|投资|会计","媒体|广告|公关","汽车|能源|冶金|机械|制造|化工|重工业","纺织|食品|家电|日化|轻工业","餐饮|旅游|休闲|娱乐|体育","医疗|保健|生物工程","国际国内贸易|代理商","交通|运输|物流","房地产|建筑|装潢","法律|咨询|服务","教育|科研|培训","政府|公共事业|非盈利机构|协会社团|公共服务","农林牧渔"]
    var fields:[[String]] = [["计算机硬件","计算机软件","计算机网络设备","计算机|网络安全","互联网|电子商务","移动互联网","电子技术|半导体|集成电路","电信与通讯","网络技术与服务","无线通讯"],
    ["保险理财","商业银行","贷款服务","投资银行","风险投资","私募股权投资","基金证券","会计审计"],
    ["媒体|新闻|出版","影视|文化|艺术","互联网媒体"],
    ["媒体|新闻|出版","影视|文化|艺术","互联网媒体","媒体设计制作","广告","市场调研","公共关系"],
    ["汽车|汽车配件","采矿与金属","石油与能源","回收与环境保护","化工|原材料","电子电气设备","机械制造与加工","造船|船舶","纺织及皮革制造","造纸与木材","交通工具与交通管理","玻璃|陶瓷|混凝土","包装与集装箱","工业自动化与管理","礼品与工艺品","仪器仪表","五金工具"],
    ["汽车|汽车配件","采矿与金属","石油与能源","回收与环境保护","化工|原材料","电子电气设备","机械制造与加工","造船|船舶","纺织及皮革制造","造纸与木材","交通工具与交通管理","玻璃|陶瓷|混凝土","包装与集装箱","工业自动化与管理","礼品与工艺品","仪器仪表","五金工具"],
    ["餐饮","娱乐","休闲度假与旅游","酒店","健身|体育运动","娱乐设备与服务"],
    ["医院与医疗","医药品","医疗设备","宠物服务|兽医","生物工程","生物信息"],
    ["国内贸易","国际贸易|进出口","批发","零售","代理商"],
    ["仓储物流","汽运|铁路","航空运输","水上运输","客运及公共交通","供应链","邮政|包裹|快递"],
    ["房地产开发","房产销售|中介","建筑工程","建筑材料","建筑设计","土木工程","装饰装潢"],
    ["法律服务","法律援助","战略|管理咨询|审计服务","招聘猎头","人力资源|培训","翻译服务","设备维护","外包服务","会务及活动服务"],
    ["教育培训","公益组织","行业组织","社会团体"],
    ["政府部门","军事机构","公共设施","水电燃气生产供应","公共安全","图书馆及博物馆","慈善公益事业","翻译服务","家政服务"],
    ["林业","渔业","农业","畜牧业"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.delegate = self
        tableView2.dataSource = self
        setExtraCellLineHidden(self.tableView1)
        setExtraCellLineHidden(self.tableView2)
//        var statusView = UIView(frame:UIApplication.sharedApplication().statusBarFrame)
//        statusView.frame.size.height = 20
//        statusView.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(statusView)
//        self.view.sendSubviewToBack(statusView)
        self.navigationItem.title = "行业信息"
        
        FieldTextField.delegate = self

    }
    //隐藏多余的分割线
    func setExtraCellLineHidden(tableView:UITableView) -> Void{
        var v = UIView(frame: CGRectMake(0, 0,self.view.frame.size.width, 1))
        v.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = v
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == tableView1 {
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return groups.count
        }
        else {
            return fields[row].count
        }
        
        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableView1 {
            cell = tableView.dequeueReusableCellWithIdentifier("FieldCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = groups[indexPath.row]
            return cell
        }
        else if tableView == tableView2 {
            cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = fields[row][indexPath.row]
            return cell
        }
        return  cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == tableView1 {
            row = indexPath.row
            tableView2.reloadData()
        }
        else if tableView == tableView2 {
            var row1 = indexPath.row 
            data = self.fields[row][row1]
   
            performSegueWithIdentifier("AddInfo", sender: self)
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
