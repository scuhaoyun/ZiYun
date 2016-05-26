//
//  SearcherViewController.m
//  cloud
//
//  Created by apple on 4/2/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "SearcherViewController.h"
#import "DB.h"
#import "MBProgressHUD.h"
#import "GBK2UTF8.h"
#import "InformationViewController.h"
#import "ZiYun-Swift.h"


@interface SearcherViewController ()

@end

@implementation SearcherViewController



@synthesize searchView,buttonView;
@synthesize recentSearches;
@synthesize hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"情报搜索";
    //self.navigationItem.backBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil]autorelease];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self reloadButtonView];
}

- (IBAction)buttonClick:(id)sender{
    NSString *search=((UIButton *)sender).titleLabel.text;
    searchView.text=search;
    [DB updateRecentSearch:search];
    [self searchInformation:search];
    [self reloadButtonView];
}

- (void)reloadButtonView{
    
    if (recentSearches!=nil) {
        [recentSearches removeAllObjects];
    }
    self.recentSearches=[DB fetchRecentSearches];
       
    [buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for(NSString *search in recentSearches){
        int seq=[recentSearches indexOfObject:search];
        int column=seq/3;
        int row=seq%3;
        
        CGFloat tmpWidth = ([[UIScreen mainScreen] bounds].size.width-25)/3;
        
        CGFloat length = [search sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].width;
        //int length = search.length*12 < (tmpWidth - 40) ? search.length:(tmpWidth/12);
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
       
        button.frame=CGRectMake(row*tmpWidth,column*35,length < (tmpWidth-30)? (length+20):(tmpWidth-5), 25);
        printf("%f",length);
        button.userInteractionEnabled=YES;
        button.hidden=NO;
        button.titleLabel.font=[UIFont systemFontOfSize:13];
//        button.titleLabel.backgroundColor=[UIColor blackColor];
        [button setTitle:search forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = true;
        button.layer.borderWidth = 3;
        button.layer.borderColor = (__bridge CGColorRef)([UIColor redColor]);
        button.backgroundColor = [UIColor colorWithRed:0.325f green:0.325f blue:0.325f alpha:1.00f];
      
       
        [buttonView addSubview:button];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //[searchView release];
    //[buttonView release];
    //[super dealloc];
}
- (IBAction)search:(id)sender {
    if (searchView.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"情报搜索" message:@"亲！关键词不能为空" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [DB addRecentSearche:searchView.text];
    [self searchInformation:searchView.text];
    
    [self reloadButtonView];
}

-(void)searchInformation:(NSString *)search{
    
    InformationViewController *informationViewController=[[InformationViewController alloc]initWithNibName:@"InformationViewController" bundle:NULL];
    NSString *appkey=@"test";
    NSString *apppwd=@"123456";
    NSString *name= [Common getUsername];
    NSString *uid=[Common getUid];
    NSString *keyword=search;
    
    //显示进度条
    hud=[MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    hud.labelText=@"正在搜索...";
    hud.dimBackground=YES;
    
    NSURL *url=[NSURL URLWithString:@"http://222.143.31.169:8080/Search.do"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval=5.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&keyword=%@",appkey,apppwd,name,uid,keyword];
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
                informationViewController.ikeyword=search;
                informationViewController.dict=[NSMutableDictionary dictionaryWithDictionary:dict];
                informationViewController.isTheme=NO;
                informationViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:informationViewController animated:YES];
            }
        }
        else{
            NSLog(@"请检查网络！");
        }
    }];
    
   
}

- (IBAction)clean:(id)sender {
    if (recentSearches!=nil) {
        [recentSearches removeAllObjects];
    }
    [buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [DB clearRecentSearches];
}
@end
