//
//  WebViewController.h
//  cloud
//
//  Created by apple on 4/16/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *url;
@end
