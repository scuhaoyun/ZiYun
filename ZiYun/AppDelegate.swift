//
//  AppDelegate.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/1/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func applicationDidFinishLaunching(application: UIApplication) {
        application.statusBarHidden = false
        

        //注册远程推送
        if ((UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0) {
                UIApplication.sharedApplication().registerForRemoteNotifications()
                UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:UIUserNotificationType.Badge|UIUserNotificationType.Sound|UIUserNotificationType.Alert, categories: nil))
            
        }
        else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge|UIRemoteNotificationType.Alert|UIRemoteNotificationType.Sound)
        }

        application.statusBarStyle = UIStatusBarStyle.LightContent
        //return true
        DB.singleton()
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //print("received local notification")
        
        application.applicationIconBadgeNumber += 1
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var deviceTokenString = deviceToken.description as NSString
        identifier = deviceTokenString.stringByReplacingOccurrencesOfString("<", withString:"").stringByReplacingOccurrencesOfString(">", withString:"").stringByReplacingOccurrencesOfString(" ", withString:"")
        println(identifier)
        //println(deviceToken)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        var type = userInfo["MSGtype"] as! String
        if (type == "msg"){
            var success = Handler.insert(userInfo["summary"] as! String,searchId: userInfo["searchId"] as! String)
            if success {
//                self.window?.rootViewController = viewController
            }
            else{
                var alertController = UIAlertController(title: "温馨提示", message: "插入数据库出错", preferredStyle: UIAlertControllerStyle.Alert)
                var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.window?.rootViewController = alertController
            }
        }
        else if type == "logot"
        {
            var alertController = UIAlertController(title: "温馨提示", message: "您的账号在别的设备上登录，您也被踢下线", preferredStyle: UIAlertControllerStyle.Alert)
            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.window?.rootViewController = alertController
        }
        else
        {
            
        }
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("注册推送失败，原因\(error)")
    }
    func applicationWillResignActive(application: UIApplication) {
        application.statusBarHidden = false
    }

    func applicationDidEnterBackground(application: UIApplication) {
        application.statusBarHidden = false
        application.applicationIconBadgeNumber = 0

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        application.statusBarHidden = false

        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        application.statusBarHidden = false

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        application.statusBarHidden = false
        DB.finalize()

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
   }

