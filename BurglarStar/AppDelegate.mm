//
//  AppDelegate.m
//  BurglarStar
//
//  Created by aJia on 2014/4/7.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "BasicNavigationController.h"
#import "AppHelper.h"
#import "BPush.h"
#import "AlertHelper.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册推播
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    [self registerBaiduMap];//百度地图注册
    [self appInitSet];//初始化设置
    
    //推播数清0
    [application setApplicationIconBadgeNumber:0];
    
    MainViewController *main=[[[MainViewController alloc] init] autorelease];
    BasicNavigationController *nav=[[[BasicNavigationController alloc] initWithRootViewController:main] autorelease];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds =YES;
    }
#endif
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    
    [AppHelper startRunAnimation];//动画
    
    return YES;
    
    //防盗之星的百度推播key
    //Dx2Vu402GcmazulkbvhYrmcd
    //我的百度推播key
    //TI31INXww3V60P6GYn5B1VyZ
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //加载动画
    //[AppHelper startRunAnimation];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    Account *acc=[Account unarchiverAccount];
    if (acc.appId&&[acc.appId length]==0) {
        [BPush bindChannel];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - custom Methods
- (void)appInitSet{
   
    //注册推播
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    //控件颜色设置
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorFromHexRGB:@"eaeaec"], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0], NSFontAttributeName, nil]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor colorFromHexRGB:@"45b1ce"]];
    
}
- (void)registerBaiduMap{
    //百度地图注册
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"0E0006d6779b856330e93e877acbd7d1"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [_mapManager release];
}
#pragma mark - BPush Methods delegate
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        //NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            Account *acc=[Account unarchiverAccount];
            acc.appId=appid;
            acc.pushUserId=userid;
            acc.channelId=channelid;
            [acc save];
            //向服务器注册推播
            [AppHelper registerApns];
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            Account *acc=[Account unarchiverAccount];
            acc.appId=@"";
            acc.pushUserId=@"";
            acc.channelId=@"";
            [acc save];
        }
    }
    //self.viewController.textView.text = [[NSString alloc] initWithFormat: @"%@ return: \n%@", method, [data description]];
}
#pragma mark - BMKGeneralDelegate Methods
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"onGetNetworkState %d",iError);
}
- (void)onGetPermissionState:(int)iError
{
    NSLog(@"onGetPermissionState %d",iError);
}
#pragma mark - APNS 回傳結果
// 成功取得設備編號token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceId = [[deviceToken description]
                          substringWithRange:NSMakeRange(1, [[deviceToken description] length]-2)];
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceId = [deviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    Account *acc=[Account unarchiverAccount];
    acc.appToken=deviceId;
    [acc save];
    
    //[AlertHelper initWithTitle:@"推送注册码" message:deviceId];
    
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];
    
}
#pragma mark - 接收推播信息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    //MainViewController *main=(MainViewController*)self.window.rootViewController;
    //[main setSelectedItemIndex:2];
}
@end
