//
//  TKAreaTargetCell.m
//  BurglarStar
//
//  Created by aJia on 2014/4/25.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKAreaTargetCell.h"

@implementation TKAreaTargetCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _labName = [[UILabel alloc] initWithFrame:CGRectZero];
    _labName.backgroundColor=[UIColor clearColor];
    _labName.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
	[self.contentView addSubview:_labName];
    
    UIImage *img2=[UIImage imageNamed:@"chk.png"];
    _chkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _chkButton.frame=CGRectMake(0, 0, img2.size.width, img2.size.height);
    [_chkButton setImage:img2 forState:UIControlStateNormal];
    [_chkButton setImage:[UIImage imageNamed:@"chk-chk.png"] forState:UIControlStateSelected];
    [self.contentView addSubview:_chkButton];
    
    _busImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 84)];
    [self.contentView addSubview:_busImageView];
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)setCheckedButton:(BOOL)ischecked{
    _chkButton.selected=ischecked;
}
- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftX=5;
    CGRect r=_chkButton.frame;
    r.origin.x=leftX;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    _chkButton.frame=r;
    
    r=_busImageView.frame;
    r.origin.x=_chkButton.frame.origin.x+_chkButton.frame.size.width+5;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    _busImageView.frame=r;
   
    leftX=r.origin.x+r.size.width+5;
    CGSize size=[_labName.text textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:self.frame.size.width];
    _labName.frame=CGRectMake(leftX, (self.frame.size.height-size.height)/2, size.width, size.height);
    
}

@end
