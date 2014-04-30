//
//  PushViewController.m
//  Wisdom
//
//  Created by aJia on 2013/11/4.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "PushViewController.h"
#import "scrollSwitch.h"
#import "PushView.h"
#import "PushDetail.h"
#import "Account.h"
@interface PushViewController ()<PushViewDelegate>

@end

@implementation PushViewController
-(void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGPoint point=_scrollView.contentOffset;
    if (point.x==0) {
        PushView *view=(PushView*)[_scrollView viewWithTag:100];
        [view reloadingSourceData];
        PushView *view1=(PushView*)[_scrollView viewWithTag:101];
        [view1 initParams];
    }else{
        PushView *view=(PushView*)[_scrollView viewWithTag:101];
        [view reloadingSourceData];
        PushView *view1=(PushView*)[_scrollView viewWithTag:100];
        [view1 initParams];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"信息提醒";
    
    self.view.backgroundColor=[UIColor whiteColor];
    scrollSwitch *switchItem=[[scrollSwitch alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    switchItem.tag=700;
    switchItem.controler=self;
    [self.view addSubview:switchItem];
   
    CGRect r=self.view.bounds;
    r.origin.y=40;
    r.size.height=self.view.bounds.size.height-[self topHeight]-40;
    _scrollView=[[UIScrollView alloc] initWithFrame:r];
    _scrollView.backgroundColor=[UIColor colorFromHexRGB:@"e5e2d0"];
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    [_scrollView setContentSize:CGSizeMake(r.size.width*2,r.size.height)];
    [self.view addSubview:_scrollView];
    
     /***
    PushDetail *detail=[[PushDetail alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 77)];
    detail.labDate.text=@"2012.10.08";
    detail.labMessage.text=@"test all 15:33";
    [_scrollView addSubview:detail];
    [detail release];
   ***/
    
    PushView *view1=[[[PushView alloc] initWithFrame:CGRectMake(0, 0, r.size.width, r.size.height)] autorelease];
    view1.infoType=1;
    view1.delegate=self;
    view1.tag=100;
    [_scrollView addSubview:view1];
    
    
    PushView *view2=[[[PushView alloc] initWithFrame:CGRectMake(r.size.width, 0, r.size.width, r.size.height)] autorelease];
    view2.tag=101;
    view2.delegate=self;
    view2.infoType=2;
    [_scrollView addSubview:view2];
 
    Account *acc=[Account unarchiverAccount];
    if(acc.isLogin){
      [view1 loadingSourceData];
    }else{
       [switchItem scrollerToRight];
    }
    [switchItem release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoticeInfo) name:@"myInfo" object:nil];
}
-(void)receiveNoticeInfo{
    scrollSwitch *item=(scrollSwitch*)[self.view viewWithTag:700];
    [item scrollerToLeft];
    
    PushView *view=(PushView*)[_scrollView viewWithTag:100];
    [view reloadingSourceData];
}
#pragma mark -PushViewDelegate Methods
- (void)showErrorNetWork{
    [self showErrorNetWorkNotice:nil];
}
- (void)showMesssageWithTitle:(NSString*)title{
    [self showSuccessViewWithHide:^(AnimateErrorView *successView) {
        successView.labelTitle.text=title;
    } completed:nil];
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    int page=offset.x / bounds.size.width;
    
    scrollSwitch *item=(scrollSwitch*)[self.view viewWithTag:700];
    if(page==0){
        [item scrollerToLeft];
    }else{
        [item scrollerToRight];
    }
    
}
-(void)pageScrollLeft{
    PushView *view=(PushView*)[_scrollView viewWithTag:100];
    view.infoType=1;
    [view reloadingSourceData];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];//页面滑动
}
-(void)pageScrollRight{
    PushView *view=(PushView*)[_scrollView viewWithTag:101];
    view.infoType=2;
    [view reloadingSourceData];
    [self.scrollView setContentOffset:CGPointMake(DeviceWidth, 0)];//页面滑动
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
