//
//  MyThemeViewController.m
//  cloud
//
//  Created by apple on 4/9/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "MyThemeViewController.h"
#import "MyThemeCell.h"
#import "MBProgressHUD.h"
#import "InformationViewController.h"
#import "GBK2UTF8.h"
#import "ZiYun-Swift.h"
#import "ThemeTitleCell.h"
@interface MyThemeViewController ()
@property (strong,nonatomic)NSMutableArray *openArray;
@end

@implementation MyThemeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSDictionary *dict = [LoginViewController getSubject];
//        NSArray *array=[[dict objectForKey:@"sub"]allKeys];
//        NSString *str=[array objectAtIndex:0];
//        self.myTheme=[[dict objectForKey:@"sub"]objectForKey:str];
//        self.professionTheme=[[dict objectForKey:@"sub"]objectForKey:@"行业专题"];
        //NSLog(dict);
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //new
    self.dateString=@"";
    [self addRefreshViewControl];
    self.openArray=[NSMutableArray arrayWithObjects:@"0",@"0", nil];
    self.navigationItem.leftBarButtonItem = self.myleftItem;
    self.navigationItem.rightBarButtonItem = self.myrightItem;
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBarBackImage.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self setExtraCellLineHidden:self.tableView];
    
};
-(void)viewDidAppear:(BOOL)animated{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = false;
}
//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 1)];
    v.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableFooterView:v];
}

//new
-(void)addRefreshViewControl{
    self.refreshControl=[[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"下拉刷新 上次更新时间:%@",self.dateString]];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    self.dateString=[formatter stringFromDate:[NSDate date]];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}

//new
-(void)RefreshViewControlEventValueChanged{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中..."];
    
    NSString *appkey=@"test";
    NSString *apppwd=@"123456";
    NSString *name= self.username;
    NSString *uid= self.uid;
    
    NSURL *url=[NSURL URLWithString:@"http://222.143.31.169:8080/RefreshSub.do"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@",appkey,apppwd,name,uid];
    
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
                NSArray *array=[[newDict objectForKey:@"sub"]allKeys];
                NSString *str=[array objectAtIndex:0];
                self.myTheme=[[newDict objectForKey:@"sub"]objectForKey:str];
                self.professionTheme=[[newDict objectForKey:@"sub"]objectForKey:@"行业专题"];
                NSLog(@"%@",self.myTheme);
                [self.tableView reloadData];
            }
        }
        else{
            NSLog(@"请检查网络！");
        }
    }];
    
    
    [self performSelector:@selector(handleData) withObject:nil afterDelay:1];
}

//new
- (void) handleData{
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"下拉刷新 上次更新时间:%@",self.dateString]];
}

//new
- (IBAction)pushSwitcher:(id)sender{
    
    UISwitch *switcher=(UISwitch*)sender;
    switcher.userInteractionEnabled=NO;
    
    NSString *appkey=@"test";
    NSString *apppwd=@"123456";
    NSString *name= self.username;
    NSString *uid= self.uid;
    NSString *subid=@"12";
    NSInteger type=switcher.isOn;
    
    NSURL *url=[NSURL URLWithString:@"http://222.143.31.169:8080/SubPush.do"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=5.0f;
    request.HTTPMethod=@"POST";
    
    NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&subid=%@&type=%ld",appkey,apppwd,name,uid,subid,type];
    param=[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    
    NSOperationQueue *quene=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:quene completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict=[GBK2UTF8 retrunNSDictionary:data];
            NSString *status=[dict objectForKey:@"status"];
            NSLog(@"%@",status);
        }
        else{
            NSLog(@"网络繁忙!");
            switcher.on=!switcher.isOn;
        }
    }];
    switcher.userInteractionEnabled=YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_tableView release];
    //[super dealloc];
}

