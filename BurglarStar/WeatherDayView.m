//
//  WeatherDayView.m
//  BurglarStar
//
//  Created by aJia on 2014/4/14.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "WeatherDayView.h"

@implementation WeatherDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        NSString *week=@"S";
        CGSize size=[week textSize:[UIFont boldSystemFontOfSize:14] withWidth:frame.size.width];
        _labWeek=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, size.height)];
        _labWeek.backgroundColor=[UIColor clearColor];
        _labWeek.textAlignment=NSTextAlignmentCenter;
        _labWeek.font=[UIFont boldSystemFontOfSize:14];
        _labWeek.textColor=[UIColor colorFromHexRGB:@"56081f"];
        _labWeek.text=week;
        [self addSubview:_labWeek];
        
        
        
        CGFloat topY=_labWeek.frame.origin.y+size.height+2;
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-25)/2, topY, 25, 25)];
        [_imageView setImage:[UIImage imageNamed:@"weather-clear.png"]];
        [self addSubview:_imageView];
        
        topY+=_imageView.frame.size.height+2;
        NSString *tempture=@"25°";
        size=[tempture textSize:[UIFont boldSystemFontOfSize:16] withWidth:frame.size.width];
        _labTemperature=[[UILabel alloc] initWithFrame:CGRectMake(0,topY, frame.size.width, size.height)];
        _labTemperature.backgroundColor=[UIColor clearColor];
        _labTemperature.textAlignment=NSTextAlignmentCenter;
        _labTemperature.font=[UIFont boldSystemFontOfSize:16];
        _labTemperature.textColor=[UIColor colorFromHexRGB:@"56081f"];
        _labTemperature.text=week;
        [self addSubview:_labTemperature];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
