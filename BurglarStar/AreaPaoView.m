//
//  AreaPaoView.m
//  LocationService
//
//  Created by aJia on 2014/1/3.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "AreaPaoView.h"

@implementation AreaPaoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //气泡view的背景图片 － 被分为左边背景和右边背景两个部分
        //UIEdgeInsets insets = UIEdgeInsetsMake(13,8, 13, 8);
        UIImage *imageNormal, *imageHighlighted;
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_left_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *leftBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                 highlightedImage:imageHighlighted];
        leftBgd.frame=CGRectMake(0, 0, frame.size.width/2, frame.size.height);
        leftBgd.tag = 11;
        
        imageNormal = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        imageHighlighted = [[UIImage imageNamed:@"mapapi.bundle/images/icon_paopao_middle_right_highlighted.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:13];
        UIImageView *rightBgd = [[UIImageView alloc] initWithImage:imageNormal
                                                  highlightedImage:imageHighlighted];
        rightBgd.frame=CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height);
        rightBgd.tag = 12;
        
        [self addSubview:leftBgd];
        [self addSubview:rightBgd];
        [leftBgd release];
        [rightBgd release];
        
        NSString *title=@"名称:";
        CGSize size=[title textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:frame.size.width];
        UILabel *labTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, (frame.size.height-size.height)/2-6, size.width, size.height)];
        labTitle.text=title;
        labTitle.textColor=[UIColor blackColor];
        labTitle.backgroundColor=[UIColor clearColor];
        labTitle.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        [self addSubview:labTitle];
        
        CGFloat leftX=labTitle.frame.origin.x+size.width+5;
        
        _field=[[UITextField alloc] initWithFrame:CGRectMake(leftX,(frame.size.height-35)/2-6, frame.size.width-leftX-10, 35)];
        _field.borderStyle=UITextBorderStyleRoundedRect;
        _field.placeholder=@"请输入名称";
        _field.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        _field.delegate=self;
        [self addSubview:_field];
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
