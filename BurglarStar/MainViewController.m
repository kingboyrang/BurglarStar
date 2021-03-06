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
#import "SOSManagerViewController.h"
#import "MoreViewController.h"
#import "AlertHelper.h"
#import "PushViewController.h"
#import "ASIServiceHTTPRequest.h"
@interface MainViewController ()
- (void)buttonLoginClick:(id)sender;
- (void)buttonRegisterClick:(id)sender;
- (void)loadInitControls;
- (void)buttonPopWeatherClick:(UIButton*)btn;
- (void)buttonUserInfoClick;
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
    //self.navigationController.navigationBar.translucent =YES;
    self.title=@"防盗之星";
    
    CGFloat h=self.view.bounds.size.height/2;

   
    
    CGFloat topY=h-[self topHeight]-44;
    
    _weatherPopView=[[WeatherPopView alloc] initWithFrame:CGRectMake(0, topY+44-74, self.view.bounds.size.width,74)];
    [self.view addSubview:_weatherPopView];
    
    _weatherView=[[WeatherView alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [_weatherView.arrowButton addTarget:self action:@selector(buttonPopWeatherClick:) forControlEvents:UIControlEventTouchUpInside];
    _weatherView.delegate=_weatherPopView;
    [self.view addSubview:_weatherView];
    
   
    
    _scrollAdView=[[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,topY)];
    _scrollAdView.backgroundColor=[UIColor colorFromHexRGB:@"e5e2d0"];
    [self.view addSubview:_scrollAdView];
    
    topY=_weatherView.frame.size.height+_weatherView.frame.origin.y;
    BSMenu *menu=[[BSMenu alloc] initWithFrame:CGRectMake(0, topY,self.view.bounds.size.width, self.view.bounds.size.height-topY-[self topHeight])];
    menu.tag=801;
    menu.delegate=self;
    CGRect r=menu.frame;
    r.origin.x=(self.view.bounds.size.width-r.size.width)/2;
    r.origin.y=topY+(self.view.bounds.size.height-topY-[self topHeight]-r.size.height)/2;
    menu.frame=r;
    [self.view addSubview:menu];
    [menu release];
    
    
    
    /***274 230
    NSString *memo=@"深圳宝安区";
     CGSize size=[memo textSize:[UIFont systemFontOfSize:12] withWidth:320];
    NSLog(@"size=%@",NSStringFromCGSize(size));
     ***/
}
- (void)loadInitControls{
    Account *acc=[Account unarchiverAccount];
    if (acc.isLogin) {//表示已登录
         if (self.navigationItem.rightBarButtonItems.count!=1) {
           UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithImage:@"head" target:self action:@selector(buttonUserInfoClick) forControlEvents:UIControlEventTouchUpInside];
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
//点击弹出天气
- (void)buttonPopWeatherClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    BSMenu *menu=(BSMenu*)[self.view viewWithTag:801];
   if(!btn.selected)//显示天气
   {
       btn.selected=YES;
       CGRect r=self.weatherPopView.frame;
       r.origin.y+=r.size.height;
       
       [self.view sendSubviewToBack:menu];
       
       [UIView animateWithDuration:0.5f animations:^{
           self.weatherPopView.frame=r;
       }];
       
   }else{//隐藏天气
       btn.selected=NO;
       CGRect r=self.weatherPopView.frame;
       r.origin.y-=r.size.height;
       
       [UIView animateWithDuration:0.5f animations:^{
           self.weatherPopView.frame=r;
       }];

   }
}
//个人信息
- (void)buttonUserInfoClick{
    UserInfoViewController *userInfo=[[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfo animated:YES];
    [userInfo release];
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
        [AlertHelper initWithTitle:@"提示" message:@"尚未登录,是否前往登录?" cancelTitle:@"取消" cancelAction:nil confirmTitle:@"确定" confirmAction:^{
            LoginViewController *login=[[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            [login release];
        }];
        return;
    }
    if (itemIndex==100) {//监控中心
        IndexViewController *index=[[IndexViewController alloc] init];
        [self.navigationController pushViewController:index animated:YES];
        [index release];
    }
    else if(itemIndex==101)//信息提醒
    {
        PushViewController *noticeMsg=[[PushViewController alloc] init];
        [self.navigationController pushViewController:noticeMsg animated:YES];
        [noticeMsg release];
    }
    else if(itemIndex==102)//sos
    {
        SOSManagerViewController *sos=[[SOSManagerViewController alloc] init];
        [self.navigationController pushViewController:sos animated:YES];
        [sos release];
    }
    else if(itemIndex==103)//车辆管理
    {
         SupervisionViewController *Supervision=[[SupervisionViewController alloc] init];
        [self.navigationController pushViewController:Supervision animated:YES];
        [Supervision release];
    }else{//人物
        MoreViewController *more=[[MoreViewController alloc] init];
        more.title=@"个人中心";
        [self.navigationController pushViewController:more animated:YES];
        [more release];
    }
}

@end
