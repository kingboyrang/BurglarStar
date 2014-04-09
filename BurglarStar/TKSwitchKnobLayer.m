//
//  TKSwitchKnobLayer.m
//  BurglarStar
//
//  Created by aJia on 2014/4/8.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKSwitchKnobLayer.h"

@implementation TKSwitchKnobLayer
- (void)drawInContext:(CGContextRef)context {
	CGContextSetFillColorWithColor(context, [UIColor colorFromHexRGB:@"4a8797"].CGColor);
    CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 2, 2));
	CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0, NULL);
}

@end
