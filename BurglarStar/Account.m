//
//  Account.m
//  LocationService
//
//  Created by aJia on 2013/12/16.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "Account.h"
#import "FileHelper.h"
@implementation Account
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.Way forKey:@"Way"];
    [encoder encodeObject:self.UserId forKey:@"UserId"];
    [encoder encodeObject:self.Password forKey:@"Password"];
    [encoder encodeObject:self.encryptPwd forKey:@"encryptPwd"];
    
    [encoder encodeObject:self.Name forKey:@"Name"];
    [encoder encodeObject:self.Phone forKey:@"Phone"];
    [encoder encodeObject:self.WorkNo forKey:@"WorkNo"];
    
    [encoder encodeBool:self.isFirstRun forKey:@"isFirstRun"];
    [encoder encodeBool:self.isLogin forKey:@"isLogin"];
    [encoder encodeBool:self.isRememberPwd forKey:@"isRememberPwd"];
    [encoder encodeFloat:self.zoomLevel forKey:@"zoomLevel"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.Way=[aDecoder decodeObjectForKey:@"Way"];
        self.UserId=[aDecoder decodeObjectForKey:@"UserId"];
        self.Password=[aDecoder decodeObjectForKey:@"Password"];
        self.encryptPwd=[aDecoder decodeObjectForKey:@"encryptPwd"];
        
        self.Name=[aDecoder decodeObjectForKey:@"Name"];
        self.Phone=[aDecoder decodeObjectForKey:@"Phone"];
        self.WorkNo=[aDecoder decodeObjectForKey:@"WorkNo"];
        
        self.isFirstRun=[aDecoder decodeBoolForKey:@"isFirstRun"];
        self.isLogin=[aDecoder decodeBoolForKey:@"isLogin"];
        self.isRememberPwd=[aDecoder decodeBoolForKey:@"isRememberPwd"];
        self.zoomLevel=[aDecoder decodeFloatForKey:@"zoomLevel"];
    }
    return self;
}
-(void)save{
    NSString *path=[DocumentPath stringByAppendingPathComponent:@"Account.db"];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}
+(void)closed{
    Account *acc=[Account unarchiverAccount];
    acc.isLogin=NO;
    acc.isRememberPwd=NO;
    acc.UserId=@"";
    acc.Password=@"";
    acc.encryptPwd=@"";
    acc.Name=@"";
    acc.Phone=@"";
    acc.WorkNo=@"";
    acc.Way=@"";
    acc.zoomLevel=11.0;
    [acc save];
}
+ (void)loginGeneralWithUserId:(NSString*)userId password:(NSString*)pwd encrypt:(NSString*)encrypt rememberPassword:(BOOL)remember withData:(NSDictionary*)dic{
    Account *acc=[Account unarchiverAccount];
    acc.isLogin=YES;
    acc.Way=@"1";
    acc.UserId=userId;
    acc.Password=pwd;
    acc.encryptPwd=encrypt;
    acc.isRememberPwd=remember;
    if (dic) {
        if ([dic objectForKey:@"Name"]!=nil) {
            acc.Name=[dic objectForKey:@"Name"];
        }
        if ([dic objectForKey:@"Phone"]!=nil) {
            acc.Phone=[dic objectForKey:@"Phone"];
        }
        if ([dic objectForKey:@"WorkNo"]!=nil) {
            acc.WorkNo=[dic objectForKey:@"WorkNo"];
        }
    }
    [acc save];
}
+ (void)loginDynamicWithUserId:(NSString*)userId password:(NSString*)pwd rememberPassword:(BOOL)remember withData:(NSDictionary*)dic{
    Account *acc=[Account unarchiverAccount];
    acc.isLogin=YES;
    acc.Way=@"2";
    acc.UserId=userId;
    acc.Password=pwd;
    acc.isRememberPwd=remember;
    if (dic) {
        if ([dic objectForKey:@"Name"]!=nil) {
            acc.Name=[dic objectForKey:@"Name"];
        }
        if ([dic objectForKey:@"Phone"]!=nil) {
            acc.Phone=[dic objectForKey:@"Phone"];
        }
        if ([dic objectForKey:@"WorkNo"]!=nil) {
            acc.WorkNo=[dic objectForKey:@"WorkNo"];
        }
    }
    [acc save];
}
+ (void)editPwd:(NSString*)pwd encrypt:(NSString*)encrypt{
    Account *acc=[Account unarchiverAccount];
    acc.Password=pwd;
    acc.encryptPwd=encrypt;
    [acc save];
}
+ (void)updateInfo:(NSString*)tel nick:(NSString*)nick{
    Account *acc=[Account unarchiverAccount];
    acc.Phone=tel;
    acc.Name=nick;
    [acc save];
}
+ (void)registerLoginWithAccount:(Account*)entity{
    Account *acc=[Account unarchiverAccount];
    acc.WorkNo=entity.WorkNo;
    acc.isLogin=YES;
    acc.Way=@"1";
    acc.UserId=entity.UserId;
    acc.Password=entity.Password;
    acc.isRememberPwd=NO;
    acc.Name=entity.Name;
    acc.Phone=entity.Phone;
    [acc save];
}
+(Account*)unarchiverAccount{
    NSString *path=[DocumentPath stringByAppendingPathComponent:@"Account.db"];
    if(![FileHelper existsFilePath:path]){ //如果不存在
        Account *acc=[[[Account alloc] init] autorelease];
        acc.isFirstRun=YES;
        acc.zoomLevel=11.0;
        return acc;
    }
    return (Account*)[NSKeyedUnarchiver unarchiveObjectWithFile: path];
}
+ (BOOL)firstRunning{
    Account *acc=[Account unarchiverAccount];
    return acc.isFirstRun;
}
+ (void)finishRunning{
    Account *acc=[Account unarchiverAccount];
    acc.isFirstRun=NO;
    [acc save];
}
+ (float)mapZoomLevel{
    Account *acc=[Account unarchiverAccount];
    return acc.zoomLevel;
}
@end
