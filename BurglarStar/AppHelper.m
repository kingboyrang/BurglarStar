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
@interface AppHelper ()
- (void)runAnimation;
- (void)watiAnimationShow:(UIImage*)image;
- (void)removeView;
- (void)removeRunningAnimation;
@end

@implementation AppHelper
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
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"GetExcessive";
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic&&[dic count]>0) {
                NSString *imgURL=[dic objectForKey:@"Result"];
                if ([imgURL length]>0) {
                    //显示图片
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadWithURL:[NSURL URLWithString:imgURL] options:0
                                    progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                        if (image && finished)
                                        {
                                            // 下载完成
                                            [self watiAnimationShow:image];
                                        }
                                    }];
                    //图片下载完成
                }
            }
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
- (void)watiAnimationShow:(UIImage*)image{
    UIView *bgView=[[UIView alloc] initWithFrame:DeviceRect];
    bgView.tag=970;
    bgView.backgroundColor=[UIColor colorFromHexRGB:@"e5e2d0"];
    
    UIImage *img=[image imageByScalingToSize:bgView.bounds.size];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:bgView.bounds];
    [imageView setImage:img];
    [bgView addSubview:imageView];
    [imageView release];
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    [window addSubview:bgView];
    [bgView release];
    
    
    //4秒过后执行其它操作
    int64_t delayInSeconds = 4.0f;
    dispatch_time_t popTime =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"bb==remove");
        [self removeRunningAnimation];
    });
}
- (void)removeView{
    NSLog(@"remove ok!");
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIView *imageView=(UIView*)[window viewWithTag:970];
    [imageView removeFromSuperview];
}
- (void)removeRunningAnimation{
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIView *imageView=(UIView*)[window viewWithTag:970];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeView)];
    imageView.alpha= 0.0;
    [UIView commitAnimations];
}
@end
