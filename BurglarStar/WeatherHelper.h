//
//  WeatherHelper.h
//  BurglarStar
//
//  Created by aJia on 2014/4/11.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVPlacemark.h"
@interface WeatherHelper : NSObject
@property (nonatomic,retain) NSDictionary *CityCode;
//单一实例
+ (WeatherHelper*)sharedInstance;
- (NSString*)cityNumberWithPlacemark:(CLPlacemark*)place;

+ (NSString*)getWeatherCityCode:(CLPlacemark*)place;
@end
