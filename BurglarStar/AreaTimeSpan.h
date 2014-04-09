//
//  AreaTimeSpan.h
//  LocationService
//
//  Created by aJia on 2014/1/8.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaTimeSpan : NSObject
@property(nonatomic,copy) NSString *weekDay;//  --星期几
@property(nonatomic,copy) NSString *validSTime;//"2013-11-29 21:55",  --区域的有效开始日期
@property(nonatomic,copy) NSString *validETime;//"2013-11-29 23:34",  --区域的有效结束日期
@property(nonatomic,copy) NSString *starTime;//"13:20",  --星期几的有效开始时间
@property(nonatomic,copy) NSString *endTime;//"15:50",   --星期几的有效结束时间
@end
