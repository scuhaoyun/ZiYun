//
//  MyThemeCell.h
//  cloud
//
//  Created by apple on 4/17/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyThemeCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
- (IBAction)switcher:(id)sender;
@property (retain, nonatomic) IBOutlet UISwitch *pushSwitch;

@end
