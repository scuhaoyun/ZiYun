//
//  InformationViewController.m
//  cloud
//
//  Created by apple on 4/15/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "InformationViewController.h"
#import "TitleCell.h"
#import "DetailCell.h"
#import "DetailContentViewController.h"
#import "GBK2UTF8.h"
#import "ZiYun-Swift.h"

@interface InformationViewController ()
@property(strong)NSMutableArray *hideArray;
@end

@implementation InformationViewController
@synthesize dict,articleArray;
@synthesize isTheme;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (isTheme) {
        self.navigationItem.title=@"专题";
    }
    else{
        self.navigationItem.title=@"文章列表";
    }
    
    //self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil]autorelease];
    self.dateString=@"";
    [self addRefreshViewControl];
    [self refresh];
    [self setExtraCellLineHidden:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = true;
}
//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 1)];
    v.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableFooterView:v];
}

-(void)refresh{
    self.articleArray=[self.dict objectForKey:@"article"];
    self.hideArray=[NSMutableArray arrayWithCapacity:[self.articleArray count]];
    for (int i=0; i<[self.articleArray count]; i++) {
        NSInteger isHide=1;
        [self.hideArray addObject:[NSString stringWithFormat:@"%ld",(long)isHide]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_informationView release];
    //[super dealloc];
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
    NSString *keyword=self.ikeyword;
    NSString *hy=self.ihy;
    NSString *time=self.itime;
    
    NSURL *url=[NSURL URLWithString:@"http://222.143.31.169:8080/Search.do"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&keyword=%@&hy=%@&time=%@",appkey,apppwd,name,uid,keyword,hy,time];
    if (!isTheme) {
        param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&keyword=%@",appkey,apppwd,name,uid,keyword];
    }
    
    if (hy.length==0) {
        param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&keyword=%@&time=%@",appkey,apppwd,name,uid,keyword,time];
    }
    param=[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                self.dict=[NSDictionary dictionaryWithDictionary:newDict];
                [self refresh];
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

#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.articleArray count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    return [self.articleArray count]*2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int type=[indexPath row]%2;
    int itemRow=[indexPath row]/2;
    NSDictionary *articleDict=[self.articleArray objectAtIndex:itemRow];
    
    if (!type) {
        static NSString *CellIdentifier=@"TitleCell";
        TitleCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
            //            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.title.text=[articleDict objectForKey:@"title"];
        cell.time.text=[articleDict objectForKey:@"pubdate"];
        if (![[self.hideArray objectAtIndex:itemRow] intValue]){
            cell.arrow.image=[UIImage imageNamed:@"arrow_down"];
        }
        
        return cell;
    }
    else{
        static NSString *DetailCellIdentifier=@"DetailCell";
        DetailCell *cell=[tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:DetailCellIdentifier owner:self options:nil]objectAtIndex:0];
        }
        
        cell.type.text=[articleDict objectForKey:@"mediaType"];
        cell.emotion.text=[articleDict objectForKey:@"emotion"];
        
        NSString *abstruct=[articleDict objectForKey:@"summary"];
        cell.summary.text=abstruct;
        cell.time.text=[articleDict objectForKey:@"pubdate"];
        cell.resource.text=[articleDict objectForKey:@"domainSource"];
        if ([[self.hideArray objectAtIndex:itemRow] intValue]) {
            cell.hidden=YES;
        }
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int type=[indexPath row]%2;
    int itemRow=[indexPath row]/2;
    if (type) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailContentViewController *viewController=[[DetailContentViewController alloc]initWithNibName:@"DetailContentViewController" bundle:nil];
        viewController.dict=[self.articleArray objectAtIndex:[indexPath row]/2];
        viewController.isStore=NO;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        TitleCell *titleCell=(TitleCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
        DetailCell *cell=(DetailCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row]+1 inSection:0]];
        
        //        CGRect frame=cell.frame;
        
        if ([[self.hideArray objectAtIndex:itemRow] intValue]) {
            cell.hidden=NO;
            //            [cell setFrame:CGRectMake(frame.origin.x, frame.origin.y, SCREENWIDTH, 230)];
            [self.hideArray replaceObjectAtIndex:itemRow withObject:@"0"];
            titleCell.arrow.image=[UIImage imageNamed:@"arrow_down"];
            [tableView reloadData];
        }
        else{
            cell.hidden=YES;
            //            [cell setFrame:CGRectMake(frame.origin.x, frame.origin.y, SCREENWIDTH, 0)];
            [self.hideArray replaceObjectAtIndex:itemRow withObject:@"1"];
            titleCell.arrow.image=[UIImage imageNamed:@"arrow_right"];
            [tableView reloadData];
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int type=[indexPath row]%2;
    int itemRow=[indexPath row]/2;
    if (!type) {
        return 50;
    }
    else{
        if ([[self.hideArray objectAtIndex:itemRow] intValue]) {
            return 0;
        }
        else{
            return 230;
        }
    }
}
@end
