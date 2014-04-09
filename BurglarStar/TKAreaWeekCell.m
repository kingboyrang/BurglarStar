//
//  TKAreaWeekCell.m
//  LocationService
//
//  Created by aJia on 2014/1/6.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKAreaWeekCell.h"

@implementation TKAreaWeekCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UIImage *image=[UIImage imageNamed:@"checkbox.png"];
    _checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    _checkbox.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [_checkbox setImage:image forState:UIControlStateNormal];
    [_checkbox setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateSelected];
    [_checkbox addTarget:self action:@selector(buttonCheckboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_checkbox];
    
    _label=[[UILabel alloc] initWithFrame:CGRectZero];
    _label.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _label.textColor=[UIColor blackColor];
    _label.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_label];
    
    UIImage *image1=[UIImage imageNamed:@"DownAccessory.png"];
    _rightView=[UIButton buttonWithType:UIButtonTypeCustom];
    _rightView.frame=CGRectMake(0, 0, image1.size.width, image1.size.height);
    [_rightView setImage:image1 forState:UIControlStateNormal];
    [_rightView setImage:[UIImage imageNamed:@"UpAccessory.png"] forState:UIControlStateSelected];
    [self.contentView addSubview:_rightView];
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}
- (void)buttonCheckboxClick:(id)sender{
    UIButton *btn=(UIButton*)sender;
    btn.selected=!btn.selected;
}
- (BOOL)hasSelected{
    return _checkbox.selected;
}
- (void)setSelectedWeek:(BOOL)selected{
    _checkbox.selected=selected;
}
- (void)setOpen:(BOOL)open{
    self.isOpen=open;
    _rightView.selected=open;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect r=_checkbox.frame;
    r.origin.x=10;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    _checkbox.frame=r;
    
    CGFloat leftX=r.origin.x+r.size.width+5;
   
    
    r=_rightView.frame;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    r.origin.x=self.frame.size.width-10-r.size.width;
    _rightView.frame=r;
    
    _label.frame=CGRectMake(leftX,(self.frame.size.height-20)/2,self.frame.size.width-leftX-r.size.width-10-2, 20);
}
@end
