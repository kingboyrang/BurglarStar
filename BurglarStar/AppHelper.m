//
//  AppHelper.m
//  LocationService
//
//  Created by aJia on 2013/12/16.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "AppHelper.h"
#import "Account.h"
@interface AppHelper ()
- (void)runningAnimation:(void(^)())completed;
- (void)changeViewIndex:(void(^)())completed;
- (void)removeRunningAnimation:(void(^)())completed;
- (void)removeView;
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
+ (void)runAnimation:(void(^)())completed{
    Account *acc=[Account unarchiverAccount];
    if (!acc.isFirstRun) {return;}
    AppHelper *app=[[[AppHelper alloc] init] autorelease];
    [app runningAnimation:completed];
}

- (void)runningAnimation:(void(^)())completed{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];

    UIImageView *tovalue=[[[UIImageView alloc] initWithFrame:DeviceRect] autorelease];
    tovalue.tag=800;
    [tovalue setImage:[UIImage imageNamed:@"load02.jpg"]];
    [window addSubview:tovalue];
    
    UIImageView *imageView2=[[[UIImageView alloc] initWithFrame:DeviceRect] autorelease];
    imageView2.tag=801;
    [imageView2 setImage:[UIImage imageNamed:@"load01.jpg"]];
    [window addSubview:imageView2];
    
    [self performSelector:@selector(changeViewIndex:) withObject:completed afterDelay:2.0f];
}
- (void)changeViewIndex:(void(^)())completed{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    
    UIImageView *fromvalue=(UIImageView*)[window viewWithTag:801];
    UIImageView *tovalue=(UIImageView*)[window viewWithTag:800];
    
    [UIView transitionFromView:fromvalue toView:tovalue duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        if (finished) {
            [fromvalue removeFromSuperview];
            [self performSelector:@selector(removeRunningAnimation:) withObject:completed afterDelay:2.0f];
        }
    }];
}
- (void)removeView{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIImageView *imageView=(UIImageView*)[window viewWithTag:800];
    [imageView removeFromSuperview];
    
    Account *acc=[Account unarchiverAccount];
    acc.isFirstRun=NO;
    [acc save];
}
- (void)removeRunningAnimation:(void(^)())completed{
   
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIImageView *imageView=(UIImageView*)[window viewWithTag:800];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeView)];
     imageView.alpha= 0.0;
    [UIView commitAnimations];
}
@end
