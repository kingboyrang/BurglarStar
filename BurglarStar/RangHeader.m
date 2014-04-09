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
        self.backgroundColor=[UIColor colorFromHexRGB:@"f0f0f0"];
        _label=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width, 20)];
        _label.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        _label.textColor=[UIColor blackColor];
        _label.textAlignment=NSTextAlignmentLeft;
        _label.backgroundColor=[UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}
@end
