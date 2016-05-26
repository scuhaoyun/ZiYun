//
//  SetupViewController.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/4/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import UIKit
class SetupViewController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(named: "navigationBarBackImage.png"), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.alpha = 1.0
        self.navigationBar.barStyle = UIBarStyle.Default
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
}