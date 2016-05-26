//
//  MyStoreViewController.m
//  cloud
//
//  Created by apple on 4/16/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "MyStoreViewController.h"
#import "DetailContentViewController.h"
#import "GBK2UTF8.h"
#import "ZiYun-Swift.h"

@interface MyStoreViewController ()

@end

@implementation MyStoreViewController
@synthesize array;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"收藏";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.array = [NSMutableArray arrayWithArray:[self.dict allKeys]];
    self.dateString=@"";
    [self addRefreshViewControl];
    [self setExtraCellLineHidden:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 1)];
    v.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableFooterView:v];
}

-(void)addRefreshViewControl{
    self.refreshControl=[[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"下拉刷新 上次更新时间:%@",self.dateString]];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    self.dateString=[formatter stringFromDate:[NSDate date]];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)RefreshViewControlEventValueChanged{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中..."];
    
    NSString *appkey=@"test";
    NSString *apppwd=@"123456";
    NSString *name= [Common getUsername];
    NSString *uid=[Common getUid];
    NSString *fid=@"12";
    
    NSURL *url=[NSURL URLWithString:@"http://222.143.31.169:8080/Favorite.do"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=5.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&fid=%@",appkey,apppwd,name,uid,fid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];

    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSDictionary *newDict=[GBK2UTF8 retrunNSDictionary:data];
            
            NSString *error=newDict[@"error"];
            if (error) {
                NSLog(@"Error:%@",error);
            }
            else{
                NSString *success=[newDict objectForKey:@"status"];
                NSLog(@"Success:%@",success);
                self.dict=[[[NSDictionary dictionaryWithDictionary:newDict]objectForKey:@"favoritearticle"]objectForKey:@"我的收藏"];
                self.array=[NSMutableArray arrayWithArray:[self.dict allKeys]];
                
                [self.tableView reloadData];
            }
        }
        else{
            NSLog(@"请检查网络！");
        }
    }];
    
    
    [self performSelector:@selector(handleData) withObject:nil afterDelay:1];
}

- (void) handleData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"下拉刷新 上次更新时间:%@",self.dateString]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.dict count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    return [self.dict count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *sid=[array objectAtIndex:[indexPath row]];
     
    cell.textLabel.text=[[_dict objectForKey:sid]objectForKey:@"title"];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0];
    cell.textLabel.numberOfLines=2;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailContentViewController *viewController=[[DetailContentViewController alloc] initWithNibName:@"DetailContentViewController" bundle:nil];
    viewController.dict=[_dict objectForKey:[self.array objectAtIndex:[indexPath row]]];
    viewController.isStore=YES;
    [self.navigationController pushViewController:viewController animated:YES];

}

@end
