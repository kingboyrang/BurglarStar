//
//  RangHeader.m
//  LocationService
//
//  Created by aJia on 2014/1/2.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "RangHeader.h"

@implementation RangHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];
        _backroundView=[[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_backroundView];
        
        NSString *memo=@"关联";
        CGSize size=[memo textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:frame.size.width];
        _label=[[UILabel alloc] initWithFrame:CGRectMake(10,(frame.size.height-size.height)/2, frame.size.width, size.height)];
        _label.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        _label.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
        _label.textAlignment=NSTextAlignmentLeft;
        _label.backgroundColor=[UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}
- (void)setCenterTopTitle:(NSString*)title{
    UIImage *titleViewImg=[UIImage imageNamed:@"top_bg01.png"];
    titleViewImg=[titleViewImg stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    NSString *memo=[NSString stringWithFormat:@"名称:%@",title];
    CGSize size=[memo textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.frame.size.width];
    
    _label.frame=CGRectMake(0,(self.frame.size.height-size.height)/2,self.frame.size.width, size.height);
    _label.textAlignment=NSTextAlignmentCenter;
    _label.text=memo;
    [_backroundView setImage:titleViewImg];
}
- (void)setLeftTopTitle:(NSString*)title{
    UIImage *header1Img=[UIImage imageNamed:@"top_bg03.png"];
    header1Img=[header1Img stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    _label.text=title;
    [_backroundView setImage:header1Img];
}
@end
