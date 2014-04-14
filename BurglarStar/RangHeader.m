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
@end
