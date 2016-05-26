//
//  DetailContentViewController.h
//  cloud
//
//  Created by apple on 4/16/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailContentViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *detailTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailSource;
@property (strong, nonatomic) IBOutlet UILabel *detailTime;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScroll;
@property(strong) NSDictionary *dict;
@property(nonatomic) NSUInteger contentLength;
@property(nonatomic) NSUInteger imageHeight;
@property(nonatomic) BOOL isStore;
@end
