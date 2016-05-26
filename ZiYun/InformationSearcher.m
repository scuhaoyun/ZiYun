//
//  InformationSearcher.m
//  cloud
//
//  Created by apple on 4/2/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "InformationSearcher.h"

@implementation InformationSearcher

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tintColor=[UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews{
    UITextField *searchField;
    NSUInteger numViews=[self.subviews count];
    for (int i=0; i<numViews; i++) {
        if ([[self.subviews objectAtIndex:i]isKindOfClass:[UITextField class]]) {
            searchField=[self.subviews objectAtIndex:i];
        }
    }
    if (!(searchField==nil)) {
        searchField.placeholder=@"事件 关键词";
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setBackgroundColor:[UIColor whiteColor]];
        
        UIImage *image=[UIImage imageNamed:@"sView.png"];
//        UIImageView *iView=[[UIImageView alloc] initWithImage:image];
//        [iView setFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
//        searchField.leftView=iView;
        [searchField.leftView setHidden:YES];
        [searchField setBackground:image];
    }
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
