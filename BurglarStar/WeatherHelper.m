//
//  WeatherHelper.m
//  BurglarStar
//
//  Created by aJia on 2014/4/11.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "WeatherHelper.h"

@interface WeatherHelper ()
- (NSString*)searchKeyWithDictionary:(NSDictionary*)dic value:(NSString*)value;
@end

@implementation WeatherHelper
+ (WeatherHelper *)sharedInstance {
    static dispatch_once_t  onceToken;
    static WeatherHelper * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[WeatherHelper alloc] init];
    });
    return sSharedInstance;
}
- (id)init{
    if (self=[super init]) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"plist"];
        self.CityCode=[[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}
- (NSString*)cityNumberWithPlacemark:(CLPlacemark*)place
{
    if (self.CityCode&&[self.CityCode count]>0) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ BEGINSWITH[cd] SELF",place.administrativeArea];
        
        NSArray *arr=[self.CityCode.allKeys filteredArrayUsingPredicate:pred];
        if (arr&&[arr count]>0) {
            NSString *key=[arr objectAtIndex:0];
            return [self searchKeyWithDictionary:[self.CityCode objectForKey:key] value:place.locality];
        }
    }
    return nil;
}
- (NSString*)searchKeyWithDictionary:(NSDictionary*)dic value:(NSString*)value{
    for (NSString *key in dic.allKeys) {
        if ([[dic objectForKey:key] isEqualToString:value]||[value hasPrefix:[dic objectForKey:key]]) {
            return key;
        }
    }
    return nil;
}
+ (NSString*)getWeatherCityCode:(CLPlacemark*)place{
    WeatherHelper *weather=[WeatherHelper sharedInstance];
    return [weather cityNumberWithPlacemark:place];
}
@end
