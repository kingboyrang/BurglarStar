//
//  MainViewController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/7.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RegisterSuccessViewController.h"
#import "UIBarButtonItem+TPCategory.h"
#import "IndexViewController.h"
#import "ASIHTTPRequest.h"
#import "SupervisionViewController.h"
#import "UserInfoViewController.h"

@interface MainViewController ()
- (void)buttonLoginClick:(id)sender;
- (void)buttonRegisterClick:(id)sender;
- (void)loadInitControls;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadInitControls];
    
    [self.scrollAdView loadAdSources];//加载图片滚动
    [self.weatherView loadCurrentLocationWeather];//加载当前位置天气
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scrollAdView pauseAd];//暂停
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"防盗之星";

    BSMenu *menu=[[BSMenu alloc] initWithFrame:CGRectZero];
    menu.delegate=self;
    CGRect r=menu.frame;
    r.origin.x=(self.view.bounds.size.width-r.size.width)/2;
    r.origin.y=self.view.bounds.size.height-r.size.height-[self topHeight]-10;
    menu.frame=r;
    [self.view addSubview:menu];
    [menu release];
    
    CGFloat topY=r.origin.y-10-44;
    _weatherView=[[WeatherView alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [self.view addSubview:_weatherView];
    
    _scrollAdView=[[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, topY)];
    [self.view addSubview:_scrollAdView];
    
/***
http://mobile.weather.com.cn/data/forecast/101280601.html
http://m.weather.com.cn/data/101280601.html
 ***/
     //client.Headers.Add("Accept", "application/json, text/javascript, */*; q=0.01");
     /***
    client.Headers.Add("Accept-Language", "zh-CN,zh;q=0.8");
    //注意：Referer 一定要加，否则获取的不是当天的。
    client.Headers.Add("Referer", "http://mobile.weather.com.cn/");
    client.Headers.Add("User-Agent", "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1;Chrome/27.0.1453.110; Trident/5.0)");
     ***/
    
    /***
     http://mobile.weather.com.cn/images/small/day/31.png
     //当天天气=http://mobile.weather.com.cn/data/sk/101280601.html
     fa 白天图片id http://mobile.weather.com.cn/images/small/day/00.png
     
     fb 夜晚图片id http://mobile.weather.com.cn/images/small/night/00.png
     
     fc 白天温度
     
     fd 夜晚温度
     
     fi 日出和日落时间
     ***/
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://mobile.weather.com.cn/data/forecast/101280601.html"]];
   
    [request addRequestHeader:@"Accept" value:@"application/json, text/javascript, */*; q=0.01"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN,zh;q=0.8"];
    [request addRequestHeader:@"Referer" value:@"http://mobile.weather.com.cn/"];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1;Chrome/27.0.1453.110; Trident/5.0)"];
   
    [request setCompletionBlock:^{
        if (request.responseStatusCode==200) {
            NSLog(@"xml=%@",request.responseString);
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *obj=[dic objectForKey:@"f"];
            NSDictionary *item=[obj objectForKey:@"f1"];
             NSLog(@"class=%@",[item class]);
            NSLog(@"%@",item);
           
        }
       
    }];
    [request setFailedBlock:^{
        NSLog(@"error=%@",request.error.description);
    }];
    [request startAsynchronous];
}
- (void)loadInitControls{
    Account *acc=[Account unarchiverAccount];
    if (acc.isLogin) {//表示已登录
         if (self.navigationItem.rightBarButtonItems.count!=1) {
           UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithImage:@"head" target:self action:nil forControlEvents:UIControlEventTouchUpInside];
           NSArray *actionButtonItems = [NSArray arrayWithObjects:btn1, nil];
           self.navigationItem.rightBarButtonItems = actionButtonItems;
         }
    }else{
        if (self.navigationItem.rightBarButtonItems.count<2) {
            UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"登录" target:self action:@selector(buttonLoginClick:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *btn2=[UIBarButtonItem barButtonWithTitle:@"注册" target:self action:@selector(buttonRegisterClick:) forControlEvents:UIControlEventTouchUpInside];
            NSArray *actionButtonItems = [NSArray arrayWithObjects:btn2,btn1, nil];
            self.navigationItem.rightBarButtonItems = actionButtonItems;
        }
       
    }
}
//登录
- (void)buttonLoginClick:(id)sender
{
    LoginViewController *login=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
    [login release];
}
//注册
- (void)buttonRegisterClick:(id)sender
{
     /***
    RegisterSuccessViewController *reg=[[RegisterSuccessViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
    [reg release];
   ***/
    
    RegisterViewController *reg=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
    [reg release];
     
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - BSMenuDelegate Methods
-(void)selectItemMenu:(id)sender index:(NSInteger)itemIndex{
    Account *acc=[Account unarchiverAccount];
    if (!acc.isLogin) {
        return;
    }
    if (itemIndex==100) {//监控中心
        IndexViewController *index=[[IndexViewController alloc] init];
        [self.navigationController pushViewController:index animated:YES];
        [index release];
    }
    else if(itemIndex==101)//信息提醒
    {
        
    }
    else if(itemIndex==102)//sos
    {
        
    }
    else if(itemIndex==103)//车辆管理
    {
         SupervisionViewController *Supervision=[[SupervisionViewController alloc] init];
        [self.navigationController pushViewController:Supervision animated:YES];
        [Supervision release];
    }else{//人物
        UserInfoViewController *userInfo=[[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userInfo animated:YES];
        [userInfo release];
    }
}

@end
