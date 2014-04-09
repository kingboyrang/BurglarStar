//
//  TrajectoryMessage.h
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrajectoryMessage : NSObject
@property(nonatomic,copy) NSString *Latitude;//--纬度
@property(nonatomic,copy) NSString *Longitude;//--经度
@property(nonatomic,copy) NSString *PCTime;//--发生异常日期时间
@property(nonatomic,copy) NSString *Reason;//--异常原因
//广东省深圳市南山区科发路3",  --发生异常地址(Address字符串要用Replace(",", "，"),把英文的","逗号换成中文"，"逗号)
@property(nonatomic,copy) NSString *Address;
@property(nonatomic,copy) NSString *ID;//--异常的唯一ID
@property(nonatomic,copy) NSString *PID;//--被监控者唯一ID
@property(nonatomic,copy) NSString *PName;//--被监控者名称
@property(nonatomic,copy) NSString *Photo;//http://localhost:10001/UpDoc/PersonLogo/1351569200.jpg",  --被监控者头像
@property(nonatomic,copy) NSString *ExceptionID;//--异常类型

@property (nonatomic,readonly) NSString *formatDateText;//转轴
@end
