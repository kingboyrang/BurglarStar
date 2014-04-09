//
//  TKBSwitch.m
//  BurglarStar
//
//  Created by aJia on 2014/4/8.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKBSwitch.h"
#import "TKSwitchKnobLayer.h"
@implementation TKBSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (Class)knobLayerClass {
    return [TKSwitchKnobLayer class];
}

@end
