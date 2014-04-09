//
//  AreaCar.h 区域关联对象
//  LocationService
//
//  Created by aJia on 2014/1/2.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaCar : NSObject
@property(nonatomic,copy) NSString *ID;//42dd7a24-3048-4211-9f86-90c785cc319f",  --目标ID
@property(nonatomic,copy) NSString *Name;//"祝文涛",  --目标名称
@property(nonatomic,copy) NSString *IDCard;//"42dd7a24-3048-4211-9f86-90c785cc319f", --设备ID
@property(nonatomic,copy) NSString *PType;//"C" –类型
@property(nonatomic,copy) NSString *Photo;//头像

@end
