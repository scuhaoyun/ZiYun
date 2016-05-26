//
//  TitleCell.m
//  cloud
//
//  Created by apple on 4/21/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

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
//    [_title release];
//    [_time release];
//    [_arrow release];
//    [super dealloc];
}
@end
