//
//  BasicWebViewController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicWebViewController.h"
#import "ASIHTTPRequest.h"
#import "UIBarButtonItem+TPCategory.h"
#import "UIImage+TPCategory.h"
@interface BasicWebViewController ()<UIWebViewDelegate>
- (void)buttonRefreshClick:(UIButton*)btn;
- (void)loadingWeb;
@end

@implementation BasicWebViewController

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
    [self loadingWeb];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *img=[UIImage imageNamed:@"refreshBtn.png"];//button_refresh.png refreshBtn.png
    if (self.webType==8) {
        img=[img imageByScalingProportionallyToSize:CGSizeMake(30, 30)];
    }
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(self.view.bounds.size.width-10-img.size.width,self.view.bounds.size.height-[self topHeight]-img.size.height-10, img.size.width, img.size.height);
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonRefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.webType!=8) {
       [self.view addSubview:btn];
    }else{
        UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem=rightBtn;
        [rightBtn release];
    }
    
    
    if (self.webType==5) {//意见反馈
         UIBarButtonItem *btn1=[UIBarButtonItem barButtonWithTitle:@"添加" target:self action:@selector(buttonAddClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=btn1;
    }
}
//添加意见反馈
- (void)buttonAddClick{
    Account *acc=[Account unarchiverAccount];
    BasicWebViewController *basic=[[BasicWebViewController alloc] init];
    basic.webType=8;
    basic.title=@"新增意见反馈";
    basic.webURL=[NSString stringWithFormat:BurglarStarAddFeedBackURL,acc.UserId];
    [self.navigationController pushViewController:basic animated:YES];
    [basic release];
}
//返回操作
- (BOOL)backPrevViewController{
    if ([self.view viewWithTag:100]) {
        UIWebView *webView=(UIWebView*)[self.view viewWithTag:100];
        if (webView.canGoBack) {
            [webView goBack];
            return NO;
        }
    }
    return YES;
}
- (void)loadingWeb{
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    if ([self.view viewWithTag:100]) {
        UIWebView *webView=(UIWebView*)[self.view viewWithTag:100];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
    }else{
        CGRect r=self.view.bounds;
        //r.size.height-=[self topHeight];
        UIWebView *webView=[[[UIWebView alloc] initWithFrame:r] autorelease];
        webView.delegate=self;
        webView.tag=100;
        //webView.scalesPageToFit=YES;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
        [self.view addSubview:webView];
        [self.view sendSubviewToBack:webView];
    }
}
//重新加载
- (void)buttonRefreshClick:(UIButton*)btn{
    [self loadingWeb];
    /***
    btn.enabled=NO;
    __block UIActivityIndicatorView *_activityIndicatorView=nil;
    if (!_activityIndicatorView) {
        _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat topY=(self.view.bounds.size.height-[self topHeight]-30)/2;
        _activityIndicatorView.frame=CGRectMake((self.view.bounds.size.width-30)/2, topY, 30, 30);
        [_activityIndicatorView startAnimating];
        [self.view addSubview:_activityIndicatorView];
    }
    ASIHTTPRequest *reuqest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.webURL]];
    [reuqest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [reuqest setCompletionBlock:^{
        btn.enabled=YES;
        [_activityIndicatorView stopAnimating];
        [_activityIndicatorView removeFromSuperview];
        _activityIndicatorView=nil;
        if(reuqest.responseStatusCode==200){
            if ([self.view viewWithTag:100]) {
                UIWebView *webView=(UIWebView*)[self.view viewWithTag:100];
                [webView loadHTMLString:reuqest.responseString baseURL:nil];
            }else{
                CGRect r=self.view.bounds;
                r.size.height-=[self topHeight];
                UIWebView *webView=[[[UIWebView alloc] initWithFrame:r] autorelease];
                webView.tag=100;
                webView.scalesPageToFit=YES;
                [webView loadHTMLString:reuqest.responseString baseURL:nil];
                [self.view addSubview:webView];
                [self.view sendSubviewToBack:webView];
            }
        }
        
    }];
    [reuqest setFailedBlock:^{
         btn.enabled=YES;
        [_activityIndicatorView stopAnimating];
        [_activityIndicatorView removeFromSuperview];
        _activityIndicatorView=nil;
    }];
    [reuqest startAsynchronous];
     ***/
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
     [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingViewAnimated:nil];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
}

@end
