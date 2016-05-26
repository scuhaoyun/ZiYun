//
//  SQLiteHelper.swift
//
//  Created by ZERO. on 15/3/18.
//  Copyright (c) 2015年 ZERO. All rights reserved.
//

import UIKit
class SQLiteHelper: NSObject {
    
    var database: COpaquePointer = nil
    var queue: dispatch_queue_t
    

    class var sharedInstance: SQLiteHelper {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SQLiteHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            // there need a path where the database file stored.
            Static.instance = SQLiteHelper(path: Constants.dbPath)
        }
        return Static.instance!
    }
    
    override init() {
        queue = dispatch_queue_create("ZERO.SQLITEHELPER", nil)
    }
    
    init(path p:String) {
        queue = dispatch_queue_create("ZERO.SQLITEHELPER", nil)
        
        if sqlite3_open(p, &self.database) != SQLITE_OK {
            println("ZERO.SqliteHelper - failed to open databse ")
            sqlite3_close(self.database)
        }
        
    }
    
    deinit {
        if database != nil {
            if sqlite3_close(database) == SQLITE_OK {
                println("database close..")
            }
        }
    }
    
    func open(path p:String!) {
        dispatch_sync(queue, { () -> Void in
            if sqlite3_open(p, &self.database) != SQLITE_OK {
                println("ZERO.SqliteHelper - failed to open databse ")
                sqlite3_close(self.database)
            }
        })
    }
    
    func close() {
        if database != nil {
            if sqlite3_close(database) != SQLITE_OK {
                let errMsg = String.fromCString(sqlite3_errmsg(database))
                println("ZERO.SqliteHelper - sqlite close error: \(errMsg)")
            }
        }
    }
    
    func executeUpdate(sql: String!) -> Bool {
        
        return self.executeUpdate(sql, params: nil)
    }
    
    func executeUpdate(sql: String!, params: [AnyObject]?) -> Bool{
        
        var result:CInt = 0
        dispatch_sync(queue) {
            let stmt = self.prepare(sql, params:params)
            if stmt != nil {
                result = self.execute(stmt, sql: sql)
            }
        }
        return self.jungle(result)
    }
    
    func executeUpdate(sql: String!, dataSource: [Array<NSObject>]?) -> Bool{
        
        if sqlite3_exec(database, "BEGIN", nil, nil, nil) == SQLITE_OK {
            
            var resultCode:Bool = true
            for var index = 0; index < dataSource!.count ; index++ {
                
                let data = dataSource![index] as [NSObject]
                let result = self.executeUpdate(sql, params: data)
                
                if !result {
                    println("ZERO.SqliteHelper - excute sql error on \(index + 1) item. ")
                    resultCode = result
                    break
                }
            }
            
            if resultCode {
                return self.commit()
            } else {
                self.rollback()
            }
            
        } else {
            let errMsg = String.fromCString(sqlite3_errmsg(database))
            println("ZERO.SqliteHelper - transaction begin error: \(errMsg)")
            self.close()
        }
        
        return false
    }
    
    func executeQuery(sql: String!) -> [SQLRow]{
        return self.executeQuery(sql, params: nil)
    }
    
    func executeQuery(sql: String!, params: [AnyObject]?) -> [SQLRow]{
        
        var result = [SQLRow]()
        
        dispatch_sync(queue) {
            let stmt = self.prepare(sql, params:params)
            if stmt != nil {
                result = self.query(stmt, sql: sql)
            }
        }
        return result
    }
    
    //MARK:-
    //MARK: private functions
    private func commit() -> Bool{
        if (sqlite3_exec(database, "COMMIT", nil, nil, nil) == SQLITE_OK) {
            return true
        } else {
            let errMsg = String.fromCString(sqlite3_errmsg(database))
            println("ZERO.SqliteHelper - transaction commit error: \(errMsg)")
            self.close()
        }
        return false
    }
    
    private func rollback() {
        println("ZERO.SqliteHelper - excute sql error, rollback.")
        if (sqlite3_exec(database, "ROLLBACK", nil, nil, nil) != SQLITE_OK) {
            let errMsg = String.fromCString(sqlite3_errmsg(database))
            println("ZERO.SqliteHelper - transaction rollback error : \(errMsg)")
            self.close()
        }
    }
    
    private func prepare(sql: String, params: [AnyObject]?=nil) -> COpaquePointer{
        
        let cSql = (sql as NSString).UTF8String
        var stmt: COpaquePointer = nil
        let result = sqlite3_prepare(database, cSql, -1, &stmt, nil)
        if result != SQLITE_OK {
            let err = sqlite3_errmsg(database)
            let errMsg = String.fromCString(err)
            println("ZERO.SqliteHelper - failed to prepare a sql \(errMsg)")
            self.close()
        }
        
        if params != nil {
            
            let count = sqlite3_bind_parameter_count(stmt)
            let cnt = CInt(params!.count)
            if count != cnt {
                let msg = "ZERO.SqliteHelper - failed to bind parameters, counts did not match. SQL: \(sql), Parameters: \(params)"
                println(msg)
                return nil
            }
            
            var flag:CInt = 0
            let intTran = UnsafeMutablePointer<Int>(bitPattern: -1)
            let tranPointer = COpaquePointer(intTran)
            let transient = CFunctionPointer<((UnsafeMutablePointer<()>) -> Void)>(tranPointer)
            
            for ndx in 1...cnt {
                
                if params![ndx-1] is String {
                    
                    let txt = params![ndx-1] as! String
                    flag = sqlite3_bind_text(stmt, CInt(ndx), txt, -1, transient)
                    
                } else if params![ndx-1] is NSData {
                    
                    let data = params![ndx-1] as! NSData
                    flag = sqlite3_bind_blob(stmt, CInt(ndx), data.bytes, -1, nil)
                    
                } else if params![ndx-1] is NSDate {
                    
                    let date = params![ndx-1] as! NSDate
                    let d = (date.timeIntervalSince1970 * 1000) as Double
                    flag = sqlite3_bind_double(stmt, CInt(ndx), CDouble(d))
                    
                } else if params![ndx-1] is Int {
                    
                    // Is this an integer or float
                    let vfl = params![ndx-1] as! Double
                    let vint = Double(Int(vfl))
                    if vfl == vint {
                        // Integer
                        let val = params![ndx-1] as! Int
                        flag = sqlite3_bind_int(stmt, CInt(ndx), CInt(val))
                    } else {
                        // Float
                        let val = params![ndx-1] as! Double
                        flag = sqlite3_bind_double(stmt, CInt(ndx), CDouble(val))
                    }
                    
                }
                
                if flag != SQLITE_OK {
                    sqlite3_finalize(stmt)
                    if let error = String.fromCString(sqlite3_errmsg(database)) {
                        
                        let msg = "ZERO.SqliteHelper - failed to bind for SQL: \(sql), Parameters: \(params), Index: \(ndx) Error: \(error)"
                        println(msg)
                    }
                    self.close()
                    return nil
                }
            }
        }
        return stmt
    }
    
    private func execute(stmt: COpaquePointer, sql: String) -> CInt {
        
        var result = sqlite3_step(stmt)
        if result != SQLITE_OK && result != SQLITE_DONE {
            
            sqlite3_finalize(stmt)
            if let err = String.fromCString(sqlite3_errmsg(database)) {
                let msg = "ZERO.SqliteHelper - failed to execute SQL: \(sql), Error: \(err)"
                println(msg)
            }
            self.close()
            return 0
        }
        
        let upp = sql.uppercaseString
        if upp.hasPrefix("INSERT") {
            
            let rid = sqlite3_last_insert_rowid(database)
            result = CInt(rid)
            
        } else if upp.hasPrefix("DELETE") || upp.hasPrefix("UPDATE") {
            
            var cnt = sqlite3_changes(database)
            if cnt == 0 {
                cnt++
            }
            result = CInt(cnt)
            
        } else {
            result = 1
        }
        
        sqlite3_finalize(stmt)
        return result
    }
    
    private func query(stmt: COpaquePointer, sql: String)->[SQLRow] {
        
        var rows = [SQLRow]()
        var fetchColumnInfo = true
        var columnCount:CInt = 0
        var columnNames = [String]()
        var columnTypes = [CInt]()
        var result = sqlite3_step(stmt)
        while result == SQLITE_ROW {
            
            if fetchColumnInfo {
                columnCount = sqlite3_column_count(stmt)
                for index in 0..<columnCount {
                    
                    let name = sqlite3_column_name(stmt, index)
                    columnNames.append(String.fromCString(name)!)
                    columnTypes.append(self.getColumnType(index, stmt: stmt))
                }
                
                fetchColumnInfo = false
            }
            
            var row = SQLRow()
            for index in 0..<columnCount {
                let key = columnNames[Int(index)]
                let type = columnTypes[Int(index)]
                if let val:AnyObject = self.getColumnValue(index, type: type, stmt: stmt) {
                    
                    let col = SQLColumn(value: val, type: type)
                    row[key] = col
                    
                }
            }
            rows.append(row)
            result = sqlite3_step(stmt)
        }
        
        sqlite3_finalize(stmt)
        
        return rows
        
    }
    
    private func getColumnType(index: CInt, stmt: COpaquePointer)->CInt {
        var type:CInt = 0
        
        let blobTypes = ["BINARY", "BLOB", "VARBINARY"]
        let charTypes = ["CHAR", "CHARACTER", "CLOB", "NATIONAL VARYING CHARACTER", "NATIVE CHARACTER", "NCHAR", "NVARCHAR", "TEXT", "VARCHAR", "VARIANT", "VARYING CHARACTER"]
        let intTypes  = ["BIGINT", "BIT", "BOOL", "BOOLEAN", "INT", "INT2", "INT8", "INTEGER", "MEDIUMINT", "SMALLINT", "TINYINT"]
        let nullTypes = ["NULL"]
        let realTypes = ["DECIMAL", "DOUBLE", "DOUBLE PRECISION", "FLOAT", "NUMERIC", "REAL"]
        
        let buf = sqlite3_column_decltype(stmt, index)
        
        if buf != nil {
            
            var tmp = String.fromCString(buf)!.uppercaseString
            
            let pos = tmp.positionOf("(")
            if pos > 0 {
                tmp = tmp.subStringTo(pos)
            }
            
            if contains(intTypes, tmp) {
                return SQLITE_INTEGER
            }
            if contains(realTypes, tmp) {
                return SQLITE_FLOAT
            }
            if contains(charTypes, tmp) {
                return SQLITE_TEXT
            }
            if contains(blobTypes, tmp) {
                return SQLITE_BLOB
            }
            if contains(nullTypes, tmp) {
                return SQLITE_NULL
            }
            
            return SQLITE_TEXT
            
        } else {
            
            type = sqlite3_column_type(stmt, index)
            
        }
        return type
        
    }
    
    private func getColumnValue(index: CInt, type: CInt, stmt: COpaquePointer)->AnyObject? {
        
        if type == SQLITE_INTEGER {
            let val = sqlite3_column_int(stmt, index)
            return Int(val)
        }
        
        if type == SQLITE_FLOAT {
            let val = sqlite3_column_double(stmt, index)
            return Double(val)
        }
        
        if type == SQLITE_BLOB {
            let data = sqlite3_column_blob(stmt, index)
            let size = sqlite3_column_bytes(stmt, index)
            let val = NSData(bytes:data, length: Int(size))
            return val
        }
        
        if type == SQLITE_NULL {
            return nil
        }
        
        let buf = UnsafePointer<Int8>(sqlite3_column_text(stmt, index))
        let val = String.fromCString(buf)
        return val
    }
    
    private func jungle(flag: CInt) ->Bool {
        return flag == 0 ? false : true
    }
    
}

