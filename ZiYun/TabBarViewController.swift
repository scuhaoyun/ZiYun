//
//  TabBarViewController.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/4/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import UIKit
class TabBarViewController : UITabBarController,UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var tabBarEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        var viewController = MyThemeViewController(nibName: "MyThemeViewController", bundle: nil)
        var dict = loginUserInfo.subject!
        //println(dict)
        var array = dict.allKeys
        var str = array[0] as! String
        viewController.myTheme = dict.objectForKey(str) as! NSMutableDictionary
        viewController.professionTheme = dict.objectForKey("行业专题") as! NSMutableDictionary
        viewController.username = loginUserInfo.username
        viewController.uid = "\(loginUserInfo.uid!)"
        viewController.myleftItem = Common.getLeftItem()
        viewController.myrightItem = Common.getRightItem()
        var tabBarController1 = UINavigationController(rootViewController: viewController)
//        tabBarController1. = Common.getRightItem()
//        tabBarController1.navigationItem.leftBarButtonItem = Common.getLeftItem("MDCL情报")
        var item1 = UITabBarItem(title: "", image:UIImage(named: "tab1_normal.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal),tag:0)
        item1.imageInsets = tabBarEdgeInsets
        tabBarController1.tabBarItem = item1
        tabBarController1.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        
        
        var homeViewController = storyBoard.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
        var item2 = UITabBarItem(title: "", image:UIImage(named: "tab2_normal.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal),tag:1)
        item2.imageInsets = tabBarEdgeInsets
        homeViewController.tabBarItem = item2
        homeViewController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        var setupViewController = storyBoard.instantiateViewControllerWithIdentifier("setupViewController") as! SetupViewController
        var setupItem = UITabBarItem(title: "", image:UIImage(named: "tab3_normal.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal),tag:2)
        setupItem.imageInsets = tabBarEdgeInsets
        setupViewController.tabBarItem = setupItem
        var viewControllerAarry = NSArray(objects: tabBarController1,homeViewController,setupViewController)
        self.setViewControllers(viewControllerAarry as [AnyObject], animated: false)
        self.selectedIndex = 1
        
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        UIView.beginAnimations( nil , context: nil)
//        UIView.setAnimationDuration(0.2)
//        
//        //CGRect frame = tabBarArrow.frame;
//        UIView.commitAnimations()
//        var animation = CATransaction
//         animation.duration = 0.5
//        animation.timingFunction = CAMediaTimingFunction(name: <#String!#>)
//        var animation =
//        CATransition* animation = [CATransition animation];
//        [animation setDuration:0.5f];
//        [animation setType:kCATransitionFade];
//        [animation setSubtype:kCATransitionFromRight];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//        [[self.view layer]addAnimation:animation forKey:@"switchView"];
    
    }


}
