//
//  HelperViewController.h
//  cloud
//
//  Created by apple on 4/1/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface HelperViewController : UIViewController <UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *helperView;

@end