class SQLColumn {
    
    var value:AnyObject? = nil
    var type:CInt = -1
    
    init(value:AnyObject, type:CInt) {
        self.value = value
        self.type = type
    }
    
    func asString()->String {
        switch (type) {
        case SQLITE_INTEGER, SQLITE_FLOAT:
            return "\(value)"
            
        case SQLITE_TEXT:
            return value as! String
            
        case SQLITE_BLOB:
            if let str = NSString(data:value as! NSData, encoding:NSUTF8StringEncoding) {
                return str as String
            } else {
                return ""
            }
            
        case SQLITE_NULL:
            return ""
            
        default:
            return ""
        }
    }
    
    func asInt()->Int {
        
        switch (type) {
        case SQLITE_INTEGER, SQLITE_FLOAT:
            return value as! Int
            
        case SQLITE_TEXT:
            let str = value as! NSString
            return str.integerValue
            
        case SQLITE_BLOB:
            if let str = NSString(data:value as! NSData, encoding:NSUTF8StringEncoding) {
                return str.integerValue
            } else {
                return 0
            }
            
        case SQLITE_NULL:
            return 0
            
        default:
            return 0
        }
    }
    
    func asDouble()->Double {
        switch (type) {
        case SQLITE_INTEGER, SQLITE_FLOAT:
            return value as! Double
            
        case SQLITE_TEXT:
            let str = value as! NSString
            return str.doubleValue
            
        case SQLITE_BLOB:
            if let str = NSString(data:value as! NSData, encoding:NSUTF8StringEncoding) {
                return str.doubleValue
            } else {
                return 0.0
            }
            
        case SQLITE_NULL:
            return 0.0
            
        default:
            return 0.0
        }
    }
    
