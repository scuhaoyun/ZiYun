//
//  SQLiteHelper.m
//  cloud
//
//  Created by apple on 4/2/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "SQLiteHelper.h"

@implementation SQLiteHelper
static NSString *kSQLiteFileName = @"cloud.sqlite";
@synthesize database;
-(NSString *)sqliteDBFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:kSQLiteFileName];
    NSLog(@"path = %@", path);
    
    return path;
}
-(void)execSQL:(NSString *)sql{
    char *error;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error)) {
        sqlite3_close(database);
        NSLog(@"数据库创建失败！");
    }
}
-(void)initDatabaseConnection{
    if (sqlite3_open([[self sqliteDBFilePath]UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    NSString *createTableSql=@"CREATE TABLE  IF NOT EXISTS recentSearch(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,searchtext TEXT NOT NULL,updatetime	INTEGER NOT NULL DEFAULT 0);";
    [self execSQL:createTableSql];
}
-(void)closeDatabase{
    if (sqlite3_close(database)!=SQLITE_OK) {
        NSAssert1(0, @"Error:failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}
@end
