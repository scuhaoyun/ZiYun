//
//  InformationViewController.h
//  cloud
//
//  Created by apple on 4/15/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
 
}

//@property (retain, nonatomic) IBOutlet UITableView *informationView;
@property(strong) NSMutableDictionary *dict;
@property(strong) NSMutableArray *articleArray;
@property(strong,nonatomic) NSString *dateString;;
@property(strong,nonatomic) NSString *ikeyword;
@property(strong,nonatomic) NSString *ihy;
@property(strong,nonatomic) NSString *itime;
@property(nonatomic) BOOL isTheme;

@end
