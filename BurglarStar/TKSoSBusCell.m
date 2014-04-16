//
//  TKSoSBusCell.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKSoSBusCell.h"

@implementation TKSoSBusCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _labName = [[UILabel alloc] initWithFrame:CGRectZero];
    _labName.backgroundColor=[UIColor clearColor];
    _labName.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _labName.textColor=[UIColor colorFromHexRGB:DeviceFontColorName];
    _labName.text=@"车牌号码";
	[self.contentView addSubview:_labName];
    
    _select = [[CVUISelect alloc] initWithFrame:CGRectMake(0, 0, 206, 35)];
    _select.popoverText.popoverTextField.borderStyle=UITextBorderStyleRoundedRect;
    _select.popoverText.popoverTextField.placeholder=@"请选择车牌号码";
    
    UIImage *img=[UIImage imageNamed:@"DownAccessory.png"];
    UIImageView *imageView=[[[UIImageView alloc] initWithImage:img] autorelease];
    _select.popoverText.popoverTextField.enabled=NO;
    _select.popoverText.popoverTextField.rightView=imageView;
    _select.popoverText.popoverTextField.rightViewMode=UITextFieldViewModeAlways;
    _select.popoverText.popoverTextField.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
	[self.contentView addSubview:_select];
    
  
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
	
    CGRect r=_select.frame;
    CGSize size=[_labName.text textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.frame.size.width];
    CGFloat leftX=(self.frame.size.width-size.width-r.size.width)/2;
    _labName.frame=CGRectMake(leftX,(self.frame.size.height-size.height)/2, size.width, size.height);
    
    r.origin.x=leftX+size.width+2;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    _select.frame=r;
    
}

@end
