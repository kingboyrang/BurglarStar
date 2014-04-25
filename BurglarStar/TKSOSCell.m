//
//  TKSOSCell.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKSOSCell.h"

@implementation TKSOSCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _labName = [[UILabel alloc] initWithFrame:CGRectZero];
    _labName.backgroundColor=[UIColor clearColor];
    _labName.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
	[self.contentView addSubview:_labName];
    
    _labDate = [[UILabel alloc] initWithFrame:CGRectZero];
    _labDate.backgroundColor=[UIColor clearColor];
    _labDate.font=[UIFont fontWithName:DeviceFontName size:14];
	[self.contentView addSubview:_labDate];
    
    UIImage *img=[UIImage imageNamed:@"ico_location.png"];
    _button=[UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame=CGRectMake(0, 0, img.size.width, img.size.height);
    [_button setImage:img forState:UIControlStateNormal];
    [self.contentView addSubview:_button];
    
     UIImage *img1=[UIImage imageNamed:@"arrow_right_n.png"];
    _arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _arrowButton.frame=CGRectMake(0, 0, img1.size.width, img1.size.height);
    [_arrowButton setImage:img forState:UIControlStateNormal];
    [self.contentView addSubview:_arrowButton];
    
    UIImage *img2=[UIImage imageNamed:@"chk.png"];
    _chkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _chkButton.frame=CGRectZero;
    [_chkButton setImage:img2 forState:UIControlStateNormal];
    [_chkButton setImage:[UIImage imageNamed:@"chk-chk.png"] forState:UIControlStateSelected];
    _chkButton.hidden=YES;
    [self.contentView addSubview:_chkButton];
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftX=5;
    if (self.showCheck) {//显示
        _chkButton.hidden=NO;
        _chkButton.frame=CGRectMake(leftX,(self.frame.size.height-26)/2, 26, 26);
        leftX+=26;
    }else{//隐藏
        _chkButton.hidden=YES;
        _chkButton.frame=CGRectZero;
    }
    //箭头
	CGRect r=_arrowButton.frame;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    r.origin.x=self.frame.size.width-10-r.size.width;
    _arrowButton.frame=r;
    //定位
    r=_button.frame;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    r.origin.x=_arrowButton.frame.origin.x-15-r.size.width;
    _button.frame=r;
    
    leftX+=5;
    CGSize size=[_labName.text textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:r.origin.x];
    _labName.frame=CGRectMake(leftX, (self.frame.size.height-size.height)/2, size.width, size.height);
    
    size=[_labDate.text textSize:[UIFont fontWithName:DeviceFontName size:14] withWidth:r.origin.x];
    _labDate.frame=CGRectMake(_button.frame.origin.x-15-size.width, (self.frame.size.height-size.height)/2, size.width, size.height);
    
}

@end
