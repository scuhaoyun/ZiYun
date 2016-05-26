//
//  CostHandler.swift
//  tallybook
//
//  Created by ZERO. on 15/3/9.
//
//

import Foundation

class MySubjectHandler: BaseHandler {
    
    override class func sqlForCreateTable() -> String? {
        
        return "CREATE TABLE if not exists mySubject (subjectID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, summary text, searchId text, status text)"
    }

    override func sqlForCheckUnique(model: NSObject) -> String? {
        
        var mySubject = model as! MySubjectModel
        return NSString(format: "SELECT * FROM mySubject WHERE subjectId = %zd", mySubject.subjectId!) as String
    }
    override func sqlForQuery() -> String? {
        
        return "select * from mySubject order by subjectID ASC"
    }
    override func sqlForQueryNoRead() -> String? {
        
        return "SELECT COUNT(*) as count FROM mySubject WHERE status = \"未读\" "
    }


    override func sqlForInsert() -> String? {
        
        return "INSERT INTO mySubject (summary,searchId,status) VALUES ( ?, ?, ?)"
    }

    override func sqlForUpdate( subjectId:Int) -> String? {
        
        return "UPDATE mySubject SET status = \"已读\" WHERE subjectId = \(subjectId) "
    }

    override func sqlForDelete() -> String? {
        
        return "DELETE FROM mySubject"
    }
    
    override func sqlForDelete(primaryKey: NSInteger) -> String? {
        
        return NSString(format: "DELETE FROM mySubject WHERE subjectId = %zd", primaryKey) as String
    }

    
//    override func sqlForQuery(primaryKey: UInt) -> String? {
//        
//        return NSString(format: "SELECT * FROM mySubject WHERE subjectId = %zd", primaryKey)
//    }
    
    override func arrayForInsert(array: [BaseModel]!) -> [Array<NSObject>]? {
        
        var result = [Array<NSObject>]()
        
        for model in array {
            let mySubject = model as! MySubjectModel
            let arr:Array<NSObject> = [StringUtils.nilHandler(mySubject.summary), StringUtils.nilHandler(mySubject.searchId), StringUtils.nilHandler(mySubject.status)]
            //summary, pubdate, searchId, revtime, pic, messageType, channelCategory, url, mediaType, emotion, id , content, author, subTitle, num , title, domainSource, domainLevel, domain, word,status
            result.append(arr)
        }
        return result
    }

//    override func arrayForUpdate(array: [BaseModel]!) -> [Array<NSObject>]? {
//        
//        var result = [Array<NSObject>]()
//        
//        for model in array {
//            
//            let mySubject = model as mySubjectModel
//            let arr:Array<NSObject> = [StringUtils.nilHandler(mySubject.longitute), StringUtils.nilHandler(mySubject.latitute), StringUtils.nilHandler(mySubject.speed),StringUtils.nilHandler(mySubject.course),StringUtils.nilHandler(mySubject.time), StringUtils.nilHandler(mySubject.key), mySubject.subjectId]
//            result.append(arr)
//        }
//        
//        return result
//    }
    
    override func resolve(rows: [SQLRow]) -> NSDictionary? {
        
        var result = [BaseModel]()
        var dic = NSMutableDictionary()
        var count = 0
        var subjectRow = "subject1"
        for row in rows {
            var tmpDic = NSMutableDictionary()
            tmpDic.setValue(row["subjectID"]?.asInt(), forKey: "subjectId")
            tmpDic.setValue(row["summary"]?.asString(), forKey: "summary")
            tmpDic.setValue(row["searchId"]?.asString(), forKey: "searchId")
            tmpDic.setValue(row["status"]?.asString(), forKey: "status")
            count += 1
            subjectRow = "subject\(count)"
            dic.setValue(tmpDic, forKey: subjectRow)
        }
        
        return NSDictionary(dictionary: dic)
    }
    
}
