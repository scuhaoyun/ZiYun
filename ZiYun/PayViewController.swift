//
//  PayViewController.swift
//  Account
//
//  Created by sunsea on 15/4/7.
//  Copyright (c) 2015年 scuapplelab. All rights reserved.
//

import UIKit
//import <AlipaySDK/AlipaySDK.h>

class PayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "交易"
            //self.view.sendSubviewToBack(statusView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        var statusView = UIView(frame:UIApplication.sharedApplication().statusBarFrame)
        statusView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(statusView)
        self.view.sendSubviewToBack(statusView)
        
        //autoLogin()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //配置请求信息
//    class Order {
//        var partner: String?
//        var seller: String?
//        var tradeNO: Int?
//        var productName: String?
//        var productDescription: String?
//        var amount: Int?
//        var notifyURL: String?
//        var service: String?
//        var paymentType: String?
//        var inputCharset: String?
//        var itBPay: String?
//    }
//    var order = Order()
//    order.partner = partner
    
}
