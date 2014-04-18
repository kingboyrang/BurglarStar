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
#import "ASIServiceArgs.h"
#import "ASIServiceResult.h"
#import "UIImageView+WebCache.h"
#import "UIImage+TPCategory.h"
@interface RegisterSuccessViewController (){
    //UILabel *_labelShowInfo;
    int total;
}
- (void)timerFireMethod:(NSTimer*)theTimer;
- (void)loadSuccessImage;
@end

@implementation RegisterSuccessViewController
- (void)dealloc{
    [super dealloc];
    //[_labelShowInfo release];
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
    
    /***
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
     ***/
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight]+44;
    _imageView=[[UIImageView alloc] initWithFrame:r];
    //[_imageView setImage:[[UIImage imageNamed:@"tick.png"] imageByScalingToSize:r.size]];
    [self.view addSubview:_imageView];
    
    
    CGFloat topY=self.view.bounds.size.height-[self topHeight]-44;
    ToolBarView *btn=[[ToolBarView alloc] initWithFrame:CGRectMake(0, topY, self.view.bounds.size.width, 44)];
    [btn.button addTarget:self action:@selector(buttonCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self loadSuccessImage];
}
- (void)loadSuccessImage{
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"GetExcessiveLogin";
    
    ASIHTTPRequest *request=args.request;
    [request setCompletionBlock:^{
        ASIServiceResult *result=[ASIServiceResult instanceWithRequest:request ServiceArgs:args];
        if (result.success) {
            NSDictionary *dic=[result json];
            if (dic&&[dic count]>0) {
                NSString *imgURL=[dic objectForKey:@"Result"];
                if ([imgURL length]>0) {
                    [_imageView setImageWithURL:[NSURL URLWithString:imgURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        if (image) {
                            [_imageView setImage:image];
                            //2秒过后执行登陆操作
                            int64_t delayInSeconds = 2.0f;
                            dispatch_time_t popTime =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                [Account registerLoginWithAccount:self.Entity];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            });
                        }
                    }];
                }
            }
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
//5秒后登陆
- (void)timerFireMethod:(NSTimer*)theTimer{
    total--;
    if (total==0) {
        [theTimer invalidate];
        [Account registerLoginWithAccount:self.Entity];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
       //_labelShowInfo.text=[NSString stringWithFormat:@"自动登录,%d秒后跳转到主画面...",total];
    }
}
//取消
-(void)buttonCancelClick{
    [Account closed];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
