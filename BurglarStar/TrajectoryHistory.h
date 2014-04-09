//
//  TrajectoryHistory.h
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrajectoryHistory : NSObject
@property(nonatomic,copy) NSString *Power;// --电量，使用百分比
@property(nonatomic,copy) NSString *Latitude;// --纬度
@property(nonatomic,copy) NSString *Longitude;// --经度
@property(nonatomic,copy) NSString *angle;// --方向，说明请参照前面
@property(nonatomic,copy) NSString *speed;// --速度
@property(nonatomic,copy) NSString *extend;// --转轴( “0”--停转；“1”—正转；“2”—反转)
@property(nonatomic,copy) NSString *oil;// -- 油表
@property(nonatomic,copy) NSString *doorStatus;// –开关门（0:开；1：关）
@property(nonatomic,copy) NSString *pctime;//2013/11/13 12：25：42" –定位的时间
@property(nonatomic,copy) NSString *address;//云南昆明市" –-定位的地址
@property(nonatomic,copy) NSString *temper;//温度

@property (nonatomic,readonly) NSString *directionText;//方向
@property (nonatomic,readonly) NSString *extendText;//转轴
@property (nonatomic,readonly) NSString *formatDateText;//转轴
@end
