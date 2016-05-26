//
//  DB.h
//  cloud
//
//  Created by apple on 4/2/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DB : NSObject

+(id)singleton;

+(void)finalize;

+(NSMutableArray *)fetchRecentSearches;

+(void)addRecentSearche:(NSString *)search;

+(void)clearRecentSearches;

+(void)updateRecentSearch:(NSString *)search;
@end
