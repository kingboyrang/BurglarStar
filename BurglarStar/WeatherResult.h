//
//  WeatherResult.h
//  Wisdom
//
//  Created by aJia on 2013/11/5.
//  Copyright (c) 2013年 lz. All rights reserved.
//

/***
 http://mobile.weather.com.cn/images/small/day/31.png
 //当天天气=http://mobile.weather.com.cn/data/sk/101280601.html
 fa 白天图片id http://mobile.weather.com.cn/images/small/day/00.png
 
 fb 夜晚图片id http://mobile.weather.com.cn/images/small/night/00.png
 
 fc 白天温度
 
 fd 夜晚温度
 
 fi 日出和日落时间
 ***/

#import <Foundation/Foundation.h>
@interface WeatherResult : NSObject
@property(nonatomic,copy) NSString *dayMemo;
@property(nonatomic,copy) NSString *imageURL;
@property(nonatomic,copy) NSString *Temperature;
@property(nonatomic,assign) NSInteger tag;

+(NSArray*)jsonStringToWeatherResults:(NSData*)json;
+(NSArray*)emptyWeatherResults;
@end
