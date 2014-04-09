//
//  TKLabelLabelCell.m
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKLabelLabelCell.h"

@implementation TKLabelLabelCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        //我是由于这层挡住了，大家注意下每一层颜色
        self.backgroundColor = [UIColor clearColor];
    }
#endif
    
    
    _showLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_showLabel.backgroundColor = [UIColor clearColor];
    _showLabel.textColor = [UIColor grayColor];
	_showLabel.highlightedTextColor = [UIColor whiteColor];
    _showLabel.font = [UIFont fontWithName:DeviceFontName size:12];
    _showLabel.numberOfLines = 0;
    _showLabel.lineBreakMode=NSLineBreakByWordWrapping;
	[self.contentView addSubview:_showLabel];
    
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    
    NSString *str=[self.label.text Trim];
    CGSize size1=[str textSize:[UIFont fontWithName:DeviceFontName size:12] withWidth:self.frame.size.width];
    CGRect r=self.label.frame;
    r.origin.y=5;
    r.size=size1;
    self.label.frame=r;
    self.label.font=[UIFont fontWithName:DeviceFontName size:12];
    //NSLog(@"frame=%@",NSStringFromCGRect(self.label.frame));
    
    r.origin.x=self.label.frame.origin.x+self.label.frame.size.width+2;
    r.size.width=self.frame.size.width-5-r.origin.x;
    CGSize size=[_showLabel.text textSize:[UIFont fontWithName:DeviceFontName size:12] withWidth:r.size.width];
    r.size=size;
    _showLabel.frame=r;
}
@end
