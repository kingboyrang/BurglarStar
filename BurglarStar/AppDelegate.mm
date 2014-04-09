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


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
    [self registerBaiduMap];//百度地图注册
    [self appInitSet];//初始化设置
   
    
    MainViewController *main=[[[MainViewController alloc] init] autorelease];
    BasicNavigationController *nav=[[[BasicNavigationController alloc] initWithRootViewController:main] autorelease];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    return YES;
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - custom Methods
- (void)appInitSet{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorFromHexRGB:@"eaeaec"], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:19.0], NSFontAttributeName, nil]];
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
#pragma mark - BMKGeneralDelegate Methods
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"onGetNetworkState %d",iError);
}
- (void)onGetPermissionState:(int)iError
{
    NSLog(@"onGetPermissionState %d",iError);
}
@end
