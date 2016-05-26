//
//  GBK2UTF8.h
//  DataTest
//
//  Created by ComputeNode0 on 4/10/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBK2UTF8 : NSObject
+ (NSData *)retrunNSData:(NSData *)data;
+ (NSDictionary *)retrunNSDictionary:(NSData *)data;
@end
