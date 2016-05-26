//
//  HelperViewController.m
//  cloud
//
//  Created by apple on 4/1/15.
//  Copyright (c) 2015 scu. All rights reserved.
//

#import "HelperViewController.h"

@interface HelperViewController ()
@property (nonatomic,strong) NSDictionary *helperDict;
@property (nonatomic) CGFloat yFloat;
@end

@implementation HelperViewController
@synthesize helperView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    helperView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    helperView.contentSize= CGSizeMake(SCREENWIDTH, self.yFloat);
    helperView.showsVerticalScrollIndicator=YES;
    helperView.scrollEnabled=YES;
    NSLog(@"%f",self.yFloat);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading ;the view from its nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"cloud.sqlite"];
    NSLog(@"path = %@", path);
    
    NSArray *queryArray=[[NSArray alloc]initWithObjects:@"1、问：紫云情报能给企业带来什么？", @"2、问：紫云情报主要功能有哪些？",@"3、问：注册时提示验证码错误是怎么回事？",@"4、问：我怎样建立自己的专题？",@" 5、我建立了专题，为什么里面的信息不是我想要的？",@"6、问：已有专题中的关键词可以修改吗？",@"7、问：我可以把有价值的信息收藏起来吗？",@"8、问：我登录时出现闪退是怎么回事？",@"9、问：我的账户不推送信息是什么原因？",@"10、问：紫云情报有隐藏功能吗？",nil];
    NSArray *answerArray=[[NSArray alloc]initWithObjects:@"答：简单的说就是“观天、晓地、知彼、察己。”具体来说就是了解国家政策、知晓行业整体发展情况和趋势、了解竞争对手动态、监测自己企业和品牌的口碑状况，同时，紫云系统可以为您寻找商机，及时为您推送市场采购信息，让您时时接受到来自市场动态信息，提高产品的成效率。从您使用紫云情报这一刻起，您就走上了“用数据驱动创新，用数据科学决策”的道路，相信紫云情报会成为您成功路上的好帮手。让我们一起开始踏上这个奇妙的旅程吧，祝您工作愉快，事业发达！", @"答：紫云情报APP主要功能有“情报搜索”“专题情报”“情报收藏”和“我的情报”四大功能模块。“情报搜索”是解决随时搜的问题，无论何时都可以去搜索自己想要的信息，只需输入自己关注信息所包含的关键词就可以了；“专题情报”主要是解决长期要关注的信息的搜集或者对涉及企业的突发事件进行信息跟踪；对一些信息感觉有参考价值或需长期保存可以把它保存到“情报收藏”；“我的情报”主要是存放自自己定制的推送信息。",@" 答：这可能是您重复提交获取验证码造成的，有些时候短信平台回复信息较慢，需要您需心等待一下，系统中的倒计时并不是提交失效提醒，所以您只需要提交一次就可以了，多次提交了的话，后一次会把前一次的验证码替换，所以您会看到提示验证码错误的信息，您需要把最后一次返回的验证码输入进去，这样就可以解决问题了。",@"答：点击“专题情报”=>“添加专题”=>给专题起个名称=>设定“搜索时限”、“搜索范围”=>选择“所属分类”，最后在关键词输入框输入您想要关键词就可以了。",@"答：这可能涉及两方面的问题，一是专题信息基本上和您所从事的行业无关，这可能是您所设置的关键词没能体现出您所处行业的特点，比如您的行业是职业教育，如果您选择的是“教学”或者“减负”，专题所展现的信息估计和您就没有多大关系了。二是里面的信息是涉及您所处行业的信息，但是很多是您不太关心的信息，关于这点，基本上是由于关键词的逻辑组合不够科学，比如您经营的是办公家具，关键词设为“家具”，那么里面凡是涉及家具的信息都会展现出来，肯定有很多信息不是您想要的，如果您把关键词设为“办公家具”，那么和办公家具无关的信息就不会显示出来，但是可能会错漏一些信息，您可以设成“办公+家具”，这样即保证信息相对精确，又能避免漏掉信息。如果您只是关注有关办公家具招标采购方面的信息，那么您把关键词设置成“办公+家具+（招标｜采购）”就可以了。",@"答：答案是肯定的，具体操作是这样的：点击“专题情报”=>“查看专题”，找到您所要修改的专题长按一会，专题左侧会出现一个“齿轮”标志，点击它就进入到修改页面了，根据您的需要进行修改吧。",@"答：当然可以的，紫云情报APP端有3处地方可以对信息进行收藏操作，分别是“情报搜索”、“专题情报”和“我的情报”。具体操作如下 操作一：点击“情报搜索”，输入关键词进行搜索，点击查看要收藏的文章，进入浏览页面，点击右上角的“收藏”，会弹出对话框，点击“我的收藏”就可以了。 操作二：点击“专题情报”=> “查看专题”=>专题名称=>欲收藏的文章=>进入浏览页面=> “收藏”=>“我的收藏”。 操作三：占击“我的情报”=> 选择要收藏的文章=>进入浏览页面=> “收藏”=>“我的收藏”。",@" 答：如果您在登录时出现退现象，您需要清理一下手机的内存环境，另外，检查一下工具软件是否有在内存占用过高时强行停止某些程序运行的设置。如果不是这些原因，请您及时与我们的客服人员联系，以便及时解决您的问题。",@"答：发现这种情况时，请您检查一下您的网络是否稳定，如果信号很弱就会影响到推送，不过您不用担心，信号正常时，系统会把最近要推送的信息补推过来。",@"答：问这个问题的用户一定是十分有心的用户，紫云情报确实有高级功能，紫云情报为用户提供了30多种信息分析工具，包括信息来源分析、信息正负面研判、信息发展趋势、以及生成分析报告等。但限于目前手机的性能，我们只能在电脑端予以提供，现阶段免费对用户开放，感兴趣的用户可以用您的用户名和密码登录www.ziyun.info，相信您会有所收获。", nil];
    self.helperDict=[NSDictionary dictionaryWithObjectsAndKeys:queryArray,@"query",answerArray,@"answer",nil];
    
    self.yFloat=10.0f;
    
    UILabel *title=[[UILabel alloc] init];
    title.frame=CGRectMake(0, self.yFloat, SCREENWIDTH, 20);
    title.text=@"紫云情报常见问题解答";
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont boldSystemFontOfSize:22.0];
    [helperView addSubview:title];
    self.yFloat+=title.frame.size.height+10;
    
    int i=0;
    while (i<10) {
        NSString *queryText=[[self.helperDict objectForKey:@"query"]objectAtIndex:i];
        UILabel *query=[[UILabel alloc] initWithFrame:CGRectMake(0, self.yFloat, SCREENWIDTH, 15)];
        query.text=queryText;
        query.textColor=[UIColor redColor];
        query.font=[UIFont systemFontOfSize:16.0];
        [helperView addSubview:query];
        self.yFloat+=query.frame.size.height+10;
        
        NSString *answerText=[[self.helperDict objectForKey:@"answer"]objectAtIndex:i];;
        CGSize constraint=CGSizeMake(SCREENWIDTH, CGFLOAT_MAX);
        //CGSize size =[answerText ç:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        CGSize size=[answerText sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        UITextView *text=[[UITextView alloc] initWithFrame:CGRectMake(0, self.yFloat, SCREENWIDTH, size.height+40)];
        text.text=answerText;
        text.font=[UIFont systemFontOfSize:16.0];
        text.scrollEnabled=NO;
        text.editable=NO;
        [helperView addSubview:text];
        self.yFloat+=text.frame.size.height+10;
        
        i++;
    }
    
    self.navigationItem.title=@"问题帮助";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
   }
@end
