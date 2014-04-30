//
//  AppHelper.m
//  LocationService
//
//  Created by aJia on 2013/12/16.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "AppHelper.h"
#import "Account.h"
#import "ASIServiceHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "UIImage+TPCategory.h"
#import "AlertHelper.h"
#import "AnimateLoadView.h"
#import "Account.h"
@interface AppHelper ()
- (void)runAnimation;
- (void)watiAnimationShow:(UIImage*)image;
- (void)removeView;
- (void)removeRunningAnimation;
- (void)addRunningView;
@end

@implementation AppHelper
//注册推播
+ (void)registerApns{
    Account *acc=[Account unarchiverAccount];
    if (acc.isLogin) {//表示已登陆
        if ([acc.UserId length]>0&&acc.pushUserId&&[acc.pushUserId length]>0&&acc.channelId&&[acc.channelId length]>0) {
            
            NSString *pwd=acc.Password&&[acc.Password length]>0?acc.Password:@"";
            NSMutableArray *params=[NSMutableArray array];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.UserId,@"uid", nil]];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:pwd,@"pwd", nil]];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.pushUserId,@"userId", nil]];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.channelId,@"channelId", nil]];
            ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
            args.serviceURL=DataPushWebserviceURL;
            args.serviceNameSpace=DataPushNameSpace;
            args.methodName=@"Register";
            args.soapParams=params;
            
            ASIHTTPRequest *request=[args request];
            [request setCompletionBlock:^{
                
            }];
            [request setFailedBlock:^{
                
            }];
            [request startAsynchronous];
            
        }
    }
}
+ (NSArray*)arrayWithSource:(NSArray*)source className:(NSString*)name{
    if (source&&[source count]>0) {
        NSMutableArray *result=[NSMutableArray arrayWithCapacity:source.count];
        for (NSDictionary *item in source) {
            id entity=[[NSClassFromString(name) alloc] init];
            for (NSString *k in item.allKeys) {
                SEL sel=NSSelectorFromString(k);
                if ([entity respondsToSelector:sel]) {
                    [entity setValue:[item objectForKey:k] forKey:k];
                }
            }
            [result addObject:entity];
            [entity release];
        }
        return result;
    }
    return [NSArray array];
}
+ (void)startRunAnimation{
    AppHelper *app=[[[AppHelper alloc] init] autorelease];
    [app runAnimation];//启动动画
}
#pragma mark -启动动画处理
- (void)runAnimation{
    [self addRunningView];//添加启动画面
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"GetExcessive";
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic&&[dic count]>0) {
                NSString *imgURL=[dic objectForKey:@"Result"];
                if ([imgURL length]>0) {
                    boo=YES;
                    //显示图片
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadWithURL:[NSURL URLWithString:imgURL] options:0
                                    progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                        if (image && finished)
                                        {
                                            // 下载完成
                                            [self watiAnimationShow:image];
                                        }else{
                                            [self removeView];
                                        }
                                    }];
                    //图片下载完成
                }
            }
        }
        if (!boo) {
            [self removeView];
        }
    }];
    [request setFailedBlock:^{
        [self removeView];
    }];
    [request startAsynchronous];
}
- (void)watiAnimationShow:(UIImage*)image{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIView *bgView=(UIView*)[window viewWithTag:970];
    if (bgView) {
        for (UIView *v in bgView.subviews) {
            [v removeFromSuperview];
        }
    }
    UIImage *img=[image imageByScalingToSize:bgView.bounds.size];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:bgView.bounds];
    [imageView setImage:img];
    [bgView addSubview:imageView];
    [imageView release];
    
    //4秒过后执行其它操作
    int64_t delayInSeconds = 4.0f;
    dispatch_time_t popTime =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeRunningAnimation];
    });
}
- (void)removeView{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    if ([window viewWithTag:970]) {
        [[window viewWithTag:970] removeFromSuperview];
    }
}
- (void)removeRunningAnimation{
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIView *imageView=(UIView*)[window viewWithTag:970];
    [UIView animateWithDuration:1.0f animations:^{
        imageView.alpha= 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [imageView removeFromSuperview];
            if ([window viewWithTag:970]) {
                [[window viewWithTag:970] removeFromSuperview];
            }
        }
    }];
}
- (void)addRunningView{
    UIView *bgView=[[UIView alloc] initWithFrame:DeviceRect];
    bgView.tag=970;
    bgView.backgroundColor=[UIColor colorFromHexRGB:@"e5e2d0"];
    
    NSString *title=@"正在启动...";
    CGSize size=[title textSize:[UIFont boldSystemFontOfSize:14] withWidth:DeviceWidth];
    UIActivityIndicatorView *_activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame=CGRectMake((DeviceWidth-30-size.width-2)/2, (DeviceHeight-30)/2, 30, 30);
    [_activityIndicatorView startAnimating];
    [bgView addSubview:_activityIndicatorView];
    
    CGFloat leftX=_activityIndicatorView.frame.origin.x+_activityIndicatorView.frame.size.width+2;
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(leftX,(DeviceHeight-size.height)/2, size.width, size.height)];
    lab.backgroundColor=[UIColor clearColor];
    lab.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    lab.font=[UIFont boldSystemFontOfSize:14];
    lab.text=title;
    [bgView addSubview:lab];
    [_activityIndicatorView release];
    [lab release];
    
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    [window addSubview:bgView];
    [bgView release];
}
@end
