//
//  WeatherView.m
//  BurglarStar
//
//  Created by aJia on 2014/4/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "WeatherView.h"
#import "UIButton+TPCategory.h"
@implementation WeatherView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img=[UIImage imageNamed:@"weather_bg.png"];
        CGRect r=self.bounds;
        r.size=img.size;
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:r];
        [imageView setImage:img];
        [self addSubview:imageView];
        [imageView release];
        
        UIImage *image=[UIImage imageNamed:@"arrow_down.png"];
        CGFloat leftX=frame.size.width-10-image.size.width;
        _arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _arrowButton.frame=CGRectMake(leftX,(frame.size.height-image.size.height)/2, image.size.width, image.size.height);
        [_arrowButton setBackgroundImage:image forState:UIControlStateNormal];
        [_arrowButton setBackgroundImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateSelected];
        [self addSubview:_arrowButton];
        
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
