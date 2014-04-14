//
//  WeatherResult.m
//  Wisdom
//
//  Created by aJia on 2013/11/5.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "WeatherResult.h"
#import "NSDate+TPCategory.h"
#define WeatherImageURLString @"http://mobile.weather.com.cn/images/small/day/%@.png"

@interface WeatherResult ()
+(NSString*)dayToString:(int)day;
@end

@implementation WeatherResult
+(NSArray*)jsonStringToWeatherResults:(NSData*)json{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *obj=[dic objectForKey:@"f"];
    NSArray *item=[obj objectForKey:@"f1"];
    if (item.count>0) {
        NSMutableArray *arr=[NSMutableArray arrayWithCapacity:item.count];
        for (int i=0; i<item.count; i++) {
            NSDictionary *entity=[item objectAtIndex:i];
            WeatherResult *mod=[[WeatherResult alloc] init];
            mod.tag=100+i;
            mod.dayMemo=[self dayToString:i];
            mod.imageURL=[NSString stringWithFormat:WeatherImageURLString,[entity objectForKey:@"fa"]];
            mod.Temperature=[NSString stringWithFormat:@"%@°",[entity objectForKey:@"fc"]];
            [arr addObject:mod];
            [mod release];
        }
        return arr;
    }
    return nil;
}
+(NSArray*)emptyWeatherResults{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:7];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"weather-clear" ofType:@"png"];
    NSArray *temps=[NSArray arrayWithObjects:@"20°",@"25°",@"23°",@"21°",@"23°",@"17°",@"19°", nil];
    for (int i=0; i<7; i++) {
        WeatherResult *mod=[[WeatherResult alloc] init];
        mod.tag=100+i;
        mod.dayMemo=[self dayToString:i];
        mod.imageURL=path;
        mod.Temperature=[temps objectAtIndex:i];
        [arr addObject:mod];
        [mod release];
    }
    return arr;
}
+(NSString*)dayToString:(int)day{
    NSDate *date=[[NSDate date] dateByAddingDays:day];
    if([date dayOfWeek]==1)return @"M";//Monday=周一
    if([date dayOfWeek]==2)return @"T";//Tuesday=周二
    if([date dayOfWeek]==3)return @"W";//Wednesday=周三
    if([date dayOfWeek]==4)return @"T";//Thursday=周四
    if([date dayOfWeek]==5)return @"F";//Friday=周五
    if([date dayOfWeek]==6)return @"S";//Saturday=周六
    return @"S";//Sunday=周日
}
@end
