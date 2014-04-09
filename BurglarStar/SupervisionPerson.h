//
//  SupervisionPerson.h
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupervisionPerson : NSObject<NSCopying>
@property(nonatomic,copy) NSString *ID;//被监控者唯一ID
@property(nonatomic,copy) NSString *Name;//被监控者名称
@property(nonatomic,copy) NSString *isOnline;//"0"表示终端不在线，"1"表示终端在线
@property(nonatomic,copy) NSString *GPSStatus;
@property(nonatomic,copy) NSString *Power;//终端电量，使用百分比
@property(nonatomic,copy) NSString *Photo;//照片
@property(nonatomic,copy) NSString *Password;//终端密码
@property(nonatomic,copy) NSString *IMEI;//终端IMEI号码
@property(nonatomic,copy) NSString *SimNo;//手机号码
@property(nonatomic,copy) NSString *DeviceCode;//终端唯一ID
@property(nonatomic,copy) NSString *Latitude;//纬度
@property(nonatomic,copy) NSString *Longitude;//经度
@property(nonatomic,copy) NSString *Address;//被监控者的定位地址
@property(nonatomic,copy) NSString *angle;//方向角度 被监控者的定位地址
@property(nonatomic,copy) NSString *speed;//速度，单位: km/h
@property(nonatomic,copy) NSString *extend;//转轴( “0”--停转；“1”—正转；“2”—反转)
@property(nonatomic,copy) NSString *oil;//油表
@property(nonatomic,copy) NSString *temper;//温度，单位：℃
@property(nonatomic,copy) NSString *DoorStatus;//车门( “0”--；“1”—；)
@property(nonatomic,copy) NSString *Phone;//亲情号码
@property(nonatomic,copy) NSString *OperatingMode;//终端发送频率，单位：秒
@property(nonatomic,copy) NSString *PCTime;//时间

@property (nonatomic,readonly) NSString *directionText;//方向
@property (nonatomic,readonly) NSString *extendText;//转轴
@property (nonatomic,readonly) NSString *fileName;//照片名称
@property (nonatomic,readonly) NSString *formatDateText;//时间
@end
