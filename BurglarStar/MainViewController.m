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
#import "WeatherView.h"
#import "LocationGPS.h"
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
    WeatherView *weather=[[WeatherView alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [self.view addSubview:weather];
    [weather release];
    
    _scrollAdView=[[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, topY)];
    [self.view addSubview:_scrollAdView];
    
    LocationGPS *gps=[LocationGPS sharedInstance];
    [gps startLocation:^(SVPlacemark *place) {
        NSLog(@"name=%@",place.name);
        NSLog(@"formattedAddress=%@",place.formattedAddress);
         NSLog(@"subThoroughfare=%@",place.subThoroughfare);
         NSLog(@"thoroughfare=%@",place.thoroughfare);
         NSLog(@"subLocality=%@",place.subLocality);
         NSLog(@"locality=%@",place.locality);
         NSLog(@"subAdministrativeArea=%@",place.subAdministrativeArea);
         NSLog(@"administrativeArea=%@",place.administrativeArea);
         NSLog(@"administrativeAreaCode=%@",place.administrativeAreaCode);
        NSLog(@"postalCode=%@",place.postalCode);
        NSLog(@"country=%@",place.country);
         NSLog(@"ISOcountryCode=%@",place.ISOcountryCode);
    } failed:nil];
    /***
     @property (nonatomic, strong, readonly) NSString *name;
     @property (nonatomic, strong, readonly) NSString *formattedAddress;
     @property (nonatomic, strong, readonly) NSString *subThoroughfare;
     @property (nonatomic, strong, readonly) NSString *thoroughfare;
     @property (nonatomic, strong, readonly) NSString *subLocality;
     @property (nonatomic, strong, readonly) NSString *locality;
     @property (nonatomic, strong, readonly) NSString *subAdministrativeArea;
     @property (nonatomic, strong, readonly) NSString *administrativeArea;
     @property (nonatomic, strong, readonly) NSString *administrativeAreaCode;
     @property (nonatomic, strong, readonly) NSString *postalCode;
     @property (nonatomic, strong, readonly) NSString *country;
     @property (nonatomic, strong, readonly) NSString *ISOcountryCode;
     
    NSURL *url = [NSURL URLWithString:@"http://61.4.185.48:81/g/"];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSLog(@"xml=%@",request.responseString);
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
     ***/
    
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
