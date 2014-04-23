//
//  AdView.m
//  stockmarket_infomation
//
//  Created by 神奇的小黄子 QQ:438172 on 12-12-10.
//  Copyright (c) 2012年 kernelnr. All rights reserved.
//

#import "AdView.h"
#import "UIImageView+WebCache.h"
#import "AdModel.h"
#import "ASIServiceHTTPRequest.h"
#import "NSTimer+TPCategory.h"
#import "UIImage+TPCategory.h"
@implementation MyUIScrollView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}
@end

@implementation AdView

#define ADIMG_INDEX 888
#define ADTITLE_INDEX   889
#define AD_BOTTOM_HEIGHT    0

- (void)dealloc{
    if (sv_Ad) {
        [sv_Ad release],sv_Ad=nil;
    }
    if (pc_AdPage) {
        [pc_AdPage release],pc_AdPage=nil;
    }
    if (lbl_Info) {
        [lbl_Info release],lbl_Info=nil;
    }
    if (adTimer) {
        [adTimer invalidate];
        [adTimer release],adTimer=nil;
    }
    [super dealloc];
}
#pragma mark - ----- init frame
- (id)initWithFrame:(CGRect)frame :(NSMutableArray *)arr
{
    self = [super initWithFrame:frame];
    
    
    if (nil != self)
    {
        // init...
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return self;
}
- (void)loadAdSources{
    [self resumeAd];//恢复计时器轮播
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"GetCarouselIMG";
    //args.httpWay=ASIServiceHttpPost;
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic&&[dic count]>0) {
                NSArray *arr=[dic objectForKey:@"SosList"];
                if (arr&&[arr count]>0) {
                    NSMutableArray *sources=[NSMutableArray arrayWithCapacity:arr.count];
                    NSDictionary *dic=[arr objectAtIndex:0];
                    for (NSString *item in dic.allKeys) {
                        AdModel *model=[[AdModel alloc] init];
                        model.advertName=@"";
                        model.thumb=[dic objectForKey:item];
                        model.webURl=model.thumb;
                        [sources addObject:model];
                        [model release];
                    }
                    //加载图片轮播
                    self.ads=sources;
                    [self adLoad];//加载图片
                }
            }
            
        }
    }];
    [request setFailedBlock:^{
         NSLog(@"error=%@",request.error.description);
    }];
    [request startAsynchronous];
}
/* ad loading... */
//暂停广告滚动
- (void)pauseAd{
    if (adTimer) {
        [adTimer pause];
    }
}
//恢复广告滚动
- (void)resumeAd{
    if (adTimer) {
        [adTimer resume];
    }
}
- (void)adLoad
{
    /* set timer(图片轮播)*/
    if (adTimer) {
        [adTimer invalidate];
        [adTimer release],adTimer=nil;
    }
    adTimer=[[NSTimer scheduledTimerWithTimeInterval:4.5f target:self selector:@selector(changedAdTimer:) userInfo:nil repeats:YES] retain];
    
    
    if (![self.subviews containsObject:sv_Ad]) {
        sv_Ad = [[MyUIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-AD_BOTTOM_HEIGHT)];
        [sv_Ad setDelegate:self];   // set delegate
        [sv_Ad setScrollEnabled:YES];
        [sv_Ad setPagingEnabled:YES];
        [sv_Ad setShowsHorizontalScrollIndicator:NO];
        [sv_Ad setShowsVerticalScrollIndicator:NO];
        [sv_Ad setAlwaysBounceVertical:NO];
        [self addSubview:sv_Ad];
    }
    [sv_Ad setContentSize:CGSizeMake(sv_Ad.frame.size.width*([_ads count]>0?[_ads count]:0), sv_Ad.frame.size.height)];
    //删除元素
    for (UIView *v in sv_Ad.subviews) {
        [v removeFromSuperview];
    }
    
    
    /***
    // infomation
    UIImageView *img_info = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, self.frame.size.height-24.f-AD_BOTTOM_HEIGHT+6, self.frame.size.width, 18.f)];
    [img_info setBackgroundColor:[UIColor blackColor]];
    [img_info setAlpha:.3f];
    [self addSubview:img_info];
     ***/
    
    /***
    int i=0;
    for (AdModel *adModel in _ads) {
        if(i==0){
            lbl_Info = [[UILabel alloc] initWithFrame:CGRectMake(6, self.frame.size.height-24+3, DeviceWidth-100, 24.f)];
            [lbl_Info setTag:ADTITLE_INDEX];
            [lbl_Info setBackgroundColor:[UIColor clearColor]];
            lbl_Info.shadowColor = [UIColor grayColor];
            lbl_Info.shadowOffset = CGSizeMake(0.3, 0.3);
            [lbl_Info setTextColor:[UIColor whiteColor]];
            [lbl_Info setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.f]];
            [lbl_Info setText:adModel.advertName];
            [lbl_Info setTextAlignment:NSTextAlignmentLeft];
            [lbl_Info setLineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
            //[lbl_Info setLineBreakMode:NSLineBreakByWordWrapping];
            [self addSubview:lbl_Info];
        }
        i++;
    }
    ***/
     if (![self.subviews containsObject:lbl_Info])
     {
         lbl_Info = [[UILabel alloc] initWithFrame:CGRectMake(6, self.frame.size.height-24+3, sv_Ad.frame.size.width-100, 24.f)];
         [lbl_Info setTag:ADTITLE_INDEX];
         lbl_Info.hidden=YES;
         [self addSubview:lbl_Info];
     }
    
    
    int y=0;
    for (AdModel *adModel in _ads)
    {
        
        UIImageView *img_Ad = [[UIImageView alloc] initWithFrame:CGRectMake(sv_Ad.frame.size.width*y, 0, sv_Ad.frame.size.width, self.frame.size.height)];
        //img_Ad.userInteractionEnabled=YES;
        [img_Ad setTag:y];
        //[img_Ad setImageWithURL:[NSURL URLWithString:adModel.thumb]];
        [img_Ad setImageWithURL:[NSURL URLWithString:adModel.thumb] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [img_Ad setImage:[image imageByScalingToSize:sv_Ad.frame.size]];
            }
        }];
        //[img_Ad setImage:[UIImage imageWithContentsOfFile:adModel.thumb]];
        [img_Ad setUserInteractionEnabled:YES];
        [sv_Ad addSubview:img_Ad];
        y++;
        
    }
    /* page ctrl */
    if (![self.subviews containsObject:pc_AdPage]) {
       pc_AdPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 64.f, 8.f)];
       //[pc_AdPage setCenter:CGPointMake(sv_Ad.frame.size.width-70.f/2.f, self.frame.size.height+3-AD_BOTTOM_HEIGHT-24.f/2.f)];
       
       [pc_AdPage setUserInteractionEnabled:YES];
       [pc_AdPage setAutoresizesSubviews:YES];
       [pc_AdPage setAlpha:1.f];
        pc_AdPage.pageIndicatorTintColor=[UIColor colorFromHexRGB:@"7a7676"];
        pc_AdPage.currentPageIndicatorTintColor=[UIColor colorFromHexRGB:@"285c81"];
       [self addSubview:pc_AdPage];
    }
    [pc_AdPage setCenter:CGPointMake(sv_Ad.frame.size.width/2.f, self.frame.size.height+3-AD_BOTTOM_HEIGHT-24.f/2.f)];
    [pc_AdPage setCurrentPage:0];
    [pc_AdPage setNumberOfPages:([_ads count]>0?[_ads count]:0)];
    
    
}

