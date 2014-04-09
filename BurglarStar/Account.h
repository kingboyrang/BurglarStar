//
//  Account.h
//  LocationService
//
//  Created by aJia on 2013/12/16.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>
@property(nonatomic,copy) NSString *Way;//登录方式(1:普通登录 2:手机动态登录)
@property(nonatomic,copy) NSString *UserId;//帐号
@property(nonatomic,copy) NSString *Password;//密码
@property(nonatomic,copy) NSString *encryptPwd;//加密密码
@property(nonatomic,copy) NSString *Name;//姓名
@property(nonatomic,copy) NSString *Phone;//电话
@property(nonatomic,copy) NSString *WorkNo;//电话
@property(nonatomic,assign) BOOL isFirstRun;//第一次启动App
@property(nonatomic,assign) BOOL isLogin;//是否已登入
@property(nonatomic,assign) BOOL isRememberPwd;//是否记住密码
@property(nonatomic,assign) float zoomLevel;//地图等级
//保存
- (void)save;
//注销
+ (void)closed;
//普通登入
+ (void)loginGeneralWithUserId:(NSString*)userId password:(NSString*)pwd encrypt:(NSString*)encrypt rememberPassword:(BOOL)remember withData:(NSDictionary*)dic;
//动态登录
+ (void)loginDynamicWithUserId:(NSString*)userId password:(NSString*)pwd rememberPassword:(BOOL)remember withData:(NSDictionary*)dic;
//注册登录
+ (void)registerLoginWithAccount:(Account*)entity;
//修改密码
+ (void)editPwd:(NSString*)pwd encrypt:(NSString*)encrypt;
//更新个人信息
+ (void)updateInfo:(NSString*)tel nick:(NSString*)nick;
//帐号
+ (Account*)unarchiverAccount;
//第一次启动
+ (BOOL)firstRunning;
+ (void)finishRunning;
+ (float)mapZoomLevel;
@end
