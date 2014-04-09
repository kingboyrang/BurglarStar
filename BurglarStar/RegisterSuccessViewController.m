//
//  RegisterSuccessViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/19.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "RegisterSuccessViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "ToolBarView.h"
@interface RegisterSuccessViewController (){
    UILabel *_labelShowInfo;
    int total;
}
- (void)timerFireMethod:(NSTimer*)theTimer;
@end

@implementation RegisterSuccessViewController
- (void)dealloc{
    [super dealloc];
    [_labelShowInfo release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    total=5;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"注册成功";
    
    NSString *memo=@"自动登录,5秒后跳转到主画面...";
    CGSize size=[memo textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.view.bounds.size.width-20];
    _labelShowInfo=[[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-size.width)/2.0,(DeviceRealHeight-44*2-size.height)/2, size.width, size.height)];
    _labelShowInfo.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _labelShowInfo.backgroundColor=[UIColor clearColor];
    _labelShowInfo.numberOfLines=0;
    _labelShowInfo.lineBreakMode=NSLineBreakByWordWrapping;
    _labelShowInfo.text=memo;
    _labelShowInfo.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    [self.view addSubview:_labelShowInfo];
    
    
    CGFloat topY=self.view.bounds.size.height-[self topHeight]-44;
    ToolBarView *btn=[[ToolBarView alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [btn.button addTarget:self action:@selector(buttonCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
//5秒后登陆
- (void)timerFireMethod:(NSTimer*)theTimer{
    total--;
    if (total==0) {
        [theTimer invalidate];
        [Account registerLoginWithAccount:self.Entity];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
       _labelShowInfo.text=[NSString stringWithFormat:@"自动登录,%d秒后跳转到主画面...",total];
    }
}
//取消
-(void)buttonCancelClick{
    [Account closed];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
