//
//  WIndicator.swift
//  indicatorDemo
//
//  Created by wangshouye on 14/11/8.
//  Copyright (c) 2014年 wangshouye. All rights reserved.
//

import UIKit

class WIndicator:UIView {
        class func showIndicatorAddedTo(view:UIView, alpha:CGFloat, animation:Bool) -> WActivityIndicator {
        var resultView = WActivityIndicator(view: view)
        view.addSubview(resultView)
        view.alpha = alpha
        resultView.show(animation)
        return resultView
    }
    
    class func removeIndicatorFrom(view:UIView, animation:Bool) {
        var indicatorView: UIView?
        view.alpha = 1.0
        for tempView in view.subviews {
            if (tempView as? WActivityIndicator != nil) {
                indicatorView = tempView as! WActivityIndicator
                break
            }
        }
        
        if ( indicatorView != nil ) {
            (indicatorView as! WActivityIndicator).hideAndRemove(true)
            indicatorView!.removeFromSuperview()
        }
    }

    
    class func showMsgInView(view: UIView, text:String, timeOut interval:NSTimeInterval, alpha:CGFloat) -> WIndicatorText {
        view.alpha = alpha
        var indicatorTextView = WIndicatorText(view: view, text: text, timeOut: interval)
        view.addSubview(indicatorTextView)
        
        
        return indicatorTextView
    }
    
}
//        用法 一
//        var indicator = WIndicator.showIndicatorAddedTo(self.view, viewAlpha: 0.55 ,animation: true)
//        indicator.text = "swift 变态啊，好繁琐  不会啊啊啊啊啊啊啊啊啊"
//
//        dispatch_async(dispatch_get_global_queue(0,0), { () -> Void in
//            sleep(3)
//
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                WIndicator.removeIndicatorFrom(self.view, animation: true)
//            })
//        })

//        用法 二
//        var indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
//
//        dispatch_async(dispatch_get_global_queue(0,0), { () -> Void in
//            sleep(3)
//
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                WIndicator.removeIndicatorFrom(self.view, animation: true)
//            })
//        })

//        用法 三
//        var indicator = WIndicator.showMsgInView(self.view, text: "浮动窗口测试啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊", timeOut: 1.5)








