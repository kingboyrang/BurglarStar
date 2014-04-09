//
//  NetWorkConnection.h
//  SystemLeave
//
//  Created by aJia on 2012/3/5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

//block
typedef void (^ListenerNetWorkResult)(NetworkStatus status,BOOL isConnection);

@protocol NetWorkDelegate <NSObject>
@optional
-(void)NetWorkHandler:(NetworkStatus)status IsConnection:(BOOL)hasConnection;
@end

@interface NetWorkConnection : NSObject {
    Reachability *hostReach;
    ListenerNetWorkResult _listenerNetWorkResult;
}
@property(nonatomic,assign) id<NetWorkDelegate> delegate;
@property(nonatomic,assign) BOOL hasNewWork;
//单例模式
+ (NetWorkConnection *)sharedInstance;
//实时监听连接
-(void)ListenerConection:(id<NetWorkDelegate>)thedelegate;
-(void)ListenerConection:(NSString*)url delegate:(id<NetWorkDelegate>)thedelegate;
-(void)dynamicListenerNetwork:(ListenerNetWorkResult)networkResult;

//判断url是否可以访问
+(BOOL)isEnabledURL:(NSString*)url;
//判断url是否可以访问
+(BOOL)isEnabledAccessURL:(NSString*)url;
//判斷網路是否连通
+(BOOL)IsEnableConnection;
+(BOOL)hasNetWork;
// 是否wifi
+ (BOOL)IsEnableWIFI;
// 是否3G
+(BOOL)IsEnable3G;
//gps检测方法
+ (BOOL)locationServicesEnabled;
@end
