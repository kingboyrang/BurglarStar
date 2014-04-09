//
//  NetWorkConnection.m
//  SystemLeave
//
//  Created by aJia on 2012/3/5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NetWorkConnection.h"
#import <CoreLocation/CoreLocation.h>

@interface NetWorkConnection()
- (void) updateInterfaceWithReachability: (Reachability*) curReach;
- (void) reachabilityChanged: (NSNotification* )note;
@end

@implementation NetWorkConnection
@synthesize delegate;
@synthesize hasNewWork;
//单例模式
+ (NetWorkConnection *)sharedInstance{
    static dispatch_once_t  onceToken;
    static NetWorkConnection * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[NetWorkConnection alloc] init];
    });
    return sSharedInstance;
}
#pragma mark 实时监听连接
-(void)ListenerConection:(id<NetWorkDelegate>)thedelegate
{
    [self ListenerConection:@"http://www.baidu.com" delegate:thedelegate];
}
-(void)ListenerConection:(NSString*)url delegate:(id<NetWorkDelegate>)thedelegate
{
    self.delegate=thedelegate;
    NSURL *webURL=[NSURL URLWithString:url];
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:[webURL host]] retain];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: hostReach];
   
}
-(void)dynamicListenerNetwork:(ListenerNetWorkResult)networkResult{
    Block_release(_listenerNetWorkResult);
    _listenerNetWorkResult=Block_copy(networkResult);
    NSURL *webURL=[NSURL URLWithString:@"http://www.baidu.com"];
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:[webURL host]] retain];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: hostReach];
}
/****
//http://www.oschina.net/code/snippet_588197_11928
//3g与2g网络区分
- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return NotReachable;
    }
    BOOL retVal = NotReachable;
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that your on Wi-Fi
        retVal = ReachableViaWiFi;
    }
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            retVal = ReachableViaWiFi;
        }
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable) {
            if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
                retVal = ReachableVia3G;
                if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired) {
                    retVal = ReachableVia2G;
                }
            }
        }
    }
    return retVal;
}
****/
+(BOOL)isEnabledURL:(NSString*)url
{
    if(url)
    {
        /***
         NSURL *webURL=[NSURL URLWithString:url];
         Reachability *hostReach = [Reachability reachabilityWithHostName:[webURL host]];
         if ([hostReach currentReachabilityStatus]==NotReachable) {
         return NO;
         }
         return YES;
         ***/
        NSURL *url1 = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        NSHTTPURLResponse *response;
        [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
        if (response == nil) {
            return NO;
        }
        return YES;
    }
    return NO;
}
+(BOOL)isEnabledAccessURL:(NSString*)url{
    NSURL *hostURL=[NSURL URLWithString:url];
    Reachability *r =[Reachability reachabilityWithHostName:hostURL.host];
    if ([r currentReachabilityStatus]==NotReachable) {
        return NO;
    }
    return YES;
}
//判斷網路連接是否正常
+(BOOL)IsEnableConnection{
      
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
    
}
+(BOOL)hasNetWork
{
    Reachability *helper=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    return [helper currentReachabilityStatus]==NotReachable?NO:YES;
}
// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
//gps检测
+ (BOOL)locationServicesEnabled {
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        //NSLog(@"手机gps定位已经开启");
        return YES;
    } else {
        //NSLog(@"手机gps定位未开启");
        return NO;
    }
}

#pragma mark -
#pragma mark 私有方法
// 连接改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    BOOL b=YES;
    if (status == NotReachable) {  //没有连接到网络就弹出提实况
        b=NO;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(NetWorkHandler:IsConnection:)]) {
        [self.delegate NetWorkHandler:status IsConnection:b];
    }
    if (_listenerNetWorkResult) {
        _listenerNetWorkResult(status,b);
    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [hostReach release];
    Block_release(_listenerNetWorkResult);
    [super dealloc];
}
@end
