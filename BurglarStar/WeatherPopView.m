//
//  WeatherPopView.m
//  BurglarStar
//
//  Created by aJia on 2014/4/14.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "WeatherPopView.h"
#import "WeatherDayView.h"
#import "UIImageView+WebCache.h"
@interface WeatherPopView ()
- (void)reloadDayWeathers:(NSArray*)source;
@end

@implementation WeatherPopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorFromHexRGB:@"f1f3e7"];
        self.alpha=0.8;
        CGFloat w=frame.size.width/7;
        NSArray *arr=[WeatherResult emptyWeatherResults];
        for (int i=0; i<arr.count; i++) {
            WeatherResult *entity=[arr objectAtIndex:i];
            WeatherDayView *dayView=[[WeatherDayView alloc] initWithFrame:CGRectMake(i*w, 0, w, frame.size.height)];
            dayView.labWeek.text=entity.dayMemo;
            dayView.labTemperature.text=entity.Temperature;
            dayView.tag=entity.tag;
            [self addSubview:dayView];
            [dayView release];
        }
    }
    return self;
}
//取得一周天气
- (void)locationGPSCityNumber:(NSString*)cityNumber{
    NSString *url=[NSString stringWithFormat:WeatherWeekURL,cityNumber];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request addRequestHeader:@"Accept" value:@"application/json, text/javascript, */*; q=0.01"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN,zh;q=0.8"];
    //注意：Referer 一定要加，否则获取的不是当天的。
    [request addRequestHeader:@"Referer" value:@"http://mobile.weather.com.cn/"];
    [request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1;Chrome/27.0.1453.110; Trident/5.0)"];
    
    [request setCompletionBlock:^{
        if (request.responseStatusCode==200) {
            [self reloadDayWeathers:[WeatherResult jsonStringToWeatherResults:request.responseData]];
        }
    }];
    [request setFailedBlock:^{
       
    }];
    [request startAsynchronous];
}
- (void)reloadDayWeathers:(NSArray*)source{
    if (source&&[source count]>0) {
         for (int i=0; i<source.count; i++) {
             WeatherResult *entity=[source objectAtIndex:i];
             id v=[self viewWithTag:entity.tag];
             if ([v isKindOfClass:[WeatherDayView class]]) {
                 WeatherDayView *dayView=(WeatherDayView*)v;
                 dayView.labWeek.text=entity.dayMemo;
                 dayView.labTemperature.text=entity.Temperature;
                 [dayView.imageView setImageWithURL:[NSURL URLWithString:entity.imageURL] placeholderImage:[UIImage imageNamed:@"weather-clear.png"]];
             }
         }
    }
}
@end
