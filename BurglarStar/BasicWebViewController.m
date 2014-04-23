//
//  BasicWebViewController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/21.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicWebViewController.h"
#import "ASIHTTPRequest.h"
@interface BasicWebViewController ()
- (void)buttonRefreshClick:(UIButton*)btn;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *img=[UIImage imageNamed:@"refreshBtn.png"];//button_refresh.png refreshBtn.png
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(self.view.bounds.size.width-10-img.size.width,self.view.bounds.size.height-[self topHeight]-img.size.height-10, img.size.width, img.size.height);
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonRefreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    ASIHTTPRequest *reuqest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.webURL]];
    [reuqest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [reuqest setCompletionBlock:^{
        if(reuqest.responseStatusCode==200){
            [self hideLoadingViewAnimated:nil];
            CGRect r=self.view.bounds;
            //r.size.height-=[self topHeight];
            UIWebView *webView=[[[UIWebView alloc] initWithFrame:r] autorelease];
            webView.tag=100;
            //webView.scalesPageToFit=YES;
            [webView loadHTMLString:reuqest.responseString baseURL:nil];
            [self.view addSubview:webView];
            [self.view sendSubviewToBack:webView];
            return;
        }
        [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
    }];
    [reuqest setFailedBlock:^{
        [self hideLoadingFailedWithTitle:@"加载失败!" completed:nil];
    }];
    [reuqest startAsynchronous];
    
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
//重新加载
- (void)buttonRefreshClick:(UIButton*)btn{
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
