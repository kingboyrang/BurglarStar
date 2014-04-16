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
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
	CGRect r=_arrowButton.frame;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    r.origin.x=self.frame.size.width-10-r.size.width;
    _arrowButton.frame=r;
    
    r=_button.frame;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    r.origin.x=_arrowButton.frame.origin.x-20-r.size.width;
    _button.frame=r;
    
    CGSize size=[_labName.text textSize:[UIFont fontWithName:DeviceFontName size:DeviceFontSize] withWidth:r.origin.x];
    _labName.frame=CGRectMake(10, (self.frame.size.height-size.height)/2, size.width, size.height);
    
    size=[_labDate.text textSize:[UIFont fontWithName:DeviceFontName size:14] withWidth:r.origin.x];
    _labDate.frame=CGRectMake(_button.frame.origin.x-20-size.width, (self.frame.size.height-size.height)/2, size.width, size.height);
    
}

@end
