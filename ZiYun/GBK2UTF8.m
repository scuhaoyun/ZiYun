//
//  GBK2UTF8.m
//  DataTest
//
//  Created by ComputeNode0 on 4/10/15.
//  Copyright (c) 2015 ComputeNode0. All rights reserved.
//

#import "GBK2UTF8.h"

@implementation GBK2UTF8
+ (NSData *)retrunNSData:(NSData *)data {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSDictionary data1 = [NSDictionary alloc]
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    NSData *utf8Data = [retStr dataUsingEncoding:NSUTF8StringEncoding];
    return utf8Data;
}
+ (NSDictionary *)retrunNSDictionary:(NSData *)data {
    //NSData * utf8Data = self.ret
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSDictionary data1 = [NSDictionary alloc]
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    NSData *utf8Data = [retStr dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}


@end

