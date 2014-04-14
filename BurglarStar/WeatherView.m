//
//  WeatherView.m
//  BurglarStar
//
//  Created by aJia on 2014/4/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "WeatherView.h"
#import "UIButton+TPCategory.h"
#import "NSDate+TPCategory.h"
#import "LocationGPS.h"
#import "WeatherHelper.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"

@interface WeatherView ()
@property (nonatomic,copy) NSString *weatherCityNumber;
- (void)updateUIWithJson:(NSData*)data;
- (void)updateUIWeatherWithJson:(NSData*)data;
@end


@implementation WeatherView
- (void)dealloc{
    [_serviceHelper release],_serviceHelper=nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _serviceHelper=[[ASIServiceHelper alloc] init];
        
        UIImage *img=[UIImage imageNamed:@"weather_bg.png"];
        CGRect r=self.bounds;
        r.size=img.size;
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:r];
        [imageView setImage:img];
        [self addSubview:imageView];
        [imageView release];
        
        UIImage *image=[UIImage imageNamed:@"arrowdown.png"];
        CGFloat leftX=frame.size.width-10-image.size.width;
        _arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _arrowButton.frame=CGRectMake(leftX,(frame.size.height-image.size.height)/2, image.size.width, image.size.height);
        [_arrowButton setBackgroundImage:image forState:UIControlStateNormal];
        [_arrowButton setBackgroundImage:[UIImage imageNamed:@"arrowup.png"] forState:UIControlStateSelected];
        [self addSubview:_arrowButton];
        
        NSString *memo=@"100°";
        CGSize size=[memo textSize:[UIFont boldSystemFontOfSize:30] withWidth:frame.size.width];
        _labCurTemp=[[UILabel alloc] initWithFrame:CGRectMake(leftX-10-size.width,(frame.size.height-size.height)/2,size.width,size.height)];
        _labCurTemp.backgroundColor=[UIColor clearColor];
        _labCurTemp.textColor=[UIColor colorFromHexRGB:@"1e303e"];
        _labCurTemp.font=[UIFont boldSystemFontOfSize:30];
        _labCurTemp.textAlignment=NSTextAlignmentRight;
        _labCurTemp.text=@"20°";
        
        [self addSubview:_labCurTemp];
        
        NSDate *date=[NSDate date];
        NSString *time=[date stringWithFormat:@"yyyy/MM/dd"];
        size=[time textSize:[UIFont boldSystemFontOfSize:16] withWidth:frame.size.width];
        _labCurDate=[[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-size.width)/2, (frame.size.height-(size.height*2+2))/2, size.width, size.height)];
        _labCurDate.backgroundColor=[UIColor clearColor];
        _labCurDate.textColor=[UIColor colorFromHexRGB:@"1e303e"];
        _labCurDate.font=[UIFont boldSystemFontOfSize:16];
        _labCurDate.text=time;
        [self addSubview:_labCurDate];
        
        _labCurCity=[[UILabel alloc] initWithFrame:CGRectMake(0,_labCurDate.frame.origin.y+_labCurDate.frame.size.height+2,frame.size.width, size.height)];
        _labCurCity.backgroundColor=[UIColor clearColor];
        _labCurCity.textColor=[UIColor colorFromHexRGB:@"1e303e"];
        _labCurCity.font=[UIFont boldSystemFontOfSize:16];
        _labCurCity.textAlignment=NSTextAlignmentCenter;
        _labCurCity.text=@"昆明   晴";
        [self addSubview:_labCurCity];
        
        UIImage *imgW=[UIImage imageNamed:@"weather-clear.png"];
        _weatherImage=[[UIImageView alloc] initWithFrame:CGRectMake(15,(frame.size.height-imgW.size.height)/2, imgW.size.width, imgW.size.height)];
        [_weatherImage setImage:imgW];
        [self addSubview:_weatherImage];
        
    }
    return self;
}
- (void)loadCurrentLocationWeather{
    LocationGPS *gps=[[LocationGPS alloc] init];
    [gps startLocation:^(SVPlacemark *place) {
        NSString *cityNumber=[WeatherHelper getWeatherCityCode:place];
        if (cityNumber!=nil) {
            
            if (![self.weatherCityNumber isEqualToString:cityNumber]) {
                self.weatherCityNumber=cityNumber;
            }else{
                return;
            }
            if (self.delegate&&[self.delegate respondsToSelector:@selector(locationGPSCityNumber:)]) {
                [self.delegate locationGPSCityNumber:cityNumber];
            }
            [_serviceHelper clearAndDelegate];
            NSURL *dayURL=[NSURL URLWithString:[NSString stringWithFormat:WeatherDayURL,cityNumber]];
            ASIHTTPRequest *request1=[ASIHTTPRequest requestWithURL:dayURL];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"day",@"name", nil]];
            [request1 setDefaultResponseEncoding:NSUTF8StringEncoding];
            [_serviceHelper addQueue:request1];
            
            NSURL *cityDayURL=[NSURL URLWithString:[NSString stringWithFormat:WeatherCityDayURL,cityNumber]];
            ASIHTTPRequest *request2=[ASIHTTPRequest requestWithURL:cityDayURL];
            [request2 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"city",@"name", nil]];
            [request2 setDefaultResponseEncoding:NSUTF8StringEncoding];
            [_serviceHelper addQueue:request2];
            
            [_serviceHelper startQueue:^(ASIHTTPRequest *request) {
                NSString *name=[request.userInfo objectForKey:@"name"];
                if ([name isEqualToString:@"day"]&&request.responseStatusCode==200) {
                    [self performSelectorOnMainThread:@selector(updateUIWithJson:) withObject:request.responseData waitUntilDone:NO];
                }
                if ([name isEqualToString:@"city"]&&request.responseStatusCode==200) {
                    [self performSelectorOnMainThread:@selector(updateUIWeatherWithJson:) withObject:request.responseData waitUntilDone:NO];
                }
            } failed:nil complete:^(NSArray *results) {
                
            }];
        }
        
    } failed:nil];
}
-(void)updateUIWithJson:(NSData*)data{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *obj=[dic objectForKey:@"weatherinfo"];
    self.labCurTemp.text=[NSString stringWithFormat:@"%@°",[obj objectForKey:@"temp"]];
}
-(void)updateUIWeatherWithJson:(NSData*)data{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *obj=[dic objectForKey:@"weatherinfo"];
    NSString *memo=[NSString stringWithFormat:@"%@   %@",[obj objectForKey:@"city"],[obj objectForKey:@"weather"]];
    self.labCurCity.text=memo;
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\d]+"
                                                                           options:0
                                                                             error:&error];
    NSString *name=[obj objectForKey:@"img1"];
    name=[regex stringByReplacingMatchesInString:name options:0 range:NSMakeRange( 0, [name length]) withTemplate:@""];
    if ([name length]>0) {
        NSString *urlStr=[NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",name];
        [self.weatherImage setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"weather-clear.png"]];
    }
    //http://m.weather.com.cn/img/b2.gif
}
@end
