//
//  DetailContentViewController.m
//  cloud
//
//  Created by apple on 4/16/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "DetailContentViewController.h"
#import "WebViewController.h"
#import "MBProgressHUD.h"
#import "HelperViewController.h"
#import "ZiYun-Swift.h"

@interface DetailContentViewController ()
@property(nonatomic)CGFloat yFloat;
@property(nonatomic,strong) NSArray *urlArray;
@end

@implementation DetailContentViewController
@synthesize detailTitle,detailTime,detailSource,detailScroll;
@synthesize contentLength,imageHeight;
@synthesize dict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //    CGRect frame=scroll.frame;
    //    frame=CGRectMake(frame.origin.x, frame.origin.y, 320, length*15);
    
    if ([self.urlArray count]!=0) {
        for(NSString *url in self.urlArray){
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
            CGRect imageFrame=imageView.frame;
            if (imageFrame.size.width>300) {
                imageFrame=CGRectMake(5, self.yFloat,300, imageFrame.size.height/(imageFrame.size.width/300));
            }
            else{
                imageFrame=CGRectMake(5, self.yFloat,imageFrame.size.width, imageFrame.size.height);
            }
            imageView.frame=imageFrame;
            self.yFloat+=imageFrame.size.height;
            [detailScroll addSubview:imageView];
        }
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, self.yFloat+5, 200, 25);
    [button setTitle:@"查看原页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(viewWeb:) forControlEvents:UIControlEventTouchUpInside];
    [detailScroll addSubview:button];
    
    
    detailScroll.contentSize=CGSizeMake(320, self.yFloat+35);
    
    
}

-(IBAction)viewWeb:(id)sender{
    WebViewController *webViewController=[[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webViewController.url=[dict objectForKey:@"url"];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(NSArray *)imageString:(NSString *) string{
    NSMutableArray *stringArray=[NSMutableArray array];
    int length=0;
    int start=0;
    for (int i=0; i<string.length; i++) {
        NSString *s=[string substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@","]) {
            NSString *subString=[string substringWithRange:NSMakeRange(start, length)];
            [stringArray addObject:subString];
            start=i+1;
            length=0;
        }
        else{
            length+=1;
        }
    }
    NSString *subString=[string substringWithRange:NSMakeRange(start, length)];
    if (subString.length>0) {
        [stringArray addObject:subString];
    }
    return stringArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"文章";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (!_isStore) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"收藏>" style:UIBarButtonItemStyleBordered target:self action:@selector(store:)];
    }
    
    detailTitle.text=[dict objectForKey:@"title"];
    if (!_isStore) {
        detailTime.text=[dict objectForKey:@"pubdate"];
        detailSource.text=[dict objectForKey:@"domainSource"];
    }
    else{
        detailTime.text=[dict objectForKey:@"publishtime"];
        detailSource.text=[dict objectForKey:@"source"];
    }
    
    NSString *content=[dict objectForKey:@"content"];
    NSString *imagesString=@"";
    NSMutableArray *imageArray=[NSMutableArray array];
    self.urlArray=[NSArray array];
    
    if (_isStore) {
        NSRange range=[content rangeOfString:@"<br/>"];
        if (range.length>0) {
            imagesString=[content substringFromIndex:range.location+range.length];
            content=[content substringToIndex:range.location];
            
            while (imagesString.length>0) {
                NSRange startRange=[imagesString rangeOfString:@"<img src="];
                NSRange endRange=[imagesString rangeOfString:@"/><br/>"];
                if (endRange.length==0) {
                    endRange=[imagesString rangeOfString:@"/>"];
                }
                
                NSString *imageString=[imagesString substringWithRange:NSMakeRange(startRange.location+startRange.length+1, endRange.location-startRange.location-startRange.length-2)];
                imagesString=[imagesString substringFromIndex:endRange.location+endRange.length];
                [imageArray addObject:imageString];
            }
            
        }
    }
    
    UITextView *contentView=[[UITextView alloc] init];
    CGRect frame=contentView.frame;
    CGSize constrain=CGSizeMake(SCREENWIDTH, CGFLOAT_MAX);
    CGSize size=[content sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    frame=CGRectMake(frame.origin.x, frame.origin.y, SCREENWIDTH, size.height);
    contentView.frame=frame;
    contentView.text=content;
    contentView.scrollEnabled=NO;
    contentView.editable=NO;
    contentView.font=[UIFont systemFontOfSize:14.0f];
    [detailScroll addSubview:contentView];
    self.yFloat=frame.size.height;
    
    if (!_isStore) {
        self.urlArray=[self imageString:[dict objectForKey:@"pic"]];
        
    }
    else if([imageArray count]>0){
        
        self.urlArray=[NSArray arrayWithArray:imageArray];
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    //self.tabBarController.tabBar.hidden = false;
}
-(void)store:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请点击选择" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"我的收藏", nil];
    [alert show];
    
}

-(void)storeIn{
    NSString *appkey=@"test";
    NSString *apppwd=@"123456";
    NSString *name= [Common getUsername];
    NSString *uid=[Common getUid];
    NSString *fid=@"12";
    NSString *searchid=[dict objectForKey:@"searchId"];
    
    //显示进度条
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    hud.labelText=@"正在收藏...";
    hud.dimBackground=YES;
    
    NSURL *url=[NSURL URLWithString:@"http://222.143.31.169:8080/AddFavorite.do"];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    request.timeoutInterval=5.0;
    request.HTTPMethod=@"POST";
    
    NSString *param=[NSString stringWithFormat:@"appkey=%@&apppwd=%@&name=%@&uid=%@&fid=%@&searchid=%@",appkey,apppwd,name,uid,fid,searchid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectError) {
        //隐藏进度条
        [hud hide:YES];
        if (data) {
            NSLog(@"%@",data);
        }
        else{
            NSLog(@"网络繁忙！");
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self storeIn];
}
@end
