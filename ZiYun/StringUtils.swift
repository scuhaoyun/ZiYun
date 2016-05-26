//
//  StringUtils.swift
//  tallybook
//
//  Created by ZERO. on 15/3/4.
//  Copyright (c) 2015年 ZERO. All rights reserved.
//

import Foundation

class StringUtils: NSObject {

    class func nilHandler(string: String?) -> String! {
        if  string == nil || string!.isEmpty{
            return ""
        } else {
            return string
        }
    }
    
}

extension String {
    
//    func md5HexDigest() -> String {
//        
//        let cString = (self as NSString).UTF8String
//        let buffer = UnsafeMutablePointer<UInt8>.alloc(16)
//        CC_MD5(cString, (CC_LONG)(strlen(cString)), buffer)
//        
//        let result = NSMutableString()
//        for var i = 0; i < 16; i++ {
//            result.appendFormat("%XZ", buffer[i])
//        }
//        free(buffer)
//        
//        return result.uppercaseString as String
//    }
    
    func positionOf(sub:String)->Int {
        var pos = -1
        if let range = self.rangeOfString(sub) {
            if !range.isEmpty {
                pos = distance(self.startIndex, range.startIndex)
            }
        }
        return pos
    }
    
    func subStringFrom(pos:Int)->String {
        var substr = ""
        let start = advance(self.startIndex, pos)
        let end = self.endIndex
        let range = start..<end
        substr = self[range]
        return substr
    }
    
    func subStringTo(pos:Int)->String {
        var substr = ""
        let end = advance(self.startIndex, pos-1)
        let range = self.startIndex...end
        substr = self[range]
        return substr
    }
}