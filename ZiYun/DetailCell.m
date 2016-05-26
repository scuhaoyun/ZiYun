//
//  DetailCell.m
//  cloud
//
//  Created by apple on 4/16/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

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
//    [_type release];
//    [_emotion release];
//    [_summary release];
//    [_time release];
//    [_resource release];
//    [super dealloc];
}

@end
