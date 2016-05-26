//
//  BaseHandler.swift
//  tallybook
//
//  Created by ZERO. on 15/2/3.
//  Copyright (c) 2015年 ZERO. All rights reserved.
//

import Foundation

class BaseHandler {
    
    var database: SQLiteHelper?
    init() {
        
        self.database = SQLiteHelper(path: Constants.dbPath)
    }
    
    func operation(model: BaseModel) -> Bool{

        var exist:Bool =  self.findObject(model)
        var success:Bool = false
        if exist == true {
            success = self.update(model)
        } else {
            success = self.insert(model)
        }
        return success
    }
    
    func findObject(model: BaseModel) -> Bool {
        
        var rs = self.database!.executeQuery(self.sqlForCheckUnique(model))
        var result:NSInteger = 0
        for row in rs {
            result = row["subjectID"]!.asInt()
            break
        }
        if result > 0 {
            return true
        }
        return false
    }
    
    func insert(model: BaseModel) -> Bool {
        
        var success:Bool = self.database!.executeUpdate(self.sqlForInsert(), dataSource: self.arrayForInsert([model]))
        return success
    }
    
    func insert(array:[BaseModel]!) -> Bool {
        
        var success:Bool = self.database!.executeUpdate(self.sqlForInsert(), dataSource: self.arrayForInsert(array))
        return success
    }

    func update(model: BaseModel) -> Bool {
        
        var sucess:Bool = self.database!.executeUpdate(self.sqlForUpdate(), dataSource: self.arrayForUpdate([model]))
        return sucess
    }
    
    func update(array: [BaseModel]!) -> Bool {
        
        var sucess:Bool = self.database!.executeUpdate(self.sqlForUpdate(), dataSource: self.arrayForUpdate(array))
        return sucess
    }
    func update(sql:String) -> Bool{
        var sucess:Bool = self.database!.executeUpdate(sql)
        return sucess
    }
    
    func delete() -> Bool {
        
        var sucess:Bool = self.database!.executeUpdate(self.sqlForDelete())
        return sucess
    }

    func delete(primaryKey: NSInteger) -> Bool{
        
        var sucess:Bool = self.database!.executeUpdate(self.sqlForDelete(primaryKey))
        return sucess
    }
    
    func query() -> NSDictionary? {
        
        let rows = self.database!.executeQuery(self.sqlForQuery())
        let result = self.resolve(rows)
        if rows.count > 0 {
            return result
        }
        return [:]
    }
    func queryNoRead() -> Int? {
        Handler.create()
        let rows = self.database!.executeQuery(self.sqlForQueryNoRead())
        return rows[0]["count"]?.asInt()
    }
    func query(primaryKey: NSInteger) -> NSObject? {
        
        let rows = self.database!.executeQuery(self.sqlForQuery(primaryKey))
        var result = self.resolve(rows)
        if result!.count > 0 {
            return result![0] as? NSObject
        }
        return nil
    }

    //MARK:- structure the SQL, override in subclass
    class func sqlForCreateTable() -> String? {
        return nil
    }
    
    func sqlForCheckUnique(model: BaseModel) -> String? {
        return nil
    }

    func sqlForInsert() -> String? {
        return nil
    }
    
    func sqlForUpdate() -> String? {
        return nil
    }
    
    func sqlForUpdate( subjectId:Int) -> String? {
        
        return "UPDATE mySubject SET status = \"已读\" WHERE subjectId = \(subjectId) "
    }

    func sqlForDelete() -> String? {
        return nil
    }
    
    func sqlForDelete(primaryKey: NSInteger) -> String? {
        return nil
    }

    func sqlForQuery() -> String? {
        return nil
    }
    func sqlForQueryNoRead() -> String? {
        
        return nil
    }

    func sqlForQuery(primaryKey: NSInteger) -> String? {
        return nil
    }
    
    func resolve(rows: [SQLRow]) -> NSDictionary? {
        return nil
    }
    
    func arrayForInsert(array: [BaseModel]!) -> [Array<NSObject>]? {
        return nil
    }
    
    func arrayForUpdate(array: [BaseModel]!) -> [Array<NSObject>]?  {
        return nil
    }
}
