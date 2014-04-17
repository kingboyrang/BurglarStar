//
//  MapAutoPointer.m
//  BurglarStar
//
//  Created by aJia on 2014/4/17.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MapAutoPointer.h"

@implementation MapAutoPointer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img=[UIImage imageNamed:@"amplify.png"];
        _autoBigButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _autoBigButton.frame=CGRectMake(0, 0, img.size.width, img.size.height);
        [_autoBigButton setImage:img forState:UIControlStateNormal];
        [self addSubview:_autoBigButton];
        
        _autoSmallButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _autoSmallButton.frame=CGRectMake(0,_autoBigButton.frame.size.height-1, img.size.width, img.size.height);
        [_autoSmallButton setImage:[UIImage imageNamed:@"shrink.png"] forState:UIControlStateNormal];
        [self addSubview:_autoSmallButton];
        
        /***
        CGRect r=frame;
        r.size.width=img.size.width;
        r.size.height=img.size.height*2;
        self.frame=r;
         ***/
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
