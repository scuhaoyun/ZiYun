//
//  DB.m
//  cloud
//
//  Created by apple on 4/2/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "DB.h"
#import "SQLiteHelper.h"
#import "sqlite3.h"

@implementation DB
static sqlite3 *kdatabase;
static SQLiteHelper *kSqlite;

+(id)singleton{
    return [[self alloc]init];
}

-(id)init{
    if ((self=[super init])) {
        if (kdatabase==nil) {
            if (kSqlite==nil) {
                kSqlite=[[SQLiteHelper alloc]init];
            }
            [kSqlite initDatabaseConnection];
            kdatabase=[kSqlite database];
        }
    }
    return self;
}

+(void)finalize{
    [kSqlite closeDatabase];
}

+(NSMutableArray *)fetchRecentSearches{
    sqlite3_stmt *state;
    NSMutableArray *searches=[NSMutableArray array];
    const char *sql="SELECT searchtext FROM recentSearch ORDER BY updatetime DESC";
    if (sqlite3_prepare_v2(kdatabase, sql, -1, &state, NULL)!=SQLITE_OK) {
        NSAssert1(0, @"Error:failed to preare statement with message '%s'.", sqlite3_errmsg(kdatabase));
    }
    while (sqlite3_step(state)==SQLITE_ROW) {
        NSString *search=[NSString stringWithUTF8String:(char*)sqlite3_column_text(state, 0)];
        [searches addObject:search];
    }
    return searches;
}

+(void)addRecentSearche:(NSString *)search{
    sqlite3_stmt *state;
    NSDate *date=[NSDate date];
    
    NSString *querySQL=[NSString stringWithFormat:@"SELECT COUNT(*) FROM recentSearch WHERE searchtext=\"%@\" ",search];
    const char *sql=[querySQL UTF8String];
    if (sqlite3_prepare_v2(kdatabase, sql, -1, &state, NULL)!=SQLITE_OK) {
        NSAssert1(0, @"Error:failed to preare statement with message '%s'.", sqlite3_errmsg(kdatabase));
    }
    if (sqlite3_step(state)==SQLITE_ROW) {
        int count=sqlite3_column_int(state, 0);
        sqlite3_stmt *state2;
        if (count==0) {
            NSString *querySQL2=[NSString stringWithFormat:@"INSERT INTO recentSearch (searchtext,updatetime) values(\"%@\",\"%@\")",search,date];
            const char *sql2=[querySQL2 UTF8String];
            if (sqlite3_prepare_v2(kdatabase, sql2,-1, &state2, NULL)!=SQLITE_OK) {
                NSAssert1(0, @"Error:failed to preare statement with message '%s'.", sqlite3_errmsg(kdatabase));
            }
            NSLog(@"%d",sqlite3_step(state2));
        }
        else{
            NSString *querySQL3=[NSString stringWithFormat:@"UPDATE recentSearch set updatetime=\"%@\" WHERE searchtext=\"%@\" ",date,search];
            const char *sql3=[querySQL3 UTF8String];
            if (sqlite3_prepare_v2(kdatabase, sql3,-1, &state2, NULL)!=SQLITE_OK) {
                NSAssert1(0, @"Error:failed to preare statement with message '%s'.", sqlite3_errmsg(kdatabase));
            }
            NSLog(@"%d",sqlite3_step(state2));
        }
    }
    

    
     
}

+(void)clearRecentSearches{
    sqlite3_stmt *state;
    const char *sql="DELETE FROM recentSearch";
    if (sqlite3_prepare_v2(kdatabase, sql, -1, &state, NULL)!=SQLITE_OK) {
        NSAssert1(0, @"Error:failed to preare statement with message '%s'.", sqlite3_errmsg(kdatabase));
    }
    if (sqlite3_step(state)==SQLITE_DONE) {
        sqlite3_stmt *state2;
        const char *sql2="UPDATE sqlite_sequence set seq=0 WHERE name='recentSearch' ";
        if (sqlite3_prepare_v2(kdatabase, sql2, -1, &state2, NULL)!=SQLITE_OK) {
            NSAssert1(0, @"Error:failed to preare statement with message '%s'.", sqlite3_errmsg(kdatabase));
        }
        NSLog(@"%d",sqlite3_step(state2));
    }
}

+(void)updateRecentSearch:(NSString *)search{
    sqlite3_stmt *state;
    NSDate *date=[NSDate date];
    NSString *querySQL=[NSString stringWithFormat:@"UPDATE recentSearch set updatetime=\"%@\" WHERE searchtext=\"%@\" ",date,search];
    const char *sql=[querySQL UTF8String];
    if (sqlite3_prepare_v2(kdatabase, sql,-1, &state, NULL)!=SQLITE_OK) {
        NSAssert1(0, @"Error:failed to preare statement with message '%s'.", sqlite3_errmsg(kdatabase));
    }
    NSLog(@"%d",sqlite3_step(state));
}

@end
