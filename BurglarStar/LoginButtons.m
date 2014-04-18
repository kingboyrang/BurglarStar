//
//  LoginButtons.m
//  LocationService
//
//  Created by aJia on 2013/12/19.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "LoginButtons.h"
#import "UIColor+TPCategory.h"
@implementation LoginButtons

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
        _cancel=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.frame=CGRectMake(0,(frame.size.height-size.height)/2, frame.size.width/2, size.height);
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateNormal];
        _cancel.titleLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
         _cancel.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
        //[_cancel setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateHighlighted];
        [self addSubview:_cancel];
        
        _submit=[UIButton buttonWithType:UIButtonTypeCustom];
        _submit.frame=CGRectMake(frame.size.width/2, (frame.size.height-size.height)/2, frame.size.width/2, size.height);
        [_submit setTitle:@"确认" forState:UIControlStateNormal];
        [_submit setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateNormal];
        _submit.titleLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        _submit.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
        //[_submit setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateHighlighted];
        [self addSubview:_submit];
    }
    return self;
}
- (void)setLeftButtonsWithCancelTitle:(NSString*)cancleTitle confirmTitle:(NSString*)submitTitle{
    CGRect r=_cancel.frame;
    r.origin.x=0;
    r.size.width=self.frame.size.width/3;
    _cancel.frame=r;
    
    r=_submit.frame;
    r.origin.x=_cancel.frame.size.width;
    r.size.width=r.origin.x;
    _submit.frame=r;
    
    if (cancleTitle&&[cancleTitle length]>0) {
        [_cancel setTitle:cancleTitle forState:UIControlStateNormal];
    }
    if (submitTitle&&[submitTitle length]>0) {
        [_submit setTitle:submitTitle forState:UIControlStateNormal];
    }
}
- (void)setRightButtonsWithCancelTitle:(NSString*)cancleTitle confirmTitle:(NSString*)submitTitle{
    CGRect r=_cancel.frame;
    r.origin.x=self.frame.size.width*2/3;
    r.size.width=self.frame.size.width/3;
    _cancel.frame=r;
    
    r=_submit.frame;
    r.origin.x=self.frame.size.width/3;
    r.size.width=r.origin.x;
    _submit.frame=r;
    
    if (cancleTitle&&[cancleTitle length]>0) {
        [_cancel setTitle:cancleTitle forState:UIControlStateNormal];
    }
    if (submitTitle&&[submitTitle length]>0) {
        [_submit setTitle:submitTitle forState:UIControlStateNormal];
    }
}
@end
