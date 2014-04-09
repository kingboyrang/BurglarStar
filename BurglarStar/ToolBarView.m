//
//  ToolBarView.m
//  BurglarStar
//
//  Created by aJia on 2014/4/8.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ToolBarView.h"

@implementation ToolBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setImage:[UIImage imageNamed:@"btn_top.png"]];
        [self addSubview:imageView];
        [imageView release];
        
        NSString *btnName=@"取消";
        CGSize size=[btnName textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.bounds.size.width];
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake((frame.size.width-size.width)/2,(frame.size.height-size.height)/2+5, size.width, size.height);
        [_button setTitle:@"取消" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        _button.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
        //[_cancel setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateHighlighted];
        [self addSubview:_button];
        
    }
    return self;
}

@end
