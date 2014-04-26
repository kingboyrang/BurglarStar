//
//  TKAreaCell.m
//  BurglarStar
//
//  Created by aJia on 2014/4/25.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKAreaCell.h"

@implementation TKAreaCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _labName = [[UILabel alloc] initWithFrame:CGRectZero];
    _labName.backgroundColor=[UIColor clearColor];
    _labName.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
	[self.contentView addSubview:_labName];
    

    
    UIImage *img1=[UIImage imageNamed:@"arrow_right_n.png"];
    _arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _arrowButton.frame=CGRectMake(0, 0, img1.size.width, img1.size.height);
    [_arrowButton setImage:img1 forState:UIControlStateNormal];
    [self.contentView addSubview:_arrowButton];
    
    UIImage *img2=[UIImage imageNamed:@"chk.png"];
    _chkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _chkButton.frame=CGRectZero;
    [_chkButton setImage:img2 forState:UIControlStateNormal];
    [_chkButton setImage:[UIImage imageNamed:@"chk-chk.png"] forState:UIControlStateSelected];
    [self.contentView addSubview:_chkButton];
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)changeMSelectedState{
    _chkButton.selected=NO;
    self.showCheck=NO;
    _chkButton.hidden=YES;
    [self setNeedsLayout];
}
- (void)mSelectedState:(BOOL)state{
     self.showCheck=YES;
     _chkButton.selected=state;
      _chkButton.hidden=NO;
    [self setNeedsLayout];
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
    
    
    leftX+=5;
    CGSize size=[_labName.text textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:r.origin.x];
    _labName.frame=CGRectMake(leftX, (self.frame.size.height-size.height)/2, size.width, size.height);
    
}

@end
