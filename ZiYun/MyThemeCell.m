//
//  MyThemeCell.m
//  cloud
//
//  Created by apple on 4/17/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "MyThemeCell.h"

@implementation MyThemeCell
@synthesize textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    [textLabel release];
//    [_pushSwitch release];
//    [super dealloc];
}
- (IBAction)switcher:(id)sender {
}
@end
