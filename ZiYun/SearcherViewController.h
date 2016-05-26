//
//  SearcherViewController.h
//  cloud
//
//  Created by apple on 4/2/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface SearcherViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *searchView;
@property (retain, nonatomic) IBOutlet UIView *buttonView;

@property(retain) NSMutableArray *recentSearches;
@property(strong) MBProgressHUD *hud;

- (IBAction)search:(id)sender;
- (IBAction)clean:(id)sender;

@end
