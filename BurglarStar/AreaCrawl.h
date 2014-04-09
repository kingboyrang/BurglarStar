//
//  AreaCrawl.h
//  LocationService
//
//  Created by aJia on 2013/12/27.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaCrawl : NSObject
@property(nonatomic,copy) NSString *SysID;//--区域唯一ID
@property(nonatomic,copy) NSString *AreaName;//--区域名称
@property(nonatomic,copy) NSString *AreaType;//--区域类型(Polygon：多边形；Rectangle：矩形；Rotundity：圆形
@property(nonatomic,copy) NSString *StartTime;//2013/04/25 14:13:00",   --有效开始时间
@property(nonatomic,copy) NSString *EndTime;//2013/04/29 14:13:00", --有效结束时间
@property(nonatomic,copy) NSString *LimitType;//--围栏规则(Out：禁出；In：禁入；Speed：限速；Stop：限停)
@property(nonatomic,copy) NSString *AreaPerson;//小仔"   --围栏成员名称
@end