#pragma mark - ----- -> 自动切换广告
static int cur_count = -1;
- (void)changedAdTimer:(NSTimer *)timer
{
    cur_count = pc_AdPage.currentPage;
    ++cur_count;
    pc_AdPage.currentPage = (cur_count%[_ads count]);
    
    AdModel *adModel=[[AdModel alloc] init];
    adModel=[_ads objectAtIndex:pc_AdPage.currentPage];
    
    [UIView animateWithDuration:.7f animations:^{
        [lbl_Info setText:adModel.advertName];
        sv_Ad.contentOffset = CGPointMake(pc_AdPage.currentPage*DeviceWidth,0);
    }];
}




#pragma mark - ----- -> 点击广告
- (void)OpenAd:(int)iTag
{
    AdModel *adModel=self.ads[iTag];
    UIApplication *app=[UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:adModel.webURl]];
    //WebViewController *webVC = [[WebViewController alloc] initWithUrl:@"http://baidu.com"];
    //[self.viewController.navigationController pushViewController:webVC  animated:YES];
    
}

#pragma mark - ----- -> scrollView opt
enum _jmpFalg { NORMAL = 0, LAST = -1, FIRST = 1 };
BOOL bJmp = NORMAL;
static float maxLoc = 0.f, minLoc = 0.f;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    maxLoc = (maxLoc>scrollView.contentOffset.x)?maxLoc:scrollView.contentOffset.x;
    minLoc = (minLoc<scrollView.contentOffset.x)?minLoc:scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    do
    {
        if (maxLoc > ([_ads count]-1)*320.f)
        {
            bJmp = FIRST;
            break;
        }
        else if (minLoc < 0*320.f)
        {
            bJmp = LAST;
            break;
        }
        else
        {
            bJmp = NORMAL;
            break;
        }
    } while (TRUE);
    
    switch ((int)bJmp)
    {
        case (int)FIRST:
        {
            pc_AdPage.currentPage = 0;
        }
            break;
        case (int)LAST:
        {
            pc_AdPage.currentPage = ([_ads count]>0?[_ads count]:0);
        }
            break;
        case (int)NORMAL:
        {
            [pc_AdPage setCurrentPage:scrollView.contentOffset.x/320.f];
        }
            break;
        default:
            break;
    }
    AdModel *adModel=[[AdModel alloc] init];
    adModel=[_ads objectAtIndex:pc_AdPage.currentPage];
    
    [UIView animateWithDuration:.7f animations:^{
        [lbl_Info setText:adModel.advertName];
        sv_Ad.contentOffset = CGPointMake((pc_AdPage.currentPage%[_ads count])*320.f, 0.f);
    }];
    maxLoc = minLoc = sv_Ad.contentOffset.x;
}

#pragma mark ----- -> touches opt

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    UIView *touchedView = [touches.anyObject view];
    //[self OpenAd:touchedView.tag];
    [self.delegate openAd:self adModel:_ads[touchedView.tag]];
 
}

@end