    func asData()->NSData? {
        switch (type) {
        case SQLITE_INTEGER, SQLITE_FLOAT:
            let str = "\(value)" as NSString
            return str.dataUsingEncoding(NSUTF8StringEncoding)
            
        case SQLITE_TEXT:
            let str = value as! NSString
            return str.dataUsingEncoding(NSUTF8StringEncoding)
            
        case SQLITE_BLOB:
            return value as? NSData
            
        case SQLITE_NULL:
            return nil
            
        default:
            return nil
        }
    }
    
    func asDate()->NSDate? {
        switch (type) {
        case SQLITE_INTEGER, SQLITE_FLOAT:
            let tm = value as! Double
            if tm == 0 {
                return nil
            }
            return NSDate(timeIntervalSince1970:tm/1000)
            
        case SQLITE_TEXT:
            let tm = value as! NSString
            
            return NSDate(timeIntervalSince1970:tm.doubleValue/1000)
            /*
            let fmt = NSDateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return fmt.dateFromString(value as String)
            
        case SQLITE_BLOB:
            if let str = NSString(data:value as NSData, encoding:NSUTF8StringEncoding) {
                let fmt = NSDateFormatter()
                fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return fmt.dateFromString(str)
            } else {
                return nil
            }*/
            
        case SQLITE_NULL:
            return nil
            
        default:
            return nil
        }
    }
}

class SQLRow {
    var data = Dictionary<String, SQLColumn>()
    
    subscript(key: String) -> SQLColumn? {
        get {
            return data[key]
        }
        
        set(newVal) {
            data[key] = newVal
        }
    }
}
