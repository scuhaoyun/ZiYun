//
//  Constants.swift
//  Database
//
//  Created by ZERO. on 15/3/19.
//  Copyright (c) 2015年 ZERO. All rights reserved.
//

import UIKit

class Constants {
    class var dbPath: String {
        get {
            var fileManager = NSFileManager.defaultManager()
            let doctumentPath: String = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String).stringByAppendingString("/MySubject.database")
            var exist = fileManager.fileExistsAtPath(doctumentPath)
            if exist == false {
                fileManager.createDirectoryAtPath(doctumentPath, withIntermediateDirectories: true, attributes: nil, error: nil)
            }
            let path = doctumentPath.stringByAppendingPathComponent("mySubject.sqlite")
            println(path)
            return path
        }
    }
}
