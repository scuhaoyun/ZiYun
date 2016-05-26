//
//  Handler.swift
//  ZiYun
//
//  Created by ComputeNode0 on 4/27/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

import Foundation
class Handler {
    //如果没有该表则建立该数据库表
    class func create() {
        var database = SQLiteHelper()
        database.open(path: Constants.dbPath)
        database.executeQuery(MySubjectHandler.sqlForCreateTable())
    }
    //插入推送字典数据
    class func insert(summary:String,searchId:String) -> Bool {
        create() 
        var mySubject = MySubjectModel()
        mySubject.summary = summary
        mySubject.searchId = searchId
        mySubject.status = "未读"
        
        var success:Bool = MySubjectHandler().insert(mySubject)
        if success {
            //self.statusLabel.text = "插入数据库成功"
        }
        else {
            //self.statusLabel.text = "插入数据库失败"
        }
        return success
    }
    //查询数据库中所有我的情报，返回一个二维字典数据
    class func queryAll() ->NSDictionary {
        var handler = MySubjectHandler()
        return handler.query()!
    }
    //查询未读的我的情报的条数
    class func queryNoRead() ->Int {
        var handler = MySubjectHandler()
        return handler.queryNoRead()!
    }
    //更新某条subjectId的status为已读
    class func updateNoRead(subjectId:Int) -> Bool {
        var handler = MySubjectHandler()
        var success:Bool = handler.update(handler.sqlForUpdate(subjectId)!)
        return success
    }
    //清空我的情报
    class func clearAll() -> Bool {
        var handler = MySubjectHandler()
        var success:Bool = handler.update(handler.sqlForDelete()!)
        return success
    }
}