//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 方彬 on 11/29/13.
//  Copyright (c) 2013 Alipay.com. All rights reserved.
//

#import "APViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GBK2UTF8.h"
#import "ZiYun-Swift.h"
#import "APAuthV2Info.h"

@implementation Product


@end

@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    //[self generateData];
}



- (void)payInfo {
    
    if ([_PriceTextField.text  isEqual: @""]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"金额不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        //[alter release];
    }
    
    NSString *appkey=@"test";
    NSString *apppwd=@"123456";
    NSString *name= [Common getUsername];
    NSString *uid=[Common getUid];
    NSString *money=_PriceTextField.text;
    NSString *pt=@"ios";
    
    NSURL *url = [NSURL URLWithString:@"http://222.143.31.169:8080/Sign.do"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=5.0;
    request.HTTPMethod=@"POST";
    
    NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&money=%@&pt=%@",appkey,apppwd,name,uid,money,pt];
    
    param=[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSDictionary *dict=[GBK2UTF8 retrunNSDictionary:data];
            NSString *error=dict[@"error"];
            if (error) {
                NSLog(@"Error:%@",error);
            }
            else{
                NSString *success=[dict objectForKey:@"status"];
                NSString *Info=[dict objectForKey:@"payInfo"];
                NSLog(@"jwiehfiuehu:%@",Info);
                
                
                NSLog(@"Success:%@",success);
                
                
                
                NSString *appScheme = @"alisdkdemo";
                
                
                NSString *orderSpec = Info;
                NSLog(@"orderSpec = %@",orderSpec);
                
                
                
                
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = nil;
                
                orderString = orderSpec;
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
                
            }
            
        }
        else{
            NSLog(@"请检查网络！");
        }
    }];
    
    
}



- (IBAction)PaySubmit:(id)sender {
    
    [self payInfo];
}



@end
