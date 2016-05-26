//
//  MyThemeViewController.h
//  cloud
//
//  Created by apple on 4/9/15.
//  Copyright (c) 2015 scu. All rights reserved.
//
#import <UIKit/UIKit.h>
#define kMyTheme 0
#define kProfessionTheme 1

@interface MyThemeViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

//mod
@property (strong) NSMutableDictionary *myTheme;
@property (strong) NSMutableDictionary *professionTheme;
@property (strong) NSString *username;
@property (strong) NSString *uid;
@property (strong) UIBarButtonItem *myleftItem;
@property (strong) UIBarButtonItem *myrightItem;
//new
@property (strong) NSString *dateString;

@end