#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.myTheme count] == 0 && [self.professionTheme count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    return [self.myTheme count]+[self.professionTheme count]+2;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath row]==0||[indexPath row]==[[self.myTheme allKeys] count]+1) {
        static NSString *TitleCellIdentifier=@"ThemeTitleCell";
        ThemeTitleCell *cell=[tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:TitleCellIdentifier owner:self options:nil]objectAtIndex:0];
        }
        if ([indexPath row]==0) {
            cell.title.text=@"我的专题";
            if ([[self.openArray objectAtIndex:kMyTheme] intValue]){
                cell.arrow.image=[UIImage imageNamed:@"arrow_down"];
            }
        }
        else{
            cell.title.text=@"行业专题";
            if ([[self.openArray objectAtIndex:kProfessionTheme] intValue]){
                cell.arrow.image=[UIImage imageNamed:@"arrow_down"];
            }
        }
        return cell;
    }
    else if ([indexPath row]<=[[self.myTheme allKeys] count]){
        NSArray *array=[self.myTheme allKeys];
        NSDictionary *dict=[self.myTheme objectForKey:[array objectAtIndex:[indexPath row]-1]];
        
        static NSString *MyThemeCellIdentifier=@"MyThemeCellIdentifier";
        MyThemeCell *cell=[tableView dequeueReusableCellWithIdentifier:MyThemeCellIdentifier];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"MyThemeCell" owner:self options:nil]objectAtIndex:0];
        }
        cell.textLabel.text=[dict objectForKey:@"name"];
        
        [cell.pushSwitch setOnImage:[UIImage imageNamed:@"off_btn.png"]];
        [cell.pushSwitch setOffImage:[UIImage imageNamed:@"on_btn.png"]];
        NSInteger group=[[dict objectForKey:@"group"] intValue];
        
        if (group==3) {
            cell.pushSwitch.hidden=YES;
        }
        else{
            cell.pushSwitch.on=group;
        }
        [cell.pushSwitch addTarget:self action:@selector(pushSwitcher:) forControlEvents:UIControlEventValueChanged];
        
        if (![[self.openArray objectAtIndex:kMyTheme] intValue]) {
            cell.hidden=YES;
        }
        return cell;
        
    }
    else{
        NSArray *array=[self.professionTheme allKeys];
        NSDictionary *dict=[self.professionTheme objectForKey:[array objectAtIndex:[indexPath row]-2-[[self.myTheme allKeys] count]]];
        
        static NSString *MyThemeCellIdentifier=@"MyThemeCellIdentifier";
        MyThemeCell *cell=[tableView dequeueReusableCellWithIdentifier:MyThemeCellIdentifier];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"MyThemeCell" owner:self options:nil]objectAtIndex:0];
        }
        cell.textLabel.text=[dict objectForKey:@"name"];
        
        [cell.pushSwitch setOnImage:[UIImage imageNamed:@"off_btn.png"]];
        [cell.pushSwitch setOffImage:[UIImage imageNamed:@"on_btn.png"]];
        NSInteger group=[[dict objectForKey:@"group"] intValue];
        
        if (group==3) {
            cell.pushSwitch.hidden=YES;
        }
        else{
            cell.pushSwitch.on=group;
        }
        [cell.pushSwitch addTarget:self action:@selector(pushSwitcher:) forControlEvents:UIControlEventValueChanged];
        if (![[self.openArray objectAtIndex:kProfessionTheme] intValue]) {
            cell.hidden=YES;
        }
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath row]==0){
        if ([[self.openArray objectAtIndex:kMyTheme] intValue]) {
            [self.openArray replaceObjectAtIndex:kMyTheme withObject:@"0"];
            for (int i=0; i<[[self.myTheme allKeys]count]; i++) {
                MyThemeCell *cell=(MyThemeCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                cell.hidden=YES;
            }
        }
        else{
            [self.openArray replaceObjectAtIndex:kMyTheme withObject:@"1"];
            for (int i=0; i<[[self.myTheme allKeys]count]; i++) {
                MyThemeCell *cell=(MyThemeCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                cell.hidden=NO;
            }
        }
        [tableView reloadData];
    }
    else if ([indexPath row]==[[self.myTheme allKeys] count]+1){
        if ([[self.openArray objectAtIndex:kProfessionTheme] intValue]) {
            [self.openArray replaceObjectAtIndex:kProfessionTheme withObject:@"0"];
            for (int i=0; i<[[self.professionTheme allKeys]count]; i++) {
                MyThemeCell *cell=(MyThemeCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                cell.hidden=YES;
            }
        }
        else{
            [self.openArray replaceObjectAtIndex:kProfessionTheme withObject:@"1"];
            for (int i=0; i<[[self.professionTheme allKeys]count]; i++) {
                MyThemeCell *cell=(MyThemeCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+2+[[self.myTheme allKeys] count] inSection:0]];
                cell.hidden=NO;
            }
        }
        [tableView reloadData];
    }
    else{
        NSArray *array=[NSArray array];
        NSDictionary *pDict=[NSDictionary dictionary];
        
        if ([indexPath row]<=[[self.myTheme allKeys] count]) {
            array=[self.myTheme allKeys];
            pDict=[self.myTheme objectForKey:[array objectAtIndex:[indexPath row]-1]];
        }
        else{
            array=[self.professionTheme allKeys];
            pDict=[self.professionTheme objectForKey:[array objectAtIndex:[indexPath row]-2-[[self.myTheme allKeys] count]]];
        }
        
        InformationViewController *informationViewController=[[InformationViewController alloc]initWithNibName:@"InformationViewController" bundle:NULL];
        
        NSString *appkey=@"test";
        NSString *apppwd=@"123456";
        NSString *name= self.username;
        NSString *uid= self.uid;
        NSString *keyword=[pDict objectForKey:@"keywod"];
        NSString *hy=[pDict objectForKey:@"hy"];
        NSString *time=[pDict objectForKey:@"time"];
        
        //显示进度条
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.labelText=@"正在搜索...";
        hud.dimBackground=YES;
        
        NSURL *url=[NSURL URLWithString:@"http://222.143.31.169:8080/Search.do"];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval=10.0;
        request.HTTPMethod=@"POST";
        NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&keyword=%@&hy=%@&time=%@",appkey,apppwd,name,uid,keyword,hy,time];
        if (hy.length==0) {
            param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&keyword=%@&time=%@",appkey,apppwd,name,uid,keyword,time];
        }
        param=[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
        
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            //隐藏进度条
            [hud hide:YES];
            if (data) {
                NSDictionary *dict=[GBK2UTF8 retrunNSDictionary:data];
                NSString *error=dict[@"error"];
                if (error) {
                    NSLog(@"Error:%@",error);
                }
                else{
                    NSString *success=[dict objectForKey:@"status"];
                    NSLog(@"Success:%@",success);
                    informationViewController.ikeyword=keyword;
                    informationViewController.ihy=hy;
                    informationViewController.itime=time;
                    informationViewController.dict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    informationViewController.isTheme=YES;
                    informationViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:informationViewController animated:YES];
                }
            }
            else{
                NSLog(@"请检查网络！");
            }
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row]==0||[indexPath row]==[[self.myTheme allKeys] count]+1) {
        return 40;
    }
    else if ([indexPath row]<=[[self.myTheme allKeys] count]){
        if (![[self.openArray objectAtIndex:kMyTheme] intValue]) {
            return 0;
        }
        return 40;
    }
    else{
        if (![[self.openArray objectAtIndex:kProfessionTheme] intValue]) {
            return 0;
        }
        return 40;
    }
}

@end
