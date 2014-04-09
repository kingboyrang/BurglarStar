//
//  RegisterCheck.m
//  Wisdom
//
//  Created by aJia on 2013/10/31.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "RegisterCheck.h"
#import "TKBSwitch.h"
@interface RegisterCheck ()
-(void)loadControls:(CGRect)frame;
-(void)buttonClickTap:(id)sender;
-(void)addButton:(CGFloat)leftx height:(CGFloat)h index:(NSInteger)tag;
@end

@implementation RegisterCheck
@synthesize hasRemember=_hasRemember;
-(void)dealloc{
    [super dealloc];
    [_lightLabel release],_lightLabel=nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _hasRemember=YES;
        self.backgroundColor=[UIColor clearColor];
        [self loadControls:frame];
    }
    return self;
}
-(void)loadControls:(CGRect)frame{
    CGFloat leftx=0;
    if (!_lightLabel) {
        NSString *title=@"记住密码,自动登录";
        CGSize size=[title textSize:[UIFont boldSystemFontOfSize:DeviceFontSize] withWidth:frame.size.width-leftx];
        _lightLabel=[[UILabel alloc] initWithFrame:CGRectMake(leftx,(27-size.height)/2,size.width, size.height)];
        _lightLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
        _lightLabel.text=title;
        _lightLabel.backgroundColor=[UIColor clearColor];
        _lightLabel.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
        
        leftx=_lightLabel.frame.origin.x+_lightLabel.frame.size.width+5;
        TKBSwitch *switchItem=[[TKBSwitch alloc] initWithFrame:CGRectMake(leftx,0, 79, 27)];
        switchItem.on=YES;
        switchItem.onTintColor=[UIColor colorFromHexRGB:@"dbdbdb"];
        //switchItem.knobColor=[UIColor colorFromHexRGB:@"4a8797"];
        switchItem.tag=900;
        [switchItem addTarget:self action:@selector(buttonClickTap:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:switchItem];
        [switchItem release];
        
        
        CGFloat topY=_lightLabel.frame.size.height+_lightLabel.frame.origin.y+30;
        NSString *str=@"注册>>";
        size=[str textSize:[UIFont boldSystemFontOfSize:DeviceFontSize] withWidth:frame.size.width];
        UILabel *labRegister=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-size.width-10, topY, size.width, size.height)];
        labRegister.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
        labRegister.font=[UIFont boldSystemFontOfSize:DeviceFontSize];
        labRegister.text=str;
        labRegister.backgroundColor=[UIColor clearColor];
        [self addSubview:labRegister];
        
        
        _registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame=labRegister.frame;
        //_registerButton.alpha=0.0;
        [self addSubview:_registerButton];
        [labRegister release];
        [self addSubview:_lightLabel];
        
    }
    
    
}
-(void)addButton:(CGFloat)leftx height:(CGFloat)h index:(NSInteger)tag{
    UIImage *image=[UIImage imageNamed:@"checkbox.png"];
    UIImage *imageSelect=[UIImage imageNamed:@"checkbox-checked.png"];
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(leftx,(h-image.size.width)/2.0, image.size.width, image.size.height);
    btn1.tag=tag;
    [btn1 setImage:image forState:UIControlStateNormal];
    [btn1 setImage:imageSelect forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(buttonClickTap:) forControlEvents:UIControlEventTouchUpInside];
    if (tag==101) {
        btn1.selected=YES;
    }
    [self addSubview:btn1];
}
-(void)buttonClickTap:(id)sender{
    TKBSwitch *btn=(TKBSwitch*)sender;
    _hasRemember=btn.on;
}
-(void)setSelectItemSwitch:(int)index{
   UISwitch *btn=(UISwitch*)[self viewWithTag:900];
   btn.on=index==1?YES:NO;
}
@end
