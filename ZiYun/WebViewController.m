//
//  WebViewController.m
//  cloud
//
//  Created by apple on 4/16/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView,url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
     self.tabBarController.tabBar.hidden = true;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"网站原页";
    self.tabBarController.tabBar.hidden = true;
    NSURL *webUrl=[NSURL URLWithString:url];
    NSURLRequest *request=[NSURLRequest requestWithURL:webUrl];
    [webView loadRequest:request];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [webView release];
//    [super dealloc];
}
@end
