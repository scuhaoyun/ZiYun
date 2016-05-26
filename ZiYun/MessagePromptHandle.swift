//
//  MessagePrompt.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/2/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import UIKit

class MessagePromptHandle {
    var player:AVAudioPlayer? = nil
    var userDefault = NSUserDefaults.standardUserDefaults()
    //加载声音文件
    init(){
         //loadSound("1")
        //self.player?.stop()
    }
    func loadSound(filename:NSString) {
        let url = NSBundle.mainBundle().URLForResource(filename as String, withExtension: "aiff")
        var error:NSError? = nil
        self.player = AVAudioPlayer(contentsOfURL: url, error: &error)
        self.player!.prepareToPlay()
    }
    //请在调用这个函数之前类尽早初始化
    func MessagePrompt(message:String){
        //锁屏通知
        if userDefault.boolForKey("lockScreenOn") {
            //发送通知
            var localNotification = UILocalNotification()
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
            localNotification.alertBody = message
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.applicationIconBadgeNumber = 1
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.alertAction = "查看"
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        //免扰模式是否开启
        if userDefault.boolForKey("unDisturbOn") {
            var today:NSDate = NSDate()
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH" //“HH"大写强制24小时制
            var hour = dateFormatter.stringFromDate(today)
            var  hourNum:Int = hour.toInt()!
            if (hourNum < 6 || hourNum > 21) {
                
            }
            else{
                playPrompt()
            }
        }
        else{
            playPrompt()
        }
    }
    
    func playPrompt() {
        if userDefault.boolForKey("voiceOn") {
            //播放声音
            self.player!.play()
        }
        if userDefault.boolForKey("shackOn") {
            //播放震动
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }

    }
    
}

