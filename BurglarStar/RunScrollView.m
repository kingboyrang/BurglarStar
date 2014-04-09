//
//  RunScrollView.m
//  LocationService
//
//  Created by aJia on 2014/1/14.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "RunScrollView.h"

@implementation RunScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled=YES;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        self.contentSize=CGSizeMake(frame.size.width*2, self.frame.size.height);
        
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
