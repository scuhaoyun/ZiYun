//
//  SQLiteHelper.h
//  cloud
//
//  Created by apple on 4/2/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface SQLiteHelper : NSObject
@property(nonatomic) sqlite3 *database;

-(NSString *)sqliteDBFilePath;
-(void)initDatabaseConnection;
-(void)closeDatabase;
@end
